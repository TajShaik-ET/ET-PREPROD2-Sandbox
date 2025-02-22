@isTest
public class ETI_CreateReceiptInAMANBatchTest {

    @isTest
    public static void TestCreateReceiptInAMANB2C(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.ETI_Person_B2C).getRecordTypeId();
        Account acc= new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        acc.ETSALES_Email__c = 'testAcc@gmail.com';
        acc.Preferred_Language__c='English';
        insert acc;
        Id recordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        ET_Service_Request__c servicerequest = new ET_Service_Request__c();
        servicerequest.Payment_Status__c = 'Payment Success';
        servicerequest.RecordTypeId = recordTypeId2;
        servicerequest.ET_Account__c = acc.id;
        insert servicerequest;
        ID intRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
        ID extReordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByName().get('External').getRecordTypeId();
        ET_Customer_Vehicle__c custveh=new ET_Customer_Vehicle__c();
        custveh.Account__c=acc.ID;
        custveh.Preferred_Language__c='English';
        custveh.Vehicle_Color_Code1__c='1';
        custveh.Vehicle_Color_Code2__c='1';
        custveh.Vehicle_Color_Code3__c='1';
        custveh.Vehicle_Color_Code4__c='1';
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
        Ebook.Booking_Date__c=system.today();
        Ebook.Service_Request__c=servicerequest.Id;
        Ebook.Allocated_Lane__c=ETI_TestUtilityClass.objLaneDetails.Id;
        
        insert Ebook;
        ETI_Vehicle_Service__c evc= new ETI_Vehicle_Service__c();
        evc.Name='service1';
        evc.Service_Code__c='19';
        evc.Service_Premises__c='customer premises';
        insert evc;
        
        List<ETI_Service_Line_Item__c>  serlist = new List<ETI_Service_Line_Item__c>();
        ETI_Service_Line_Item__c Eserviceline=new ETI_Service_Line_Item__c();
        Eserviceline.Total_Fee__c=105;
        Eserviceline.Tax_Amount__c=5;
        Eserviceline.Fee_Amount__c=100;
        Eserviceline.New_Color__c='Red';
        Eserviceline.New_Color2__c='yellow';
        Eserviceline.New_Color3__c='blue';
        Eserviceline.New_Color4__c='green';
        Eserviceline.Service__c=evc.Id;
        Eserviceline.Booking__c=Ebook.Id;
        Eserviceline.Remarks__c='test';
        insert Eserviceline;
        Id PaymentRecordTypeId = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Card_Payment').getRecordTypeId();
        ETST_Payment__c objPayment = new ETST_Payment__c(recordTypeId=PaymentRecordTypeId,ETST_Payment_State__c='Payment Success',ETST_Capture_State__c='SUCCESS',ET_Service_Request__c=servicerequest.Id,ETST_Amount__c=100);
        insert objPayment;
               
        test.startTest();
        ETI_CreateReceiptInAMANBatch.testcodeCoverage();
        ETI_CreateReceiptInAMANBatch etbb=new ETI_CreateReceiptInAMANBatch(Date.today(),null);
        Database.executeBatch(etbb,1);
        String sch ='0 48 * * * ?'; 
        System.schedule('Schedule CreateReceiptInAMANBatch', sch,etbb);
        test.stopTest();
    }
    private static testmethod void TestCreateReceiptInAMANB2B(){
        Id bkngIntRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        id B2BRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
        Id p1 = [select id from profile where name='OneET Business Partner Login User'].id;
        Account acc = new Account(name ='noor test1',RecordTypeId=B2BRecordtypeId,ETI_Emirates__c='Abu Dhabi',ETSALES_Email__c = 'testAcc1@gmail.com',ETSALES_TaxRegistrationNo__c = '123456789012345') ;
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
        test.startTest();
        ETI_CreateReceiptInAMANBatch etbb=new ETI_CreateReceiptInAMANBatch(Date.today(),null);
        Database.executeBatch(etbb,1);
        String sch ='0 48 * * * ?'; 
        System.schedule('Schedule CreateReceiptInAMANBatch', sch,etbb);
        test.stopTest();
    }
}