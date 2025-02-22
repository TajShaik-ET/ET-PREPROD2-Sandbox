@isTest
public class ETST_StudentActivatetScheduler_Test{
/*
public static testmethod void studentActivateBatchClassTestData(){
       
        Account objBusinessAcct = new Account();
        objBusinessAcct.Name = 'ALDAR Academies L.L.C   Al Muna Academy';
        objBusinessAcct.Type = 'Private School';
        objBusinessAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId();        
        insert objBusinessAcct;
        Contact con = new Contact();
        con.LastName = 'Last name';
        con.Email = 'noor.shaik@smaartt.com';
        insert con;
        Account objPersonAcct = new Account();
        objPersonAcct.FirstName = 'ALDAR ';
        objPersonAcct.LastName = 'Al Muna Academy';
        objPersonAcct.PersonEmail = 'noor.shaik@smaartt.com';
        objPersonAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();        
        insert objPersonAcct;
        
        ETST_Student__c objStudent = new ETST_Student__c();
        objStudent.Name  = 'Test Student';
        objStudent.ETST_Emirates_Id__c = '784-2345-1234657-3';
        objStudent.ETST_Gender__c = 'Male';
        objStudent.ETST_Student_Id__c = 'std0001';
        objStudent.ETST_Nationality__c = 'United Arab Emirates';
        objStudent.ETST_Date_of_Birth__c = date.today().addYears(-28);
        objStudent.ETST_ESIS_No__c = '123';
        objStudent.ETST_Division__c = 'A';
        objStudent.ETST_Grade__c = 'A';
        objStudent.ETST_Emirate__c = 'Dubai';
        objStudent.ETST_School__c = objBusinessAcct.Id;
        objStudent.ETST_Account_Name__c = objPersonAcct.Id;
        objStudent.ETST_Phone__c = '971557858043';
        objStudent.ETST_Status__c='Inactive';
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
        objServiceReq.ETST_Reason_for_Cancellation__c = 'On Hold';
        objServiceReq.ETST_Cancellation_End_Date__c = Date.today().addDays(-1);
        //objServiceReq.ETST_Pick_Up_Time__c = 120;
        objServiceReq.ETST_Fare_Charges__c = 1200;
        objServiceReq.ETST_Pick_Up_End_Date__c = date.today();
        objServiceReq.ETST_Pick_Up_From__c = '4 19dStreet - Bur DubaiAl Hamriya - Dubai - United Arab Emirates';
        objServiceReq.ETST_Transport_Type__c = 'Two Way';
        objServiceReq.ETST_Is_Active__c = true;
        objServiceReq.ETST_Drop_Off_To__c = '4 19dStreet - Bur DubaiAl Hamriya - Dubai - United Arab Emirates';
        insert objServiceReq;
        
        ETST_StudentActivateBatchClass bat = new ETST_StudentActivateBatchClass();
        DataBase.executeBatch(bat);
        ETST_StudentActivatetScheduler sh1 = new ETST_StudentActivatetScheduler();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1); 
    }
*/
}