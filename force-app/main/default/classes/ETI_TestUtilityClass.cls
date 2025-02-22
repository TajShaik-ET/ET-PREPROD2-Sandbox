/**************************************************************************************************
Name : ETI_TestUtilityClass
Date Created: 02/22/2021
Author: Noor Shaik
Description : This is the class where-in all test data is created, to be used by test classes                 

Modification History :   
[Noor Shaik on 02/22/2021] - Modified the Util Class to add/Modify methods for ETI_ServiceRequestHandler

[<User> on <Date>] - <Detail>
****************************************************************************************************/
@isTest
public class ETI_TestUtilityClass {

    /******* DECLARATION OF STATIC VARIABLES **********/  
    public static User objUser; 
    public static Account objAccount; 
    public static Contact objContact; 
    public static ET_Customer_Vehicle__c objVehicle;
    public static ET_Service_Request__c objServiceReq;
    public static Attachment objAttachment;
    public static ETI_Vehicle_Service__c objVehService;
    public static EmailTemplate objTemplate;
    public static ET_Location__c objLocation;
    public static ETI_Lane_Details__c objLaneDetails;
    public static list<ETI_Booking__c> bookingList;
    public static list<ETI_Service_Line_Item__c> bookingItemList;
    public static Invoice__c objInvoice;
    public static ETI_Inspection_Receipt__c  objReceipt;
    public static ETST_Payment__c objPayment;
    public static ET_Refund__c objRefund;
    
