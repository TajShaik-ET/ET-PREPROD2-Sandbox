@isTest
public class ETI_BookingTestResultControllerTest {
    
    private static testmethod void testmethodInspection(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.ETI_Person_B2C).getRecordTypeId();
        Account acc= new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        acc.ETSALES_Email__c = 'testAcc@gmail.com';
        acc.Preferred_Language__c='English';
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
        
        list<ETI_Service_Line_Item__c>  serviceLineItemWrp = new list<ETI_Service_Line_Item__c>();
        ETI_Service_Line_Item__c serviceline = new ETI_Service_Line_Item__c();
        serviceline.Booking__c=objBooking.Id;
        insert serviceline;
        
        PageReference pageRef = Page.ETI_VehicleTestResult; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',ETI_VehicleController.getEncryptedData(objBooking.Id));
        ETI_BookingTestResultController ctrl = new ETI_BookingTestResultController();
    }
}