@isTest
public class ETI_BookingReminderBatchTest {

    @isTest
    public static void TestBookingReminder(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.ETI_Person_B2C).getRecordTypeId();
        Account acc= new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        acc.ETSALES_Email__c = 'testAcc@gmail.com';
        acc.Preferred_Language__c='English';
        insert acc;
        Contact con=new Contact();
        con.LastName='test';
        con.Email='test@gmail.com';
        insert con;
        Id recordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        ET_Service_Request__c servicerequest = new ET_Service_Request__c();
        servicerequest.Payment_Status__c = 'Payment Success';
        servicerequest.RecordTypeId = recordTypeId2;
        servicerequest.ET_Account__c = acc.id;
        insert servicerequest;
        ID extReordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByName().get('External').getRecordTypeId();
        ET_Customer_Vehicle__c custveh=new ET_Customer_Vehicle__c();
        custveh.Account__c=acc.ID;
        custveh.Preferred_Language__c='English';
        custveh.Vehicle_Color_Code1__c='1';
        custveh.Vehicle_Color_Code2__c='1';
        custveh.Vehicle_Color_Code3__c='1';
        custveh.Vehicle_Color_Code4__c='1';
        custveh.Plate_No__c='1234';
        insert custveh;
        ETI_TestUtilityClass.testLocationData();
        ETI_TestUtilityClass.testLaneDetails();
        
        ETI_Booking__c Ebook=new ETI_Booking__c();
        Ebook.User__c=acc.Id;
        Ebook.Mobile_No__c='+97112345678';
        Ebook.RecordTypeId=extReordTypeId;
        Ebook.Customer_Vehicle__c=custveh.Id;
        Ebook.Customer_Site_Address__c='Delhi';
        Ebook.Service_Type__c='certificate';
        Ebook.Customer_Site_Geometry__c='Geometry1';
        Ebook.Booking_Status__c='Booked';
        Ebook.Booking_Date__c=system.today()+1;
        Ebook.Service_Request__c=servicerequest.Id;
        Ebook.Allocated_Lane__c=ETI_TestUtilityClass.objLaneDetails.Id;
        
        insert Ebook;
               
        test.startTest();
        ETI_BookingReminderBatch etbb=new ETI_BookingReminderBatch(null);
        Database.executeBatch(etbb,1);
        String sch ='0 48 * * * ?'; 
        System.schedule('Schedule BookingReminderBatch', sch,etbb);

        test.stopTest();
    }
}