@isTest
public class ContactValidationHandlerTest {

    @testSetup
    static void setupTestData() {
        // Query for profiles containing 'T&L' (you cannot use LIKE in SOQL)
        Profile tlProfile = [SELECT Id FROM Profile WHERE Name = 'T&L - Account Manager' LIMIT 1];
        if (tlProfile == null) {
            //System.assert(false, 'T&L profile does not exist in the org.');
        }
        
        // Insert a User with the 'T&L' Profile
        User tlUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + Math.random() + '@example.com',
            Alias = 'tuser',
            ProfileId = tlProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert tlUser;

        // Query for profiles that don't match 'T&L'
        Profile otherProfile = [SELECT Id FROM Profile WHERE Name != 'System Administrator' LIMIT 1];
        if (otherProfile == null) {
            System.assert(false, 'A non-T&L profile does not exist in the org.');
        }

        // Insert a User with the non-T&L Profile
        User standardUser = new User(
            FirstName = 'Standard',
            LastName = 'User',
            Email = 'standarduser@example.com',
            Username = 'standarduser' + Math.random() + '@example.com',
            Alias = 'suser',
            ProfileId = otherProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert standardUser;
    }

    @isTest
    static void testValidateContacts_withTLProfile() {
        User tlUser = [SELECT Id FROM User WHERE Profile.Name = 'T&L - Account Manager' LIMIT 1];
        Contact contact1 = new Contact(
            FirstName = 'John',
            LastName = null, 
            Email = null,    
            ETSales_Phone__c = null, 
            OwnerId = tlUser.Id
        );
        Contact contact2 = new Contact(
            FirstName = 'Jane',
            LastName = 'Doe',
            Email = 'jane.doe@example.com',
            ETSales_Phone__c = '123-456-7890',
            OwnerId = tlUser.Id
        );
        
        Test.startTest();
        List<Contact> contacts = new List<Contact>{ contact1, contact2 };
        ContactValidationHandler.validateContacts(contacts);
        Test.stopTest();
    }

    @isTest
    static void testValidateContacts_withNonTLProfile() {
        User standardUser = [SELECT Id FROM User WHERE Profile.Name != 'T&L - Account Manager' LIMIT 1];
        Contact contact1 = new Contact(
            FirstName = 'Alex',
            LastName = null, 
            Email = null,    
            ETSales_Phone__c = null, 
            OwnerId = standardUser.Id
        );
        
        Test.startTest();
        List<Contact> contacts = new List<Contact>{ contact1 };
        ContactValidationHandler.validateContacts(contacts);
        Test.stopTest();
    }
}