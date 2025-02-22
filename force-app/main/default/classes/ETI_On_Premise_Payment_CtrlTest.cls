@isTest
public class ETI_On_Premise_Payment_CtrlTest {
    
    private static testmethod void testOnlineB2C(){
        
        /*ET_Service_Request__c objServiceRequest = new ET_Service_Request__c();
        objServiceRequest.Payment_Status__c = 'Fully Paid';
        insert objServiceRequest;*/
        ETI_TestUtilityClass.testUserCreation();
        ETI_TestUtilityClass.testAccountCreation();
        ETI_TestUtilityClass.objAccount.Preferred_Language__c='English';
        update ETI_TestUtilityClass.objAccount;
        ETI_TestUtilityClass.testCustomerVehicle();
        ETI_TestUtilityClass.testLocationData();
        ETI_TestUtilityClass.testLaneDetails();
        ETI_TestUtilityClass.testVehicleService();
        ETI_TestUtilityClass.objVehService.Service_Code__c='19';
        update ETI_TestUtilityClass.objVehService;
        ETI_TestUtilityClass.testServiceRequest();
        ETI_TestUtilityClass.testBookings();
        ETI_TestUtilityClass.bookingList[0].Booking_Date__c=Date.Today();
        ETI_TestUtilityClass.bookingList[0].Service_Type__c = 'Certificate';
        ETI_TestUtilityClass.bookingList[0].Allocated_Lane__c=ETI_TestUtilityClass.objLaneDetails.Id;
        update ETI_TestUtilityClass.bookingList[0];
        ETI_TestUtilityClass.testBookingItems();
        ETI_TestUtilityClass.bookingItemList[0].Service__c=ETI_TestUtilityClass.objVehService.Id;
        ETI_TestUtilityClass.bookingItemList[0].New_Color__c='5';
        ETI_TestUtilityClass.bookingItemList[0].New_Color2__c='5';
        ETI_TestUtilityClass.bookingItemList[0].New_Color3__c='5';
        ETI_TestUtilityClass.bookingItemList[0].New_Color4__c='5';
        ETI_TestUtilityClass.bookingItemList[0].Remarks__c='test';
        update ETI_TestUtilityClass.bookingItemList[0];
        Test.startTest();
        ETI_On_Premise_Payment_Ctrl.getAmount(ETI_TestUtilityClass.objServiceReq.Id);
        ETI_On_Premise_Payment_Ctrl.updateServiceRequest(ETI_TestUtilityClass.objServiceReq.Id, '1001','Cash');
        ETI_On_Premise_Payment_Ctrl.getB2BRecordtypeId();
        ETI_On_Premise_Payment_Ctrl.sendData(null,ETI_TestUtilityClass.bookingItemList[0].id,null,null,'Cash', '');
        Test.stopTest();
    }
    private static testmethod void testOnlineB2B(){
        Id bkngIntRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        id B2BRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
        Id p1 = [select id from profile where name='OneET Business Partner Login User'].id;
        Account acc = new Account(name ='noor test1',RecordTypeId=B2BRecordtypeId,ETI_Emirates__c='Abu Dhabi',ETSALES_Email__c = 'testAcc1@gmail.com') ;
        insert acc; 
        Contact con = new Contact(LastName ='testCon',AccountId = acc.Id,email='test123@sm1.com',Preferred_Language__c='English');
        insert con;  
        User user = new User(alias = 'test123', email='test123@sm1.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p1, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='test123@sm1.com');
        insert user;
        ETI_TestUtilityClass.testUserCreation();
        ETI_TestUtilityClass.testCustomerVehicle();
        ETI_TestUtilityClass.objVehicle.Account__c=acc.Id;
        ETI_TestUtilityClass.objVehicle.Contact__c=con.Id;
        ETI_TestUtilityClass.objVehicle.Customer_Name__c='test';
        ETI_TestUtilityClass.objVehicle.Vehicle_Color_Code1__c='1';
        ETI_TestUtilityClass.objVehicle.Vehicle_Color_Code2__c='1';
        ETI_TestUtilityClass.objVehicle.Vehicle_Color_Code3__c='1';
        ETI_TestUtilityClass.objVehicle.Vehicle_Color_Code4__c='1';
        update ETI_TestUtilityClass.objVehicle;
        ETI_TestUtilityClass.testLocationData();
        ETI_TestUtilityClass.testLaneDetails();
        ETI_TestUtilityClass.testVehicleService();
        ETI_TestUtilityClass.objVehService.Service_Code__c='19';
        update ETI_TestUtilityClass.objVehService;
        ET_Service_Request__c serviceReq= new ET_Service_Request__c(Payment_Status__c = 'Payment Success',RecordTypeId = recordTypeId,ET_Account__c = acc.id,
                                                                    ETI_Payment_Type__c='Online');
        insert serviceReq;
        ETI_Booking__c booking=new ETI_Booking__c(Customer_Vehicle__c = ETI_TestUtilityClass.objVehicle.id,Booking_Status__c = 'Booked',Service_Request__c = serviceReq.id,
                                                  Selected_Services__c = 'Test',Chassis_No__c = 'D032B5GC000790',Test_Result__c = 'Pass',recordTypeId=bkngIntRecordTypeId,
                                                  User__c = acc.id,Is_booking_Confirmed__c = true,Service_Type__c = 'Certificate',Booking_Date__c= date.today(),
                                                  Allocated_Lane__c=ETI_TestUtilityClass.objLaneDetails.Id,Customer_Site_Address__c='test',Customer_Site_Geometry__c='test');
        insert booking;
        ETI_Service_Line_Item__c item1=new ETI_Service_Line_Item__c(Service_Name__c = 'SLA',Test_Result__c = 'Pass',Booking__c = booking.Id,
                                                                    Service__c = ETI_TestUtilityClass.objVehService.Id,Description__c= 'test link result',
                                                                    New_Color__c='5',New_Color2__c='5',New_Color3__c='5',New_Color4__c='5',Remarks__c='test',
                                                                    Fee_Amount__c=100,Tax_Amount__c=0,Total_Fee__c=100);
        insert item1;
        ETI_Inspection_Receipt__c objReceipt = new ETI_Inspection_Receipt__c(ET_Status__c = 'Active',Bookings__c= booking.Id,
                                                                             ETI_Amount__c=100);
        insert objReceipt;
        Test.startTest();
        ETI_On_Premise_Payment_Ctrl.getAmount(serviceReq.Id);
        ETI_On_Premise_Payment_Ctrl.updateServiceRequest(serviceReq.Id, '1002','Cash');
        ETI_On_Premise_Payment_Ctrl.getB2BRecordtypeId();
        Test.stopTest();
    }
    private static testmethod void testWalkinBooking(){
        Id bkngIntRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        id B2BRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
        Id p1 = [select id from profile where name='OneET Business Partner Login User'].id;
        Account acc = new Account(name ='noor test1',RecordTypeId=B2BRecordtypeId,ETI_Emirates__c='Abu Dhabi',ETSALES_Email__c = 'testAcc1@gmail.com') ;
        insert acc; 
        Contact con = new Contact(LastName ='testCon',AccountId = acc.Id,email='test123@sm1.com',Preferred_Language__c='English');
        insert con;  
        User user = new User(alias = 'test123', email='test123@sm1.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p1, country='United States',IsActive =true,
                ContactId = con.Id,
                timezonesidkey='America/Los_Angeles', username='test123@sm1.com');
        insert user;
        //system.runAs(user) {
            ETI_TestUtilityClass.testUserCreation();
            ETI_TestUtilityClass.testCustomerVehicle();
            ETI_TestUtilityClass.objVehicle.Account__c=acc.Id;
            ETI_TestUtilityClass.objVehicle.Contact__c=con.Id;
            ETI_TestUtilityClass.objVehicle.Customer_Name__c='test';
            ETI_TestUtilityClass.objVehicle.Kind_Code__c='2';
            ETI_TestUtilityClass.objVehicle.Plate_Type_Code__c='2';
            ETI_TestUtilityClass.objVehicle.Plate_Source_Code__c='2';
            ETI_TestUtilityClass.objVehicle.Plate_Color_Code__c='2';
            ETI_TestUtilityClass.objVehicle.Model_Code__c='2';
            ETI_TestUtilityClass.objVehicle.Trade_License_Number__c='2';
            ETI_TestUtilityClass.objVehicle.Permission_Issue_Place__c='Abu Dhabi';
            ETI_TestUtilityClass.objVehicle.Vehicle_Year__c='2018';
            ETI_TestUtilityClass.objVehicle.Engine_No__c='1111';
            update ETI_TestUtilityClass.objVehicle;
            ETI_TestUtilityClass.testLocationData();
            ETI_TestUtilityClass.testLaneDetails();
            ETI_TestUtilityClass.testVehicleService();
            ETI_TestUtilityClass.objVehService.Service_Code__c='19';
            update ETI_TestUtilityClass.objVehService;
            ET_Service_Request__c serviceReq= new ET_Service_Request__c(Payment_Status__c = 'Payment Success',RecordTypeId = recordTypeId,ET_Account__c = acc.id,
                                                                        ETI_Payment_Type__c='Online');
            insert serviceReq;
            ETI_Booking__c booking=new ETI_Booking__c(Customer_Vehicle__c = ETI_TestUtilityClass.objVehicle.id,Booking_Status__c = 'Booked',Service_Request__c = serviceReq.id,
                                                   Selected_Services__c = 'Test',Chassis_No__c = 'D032B5GC000790',Test_Result__c = 'Pass',recordTypeId=bkngIntRecordTypeId,
                                                   Is_booking_Confirmed__c = true,Service_Type__c = 'Certificate',Booking_Date__c= date.today(),KM_Reading__c='111',Mobile_No__c='971555555555',
                                                   Allocated_Lane__c=ETI_TestUtilityClass.objLaneDetails.Id,Customer_Site_Address__c='test',Customer_Site_Geometry__c='test');
            insert booking;
            ETI_Service_Line_Item__c item1=new ETI_Service_Line_Item__c(Service_Name__c = 'SLA',Test_Result__c = 'Pass',Booking__c = booking.Id,
                                                                        Service__c = ETI_TestUtilityClass.objVehService.Id,Description__c= 'test link result',
                                                                        New_Color__c='5',New_Color2__c='5',New_Color3__c='5',New_Color4__c='5',Remarks__c='test',
                                                                        Fee_Amount__c=100,Tax_Amount__c=0,Total_Fee__c=100);
            insert item1;
            Test.startTest();
            ETI_On_Premise_Payment_Ctrl.getAmount(serviceReq.Id);
            ETI_On_Premise_Payment_Ctrl.updateServiceRequest(serviceReq.Id, '1003','Cash');
            ETI_On_Premise_Payment_Ctrl.getB2BRecordtypeId();
            ETI_On_Premise_Payment_Ctrl.utilityMethod();

        //}
        Test.stopTest();
    }

  
}