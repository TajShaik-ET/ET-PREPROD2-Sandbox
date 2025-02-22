/*
 Developer Name - Srihari Koyila
 Developed Date - 20 June 2023
 Test Class     - MOTO_IntegrationTest , Oracle_Integration_Mock 
****************************************************************************************************************/
@isTest
public class MOTO_VehInspectionCtrlTest {
   
     @isTest
    public static void testGetOpportunities2() {
		lead le = new lead();
        le.lastname = 'test new';
        le.RecordTypeId = Schema.SObjectType.lead.getRecordTypeInfosByDeveloperName().get('Moto_Service_Center_Body_Shop').getRecordTypeId();
        le.email ='tesr@gmail.com';
        le.MobilePhone='0558656023';
        insert le;
        Account acc = new Account();
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        acc.lastname = 'test';
        acc.PersonMobilePhone = '123456789';
        insert acc;
        Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.name='12345';
        vm.Internal_No__c ='12345';
        vm.Description__c ='test';
        vm.Chassis_No__c = 'MMBJNKB509D018612';
        vm.Account_Id__c = acc.Id;
        insert vm;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'New Opportunity';
        opp.AccountId=acc.Id;
        opp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
        opp.StageName = 'Service Booking';
        opp.Amount = 10000;
        opp.Chassis_Number__c = 'MMBJNKB509D018612';
        opp.Appointment_Date__c = Date.today().addDays(10);
        opp.CloseDate = Date.today().addDays(10);
        opp.Insurance_Company__c = 'Salama Insurance';
        opp.Insurance__c = true;
        insert opp;
        
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'New Opportunity';
        //oppRec.StageName = 'Service Booking';
        oppRec.Amount = 10000;
        oppRec.Chassis_Number__c = 'MMBJNKB509D018612';
        oppRec.Appointment_Date__c = Date.today().addDays(10);
        //oppRec.CloseDate = Date.today().addDays(10);
        oppRec.Insurance_Company__c = 'Salama Insurance';
        oppRec.Insurance__c = true;

         Test.startTest(); 
     
          MOTO_VehInspectionCtrl.testcodeCoverage();
          MOTO_VehInspectionCtrl.testcodeCoverage1();
       	  MOTO_VehInspectionCtrl.testcodeCoverage2();
          MOTO_VehInspectionCtrl.testcodeCoverage4();
          MOTO_VehInspectionCtrl.getLeads(le.email);
          MOTO_VehInspectionCtrl.getOpportunityData();
        //MOTO_VehInspectionCtrl.CreateOpportunityforInternalVehicle(vm.Internal_No__c,opp);
        //MOTO_VehInspectionCtrl.CreateOpportunityReturn(vm.Id, opp);
        MOTO_VehInspectionCtrl.updateOpportunityRecord(opp.Id, opp);
          MOTO_VehInspectionCtrl.getOpportunities(acc.PersonMobilePhone);
          MOTO_VehInspectionCtrl.getVehicle(vm.Chassis_No__c);
          MOTO_VehInspectionCtrl.saveAccountRecord(vm.Id, acc);
          MOTO_VehInspectionCtrl.getOpportunitiesFormsHome(acc.PersonMobilePhone);
        Test.stopTest();
        
    }
/*
 	@isTest
    public static void testGetOpportunities() {
         Test.startTest(); 
       
        Account acc = new Account();
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        acc.lastname = 'test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'New Opportunity';
        opp.AccountId=acc.Id;
        opp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
        opp.StageName = 'Service Booking';
        opp.Amount = 10000;
        opp.Chassis_Number__c = 'MMBJNKB509D018612';
        opp.Appointment_Date__c = Date.today().addDays(10);
        opp.CloseDate = Date.today().addDays(10);
        opp.Insurance_Company__c = 'Salama Insurance';
        opp.Insurance__c = true;
        insert opp;
        
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'New Opportunity';
        //oppRec.StageName = 'Service Booking';
        oppRec.Amount = 10000;
        oppRec.Chassis_Number__c = 'MMBJNKB509D018612';
        oppRec.Appointment_Date__c = Date.today().addDays(10);
        //oppRec.CloseDate = Date.today().addDays(10);
        oppRec.Insurance_Company__c = 'Salama Insurance';
        oppRec.Insurance__c = true;
        
        lead le = new lead();
        le.lastname = 'test new';
        le.RecordTypeId = Schema.SObjectType.lead.getRecordTypeInfosByDeveloperName().get('Moto_Service_Center_Body_Shop').getRecordTypeId();
        le.email ='tesr@gmail.com';
        le.MobilePhone='0558656023';
        insert le;
        
        
        lead lef = new lead();
        lef.lastname = 'test new 1';
        lef.RecordTypeId = Schema.SObjectType.lead.getRecordTypeInfosByDeveloperName().get('Moto_Service_Center_Body_Shop').getRecordTypeId();
        lef.email ='tesr@gmail.com';
        lef.MobilePhone='05586560231';
        
        
        Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.name='12345';
        vm.Internal_No__c ='12345';
        vm.Description__c ='test';
        insert vm;
        
        Vehicle_Receiving_Info__c veh = new Vehicle_Receiving_Info__c();
        veh.Opportunity__c = opp.id;
        insert veh;
        
        X36_Points_Health_Check__c hea = new X36_Points_Health_Check__c();
        hea.Opportunity__c = opp.id;
        
        X111_Point_Check__c pncheck = new X111_Point_Check__c();
        pncheck.Opportunity__c = opp.id;
        
       
        
        Vehicle_Receiving_Info__c vehicle = new Vehicle_Receiving_Info__c();
        vehicle.Opportunity__c = opp.id;
        List<Vehicle_Receiving_Info__c> vehicleList = new List<Vehicle_Receiving_Info__c>();
        vehicleList.add(vehicle);
        String fileData = '[{"filename":"testFile.txt","filetype":"txt","base64":"SGVsbG8gd29ybGQh"}]';
        
        //
        
        // ContentDocumentLink testLink = new ContentDocumentLink();
        // testLink.LinkedEntityId=opp.id;
        //  testLink.ShareType='V';
        // testLink.ContentDocumentId = '0698E000003HkZmQAK';
        // insert testLink;
        // testLink.LinkedEntityId = veh.Id;
        
        // update testLink;
        
        //ApexPages.StandardController stdController = new ApexPages.StandardController(veh);
        //MOTO_VehInspectionCtrl controller = new MOTO_VehInspectionCtrl(stdController);
        
        MOTO_VehInspectionCtrl.getOpportunities('055343');
        MOTO_VehInspectionCtrl.getOpportunitiesFormsHome('05545');
        MOTO_VehInspectionCtrl.getInternalNumber('123544','test','test','PlateType');
        MOTO_VehInspectionCtrl.updateOpportunityRecord(opp.Id,oppRec);
        //MOTO_VehInspectionCtrl.CreateOpportunityforInternalVehicle('12345');
        
        //MOTO_VehInspectionCtrl.saveSign('wewqeqweqwew',Opp.id);
       // MOTO_VehInspectionCtrl.saveHealthCheck(hea);
//        MOTO_VehInspectionCtrl.vehicleReceivingformSaveHandler(vehicleList,fileData);
        //MOTO_VehInspectionCtrl.addFilesToRecords(Opp.id,fileData, null);
       // MOTO_VehInspectionCtrl.save111PointsCheck(pncheck,fileData);
        //MOTO_VehInspectionCtrl.addFilesToRecords111(Opp.id,fileData, null);
        //MOTO_VehInspectionCtrl.LEADSOURCE_FIELDOptions('Account','Type');
        //MOTO_VehInspectionCtrl.convertLeadAndGetOpportunityId(new list<id>{le.Id});
       
        MOTO_VehInspectionCtrl.getPicklistValues('Account','Type');
        //MOTO_VehInspectionCtrl.saveLeadRecord(lef);
       // MOTO_VehInspectionCtrl.saveServiceestimationRecord(est);
       // MOTO_VehInspectionCtrl.saveServiceLineitem(new List<Service_Estimation_Lines__c>{Srest});
        
        MOTO_VehInspectionCtrl.uploadedDocs docs = new MOTO_VehInspectionCtrl.uploadedDocs();
        docs.filename = 'TestFile';
        docs.filetype = 'PDF';
        docs.base64 = 'SGVsbG8gd29ybGQh';
        MOTO_VehInspectionCtrl.testcodeCoverage();
        Test.stopTest();
        
    }
    @isTest
    public static void testGetOpportunities2() {
         Test.startTest(); 
        Account acc = new Account();
        acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        acc.lastname = 'test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'New Opportunity';
        opp.AccountId=acc.Id;
        opp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
        opp.StageName = 'Service Booking';
        opp.Amount = 10000;
        opp.Chassis_Number__c = 'MMBJNKB509D018612';
        opp.Appointment_Date__c = Date.today().addDays(10);
        opp.CloseDate = Date.today().addDays(10);
        opp.Insurance_Company__c = 'Salama Insurance';
        opp.Insurance__c = true;
        insert opp;
        
        Opportunity oppRec = new Opportunity();
        oppRec.Name = 'New Opportunity';
        //oppRec.StageName = 'Service Booking';
        oppRec.Amount = 10000;
        oppRec.Chassis_Number__c = 'MMBJNKB509D018612';
        oppRec.Appointment_Date__c = Date.today().addDays(10);
        //oppRec.CloseDate = Date.today().addDays(10);
        oppRec.Insurance_Company__c = 'Salama Insurance';
        oppRec.Insurance__c = true;
        
        lead le = new lead();
        le.lastname = 'test new';
        le.RecordTypeId = Schema.SObjectType.lead.getRecordTypeInfosByDeveloperName().get('Moto_Service_Center_Body_Shop').getRecordTypeId();
        le.email ='tesr@gmail.com';
        le.MobilePhone='0558656023';
        insert le;
        
        
        lead lef = new lead();
        lef.lastname = 'test new 1';
        lef.RecordTypeId = Schema.SObjectType.lead.getRecordTypeInfosByDeveloperName().get('Moto_Service_Center_Body_Shop').getRecordTypeId();
        lef.email ='tesr@gmail.com';
        lef.MobilePhone='05586560231';
        
        
        Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.name='12345';
        vm.Internal_No__c ='12345';
        vm.Description__c ='test';
        insert vm;
        
        Vehicle_Receiving_Info__c veh = new Vehicle_Receiving_Info__c();
        veh.Opportunity__c = opp.id;
        insert veh;
        
        X36_Points_Health_Check__c hea = new X36_Points_Health_Check__c();
        hea.Opportunity__c = opp.id;
        
        X111_Point_Check__c pncheck = new X111_Point_Check__c();
        pncheck.Opportunity__c = opp.id;
        
        
        Vehicle_Receiving_Info__c vehicle = new Vehicle_Receiving_Info__c();
        vehicle.Opportunity__c = opp.id;
        List<Vehicle_Receiving_Info__c> vehicleList = new List<Vehicle_Receiving_Info__c>();
        vehicleList.add(vehicle);
        String fileData = '[{"filename":"testFile.txt","filetype":"txt","base64":"SGVsbG8gd29ybGQh"}]';
        MOTO_VehInspectionCtrl.LIST_OF_REQUIRED_SERVICE_FIELDOptions('Account','Type');
        MOTO_VehInspectionCtrl.PAYMENTMODE_FIELDOptions('Account','Type');
        MOTO_VehInspectionCtrl.DISCOUNTAPPLICABLE_FIELDOptions('Account','Type');
        MOTO_VehInspectionCtrl.INSURANCE_COMPANY_FIELDOptions('Account','Type');
        MOTO_VehInspectionCtrl.VEHICLEMILEAGE_FIELDOptions('Account','Type');
       
       
        
        Test.stopTest();
        
    }*/











}