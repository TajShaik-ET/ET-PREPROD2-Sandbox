@isTest
public class ETI_B2B_VehicleControllerTest {
    
    @testsetup
    public static void setupdata(){
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        insert acc;
        /*  user us = [select accountid from user where id =:userinfo.getUserId()];
            us.accountid = acc.id;
            update us;*/
        Contact con = new Contact();
        con.LastName = 'Noor';
        con.Email = Label.ETI_TargetObject_Email;
        insert con;
        List<ETI_Aman_Lookup__c> etiAmanList = new List<ETI_Aman_Lookup__c>();
        ETI_Aman_Lookup__c etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'Test';
        etiAman.ETI_LookupType__c = 'PLATE_TYPE';
        etiAman.ETI_LookupCode__c = '01';
        etiAmanList.add(etiAman);
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'Test';
        etiAman.ETI_LookupType__c = 'PLATE_SOURCE';
        etiAman.ETI_LookupCode__c = '01';
        etiAmanList.add(etiAman);
        
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'Black';
        etiAman.ETI_LookupType__c = 'PLATE_COLOR';
        etiAman.ETI_LookupCode__c = '01';
        etiAmanList.add(etiAman);
        
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'Test';
        etiAman.ETI_LookupType__c = 'TEST_PURPOSE';
        etiAman.ETI_LookupCode__c = '01';
        etiAmanList.add(etiAman);
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'Registration';
        etiAman.ETI_LookupType__c = 'TEST_PURPOSE';
        etiAman.ETI_LookupCode__c = '01';
        etiAmanList.add(etiAman);
        etiAman = new ETI_Aman_Lookup__c();
        etiAman.Name = 'Black';
        etiAman.ETI_LookupType__c = 'VEHICLE_TYPE';
        etiAman.ETI_LookupCode__c = '01';
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
        
        
        /*  Service__c  serv = new Service__c();
            serv.Name = 'Test';
            serv.*/
    }
    private static testmethod void testmethodInspection(){
        
        list<ET_Customer_Vehicle__c> cutmvehList = new list<ET_Customer_Vehicle__c>();
        
        ET_Customer_Vehicle__c etcv = new ET_Customer_Vehicle__c();
        
        etcv.Chassis_No__c = 'LSFD032B5GC000790';
        etcv.Plate_No__c = '65517';
        etcv.Registration_Type__c ='Registered';
        
        cutmvehList.add(etcv);
        
        
        ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();
        
        etcv1.Chassis_No__c = 'D032B5GC000790';
        etcv1.Plate_No__c = '';
        etcv1.Registration_Type__c ='Registered';
        
        // cutmvehList.add(etcv1);        
        insert cutmvehList; 
        
        Test.startTest();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // etcv1.Chassis_No__c = 'D032B125GC000790';
        ETI_B2B_VehicleController.saveVehicle(etcv1);
        ETI_B2B_VehicleController.getCaseTypes();
        ETI_B2B_VehicleController.saveCase(null);
        ETI_B2B_VehicleController.objDisplayServiceSettings();
      
         //getPickListValues1
        ETI_B2B_VehicleController.getPickListValuesIntoListMNVRBrand();
        //updateSpeaBookingDetails
        ETI_B2B_VehicleController.getAmanLookupDetails('en');
        //ETI_B2B_VehicleController.getLocationsForService();
        //ETI_B2B_VehicleController.CreateServiceRequest();
        ETI_B2B_VehicleController.fetchRescheduleCancelMetaData();
        ETI_B2B_VehicleController.getAccountDetails();
        ETI_B2B_VehicleController.getAccountId();
        //ETI_B2B_VehicleController.bkngWrapper;
        ETI_B2B_VehicleController.getAddressSet('test');
        
        ETI_B2B_VehicleController.getVehicleDetails(etcv.Id);
        ETI_B2B_VehicleController.updateVehicleDetails(etcv);
        //ETI_B2B_VehicleController.getBookingData(cutmvehList);
        ETI_B2B_VehicleController.getRetestBookingData([SELECT id FROM ET_Customer_Vehicle__c WHERE status__c = 'Active'][0].id);
        // ETI_B2B_VehicleController.getBookingData(etcv);
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        
        insert acc;
        
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
        
        //ETI_B2B_VehicleController.getBookingDataForUpdate(e.id,34.4);
        ETI_B2B_VehicleController.getBookingDataFromBookingId(e.id);
        Test.stopTest();  
    }
    /*@isTest
public static void testcase1(){

ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();

etcv1.Chassis_No__c = '12345';
etcv1.Plate_No__c = '12345';
etcv1.Registration_Type__c ='Registered';
etcv1.Plate_Source__c = 'Test';
etcv1.Plate_Type__c = 'Test';
etcv1.Plate_Color__c = 'Black';
Test.startTest();
System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
ETI_B2B_VehicleController.saveVehicle(etcv1);
Test.stopTest();
}
@isTest
public static void testcase2(){

ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();

etcv1.Chassis_No__c = '';
etcv1.Plate_No__c = '12345';
etcv1.Registration_Type__c ='Registered';
etcv1.Plate_Source__c = 'Test';
etcv1.Plate_Type__c = 'Test';
etcv1.Plate_Color__c = 'Black';

Test.startTest();
System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
ETI_B2B_VehicleController.saveVehicle(etcv1);
Test.stopTest();
}*/
    @isTest
    public static void testcase3(){
        
        ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();
        
        etcv1.Chassis_No__c = '';
        etcv1.Plate_No__c = '12345';
        etcv1.Registration_Type__c ='Registered';
        etcv1.Plate_Source__c = 'Test';
        etcv1.Plate_Type__c = 'Test';
        etcv1.Plate_Color__c = 'Black';
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
          ETI_B2B_VehicleController.checkDuplicatevehicle1(etcv1,1);
        ETI_B2B_VehicleController.checkDuplicatevehicle(etcv1,1);
        
        //ETI_B2B_VehicleController.getVehicleInfoFromAbuDhabi(etcv1,'Chassis No'); //31/10/20
        Test.stopTest();
    }
    @isTest
    public static void testcase4(){
        
        ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();
        
        etcv1.Chassis_No__c = '12345';
        etcv1.Plate_No__c = '12345';
        etcv1.Registration_Type__c ='Registered';
        etcv1.Plate_Source__c = 'Test';
        etcv1.Plate_Type__c = 'Test';
        etcv1.Plate_Color__c = 'Black';
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        ETI_B2B_VehicleController.getVehicleInfoFromAbuDhabi(etcv1,'Chassis No');
        ETI_B2B_VehicleController.getLookupFromAman('TEST', '01');
        Test.stopTest();
    }
    @isTest
    public static void testcase5(){
        
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        id customerID = [SELECT id FROM ET_Customer_Vehicle__c LIMIT 1][0].id;
        Test.startTest();
        ETI_B2B_VehicleController.getVehicles(UserInfo.getUserId(),'Abu Dhabi');
        ETI_B2B_VehicleController.checkVehicleBookings(new List<id>{customerID});
        ETI_B2B_VehicleController.deleteVehicles(new List<id>{customerID});
        ETI_B2B_VehicleController.getPickListValues('ET_Customer_Vehicle__c', 'status__c');
        Test.stopTest();
    }
    @isTest
    public static void testcase6(){
        Test.startTest();
        ETI_B2B_VehicleController.getBookingWrapper([SELECT Purpose_Type__c, Customer_Vehicle__c FROM ETI_Booking__c], 'Sharjah','en');
        ETI_B2B_VehicleController.getCertificateServices('ET_Customer_Vehicle__c', 'status__c', 'Visit ET Premises');
        ETI_B2B_VehicleController.getCertificateServices('ET_Customer_Vehicle__c', 'status__c', 'Active');
       // ETI_B2B_VehicleController.getCertificates('Visit ET Premises',new Map<string,list<string>>());
       // ETI_B2B_VehicleController.getServices('Police Inspection','Visit ET Premises', false);
       // ETI_B2B_VehicleController.getServices('Police Inspection','Visit ET Premises', true);
        ETI_B2B_VehicleController.getTestPurposeTypes('en');
        ETI_B2B_VehicleController.getVehicleTypes('en');
        Test.stopTest();
    }
    @isTest
    public static void testcase7(){
        String str = '[{"vehicleId":"","fileName":"test File","docName":"","contentType":"","base64Data":""}]';
        Test.startTest();
        ETI_B2B_VehicleController.removeUploadedFiles(str, 'test');
        Test.stopTest();
    }
    @isTest
    public static void testcase8(){
        String str = '[{"vehicleTypeCode":null,"uploadedFile":null,"slotList":null,"serviceTypes":null,"servicesMap":null,"serviceCode":null,"rowIndex":null,"requestId":null,"newVehicleType":null,"newColor":null,"locations":null,"locationMap":null,"isVehicleTypeChange":null,"isValidated":null,"isSelectedRecord":true,"isRemoveDisabled":null,"isFeeDetailsExist":null,"isEnabled":null,"isColorChange":null,"isChildValidated":null,"isAdfcaVehicle":null,"isAddDisabled":null,"errorMessage":null,"enableAvailableSlots":null,"childErrorMessage":null,"certificates":null,"AddressList":null}]';
        Test.startTest();
        //ETI_B2B_VehicleController.getAvailableSlots(str);
        ETI_B2B_VehicleController.getBookedSlots(System.today(), 'Test Branch', 'Test');
        ETI_B2B_VehicleController.getRequiredDocumentsForUnregistered();
        Test.stopTest();
    }
   /* @isTest
    public static void testcase9(){
        String str = '[{"booking":{"attributes":{"type":"ETI_Booking__c"},"Service_Type__c":"Certificate", "Selected_Services__c":"A;B"},"vehicleTypeCode":null,"uploadedFile":null,"slotList":null,"serviceTypes":null,"servicesMap":null,"serviceCode":null,"rowIndex":null,"requestId":null,"newVehicleType":null,"newColor":null,"locations":null,"locationMap":null,"isVehicleTypeChange":null,"isValidated":null,"isSelectedRecord":true,"isRemoveDisabled":null,"isFeeDetailsExist":null,"isEnabled":null,"isColorChange":null,"isChildValidated":null,"isAdfcaVehicle":null,"isAddDisabled":null,"errorMessage":null,"enableAvailableSlots":null,"childErrorMessage":null,"certificates":null,"AddressList":null}]';
        Test.startTest();
        ETI_B2B_VehicleController.getRequiredDocuments(str);
        Test.stopTest();
    }*/
    @isTest
    public static void testcase10(){ 
        
        String str = '[{"booking":{"attributes":{"type":"ETI_Booking__c"},"Service_Type__c":"Police Inspection", "Selected_Services__c":"A;B"},"vehicleTypeCode":null,"uploadedFile":null,"slotList":null,"serviceTypes":null,"servicesMap":null,"serviceCode":null,"rowIndex":null,"requestId":null,"newVehicleType":null,"newColor":null,"locations":null,"locationMap":null,"isVehicleTypeChange":null,"isValidated":null,"isSelectedRecord":true,"vehicleTypeCode":"01","isRemoveDisabled":null,"isFeeDetailsExist":null,"isEnabled":null,"isColorChange":null,"isChildValidated":null,"isAdfcaVehicle":null,"isAddDisabled":null,"errorMessage":null,"enableAvailableSlots":null,"childErrorMessage":null,"certificates":null,"AddressList":null}]';
        Test.startTest();
        ETI_B2B_VehicleController.getAvailableCenters('AbuDhabi','en');
        Test.stopTest();
    }
   /* @isTest
    public static void testcase12(){ 
        id serviceid = [select id from ET_Service_Request__c limit 1][0].id;
        id ids = [SELECT id FROM ET_Customer_Vehicle__c LIMIT 1][0].id;
        ETI_Booking__c et =  [SELECT id, Service_Type__c, Customer_Vehicle__c FROM ETI_Booking__c LIMIT 1];
        String  etbook = JSON.serialize(et);
        String str = '[{"booking":{"attributes":{"type":"ETI_Booking__c"},"Service_Type__c":"Certificate","Id":"'+ et.id+'","Selected_Services__c":"A;B","Customer_Vehicle__c":"' + ids+'"},"vehicleTypeCode":null,"uploadedFile":[{"vehicleId":"' +ids + '","fileName":"test File","docName":"","contentType":"","base64Data":"Test"}],"slotList":null,"serviceTypes":null,"servicesMap":null,"serviceCode":null,"rowIndex":null,"requestId":"'+ serviceid + '","newVehicleType":"Test","newColor":"red","locations":null,"locationMap":null,"isVehicleTypeChange":true,"isValidated":null,"isSelectedRecord":true,"isRemoveDisabled":null,"isFeeDetailsExist":null,"isEnabled":null,"isColorChange":true,"isChildValidated":null,"isAdfcaVehicle":null,"isAddDisabled":null,"errorMessage":null,"enableAvailableSlots":null,"childErrorMessage":null,"certificates":null,"AddressList":null}]';
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(str, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail> mapval = new Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail>();
        ETI_B2B_UtilityWrapper.InspectionFeeDetail etiIns = new ETI_B2B_UtilityWrapper.InspectionFeeDetail('S','',21, 21, 21);
        mapval.put('D032B5GC000790-01', etiIns);
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        ETI_B2B_VehicleController.getAvailableCenters(str, 'Visit ET Premises', 'AbuDhabi');
        //ETI_B2B_VehicleController.createDraftBookings(str);
        // ETI_B2B_VehicleController.saveBooking(str,'Visit ET Premises');
        ETI_B2B_VehicleController.createsServiceItems(bookingWrp, [SELECT id,Service_Type__c,Service_Request__c, Customer_Vehicle__c, Chassis_No__c, Selected_Services__c FROM ETI_Booking__c limit 1], mapval);
        Test.stopTest();
    }*/
    @isTest
    public static void testcase13(){ 
        id serviceid = [select id from ET_Service_Request__c limit 1][0].id;
        id ids = [SELECT id FROM ET_Customer_Vehicle__c LIMIT 1][0].id;
        ETI_Booking__c et =  [SELECT id, Service_Type__c, Customer_Vehicle__c FROM ETI_Booking__c LIMIT 1];
        String  etbook = JSON.serialize(et);
        String str = '[{"booking":{"attributes":{"type":"ETI_Booking__c"},"Service_Type__c":"Certificate","Id":"'+ et.id+'","Selected_Services__c":"A;B","Customer_Vehicle__c":"' + ids+'"},"vehicleTypeCode":null,"uploadedFile":[{"vehicleId":"' +ids + '","fileName":"test File","docName":"","contentType":"","base64Data":"Test"}],"slotList":null,"serviceTypes":null,"servicesMap":null,"serviceCode":null,"rowIndex":null,"requestId":"'+ serviceid + '","newVehicleType":"Test","newColor":"red","locations":null,"locationMap":null,"isVehicleTypeChange":true,"isValidated":null,"isSelectedRecord":true,"isRemoveDisabled":null,"isFeeDetailsExist":null,"isEnabled":null,"isColorChange":true,"isChildValidated":null,"isAdfcaVehicle":null,"isAddDisabled":null,"errorMessage":null,"enableAvailableSlots":null,"childErrorMessage":null,"certificates":null,"AddressList":null}]';
        
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        //ETI_B2B_VehicleController.saveBooking(str,'Visit ET Premises'); 
        Test.stopTest();
    }
    @isTest
    public static void testcase14(){ 
        Date stDat = System.today();
        Date endDat = System.today().addDays(1);
        ET_Customer_Vehicle__c cus = [SELECT Plate_Source__c, Plate_Type__c, Plate_Color__c, Plate_No__c, Chassis_No__c, Registration_Type__c, id FROM ET_Customer_Vehicle__c LIMIT 1];
        List<ETI_Booking__c> bookingList = [SELECT id,Selected_Services__c,Purpose_Type__c,Test_Result__c, Service_Type__c, Customer_Vehicle__c, Vehicle_Service__c, Booking_Date__c, ETI_Pick_Up_Location__c, ET_Location__c, Chassis_No__c, Preferred_Time__c, ETI_Booking_slots__c, Service_Premises__c,Mobile_No__c FROM ETI_Booking__c where Mobile_No__c!=null LIMIT 1];
        /* ETI_B2B_UtilityWrapper.walkInWrapper walkInWrapper = new ETI_B2B_UtilityWrapper.walkInWrapper();
walkInWrapper.customerVehicle = cus;
walkInWrapper.booking = bookingList[0];
walkInWrapper.booking.Selected_Services__c = 'Test;Test';
walkInWrapper.serviceLineItem = new List<ETI_Service_Line_Item__c>();
walkInWrapper.customerVehicle = cus;
walkInWrapper.customerVehicle = cus;
walkInWrapper.customerVehicle = cus;*/
        //String jsonStr = JSON.serialize(walkInWrapper);
        
        Test.startTest();
        ETI_B2B_VehicleController.getAfterBookingDetails(bookingList); 
        ETI_B2B_VehicleController.getBookingHistory(true, cus.id, stDat, endDat);
        ETI_B2B_VehicleController.getBookingHistory(false, cus.id, stDat, endDat);
        ETI_B2B_VehicleController.getUpcomingBookings(null,stDat, endDat, 'Sharjah');
        ETI_B2B_VehicleController.getUpcomingBookings(null,stDat, endDat, 'Abu Dhabi');
        ETI_B2B_VehicleController.getUpcomingServiceRequests(stDat, endDat, 'Sharjah');
        ETI_B2B_VehicleController.getUpcomingServiceRequests(stDat, endDat, 'Abu Dhabi');
        ETI_B2B_VehicleController.uploadRequiredDocuments('stDat', 'endDat', 'pdf', cus.id);
        ETI_B2B_VehicleController.saveTheFile('stDat', 'endDat', 'pdf', cus, cus.id, true);
        //ETI_B2B_VehicleController.saveTheFile('stDat', 'endDat', 'pdf', cus, '', true);
        ETI_B2B_VehicleController.getPaymentHistory(stDat, endDat);
        ETI_B2B_VehicleController.getMyCases(stDat, endDat);
        ETI_B2B_VehicleController.getMyCasesHistory(stDat, endDat);
        ETI_B2B_VehicleController.buildErrorResponse('Test', 'Test', 'message');
        //ETI_B2B_VehicleController.createBookingObject(bookingList);
        Test.stopTest();
    }
    
