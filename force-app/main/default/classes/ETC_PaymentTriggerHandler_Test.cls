@isTest
public class ETC_PaymentTriggerHandler_Test {

    @isTest public static void vehicleBkngHandlerTest(){
        List<ET_Service_Request__c> reqList = ETC_TestDataFactory.createServiceRequests(1);
        reqList[0].ETCAR_Request_Type__c='Manual';
        insert reqList;
        List<ETCAR_Car__c> carsList = ETC_TestDataFactory.createCars(3, 'SUV');
        insert carsList;
        List<ETCAR_Service_Request_Line_Item__c> vBkngList = ETC_TestDataFactory.createVehicleBookings(3, reqList[0].Id,carsList[0].Id);
        vBkngList[0].ETST_Service_Type__c = 'One Way';
        vBkngList[1].ETST_Service_Type__c = 'Hourly';
        vBkngList[1].ETC_Duration__c = '3 Hours';
        insert vBkngList;  
        
        ETST_Payment__c pay = new ETST_Payment__c(ET_Service_Request__c = reqList[0].Id,ETST_Amount__c=100.0,ETST_Capture_State__c='SUCCESS');
        insert pay;
        pay.ETST_Payment_State__c='CAPTURED';
        update pay;
      }
}