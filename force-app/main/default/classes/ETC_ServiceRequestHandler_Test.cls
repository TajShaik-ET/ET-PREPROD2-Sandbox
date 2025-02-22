@isTest
public class ETC_ServiceRequestHandler_Test {
    
    @isTest public static void serviceReqTest(){
         List<ET_Service_Request__c> reqList = ETC_TestDataFactory.createServiceRequests(3);
        insert reqList;
        List<ETCAR_Car__c> carsList = ETC_TestDataFactory.createCars(3, 'SUV');
        insert carsList;
        List<ETCAR_Service_Request_Line_Item__c> vBkngList = ETC_TestDataFactory.createVehicleBookings(3, reqList[1].Id,carsList[0].Id);
        vBkngList[0].ETST_Service_Type__c = 'One Way';
        vBkngList[1].ETST_Service_Type__c = 'Hourly';
        vBkngList[1].ETC_Duration__c = '3 Hours';
        insert vBkngList;
        Test.startTest();
        reqList[0].ETC_Send_Payment_Link__c = true;
        update reqList[0];
        reqList[1].ETC_Payment_Status__c = 'Payment Success';
        update reqList[1];
        reqList[2].ETC_Payment_Status__c = 'Refund Requested';
        update reqList[2];
        ET_Receipt__c recpt = new ET_Receipt__c();
        recpt.RecordTypeId = Schema.SObjectType.ET_Receipt__c.getRecordTypeInfosByDeveloperName().get('ET_Car_Services').getRecordTypeId(); 
        recpt.ET_Service_Request__c = reqList[0].id;
        recpt.ET_Amount__c =100.0;
        insert recpt;
        
        ETC_ServiceRequestHandler.updatePostServicePayment(reqList[0].id);
        Test.stopTest();
       
        
    }
}