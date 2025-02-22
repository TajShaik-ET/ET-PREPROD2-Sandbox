@isTest
public class ET_WorkForceQuoteItemsCalcClass_Test {

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
    public static void codeCoverage()
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
        //quoteItem.ET_Workforce_Record_Type__c = 'ET_Driver';
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
        quoteItem.ET_Vat_Rate__c = 'Exempt';
        quoteItem.ET_Reserve_Rate__c = 5;
        quoteItem.ET_Workforce_Quote_Item_Type__c = 'Accountant/Cashier';
        quoteItem.ET_Working_Months_Per_Year__c = 5;
        quoteItem.Number_of_Annual_Leave_months__c = 2;
        quoteItem.Number_of_End_of_Service_months__c = '2234';
        quoteItem.ET_Workforce_basic_salary__c = 2;
        insert quoteItem;
        
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c();
        reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        //reqMapping.ET_Driver_Unique_Id__c ='Test=>1';
        reqMapping.ET_Number_of_Drivers__c = 1;
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
        //vehicleQuote.ET_Vat_Rate__c = '5'; 
        //
          ET_Special_Workforce_Requirement__c swr = new ET_Special_Workforce_Requirement__c();
 			swr.ET_Smart_Phone_Cost_Type__c='one-time';
        swr.Work_force_Request__c = workforce.id;
        swr.Name = 'Test';
        swr.ET_Over_Time__c = 2;
        swr.ET_Smart_Phone__c = 10;
        swr.ET_Air_Tickets_Cost_Type__c = 'onetime';
        swr.ET_Air_Tickets__c = 2;
        swr.ET_Accommodation_Allowance_Type__c='onetime';
        swr.ET_Accommodation_Allowance_Type__c='onetime';
        swr.ET_Accommodation_Allowance__c = 2;
        swr.ET_Extra_Certification_Cost_Type__c = 'onetime';
        swr.ET_Extra_Certification__c = 2;
          insert swr;
        
       
        insert vehicleQuote;
        List<ET_Pricing_VAT_setup__c> vatData =  new List<ET_Pricing_VAT_setup__c>();
        vatData = [Select id,ET_Cost_Api_Name__c,ET_IsRecoverable__c,Name,ET_Cost_Type__c FROM ET_Pricing_VAT_setup__c 
                   where ET_IsRecoverable__c = true ];
        
        
      
           ET_Pricing_VAT_setup__c vat = new ET_Pricing_VAT_setup__c();
            vat.ET_Cost_Api_Name__c ='ET_Air_Tickets__c' ;
            vat.ET_IsRecoverable__c=true;
            vat.ET_Cost_Type__c='Manpower';  
            vat.Name='Air Tickets';
         insert vat; 
			vatData.add(vat);
        ET_ServiceRequestController.workforceQuoteCalcClass workforceClassObj = new ET_ServiceRequestController.workforceQuoteCalcClass();
        ET_WorkForceQuoteItemsCalculationClass.prepareWorkforceObject(quoteItem,workforceClassObj,vatData);
        
        ET_WorkForceQuoteItemsCalculationClass.prepareWorkForceObjectForTotalProject('Accountant/Cashier',q.id);
          ET_ServiceRequestController.QuoteCalculationClass quotecalculationObj = new ET_ServiceRequestController.QuoteCalculationClass();
        ET_WorkForceQuoteItemsCalculationClass.calculateWorkForceQuoteElementsWithRates(pricingReq.id,q.id,quotecalculationObj,vatData);
        
        
         //ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates(pricingReq.id,q.id,q.id);
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
        //quoteItem.ET_Workforce_Record_Type__c = 'ET_Driver';
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
        quoteItem.ET_Vat_Rate__c = '5';
        quoteItem.ET_Reserve_Rate__c = 5;
        quoteItem.ET_Workforce_Quote_Item_Type__c = 'Accountant/Cashier';
        quoteItem.ET_Working_Months_Per_Year__c = 5;
        quoteItem.Number_of_Annual_Leave_months__c = 2;
        quoteItem.Number_of_End_of_Service_months__c = '2234';
        quoteItem.ET_Workforce_basic_salary__c = 2;
        insert quoteItem;
        
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c();
        reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        //reqMapping.ET_Driver_Unique_Id__c ='Test=>1';
        reqMapping.ET_Number_of_Drivers__c = 1;
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
        //vehicleQuote.ET_Vat_Rate__c = '5'; 
        
        
          ET_Special_Workforce_Requirement__c swr = new ET_Special_Workforce_Requirement__c();
 			swr.ET_Smart_Phone_Cost_Type__c='onetime';
        swr.Work_force_Request__c = workforce.id;
        swr.Name = 'Test';
        swr.ET_Over_Time__c = 2;
        swr.ET_Smart_Phone__c = 10;
        swr.ET_Air_Tickets_Cost_Type__c = 'annualy';
        swr.ET_Air_Tickets__c = 2;
        swr.ET_Accommodation_Allowance_Type__c='annualy';
        swr.ET_Accommodation_Allowance_Type__c='annualy';
        swr.ET_Accommodation_Allowance__c = 2;
        swr.ET_Extra_Certification_Cost_Type__c = 'annualy';
        swr.ET_Extra_Certification__c = 2;
          insert swr;
        
       
        insert vehicleQuote;
        List<ET_Pricing_VAT_setup__c> vatData =  new List<ET_Pricing_VAT_setup__c>();
        vatData = [Select id,ET_Cost_Api_Name__c,ET_IsRecoverable__c,Name,ET_Cost_Type__c FROM ET_Pricing_VAT_setup__c 
                   where ET_IsRecoverable__c = true ];
        
        
      
