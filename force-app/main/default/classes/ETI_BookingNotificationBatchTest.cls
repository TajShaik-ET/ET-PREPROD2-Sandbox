@isTest
public class ETI_BookingNotificationBatchTest {
    private static testmethod void testBookingNotification(){
        Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        Id B2BRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
        Id bkngIntRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        ETI_TestUtilityClass.testUserCreation();
        ETI_TestUtilityClass.testVehicleService();
        Id p1 = [select id from profile where name='OneET Business Partner Login User'].id;
        String Sbjct='{!ETI_Booking__c.Vehicle_Number__c}';
        string Bodyvar= '{!emailContent}';
        EmailTemplate objTemplate1 = new EmailTemplate();
        System.runAs(ETI_TestUtilityClass.objUser){
            objTemplate1 = new EmailTemplate(developerName = 'Booking_Confirmation', Subject=Sbjct,HtmlValue=Bodyvar,Body = Bodyvar,FolderId = ETI_TestUtilityClass.objUser.Id, TemplateType= 'text', Name = 'test');
            insert objTemplate1;
        }
        Account acc = new Account(name ='noor test1',RecordTypeId=B2BRecordtypeId,ETI_Emirates__c='Abu Dhabi',ETSALES_Email__c = 'testAcc1@gmail.com') ;
        insert acc; 
        Contact con = new Contact(LastName ='testCon',AccountId = acc.Id,email='test123@sm1.com');
        insert con;  
        User user = new User(alias = 'test123', email='test123@sm1.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p1, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='test123@sm1.com');
       
        insert user;
        system.runAs(user) {
            ET_Customer_Vehicle__c objVehicle = new ET_Customer_Vehicle__c(OwnerId = user.Id,Chassis_No__c = 'D032B5GC000790',Plate_No__c = '53215',
                                                status__c = 'Active',Registration_Type__c ='Registered');
            insert objVehicle;
            ET_Service_Request__c serviceReq= new ET_Service_Request__c(Payment_Status__c = 'Payment Success',RecordTypeId = recordTypeId,ET_Account__c = acc.id,
                                                                        ETI_Payment_Type__c='Online');
            insert serviceReq;
            ET_Service_Request__c serviceReq2= new ET_Service_Request__c(Payment_Status__c = 'Payment Success',RecordTypeId = recordTypeId,ET_Account__c = acc.id,
                                                                        ETI_Payment_Type__c='Online');
            insert serviceReq2;
            ETI_Booking__c booking1=new ETI_Booking__c(Customer_Vehicle__c = objVehicle.id,Booking_Status__c = 'Booked',Service_Request__c = serviceReq.id,
                                               Selected_Services__c = 'Test',Chassis_No__c = 'D032B5GC000790',Test_Result__c = 'Pass',recordTypeId=bkngIntRecordTypeId,
                                               User__c = acc.id,Is_booking_Confirmed__c = true,Service_Type__c ='Police Inspection',Booking_Date__c= date.today()-2);
            insert booking1;
            ETI_Booking__c booking2=new ETI_Booking__c(Customer_Vehicle__c = objVehicle.id,Booking_Status__c = 'Booked',Service_Request__c = serviceReq2.id,
                                               Selected_Services__c = 'Test',Chassis_No__c = 'D032B5GC000790',Test_Result__c = 'Pass',recordTypeId=bkngIntRecordTypeId,
                                               User__c = acc.id,Is_booking_Confirmed__c = true,Service_Type__c ='Police Inspection',Booking_Date__c= date.today()-2);
            insert booking2;
            ETI_Service_Line_Item__c item1=new ETI_Service_Line_Item__c(Service_Name__c = 'SLA',Test_Result__c = 'Pass',Booking__c = booking1.Id,
                                                                    Service__c = ETI_TestUtilityClass.objVehService.Id,Description__c= 'test link result',Total_Fee__c=100);
            insert item1;
            
            ETI_Service_Line_Item__c item2=new ETI_Service_Line_Item__c(Service_Name__c = 'SLA',Test_Result__c = 'Pass',Booking__c = booking2.Id,
                                                                    Service__c = ETI_TestUtilityClass.objVehService.Id,Description__c= 'test link result',Total_Fee__c=100);
            insert item2;
        }
        ETI_BookingNotificationBatch etbb = new ETI_BookingNotificationBatch();
        Database.executeBatch(etbb);
        String sch ='0 48 * * * ?'; 
        System.schedule('Schedule BookingNotificationBatch', sch,etbb);
    }
}