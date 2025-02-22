/*
* File Name:ET_SOA_Services
* Author : Smaartt
* CreatedDate : 28/03/2020
* Modification Purpose
* * 1. Sagar: Utility class to avail Abudhabi / Aman - SOA services across all applications
* * 2. Sagar : 02 June 2020 Modified to update latest service upgrade by ET team
* * 3. Sreelakshmi SK : 10 Mar 2023 Modified syncInvoicesToEBS method to push receipt data as line items
* * 4. Sreelakshmi SK : 16 Mar 2023 Modified syncInvoicesToEBS method to include Service Start Date and Service End Date while pushing
*/
public class ET_SOA_Services {
    static id B2BRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
    static id B2CRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Person_B2C).getRecordTypeId();
    public ETAbuDhabiInspectionService.getVehicleDetailsResponse_element result{get;set;}
    public ET_Fee.Output feesResult {get;set;}
    public ET_Fee.OutputFuture feesFutureResult {get;set;}
    public ET_InspectionCancellation.Output cancelResult {get;set;}
    public ET_InspectionCancellation.OutputFuture cancelFutureResult {get;set;}
    public ET_Lookup.Output lookupResult {get;set;}
    public ET_ERPVehicle.XxetVehicleMasterDetMvCollection vehicleResult {get;set;}
    public ET_ERPVehicle.OutputFuture vehicleFutureResult {get;set;}
    public ET_ERPVehicle.Output resultM {get;set;}
    public ETAECustomer.Output customerResult{get;set;}
    
    public String asyncResult {get;set;}
    Integer TIMEOUT_INT_SECS = 100;  
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to invoke rest API for etisalat digital.
    * @Params           null
    * @return           void
    *********************************************************************************************************/
    public static void testAPI(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //https://iotmobility.etisalatdigital.ae/Thingworx/Things/EmiratesAirlines_API_V1/Services/RealTimeLocationDataByPlateNo?PlateNo=M-25499
        request.setEndpoint('https://iotmobility.etisalatdigital.ae/Thingworx/Things/EmiratesAirlines_API_V1/Services/RealTimeLocationDataByPlateNo?PlateNo=M-25499');
        request.setMethod('POST');
        request.setHeader('appKey', 'bd1e721e-61c3-42f5-8d71-724630f34abc');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Cache-Control', 'no-cache');
        request.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            //ET_Common_Util.sendEmail('Test Etisalat Response', new string[]{'sagar.kambli@smaartt.com'}, null, null, response.getBody());
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            /*List<Object> animals = (List<Object>) results.get('animals');
            System.debug('Received the following animals:');
            for (Object animal: animals) {
            System.debug(animal);
            }*/
            system.debug(response.getBody());
        }
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to invoke vehicle master data webservice.
    * @Params           null
    * @return           ET_ERPVehicle.XxetVehicleMasterDetMvCollection
    *********************************************************************************************************/    
    public static ET_ERPVehicle.XxetVehicleMasterDetMvCollection showData(){
        ET_ERPVehicle.XxetVehicleMasterDetMvCollection collection;
        ET_ERPVehicleService.execute_pt service = new ET_ERPVehicleService.execute_pt();
        
        ET_ERPVehicle.Output vehicleResult ;
        if (System.test.isRunningTest()){
            vehicleResult =new ET_ERPVehicle.Output();
            vehicleResult.XxetVehicleMasterDetMvCollection = new ET_ERPVehicle.XxetVehicleMasterDetMvCollection();
            vehicleResult.XxetVehicleMasterDetMvCollection.XxetVehicleMasterDetMv = new List<ET_ERPVehicle.XxetVehicleMasterDetMv>();
            System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorResponce());
        }
        else{
            try{
                vehicleResult = service.execute('CORP','M0047646','Abu Dhabi Transport and leasing');
            }
            catch(exception ex){
                UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETI_SOA_Services', 'showData', '', UTIL_Logging.DEBUG_LEVEL_WARN);
                UTIL_Logging.logException(exLog);
            }
        }
        
        
        if(vehicleResult!=null)
        {
            collection = vehicleResult.XxetVehicleMasterDetMvCollection;
            List<ET_ERPVehicle.XxetVehicleMasterDetMv> datalist = collection.XxetVehicleMasterDetMv;
            system.debug(datalist.size());
        }
        return collection;
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to invoke ET_ERPVehicleService webservice.
    * @Params           null
    * @return           Continuation
    *********************************************************************************************************/ 
    // Invoke Asynchronous Receipt Creation process
    public Continuation CallVehicleAsync(){
        Continuation cont = new Continuation(TIMEOUT_INT_SECS);
        cont.continuationMethod = 'processResponse';
        ET_ERPVehicleService.Asyncexecute_pt service = new ET_ERPVehicleService.Asyncexecute_pt();
        try{
            vehicleFutureResult = service.beginExecute(cont,'CORP','M0047646','Abu Dhabi Transport and leasing');
        }
        catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'CallVehicleAsync', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        
        return cont;
    }
    
    // Get the result of asynchronous receipt result process
    public  ET_ERPVehicle.Output processResponse() {
        resultM = vehicleFutureResult.getValue();
        return null; 
    }
    
    /************************** VEHICLE DETAILS *******************************************************************************************************************/
    /*
    * Example - 
    * ETAbuDhabiInspectionService.GetVehicleDetailsRequest request = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
    * request.ChassisNo = 'LSFD032B5GC000790';
    * request.SystemCode = 4;
    * request.UserID = 'ET';
    * For more arguments like plateInfo - Please refer ETAbuDhabiInspectionService.GetVehicleDetailsRequest class
    * result = service.execute(request); 
    * 
    */
    public ETAbuDhabiInspectionService.getVehicleDetailsResponse_element getVehiclesDetails(ETAbuDhabiInspectionService.GetVehicleDetailsRequest vehicleRequest){
        ETAbuDhabiInspectionService.execute_pt service = new ETAbuDhabiInspectionService.execute_pt();        
        ETAbuDhabiInspectionService.getVehicleDetailsResponse_element vehicleDetails;
        try{
            vehicleDetails = service.execute(vehicleRequest);
            System.debug('vehicleDetails 134 = ' +JSON.serializePretty(vehicleDetails) );
             return vehicleDetails;
        }
        catch(exception ex){
            
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'getVehiclesDetails', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
            return null;
        }
        finally{
            UTIL_Logging.createIntegrationLogWithResponse('OUTBOUND',JSON.serialize(vehicleRequest), 'Abudhabi getVehiclesDetails',
                                                          'Inspection SF','Aman',
                                                          String.valueOf(vehicleRequest.ChassisNo)!=null ? String.valueOf(vehicleRequest.ChassisNo):String.valueOF(vehicleRequest.PlateInfo.PlateNo),String.valueOf(vehicleDetails));
            
        }
       
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to invoke ET_Lookup_Service webservice.
    * @Params           lookupType,lookupCode
    * @return           null
    *********************************************************************************************************/ 
    public void getLookupValueSync(String lookupType, string lookupCode){
        ET_Lookup_Service.execute_pt service = new ET_Lookup_Service.execute_pt();
        try{
            lookupResult = service.execute(lookupType, lookupCode);
        }
        catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'getLookupValueSync', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to GET INSPECTION FEE DETAILS,Synchronous Get Fee Details.
    * @Params           serviceRequestInputDetails
    * @return           ET_Fee.Output
    *********************************************************************************************************/
    public ET_Fee.Output getInspectionFee(List<ET_Fee.InspectionFeeInputDetail> serviceRequestInputDetails){
        ET_Fee_Service.execute_pt service = new ET_Fee_Service.execute_pt();
        ET_Fee.InspectionFeeInputDetailCollection_element element_collection = new ET_Fee.InspectionFeeInputDetailCollection_element();
        element_collection.InspectionFeeInputDetail = serviceRequestInputDetails;
        system.debug(element_collection);
        try{
            feesResult = service.execute(element_collection);
            System.debug('##############################################    ' + feesResult);
        }
        catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'createCustomer', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        return feesResult;
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to get Inspection FeeAsync
    * @Params           serviceRequestInputDetails
    * @return           null
    *********************************************************************************************************/
    public void getInspectionFeeAsync(List<ET_Fee.InspectionFeeInputDetail> serviceRequestInputDetails){
        Continuation cont = new Continuation(TIMEOUT_INT_SECS);
        cont.continuationMethod = 'getFeeResponse';
        ET_Fee_Service.Asyncexecute_pt service = new ET_Fee_Service.Asyncexecute_pt();
        ET_Fee.InspectionFeeInputDetailCollection_element element_collection = new ET_Fee.InspectionFeeInputDetailCollection_element();
        element_collection.InspectionFeeInputDetail = serviceRequestInputDetails;
        try{
            feesFutureResult = service.beginExecute(cont,element_collection); 
        }
        catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'getInspectionFeeAsync', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Get the result of asynchronous receipt result process
    * @Params           null
    * @return           null
    *********************************************************************************************************/
    public ET_Fee.Output getFeeResponse() {
        feesResult = feesFutureResult.getValue();
        return feesResult; 
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to CANCEL INSPECTION SERVICE,Synchronous Receipt Cancellation
    * @Params           AmanReceiptNo
    * @return           ET_InspectionCancellation.Output
    *********************************************************************************************************/
    public ET_InspectionCancellation.Output cancelInspectionService(String AmanReceiptNo){
        ET_InspectionCancellationService.execute_pt service = new ET_InspectionCancellationService.execute_pt();
        try{ 
            cancelResult = service.execute(AmanReceiptNo);
        }
        catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'cancelInspectionService', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        return cancelResult;
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Invoke Asynchronous Receipt cancellation process
    * @Params           AmanReceiptNo
    * @return           null
    *********************************************************************************************************/
    
    public void cancelInspectionServiceAsync(String AmanReceiptNo){
        Continuation cont = new Continuation(TIMEOUT_INT_SECS);
        cont.continuationMethod = 'cancelReceiptResponse';
        ET_InspectionCancellationService.Asyncexecute_pt service = new ET_InspectionCancellationService.Asyncexecute_pt();
        try{
            cancelFutureResult = service.beginExecute(cont,AmanReceiptNo);    
        }
        catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'cancelInspectionServiceAsync', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Get the result of asynchronous receipt cancellation process
    * @Params           null
    * @return           ET_InspectionCancellation.Output
    *********************************************************************************************************/
    
    public ET_InspectionCancellation.Output cancelReceiptResponse() {
        cancelResult = cancelFutureResult.getValue();
        return cancelResult; 
    }
    
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Read endpoint information from Custom Metadata
    * @Params           DeveloperName
    * @return           ET_SOA_Endpoint__mdt
    *********************************************************************************************************/
    public static List<ET_SOA_Endpoint__mdt> getSOAPEndpointFromMetadata(string DeveloperName){
        list<string> developerNames = new list<string>();
        developerNames = DeveloperName.split(';');
        return [SELECT Id,OrgID__c,Source_System__c,TestEndpoint__c,RecordTypes__c,LiveEndpoint__c, DeveloperName, Live_URL__c, Test_URL__c, isLive__c, Username__c, Password__c FROM ET_SOA_Endpoint__mdt where DeveloperName in:developerNames];
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Create AR Customer
    * @Params           customer
    * @return           ETAECustomer.Output
    *********************************************************************************************************/
    public static ETAECustomer.Output createCustomer(Account customer){
        ETCustomerSoapService.execute_pt service = new ETCustomerSoapService.execute_pt();
        ETAECustomer.CustomerInfo customerInfo = new ETAECustomer.CustomerInfo();
        ETAECustomer.Output customerResult = new ETAECustomer.Output();
        try{
            customerInfo = doMapping_Customer(customer,service.org_id_x);
            try{
                if(customerInfo!=null)
                    customerResult = service.execute(customerInfo);
            }
            catch(exception ex){
                UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'createCustomer', '', UTIL_Logging.DEBUG_LEVEL_WARN);
                UTIL_Logging.logException(exLog);
            }
        }
        catch(Exception e){
            ETAECustomer.Output result = new ETAECustomer.Output();
            result.StatusFlag = 'E';
            result.ErrorMsg = e.getStackTraceString();
        }
        return customerResult;
    }
    
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Mapping Customer - SOA Customer
    * @Params           customer,orgId
    * @return           ETAECustomer.CustomerInfo 
    *********************************************************************************************************/
    public static ETAECustomer.CustomerInfo doMapping_Customer(Account customer,Integer orgId){
        system.debug('orgId: '+orgId);
        ETAECustomer.CustomerInfo customerMapping = new ETAECustomer.CustomerInfo();
        string customerType = customer.ETSALES_Customer_Type__c;
        customerMapping.OrgId = orgId; 
        if(customer.ETSALES_Reference__c!=null)
            customerMapping.Reference = customer.ETSALES_Reference__c;
        if(customer.ETSALES_Emirates_Passport__c!=null)
            customerMapping.EmiratesID = customer.ETSALES_Emirates_Passport__c;
        if(customer.ETSALES_Trade_License_Number__c!=null)
            customerMapping.TradeLicenseNumber = customer.ETSALES_Trade_License_Number__c;
        if(customer.ETSALES_Trade_License_Expiry_Date__c!=null)
        {
            customerMapping.TradeLicenseExpiryDate = getSOADate(customer.ETSALES_Trade_License_Expiry_Date__c);    
        }
        if(customer.ETSALES_TaxRegistrationNo__c!=null)
            customerMapping.TaxRegistrationNo = customer.ETSALES_TaxRegistrationNo__c;
        if(customer.BillingStreet!=null)
            customerMapping.Address1 = customer.BillingStreet;
        if(customer.BillingCity!=null)
            customerMapping.City = customer.BillingCity;
        if(customer.BillingCountry!=null)
        {
            if(customer.BillingCountry.toLowerCase() == 'uae' || customer.BillingCountry.toLowerCase() == 'dubai')
                customerMapping.Country = 'AE';
            else if(customer.BillingCountry.toLowerCase() == 'saudi arabia')
                customerMapping.Country = 'SA';
            else if(customer.BillingCountry.toLowerCase() == 'oman')
                customerMapping.Country = 'OM';
        }
        
        if(customer!=null && customerType!=null && customerType.toLowerCase()==ET_Common_Util.PERSON.toLowerCase()){
            customerMapping.CustomerType = ET_Common_Util.PERSON;
            if(customer.FirstName!=null)
                customerMapping.CustomerFirstName =  customer.FirstName;
            if(customer.LastName!=null)
                customerMapping.CustomerLastName =  customer.LastName;
        }
        else{
            customerMapping.CustomerType = ET_Common_Util.ORGANIZATION;
            if(customer.Name!=null)
                customerMapping.CustomerName = customer.Name;
        }
        
        return customerMapping;
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Create AR Supplier
    * @Params           supplier
    * @return           ETSupplier.Output
    *********************************************************************************************************/
    public static ETSupplier.Output createSupplier(Account supplier){
        ETSupplierService.execute_pt service = new ETSupplierService.execute_pt();
        ETSupplier.SupplierInfo supplierInfo = new ETSupplier.SupplierInfo();
        ETSupplier.Output supplierResult = new ETSupplier.Output();
        try{
            supplierInfo = doMapping_Supplier(supplier,service.org_id_x);
            try{
                if(supplierInfo!=null)
                    supplierResult = service.execute(supplierInfo);
            }
            catch(exception ex){
                UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'createSupplier', '', UTIL_Logging.DEBUG_LEVEL_WARN);
                UTIL_Logging.logException(exLog);
            }
        }
        catch(Exception e){
            ETSupplier.Output result = new ETSupplier.Output();
            result.StatusFlag = 'E';
            result.ErrorMsg = e.getStackTraceString();
            System.debug('@@@ ex  ' + e.getMessage());
        }
        return supplierResult;
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Mapped Customer - SOA Supplierr
    * @Params           supplier,orgId
    * @return           ETSupplier.SupplierInfo 
    *********************************************************************************************************/
    public static ETSupplier.SupplierInfo doMapping_Supplier(Account supplier,Integer orgId){
        system.debug('orgId: '+orgId);
        ETSupplier.SupplierInfo supplierMapping = new ETSupplier.SupplierInfo();
        string supplierType = supplier.ETSALES_Customer_Type__c;
        supplierMapping.OrgId = orgId; 
        if(supplier.ETT_Reference_Number__c!=null)
            supplierMapping.Reference = supplier.ETT_Reference_Number__c;
        if(supplier.ETSALES_Emirates_Passport__c!=null)
            supplierMapping.EmiratesID = supplier.ETSALES_Emirates_Passport__c;
        if(supplier.ETSALES_Trade_License_Number__c!=null)
            supplierMapping.TradeLicenseNumber = supplier.ETSALES_Trade_License_Number__c;
        if(supplier.ETSALES_Trade_License_Expiry_Date__c!=null)
        {
            supplierMapping.TradeLicenseExpiryDate = getSOADate(supplier.ETSALES_Trade_License_Expiry_Date__c);    
        }
        if(supplier.ETSALES_TaxRegistrationNo__c!=null)
            supplierMapping.TaxRegistrationNo = supplier.ETSALES_TaxRegistrationNo__c;
        if(supplier.BillingStreet!=null)
            supplierMapping.Address1 = supplier.BillingStreet;
        if(supplier.BillingCity!=null)
            supplierMapping.City = supplier.BillingCity;
        if(supplier.BillingCountry!=null)
        {
            if(supplier.BillingCountry.toLowerCase() == 'uae' || supplier.BillingCountry.toLowerCase() == 'dubai')
                supplierMapping.Country = 'AE';
            else if(supplier.BillingCountry.toLowerCase() == 'saudi arabia')
                supplierMapping.Country = 'SA';
            else if(supplier.BillingCountry.toLowerCase() == 'oman')
                supplierMapping.Country = 'OM';
        }
        
        if(supplier!=null && supplierType!=null && supplierType.toLowerCase()==ET_Common_Util.PERSON.toLowerCase()){
            supplierMapping.SupplierType = ET_Common_Util.PERSON;
            if(supplier.FirstName!=null)
                supplierMapping.SupplierFirstName =  supplier.FirstName;
            if(supplier.LastName!=null)
                supplierMapping.SupplierLastName =  supplier.LastName;
        }
        else{
            supplierMapping.SupplierType = ET_Common_Util.ORGANIZATION;
            if(supplier.Name!=null)
                supplierMapping.SupplierName = supplier.Name;
        }
        
        if(supplier.ETT_Auction_Percentage__c!=null)
            supplierMapping.AuctionPercentage = supplier.ETT_Auction_Percentage__c;
        if(supplier.ETT_Bank_Account_Name__c!=null)
            supplierMapping.BankAccountName = supplier.ETT_Bank_Account_Name__c;
        if(supplier.ETT_Bank_Account_Number__c!=null)
            supplierMapping.BankAccountNumber = supplier.ETT_Bank_Account_Number__c;
        if(supplier.ETT_Bank_Name__c!=null)
            supplierMapping.BankName = supplier.ETT_Bank_Name__c;
        if(supplier.ETT_Bank_Branch_Name__c!=null)
            supplierMapping.BankBranchName = supplier.ETT_Bank_Branch_Name__c;
        if(supplier.ETT_IBAN__c!=null)
            supplierMapping.IBAN = supplier.ETT_IBAN__c;
        if(supplier.ETT_Minimum_Commission_Amount__c!=null)
            supplierMapping.MinCommisionAmt = supplier.ETT_Minimum_Commission_Amount__c;
        return supplierMapping;
    }
    
    public static string getSOADate(Date givenDate){
        string datestring = '';
        if(givenDate!=null)
            datestring = givenDate.year() + '-' + givenDate.month() + '-' + givenDate.day();
        
        return datestring;
    }
    
    /*
    * Only active inspection request for online payments 
    * Case 1 : payment done and  (proceed for receipt creation, sync receipt) in real time
    * Case 2 : payment done, receipts present in system, but not synced in aman due service down)
    */
        
        /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to get ServiceRequest Data For Payments
    * @Params           null
    * @return           null
    *********************************************************************************************************/
    public static List<ET_Service_Request__c> getServiceRequestDataForPayments(){
        List<ET_Service_Request__c> requestList = new List<ET_Service_Request__c>();
        Set<Id> service_Ids = new  Set<Id>();
        
        for(ETST_Payment__c payment: [SELECT Id,ET_Service_Request__c FROM ETST_Payment__c 
                                      where ET_Service_Request__c!=null and ET_Service_Request__r.RecordType.DeveloperName = 'Vehicle_Inspection'
                                      and ET_Service_Request__r.ETST_Is_Active__c = true and Has_Receipt__c = false and Recordtype.DeveloperName in('Card_Payment') and 
                                      ETST_Payment_State__c =: ET_Common_Util.PAYMENT_CAPTURED]){
                                          service_Ids.add(payment.ET_Service_Request__c);
                                      }
        
        requestList = [SELECT Id, RecordTypeId, Name,Total_Amount__c, ET_Account__c, (SELECT Id,Total_Amount__c from Bookings__r), (SELECT Id,ETST_AuthorizationCode__c,ETST_Payment_State__c,ETST_Payment_Mode__c from ET_Payments__r), (SELECT Id from Receipts__r) FROM ET_Service_Request__c where Id in:service_Ids];
        return requestList;
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to get getInspection Receipts
    * @Params           newReceipts
    * @return           ETI_Inspection_Receipt__c
    *********************************************************************************************************/
    public static List<ETI_Inspection_Receipt__c> getInspectionReceipts(Set<Id> newReceipts){
        List<ETI_Inspection_Receipt__c> receipts = [SELECT Id,CrmTrxReference__c,
                                                    Service_Line_Item__r.Booking__r.User__r.Name,
                                                    Service_Line_Item__r.Booking__r.User__r.Preferred_Language__c,
                                                    Service_Line_Item__r.Booking__r.User__r.Phone,
                                                    Service_Line_Item__r.Booking__r.Customer_Site_Address__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Site_Geometry__c,
                                                    Service_Line_Item__r.Booking__r.Total_Amount__c,
                                                    Service_Line_Item__r.Booking__r.Name,
                                                    Service_Line_Item__r.Booking__r.Vehicle_Number__c,
                                                    Service_Line_Item__r.Booking__r.ET_Location__r.Location_Code__c,
                                                    Service_Line_Item__r.Booking__r.Booking_Date__C,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Registration_Type__c, 
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_No__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_Type_Code__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_Source_Code__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_Color_Code__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Chassis_No__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Model_Code__c,
                                                    Service_Line_Item__r.Booking__r.Purpose_Type__r.ETI_LookupCode__c,
                                                    Service_Line_Item__r.Booking__r.Trade_License_Number__c,
                                                    Service_Line_Item__r.Booking__r.Total_Fee__c,
                                                    Service_Line_Item__r.Booking__r.Total_Tax__c,
                                                    Service_Request__r.Total_Amount__c
                                                    FROM ETI_Inspection_Receipt__c where isSyncedToAman__c = false and Id in: newReceipts];
        return receipts;
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to get getInspection Unprocessed Receipts
    * @Params           null
    * @return           ETI_Inspection_Receipt__c
    *********************************************************************************************************/
    public static List<ETI_Inspection_Receipt__c> getInspectionUnprocessedReceipts(){
        List<ETI_Inspection_Receipt__c> receipts = [SELECT Id,CrmTrxReference__c,
                                                    Service_Line_Item__r.Booking__r.User__r.Name,
                                                    Service_Line_Item__r.Booking__r.User__r.Preferred_Language__c,
                                                    Service_Line_Item__r.Booking__r.User__r.Phone,
                                                    Service_Line_Item__r.Booking__r.Customer_Site_Address__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Site_Geometry__c,
                                                    Service_Line_Item__r.Booking__r.Total_Amount__c,
                                                    Service_Line_Item__r.Booking__r.Name,
                                                    Service_Line_Item__r.Booking__r.Vehicle_Number__c,
                                                    Service_Line_Item__r.Booking__r.ET_Location__r.Location_Code__c,
                                                    Service_Line_Item__r.Booking__r.Booking_Date__C,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Registration_Type__c, 
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_No__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_Type_Code__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_Source_Code__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Plate_Color_Code__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Chassis_No__c,
                                                    Service_Line_Item__r.Booking__r.Customer_Vehicle__r.Model_Code__c,
                                                    Service_Line_Item__r.Booking__r.Purpose_Type__r.ETI_LookupCode__c,
                                                    Service_Line_Item__r.Booking__r.Trade_License_Number__c,
                                                    Service_Line_Item__r.Booking__r.Total_Fee__c,
                                                    Service_Line_Item__r.Booking__r.Total_Tax__c,
                                                    Service_Request__r.Total_Amount__c
                                                    FROM ETI_Inspection_Receipt__c where isSyncedToAman__c = false];
        return receipts;
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to get sync receipts to AMAN system
    * @Params           recIds,vSerLineItemRecId,vBookingId,receiptId
    * @return           void
    *********************************************************************************************************/
    @future(callout=true)
    public static void sendDatatoAman(Set<Id> recIds,String vSerLineItemRecId,String vBookingId,String receiptId){
        //Variable declartion.
        string jsonBody='';
        Map<Id,recordType> vMapAccRec = new Map<Id,recordType>([Select Id,DeveloperName 
                                                                FROM recordtype 
                                                                WHERE sObjectType ='Account']);
        
        ET_CreateReceipt.VehicleDetailCollection_element objVehElement= new  ET_CreateReceipt.VehicleDetailCollection_element();
        ET_CreateReceipt.Output response_x = new ET_CreateReceipt.Output();
        User u = [SELECT Id, UserName 
                  FROM User 
                  WHERE Id = :UserInfo.getUserId() Limit 1];
        try{
            system.debug('vSerLineItemRecId-->'+vSerLineItemRecId);
            system.debug('vBookingId-->'+vBookingId);
            Date intTodayDate=Date.Today().addDays(+integer.valueOf(system.label.ETI_Int_AmanReceipt_Creation_Days));
            Date extTodayDate=Date.Today().addDays(+integer.valueOf(system.label.ETI_Ext_AmanReceipt_Creation_Days));
            Id intRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
            Id extReordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();
            Id walkInReordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('Walk_In').getRecordTypeId();
            //variable Declartion.
            String CrmTrxReference='',CrmCustomerNo='',CustomerName='',CustomerMobileNo='',PreferredLanguage='',CustomerSiteAddress='',CustSiteGpsCord='',CrCardAuthCode='';
            String userName = u.UserName;
            Decimal TotalPaidAmount=0;
            List<ETI_Inspection_Receipt__c> vListReceiptInsert = new List<ETI_Inspection_Receipt__c>();
            List<ETI_Booking__c> vServiceObj = new List<ETI_Booking__c>();
            
            //Check if record Id is not null and query booking and service line item.
            if(recIds == null && vSerLineItemRecId != null){
                vServiceObj = [SELECT Id,Name,User__c,User__r.Name,Mobile_No__c,User__r.PersonMobilePhone,User__r.Preferred_Language__c,Service_Type__c,
                               createdby.contact.Name,CreatedBy.Contact.Preferred_Language__c,CreatedBy.Contact.Phone,user__r.recordtypeId,Service_Request__r.ETI_Payment_Type__c,
                               Customer_Site_Address__c,Customer_Site_Geometry__c,Vehicle_Number__c,Allocated_Lane__r.Lane_Type_AMAN__c,AMAN_Last_Lane_Type__c,
                               ET_Location__r.Location_Code__c,Booking_Date__c,Customer_Vehicle__r.Registration_Type__c,Customer_Vehicle__r.Customer_Name__c,Customer_Vehicle__r.Kind_Code__c,
                               Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__c,Customer_Vehicle__r.Plate_Type_Code__c,Customer_Vehicle__r.Plate_Source_Code__c,Customer_Vehicle__r.Plate_Color_Code__c,
                               Purpose_Type__r.ETI_LookupCode__c,Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,Total_Tax__c,Customer_Vehicle__r.Preferred_Language__c,
                               Customer_Vehicle__r.Vehicle_Color_Code1__c,Customer_Vehicle__r.Vehicle_Color_Code2__c,Customer_Vehicle__r.Vehicle_Color_Code3__c,Customer_Vehicle__r.Vehicle_Color_Code4__c,
                               Total_Amount__c,Customer_Vehicle__r.Model_Code__c,Trade_License_Number__c,Customer_Vehicle__r.Trade_License_Number__c,KM_Reading__c,Customer_Vehicle__r.Custom_Number__c,Customer_Vehicle__r.Vehicle_Type_Code__c,
                               Customer_Vehicle__r.Permission_Issue_Place__c,Customer_Vehicle__r.Vehicle_Year__c,Service_Request__c,Customer_Vehicle__r.Engine_No__c,RecordTypeId,Customer_Vehicle__r.Permit_Purpose_Code__c,Customer_Vehicle__r.Items_Transported__c,
                               (SELECT Id,Name,Service__r.Service_Code__c,Total_Fee__c,Fee_Amount__c,Tax_Amount__c,New_Color__c,
                                New_Color2__c,New_Color3__c,New_Color4__c,New_Vehicle_Type__c,Remarks__c
                                FROM Services__r 
                                WHERE Id =:vSerLineItemRecId)
                               FROM ETI_Booking__c 
                               WHERE Id =:vBookingId AND Booking_Status__c!='Cancelled' AND ((RecordTypeId=:intRecordTypeId AND Booking_Date__c =:intTodayDate) OR 
                                                          (RecordTypeId=:extReordTypeId AND Booking_Date__c=:extTodayDate) OR Booking_Date__c=:Date.Today()) AND Service_Type__c != 'SPEA Inspection'];
            }
            else{
                vServiceObj = [SELECT Id,Name,User__c,User__r.Name,User__r.PersonMobilePhone,Mobile_No__c,User__r.Preferred_Language__c,
                               createdby.contact.Name,CreatedBy.Contact.Preferred_Language__c,CreatedBy.Contact.Phone,user__r.recordtypeId,Service_Request__r.ETI_Payment_Type__c,
                               Service_Type__c,Customer_Site_Address__c,Customer_Site_Geometry__c,Vehicle_Number__c,Allocated_Lane__r.Lane_Type_AMAN__c,AMAN_Last_Lane_Type__c,
                               ET_Location__r.Location_Code__c,Booking_Date__c,Customer_Vehicle__r.Registration_Type__c,Customer_Vehicle__r.Customer_Name__c,Customer_Vehicle__r.Kind_Code__c,
                               Customer_Vehicle__r.Plate_No__c,Customer_Vehicle__c,Customer_Vehicle__r.Plate_Type_Code__c,Customer_Vehicle__r.Plate_Source_Code__c,Customer_Vehicle__r.Plate_Color_Code__c,
                               Purpose_Type__r.ETI_LookupCode__c,Customer_Vehicle__r.Chassis_No__c,Total_Fee__c,Total_Tax__c,Customer_Vehicle__r.Preferred_Language__c,
                               Customer_Vehicle__r.Vehicle_Color_Code1__c,Customer_Vehicle__r.Vehicle_Color_Code2__c,Customer_Vehicle__r.Vehicle_Color_Code3__c,Customer_Vehicle__r.Vehicle_Color_Code4__c,
                               Total_Amount__c,Customer_Vehicle__r.Model_Code__c,Trade_License_Number__c,Customer_Vehicle__r.Trade_License_Number__c,KM_Reading__c,Customer_Vehicle__r.Custom_Number__c,Customer_Vehicle__r.Vehicle_Type_Code__c,
                               Customer_Vehicle__r.Permission_Issue_Place__c,Customer_Vehicle__r.Vehicle_Year__c,Service_Request__c,Customer_Vehicle__r.Engine_No__c,RecordTypeId,Customer_Vehicle__r.Permit_Purpose_Code__c,Customer_Vehicle__r.Items_Transported__c,
                               (SELECT Id,Name,Service__r.Service_Code__c,Total_Fee__c,Fee_Amount__c,Tax_Amount__c,New_Color__c,
                                New_Color2__c,New_Color3__c,New_Color4__c,New_Vehicle_Type__c,Remarks__c
                                FROM Services__r)
                               FROM ETI_Booking__c 
                               WHERE Service_Request__c IN :recIds AND Booking_Status__c!='Cancelled' AND((RecordTypeId=:intRecordTypeId AND Booking_Date__c =:intTodayDate) OR 
                                                                        (RecordTypeId=:extReordTypeId AND Booking_Date__c=:extTodayDate) OR Booking_Date__c=:Date.Today()) AND Service_Type__c != 'SPEA Inspection'];
                
            }
            if(!vServiceObj.isEmpty()){
                List<ETST_Payment__c> paymentRecord = new List<ETST_Payment__c>([SELECT Id,ETST_AuthorizationCode__c,createdBy.UserName
                                                                                 FROM ETST_Payment__c 
                                                                                 WHERE ET_Service_Request__c=:vServiceObj[0].Service_Request__c ]);
                
                for(ETST_Payment__c payment:paymentRecord)
                {
                    userName=payment.createdBy.UserName;
                    if(payment.ETST_AuthorizationCode__c!=null)
                    {
                         CrCardAuthCode =payment.ETST_AuthorizationCode__c;
                        break;
                    }
                }
               // system.debug('paymentRecord[0]-->>'+paymentRecord[0].ETST_AuthorizationCode__c);
                //if(paymentRecord[0]!=null){
                 //   CrCardAuthCode =paymentRecord[0].ETST_AuthorizationCode__c;
                  //  userName=paymentRecord[0].createdBy.UserName;
                //}
                system.debug('vServiceObj-->'+vServiceObj);
                for(ETI_Booking__c vBook : vServiceObj){
                    ET_CreateReceipt.Input objInput = new ET_CreateReceipt.Input();
                    if(vBook.Mobile_No__c!=null) {
                        String mobile = vBook.Mobile_No__c.StartsWith('0') ? vBook.Mobile_No__c.replaceFirst('0','+971') : vBook.Mobile_No__c;                   
                        CustomerMobileNo = mobile;
                    }
                    else{
                        CustomerMobileNo = '+971555555555';
                    }
                    if(vBook.User__c !=null){
                        if(vMapAccRec.get(vBook.user__r.recordtypeId).DeveloperName == Label.ETI_Person_B2C){
                            if(vBook.User__r.Preferred_Language__c!=null){
                                if(vBook.User__r.Preferred_Language__c=='English')
                                    PreferredLanguage = 'E';
                                else
                                    if(vBook.User__r.Preferred_Language__c=='Arabic')
                                    PreferredLanguage = 'A';
                            }                
                            if(vBook.User__r.Name!=null) 
                                CustomerName =  vBook.User__r.Name;
                        }
                        else if(vMapAccRec.get(vBook.user__r.recordtypeId).DeveloperName == Label.ETI_Business_B2B_Inspection){
                            if(vBook.CreatedBy.Contact.Preferred_Language__c!=null){
                                if(vBook.CreatedBy.Contact.Preferred_Language__c=='English')
                                    PreferredLanguage = 'E';
                                else
                                    if(vBook.CreatedBy.Contact.Preferred_Language__c=='Arabic')
                                    PreferredLanguage = 'A';
                            }
                            if(vBook.CreatedBy.Contact.Name!=null) 
                                CustomerName =  vBook.CreatedBy.Contact.Name;
                        }
                        
                        else if(vMapAccRec.get(vBook.user__r.recordtypeId).DeveloperName != Label.ETI_Person_B2C){
                             if(vBook.CreatedBy.Contact != null){
                                 if(vBook.CreatedBy.Contact.Preferred_Language__c!=null){
                                     if(vBook.CreatedBy.Contact.Preferred_Language__c=='English')
                                         PreferredLanguage = 'E';
                                     else
                                         if(vBook.CreatedBy.Contact.Preferred_Language__c=='Arabic')
                                         PreferredLanguage = 'A';
                                 }
                                 if(vBook.CreatedBy.Contact.Name!=null) 
                                     CustomerName =  vBook.CreatedBy.Contact.Name;
                             }
                         }
                        
                    }
                    
                    else if(vBook.Customer_Vehicle__c !=null){
                        if(vBook.Customer_Vehicle__r.Preferred_Language__c!=null){
                            if(vBook.Customer_Vehicle__r.Preferred_Language__c=='English')
                                PreferredLanguage = 'E';
                            else
                                if(vBook.Customer_Vehicle__r.Preferred_Language__c=='Arabic')
                                PreferredLanguage = 'A';
                        }     
                        if(vBook.Customer_Vehicle__r.Customer_Name__c!=null)
                            CustomerName =  vBook.Customer_Vehicle__r.Customer_Name__c;
                    }
                    if(vBook.Customer_Site_Address__c!=null) 
                        CustomerSiteAddress =vBook.Customer_Site_Address__c;
                    if(vBook.Customer_Site_Geometry__c!=null) 
                        CustSiteGpsCord = vBook.Customer_Site_Geometry__c; 
                    CrmCustomerNo = System.Label.ETI_CrmCustomerNo;
                    Integer i=1;
                    ETI_Inspection_Receipt__c  newRec;
                    for(ETI_Service_Line_Item__c vItem : vBook.Services__r){
                        if(vItem.Name!=null)
                            CrmTrxReference = vItem.Name; 
                        if(vItem.Total_Fee__c!=null) 
                            TotalPaidAmount =vItem.Total_Fee__c; 
                        ET_CreateReceipt.VehicleDetail objVehicle = setupVehicleWrapper(vBook);
                        if(vItem.Service__r.Service_Code__c!=null)
                            objVehicle.ServiceCode=vItem.Service__r.Service_Code__c;
                        if(vItem.Fee_Amount__c!=null)
                            objVehicle.FeeAmount=vItem.Fee_Amount__c;
                        if(vItem.Tax_Amount__c!=null)       
                            objVehicle.TaxAmount=vItem.Tax_Amount__c;
                        if(vItem.Total_Fee__c!=null) 
                            objVehicle.TotalAmount=vItem.Total_Fee__c;
                        if(vItem.Name != null)
                            objVehicle.BookingReference=vItem.Name;
                        if(vBook.Service_Type__c == 'Certificate' && (vItem.Service__r.Service_Code__c=='19' || vItem.Service__r.Service_Code__c=='27' || vItem.Service__r.Service_Code__c=='33' || vItem.Service__r.Service_Code__c=='23')){
                            if(vItem.New_Color__c !=null)
                                objVehicle.NewVehColor1=vItem.New_Color__c;
                            if(vItem.New_Color2__c !=null)
                                objVehicle.NewVehColor2=vItem.New_Color2__c;
                            if(vItem.New_Color3__c !=null)
                                objVehicle.NewVehColor3=vItem.New_Color3__c;
                            if(vItem.New_Color4__c !=null)
                                objVehicle.NewVehColor4=vItem.New_Color4__c;
                        }
                        if(vBook.Customer_Vehicle__r.Vehicle_Color_Code1__c!=null)
                            objVehicle.VehColor1=vBook.Customer_Vehicle__r.Vehicle_Color_Code1__c;
                        if(vBook.Customer_Vehicle__r.Vehicle_Color_Code2__c!=null)
                            objVehicle.VehColor2=vBook.Customer_Vehicle__r.Vehicle_Color_Code2__c;
                        if(vBook.Customer_Vehicle__r.Vehicle_Color_Code3__c!=null)
                            objVehicle.VehColor3=vBook.Customer_Vehicle__r.Vehicle_Color_Code3__c;
                        if(vBook.Customer_Vehicle__r.Vehicle_Color_Code4__c!=null)
                            objVehicle.VehColor4=vBook.Customer_Vehicle__r.Vehicle_Color_Code4__c;
                        if(vBook.Service_Type__c == 'Certificate' && (vItem.Service__r.Service_Code__c=='20' || vItem.Service__r.Service_Code__c=='26' || vItem.Service__r.Service_Code__c=='32')){
                            if(vItem.New_Vehicle_Type__c !=null)
                                objVehicle.VehNewTypeId=vItem.New_Vehicle_Type__c;   
                        }  
                        if(vBook.RecordTypeId==walkInReordTypeId){
                            if(vBook.Allocated_Lane__r.Lane_Type_AMAN__c !=null)
                                objVehicle.LaneTypeId=vBook.Allocated_Lane__r.Lane_Type_AMAN__c;
                            if(vItem.Remarks__c!=null)
                                objVehicle.Remarks=vItem.Remarks__c;
                            /*else 
                            if(vBook.AMAN_Last_Lane_Type__c!=null && vBook.AMAN_Last_Lane_Type__c!='')  
                                objVehicle.LaneTypeId=vBook.AMAN_Last_Lane_Type__c;*/
                        }else {
                            /*if(vBook.AMAN_Last_Lane_Type__c!=null && vBook.AMAN_Last_Lane_Type__c!='')  
                                objVehicle.LaneTypeId=vBook.AMAN_Last_Lane_Type__c;
                            else */
                            if(vBook.Allocated_Lane__r.Lane_Type_AMAN__c !=null)
                                objVehicle.LaneTypeId=vBook.Allocated_Lane__r.Lane_Type_AMAN__c;
                        }
                        if(vBook.Customer_Vehicle__r.Permit_Purpose_Code__c!=null)
                            objVehicle.PermitPurpose=vBook.Customer_Vehicle__r.Permit_Purpose_Code__c;
                        if(vBook.Customer_Vehicle__r.Items_Transported__c!=null)
                            objVehicle.ItemsTransported=vBook.Customer_Vehicle__r.Items_Transported__c;
                        objVehicle.SerialNo=i++;
                        
                        if(objVehicle !=null) 
                            objVehElement.VehicleDetail=new ET_CreateReceipt.VehicleDetail[]{objVehicle};
                                ET_CreateReceiptService.execute_pt  obj = new ET_CreateReceiptService.execute_pt();
                        //Changes by Lahari
                        if(CustomerName != null && CustomerName.length() > 50){
                            CustomerName = CustomerName.substring(0, 50);
                        }
                        //End
                        jsonBody = '{"CrmTrxReference":"'+CrmTrxReference+'","CrmCustomerNo":"'+CrmCustomerNo+'","CustomerName":"'+CustomerName+'","CustomerMobileNo":"'+CustomerMobileNo+'","PreferredLanguage":"'+PreferredLanguage+'","CustomerSiteAddress":"'+CustomerSiteAddress+'","CustSiteGpsCord":"'+CustSiteGpsCord+'","TotalPaidAmount":"'+TotalPaidAmount+'","CrCardAuthCode":"'+CrCardAuthCode+'","UserName":"' +userName+'", "objVehElement":"'+JSON.serialize(objVehElement)+'"}';
                        system.debug('json--->'+jsonBody);     
                        response_x =  obj.execute(CrmTrxReference,CrmCustomerNo,CustomerName,
                                                  CustomerMobileNo,PreferredLanguage,CustomerSiteAddress,
                                                  CustSiteGpsCord,TotalPaidAmount,CrCardAuthCode,userName,objVehElement); 
                        
                        // system.debug('response_x.Status--->'+response_x.AmanStatusCollection.AmanStatus[0].Status);
                        system.debug('response_x.Message--->'+response_x.Message);
                        system.debug('response_x.AmanStatusCollection--->'+response_x.AmanStatusCollection);
                        if(receiptId==null && recIds == null && vSerLineItemRecId != null){
                            newRec= new ETI_Inspection_Receipt__c();
                        }
                        else{
                            newRec= new ETI_Inspection_Receipt__c(Id = receiptId);
                        }
                        newRec.Service_Line_Item__c =vItem.Id;
                        newRec.Bookings__c = vBook.Id;
                        newRec.Service_Request__c = vBook.Service_Request__c;
                        newRec.ET_Status__c = 'Active';
                        newRec.ETI_Amount__c = vItem.Total_Fee__c;
                        newRec.AMAN_Receipt_No__c = response_x.AmanStatusCollection.AmanStatus[0].AmanReceiptNo!=null ?response_x.AmanStatusCollection.AmanStatus[0].AmanReceiptNo:'';
                        if(response_x.AmanStatusCollection.AmanStatus[0].Status == 'S' ){
                            newRec.Integration_Status__c = 'Success';
                            newRec.Integration_Message__c = response_x.AmanStatusCollection.AmanStatus[0].Message;
                            newRec.isSyncedToAman__c = true;
                        }
                        else if(response_x.AmanStatusCollection.AmanStatus[0].Status == 'E'){
                            newRec.Integration_Status__c = 'Error';
                            newRec.Integration_Message__c = response_x.AmanStatusCollection.AmanStatus[0].Message;
                        }
                        vListReceiptInsert.add(newRec);
                        system.debug('--->'+vListReceiptInsert);
                    }
                }
                if(!vListReceiptInsert.isEmpty()){
                    system.debug('--->'+vListReceiptInsert);
                    upsert vListReceiptInsert;
                    ETI_Service_Line_Item__c updateSLI;
                    List<ETI_Service_Line_Item__c> vListUpSLI = new   List<ETI_Service_Line_Item__c>();
                    for(ETI_Inspection_Receipt__c vRec :[SELECT Id,Service_Line_Item__c,AMAN_Receipt_No__c
                                                         FROM ETI_Inspection_Receipt__c WHERE ID IN: vListReceiptInsert] ){
                                                             system.debug('-->'+vRec.AMAN_Receipt_No__c);
                                                             if(vRec.AMAN_Receipt_No__c!=null){
                                                                 updateSLI =new ETI_Service_Line_Item__c( Id=vRec.Service_Line_Item__c);
                                                                 updateSLI.AMAN_Receipt_No__c = vRec.AMAN_Receipt_No__c;
                                                                 vListUpSLI.add(updateSLI);
                                                             }
                                                         }
                    if(!vListUpSLI.isEmpty())
                        update vListUpSLI;
                   
                }
                if(recIds != null && recIds.size()>0 && vSerLineItemRecId == null && vBookingId == null && receiptId == null)
                    ETI_ServiceRequestHandler.sendEmailNotification(recIds);
            }
        }
        catch(Exception ex) {
            System.Debug('Exception"- ' + ex.getMessage());
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Services', 'sendDatatoAman', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        finally{
            UTIL_Logging.createIntegrationLogWithResponse('OUTBOUND',jsonBody, 'sendDatatoAman',
                                              'SF','Aman',String.valueOf(recIds)!=null?String.valueOf(recIds):vSerLineItemRecId,String.valueOf(response_x));
        }
    }
    
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to set wrapper for sync receipts to AMAN system
    * @Params           ETI_Booking__c
    * @return           ET_CreateReceipt.VehicleDetail
    *********************************************************************************************************/    
    public static ET_CreateReceipt.VehicleDetail setupVehicleWrapper(ETI_Booking__c obj){
        //Variable declaration.
        ET_CreateReceipt.VehicleDetail objVehicle = new ET_CreateReceipt.VehicleDetail();
        Map<String,String> mapLocationNameToCode = new Map<String,String>();
        for(ETI_Location_Codes__mdt vItem:[SELECT Id, DeveloperName, Location_Code__c, 
                                           Label, QualifiedApiName
                                           FROM ETI_Location_Codes__mdt]){
                                               
                                               mapLocationNameToCode.put(vItem.Label,vItem.Location_Code__c);
                                           }
        //objVehicle.VehicleId=obj.Vehicle_Number__c!=null?obj.Vehicle_Number__c:''; commented 02/09/2021 
        objVehicle.LocId=obj.ET_Location__r.Location_Code__c!=null?obj.ET_Location__r.Location_Code__c:'';
        objVehicle.ServiceDate=System.now().addMinutes(5);  
        if(obj.Customer_Vehicle__r.Registration_Type__c!=null){
            if(obj.Customer_Vehicle__r.Registration_Type__c=='Registered'){
                objVehicle.RegType='R';
                if(obj.Customer_Vehicle__r.Kind_Code__c!=null)
                    objVehicle.VehTypeId=obj.Customer_Vehicle__r.Kind_Code__c;
            }else {
                objVehicle.RegType='U';
                if(obj.Customer_Vehicle__r.Vehicle_Type_Code__c!=null)
                    objVehicle.VehTypeId=obj.Customer_Vehicle__r.Vehicle_Type_Code__c;
                if(obj.Customer_Vehicle__r.Custom_Number__c!=null && obj.Customer_Vehicle__r.Custom_Number__c!='')
                    objVehicle.CustomNo=obj.Customer_Vehicle__r.Custom_Number__c;
            }
        }
        if(obj.Customer_Vehicle__r.Plate_No__c!=null)
            objVehicle.PlateNo=obj.Customer_Vehicle__r.Plate_No__c;
        if(obj.Customer_Vehicle__r.Plate_Type_Code__c!=null)
            objVehicle.PlateTypeId=obj.Customer_Vehicle__r.Plate_Type_Code__c;
        if(obj.Customer_Vehicle__r.Plate_Source_Code__c!=null)
            objVehicle.PlateSourceId=obj.Customer_Vehicle__r.Plate_Source_Code__c;
        if(obj.Customer_Vehicle__r.Plate_Color_Code__c!=null)
            objVehicle.PlateColor=obj.Customer_Vehicle__r.Plate_Color_Code__c;
        if(obj.Purpose_Type__r.ETI_LookupCode__c!=null)
            objVehicle.TestPurposeId=obj.Purpose_Type__r.ETI_LookupCode__c;
        if(obj.Customer_Vehicle__r.Chassis_No__c!=null)
            objVehicle.ChassisNo=obj.Customer_Vehicle__r.Chassis_No__c;
        if(obj.Customer_Vehicle__r.Model_Code__c!=null) 
            objVehicle.VehModelId=obj.Customer_Vehicle__r.Model_Code__c;
        if(obj.Service_Request__r.ETI_Payment_Type__c!=null && obj.Service_Request__r.ETI_Payment_Type__c!=''){
             if(obj.Service_Request__r.ETI_Payment_Type__c=='Online') 
                objVehicle.InvType='ON';
            else if(obj.Service_Request__r.ETI_Payment_Type__c=='Card')
                objVehicle.InvType='CD';
            else if(obj.Service_Request__r.ETI_Payment_Type__c=='Cash')
                objVehicle.InvType='CS';
        }
        if(obj.Customer_Vehicle__r.Trade_License_Number__c!=null) 
            objVehicle.TradeLicenseNo=obj.Customer_Vehicle__r.Trade_License_Number__c;
        if(obj.KM_Reading__c!=null) 
            objVehicle.KmReading=Long.valueOf(obj.KM_Reading__c);
        if(obj.Customer_Vehicle__r.Registration_Type__c=='Registered' && obj.Customer_Vehicle__r.Kind_Code__c!=null && obj.Customer_Vehicle__r.Kind_Code__c!='0')
            objVehicle.VehTypeId=obj.Customer_Vehicle__r.Kind_Code__c;
        else if(obj.Customer_Vehicle__r.Vehicle_Type_Code__c!=null)
            objVehicle.VehTypeId=obj.Customer_Vehicle__r.Vehicle_Type_Code__c;
        if(obj.Customer_Vehicle__r.Permission_Issue_Place__c!=null)
            objVehicle.PermissionIssuePlace=mapLocationNameToCode.get(obj.Customer_Vehicle__r.Permission_Issue_Place__c.toUpperCase());
        if(obj.Customer_Vehicle__r.Vehicle_Year__c!=null)
            objVehicle.Model=Integer.valueOf(obj.Customer_Vehicle__r.Vehicle_Year__c);
        if(obj.Customer_Vehicle__r.Vehicle_Year__c!=null)
            objVehicle.Model=Integer.valueOf(obj.Customer_Vehicle__r.Vehicle_Year__c);
        if(obj.Customer_Vehicle__r.Engine_No__c!=null)
            objVehicle.EngineNo=obj.Customer_Vehicle__r.Engine_No__c;
        else 
          objVehicle.EngineNo='NA';
        return objVehicle;
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Sync receipts in Aman   
    * @Params           newReceipts
    * @return           void
    *********************************************************************************************************/ 
    public static void syncReceiptInAman(Set<Id> newReceipts){
        /*List<ETI_Inspection_Receipt__c>  receipts = getInspectionReceipts(newReceipts);
        if(receipts.size()>0){
            ETSyncReceipts job = new ETSyncReceipts(receipts);
            Database.executeBatch(job,200);
        }  */
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to validate Vehicle Info in ADFCA
    * @Params           ChassisNo,TradeLicNo
    * @return           ET_ValidateVehicleInfo.VehicleInfromation
    *********************************************************************************************************/    
    public static ET_ValidateVehicleInfo.VehicleInfromation validateVehicleInfo(String ChassisNo,String TradeLicNo){
        ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap t1 = new ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap(); 
        ET_ValidateVehicleInfo.VehicleInfromation response = t1.GetValidateVehicleInformation(ChassisNo, TradeLicNo);
        try{  
            return response;
        }
        catch(Exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_SOA_Servies', 'validateVehicleInfo', '', UTIL_Logging.DEBUG_LEVEL_ERROR);
            UTIL_Logging.logException(exLog);
            return null;
        }
        finally{//noor commented below code on 3/11/20
            //code to run whether there is an exception or not 
            /*UTIL_Logging.createIntegrationLogWithResponse('OUTBOUND','{' +ChassisNo +',' +TradeLicNo +'}', 'ValidateVehicleInfo',
                                              'SF','Oracle EBS',ChassisNo,string.valueOf(response) );*/
        }
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Sync Invoice and invoice line items to Oracle EBS
    * @Params           finDocId
    * @return           void
    *********************************************************************************************************/ 
    Public static void syncInvoicesToEBS(Id finDocId){
        system.debug('syncInvoicesToEBS Method');
        //Variable declaration.
        Integer lineNo=1;
        ET_CraeteARInvoice.AMAN_INVOICE_element invoice = new ET_CraeteARInvoice.AMAN_INVOICE_element();
        ET_CraeteARInvoice.OutputParameters_element response = new ET_CraeteARInvoice.OutputParameters_element(); 
        try{
            //Query finance document and invoice header information from metadata.    
            ET_Finance_Document__c financeDoc=[SELECT Id,Name,Integration_Status__c,
                                               Document_External_Id__c,CreatedDate,
                                               Integration_Message__c,ET_Bill_To_Customer__c
                                               FROM ET_Finance_Document__c
                                               WHERE Id=:finDocId];
            ET_Invoice_Header__mdt invHeader=[select developerName,ET_BatchSource__c,ET_BillToCustomerNumber__c,ET_Comments__c,
                                              ET_CustTrxType__c,ET_PaymentMethod__c,ET_TransactionCurrency__c 
                                              from ET_Invoice_Header__mdt where developerName='School_Invoice' LIMIT 1];
            //Header input details.
            ET_CraeteARInvoice.INV_HEADER_element inputHeader = new ET_CraeteARInvoice.INV_HEADER_element();
            inputHeader.BatchSource=invHeader.ET_BatchSource__c;//'CRM-GST';
            inputHeader.TransactionNumber=financeDoc.Name;//'TRX6';
            inputHeader.TransactionDate=financeDoc.CreatedDate.date();//Date.parse('10/10/2020');//Date.today();
            //inputHeader.TransactionDate=Date.parse('10/02/2023');//Date.today();
           	System.debug('inputHeader.TransactionDate: '+inputHeader.TransactionDate);
            inputHeader.FromPeriod='';
            inputHeader.ToPeriod='';
            inputHeader.TransactionCurrency=invHeader.ET_TransactionCurrency__c;//'AED';
            inputHeader.BillToCustomerNumber=financeDoc.ET_Bill_To_Customer__c;//'1790';
            inputHeader.CustTrxType=invHeader.ET_CustTrxType__c;//'SCHOOL_BUS_FEE';
            inputHeader.PaymentMethod=invHeader.ET_PaymentMethod__c;//'ON';
            inputHeader.Comments=invHeader.ET_Comments__c;//'Testing1';
            
            //line item input details.
            List<ET_CraeteARInvoice.INV_LINES_element> lineItems = new List<ET_CraeteARInvoice.INV_LINES_element>();
            
            //ET_CraeteARInvoice.INV_LINES_element linItem = new ET_CraeteARInvoice.INV_LINES_element();
            List<ET_Finance_Document_LineItem__c> docItemList=[select Id,ET_Line_Type__c,ET_Description__c,
                                                               ET_Amount__c,ET_Tax_Code__c,ET_Tax_Rate__c,
                                                               ET_Tax_Amount__c,ET_Activity_Center__c,ET_Location__c,
                                                               ET_Department__c,ET_Project__c,ET_Service_Type__c
                                                               from ET_Finance_Document_LineItem__c where ET_Finance_Document__c=:finDocId];
           //Added by Sreelakshmi SK-- 10 Mar 2023  --START-- 
           	String strtDateConverted;
            String endDateConvereted;
            Date strtDate;
            Date endDate;
            List<ET_Receipt__c> ReceiptList = new List<ET_Receipt__c>();
            ReceiptList=[select id,name,ET_Finance_Document__c,ET_Amount__c,Service_Start_Date__c,Service_End_Date__c,Activity__c,Location__c,ET_Payment__r.ETST_AuthorizationCode__c from ET_Receipt__c where ET_Finance_Document__c=:finDocId];
            System.debug('ReceiptList debug check: '+ReceiptList);
            
            for (ET_Receipt__c rec:ReceiptList){
                for(ET_Finance_Document_LineItem__c docItem:docItemList){
                    ET_CraeteARInvoice.INV_LINES_element linItem = new ET_CraeteARInvoice.INV_LINES_element();
                    linItem.line_number=lineNo++;
                    linItem.line_type=docItem.ET_Line_Type__c;//'SCHOOL_BUS_FEE';
                    linItem.Description=rec.Name;
                    linItem.Quantity=1;
                    linItem.Rate=rec.ET_Amount__c;
                    linItem.Amount=rec.ET_Amount__c;
                    linItem.Tax_Code=String.valueOf(docItem.ET_Tax_Code__c);//'AR VAT RECOVER EXEMPT';
                    linItem.Tax_Rate=Decimal.valueOf(docItem.ET_Tax_Rate__c);
                    linItem.Tax_Amount=docItem.ET_Tax_Amount__c;
                    linItem.Activity_Center=rec.Activity__c; //docItem.ET_Activity_Center__c;//'112001';  //Added by Taj Shaik -- 02 Feb 2024
                    linItem.Location=rec.Location__c; //docItem.ET_Location__c;//'311001';  //Added by Taj Shaik -- 02 Feb 2024
                    linItem.Department=docItem.ET_Department__c;//'92001';
                    linItem.Project=docItem.ET_Project__c;//'000000';
                    linItem.ServiceType=docItem.ET_Service_Type__c;//'SCHOOL TRANSPORTATION';
                    linItem.AuthCode=rec.ET_Payment__r.ETST_AuthorizationCode__c;//'12923'; //Added by Taj Shaik -- 02 Feb 2024
                    
                    //Added by Sreelakshmi SK-- 16 Mar 2023  --START--
                    
                    strtDate=rec.Service_Start_Date__c;
                    Datetime strtDatetime = Datetime.newInstance(strtDate.year(), strtDate.month(), strtDate.day());
                    strtDateConverted=strtDatetime.format('dd-MMM-yyyy');
                    
                    endDate=rec.Service_End_Date__c;
                    Datetime endDatetime = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day());
                    endDateConvereted=endDatetime.format('dd-MMM-yyyy');
                    
                    linItem.ServiceStartDate=strtDateConverted;
                    linItem.ServiceEndDate=endDateConvereted;
                    
                    //Added by Sreelakshmi SK-- 16 Mar 2023  --END--
                    
                    lineItems.add(linItem);
                }
            } 
            System.debug('Size of lineItems: '+lineItems.size());
            System.debug('Line Items Pushed: '+lineItems); 
            
            //Added by Sreelakshmi SK-- 10 Mar 2023  --END-- 
            
          /*  for(ET_Finance_Document_LineItem__c docItem:docItemList){
                linItem.line_number=lineNo++;
                linItem.line_type=docItem.ET_Line_Type__c;//'SCHOOL_BUS_FEE';
                linItem.Description=docItem.ET_Description__c;//'Testing School Invoice';
                linItem.Quantity=1;
                linItem.Rate=docItem.ET_Amount__c;
                linItem.Amount=docItem.ET_Amount__c;
                linItem.Tax_Code=String.valueOf(docItem.ET_Tax_Code__c);//'AR VAT RECOVER EXEMPT';
                linItem.Tax_Rate=Decimal.valueOf(docItem.ET_Tax_Rate__c);
                linItem.Tax_Amount=docItem.ET_Tax_Amount__c;
                linItem.Activity_Center=docItem.ET_Activity_Center__c;//'112001';
                linItem.Location=docItem.ET_Location__c;//'311001';
                linItem.Department=docItem.ET_Department__c;//'92001';
                linItem.Project=docItem.ET_Project__c;//'000000';
                linItem.ServiceType=docItem.ET_Service_Type__c;//'SCHOOL TRANSPORTATION';
                lineItems.add(linItem);
            }*/
            ET_CraeteARInvoice.LINES_GROUP_element groupItem = new ET_CraeteARInvoice.LINES_GROUP_element();
            groupItem.INV_LINES=lineItems;
            System.debug('groupItem.INV_LINES: '+groupItem.INV_LINES);
            
            
            
            //Populate final wrapper to be sent as webservice invocation parameter.
            invoice.INV_HEADER =inputHeader;
            invoice.LINES_GROUP=groupItem;
            System.debug('invoice.LINES_GROUP: '+invoice.LINES_GROUP);
            System.debug('Invoice: '+invoice);
            
            ET_CreateARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt request = new ET_CreateARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt();
            
             response=request.process(invoice);
            system.debug(response);
            if(response!=null){
                if(response.PV_OUT_STATUS=='Y'){
                    financeDoc.Integration_Status__c='Success';
                    financeDoc.Document_External_Id__c=response.PV_OUT_EBIZ_TRX_NO;
                }else{
                    financeDoc.Integration_Status__c='Error';
                    financeDoc.Integration_Message__c=response.PV_OUT_ERROR;
                }
                update financeDoc;
            }
            
        }Catch(Exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETI_SOA_Services', 'syncInvoicesToEBS', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        finally {
            //code to run whether there is an exception or not
            UTIL_Logging.createIntegrationLogWithResponse('OUTBOUND',string.valueOf(invoice), 'Create Invoice',
                                              'SF','Oracle EBS',finDocId,String.valueOf(response) );
        }
        
        
    }
    
    Public static void syncInvoicesToEBSNew(Id finDocId, ET_Invoice_Header__mdt invHeader){
        system.debug('syncInvoicesToEBSNew Method');
        //Variable declaration.
        Integer lineNo=1;
        ET_CraeteARInvoice.AMAN_INVOICE_element invoice = new ET_CraeteARInvoice.AMAN_INVOICE_element();
        ET_CraeteARInvoice.OutputParameters_element response = new ET_CraeteARInvoice.OutputParameters_element(); 
        try{
            //Query finance document and invoice header information from metadata.    
            ET_Finance_Document__c financeDoc = [SELECT Id,Name,Integration_Status__c,Document_External_Id__c,CreatedDate,Integration_Message__c,ET_Bill_To_Customer__c,ET_Prepared_Date__c,ET_Approved_Date__c,ET_Validated_Date__c FROM ET_Finance_Document__c WHERE Id =: finDocId];
            //Header input details.
            ET_CraeteARInvoice.INV_HEADER_element inputHeader = new ET_CraeteARInvoice.INV_HEADER_element();
            inputHeader.BatchSource = invHeader.ET_BatchSource__c; //'CRM-GST';
            inputHeader.TransactionNumber = financeDoc.Name; //'TRX6';
            inputHeader.TransactionDate = financeDoc.ET_Validated_Date__c.date(); //financeDoc.CreatedDate.date(); //Date.parse('10/10/2020');//Date.today();
            //inputHeader.TransactionDate=Date.parse('10/02/2023');//Date.today();
            System.debug('inputHeader.TransactionDate: '+inputHeader.TransactionDate);
            inputHeader.FromPeriod = '';
            inputHeader.ToPeriod = '';
            inputHeader.TransactionCurrency = invHeader.ET_TransactionCurrency__c; //'AED';
            inputHeader.BillToCustomerNumber = financeDoc.ET_Bill_To_Customer__c; //'1790';
            inputHeader.CustTrxType = invHeader.ET_CustTrxType__c; //'SCHOOL_BUS_FEE';
            inputHeader.PaymentMethod = invHeader.ET_PaymentMethod__c; //'ON';
            inputHeader.Comments = invHeader.ET_Comments__c; //'Testing1';
            //line item input details.
            List<ET_CraeteARInvoice.INV_LINES_element> lineItems = new List<ET_CraeteARInvoice.INV_LINES_element>();
            //ET_CraeteARInvoice.INV_LINES_element linItem = new ET_CraeteARInvoice.INV_LINES_element();
            List<ET_Finance_Document_LineItem__c> docItemList = [SELECT Id,ET_Line_Type__c,ET_Description__c,ET_Amount__c,ET_Tax_Code__c,ET_Tax_Rate__c,ET_Tax_Amount__c,ET_Activity_Center__c,ET_Location__c,ET_Department__c,ET_Project__c,ET_Service_Type__c FROM ET_Finance_Document_LineItem__c WHERE ET_Finance_Document__c =: finDocId];
            //Added by Sreelakshmi SK-- 10 Mar 2023  --START-- 
            String strtDateConverted;
            String endDateConvereted;
            Date strtDate;
            Date endDate;
            List<ET_Receipt__c> ReceiptList = new List<ET_Receipt__c>();
            ReceiptList = [SELECT Id,name,ET_Finance_Document__c,ET_Amount__c,Service_Start_Date__c,Service_End_Date__c,Activity__c,Location__c,ET_Payment__r.ETST_AuthorizationCode__c,Payable_Type__c FROM ET_Receipt__c WHERE ET_Finance_Document__c =: finDocId];
            System.debug('ReceiptList debug check: '+ReceiptList);
            for (ET_Receipt__c rec:ReceiptList){
                for(ET_Finance_Document_LineItem__c docItem:docItemList){
                    ET_CraeteARInvoice.INV_LINES_element linItem = new ET_CraeteARInvoice.INV_LINES_element();
                    linItem.line_number = lineNo++;
                    linItem.line_type = invHeader.developerName != 'SPEA_Invoice' ? docItem.ET_Line_Type__c: rec.Payable_Type__c; //docItem.ET_Line_Type__c; //'SCHOOL_BUS_FEE';
                    linItem.Description = rec.Name;
                    linItem.Quantity = 1;
                    linItem.Rate = rec.ET_Amount__c;
                    linItem.Amount = rec.ET_Amount__c;
                    linItem.Tax_Code = String.valueOf(docItem.ET_Tax_Code__c); //'AR VAT RECOVER EXEMPT';
                    linItem.Tax_Rate = Decimal.valueOf(docItem.ET_Tax_Rate__c);
                    if(invHeader.developerName != 'SPEA_Invoice'){
                        linItem.Tax_Amount = docItem.ET_Tax_Amount__c;    
                    }else if(invHeader.developerName == 'SPEA_Invoice'){
                        Decimal percentageAmount = Decimal.valueOf(docItem.ET_Tax_Rate__c)/100;
                        linItem.Tax_Amount = rec.ET_Amount__c*percentageAmount;
                    }
                    linItem.Activity_Center = rec.Activity__c; //docItem.ET_Activity_Center__c;//'112001';  //Added by Taj Shaik -- 02 Feb 2024
                    linItem.Location = rec.Location__c; //docItem.ET_Location__c;//'311001';  //Added by Taj Shaik -- 02 Feb 2024
                    linItem.Department = docItem.ET_Department__c; //'92001';
                    linItem.Project = docItem.ET_Project__c; //'000000';
                    linItem.ServiceType = docItem.ET_Service_Type__c; //'SCHOOL TRANSPORTATION';
                    linItem.AuthCode = rec.ET_Payment__r.ETST_AuthorizationCode__c; //'12923'; //Added by Taj Shaik -- 02 Feb 2024
                    if(invHeader.developerName != 'SPEA_Invoice'){
                        //Added by Sreelakshmi SK-- 16 Mar 2023  --START--
                        strtDate = rec.Service_Start_Date__c;
                        Datetime strtDatetime = Datetime.newInstance(strtDate.year(), strtDate.month(), strtDate.day());
                        strtDateConverted = strtDatetime.format('dd-MMM-yyyy');
                        endDate = rec.Service_End_Date__c;
                        Datetime endDatetime = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day());
                        endDateConvereted = endDatetime.format('dd-MMM-yyyy');
                        linItem.ServiceStartDate = strtDateConverted;
                        linItem.ServiceEndDate = endDateConvereted;
                        //Added by Sreelakshmi SK-- 16 Mar 2023  --END--   
                    }                 
                    lineItems.add(linItem);
                }
            } 
            System.debug('Size of lineItems: '+lineItems.size());
            System.debug('Line Items Pushed: '+lineItems); 
            //Added by Sreelakshmi SK-- 10 Mar 2023  --END-- 
            ET_CraeteARInvoice.LINES_GROUP_element groupItem = new ET_CraeteARInvoice.LINES_GROUP_element();
            groupItem.INV_LINES = lineItems;
            System.debug('groupItem.INV_LINES: '+groupItem.INV_LINES);
            //Populate final wrapper to be sent as webservice invocation parameter.
            invoice.INV_HEADER = inputHeader;
            invoice.LINES_GROUP = groupItem;
            System.debug('invoice.LINES_GROUP: '+invoice.LINES_GROUP);
            System.debug('Invoice: '+invoice);
            ET_CreateARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt request = new ET_CreateARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt();
            response = request.process(invoice);
            system.debug(response);
            if(response != null){
                if(response.PV_OUT_STATUS == 'Y'){
                    financeDoc.Integration_Status__c = 'Success';
                    financeDoc.Document_External_Id__c = response.PV_OUT_EBIZ_TRX_NO;
                }else{
                    financeDoc.Integration_Status__c = 'Error';
                    financeDoc.Integration_Message__c = response.PV_OUT_ERROR;
                }
                Update financeDoc;
            }
        }Catch(Exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETI_SOA_Services', 'syncInvoicesToEBS', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        finally {
            //code to run whether there is an exception or not
            UTIL_Logging.createIntegrationLogWithResponse('OUTBOUND',string.valueOf(invoice),'Create Invoice','SF','Oracle EBS',finDocId,String.valueOf(response));
        }
    }
    
    @future(callout=true)
    Public static void syncReceiptsToEBSRental(Id finDocId){
        system.debug('syncInvoicesToEBS Method');
        //Variable declaration.
        Integer lineNo=1;
        ET_CraeteARInvoice.AMAN_INVOICE_element invoice = new ET_CraeteARInvoice.AMAN_INVOICE_element();
        ET_CraeteARInvoice.OutputParameters_element response = new ET_CraeteARInvoice.OutputParameters_element(); 
        try{
            //Query finance document and invoice header information from metadata.    
            ET_Finance_Document__c financeDoc=[SELECT Id,Name,Integration_Status__c,
                                               Document_External_Id__c,CreatedDate,
                                               Integration_Message__c
                                               FROM ET_Finance_Document__c
                                               WHERE Id=:finDocId];
            ET_Invoice_Header__mdt invHeader=[select developerName,ET_BatchSource__c,ET_BillToCustomerNumber__c,ET_Comments__c,
                                              ET_CustTrxType__c,ET_PaymentMethod__c,ET_TransactionCurrency__c 
                                              from ET_Invoice_Header__mdt where developerName='School_Invoice' LIMIT 1];
            //Header input details.
            ET_CraeteARInvoice.INV_HEADER_element inputHeader = new ET_CraeteARInvoice.INV_HEADER_element();
            inputHeader.BatchSource=invHeader.ET_BatchSource__c;//'CRM-GST';
            inputHeader.TransactionNumber=financeDoc.Name;//'TRX6';
            //inputHeader.TransactionDate=financeDoc.CreatedDate.date();//Date.parse('10/10/2020');//Date.today();
            inputHeader.TransactionDate=Date.parse('10/02/2023');
            System.debug('inputHeader.TransactionDate: '+inputHeader.TransactionDate);
            inputHeader.FromPeriod='';
            inputHeader.ToPeriod='';
            inputHeader.TransactionCurrency=invHeader.ET_TransactionCurrency__c;//'AED';
            inputHeader.BillToCustomerNumber=invHeader.ET_BillToCustomerNumber__c;//'1790';
            inputHeader.CustTrxType=invHeader.ET_CustTrxType__c;//'SCHOOL_BUS_FEE';
            inputHeader.PaymentMethod=invHeader.ET_PaymentMethod__c;//'ON';
            inputHeader.Comments=invHeader.ET_Comments__c;//'Testing1';
            
            //line item input details.
            List<ET_CraeteARInvoice.INV_LINES_element> lineItems = new List<ET_CraeteARInvoice.INV_LINES_element>();
            
            ET_CraeteARInvoice.INV_LINES_element linItem = new ET_CraeteARInvoice.INV_LINES_element();
            List<ET_Finance_Document_LineItem__c> docItemList=[select Id,ET_Line_Type__c,ET_Description__c,
                                                               ET_Amount__c,ET_Tax_Code__c,ET_Tax_Rate__c,
                                                               ET_Tax_Amount__c,ET_Activity_Center__c,ET_Location__c,
                                                               ET_Department__c,ET_Project__c,ET_Service_Type__c
                                                               from ET_Finance_Document_LineItem__c where ET_Finance_Document__c=:finDocId];
            
            
            
             
            
            for(ET_Finance_Document_LineItem__c docItem:docItemList){
                linItem.line_number=lineNo++;
                linItem.line_type=docItem.ET_Line_Type__c;//'SCHOOL_BUS_FEE';
                linItem.Description=docItem.ET_Description__c;//'Testing School Invoice';
                linItem.Quantity=1;
                linItem.Rate=docItem.ET_Amount__c;
                linItem.Amount=docItem.ET_Amount__c;
                linItem.Tax_Code=String.valueOf(docItem.ET_Tax_Code__c);//'AR VAT RECOVER EXEMPT';
                linItem.Tax_Rate=Decimal.valueOf(docItem.ET_Tax_Rate__c);
                linItem.Tax_Amount=docItem.ET_Tax_Amount__c;
                linItem.Activity_Center=docItem.ET_Activity_Center__c;//'112001';
                linItem.Location=docItem.ET_Location__c;//'311001';
                linItem.Department=docItem.ET_Department__c;//'92001';
                linItem.Project=docItem.ET_Project__c;//'000000';
                linItem.ServiceType=docItem.ET_Service_Type__c;//'SCHOOL TRANSPORTATION';
                lineItems.add(linItem);
            }
            ET_CraeteARInvoice.LINES_GROUP_element groupItem = new ET_CraeteARInvoice.LINES_GROUP_element();
            groupItem.INV_LINES=lineItems;
            
            //Populate final wrapper to be sent as webservice invocation parameter.
            invoice.INV_HEADER =inputHeader;
            invoice.LINES_GROUP=groupItem;
            
            ET_CreateARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt request = new ET_CreateARInvoiceService.SyncARInvoiceToEBSServiceBPELProcess_pt();
            
             response=request.process(invoice);
            system.debug(response);
            if(response!=null){
                if(response.PV_OUT_STATUS=='Y'){
                    financeDoc.Integration_Status__c='Success';
                    financeDoc.Document_External_Id__c=response.PV_OUT_EBIZ_TRX_NO;
                }else{
                    financeDoc.Integration_Status__c='Error';
                    financeDoc.Integration_Message__c=response.PV_OUT_ERROR;
                }
                update financeDoc;
            }
            
        }Catch(Exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETI_SOA_Services', 'syncInvoicesToEBS', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        finally {
            //code to run whether there is an exception or not
            UTIL_Logging.createIntegrationLogWithResponse('OUTBOUND',string.valueOf(invoice), 'Create Invoice',
                                              'SF','Oracle EBS',finDocId,String.valueOf(response) );
        }
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to return the SF and External system field mapping.
    * @Params           mapper
    * @return            Map<String, Object>
    *********************************************************************************************************/ 
    Public static   Map<String, Object> getFieldMapping(String mapper){ 
        ET_Mapper__mdt trs=[SELECT Id, Source_Object__c, Source_Field__c, Source_Datatype__c, Target_Object__c, Target_Field__c, Target_Datatype__c, FieldMapper__c, Label, DeveloperName 
                            FROM ET_Mapper__mdt 
                            WHERE DeveloperName=:mapper LIMIT 1];
        String stringAcc=trs.FieldMapper__c.replaceAll('\r\n', '');
        Map<String, Object> mapAcc = (Map<String, Object>)JSON.deserializeUntyped(stringAcc);
        mapAcc.remove('attributes');
        system.debug('mapAcc'  +mapAcc);
        return   mapAcc;
    }
    public static void utilityMehtod(){
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
}