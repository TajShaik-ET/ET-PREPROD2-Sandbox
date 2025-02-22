@isTest
public class ETI_BookingInvoiceControllerTest {
    
    private static testmethod void testmethodInspection(){
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        
        insert acc;
        /*   user us = [select accountid from user where id =:userinfo.getUserId()];
                us.accountid = acc.id;
                update us;*/
        Contact con = new Contact();
        con.LastName = 'Noor';
        con.Email = Label.ETI_TargetObject_Email;
        insert con;
        
        
        ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();
        etcv1.OwnerId = userinfo.getUserId();
        etcv1.Chassis_No__c = 'D032B5GC000790';
        etcv1.Plate_No__c = '';
        etcv1.status__c = 'Active';
        etcv1.Registration_Type__c ='Registered'; 
        
        
        insert etcv1;
        
        Id recordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        ET_Service_Request__c etsr = new ET_Service_Request__c();
        
        etsr.Payment_Status__c = 'Not Initiated';
        etsr.RecordTypeId = recordTypeId2;
        etsr.ET_Account__c = acc.id;
        
        insert etsr;
        
        ETI_Booking__c etiBooking = new ETI_Booking__c();
        
        etiBooking.Customer_Vehicle__c = etcv1.id;
        etiBooking.Booking_Status__c = 'confirm';
        etiBooking.Service_Request__c = etsr.id;
        etiBooking.Selected_Services__c = 'Test';
        etiBooking.Chassis_No__c = 'D032B5GC000790';
        //etiBooking.User__c = acc.id;
        ETI_Booking__c etiBooking1 = new ETI_Booking__c();
        
        etiBooking1.Customer_Vehicle__c = etcv1.id;
        etiBooking1.Booking_Status__c = 'Booked';
        etiBooking1.Service_Request__c = etsr.id;
        etiBooking1.Selected_Services__c = 'Test';
        etiBooking1.Chassis_No__c = 'D032B5GC000790';
         insert etiBooking1;
        test.startTest();
        insert etiBooking;
       
        test.stopTest();
        
        list<ETI_Booking__c> etlist = new list<ETI_Booking__c>();
        etlist.add(etiBooking);
        
        /* PageReference pageRef = Page.ETI_BookingInvoice;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(etiBooking);
            ApexPages.currentPage().getParameters().put('Id',etiBooking.id);*/
                    
        // EmployeeController ec = new EmployeeController(sc);
        PageReference pageRef = new PageReference('ETI_BookingInvoice');
        Blob cryptoKey = Blob.valueOf('123456789012345678901234');
        Blob data = Blob.valueOf(etiBooking1.id);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES192', cryptoKey, data);
        pageRef.getParameters().put('Id', EncodingUtil.base64Encode(encryptedData));
        Test.setCurrentPage(pageRef);
        
        ETI_BookingInvoiceController et = new ETI_BookingInvoiceController();
        et.bookingList = new  List<ETI_Booking__c>();
        // ETI_BookingInvoiceController.utilityMethod();
        /*  Test.StartTest(); 
            ApexPages.StandardController sc = new ApexPages.StandardController(etiBooking);
            PageReference pageRef = Page.ETI_VehicleController; // Add your VF page Name here
            pageRef.getParameters().put('id', String.valueOf(etiBooking.Id));
            Test.setCurrentPage(pageRef); */

        //et.booking = etiBooking;
        //et.bookingList = etlist;
        
        
    }
}