@isTest
public class CaseDisputesTest {
    @isTest
    static void testUpdateDisputeConfirmation() {
        // Create a test Account
      Account testAccount = new Account(
            RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId(),
            Name = 'AL KHAIL',
            phone= '971567567',  
            billingcity='DUBAI',
            billingpostalcode='SW1635HJ',
            billingcountry='UAE',
            billingstreet='DUBAI INTERNET CITY',
            ETST_Name_AR__c='AL JEE',
          ETSALES_TaxRegistrationNo__c = '123456789654789'
            
        );
        insert testAccount;
        
        //Cretae data with Contact
        Contact testCon = new Contact(
            AccountId = testAccount.Id,
            FirstName = 'al mousa',
            LastName = 'alhukatr',
            email = 'test@test.com',
            RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(),
            birthdate = Date.newInstance(1992, 04, 12)
            
        );
        insert testCon;
        

        // Create a test Case with the required fields
        Case testCase = new Case(
            AccountId = testAccount.Id,
            ContactId = testCon.Id,
            Dispute_conformations__c = false
        );
        insert testCase;

        // Start the test
        Test.startTest();

        // Test the scenario where Dispute_conformations__c is false
        String result1 = CaseDisputes.updateDisputeConfirmation(testCase.Id);

        // Verify that the dispute confirmation was updated successfully
        Case updatedCase = [SELECT Dispute_conformations__c FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(true, updatedCase.Dispute_conformations__c, 'Dispute confirmation should be updated to true.');
        System.assertEquals('Dispute Confirmation updated successfully.', result1);

        // Test the scenario where Dispute_conformations__c is already true
        String result2 = CaseDisputes.updateDisputeConfirmation(testCase.Id);

        // Stop the test
        Test.stopTest();

        // Verify that the method returns the correct message when already updated
        System.assertEquals('Already you have updated dispute fields.', result2);
    }
}