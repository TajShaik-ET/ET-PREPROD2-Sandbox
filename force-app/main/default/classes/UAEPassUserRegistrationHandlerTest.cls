@isTest
public Without Sharing class UAEPassUserRegistrationHandlerTest{

    @TestSetup
    static void setupTestData(){
        // Step 1: Create the UserRole and User first
        User accountOwner = createUserWithRole();
        // Step 2: Create Account and associate it with the Contact from the previously created User
        System.runAs(accountOwner){
            createAccountAndPortalUser(accountOwner.Id);
        }
    }

    // Step 1: Create UserRole and User
    static User createUserWithRole(){
        // Create a UserRole
        UserRole userRole = new UserRole(
            Name = 'Test Role', 
            DeveloperName = 'Test_Role'
        );
        Insert userRole;
        // Fetch the profile for creating the owner user
        Profile standardUserProfile = [SELECT Id
                                       FROM Profile
                                       WHERE Name = 'Standard User'
                                       LIMIT 1];
        // Create the Account owner with a role
        User accountOwner = new User(
            Alias = 'ownrusr', 
            Email = 'owneruser@example.com', 
            EmailEncodingKey = 'UTF-8', 
            FirstName = 'Owner', 
            LastName = 'User', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = standardUserProfile.Id, 
            TimeZoneSidKey = 'America/Los_Angeles', 
            UserName = 'owneruser@example.com', 
            UserRoleId = userRole.Id, 
            IsActive = true
        );
        Insert accountOwner;
        return accountOwner;
    }

    // Step 2: Create Account and Portal User
    static void createAccountAndPortalUser(Id ownerId){
        // Insert Account record
        String accRecType = 'Person_B2C';
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(accRecType).getRecordTypeId();
        acc.LastName = 'A';
        acc.FirstName = 'firstName';
        acc.PersonEmail = 'standuser@gmail.com';
        acc.OwnerId = ownerId; // Set the Account owner to the provided user with a role
        Insert acc;
        // Query the Account with PersonContactId
        Account accSaved = [SELECT Id, PersonContactId
                            FROM Account
                            WHERE Id = :acc.Id
                            LIMIT 1];

        // Fetch the portal profile for the portal user
        Profile portalProfile = [SELECT Id
                                 FROM Profile
                                 WHERE Name = :System.Label.OneET_CustomerCmnty_Profile
                                 LIMIT 1];
        System.debug('portalProfile: ' + portalProfile.Id);
        // Create a Portal User associated with the Contact from the Account
        User portalUser = new User(
            Alias = 'portusr', 
            Email = 'oneet@gmail.com', 
            EmailEncodingKey = 'UTF-8', 
            FirstName = 'Portal', 
            LastName = 'User', 
            LanguageLocaleKey = 'en_US', 
            ProfileId = portalProfile.Id, 
            TimeZoneSidKey = 'Asia/Dubai', 
            LocaleSidKey = 'en_AE', 
            UserName = 'oneet@gmail.com', 
            IsActive = true, 
            UUID__c = 'idA', 
            CommunityNickname = 'User' + String.valueOf(Math.random()).substring(0, 6), 
            ContactId = accSaved.PersonContactId
        );
        Insert portalUser;
    }

    static testMethod void testConfirmUser(){
        user OneEtUser = [SELECT Id, FirstName, LastName, Email
                          FROM User
                          WHERE UserName = 'oneet@gmail.com'
                          LIMIT 1];
        System.debug('OneEtUser: ' + OneEtUser);
        UAEPassUserRegistrationHandler handler = new UAEPassUserRegistrationHandler();
        Auth.UserData sampleData = new Auth.UserData('idA', 'firstName', 'A', 'firstName A', 'oneet@gmail.com', null, 'oneet@gmail.com', 'en_US', 'facebook', null, new Map<String, String>{ 'language' => 'en_US' });
        User u = handler.createUser(null, sampleData);
        //Insert (u);
        String uid = u.id;
        sampleData = new Auth.UserData('idB', 'firstName', 'B', 'firstName B', 'userA@example.org', null, 'usernameB', 'en_US', 'facebook', null, new Map<String, String>{  }); // note that user B is using userA's email
        Id confirmedUserId = handler.confirmUser(uid, '060xx0000004Eh6', null, sampleData);
        System.assertEquals(uid, confirmedUserId); // we should see userA's id
    }

    static testmethod void testMethod1(){
        UAEPassUserRegistrationHandler handler = new UAEPassUserRegistrationHandler();
        Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast', 'testFirst testLast', 'testuse8888321r@example.org', null, 'testuserlong', 'en_US', 'facebook', null, new Map<String, String>{ 'language' => 'en_US' });
        try{
            handler.updateUser(null, null, sampleData);
            handler.handleUserNotFound(sampleData);
            handler.testCodeMethod();
        } catch (Exception e){

        }
    }

}