@isTest
public class MOTO_GetEstimationTest {
    @isTest 
    Public static void GenerateQuotemethod(){
        
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        Account acc= new Account();
        acc.FirstName = 'John';
        acc.LastName = 'Doe';
        acc.PersonEmail = 'test@gmail.com';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name='emirates oils ltd';
        opp.StageName='Service Booking';
        opp.CloseDate=system.today()+5;
        opp.AccountId=acc.Id;
        
        insert opp;
        
        string ServiceEtimationNo='1931859';
        string recordId=opp.Id;
        
        Test.startTest();
        MOTO_GetEstimation.GenerateQuoteDoc(ServiceEtimationNo,opp.Id); 
        string res = '{"EstimationSQLOutput" : [ { "internal_number" : "PV12153","estimate_no" : "2131544", "work_order_no" : "6436931", "service_no" : 2461083, "work_description" : "VEH TATA BUS- LUBE SERVICE AC ENGINE SERVICE BODY WASHING AND GREASING","current_status" : "Work In Progress", "service_location" : "Dubai Al Ramool (C) Workshop","estimator" : "IFTIKHAR  UL HAQ", "document" : "JVBERi0xLjQNCjUgMCBvYmoNCjw8DQovVHl"}]}';

        ET_MotoWrapperClass.EstimationSQLOutput etw = new ET_MotoWrapperClass.EstimationSQLOutput ();
        etw.current_status = '';
        etw.document ='weqwewqewqeqwew';
        etw.estimate_no='12324';
        etw.internal_number='213213';
        etw.estimator='jana';
        etw.is_invoice_paid='no';
        etw.is_invoiced='no';
        etw.net_amount=1234;
        etw.plate_number='13134';
        etw.service_location='test';
        etw.service_no=123;
        etw.total_amount=1245;
        etw.total_labor_charge=113;
        etw.total_material_charge=122;
        etw.vat_amount=1213;
        etw.work_description='';
        etw.work_order_no='121';
        etw.total_other_charge=123;
       	
        Blob testBlob = Blob.valueOf('Test PDF Content');
        
        Test.stopTest();
    }
    
    @isTest
    static void testSendEstimateEmail() {
        // Create a test Opportunity and a PDF blob for testing
        Account acc= new Account();
        acc.FirstName = 'John';
        acc.LastName = 'Doe';
        acc.PersonEmail = 'test@gmail.com';
        
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name='emirates oils ltd';
        opp.StageName='Service Booking';
        opp.CloseDate=system.today()+5;
        opp.AccountId=acc.Id;
        
        insert opp;

        Blob testBlob = Blob.valueOf('Test PDF Content');

        // Call the method and assert the expected outcome
        Test.startTest();
        MOTO_GetEstimation.sendEstimateEmail(testBlob, opp.Id);
        Test.stopTest();

        // Add assertions based on the expected behavior of your method
        // For example, you can assert that the email was sent successfully
        // and check the debug logs for the email sending results.
    }
    
    @isTest
    Public static void WrapperPayment_TGN_TEST(){
        MOTO_GetEstimation.WrapperPayment obj = new MOTO_GetEstimation.WrapperPayment();
        
    }
    @isTest
    Public static void GetEstimationpdf(){
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        Account acc= new Account();
        acc.FirstName = 'John';
        acc.LastName = 'Doe';
        acc.PersonEmail = 'test@gmail.com';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name='emirates oils ltd test';
        opp.StageName='Service Booking';
        opp.CloseDate=system.today()+5;
        opp.AccountId=acc.Id;
        
        insert opp;
        string ServiceEtimationNo='1931859';
        
        Test.startTest();
        try
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(opp);
            MOTO_GetEstimation gtesm =new MOTO_GetEstimation(sc);
            PageReference pageRef = Page.MOTO_EstimationInvoicePdf;
            pageRef.getParameters().put('estimNo', ServiceEtimationNo);
            Test.setCurrentPage(pageRef);
        }
        catch(exception e)
        {
        }     
        Test.stopTest();
    }
    
}