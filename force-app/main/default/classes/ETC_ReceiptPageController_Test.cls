@isTest
public class ETC_ReceiptPageController_Test {
    
    @isTest public static void receiptcontrollerTest(){
        List<ET_Service_Request__c> reqList = ETC_TestDataFactory.createServiceRequests(1);
        insert reqList;
        
        ET_Receipt__c recpt = new ET_Receipt__c();
        recpt.ET_Service_Request__c = reqList[0].id;
        recpt.ET_Amount__c =100.0;
        insert recpt;
        
        Test.StartTest(); 
        ETC_ReceiptPageController objRef = new ETC_ReceiptPageController();
        PageReference pageRef = Page.ETC_ReceiptPage;
        pageRef.getParameters().put('recordId', String.valueOf(reqList[0].Id));
        Test.setCurrentPage(pageRef);
        Test.StopTest();
        
    }   
    
}