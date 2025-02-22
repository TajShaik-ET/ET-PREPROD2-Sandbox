@IsTest
public class ETI_BookingInspectionHandlerTest {
    @testSetup
    private static  void testmethodInspection(){
        // create test user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@sm.com', 
                EmailEncodingKey='UTF-8', isActive = true, LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@sm.com');
        insert u;
        
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
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
        etcv1.Chassis_No__c = 'D032B5GC000790';
        etcv1.Plate_No__c = '53215';
        etcv1.status__c = 'Active';
        etcv1.Registration_Type__c ='Registered';
        insert etcv1;
        
        Id recordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        ET_Service_Request__c etsr = new ET_Service_Request__c();
        etsr.Payment_Status__c = 'Not Initiated';
        etsr.RecordTypeId = recordTypeId2;
        etsr.ET_Account__c = acc.id;
        insert etsr;
       
        Attachment att = new Attachment();
        att.ParentId = etsr.Id;
        att.Name = 'Test';
        att.Body = Blob.valueOf('Test');
        insert att;
        ETI_Vehicle_Service__c vehService = new ETI_Vehicle_Service__c();
        vehService.Service_Type__c='Certificate';
        vehService.Service_Premises__c='Visit ET Premises';
        vehService.Name = 'Test';
        vehService.Service_Code__c = '01';
        insert vehService;
        EmailTemplate e = new EmailTemplate ();
        System.runAs(u){
            String Sbjct='{!ETI_Booking__c.Vehicle_Number__c}';
            string Bodyvar= '{!ETI_Booking__c.Vehicle_Number__c} {!ETI_Booking__c.Test_Result__c} {!ETI_Booking__c.Vehicle_Number__c}';
            e = new EmailTemplate (developerName = 'Test_Result_Notification', Subject=Sbjct,HtmlValue=Bodyvar,Body = Bodyvar,FolderId = u.Id, TemplateType= 'text', Name = 'test'); 
            insert e;
        }
        ETI_Booking__c etiBooking = new ETI_Booking__c();
        etiBooking.Customer_Vehicle__c = etcv1.id;
        etiBooking.Booking_Status__c = 'Confirm';
        etiBooking.Service_Request__c = etsr.id;
        etiBooking.Selected_Services__c = 'Test';
        etiBooking.Chassis_No__c = 'D032B5GC000790';
        etiBooking.Test_Result__c = 'Pass';
        etiBooking.User__c = acc.id;
        etiBooking.Is_booking_Confirmed__c = true;
        etiBooking.Service_Type__c ='Police Inspection';
        etiBooking.Booking_Date__c= date.today()-2;
   
        Test.startTest();
        insert etiBooking;
        ETI_Service_Line_Item__c etline = new ETI_Service_Line_Item__c();
        etline.Service_Name__c = 'SLA';
        etline.Test_Result__c = 'Pass';
        etline.Booking__c = etiBooking.Id;
        etline.Service__c = vehService.Id;
        etline.Description__c= 'test link result';
        insert etline;
        etiBooking.Booking_Status__c = 'Booked';
        etiBooking.Test_Result__c = 'Failed';
        //etiBooking.Is_booking_Confirmed__c = true;
        update etiBooking;
        
        //cancelReceipt
        ETI_Inspection_Receipt__c receipt =new ETI_Inspection_Receipt__c();
        receipt.ET_Status__c = 'Active';
        receipt.Bookings__c= etiBooking.Id;
        receipt.ETI_Amount__c=100;
        insert receipt;
        etiBooking.Booking_Status__c = 'Cancelled';
        update etiBooking;
        Test.stopTest();
        
    }
    @isTest
    public static void testCase2(){
        List<ETI_Booking__c> bookingList = [SELECT id , Is_booking_Confirmed__c, Test_Result__c, (Select Id, Name,Service_Name__c,Test_Result__c From Services__r) FROM ETI_Booking__c];
       
        ETI_Service_Line_Item__c etline = new ETI_Service_Line_Item__c();
        etline.Service_Name__c = 'SLA';
        etline.Test_Result__c = 'Pass';
        etline.Booking__c = bookingList[0].Id;
        etline.Service__c = [select id from ETI_Vehicle_Service__c][0].Id;
        etline.Test_Result__c = 'Failed';
        insert etline;
        Map<Id, ETI_Booking__c> newMap = new   Map<Id, ETI_Booking__c>();
        ETI_Booking__c etiBooking = bookingList[0].clone();
        etiBooking.Is_booking_Confirmed__c = false;
        bookingList[0].Is_booking_Confirmed__c = true;
        newMap.put(bookingList[0].Id,bookingList[0]);
       
        Map<Id, ETI_Booking__c> oldMap = new   Map<Id, ETI_Booking__c>();
        oldMap.put(bookingList[0].Id,etiBooking);
       
        
        //bookingList[0].Is_booking_Confirmed__c = true;
        Test.startTest();
        //ETI_BookingInspectionHandler.updateEncrypted(newMap);
        ETI_BookingInspectionHandler.SendBookingConfirmationforExternal(newMap, oldMap);
        ETI_BookingInspectionHandler.SendTestResultCustomer(newMap, oldMap);
        // update bookingList[0];
       
        Test.stopTest();
    }
    
    
    
}