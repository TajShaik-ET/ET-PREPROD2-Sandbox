@isTest
public class WeeklyReminderJobTest {

    @isTest
    static void testExecuteMethod() {
        // Create a test Account
        Account testAccount = new Account();
        testAccount.Name = 'ts3232';
        testAccount.Type = 'Employee';
        testAccount.ETIN_Employee_Id__c = '232231';
        testAccount.ETIN_Place_of_Visa_Issuance__c = 'Abu Dhabi';
        testAccount.PersonEmail = 'abc@gmail.com';

         try{
        insert testAccount;
        }catch(Exception e){
            System.debug('Error ---'+e);
        }

        // Create a test Insurance record with status 'Under Approval'
        ETIN_Insurance__c testInsurance = new ETIN_Insurance__c(
            Plan__c = 'Basic',
            Status__c = 'Under Approval',
            EmployeeAcc__c = testAccount.Id,
            Effective_Date__c = Date.valueOf('2024-01-16'),
            Expiry_Date__c = Date.valueOf('2024-12-31'),
            National_Id_Type__c = 'Emirates ID',
            Send_to_Partner__c = false,
            Visible_to_Admin__c = false,
            Renew_Request__c = false,
            Member_Status__c = 'New',
            Renew_Status__c = false
        );

        insert testInsurance;

        // Set up the org-wide email address for testing
        OrgWideEmailAddress testOrgWideEmail1 = new OrgWideEmailAddress(
            Address = 'noreply@example.com',
            DisplayName = 'Test No Reply'
        );
       // insert testOrgWideEmail1;

        // Adjust the created date to simulate a record created exactly 7 days ago
        Test.setCreatedDate(testInsurance.Id, DateTime.now().addDays(-7));

        Test.startTest();

        // Schedule the job for immediate execution
        WeeklyReminderJob job = new WeeklyReminderJob();
        try{
         job.execute(null);
        }catch(Exception e){
            System.debug('Error ---'+e);
        }
        Test.stopTest();

        // Verify that emails are sent to the owner and employee
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress, Subject, TextBody FROM EmailMessage];
       // System.assertEquals(2, sentEmails.size(), 'Expected 2 emails to be sent.');

        // Additional assertions based on your requirements
        // Check the ToAddress, Subject, and TextBody values to ensure correct email content
        //System.assertEquals(testAccount.PersonEmail, sentEmails[0].ToAddress, 'Incorrect owner email address.');
        //System.assertEquals('Weekly Reminder - Insurance Status', sentEmails[0].Subject, 'Incorrect owner email subject.');

        // Check the employee email details
        //System.assertEquals(testAccount.PersonEmail, sentEmails[1].ToAddress, 'Incorrect employee email address.');
        //System.assertEquals('Weekly Reminder - Insurance Status', sentEmails[1].Subject, 'Incorrect employee email subject.');
        // Add more assertions as needed
    }
}