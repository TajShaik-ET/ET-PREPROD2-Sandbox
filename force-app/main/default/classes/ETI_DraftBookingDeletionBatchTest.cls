@isTest
public class ETI_DraftBookingDeletionBatchTest {
    
    private static testmethod void testmethodInspection(){
        
        ET_Customer_Vehicle__c ObjCustomerVehicle = new ET_Customer_Vehicle__c();
        ObjCustomerVehicle.OwnerId = UserInfo.getUserId();
        ObjCustomerVehicle.Chassis_No__c = 'D032B5GC000790';
        ObjCustomerVehicle.Plate_No__c = '';
        ObjCustomerVehicle.status__c = 'Active';
        ObjCustomerVehicle.Registration_Type__c ='Registered';
        insert ObjCustomerVehicle;
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        
        insert acc;
        
        
         Contact con = new Contact();
        con.LastName = 'Noor';
        con.Email = Label.ETI_TargetObject_Email;
        insert con;
        
        
        Id recordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        
        ET_Service_Request__c objServiceRequest = new ET_Service_Request__c();
        objServiceRequest.Payment_Status__c = 'Not Initiated';
        objServiceRequest.RecordTypeId = recordTypeId2;
        objServiceRequest.ET_Account__c = acc.id;
        insert objServiceRequest;
        
        ETI_Booking__c objBooking = new ETI_Booking__c();
        objBooking.Booking_Status__c = 'Draft';
        objBooking.Service_Request__c = objServiceRequest.Id;
        objBooking.Customer_Vehicle__c = ObjCustomerVehicle.Id;
        insert objBooking;
        
        ETI_DraftBookingDeletionBatch etbb = new ETI_DraftBookingDeletionBatch();
        
        test.startTest();
        
        Database.executeBatch(etbb);
        
        Test.stopTest();
    }
    
}