@isTest
public class ETIN_InsuranceTriggerHelperTest {
 @isTest
    static void testInsuranceStatusUpdateEmail() {
        // Create a test Account
       Account testAccount = new Account();
        testAccount.Name = 'ts3232';
        testAccount.Type = 'Employee';
        testAccount.ETIN_Employee_Id__c ='232231';
        testAccount.ETIN_Place_of_Visa_Issuance__c = 'Abu Dhabi';
        
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
            OrgWideEmailAddress testOrgWideEmail = new OrgWideEmailAddress(
            Address = 'noreply@example.com',
            DisplayName = 'Test No Reply'
        );
       // insert testOrgWideEmail;
        Test.startTest();
        // Update the Insurance record to trigger the email
        testInsurance.Status__c = 'Completed';
        try{
        update testInsurance;
        }catch(Exception e){
            System.debug('Error ---'+e);
        }
        Test.stopTest();
              List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage];
          }
     
}