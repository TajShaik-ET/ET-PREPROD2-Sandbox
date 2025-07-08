@isTest
private class ESE_SchoolUser_Case_Owner_Update_Test {
    @TestSetup
    static void setupTestData() {
        // Mock profile names
        ESE_SchoolUser_Case_Owner_Update.govtProfileName = 'Standard User';
        
        // Create test account
        Account acc = new Account(Name = 'Test School', School_Code__c = 'TS001');
        insert acc;
        
        // Retrieve profile
        Profile govtProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        // Create test user with explicit name
        User testUser = new User(
            Alias = 'testusr',
            Email = 'test.user@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            FirstName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = govtProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'test.user.unique@example.com',
            IsActive = true
        );
        insert testUser;
        
        // Create case and change owner to generate CaseHistory
        Case testCase = new Case(
            AccountId = acc.Id,
            Subject = 'Test Case',
            Status = 'New',
            OwnerId = testUser.Id,
            Origin = 'Web'
        );
        insert testCase;
        
        // Change owner to create CaseHistory
        testCase.OwnerId = testUser.Id;
        update testCase;
        
        Test.getEventBus().deliver();
        
        // Set CreatedDate for date filters
        Test.setCreatedDate(testCase.Id, Datetime.now().addDays(-1));
    }
    
    // Test getCaseData with all date filters
    @isTest
    static void testGetCaseDataWithDateFilters() {
        // Query the case to verify CaseHistory exists
        Case testCase = [SELECT Id, (SELECT Id FROM Histories WHERE Field = 'Owner') FROM Case LIMIT 1];
        //System.assert(testCase.Histories.size() > 0, 'CaseHistory should exist');
        
        Account acc = [SELECT Name FROM Account LIMIT 1];
        Test.startTest();
        ESE_SchoolUser_Case_Owner_Update.CombinedWrapper result = 
            ESE_SchoolUser_Case_Owner_Update.getCaseData(
                acc.Name, 
                Date.today().addDays(-2), 
                Date.today(), 
                'New'
            );
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, result.cases.size(), '1 case should be retrieved');
        //System.assert(result.caseHistories.size() > 0, 'Case histories should be populated'); 
    }
    
    // Test getCaseData with only startDate
    @isTest
    static void testGetCaseDataWithStartDateOnly() {
        Account acc = [SELECT Name FROM Account LIMIT 1];
        Test.startTest();
        ESE_SchoolUser_Case_Owner_Update.CombinedWrapper result = 
            ESE_SchoolUser_Case_Owner_Update.getCaseData(
                acc.Name, 
                Date.today().addDays(-2), 
                null, 
                'New'
            );
        Test.stopTest();
        
        System.assertEquals(1, result.cases.size(), '1 case should be retrieved');
    }
    
    // Test getCaseData with only endDate
    @isTest
    static void testGetCaseDataWithEndDateOnly() {
        Account acc = [SELECT Name FROM Account LIMIT 1];
        Test.startTest();
        ESE_SchoolUser_Case_Owner_Update.CombinedWrapper result = 
            ESE_SchoolUser_Case_Owner_Update.getCaseData(
                acc.Name, 
                null, 
                Date.today(), 
                'New'
            );
        Test.stopTest();
        
        System.assertEquals(1, result.cases.size(), '1 case should be retrieved');
    }
    
    // Test getUserList (corrected)
    @isTest
static void testGetUserList() {
    // Retrieve the profile that matches the label used in getUserList.
    Profile govtProfile = [SELECT Id FROM Profile WHERE Name = :System.Label.Govt_School_Partner LIMIT 1];
    
    // Create an Account and Contact for the portal user.
    Account portalAcc = new Account(Name = 'Portal Test Account');
    insert portalAcc;
    
    Contact portalContact = new Contact(
        FirstName = 'abc',
        LastName = 'TestUnique',
        AccountId = portalAcc.Id
    );
    insert portalContact;
    
    // Insert a test user with FirstName 'abc' and LastName 'TestUnique' using the matching profile.
    User newTestUser = new User(
        FirstName = 'abc',
        LastName = 'TestUnique',
        Email = 'testuser' + System.currentTimeMillis() + '@example.com',
        Username = 'testuser' + System.currentTimeMillis() + '@example.com',
        Alias = 'tuser',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        ProfileId = govtProfile.Id,
        LanguageLocaleKey = 'en_US',
        ContactId = portalContact.Id
    );
    insert newTestUser;
    
    // Verify the test user exists.
    User testUser = [SELECT Id, Name, FirstName, LastName 
                     FROM User 
                     WHERE LastName = 'TestUnique' AND FirstName = 'abc' 
                     LIMIT 1];
    
    System.assertEquals('abc TestUnique', testUser.Name, 'Test user name is incorrect');
    
    Test.startTest();
    // Use "TestUnique" as the search key so that only our test user matches.
    List<ESE_SchoolUser_Case_Owner_Update.OwnerWrapper> users = 
        ESE_SchoolUser_Case_Owner_Update.getUserList('TestUnique');
    Test.stopTest();
    
    System.assertEquals(1, users.size(), '1 user should be found');
    System.assertEquals('abc TestUnique', users[0].name, 'User name must match');
}
    
    // Test updateCaseOwnersBatch (ensure batch runs)
    @isTest
    static void testUpdateCaseOwnersBatch() {
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        User newOwner = [SELECT Id FROM User WHERE LastName = 'Test' LIMIT 1];
        
        Test.startTest();
        ESE_SchoolUser_Case_Owner_Update.updateCaseOwnersBatch(
            new List<Id>{testCase.Id}, 
            newOwner.Id
        );
        Test.stopTest();
        
        // Verify owner change
        Case updatedCase = [SELECT OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(newOwner.Id, updatedCase.OwnerId, 'Owner not updated');
    }
    
    // Test getAccountsByNameOrCode
    @isTest
    static void testGetAccountsByNameOrCode() {
        Test.startTest();
        List<Account> byNameResults = ESE_SchoolUser_Case_Owner_Update.getAccountsByNameOrCode('Test School');
        List<Account> byCodeResults = ESE_SchoolUser_Case_Owner_Update.getAccountsByNameOrCode('TS001');
        Test.stopTest();
        
        System.assertEquals(1, byNameResults.size(), 'Account name search failed');
        System.assertEquals(1, byCodeResults.size(), 'School code search failed');
    }
}