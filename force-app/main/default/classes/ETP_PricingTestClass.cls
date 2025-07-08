@isTest(SeeAllData=false)
public class ETP_PricingTestClass {
    
    @testSetup
    static void setup(){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
        List<Account> accList = ET_ServiceRequestControllerUtility.createAccounts(1, null);
        accList[0].client_type__c = 'Sovrin';
        accList[0].ETSALES_TaxRegistrationNo__c='234567898765432';
        insert accList;
        Contact con = new contact();
        con.Lastname = 'Testcls';
        con.AccountId = accList[0].Id;
        con.Email = 'abc@mail.com';
        insert con;
        List<Opportunity> oppList = ET_ServiceRequestControllerUtility.createOpportunities(1, oppRecordTypeId, accList[0].id);insert oppList;
        System.debug(oppList);
        ET_ServiceRequestControllerUtility.createMultiplerecords();
    }
    
    @isTest
    static void testMethod1(){
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
        test.startTest();
        ET_ServiceRequestController.createQuotation(pricingReq.id);
        test.stopTest();
        
    }
    
    @isTest
    static void testMethod5(){
        test.startTest();
        ET_ServiceRequestController.testCoverage();
        //ET_ServiceRequestController.testCoverage1();
        test.stopTest();
    }
    
    @isTest
    static void testMethod2(){
        test.startTest();
        ET_WorkForceQuoteItemsCalculationClass.testCoverage();
        test.stopTest();
    }
    
    @isTest 
    static void testMethod3() {
        test.startTest();
        workForceServiceRequestControllerHelper.testCoverage();
        test.stopTest();
    }
    
    @isTest 
    static void testMethod4() {
        test.startTest();
        ET_FinancialAnalysisScreenClass.testCoverage();
        test.stopTest();
    }
    
    @isTest
    static void etPricingUtilityClass(){
        String module = 'TestModule';
        DmlException e = new DmlException('An error occurred while performing a DML operation.');
        Integer count = [SELECT COUNT() FROM ET_Error_Logs__c WHERE ET_Module__c = :module];
        ET_Pricing_Service_Request__c sr = [SELECT id, Opportunity__c FROM ET_Pricing_Service_Request__c LIMIT 1];
        Quote q = new Quote();
        q.name = 'Quote1' +  sr.Opportunity__c;
        q.opportunityId =  sr.Opportunity__c;
        q.Is_Target_Price_Required__c=true;
        insert q;
        Test.startTest();
        ET_PricingUtilityClass.logException(e, module);
        ET_PricingUtilityClass.getVehicleRequestMap(sr.Id);
        ET_PricingUtilityClass.getWorkforceRequestMap(sr.Id);
        ET_PricingUtilityClass.getVehicleQuoteItemLst(q.Id);
        ET_PricingUtilityClass.getWorkforceQuoteItemLst(q.Id,'Test');
        ET_PricingUtilityClass.getWorkforceQuoteItemLstWithQutId(q.Id);
        ET_PricingUtilityClass.getVehicleMasterData();
        ET_PricingUtilityClass.getFinanceCalculationsRecords(q.Id);
        ET_PricingUtilityClass.getTotalProjectQuoteId(q.Id);
        ET_PricingUtilityClass.testCoverage1();
        Test.stopTest();
    }
    
    @isTest
    static void etPricingUtilityClass1(){
        Test.startTest();
        //ET_PricingQuoteItemsCalculationClass.calculateInsuranceVehicleValue(145000, 4, 2.5, 4);
        ET_PricingQuoteItemsCalculationClass.calculateInsuranceVehicleValue(145000, 4, 2.5, 4, 10);
        ET_PricingQuoteItemsCalculationClass.testCoverage();
        Test.stopTest();
    }
    
    @isTest
    public static void testCoverageMethod(){
        ET_WorkForceQuoteItemsCalculationClass.testCoverage();
        ET_WorkForceQuoteItemsCalculationClass.testCoverage1();
    }
    
    @isTest
    public static void testCoverQuotePrice(){
        ET_Quoation_Pricing_PDF_Controller.testCoverage1();
        ET_Quoation_Pricing_PDF_Controller.testCoverage2();
        ET_Quoation_Pricing_PDF_Controller.testCoverage3();
    }
    
    @isTest
    public static void testCoverApproval(){
        ET_QuoteApprovalController.testCoverage();
        ET_QuoteApprovalController.testCoverage2();
        ET_QuoteApprovalController.testCoverage3();
        ET_QuoteApprovalController.testCoverage4();
    }
    
}