@isTest(SeeAllData = false)
public class ET_FinancialAnalysisScreenClassTest {
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
    static void testFinancialAnalysisScreen() {
        Quote q = [Select id ,ET_Total_Investment__c,
                     Total_Number_of_Main_Vehicles__c,
                     Total_Number_of_Drivers__c,
                     Total_Number_of_Accountants__c,
                     Total_Number_of_Coordinators__c,
                     Total_Number_of_Nannies__c,
                     Total_Number_of_Other_Employees__c,
                     Total_Number_of_Supervisors__c from Quote Limit 1];
        String servReqId = [select id, ET_Pricing_Service_Request__c from Quote where id =:q.Id].ET_Pricing_Service_Request__c;
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c();
        reqMapping.ET_Pricing_Service_Request__c = servReqId;
        reqMapping.ET_Vehicle_Unique_key__c = 'Test=>1';
        reqMapping.ET_Accountant_Unique_Key__c = '1234321';
        reqMapping.ET_Coordinator_Unique_Key__c = '1234321';
        reqMapping.ET_Driver_Unique_Id__c = '1234321';
        reqMapping.ET_Nanny_Unique_Key__c = '1234321';
        reqMapping.ET_Supervisor_Unique_Key__c = '1234321';
        reqMapping.ET_Other_Employee_Unique_Key__c = '1234321';
        reqMapping.ET_Number_of_Vehicles__c = 5;
        insert reqMapping;
        Financial_Analysis__c financialAys = new Financial_Analysis__c();
        financialAys.Quote__c = q.Id;
        insert financialAys;
        ET_Vehicle_Quote_Item__c vehicalQuoteItem = new ET_Vehicle_Quote_Item__c();
        vehicalQuoteItem.ET_Quote_Item_Type__c='Vehicle';
        vehicalQuoteItem.ET_Number_of_Vehicles__c=5;
        vehicalQuoteItem.ET_Contract_Period__c=1;
        vehicalQuoteItem.Quote__c = q.ID;
        vehicalQuoteItem.ET_Total_Vehicles_Cost__c=1200;  
        vehicalQuoteItem.ET_Total_Fuel_Cost__c=1200;  
        vehicalQuoteItem.Substitutional_Vehicles_Cost_Per_Vehicle__c=1200;  
        vehicalQuoteItem.Total_Annual_Cost_Target_Prices__c=1200;  
        vehicalQuoteItem.Total_Fuel_Cost_Target_Price__c=1200;  
        vehicalQuoteItem.ET_Annual_Fuel_Profit_Value__c=1200;  
        vehicalQuoteItem.Total_Annual_Price_Target_Prices__c=1200;  
        vehicalQuoteItem.Total_Vehicles_Cost_Discounted__c=1200;  
        vehicalQuoteItem.Total_Fuel_Cost_Discounted__c=1200;  
        vehicalQuoteItem.ET_Annual_Vehicles_Profit_Value__c=1200;  
        vehicalQuoteItem.Substitutional_vehcls_profit_Per_Vehicle__c=1200;  
        vehicalQuoteItem.Vehicle_Profit_Value_Target_Price__c=1200;  
        vehicalQuoteItem.ET_Annual_Fuel_Profit_Target_Prices__c=1200;  
        vehicalQuoteItem.Fuel_Profit_Value_Discounted__c=1200;  
        vehicalQuoteItem.Discounted_Vehicle_Profit_Value_Target__c=1200;  
        insert vehicalQuoteItem;
        
        Financial_Analysis__c fc = new Financial_Analysis__c();
        fc.Quote__c = q.Id;
        fc.Line__c = 1;
        insert fc;
        
        ET_Workforce_Quote_Item__c quoteItem = new ET_Workforce_Quote_Item__c();
		quoteItem.Quote__c =q.id;
        quoteItem.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem.ET_Workforce_Line_Number__c = 1;
        quoteItem.ET_Contract_Period__c = 2;
        quoteItem.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem.ET_Number_of_Workforce__c = 2;
        quoteItem.Number_of_coverage_years_for_visa__c = 4;
        quoteItem.Total_dynamic_other_cost__c = 5;
        quoteItem.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem.Profit_Percentage_from_Master__c = 10;
        quoteItem.ET_Workforce_Quote_Item_Type__c='Driver';
        quoteItem.ET_Total_Cost__c=150.0;
        quoteItem.ET_Annual_Profit_Value__c=1500.0;
        insert quoteItem;
        
        ET_Workforce_Quote_Item__c quoteItem1 = new ET_Workforce_Quote_Item__c();
		quoteItem1.Quote__c =q.id;
        quoteItem1.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem1.ET_Workforce_Line_Number__c = 1;
        quoteItem1.ET_Contract_Period__c = 1;
        quoteItem1.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem1.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem1.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem1.ET_Number_of_Workforce__c = 2;
        quoteItem1.Number_of_coverage_years_for_visa__c = 4;
        quoteItem1.Total_dynamic_other_cost__c = 5;
        quoteItem1.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem1.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem1.Profit_Percentage_from_Master__c = 10;
        quoteItem1.ET_Workforce_Quote_Item_Type__c='Nanny';
        quoteItem1.ET_Total_Cost__c=150.0;
        quoteItem1.ET_Annual_Profit_Value__c=1500.0;
        insert quoteItem1;
        
        ET_Workforce_Quote_Item__c quoteItem2 = new ET_Workforce_Quote_Item__c();
		quoteItem2.Quote__c =q.id;
        quoteItem2.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem2.ET_Workforce_Line_Number__c = 1;
        quoteItem2.ET_Contract_Period__c = 1;
        quoteItem2.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem2.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem2.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem2.ET_Number_of_Workforce__c = 2;
        quoteItem2.Number_of_coverage_years_for_visa__c = 4;
        quoteItem2.Total_dynamic_other_cost__c = 5;
        quoteItem2.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem2.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem2.Profit_Percentage_from_Master__c = 10;
        quoteItem2.ET_Workforce_Quote_Item_Type__c='Supervisor';
        quoteItem2.ET_Total_Cost__c=150.0;
        quoteItem2.ET_Annual_Profit_Value__c=1500.0;
        insert quoteItem2;
        
        ET_Workforce_Quote_Item__c quoteItem3 = new ET_Workforce_Quote_Item__c();
		quoteItem3.Quote__c =q.id;
        quoteItem3.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem3.ET_Workforce_Line_Number__c = 1;
        quoteItem3.ET_Contract_Period__c = 1;
        quoteItem3.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem3.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem3.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem3.ET_Number_of_Workforce__c = 2;
        quoteItem3.Number_of_coverage_years_for_visa__c = 4;
        quoteItem3.Total_dynamic_other_cost__c = 5;
        quoteItem3.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem3.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem3.Profit_Percentage_from_Master__c = 10;
        quoteItem3.ET_Workforce_Quote_Item_Type__c='Coordinator';
        quoteItem3.ET_Total_Cost__c=150.0;
        quoteItem3.ET_Annual_Profit_Value__c=1500.0;
        insert quoteItem3;
        
        ET_Workforce_Quote_Item__c quoteItem4 = new ET_Workforce_Quote_Item__c();
		quoteItem4.Quote__c =q.id;
        quoteItem4.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem4.ET_Workforce_Line_Number__c = 1;
        quoteItem4.ET_Contract_Period__c = 1;
        quoteItem4.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem4.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem4.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem4.ET_Number_of_Workforce__c = 2;
        quoteItem4.Number_of_coverage_years_for_visa__c = 4;
        quoteItem4.Total_dynamic_other_cost__c = 5;
        quoteItem4.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem4.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem4.Profit_Percentage_from_Master__c = 10;
        quoteItem4.ET_Workforce_Quote_Item_Type__c='Accountant/Cashier';
        quoteItem4.ET_Total_Cost__c=150.0;
        quoteItem4.ET_Annual_Profit_Value__c=1500.0;
        insert quoteItem4;
        
        ET_Workforce_Quote_Item__c quoteItem5 = new ET_Workforce_Quote_Item__c();
		quoteItem5.Quote__c =q.id;
        quoteItem5.ET_Workforce_Record_Type__c = 'ET_Accountant_Cashier';
        quoteItem5.ET_Workforce_Line_Number__c = 1;
        quoteItem5.ET_Contract_Period__c = 1;
        quoteItem5.ET_Workforce_Gross_Salary__c = 1000;
        quoteItem5.ET_Depreciation_Method__c = 'Straight Line';
      	quoteItem5.Salary_No_of_Months_for_other_Manpower__c = 3;
        quoteItem5.ET_Number_of_Workforce__c = 2;
        quoteItem5.Number_of_coverage_years_for_visa__c = 4;
        quoteItem5.Total_dynamic_other_cost__c = 5;
        quoteItem5.ET_Total_Direct_Operational_Costs__c = 10;
        quoteItem5.ET_Workforce_Unique_Key__c = 'Test' ;
        quoteItem5.Profit_Percentage_from_Master__c = 10;
        quoteItem5.ET_Workforce_Quote_Item_Type__c='Other Employee';
        quoteItem5.ET_Total_Cost__c=150.0;
        quoteItem5.ET_Annual_Profit_Value__c=1500.0;
        insert quoteItem5;
        
        Financial_Analysis__c fa = new Financial_Analysis__c();
        fa.Quote__c=q.Id;
        insert fa;
        List<Financial_Analysis__c> fList = new List<Financial_Analysis__c>();
        Financial_Analysis__c fa1 = new Financial_Analysis__c();
        fa1.Quote__c=q.Id;
        fa1.Total_Investment__c=1000;
        fa1.Contract_Year__c=1;
        fa1.Payback_3__c=1000;
        fa1.Payback_2__c=1000;
        fa1.Payback_Ratio_3__c=1000;
        fa1.Free_Cash_Flow_Annual__c=1000;
        fa1.Resale_Value_used_for_Calculation__c=1000;
        fa1.Total_Annual_Profit_Discounted__c =1100;
        fa1.Utilization_factor__c=100;
        fa1.Total_Depreciation__c=1000;
        fa1.Total_Resale_Value__c=1000;
        fa1.Total_Driver_Profits__c=500;
        fa1.Total_Nanny_Profits__c=500;
        fa1.Total_Coordinator_Profits__c=500;
        fa1.Total_Other_Employee_Profits__c=500;
        fa1.Total_Supervisor_Profits__c=500;
        fa1.Total_Accountant_Profits__c=500;
        fa1.Total_Fuel_Profits__c=500;
        fa1.Payback_1__c=500;
        fa1.Free_Cash_Flow_Cumulative__c=500;
        fa1.Total_Manpower_profit_used_for_calcs__c=500;
        fa1.Total_Profit_used_for_calculation__c=500;
        
        fList.add(fa1);
        Financial_Analysis__c fa2 = new Financial_Analysis__c();
        fa2.Quote__c=q.Id;
        fa2.Contract_Year__c=1;
        fa2.Payback_3__c=1000;
        fa2.Payback_2__c=1000;
        fa2.Payback_Ratio_3__c=1000;
        fa2.Total_Investment__c=1000;
        fa2.Free_Cash_Flow_Annual__c=1000;
        fa2.Resale_Value_used_for_Calculation__c=1000;
        fa2.Total_Annual_Profit_Discounted__c =1100;
        fa2.Utilization_factor__c=100;
        fa2.Total_Annual_Price_including_VAT__c=1100;
        fa2.Price_Per_Month_including_VAT__c=1100;
        fa2.Total_Value_of_Rental__c=1100;
        fList.add(fa2);
        insert fList;
        Map<Integer,Financial_Analysis__c> newFinancialAnalysisMap = new Map<Integer,Financial_Analysis__c>();
        Integer i=1;
        for(Financial_Analysis__c fp:fList){
            newFinancialAnalysisMap.put(i, fp);
            i++;
        }
        String st=JSON.serialize(fList);
        Test.startTest();
        ET_FinancialAnalysisScreenClass obj = new ET_FinancialAnalysisScreenClass();
        ET_FinancialAnalysisScreenClass.intializeClassMaps();
        ET_FinancialAnalysisScreenClass.setQuoteData(q.Id);
        //ET_FinancialAnalysisScreenClass.setVehicleRelatedMapValues(vehicalQuoteItem);
        //ET_FinancialAnalysisScreenClass.financialAnalysisScreenData(q.id);
       // ET_FinancialAnalysisScreenClass.setManpowerRelatedMapValues(quoteItem,true);
        /*ET_FinancialAnalysisScreenClass.setManpowerRelatedMapValues(quoteItem1,true);
        ET_FinancialAnalysisScreenClass.setManpowerRelatedMapValues(quoteItem2,true);
        ET_FinancialAnalysisScreenClass.setManpowerRelatedMapValues(quoteItem3,true);
        ET_FinancialAnalysisScreenClass.setManpowerRelatedMapValues(quoteItem4,true);
        ET_FinancialAnalysisScreenClass.setManpowerRelatedMapValues(quoteItem5,true);*/
        ET_FinancialAnalysisScreenClass.saveFinancialCalculations(q.Id,null);
        ET_FinancialAnalysisScreenClass.calculateNetPresentValue(2000,2000,2000,2000);
        ET_FinancialAnalysisScreenClass.freeCashFlowCumulativeCalc(1,2000,2000,2000);
        ET_FinancialAnalysisScreenClass.freeCashFlowCumulativeCalc(2,2000,2000,2000);
        ET_FinancialAnalysisScreenClass.freeCashFlowCumulativeCalc(5,7000,3000,2000);
        ET_FinancialAnalysisScreenClass.doCostCalculation(fa,1, 1 , 'test', 'test', 'test', 1.0,true, false);
        ET_FinancialAnalysisScreenClass.calcualteIRR(st);
       // ET_FinancialAnalysisScreenClass.FinancialAnalysisFortotalProject(fList,q.Id);
        //ET_FinancialAnalysisScreenClass.financialAnalysisData(newFinancialAnalysisMap,'1234321',q.Id);
      Test.stopTest();
    }
    @isTest
    public static void testCoverageMethod(){
        ET_FinancialAnalysisScreenClass.testCoverage();
    }
}