           ET_Pricing_VAT_setup__c vat = new ET_Pricing_VAT_setup__c();
            vat.ET_Cost_Api_Name__c ='ET_Air_Tickets__c' ;
            vat.ET_IsRecoverable__c=true;
            vat.ET_Cost_Type__c='Manpower';  
            vat.Name='Air Tickets';
         insert vat; 
			vatData.add(vat);
        ET_ServiceRequestController.workforceQuoteCalcClass workforceClassObj = new ET_ServiceRequestController.workforceQuoteCalcClass();
        ET_WorkForceQuoteItemsCalculationClass.prepareWorkforceObject(quoteItem,workforceClassObj,vatData);
        
        ET_WorkForceQuoteItemsCalculationClass.prepareWorkForceObjectForTotalProject('Accountant/Cashier',q.id);
          ET_ServiceRequestController.QuoteCalculationClass quotecalculationObj = new ET_ServiceRequestController.QuoteCalculationClass();
        ET_WorkForceQuoteItemsCalculationClass.calculateWorkForceQuoteElementsWithRates(pricingReq.id,q.id,quotecalculationObj,vatData);
        
        
         //ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates(pricingReq.id,q.id,q.id);
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
        //quoteItem.ET_Workforce_Record_Type__c = 'ET_Driver';
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
        quoteItem.ET_Vat_Rate__c = '5';
        quoteItem.ET_Reserve_Rate__c = 5;
        quoteItem.ET_Workforce_Quote_Item_Type__c = 'Accountant/Cashier';
        quoteItem.ET_Working_Months_Per_Year__c = 5;
        quoteItem.Number_of_Annual_Leave_months__c = 2;
        quoteItem.Number_of_End_of_Service_months__c = '2234';
        quoteItem.ET_Workforce_basic_salary__c = 2;
        insert quoteItem;
        
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c();
        reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        //reqMapping.ET_Driver_Unique_Id__c ='Test=>1';
        reqMapping.ET_Number_of_Drivers__c = 1;
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
        //vehicleQuote.ET_Vat_Rate__c = '5'; 
        //
          ET_Special_Workforce_Requirement__c swr = new ET_Special_Workforce_Requirement__c();
 			swr.ET_Smart_Phone_Cost_Type__c='annualy';
        swr.Work_force_Request__c = workforce.id;
        swr.Name = 'Test';
        swr.ET_Over_Time__c = 2;
        swr.ET_Smart_Phone__c = 10;
        swr.ET_Air_Tickets_Cost_Type__c = 'monthly';
        swr.ET_Air_Tickets__c = 2;
        swr.ET_Accommodation_Allowance_Type__c='monthly';
        swr.ET_Accommodation_Allowance_Type__c='monthly';
        swr.ET_Accommodation_Allowance__c = 2;
        swr.ET_Extra_Certification_Cost_Type__c = 'monthly';
        swr.ET_Extra_Certification__c = 2;
          insert swr;
        
       
        insert vehicleQuote;
        List<ET_Pricing_VAT_setup__c> vatData =  new List<ET_Pricing_VAT_setup__c>();
        vatData = [Select id,ET_Cost_Api_Name__c,ET_IsRecoverable__c,Name,ET_Cost_Type__c FROM ET_Pricing_VAT_setup__c 
                   where ET_IsRecoverable__c = true ];
        
        
      
           ET_Pricing_VAT_setup__c vat = new ET_Pricing_VAT_setup__c();
            vat.ET_Cost_Api_Name__c ='ET_Air_Tickets__c' ;
            vat.ET_IsRecoverable__c=true;
            vat.ET_Cost_Type__c='Manpower';  
            vat.Name='Air Tickets';
         insert vat; 
			vatData.add(vat);
        ET_ServiceRequestController.workforceQuoteCalcClass workforceClassObj = new ET_ServiceRequestController.workforceQuoteCalcClass();
        ET_WorkForceQuoteItemsCalculationClass.prepareWorkforceObject(quoteItem,workforceClassObj,vatData);
        
