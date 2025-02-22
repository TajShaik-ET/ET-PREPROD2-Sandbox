@isTest
    public class ETI_UdpateVehicleDetailsAfterBatchTest {
    private static testmethod void testmethodInspection(){
        Id regRecordTypeId = Schema.SObjectType.ET_Customer_Vehicle__c.getRecordTypeInfosByDeveloperName().get('Registered_Vehicle').getRecordTypeId();
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
        customerVehicle.Chassis_No__c = 'JTFHX02P8D0073462';
        customerVehicle.Registration_Type__c='Un-Registered';
        customerVehicle.Selected_Type__c='Chassis No';  
        insert customerVehicle;
                        
        List<ETI_Booking__c>  bookinlist = new List<ETI_Booking__c>();
        ETI_Booking__c objBooking = new ETI_Booking__c();
        objBooking.ET_Location__c = locationObj.Id;
        objBooking.Service_Request__c = serviceRequest.Id;
        objBooking.Booking_Date__c = Date.Today()-5;//Date.valueOf('2020-07-21');
        objBooking.Service_Type__c = 'Police Inspection';
        objBooking.ET_Location__c=locationObj.ETSALES_Emirates__c;
        objBooking.Customer_Vehicle__c = customerVehicle.Id;
        objBooking.Booking_Status__c = 'Booked';
        objBooking.Plate_No__c=customerVehicle.Plate_No__c;
        objBooking.Plate_Color__c=customerVehicle.Plate_Color__c;
        objBooking.Chassis_No__c=customerVehicle.Chassis_No__c;
        objBooking.Test_Result__c='Pass';
        insert objBooking;
        
        list<ETI_Service_Line_Item__c>  serviceLineItemWrp = new list<ETI_Service_Line_Item__c>();
        ETI_Service_Line_Item__c serviceline = new ETI_Service_Line_Item__c();
        serviceline.Booking__c=objBooking.Id;
        serviceline.Test_Date__c=Date.Today()+3;
        serviceline.Test_Result__c='Pass';
        insert serviceline;
        test.startTest();
        ETI_UdpateVehicleDetailsAfterResultBatch etbb= new ETI_UdpateVehicleDetailsAfterResultBatch(new Set<Id>{customerVehicle.Id});
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Database.executeBatch(etbb,1);
        String sch ='0 48 * * * ?'; 
        System.schedule('Schedule BookingsCancellation', sch,etbb);
        ET_Customer_Vehicle__c customerVehicle1 = new ET_Customer_Vehicle__c();
        customerVehicle1.Account__c = acc.Id;
        customerVehicle1.Registration_Type__c='Registered';
        customerVehicle1.Selected_Type__c='Plate Combination';  
        customerVehicle1.Plate_No__c='32052';
        customerVehicle1.Plate_Color_Code__c ='52';
        customerVehicle1.Plate_Type_Code__c = '1';
        customerVehicle1.Plate_Source_Code__c ='1';
        insert customerVehicle1;
        ETI_UdpateVehicleDetailsAfterResultBatch etbb1= new ETI_UdpateVehicleDetailsAfterResultBatch(new Set<Id>{customerVehicle1.Id});
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Database.executeBatch(etbb1,1);
        test.stopTest();    
    }
   
}