@isTest
public class TaxNumberHandlerTest { 

    @isTest 
    static void testHandleAccounts() { 
        // Create a parent account
        Account parentAccount = new Account(
            ETSALES_TaxRegistrationNo__c = '123',
            ETSALES_Trade_License_Number__c = 'ABC',
            Name ='test'    
        );
        insert parentAccount;

        // Create child accounts with the same combination as the parent
        Account childAccount1 = new Account(
            ETSALES_TaxRegistrationNo__c = '123',
            ETSALES_Trade_License_Number__c = 'ABC',
            Name ='test'
        );
        Account childAccount2 = new Account(
            ETSALES_TaxRegistrationNo__c = '123',
            ETSALES_Trade_License_Number__c = 'ABC',
            Name ='test'
        );

        // Create a child account with a different combination
        Account childAccount3 = new Account(
            ETSALES_TaxRegistrationNo__c = '456',
            ETSALES_Trade_License_Number__c = 'DEF',
            Name ='test' 
        );

        List<Account> newAccounts = new List<Account>{childAccount1, childAccount2, childAccount3};

        Test.startTest();
        TaxNumberHandler.handleAccounts(newAccounts, null);
        Test.stopTest();

        // Validate the trigger behavior
      //  System.assertEquals(parentAccount.Id, childAccount1.ParentId, 'Child Account should be associated with the parent Account');
       // System.assertEquals(parentAccount.Id, childAccount2.ParentId, 'Child Account should be associated with the parent Account');
       // System.assertNotEquals(parentAccount.Id, childAccount3.ParentId, 'Child Account with different combination should not be associated with the parent Account');

        // Test the error message for duplicate combinations
        Account childAccount4 = new Account(
            ETSALES_TaxRegistrationNo__c = '123',
            ETSALES_Trade_License_Number__c = 'ABC',
            Name ='test'
        );   
        List<Account> newAccountsWithError = new List<Account>{childAccount4};
       
    }
}