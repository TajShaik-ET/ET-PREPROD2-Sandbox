@isTest
public class ETI_VehicleControllerTest {
    
    @testsetup
    public static void setupdata(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        acc.PersonMobilePhone='+971555555555';
        insert acc;
        /*  user us = [select accountid from user where id =:userinfo.getUserId()];
            us.accountid = acc.id;
            update us;*/
        Contact con = new Contact();
        con.LastName = 'Noor';
        con.Email = 'deepak_thomas@et.ae';
        insert con;
        List<ETI_Aman_Lookup__c> etiAmanList = new List<ETI_Aman_Lookup__c>();
        ETI_Aman_Lookup__c etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'PRIVATE';
        etiAman.ETI_LookupType__c = 'PLATE_TYPE';
        etiAman.ETI_LookupCode__c = '01';
        etiAman.isActive__c=true;
        etiAman.ETI_ArabicName__c='test';
        etiAmanList.add(etiAman);
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'ABU DHABI';
        etiAman.ETI_LookupType__c = 'PLATE_SOURCE';
        etiAman.ETI_LookupCode__c = '01';
        etiAman.isActive__c=true;
        etiAman.ETI_ArabicName__c='test';
        etiAmanList.add(etiAman);
        
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'SEVENTEENTH CATEGORY';
        etiAman.ETI_LookupType__c = 'PLATE_COLOR';
        etiAman.ETI_LookupCode__c = '52';
        etiAman.isActive__c=true;
        etiAman.ETI_ArabicName__c='test';
        etiAmanList.add(etiAman);
        
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'Test';
        etiAman.ETI_LookupType__c = 'TEST_PURPOSE';
        etiAman.ETI_LookupCode__c = '01';
        etiAman.isActive__c=true;
        etiAman.ETI_ArabicName__c='test';
        etiAmanList.add(etiAman);
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'Registration';
        etiAman.ETI_LookupType__c = 'TEST_PURPOSE';
        etiAman.ETI_LookupCode__c = '01';
        etiAman.isActive__c=true;
        etiAman.ETI_ArabicName__c='test';
        etiAmanList.add(etiAman);
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'Black';
        etiAman.ETI_LookupType__c = 'VEHICLE_TYPE';
        etiAman.ETI_LookupCode__c = '01';
        etiAman.isActive__c=true;
        etiAman.ETI_ArabicName__c='test';
        etiAmanList.add(etiAman);
        
        insert etiAmanList;
        
        ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();
        etcv1.OwnerId = userinfo.getUserId();
        etcv1.Chassis_No__c = 'D032B5GC000790';
        etcv1.Plate_No__c = '';
        etcv1.status__c = 'Active';
        etcv1.Registration_Type__c ='Registered';
        List<ETI_Vehicle_Service__c> vehServiceList = new list<ETI_Vehicle_Service__c>();
        ETI_Vehicle_Service__c vehService = new ETI_Vehicle_Service__c();
        vehService.Service_Type__c='Certificate';
        vehService.Service_Premises__c='Visit ET Premises';
        vehService.Name = 'Test';
        vehService.Service_Code__c = '01';
        vehServiceList.add(vehService);
        vehService = new ETI_Vehicle_Service__c();
        vehService.Service_Type__c='Police Inspection';
        vehService.Service_Premises__c='Visit ET Premises';
        vehService.Name = 'Test';
        vehService.Service_Code__c = '01';
        vehServiceList.add(vehService);
        vehService = new ETI_Vehicle_Service__c();
        vehService.Service_Type__c='ADFCA';
        vehService.Service_Premises__c='Visit ET Premises';
        vehService.Name = 'Test';
        vehService.Service_Code__c = '01';
        vehServiceList.add(vehService);
        insert vehServiceList;
        
        // cutmvehList.add(etcv1);        
        insert etcv1; 
        
        Id recordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        ET_Service_Request__c etsr = new ET_Service_Request__c();
        
        etsr.Payment_Status__c = 'Not Initiated';
        etsr.RecordTypeId = recordTypeId2;
        etsr.ET_Account__c = acc.id;
        
        insert etsr;
        
        ETI_Booking__c etiBooking = new ETI_Booking__c();
        // etiBooking.Name = 'Test';
        etiBooking.Customer_Vehicle__c = etcv1.id;
        etiBooking.Booking_Status__c = 'Booked';
        etiBooking.Service_Request__c = etsr.id;
        etiBooking.Selected_Services__c = 'Test;Test';
        etiBooking.Chassis_No__c = 'D032B5GC000790';
        etiBooking.Purpose_Type__c = etiAmanList[4].id;
        insert etiBooking;
        ETI_Service_Line_Item__c etline = new ETI_Service_Line_Item__c();
        etline.Booking__c = etiBooking.id;
        etline.Service__c = vehServiceList[0].id;
        etline.Test_Result__c = 'Failed';
        insert etline;
        
    }
    private static testmethod void testmethodInspection(){
        Account acc=[Select Id,Name,PersonEmail,RecordTypeId,PersonMobilePhone From Account];
        List<ETI_Aman_Lookup__c> amanLookupList =[SELECT Id, Name,ETI_ArabicName__c, ETI_LookupCode__c,isActive__c FROM ETI_Aman_Lookup__c ];
        list<ET_Customer_Vehicle__c> cutmvehList = new list<ET_Customer_Vehicle__c>();
        ET_Customer_Vehicle__c etcv = new ET_Customer_Vehicle__c();
        etcv.Chassis_No__c = 'LSFD032B5GC000790';
        etcv.Plate_No__c = '';
        etcv.Registration_Type__c ='Registered';
        etcv.Status__c='Active';
        etcv.Account__c=acc.Id;
        cutmvehList.add(etcv);
        ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();
        etcv1.Plate_No__c = '32052';
        etcv1.Plate_Source__c='ABU DHABI';
        etcv1.Plate_Type__c='PRIVATE';
        etcv1.Plate_Color__c='SEVENTEENTH CATEGORY';
        etcv1.Registration_Type__c ='Registered';
        cutmvehList.add(etcv1);     
        ET_Customer_Vehicle__c etcv3 = new ET_Customer_Vehicle__c();
        etcv3.Chassis_No__c = 'LSFD032B5GC000790';
        etcv3.Plate_No__c = '';
        etcv3.Registration_Type__c ='Registered';
        etcv3.Status__c='Active';
        etcv3.Account__c=acc.Id;
        cutmvehList.add(etcv3);
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        etcv.Chassis_No__c = 'D032B125GC000790';
        etcv.Plate_No__c = '';
        ETI_VehicleController.saveVehicle(etcv);
        ETI_VehicleController.saveVehicle(etcv3);
        //No Service
        etcv.Chassis_No__c = 'D032B125G';
        etcv.Plate_No__c = '';
        ETI_VehicleController.saveVehicle(etcv);
        //Un-Registered
        ET_Customer_Vehicle__c etcv2 = new ET_Customer_Vehicle__c();
        etcv2.Registration_Type__c ='Un-Registered';
        etcv2.Chassis_No__c = 'D032B125G1111';
        etcv2.Plate_No__c = '';
        ETI_VehicleController.saveVehicle(etcv2);
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        ETI_VehicleController.saveVehicle(etcv1);
        etcv1.Chassis_No__c = 'ABC';
        ETI_VehicleController.saveVehicle(etcv1);
        //insert cutmvehList; 
        ETI_VehicleController.getCaseTypes(); 
        ETI_VehicleController.initializeWrapper();
        ETI_VehicleController.getAmanLookupDetails('en');
        //ETI_VehicleController.getLocationsForService();
        //ETI_VehicleController.CreateServiceRequest();
        ETI_VehicleController.fetchRescheduleCancelMetaData();
        ETI_VehicleController.getAccountDetails();
        ETI_VehicleController.getAccountId();
        //ETI_VehicleController.bkngWrapper;
        //ETI_VehicleController.CreateServiceRequest();
        ETI_VehicleController.getAllLocations();
        ETI_VehicleController.getAddressSet('test');
        
        ETI_VehicleController.getVehicleDetails(etcv.Id);
        ETI_VehicleController.updateVehicleDetails(etcv);
        ETI_VehicleController.getBookingData(cutmvehList);
        ETI_VehicleController.getRetestBookingData([SELECT id FROM ET_Customer_Vehicle__c WHERE status__c = 'Active'][0].id);
        // ETI_VehicleController.getBookingData(etcv);
        /*Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        insert acc;*/
        
        Id recordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        ET_Service_Request__c etsr = new ET_Service_Request__c();
        
        etsr.Payment_Status__c = 'Not Initiated';
        etsr.RecordTypeId = recordTypeId2;
        etsr.ET_Account__c = acc.id;
        insert etsr;
        
        ETI_Booking__c e = new ETI_Booking__c();
        e.Chassis_No__c = '324234324';
        e.Customer_Vehicle__c = etcv.Id;
        e.Booking_Status__c = 'Booked';
        e.Service_Request__c = etsr.id ;
        insert e;
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection_Services').getRecordTypeId();
        Case objCase = new Case();
        objCase.RecordTypeId = caseRecordTypeId;
        objCase.ETI_Customer_Vehicle__c = etcv1.id;
        objCase.Description = 'test';
        insert objCase; 
        ETI_VehicleController.saveCase(objCase);
        ETI_VehicleController.objDisplayServiceSettings();
        ETI_VehicleController.checkDuplicatevehicle(etcv1,0);
        ETI_VehicleController.checkDuplicatevehicle(etcv3,0);
        ETI_VehicleController.getVehicleServiceType();
        ETI_VehicleController.getPlateCombinations('PLATE_SOURCE',null,null);
        ETI_VehicleController.getPlateCombinations('PLATE_TYPE',null,null);
        ETI_VehicleController.getPlateCombinations('PLATE_COLOR',null,null);
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        //ETI_VehicleController.getLookupFromAman('PLATE_SOURCE','1');
        ETI_VehicleController.getAmanLookups('PLATE_SOURCE');
        ETI_VehicleController.getVehicles(userInfo.getUserId());
        //Update
        ETI_VehicleController.checkVehicleBookings(new List<Id>{etcv.Id});
        //Delete
        ETI_VehicleController.checkVehicleBookings(new List<Id>{etcv1.Id});
        /*Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc1 = new Account();
        acc1.FirstName = 'test1';
        acc1.LastName = 'test1';
        acc1.PersonEmail = 'test1@gmail.com';
        acc1.RecordTypeId = recordTypeId;
        acc1.PersonMobilePhone='+971555555555';
        insert acc1;
        etcv.Account__c=acc1.Id;
        update etcv;*/
        ETI_VehicleController.getBookingData(new list<ET_Customer_Vehicle__c>{etcv});
        ETI_VehicleController.mobileRegex('+971555555555');
        ETI_Reschedule_Cancel_Charges__mdt mdtRecord = [SELECT Type__c, Refund_Percentage__c,Refund_Amount__c, Max_Time_Limit__c FROM ETI_Reschedule_Cancel_Charges__mdt Where isActive__c=true order by Max_Time_Limit__c asc limit 1];
        ETI_VehicleController.getRescheduledBookingData(e.id,mdtRecord.Id);
        ETI_VehicleController.getPickListValues('ET_Customer_Vehicle__c','Registration_Type__c');
        ETI_VehicleController.getPickListValues1('ET_Customer_Vehicle__c','Registration_Type__c');
        ETI_VehicleController.getBookingWrapper(new list<ETI_Booking__c>{e},'Abu Dhabi','en');
        //ETI_VehicleController.getBookingData(e,null,null,null);
        list<ETI_UtilityWrapper.fileToBeUploaded> finalDocList =new list<ETI_UtilityWrapper.fileToBeUploaded>();
        ETI_UtilityWrapper.fileToBeUploaded fileToBeUploaded=new ETI_UtilityWrapper.fileToBeUploaded();
        fileToBeUploaded.fileName='test';
        finalDocList.add(fileToBeUploaded);
        ETI_VehicleController.removeUploadedFiles(JSON.serialize(finalDocList),'test');
        ETI_VehicleController.doPaymentStatusUpdate(etsr.Id);
        //ETI_VehicleController.getSelectedCertificateCenters();
        //ETI_VehicleController.getBookingDataForUpdate(e.id,34.4);
        ETI_VehicleController.getBookingDataFromBookingId(e.id);
        ETI_VehicleController.utilityMethod();
        ETI_VehicleController.utilityMethod1();
        Test.stopTest();  
    }

}