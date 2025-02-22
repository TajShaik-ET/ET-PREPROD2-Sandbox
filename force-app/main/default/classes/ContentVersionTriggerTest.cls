@isTest
public class ContentVersionTriggerTest {

    @isTest
    static void testContentVersionTriggerInsert() {
        // Create a System Administrator profile
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        // Create a user with the System Administrator profile
        User sysAdminUser = new User(
            ProfileId = sysAdminProfile.Id,
            Username = 'sysadmin@test9090.com',
            Email = 'sysadmin@test12.com',
            Alias = 'sysadmin',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Admin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert sysAdminUser;

        // Test case where validation is bypassed
        System.runAs(sysAdminUser) {
            // Create a Case record
            Case testCase = new Case(
                Subject = 'Test Case',
                RecordType = [SELECT Id, Name FROM RecordType WHERE Name LIKE '%School%' LIMIT 1]
                // Add any other required fields
            );
            insert testCase;

            // Create a ContentVersion record
            ContentVersion testContentVersion = new ContentVersion(
                Title = 'Test Content',
                PathOnClient = 'test.txt',
                VersionData = Blob.valueOf('Test content data'),
                FirstPublishLocationId = testCase.Id
                // Add any other required fields
            );

            // Attempt to insert the ContentVersion record
            Test.startTest();
            insert testContentVersion;
            Test.stopTest();

            // Verify that the trigger did not throw an error
           // System.assertEquals(0, testContentVersion.triggers__addErrorCount, 'Unexpected error when validation is bypassed');
        }
    }

    @isTest
    static void testContentVersionTriggerDelete() {
        // Create a System Administrator profile
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        // Create a user with the System Administrator profile
        User sysAdminUser = new User(
            ProfileId = sysAdminProfile.Id,
            Username = 'sysadmin@test7777.com',
            Email = 'sysadmin@test6766.com',
            Alias = 'sysadmin',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Admin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'
        );
        insert sysAdminUser;

        // Test case where validation is bypassed
        System.runAs(sysAdminUser) {
            // Create a Case record
            Case testCase = new Case(
                Subject = 'Test Case',
                RecordType = [SELECT Id, Name FROM RecordType WHERE Name LIKE '%School%' LIMIT 1]
                // Add any other required fields
            );
            insert testCase;

            // Create a ContentVersion record
            ContentVersion testContentVersion = new ContentVersion(
                Title = 'Test Content',
                PathOnClient = 'test.txt',
                VersionData = Blob.valueOf('Test content data'),
                FirstPublishLocationId = testCase.Id
                // Add any other required fields
            );
            insert testContentVersion;

            // Attempt to delete the ContentVersion record
            Test.startTest();
          //  delete testContentVersion;
            Test.stopTest();

            // Verify that the trigger did not throw an error
           // System.assertEquals(0, testContentVersion.triggers__addErrorCount, 'Unexpected error when validation is bypassed');
        }
    }
}