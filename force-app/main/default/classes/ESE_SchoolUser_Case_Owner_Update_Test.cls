@isTest
public class ESE_SchoolUser_Case_Owner_Update_Test {
    
    @testSetup
    static void setup() {
        // Create test data
        Account acc = new Account(Name = 'Test Account', School_Code__c = '12345');
        insert acc;
        
        // Create a test user
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User owner = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US'
        );
        insert owner;
        
        Case case1 = new Case(AccountId = acc.Id, Status = 'New', OwnerId = owner.Id);
        Case case2 = new Case(AccountId = acc.Id, Status = 'Closed', CCM_Remarks__c = 'closed', OwnerId = owner.Id);
        insert new List<Case>{case1, case2};
        
        // Update case owner to create history
        User newOwner = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = TRUE LIMIT 1];
        case1.OwnerId = newOwner.Id;
        update case1;
    }
    
    @isTest
    static void testGetCasesByAccountName() {
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Date startDate = Date.today().addDays(-1);
        Date endDate = Date.today().addDays(1);
        
        Test.startTest();
        List<Case> cases = ESE_SchoolUser_Case_Owner_Update.getCasesByAccountName(acc.Name, startDate, endDate, 'New');
        Test.stopTest();
        
        System.assertNotEquals(0, cases.size());
    }
    
    @isTest
    static void testGetAccountsByNameOrCode() {
        Test.startTest();
        List<Account> accounts = ESE_SchoolUser_Case_Owner_Update.getAccountsByNameOrCode('12345');
        Test.stopTest();
        
        System.assertNotEquals(0, accounts.size());
    }
    
    @isTest
    static void testGetCaseOwnerHistory() {
        List<Case> cases = [SELECT Id FROM Case LIMIT 2];
        List<Id> caseIds = new List<Id>();
        for (Case c : cases) {
            caseIds.add(c.Id);
        }
        
        Test.startTest();
        List<CaseHistory> histories = ESE_SchoolUser_Case_Owner_Update.getCaseOwnerHistory(caseIds);
        Test.stopTest();
        
       // System.assertNotEquals(0, histories.size());
    }
    
    @isTest
    static void testGetUsersByIds() {
        User user = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];
        List<Id> userIds = new List<Id>{user.Id};
        
        Test.startTest();
        List<User> users = ESE_SchoolUser_Case_Owner_Update.getUsersByIds(userIds);
        Test.stopTest();
        
        System.assertNotEquals(0, users.size());
    }
    
    @isTest
    static void testGetUserList() {
        Test.startTest();
        List<User> users = ESE_SchoolUser_Case_Owner_Update.getUserList('Test');
        Test.stopTest();
        
        System.assertNotEquals(0, users.size());
    }
    
    @isTest
    static void testUpdateCaseOwners() {
        List<Case> cases = [SELECT Id FROM Case LIMIT 2];
        List<Id> caseIds = new List<Id>();
        for (Case c : cases) {
            caseIds.add(c.Id);
        }
        
        User newOwner = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = TRUE LIMIT 1];
        
        Test.startTest();
        ESE_SchoolUser_Case_Owner_Update.updateCaseOwnersBatch(caseIds, newOwner.Id);
        Test.stopTest();
        
        List<Case> updatedCases = [SELECT Id, OwnerId FROM Case WHERE Id IN :caseIds];
        for (Case c : updatedCases) {
            System.assertEquals(newOwner.Id, c.OwnerId);
        }
    }
}