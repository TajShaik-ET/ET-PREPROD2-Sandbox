@IsTest
public class customerPortalCtrlTest{
    
    @TestSetup
    static void setupTestData(){
        profile p = [SELECT Id
                     FROM Profile
                     WHERE Name = 'Standard User'];
        UserRole role = new UserRole(
            DeveloperName = 'MyCustomRole', 
            Name = 'My Role'
        );
        Insert role;
        User adminUser = new User(
            Alias = 'standt', 
            Email = 'aser39452dsjfk@sdk.com', 
            EmailEncodingKey = 'UTF-8', 
            LastName = 'Testing', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey = 'America/Los_Angeles', 
            UserName = 'aser39452dsjfk@sdk.com', 
            UserRoleId = role.Id
        );
        Insert adminUser;
    }
    
    @IsTest
    static void testCreateUser(){
        user adminUser = [SELECT Id, FirstName, LastName, Email
                          FROM User
                          WHERE UserName = 'aser39452dsjfk@sdk.com' LIMIT 1];
        // Prepare the test data
        customerPortalCtrl.SSOUserData testUserData = new customerPortalCtrl.SSOUserData();
        testUserData.identifier = '123456';
        testUserData.firstName = 'Test';
        testUserData.lastName = 'User';
        testUserData.email = 'testuser@example.com';
        testUserData.mobile = '1234567890';
        testUserData.attributeMap = New Map<String,String>();
        String userInfoStr = JSON.serialize(testUserData);
        String accRecType = 'Person_B2C';
        Test.startTest();
        String userId;
        System.runAs(adminUser){
            userId = customerPortalCtrl.createUser(userInfoStr, accRecType);
        }
        //System.assertNotEquals(null, userId, 'User ID should not be null');
        Test.stopTest();
    }
    
    @IsTest
    static void testLogin(){
        String username = 'aser39452dsjfk@sdk.com';
        String password = 'password123';
        String startUrl = '';
        String userInfoStr = '{"identifier":"123456","firstName":"Test","lastName":"User","email":"testuser@example.com","mobile":"1234567890"}';
        Test.startTest();
        Boolean loginSuccess = customerPortalCtrl.login(username, password, startUrl, userInfoStr);
        Test.stopTest();
    }
    
    @IsTest
    static void testLinkThirdPartyAccount(){
        String thirdPartyAccountName = 'Google';
        String thirdPartyAccountId = 'google123';
        user adminUser = [SELECT Id, FirstName, LastName, Email
                          FROM User
                          WHERE UserName = 'aser39452dsjfk@sdk.com'][0];
        Test.startTest();
        System.runAs(adminUser){
            customerPortalCtrl.linkThirdPartyAccount(adminUser.Id, thirdPartyAccountName, thirdPartyAccountId);
        }
        Test.stopTest();
    }
    
    @IsTest
    static void testGetSSOUserData(){
        String testData = '[identifier=123456, fullName=Test User, firstName=Test, lastName=User, email=testuser@example.com, mobile=1234567890, gender=M]';
        String encryptedData = EncryptionUtils.encryptString(testData); // Assuming EncryptionUtils is available for the test
        Test.startTest();
        customerPortalCtrl.SSOUserData result = customerPortalCtrl.getSSOUserData(encryptedData);
        Test.stopTest();
    }
    
    @IsTest
    static void testFromString(){
        String data = 'identifier=123456, fullName=Test User, firstName=Test, lastName=User, email=testuser@example.com, mobile=1234567890, gender=M';
        Test.startTest();
        customerPortalCtrl.SSOUserData result = customerPortalCtrl.fromString(data);
        Test.stopTest();
    }
    
}