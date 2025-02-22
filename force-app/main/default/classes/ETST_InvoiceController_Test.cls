@isTest
public class ETST_InvoiceController_Test {
    
    public static testMethod void loadInvoicesTest(){
        
        System.Test.StartTest();
        
        ETST_School__c school = new ETST_School__c(Name = 'Test School');
        insert school;
 
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test');
        insert acc;
        
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_Account_Name__c=acc.Id, ETST_School_Name__c = school.Id);
        insert stdnt;
        
        ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Paid_By__c = 'Self');
        insert etreq;
        
        ETST_InvoiceController invctrl = new ETST_InvoiceController();
        
        Invoice__c inv = new Invoice__c(ETST_Active__c=true,Service_Request__c=etreq.Id);
        insert inv;
        
        
        invctrl.recordId = etreq.Id;
        invctrl.employerAddress = 'Test Address';
        invctrl.loadInvoices();        
       // ETST_InvoiceController.testData();
        invctrl.transportRequest = etreq;
        invctrl.selfAddress = 'testSelfAddress';
        invctrl.address = 'testAddress';
        
        System.Test.StopTest();
    }

    
}