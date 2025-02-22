@isTest
public class ET_PricingQuoteItemsCalcClass_Test {
@testSetup
    static void setup(){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
        List<Account> accList = ET_ServiceRequestControllerUtility.createAccounts(1, null);
        accList[0].client_type__c = 'Sovrin';
        insert accList;
        List<Opportunity> oppList = ET_ServiceRequestControllerUtility.createOpportunities(1, oppRecordTypeId, accList[0].id);insert oppList;
        System.debug(oppList);
        ET_ServiceRequestControllerUtility.createMultiplerecords();
    }
    @isTest
    public static void codeCoverage1()
    {
        ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //  Id quoteItemRecordTypeId = Schema.SObjectType.ET_Workforce_Quote_Item__c.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        
        workforce.ET_Contract_Period__c = '1 Yr';
        update workforce;
        Quote q = [Select id from Quote Limit 1];
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem.ET_Workforce_Line_Number__c = 1;
        quoteItem.ET_Contract_Period__c = 1;
        quoteItem.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem.ET_Number_of_Workforce__c = 2;
        quoteItem.Number_of_coverage_years_for_visa__c = 4;
        quoteItem.Total_dynamic_other_cost__c = 5;
        quoteItem.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem.Profit_Percentage_from_Master__c = 10;
        insert quoteItem;
        
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c();
        reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        reqMapping.ET_Number_of_Accountants__c = 1;
        
        insert reqMapping;
        
        ET_Vehicle_Quote_Item__c vehicleQuote = new ET_Vehicle_Quote_Item__c();
        vehicleQuote.Quote__c = q.id;
        vehicleQuote.ET_Quote_Item_Type__c='Vehicle';
        vehicleQuote.ET_Line_Number__c = 1;
        vehicleQuote.ET_Contract_Period__c = 1;
        vehicleQuote.ET_Depreciation_Method__c='Accelerated';
        vehicleQuote.ET_Fleet_Type__c='ET Fleet';
        vehicleQuote.ET_Depreciation_Type__c='Percentage';
        vehicleQuote.ET_Vehicle_Source__c = 'Main';
        vehicleQuote.ET_Vehicle_Current_Purchase_Price__c=3000;
        vehicleQuote.ET_Vehicle_Original_Purchase_Price__c = 2000;
        vehicleQuote.ET_Number_of_Vehicles__c = 2;
        vehicleQuote.ET_Min_Depreciation_Years__c = 2;
        vehicleQuote.ET_Vat_Rate__c = 'Exempt';
       vehicleQuote.ET_Vehicle_Maintenance_Rate__c= 1;
        vehicleQuote.ET_Total_Annual_Mileage__c = 15;
        vehicleQuote.ET_Vehicle_Depreciation_Percentage__c = 10;
        vehicleQuote.ET_Depreciation_Reserve_Rate__c = 5;
        vehicleQuote.ET_General_Reserve_Rate__c = 10;
       vehicleQuote.ET_Maintainence_Reserve_Rate__c = 10;
        vehicleQuote.ET_Fuel_Reserve_Rate__c = 5;
        vehicleQuote.ET_Vehicle_Profit_Rate_from_Master__c=5;
        insert vehicleQuote;
        
         ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates(pricingReq.id,q.id,q.id);
        Vehicle__c vehicle = [Select id,ET_Vehicle_Condition__c from Vehicle__c Limit 1];
        vehicle.ET_Vehicle_Condition__c = 'used';
        update vehicle;
         vehicleQuote.ET_Pricing_Vehicle_Request__c = vehicle.id;
        update vehicleQuote;
        ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates(pricingReq.id,q.id,q.id);
        ET_PricingQuoteItemsCalculationClass.calculateInsuranceVehicleValue(10000,2,5,2);
        ET_PricingQuoteItemsCalculationClass.updateVehicleTotalProjectSummaryVehicleQuoteItems(q.id);
         Map<String, ET_Vehicle_Quote_Item__c> vehQItemsWithIdMap = new Map<String, ET_Vehicle_Quote_Item__c>();
        vehQItemsWithIdMap.put(vehicleQuote.id,vehicleQuote);
        List<ET_ServiceRequestController.vehicleQuoteCalcClass> vehicleQuoteClassLst = new List<ET_ServiceRequestController.vehicleQuoteCalcClass>();
        ET_ServiceRequestController.vehicleQuoteCalcClass obj1 = new ET_ServiceRequestController.vehicleQuoteCalcClass ();
        obj1.vehicleQuoteId =vehicleQuote.id; 
        vehicleQuoteClassLst.add(obj1);
        ET_ServiceRequestController.QuoteCalculationClass quoteCalcObj = new ET_ServiceRequestController.QuoteCalculationClass();
        quoteCalcObj.vehicleQuoteItemLst =vehicleQuoteClassLst;
          List<ET_Pricing_VAT_setup__c> vatData =  new List<ET_Pricing_VAT_setup__c>();
        vatData = [Select id,ET_Cost_Api_Name__c,ET_IsRecoverable__c,Name,ET_Cost_Type__c FROM ET_Pricing_VAT_setup__c 
                   where ET_IsRecoverable__c = true ];
        ET_PricingQuoteItemsCalculationClass.updateQuoteLineItemsWithPricing(quoteCalcObj,vehQItemsWithIdMap,vatData,q.id);
        List<Decimal> costList = new List<Decimal>{12.12,24.23,30.21};
       // ET_PricingQuoteItemsCalculationClass.getFinalCost(costList);
        
    }
      @isTest
    public static void codeCoverage2()
    {
        ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //  Id quoteItemRecordTypeId = Schema.SObjectType.ET_Workforce_Quote_Item__c.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        
        workforce.ET_Contract_Period__c = '1 Yr';
        update workforce;
        Quote q = [Select id from Quote Limit 1];
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem.ET_Workforce_Line_Number__c = 1;
        quoteItem.ET_Contract_Period__c = 1;
        quoteItem.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem.ET_Number_of_Workforce__c = 2;
        quoteItem.Number_of_coverage_years_for_visa__c = 4;
        quoteItem.Total_dynamic_other_cost__c = 5;
        quoteItem.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem.Profit_Percentage_from_Master__c = 10;
        insert quoteItem;
        
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c();
        reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        reqMapping.ET_Number_of_Accountants__c = 1;
        
        insert reqMapping;
        
        ET_Vehicle_Quote_Item__c vehicleQuote = new ET_Vehicle_Quote_Item__c();
        vehicleQuote.Quote__c = q.id;
        vehicleQuote.ET_Quote_Item_Type__c='Vehicle';
        vehicleQuote.ET_Line_Number__c = 1;
        vehicleQuote.ET_Contract_Period__c = 1;
        vehicleQuote.ET_Depreciation_Method__c='Straight Line';
        vehicleQuote.ET_Fleet_Type__c='ET Fleet';
        vehicleQuote.ET_Depreciation_Type__c='Percentage';
        vehicleQuote.ET_Minimum_resale_value_percentage__c = 10;
        
        insert vehicleQuote;
        
           ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates(pricingReq.id,q.id,q.id);
        
    }
    
