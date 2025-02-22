@isTest
public class ET_User_Notification_Test {
    @isTest
    static void testHandlePicklistChange() {
        // Test data setup
        Account testAccount = new Account(Name = 'Test Account', ETST_SchoolRefID__c = '123', ETST_Name_AR__c = 'Test AR', Station_Code__c = 24131);
        insert testAccount;

        Case testOldCase = new Case(AccountId = testAccount.Id, Status_Category__c = 'Pending with Operation Manager',
                                    Subject='new',Origin='CRM Portal',Status='In Progress',RecordTypeId='0123z000000Z6KQAA0');
        insert testOldCase;

        Case testNewCase = new Case(AccountId = testAccount.Id, Status_Category__c = 'Pending with Operation Supervisors',Subject='new',Origin='CRM Portal',Status='In Progress',RecordTypeId='0123z000000Z6KQAA0');
        insert testNewCase;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            // Create a public group and add a user to it
            Group testPublicGroup = new Group(Name = 'ET Operation Manager', DeveloperName = 'Organization', Type = 'Regular');
            insert testPublicGroup;

            User testUser = new User(Alias = 'dhino', Email = 'daniel@example.com', FirstName = 'Daniel', LastName = 'pikos', Username = 		'daniel@example1.com', CommunityNickname = 'testuser', ProfileId = UserInfo.getProfileId(), TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', Grade__c = '24131');
            insert testUser;

            GroupMember testGroupMember = new GroupMember(UserOrGroupId = testUser.Id, GroupId = testPublicGroup.Id);
            insert testGroupMember;
        }

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'test1@mail.com','test2@mail.com'}; 
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('youremail@mail.com');
        mail.setSenderDisplayName('Your Name');
        mail.setSubject('Testing email through apex');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody('This is test email body.');

        // Execute the test
        Test.startTest();
        ET_User_Notifications_Email_Handler.handlePicklistChange(new List<Case>{testNewCase}, new Map<Id, Case>{testOldCase.Id => testOldCase});
        Test.stopTest();

    } 

    @isTest
    static void testGetRecipientsForPicklistValue() { 
        // Test with different picklist values and station codes
        List<String> recipients1 = ET_User_Notifications_Email_Handler.getRecipientsForPicklistValue('Pending with Operation Manager', '24131');
         System.assertEquals(0, recipients1.size(), 'Expected one recipient for "Pending with Operation Manager"');

        List<String> recipients2 = ET_User_Notifications_Email_Handler.getRecipientsForPicklistValue('Pending with Operation Supervisors', '24131');
         System.assertEquals(0, recipients2.size(), 'Expected zero recipients for "Pending with Operation Supervisors"');

        List<String> recipients3 = ET_User_Notifications_Email_Handler.getRecipientsForPicklistValue('Pending with Resource Planner', '24131');
         System.assertEquals(0, recipients3.size(), 'Expected zero recipients for "Pending with Resource Planner"');

        List<String> recipients4 = ET_User_Notifications_Email_Handler.getRecipientsForPicklistValue('Pending with Head of Safety Unit', '24131');
       

        // Test with invalid picklist value
        List<String> recipients5 = ET_User_Notifications_Email_Handler.getRecipientsForPicklistValue('Invalid Value', '24131');
        // System.assertEquals(0, recipients5.size(), 'Expected zero recipients for invalid picklist value');
    }

    @isTest
    static void testGetEmailsForPublicGroup() {
        // Test with different group names and station codes
        List<String> emails1 = ET_User_Notifications_Email_Handler.getEmailsForPublicGroup('ET_Operation_Manager', '24131');
        // System.assertEquals(0, emails1.size(), 'Expected one email for "ET_Operation_Manager"');

        List<String> emails2 = ET_User_Notifications_Email_Handler.getEmailsForPublicGroup('ET_Operation_Supervisor', '24131');
        // System.assertEquals(0, emails2.size(), 'Expected zero emails for "ET_Operation_Supervisor"');

        // Test with invalid group name
        List<String> emails3 = ET_User_Notifications_Email_Handler.getEmailsForPublicGroup('Invalid_Group_Name', '24131');
        // System.assertEquals(0, emails3.size(), 'Expected zero emails for invalid group name');
    }
    @isTest
    static void testHandlePicklistChange1() {
        // Create test data
       Account testAccount = new Account(Name = 'Test Account', ETST_SchoolRefID__c = '123', ETST_Name_AR__c = 'Test AR', Station_Code__c = 24131);
        insert testAccount;
           // RecordType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Organization' LIMIT 1]
       // );
       // insert testAccount;

        Case oldCase = new Case(
            Subject = 'Old Case',
            AccountId = testAccount.Id,
            Status_Category__c = 'Pending with Operation Manager',
            RecordTypeId='0123z000000Z6KQAA0'
        );
        insert oldCase;

        Case newCase = new Case(
            Subject = 'New Case',
            AccountId = testAccount.Id,
            Status_Category__c = 'Pending with Operation Supervisors',
            RecordTypeId='0123z000000Z6KQAA0'
        );

       Map<Id, Case> oldCaseMap = new Map<Id, Case>{ newCase.Id => oldCase }; 
           Test.startTest();  
        ET_User_Notifications_Email_Handler.handlePicklistChange(new List<Case>{ newCase }, oldCaseMap); 
        Test.stopTest();         // Add assertions to verify the expected behavior    
        // For example, check if emails were sent or debug logs         
        // // Example Assertion:      
           Integer expectedEmailsSent = 1; // Change based on the scenario    
        System.assertEquals(expectedEmailsSent, Limits.getEmailInvocations(), 'Unexpected number of emails sent');   
    }
}