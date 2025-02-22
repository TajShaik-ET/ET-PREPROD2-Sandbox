@isTest
public class ET_SOA_Services_Test {
    @testsetup
    public static void setUpdata(){
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorResponce());  
        List<Account> accList = new List<Account>();
        Account acc  = new Account(Name = 'Test Name');
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        // acc.ETSALES_Customer_Type__c = 'Person';
        accList.add(acc);
        acc  = new Account(Name = '001');
        //acc.ETSALES_Customer_Type__c = 'Person';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId(); 
        // accList.add(acc);
        insert accList;
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Salesforce_Customer__c = accList[0].id;
        insert etSales;
        ETST_Calendar__c etcal = new ETST_Calendar__c();
        insert etcal;
        new ET_InspectionCancellation.Output();
        new ET_InspectionCancellation.Control();
        new Et_Fee.InspectionFeeOutputDetailCollection_element();
        new Et_Fee.Output();
        new Et_Fee.Control();
        new Et_Fee.InspectionFeeOutputDetail();
        new Et_Fee.InspectionFeeInputDetail();
        
        
    }
    
    @isTest
    public static void testCase1(){
        
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorResponce());
        ET_SOA_Services.testAPI();
        System.Test.stopTest();
    }
    @isTest
    public static void testCase2(){
        
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorResponce());
        ET_SOA_Services.showData();
        System.Test.stopTest();
    }
    @isTest
    public static void testCase3(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        System.Test.startTest();
        
        etSoa.CallVehicleAsync();
        System.Test.stopTest();
    }
    @isTest
    public static void testForcreateSupplier(){
        // ET_SOA_Services  etSoa = new ET_SOA_Services();
        System.Test.startTest();
        Account acc =  [SELECT ETT_Minimum_Commission_Amount__c, ETT_IBAN__c, ETT_Bank_Branch_Name__c, ETT_Bank_Name__c,
                        ETT_Bank_Account_Number__c, ETT_Bank_Account_Name__c, ETT_Auction_Percentage__c, Name,
                        LastName, FirstName, BillingCountry, BillingCity, BillingStreet, ETSALES_TaxRegistrationNo__c,
                        ETSALES_Trade_License_Expiry_Date__c, ETSALES_Trade_License_Number__c, ETSALES_Emirates_Passport__c,
                        ETT_Reference_Number__c, ETSALES_Customer_Type__c FROM Account LIMIT 1];
        ET_SOA_Services.createSupplier(acc);
        System.Test.stopTest();
    }
    @isTest
    public static void testForcreateSupplierCase1(){
        Continuation cont = new Continuation(100);
        cont.continuationMethod = 'processResponse';
        
        ETSupplierService.Asyncexecute_pt asyn = new ETSupplierService.Asyncexecute_pt();
        // ET_SOA_Services  etSoa = new ET_SOA_Services();
        System.Test.startTest();
        
        asyn.beginExecute(cont, new ETSupplier.AuthInfo(), new ETSupplier.SupplierInfo());
        System.Test.stopTest();
    }
    @isTest
    public static void testCase4(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        System.Test.startTest();
        
        etSoa.processResponse();
        System.Test.stopTest();
    }
    @isTest
    public static void testForgetVehiclesDetails(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        ETAbuDhabiInspectionService.GetVehicleDetailsRequest vehicleRequest = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
        System.Test.startTest();
        
        //ETAbuDhabiInspectionService.getVehicleDetailsResponse_element result= etSoa.getVehiclesDetails(vehicleRequest);
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForGetLookupValueSync(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        System.Test.startTest();
        
        etSoa.getLookupValueSync('vehicleRequest', '001');
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForGetInspectionFee(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        List<ET_Fee.InspectionFeeInputDetail> serviceRequestInputDetails = new List<ET_Fee.InspectionFeeInputDetail>();
        System.Test.startTest();
        
        etSoa.getInspectionFee(serviceRequestInputDetails);
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForGetInspectionFeeAsync(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        List<ET_Fee.InspectionFeeInputDetail> serviceRequestInputDetails = new List<ET_Fee.InspectionFeeInputDetail>();
        System.Test.startTest();
        
        etSoa.getInspectionFeeAsync(serviceRequestInputDetails);
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForGetFeeResponse(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        etSoa.feesFutureResult = new ET_Fee.OutputFuture();
        System.Test.startTest();
        
        etSoa.getFeeResponse();
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForcreateReceipt(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        //new ET_CreateReceipt.AmanStatus();
        //new ET_CreateReceipt.VehicleDetail();
        // new ET_CreateReceipt.AmanStatusCollection_element();
        System.Test.startTest();
        DateTime d = DateTime.newInstance(2020, 05, 29);
        // etSoa.createReceipt('Test Name', 'Test Name', 'Test Name', 'Test Name', 'Test Name', 'Test Name',null , 3.2, 'Test Name', new ET_CreateReceipt.VehicleDetailCollection_element());
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForcreateReceiptAsync(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        System.Test.startTest();
        DateTime d = DateTime.newInstance(2020, 05, 29);
        //etSoa.createReceiptAsync('Test Name', 'Test Name', 'Test Name', 'Test Name', 'Test Name', 'Test Name',null , 3.2, 'Test Name', new ET_CreateReceipt.VehicleDetailCollection_element());
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForcreateReceiptResponse(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        //etSoa.saveReceiptFutureResult = new ET_CreateReceipt.OutputFuture();
        System.Test.startTest();
        
        // etSoa.createReceiptResponse();
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForcancelInspectionService(){
        /*  ET_SOA_Services  etSoa = new ET_SOA_Services();
etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
System.Test.startTest();

etSoa.cancelInspectionService('001');
System.Test.stopTest(); */
        
    } 
    @isTest
    public static void testForCancelInspectionServiceAsync(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.vehicleFutureResult = new ET_ERPVehicle.OutputFuture();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        System.Test.startTest();
        
        etSoa.cancelInspectionServiceAsync('001');
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForcancelReceiptResponse(){
        ET_SOA_Services  etSoa = new ET_SOA_Services();
        etSoa.cancelFutureResult = new ET_InspectionCancellation.OutputFuture();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        System.Test.startTest();
        
        etSoa.cancelReceiptResponse();
        System.Test.stopTest();
        
    }
    @isTest
    public static void testForcreateCustomer(){
        
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        System.Test.startTest();
        Account acc = new Account(Name = 'Test');
        ET_SOA_Services.createCustomer(acc);
        System.Test.stopTest();
        
    }
    @isTest
    public static void testFordoMapping(){
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        System.Test.startTest();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId(); 
        Account acc0 = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',ETSALES_Emirates_Passport__c='Pa1123',ETSALES_Trade_License_Number__c='12234',
                                   ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(1),ETSALES_TaxRegistrationNo__c='1234',BillingStreet='strre',BillingCity='city',BillingCountry='uae',
                                   ETT_Auction_Percentage__c=10,ETT_Bank_Account_Name__c='test',ETT_Bank_Account_Number__c='1234',ETT_Bank_Branch_Name__c='dubai',
                                   ETT_Bank_Name__c='test',ETT_IBAN__c=10,ETT_Minimum_Commission_Amount__c=10,
                                   ETSALES_Customer_Type__c='Person', PersonEmail='test@test.com',etst_coordinator__c=userinfo.getUserId()); // Trade License Expiry date added addDays(1)-- Sreelakshmi SK 25/4/23
        insert acc0; 
        Account acc1 = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',ETSALES_Emirates_Passport__c='Pa1123',ETSALES_Trade_License_Number__c='12234',
                                   ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(1),ETSALES_TaxRegistrationNo__c='1234',BillingStreet='strre',BillingCity='city',BillingCountry='oman',
                                   ETSALES_Customer_Type__c='Person', PersonEmail='test@test.com',etst_coordinator__c=userinfo.getUserId()); // Trade License Expiry date added addDays(1)-- Sreelakshmi SK 25/4/23
        insert acc1;
        Account acc2 = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',ETSALES_Emirates_Passport__c='Pa1123',ETSALES_Trade_License_Number__c='12234',
                                   ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(1),ETSALES_TaxRegistrationNo__c='1234',BillingStreet='strre',BillingCity='city',BillingCountry='saudi arabia',
                                   ETSALES_Customer_Type__c='Person', PersonEmail='test@test.com',etst_coordinator__c=userinfo.getUserId()); // Trade License Expiry date added addDays(1)-- Sreelakshmi SK 25/4/23
        insert acc2;
        
        ET_SOA_Services.doMapping_Customer(acc0, 123);
        ET_SOA_Services.doMapping_Customer(acc1, 123);
        ET_SOA_Services.doMapping_Customer(acc2, 123);
        ET_SOA_Services.doMapping_Supplier(acc0, 123);
        ET_SOA_Services.doMapping_Supplier(acc1, 123);
        ET_SOA_Services.doMapping_Supplier(acc2, 123);
        ET_SOA_Services.utilityMehtod();
        System.Test.stopTest();
    }
    
    
    @isTest public static void testCase23(){
        new Et_ERPVehicle.Control();
        new Et_ERPVehicle.VehicleMasterSelect_pVehMode_pInternalNo_pActivity();
        new Et_ERPVehicle.XxetVehicleMasterDetMv();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        ET_ERPVehicleService.execute_pt etVech = new ET_ERPVehicleService.execute_pt();
        System.Test.startTest();
        etVech.execute('Test mode','001','drive');
        System.Test.stopTest();
    }
    
    /*@isTest 
    public static void testForETI_Batch_Vehicle_Service(){
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        System.Test.startTest();
        DataBase.executeBatch(new ETI_Batch_Vehicle_Service('drive', 'Test mode'), 1);
        
        System.Test.stopTest();
    }*/
    @isTest public static void testForEt_LookUp(){
        
        System.Test.startTest();
        new ET_lookup.Control();
        new ET_lookup.OutputFuture();
        new ET_lookup.GetLookupValuesSelect_InputParameters();
        System.Test.stopTest();
    }
    @isTest public static void testForEt_LookUpService(){
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        ET_Lookup_Service.Asyncexecute_pt etAsyn = new ET_Lookup_Service.Asyncexecute_pt();
        Continuation cont = new Continuation(100);
        cont.continuationMethod = 'processResponse';
        ET_ERPVehicleService.Asyncexecute_pt service = new ET_ERPVehicleService.Asyncexecute_pt();
        
        System.Test.startTest();
        etAsyn.beginExecute(cont,'CORP','M0047646');
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, new ET_ERPVehiclesServiceSchedule());
        System.Test.stopTest();
    }
    @isTest public static void testForET_SOA_Authorize(){
        
        System.Test.startTest();
        //ET_SOA_Authorize.initializeSecurityForCustomer();
        System.Test.stopTest();
    }
    
    @isTest
    public static void getServiceRequestDataForPaymentsTest(){
        System.Test.startTest();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        // Trade License Expiry date added addDays(1)-- Sreelakshmi SK 25/4/23
        Account acc0 = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',ETSALES_Emirates_Passport__c='Pa1123',ETSALES_Trade_License_Number__c='12234',
                                   ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(1),ETSALES_TaxRegistrationNo__c='1234',BillingStreet='strre',BillingCity='city',BillingCountry='uae',
                                   ETT_Auction_Percentage__c=10,ETT_Bank_Account_Name__c='test',ETT_Bank_Account_Number__c='1234',ETT_Bank_Branch_Name__c='dubai',
                                   ETT_Bank_Name__c='test',ETT_IBAN__c=10,ETT_Minimum_Commission_Amount__c=10,ETSALES_Customer_Type__c='Person', PersonEmail='test@test.com',etst_coordinator__c=userinfo.getUserId());
        insert acc0;
        
        Id devRecordTypeIdSR = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Paid_By__c = 'Self',ETST_Pick_Up_Start_Date__c=system.today(),
                                                                 ETST_Pick_Up_End_Date__c=system.today()+60,ETST_Cancellation_End_Date__c=system.today()+20,ETST_Is_Active__c = true,
                                                                 ETST_Cancellation_Effective_Date__c=system.today()+20,ETST_Service_Type__c='Yearly',ETST_Fare_Charges__c=10000,
                                                                 ET_Account__c=acc0.Id,RecordTypeId=devRecordTypeIdSR);
        insert etreq;
        
        ETST_Payment__c objETSTPayment = new ETST_Payment__c();
        objETSTPayment.RecordTypeId = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Card_Payment').getRecordTypeId();
        objETSTPayment.ETST_Amount__c = 1200;
        objETSTPayment.ET_Service_Request__c = etreq.id;
        objETSTPayment.ETST_Payment_State__c = 'SUCCESS';
        objETSTPayment.Has_Receipt__c = false;
        objETSTPayment.ETST_Payment_State__c ='CAPTURED';
        insert objETSTPayment;
        
        ET_SOA_Services.getServiceRequestDataForPayments();
        System.Test.stopTest();
        
    }
    
    @isTest
    public static void getInspectionReceiptsTest(){
        Set<Id> ids = new Set<Id>();
        ET_SOA_Services.getInspectionReceipts(ids);
        ET_SOA_Services.getInspectionUnprocessedReceipts();
        ET_SOA_Services.syncReceiptInAman(ids);
    }
    
    @isTest
    public static void syncInvoicesToEBSTest(){
        
        ET_Finance_Document__c doc = new ET_Finance_Document__c();
        doc.ET_Zone__c='Zone A';
        doc.ET_Location__c='Mosafah 1';
        doc.ET_Activity__c='Private School Transportation Cente';
        doc.ET_Transaction_Type__c='On Premise';
        insert doc;
        ET_Finance_Document_LineItem__c docLine = new ET_Finance_Document_LineItem__c(ET_Finance_Document__c=doc.Id,ET_Line_Type__c='line',ET_Description__c='description',
                                                                                      ET_Amount__c=1000,ET_Tax_Amount__c=100,ET_Tax_Code__c='1234',ET_Tax_Rate__c='5',ET_Project__c='test',ET_Service_Type__c='test',
                                                                                      ET_Activity_Center__c='test',ET_Location__c='test',ET_Department__c='test');
        insert docLine;
        
        ET_Invoice_Header__mdt invHeader=[select developerName,ET_BatchSource__c,ET_BillToCustomerNumber__c,ET_Comments__c,
                                          ET_CustTrxType__c,ET_PaymentMethod__c,ET_TransactionCurrency__c 
                                          from ET_Invoice_Header__mdt where developerName='School_Invoice' LIMIT 1];
        
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        System.Test.startTest();
        ET_SOA_Services.syncInvoicesToEBS(doc.Id);
        ET_SOA_Services.syncInvoicesToEBSNew(doc.Id,invHeader);
        System.Test.stopTest();
    } 
    
    /* @isTest
    public static void asyncsyncInvoicesToEBSTest(){        
        ET_CreateARInvoiceService.AsyncSyncARInvoiceToEBSServiceBPELProcess_pt asyncInstnace = new ET_CreateARInvoiceService.AsyncSyncARInvoiceToEBSServiceBPELProcess_pt();
        ET_CraeteARInvoice.AMAN_INVOICE_element invoice = new ET_CraeteARInvoice.AMAN_INVOICE_element();
        Continuation con = new Continuation(40);
        asyncInstnace.beginProcess(con,invoice);
        
    }*/
}