      @isTest
    public static void codeCoverage3()
    {
        ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //  Id quoteItemRecordTypeId = Schema.SObjectType.ET_Workforce_Quote_Item__c.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        
        workforce.ET_Contract_Period__c = '1 Yr';
        update workforce;
        Quote q = [Select id from Quote Limit 1];
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem.ET_Workforce_Line_Number__c = 1;
        quoteItem.ET_Contract_Period__c = 1;
        quoteItem.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem.ET_Number_of_Workforce__c = 2;
        quoteItem.Number_of_coverage_years_for_visa__c = 4;
        quoteItem.Total_dynamic_other_cost__c = 5;
        quoteItem.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem.Profit_Percentage_from_Master__c = 10;
        insert quoteItem;
        
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c();
        reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        reqMapping.ET_Number_of_Accountants__c = 1;
        
        insert reqMapping;
        
        ET_Vehicle_Quote_Item__c vehicleQuote = new ET_Vehicle_Quote_Item__c();
        vehicleQuote.Quote__c = q.id;
        vehicleQuote.ET_Quote_Item_Type__c='Vehicle';
        vehicleQuote.ET_Line_Number__c = 1;
        vehicleQuote.ET_Contract_Period__c = 1;
        vehicleQuote.ET_Depreciation_Method__c='Straight Line';
        vehicleQuote.ET_Fleet_Type__c='';
        vehicleQuote.ET_Depreciation_Type__c='Percentage';
        vehicleQuote.ET_Vehicle_Source__c = 'Main';
        vehicleQuote.ET_Vehicle_Current_Purchase_Price__c=3000;
        vehicleQuote.ET_Vehicle_Original_Purchase_Price__c = 2000;
        vehicleQuote.ET_Number_of_Vehicles__c = 2;
        vehicleQuote.ET_Min_Depreciation_Years__c = 2;      
       
        insert vehicleQuote;
        
        Vehicle__c vehicle = [Select id,ET_Vehicle_Condition__c from Vehicle__c Limit 1];
        vehicle.ET_Vehicle_Condition__c = 'used';
        update vehicle;
         vehicleQuote.ET_Pricing_Vehicle_Request__c = vehicle.id;
        update vehicleQuote;
        ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates(pricingReq.id,q.id,q.id);
        ET_PricingQuoteItemsCalculationClass.calculateInsuranceVehicleValue(10000,2,5,2);
        ET_PricingQuoteItemsCalculationClass.updateVehicleTotalProjectSummaryVehicleQuoteItems(q.id);
        
    }
    
