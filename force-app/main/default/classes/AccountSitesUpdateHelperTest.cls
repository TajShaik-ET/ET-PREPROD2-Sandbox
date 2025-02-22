@isTest
public class AccountSitesUpdateHelperTest {
   @testSetup
    static void setupData() {
        Account testAcc = new Account(
            Name = 'Test Account',
            ETSALES_TaxRegistrationNo__c = '123456789123456',
            ETSALES_Profile_Class__c = 'Class A'
        );
        insert testAcc;
        ETSALES_Account_Sites__c testSite = new ETSALES_Account_Sites__c(
            ETSALES_Account__c = testAcc.Id,
            Customer_TRN__c = testAcc.ETSALES_TaxRegistrationNo__c,
            ETSALES_Site_Profile_Class__c = testAcc.ETSALES_Profile_Class__c
        );
        insert testSite;
    }
    @isTest
    static void testUpdateAccountSites() {
        Account testAcc = [SELECT Id, ETSALES_TaxRegistrationNo__c, ETSALES_Profile_Class__c FROM Account LIMIT 1];
        testAcc.ETSALES_TaxRegistrationNo__c = '987654';
        testAcc.ETSALES_Profile_Class__c = 'Class B';
        Account oldAcc = new Account(
            Id = testAcc.Id,
            ETSALES_TaxRegistrationNo__c = '123456',
            ETSALES_Profile_Class__c = 'Class A'
        );
        Map<Id, Account> oldAccountMap = new Map<Id, Account> { oldAcc.Id => oldAcc };
            Test.startTest();
        AccountSitesUpdateHelper.updateAccountSites(new List<Account>{ testAcc }, oldAccountMap);
        Test.stopTest();
        ETSALES_Account_Sites__c updatedSite = [SELECT Customer_TRN__c, ETSALES_Site_Profile_Class__c
                                                FROM ETSALES_Account_Sites__c
                                                WHERE ETSALES_Account__c = :testAcc.Id LIMIT 1];
        System.assertEquals('987654', updatedSite.Customer_TRN__c, 'Customer_TRN__c should have been updated.');
        System.assertEquals('Class B', updatedSite.ETSALES_Site_Profile_Class__c, 'ETSALES_Site_Profile_Class__c should have been updated.');
    }
}