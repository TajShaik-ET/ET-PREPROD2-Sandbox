@isTest
public class ET_Payment_Controller_Test{
    
    public static testmethod void testData(){
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.ETSALES_TaxRegistrationNo__c = '123456765432123';
        insert acc;
        
        ET_Service_Request__c serviceRequest = new ET_Service_Request__c();
        serviceRequest.ET_Account__c = acc.Id;
        insert serviceRequest;
        
        ET_Location__c locationObj = new ET_Location__c();
        locationObj.Name = 'Abu Dhabi';
        insert locationObj;
        
        ET_Customer_Vehicle__c customerVehicle = new ET_Customer_Vehicle__c();
        customerVehicle.Account__c = acc.Id;
        customerVehicle.Chassis_No__c = '43235';
        customerVehicle.Plate_Color__c='red';
        customerVehicle.Plate_No__c='4512';
        insert customerVehicle;
        
        List<ETI_Booking__c>  bookinlist = new List<ETI_Booking__c>();
        ETI_Booking__c objBooking = new ETI_Booking__c();
        objBooking.ET_Location__c = locationObj.Id;
        objBooking.Service_Request__c = serviceRequest.Id;
        objBooking.Booking_Date__c = Date.valueOf('2020-07-21');
        objBooking.Service_Type__c = 'Police Inspection';
        objBooking.ET_Location__c=locationObj.ETSALES_Emirates__c;
        objBooking.Customer_Vehicle__c = customerVehicle.Id;
        objBooking.Booking_Status__c = 'Booked';
        objBooking.Amount__c= 200;
        objBooking.Plate_No__c=customerVehicle.Plate_No__c;
        objBooking.Plate_Color__c=customerVehicle.Plate_Color__c;
        objBooking.Chassis_No__c=customerVehicle.Chassis_No__c;
        insert objBooking;
        
        
        ETI_Service_Line_Item__c serviceline = new ETI_Service_Line_Item__c();
        serviceline.Booking__c=objBooking.Id;
        insert serviceline;
        
        ETI_Inspection_Receipt__c  receipt = new ETI_Inspection_Receipt__c();
        receipt.Bookings__c=objBooking.id;
        receipt.Service_Line_Item__c=serviceline.Id;
        receipt.AMAN_Receipt_No__c='45124';
        receipt.ET_Status__c='Active';
        receipt.ETI_Amount__c=400;
        insert receipt;
        
        ETST_Payment__c payRecord = new ETST_Payment__c();
        payRecord.ET_Service_Request__c=serviceRequest.id;
        payRecord.ETST_Amount__c = 200;
        payRecord.ETST_Capture_State__c = 'SUCCESS';
        insert payRecord;
        
        
        PageReference pageRef = Page.ETPaymentForm;
        Test.setCurrentPage(pageRef);
        
        string messageUI = Apexpages.currentPage().getParameters().get('messageUI');
        string sessionKey = Apexpages.currentPage().getParameters().get('sessionId');
        
        PageRef.getParameters().put('messageUI','Test');
        PageRef.getParameters().put('src','et');
        PageRef.getParameters().put('recordId',string.valueOf(serviceRequest.Id));
        ET_Payment_Controller payctrl = new ET_Payment_Controller();
        
        
        
        //payctrl.setMessage();
        Date todaysdate = date.today();
        String dateString= string.valueOf(todaysdate);
        ET_Payment_Controller.makePayment();
        payctrl.setMessage();
        
        ET_Payment_Controller.updateFormValue();
        ET_Payment_Controller.updateServiceStatus(serviceRequest.Id,'Refund Requested',1000);
        
        //payctrl.updatePayment();
        ET_Payment_Controller.convertISODateTimeString(dateString);
        /*ET_Payment_Controller.convertISODateTimeString(dateString);


string payment_status = Apexpages.currentPage().getParameters().get('status');
string payment_Id = Apexpages.currentPage().getParameters().get(payRecord.Id);
payctrl.updatePayment();
ET_Payment_Controller.getPaymentStatus(payRecord.Id);*/
        // ET_Payment_Controller.utilityMethod();
    }
    
