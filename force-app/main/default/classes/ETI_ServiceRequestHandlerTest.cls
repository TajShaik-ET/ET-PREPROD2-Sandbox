@IsTest
public class ETI_ServiceRequestHandlerTest {
    @isTest
    public static void testmethodInspection1(){
        ETI_TestUtilityClass.testUserCreation();
        System.runAs(ETI_TestUtilityClass.objUser){
            ETI_TestUtilityClass.testAccountCreation();
            ETI_TestUtilityClass.testCustomerVehicle();
            ETI_TestUtilityClass.testServiceRequest();
            ETI_TestUtilityClass.testBookings();
        }
        Test.startTest();
            Id bkngExtRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();
            ETI_TestUtilityClass.bookingList[0].recordTypeId =bkngExtRecordTypeId;
            update ETI_TestUtilityClass.bookingList[0];
            ETI_TestUtilityClass.objServiceReq.Payment_Status__c ='Payment Success';
            update ETI_TestUtilityClass.objServiceReq;
            ET_Location__c location=new ET_Location__c(Name='Al Ain Inspection Centre',Status__c='Active',Location_Code__c='04023');
            insert location;
            ETI_TestUtilityClass.bookingList[0].ET_Location__c=location.Id;
            update ETI_TestUtilityClass.bookingList[0];
            ETI_TestUtilityClass.objServiceReq.Payment_Status__c =system.label.ETI_ServiceRequest_Payment_Status;
            update ETI_TestUtilityClass.objServiceReq;
        
        Test.stopTest();
    }
   
    @isTest
    public static void testmethodInspection2(){
        Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        ETI_TestUtilityClass.testUserCreation();
        ETI_TestUtilityClass.testAccountCreation();
        ETI_TestUtilityClass.testCustomerVehicle();
        ETI_TestUtilityClass.testServiceRequest();
        Id invRecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        Invoice__c objInvoice1 = new Invoice__c(recordTypeId=invRecordTypeId,fromDate__c=Date.today(),Service_Request__c=ETI_TestUtilityClass.objServiceReq.Id,
                                    Customer__c=ETI_TestUtilityClass.objServiceReq.ET_Account__c,Total_Inv_Amount__c=100,
                                    Customer_Number__c=ETI_TestUtilityClass.objServiceReq.ET_Account__r.PersonMobilePhone,Payment_Status__c=ETI_TestUtilityClass.objServiceReq.Payment_Status__c,ETST_Active__c=true);
        insert objInvoice1;
        system.debug('Invoices>> '+objInvoice1);
        //ETI_TestUtilityClass.tesInvoice();
        ETI_TestUtilityClass.testBookings();
        ETI_TestUtilityClass.testVehicleService();
        ETI_TestUtilityClass.testBookingItems();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'standt', Email='standarduser1@sm.com', 
                            EmailEncodingKey='UTF-8', isActive = true, LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@sm.com');
        insert objUser1;
        EmailTemplate objTemplate = new EmailTemplate();
        System.runAs(objUser1){
            String Sbjct='{!ETI_Booking__c.Vehicle_Number__c}';
            string Bodyvar= '{!emailContent}';
            objTemplate = new EmailTemplate(developerName = 'Booking_Confirmation', Subject=Sbjct,HtmlValue=Bodyvar,Body = Bodyvar,FolderId = objUser1.Id, TemplateType= 'text', Name = 'test');
            insert objTemplate;
        }
        Test.startTest();
        ETI_ServiceRequestHandler.sendEmailNotification(new Set<Id> {ETI_TestUtilityClass.objServiceReq.Id});
        
        //B2C Receipt
        ET_Service_Request__c serviceReq1= new ET_Service_Request__c(Payment_Status__c = 'Not Initiated',RecordTypeId = recordTypeId,ET_Account__c = ETI_TestUtilityClass.objAccount.id,
                                                                    ETI_Payment_Type__c='Online');
        insert serviceReq1;
        Id bkngIntRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        ETI_Booking__c booking=new ETI_Booking__c(Customer_Vehicle__c = ETI_TestUtilityClass.objVehicle.id,Booking_Status__c = 'Booked',Service_Request__c = serviceReq1.id,
                                           Selected_Services__c = 'Test',Chassis_No__c = 'D032B5GC000790',Test_Result__c = 'Pass',recordTypeId=bkngIntRecordTypeId,
                                           User__c = ETI_TestUtilityClass.objAccount.id,Is_booking_Confirmed__c = true,Service_Type__c ='Police Inspection',Booking_Date__c= date.today()-2);
        insert booking;
        ETI_Service_Line_Item__c item=new ETI_Service_Line_Item__c(Service_Name__c = 'SLA',Test_Result__c = 'Pass',Booking__c = ETI_TestUtilityClass.bookingList[0].Id,
                                                                Service__c = ETI_TestUtilityClass.objVehService.Id,Description__c= 'test link result',Total_Fee__c=100);
        insert item;
        ETI_ServiceRequestHandler.sendEmailNotification(new Set<Id> {ETI_TestUtilityClass.objServiceReq.Id,serviceReq1.Id});
        
        //B2B EmailNotification
        id B2BRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
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
            ET_Service_Request__c serviceReq= new ET_Service_Request__c(Payment_Status__c = 'Not Initiated',RecordTypeId = recordTypeId,ET_Account__c = acc.id,
                                                                    ETI_Payment_Type__c='Online');
            insert serviceReq;
            Invoice__c objInvoice2 = new Invoice__c(recordTypeId=invRecordTypeId,fromDate__c=Date.today(),Service_Request__c=serviceReq.Id,
                                        Customer__c=serviceReq.ET_Account__c,Total_Inv_Amount__c=100,Payment_Status__c=serviceReq.Payment_Status__c,ETST_Active__c=true);
            insert objInvoice2;
            system.debug('Invoices>> '+objInvoice2);
            ETI_ServiceRequestHandler.sendEmailNotification(new Set<Id> {serviceReq.Id});
            
            //B2B Receipt
            ET_Customer_Vehicle__c objVehicle = new ET_Customer_Vehicle__c(OwnerId = user.Id,Chassis_No__c = 'D032B5GC000790',Plate_No__c = '53215',
                                                status__c = 'Active',Registration_Type__c ='Registered');
            insert objVehicle;
            ET_Service_Request__c serviceReq2= new ET_Service_Request__c(Payment_Status__c = 'Not Initiated',RecordTypeId = recordTypeId,ET_Account__c = acc.id,
                                                                        ETI_Payment_Type__c='Online');
            insert serviceReq2;
            ETI_Booking__c booking1=new ETI_Booking__c(Customer_Vehicle__c = objVehicle.id,Booking_Status__c = 'Booked',Service_Request__c = serviceReq2.id,
                                               Selected_Services__c = 'Test',Chassis_No__c = 'D032B5GC000790',Test_Result__c = 'Pass',recordTypeId=bkngIntRecordTypeId,
                                               User__c = acc.id,Is_booking_Confirmed__c = true,Service_Type__c ='Police Inspection',Booking_Date__c= date.today()-2);
            insert booking1;
            ETI_Service_Line_Item__c item1=new ETI_Service_Line_Item__c(Service_Name__c = 'SLA',Test_Result__c = 'Pass',Booking__c = booking1.Id,
                                                                    Service__c = ETI_TestUtilityClass.objVehService.Id,Description__c= 'test link result',Total_Fee__c=100);
            insert item1;
            ETI_ServiceRequestHandler.sendEmailNotification(new Set<Id> {serviceReq.Id,serviceReq2.Id});

        }
        Test.stopTest();
       
    }
    
    
}