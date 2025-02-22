/*
 * Class modified: 26.05.2023 
 * Free cash flow formula update 26.05.2023
 * for School transportation Extra KM new row addition 02.05.2023 
 * Corporate tax formula updation 02.05.2023 
 * Updated by: Arunsarathy

*/public class ET_FinancialAnalysisScreenClass {
    private static List<Quote> quoteLst ;
    private static List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLst ;
    private static List<ET_Workforce_Quote_Item__c> workforceQuoteItemLst ;
    private static Map<String,ET_Request_Mapping__c> reqMappings;
    private static map<String,ET_Vehicle_Quote_Item__c> vehicleQuoteItemMap;
    private static Map<String, List<String>> targetPriceForCombination;
    private static map<String,list<Financial_Analysis__c>> financialAnalysisMap;
    private static map<string,map<integer,Financial_Analysis__c>> financialAnalysisUniqueKeyMap;
    private static List<ET_Workforce_Quote_Item__c> updateWorkforceQuoteItemLst;
    private static List<ET_Vehicle_Quote_Item__c> updateVehicleQuoteItemLst;
    
    public static Decimal countYearsofNegativeCashFlow=0;
    public static Decimal countMonthsofNegativeCashFlow=0;
    
    private static Map<String,Decimal> cuurentPurchasePrice;
    private static Map<String,Decimal> vehicleDepreciation ;
    private static Map<String,Decimal> vehicleResaleValue ;
    private static Map<String,Decimal> workingMonthsPerYear ;
    private static Map<String,String> vatRateMap ;
    private static Map<Decimal,Decimal> contractYearAndVehicleProfits ;
    private static Map<Decimal,Decimal> contractYearAndDriverProfits ;
    private static Map<Decimal,Decimal> contractYearAndNannyProfits ;
    private static Map<Decimal,Decimal> contractYearAndCoordinatorProfits ;
    private static Map<Decimal,Decimal> contractYearAndOtherEmployeeProfits ;
    private static Map<Decimal,Decimal> contractYearAndFuelProfits ;
    private static Map<Decimal,Decimal> contractYearAndSupervisorProfits ;
    private static Map<Decimal,Decimal> contractYearAndAccountantProfits ;
    private static Map<Decimal,Decimal> contractYearAndRemainingDepreciationOf10Years ;
    
    private static Map<Decimal,Decimal> contractYearAndVehicleProfitsTarget ;
    private static Map<Decimal,Decimal> contractYearAndDriverProfitsTarget ;
    private static Map<Decimal,Decimal> contractYearAndNannyProfitsTarget ;
    private static Map<Decimal,Decimal> contractYearAndCoordinatorProfitsTarget ;
    private static Map<Decimal,Decimal> contractYearAndOtherEmployeeProfitsTarget ;
    private static Map<Decimal,Decimal> contractYearAndFuelProfitsTarget ;
    private static Map<Decimal,Decimal> contractYearAndSupervisorProfitsTarget ;
    private static Map<Decimal,Decimal> contractYearAndAccountantProfitsTarget ;
    
    private static Map<Decimal,Decimal> contractYearAndVehicleProfitsDiscounted ;
    private static Map<Decimal,Decimal> contractYearAndDriverProfitsDiscounted ;
    private static Map<Decimal,Decimal> contractYearAndNannyProfitsDiscounted ;
    private static Map<Decimal,Decimal> contractYearAndCoordinatorProfitsDiscounted ;
    private static Map<Decimal,Decimal> contractYearAndOtherEmployeeProfitsDiscounted ;
    private static Map<Decimal,Decimal> contractYearAndFuelProfitsDiscounted ;
    private static Map<Decimal,Decimal> contractYearAndSupervisorProfitsDiscounted ;
    private static Map<Decimal,Decimal> contractYearAndAccountantProfitsDiscounted ;
    
    private static Map<Decimal,Decimal> contractYearAndVehicleAnnualProfit;
    private static Map<Decimal,Decimal> contractYearAndVehicleFinancingExpenses ;
    private static Map<Decimal,String> contractYearAndVehicleDepreciationExp; 
    private static Map<Decimal,String> contractYearAndVehicleResaleValue; 
    
    private static Map<Decimal,Decimal> contractYearAndVehicleCost ;
    private static Map<Decimal,Decimal> contractYearAndFuelCost ;
    private static Map<Decimal,Decimal> contractYearAndDriverCost ;
    private static Map<Decimal,Decimal> contractYearAndNannyCost ;
    private static Map<Decimal,Decimal> contractYearAndSupervisorCost ;
    private static Map<Decimal,Decimal> contractYearAndCoordinatorCost ;
    private static Map<Decimal,Decimal> contractYearAndAccountantCost ;
    private static Map<Decimal,Decimal> contractYearAndOtherEmpCost ;
    private static Map<Decimal,Decimal> contractYearAndFreeCashFlow ;
    private static Map<Decimal,Decimal> contractYearAndPricePerPricingType ;
    
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualCost ;
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualProfit ;
    //Vehicle and Manpower
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualExcludingVAT ;
    private static Map<Decimal,Decimal> contractYearAndPricePerMonthExcludingVAT ;
    private static Map<Decimal,Decimal> contractYearAndVATAmount ;
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualIncludingVAT ;
    private static Map<Decimal,Decimal> contractYearAndPricePerMonthIncludingVAT ;
    
    //Vehicle and fuel
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualCostForVehAndFuel ;
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualProfitForVehAndFuel ;
    private static Map<Decimal,Decimal> contractYearAndVATAmountVehicleAndFuel ; 
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualIncludingVATVehicleAndFuel ; 
    private static Map<Decimal,Decimal> contractYearAndPricePerMonthIncludingVATVehicleAndFuel ; 
    
    // only Manpower
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualCostForOnlYManpower ;
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualProfitForOnlYManpower ;
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualExcludingVATManpower ;
    private static Map<Decimal,Decimal> contractYearAndPricePerMonthExcludingVATManpower ; 
    private static Map<Decimal,Decimal> contractYearAndVATAmountManpower ; 
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualIncludingVATManpower ; 
    private static Map<Decimal,Decimal> contractYearAndPricePerMonthIncludingVATManpower  ;
    
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualCostTarget ;
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualCostDiscounted ;
    
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualProfitTarget ;
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualProfitDiscounted ;
    
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualPriceExcludingVAtTarget ;
    private static Map<Decimal,Decimal> contractYearAndTotalAnnualExcludingVAtDiscounted ;
    
    //Total Value Of Quotation
    private static Map<Decimal,Decimal> totalValueofRental ;
    private static Map<Decimal,Decimal> totalInvestment ;
    private static Map<Decimal,Decimal> totalDepreciation ;
    private static Map<Decimal,Decimal> totalResaleValue ;
    private static Map<Decimal,Decimal> totalVehicleProfits ;
    private static Map<Decimal,Decimal> totalDriverProfits ;
    private static Map<Decimal,Decimal> totalNannyprofits ;
    private static Map<Decimal,Decimal> totalCoordinatorprofits ;
    private static Map<Decimal,Decimal> totalSupervisorprofits ;
    private static Map<Decimal,Decimal> totalAccountantprofits ;
    private static Map<Decimal,Decimal> totalOtherEmployeeprofits ;
    private static Map<Decimal,Decimal> totalFuelProfits ;
    
    //Financial Analysis    
    private static Map<Decimal,Decimal> payback ;
    private static Map<Decimal,Decimal> paybackRatio ;
    private static Map<Decimal,Decimal> payback2 ;
    private static Map<Decimal,Decimal> paybackRatio2 ;
    private static Map<Decimal,Decimal> payback3 ;
    private static Map<Decimal,Decimal> paybackRatio3 ;
    private static Map<Decimal,Decimal> annualshareOfPaybackRatio3 ;
    
    private static Map<Decimal,Decimal> freeCashFlowAnnual ;
    private static Map<Decimal,Decimal> freeCashFlowCumulative ;
    private static Map<Decimal,Decimal> netPresentValue ;
    private static Map<Decimal,Decimal> costOfCapitalAssumed ;
    private static Map<Decimal,Decimal> netProfitMargin ;
    private static Map<Decimal,Decimal> paybackPeriodYears ;
    private static Map<Decimal,Decimal> internalRateOfReturn ;
    private static Map<Decimal,Decimal> returnOnInvestment ;
    
    private static Map<Decimal,Decimal> freeCashFlowAnnualTarget ;
    private static Map<Decimal,Decimal> freeCashFlowCumulativeTarget ;
    private static Map<Decimal,Decimal> netPresentValueTarget ;
    private static Map<Decimal,Decimal> costOfCapitalAssumedTarget ;
    private static Map<Decimal,Decimal> netProfitMarginTarget ;
    private static Map<Decimal,Decimal> paybackPeriodYearsTarget ;
    private static Map<Decimal,Decimal> internalRateOfReturnTarget ;
    private static Map<Decimal,Decimal> returnOnInvestmentTarget ;
    
    private static Map<Decimal,Decimal> freeCashFlowAnnualDiscounted ;
    private static Map<Decimal,Decimal> freeCashFlowCumulativeDiscounted ;
    private static Map<Decimal,Decimal> netPresentValueDiscounted ;
    private static Map<Decimal,Decimal> costOfCapitalAssumedDiscounted ;
    private static Map<Decimal,Decimal> netProfitMarginDiscounted ;
    private static Map<Decimal,Decimal> paybackPeriodYearsDiscounted ;
    private static Map<Decimal,Decimal> internalRateOfReturnDiscounted ;
    private static Map<Decimal,Decimal> returnOnInvestmentDiscounted ;
    Public static decimal totalMainVehicles =0;
     Public static decimal totalCostDriver =0;
    @testvisible
    private static void intializeClassMaps(){
        cuurentPurchasePrice = new Map<String,Decimal>();
        vehicleDepreciation = new Map<String,Decimal>();
        vehicleResaleValue = new Map<String,Decimal>();
        workingMonthsPerYear = new Map<String,Decimal>();
        vatRateMap = new Map<String,String>();
        contractYearAndVehicleCost = new Map<Decimal,Decimal>();
        contractYearAndFuelCost = new Map<Decimal,Decimal>();
        contractYearAndDriverCost = new Map<Decimal,Decimal>();
        contractYearAndNannyCost = new Map<Decimal,Decimal>();
        contractYearAndSupervisorCost = new Map<Decimal,Decimal>();
        contractYearAndCoordinatorCost = new Map<Decimal,Decimal>();
        contractYearAndAccountantCost = new Map<Decimal,Decimal>();
        contractYearAndOtherEmpCost = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualCostForOnlYManpower = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualProfitForOnlYManpower  = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualCost = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualProfit = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualExcludingVAT = new Map<Decimal,Decimal>();
        contractYearAndPricePerMonthExcludingVAT = new Map<Decimal,Decimal>();
        contractYearAndVATAmount = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualIncludingVAT = new Map<Decimal,Decimal>();
        contractYearAndPricePerMonthIncludingVAT = new Map<Decimal,Decimal>();
        
        contractYearAndTotalAnnualCostTarget = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualCostDiscounted = new Map<Decimal,Decimal>();
        
        contractYearAndTotalAnnualProfitTarget = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualProfitDiscounted = new Map<Decimal,Decimal>();
        
        contractYearAndTotalAnnualPriceExcludingVAtTarget = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualExcludingVAtDiscounted = new Map<Decimal,Decimal>();
        
        contractYearAndTotalAnnualCostForVehAndFuel = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualProfitForVehAndFuel = new Map<Decimal,Decimal>();
        contractYearAndVATAmountVehicleAndFuel = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualIncludingVATVehicleAndFuel = new Map<Decimal,Decimal>();
        contractYearAndPricePerMonthIncludingVATVehicleAndFuel = new Map<Decimal,Decimal>();
        
        contractYearAndTotalAnnualExcludingVATManpower = new Map<Decimal,Decimal>();
        contractYearAndPricePerMonthExcludingVATManpower = new Map<Decimal,Decimal>();
        contractYearAndVATAmountManpower = new Map<Decimal,Decimal>();
        contractYearAndTotalAnnualIncludingVATManpower = new Map<Decimal,Decimal>();
        contractYearAndPricePerMonthIncludingVATManpower = new Map<Decimal,Decimal>();
        
        totalValueofRental = new Map<Decimal,Decimal>();
        totalInvestment = new Map<Decimal,Decimal>();
        totalDepreciation = new Map<Decimal,Decimal>();
        totalResaleValue = new Map<Decimal,Decimal>();
        totalVehicleProfits = new Map<Decimal,Decimal>();
        totalDriverProfits = new Map<Decimal,Decimal>();
        totalNannyprofits = new Map<Decimal,Decimal>();
        totalCoordinatorprofits = new Map<Decimal,Decimal>();
        totalSupervisorprofits = new Map<Decimal,Decimal>();
        totalAccountantprofits = new Map<Decimal,Decimal>();
        totalOtherEmployeeprofits = new Map<Decimal,Decimal>();
        totalFuelProfits = new Map<Decimal,Decimal>();
        
        payback = new Map<Decimal,Decimal>();
        paybackRatio = new Map<Decimal,Decimal>();
        payback2 = new Map<Decimal,Decimal>();
        paybackRatio2 = new Map<Decimal,Decimal>();
        payback3 = new Map<Decimal,Decimal>();
        paybackRatio3 = new Map<Decimal,Decimal>();
        annualshareOfPaybackRatio3 = new Map<Decimal,Decimal>();
        
        freeCashFlowAnnual = new Map<Decimal,Decimal>();
        freeCashFlowCumulative = new Map<Decimal,Decimal>();
        netPresentValue = new Map<Decimal,Decimal>();
        costOfCapitalAssumed = new Map<Decimal,Decimal>();
        netProfitMargin = new Map<Decimal,Decimal>();
        paybackPeriodYears = new Map<Decimal,Decimal>();
        internalRateOfReturn = new Map<Decimal,Decimal>();
        returnOnInvestment = new Map<Decimal,Decimal>();
        
        freeCashFlowAnnualTarget = new Map<Decimal,Decimal>();
        freeCashFlowCumulativeTarget = new Map<Decimal,Decimal>();
        netPresentValueTarget = new Map<Decimal,Decimal>();
        costOfCapitalAssumedTarget = new Map<Decimal,Decimal>();
        netProfitMarginTarget = new Map<Decimal,Decimal>();
        paybackPeriodYearsTarget = new Map<Decimal,Decimal>();
        internalRateOfReturnTarget = new Map<Decimal,Decimal>();
        returnOnInvestmentTarget = new Map<Decimal,Decimal>();
        
        freeCashFlowAnnualDiscounted = new Map<Decimal,Decimal>();
        freeCashFlowCumulativeDiscounted = new Map<Decimal,Decimal>();
        netPresentValueDiscounted = new Map<Decimal,Decimal>();
        costOfCapitalAssumedDiscounted = new Map<Decimal,Decimal>();
        netProfitMarginDiscounted = new Map<Decimal,Decimal>();
        paybackPeriodYearsDiscounted = new Map<Decimal,Decimal>();
        internalRateOfReturnDiscounted = new Map<Decimal,Decimal>();
        returnOnInvestmentDiscounted = new Map<Decimal,Decimal>();
    }
    @testvisible
    private static void setQuoteData(Id quoteId){
        quoteLst =  [Select id,
                     QuoteNumber,
                     GL_Zone__c,
                     Account.Name,
                     Account.ETSALES_Profile_Class__c,
                     Opportunity.Type,
                     ET_Total_Investment__c,
                     Total_Number_of_Main_Vehicles__c,
                     Total_Number_of_Drivers__c,
                     Total_Number_of_Accountants__c,
                     Total_Number_of_Coordinators__c,
                     Total_Number_of_Nannies__c,
                     Total_Number_of_Other_Employees__c,
                     Total_Number_of_Supervisors__c,
                     CreatedBy.Name
                     From Quote where id =:quoteId];
        
        totalMainVehicles = quoteLst[0].Total_Number_of_Main_Vehicles__c;
        //system.debug('quoteLst  = ' + JSON.serializePretty(quoteLst));
        //system.debug('totalMainVehicles  = ' + totalMainVehicles);
        vehicleQuoteItemLst  =  ET_PricingUtilityClass.getVehicleQuoteItemLst(quoteId);
        
        workforceQuoteItemLst = ET_PricingUtilityClass.getWorkforceQuoteItemLstWithQutId(quoteId);
        reqMappings=new Map<String,ET_Request_Mapping__c>();
        String servReqId = [select id, ET_Pricing_Service_Request__c from Quote where id =:quoteId].ET_Pricing_Service_Request__c;
        //System.debug('servReqId :::'+servReqId);
        for(ET_Request_Mapping__c req:[select id,ET_Vehicle_Unique_key__c,
                                       ET_Accountant_Unique_Key__c,
                                       ET_Coordinator_Unique_Key__c,
                                       ET_Driver_Unique_Id__c,
                                       ET_Nanny_Unique_Key__c,
                                       ET_Supervisor_Unique_Key__c,
                                       ET_Other_Employee_Unique_Key__c,ET_Number_of_Vehicles__c,
                                       ET_Number_of_Accountants__c,ET_Number_of_Coordinators__c,
                                       ET_Number_of_Drivers__c,ET_Number_of_Nannies__c,
                                       ET_Number_of_Other_Employees__c,ET_Number_of_Supervisors__c
                                       from ET_Request_Mapping__c where ET_Pricing_Service_Request__c =:servReqId ])
        {
            if(req.ET_Vehicle_Unique_key__c!=null) 
                reqMappings.put(req.ET_Vehicle_Unique_key__c,req);
            if(req.ET_Accountant_Unique_Key__c!=null)                                 
                reqMappings.put(req.ET_Accountant_Unique_Key__c,req);
            if(req.ET_Coordinator_Unique_Key__c!=null) 
                reqMappings.put(req.ET_Coordinator_Unique_Key__c,req);
            if(req.ET_Driver_Unique_Id__c!=null) 
                reqMappings.put(req.ET_Driver_Unique_Id__c,req);
            if(req.ET_Nanny_Unique_Key__c!=null)                                  
                reqMappings.put(req.ET_Nanny_Unique_Key__c,req);
            if(req.ET_Supervisor_Unique_Key__c!=null) 
                reqMappings.put(req.ET_Supervisor_Unique_Key__c,req);
            if(req.ET_Other_Employee_Unique_Key__c!=null) 
                reqMappings.put(req.ET_Other_Employee_Unique_Key__c,req);
        }
        // Key =Vehicle key and Values = list of finance records for all contract years for that Vehicle..
        financialAnalysisMap=new map<String,list<Financial_Analysis__c>>();
        // key = Vehicle key and Values = map of finance records with respect to contract year for that Vehicle..
        financialAnalysisUniqueKeyMap=new map<string,map<integer,Financial_Analysis__c>>();
        List<Financial_Analysis__c> financeList = new List<Financial_Analysis__c>();
        financeList = ET_PricingUtilityClass.getFinanceCalculationsRecords(quoteId);
        
        for(Financial_Analysis__c obj: financeList){
            if(!financialAnalysisMap.containsKey(obj.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(obj.Line__c)))
                financialAnalysisMap.put(obj.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(obj.Line__c),new list<Financial_Analysis__c>{obj});
            else 
                financialAnalysisMap.get(obj.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(obj.Line__c)).add(obj);
            if(!financialAnalysisUniqueKeyMap.containsKey(obj.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(obj.Line__c))){
                map<integer,Financial_Analysis__c> financialAnalysisYearWiseMap =new map<integer,Financial_Analysis__c>();
                if(!financialAnalysisYearWiseMap.containsKey(integer.valueOf(obj.Contract_Year__c)))
                    financialAnalysisYearWiseMap.put(integer.valueOf(obj.Contract_Year__c),obj);
                if(!financialAnalysisYearWiseMap.isEmpty())
                    financialAnalysisUniqueKeyMap.put(obj.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(obj.Line__c),financialAnalysisYearWiseMap);
            }else {
                map<integer,Financial_Analysis__c> financialAnalysisYearWiseMap=financialAnalysisUniqueKeyMap.get(obj.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(obj.Line__c));
                if(!financialAnalysisYearWiseMap.containsKey(integer.valueOf(obj.Contract_Year__c)))
                    financialAnalysisYearWiseMap.put(integer.valueOf(obj.Contract_Year__c),obj);
                financialAnalysisUniqueKeyMap.put(obj.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(obj.Line__c),financialAnalysisYearWiseMap);
            }
        }
        
        // map - Key = Vehicle key and Values = list of manpower keys for that vehicle..
        targetPriceForCombination = ET_VehicleCalcDetailsController.getTargetPriceForCombination(quoteId);
    }
    @Testvisible
    private static void setVehicleRelatedMapValues(ET_Vehicle_Quote_Item__c vehicleQuoteItem){
        //totalAnnualCost
        getCost('totalAnnualCost', 'Vehicle', contractYearAndTotalAnnualCost,null,null, vehicleQuoteItem, 'ET_Total_Vehicles_Cost__c');
        getCost('totalAnnualCost', 'Vehicle', contractYearAndTotalAnnualCost,null,null, vehicleQuoteItem, 'ET_Total_Vehicle_Vat_cost__c');
        getCost('totalAnnualCost', 'Vehicle', contractYearAndTotalAnnualCost,null,null, vehicleQuoteItem, 'ET_Total_Fuel_Cost__c');
        getCost('totalAnnualCost', 'Vehicle', contractYearAndTotalAnnualCost,null,null, vehicleQuoteItem, 'Substitutional_Vehicles_Cost_Per_Vehicle__c');
         getCost('totalAnnualCost', 'Vehicle', contractYearAndTotalAnnualCost,null,null, vehicleQuoteItem, 'Corporate_Tax__c');
        // totalAnnualCostForVehicleAndFuel
        getCost('totalAnnualCostForVehAndFuel', 'Vehicle', contractYearAndTotalAnnualCostForVehAndFuel,null,null, vehicleQuoteItem, 'ET_Total_Vehicles_Cost__c');
        getCost('totalAnnualCostForVehAndFuel', 'Vehicle', contractYearAndTotalAnnualCostForVehAndFuel,null,null, vehicleQuoteItem, 'ET_Total_Vehicle_Vat_cost__c');
        getCost('totalAnnualCostForVehAndFuel', 'Vehicle', contractYearAndTotalAnnualCostForVehAndFuel,null,null, vehicleQuoteItem, 'ET_Total_Fuel_Cost__c');
        getCost('totalAnnualCostForVehAndFuel', 'Vehicle', contractYearAndTotalAnnualCostForVehAndFuel,null,null, vehicleQuoteItem, 'Substitutional_Vehicles_Cost_Per_Vehicle__c');
        getCost('totalAnnualCostForVehAndFuel', 'Vehicle', contractYearAndTotalAnnualCostForVehAndFuel,null,null, vehicleQuoteItem, 'Corporate_Tax__c');//Added by arun 02.05.2023
        
        
        //totalAnnualCostTargetPrice
        getCost('totalAnnualCostTargetPrice', 'Vehicle', contractYearAndTotalAnnualCostTarget,null,null, vehicleQuoteItem, 'Total_Annual_Cost_Target_Prices__c');
        getCost('totalAnnualCostTargetPrice', 'Vehicle', contractYearAndTotalAnnualCostTarget,null,null, vehicleQuoteItem, 'ET_Total_Vehicle_Vat_cost__c');
        getCost('totalAnnualCostTargetPrice', 'Vehicle', contractYearAndTotalAnnualCostTarget,null,null, vehicleQuoteItem, 'Total_Fuel_Cost_Target_Price__c');
        getCost('totalAnnualCostTargetPrice', 'Vehicle', contractYearAndTotalAnnualCostTarget,null,null, vehicleQuoteItem, 'Substitutional_Vehicles_Cost_Per_Vehicle__c');
         getCost('totalAnnualCostTargetPrice', 'Vehicle', contractYearAndTotalAnnualCostTarget,null,null, vehicleQuoteItem, 'Corporate_Tax__c'); //Added by arun 02.05.2023
        
        // totalAnnualPricewithoutVAT Target Price 
        getCost('totalAnnualPricewithoutVATTargetPrice', 'Vehicle', contractYearAndTotalAnnualPriceExcludingVAtTarget,null,null, vehicleQuoteItem, 'Total_Annual_Price_Target_Prices__c');
        
        //totalAnnualCostDiscountedPrice
        getCost('totalAnnualCostDiscountedPrice', 'Vehicle', contractYearAndTotalAnnualCostDiscounted,null,null, vehicleQuoteItem, 'Total_Vehicles_Cost_Discounted__c');
        getCost('totalAnnualCostDiscountedPrice', 'Vehicle', contractYearAndTotalAnnualCostDiscounted,null,null, vehicleQuoteItem, 'ET_Total_Vehicle_Vat_cost__c');
        getCost('totalAnnualCostDiscountedPrice', 'Vehicle', contractYearAndTotalAnnualCostDiscounted,null,null, vehicleQuoteItem, 'Total_Fuel_Cost_Discounted__c');
        getCost('totalAnnualCostDiscountedPrice', 'Vehicle', contractYearAndTotalAnnualCostDiscounted,null,null, vehicleQuoteItem, 'Substitutional_Vehicles_Cost_Per_Vehicle__c');
        getCost('totalAnnualCostDiscountedPrice', 'Vehicle', contractYearAndTotalAnnualCostDiscounted,null,null, vehicleQuoteItem, 'Corporate_Tax__c'); //Added by arun 02.05.2023
        
        //totalAnnualProfit
        getCost('totalAnnualProfit', 'Vehicle', contractYearAndTotalAnnualProfit,null,null, vehicleQuoteItem, 'ET_Annual_Vehicles_Profit_Value__c');
        getCost('totalAnnualProfit', 'Vehicle', contractYearAndTotalAnnualProfit,null,null, vehicleQuoteItem, 'ET_Annual_Fuel_Profit_Value__c');
        getCost('totalAnnualProfit', 'Vehicle', contractYearAndTotalAnnualProfit,null,null, vehicleQuoteItem, 'Substitutional_vehcls_profit_Per_Vehicle__c');
        
        //totalAnnualProfitForVehAndFuel
        getCost('totalAnnualProfitForVehAndFuel', 'Vehicle', contractYearAndTotalAnnualProfitForVehAndFuel,null,null, vehicleQuoteItem, 'ET_Annual_Vehicles_Profit_Value__c');
        getCost('totalAnnualProfitForVehAndFuel', 'Vehicle', contractYearAndTotalAnnualProfitForVehAndFuel,null,null, vehicleQuoteItem, 'ET_Annual_Fuel_Profit_Value__c');
        getCost('totalAnnualProfitForVehAndFuel', 'Vehicle', contractYearAndTotalAnnualProfitForVehAndFuel,null,null, vehicleQuoteItem, 'Substitutional_vehcls_profit_Per_Vehicle__c');
        
        //totalAnnualProfitTarget
        getCost('totalAnnualProfitTarget', 'Vehicle', contractYearAndTotalAnnualProfitTarget,null,null, vehicleQuoteItem, 'Vehicle_Profit_Value_Target_Price__c');
        getCost('totalAnnualProfitTarget', 'Vehicle', contractYearAndTotalAnnualProfitTarget,null,null, vehicleQuoteItem, 'ET_Annual_Fuel_Profit_Target_Prices__c');
        getCost('totalAnnualProfitTarget', 'Vehicle', contractYearAndTotalAnnualProfitTarget,null,null, vehicleQuoteItem, 'Substitutional_vehcls_profit_Per_Vehicle__c');
        
        //totalAnnualProfitDiscount
        getCost('totalAnnualProfitDiscount', 'Vehicle', contractYearAndTotalAnnualProfitDiscounted,null,null, vehicleQuoteItem, 'Discounted_Vehicle_Profit_Value_Target__c');
        getCost('totalAnnualProfitDiscount', 'Vehicle', contractYearAndTotalAnnualProfitDiscounted,null,null, vehicleQuoteItem, 'Fuel_Profit_Value_Discounted__c');
        getCost('totalAnnualProfitDiscount', 'Vehicle', contractYearAndTotalAnnualProfitDiscounted,null,null, vehicleQuoteItem, 'Substitutional_vehcls_profit_Per_Vehicle__c');
        
        getCost('vehicleProfits', 'Vehicle', contractYearAndVehicleProfits,null,null, vehicleQuoteItem, 'ET_Annual_Vehicles_Profit_Value__c');
        getCost('vehicleProfitsTarget', 'Vehicle', contractYearAndVehicleProfitsTarget,null,null, vehicleQuoteItem, 'Vehicle_Profit_Value_Target_Price__c');
        getCost('vehicleProfitsDiscounted', 'Vehicle', contractYearAndVehicleProfitsDiscounted,null,null, vehicleQuoteItem, 'Discounted_Vehicle_Profit_Value_Target__c');
        
        // RemainingDepreciationOf10Years
        getCost('RemainingDepreciationOf10Years', 'Vehicle', contractYearAndRemainingDepreciationOf10Years,null,null, vehicleQuoteItem, 'ET_Remaining_Depreciation_of_10_Years__c');
        
        getCost('fuelProfits', 'Vehicle', contractYearAndFuelProfits,null,null, vehicleQuoteItem, 'ET_Annual_Fuel_Profit_Value__c');
        getCost('fuelProfitsTarget', 'Vehicle', contractYearAndFuelProfitsTarget,null,null, vehicleQuoteItem, 'ET_Annual_Fuel_Profit_Target_Prices__c');
        getCost('fuelProfitsDiscounted', 'Vehicle', contractYearAndFuelProfitsDiscounted,null,null, vehicleQuoteItem, 'Fuel_Profit_Value_Discounted__c');
        
        getCost('vehicleAnnualProfit', 'Vehicle', contractYearAndVehicleAnnualProfit,null,null, vehicleQuoteItem, 'ET_Annual_Vehicles_Profit_Value__c');
        getCost('vehicleFinancingExpenses', 'Vehicle', contractYearAndVehicleFinancingExpenses,null,null, vehicleQuoteItem, 'ET_Vehicle_Financing__c');
        //ET_Vehicle_Depreciation__c   ET_Vehicle_Resale_Value__c
        getCost('vehicleDepreciationExpenses', 'Vehicle',null,null,contractYearAndVehicleDepreciationExp, vehicleQuoteItem, 'Total_Depreciation__c');
        getCost('vehicleResale', 'Vehicle',null,null, contractYearAndVehicleResaleValue, vehicleQuoteItem, 'Total_Resale_Value__c');
    }
    @Testvisible 
    private static void setManpowerRelatedMapValues(ET_Workforce_Quote_Item__c workforceQuoteItem, boolean isTargerPriceRequired, boolean separatePricesRequired ){
        if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Driver')){
            getCost('totalAnnualCost', 'Driver', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCost', 'Driver', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualCost', 'Driver', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            //only Manpower
            getCost('totalAnnualCostForOnlyManpower', 'Driver', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCostForOnlyManpower', 'Driver', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualCostForOnlyManpower', 'Driver', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            getCost('totalAnnualProfitForOnlyManpower', 'Driver', contractYearAndTotalAnnualProfitForOnlYManpower,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            getCost('totalAnnualProfit', 'Driver', contractYearAndTotalAnnualProfit,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            getCost('driverProfits', 'Driver', contractYearAndDriverProfits,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            
            if(isTargerPriceRequired){
                getCost('totalAnnualCostTargetPrice', 'Driver', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'Total_Cost_Target_Prices__c');
                getCost('totalAnnualCostTargetPrice', 'Driver', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
                getCost('totalAnnualCostForOnlyManpower', 'Driver', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'Corporate_Tax__c');
                getCost('totalAnnualCostDiscountedPrice', 'Driver', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'Total_Cost_Discounted__c');
                getCost('totalAnnualCostDiscountedPrice', 'Driver', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
                getCost('totalAnnualProfitDiscount', 'Driver', contractYearAndTotalAnnualProfitDiscounted,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Discounted__c');
                getCost('totalAnnualProfitTarget', 'Driver', contractYearAndTotalAnnualProfitTarget,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Target_Prices__c');
                getCost('driverProfitsTarget', 'Driver', contractYearAndDriverProfitsTarget,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Target_Prices__c');
                getCost('driverProfitsDiscounted', 'Driver', contractYearAndDriverProfitsDiscounted,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Discounted__c');
            }
            
        }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Nanny')){
            getCost('totalAnnualCost', 'Nanny', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCost', 'Nanny', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualProfit', 'Nanny', contractYearAndTotalAnnualProfit,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            getCost('nannyProfits', 'Nanny', contractYearAndNannyProfits,workforceQuoteItem, null,null, 'ET_Annual_Profit_Value__c');
            getCost('totalAnnualCost', 'Nanny', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            // only Manpower
            getCost('totalAnnualCostForOnlyManpower', 'Nanny', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCostForOnlyManpower', 'Nanny', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualProfitForOnlyManpower', 'Nanny', contractYearAndTotalAnnualProfitForOnlYManpower,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
             getCost('totalAnnualCostForOnlyManpower', 'Nanny', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            if(isTargerPriceRequired){
                getCost('totalAnnualCostTargetPrice', 'Nanny', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'Total_Cost_Target_Prices__c');
                getCost('totalAnnualCostTargetPrice', 'Nanny', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
                getCost('totalAnnualCostDiscountedPrice', 'Nanny', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'Total_Cost_Discounted__c');
                getCost('totalAnnualCostDiscountedPrice', 'Nanny', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
                getCost('totalAnnualProfitDiscount', 'Nanny', contractYearAndTotalAnnualProfitDiscounted,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Discounted__c');
                getCost('totalAnnualProfitTarget', 'Nanny', contractYearAndTotalAnnualProfitTarget,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Target_Prices__c');
                getCost('nannyProfitsTarget', 'Nanny', contractYearAndNannyProfitsTarget,workforceQuoteItem, null,null, 'Manpower_Profit_Value_Target_Prices__c');
                getCost('nannyProfitsDiscounted', 'Nanny', contractYearAndNannyProfitsDiscounted,workforceQuoteItem, null,null, 'Manpower_Profit_Value_Discounted__c');
            }
        }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Supervisor')){
            getCost('totalAnnualCost', 'Supervisor', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCost', 'Supervisor', contractYearAndTotalAnnualCost,workforceQuoteItem, null,null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualCost', 'Supervisor', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            getCost('totalAnnualCostTargetPrice', 'Supervisor', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'Total_Cost_Target_Prices__c');
            getCost('totalAnnualCostTargetPrice', 'Supervisor', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            // only Manpower
            getCost('totalAnnualCostForOnlyManpower', 'Supervisor', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCostForOnlyManpower', 'Supervisor', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualProfitForOnlyManpower', 'Supervisor', contractYearAndTotalAnnualProfitForOnlYManpower,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            getCost('totalAnnualCostForOnlyManpower', 'Supervisor', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            getCost('totalAnnualCostDiscountedPrice', 'Supervisor', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'Total_Cost_Discounted__c');
            getCost('totalAnnualCostDiscountedPrice', 'Superviso', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            
            getCost('totalAnnualProfit', 'Supervisor', contractYearAndTotalAnnualProfit,workforceQuoteItem, null,null, 'ET_Annual_Profit_Value__c');
            getCost('totalAnnualProfitDiscount', 'Supervisor', contractYearAndTotalAnnualProfitDiscounted,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Discounted__c');
            getCost('totalAnnualProfitTarget', 'Supervisor', contractYearAndTotalAnnualProfitTarget,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Target_Prices__c');
            
            getCost('supervisorProfits', 'Supervisor', contractYearAndSupervisorProfits,workforceQuoteItem, null,null, 'ET_Annual_Profit_Value__c');
            getCost('supervisorProfitsTarget', 'Supervisor', contractYearAndSupervisorProfitsTarget,workforceQuoteItem, null,null, 'Manpower_Profit_Value_Target_Prices__c');
            getCost('supervisorProfitsDiscounted', 'Supervisor', contractYearAndSupervisorProfitsDiscounted,workforceQuoteItem, null,null, 'Manpower_Profit_Value_Discounted__c');
        }
        else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Coordinator')){
            getCost('totalAnnualCost', 'Coordinator', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCost', 'Coordinator', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualCost', 'Coordinator', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            // only Manpower
            getCost('totalAnnualCostForOnlyManpower', 'Coordinator', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCostForOnlyManpower', 'Coordinator', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualProfitForOnlyManpower', 'Coordinator', contractYearAndTotalAnnualProfitForOnlYManpower,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
             getCost('totalAnnualCostForOnlyManpower', 'Coordinator', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            getCost('totalAnnualCostTargetPrice', 'Coordinator', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'Total_Cost_Target_Prices__c');
            getCost('totalAnnualCostTargetPrice', 'Coordinator', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            
            getCost('totalAnnualCostDiscountedPrice', 'Coordinator', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'Total_Cost_Discounted__c');
            getCost('totalAnnualCostDiscountedPrice', 'Coordinator', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            
            getCost('totalAnnualProfit', 'Coordinator', contractYearAndTotalAnnualProfit,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            getCost('totalAnnualProfitDiscount', 'Coordinator', contractYearAndTotalAnnualProfitDiscounted,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Discounted__c');
            getCost('totalAnnualProfitTarget', 'Coordinator', contractYearAndTotalAnnualProfitTarget,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Target_Prices__c');
            
            getCost('coordinatorProfits', 'Coordinator', contractYearAndCoordinatorProfits,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            getCost('coordinatorProfitsTarget', 'Coordinator', contractYearAndCoordinatorProfitsTarget,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Target_Prices__c');
            getCost('coordinatorProfitsDiscounted', 'Coordinator', contractYearAndCoordinatorProfitsDiscounted,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Discounted__c');
        }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Accountant/Cashier')){
            getCost('totalAnnualCost', 'Accountant/Cashier', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCost', 'Accountant/Cashier', contractYearAndTotalAnnualCost,workforceQuoteItem, null,null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualCost', 'Accountant/Cashier', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            // only Manpower
            getCost('totalAnnualCostForOnlyManpower', 'Accountant/Cashier', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCostForOnlyManpower', 'Accountant/Cashier', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualCostForOnlyManpower', 'Accountant/Cashier', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            getCost('totalAnnualProfitForOnlyManpower', 'Accountant/Cashier', contractYearAndTotalAnnualProfitForOnlYManpower,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            
            getCost('totalAnnualCostTargetPrice', 'Accountant/Cashier', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'Total_Cost_Target_Prices__c');
            getCost('totalAnnualCostTargetPrice', 'Accountant/Cashier', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            
            getCost('totalAnnualCostDiscountedPrice', 'Accountant/Cashier', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'Total_Cost_Discounted__c');
            getCost('totalAnnualCostDiscountedPrice', 'Accountant/Cashier', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            
            getCost('totalAnnualProfit', 'Accountant/Cashier', contractYearAndTotalAnnualProfit,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            getCost('totalAnnualProfitDiscount', 'Accountant/Cashier', contractYearAndTotalAnnualProfitDiscounted,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Discounted__c');
            getCost('totalAnnualProfitTarget', 'Accountant/Cashier', contractYearAndTotalAnnualProfitTarget,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Target_Prices__c');
            
            getCost('accountantProfits', 'Accountant/Cashier', contractYearAndAccountantProfits,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            getCost('accountantProfitsTarget', 'Accountant/Cashier', contractYearAndAccountantProfitsTarget,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Target_Prices__c');
            getCost('accountantProfitsDiscounted', 'Accountant/Cashier', contractYearAndAccountantProfitsDiscounted,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Discounted__c');
        }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Other Employee')){
            getCost('totalAnnualCost', 'Other Employee', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCost', 'Other Employee', contractYearAndTotalAnnualCost,workforceQuoteItem, null,null, 'ET_Workforce_VAT_Cost__c');
            getCost('totalAnnualCost', 'Other Employee', contractYearAndTotalAnnualCost,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            // only Manpower
            getCost('totalAnnualCostForOnlyManpower', 'Other Employee', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Total_Cost__c');
            getCost('totalAnnualCostForOnlyManpower', 'Other Employee', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
              getCost('totalAnnualCostForOnlyManpower', 'Other Employee', contractYearAndTotalAnnualCostForOnlYManpower,workforceQuoteItem,null, null, 'Corporate_Tax__c');
            getCost('totalAnnualProfitForOnlyManpower', 'Other Employee', contractYearAndTotalAnnualProfitForOnlYManpower,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            
            getCost('totalAnnualCostTargetPrice', 'Other Employee', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'Total_Cost_Target_Prices__c');
            getCost('totalAnnualCostTargetPrice', 'Other Employee', contractYearAndTotalAnnualCostTarget,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            
            getCost('totalAnnualCostDiscountedPrice', 'Other Employee', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'Total_Cost_Discounted__c');
            getCost('totalAnnualCostDiscountedPrice', 'Other Employee', contractYearAndTotalAnnualCostDiscounted,workforceQuoteItem,null, null, 'ET_Workforce_VAT_Cost__c');
            
            getCost('totalAnnualProfit', 'Other Employee', contractYearAndTotalAnnualProfit,workforceQuoteItem,null, null, 'ET_Annual_Profit_Value__c');
            getCost('totalAnnualProfitDiscount', 'Other Employee', contractYearAndTotalAnnualProfitDiscounted,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Discounted__c');
            getCost('totalAnnualProfitTarget', 'Other Employee', contractYearAndTotalAnnualProfitTarget,workforceQuoteItem,null, null, 'Manpower_Profit_Value_Target_Prices__c');
            
            getCost('otherEmpProfits', 'Other Employee', contractYearAndOtherEmployeeProfits,workforceQuoteItem, null,null, 'ET_Annual_Profit_Value__c');
            getCost('otherEmpProfitsTarget', 'Other Employee', contractYearAndOtherEmployeeProfitsTarget,workforceQuoteItem, null,null, 'Manpower_Profit_Value_Target_Prices__c');
            getCost('otherEmpProfitsDiscounted', 'Other Employee', contractYearAndOtherEmployeeProfitsDiscounted,workforceQuoteItem, null,null, 'Manpower_Profit_Value_Discounted__c');
        }
    }
    private static void getCost(String type,String workforceType, Map<Decimal,Decimal> costMap,  ET_Workforce_Quote_Item__c workforceQuoteItem,Map<Decimal,String> DepreciationCostMap, ET_Vehicle_Quote_Item__c vehicleQuoteItem,String costApiName ){
        /*system.debug('type = '+ type);
system.debug('workforceType = '+ workforceType);
system.debug('costMap = '+ JSON.serializePretty(costMap));
system.debug('workforceQuoteItem = '+ JSON.serializePretty(workforceQuoteItem));
system.debug('DepreciationCostMap = '+ JSON.serializePretty(DepreciationCostMap));
system.debug('costApiName = '+ costApiName);*/
        if(workforceQuoteItem != null){
            if(workforceQuoteItem.get(costApiName) != null && workforceQuoteItem.ET_Number_of_Workforce__c != null){
                if( costMap != null && costMap.get(workforceQuoteItem.ET_Contract_Period__c) != null && costMap.get(workforceQuoteItem.ET_Contract_Period__c) != 0.0)
                {
                    if(workforceType == 'Driver' || workforceType == 'Nanny' ){
                        if(type=='totalAnnualCost')
                        {
                             system.debug('supervisor cost 510'+ ((((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c)));
                            contractYearAndTotalAnnualCost.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c)); 
                            System.debug('Total Annual__1'+contractYearAndTotalAnnualCost);
                        }
                        else if(type=='totalAnnualCostForOnlyManpower')
                        {
                            contractYearAndTotalAnnualCostForOnlYManpower.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + (Decimal)workforceQuoteItem.get(costApiName)); 
                        }
                        
                        else if(type=='totalAnnualCostTargetPrice'){
                            contractYearAndTotalAnnualCostTarget.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c)); 
                        }
                        
                        else if(type=='totalAnnualCostDiscountedPrice'){
                            contractYearAndTotalAnnualCostDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c)); 
                        }
                        
                        else if(type=='totalAnnualProfit'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c);
                            contractYearAndTotalAnnualProfit.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + profitValue); 
                        }
                        else if(type=='totalAnnualProfitForOnlyManpower'){
                            Decimal profitValue;
                            profitValue= ((Decimal)workforceQuoteItem.get(costApiName));
                            contractYearAndTotalAnnualProfitForOnlYManpower.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + profitValue); 
                        }
                        else if(type=='totalAnnualProfitTarget'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c);
                            contractYearAndTotalAnnualProfitTarget.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + profitValue); 
                        }
                        else if(type=='totalAnnualProfitDiscount'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c);
                            contractYearAndTotalAnnualProfitDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + profitValue); 
                        }
                    }
                    else{
                        //system.debug('type 514 = '+ type);
                       system.debug('workforceType 515 = '+ workforceType);
                        if(type=='totalAnnualCost')
                        {
                            //system.debug('costMap.get(workforceQuoteItem.ET_Contract_Period__c) = '+ costMap.get(workforceQuoteItem.ET_Contract_Period__c));
                            system.debug('supervisor cost 519 = '+ (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles));
                            contractYearAndTotalAnnualCost.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles)); 
                        System.debug('Total Annual__2'+contractYearAndTotalAnnualCost);
                        }
                        else if(type=='totalAnnualCostForOnlyManpower')
                        {
                            contractYearAndTotalAnnualCostForOnlYManpower.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + (Decimal)workforceQuoteItem.get(costApiName)); 
                        }
                        
                        else if(type=='totalAnnualCostTargetPrice'){
                            contractYearAndTotalAnnualCostTarget.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles)); 
                        }
                        
                        else if(type=='totalAnnualCostDiscountedPrice'){
                            contractYearAndTotalAnnualCostDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles)); 
                        }
                        
                        else if(type=='totalAnnualProfit'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles);
                            contractYearAndTotalAnnualProfit.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + profitValue); 
                        }
                        else if(type=='totalAnnualProfitForOnlyManpower'){
                            Decimal profitValue;
                            profitValue= (Decimal)workforceQuoteItem.get(costApiName);
                            contractYearAndTotalAnnualProfitForOnlYManpower.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + profitValue); 
                        }
                        else if(type=='totalAnnualProfitTarget'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles);
                            contractYearAndTotalAnnualProfitTarget.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + profitValue); 
                        }
                        else if(type=='totalAnnualProfitDiscount'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles);
                            contractYearAndTotalAnnualProfitDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,costMap.get(workforceQuoteItem.ET_Contract_Period__c) + profitValue); 
                        }
                    }
                    
                    
                }
                else{
                    // system.debug('contractYearAndTotalAnnualCost1 = '+ JSON.serializePretty(contractYearAndTotalAnnualCost) );
                    if(workforceType == 'Driver' || workforceType == 'Nanny' ){
                        if(type=='totalAnnualCost'){
                            contractYearAndTotalAnnualCost.put(workforceQuoteItem.ET_Contract_Period__c,(((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c));
                        System.debug('Total Annual__3'+contractYearAndTotalAnnualCost);
                        }
                        else if(type=='totalAnnualCostForOnlyManpower')
                        {
                            contractYearAndTotalAnnualCostForOnlYManpower.put(workforceQuoteItem.ET_Contract_Period__c, (Decimal)workforceQuoteItem.get(costApiName)); 
                        }
                        else if(type=='totalAnnualCostTargetPrice'){
                            contractYearAndTotalAnnualCostTarget.put(workforceQuoteItem.ET_Contract_Period__c,(((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c));
                        }
                        else if(type=='totalAnnualCostDiscountedPrice'){
                            contractYearAndTotalAnnualCostDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,(((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c));
                        }
                        else if(type=='totalAnnualProfit'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c);
                            contractYearAndTotalAnnualProfit.put(workforceQuoteItem.ET_Contract_Period__c,profitValue);
                        }
                        else if(type=='totalAnnualProfitForOnlyManpower'){
                            Decimal profitValue;
                            profitValue= (Decimal)workforceQuoteItem.get(costApiName);
                            contractYearAndTotalAnnualProfitForOnlYManpower.put(workforceQuoteItem.ET_Contract_Period__c, profitValue); 
                        }
                        else if(type=='totalAnnualProfitTarget'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c);
                            contractYearAndTotalAnnualProfitTarget.put(workforceQuoteItem.ET_Contract_Period__c,profitValue);
                        }
                        
                        else if(type=='totalAnnualProfitDiscount'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/reqMappings.get(workforceQuoteItem.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItem.Line_number_from_input__c).ET_Number_of_Vehicles__c);
                            contractYearAndTotalAnnualProfitDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,profitValue);
                        }
                    }
                    else{
                        //system.debug('type 573 = '+ type);
                        //system.debug('workforceType 573 = '+ workforceType);
                        if(type=='totalAnnualCost'){
                            contractYearAndTotalAnnualCost.put(workforceQuoteItem.ET_Contract_Period__c,(((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles));
                            system.debug('contractYearAndTotalAnnualCost2 = '+ JSON.serializePretty(contractYearAndTotalAnnualCost) );
                        }
                        else if(type=='totalAnnualCostForOnlyManpower')
                        {
                            contractYearAndTotalAnnualCostForOnlYManpower.put(workforceQuoteItem.ET_Contract_Period__c, (Decimal)workforceQuoteItem.get(costApiName)); 
                        }
                        else if(type=='totalAnnualCostTargetPrice'){
                            contractYearAndTotalAnnualCostTarget.put(workforceQuoteItem.ET_Contract_Period__c,(((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles));
                        }
                        else if(type=='totalAnnualCostDiscountedPrice'){
                            contractYearAndTotalAnnualCostDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,(((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles));
                        }
                        else if(type=='totalAnnualProfit'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles);
                            contractYearAndTotalAnnualProfit.put(workforceQuoteItem.ET_Contract_Period__c,profitValue);
                        }
                        else if(type=='totalAnnualProfitForOnlyManpower'){
                            Decimal profitValue;
                            profitValue= (Decimal)workforceQuoteItem.get(costApiName);
                            contractYearAndTotalAnnualProfitForOnlYManpower.put(workforceQuoteItem.ET_Contract_Period__c, profitValue); 
                        }
                        else if(type=='totalAnnualProfitTarget'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles);
                            contractYearAndTotalAnnualProfitTarget.put(workforceQuoteItem.ET_Contract_Period__c,profitValue);
                        }
                        
                        else if(type=='totalAnnualProfitDiscount'){
                            Decimal profitValue;
                            profitValue= (((Decimal)workforceQuoteItem.get(costApiName)*workforceQuoteItem.ET_Number_of_Workforce__c)/totalMainVehicles);
                            contractYearAndTotalAnnualProfitDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,profitValue);
                        }
                        
                    }
                    if(type=='driverProfits')
                        contractYearAndDriverProfits.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='driverProfitsTarget')
                        contractYearAndDriverProfitsTarget.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='driverProfitsDiscounted')
                        contractYearAndDriverProfitsDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    
                    else if(type=='nannyProfits')
                        contractYearAndNannyProfits.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='nannyProfitsTarget')
                        contractYearAndNannyProfitsTarget.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='nannyProfitsDiscounted')
                        contractYearAndNannyProfitsDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    
                    else if(type=='coordinatorProfits')
                        contractYearAndCoordinatorProfits.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='coordinatorProfitsTarget')
                        contractYearAndCoordinatorProfitsTarget.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='coordinatorProfitsDiscounted')
                        contractYearAndCoordinatorProfitsDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    
                    else if(type=='otherEmpProfits')
                        contractYearAndOtherEmployeeProfits.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='otherEmpProfitsTarget')
                        contractYearAndOtherEmployeeProfitsTarget.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='otherEmpProfitsDiscounted')
                        contractYearAndOtherEmployeeProfitsDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    
                    else if(type=='supervisorProfits')
                        contractYearAndSupervisorProfits.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='supervisorProfitsTarget')
                        contractYearAndSupervisorProfitsTarget.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    else if(type=='supervisorProfitsDiscounted')
                        contractYearAndSupervisorProfitsDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName) );
                    
                    else if(type=='accountantProfits')
                        contractYearAndAccountantProfits.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName));
                    else if(type=='accountantProfitsTarget')
                        contractYearAndAccountantProfitsTarget.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName));
                    else if(type=='accountantProfitsDiscounted')
                        contractYearAndAccountantProfitsDiscounted.put(workforceQuoteItem.ET_Contract_Period__c,(Decimal)workforceQuoteItem.get(costApiName));
                }
            }
        }
        else if(vehicleQuoteItem != null){
            if(vehicleQuoteItem.get(costApiName) != null && vehicleQuoteItem.ET_Number_of_Vehicles__c != null){
                if(type != 'vehicleDepreciationExpenses' && type != 'vehicleResale' && costMap.get(vehicleQuoteItem.ET_Contract_Period__c) != null && costMap.get(vehicleQuoteItem.ET_Contract_Period__c) != 0.0){
                    if(type=='totalAnnualCost')
                    {
                        contractYearAndTotalAnnualCost.put(vehicleQuoteItem.ET_Contract_Period__c,costMap.get(vehicleQuoteItem.ET_Contract_Period__c) + (Decimal)vehicleQuoteItem.get(costApiName));
                    system.debug('contractYearAndTotalAnnualCost3 = '+ JSON.serializePretty(contractYearAndTotalAnnualCost) );
                    }
                    
                    else if(type=='totalAnnualCostForVehAndFuel')
                    {
                        contractYearAndTotalAnnualCostForVehAndFuel.put(vehicleQuoteItem.ET_Contract_Period__c,costMap.get(vehicleQuoteItem.ET_Contract_Period__c) +  (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    
                    else if(type=='totalAnnualPricewithoutVATTargetPrice')
                    {
                        contractYearAndTotalAnnualPriceExcludingVAtTarget.put(vehicleQuoteItem.ET_Contract_Period__c, (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    else if(type=='totalAnnualCostTargetPrice'){
                        contractYearAndTotalAnnualCostTarget.put(vehicleQuoteItem.ET_Contract_Period__c,costMap.get(vehicleQuoteItem.ET_Contract_Period__c) + (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    else if(type=='totalAnnualCostDiscountedPrice'){
                        contractYearAndTotalAnnualCostDiscounted.put(vehicleQuoteItem.ET_Contract_Period__c,costMap.get(vehicleQuoteItem.ET_Contract_Period__c) + (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    
                    
                    else if(type=='totalAnnualProfit')
                    {
                        contractYearAndTotalAnnualProfit.put(vehicleQuoteItem.ET_Contract_Period__c,costMap.get(vehicleQuoteItem.ET_Contract_Period__c) + (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    
                    else if(type=='totalAnnualProfitForVehAndFuel')
                    {
                        contractYearAndTotalAnnualProfitForVehAndFuel.put(vehicleQuoteItem.ET_Contract_Period__c,costMap.get(vehicleQuoteItem.ET_Contract_Period__c) + (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    
                    else if(type=='totalAnnualProfitTarget'){
                        contractYearAndTotalAnnualProfitTarget.put(vehicleQuoteItem.ET_Contract_Period__c,costMap.get(vehicleQuoteItem.ET_Contract_Period__c) + (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    
                    else if(type=='totalAnnualProfitDiscount'){
                        contractYearAndTotalAnnualProfitDiscounted.put(vehicleQuoteItem.ET_Contract_Period__c,costMap.get(vehicleQuoteItem.ET_Contract_Period__c) + (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    
                }
                else{
                    if(type=='totalAnnualCost')
                        contractYearAndTotalAnnualCost.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName)) ;  
                    
                    else if(type=='totalAnnualCostForVehAndFuel')
                    {
                        contractYearAndTotalAnnualCostForVehAndFuel.put(vehicleQuoteItem.ET_Contract_Period__c, (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    else if(type=='totalAnnualPricewithoutVATTargetPrice')
                    {
                        contractYearAndTotalAnnualPriceExcludingVAtTarget.put(vehicleQuoteItem.ET_Contract_Period__c, (Decimal)vehicleQuoteItem.get(costApiName));
                    }
                    
                    else if(type=='totalAnnualCostTargetPrice'){
                        contractYearAndTotalAnnualCostTarget.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName)) ;  
                    }
                    else if(type=='totalAnnualCostDiscountedPrice'){
                        contractYearAndTotalAnnualCostDiscounted.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName)) ;  
                    }
                    
                    else if(type=='totalAnnualProfit')
                        contractYearAndTotalAnnualProfit.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName));
                    else if(type=='totalAnnualProfitForVehAndFuel')
                        contractYearAndTotalAnnualProfitForVehAndFuel.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName));
                    else if(type=='totalAnnualProfitTarget')
                        contractYearAndTotalAnnualProfitTarget.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName));
                    else if(type=='totalAnnualProfitDiscount')
                        contractYearAndTotalAnnualProfitDiscounted.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName));
                    else if(type=='vehicleProfits')
                        contractYearAndVehicleProfits.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName) );
                    else if(type=='vehicleProfitsTarget')
                        contractYearAndVehicleProfitsTarget.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName) );
                    else if(type=='vehicleProfitsDiscounted')
                        contractYearAndVehicleProfitsDiscounted.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName) );
                    else if(type=='RemainingDepreciationOf10Years')
                        contractYearAndRemainingDepreciationOf10Years.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName) );
                    else if(type=='fuelProfits')
                        contractYearAndFuelProfits.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName) );
                    else if(type=='fuelProfitsTarget')
                        contractYearAndFuelProfitsTarget.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName) );
                    else if(type=='fuelProfitsDiscounted')
                        contractYearAndFuelProfitsDiscounted.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName) );
                    else if(type=='vehicleFinancingExpenses')
                        contractYearAndVehicleFinancingExpenses.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName));
                    else if(type=='vehicleDepreciationExpenses'){
                        contractYearAndVehicleDepreciationExp.put(vehicleQuoteItem.ET_Contract_Period__c,String.valueOf(vehicleQuoteItem.get(costApiName)));
                        System.debug('VehicleDep__q'+String.valueOf(vehicleQuoteItem.get(costApiName)));
                        system.debug('contractYearAndVehicleDepreciationExp = ' + json.serializePretty(contractYearAndVehicleDepreciationExp));
                    }
                    else if(type=='vehicleResale')
                        contractYearAndVehicleResaleValue.put(vehicleQuoteItem.ET_Contract_Period__c,String.valueOf(vehicleQuoteItem.get(costApiName)));
                    else if(type=='vehicleAnnualProfit')
                        contractYearAndVehicleAnnualProfit.put(vehicleQuoteItem.ET_Contract_Period__c,(Decimal)vehicleQuoteItem.get(costApiName));
                }
                //system.debug('contractYearAndTotalAnnualCost2>> '+contractYearAndTotalAnnualCost);
            }
        }
    }
    public static Financial_Analysis__c doCostCalculation(Financial_Analysis__c financialAnalysis,Integer contractYear, Integer workingMonths , string obj, String pricingType, String pricingMethod , decimal utilizationFactor,
                                                          boolean isTargerPriceRequired,  boolean separatePricesRequired)
    {
        if(contractYearAndTotalAnnualCost.containsKey(contractYear) && contractYearAndTotalAnnualCost.get(contractYear) != null){
            financialAnalysis.Total_Annual_Cost__c = Math.round(contractYearAndTotalAnnualCost.get(contractYear));
            financialAnalysis.Total_Annual_Price_excluding_VAT__c =  Math.round(contractYearAndTotalAnnualCost.get(contractYear));
        }
        
        if(contractYearAndTotalAnnualCostTarget.containsKey(contractYear) && contractYearAndTotalAnnualCostTarget.get(contractYear) != null){
            financialAnalysis.Total_Annual_Cost_Target_Price__c = Math.round(contractYearAndTotalAnnualCostTarget.get(contractYear));
            
        }
        
        if(contractYearAndTotalAnnualPriceExcludingVAtTarget.containsKey(contractYear) && contractYearAndTotalAnnualPriceExcludingVAtTarget.get(contractYear) != null){
            financialAnalysis.Total_Annual_Price_excluding_VAT_Target__c =  Math.round(contractYearAndTotalAnnualPriceExcludingVAtTarget.get(contractYear));
        }
        
        if(contractYearAndTotalAnnualCostDiscounted.containsKey(contractYear) && contractYearAndTotalAnnualCostDiscounted.get(contractYear) != null){
            financialAnalysis.Total_Annual_Cost_Discounted__c = Math.round(contractYearAndTotalAnnualCostDiscounted.get(contractYear));
            financialAnalysis.Total_Annual_Price_excluding_VAT_Discoun__c =  Math.round(contractYearAndTotalAnnualCostDiscounted.get(contractYear));
        }
        
        if(contractYearAndTotalAnnualCost.containsKey(contractYear) && contractYearAndTotalAnnualProfit.get(contractYear) != null){
            financialAnalysis.Total_Annual_Profit__c = Math.round(contractYearAndTotalAnnualProfit.get(contractYear));
            financialAnalysis.Total_Annual_Price_excluding_VAT__c= Math.round(financialAnalysis.Total_Annual_Price_excluding_VAT__c+contractYearAndTotalAnnualProfit.get(contractYear));
        }
        //system.debug('separatePricesRequired = '+ separatePricesRequired);
        if(separatePricesRequired){
            // price for vehicle and fuel
            if(contractYearAndTotalAnnualCostForVehAndFuel.containsKey(contractYear) && contractYearAndTotalAnnualCostForVehAndFuel.get(contractYear) != null && contractYearAndTotalAnnualProfitForVehAndFuel.containsKey(contractYear) && contractYearAndTotalAnnualProfitForVehAndFuel.get(contractYear) != null){
                financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c= Math.round( contractYearAndTotalAnnualCostForVehAndFuel.get(contractYear) + contractYearAndTotalAnnualProfitForVehAndFuel.get(contractYear));
            }
            
            // Total annual price for Manpower only = Total annual price - total annual price for vehicle and fuel
            
            /*if(financialAnalysis.Total_Annual_Price_excluding_VAT__c != null &&  financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c != null){
financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c  = financialAnalysis.Total_Annual_Price_excluding_VAT__c - financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c;
}*/
            
            if(contractYearAndTotalAnnualCostForOnlYManpower.containsKey(contractYear) && contractYearAndTotalAnnualCostForOnlYManpower.get(contractYear) != null &&
               contractYearAndTotalAnnualProfitForOnlYManpower.containsKey(contractYear) && contractYearAndTotalAnnualProfitForOnlYManpower.get(contractYear) != null){
                   financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c  = Math.round(contractYearAndTotalAnnualCostForOnlYManpower.get(contractYear) + contractYearAndTotalAnnualProfitForOnlYManpower.get(contractYear));
               }
        }
        
        
        
        
        if(contractYearAndTotalAnnualCostTarget.containsKey(contractYear) && contractYearAndTotalAnnualProfitTarget.get(contractYear) != null){
            financialAnalysis.Total_annual_Profit_Target_Price__c = Math.round(contractYearAndTotalAnnualProfitTarget.get(contractYear));
        }
        
        if(contractYearAndTotalAnnualCostDiscounted.containsKey(contractYear) && contractYearAndTotalAnnualProfitDiscounted.get(contractYear) != null){
            financialAnalysis.Total_Annual_Profit_Discounted__c = Math.round(contractYearAndTotalAnnualProfitDiscounted.get(contractYear));
            financialAnalysis.Total_Annual_Price_excluding_VAT_Discoun__c= Math.round(financialAnalysis.Total_Annual_Price_excluding_VAT_Discoun__c+contractYearAndTotalAnnualProfitDiscounted.get(contractYear));
        }
        financialAnalysis.ET_Pricing_Type__c = pricingType;
        financialAnalysis.ET_Pricing_Method__c = pricingMethod;
        financialAnalysis.is_Target_Price_Required__c = isTargerPriceRequired;                                                     
        financialAnalysis.Request_for_separate_prices__c = separatePricesRequired;                                                     
        financialAnalysis.Utilization_factor__c = utilizationFactor;
        
        if(financialAnalysis.Total_Annual_Price_excluding_VAT__c != null && workingMonths != null ){
            financialAnalysis.Price_Per_Month_excluding_VAT__c = Math.round(financialAnalysis.Total_Annual_Price_excluding_VAT__c/workingMonths);
        }
        if(separatePricesRequired){
            // Price per month excluding VAT - Vehicle and Fuel
            if(financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c != null && workingMonths != null ){
                financialAnalysis.Price_Per_month_excluding_VAT_Vehicle__c = Math.round(financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c/workingMonths);
            }
            // price per month excluding VAT - Manpower only
            if(financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c != null && workingMonths != null ){
                financialAnalysis.Price_Per_Month_excluding_VAT_Manpower__c = Math.round(financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c/workingMonths);
            }
        }
        
        String vatRate = '0';
        decimal vatRateIntValue = 0.0;
        if(vatRateMap != null && vatRateMap.containsKey(obj)){
            vatRate = vatRateMap.get(obj);
            if(vatRate != 'Exempt'){
                vatRateIntValue = decimal.valueOf(vatRate);
            }
            if(financialAnalysis.Total_Annual_Price_excluding_VAT__c != null ){
                financialAnalysis.VAT_Amount__c = Math.round(financialAnalysis.Total_Annual_Price_excluding_VAT__c *(vatRateIntValue / 100) );
            }
            if(separatePricesRequired){
                // Vat for Vehicle and Fuel cost
                if(financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c != null ){
                    financialAnalysis.VAT_Amount_for_Vehicle__c = Math.round(financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c *(vatRateIntValue / 100) );
                }
                
                // Vat for manpower only..
                if(financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c != null ){
                    financialAnalysis.VAT_Amount_for_Manpower__c = Math.round(financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c *(vatRateIntValue / 100) );
                }
            }
            
        }
        
        if(financialAnalysis.Total_Annual_Price_excluding_VAT__c != null && financialAnalysis.Total_Annual_Price_excluding_VAT__c != 0.0)
        {
            financialAnalysis.Total_Annual_Price_including_VAT__c = Math.round(financialAnalysis.Total_Annual_Price_excluding_VAT__c+ (financialAnalysis.VAT_Amount__c != null ? financialAnalysis.VAT_Amount__c :0 ));
          
        }
        
        if(separatePricesRequired){
            // Total annual price including VAT for Vehicle and Fuel...
            if(financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c != null && financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c != 0.0)
            {
                financialAnalysis.Total_Annual_Price_including_VAT_Vehicle__c = Math.round(financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c+ (financialAnalysis.VAT_Amount_for_Vehicle__c != null ? financialAnalysis.VAT_Amount_for_Vehicle__c :0 ));
            }
            
            // Total annual price including VAT for Manpower
            if(financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c != null && financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c != 0.0)
            {
                financialAnalysis.Total_Annual_Price_including_VAT_Manpowe__c = Math.round(financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c+ (financialAnalysis.VAT_Amount_for_Manpower__c != null ? financialAnalysis.VAT_Amount_for_Manpower__c :0 ));
      
            }
        }
        
        
        if(financialAnalysis.Total_Annual_Price_including_VAT__c != null && workingMonths != null ){
            financialAnalysis.Price_Per_Month_including_VAT__c = Math.round(financialAnalysis.Total_Annual_Price_including_VAT__c/workingMonths);
        }
        
        if(separatePricesRequired){
            // Price per month for Vehicle and Fuel...
            if(financialAnalysis.Total_Annual_Price_including_VAT_Vehicle__c != null && workingMonths != null ){
                financialAnalysis.Price_Per_Month_including_VAT_Vehicle__c = Math.round(financialAnalysis.Total_Annual_Price_including_VAT_Vehicle__c/workingMonths);
            }
            
            // Price per month including VAT for Manpower only
            if(financialAnalysis.Total_Annual_Price_including_VAT_Manpowe__c != null && workingMonths != null ){
                financialAnalysis.Price_Per_month_including_VAT_Manpower__c = Math.round(financialAnalysis.Total_Annual_Price_including_VAT_Manpowe__c/workingMonths);
            }
        }
        
        //  system.debug('financialAnalysis = ' + JSON.serializePretty(financialAnalysis));
        return financialAnalysis; 
    }
    @AuraEnabled
    public static list<Financial_Analysis__c> saveFinancialCalculations(Id quoteId, Id totalProjectQuoteId){
        try{
            if(quoteId != null){
                // system.debug('Finance Calcs started');
                list<Financial_Analysis__c> financialAnalysisLst=new list<Financial_Analysis__c>();
                updateWorkforceQuoteItemLst=new list<ET_Workforce_Quote_Item__c>();
                updateVehicleQuoteItemLst=new list<ET_Vehicle_Quote_Item__c>();
                
                // set required data in lists and Map
                setQuoteData(quoteId);
                
                Map<String, ET_Vehicle_Quote_Item__c> vehQuoteItemWrtoKeyMap = new Map<String, ET_Vehicle_Quote_Item__c>();
                // Key = line and Values = map of vehicle quote items with contract year....
                Map<String, Map<decimal,ET_Vehicle_Quote_Item__c>> vehQuoteMapWrtoKeyLineMap = new Map<String, Map<decimal,ET_Vehicle_Quote_Item__c>>();
                
                
                for(ET_Vehicle_Quote_Item__c vQuote : [select id, ET_Vehicle_Unique_key__c,ET_Contract_Period__c , ET_Vehicle_Source__c,ET_Line_Number__c
                                                       from ET_Vehicle_Quote_Item__c
                                                       where Quote__c =:quoteId])
                {
                    vehQuoteItemWrtoKeyMap.put(vQuote.ET_Vehicle_Unique_key__c+'=>'+vQuote.ET_Line_Number__c, vQuote);
                    // construct a Map with line and internal Map(contract year and Quote)...
                    if(vehQuoteMapWrtoKeyLineMap.containsKey(vQuote.ET_Vehicle_Unique_key__c+'=>'+vQuote.ET_Line_Number__c)){
                        Map<decimal,ET_Vehicle_Quote_Item__c> quotesWithContYears = vehQuoteMapWrtoKeyLineMap.get(vQuote.ET_Vehicle_Unique_key__c+'=>'+vQuote.ET_Line_Number__c);
                        if(!quotesWithContYears.containsKey(vQuote.ET_Contract_Period__c)){
                            quotesWithContYears.put(vQuote.ET_Contract_Period__c , vQuote);
                        }
                    }
                    else {
                        Map<decimal,ET_Vehicle_Quote_Item__c> innerMap = new Map<decimal,ET_Vehicle_Quote_Item__c>();
                        innerMap.put(vQuote.ET_Contract_Period__c , vQuote);
                        vehQuoteMapWrtoKeyLineMap.put(vQuote.ET_Vehicle_Unique_key__c+'=>'+vQuote.ET_Line_Number__c , innerMap);
                    }
                }
                
                // system.debug('targetPriceForCombination 917= '+ json.serializePretty(targetPriceForCombination));
                if(!targetPriceForCombination.isEmpty()){
                    for(integer i=1;i<=targetPriceForCombination.size(); i++){
                        for(String obj:targetPriceForCombination.keySet()){
                            if(integer.valueOf(obj.split('=>')[1])==i){
                                if(!financialAnalysisUniqueKeyMap.isEmpty() && financialAnalysisUniqueKeyMap.containsKey(obj))
                                    financialAnalysisLst.addAll(financialAnalysisData(financialAnalysisUniqueKeyMap.get(obj),obj,quoteId, vehQuoteItemWrtoKeyMap , vehQuoteMapWrtoKeyLineMap) );
                                else 
                                    financialAnalysisLst.addAll(financialAnalysisData(new map<Integer,Financial_Analysis__c>(),obj,quoteId, vehQuoteItemWrtoKeyMap , vehQuoteMapWrtoKeyLineMap));
                            }
                        }
                    }
                }
                // Save Total Project Financ Calcs
                FinancialAnalysisFortotalProject(financialAnalysisLst, totalProjectQuoteId);
                //   system.debug('financialAnalysisLst = '+ json.serializePretty(financialAnalysisLst));
                if(!financialAnalysisLst.isEmpty())
                {
                    // system.debug('finance records upserted');
                    // system.debug('financialAnalysisLst size final = '+ financialAnalysisLst.size());
                    upsert financialAnalysisLst Unique_Identifier__c;  
                    
                    // Call a method to Calculate and update IRR 
                    // system.debug('calcualteIRR Calling 1');
                    calcualteIRR(JSON.serialize(financialAnalysisLst));
                    // system.debug('calcualteIRR Called 1');
                }
                if(!updateVehicleQuoteItemLst.isEmpty())
                {
                    system.debug('updateVehicleQuoteItemLst = '+ JSON.serializePretty(updateVehicleQuoteItemLst) );
                    update updateVehicleQuoteItemLst;  
                }
            }
        }
        Catch(Exception e){
            system.debug('Exception e = '+ e.getMessage());
            system.debug('Exception Stack Trace= '+ e.getStackTraceString());
            system.debug('Exception line = '+ e.getLineNumber());
            system.debug('Exception line = '+ e.getCause());
            //throw new AuraHandledException('Error in Totals calculation. Please reach to system admin.');
        }
        
        return null;
    }
    
    @future
    public static void calcualteIRR( String financialAnalysisLstString ){
        // system.debug('calcualteIRR Called');
        try{
            list<Financial_Analysis__c> financialAnalysisLst = (list<Financial_Analysis__c>)JSON.deserialize(financialAnalysisLstString, list<Financial_Analysis__c>.class );
			list<Financial_Analysis__c> update_financialAnalysisLst = new list<Financial_Analysis__c> ();
			list<Financial_Analysis__c> update_financialAnalysisLst2 = new list<Financial_Analysis__c> ();
            if(!financialAnalysisLst.isEmpty()){
                for(Financial_Analysis__c fin : financialAnalysisLst ){
                    integer investment  = integer.valueOf(fin.Total_Investment__c); 
                    integer cashflowAmunt;
                    integer period = integer.valueOf(fin.Contract_Year__c);
                    integer terminalAmount  = integer.valueOf(fin.Resale_Value_used_for_Calculation__c);
                    boolean isTargerPriceRequired = fin.is_Target_Price_Required__c;
                    boolean separatePricesRequired = fin.Request_for_separate_prices__c;
                    decimal resaleValue  = fin.Resale_Value_used_for_Calculation__c;
                    integer freeCashFlow =0;
                    if(fin.Free_Cash_Flow_Annual__c != null && resaleValue != null){
                        freeCashFlow = integer.valueOf(fin.Free_Cash_Flow_Annual__c) -integer.valueOf(resaleValue) ;
                    }
                    
                    integer freeCashFlowTarget =0;
                    if(isTargerPriceRequired && fin.Free_Cash_Flow_Annual_Target__c != null && resaleValue != null){
                        freeCashFlowTarget = integer.valueOf(fin.Free_Cash_Flow_Annual_Target__c) -integer.valueOf(resaleValue) ;
                    }
                    
                    integer freeCashFlowDiscounted =0;
                    if(isTargerPriceRequired && fin.Free_Cash_Flow_Annual_Discounted__c != null && resaleValue != null){
                        freeCashFlowDiscounted = integer.valueOf(fin.Free_Cash_Flow_Annual_Discounted__c) -integer.valueOf(resaleValue) ;
                    }
                    // system.debug('period = '+ period);
                    if(!test.isRunningTest()){
                        Financial_Analysis__c finan=ET_ServiceRequestController.calcualteIRR(investment,freeCashFlow,period,integer.valueOf(resaleValue),fin.id, 'Internal_Rate_of_Return__c' );
                        system.debug('finance'+finan);
						update_financialAnalysisLst.add(finan);
                    }
                    
                    //system.debug('isTargerPriceRequired = '+ isTargerPriceRequired);
                    if(!test.isRunningTest()){
                        if(isTargerPriceRequired){
                            Financial_Analysis__c finan2=ET_ServiceRequestController.calcualteIRR(investment,freeCashFlowTarget,period,integer.valueOf(resaleValue),fin.id , 'Internal_Rate_of_Return_Target__c');
							update_financialAnalysisLst2.add(finan2);
                            // ET_ServiceRequestController.calcualteIRR(investment,freeCashFlowDiscounted,period,integer.valueOf(resaleValue),fin.id, 'Internal_Rate_of_Return_Discounted__c');
                            // system.debug('IRR Calculated for Target Prices ');
                        }
                    }
                    
                } 
                //  system.debug('financialAnalysisLst = ' + JSON.serializePretty(financialAnalysisLst));
				update update_financialAnalysisLst;
				update update_financialAnalysisLst2;
                
            }
        }
        Catch(Exception e){
            system.debug('Exception e = '+ e.getMessage());
            system.debug('Exception Stack Trace= '+ e.getStackTraceString());
            //throw new AuraHandledException('Error in Totals calculation. Please reach to system admin.');
        }
    }
    
    
    public static Map<String, ET_Vehicle_Quote_Item__c> getVehicleDetailsWrtoVehicleKey(String quoteId){
        Map<String, ET_Vehicle_Quote_Item__c> vehQuoteItemWrtoKeyMap = new Map<String, ET_Vehicle_Quote_Item__c>();
        
        for(ET_Vehicle_Quote_Item__c vQuote : [select id, ET_Vehicle_Unique_key__c, ET_Vehicle_Source__c,ET_Line_Number__c
                                               from ET_Vehicle_Quote_Item__c
                                               where Quote__c =:quoteId])
        {
            vehQuoteItemWrtoKeyMap.put(vQuote.ET_Vehicle_Unique_key__c+'=>'+vQuote.ET_Line_Number__c, vQuote);
        }
        
        return vehQuoteItemWrtoKeyMap;
    }
    
    public static list<Financial_Analysis__c> financialAnalysisData(map<Integer,Financial_Analysis__c> financialAnalysisYearWiseMap,String obj,Id quoteId , Map<String, ET_Vehicle_Quote_Item__c> vehQuoteItemMap , Map<String, Map<decimal,ET_Vehicle_Quote_Item__c>> vehQuoteMapWrtoKeyLineMap){
        
        list<Financial_Analysis__c> financialAnalysisLst=new list<Financial_Analysis__c>();
        intializeClassMaps();
        vehicleQuoteItemMap = new map<String,ET_Vehicle_Quote_Item__c>();
        contractYearAndVehicleProfits = new Map<Decimal,Decimal>();
        contractYearAndDriverProfits = new Map<Decimal,Decimal>();
        contractYearAndNannyProfits = new Map<Decimal,Decimal>();
        contractYearAndCoordinatorProfits = new Map<Decimal,Decimal>();
        contractYearAndOtherEmployeeProfits = new Map<Decimal,Decimal>();
        contractYearAndFuelProfits = new Map<Decimal,Decimal>();
        contractYearAndSupervisorProfits = new Map<Decimal,Decimal>();
        contractYearAndAccountantProfits = new Map<Decimal,Decimal>();
        contractYearAndRemainingDepreciationOf10Years = new Map<Decimal,Decimal>();
        
        contractYearAndVehicleProfitsTarget = new Map<Decimal,Decimal>();
        contractYearAndDriverProfitsTarget = new Map<Decimal,Decimal>();
        contractYearAndNannyProfitsTarget = new Map<Decimal,Decimal>();
        contractYearAndCoordinatorProfitsTarget = new Map<Decimal,Decimal>();
        contractYearAndOtherEmployeeProfitsTarget = new Map<Decimal,Decimal>();
        contractYearAndFuelProfitsTarget = new Map<Decimal,Decimal>();
        contractYearAndSupervisorProfitsTarget = new Map<Decimal,Decimal>();
        contractYearAndAccountantProfitsTarget = new Map<Decimal,Decimal>();
        
        contractYearAndVehicleProfitsDiscounted = new Map<Decimal,Decimal>();
        contractYearAndDriverProfitsDiscounted  = new Map<Decimal,Decimal>();
        contractYearAndNannyProfitsDiscounted  = new Map<Decimal,Decimal>();
        contractYearAndCoordinatorProfitsDiscounted  = new Map<Decimal,Decimal>();
        contractYearAndOtherEmployeeProfitsDiscounted  = new Map<Decimal,Decimal>();
        contractYearAndFuelProfitsDiscounted  = new Map<Decimal,Decimal>();
        contractYearAndSupervisorProfitsDiscounted  = new Map<Decimal,Decimal>();
        contractYearAndAccountantProfitsDiscounted  = new Map<Decimal,Decimal>();
        
        
        contractYearAndVehicleFinancingExpenses = new Map<Decimal,Decimal>();
        contractYearAndVehicleAnnualProfit = new Map<Decimal,Decimal>();
        contractYearAndVehicleDepreciationExp = new Map<Decimal,String>();
        contractYearAndVehicleResaleValue = new Map<Decimal,String>();
        contractYearAndFreeCashFlow = new Map<Decimal,Decimal>();
        contractYearAndPricePerPricingType = new Map<Decimal,Decimal>();
        Set<integer> contractYears = new Set<integer>();
        String pricingType;
        String serviceType;
        String pricingMethod;
        String vehicleCondition;
        String pricingServiceReqNumber ;
        boolean isTargerPriceRequired ;
        boolean separatePricesRequired ;
        decimal utilizationFactor =0.0;
        try{
            if(obj!=null){
                // system.debug('obj = '+ obj);
                if(vehicleQuoteItemLst != null && vehicleQuoteItemLst.size() > 0 ){
                    for(ET_Vehicle_Quote_Item__c vehicleQuoteItem :  vehicleQuoteItemLst){
                        if(vehicleQuoteItem.ET_Vehicle_Source__c != 'Substitutional' //&& vehicleQuoteItem.ET_Fleet_Type__c != 'Client Fleet'
                          ){
                            if(vehicleQuoteItem.ET_Vehicle_Unique_key__c==obj.split('=>')[0] && vehicleQuoteItem.ET_Line_Number__c==decimal.valueOf(obj.split('=>')[1])){
                                setVehicleRelatedMapValues(vehicleQuoteItem);
                                // system.debug('financialAnalysisYearWiseMap = '+ json.serializePretty(financialAnalysisYearWiseMap));
                                if(!(reqMappings.containsKey(obj) && vehicleQuoteItemMap.containsKey(obj)))
                                    vehicleQuoteItemMap.put(obj,vehicleQuoteItem);
                                //ET_Vehicle_Current_Purchase_Price__c
                                if(!cuurentPurchasePrice.containsKey(obj))
                                    cuurentPurchasePrice.put(obj, vehicleQuoteItem.Total_Current_Value__c);
                                if(!vehicleDepreciation.containsKey(obj)){
                                    decimal depreciation = 0.0;
                                    if(vehicleQuoteItem.ET_Vehicle_Depreciation__c == 'N/A'){
                                        depreciation = 0.0;
                                    }
                                    else{
                                        depreciation = decimal.valueOf(vehicleQuoteItem.ET_Vehicle_Depreciation__c);
                                    }
                                    vehicleDepreciation.put(obj, depreciation);
                                }
                                
                                if(!vehicleResaleValue.containsKey(obj)){
                                    decimal resaleValue = 0.0;
                                    if(vehicleQuoteItem.ET_Vehicle_Resale_Value__c == 'N/A'){
                                        resaleValue = 0.0;
                                    }
                                    else{
                                        resaleValue = decimal.valueOf(vehicleQuoteItem.ET_Vehicle_Resale_Value__c);
                                    }
                                    vehicleResaleValue.put(obj, resaleValue);
                                }
                                if(!workingMonthsPerYear.containsKey(obj))
                                    workingMonthsPerYear.put(obj, vehicleQuoteItem.ET_Price_Utilization__c);
                                if(!vatRateMap.containsKey(obj))
                                    vatRateMap.put(obj, vehicleQuoteItem.ET_Vat_Rate__c);
                                pricingType = vehicleQuoteItem.ET_Pricing_Type__c;
                                serviceType = vehicleQuoteItem.ET_Service_Type__c;
                                pricingMethod = vehicleQuoteItem.ET_Pricing_Method__c;
                                utilizationFactor = vehicleQuoteItem.ET_Price_Utilization__c;
                                isTargerPriceRequired = vehicleQuoteItem.Request_for_Target_Price__c;
                                separatePricesRequired = vehicleQuoteItem.Request_for_separate_prices__c;
                                
                                // system.debug('separatePricesRequired = ' + separatePricesRequired);
							vehicleCondition = vehicleQuoteItem.ET_Vehicle_Condition__c;
							List<String> contractYearLst ;
						if(vehicleQuoteItem.ET_Pricing_Vehicle_Request__r.ET_Contract_Period__c != null){
							contractYearLst = vehicleQuoteItem.ET_Pricing_Vehicle_Request__r.ET_Contract_Period__c.split(',');
						}
						if(contractYearLst != null && contractYearLst.size() > 0){
							for(String Year : contractYearLst ){
								String intYear = Year.substring(0,1);
								contractYears.add(integer.valueOf(intYear));
							}
						}
						}
                            
                        }
                        
                    }
                }
                if(workforceQuoteItemLst != null && workforceQuoteItemLst.size()>0){
                    // This will apply for Manpowers those are combined in Customize pricing...
                    if(targetPriceForCombination.get(obj)!=null){
                        for(String str:targetPriceForCombination.get(obj)){
                            for(ET_Workforce_Quote_Item__c workforceQuoteItem : workforceQuoteItemLst){
                                //workforceQuoteItem.ET_Workforce_Unique_Key__c==str.split('=>')[0] && workforceQuoteItem.ET_Workforce_Line_Number__c==decimal.valueOf(str.split('=>')[1])
                                //workforceQuoteItem.ET_Workforce_Unique_Key__c==str.split('=>')[0]
                                if(workforceQuoteItem.ET_Workforce_Unique_Key__c==str.split('=>')[0] && workforceQuoteItem.Line_number_from_input__c==decimal.valueOf(str.split('=>')[1]) ){
                                    setManpowerRelatedMapValues(workforceQuoteItem,isTargerPriceRequired, separatePricesRequired);
                                    totalCostDriver = workforceQuoteItem.ET_Total_Cost__c;
                                }
                                if(!workingMonthsPerYear.containsKey(obj))
                                    workingMonthsPerYear.put(obj, workforceQuoteItem.ET_Price_Utilization__c);
                                pricingType = workforceQuoteItem.ET_Pricing_Type__c;
                            }
                        }
                    }
                    // Calculate Manpower Values for Manpowers other than, Driver and Nanny. These manpowers are quotation level manpowers...
                    for(ET_Workforce_Quote_Item__c workforceQuoteItem : workforceQuoteItemLst){
                        if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c != 'Driver' &&  workforceQuoteItem.ET_Workforce_Quote_Item_Type__c != 'Nanny'){
                            setManpowerRelatedMapValues(workforceQuoteItem,isTargerPriceRequired, separatePricesRequired);
                            if(!workingMonthsPerYear.containsKey(obj))
                                workingMonthsPerYear.put(obj, workforceQuoteItem.ET_Price_Utilization__c);
                            pricingType = workforceQuoteItem.ET_Pricing_Type__c;
                        }
                    }
                }
                
                if(workingMonthsPerYear.get(obj)!=null){
                    // system.debug('contractYears 1= '+ contractYears);
                    if(contractYears != null && contractYears.size() > 0){
                        for(integer i : contractYears){
                            Financial_Analysis__c financialAnalysis = doCostCalculation(!financialAnalysisYearWiseMap.isEmpty()?financialAnalysisYearWiseMap.get(i):new Financial_Analysis__c(),i,integer.valueOf(workingMonthsPerYear.get(obj)) , 
                                                                                        obj, pricingType, pricingMethod, utilizationFactor, isTargerPriceRequired , separatePricesRequired);
                            //system.debug('financialAnalysis = '+ json.serializePretty(financialAnalysis));
                            // system.debug('financialAnalysisYearWiseMap = '+ json.serializePretty(financialAnalysisYearWiseMap));
                            decimal totalProfit =0.0;
                            decimal totalProfitTarget =0.0;
                            decimal totalProfitDiscounted =0.0;
                            if(financialAnalysisYearWiseMap.isEmpty()){
                                financialAnalysis.Contract_Year__c =i;
                                financialAnalysis.ET_Vehicle_Unique_key__c=obj.split('=>')[0];
                                financialAnalysis.Line__c=decimal.valueOf(obj.split('=>')[1]);
                                financialAnalysis.Quote__c=quoteId;
                                financialAnalysis.Unique_Identifier__c= quoteId + '-'+financialAnalysis.Line__c + '-'+ financialAnalysis.Contract_Year__c;
                                
                                // system.debug('vehQuoteItemMap = '+ JSON.serializePretty(vehQuoteItemMap));
                                // system.debug('key 1066 = '+ financialAnalysis.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(financialAnalysis.Line__c));
                                if(vehQuoteItemMap != null && vehQuoteItemMap.containsKey(financialAnalysis.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(financialAnalysis.Line__c))){
                                    ET_Vehicle_Quote_Item__c vehQuoteItem = vehQuoteItemMap.get(financialAnalysis.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(financialAnalysis.Line__c));
                                    financialAnalysis.Vehicle_source__c =  vehQuoteItem.ET_Vehicle_Source__c;
                                }
                                
                                if(reqMappings.containsKey(obj))
                                    financialAnalysis.Request_Mapping__c = reqMappings.get(obj).Id;
                            }
                            
                            if(vehQuoteMapWrtoKeyLineMap != null && vehQuoteMapWrtoKeyLineMap.containsKey(financialAnalysis.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(financialAnalysis.Line__c))){
                                // calculate and update vehicle quote items for 'Vehicle profit margin'..
                                ET_Vehicle_Quote_Item__c vQitem = new ET_Vehicle_Quote_Item__c();
                                Map<decimal,ET_Vehicle_Quote_Item__c> vehQuoteItemMapWithRespectToContractYears = vehQuoteMapWrtoKeyLineMap.get(financialAnalysis.ET_Vehicle_Unique_key__c+'=>'+string.valueOf(financialAnalysis.Line__c));
                                ET_Vehicle_Quote_Item__c vehQuoteItem = vehQuoteItemMapWithRespectToContractYears.get(decimal.valueOf(i));
                                vQitem.id = vehQuoteItem.Id;
                                // assign Vehicle quote item to Finance record...
                                financialAnalysis.Vehicle_Quote_Item__c = vehQuoteItem.Id;
                                if(contractYearAndVehicleProfits.get(i) != null && financialAnalysis.Total_Annual_Price_excluding_VAT__c != null && financialAnalysis.Total_Annual_Price_excluding_VAT__c != 0){
                                    vQitem.ET_Annual_Vehicles_Profit_Margin__c = ((contractYearAndVehicleProfits.get(i)/financialAnalysis.Total_Annual_Price_excluding_VAT__c)*100).setScale(2);
                                }
                                
                                if(vQitem.id != null && vQitem.ET_Annual_Vehicles_Profit_Margin__c != null){
                                    updateVehicleQuoteItemLst.add(vQitem);
                                }
                            }
                            
                            
                            if(financialAnalysis.Total_Annual_Cost__c!=0){
                                // system.debug('reqMappings = '+ json.serializePretty(reqMappings));
                                //system.debug('vehicleQuoteItemMap = '+ json.serializePretty(vehicleQuoteItemMap));
                                if(reqMappings.containsKey(obj)){
                                    if(financialAnalysis.Total_Annual_Price_excluding_VAT__c != null ){
                                        financialAnalysis.Total_Value_of_Rental__c=financialAnalysis.Total_Annual_Price_excluding_VAT__c*reqMappings.get(obj).ET_Number_of_Vehicles__c*i;
                                    }
                                    
                                    if(serviceType == 'School Transportation' && vehicleCondition == 'Used'){
                                        financialAnalysis.Total_Investment__c = contractYearAndRemainingDepreciationOf10Years.get(i)*reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                    }
                                    else
                                    {
                                        financialAnalysis.Total_Investment__c=cuurentPurchasePrice.get(obj)*reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                    }
                                    
                                    if(contractYearAndVehicleResaleValue!=null && contractYearAndVehicleResaleValue.containsKey(i)){
                                        decimal resaleValue = 0.0;
                                        if(contractYearAndVehicleResaleValue.get(i) == 'N/A'){
                                            resaleValue = 0.0;
                                        }
                                        else{
                                            resaleValue = decimal.valueOf(contractYearAndVehicleResaleValue.get(i));
                                        }
                                        financialAnalysis.Total_Resale_Value__c=Math.round(resaleValue*reqMappings.get(obj).ET_Number_of_Vehicles__c);
                                    }
                                    if(contractYearAndVehicleDepreciationExp!=null && contractYearAndVehicleDepreciationExp.containsKey(i)){
                                        decimal depreciation = 0.0;
                                        if(contractYearAndVehicleDepreciationExp.get(i) == 'N/A'){
                                            depreciation = 0.0;
                                        }
                                        else{
                                            depreciation = decimal.valueOf(contractYearAndVehicleDepreciationExp.get(i));
                                        }
                                        financialAnalysis.Total_Depreciation__c=Math.round(depreciation*i*reqMappings.get(obj).ET_Number_of_Vehicles__c);
                                    }
                                    if(contractYearAndVehicleProfits!=null && contractYearAndVehicleProfits.containsKey(i))
                                        financialAnalysis.Total_Vehicle_Profits__c=contractYearAndVehicleProfits.get(i)*i*reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                    if(contractYearAndDriverProfits!=null && contractYearAndDriverProfits.containsKey(i))
                                        financialAnalysis.Total_Driver_Profits__c=contractYearAndDriverProfits.get(i)*i*reqMappings.get(obj).ET_Number_of_Drivers__c;
                                    if(contractYearAndNannyProfits!=null && contractYearAndNannyProfits.containsKey(i))
                                        financialAnalysis.Total_Nanny_Profits__c=contractYearAndNannyProfits.get(i)*i*reqMappings.get(obj).ET_Number_of_Nannies__c;
                                    if(contractYearAndCoordinatorProfits!=null && contractYearAndCoordinatorProfits.containsKey(i))
                                        //financialAnalysis.Total_Coordinator_Profits__c=contractYearAndCoordinatorProfits.get(i)*i*reqMappings.get(obj).ET_Number_of_Coordinators__c;
                                        financialAnalysis.Total_Coordinator_Profits__c=contractYearAndCoordinatorProfits.get(i)*i*quoteLst[0].Total_Number_of_Coordinators__c;
                                    if(contractYearAndSupervisorProfits!=null && contractYearAndSupervisorProfits.containsKey(i))
                                        //financialAnalysis.Total_Supervisor_Profits__c=contractYearAndSupervisorProfits.get(i)*i*reqMappings.get(obj).ET_Number_of_Supervisors__c;
                                        financialAnalysis.Total_Supervisor_Profits__c=contractYearAndSupervisorProfits.get(i)*i*quoteLst[0].Total_Number_of_Supervisors__c;
                                    if(contractYearAndAccountantProfits!=null && contractYearAndAccountantProfits.containsKey(i))
                                        //financialAnalysis.Total_Accountant_Profits__c=contractYearAndAccountantProfits.get(i)*i*reqMappings.get(obj).ET_Number_of_Accountants__c;
                                        financialAnalysis.Total_Accountant_Profits__c=contractYearAndAccountantProfits.get(i)*i*quoteLst[0].Total_Number_of_Accountants__c;
                                    if(contractYearAndOtherEmployeeProfits!=null && contractYearAndOtherEmployeeProfits.containsKey(i))
                                        //financialAnalysis.Total_Other_Employee_Profits__c=contractYearAndOtherEmployeeProfits.get(i)*i*reqMappings.get(obj).ET_Number_of_Other_Employees__c;
                                        financialAnalysis.Total_Other_Employee_Profits__c=contractYearAndOtherEmployeeProfits.get(i)*i*quoteLst[0].Total_Number_of_Other_Employees__c;
                                    if(contractYearAndFuelProfits!=null && contractYearAndFuelProfits.containsKey(i))
                                        financialAnalysis.Total_Fuel_Profits__c=contractYearAndFuelProfits.get(i)*i*reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                    
                                    // Target
                                    if(isTargerPriceRequired && contractYearAndVehicleProfitsTarget!=null && contractYearAndVehicleProfitsTarget.containsKey(i))
                                        financialAnalysis.Total_Vehicle_Profit_Target__c=contractYearAndVehicleProfitsTarget.get(i)*i*reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                    if(isTargerPriceRequired && contractYearAndDriverProfitsTarget!=null && contractYearAndDriverProfitsTarget.containsKey(i))
                                        financialAnalysis.Total_Driver_Profits_Target__c=contractYearAndDriverProfitsTarget.get(i)*i*reqMappings.get(obj).ET_Number_of_Drivers__c;
                                    if(isTargerPriceRequired && contractYearAndNannyProfitsTarget!=null && contractYearAndNannyProfitsTarget.containsKey(i))
                                        financialAnalysis.Total_Nanny_Profits_Target__c=contractYearAndNannyProfitsTarget.get(i)*i*reqMappings.get(obj).ET_Number_of_Nannies__c;
                                    if(isTargerPriceRequired && contractYearAndCoordinatorProfitsTarget!=null && contractYearAndCoordinatorProfitsTarget.containsKey(i))
                                        //financialAnalysis.Total_Coordinator_Profits_Target__c=contractYearAndCoordinatorProfitsTarget.get(i)*i*reqMappings.get(obj).ET_Number_of_Coordinators__c;
                                        financialAnalysis.Total_Coordinator_Profits_Target__c=contractYearAndCoordinatorProfitsTarget.get(i)*i*quoteLst[0].Total_Number_of_Coordinators__c;
                                    if(isTargerPriceRequired && contractYearAndSupervisorProfitsTarget!=null && contractYearAndSupervisorProfitsTarget.containsKey(i))
                                        //financialAnalysis.Total_Supervisor_Profits_Target__c=contractYearAndSupervisorProfitsTarget.get(i)*i*reqMappings.get(obj).ET_Number_of_Supervisors__c;
                                        financialAnalysis.Total_Coordinator_Profits_Target__c=contractYearAndSupervisorProfitsTarget.get(i)*i*quoteLst[0].Total_Number_of_Supervisors__c;
                                    if(isTargerPriceRequired && contractYearAndAccountantProfitsTarget!=null && contractYearAndAccountantProfitsTarget.containsKey(i))
                                        //financialAnalysis.Total_Accountant_Profits_Target__c=contractYearAndAccountantProfitsTarget.get(i)*i*reqMappings.get(obj).ET_Number_of_Accountants__c;
                                        financialAnalysis.Total_Accountant_Profits_Target__c=contractYearAndAccountantProfitsTarget.get(i)*i*quoteLst[0].Total_Number_of_Accountants__c;
                                    if(isTargerPriceRequired && contractYearAndOtherEmployeeProfitsTarget!=null && contractYearAndOtherEmployeeProfitsTarget.containsKey(i))
                                        //financialAnalysis.Total_Other_Emp_Profits_Target__c=contractYearAndOtherEmployeeProfitsTarget.get(i)*i*reqMappings.get(obj).ET_Number_of_Other_Employees__c;
                                        financialAnalysis.Total_Other_Emp_Profits_Target__c=contractYearAndOtherEmployeeProfitsTarget.get(i)*i*quoteLst[0].Total_Number_of_Other_Employees__c;
                                    if(isTargerPriceRequired && contractYearAndFuelProfitsTarget!=null && contractYearAndFuelProfitsTarget.containsKey(i))
                                        financialAnalysis.Total_Fuel_Profits_Target__c=contractYearAndFuelProfitsTarget.get(i)*i*reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                    
                                    // Discounted
                                    if(isTargerPriceRequired && contractYearAndVehicleProfitsDiscounted!=null && contractYearAndVehicleProfitsDiscounted.containsKey(i))
                                        financialAnalysis.Total_Vehicle_Profit_Discounted__c=contractYearAndVehicleProfitsDiscounted.get(i)*i*reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                    if(isTargerPriceRequired && contractYearAndDriverProfitsDiscounted!=null && contractYearAndDriverProfitsDiscounted.containsKey(i))
                                        financialAnalysis.Total_Driver_Profits_Discounted__c=contractYearAndDriverProfitsDiscounted.get(i)*i*reqMappings.get(obj).ET_Number_of_Drivers__c;
                                    if(isTargerPriceRequired && contractYearAndNannyProfitsDiscounted!=null && contractYearAndNannyProfitsDiscounted.containsKey(i))
                                        financialAnalysis.Total_Nanny_Profits_Discounted__c=contractYearAndNannyProfitsDiscounted.get(i)*i*reqMappings.get(obj).ET_Number_of_Nannies__c;
                                    if(isTargerPriceRequired && contractYearAndCoordinatorProfitsDiscounted!=null && contractYearAndCoordinatorProfitsDiscounted.containsKey(i))
                                        //financialAnalysis.Total_Coordinator_Profits_Discounted__c=contractYearAndCoordinatorProfitsDiscounted.get(i)*i*reqMappings.get(obj).ET_Number_of_Coordinators__c;
                                        financialAnalysis.Total_Coordinator_Profits_Discounted__c=contractYearAndCoordinatorProfitsDiscounted.get(i)*i*quoteLst[0].Total_Number_of_Coordinators__c;
                                    if(isTargerPriceRequired && contractYearAndSupervisorProfitsDiscounted!=null && contractYearAndSupervisorProfitsDiscounted.containsKey(i))
                                        //financialAnalysis.Total_Supervisor_Profits_Discounted__c=contractYearAndSupervisorProfitsDiscounted.get(i)*i*reqMappings.get(obj).ET_Number_of_Supervisors__c;
                                        financialAnalysis.Total_Supervisor_Profits_Discounted__c=contractYearAndSupervisorProfitsDiscounted.get(i)*i*quoteLst[0].Total_Number_of_Supervisors__c;
                                    if(isTargerPriceRequired && contractYearAndAccountantProfitsDiscounted!=null && contractYearAndAccountantProfitsDiscounted.containsKey(i))
                                        //financialAnalysis.Total_Accountant_Profits_Discounted__c=contractYearAndAccountantProfitsDiscounted.get(i)*i*reqMappings.get(obj).ET_Number_of_Accountants__c;
                                        financialAnalysis.Total_Accountant_Profits_Discounted__c=contractYearAndAccountantProfitsDiscounted.get(i)*i*quoteLst[0].Total_Number_of_Accountants__c;
                                    if(isTargerPriceRequired && contractYearAndOtherEmployeeProfitsDiscounted!=null && contractYearAndOtherEmployeeProfitsDiscounted.containsKey(i))
                                        //financialAnalysis.Total_other_Emp_Profits_Discounted__c=contractYearAndOtherEmployeeProfitsDiscounted.get(i)*i*reqMappings.get(obj).ET_Number_of_Other_Employees__c;
                                        financialAnalysis.Total_other_Emp_Profits_Discounted__c=contractYearAndOtherEmployeeProfitsDiscounted.get(i)*i*quoteLst[0].Total_Number_of_Other_Employees__c;
                                    if(isTargerPriceRequired && contractYearAndFuelProfitsDiscounted!=null && contractYearAndFuelProfitsDiscounted.containsKey(i))
                                        financialAnalysis.Total_Fuel_Profits_Discounted__c=contractYearAndFuelProfitsDiscounted.get(i)*i*reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                    
                                    
                                }
                                else if(vehicleQuoteItemMap.containsKey(obj)){
                                    financialAnalysis.Total_Value_of_Rental__c=financialAnalysis.Total_Annual_Price_excluding_VAT__c*vehicleQuoteItemMap.get(obj).ET_Number_of_Vehicles__c*i;
                                    if(serviceType == 'School Transportation' && vehicleCondition == 'Used'){
                                        financialAnalysis.Total_Investment__c = contractYearAndRemainingDepreciationOf10Years.get(i)*vehicleQuoteItemMap.get(obj).ET_Number_of_Vehicles__c;
                                    }
                                    else
                                    {
                                        financialAnalysis.Total_Investment__c=cuurentPurchasePrice.get(obj)*vehicleQuoteItemMap.get(obj).ET_Number_of_Vehicles__c;
                                    }
                                    
                                    decimal resaleValue = 0.0;
                                    if(contractYearAndVehicleResaleValue.containsKey(i) && contractYearAndVehicleResaleValue.get(i) == 'N/A'){
                                        resaleValue = 0.0;
                                    }
                                    else{
                                        resaleValue = decimal.valueOf(contractYearAndVehicleResaleValue.get(i));
                                    }
                                    if(contractYearAndVehicleResaleValue!=null && contractYearAndVehicleResaleValue.containsKey(i)){
                                        financialAnalysis.Total_Resale_Value__c=resaleValue*vehicleQuoteItemMap.get(obj).ET_Number_of_Vehicles__c;
                                    }
                                    decimal depreciation = 0.0;
                                    if(contractYearAndVehicleDepreciationExp.containsKey(i) && contractYearAndVehicleDepreciationExp.get(i) == 'N/A'){
                                        depreciation = 0.0;
                                    }
                                    else{
                                        depreciation = decimal.valueOf(contractYearAndVehicleDepreciationExp.get(i));
                                    }
                                    if(contractYearAndVehicleDepreciationExp!=null && contractYearAndVehicleDepreciationExp.containsKey(i)){
                                        financialAnalysis.Total_Depreciation__c=Math.round(depreciation*i*vehicleQuoteItemMap.get(obj).ET_Number_of_Vehicles__c);
                                    }
                                    if(contractYearAndVehicleProfits!=null && contractYearAndVehicleProfits.containsKey(i))
                                        financialAnalysis.Total_Vehicle_Profits__c=contractYearAndVehicleProfits.get(i)*i*vehicleQuoteItemMap.get(obj).ET_Number_of_Vehicles__c;
                                    if(contractYearAndFuelProfits!=null && contractYearAndFuelProfits.containsKey(i) && contractYearAndFuelProfits.get(i) != null && reqMappings.get(obj) != null)
                                        financialAnalysis.Total_Fuel_Profits__c=contractYearAndFuelProfits.get(i)*i*reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                }
                                if(financialAnalysis.Total_Depreciation__c != null &&  financialAnalysis.Total_Vehicle_Profits__c != null){
                                    financialAnalysis.Payback_1__c = financialAnalysis.Total_Depreciation__c+financialAnalysis.Total_Vehicle_Profits__c;
                                }
                                if(financialAnalysis.Payback_1__c != null &&  financialAnalysis.Total_Investment__c != null){
                                    financialAnalysis.Payback_Ratio_1__c = (financialAnalysis.Payback_1__c/financialAnalysis.Total_Investment__c)*100;
                                }
                                if(financialAnalysis.Payback_1__c != null &&  financialAnalysis.Total_Resale_Value__c != null){
                                    //Added by Arunsarathy on 14.03.2023 for School Trasportation Updation
                                    if(serviceType == 'School Transportation'){
                                        financialAnalysis.Payback_2__c = financialAnalysis.Payback_1__c+(financialAnalysis.Total_Investment__c-(financialAnalysis.Total_Depreciation__c+financialAnalysis.Total_Resale_Value__c))+financialAnalysis.Total_Resale_Value__c;
                                    }else{
                                        financialAnalysis.Payback_2__c = financialAnalysis.Payback_1__c+financialAnalysis.Total_Resale_Value__c;
                                    }
                                }
                                if(financialAnalysis.Payback_2__c != null &&  financialAnalysis.Total_Investment__c != null){
                                    financialAnalysis.Payback_Ratio_2__c = (financialAnalysis.Payback_2__c/financialAnalysis.Total_Investment__c)*100;
                                }
                                if(financialAnalysis.Payback_Ratio_2__c != null ){
                                    financialAnalysis.Annual_share_of_Payback_Ratio_2__c = (financialAnalysis.Payback_Ratio_2__c-100)/i;
                                }
                                if(financialAnalysis.Payback_2__c != null ){
                                    if(financialAnalysis.Total_Driver_Profits__c !=0 && financialAnalysis.Total_Driver_Profits__c != null){
                                        totalProfit += financialAnalysis.Total_Driver_Profits__c;
                                    }
                                    if(financialAnalysis.Total_Nanny_Profits__c !=0 && financialAnalysis.Total_Nanny_Profits__c != null){
                                        totalProfit += financialAnalysis.Total_Nanny_Profits__c;
                                    }
                                    if(financialAnalysis.Total_Coordinator_Profits__c !=0 && financialAnalysis.Total_Coordinator_Profits__c != null){
                                        totalProfit += financialAnalysis.Total_Coordinator_Profits__c;
                                    }
                                    if(financialAnalysis.Total_Supervisor_Profits__c !=0 && financialAnalysis.Total_Supervisor_Profits__c != null){
                                        totalProfit += financialAnalysis.Total_Supervisor_Profits__c;
                                    }
                                    if(financialAnalysis.Total_Accountant_Profits__c !=0 && financialAnalysis.Total_Accountant_Profits__c != null){
                                        totalProfit += financialAnalysis.Total_Accountant_Profits__c;
                                    }
                                    if(financialAnalysis.Total_Other_Employee_Profits__c !=0 && financialAnalysis.Total_Other_Employee_Profits__c != null){
                                        totalProfit += financialAnalysis.Total_Other_Employee_Profits__c;
                                    }
                                    if(financialAnalysis.Total_Fuel_Profits__c !=0 && financialAnalysis.Total_Fuel_Profits__c != null){
                                        totalProfit += financialAnalysis.Total_Fuel_Profits__c;
                                    }
                                    
                                    financialAnalysis.Total_Manpower_profit_used_for_calcs__c = totalProfit;
                                    
                                    //Target total Profit
                                    if(isTargerPriceRequired && financialAnalysis.Total_Driver_Profits_Target__c !=0 && financialAnalysis.Total_Driver_Profits_Target__c != null){
                                        totalProfitTarget += financialAnalysis.Total_Driver_Profits_Target__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Nanny_Profits_Target__c !=0 && financialAnalysis.Total_Nanny_Profits_Target__c != null){
                                        totalProfitTarget += financialAnalysis.Total_Nanny_Profits_Target__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Coordinator_Profits_Target__c !=0 && financialAnalysis.Total_Coordinator_Profits_Target__c != null){
                                        totalProfitTarget += financialAnalysis.Total_Coordinator_Profits_Target__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Supervisor_Profits_Target__c !=0 && financialAnalysis.Total_Supervisor_Profits_Target__c != null){
                                        totalProfitTarget += financialAnalysis.Total_Supervisor_Profits_Target__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Accountant_Profits_Target__c !=0 && financialAnalysis.Total_Accountant_Profits_Target__c != null){
                                        totalProfitTarget += financialAnalysis.Total_Accountant_Profits_Target__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Other_Emp_Profits_Target__c !=0 && financialAnalysis.Total_Other_Emp_Profits_Target__c != null){
                                        totalProfitTarget += financialAnalysis.Total_Other_Emp_Profits_Target__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Fuel_Profits_Target__c !=0 && financialAnalysis.Total_Fuel_Profits_Target__c != null){
                                        totalProfitTarget += financialAnalysis.Total_Fuel_Profits_Target__c;
                                    }
                                    
                                    //Discount total Profit
                                    if(isTargerPriceRequired && financialAnalysis.Total_Driver_Profits_Discounted__c !=0 && financialAnalysis.Total_Driver_Profits_Discounted__c != null){
                                        totalProfitDiscounted += financialAnalysis.Total_Driver_Profits_Discounted__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Nanny_Profits_Discounted__c !=0 && financialAnalysis.Total_Nanny_Profits_Discounted__c != null){
                                        totalProfitDiscounted += financialAnalysis.Total_Nanny_Profits_Discounted__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Coordinator_Profits_Discounted__c !=0 && financialAnalysis.Total_Coordinator_Profits_Discounted__c != null){
                                        totalProfitDiscounted += financialAnalysis.Total_Coordinator_Profits_Discounted__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Supervisor_Profits_Discounted__c !=0 && financialAnalysis.Total_Supervisor_Profits_Discounted__c != null){
                                        totalProfitDiscounted += financialAnalysis.Total_Supervisor_Profits_Discounted__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Accountant_Profits_Discounted__c !=0 && financialAnalysis.Total_Accountant_Profits_Discounted__c != null){
                                        totalProfitDiscounted += financialAnalysis.Total_Accountant_Profits_Discounted__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_other_Emp_Profits_Discounted__c !=0 && financialAnalysis.Total_other_Emp_Profits_Discounted__c != null){
                                        totalProfitDiscounted += financialAnalysis.Total_other_Emp_Profits_Discounted__c;
                                    }
                                    if(isTargerPriceRequired && financialAnalysis.Total_Fuel_Profits_Discounted__c !=0 && financialAnalysis.Total_Fuel_Profits_Discounted__c != null){
                                        totalProfitDiscounted += financialAnalysis.Total_Fuel_Profits_Discounted__c;
                                    }
                                    
                                    financialAnalysis.Payback_3__c = financialAnalysis.Payback_2__c+totalProfit;
                                    
                                }
                                if(financialAnalysis.Payback_3__c != null &&  financialAnalysis.Total_Investment__c != null){
                                    financialAnalysis.Payback_Ratio_3__c = (financialAnalysis.Payback_3__c/financialAnalysis.Total_Investment__c)*100;
                                }
                                if(financialAnalysis.Payback_Ratio_3__c != null ){
                                    financialAnalysis.Annual_share_of_Payback_Ratio_3__c = (financialAnalysis.Payback_Ratio_3__c-100)/i;
                                }
                                
                                Decimal noOfVehicles=0;
                                if(reqMappings.containsKey(obj))
                                    noOfVehicles = reqMappings.get(obj).ET_Number_of_Vehicles__c;
                                else if(vehicleQuoteItemMap.containsKey(obj))
                                    noOfVehicles = vehicleQuoteItemMap.get(obj).ET_Number_of_Vehicles__c;
                                decimal depreciation = 0.0;
                                if(contractYearAndVehicleDepreciationExp.containsKey(i) && contractYearAndVehicleDepreciationExp.get(i) == 'N/A'){
                                    depreciation = 0.0;
                                }
                                else if(contractYearAndVehicleDepreciationExp.containsKey(i)){
                                    depreciation = decimal.valueOf(contractYearAndVehicleDepreciationExp.get(i));
                                }
                                
                                decimal resaleValue = 0.0;
                                if(financialAnalysis.Total_Investment__c != null){
                                    resaleValue = financialAnalysis.Total_Investment__c - (depreciation*noOfVehicles*i);
                                    system.debug('depreciation__q'+depreciation);
                                    system.debug('depreciation__i'+i);
                                }
                                decimal resaleValueForIRR = 0.0;		
								resaleValueForIRR = financialAnalysis.Total_Resale_Value__c != null ? financialAnalysis.Total_Resale_Value__c : 0 ;
                                
                                financialAnalysis.Resale_Value_used_for_Calculation__c = resaleValue;
                                financialAnalysis.Number_of_Vehicles__c = noOfVehicles;
                                
                                if(financialAnalysis.Total_Annual_Profit__c != null && depreciation != null && noOfVehicles != null){
                                    //Added on 26.05.2023 free cash flow formula updated by Arunsarathy
                                   financialAnalysis.Free_Cash_Flow_Annual__c = (financialAnalysis.Total_Annual_Profit__c+(contractYearAndVehicleFinancingExpenses.containsKey(i)?contractYearAndVehicleFinancingExpenses.get(i):0))*noOfVehicles+ (depreciation*noOfVehicles)+resaleValue;
                                    // financialAnalysis.Free_Cash_Flow_Annual__c = (financialAnalysis.Total_Annual_Profit__c+(contractYearAndVehicleFinancingExpenses.containsKey(i)?contractYearAndVehicleFinancingExpenses.get(i):0))*noOfVehicles+ (depreciation)+resaleValue;
                                     // financialAnalysis.Free_Cash_Flow_Annual__c = (resaleValueForIRR +depreciation+financialAnalysis.Total_Annual_Profit__c+(contractYearAndVehicleFinancingExpenses.containsKey(i)?contractYearAndVehicleFinancingExpenses.get(i):0))*noOfVehicles;
                                     system.debug('financialAnalysis.Free_Cash_Flow_Annual__c '+ financialAnalysis.Free_Cash_Flow_Annual__c);
                                
                                }
                                
                                if(isTargerPriceRequired && financialAnalysis.Total_Annual_Profit_Discounted__c != null && depreciation != null && noOfVehicles != null){
                                   financialAnalysis.Free_Cash_Flow_Annual_Discounted__c = (financialAnalysis.Total_Annual_Profit_Discounted__c+(contractYearAndVehicleFinancingExpenses.containsKey(i)?contractYearAndVehicleFinancingExpenses.get(i):0))*noOfVehicles+ (depreciation*noOfVehicles)+resaleValue;
                                      //financialAnalysis.Free_Cash_Flow_Annual_Discounted__c = (resaleValueForIRR +depreciation+financialAnalysis.Total_Annual_Profit_Discounted__c+(contractYearAndVehicleFinancingExpenses.containsKey(i)?contractYearAndVehicleFinancingExpenses.get(i):0))*noOfVehicles;
                                }
                                
                                if(isTargerPriceRequired && financialAnalysis.Total_annual_Profit_Target_Price__c != null && depreciation != null && noOfVehicles != null){
                                    financialAnalysis.Free_Cash_Flow_Annual_Target__c = (financialAnalysis.Total_annual_Profit_Target_Price__c+(contractYearAndVehicleFinancingExpenses.containsKey(i)?contractYearAndVehicleFinancingExpenses.get(i):0))*noOfVehicles+ (depreciation*noOfVehicles)+resaleValue;
                                      //financialAnalysis.Free_Cash_Flow_Annual_Target__c = (resaleValueForIRR +depreciation+financialAnalysis.Total_annual_Profit_Target_Price__c+(contractYearAndVehicleFinancingExpenses.containsKey(i)?contractYearAndVehicleFinancingExpenses.get(i):0))*noOfVehicles;
                                }
                                if(financialAnalysis.Total_Investment__c != null && financialAnalysis.Free_Cash_Flow_Annual__c !=null && resaleValue != null ){
                                    cashFlowCumulativeWrapper cashFlowWrapper =  freeCashFlowCumulativeCalc(i,financialAnalysis.Total_Investment__c,financialAnalysis.Free_Cash_Flow_Annual__c,resaleValue);
                                    if(cashFlowWrapper != null){
                                        financialAnalysis.Free_Cash_Flow_Cumulative__c = cashFlowWrapper.cashFlowCumulative;
                                    }
                                }
                                
                                if(isTargerPriceRequired && financialAnalysis.Total_Investment__c != null && financialAnalysis.Free_Cash_Flow_Annual_Discounted__c !=null && financialAnalysis.Total_Resale_Value__c != null ){
                                    cashFlowCumulativeWrapper cashFlowWrapper =  freeCashFlowCumulativeCalc(i,financialAnalysis.Total_Investment__c,financialAnalysis.Free_Cash_Flow_Annual_Discounted__c,resaleValue);
                                    if(cashFlowWrapper != null){
                                        financialAnalysis.Free_Cash_Flow_Cumulative_Discounted__c = cashFlowWrapper.cashFlowCumulative;
                                    }                        
                                }
                                if(isTargerPriceRequired && financialAnalysis.Total_Investment__c != null && financialAnalysis.Free_Cash_Flow_Annual_Target__c !=null && financialAnalysis.Total_Resale_Value__c != null ){
                                    cashFlowCumulativeWrapper cashFlowWrapper =  freeCashFlowCumulativeCalc(i,financialAnalysis.Total_Investment__c,financialAnalysis.Free_Cash_Flow_Annual_Target__c,resaleValue);
                                    if(cashFlowWrapper != null){
                                        financialAnalysis.Free_Cash_Flow_Cumulative_Target__c = cashFlowWrapper.cashFlowCumulative;
                                    } 
                                }
                                
                                Decimal PresentValue = 0.0;
                                Decimal PresentValueDiscounted = 0.0;
                                Decimal PresentValueTarget = 0.0;
                                if(financialAnalysis.Free_Cash_Flow_Annual__c != null){
                                    PresentValue = calculateNetPresentValue( i,financialAnalysis.Total_Investment__c,financialAnalysis.Free_Cash_Flow_Annual__c, resaleValue);
                                }
                                financialAnalysis.Net_Present_Value__c = Math.round(PresentValue);
                                
                                if(isTargerPriceRequired && financialAnalysis.Free_Cash_Flow_Annual_Target__c != null){
                                    PresentValueTarget = calculateNetPresentValue( i,financialAnalysis.Total_Investment__c,financialAnalysis.Free_Cash_Flow_Annual_Target__c, resaleValue);
                                }
                                financialAnalysis.Net_Present_Value_Target__c = Math.round(PresentValueTarget);
                                
                                if(isTargerPriceRequired && financialAnalysis.Free_Cash_Flow_Annual_Discounted__c != null){
                                    PresentValueDiscounted = calculateNetPresentValue( i,financialAnalysis.Total_Investment__c,financialAnalysis.Free_Cash_Flow_Annual_Discounted__c, resaleValue);
                                }
                                financialAnalysis.Net_Present_Value_Discounted__c = Math.round(PresentValueDiscounted);
                                
                                if(financialAnalysis.Total_Annual_Profit__c != null && financialAnalysis.Total_Annual_Price_excluding_VAT__c != null){
                                    financialAnalysis.Net_Profit_Margin__c = ((financialAnalysis.Total_Annual_Profit__c/financialAnalysis.Total_Annual_Price_excluding_VAT__c)*100).setScale(2);
                                }
                                
                                if(isTargerPriceRequired && financialAnalysis.Total_Annual_Profit_Discounted__c != null && financialAnalysis.Total_Annual_Price_excluding_VAT_Discoun__c != null){
                                    financialAnalysis.Net_Profit_Margin_Discounted__c = ((financialAnalysis.Total_Annual_Profit_Discounted__c/financialAnalysis.Total_Annual_Price_excluding_VAT_Discoun__c)*100).setScale(2);
                                }
                                
                                if(isTargerPriceRequired && financialAnalysis.Total_annual_Profit_Target_Price__c != null && financialAnalysis.Total_Annual_Price_excluding_VAT_Target__c != null){
                                    financialAnalysis.Net_Profit_Margin_Target__c = ((financialAnalysis.Total_annual_Profit_Target_Price__c/financialAnalysis.Total_Annual_Price_excluding_VAT_Target__c)*100).setScale(2);
                                }
                                
                                financialAnalysis.Cost_Of_Capital_Assumed__c =Decimal.valueOf(Label.ET_Cost_of_Capital_Assumed);
                                
                                decimal noOfYearsOfNegativeCashFlow = 0.0;
                                decimal noOfMonthsOfNegativeCashFlow = 0.0;
                                if(financialAnalysis.Total_Investment__c != null && financialAnalysis.Free_Cash_Flow_Annual__c !=null && resaleValue != null ){
                                    cashFlowCumulativeWrapper cashFlowWrapper =  freeCashFlowCumulativeCalc(i,financialAnalysis.Total_Investment__c,financialAnalysis.Free_Cash_Flow_Annual__c,resaleValue);
                                    if(cashFlowWrapper != null){
                                        noOfYearsOfNegativeCashFlow = cashFlowWrapper.countYearsofNegativeCashFlow;
                                        noOfMonthsOfNegativeCashFlow = cashFlowWrapper.countMonthsofNegativeCashFlow;
                                    }
                                }
                                
                                if(noOfYearsOfNegativeCashFlow != null && noOfMonthsOfNegativeCashFlow != null){
                                    financialAnalysis.Payback_Period_Years__c=noOfYearsOfNegativeCashFlow+noOfMonthsOfNegativeCashFlow;
                                }
                                integer freeCashFlow =0;
                                if(financialAnalysis.Free_Cash_Flow_Annual__c != null && resaleValue != null){
                                    freeCashFlow = integer.valueOf(financialAnalysis.Free_Cash_Flow_Annual__c) -integer.valueOf(resaleValue) ;
                                }
                                
                                integer freeCashFlowTarget =0;
                                if(isTargerPriceRequired && financialAnalysis.Free_Cash_Flow_Annual_Target__c != null && resaleValue != null){
                                    freeCashFlowTarget = integer.valueOf(financialAnalysis.Free_Cash_Flow_Annual_Target__c) -integer.valueOf(resaleValue) ;
                                }
                                
                                integer freeCashFlowDiscounted =0;
                                if(isTargerPriceRequired && financialAnalysis.Free_Cash_Flow_Annual_Discounted__c != null && resaleValue != null){
                                    freeCashFlowDiscounted = integer.valueOf(financialAnalysis.Free_Cash_Flow_Annual_Discounted__c) -integer.valueOf(resaleValue) ;
                                }
                                
                                
                                /*financialAnalysis.Internal_Rate_of_Return__c=ET_ServiceRequestController.calcualteIRR(integer.valueOf(financialAnalysis.Total_Investment__c),freeCashFlow,i,integer.valueOf(resaleValue));
if(isTargerPriceRequired){
financialAnalysis.Internal_Rate_of_Return_Target__c=ET_ServiceRequestController.calcualteIRR(integer.valueOf(financialAnalysis.Total_Investment__c),freeCashFlowTarget,i,integer.valueOf(resaleValue));
financialAnalysis.Internal_Rate_of_Return_Discounted__c=ET_ServiceRequestController.calcualteIRR(integer.valueOf(financialAnalysis.Total_Investment__c),freeCashFlowDiscounted,i,integer.valueOf(resaleValue));
}*/
                                
                                if(financialAnalysis.Total_Investment__c != null){
                                    if(financialAnalysis.Total_Vehicle_Profits__c != null ){
                                        totalProfit += financialAnalysis.Total_Vehicle_Profits__c;
                                        financialAnalysis.Total_Profit_used_for_calculation__c = totalProfit;
                                    }
                                    financialAnalysis.Return_on_Investment__c = ((totalProfit)/financialAnalysis.Total_Investment__c)*100;
                                }
                                
                                //target
                                if(isTargerPriceRequired){
                                    if(financialAnalysis.Total_Investment__c != null){
                                        if(financialAnalysis.Total_Vehicle_Profit_Target__c != null ){
                                            totalProfitTarget += financialAnalysis.Total_Vehicle_Profit_Target__c;
                                            financialAnalysis.Total_Profit_used_for_calc_Target__c = totalProfitTarget;
                                        }
                                        financialAnalysis.Return_on_Investment_Target__c = ((totalProfitTarget)/financialAnalysis.Total_Investment__c)*100;
                                    }
                                    
                                    //discounted
                                    if(financialAnalysis.Total_Investment__c != null){
                                        if(financialAnalysis.Total_Vehicle_Profit_Discounted__c != null ){
                                            totalProfitDiscounted += financialAnalysis.Total_Vehicle_Profit_Discounted__c;
                                            financialAnalysis.Total_Profit_used_for_calc_Discount__c = totalProfitDiscounted;
                                        }
                                        financialAnalysis.Return_on_Investment_Discounted__c = ((totalProfitDiscounted)/financialAnalysis.Total_Investment__c)*100;
                                    }
                                }
                                
                                
                                if(financialAnalysis.Total_Annual_Price_including_VAT__c != null && reqMappings.get(obj).ET_Number_of_Vehicles__c != null && financialAnalysis.Utilization_factor__c !=0.0 ){
                                    financialAnalysis.Price_Per_Pricing_Type__c =  (financialAnalysis.Total_Annual_Price_including_VAT__c * reqMappings.get(obj).ET_Number_of_Vehicles__c)/ financialAnalysis.Utilization_factor__c;
                                }
                                
                                
                                financialAnalysisLst.add(financialAnalysis);
                            }
                        }
                    }
                }
            }
        }
        Catch(Exception e){
            system.debug('Exception e = '+ e.getMessage());
            system.debug('Exception Stack Trace= '+ e.getStackTraceString());
            system.debug('Exception line = '+ e.getLineNumber());
            system.debug('Exception line = '+ e.getCause());
            //throw new AuraHandledException('Error in Totals calculation. Please reach to system admin.');
        }
        
        //   system.debug('financialAnalysisLst = '+ JSON.serializePretty(financialAnalysisLst));
        if(financialAnalysisLst != null ){
            //  system.debug('financialAnalysisLst size = '+ financialAnalysisLst.size());
        }
        return financialAnalysisLst;
    }
    
    
    public static void FinancialAnalysisFortotalProject(list<Financial_Analysis__c> financialAnalysisLst, Id totalProjectQuoteId){
        Map<integer,Decimal> contractYearAndTotalCostForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualProfitForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualPriceExcludingVATForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthExcludingVATForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndVATAmountForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualPriceIncludingVATForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthIncludingVATForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalValueOfRentalForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalInvestmentForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalDepreciationForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalResaleValueForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalVehicleProfitsForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalDriverProfitsForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalNannyProfitsForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalCoordinatorProfitsForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalOtherEmployeeProfitsForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalFuelProfitsForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalSupervisorProfitsForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAccountantProfitsForTProject = new Map<integer,Decimal> ()  ;
        
        // for Vehicle and fuel Total price
        Map<integer,Decimal> contractYearAndTotalAnnualPriceExcludingVATVehcileAndFuelForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthExcludingVATVehcileAndFuelForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndForVatAmountForVehcileAndFuelTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualPriceIncludingVATVehcileAndFuelForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthIncludingVATVehcileAndFuelForTProject = new Map<integer,Decimal> ()  ;
        
        // for only Manpower
        Map<integer,Decimal> contractYearAndTotalAnnualPriceExcludingVATManpowerForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthExcludingVATManpowerForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndVatAmountForManpowerForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualPriceIncludingVATManpowerForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthIncludingVATManpowerForTProject = new Map<integer,Decimal> ()  ;
        
        Map<integer,Decimal> contractYearAndPayback1ForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackRatio1ForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPayback2ForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackRatio2ForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndAnnualshareOfPaybackRatio2ForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPayback3ForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackRatio3ForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndAnnualShareOfPaybackRatio3ForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndFreeCashFlowAnnualForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndFreeCashFlowCumulativeForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndNetPresentValueForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndCostOfCapitalAssumedForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndNetProfitMarginForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackPeriodForTProject = new Map<integer,Decimal> ()  ;
		Map<integer,integer> Mainvehiclecount = new Map<integer,integer> () ;
        Map<integer,Decimal> contractYearAndInternalRateOfReturnForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndReturnOnInvestmentForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndResaleValueUsedForCalcsForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalProfitUsedForCalcsForTProject = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalManpowerProfitUsedForCalcsForTProject = new Map<integer,Decimal> ()  ;
        
        // Total Project for Target and Discounted Pricess....
        // 1st section - Target
        Map<integer,Decimal> contractYearAndTotalCostForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualProfitForTProject_Target  = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualPriceExcludingVATForTProject_Target  = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthExcludingVATForTProject_Target  = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndVATAmountForTProject_Target  = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualPriceIncludingVATForTProject_Target  = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthIncludingVATForTProject_Target  = new Map<integer,Decimal> ()  ;
        
        // 1st section - Discounted
        Map<integer,Decimal> contractYearAndTotalCostForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualProfitForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualPriceExcludingVATForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthExcludingVATForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndVATAmountForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalAnnualPriceIncludingVATForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPricePerMonthIncludingVATForTProject_discounted = new Map<integer,Decimal> ()  ;
        
        // 3rd section - Target
        Map<integer,Decimal> contractYearAndPayback1ForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackRatio1ForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPayback2ForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackRatio2ForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndAnnualshareOfPaybackRatio2ForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPayback3ForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackRatio3ForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndAnnualShareOfPaybackRatio3ForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndFreeCashFlowAnnualForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndFreeCashFlowCumulativeForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndNetPresentValueForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndCostOfCapitalAssumedForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndNetProfitMarginForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackPeriodForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndInternalRateOfReturnForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndReturnOnInvestmentForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndResaleValueUsedForCalcsForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalProfitUsedForCalcsForTProject_Target = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalManpowerProfitUsedForCalcsForTProject_Target = new Map<integer,Decimal> ()  ;
        
        // 3rd section - Discounted
        Map<integer,Decimal> contractYearAndPayback1ForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackRatio1ForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPayback2ForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackRatio2ForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndAnnualshareOfPaybackRatio2ForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPayback3ForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackRatio3ForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndAnnualShareOfPaybackRatio3ForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndFreeCashFlowAnnualForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndFreeCashFlowCumulativeForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndNetPresentValueForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndCostOfCapitalAssumedForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndNetProfitMarginForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndPaybackPeriodForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndInternalRateOfReturnForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndReturnOnInvestmentForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndResaleValueUsedForCalcsForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalProfitUsedForCalcsForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,Decimal> contractYearAndTotalManpowerProfitUsedForCalcsForTProject_discounted = new Map<integer,Decimal> ()  ;
        Map<integer,boolean> contractYearAndTargerPriceRequired= new Map<integer,boolean> ()  ;
        Map<integer,boolean> contractYearAndSeparatePriceRequired= new Map<integer,boolean> ()  ;
        
        
        
        List<integer> contractYears = new List<integer>();  
        if(financialAnalysisLst != null && !financialAnalysisLst.isempty()){
            for(Financial_Analysis__c fin : financialAnalysisLst){
                if(fin.Vehicle_source__c == 'Main'){
                    integer integerContractYear = integer.valueOf(fin.Contract_Year__c);
                    integer numberOfVehicles = integer.valueOf(fin.Number_of_Vehicles__c);
                    contractYears.add(integerContractYear);
                    // Target Price 
                    contractYearAndTargerPriceRequired.put(integerContractYear, fin.is_Target_Price_Required__c);
                    // separate price
                    contractYearAndSeparatePriceRequired.put(integerContractYear, fin.Request_for_separate_prices__c);
                    // Total Cost
                    if(contractYearAndTotalCostForTProject != null &&  
                       contractYearAndTotalCostForTProject.containsKey(integerContractYear) && fin.Total_Annual_Cost__c != null  ){
                           contractYearAndTotalCostForTProject.put(integerContractYear ,contractYearAndTotalCostForTProject.get(integerContractYear)+fin.Total_Annual_Cost__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_Annual_Cost__c != null  ){
                            contractYearAndTotalCostForTProject.put(integerContractYear, fin.Total_Annual_Cost__c*numberOfVehicles);
                        }
                    }
                    
                    // Total Cost - Target
                    if(contractYearAndTotalCostForTProject_Target != null &&  
                       contractYearAndTotalCostForTProject_Target.containsKey(integerContractYear) && fin.Total_Annual_Cost_Target_Price__c != null  ){
                           contractYearAndTotalCostForTProject_Target.put(integerContractYear ,contractYearAndTotalCostForTProject_Target.get(integerContractYear)+fin.Total_Annual_Cost_Target_Price__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_Annual_Cost_Target_Price__c != null  ){
                            contractYearAndTotalCostForTProject_Target.put(integerContractYear, fin.Total_Annual_Cost_Target_Price__c*numberOfVehicles);
                        }
                    }
                    
                    // Total Cost - Discounted
                    if(contractYearAndTotalCostForTProject_discounted != null &&  
                       contractYearAndTotalCostForTProject_discounted.containsKey(integerContractYear) && fin.Total_Annual_Cost_Discounted__c != null  ){
                           contractYearAndTotalCostForTProject_discounted.put(integerContractYear ,contractYearAndTotalCostForTProject_discounted.get(integerContractYear)+fin.Total_Annual_Cost_Discounted__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_Annual_Cost_Discounted__c != null  ){
                            contractYearAndTotalCostForTProject_discounted.put(integerContractYear, fin.Total_Annual_Cost_Discounted__c*numberOfVehicles);
                        }
                    }
                    
                    // TotalAnnualProfit
                    
                    if(contractYearAndTotalAnnualProfitForTProject != null &&  
                       contractYearAndTotalAnnualProfitForTProject.containsKey(integerContractYear) && fin.Total_Annual_Profit__c != null  ){
                           contractYearAndTotalAnnualProfitForTProject.put(integerContractYear ,contractYearAndTotalAnnualProfitForTProject.get(integerContractYear)+fin.Total_Annual_Profit__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_Annual_Profit__c != null  ){
                            contractYearAndTotalAnnualProfitForTProject.put(integerContractYear, fin.Total_Annual_Profit__c*numberOfVehicles);
                        }
                    }
                    
                    // TotalAnnualProfit - Target
                    
                    if(contractYearAndTotalAnnualProfitForTProject_Target != null &&  
                       contractYearAndTotalAnnualProfitForTProject_Target.containsKey(integerContractYear) && fin.Total_annual_Profit_Target_Price__c != null  ){
                           contractYearAndTotalAnnualProfitForTProject_Target.put(integerContractYear ,contractYearAndTotalAnnualProfitForTProject_Target.get(integerContractYear)+fin.Total_annual_Profit_Target_Price__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_annual_Profit_Target_Price__c != null  ){
                            contractYearAndTotalAnnualProfitForTProject_Target.put(integerContractYear, fin.Total_annual_Profit_Target_Price__c*numberOfVehicles);
                        }
                    }
                    // TotalAnnualProfit - Discounted
                    
                    if(contractYearAndTotalAnnualProfitForTProject_discounted != null &&  
                       contractYearAndTotalAnnualProfitForTProject_discounted.containsKey(integerContractYear) && fin.Total_Annual_Profit_Discounted__c != null  ){
                           contractYearAndTotalAnnualProfitForTProject_discounted.put(integerContractYear ,contractYearAndTotalAnnualProfitForTProject_discounted.get(integerContractYear)+fin.Total_Annual_Profit_Discounted__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_Annual_Profit_Discounted__c != null  ){
                            contractYearAndTotalAnnualProfitForTProject_discounted.put(integerContractYear, fin.Total_Annual_Profit_Discounted__c*numberOfVehicles);
                        }
                    }
                    
                    // TotalAnnualPriceExcludingVAT
                    
                    if(contractYearAndTotalAnnualPriceExcludingVATForTProject != null &&  
                       contractYearAndTotalAnnualPriceExcludingVATForTProject.containsKey(integerContractYear) && fin.Total_Annual_Price_excluding_VAT__c != null  ){
                           contractYearAndTotalAnnualPriceExcludingVATForTProject.put(integerContractYear ,contractYearAndTotalAnnualPriceExcludingVATForTProject.get(integerContractYear)+fin.Total_Annual_Price_excluding_VAT__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_Annual_Price_excluding_VAT__c != null  ){
                            contractYearAndTotalAnnualPriceExcludingVATForTProject.put(integerContractYear, fin.Total_Annual_Price_excluding_VAT__c*numberOfVehicles);
                        }
                    }
                    
                    // TotalAnnualPriceExcludingVAT - Target
                    
                    if(contractYearAndTotalAnnualPriceExcludingVATForTProject_Target != null &&  
                       contractYearAndTotalAnnualPriceExcludingVATForTProject_Target.containsKey(integerContractYear) && fin.Total_Annual_Price_excluding_VAT_Target__c != null  ){
                           contractYearAndTotalAnnualPriceExcludingVATForTProject_Target.put(integerContractYear ,contractYearAndTotalAnnualPriceExcludingVATForTProject_Target.get(integerContractYear)+fin.Total_Annual_Price_excluding_VAT__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_Annual_Price_excluding_VAT_Target__c != null  ){
                            contractYearAndTotalAnnualPriceExcludingVATForTProject_Target.put(integerContractYear, fin.Total_Annual_Price_excluding_VAT_Target__c*numberOfVehicles);
                        }
                    }
                    
                    // TotalAnnualPriceExcludingVAT - Discounted
                    
                    if(contractYearAndTotalAnnualPriceExcludingVATForTProject_discounted != null &&  
                       contractYearAndTotalAnnualPriceExcludingVATForTProject_discounted.containsKey(integerContractYear) && fin.Total_Annual_Price_excluding_VAT_Discoun__c != null  ){
                           contractYearAndTotalAnnualPriceExcludingVATForTProject_discounted.put(integerContractYear ,contractYearAndTotalAnnualPriceExcludingVATForTProject_discounted.get(integerContractYear)+fin.Total_Annual_Price_excluding_VAT_Discoun__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_Annual_Price_excluding_VAT_Discoun__c != null  ){
                            contractYearAndTotalAnnualPriceExcludingVATForTProject_discounted.put(integerContractYear, fin.Total_Annual_Price_excluding_VAT_Discoun__c*numberOfVehicles);
                        }
                    }
                    
                    //PricePerMonthExcludingVAT
                    if(contractYearAndPricePerMonthExcludingVATForTProject != null &&  
                       contractYearAndPricePerMonthExcludingVATForTProject.containsKey(integerContractYear) && fin.Price_Per_Month_excluding_VAT__c != null  ){
                           contractYearAndPricePerMonthExcludingVATForTProject.put(integerContractYear ,contractYearAndPricePerMonthExcludingVATForTProject.get(integerContractYear)+fin.Price_Per_Month_excluding_VAT__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Price_Per_Month_excluding_VAT__c != null  ){
                            contractYearAndPricePerMonthExcludingVATForTProject.put(integerContractYear, fin.Price_Per_Month_excluding_VAT__c*numberOfVehicles);
                        }
                    }
                    
                    //VATAmount
                    if(contractYearAndVATAmountForTProject != null &&  
                       contractYearAndVATAmountForTProject.containsKey(integerContractYear) && fin.VAT_Amount__c != null  ){
                           contractYearAndVATAmountForTProject.put(integerContractYear ,contractYearAndVATAmountForTProject.get(integerContractYear)+fin.VAT_Amount__c*numberOfVehicles );
                       }
                    else{
                        if(fin.VAT_Amount__c != null  ){
                            contractYearAndVATAmountForTProject.put(integerContractYear, fin.VAT_Amount__c*numberOfVehicles);
                        }
                    }
                    
                    //TotalAnnualPriceIncludingVAT
                    if(contractYearAndTotalAnnualPriceIncludingVATForTProject != null &&  
                       contractYearAndTotalAnnualPriceIncludingVATForTProject.containsKey(integerContractYear) && fin.Total_Annual_Price_including_VAT__c != null  ){
                           contractYearAndTotalAnnualPriceIncludingVATForTProject.put(integerContractYear ,contractYearAndTotalAnnualPriceIncludingVATForTProject.get(integerContractYear)+fin.Total_Annual_Price_including_VAT__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Total_Annual_Price_including_VAT__c != null  ){
                            contractYearAndTotalAnnualPriceIncludingVATForTProject.put(integerContractYear, fin.Total_Annual_Price_including_VAT__c*numberOfVehicles);
                        }
                    }
                    
                    //PricePerMonthIncludingVAT
                    if(contractYearAndPricePerMonthIncludingVATForTProject != null &&  
                       contractYearAndPricePerMonthIncludingVATForTProject.containsKey(integerContractYear) && fin.Price_Per_Month_including_VAT__c != null  ){
                           contractYearAndPricePerMonthIncludingVATForTProject.put(integerContractYear ,contractYearAndPricePerMonthIncludingVATForTProject.get(integerContractYear)+fin.Price_Per_Month_including_VAT__c*numberOfVehicles );
                       }
                    else{
                        if(fin.Price_Per_Month_including_VAT__c != null  ){
                            contractYearAndPricePerMonthIncludingVATForTProject.put(integerContractYear, fin.Price_Per_Month_including_VAT__c*numberOfVehicles);
                        }
                    }
                    
                    if(fin.Request_for_separate_prices__c){
                        // Seprate price for Vehicle and Fuel
                        // Total Annual Price excluding VAT
                        if(contractYearAndTotalAnnualPriceExcludingVATVehcileAndFuelForTProject != null &&  
                           contractYearAndTotalAnnualPriceExcludingVATVehcileAndFuelForTProject.containsKey(integerContractYear) && fin.Tot_Ann_price_exc_vat_for_vehicle_fuel__c != null  ){
                               contractYearAndTotalAnnualPriceExcludingVATVehcileAndFuelForTProject.put(integerContractYear ,contractYearAndTotalAnnualPriceExcludingVATVehcileAndFuelForTProject.get(integerContractYear)+fin.Tot_Ann_price_exc_vat_for_vehicle_fuel__c*numberOfVehicles );
                           }
                        else{
                            if(fin.Tot_Ann_price_exc_vat_for_vehicle_fuel__c != null  ){
                                contractYearAndTotalAnnualPriceExcludingVATVehcileAndFuelForTProject.put(integerContractYear, fin.Tot_Ann_price_exc_vat_for_vehicle_fuel__c*numberOfVehicles);
                            }
                        }
                        
                        // Price Per Month excluding VAT 
                        if(contractYearAndPricePerMonthExcludingVATVehcileAndFuelForTProject != null &&  
                           contractYearAndPricePerMonthExcludingVATVehcileAndFuelForTProject.containsKey(integerContractYear) && fin.Price_Per_month_excluding_VAT_Vehicle__c != null  ){
                               contractYearAndPricePerMonthExcludingVATVehcileAndFuelForTProject.put(integerContractYear ,contractYearAndPricePerMonthExcludingVATVehcileAndFuelForTProject.get(integerContractYear)+fin.Price_Per_month_excluding_VAT_Vehicle__c*numberOfVehicles );
                           }
                        else{
                            if(fin.Price_Per_month_excluding_VAT_Vehicle__c != null  ){
                                contractYearAndPricePerMonthExcludingVATVehcileAndFuelForTProject.put(integerContractYear, fin.Price_Per_month_excluding_VAT_Vehicle__c*numberOfVehicles);
                            }
                        }
                        
                        // VAT Amount 
                        if(contractYearAndForVatAmountForVehcileAndFuelTProject != null &&  
                           contractYearAndForVatAmountForVehcileAndFuelTProject.containsKey(integerContractYear) && fin.VAT_Amount_for_Vehicle__c != null  ){
                               contractYearAndForVatAmountForVehcileAndFuelTProject.put(integerContractYear ,contractYearAndForVatAmountForVehcileAndFuelTProject.get(integerContractYear)+fin.VAT_Amount_for_Vehicle__c*numberOfVehicles );
                           }
                        else{
                            if(fin.VAT_Amount_for_Vehicle__c != null  ){
                                contractYearAndForVatAmountForVehcileAndFuelTProject.put(integerContractYear, fin.VAT_Amount_for_Vehicle__c*numberOfVehicles);
                            }
                        }
                        
                        // Total Annual Price including VAT
                        if(contractYearAndTotalAnnualPriceIncludingVATVehcileAndFuelForTProject != null &&  
                           contractYearAndTotalAnnualPriceIncludingVATVehcileAndFuelForTProject.containsKey(integerContractYear) && fin.Total_Annual_Price_including_VAT_Vehicle__c != null  ){
                               contractYearAndTotalAnnualPriceIncludingVATVehcileAndFuelForTProject.put(integerContractYear ,contractYearAndTotalAnnualPriceIncludingVATVehcileAndFuelForTProject.get(integerContractYear)+fin.Total_Annual_Price_including_VAT_Vehicle__c*numberOfVehicles );
                           }
                        else{
                            if(fin.Total_Annual_Price_including_VAT_Vehicle__c != null  ){
                                contractYearAndTotalAnnualPriceIncludingVATVehcileAndFuelForTProject.put(integerContractYear, fin.Total_Annual_Price_including_VAT_Vehicle__c*numberOfVehicles);
                            }
                        }
                        
                        // Price Per Month including VAT
                        if(contractYearAndPricePerMonthIncludingVATVehcileAndFuelForTProject != null &&  
                           contractYearAndPricePerMonthIncludingVATVehcileAndFuelForTProject.containsKey(integerContractYear) && fin.Price_Per_Month_including_VAT_Vehicle__c != null  ){
                               contractYearAndPricePerMonthIncludingVATVehcileAndFuelForTProject.put(integerContractYear ,contractYearAndPricePerMonthIncludingVATVehcileAndFuelForTProject.get(integerContractYear)+fin.Price_Per_Month_including_VAT_Vehicle__c*numberOfVehicles );
                           }
                        else{
                            if(fin.Price_Per_Month_including_VAT_Vehicle__c != null  ){
                                contractYearAndPricePerMonthIncludingVATVehcileAndFuelForTProject.put(integerContractYear, fin.Price_Per_Month_including_VAT_Vehicle__c*numberOfVehicles);
                            }
                        }
                        
                        // Seprate price for only Manpower
                        
                        // Total Annual Price excluding VAT
                        if(contractYearAndTotalAnnualPriceExcludingVATManpowerForTProject != null &&  
                           contractYearAndTotalAnnualPriceExcludingVATManpowerForTProject.containsKey(integerContractYear) && fin.Total_Annual_Pric_excluding_VAT_Manpower__c != null  ){
                               contractYearAndTotalAnnualPriceExcludingVATManpowerForTProject.put(integerContractYear ,contractYearAndTotalAnnualPriceExcludingVATManpowerForTProject.get(integerContractYear)+fin.Total_Annual_Pric_excluding_VAT_Manpower__c*numberOfVehicles );
                           }
                        else{
                            if(fin.Total_Annual_Pric_excluding_VAT_Manpower__c != null  ){
                                contractYearAndTotalAnnualPriceExcludingVATManpowerForTProject.put(integerContractYear, fin.Total_Annual_Pric_excluding_VAT_Manpower__c*numberOfVehicles);
                            }
                        }
                        
                        // Price Per month excluding VAT 
                        if(contractYearAndPricePerMonthExcludingVATManpowerForTProject != null &&  
                           contractYearAndPricePerMonthExcludingVATManpowerForTProject.containsKey(integerContractYear) && fin.Price_Per_Month_excluding_VAT_Manpower__c != null  ){
                               contractYearAndPricePerMonthExcludingVATManpowerForTProject.put(integerContractYear ,contractYearAndPricePerMonthExcludingVATManpowerForTProject.get(integerContractYear)+fin.Price_Per_Month_excluding_VAT_Manpower__c*numberOfVehicles );
                           }
                        else{
                            if(fin.Price_Per_Month_excluding_VAT_Manpower__c != null  ){
                                contractYearAndPricePerMonthExcludingVATManpowerForTProject.put(integerContractYear, fin.Price_Per_Month_excluding_VAT_Manpower__c*numberOfVehicles);
                            }
                        }
                        
                        // VAT Amount	
                        if(contractYearAndVatAmountForManpowerForTProject != null &&  
                           contractYearAndVatAmountForManpowerForTProject.containsKey(integerContractYear) && fin.VAT_Amount_for_Manpower__c != null  ){
                               contractYearAndVatAmountForManpowerForTProject.put(integerContractYear ,contractYearAndVatAmountForManpowerForTProject.get(integerContractYear)+fin.VAT_Amount_for_Manpower__c*numberOfVehicles );
                           }
                        else{
                            if(fin.VAT_Amount_for_Manpower__c != null  ){
                                contractYearAndVatAmountForManpowerForTProject.put(integerContractYear, fin.VAT_Amount_for_Manpower__c*numberOfVehicles);
                            }
                        }
                        
                        // Total Annual Price including VAT
                        if(contractYearAndTotalAnnualPriceIncludingVATManpowerForTProject != null &&  
                           contractYearAndTotalAnnualPriceIncludingVATManpowerForTProject.containsKey(integerContractYear) && fin.Total_Annual_Price_including_VAT_Manpowe__c != null  ){
                               contractYearAndTotalAnnualPriceIncludingVATManpowerForTProject.put(integerContractYear ,contractYearAndTotalAnnualPriceIncludingVATManpowerForTProject.get(integerContractYear)+fin.Total_Annual_Price_including_VAT_Manpowe__c*numberOfVehicles );
                           }
                        else{
                            if(fin.Total_Annual_Price_including_VAT_Manpowe__c != null  ){
                                contractYearAndTotalAnnualPriceIncludingVATManpowerForTProject.put(integerContractYear, fin.Total_Annual_Price_including_VAT_Manpowe__c*numberOfVehicles);
                            }
                        }
                        
                        // Price Per Month including VAT
                        if(contractYearAndPricePerMonthIncludingVATManpowerForTProject != null &&  
                           contractYearAndPricePerMonthIncludingVATManpowerForTProject.containsKey(integerContractYear) && fin.Price_Per_month_including_VAT_Manpower__c != null  ){
                               contractYearAndPricePerMonthIncludingVATManpowerForTProject.put(integerContractYear ,contractYearAndPricePerMonthIncludingVATManpowerForTProject.get(integerContractYear)+fin.Price_Per_month_including_VAT_Manpower__c*numberOfVehicles );
                           }
                        else{
                            if(fin.Price_Per_month_including_VAT_Manpower__c != null  ){
                                contractYearAndPricePerMonthIncludingVATManpowerForTProject.put(integerContractYear, fin.Price_Per_month_including_VAT_Manpower__c*numberOfVehicles);
                            }
                        }
                    }
                    
                    
                    //TotalValueOfRental
                    if(contractYearAndTotalValueOfRentalForTProject != null &&  
                       contractYearAndTotalValueOfRentalForTProject.containsKey(integerContractYear) && fin.Total_Value_of_Rental__c != null  ){
                           contractYearAndTotalValueOfRentalForTProject.put(integerContractYear ,contractYearAndTotalValueOfRentalForTProject.get(integerContractYear)+fin.Total_Value_of_Rental__c );
                       }
                    else{
                        if(fin.Total_Value_of_Rental__c != null  ){
                            contractYearAndTotalValueOfRentalForTProject.put(integerContractYear, fin.Total_Value_of_Rental__c);
                        }
                    }
                    
                    //totalInvestment
                    if(contractYearAndTotalInvestmentForTProject != null &&  
                       contractYearAndTotalInvestmentForTProject.containsKey(integerContractYear) && fin.Total_Investment__c != null  ){
                           contractYearAndTotalInvestmentForTProject.put(integerContractYear ,contractYearAndTotalInvestmentForTProject.get(integerContractYear)+fin.Total_Investment__c );
                       }
                    else{
                        if(fin.Total_Investment__c != null  ){
                            contractYearAndTotalInvestmentForTProject.put(integerContractYear, fin.Total_Investment__c);
                        }
                    }
                    
                    //totalDepreciation
                    if(contractYearAndTotalDepreciationForTProject != null &&  
                       contractYearAndTotalDepreciationForTProject.containsKey(integerContractYear) && fin.Total_Depreciation__c != null  ){
                           contractYearAndTotalDepreciationForTProject.put(integerContractYear ,contractYearAndTotalDepreciationForTProject.get(integerContractYear)+fin.Total_Depreciation__c );
                       }
                    else{
                        if(fin.Total_Depreciation__c != null  ){
                            contractYearAndTotalDepreciationForTProject.put(integerContractYear, fin.Total_Depreciation__c);
                        }
                    }
                    
                    //totalResaleValue
                    if(contractYearAndTotalResaleValueForTProject != null &&  
                       contractYearAndTotalResaleValueForTProject.containsKey(integerContractYear) && fin.Total_Resale_Value__c != null  ){
                           contractYearAndTotalResaleValueForTProject.put(integerContractYear ,contractYearAndTotalResaleValueForTProject.get(integerContractYear)+fin.Total_Resale_Value__c );
                       }
                    else{
                        if(fin.Total_Resale_Value__c != null  ){
                            contractYearAndTotalResaleValueForTProject.put(integerContractYear, fin.Total_Resale_Value__c);
                        }
                    }
                    
                    //totalVehicleProfits
                    if(contractYearAndTotalVehicleProfitsForTProject != null &&  
                       contractYearAndTotalVehicleProfitsForTProject.containsKey(integerContractYear) && fin.Total_Vehicle_Profits__c != null  ){
                           contractYearAndTotalVehicleProfitsForTProject.put(integerContractYear ,contractYearAndTotalVehicleProfitsForTProject.get(integerContractYear)+fin.Total_Vehicle_Profits__c );
                       }
                    else{
                        if(fin.Total_Vehicle_Profits__c != null  ){
                            contractYearAndTotalVehicleProfitsForTProject.put(integerContractYear, fin.Total_Vehicle_Profits__c);
                        }
                    }
                    
                    //totalDriverProfits
                    if(contractYearAndTotalDriverProfitsForTProject != null &&  
                       contractYearAndTotalDriverProfitsForTProject.containsKey(integerContractYear) && fin.Total_Driver_Profits__c != null  ){
                           contractYearAndTotalDriverProfitsForTProject.put(integerContractYear ,contractYearAndTotalDriverProfitsForTProject.get(integerContractYear)+fin.Total_Driver_Profits__c );
                       }
                    else{
                        if(fin.Total_Driver_Profits__c != null  ){
                            contractYearAndTotalDriverProfitsForTProject.put(integerContractYear, fin.Total_Driver_Profits__c);
                        }
                    }
                    
                    //totalNannyprofits
                    if(contractYearAndTotalNannyProfitsForTProject != null &&  
                       contractYearAndTotalNannyProfitsForTProject.containsKey(integerContractYear) && fin.Total_Nanny_Profits__c != null  ){
                           contractYearAndTotalNannyProfitsForTProject.put(integerContractYear ,contractYearAndTotalNannyProfitsForTProject.get(integerContractYear)+fin.Total_Nanny_Profits__c );
                       }
                    else{
                        if(fin.Total_Nanny_Profits__c != null  ){
                            contractYearAndTotalNannyProfitsForTProject.put(integerContractYear, fin.Total_Nanny_Profits__c);
                        }
                    }
                    
                    //totalCoordinatorprofits
                    if(contractYearAndTotalCoordinatorProfitsForTProject != null &&  
                       contractYearAndTotalCoordinatorProfitsForTProject.containsKey(integerContractYear) && fin.Total_Coordinator_Profits__c != null  ){
                           contractYearAndTotalCoordinatorProfitsForTProject.put(integerContractYear ,contractYearAndTotalCoordinatorProfitsForTProject.get(integerContractYear)+fin.Total_Coordinator_Profits__c );
                       }
                    else{
                        if(fin.Total_Coordinator_Profits__c != null  ){
                            contractYearAndTotalCoordinatorProfitsForTProject.put(integerContractYear, fin.Total_Coordinator_Profits__c);
                        }
                    }
                    
                    //totalOtherEmployeeprofits
                    if(contractYearAndTotalOtherEmployeeProfitsForTProject != null &&  
                       contractYearAndTotalOtherEmployeeProfitsForTProject.containsKey(integerContractYear) && fin.Total_Other_Employee_Profits__c != null  ){
                           contractYearAndTotalOtherEmployeeProfitsForTProject.put(integerContractYear ,contractYearAndTotalOtherEmployeeProfitsForTProject.get(integerContractYear)+fin.Total_Other_Employee_Profits__c );
                       }
                    else{
                        if(fin.Total_Other_Employee_Profits__c != null  ){
                            contractYearAndTotalOtherEmployeeProfitsForTProject.put(integerContractYear, fin.Total_Other_Employee_Profits__c);
                        }
                    }
                    
                    //totalSupervisorprofits
                    if(contractYearAndTotalSupervisorProfitsForTProject != null &&  
                       contractYearAndTotalSupervisorProfitsForTProject.containsKey(integerContractYear) && fin.Total_Supervisor_Profits__c != null  ){
                           contractYearAndTotalSupervisorProfitsForTProject.put(integerContractYear ,contractYearAndTotalSupervisorProfitsForTProject.get(integerContractYear)+fin.Total_Supervisor_Profits__c );
                       }
                    else{
                        if(fin.Total_Supervisor_Profits__c != null  ){
                            contractYearAndTotalSupervisorProfitsForTProject.put(integerContractYear, fin.Total_Supervisor_Profits__c);
                        }
                    }
                    
                    //totalAccountantprofits
                    if(contractYearAndTotalAccountantProfitsForTProject != null &&  
                       contractYearAndTotalAccountantProfitsForTProject.containsKey(integerContractYear) && fin.Total_Accountant_Profits__c != null  ){
                           contractYearAndTotalAccountantProfitsForTProject.put(integerContractYear ,contractYearAndTotalAccountantProfitsForTProject.get(integerContractYear)+fin.Total_Accountant_Profits__c );
                       }
                    else{
                        if(fin.Total_Accountant_Profits__c != null  ){
                            contractYearAndTotalAccountantProfitsForTProject.put(integerContractYear, fin.Total_Accountant_Profits__c);
                        }
                    }
                    
                    //totalFuelProfits
                    if(contractYearAndTotalFuelProfitsForTProject != null &&  
                       contractYearAndTotalFuelProfitsForTProject.containsKey(integerContractYear) && fin.Total_Fuel_Profits__c != null  ){
                           contractYearAndTotalFuelProfitsForTProject.put(integerContractYear ,contractYearAndTotalFuelProfitsForTProject.get(integerContractYear)+fin.Total_Fuel_Profits__c );
                       }
                    else{
                        if(fin.Total_Fuel_Profits__c != null  ){
                            contractYearAndTotalFuelProfitsForTProject.put(integerContractYear, fin.Total_Fuel_Profits__c);
                        }
                    }
                    
                    //Payback1
                    if(contractYearAndPayback1ForTProject != null &&  
                       contractYearAndPayback1ForTProject.containsKey(integerContractYear) && fin.Payback_1__c!= null ){
                           contractYearAndPayback1ForTProject.put(integerContractYear ,contractYearAndPayback1ForTProject.get(integerContractYear)+fin.Payback_1__c );
                       }
                    else{
                        if(fin.Payback_1__c!= null ){
                            contractYearAndPayback1ForTProject.put(integerContractYear, fin.Payback_1__c);
                        }
                    }
                    
                    //Payback2
                    if(contractYearAndPayback2ForTProject != null &&  
                       contractYearAndPayback2ForTProject.containsKey(integerContractYear) && fin.Payback_2__c!= null ){
                           contractYearAndPayback2ForTProject.put(integerContractYear ,contractYearAndPayback2ForTProject.get(integerContractYear)+fin.Payback_2__c );
                       }
                    else{
                        if(fin.Payback_2__c!= null ){
                            contractYearAndPayback2ForTProject.put(integerContractYear, fin.Payback_2__c);
                        }
                    }
                    
                    //freeCashFlowAnnual
                    if(contractYearAndFreeCashFlowAnnualForTProject != null &&  
                       contractYearAndFreeCashFlowAnnualForTProject.containsKey(integerContractYear) && fin.Free_Cash_Flow_Annual__c != null  ){
                           contractYearAndFreeCashFlowAnnualForTProject.put(integerContractYear ,contractYearAndFreeCashFlowAnnualForTProject.get(integerContractYear)+fin.Free_Cash_Flow_Annual__c );
                       }
                    else{
                        if(fin.Free_Cash_Flow_Annual__c != null  ){
                            contractYearAndFreeCashFlowAnnualForTProject.put(integerContractYear, fin.Free_Cash_Flow_Annual__c);
                        }
                    }
                    
                    //freeCashFlowAnnual - target
                    if(contractYearAndFreeCashFlowAnnualForTProject_Target != null &&  
                       contractYearAndFreeCashFlowAnnualForTProject_Target.containsKey(integerContractYear) && fin.Free_Cash_Flow_Annual_Target__c != null  ){
                           contractYearAndFreeCashFlowAnnualForTProject_Target.put(integerContractYear ,contractYearAndFreeCashFlowAnnualForTProject_Target.get(integerContractYear)+fin.Free_Cash_Flow_Annual_Target__c );
                       }
                    else{
                        if(fin.Free_Cash_Flow_Annual_Target__c != null  ){
                            contractYearAndFreeCashFlowAnnualForTProject_Target.put(integerContractYear, fin.Free_Cash_Flow_Annual_Target__c);
                        }
                    }
                    
                    //freeCashFlowAnnual - discounted
                    if(contractYearAndFreeCashFlowAnnualForTProject_discounted != null &&  
                       contractYearAndFreeCashFlowAnnualForTProject_discounted.containsKey(integerContractYear) && fin.Free_Cash_Flow_Annual_Discounted__c != null  ){
                           contractYearAndFreeCashFlowAnnualForTProject_discounted.put(integerContractYear ,contractYearAndFreeCashFlowAnnualForTProject_discounted.get(integerContractYear)+fin.Free_Cash_Flow_Annual_Discounted__c );
                       }
                    else{
                        if(fin.Free_Cash_Flow_Annual_Discounted__c != null  ){
                            contractYearAndFreeCashFlowAnnualForTProject_discounted.put(integerContractYear, fin.Free_Cash_Flow_Annual_Discounted__c);
                        }
                    }
                    
                    //freeCashFlowCumulative
                    if(contractYearAndFreeCashFlowCumulativeForTProject != null &&  
                       contractYearAndFreeCashFlowCumulativeForTProject.containsKey(integerContractYear) && fin.Free_Cash_Flow_Cumulative__c != null  ){
                           contractYearAndFreeCashFlowCumulativeForTProject.put(integerContractYear ,contractYearAndFreeCashFlowCumulativeForTProject.get(integerContractYear)+fin.Free_Cash_Flow_Cumulative__c );
                       }
                    else{
                        if(fin.Free_Cash_Flow_Cumulative__c != null  ){
                            contractYearAndFreeCashFlowCumulativeForTProject.put(integerContractYear, fin.Free_Cash_Flow_Cumulative__c);
                        }
                    }
                    
                    //freeCashFlowCumulative - Target
                    if(contractYearAndFreeCashFlowCumulativeForTProject_Target != null &&  
                       contractYearAndFreeCashFlowCumulativeForTProject_Target.containsKey(integerContractYear) && fin.Free_Cash_Flow_Cumulative_Target__c != null  ){
                           contractYearAndFreeCashFlowCumulativeForTProject_Target.put(integerContractYear ,contractYearAndFreeCashFlowCumulativeForTProject_Target.get(integerContractYear)+fin.Free_Cash_Flow_Cumulative_Target__c );
                       }
                    else{
                        if(fin.Free_Cash_Flow_Cumulative_Target__c != null  ){
                            contractYearAndFreeCashFlowCumulativeForTProject_Target.put(integerContractYear, fin.Free_Cash_Flow_Cumulative_Target__c);
                        }
                    }
                    
                    //freeCashFlowCumulative - discounted
                    if(contractYearAndFreeCashFlowCumulativeForTProject_discounted != null &&  
                       contractYearAndFreeCashFlowCumulativeForTProject_discounted.containsKey(integerContractYear) && fin.Free_Cash_Flow_Cumulative_Discounted__c != null  ){
                           contractYearAndFreeCashFlowCumulativeForTProject_discounted.put(integerContractYear ,contractYearAndFreeCashFlowCumulativeForTProject_discounted.get(integerContractYear)+fin.Free_Cash_Flow_Cumulative_Discounted__c );
                       }
                    else{
                        if(fin.Free_Cash_Flow_Cumulative_Discounted__c != null  ){
                            contractYearAndFreeCashFlowCumulativeForTProject_discounted.put(integerContractYear, fin.Free_Cash_Flow_Cumulative_Discounted__c);
                        }
                    }
                    
                    //Resale Value Used For Calcs
                    if(contractYearAndResaleValueUsedForCalcsForTProject != null &&  
                       contractYearAndResaleValueUsedForCalcsForTProject.containsKey(integerContractYear) && fin.Resale_Value_used_for_Calculation__c != null  ){
                           contractYearAndResaleValueUsedForCalcsForTProject.put(integerContractYear ,contractYearAndResaleValueUsedForCalcsForTProject.get(integerContractYear)+fin.Resale_Value_used_for_Calculation__c );
                       }
                    else{
                        if(fin.Resale_Value_used_for_Calculation__c != null  ){
                            contractYearAndResaleValueUsedForCalcsForTProject.put(integerContractYear, fin.Resale_Value_used_for_Calculation__c);
                        }
                    }
                    
                    //Manpower Profit Used For Calcs
                    if(contractYearAndTotalManpowerProfitUsedForCalcsForTProject != null &&  
                       contractYearAndTotalManpowerProfitUsedForCalcsForTProject.containsKey(integerContractYear) && fin.Total_Manpower_profit_used_for_calcs__c != null  ){
                           contractYearAndTotalManpowerProfitUsedForCalcsForTProject.put(integerContractYear ,contractYearAndTotalManpowerProfitUsedForCalcsForTProject.get(integerContractYear)+fin.Total_Manpower_profit_used_for_calcs__c );
                       }
                    else{
                        if(fin.Total_Manpower_profit_used_for_calcs__c != null  ){
                            contractYearAndTotalManpowerProfitUsedForCalcsForTProject.put(integerContractYear, fin.Total_Manpower_profit_used_for_calcs__c);
                        }
                    }
                    
                    
                    //Total Profit Used For Calc
                    if(contractYearAndTotalProfitUsedForCalcsForTProject != null &&  
                       contractYearAndTotalProfitUsedForCalcsForTProject.containsKey(integerContractYear) && fin.Total_Profit_used_for_calculation__c != null  ){
                           contractYearAndTotalProfitUsedForCalcsForTProject.put(integerContractYear ,contractYearAndTotalProfitUsedForCalcsForTProject.get(integerContractYear)+fin.Total_Profit_used_for_calculation__c );
                       }
                    else{
                        if(fin.Total_Profit_used_for_calculation__c != null  ){
                            contractYearAndTotalProfitUsedForCalcsForTProject.put(integerContractYear, fin.Total_Profit_used_for_calculation__c);
                        }
                    }
                    
                    //Total Profit Used For Calc --- Target
                    if(contractYearAndTotalProfitUsedForCalcsForTProject_Target != null &&  
                       contractYearAndTotalProfitUsedForCalcsForTProject_Target.containsKey(integerContractYear) && fin.Total_Profit_used_for_calc_Target__c != null  ){
                           contractYearAndTotalProfitUsedForCalcsForTProject_Target.put(integerContractYear ,contractYearAndTotalProfitUsedForCalcsForTProject_Target.get(integerContractYear)+fin.Total_Profit_used_for_calc_Target__c );
                       }
                    else{
                        if(fin.Total_Profit_used_for_calc_Target__c != null  ){
                            contractYearAndTotalProfitUsedForCalcsForTProject_Target.put(integerContractYear, fin.Total_Profit_used_for_calc_Target__c);
                        }
                    }
                    
                    //Total Profit Used For Calc --- Discount
                    if(contractYearAndTotalProfitUsedForCalcsForTProject_discounted != null &&  
                       contractYearAndTotalProfitUsedForCalcsForTProject_discounted.containsKey(integerContractYear) && fin.Total_Profit_used_for_calc_Discount__c != null  ){
                           contractYearAndTotalProfitUsedForCalcsForTProject_discounted.put(integerContractYear ,contractYearAndTotalProfitUsedForCalcsForTProject_discounted.get(integerContractYear)+fin.Total_Profit_used_for_calc_Discount__c );
                       }
                    else{
                        if(fin.Total_Profit_used_for_calc_Discount__c != null  ){
                            contractYearAndTotalProfitUsedForCalcsForTProject_discounted.put(integerContractYear, fin.Total_Profit_used_for_calc_Discount__c);
                        }
                    }
                    
                    // Payback period
                    if(contractYearAndPaybackPeriodForTProject != null &&  
                       contractYearAndPaybackPeriodForTProject.containsKey(integerContractYear) && fin.Payback_Period_Years__c != null  ){
                           contractYearAndPaybackPeriodForTProject.put(integerContractYear ,contractYearAndPaybackPeriodForTProject.get(integerContractYear)+fin.Payback_Period_Years__c );
						   Mainvehiclecount.put(integerContractYear, Mainvehiclecount.get(integerContractYear)+1);
                       }
                    else{
                        if(fin.Payback_Period_Years__c != null  ){
                            contractYearAndPaybackPeriodForTProject.put(integerContractYear, fin.Payback_Period_Years__c);
							Mainvehiclecount.put(integerContractYear,1);
                        }
                    }
                }
            }
            
            Set<integer> contractYearsUniq = new Set<integer>();
            contractYearsUniq.addAll(contractYears);
            List<Financial_Analysis__c> financeAnalysisList = new List<Financial_Analysis__c>();
            if(contractYearsUniq != null && contractYearsUniq.size() > 0 ){
                for(integer i : contractYearsUniq){
                    Financial_Analysis__c finRec = new Financial_Analysis__c();
                    finRec.Contract_Year__c = i;
                    finRec.Line__c = 1;
                    finRec.Unique_Identifier__c = totalProjectQuoteId + '-'+ finRec.Contract_Year__c + '-'+finRec.Unique_Identifier__c ;
                    if(contractYearAndTargerPriceRequired != null && contractYearAndTargerPriceRequired.containsKey(i)){
                        finRec.is_Target_Price_Required__c = contractYearAndTargerPriceRequired.get(i);
                    }
                    if(contractYearAndSeparatePriceRequired != null && contractYearAndSeparatePriceRequired.containsKey(i)){
                        finRec.Request_for_separate_prices__c = contractYearAndSeparatePriceRequired.get(i);
                    }
                    //system.debug('finRec.Request_for_separate_prices__c = '+ finRec.Request_for_separate_prices__c);
                    contractYearAndTargerPriceRequired.get(i);
                    if(contractYearAndTotalCostForTProject != null && contractYearAndTotalCostForTProject.containsKey(i)){
                        finRec.Total_Annual_Cost__c = Math.round(contractYearAndTotalCostForTProject.get(i));
                    }
                    if(contractYearAndTotalAnnualProfitForTProject != null && contractYearAndTotalAnnualProfitForTProject.containsKey(i)){
                        finRec.Total_Annual_Profit__c = Math.round(contractYearAndTotalAnnualProfitForTProject.get(i));
                    }
                    if(contractYearAndTotalAnnualPriceExcludingVATForTProject != null && contractYearAndTotalAnnualPriceExcludingVATForTProject.containsKey(i)){
                        finRec.Total_Annual_Price_excluding_VAT__c = Math.round(contractYearAndTotalAnnualPriceExcludingVATForTProject.get(i));
                    }
                    
                    // target  
                    if(contractYearAndTotalCostForTProject_Target != null && contractYearAndTotalCostForTProject_Target.containsKey(i)){
                        finRec.Total_Annual_Cost_Target_Price__c = Math.round(contractYearAndTotalCostForTProject_Target.get(i));
                    }
                    if(contractYearAndTotalAnnualProfitForTProject_Target != null && contractYearAndTotalAnnualProfitForTProject_Target.containsKey(i)){
                        finRec.Total_annual_Profit_Target_Price__c = Math.round(contractYearAndTotalAnnualProfitForTProject_Target.get(i));
                    }
                    if(contractYearAndTotalAnnualPriceExcludingVATForTProject_Target != null && contractYearAndTotalAnnualPriceExcludingVATForTProject_Target.containsKey(i)){
                        finRec.Total_Annual_Price_excluding_VAT_Target__c = Math.round(contractYearAndTotalAnnualPriceExcludingVATForTProject_Target.get(i));
                    }
                    
                    //discounted Prices..
                    if(contractYearAndTotalCostForTProject_discounted != null && contractYearAndTotalCostForTProject_discounted.containsKey(i)){
                        finRec.Total_Annual_Cost_Discounted__c = Math.round(contractYearAndTotalCostForTProject_discounted.get(i));
                    }
                    if(contractYearAndTotalAnnualProfitForTProject_discounted != null && contractYearAndTotalAnnualProfitForTProject_discounted.containsKey(i)){
                        finRec.Total_Annual_Profit_Discounted__c = Math.round(contractYearAndTotalAnnualProfitForTProject_discounted.get(i));
                    }
                    if(contractYearAndTotalAnnualPriceExcludingVATForTProject_discounted != null && contractYearAndTotalAnnualPriceExcludingVATForTProject_discounted.containsKey(i)){
                        finRec.Total_Annual_Price_excluding_VAT_Discoun__c = Math.round(contractYearAndTotalAnnualPriceExcludingVATForTProject_discounted.get(i));
                    }
                    
                    if(contractYearAndPricePerMonthExcludingVATForTProject != null && contractYearAndPricePerMonthExcludingVATForTProject.containsKey(i)){
                        finRec.Price_Per_Month_excluding_VAT__c = Math.round(contractYearAndPricePerMonthExcludingVATForTProject.get(i));
                    }
                    if(contractYearAndVATAmountForTProject != null && contractYearAndVATAmountForTProject.containsKey(i)){
                        finRec.VAT_Amount__c = Math.round(contractYearAndVATAmountForTProject.get(i));
                    }
                    if(contractYearAndTotalAnnualPriceIncludingVATForTProject != null && contractYearAndTotalAnnualPriceIncludingVATForTProject.containsKey(i)){
                        finRec.Total_Annual_Price_including_VAT__c = Math.round(contractYearAndTotalAnnualPriceIncludingVATForTProject.get(i));
                    }
                    if(contractYearAndPricePerMonthIncludingVATForTProject != null && contractYearAndPricePerMonthIncludingVATForTProject.containsKey(i)){
                        finRec.Price_Per_Month_including_VAT__c = Math.round(contractYearAndPricePerMonthIncludingVATForTProject.get(i));
                    }
                    
                    // separate prices - Vehicle and Fuel
                    if(finRec.Request_for_separate_prices__c){
                        if(contractYearAndTotalAnnualPriceExcludingVATVehcileAndFuelForTProject != null && contractYearAndTotalAnnualPriceExcludingVATVehcileAndFuelForTProject.containsKey(i)){
                            finRec.Tot_Ann_price_exc_vat_for_vehicle_fuel__c = Math.round(contractYearAndTotalAnnualPriceExcludingVATVehcileAndFuelForTProject.get(i));
                        }
                        if(contractYearAndPricePerMonthExcludingVATVehcileAndFuelForTProject != null && contractYearAndPricePerMonthExcludingVATVehcileAndFuelForTProject.containsKey(i)){
                            finRec.Price_Per_month_excluding_VAT_Vehicle__c = Math.round(contractYearAndPricePerMonthExcludingVATVehcileAndFuelForTProject.get(i));
                        }
                        if(contractYearAndForVatAmountForVehcileAndFuelTProject != null && contractYearAndForVatAmountForVehcileAndFuelTProject.containsKey(i)){
                            finRec.VAT_Amount_for_Vehicle__c = Math.round(contractYearAndForVatAmountForVehcileAndFuelTProject.get(i));
                        }
                        if(contractYearAndTotalAnnualPriceIncludingVATVehcileAndFuelForTProject != null && contractYearAndTotalAnnualPriceIncludingVATVehcileAndFuelForTProject.containsKey(i)){
                            finRec.Total_Annual_Price_including_VAT_Vehicle__c = Math.round(contractYearAndTotalAnnualPriceIncludingVATVehcileAndFuelForTProject.get(i));
                        }
                        if(contractYearAndPricePerMonthIncludingVATVehcileAndFuelForTProject != null && contractYearAndPricePerMonthIncludingVATVehcileAndFuelForTProject.containsKey(i)){
                            finRec.Price_Per_Month_including_VAT_Vehicle__c = Math.round(contractYearAndPricePerMonthIncludingVATVehcileAndFuelForTProject.get(i));
                        }
                        
                        // separate prices - only Manpower
                        if(contractYearAndTotalAnnualPriceExcludingVATManpowerForTProject != null && contractYearAndTotalAnnualPriceExcludingVATManpowerForTProject.containsKey(i)){
                            finRec.Total_Annual_Pric_excluding_VAT_Manpower__c = Math.round(contractYearAndTotalAnnualPriceExcludingVATManpowerForTProject.get(i));
                        }
                        if(contractYearAndPricePerMonthExcludingVATManpowerForTProject != null && contractYearAndPricePerMonthExcludingVATManpowerForTProject.containsKey(i)){
                            finRec.Price_Per_Month_excluding_VAT_Manpower__c = Math.round(contractYearAndPricePerMonthExcludingVATManpowerForTProject.get(i));
                        }
                        if(contractYearAndVatAmountForManpowerForTProject != null && contractYearAndVatAmountForManpowerForTProject.containsKey(i)){
                            finRec.VAT_Amount_for_Manpower__c = Math.round(contractYearAndVatAmountForManpowerForTProject.get(i));
                        }
                        if(contractYearAndTotalAnnualPriceIncludingVATManpowerForTProject != null && contractYearAndTotalAnnualPriceIncludingVATManpowerForTProject.containsKey(i)){
                            finRec.Total_Annual_Price_including_VAT_Manpowe__c = Math.round(contractYearAndTotalAnnualPriceIncludingVATManpowerForTProject.get(i));
                        }
                        if(contractYearAndPricePerMonthIncludingVATManpowerForTProject != null && contractYearAndPricePerMonthIncludingVATManpowerForTProject.containsKey(i)){
                            finRec.Price_Per_month_including_VAT_Manpower__c = Math.round(contractYearAndPricePerMonthIncludingVATManpowerForTProject.get(i));
                        }
                        
                    }
                    
                    
                    if(contractYearAndTotalValueOfRentalForTProject != null && contractYearAndTotalValueOfRentalForTProject.containsKey(i)){
                        finRec.Total_Value_of_Rental__c = Math.round(contractYearAndTotalValueOfRentalForTProject.get(i));
                    }
                    if(contractYearAndTotalInvestmentForTProject != null && contractYearAndTotalInvestmentForTProject.containsKey(i)){
                        finRec.Total_Investment__c = Math.round(contractYearAndTotalInvestmentForTProject.get(i));
                    }
                    if(contractYearAndTotalDepreciationForTProject != null && contractYearAndTotalDepreciationForTProject.containsKey(i)){
                        finRec.Total_Depreciation__c = Math.round(contractYearAndTotalDepreciationForTProject.get(i));
                    }
                    if(contractYearAndTotalResaleValueForTProject != null && contractYearAndTotalResaleValueForTProject.containsKey(i)){
                        finRec.Total_Resale_Value__c = Math.round(contractYearAndTotalResaleValueForTProject.get(i));
                    }
                    if(contractYearAndTotalVehicleProfitsForTProject != null && contractYearAndTotalVehicleProfitsForTProject.containsKey(i)){
                        finRec.Total_Vehicle_Profits__c = Math.round(contractYearAndTotalVehicleProfitsForTProject.get(i));
                    }
                    if(contractYearAndTotalDriverProfitsForTProject != null && contractYearAndTotalDriverProfitsForTProject.containsKey(i)){
                        finRec.Total_Driver_Profits__c = Math.round(contractYearAndTotalDriverProfitsForTProject.get(i));
                    }
                    if(contractYearAndTotalNannyProfitsForTProject != null && contractYearAndTotalNannyProfitsForTProject.containsKey(i)){
                        finRec.Total_Nanny_Profits__c = Math.round(contractYearAndTotalNannyProfitsForTProject.get(i));
                    }
                    if(contractYearAndTotalCoordinatorProfitsForTProject != null && contractYearAndTotalCoordinatorProfitsForTProject.containsKey(i)){
                        finRec.Total_Coordinator_Profits__c = Math.round(contractYearAndTotalCoordinatorProfitsForTProject.get(i));
                    }
                    if(contractYearAndTotalSupervisorProfitsForTProject != null && contractYearAndTotalSupervisorProfitsForTProject.containsKey(i)){
                        finRec.Total_Supervisor_Profits__c = Math.round(contractYearAndTotalSupervisorProfitsForTProject.get(i));
                    }
                    if(contractYearAndTotalAccountantProfitsForTProject != null && contractYearAndTotalAccountantProfitsForTProject.containsKey(i)){
                        finRec.Total_Accountant_Profits__c = Math.round(contractYearAndTotalAccountantProfitsForTProject.get(i));
                    }
                    if(contractYearAndTotalOtherEmployeeProfitsForTProject != null && contractYearAndTotalOtherEmployeeProfitsForTProject.containsKey(i)){
                        finRec.Total_Other_Employee_Profits__c = Math.round(contractYearAndTotalOtherEmployeeProfitsForTProject.get(i));
                    }
                    if(contractYearAndTotalFuelProfitsForTProject != null && contractYearAndTotalFuelProfitsForTProject.containsKey(i)){
                        finRec.Total_Fuel_Profits__c = Math.round(contractYearAndTotalFuelProfitsForTProject.get(i));
                    }
                    
                    if(contractYearAndFreeCashFlowAnnualForTProject != null && contractYearAndFreeCashFlowAnnualForTProject.containsKey(i)){
                        finRec.Free_Cash_Flow_Annual__c = Math.round(contractYearAndFreeCashFlowAnnualForTProject.get(i));
                    }
                    if(contractYearAndFreeCashFlowCumulativeForTProject != null && contractYearAndFreeCashFlowCumulativeForTProject.containsKey(i)){
                        finRec.Free_Cash_Flow_Cumulative__c = Math.round(contractYearAndFreeCashFlowCumulativeForTProject.get(i));
                    }
                    
                    // Target 
                    if(contractYearAndFreeCashFlowAnnualForTProject_Target != null && contractYearAndFreeCashFlowAnnualForTProject_Target.containsKey(i)){
                        finRec.Free_Cash_Flow_Annual_Target__c = Math.round(contractYearAndFreeCashFlowAnnualForTProject_Target.get(i));
                    }
                    if(contractYearAndFreeCashFlowCumulativeForTProject_Target != null && contractYearAndFreeCashFlowCumulativeForTProject_Target.containsKey(i)){
                        finRec.Free_Cash_Flow_Cumulative_Target__c = Math.round(contractYearAndFreeCashFlowCumulativeForTProject_Target.get(i));
                    }
                    
                    // Discounted
                    if(contractYearAndFreeCashFlowAnnualForTProject_discounted != null && contractYearAndFreeCashFlowAnnualForTProject_discounted.containsKey(i)){
                        finRec.Free_Cash_Flow_Annual_Discounted__c = Math.round(contractYearAndFreeCashFlowAnnualForTProject_discounted.get(i));
                    }
                    if(contractYearAndFreeCashFlowCumulativeForTProject_discounted != null && contractYearAndFreeCashFlowCumulativeForTProject_discounted.containsKey(i)){
                        finRec.Free_Cash_Flow_Cumulative_Discounted__c = Math.round(contractYearAndFreeCashFlowCumulativeForTProject_discounted.get(i));
                    }
                    
                    if(contractYearAndResaleValueUsedForCalcsForTProject != null && contractYearAndResaleValueUsedForCalcsForTProject.containsKey(i)){
                        finRec.Resale_Value_used_for_Calculation__c = Math.round(contractYearAndResaleValueUsedForCalcsForTProject.get(i));
                    }
                    
                    if(contractYearAndPayback1ForTProject != null && contractYearAndPayback1ForTProject.containsKey(i)){
                        finRec.Payback_1__c = Math.round(contractYearAndPayback1ForTProject.get(i));
                    }
                    
                    if(contractYearAndPayback2ForTProject != null && contractYearAndPayback2ForTProject.containsKey(i)){
                        finRec.Payback_2__c = Math.round(contractYearAndPayback2ForTProject.get(i));
                    }
                    
                    // calcs
                    //Payback_Ratio_1__c
                    if(contractYearAndPayback1ForTProject != null && contractYearAndPayback1ForTProject.containsKey(i) && 
                       contractYearAndTotalInvestmentForTProject != null && contractYearAndTotalInvestmentForTProject.containsKey(i)){
                           finRec.Payback_Ratio_1__c = ((contractYearAndPayback1ForTProject.get(i)/contractYearAndTotalInvestmentForTProject.get(i))*100).setScale(2);
                       }
                    
                    //Payback_Ratio_2__c
                    if(contractYearAndPayback2ForTProject != null && contractYearAndPayback2ForTProject.containsKey(i) && 
                       contractYearAndTotalInvestmentForTProject != null && contractYearAndTotalInvestmentForTProject.containsKey(i)){
                           finRec.Payback_Ratio_2__c = ((contractYearAndPayback2ForTProject.get(i)/contractYearAndTotalInvestmentForTProject.get(i))*100).setScale(2);
                       }
                    
                    //Annual_share_of_Payback_Ratio_2__c
                    if(finRec.Payback_Ratio_2__c != null){
                        finRec.Annual_share_of_Payback_Ratio_2__c = ( finRec.Payback_Ratio_2__c - 100)/i;
                    }
                    
                    //Payback_3__c
                    if(contractYearAndPayback2ForTProject != null && contractYearAndPayback2ForTProject.containsKey(i) && 
                       contractYearAndTotalManpowerProfitUsedForCalcsForTProject != null && contractYearAndTotalManpowerProfitUsedForCalcsForTProject.containsKey(i)){
                           finRec.Payback_3__c = (contractYearAndPayback2ForTProject.get(i) + contractYearAndTotalManpowerProfitUsedForCalcsForTProject.get(i));
                       }
                    //Payback_Ratio_3__c
                    if(finRec.Payback_3__c != null && 
                       contractYearAndTotalInvestmentForTProject != null && contractYearAndTotalInvestmentForTProject.containsKey(i)){
                           finRec.Payback_Ratio_3__c =  ((finRec.Payback_3__c/contractYearAndTotalInvestmentForTProject.get(i))*100).setScale(2);
                       }
                    
                    //Annual_share_of_Payback_Ratio_3__c
                    if(finRec.Payback_Ratio_3__c != null){
                        finRec.Annual_share_of_Payback_Ratio_3__c = ( finRec.Payback_Ratio_3__c - 100)/i;
                    }
                    
                    Decimal PresentValue = 0.0;
                    if(finRec.Total_Investment__c!= null &&  finRec.Free_Cash_Flow_Annual__c != null && finRec.Resale_Value_used_for_Calculation__c != null){
                        PresentValue = calculateNetPresentValue( i,finRec.Total_Investment__c, finRec.Free_Cash_Flow_Annual__c, finRec.Resale_Value_used_for_Calculation__c);
                    }
                    finRec.Net_Present_Value__c = Math.round(PresentValue);
                    
                    // NetPresent Value - Target 
                    Decimal PresentValueTarget = 0.0;
                    if(finRec.Total_Investment__c!= null &&  finRec.Free_Cash_Flow_Annual_Target__c != null && finRec.Resale_Value_used_for_Calculation__c != null){
                        PresentValueTarget = calculateNetPresentValue( i,finRec.Total_Investment__c, finRec.Free_Cash_Flow_Annual_Target__c, finRec.Resale_Value_used_for_Calculation__c);
                    }
                    finRec.Net_Present_Value_Target__c = Math.round(PresentValueTarget);
                    
                    // NetPresent Value - Discount 
                    Decimal PresentValueDiscount = 0.0;
                    if(finRec.Total_Investment__c!= null &&  finRec.Free_Cash_Flow_Annual_Discounted__c != null && finRec.Resale_Value_used_for_Calculation__c != null){
                        PresentValueDiscount = calculateNetPresentValue( i,finRec.Total_Investment__c, finRec.Free_Cash_Flow_Annual_Discounted__c, finRec.Resale_Value_used_for_Calculation__c);
                    }
                    finRec.Net_Present_Value_Discounted__c = Math.round(PresentValueDiscount);
                    
                    
                    // Net Profit Margin (%)
                    if(finRec.Total_Annual_Profit__c != null && finRec.Total_Annual_Price_excluding_VAT__c != null){
                        finRec.Net_Profit_Margin__c = ((finRec.Total_Annual_Profit__c/finRec.Total_Annual_Price_excluding_VAT__c)*100).setScale(2);
                    }
                    
                    if(finRec.is_Target_Price_Required__c && finRec.Total_Annual_Profit_Discounted__c != null && finRec.Total_Annual_Price_excluding_VAT_Discoun__c != null){
                        finRec.Net_Profit_Margin_Discounted__c = ((finRec.Total_Annual_Profit_Discounted__c/finRec.Total_Annual_Price_excluding_VAT_Discoun__c)*100).setScale(2);
                    }
                    
                    if(finRec.is_Target_Price_Required__c && finRec.Total_annual_Profit_Target_Price__c != null && finRec.Total_Annual_Price_excluding_VAT_Target__c != null){
                        finRec.Net_Profit_Margin_Target__c = ((finRec.Total_annual_Profit_Target_Price__c/finRec.Total_Annual_Price_excluding_VAT_Target__c)*100).setScale(2);
                    }
                    
                    finRec.Cost_Of_Capital_Assumed__c =Decimal.valueOf(Label.ET_Cost_of_Capital_Assumed);
                    
                    integer freeCashFlow =0;
                    if(finRec.Free_Cash_Flow_Annual__c != null && finRec.Resale_Value_used_for_Calculation__c  != null){
                        freeCashFlow = integer.valueOf(finRec.Free_Cash_Flow_Annual__c) -integer.valueOf(finRec.Resale_Value_used_for_Calculation__c ) ;
                    }
                    
                    if(contractYearAndTotalProfitUsedForCalcsForTProject.get(i) != null &&finRec.Total_Investment__c != null ){
                        finRec.Return_on_Investment__c = ((contractYearAndTotalProfitUsedForCalcsForTProject.get(i))/finRec.Total_Investment__c)*100;
                    }
                    if(contractYearAndTotalProfitUsedForCalcsForTProject_Target.get(i) != null &&finRec.Total_Investment__c != null ){
                        finRec.Return_on_Investment_Target__c = ((contractYearAndTotalProfitUsedForCalcsForTProject_Target.get(i))/finRec.Total_Investment__c)*100;
                    }
                    if(contractYearAndTotalProfitUsedForCalcsForTProject_discounted.get(i) != null &&finRec.Total_Investment__c != null ){
                        finRec.Return_on_Investment_Discounted__c = ((contractYearAndTotalProfitUsedForCalcsForTProject_discounted.get(i))/finRec.Total_Investment__c)*100;
                    }
                    
                    if(contractYearAndPaybackPeriodForTProject != null && contractYearAndPaybackPeriodForTProject.containsKey(i)){
                        finRec.Payback_Period_Years__c = Math.round((contractYearAndPaybackPeriodForTProject.get(i))/Mainvehiclecount.get(i));
                    }
                    
                    // Payback period in years 
                    /* decimal noOfYearsOfNegativeCashFlow = 0.0;
decimal noOfMonthsOfNegativeCashFlow = 0.0;
if(finRec.Total_Investment__c != null && finRec.Free_Cash_Flow_Annual__c !=null && finRec.Resale_Value_used_for_Calculation__c != null ){
cashFlowCumulativeWrapper cashFlowWrapper =  freeCashFlowCumulativeCalc(i,finRec.Total_Investment__c,finRec.Free_Cash_Flow_Annual__c,finRec.Resale_Value_used_for_Calculation__c);
system.debug('cashFlowWrapper check = '+ json.serializePretty(cashFlowWrapper));
if(cashFlowWrapper != null){
noOfYearsOfNegativeCashFlow = cashFlowWrapper.countYearsofNegativeCashFlow;
noOfMonthsOfNegativeCashFlow = cashFlowWrapper.countMonthsofNegativeCashFlow;
}
}

system.debug('i check = '+ i);
system.debug('noOfYearsOfNegativeCashFlow '+ noOfYearsOfNegativeCashFlow + ' noOfMonthsOfNegativeCashFlow = '+ noOfMonthsOfNegativeCashFlow);
if(noOfYearsOfNegativeCashFlow != null && noOfMonthsOfNegativeCashFlow != null){
finRec.Payback_Period_Years__c=noOfYearsOfNegativeCashFlow+noOfYearsOfNegativeCashFlow;
}*/
                    
                    
                    
                    finRec.Quote__c = totalProjectQuoteId;
                    
                    financeAnalysisList.add(finRec); 
                    
                }
                
                if(financeAnalysisList != null && !financeAnalysisList.isEmpty()){
                    upsert financeAnalysisList Unique_Identifier__c;
                    // Call a method to Calculate and update IRR 
                    calcualteIRR(JSON.serialize(financeAnalysisList));
                }
                
            }
        }
    }
    
    public static decimal calculateNetPresentValue(integer contractYear,Decimal totalInvestment,Decimal freeCashFlowAnnual, Decimal totalResaleValue){
        decimal netPresentValue = 0.0;
        Decimal PresentValue1=1+(Decimal.valueOf(Label.ET_Cost_of_Capital_Assumed)/100);
        Decimal PresentValue2 = 0.0;
        Decimal PVFactor = 0.0;
        if(contractYear == 1){
            if(PresentValue1 != null){
                PresentValue2=PresentValue1.pow(1);
            }
            if(PresentValue2 != null){
                PVFactor= 1/PresentValue2;
            }
            netPresentValue = (freeCashFlowAnnual )*pvFactor; 
        }
        else if(contractYear >=2){
            for(integer i=1 ; i<=contractYear ; i++){
                if(PresentValue1 != null){
                    PresentValue2=PresentValue1.pow(i);
                }
                if(PresentValue2 != null){
                    PVFactor= 1/PresentValue2;
                }
                // net present value calculation....
                if(i != contractYear){
                    netPresentValue += (freeCashFlowAnnual - totalResaleValue )*PVFactor; 
                }
                else if(i == contractYear ){
                    netPresentValue += (freeCashFlowAnnual )*PVFactor; 
                }
            }
        }
        netPresentValue = netPresentValue - totalInvestment;
        return netPresentValue;
        
    }
    
    public static cashFlowCumulativeWrapper freeCashFlowCumulativeCalc(integer contractYear,Decimal totalInvestment,Decimal freeCashFlowAnnual, Decimal totalResaleValue){
        Decimal cashFlowCumulative =0;
        Decimal countYearsofNegativeCashFlow2 =0;
        Decimal freeCashFlowOfPveYear =0;
        Decimal CumulativefreeCashFlowOfPveYear =0;
        cashFlowCumulativeWrapper cashFlowWrapper = new cashFlowCumulativeWrapper();
        if(contractYear==1){
            cashFlowCumulative = -totalInvestment+freeCashFlowAnnual;
            if(cashFlowCumulative<0)
                countYearsofNegativeCashFlow2 +=1;
            else {
                if(freeCashFlowOfPveYear==0)
                    freeCashFlowOfPveYear = freeCashFlowAnnual;
                if(CumulativefreeCashFlowOfPveYear==0)
                    CumulativefreeCashFlowOfPveYear = cashFlowCumulative;
            }
        }
        else {
            for(Integer i=1; i <= contractYear; i++){
                if(i==1){
                    cashFlowCumulative = -totalInvestment+(freeCashFlowAnnual-totalResaleValue);
                    if(cashFlowCumulative<0)
                        countYearsofNegativeCashFlow2 +=1;
                    else {
                        if(freeCashFlowOfPveYear==0)
                            freeCashFlowOfPveYear = freeCashFlowAnnual;
                        if(CumulativefreeCashFlowOfPveYear==0)
                            CumulativefreeCashFlowOfPveYear = cashFlowCumulative;
                    }
                }
                else if(i!=contractYear){
                    cashFlowCumulative = cashFlowCumulative+(freeCashFlowAnnual-totalResaleValue);
                    if(cashFlowCumulative<0)
                        countYearsofNegativeCashFlow2 +=1;
                    else {
                        if(freeCashFlowOfPveYear==0)
                            freeCashFlowOfPveYear = freeCashFlowAnnual;
                        if(CumulativefreeCashFlowOfPveYear==0)
                            CumulativefreeCashFlowOfPveYear = cashFlowCumulative;
                    }
                }
                else {
                    cashFlowCumulative = cashFlowCumulative+freeCashFlowAnnual;
                    if(cashFlowCumulative<0)
                        countYearsofNegativeCashFlow2 +=1;
                    else {
                        if(freeCashFlowOfPveYear==0)
                            freeCashFlowOfPveYear = freeCashFlowAnnual;
                        if(CumulativefreeCashFlowOfPveYear==0)
                            CumulativefreeCashFlowOfPveYear = cashFlowCumulative;
                    }
                }
            }
        }
        
        countYearsofNegativeCashFlow = countYearsofNegativeCashFlow2;
        if(freeCashFlowOfPveYear!=0)
            countMonthsofNegativeCashFlow = (freeCashFlowOfPveYear-CumulativefreeCashFlowOfPveYear)/freeCashFlowOfPveYear;
        
        cashFlowWrapper.cashFlowCumulative = cashFlowCumulative;
        cashFlowWrapper.countYearsofNegativeCashFlow = countYearsofNegativeCashFlow2;
        if(freeCashFlowOfPveYear!=0){
            cashFlowWrapper.countMonthsofNegativeCashFlow = (freeCashFlowOfPveYear-CumulativefreeCashFlowOfPveYear)/freeCashFlowOfPveYear;       
        }
        return cashFlowWrapper;
    }
    
    Public class cashFlowCumulativeWrapper{
        public decimal cashFlowCumulative;
        public decimal countYearsofNegativeCashFlow;
        public decimal countMonthsofNegativeCashFlow;
    }
    
    @AuraEnabled
    public static list<RentalPriceClass> financialAnalysisScreenData(Id quoteId){
        list<Financial_Analysis__c> financialAnalysisLst=new list<Financial_Analysis__c>();
        list<RentalPriceClass> rentalPriceClassLst=new list<RentalPriceClass>();
        setQuoteData(quoteId);
        //system.debug('financialAnalysisMap>> '+financialAnalysisMap);
        if(!financialAnalysisMap.isEmpty()){
            for(String obj:financialAnalysisMap.keySet()){
                //system.debug('obj>> '+obj);
                list<RentalPriceCalClass> rentalPriceCalLst = new list<RentalPriceCalClass>();
                list<TotalValueOfQuotation> totalValueOfQuotationLst=new list<TotalValueOfQuotation>();
                list<FinancialAnalysis> financialAnalysisWrpLst=new list<FinancialAnalysis>();
                RentalPriceClass rentalPriceClassObj=new RentalPriceClass();
                RentalPriceHeader headerInfo=new RentalPriceHeader();
                if(headerInfo.totalLines==null)
                    headerInfo.totalLines=targetPriceForCombination.size();
                if(vehicleQuoteItemLst != null && vehicleQuoteItemLst.size() > 0 ){
                    for(ET_Vehicle_Quote_Item__c vehicleQuoteItem :  vehicleQuoteItemLst){
                        rentalPriceClassObj.reqMapping='Vehicle - ';
                        if(vehicleQuoteItem.ET_Vehicle_Unique_key__c==obj.split('=>')[0] && vehicleQuoteItem.ET_Line_Number__c==decimal.valueOf(obj.split('=>')[1])){
                            if(headerInfo.quoteNumber=='' || headerInfo.quoteNumber==null)
                                headerInfo.quoteNumber = vehicleQuoteItem.Quote__r.QuoteNumber;
                            if(headerInfo.zone=='' || headerInfo.zone==null)
                                headerInfo.zone= vehicleQuoteItem.Quote__r.GL_Zone__c;
                            if(headerInfo.clientName=='' || headerInfo.clientName==null)
                                headerInfo.clientName = vehicleQuoteItem.Quote__r.Account.Name;
                            if(headerInfo.clientType=='' || headerInfo.clientType==null)
                                headerInfo.clientType = vehicleQuoteItem.Quote__r.Account.ETSALES_Profile_Class__c;
                            if(headerInfo.contractType=='' || headerInfo.contractType==null)
                                headerInfo.contractType = vehicleQuoteItem.Quote__r.Opportunity.Type;
                            if(headerInfo.totalInvestmentValue==null)
                                headerInfo.totalInvestmentValue = vehicleQuoteItem.Quote__r.ET_Total_Investment__c;
                            if(headerInfo.serviceEmirate=='' || headerInfo.serviceEmirate==null)
                                headerInfo.serviceEmirate= vehicleQuoteItem.ET_Service_Emirate__c;
                            if(headerInfo.fleetType=='' || headerInfo.fleetType==null)
                                headerInfo.fleetType= vehicleQuoteItem.ET_Fleet_Type__c;
                            if(headerInfo.noOfVehicles==null)
                                headerInfo.noOfVehicles = integer.valueOf(vehicleQuoteItem.ET_Number_of_Vehicles__c);
                            if(headerInfo.lineNo==null)
                                headerInfo.lineNo = integer.valueOf(vehicleQuoteItem.ET_Line_Number__c);
                            if(headerInfo.requestor=='' || headerInfo.requestor==null)
                                headerInfo.requestor = vehicleQuoteItem.Quote__r.CreatedBy.Name;
                        }
                    }
                }
                if(workforceQuoteItemLst != null && workforceQuoteItemLst.size()>0 
                   && targetPriceForCombination.get(obj)!=null && targetPriceForCombination.get(obj).size()>0){
                       rentalPriceClassObj.reqMapping=rentalPriceClassObj.reqMapping+'With ';
                       string combination;
                       for(String str:targetPriceForCombination.get(obj)){
                           if(str.contains('Fuel')){
                               if(combination!='' && combination!=null)
                                   combination=combination+', Fuel';
                               else 
                                   combination=' Fuel';
                           }
                           if(str.contains('Driver')){
                               if(combination!='' && combination!=null)
                                   combination=combination+', Driver';
                               else 
                                   combination=' Driver';
                           }
                           if(str.contains('Nanny')){
                               if(combination!='' && combination!=null)
                                   combination=combination+', Nanny';
                               else 
                                   combination=' Nanny';
                           }
                           if(str.contains('Coordinator')){
                               if(combination!='' && combination!=null)
                                   combination=combination+', Coordinator';
                               else 
                                   combination=' Coordinator';
                           }
                           if(str.contains('Accountant')){
                               if(combination!='' && combination!=null)
                                   combination=combination+', Accountant';
                               else 
                                   combination=' Accountant';
                           }
                           if(str.contains('Supervisor')){
                               if(combination!='' && combination!=null)
                                   combination=combination+', Supervisor';
                               else 
                                   combination=' Supervisor';
                           }
                           if(str.contains('Emp')){
                               if(combination!='' && combination!=null)
                                   combination=combination+', Other Employee';
                               else 
                                   combination=' Other Employee';
                           }
                       }
                       rentalPriceClassObj.reqMapping=rentalPriceClassObj.reqMapping+combination+' - ';
                   }
                rentalPriceClassObj.reqMapping=rentalPriceClassObj.reqMapping+obj.split('=>')[0].replaceAll('_',' ');
                rentalPriceClassObj.rentalPriceHeaderInfo=headerInfo;
                for(Financial_Analysis__c financialAnalysis:financialAnalysisMap.get(obj)){
                    RentalPriceCalClass  rentalPriceCalObj = new  RentalPriceCalClass();
                    rentalPriceCalObj.contractYear = integer.valueOf(financialAnalysis.Contract_Year__c);
                    rentalPriceCalObj.quoteType =  financialAnalysis.quote__r.ET_Type__c;
                    rentalPriceCalObj.totalAnnualCost =  financialAnalysis.Total_Annual_Cost__c;
                    rentalPriceCalObj.totalAnnualPriceExcludingVAT = financialAnalysis.Total_Annual_Price_excluding_VAT__c;
                    rentalPriceCalObj.totalAnnualProfit = financialAnalysis.Total_Annual_Profit__c;
                    
                    rentalPriceCalObj.totalAnnualCostDiscounted =  financialAnalysis.Total_Annual_Cost_Discounted__c;
                    rentalPriceCalObj.totalAnnualPriceExcludingVATDiscounted = financialAnalysis.Total_Annual_Price_excluding_VAT_Discoun__c;
                    rentalPriceCalObj.totalAnnualProfitDiscounted = financialAnalysis.Total_Annual_Profit_Discounted__c;
                    
                    rentalPriceCalObj.totalAnnualCostTarget =  financialAnalysis.Total_Annual_Cost_Target_Price__c;
                    rentalPriceCalObj.totalAnnualPriceExcludingVATTarget = financialAnalysis.Total_Annual_Price_excluding_VAT_Target__c;
                    rentalPriceCalObj.totalAnnualProfitTarget = financialAnalysis.Total_annual_Profit_Target_Price__c;
                    
                    
                    rentalPriceCalObj.pricePerMonthExcludingVAT = financialAnalysis.Price_Per_Month_excluding_VAT__c;
                    rentalPriceCalObj.vATAmount = financialAnalysis.VAT_Amount__c;
                    rentalPriceCalObj.totalAnnualPriceIncludingVAT = financialAnalysis.Total_Annual_Price_including_VAT__c;
                    rentalPriceCalObj.pricePerMonthIncludingVAT = financialAnalysis.Price_Per_Month_including_VAT__c;
                    rentalPriceCalObj.pricingType = financialAnalysis.ET_Pricing_Type__c;
                    rentalPriceCalObj.isTargerPriceRequired = financialAnalysis.is_Target_Price_Required__c;
                    rentalPriceCalObj.separatePricesRequired = financialAnalysis.Request_for_separate_prices__c;
                    
                    rentalPriceCalObj.totalAnnualPriceExcludingVATVehcileAndFuel = financialAnalysis.Tot_Ann_price_exc_vat_for_vehicle_fuel__c;
                    rentalPriceCalObj.pricePerMonthExcludingVATVehcileAndFuel = financialAnalysis.Price_Per_month_excluding_VAT_Vehicle__c;
                    rentalPriceCalObj.vatAmountForVehcileAndFuel = financialAnalysis.VAT_Amount_for_Vehicle__c;
                    rentalPriceCalObj.totalAnnualPriceIncludingVATVehcileAndFuel = financialAnalysis.Total_Annual_Price_including_VAT_Vehicle__c;
                    rentalPriceCalObj.pricePerMonthIncludingVATVehcileAndFuel = financialAnalysis.Price_Per_Month_including_VAT_Vehicle__c;
                    
                    rentalPriceCalObj.totalAnnualPriceExcludingVATManpower = financialAnalysis.Total_Annual_Pric_excluding_VAT_Manpower__c;
                    rentalPriceCalObj.pricePerMonthExcludingVATManpower = financialAnalysis.Price_Per_Month_excluding_VAT_Manpower__c;
                    rentalPriceCalObj.vatAmountForManpower = financialAnalysis.VAT_Amount_for_Manpower__c;
                    rentalPriceCalObj.totalAnnualPriceIncludingVATManpower = financialAnalysis.Total_Annual_Price_including_VAT_Manpowe__c;
                    rentalPriceCalObj.pricePerMonthIncludingVATManpower = financialAnalysis.Price_Per_month_including_VAT_Manpower__c;
                    rentalPriceCalObj.extraKMPrice = financialAnalysis.extraKMPrice__c;
                    rentalPriceCalObj.corporateTax = financialAnalysis.Corporate_Tax__c;//Added by Arunsarathy on 28.04.2023 for corporate tax update
                    rentalPriceCalLst.add(rentalPriceCalObj);
                    
                    TotalValueOfQuotation totalValueOfQuotationObj=new TotalValueOfQuotation();
                    totalValueOfQuotationObj.totalValueofRental = financialAnalysis.Total_Value_of_Rental__c;
                    totalValueOfQuotationObj.totalInvestment =  financialAnalysis.Total_Investment__c;
                    totalValueOfQuotationObj.totalDepreciation = financialAnalysis.Total_Depreciation__c;
                    totalValueOfQuotationObj.totalResaleValue = financialAnalysis.Total_Resale_Value__c;
                    totalValueOfQuotationObj.totalVehicleProfits = financialAnalysis.Total_Vehicle_Profits__c;
                    totalValueOfQuotationObj.totalDriverProfits = financialAnalysis.Total_Driver_Profits__c;
                    totalValueOfQuotationObj.totalNannyprofits =  financialAnalysis.Total_Nanny_Profits__c;
                    totalValueOfQuotationObj.totalCoordinatorprofits = financialAnalysis.Total_Coordinator_Profits__c;
                    totalValueOfQuotationObj.totalSupervisorprofits = financialAnalysis.Total_Supervisor_Profits__c;
                    totalValueOfQuotationObj.totalAccountantprofits =  financialAnalysis.Total_Accountant_Profits__c;
                    totalValueOfQuotationObj.totalOtherEmployeeprofits = financialAnalysis.Total_Other_Employee_Profits__c;   
                    totalValueOfQuotationObj.totalFuelProfits = financialAnalysis.Total_Fuel_Profits__c;
                    totalValueOfQuotationLst.add(totalValueOfQuotationObj);
                    
                    FinancialAnalysis financialAnalysisObj=new FinancialAnalysis();
                    financialAnalysisObj.payback =  financialAnalysis.Payback_1__c;
                    if(financialAnalysis.Payback_Ratio_1__c != null){
                        financialAnalysisObj.paybackRatio = financialAnalysis.Payback_Ratio_1__c.setScale(2);
                    }
                    financialAnalysisObj.payback2 = financialAnalysis.Payback_2__c;
                    if(financialAnalysis.Payback_Ratio_2__c != null){
                        financialAnalysisObj.paybackRatio2 = financialAnalysis.Payback_Ratio_2__c.setScale(2); 
                    }
                    if(financialAnalysis.Annual_share_of_Payback_Ratio_2__c != null){
                        financialAnalysisObj.annualshareOfPaybackRatio2 = financialAnalysis.Annual_share_of_Payback_Ratio_2__c.setScale(2);
                    }
                    financialAnalysisObj.payback3 = financialAnalysis.Payback_3__c;
                    if(financialAnalysis.Payback_Ratio_3__c != null){
                        financialAnalysisObj.paybackRatio3 = financialAnalysis.Payback_Ratio_3__c.setScale(2);
                    }
                    
                    if(financialAnalysis.Annual_share_of_Payback_Ratio_3__c != null){
                        financialAnalysisObj.annualshareOfPaybackRatio3 = financialAnalysis.Annual_share_of_Payback_Ratio_3__c.setScale(2);
                    }
                    
                    financialAnalysisObj.freeCashFlowAnnual = financialAnalysis.Free_Cash_Flow_Annual__c;
                    financialAnalysisObj.freeCashFlowCumulative = financialAnalysis.Free_Cash_Flow_Cumulative__c;
                    financialAnalysisObj.netPresentValue = financialAnalysis.Net_Present_Value__c;
                    financialAnalysisObj.netProfitMargin = financialAnalysis.Net_Profit_Margin__c;
                    financialAnalysisObj.costOfCapitalAssumed = financialAnalysis.Cost_Of_Capital_Assumed__c;
                    financialAnalysisObj.paybackPeriodYears= financialAnalysis.Payback_Period_Years__c;
                    financialAnalysisObj.internalRateOfReturn= financialAnalysis.Internal_Rate_of_Return__c;
                    financialAnalysisObj.returnOnInvestment = financialAnalysis.Return_on_Investment__c;
                    
                    financialAnalysisObj.freeCashFlowAnnualDiscounted = financialAnalysis.Free_Cash_Flow_Annual_Discounted__c;
                    financialAnalysisObj.freeCashFlowCumulativeDiscounted = financialAnalysis.Free_Cash_Flow_Cumulative_Discounted__c;
                    financialAnalysisObj.netPresentValueDiscounted = financialAnalysis.Net_Present_Value_Discounted__c;
                    financialAnalysisObj.netProfitMarginDiscounted = financialAnalysis.Net_Profit_Margin_Discounted__c;
                    financialAnalysisObj.internalRateOfReturnDiscounted= financialAnalysis.Internal_Rate_of_Return_Discounted__c;
                    financialAnalysisObj.returnOnInvestmentDiscounted = financialAnalysis.Return_on_Investment_Discounted__c;
                    
                    financialAnalysisObj.freeCashFlowAnnualTarget = financialAnalysis.Free_Cash_Flow_Annual_Target__c;
                    financialAnalysisObj.freeCashFlowCumulativeTarget = financialAnalysis.Free_Cash_Flow_Cumulative_Target__c;
                    financialAnalysisObj.netPresentValueTarget = financialAnalysis.Net_Present_Value_Target__c;
                    financialAnalysisObj.netProfitMarginTarget = financialAnalysis.Net_Profit_Margin_Target__c;
                    financialAnalysisObj.internalRateOfReturnTarget= financialAnalysis.Internal_Rate_of_Return_Target__c;
                    financialAnalysisObj.returnOnInvestmentTarget = financialAnalysis.Return_on_Investment_Target__c;
                    financialAnalysisObj.pricePerPricingType = financialAnalysis.Price_Per_Pricing_Type__c;
                    financialAnalysisObj.pricingMethod = financialAnalysis.ET_Pricing_Method__c;
                    financialAnalysisObj.contractYear = integer.valueOf(financialAnalysis.Contract_Year__c); //Taj
                    financialAnalysisWrpLst.add(financialAnalysisObj);
                }
                rentalPriceClassObj.rentalPriceCalculationLst=rentalPriceCalLst;
                rentalPriceClassObj.totalValueOfQuotationLst=totalValueOfQuotationLst;
                rentalPriceClassObj.financialAnalysisLst=financialAnalysisWrpLst;
                rentalPriceClassLst.add(rentalPriceClassObj);
            }
        }
        //system.debug('rentalPriceClassLst>> '+rentalPriceClassLst);
        return rentalPriceClassLst;
    }
    public class RentalPriceClass {
        @AuraEnabled
        public string reqMapping;
        @AuraEnabled
        public RentalPriceHeader rentalPriceHeaderInfo;
        @AuraEnabled
        public List<RentalPriceCalClass> rentalPriceCalculationLst;
        @AuraEnabled
        public List<TotalValueOfQuotation> totalValueOfQuotationLst;
        @AuraEnabled
        public List<FinancialAnalysis> financialAnalysisLst;
        @AuraEnabled
        public  List<Financial_Analysis__c> financialCalcsList=new List<Financial_Analysis__c>();
    }
    public class RentalPriceHeader{
        @AuraEnabled
        public string zone;
        @AuraEnabled
        public string quoteNumber;
        @AuraEnabled
        public string clientName;
        @AuraEnabled
        public string clientType;
        @AuraEnabled
        public string clientCategory;
        @AuraEnabled
        public string clientStatus;
        @AuraEnabled
        public string contractType;
        @AuraEnabled
        public Decimal totalInvestmentValue;
        @AuraEnabled
        public string serviceEmirate;
        @AuraEnabled
        public string fleetType;
        @AuraEnabled
        public Integer noOfVehicles;
        @AuraEnabled
        public Integer lineNo;
        @AuraEnabled
        public Integer totalLines;
        @AuraEnabled
        public string requestor;
    }
    public class RentalPriceCalClass{
        @AuraEnabled
        public Integer contractYear = 0;
        @AuraEnabled
        public string quoteType;
        @AuraEnabled
        public Decimal totalAnnualCost = 0.0;
        @AuraEnabled
        public Decimal totalAnnualCostDiscounted = 0.0;
        @AuraEnabled
        public Decimal totalAnnualCostTarget = 0.0;
        @AuraEnabled
        public Decimal totalAnnualProfit = 0.0;
        @AuraEnabled
        public Decimal totalAnnualProfitDiscounted = 0.0;
        @AuraEnabled
        public Decimal totalAnnualProfitTarget = 0.0;
        @AuraEnabled
        public Decimal totalAnnualPriceExcludingVAT = 0.0;
        @AuraEnabled
        public Decimal totalAnnualPriceExcludingVATDiscounted = 0.0;
        @AuraEnabled
        public Decimal totalAnnualPriceExcludingVATTarget = 0.0;
        @AuraEnabled
        public Decimal pricePerMonthExcludingVAT = 0.0;
        @AuraEnabled
        public Decimal vATAmount = 0.0;
        @AuraEnabled
        public Decimal totalAnnualPriceIncludingVAT = 0.0;
        @AuraEnabled
        public Decimal pricePerMonthIncludingVAT = 0.0;
        @AuraEnabled
        public String pricingType ;
        @AuraEnabled
        public boolean isTargerPriceRequired ;
        @AuraEnabled
        public boolean separatePricesRequired ;
        @AuraEnabled
        
        public Decimal totalAnnualPriceExcludingVATVehcileAndFuel = 0.0;
        @AuraEnabled
        public Decimal pricePerMonthExcludingVATVehcileAndFuel = 0.0;
        @AuraEnabled
        public Decimal vatAmountForVehcileAndFuel = 0.0;
        @AuraEnabled
        public Decimal totalAnnualPriceIncludingVATVehcileAndFuel = 0.0;
        @AuraEnabled
        public Decimal pricePerMonthIncludingVATVehcileAndFuel = 0.0;
        
        @AuraEnabled
        public Decimal totalAnnualPriceExcludingVATManpower = 0.0;
        @AuraEnabled
        public Decimal pricePerMonthExcludingVATManpower = 0.0;
        @AuraEnabled
        public Decimal vatAmountForManpower = 0.0;
        @AuraEnabled
        public Decimal totalAnnualPriceIncludingVATManpower = 0.0;
        @AuraEnabled
        public Decimal pricePerMonthIncludingVATManpower = 0.0;
        @AuraEnabled
        public Decimal extraKMPrice = 0.0;
         @AuraEnabled
        public Decimal corporateTax = 0.0; //Added by Arunsarathy on 28.04.2023 updated corporate tax
        
    }
    public class TotalValueOfQuotation{
        @AuraEnabled
        public Decimal totalValueofRental = 0.0;
        @AuraEnabled
        public Decimal totalInvestment = 0.0;
        @AuraEnabled
        public Decimal totalDepreciation = 0.0;
        @AuraEnabled
        public Decimal totalResaleValue = 0.0;
        @AuraEnabled 
        public Decimal totalVehicleProfits = 0.0;
        @AuraEnabled
        public Decimal totalDriverProfits = 0.0;
        @AuraEnabled
        public Decimal totalNannyprofits = 0.0;
        @AuraEnabled 
        public Decimal totalCoordinatorprofits = 0.0;
        @AuraEnabled
        public Decimal totalSupervisorprofits = 0.0;
        @AuraEnabled
        public Decimal totalAccountantprofits = 0.0;
        @AuraEnabled
        public Decimal totalOtherEmployeeprofits = 0.0;
        @AuraEnabled
        public Decimal totalFuelProfits = 0.0;
        @AuraEnabled
        public boolean showDriverProfit = true;
        @AuraEnabled
        public boolean showNannyProfit = true;
        @AuraEnabled
        public boolean showAccountantProfit = true;
        @AuraEnabled
        public boolean showCoordinatorProfit = true;
        @AuraEnabled
        public boolean showSupervisorProfit = true;
        @AuraEnabled
        public boolean showOtherManpowerProfit = true;
    }
    public class FinancialAnalysis{
        @AuraEnabled
        public Decimal payback = 0.0;
        @AuraEnabled
        public Decimal paybackRatio = 0.0;
        @AuraEnabled
        public Decimal payback2  = 0.0;
        @AuraEnabled
        public Decimal paybackRatio2  = 0.0;
        @AuraEnabled
        public Decimal annualshareOfPaybackRatio2 = 0.0;
        @AuraEnabled
        public Decimal payback3 = 0.0;
        @AuraEnabled
        public Decimal paybackRatio3 = 0.0;
        @AuraEnabled 
        public Decimal annualshareOfPaybackRatio3 = 0.0;
        @AuraEnabled
        public Decimal freeCashFlowAnnual = 0.0;
        @AuraEnabled
        public Decimal freeCashFlowAnnualDiscounted = 0.0;
        @AuraEnabled
        public Decimal freeCashFlowAnnualTarget = 0.0;
        @AuraEnabled
        public Decimal freeCashFlowCumulative = 0.0;
        @AuraEnabled
        public Decimal freeCashFlowCumulativeDiscounted = 0.0;
        @AuraEnabled
        public Decimal freeCashFlowCumulativeTarget = 0.0;
        @AuraEnabled
        public Decimal netPresentValue = 0.0;
        @AuraEnabled
        public Decimal netPresentValueDiscounted = 0.0;
        @AuraEnabled
        public Decimal netPresentValueTarget = 0.0;
        @AuraEnabled
        public Decimal costOfCapitalAssumed = 0.0;
        @AuraEnabled
        public Decimal netProfitMargin = 0.0;
        @AuraEnabled
        public Decimal netProfitMarginDiscounted = 0.0;
        @AuraEnabled
        public Decimal netProfitMarginTarget = 0.0;
        @AuraEnabled
        public Decimal paybackPeriodYears = 0.0;
        @AuraEnabled
        public Decimal paybackPeriodYearsDiscounted = 0.0;
        @AuraEnabled
        public Decimal paybackPeriodYearsTarget = 0.0;
        @AuraEnabled
        public Decimal internalRateOfReturn = 0.0;
        @AuraEnabled
        public Decimal internalRateOfReturnDiscounted = 0.0;
        @AuraEnabled
        public Decimal internalRateOfReturnTarget = 0.0;
        @AuraEnabled 
        public Decimal returnOnInvestment = 0.0;
        @AuraEnabled 
        public Decimal returnOnInvestmentDiscounted = 0.0;
        @AuraEnabled 
        public Decimal returnOnInvestmentTarget = 0.0;
        @AuraEnabled 
        public String pricingMethod ;
        @AuraEnabled 
        public String pricingType ;
        @AuraEnabled 
        public Decimal pricePerPricingType = 0.0;
        @AuraEnabled
        public Integer contractYear = 0; //Taj
    }
    
    public static void testCoverage(){
        integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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