    @isTest
    public static void codeCoverage4()
    {
        ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //  Id quoteItemRecordTypeId = Schema.SObjectType.ET_Workforce_Quote_Item__c.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        
        workforce.ET_Contract_Period__c = '1 Yr';
        update workforce;
        Quote q = [Select id from Quote Limit 1];
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem.ET_Workforce_Line_Number__c = 1;
        quoteItem.ET_Contract_Period__c = 1;
        quoteItem.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem.ET_Number_of_Workforce__c = 2;
        quoteItem.Number_of_coverage_years_for_visa__c = 4;
        quoteItem.Total_dynamic_other_cost__c = 5;
        quoteItem.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem.Profit_Percentage_from_Master__c = 10;
        insert quoteItem;
        
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c();
        reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        reqMapping.ET_Number_of_Accountants__c = 1;
        
        insert reqMapping;
        
        ET_Vehicle_Quote_Item__c vehicleQuote = new ET_Vehicle_Quote_Item__c();
        vehicleQuote.Quote__c = q.id;
        vehicleQuote.ET_Quote_Item_Type__c='Vehicle';
        vehicleQuote.ET_Line_Number__c = 1;
        vehicleQuote.ET_Contract_Period__c = 1;
        vehicleQuote.ET_Depreciation_Method__c='Accelerated';
        vehicleQuote.ET_Fleet_Type__c='ET Fleet';
        vehicleQuote.ET_Depreciation_Type__c='Value';
        vehicleQuote.ET_Vehicle_Source__c = 'Main';
        vehicleQuote.ET_Vehicle_Current_Purchase_Price__c=3000;
        vehicleQuote.ET_Vehicle_Original_Purchase_Price__c = 2000;
        vehicleQuote.ET_Number_of_Vehicles__c = 2;
        vehicleQuote.ET_Min_Depreciation_Years__c = 2;      
       
        insert vehicleQuote;
        
         ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates(pricingReq.id,q.id,q.id);
      
        
    }
}