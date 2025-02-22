@isTest
public class ETST_Global_Handler_Test {
    @testsetup
    public static void setUpdata(){
        
    }
    
    @isTest
    public static void testGlobalHandler(){
        List<Account> accList = new List<Account>();
        Account acc  = new Account(Name = 'Test Name');
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        accList.add(acc);
        acc  = new Account(Name = '001');
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId(); 
        // accList.add(acc);
        insert accList;
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Salesforce_Customer__c = accList[0].id;
        insert etSales;
        ETST_Calendar__c etcal = new ETST_Calendar__c();
        insert etcal;
        new ET_InspectionCancellation.Output();
        new ET_InspectionCancellation.Control();
        new Et_Fee.InspectionFeeOutputDetailCollection_element();
        new Et_Fee.Output();
        new Et_Fee.Control();
        new Et_Fee.InspectionFeeOutputDetail();
        new Et_Fee.InspectionFeeInputDetail();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc1 = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test');
        insert acc1;
        
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_Account_Name__c=acc1.Id);
        insert stdnt;
        
        Id serviceReqRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Service_Request').getRecordTypeId();
        ET_Service_Request__c  etreq = new ET_Service_Request__c(RecordTypeId=serviceReqRecordTypeId,Payment_Status__c='Not Initiated',ETST_Fare_Charges__c=80,ETST_Student__c=stdnt.Id,ETST_Paid_By__c = 'Self');
        insert etreq;
        
        etreq.Payment_Status__c='Partially Paid';
        etreq.ETST_Fare_Charges__c =1500;
        etreq.ETST_Pick_Up_End_Date__c = system.today();
        etreq.ETST_Pick_Up_Start_Date__c = system.today().addmonths(-2);
        update etreq;
        
        ET_Receipt__c receipt = new ET_Receipt__c();
        receipt.ET_Service_Request__c = etreq.id;
        receipt.ET_Amount__c = 100;
        insert receipt;
        
        ETST_Payment__c objETSTPayment = new ETST_Payment__c();
        objETSTPayment.RecordTypeId = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByName().get('On Premise Payment').getRecordTypeId();
        objETSTPayment.ETST_Amount__c = 1200;
        objETSTPayment.ET_Service_Request__c = etreq.id;
        objETSTPayment.ETST_Payment_State__c = 'CAPTURED';
        insert objETSTPayment;
        
    }
    
    @isTest static void testGlobalHanlder2(){
        ETST_Global_Handler.magicmethod(); 
        id profileId = [Select Id from Profile where Name='School Coordinator(Platform)' limit 1].Id;
        user coordinator = [Select Id,Name from User where Profileid=:profileId  and isactive=true limit 1];
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com',etst_coordinator__c=userinfo.getUserId());
        insert acc; 
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId(); 
        Account acc1 = new Account(RecordTypeId=schoolRecordTypeId,Name='Test');
        insert acc1;
        Account acc2 = new Account(RecordTypeId=schoolRecordTypeId,Name='Test1');
        insert acc2;
        delete acc2;
        ET_Sales_Agreement__c agr = new ET_Sales_Agreement__c(Salesforce_Customer__c=acc1.Id);
        insert agr;        
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',
                                                    ETST_Account_Name__c=acc.Id,ETST_School__c=acc1.Id,ETST_Parent_Access_Granted__c=false);
        insert stdnt;
        acc1.etst_coordinator__c=coordinator.Id;
        update acc1;
        
        
    }
    
}