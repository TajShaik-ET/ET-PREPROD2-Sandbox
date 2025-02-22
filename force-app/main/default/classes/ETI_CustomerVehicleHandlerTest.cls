@isTest
public class ETI_CustomerVehicleHandlerTest {
    private static testmethod void testmethodInspection(){
    Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
    Id vechicleRTId = Schema.SObjectType.ET_Customer_Vehicle__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId(); 
    Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        acc.ETSALES_Email__c = 'testAcc@gmail.com';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Noor';
        con.Email = Label.ETI_TargetObject_Email;
        insert con;
        
        ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();
        etcv1.OwnerId = userinfo.getUserId();
        etcv1.RecordTypeId =vechicleRTId;
        etcv1.Chassis_No__c = 'D032B5GC000790';
        etcv1.Plate_No__c = '53215';
        etcv1.status__c = 'Active';
        etcv1.Registration_Type__c ='Registered';
        insert etcv1;
        
        ETI_Vehicle_Service__c vS=new ETI_Vehicle_Service__c ();
        vs.name='test';
        insert vs;
        
        Id recordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        ET_Service_Request__c etsr = new ET_Service_Request__c();
        etsr.Payment_Status__c = 'Not Initiated';
        etsr.RecordTypeId = recordTypeId2;
        etsr.ET_Account__c = acc.id;
        insert etsr;
       
        ETI_Booking__c etiBooking = new ETI_Booking__c();
        etiBooking.Customer_Vehicle__c = etcv1.id;
        etiBooking.Booking_Status__c = 'Confirm';
        etiBooking.Service_Request__c = etsr.id;
        etiBooking.Selected_Services__c = 'Test';
        etiBooking.Chassis_No__c = 'D032B5GC000790';
        etiBooking.Test_Result__c = 'Pass';
        etiBooking.User__c = acc.id;
        etiBooking.Is_booking_Confirmed__c = true;
   
        insert etiBooking;
        ETI_Service_Line_Item__c service=new ETI_Service_Line_Item__c ();
        service.Booking__c=etiBooking.Id;
        service.Service__c=vs.ID;
        insert service;
        etcv1.Chassis_No__C='qqqqqq1';
        etcv1.Tcf_No__c='123';
        update etcv1 ;
    }
}