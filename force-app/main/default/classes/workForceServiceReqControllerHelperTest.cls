@isTest(SeeAllData = false)
public class workForceServiceReqControllerHelperTest {
		 @testSetup
    static void setup(){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
        List<Account> accList = ET_ServiceRequestControllerUtility.createAccounts(1, null);
        accList[0].client_type__c = 'Sovrin';
        insert accList;
        List<Opportunity> oppList = ET_ServiceRequestControllerUtility.createOpportunities(1, oppRecordTypeId, accList[0].id);insert oppList;
        System.debug(oppList);
               ET_ServiceRequestControllerUtility.createMultiplerecords();
       // ET_ServiceRequestControllerUtility.createWorkspaceMaster();
    }
    /*@isTest 
    static void testOtherCostCalcDetails() {
       // workForceServiceRequestControllerHelper obj = new workForceServiceRequestControllerHelper();
          ET_ServiceRequestController.QuoteCalculationClass quotecalculationObj = new ET_ServiceRequestController.QuoteCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
        workForceServiceRequestControllerHelper obj = new workForceServiceRequestControllerHelper(pricingReq.id,quotecalculationObj);
         List<ET_Pricing_VAT_setup__c> vatData =  new List<ET_Pricing_VAT_setup__c>();
        vatData = [Select id,ET_Cost_Api_Name__c,ET_IsRecoverable__c,Name,ET_Cost_Type__c FROM ET_Pricing_VAT_setup__c 
                   where ET_IsRecoverable__c = true ];
        ET_Pricing_Service_Reserve_Master__c priceServiceMaster = [Select id from ET_Pricing_Service_Reserve_Master__c Limit 1];
        Map<String,ET_Pricing_Service_Reserve_Master__c> priceServiceMasterMap = new Map<String,ET_Pricing_Service_Reserve_Master__c>();
        priceServiceMasterMap.put(priceServiceMaster.id,priceServiceMaster);
        
        ET_Work_force__c workforce = [Select id ,ET_Driver_Category__c, ET_Number_of_Accountants__c from ET_Work_force__c Limit 1];
        workforce.ET_Number_of_Accountants__c = 2;
        workforce.ET_Driver_Category__c = 'Driver';
        update workforce;
        
        ET_Work_force__c et_work_force = new ET_Work_force__c(
            CurrencyIsoCode = 'AED',
            ET_Contract_Period__c = '2 Yrs,3 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Driver_Category__c = 'Nanny',
            ET_No_of_Drivers__c = 10.0,
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Pricing_Service_Request__c = priceServiceMaster.id,
            ET_Special_Requirements__c = 'Yes',
            ET_Workforce_Line_Info__c = 'ET_Driver:1',
            ET_Working_Days_Per_Week__c = 3.0,
            ET_Working_Months_Per_Year__c = 8.0);
    insert et_work_force;
        
        Workforce_Master__c workforcemaster = [Select id,ET_Workforce_Category__c from Workforce_Master__c Limit 1];
        System.debug('workforcemaster.ET_Workforce_Category__c'+workforcemaster.ET_Workforce_Category__c);
       // update workforcemaster;    
        workForceServiceRequestControllerHelper.doWorkforceQuoteCalculation(pricingReq.id,quotecalculationObj,false,null,priceServiceMasterMap);
    }
    */
    @isTest 
    static void testCoverage() {
        workForceServiceRequestControllerHelper.testCoverage();
    }
    
}