    @isTest
    public static void testForgetAddressDetailsByPlaceId(){
        ETI_B2B_VehicleController.getAddressDetailsByPlaceId('01');
    }
    @isTest
    public static void testcase16(){
        
        Map<String,String> mapPlateType = new Map<String,String>();
        mapPlateType.put('testPlate', 'testPlateVal');

        List<Map<String,String>> plateTypes = new List<Map<String,String>>();        
        plateTypes.add(mapPlateType);
        
        list<string> locations1 = new list<string>();
        locations1.add('Abu Dhabi');
        
        list<ETI_Required_Documents__c> requiredDocuments1 = new list<ETI_Required_Documents__c>();
        requiredDocuments1.add(new ETI_Required_Documents__c(Name='Test Document'));
        
        ETI_B2B_UtilityWrapper.fileNameWrp objfileNameWrp = new ETI_B2B_UtilityWrapper.fileNameWrp();
        ETI_B2B_UtilityWrapper.fileToBeUploaded objfileToBeUploaded = new ETI_B2B_UtilityWrapper.fileToBeUploaded();        
        list<ETI_B2B_UtilityWrapper.fileToBeUploaded> uploadedFile1 = new list<ETI_B2B_UtilityWrapper.fileToBeUploaded>();
        uploadedFile1.add(objfileToBeUploaded);
        
        list<ETI_B2B_UtilityWrapper.fileNameWrp> fileName1 = new list<ETI_B2B_UtilityWrapper.fileNameWrp>();
        fileName1.add(objfileNameWrp);
        
        ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();
        etcv1.OwnerId = userinfo.getUserId();
        etcv1.Chassis_No__c = 'D032B5GC000790';
        etcv1.Plate_No__c = '';
        etcv1.status__c = 'Active';
        etcv1.Registration_Type__c ='Registered';
        insert etcv1;
        List<ET_Customer_Vehicle__c> cvList = new List<ET_Customer_Vehicle__c>();
        cvList.add(etcv1);
        List<String> cvIdList = new List<String>();
        cvIdList.add(etcv1.Id);
        
        ETI_Vehicle_Service__c vehService = new ETI_Vehicle_Service__c();
        vehService.Service_Type__c='ADFCA';
        vehService.Service_Premises__c='Visit ET Premises';
        vehService.Name = 'Test';
        vehService.Service_Code__c = '01';
        insert vehService;
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        //acc.PersonMobilePhone='+971555555555';
        insert acc;

        Contact con = new Contact();
        con.LastName = 'NoorShaik';
        con.Email = 'noorshaiketi@smaartt.com';
        insert con;
        
        
        Id recordTypeId2 = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        ET_Service_Request__c etsr = new ET_Service_Request__c();
        etsr.Payment_Status__c = 'Not Initiated';
        etsr.RecordTypeId = recordTypeId2;
        etsr.ET_Account__c = acc.id;
        insert etsr;
        
        ETI_Lane_Details__c objLandDetails = new ETI_Lane_Details__c();
        objLandDetails.Available_Slots__c = '09:00';
        objLandDetails.Lane_Status__c = 'Active';
        objLandDetails.Slot_Frequency__c = '10 Minutes';
        insert objLandDetails;
        
        
        ETI_Booking__c booking1 = new ETI_Booking__c();         
        booking1.Service_Premises__c = 'Visit ET Premises';
        booking1.Service_Request__c = etsr.Id;
        booking1.Booking_Status__c = 'Booked';
        booking1.Customer_Vehicle__c = etcv1.Id;
        booking1.Allocated_Lane__c = objLandDetails.Id;
        booking1.ETI_Booking_slots__c = '08:00';
        booking1.Customer_Vehicle__c = etcv1.Id;
        booking1.Booking_Date__c = date.parse('10/1/2020');
        booking1.Service_Type__c = 'Certificate';
        booking1.Service_Premises__c = 'Visit ET Premises';
        booking1.Location__c = 'Abu Dhabi';
        booking1.Mobile_No__c='0555555555';
        insert booking1;
         String fileData = 'testfilename';
        string jsonstr='[{"filename":"Passport.pdf","filetype":"application/pdf","base64":"'+fileData+'"}]';

/*
(ETI_Booking__c bkng:[

SELECT ID,Name,Allocated_Lane__c,ETI_Booking_slots__c,Customer_Vehicle__c,Booking_Date__c 
FROM ETI_Booking__c WHERE Booking_Date__c =: bkngWrp.booking.Booking_Date__c 
AND ET_Location__c =: bkngWrp.booking.ET_Location__c AND Allocated_Lane__c !=NULL AND ETI_Booking_slots__c!=NULL]){

*/
        List<Map<String,String>> serviceTypes1 = new List<Map<String,String>>();
        serviceTypes1.add(new Map<String,String>{'label' => 'Repairing', 'value' =>'Repairing'});
        
        List<ETI_B2B_UtilityWrapper.bookingWrapper> objBookingWrapper1 = new List<ETI_B2B_UtilityWrapper.bookingWrapper>();
        //List<ETI_B2B_UtilityWrapper.bookingWrapper> objBookingWrapper1 = new ETI_B2B_UtilityWrapper.bookingWrapper(1,true,true,'requestId',requiredDocuments1,uploadedFile1,fileName1,booking1,serviceTypes1,'vehCode','serviceCode',plateTypes,plateTypes,locations1,true,true,true,true,true,true,true,true,true);        
        

        objBookingWrapper1.add(new ETI_B2B_UtilityWrapper.bookingWrapper(1,true,true,null,requiredDocuments1,uploadedFile1,fileName1,false,new ET_Customer_Vehicle__c(),booking1,new Map<string,list<string>>(),serviceTypes1,'vehCode','serviceCode',plateTypes,plateTypes,locations1,true,true,true,true,true,true,true,true,true,false,false,false,false));
        System.debug(JSON.serialize(objBookingWrapper1));
        
        ETI_B2B_VehicleController.getVehicleServiceType();
         ETI_B2B_VehicleController.getPlateCombinations('PLATE_SOURCE','SHARJAH','WHITE');
        ETI_B2B_VehicleController.getPlateCombinations('PLATE_TYPE','SHARJAH','WHITE');
        ETI_B2B_VehicleController.getPlateCombinations('PLATE_COLOR','SHARJAH','WHITE');
        ETI_B2B_VehicleController.getAmanLookups('PLATE_SOURCE');
        ETI_B2B_VehicleController.checkBookings(cvIdList);
        ETI_B2B_VehicleController.getChangelocationFromContact();
        ETI_B2B_VehicleController.mobileRegex('971-145698745');
        ETI_B2B_VehicleController.getVehicleColors('en');
        ETI_B2B_VehicleController.getVehicleColors('');
        
        ETI_B2B_VehicleController.createDraftBookings((JSON.serialize(objBookingWrapper1)),jsonstr);
        ETI_B2B_VehicleController.removeDraftBookings(JSON.serialize(objBookingWrapper1));
       //ETI_B2B_VehicleController.createDraftBookings(JSON.serialize(objBookingWrapper1));
        ETI_B2B_VehicleController.getAvailableSlots(JSON.serialize(objBookingWrapper1), true);
        ETI_B2B_VehicleController.updatePreferredLanguage(acc);
        
        String clearText = 'the quick brown fox jumps over the lazy dog';
        Blob key = Blob.valueOf('123456789012345678901234');
        Blob data = Blob.valueOf(booking1.Id);
        Blob cipherText = Crypto.encryptWithManagedIV('AES192', key, data);

        ETI_B2B_VehicleController.getDecryptedData(EncodingUtil.base64Encode(cipherText));
        ETI_B2B_VehicleController.getPlateCodeByCode('9', 'TEST_PURPOSE','en');

        ET_Customer_Vehicle__c objCustVehicle = new ET_Customer_Vehicle__c();
        objCustVehicle.OwnerId = userinfo.getUserId();
        objCustVehicle.Chassis_No__c = 'POWEWR232WQW';
        objCustVehicle.Plate_No__c = '';
        objCustVehicle.status__c = 'Active';
        objCustVehicle.Registration_Type__c ='Registered';
        //insert objCustVehicle;
        
        ET_Customer_Vehicle__c objCustVehicle2 = new ET_Customer_Vehicle__c();
        objCustVehicle2.OwnerId = userinfo.getUserId();
        objCustVehicle2.Chassis_No__c = 'ASFEEWR232WQW';
        objCustVehicle2.Plate_No__c = '';
        objCustVehicle2.status__c = 'Active';
        objCustVehicle2.Registration_Type__c ='Un-Registered';
        
        
        ET_Customer_Vehicle__c objCustVehicle3 = new ET_Customer_Vehicle__c();
        objCustVehicle3.OwnerId = userinfo.getUserId();
        objCustVehicle3.Chassis_No__c = '';
        objCustVehicle3.Plate_No__c = '';
        objCustVehicle3.status__c = 'Active';
        objCustVehicle3.Registration_Type__c ='Registered';
        
        ETI_B2B_VehicleController.utilityMethod();
        ETI_B2B_VehicleController.utilityMethod1();
        ETI_B2B_VehicleController.saveVehicle(objCustVehicle);
        ETI_B2B_VehicleController.saveVehicle(objCustVehicle2);
        ETI_B2B_VehicleController.saveVehicle(objCustVehicle3);
        ETI_B2B_UtilityWrapper.utilityMethod();
        //ETI_B2B_VehicleController.removeBookings([SELECT id FROM ETI_Booking__c LIMIT 1][0].id);

    }
    
    
    /*@isTest
        public static void testcase11(){ 
        id serviceid = [select id from ET_Service_Request__c limit 1][0].id;
        id ids = [SELECT id FROM ET_Customer_Vehicle__c LIMIT 1][0].id;
        ETI_Booking__c et =  [SELECT id, Service_Type__c, Customer_Vehicle__c FROM ETI_Booking__c LIMIT 1];
        String  etbook = JSON.serialize(et);
        String str = '[{"booking":{"attributes":{"type":"ETI_Booking__c"},"Service_Type__c":"Certificate", "Selected_Services__c":"A;B","Customer_Vehicle__c":"' + ids+'"},"vehicleTypeCode":null,"uploadedFile":[{"vehicleId":"' +ids + '","fileName":"test File","docName":"","contentType":"","base64Data":"Test"}],"slotList":null,"serviceTypes":null,"servicesMap":null,"serviceCode":null,"rowIndex":null,"requestId":"'+ serviceid + '","newVehicleType":"Test","newColor":"red","locations":null,"locationMap":null,"isVehicleTypeChange":true,"isValidated":null,"isSelectedRecord":true,"isRemoveDisabled":null,"isFeeDetailsExist":null,"isEnabled":null,"isColorChange":true,"isChildValidated":null,"isAdfcaVehicle":null,"isAddDisabled":null,"errorMessage":null,"enableAvailableSlots":null,"childErrorMessage":null,"certificates":null,"AddressList":null}]';
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(str, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail> mapval = new Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail>();
        ETI_B2B_UtilityWrapper.InspectionFeeDetail etiIns = new ETI_B2B_UtilityWrapper.InspectionFeeDetail(21, 21, 21);
        mapval.put('D032B5GC000790-01', etiIns);
        /*ETI_B2B_UtilityWrapper.InspectionFeeDetail etiIns = new ETI_B2B_UtilityWrapper.InspectionFeeDetail(21, 21, 21);
        mapval.put('D032B5GC000790-01', etiIns);
        
        ETI_B2B_UtilityWrapper.InspectionFeeDetail etiIns = new ETI_B2B_UtilityWrapper.InspectionFeeDetail(21, 21, 21);
        mapval.put('D032B5GC000790-01', etiIns);
        
        ETI_B2B_UtilityWrapper.InspectionFeeDetail etiIns = new ETI_B2B_UtilityWrapper.InspectionFeeDetail(21, 21, 21);
        mapval.put('D032B5GC000790-01', etiIns);
        Test.startTest();
        ETI_B2B_VehicleController.getAvailableCenters(str, 'Visit ET Premises', 'AbuDhabi');
        ETI_B2B_VehicleController.createDraftBookings(str);
        ETI_B2B_VehicleController.saveBooking(str,'Visit ET Premises');
        ETI_B2B_VehicleController.createsServiceItems(bookingWrp, [SELECT id, Customer_Vehicle__c, Chassis_No__c, Selected_Services__c FROM ETI_Booking__c limit 1], mapval);
        Test.stopTest();
        }*/
}