    @testSetup
    public static void setupdata(){
        ETST_Payment__c epaym = new ETST_Payment__c();
        epaym.ETST_Amount__c = 200;
        epaym.ETST_Capture_State__c = 'SUCCESS';
        epaym.ETST_refund_state__c= 'SUCCESS';
        epaym.ETST_Payment_URL__c = 'http://example.com/example/test';
        epaym.ETST_Refund_Date_Time__c= system.now();
        epaym.ExternalId__c ='232323';
        insert epaym;
        
        
        ET_External_Endpoint__mdt tokendetails = [SELECT Id,outletRef__c,HostedSessionID__C, PaymentURL__c,DeveloperName, MasterLabel, URL__c, QualifiedApiName, Action__c, Content_Type__c, Authorization__c, Grant_Type__c, EnvironmentType__c FROM ET_External_Endpoint__mdt limit 1 ];//where DeveloperName ='ETPayment' and EnvironmentType__c ='UAT' limit 1];
        
    }
    
    
    public static testMethod void testMakePayment(){
        
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        ET_Payment_Controller pmntctrl = new ET_Payment_Controller();
        ET_Payment_Controller.serviceAmountValue=1000;
        ET_Payment_Controller.emailVal ='test@gmail.com';
        ET_Payment_Controller.firstName='fname';
        ET_Payment_Controller.lastName='lname';
        System.Test.startTest();
        String key = String.valueOf([SELECT id from ETST_Payment__c limit 1][0].id);
        ET_Payment_Controller.getPaymentById(key);
        ET_Payment_Controller.getPayment(key);
        
        DateTime dt = system.now();
        
        String dtf = '2020-07-03T01:09:36.933';
        ET_Payment_Controller.convertISODateTimeString(dtf);
        ET_Payment_Controller.makePayment();
        ET_Payment_Controller.getPaymentStatus('232323',false);
        
        System.Test.stopTest();
    }
    
    
    /*  public static testMethod void testMakePayment1(){

System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
ET_Payment_Controller pmntctrl = new ET_Payment_Controller();

System.Test.startTest();        
ET_Payment_Controller.makePayment();        
System.Test.stopTest();
}*/
    
    /* public static testMethod void testUpdatePayment(){

System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
PageReference pageRef = Page.ETPaymentForm;
PageRef.getParameters().put('paymentId','232323');
ET_Payment_Controller payCtrl = new ET_Payment_Controller();
System.Test.startTest();        
payCtrl.updatePayment();        
System.Test.stopTest();
} //getPaymentRow*/
    
    public static testMethod void testVoidPayment(){
             String key = String.valueOf([SELECT id from ETST_Payment__c limit 1][0].id);
         system.debug('--key--'+key);
        System.Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());        
        ET_Payment_Controller.cancelRefund(key);
        
        System.Test.stopTest();
    }
    
    @isTest
    static void testGetRefundStatus_SuccessfulRefund() {
        // Create a test ETST_Payment__c record with refund state as 'SUCCESS'
        ETST_Payment__c testPaymentRecord = new ETST_Payment__c(
            ExternalId__c = 'sampleExternalId', // Replace with a unique External Id
            ETST_refund_state__c = 'SUCCESS'// Refund state set to 'SUCCESS' for testing
            // Populate other required fields
        );
        insert testPaymentRecord;
        
        // Create and set up mock HTTP callout
      //  Test.setMock(HttpCalloutMock.class, new ET_Common_Util.MockHttpResponseGenerator());
        
        Test.startTest();
        
        // Call the method to be tested
        String refundStatus = ET_Payment_Controller.getRefundStatus('sampleExternalId');
        
        Test.stopTest();
    }
    
    // Test for unsuccessful refund status due to refund state 'FAILED'
    @isTest
    static void testGetRefundStatus_RefundFailed() {
        // Create a test ETST_Payment__c record with refund state as 'FAILED' for testing non-successful refund
        ETST_Payment__c testPaymentRecord = new ETST_Payment__c(
            ExternalId__c = 'sampleExternalId', // Replace with a unique External Id
            ETST_refund_state__c = 'FAILED'// Refund state set to 'FAILED' for testing
            // Populate other required fields
        );
        insert testPaymentRecord;
        
        // Create and set up mock HTTP callout
      //  Test.setMock(HttpCalloutMock.class, new ET_Common_Util.MockHttpResponseGenerator());
        
        Test.startTest();
        
        // Call the method to be tested
        String refundStatus = ET_Payment_Controller.getRefundStatus('sampleExternalId');
        
        Test.stopTest();
        
    }
    
    // Test for payment already cancelled
    @isTest
    static void testGetRefundStatus_PaymentAlreadyCancelled() {
        // Create a test ETST_Payment__c record with capture state as 'VOID' indicating payment cancellation
        ETST_Payment__c testPaymentRecord = new ETST_Payment__c(
            ExternalId__c = 'sampleExternalId', // Replace with a unique External Id
            ETST_Capture_State__c = 'VOID'// Capture state set to 'VOID' for testing payment cancellation
            // Populate other required fields
        );
        insert testPaymentRecord;
        
        Test.startTest();
        
        // Call the method to be tested
        String refundStatus = ET_Payment_Controller.getRefundStatus('sampleExternalId');
        
        Test.stopTest();
    }
    @isTest
    static void testGetRefundStatus_NoPaymentRecordExists() {
        Test.startTest();
        
        // Call the method to be tested when no payment record exists
        String refundStatus = ET_Payment_Controller.getRefundStatus('nonExistingExternalId');
          ET_Payment_Controller.utilityMethod();
        Test.stopTest();
    }
    
    
    
}