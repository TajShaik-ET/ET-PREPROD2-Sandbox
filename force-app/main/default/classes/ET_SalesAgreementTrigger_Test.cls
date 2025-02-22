@isTest
public class ET_SalesAgreementTrigger_Test{
 
 public static testmethod void saleaAggrementTrg(){
 
        Account objBusinessAcct = new Account();
        objBusinessAcct.Name = 'ALDAR Academies L.L.C   Al Muna Academy';
        objBusinessAcct.Type = 'Private School';
        objBusinessAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId();        
        insert objBusinessAcct;
        Contact con = new Contact();
        con.LastName = 'Last name';
        con.Email = 'noor.shaik@smaartt.com';
        insert con;
        Account objPersonAcct = new Account();
        objPersonAcct.FirstName = 'ALDAR ';
        objPersonAcct.LastName = 'Al Muna Academy';
        objPersonAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();        
        insert objPersonAcct;
        
        ET_Sales_Agreement__c objSalesAgr = new ET_Sales_Agreement__c();
        objSalesAgr.Name = 'Test';
        objSalesAgr.Activity__c = 'test';
        objSalesAgr.Administration_Charges__c  = 1234;
        objSalesAgr.Contract_End_Date__c = date.today().addDays(30);
        objSalesAgr.Contract_No__c = '123456789';
        objSalesAgr.Contract_Start_Date__c = date.today();
        objSalesAgr.Customer_PO_No__c = '12345';
        objSalesAgr.Salesforce_Customer__c = objPersonAcct.Id;
        insert objSalesAgr;
 }
}