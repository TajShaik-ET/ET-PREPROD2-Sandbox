@isTest(SeeAllData = false)
public class ET_VehicleCalcDetailsControllerTest {
    @testSetup
    static void setup(){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
        List<Account> accList = ET_ServiceRequestControllerUtility.createAccounts(1, null);
        accList[0].client_type__c = 'Sovrin';
        insert accList;
        List<Opportunity> oppList = ET_ServiceRequestControllerUtility.createOpportunities(1, oppRecordTypeId, accList[0].id);insert oppList;
        System.debug(oppList);
    }
    @isTest 
    static void testOtherCostCalcDetails() {
        List<Opportunity> oppList = [SELECT id,name FROM Opportunity ];
        Quote q = new Quote();
        q.name = 'Quote1' + oppList[0].name;
        q.opportunityId = oppList[0].id;
        q.Is_Target_Price_Required__c=true;
        insert q;
        ET_Quote_Item_SpecReq__c qItemSpecReq=new ET_Quote_Item_SpecReq__c();
        qItemSpecReq.Name='test';
        qItemSpecReq.ET_Api_Name__c='';
        qItemSpecReq.ET_Cost__c=100;
        qItemSpecReq.Quote__c=q.id;
        qItemSpecReq.Line_Item_Number__c=1;
        qItemSpecReq.Quote_Contract_Year__c=1;
        insert qItemSpecReq;
        ET_Vehicle_Quote_Item__c et_vehicle_quote_item = new ET_Vehicle_Quote_Item__c(
        CurrencyIsoCode = 'AED',
        Quote__c = q.id,
        ET_Annual_Fuel_Profit_Margin_Rate__c = 3.0,
        ET_Annual_Fuel_Profit_Value__c = 345.0,
        ET_Annual_Vehicles_Profit_Margin__c = 8.2,
        ET_Annual_Vehicles_Profit_Value__c = 2250.0,
        ET_Contract_Period__c = 1.0,
        ET_Depreciation_Reserve__c = 750.0,
        ET_Fuel_Expenses__c = 11500.0,
        ET_Fuel_Reserve__c = 575.0,
        ET_General_Reserve__c = 1504.0,
        ET_Line_Number__c = 1.0,
        ET_Maintenance_Reserve__c = 125.0,
        ET_Number_of_Vehicles__c = 10.0,
        ET_Price_Utilization__c = 1.0,
        ET_Pricing_Method__c = 'Per Unit',
        ET_Pricing_Type__c = 'Annual Price',
        ET_Quote_Item_Type__c = 'Vehicle',
        ET_Total_Fixed_Cost__c = 7560.0,
        ET_Total_Fuel_Cost__c = 12075.0,
        ET_Total_Reserve_Cost__c = 2379.0,
        ET_Total_Variable_Cost__c = 17500.0,
        ET_Total_Vehicles_Cost__c = 27439.0,
        ET_Vehicle_Depreciation__c = '15000.0',
        ET_Vehicle_Financing__c = 4500.0,
        ET_Vehicle_Insurance__c = 960.0,
         ET_Vehicle_Current_Purchase_Price__c= 50000.0,
        ET_Vehicle_Registration__c = 400.0,
        ET_Vehicle_Repairs_and_Maintenance__c = 2500.0,
        ET_Vehicle_Resale_Value__c = '35000.0',
        ET_Vehicle_Unique_key__c = 'Toyota_Yaris_GLX_2020',
        Approval_Details__c='test,test,test,test;');
        insert et_vehicle_quote_item;
        ET_Quote_Item_SpecReq__c quoteItemSpecReq=new ET_Quote_Item_SpecReq__c();
        quoteItemSpecReq.Name='Washing';
        quoteItemSpecReq.ET_Vehicle_Quote_Item__c=et_vehicle_quote_item.Id;
        quoteItemSpecReq.ET_Cost__c=100;
        insert quoteItemSpecReq;
        ET_Pricing_Service_Request__c sr = new ET_Pricing_Service_Request__c(Opportunity__c = oppList[0].Id, ET_PSR_IsActive__c = true,ET_Accountant_Pricing_Choice__c='test',
                                                                             ET_Coordinator_Pricing_Choice__c='test',ET_Supervisor_Pricing_Choice__c='test');
        insert sr;
        ET_Request_Mapping__c reqMapping=new ET_Request_Mapping__c();
        reqMapping.ET_Vehicle_Unique_key__c='test';
        reqMapping.ET_Number_of_Vehicles__c = 2;
        reqMapping.ET_Number_of_Accountants__c=2;
        reqMapping.ET_Number_of_Coordinators__c=2;
        reqMapping.ET_Number_of_Drivers__c=2;
        reqMapping.ET_Number_of_Nannies__c=2;
        reqMapping.ET_Number_of_Other_Employees__c=2;
        reqMapping.ET_Number_of_Supervisors__c=2;
        reqMapping.ET_Pricing_Service_Request__c=sr.id;
        insert reqMapping;
        q.ET_Pricing_Service_Request__c=sr.id;
        update q;
        Test.startTest();
        ET_VehicleCalcDetailsController.ET_getvehicleCalcDetails(q.Id);
      //  ET_VehicleCalcDetailsController.getCombinationTargetCostForEachVehcile(q.Id);
        ET_VehicleCalcDetailsController.getTargetPriceForCombination(q.Id);
        ET_VehicleCalcDetailsController.getReqMappingRecWrtoVehicleKey(q.Id);
        ET_VehicleCalcDetailsController.getTotalNumberOfMainVehicles(q.Id);
        ET_VehicleCalcDetailsController.getSubstitutionalVehiclesCost(q.Id,'test');
        ET_VehicleCalcDetailsController.getCombinationTargetCostForEachVehcile(q.Id,'test');
        ET_VehicleCalcDetailsController.getCombinationServicesMap(q.Id);
        Test.stopTest();
    }
}