    /******* DATA CREATION FOR USER **********/
    public static void testUserCreation(){
        //[02/22/2021 , Added the query to get Profile Id which can be used while creating test user]
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        objUser = new User(Alias = 'standt', Email='standarduser@sm.com', 
                            EmailEncodingKey='UTF-8', isActive = true, LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@sm.com');
        insert objUser;
        System.assertEquals('Testing' , objUser.LastName);
    }
    /******* DATA CREATION FOR ACCOUNT **********/
    public static void testAccountCreation(){
        //[02/22/2021 , Modified to add the TreePoscdesc Values]
        Id recordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        objAccount = new Account(FirstName = 'Test',LastName = 'Account',PersonEmail = 'test@gmail.com',Preferred_Language__c='English',
                                 RecordTypeId = recordTypeId,ETSALES_Email__c = 'testAcc@gmail.com',PersonMobilePhone='+971555555555');
        insert objAccount;
        System.assertEquals('Account',objAccount.LastName);
    }
    
    /******* DATA CREATION FOR Contact **********/
    public static void testContactCreation(){
        objContact = new Contact(LastName = 'Noor',Email = Label.ETI_TargetObject_Email);
        insert objContact;
        System.assertEquals('Noor',objContact.LastName);
    }
    /******* DATA CREATION FOR  ET_Customer_Vehicle__c**********/
    public static void testCustomerVehicle(){
        objVehicle = new ET_Customer_Vehicle__c(OwnerId = userinfo.getUserId(),Chassis_No__c = 'D032B5GC000790',Plate_No__c = '53215',
                                                status__c = 'Active',Registration_Type__c ='Registered');
        insert objVehicle;
        System.assertEquals('D032B5GC000790',objVehicle.Chassis_No__c);
    }
    /******* DATA CREATION FOR  ET_Service_Request__c**********/
    public static void testServiceRequest(){
        Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        objServiceReq= new ET_Service_Request__c(Payment_Status__c = 'Not Initiated',RecordTypeId = recordTypeId,ET_Account__c = objAccount.id,
                                                 ETI_Payment_Type__c='Online');
        insert objServiceReq;
        System.assertEquals('Not Initiated',objServiceReq.Payment_Status__c );
    }
    /******* DATA CREATION FOR  Attachment **********/
    public static void testAttachment(){
        objAttachment = new Attachment(ParentId = objServiceReq.Id,Name = 'Test',Body = Blob.valueOf('Test'));
        insert objAttachment;
        System.assertEquals('Test',objAttachment.Name );
    }
    /******* DATA CREATION FOR  ETI_Vehicle_Service__c**********/
    public static void testVehicleService(){
        objVehService = new ETI_Vehicle_Service__c(Service_Type__c='Certificate',Service_Premises__c='Visit ET Premises',
                                                       Name = 'Test',Service_Code__c = '01');
        insert objVehService;
        System.assertEquals('Test',objVehService.Name);
    }
    /******* DATA CREATION FOR  EmailTemplate **********/
    public static void testEmailTemplate(){
        String Sbjct='{!ETI_Booking__c.Vehicle_Number__c}';
        string Bodyvar= '{!ETI_Booking__c.Vehicle_Number__c} {!ETI_Booking__c.Test_Result__c} {!ETI_Booking__c.Vehicle_Number__c}';
        objTemplate = new EmailTemplate(developerName = 'Test_Result_Notification', Subject=Sbjct,HtmlValue=Bodyvar,Body = Bodyvar,FolderId = objUser.Id, TemplateType= 'text', Name = 'test');
        insert objTemplate;
        System.assertEquals('Test_Result_Notification',objTemplate.developerName);
    }
    /******* DATA CREATION FOR  ET_Location__c**********/
    public static void testLocationData(){
        objLocation = new ET_Location__c(Name = 'Abu Dhabi',Status__c='Active');
        insert objLocation;
        System.assertEquals('Abu Dhabi',objLocation.Name);
    }
    /******* DATA CREATION FOR  ETI_Lane_Details__c**********/
    public static void testLaneDetails(){
        objLaneDetails = new ETI_Lane_Details__c(Lane_Status__c='Active',Booking_Type__c='Internal',ET_Location__c=objLocation.id,Slot_Frequency__c='10 Minutes',Available_Slots__c='08:00;08:15',Lane_Type_AMAN__c='test');
        insert objLaneDetails;
        System.assertEquals('Active',objLaneDetails.Lane_Status__c);
    }
    /******* DATA CREATION FOR  ETI_Booking__c **********/
    public static void testBookings(){
        bookingList = new list<ETI_Booking__c>();  
        Id bkngIntRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        bookingList.add(new ETI_Booking__c(Customer_Vehicle__c = objVehicle.id,Booking_Status__c = 'Booked',Service_Request__c = objServiceReq.id,
                                           Selected_Services__c = 'Test',Chassis_No__c = 'D032B5GC000790',Test_Result__c = 'Pass',recordTypeId=bkngIntRecordTypeId,
                                           User__c = objAccount.id,Is_booking_Confirmed__c = true,Service_Type__c ='Police Inspection',Booking_Date__c= date.today()-2));
        insert bookingList;
        System.assertEquals('Booked',bookingList[0].Booking_Status__c);
    }
    /******* DATA CREATION FOR  ETI_Service_Line_Item__c **********/
    public static void testBookingItems(){
        bookingItemList = new list<ETI_Service_Line_Item__c>(); 
        bookingItemList.add(new ETI_Service_Line_Item__c(Service_Name__c = 'SLA',Test_Result__c = 'Pass',Booking__c = bookingList[0].Id,
                                                         Service__c = objVehService.Id,Description__c= 'test link result',Total_Fee__c=100));
        insert bookingItemList;
        System.assertEquals('Pass',bookingItemList[0].Test_Result__c);
    }
    /******* DATA CREATION FOR  Invoice__c**********/
    public static void tesInvoice(){
        Id invRecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        objInvoice = new Invoice__c(recordTypeId=invRecordTypeId,fromDate__c=Date.today(),Service_Request__c=objServiceReq.Id,
                                    Customer__c=objServiceReq.ET_Account__c,Total_Inv_Amount__c=objServiceReq.Total_Amount__c,
                                    Customer_Number__c=objServiceReq.ET_Account__r.PersonMobilePhone,Payment_Status__c=objServiceReq.Payment_Status__c,ETST_Active__c=true);
        insert objInvoice;
        System.assertEquals(true,objInvoice.ETST_Active__c);
    }
    /******* DATA CREATION FOR  ETI_Inspection_Receipt__c **********/
    public static void tesAmantReceipt(){
        objReceipt = new ETI_Inspection_Receipt__c(ET_Status__c = 'Active',Bookings__c= bookingList[0].Id,
                                                   ETI_Amount__c=100);
        insert objReceipt;
        System.assertEquals('Active',objReceipt.ET_Status__c);
    }
    /******* DATA CREATION FOR  ETST_Payment__c **********/
    public static void tesPaymentData(){
        Id recordTypeId = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Card_Payment').getRecordTypeId();
        objPayment = new ETST_Payment__c(recordTypeId=recordTypeId,ETST_Payment_State__c='Payment Success',ETST_Capture_State__c='SUCCESS',ET_Service_Request__c=objServiceReq.Id,ETST_Amount__c=100);
        insert objPayment;
        System.assertEquals('SUCCESS',objPayment.ETST_Capture_State__c);
    }
    /******* DATA CREATION FOR  ET_Refund__c **********/
    public static void tesRefundData(){
        objRefund = new ET_Refund__c(ET_Refund_Status__c='Completed',ET_Payment__c=objPayment.Id,ETI_Booking__c= bookingList[0].Id,ET_Refund_Amount__c=100,ET_Service_Request__c=objServiceReq.Id);
        insert objRefund;
        System.assertEquals('Completed',objRefund.ET_Refund_Status__c);
    }
}