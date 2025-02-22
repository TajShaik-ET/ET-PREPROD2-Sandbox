@isTest
public class Account_SendToERP_Test {
   
   
    @isTest
    public static void Acc_SendToERPTest(){
        
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        Account acc = new Account(Name='Test1');
        acc.RecordTypeId  = RecordTypeId;
        acc.ETSALES_Payment_Terms__c='15 Days';
        acc.ETSALES_Customer_Account_Id__c = '1234';
        insert acc; 
		
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName ='TestCOn';
        con.Email ='test@gmail.com';
        insert con;
        ETSALES_Address__c add = new ETSALES_Address__c();
        add.ETSALES_Account__c = acc.Id;
        add.ETSALES_Address1__c = 'Test Address 1';
        add.ETSALES_Country__c = 'AE';
        insert add;
        
        ETSALES_Account_Sites__c site = new ETSALES_Account_Sites__c();
        site.ETSALES_Account__c = acc.Id;
        site.ETSALES_Address__c= add.Id;
        insert site;
        
        test.startTest();
        syncWithOracleBtnCtrl.callERPAccountIntegration(acc.Id);        
        system.enqueueJob(new Contact_SendToERP(acc.Id,'23242','23232'));        
        system.enqueueJob(new Address_SendToERPQueueableCtrl(acc.Id,'23242'));
        system.enqueueJob(new AccountSite_SendToERPQueueableCtrl(acc.Id,'23242','121344'));
        
        test.stopTest();
        
        
    }
    
    
    

}