        ET_WorkForceQuoteItemsCalculationClass.prepareWorkForceObjectForTotalProject('Accountant/Cashier',q.id);
          ET_ServiceRequestController.QuoteCalculationClass quotecalculationObj = new ET_ServiceRequestController.QuoteCalculationClass();
        ET_WorkForceQuoteItemsCalculationClass.calculateWorkForceQuoteElementsWithRates(pricingReq.id,q.id,quotecalculationObj,vatData);
        
        
         //ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates(pricingReq.id,q.id,q.id);
    }
    
      @isTest
     public static void codeCoverageETCoordinator()
    {
    
     ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //
        Id workforceRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName().get('ET_Coordinator').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,recordTypeId,ET_Workforce_Record_Type_Name__c,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        System.debug('reocrd type name ='+workforce.ET_Workforce_Record_Type_Name__c);
         System.debug('reocrd type name ='+workforce.recordTypeId);
        workforce.recordTypeId = workforceRecordTypeId;
        workforce.ET_Contract_Period__c = '1 Yr';
        update workforce;
         
        Quote q = [Select id from Quote Limit 1];
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Coordinator';
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
        //reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Driver_Unique_Id__c ='Test=>1'; 
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        //reqMapping.ET_Number_of_Accountants__c = 1;
        
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
     @isTest
     public static void codeCoverageETDriver()
    {
    
     ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //
        Id workforceRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName().get('ET_Driver').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,recordTypeId,ET_Workforce_Record_Type_Name__c,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        System.debug('reocrd type name ='+workforce.ET_Workforce_Record_Type_Name__c);
         System.debug('reocrd type name ='+workforce.recordTypeId);
        workforce.recordTypeId = workforceRecordTypeId;
        workforce.ET_Contract_Period__c = '1 Yr';
        update workforce;        
        Quote q = [Select id from Quote Limit 1];
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Driver';
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
        quoteItem.Salary_No_of_months_for_Driver_for_SLine__c = 10;
        insert quoteItem;
        
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c();
        //reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Driver_Unique_Id__c ='Test=>1'; 
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        //reqMapping.ET_Number_of_Accountants__c = 1;
        
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
     @isTest
     public static void codeCoverageETNanny()
    {
    
     ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //
        Id workforceRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName().get('ET_Nanny').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,recordTypeId,ET_Workforce_Record_Type_Name__c,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        System.debug('reocrd type name ='+workforce.ET_Workforce_Record_Type_Name__c);
         System.debug('reocrd type name ='+workforce.recordTypeId);
        workforce.recordTypeId = workforceRecordTypeId;
        workforce.ET_Contract_Period__c = '1 Yr';
        update workforce;        
        Quote q = [Select id from Quote Limit 1];
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Nanny';
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
        //reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Driver_Unique_Id__c ='Test=>1'; 
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        //reqMapping.ET_Number_of_Accountants__c = 1;
        
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
     @isTest
     public static void codeCoverageETSupervisor()
    {
    
     ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //
        Id workforceRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName().get('ET_Supervisor').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,recordTypeId,ET_Workforce_Record_Type_Name__c,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        System.debug('reocrd type name ='+workforce.ET_Workforce_Record_Type_Name__c);
         System.debug('reocrd type name ='+workforce.recordTypeId);
        workforce.recordTypeId = workforceRecordTypeId;
        workforce.ET_Contract_Period__c = '1 Yr';
        update workforce;
          
        Quote q = [Select id from Quote Limit 1];
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Supervisor';
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
        //reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Driver_Unique_Id__c ='Test=>1'; 
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        //reqMapping.ET_Number_of_Accountants__c = 1;
        
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
     @isTest
     public static void codeCoverageETAccountant()
    {
    
     ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //
        Id workforceRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName().get('ET_Accountant_Cashier').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,recordTypeId,ET_Workforce_Record_Type_Name__c,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        System.debug('reocrd type name ='+workforce.ET_Workforce_Record_Type_Name__c);
         System.debug('reocrd type name ='+workforce.recordTypeId);
        workforce.recordTypeId = workforceRecordTypeId;
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
        //reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Driver_Unique_Id__c ='Test=>1'; 
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        //reqMapping.ET_Number_of_Accountants__c = 1;
        
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
     @isTest
     public static void codeCoverageETOtherEmployee()
    {
    
     ET_PricingQuoteItemsCalculationClass obj = new ET_PricingQuoteItemsCalculationClass();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
      //
        Id workforceRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName().get('ET_Other_Employee').getRecordTypeId();
       ET_Work_force__c workforce = [Select id,recordTypeId,ET_Workforce_Record_Type_Name__c,ET_Contract_Period__c from ET_Work_force__c Limit 1];
        System.debug('reocrd type name ='+workforce.ET_Workforce_Record_Type_Name__c);
         System.debug('reocrd type name ='+workforce.recordTypeId);
        workforce.recordTypeId = workforceRecordTypeId;
        workforce.ET_Contract_Period__c = '1 Yr';
        update workforce;       
        Quote q = [Select id from Quote Limit 1];
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Other_Employee';
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
        //reqMapping.ET_Accountant_Unique_Key__c = 'Test=>1';
        reqMapping.ET_Driver_Unique_Id__c ='Test=>1'; 
        reqMapping.ET_Vehicle_Unique_key__c = 'Test';
        reqMapping.ET_Pricing_Service_Request__c = pricingReq.id;
        reqMapping.ET_Number_of_Vehicles__c = 2;
        //reqMapping.ET_Number_of_Accountants__c = 1;
        
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
    
    @isTest
    public static void testCoverageMethod(){
        ET_WorkForceQuoteItemsCalculationClass.testCoverage();
    }
    
    
    
}