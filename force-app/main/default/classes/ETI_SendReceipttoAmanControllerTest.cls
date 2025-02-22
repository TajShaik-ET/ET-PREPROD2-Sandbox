@IsTest
public class ETI_SendReceipttoAmanControllerTest {
    @isTest
    public static void testSendReceipttoAman(){
        ETI_TestUtilityClass.testUserCreation();
        ETI_TestUtilityClass.testAccountCreation();
        ETI_TestUtilityClass.testCustomerVehicle();
        ETI_TestUtilityClass.testServiceRequest();
        ETI_TestUtilityClass.testBookings();
        ETI_TestUtilityClass.objServiceReq.Payment_Status__c = 'Payment Success';
        update ETI_TestUtilityClass.objServiceReq;
        ETI_SendReceipttoAmanController.createReceiptInAman(ETI_TestUtilityClass.objServiceReq.Id);
        
        ETI_TestUtilityClass.bookingList[0].Booking_Date__c= date.today()+3;
        update ETI_TestUtilityClass.bookingList[0];
        ETI_TestUtilityClass.testVehicleService();
        ETI_TestUtilityClass.testBookingItems();
        ETI_TestUtilityClass.bookingItemList[0].Booking__c=ETI_TestUtilityClass.bookingList[0].Id;
        ETI_TestUtilityClass.bookingItemList[0].AMAN_Receipt_No__c=null;
        update  ETI_TestUtilityClass.bookingItemList[0];
        ETI_TestUtilityClass.tesAmantReceipt();
        ETI_TestUtilityClass.objReceipt.Service_Request__c=ETI_TestUtilityClass.objServiceReq.Id;
        update ETI_TestUtilityClass.objReceipt;
        ETI_SendReceipttoAmanController.createReceiptInAman(ETI_TestUtilityClass.objServiceReq.Id);
        
        ETI_TestUtilityClass.tesAmantReceipt();
        ETI_TestUtilityClass.testVehicleService();
        ETI_TestUtilityClass.testBookingItems();
        ETI_TestUtilityClass.objReceipt.Integration_Status__C ='Error';
        ETI_TestUtilityClass.objReceipt.Integration_Message__c='Error';
        ETI_TestUtilityClass.objReceipt.Service_Line_Item__c=ETI_TestUtilityClass.bookingItemList[0].Id;
        Update ETI_TestUtilityClass.objReceipt;
        ETI_SendReceipttoAmanController.sendDataToAman(ETI_TestUtilityClass.objReceipt.Id);
    }
}