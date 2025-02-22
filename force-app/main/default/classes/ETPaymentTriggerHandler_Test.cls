/*
CreatedDate:07/28/2020
CreatedBy:G.Krishnareddy
Description:ETPaymentTriggerHandler/ETPaymentTriggerHelper for Test Data Preparation
*/
@isTest
public class ETPaymentTriggerHandler_Test{
    
    public static testmethod void paymentTriggerHandlerTestData(){
        Test.startTest();
        Account objBusinessAcct = new Account();
        objBusinessAcct.Name = 'ALDAR Academies L.L.C Al Muna Academy';
        objBusinessAcct.Type = 'Private School';
        objBusinessAcct.RecordTypeId = Schema.SObjectType.Account
            .getRecordTypeInfosByName()
            .get('Business (B2B) - School')
            .getRecordTypeId();        
        insert objBusinessAcct;
        Contact con = new Contact();
        con.LastName = 'Last name';
        con.Email = 'deepak_thomas@et.ae';
        con.AccountId = objBusinessAcct.Id; // Associate Contact with Account
        insert con;
        Account objPersonAcct = new Account();
        objPersonAcct.FirstName = 'ALDAR';
        objPersonAcct.LastName = 'Al Muna Academy';
        objPersonAcct.RecordTypeId = Schema.SObjectType.Account
            .getRecordTypeInfosByName()
            .get('Person (B2C)')
            .getRecordTypeId();        
        insert objPersonAcct;
        ETST_Student__c objStudent = new ETST_Student__c();
        objStudent.Name  = 'Test Student';
        objStudent.ETST_Emirates_Id__c = '784-2345-1234657-3';
        objStudent.ETST_Gender__c = 'Male';
        objStudent.ETST_Student_Id__c = 'std0001';
        objStudent.ETST_Nationality__c = 'United Arab Emirates';
        objStudent.ETST_Date_of_Birth__c = Date.today().addYears(-28);
        objStudent.ETST_ESIS_No__c = '123';
        objStudent.ETST_Division__c = 'A';
        objStudent.ETST_Grade__c = 'A';
        objStudent.ETST_Emirate__c = 'Dubai';
        objStudent.ETST_School__c = objBusinessAcct.Id;
        objStudent.ETST_Account_Name__c = objPersonAcct.Id;
        objStudent.ETST_Phone__c = '971557858043';
        insert objStudent;
        ET_Customer_Vehicle__c objCustomerVehicle = new ET_Customer_Vehicle__c();
        objCustomerVehicle.Chassis_No__c = 'AIU12111';
        objCustomerVehicle.Registration_Type__c = 'Registered';
        objCustomerVehicle.Plate_No__c = '111';
        objCustomerVehicle.Plate_Color__c = 'RED';
        objCustomerVehicle.Plate_Source__c = 'ABU DHABI';
        objCustomerVehicle.Plate_Type__c = 'PRIVATE';   
        objCustomerVehicle.Vehicle_Type__c = 'HEAVY BUS MORE THAN 27 PASSENGERS';
        objCustomerVehicle.Is_Verified__c = TRUE;
        objCustomerVehicle.Account__c = objBusinessAcct.Id;
        objCustomerVehicle.Status__c = 'Active';
        objCustomerVehicle.Vehicle_Type_Code__c = '5';
        insert objCustomerVehicle;
        ET_Service_Request__c objServiceReq =  new ET_Service_Request__c();
        objServiceReq.ETST_Student__c = objStudent.Id;
        objServiceReq.ETST_Service_Type__c = 'Half Yearly';
        objServiceReq.ETST_Fare_Charges__c = 1200;
        objServiceReq.ETST_Pick_Up_End_Date__c = Date.today();
        objServiceReq.ETST_Pick_Up_From__c = '4 19dStreet - Bur DubaiAl Hamriya - Dubai - United Arab Emirates';
        objServiceReq.ETST_Transport_Type__c = 'Two Way';
        objServiceReq.ETST_Is_Active__c = true;
        objServiceReq.ETST_Drop_Off_To__c = '4 19dStreet - Bur DubaiAl Hamriya - Dubai - United Arab Emirates';
        insert objServiceReq;
        ETI_Aman_Lookup__c objAmanLKP = new ETI_Aman_Lookup__c();
        objAmanLKP.Name = 'Renewal';
        objAmanLKP.ETI_LookupType__c = 'TEST_PURPOSE';
        objAmanLKP.ETI_LookupCode__c = '2';
        insert objAmanLKP;
        ETI_Booking__c objbooking = new ETI_Booking__c();
        objbooking.RecordTypeId = Schema.SObjectType.ETI_Booking__c
            .getRecordTypeInfosByName()
            .get('Internal')
            .getRecordTypeId();
        objbooking.Service_Request__c = objServiceReq.Id;
        objbooking.User__c = objBusinessAcct.Id;
        objbooking.Customer_Vehicle__c = objCustomerVehicle.Id;
        objbooking.Service_Type__c = 'Police Inspection';   
        objbooking.Purpose_Type__c = objAmanLKP.Id;
        objbooking.Booking_Status__c = 'Booked';
        objbooking.Amount__c = 1300;
        insert objbooking;
        ETST_Payment__c objETSTPayment = new ETST_Payment__c();
        objETSTPayment.RecordTypeId = Schema.SObjectType.ETST_Payment__c
            .getRecordTypeInfosByName()
            .get('On Premise Payment')
            .getRecordTypeId();
        objETSTPayment.ETST_Amount__c = 1200;
        objETSTPayment.ET_Service_Request__c = objServiceReq.Id;
        objETSTPayment.ETST_Payment_State__c = 'SUCCESS';
        insert objETSTPayment;
        objETSTPayment.ETST_Payment_State__c = 'COMPLETED'; // Example state change
        update objETSTPayment;
        Test.stopTest();
        
    }
}