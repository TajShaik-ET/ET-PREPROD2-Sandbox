@isTest
public class ETI_ServiceLineItemHandlerTest {
    private static testmethod void testmethodInspection(){
        Set<Id> vSetSLIIds = new Set<Id>();
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        ET_Service_Request__c serviceRequest = new ET_Service_Request__c();
        serviceRequest.ET_Account__c = acc.Id;
        insert serviceRequest;
        
        ET_Location__c locationObj = new ET_Location__c();
        locationObj.Name = 'Abu Dhabi';
        insert locationObj;
        
        ET_Customer_Vehicle__c customerVehicle = new ET_Customer_Vehicle__c();
        customerVehicle.Account__c = acc.Id;
        customerVehicle.Chassis_No__c = '43235';
        customerVehicle.Plate_Color__c='red';
        customerVehicle.Plate_No__c='4512';
        insert customerVehicle;
        
        List<ETI_Booking__c>  bookinlist = new List<ETI_Booking__c>();
        ETI_Booking__c objBooking = new ETI_Booking__c();
        objBooking.ET_Location__c = locationObj.Id;
        objBooking.Service_Request__c = serviceRequest.Id;
        objBooking.Booking_Date__c = Date.valueOf('2020-07-21');
        objBooking.Service_Type__c = 'Police Inspection';
        objBooking.ET_Location__c=locationObj.ETSALES_Emirates__c;
        objBooking.Customer_Vehicle__c = customerVehicle.Id;
        objBooking.Booking_Status__c = 'Booked';
        objBooking.Plate_No__c=customerVehicle.Plate_No__c;
        objBooking.Plate_Color__c=customerVehicle.Plate_Color__c;
        objBooking.Chassis_No__c=customerVehicle.Chassis_No__c;
        insert objBooking;
        objBooking.Test_Result__c='Pass';
        update objBooking;
        
        List<ETI_Service_Line_Item__c> newList = new List<ETI_Service_Line_Item__c> ();
        ETI_Service_Line_Item__c serviceline = new ETI_Service_Line_Item__c();
        serviceline.Booking__c=objBooking.Id;
        serviceline.Test_Result__c='Pass';
        serviceline.Test_Date__c=datetime.newInstance(2021, 9, 15, 12, 30, 0);
        insert serviceline;
        vSetSLIIds.add(serviceline.Id);
        
        serviceline.Test_Result__c='Fail';
        update serviceline;
        serviceline.Test_Result__c='Pass';
        update serviceline;
        serviceline.Test_Result__c='No';
        update serviceline;
    }
}