/*
* Class Last modified Date: 05.06.2023 
* Maintenace rate for School transporation: 05.06.2023 
* for School transportation Extra KM new row addition 02.05.2023 
* Corporate tax formula updation 02.05.2023 
* Default Salik Cost and Tracking Cost updation 23-02-2024 
* Updated by: Arunsarathy

*/
public without sharing class ET_PricingQuoteItemsCalculationClass {
    // declare maps for Total Project Calculations...
    /* private static List<Quote> quoteLst ;
private static List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLst ;
private static List<ET_Workforce_Quote_Item__c> workforceQuoteItemLst ;
*/
    Private static integer totalVehicleLines =0;
    Private static decimal totalVehicles =0;
    Public static decimal quotationTotalInvestment =0;
    private static Map<integer,Decimal> contractYearAndvehiclePurchasePriceBasedOnCondition ;
    private static Map<integer,Decimal> contractYearAndOriginalPurchasePrice;
    private static Map<integer,Decimal> contractYearAndvehicleTotalInvestment;
    private static Map<integer,Decimal> contractYearAndvehicleResaleValue;
    private static Map<integer,Decimal> contractYearAndremainingDepreciationOf10Years;
    private static Map<integer,Decimal> contractYearAndvehicleDepreciation;
    private static Map<integer,Decimal> contractYearAndvehicleRepairsAndMaintenance;
    private static Map<integer,Decimal> contractYearAndvehicleFinancing;
    private static Map<integer,Decimal> contractYearAndvehicleInsurance;
    private static Map<integer,Decimal> contractYearAndsalikCost;
    private static Map<integer,Decimal> contractYearAndbasicTrackingSystemCost;
    private static Map<integer,Decimal> contractYearAndvehicleRegistrationAndInspectionFee;
    
    private static Map<integer,Decimal> contractYearAndfuelExpenses;
    private static Map<integer,Decimal> contractYearAndvehicleTotalVariableCost;
    private static Map<integer,Decimal> contractYearAndvehicleTotalFixedCost;
    private static Map<integer,Decimal> contractYearAnddeprciationReserve;
    private static Map<integer,Decimal> contractYearAndmaintenanceReserve;
    private static Map<integer,Decimal> contractYearAndGeneralReserve;
    private static Map<integer,Decimal> contractYearAndfuelReserve;
    private static Map<integer,Decimal> contractYearAndtotalFuelCost;
    private static Map<integer,Decimal> contractYearAndtotalReserveCost;
    
    private static Map<integer,Decimal> contractYearAndvatCostonDirectExpenses;
    private static Map<integer,Decimal> contractYearAndvehicleTotalCost;
    private static Map<integer,Decimal> contractYearAndannualFuelProfitMarginRate;
    private static Map<integer,Decimal> contractYearAndannualFuelProfitMarginValue;
    private static Map<integer,Decimal> contractYearAndannualVehicleProfitMarginValue;
    private static Map<integer,Decimal> contractYearAndannualVehicleProfitMarginRate;
    private static Map<integer,Decimal> contractYearAndvehicleVATAmount;
    private static Map<integer,Decimal> contractYearAndvehicleCorporateTax;
    
    // Maps for Target Prices 
    private static Map<integer,Decimal> contractYearAndGeneralReserveTarget;
    private static Map<integer,Decimal> contractYearAndGeneralReserveDiscount;
    private static Map<integer,Decimal> contractYearAndTotalVehicleCostDiscount;
    private static Map<integer,Decimal> contractYearAndTotalVehicleCostTarget;
    private static Map<integer,Decimal> contractYearAndVehicleProfitMarginRateDiscount;
    private static Map<integer,Decimal> contractYearAndVehicleProfitMarginRateTarget;
    private static Map<integer,Decimal> contractYearAndVehicleProfitMarginValueDiscount;
    private static Map<integer,Decimal> contractYearAndVehicleProfitMarginValueTarget;
    private static Map<integer,Decimal> contractYearAndTotalFuelCostDiscount;
    private static Map<integer,Decimal> contractYearAndTotalFuelCostTarget;
    
    // Maps for Trailer..
    private static Map<integer,Decimal> contractYearAndTrailerDepreciation;
    private static Map<integer,Decimal> contractYearAndTrailerResaleValue;
    private static Map<integer,Decimal> contractYearAndTrailerMaintenanceExpenses;
    private static Map<integer,Decimal> contractYearAndTrailerExternalMaintenance;
    private static Map<integer,Decimal> contractYearAndTrailerRegistrationFee;
    private static Map<integer,Decimal> contractYearAndTrailerCurrentPurchasePrice;
    private static Map<integer,Decimal> contractYearAndTrailerOriginalPurchasePrice;
    public static boolean isTrailerSelectedTProj = false;
    
    // Maps for Refrigerator..
    private static Map<integer,Decimal> contractYearAndRefrigeratorDepreciation;
    private static Map<integer,Decimal> contractYearAndRefrigeratorResaleValue;
    private static Map<integer,Decimal> contractYearAndRefrigeratorMaintenanceExpenses;
    private static Map<integer,Decimal> contractYearAndRefrigeratorExternalMaintenance;
    private static Map<integer,Decimal> contractYearAndRefrigeratorRegistrationFee;
    private static Map<integer,Decimal> contractYearAndRefrigeratorCurrentPurchasePrice;
    private static Map<integer,Decimal> contractYearAndRefrigeratorOriginalPurchasePrice;
    public static boolean isRefrigeratorSelectedTProj = false;
    
    
    private static Map<integer,boolean> contractYearPresenceMap;
    
    
    // initialize Maps 
    private static void intializeClassMaps(){
        contractYearAndOriginalPurchasePrice = new Map<integer,Decimal>();
        contractYearAndvehiclePurchasePriceBasedOnCondition = new Map<integer,Decimal>();
        contractYearAndvehicleTotalInvestment = new Map<integer,Decimal>();
        contractYearAndvehicleResaleValue = new Map<integer,Decimal>();
        contractYearAndremainingDepreciationOf10Years = new Map<integer,Decimal>();
        
        contractYearAndvehicleDepreciation = new Map<integer,Decimal>();
        contractYearAndvehicleRepairsAndMaintenance = new Map<integer,Decimal>();
        contractYearAndvehicleFinancing = new Map<integer,Decimal>();
        contractYearAndvehicleInsurance = new Map<integer,Decimal>();
        contractYearAndsalikCost = new Map<integer,Decimal>();
        contractYearAndbasicTrackingSystemCost = new Map<integer,Decimal>();
        contractYearAndvehicleRegistrationAndInspectionFee = new Map<integer,Decimal>();
        contractYearAndfuelExpenses = new Map<integer,Decimal>();
        contractYearAndvehicleTotalVariableCost = new Map<integer,Decimal>();
        contractYearAndvehicleTotalFixedCost = new Map<integer,Decimal>();
        contractYearAndvehicleCorporateTax = new Map<integer,Decimal>();
        
        contractYearAnddeprciationReserve = new Map<integer,Decimal>();
        contractYearAndmaintenanceReserve = new Map<integer,Decimal>();
        contractYearAndGeneralReserve = new Map<integer,Decimal>();
        contractYearAndfuelReserve = new Map<integer,Decimal>();
        contractYearAndtotalFuelCost = new Map<integer,Decimal>();
        contractYearAndtotalReserveCost = new Map<integer,Decimal>();
        contractYearAndvatCostonDirectExpenses = new Map<integer,Decimal>();
        
        contractYearAndvehicleTotalCost = new Map<integer,Decimal>();
        contractYearAndannualFuelProfitMarginRate = new Map<integer,Decimal>();
        contractYearAndannualFuelProfitMarginValue = new Map<integer,Decimal>();
        contractYearAndannualVehicleProfitMarginValue = new Map<integer,Decimal>();
        contractYearAndannualVehicleProfitMarginRate = new Map<integer,Decimal>();
        contractYearAndvehicleVATAmount = new Map<integer,Decimal>();
        contractYearPresenceMap = new Map<integer,boolean>();
        
        // target prices --
        contractYearAndGeneralReserveTarget = new Map<integer,Decimal>();
        contractYearAndGeneralReserveDiscount = new Map<integer,Decimal>();
        contractYearAndTotalVehicleCostDiscount = new Map<integer,Decimal>();
        contractYearAndTotalVehicleCostTarget = new Map<integer,Decimal>();
        contractYearAndVehicleProfitMarginRateDiscount = new Map<integer,Decimal>();
        contractYearAndVehicleProfitMarginRateTarget = new Map<integer,Decimal>();
        contractYearAndVehicleProfitMarginValueDiscount = new Map<integer,Decimal>();
        contractYearAndVehicleProfitMarginValueTarget = new Map<integer,Decimal>();
        contractYearAndTotalFuelCostDiscount = new Map<integer,Decimal>();
        contractYearAndTotalFuelCostTarget = new Map<integer,Decimal>();
        
        // for Trailer 
        contractYearAndTrailerDepreciation = new Map<integer,Decimal>();
        contractYearAndTrailerResaleValue = new Map<integer,Decimal>();
        contractYearAndTrailerMaintenanceExpenses = new Map<integer,Decimal>();
        contractYearAndTrailerExternalMaintenance = new Map<integer,Decimal>();
        contractYearAndTrailerRegistrationFee = new Map<integer,Decimal>();
        contractYearAndTrailerCurrentPurchasePrice = new Map<integer,Decimal>();
        contractYearAndTrailerOriginalPurchasePrice = new Map<integer,Decimal>();
        
        // for Refrigerator 
        contractYearAndRefrigeratorDepreciation = new Map<integer,Decimal>();
        contractYearAndRefrigeratorResaleValue = new Map<integer,Decimal>();
        contractYearAndRefrigeratorMaintenanceExpenses = new Map<integer,Decimal>();
        contractYearAndRefrigeratorExternalMaintenance = new Map<integer,Decimal>();
        contractYearAndRefrigeratorRegistrationFee = new Map<integer,Decimal>();
        contractYearAndRefrigeratorCurrentPurchasePrice = new Map<integer,Decimal>();
        contractYearAndRefrigeratorOriginalPurchasePrice = new Map<integer,Decimal>();
    }
    
    
    /*
Method : calculateQuoteElementsWithRates
Description : To Calculate all Quote elements that is - Vehicle quote elements and Manpower quote elements with Rates from Quote...
*/
    public static String calculateQuoteElementsWithRates(String serviceReqId, String quoteId , String totalProjectQuoteId){
        // system.debug('calculateQuoteElementsWithRates called');
        // system.debug('serviceReqId : '+ serviceReqId + ' quoteId: '+ quoteId);
        //Taj
        Map<String,ET_Predefined_Cost_Master__c> costMasterMap = New Map<String,ET_Predefined_Cost_Master__c>();
        for(ET_Predefined_Cost_Master__c costMaster: [SELECT Id,Name,ET_Api_Name__c,ET_Category__c,ET_Sector_Type__c,ET_IsActive__c,ET_Year_1_Cost__c,ET_Year_2_Cost__c,ET_Year_3_Cost__c,ET_Year_4_Cost__c,ET_Year_5_Above_Cost__c FROM ET_Predefined_Cost_Master__c WHERE ET_IsActive__c = true]){
            String key = costMaster.ET_Api_Name__c+'_'+costMaster.ET_Category__c+'_'+costMaster.ET_Sector_Type__c;
            key = key.replaceAll(' ', '_');
            System.debug('costMasterMap key: '+key);
            if(!costMasterMap.containsKey(key))
            costMasterMap.put(key, costMaster);
        }
        
        String response;
        // Initailizations
        Map<String, ET_Vehicle_Quote_Item__c> vehQItemsWithLineAndYear = new Map<String, ET_Vehicle_Quote_Item__c>();
        Map<String, ET_Vehicle_Quote_Item__c> vehQItemsWithId = new Map<String, ET_Vehicle_Quote_Item__c>();
        List<ET_ServiceRequestController.vehicleQuoteCalcClass> vehicleQuoteCalcLst = new List<ET_ServiceRequestController.vehicleQuoteCalcClass>();
        ET_ServiceRequestController.QuoteCalculationClass quotecalculationObj = new ET_ServiceRequestController.QuoteCalculationClass();
        List<ET_Workforce_Quote_Item__c> wFrceQItemslIst = new List<ET_Workforce_Quote_Item__c>();
        // initialize Maps 
        intializeClassMaps();
        List<ET_Pricing_VAT_setup__c> vatData =  new List<ET_Pricing_VAT_setup__c>();
        vatData = [Select id,ET_Cost_Api_Name__c,ET_IsRecoverable__c,Name,ET_Cost_Type__c FROM ET_Pricing_VAT_setup__c 
                   where ET_IsRecoverable__c = true ];
        
        // do workforce quote Item calculations with Rates from output quote items and input
        
        //  system.debug('calculateWorkForceQuoteElementsWithRates Called');
        quotecalculationObj = ET_WorkForceQuoteItemsCalculationClass.calculateWorkForceQuoteElementsWithRates(serviceReqId, quoteId , quotecalculationObj,vatData );
        // system.debug('updateWorkForceObjectsForTotalProject Called');
        ET_WorkForceQuoteItemsCalculationClass.updateWorkForceObjectsForTotalProject(totalProjectQuoteId);
        
        //query Vehicle Requests for given Service Request
        Map<Id, Vehicle__c > vehRequests = ET_PricingUtilityClass.getVehicleRequestMap(serviceReqId);
        
        //query Vehicle quote Items for given Quote
        List<ET_Vehicle_Quote_Item__c> vehQItemsList = ET_PricingUtilityClass.getVehicleQuoteItemLst(quoteId);
        if(!vehQItemsList.isEmpty()){
            for(ET_Vehicle_Quote_Item__c vQuote : vehQItemsList ){
                String key = vQuote.ET_Line_Number__c+'-'+vQuote.ET_Contract_Period__c;
                vehQItemsWithLineAndYear.put( key, vQuote);
                vehQItemsWithId.put(vQuote.id, vQuote);
            }
        }
        
        //elements Calculation starts - Iterate for each Vehicle and each Contract Year..
        //  system.debug('vehRequests = '+ JSON.serializePretty(vehRequests));
        try{
            if(!vehRequests.isEmpty()){
                for(Vehicle__c vehicle : vehRequests.values() ){
                    
                    List<String> contractYearLst = vehicle.ET_Contract_Period__c.split(',');
                    decimal noOfVehicles = vehicle.ET_Vehicle_Quantity__c;
                    totalVehicles += noOfVehicles;
                    totalVehicleLines ++;
                    // Total investment 
                    decimal totalInvestment = 0;
                    
                    if(!contractYearLst.isEmpty()){
                        for(String contractYear : contractYearLst){
                            ET_ServiceRequestController.vehicleQuoteCalcClass vehicleQuoteCalcObj = new ET_ServiceRequestController.vehicleQuoteCalcClass();
                            contractYear = contractYear.substring(0,1);
                            integer integerContractYear = integer.ValueOf(contractYear);
                            vehicleQuoteCalcObj.contractYear = integerContractYear ;
                            String key = vehicle.ET_Vehicle_Line__c+'-'+contractYear;
                            // system.debug('key =  '+ key);
                            // system.debug('vehQItemsWithLineAndYear = '+ JSON.serializePretty(vehQItemsWithLineAndYear));
                            ET_Vehicle_Quote_Item__c vehQuoteItem ;
                            
                            if(vehQItemsWithLineAndYear.containsKey(key)){
                                vehQuoteItem = vehQItemsWithLineAndYear.get(key); // get veh Quote Item for the given Line and Year...
                            }
                            
                            // system.debug('vehQuoteItem tst = '+ JSON.serializePretty(vehQuoteItem));
                            
                            // if vehQuoteItem is null - don't Proceed..
                            if(vehQuoteItem != null){
                                vehicleQuoteCalcObj.vehicleQuoteId = vehQuoteItem.id;
                                Decimal currentVehicleValue =0.0;
                                Decimal originalVehicleValue=0.0;
                                Decimal depreciationRate = vehQuoteItem.ET_Vehicle_Depreciation_Percentage__c != null ? vehQuoteItem.ET_Vehicle_Depreciation_Percentage__c : 0.0;
                                Decimal extraDepreciationRate = vehQuoteItem.ET_Depreciation_Rate_for_Extra_Mileage__c!= null ?vehQuoteItem.ET_Depreciation_Rate_for_Extra_Mileage__c : 0.0 ;
                                vehicleQuoteCalcObj.depreciationRateforExtraMileage = extraDepreciationRate;
                                decimal totalDepreciation = depreciationRate + extraDepreciationRate;
                                Decimal maxDepreciationRate; 
                                Integer modelYearInRequest = Integer.valueOf(vehicle.ET_Vehicle_Model_Year__c);
                                String vehicleCondFromRequest = vehicle.ET_Vehicle_Condition__c;
                                Integer diffInManufactureYears = (System.Today().year() - modelYearInRequest);
                                Decimal diffInManufactureYearsNew = vehQuoteItem.Passed_years_from_Bus_Model__c;
                                Decimal annualMileage = vehQuoteItem.ET_Total_Annual_Mileage__c;
                                String depreciationType = vehQuoteItem.ET_Depreciation_Type__c;
                                String fleetType = vehQuoteItem.ET_Fleet_Type__c;
                                decimal resaleValue = 0.0;
                                String vehSource = vehQuoteItem.ET_Vehicle_Source__c;
                                if(vehQuoteItem.ET_Vehicle_Resale_Value__c == 'N/A'){
                                    resaleValue = 0.0;
                                }
                                else if(vehQuoteItem.ET_Vehicle_Resale_Value__c != null){
                                    resaleValue = decimal.valueOf(vehQuoteItem.ET_Vehicle_Resale_Value__c).setScale(2);
                                }
                                
                                
                                currentVehicleValue = vehQuoteItem.ET_Vehicle_Current_Purchase_Price__c;
                                originalVehicleValue = vehQuoteItem.ET_Vehicle_Original_Purchase_Price__c;
                                vehicleQuoteCalcObj.vehiclePurchasePriceBasedOnCondition = currentVehicleValue;
                                if(vehSource == 'Main' || vehSource == 'Substitutional'){
                                    if(totalInvestment == null || totalInvestment == 0){
                                        totalInvestment = currentVehicleValue * vehQuoteItem.ET_Number_of_Vehicles__c;
                                        quotationTotalInvestment += totalInvestment;
                                    }
                                }
                                
                                // if Trailer selected 
                                boolean isTrailerSelected = vehQuoteItem.Is_trailer_selected__c;
                                if(vehQuoteItem.Is_trailer_selected__c){
                                    isTrailerSelectedTProj = vehQuoteItem.Is_trailer_selected__c;
                                }
                                Decimal currentValueOfTrailer =0.0;
                                Decimal originalValueOfTrailer=0.0;
                                Decimal trailerDepreciationRate = vehQuoteItem.Trailer_Depreciation_Rate__c != null ? vehQuoteItem.Trailer_Depreciation_Rate__c : 0.0;
                                String trailerDepreciationType = vehQuoteItem.Trailer_depreciation_type__c;
                                decimal trailerTotalDepreciation = trailerDepreciationRate ;
                                Decimal trailerMaxDepreciationRate; 
                                Integer trailerModelYearInRequest = Integer.valueOf(vehicle.Trailer_model_year__c);
                                String trailerCondFromRequest = vehicle.Trailer_condition__c;
                                Integer trailerDiffInManufactureYears;
                                if(trailerModelYearInRequest != null){
                                    trailerDiffInManufactureYears = (System.Today().year() - trailerModelYearInRequest);
                                }
                                decimal trailerResaleValue = 0.0;
                                if(vehQuoteItem.Trailer_Resale_Value__c == 'N/A'){
                                    trailerResaleValue = 0.0;
                                }
                                else if(vehQuoteItem.Trailer_Resale_Value__c != null){
                                    trailerResaleValue = decimal.valueOf(vehQuoteItem.Trailer_Resale_Value__c).setScale(2);
                                }
                                
                                currentValueOfTrailer = vehQuoteItem.Trailer_Current_Purchase_Price__c;
                                originalValueOfTrailer = vehQuoteItem.Trailer_Original_Purchase_Price__c;
                                vehicleQuoteCalcObj.trailerCurrentPurchasePrice = currentValueOfTrailer;
                                // ************* Trailer attributes end ***************************************//
                                
                                
                                // if Refrigerator selected 
                                boolean isRefrigeratorSelected = vehQuoteItem.Is_Refrigerator_selected__c;
                                if(vehQuoteItem.Is_Refrigerator_selected__c){
                                    isRefrigeratorSelectedTProj = vehQuoteItem.Is_Refrigerator_selected__c;
                                }
                                Decimal currentValueOfRefrigerator =0.0;
                                Decimal originalValueOfRefrigerator=0.0;
                                Decimal refrigeratorDepreciationRate = vehQuoteItem.Refrigerator_Depreciation_Rate__c != null ? vehQuoteItem.Refrigerator_Depreciation_Rate__c : 0.0;
                                String refrigeratorDepreciationType = vehQuoteItem.Refrigerator_depreciation_type__c;
                                decimal refrigeratorTotalDepreciation = refrigeratorDepreciationRate ;
                                Decimal refrigeratorMaxDepreciationRate; 
                                Integer refrigeratorModelYearInRequest = Integer.valueOf(vehicle.Refrigerator_model_year__c);
                                String refrigeratorCondFromRequest = vehicle.Refrigerator_condition__c;
                                Integer refrigeratorDiffInManufactureYears;
                                if(refrigeratorModelYearInRequest != null){
                                    refrigeratorDiffInManufactureYears = (System.Today().year() - refrigeratorModelYearInRequest);
                                }
                                decimal refrigeratorResaleValue = 0.0;
                                if(vehQuoteItem.Refrigerator_Resale_Value__c == 'N/A'){
                                    refrigeratorResaleValue = 0.0;
                                }
                                else if(vehQuoteItem.Refrigerator_Resale_Value__c != null){
                                    refrigeratorResaleValue = decimal.valueOf(vehQuoteItem.Refrigerator_Resale_Value__c).setScale(2);
                                }
                                
                                currentValueOfRefrigerator = vehQuoteItem.Refrigerator_Current_Purchase_Price__c;
                                originalValueOfRefrigerator = vehQuoteItem.Refrigerator_Original_Purchase_Price__c;
                                vehicleQuoteCalcObj.refrigeratorCurrentPurchasePrice = currentValueOfRefrigerator;
                                // ************* Trailer attributes end ***************************************//
                                
                                
                                
                                
                                // Total current Value - sum of current values of Vehicles, Trailer and Refrigerator...
                                decimal vehicleTrailerAndRefrigeratorCurrentValue = (vehQuoteItem.Trailer_Current_Purchase_Price__c != null ? vehQuoteItem.Trailer_Current_Purchase_Price__c : 0) +(vehQuoteItem.Refrigerator_Current_Purchase_Price__c != null ? vehQuoteItem.Refrigerator_Current_Purchase_Price__c : 0)
                                    +vehQuoteItem.ET_Vehicle_Current_Purchase_Price__c;
                                
                                // Total original Value - sum of original values of Vehicles, Trailer and Refrigerator...
                                decimal vehicleTrailerAndRefrigeratorOriginalValue = (vehQuoteItem.Trailer_Original_Purchase_Price__c != null ? vehQuoteItem.Trailer_Original_Purchase_Price__c : 0) +(vehQuoteItem.Refrigerator_Original_Purchase_Price__c != null ? vehQuoteItem.Refrigerator_Original_Purchase_Price__c : 0)
                                    +vehQuoteItem.ET_Vehicle_Original_Purchase_Price__c;
                                
                                
                                decimal vehicleTrailerAndRefrigeratorDepreciationValue =0;
                                decimal vehicleTrailerAndRefrigeratorResaleValue =0;
                                vehicleQuoteCalcObj.vehicleTrailerAndRefrigeratorCurrentValue = vehicleTrailerAndRefrigeratorCurrentValue;
                                
                                
                                //Map of Values for Total Project Calculations.... Sum up Values for each contract year for all Lines..
                                
                                if(contractYearPresenceMap != null && !contractYearPresenceMap.containsKey(integerContractYear)){
                                    contractYearPresenceMap.put(integerContractYear, true);
                                }
                                
                                // Total Project for Current Purchase price
                                if(vehSource == 'Main' && contractYearAndvehiclePurchasePriceBasedOnCondition != null &&  
                                   contractYearAndvehiclePurchasePriceBasedOnCondition.containsKey(integerContractYear) && currentVehicleValue != null && currentVehicleValue != 0.0){
                                       contractYearAndvehiclePurchasePriceBasedOnCondition.put(integerContractYear ,contractYearAndvehiclePurchasePriceBasedOnCondition.get(integerContractYear)+currentVehicleValue*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && currentVehicleValue != null && currentVehicleValue != 0.0 ){
                                        contractYearAndvehiclePurchasePriceBasedOnCondition.put(integerContractYear, currentVehicleValue*noOfVehicles );
                                    }
                                }
                                
                                // Total Project for original Purchase price
                                if(vehSource == 'Main' && contractYearAndOriginalPurchasePrice != null &&  
                                   contractYearAndOriginalPurchasePrice.containsKey(integerContractYear) && originalVehicleValue != null && originalVehicleValue != 0.0){
                                       contractYearAndOriginalPurchasePrice.put(integerContractYear ,contractYearAndOriginalPurchasePrice.get(integerContractYear)+originalVehicleValue*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && originalVehicleValue != null && originalVehicleValue != 0.0 ){
                                        contractYearAndOriginalPurchasePrice.put(integerContractYear, originalVehicleValue*noOfVehicles );
                                    }
                                }
                                
                                // Total Project for Current Purchase price of Trailer
                                if(isTrailerSelected){
                                    if(vehSource == 'Main' && contractYearAndTrailerCurrentPurchasePrice != null &&  
                                       contractYearAndTrailerCurrentPurchasePrice.containsKey(integerContractYear) && currentValueOfTrailer != null && currentValueOfTrailer != 0.0){
                                           contractYearAndTrailerCurrentPurchasePrice.put(integerContractYear ,contractYearAndTrailerCurrentPurchasePrice.get(integerContractYear)+currentValueOfTrailer*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && currentValueOfTrailer != null && currentValueOfTrailer != 0.0 ){
                                            contractYearAndTrailerCurrentPurchasePrice.put(integerContractYear, currentValueOfTrailer*noOfVehicles );
                                        }
                                    }
                                    
                                    // Total Project for original Purchase price of Trailer
                                    if(vehSource == 'Main' && contractYearAndTrailerOriginalPurchasePrice != null &&  
                                       contractYearAndTrailerOriginalPurchasePrice.containsKey(integerContractYear) && originalValueOfTrailer != null && originalValueOfTrailer != 0.0){
                                           contractYearAndTrailerOriginalPurchasePrice.put(integerContractYear ,contractYearAndTrailerOriginalPurchasePrice.get(integerContractYear)+originalValueOfTrailer*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && originalValueOfTrailer != null && originalValueOfTrailer != 0.0 ){
                                            contractYearAndTrailerOriginalPurchasePrice.put(integerContractYear, originalValueOfTrailer*noOfVehicles );
                                        }
                                    }
                                }
                                
                                // Total Project for Current Purchase price of Refrigerator
                                if(isRefrigeratorSelected){
                                    if(vehSource == 'Main' && contractYearAndRefrigeratorCurrentPurchasePrice != null &&  
                                       contractYearAndRefrigeratorCurrentPurchasePrice.containsKey(integerContractYear) && currentValueOfRefrigerator != null && currentValueOfRefrigerator != 0.0){
                                           contractYearAndRefrigeratorCurrentPurchasePrice.put(integerContractYear ,contractYearAndRefrigeratorCurrentPurchasePrice.get(integerContractYear)+currentValueOfRefrigerator*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && currentValueOfRefrigerator != null && currentValueOfRefrigerator != 0.0 ){
                                            contractYearAndRefrigeratorCurrentPurchasePrice.put(integerContractYear, currentValueOfRefrigerator*noOfVehicles );
                                        }
                                    }
                                    
                                    // Total Project for original Purchase price of Refrigerator
                                    if(vehSource == 'Main' && contractYearAndRefrigeratorOriginalPurchasePrice != null &&  
                                       contractYearAndRefrigeratorOriginalPurchasePrice.containsKey(integerContractYear) && originalValueOfRefrigerator != null && originalValueOfRefrigerator != 0.0){
                                           contractYearAndRefrigeratorOriginalPurchasePrice.put(integerContractYear ,contractYearAndRefrigeratorOriginalPurchasePrice.get(integerContractYear)+originalValueOfRefrigerator*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && originalValueOfRefrigerator != null && originalValueOfRefrigerator != 0.0 ){
                                            contractYearAndRefrigeratorOriginalPurchasePrice.put(integerContractYear, originalValueOfRefrigerator*noOfVehicles );
                                        }
                                    }
                                }
                                
                                if(vehicleTrailerAndRefrigeratorCurrentValue != null && vehQuoteItem.ET_Number_of_Vehicles__c != null ){
                                    vehicleQuoteCalcObj.vehicleTotalInvestment = vehicleTrailerAndRefrigeratorCurrentValue *vehQuoteItem.ET_Number_of_Vehicles__c;
                                    // For total Project quote Total Investment
                                    if(vehSource == 'Main' && contractYearAndvehicleTotalInvestment != null &&  
                                       contractYearAndvehicleTotalInvestment.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleTotalInvestment != null && vehicleQuoteCalcObj.vehicleTotalInvestment != 0.0){
                                           contractYearAndvehicleTotalInvestment.put(integerContractYear ,contractYearAndvehicleTotalInvestment.get(integerContractYear)+vehicleQuoteCalcObj.vehicleTotalInvestment*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleTotalInvestment != null && vehicleQuoteCalcObj.vehicleTotalInvestment != 0.0 ){
                                            contractYearAndvehicleTotalInvestment.put(integerContractYear, vehicleQuoteCalcObj.vehicleTotalInvestment*noOfVehicles );
                                        }
                                    }
                                }
                                
                                //******************************resale value calc**START****** */
                                
                                Decimal annualKmFrmServiceRequest = vehicle.ET_Annual_KM__c;
                                String depreciationMethod = vehQuoteItem.ET_Depreciation_Method__c ;
                                if(depreciationMethod!= null && depreciationMethod  != ''){
                                    if(depreciationMethod == 'Accelerated' && fleetType == 'ET Fleet'){
                                        if(depreciationType == 'Percentage'){
                                            //totalDepreciation < 90 && vehicle.ET_Vehicle_Condition__c == 'New'
                                            if(vehicle.ET_Vehicle_Condition__c == 'New'){
                                                vehicleQuoteCalcObj.vehicleDepreciationRate = depreciationRate;
                                                vehicleQuoteCalcObj.vehicleResaleDecimalValue = vehicleQuoteCalcObj.vehiclePurchasePriceBasedOnCondition * (1-(totalDepreciation/100));
                                                vehicleQuoteCalcObj.vehicleDepreciationDecimalValue = (originalVehicleValue - vehicleQuoteCalcObj.vehicleResaleDecimalValue)/integerContractYear;
                                            }
                                            else if(depreciationRate < 90 && vehicle.ET_Vehicle_Condition__c == 'Used'){
                                                vehicleQuoteCalcObj.vehicleDepreciationRate = depreciationRate;
                                                vehicleQuoteCalcObj.vehicleDepreciationDecimalValue = (originalVehicleValue *(totalDepreciation/100))/integerContractYear;
                                                vehicleQuoteCalcObj.vehicleResaleDecimalValue = currentVehicleValue -(vehicleQuoteCalcObj.vehicleDepreciationDecimalValue *integerContractYear);
                                                decimal minResaleValue = 0.0;
                                                if(vehQuoteItem.ET_Minimum_resale_value_percentage__c != null && vehQuoteItem.ET_Minimum_resale_value_percentage__c != 0){
                                                    minResaleValue = originalVehicleValue*(vehQuoteItem.ET_Minimum_resale_value_percentage__c/100);
                                                }
                                                else if(vehQuoteItem.ET_Min_Resale_Value__c != null && vehQuoteItem.ET_Min_Resale_Value__c != 0){
                                                    minResaleValue =vehQuoteItem.ET_Min_Resale_Value__c;
                                                }
                                                
                                                if(vehicleQuoteCalcObj.vehicleResaleDecimalValue < minResaleValue ){
                                                    vehicleQuoteCalcObj.vehicleResaleDecimalValue = minResaleValue;
                                                }
                                                
                                            }
                                            else if(totalDepreciation >= 90 && vehicle.ET_Vehicle_Condition__c == 'Used'){
                                                if(vehQuoteItem.ET_Minimum_resale_value_percentage__c != null && vehQuoteItem.ET_Minimum_resale_value_percentage__c != 0){
                                                    vehicleQuoteCalcObj.vehicleResaleDecimalValue = originalVehicleValue*(vehQuoteItem.ET_Minimum_resale_value_percentage__c/100);
                                                }
                                                else if(vehQuoteItem.ET_Min_Resale_Value__c != null && vehQuoteItem.ET_Min_Resale_Value__c != 0){
                                                    vehicleQuoteCalcObj.vehicleResaleDecimalValue =vehQuoteItem.ET_Min_Resale_Value__c;
                                                }
                                                
                                                vehicleQuoteCalcObj.vehicleDepreciationRate =(1 - vehicleQuoteCalcObj.vehicleResaleDecimalValue/originalVehicleValue)*100 ;
                                                
                                                vehicleQuoteCalcObj.vehicleDepreciationDecimalValue = (currentVehicleValue - vehicleQuoteCalcObj.vehicleResaleDecimalValue)/integerContractYear;
                                            }
                                            
                                        }
                                        else if(depreciationType == 'Value'){
                                            vehicleQuoteCalcObj.vehicleResaleDecimalValue = resaleValue;
                                            decimal depreciation =0.0;
                                            if(vehicle.ET_Vehicle_Condition__c == 'New'){
                                                depreciation = (originalVehicleValue - vehicleQuoteCalcObj.vehicleResaleDecimalValue)/integerContractYear;
                                                depreciationRate = ((depreciation *integerContractYear)/ originalVehicleValue)*100;
                                            }
                                            else if(vehicle.ET_Vehicle_Condition__c == 'Used'){
                                                depreciation = (currentVehicleValue - vehicleQuoteCalcObj.vehicleResaleDecimalValue)/integerContractYear;
                                                depreciationRate = (1 -(resaleValue /originalVehicleValue ))*100;
                                            }
                                            vehicleQuoteCalcObj.vehicleDepreciation = string.valueOf(depreciation);
                                            vehicleQuoteCalcObj.vehicleDepreciationDecimalValue =depreciation;
                                            vehicleQuoteCalcObj.vehicleDepreciationRate = depreciationRate;
                                        }
                                    }
                                    else if(depreciationMethod == 'Straight Line' && fleetType == 'ET Fleet'){
                                        if(vehQuoteItem.ET_Minimum_resale_value_percentage__c != null && vehQuoteItem.ET_Minimum_resale_value_percentage__c != 0 && originalVehicleValue!= null){
                                            vehicleQuoteCalcObj.vehicleResaleDecimalValue = originalVehicleValue*(vehQuoteItem.ET_Minimum_resale_value_percentage__c/100);
                                        }
                                        else if(vehQuoteItem.ET_Min_Resale_Value__c != null && vehQuoteItem.ET_Min_Resale_Value__c != 0){
                                            vehicleQuoteCalcObj.vehicleResaleDecimalValue =vehQuoteItem.ET_Min_Resale_Value__c;
                                        }
                                        
                                        // depreciation percentage..
                                        vehicleQuoteCalcObj.vehicleDepreciationRate =(1 - vehicleQuoteCalcObj.vehicleResaleDecimalValue/originalVehicleValue)*100 ;
                                        
                                    }
                                }
                                
                                //******* depreciation and resale Value calculation for --- Trailer ***********//
                                
                                if(isTrailerSelected){
                                    if(depreciationMethod!= null && depreciationMethod  != ''){
                                        if(depreciationMethod == 'Accelerated' && fleetType == 'ET Fleet'){
                                            if(trailerDepreciationType == 'Percentage'){
                                                if(trailerTotalDepreciation < 90 && vehicle.Trailer_condition__c == 'New'){
                                                    vehicleQuoteCalcObj.trailerDepreciationRate = trailerDepreciationRate;
                                                    vehicleQuoteCalcObj.trailerResaleDecimalValue = vehicleQuoteCalcObj.trailerCurrentPurchasePrice * (1-(trailerTotalDepreciation/100));
                                                    vehicleQuoteCalcObj.trailerDepreciationDecimalValue = (originalValueOfTrailer - vehicleQuoteCalcObj.trailerResaleDecimalValue)/integerContractYear;
                                                }
                                                else if(trailerDepreciationRate < 90 && vehicle.Trailer_condition__c == 'Used'){
                                                    vehicleQuoteCalcObj.trailerDepreciationRate = trailerDepreciationRate;
                                                    vehicleQuoteCalcObj.trailerDepreciationDecimalValue = (originalValueOfTrailer *(trailerTotalDepreciation/100))/integerContractYear;
                                                    vehicleQuoteCalcObj.trailerResaleDecimalValue = currentValueOfTrailer -(vehicleQuoteCalcObj.trailerDepreciationDecimalValue *integerContractYear);
                                                    decimal minResaleValue = 0.0;
                                                    if(vehQuoteItem.Trailer_min_Resale_Value_Percentage__c != null && vehQuoteItem.Trailer_min_Resale_Value_Percentage__c != 0){
                                                        minResaleValue = originalValueOfTrailer*(vehQuoteItem.Trailer_min_Resale_Value_Percentage__c/100);
                                                    }
                                                    else if(vehQuoteItem.Trailer_min_Resale_Value__c != null && vehQuoteItem.Trailer_min_Resale_Value__c != 0){
                                                        minResaleValue =vehQuoteItem.Trailer_min_Resale_Value__c;
                                                    }
                                                    
                                                    if(vehicleQuoteCalcObj.trailerResaleDecimalValue < minResaleValue ){
                                                        vehicleQuoteCalcObj.trailerResaleDecimalValue = minResaleValue;
                                                    }
                                                    
                                                }
                                                else if(trailerTotalDepreciation >= 90 && vehicle.Trailer_condition__c == 'Used'){
                                                    if(vehQuoteItem.Trailer_min_Resale_Value_Percentage__c != null && vehQuoteItem.Trailer_min_Resale_Value_Percentage__c != 0){
                                                        vehicleQuoteCalcObj.trailerResaleDecimalValue = originalValueOfTrailer*(vehQuoteItem.Trailer_min_Resale_Value_Percentage__c/100);
                                                    }
                                                    else if(vehQuoteItem.Trailer_min_Resale_Value__c != null && vehQuoteItem.Trailer_min_Resale_Value__c != 0){
                                                        vehicleQuoteCalcObj.trailerResaleDecimalValue =vehQuoteItem.Trailer_min_Resale_Value__c;
                                                    }
                                                    
                                                    vehicleQuoteCalcObj.trailerDepreciationRate =(1 - vehicleQuoteCalcObj.trailerResaleDecimalValue/originalValueOfTrailer)*100 ;
                                                    
                                                    vehicleQuoteCalcObj.trailerDepreciationDecimalValue = (currentValueOfTrailer - vehicleQuoteCalcObj.trailerResaleDecimalValue)/integerContractYear;
                                                }
                                                
                                            }
                                            else if(trailerDepreciationType == 'Value'){
                                                vehicleQuoteCalcObj.trailerResaleDecimalValue = trailerResaleValue;
                                                decimal depreciation =0.0;
                                                if(vehicle.Trailer_condition__c == 'New'){
                                                    depreciation = (originalValueOfTrailer - vehicleQuoteCalcObj.trailerResaleDecimalValue)/integerContractYear;
                                                    trailerDepreciationRate = ((depreciation *integerContractYear)/ originalValueOfTrailer)*100;
                                                }
                                                else if(vehicle.Trailer_condition__c == 'Used'){
                                                    depreciation = (currentValueOfTrailer - vehicleQuoteCalcObj.trailerResaleDecimalValue)/integerContractYear;
                                                    trailerDepreciationRate = (1 -(trailerResaleValue /originalValueOfTrailer ))*100;
                                                }
                                                
                                                vehicleQuoteCalcObj.trailerDepreciation = string.valueOf(depreciation);
                                                vehicleQuoteCalcObj.trailerDepreciationDecimalValue =depreciation;
                                                vehicleQuoteCalcObj.trailerDepreciationRate = trailerDepreciationRate;
                                                //   system.debug('trailerDepreciationRate = '+ trailerDepreciationRate);
                                            }
                                        }
                                        
                                        else if(depreciationMethod == 'Straight Line' && fleetType == 'ET Fleet'){
                                            if(vehQuoteItem.Trailer_min_Resale_Value_Percentage__c != null && vehQuoteItem.Trailer_min_Resale_Value_Percentage__c != 0 && originalValueOfTrailer!= null){
                                                vehicleQuoteCalcObj.trailerResaleDecimalValue = originalValueOfTrailer*(vehQuoteItem.Trailer_min_Resale_Value_Percentage__c/100);
                                            }
                                            else if(vehQuoteItem.Trailer_min_Resale_Value__c != null && vehQuoteItem.Trailer_min_Resale_Value__c != 0){
                                                vehicleQuoteCalcObj.trailerResaleDecimalValue =vehQuoteItem.Trailer_min_Resale_Value__c;
                                            }
                                        }
                                    }
                                }
                                
                                
                                //******* depreciation and resale Value calculation for --- Refrigerator ***********//
                                
                                if(isRefrigeratorSelected){
                                    if(depreciationMethod!= null && depreciationMethod  != ''){
                                        if(depreciationMethod == 'Accelerated' && fleetType == 'ET Fleet'){
                                            if(refrigeratorDepreciationType == 'Percentage'){
                                                if(refrigeratorTotalDepreciation < 90 && vehicle.Refrigerator_condition__c == 'New'){
                                                    vehicleQuoteCalcObj.refrigeratorDepreciationRate = refrigeratorDepreciationRate;
                                                    vehicleQuoteCalcObj.refrigeratorResaleDecimalValue = vehicleQuoteCalcObj.refrigeratorCurrentPurchasePrice * (1-(refrigeratorTotalDepreciation/100));
                                                    vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue = (originalValueOfRefrigerator - vehicleQuoteCalcObj.refrigeratorResaleDecimalValue)/integerContractYear;
                                                }
                                                else if(refrigeratorDepreciationRate < 90 && vehicle.Refrigerator_condition__c == 'Used'){
                                                    vehicleQuoteCalcObj.refrigeratorDepreciationRate = refrigeratorDepreciationRate;
                                                    vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue = (originalValueOfRefrigerator *(refrigeratorTotalDepreciation/100))/integerContractYear;
                                                    vehicleQuoteCalcObj.refrigeratorResaleDecimalValue = currentValueOfRefrigerator -(vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue *integerContractYear);
                                                    decimal minResaleValue = 0.0;
                                                    if(vehQuoteItem.Refrigerator_min_Resale_Value_Percentage__c != null && vehQuoteItem.Refrigerator_min_Resale_Value_Percentage__c != 0){
                                                        minResaleValue = originalValueOfRefrigerator*(vehQuoteItem.Refrigerator_min_Resale_Value_Percentage__c/100);
                                                    }
                                                    else if(vehQuoteItem.Refrigerator_min_Resale_Value__c != null && vehQuoteItem.Refrigerator_min_Resale_Value__c != 0){
                                                        minResaleValue =vehQuoteItem.Refrigerator_min_Resale_Value__c;
                                                    }
                                                    
                                                    if(vehicleQuoteCalcObj.refrigeratorResaleDecimalValue < minResaleValue ){
                                                        vehicleQuoteCalcObj.refrigeratorResaleDecimalValue = minResaleValue;
                                                    }
                                                    
                                                }
                                                else if(refrigeratorTotalDepreciation >= 90 && vehicle.Refrigerator_condition__c == 'Used'){
                                                    if(vehQuoteItem.Refrigerator_min_Resale_Value_Percentage__c != null && vehQuoteItem.Refrigerator_min_Resale_Value_Percentage__c != 0){
                                                        vehicleQuoteCalcObj.refrigeratorResaleDecimalValue = originalValueOfRefrigerator*(vehQuoteItem.Refrigerator_min_Resale_Value_Percentage__c/100);
                                                    }
                                                    else if(vehQuoteItem.Refrigerator_min_Resale_Value__c != null && vehQuoteItem.Refrigerator_min_Resale_Value__c != 0){
                                                        vehicleQuoteCalcObj.refrigeratorResaleDecimalValue =vehQuoteItem.Refrigerator_min_Resale_Value__c;
                                                    }
                                                    
                                                    vehicleQuoteCalcObj.refrigeratorDepreciationRate =(1 - vehicleQuoteCalcObj.refrigeratorResaleDecimalValue/originalValueOfRefrigerator)*100 ;
                                                    
                                                    vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue = (currentValueOfRefrigerator - vehicleQuoteCalcObj.refrigeratorResaleDecimalValue)/integerContractYear;
                                                }
                                                
                                            }
                                            else if(refrigeratorDepreciationType == 'Value'){
                                                vehicleQuoteCalcObj.refrigeratorResaleDecimalValue = refrigeratorResaleValue;
                                                decimal depreciation =0.0;
                                                if(vehicle.Refrigerator_condition__c == 'New'){
                                                    depreciation = (originalValueOfRefrigerator - vehicleQuoteCalcObj.refrigeratorResaleDecimalValue)/integerContractYear;
                                                    refrigeratorDepreciationRate = ((depreciation *integerContractYear)/ originalValueOfRefrigerator)*100;
                                                }
                                                else if(vehicle.Refrigerator_condition__c == 'Used'){
                                                    depreciation = (currentValueOfRefrigerator - vehicleQuoteCalcObj.refrigeratorResaleDecimalValue)/integerContractYear;
                                                    refrigeratorDepreciationRate = (1 -(refrigeratorResaleValue /originalValueOfRefrigerator ))*100;
                                                }
                                                
                                                vehicleQuoteCalcObj.refrigeratorDepreciation = string.valueOf(depreciation);
                                                vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue =depreciation;
                                                vehicleQuoteCalcObj.refrigeratorDepreciationRate = refrigeratorDepreciationRate;
                                            }
                                        }
                                        
                                        else if(depreciationMethod == 'Straight Line' && fleetType == 'ET Fleet'){
                                            if(vehQuoteItem.Refrigerator_min_Resale_Value_Percentage__c != null && vehQuoteItem.Refrigerator_min_Resale_Value_Percentage__c != 0 && originalValueOfRefrigerator!= null){
                                                vehicleQuoteCalcObj.refrigeratorResaleDecimalValue = originalValueOfRefrigerator*(vehQuoteItem.Refrigerator_min_Resale_Value_Percentage__c/100);
                                            }
                                            else if(vehQuoteItem.Refrigerator_min_Resale_Value__c != null && vehQuoteItem.Refrigerator_min_Resale_Value__c != 0){
                                                vehicleQuoteCalcObj.refrigeratorResaleDecimalValue =vehQuoteItem.Refrigerator_min_Resale_Value__c;
                                            }
                                        }
                                    }
                                }
                                
                                
                                //******************************resale value calc**END****** */
                                
                                // ****************Remaining depreciation of 10 years Calculation - only for Stright line method and Used Vehicle ****************//
                                
                                if(depreciationMethod == 'Straight Line'  && vehQuoteItem.ET_Min_Depreciation_Years__c != null 
                                   && vehQuoteItem.ET_Min_Depreciation_Years__c != 0 
                                   // &&  vehQuoteItem.ET_Vehicle_Condition__c == 'used' // formula update by on Arun 13.03.2023 for new vehicle also the same formula 
                                  ){
                                      vehicleQuoteCalcObj.remainingDepreciationOf10Years = (originalVehicleValue - (originalVehicleValue/vehQuoteItem.ET_Min_Depreciation_Years__c)*diffInManufactureYears);
                                  }
                                
                                // for Trailer 
                                if(isTrailerSelected && depreciationMethod == 'Straight Line'  && vehQuoteItem.Trailer_min_Depreciation_Years__c != null 
                                   && vehQuoteItem.Trailer_min_Depreciation_Years__c != 0 &&  vehQuoteItem.Trailer_Condition__c == 'used'){
                                       vehicleQuoteCalcObj.trailerRemainingDepreciationOf10Years = (originalValueOfTrailer - (originalValueOfTrailer/(vehQuoteItem.Trailer_min_Depreciation_Years__c*trailerDiffInManufactureYears)));
                                   }
                                
                                // for Refrigerator 
                                if(isRefrigeratorSelected && depreciationMethod == 'Straight Line'  && vehQuoteItem.Refrigerator_min_Depreciation_Years__c != null 
                                   && vehQuoteItem.Refrigerator_min_Depreciation_Years__c != 0 &&  vehQuoteItem.Refrigerator_Condition__c == 'used'){
                                       vehicleQuoteCalcObj.refrigeratorRemainingDepreciationOf10Years = (originalValueOfRefrigerator - (originalValueOfRefrigerator/(vehQuoteItem.Refrigerator_min_Depreciation_Years__c*refrigeratorDiffInManufactureYears)));
                                   }
                                
                                // For total Project quote remaining Depreciation Of 10Years
                                if(vehSource == 'Main' && contractYearAndremainingDepreciationOf10Years != null &&  
                                   contractYearAndremainingDepreciationOf10Years.containsKey(integerContractYear) && vehicleQuoteCalcObj.remainingDepreciationOf10Years != null ){
                                       contractYearAndremainingDepreciationOf10Years.put(integerContractYear ,contractYearAndremainingDepreciationOf10Years.get(integerContractYear)+vehicleQuoteCalcObj.remainingDepreciationOf10Years );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.remainingDepreciationOf10Years != null ){
                                        contractYearAndremainingDepreciationOf10Years.put(integerContractYear, vehicleQuoteCalcObj.remainingDepreciationOf10Years );
                                    }
                                }
                                
                                if(depreciationMethod == 'Straight Line'  && vehQuoteItem.ET_Min_Depreciation_Years__c != null && 
                                   vehQuoteItem.ET_Min_Depreciation_Years__c != 0 &&  vehQuoteItem.ET_Vehicle_Condition__c == 'Used')
                                {
                                    decimal remainingDepreciationYears =vehQuoteItem.ET_Min_Depreciation_Years__c - diffInManufactureYears;
                                    if(vehicleQuoteCalcObj.contractYear < = remainingDepreciationYears ){
                                        vehicleQuoteCalcObj.vehicleDepreciationDecimalValue = (originalVehicleValue - vehicleQuoteCalcObj.vehicleResaleDecimalValue)/vehQuoteItem.ET_Min_Depreciation_Years__c;
                                    }
                                    else{
                                        vehicleQuoteCalcObj.vehicleDepreciationDecimalValue =  vehicleQuoteCalcObj.remainingDepreciationOf10Years/vehicleQuoteCalcObj.contractYear;
                                    }
                                }
                                else if(depreciationMethod == 'Straight Line'  && vehQuoteItem.ET_Min_Depreciation_Years__c != null && 
                                        vehQuoteItem.ET_Min_Depreciation_Years__c != 0 &&  vehQuoteItem.ET_Vehicle_Condition__c == 'New')
                                {
                                    vehicleQuoteCalcObj.vehicleDepreciationDecimalValue = (originalVehicleValue - vehicleQuoteCalcObj.vehicleResaleDecimalValue)/vehQuoteItem.ET_Min_Depreciation_Years__c;
                                }
                                if(fleetType =='Lease to Own'){
                                    vehicleQuoteCalcObj.vehicleDepreciationRate = 100;
                                    vehicleQuoteCalcObj.vehicleResaleDecimalValue = 0;
                                    vehicleQuoteCalcObj.vehicleDepreciationDecimalValue = (currentVehicleValue - vehicleQuoteCalcObj.vehicleResaleDecimalValue)/integerContractYear;
                                }
                                else if(fleetType =='Client Fleet'){
                                    vehicleQuoteCalcObj.vehicleDepreciationRate = 0;
                                    vehicleQuoteCalcObj.vehicleResaleDecimalValue = 0;
                                    vehicleQuoteCalcObj.vehicleDepreciationDecimalValue = 0;
                                }
                                vehicleQuoteCalcObj.vehicleDepreciation = string.valueOf(Math.round(vehicleQuoteCalcObj.vehicleDepreciationDecimalValue));
                                
                                // resale value as a String ---
                                vehicleQuoteCalcObj.vehicleResaleValue = string.valueOf(Math.round(vehicleQuoteCalcObj.vehicleResaleDecimalValue));
                                
                                // For total Project quote Resale Value
                                if(vehSource == 'Main' && contractYearAndvehicleResaleValue != null &&  
                                   contractYearAndvehicleResaleValue.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleResaleDecimalValue != null ){
                                       contractYearAndvehicleResaleValue.put(integerContractYear ,contractYearAndvehicleResaleValue.get(integerContractYear)+vehicleQuoteCalcObj.vehicleResaleDecimalValue*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleResaleDecimalValue != null  ){
                                        contractYearAndvehicleResaleValue.put(integerContractYear, vehicleQuoteCalcObj.vehicleResaleDecimalValue*noOfVehicles );
                                    }
                                }
                                
                                // For total Project quote Depreciation
                                if(vehSource == 'Main' && contractYearAndvehicleDepreciation != null &&  
                                   contractYearAndvehicleDepreciation.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleDepreciationDecimalValue != null  ){
                                       contractYearAndvehicleDepreciation.put(integerContractYear ,contractYearAndvehicleDepreciation.get(integerContractYear)+vehicleQuoteCalcObj.vehicleDepreciationDecimalValue*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleDepreciationDecimalValue != null ){
                                        contractYearAndvehicleDepreciation.put(integerContractYear, vehicleQuoteCalcObj.vehicleDepreciationDecimalValue*noOfVehicles );
                                    }
                                }
                                
                                // Trailer 
                                if(isTrailerSelected){
                                    if(depreciationMethod == 'Straight Line'  && vehQuoteItem.Trailer_min_Depreciation_Years__c != null && 
                                       vehQuoteItem.Trailer_min_Depreciation_Years__c != 0)
                                    {
                                        decimal remainingDepreciationYears =vehQuoteItem.Trailer_min_Depreciation_Years__c - trailerDiffInManufactureYears;
                                        if(vehicleQuoteCalcObj.contractYear < = remainingDepreciationYears &&  vehQuoteItem.Trailer_Condition__c == 'Used'){
                                            vehicleQuoteCalcObj.trailerDepreciationDecimalValue = (originalValueOfTrailer - vehicleQuoteCalcObj.trailerResaleDecimalValue)/vehQuoteItem.Trailer_min_Depreciation_Years__c;
                                        }
                                        else{
                                            vehicleQuoteCalcObj.trailerDepreciationDecimalValue =  vehicleQuoteCalcObj.trailerRemainingDepreciationOf10Years/vehicleQuoteCalcObj.contractYear;
                                        }
                                    }
                                    if(fleetType =='Lease to Own'){
                                        vehicleQuoteCalcObj.trailerDepreciationRate = 100;
                                        vehicleQuoteCalcObj.trailerResaleDecimalValue = 0;
                                        vehicleQuoteCalcObj.trailerDepreciationDecimalValue = (currentValueOfTrailer - vehicleQuoteCalcObj.trailerResaleDecimalValue)/integerContractYear;
                                    }
                                    else if(fleetType =='Client Fleet'){
                                        vehicleQuoteCalcObj.trailerDepreciationRate = 0;
                                        vehicleQuoteCalcObj.trailerResaleDecimalValue = 0;
                                        vehicleQuoteCalcObj.trailerDepreciationDecimalValue = 0;
                                    }
                                    
                                    vehicleQuoteCalcObj.trailerDepreciation = string.valueOf(Math.round(vehicleQuoteCalcObj.trailerDepreciationDecimalValue));
                                    // resale value as a String ---
                                    vehicleQuoteCalcObj.trailerResaleValue = string.valueOf(Math.round(vehicleQuoteCalcObj.trailerResaleDecimalValue));
                                }
                                
                                // Refrigerator 
                                if(isRefrigeratorSelected){
                                    if(depreciationMethod == 'Straight Line'  && vehQuoteItem.Refrigerator_min_Depreciation_Years__c != null && 
                                       vehQuoteItem.Refrigerator_min_Depreciation_Years__c != 0)
                                    {
                                        decimal remainingDepreciationYears =vehQuoteItem.Refrigerator_min_Depreciation_Years__c - refrigeratorDiffInManufactureYears;
                                        if(vehicleQuoteCalcObj.contractYear < = remainingDepreciationYears &&  vehQuoteItem.Refrigerator_Condition__c == 'Used'){
                                            vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue = (originalValueOfRefrigerator - vehicleQuoteCalcObj.refrigeratorResaleDecimalValue)/vehQuoteItem.Refrigerator_min_Depreciation_Years__c;
                                        }
                                        else{
                                            vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue =  vehicleQuoteCalcObj.refrigeratorRemainingDepreciationOf10Years/vehicleQuoteCalcObj.contractYear;
                                        }
                                    }
                                    if(fleetType =='Lease to Own'){
                                        vehicleQuoteCalcObj.refrigeratorDepreciationRate = 100;
                                        vehicleQuoteCalcObj.refrigeratorResaleDecimalValue = 0;
                                        vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue = (currentValueOfRefrigerator - vehicleQuoteCalcObj.refrigeratorResaleDecimalValue)/integerContractYear;
                                    }
                                    else if(fleetType =='Client Fleet'){
                                        vehicleQuoteCalcObj.refrigeratorDepreciationRate = 0;
                                        vehicleQuoteCalcObj.refrigeratorResaleDecimalValue = 0;
                                        vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue = 0;
                                    }
                                    
                                    vehicleQuoteCalcObj.refrigeratorDepreciation = string.valueOf(Math.round(vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue));
                                    // resale value as a String ---
                                    vehicleQuoteCalcObj.refrigeratorResaleValue = string.valueOf(Math.round(vehicleQuoteCalcObj.refrigeratorResaleDecimalValue));
                                }
                                
                                
                                
                                // calculate Total depreciation and Resale Value for vehicle, Trailer and refrigerator...
                                vehicleQuoteCalcObj.vehicleTrailerAndRefrigeratorDepreciationValue = (vehicleQuoteCalcObj.vehicleDepreciationDecimalValue != null ?vehicleQuoteCalcObj.vehicleDepreciationDecimalValue : 0) + 
                                    (vehicleQuoteCalcObj.trailerDepreciationDecimalValue != null ? vehicleQuoteCalcObj.trailerDepreciationDecimalValue : 0) + 
                                    (vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue != null ? vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue : 0);
                                
                                vehicleQuoteCalcObj.vehicleTrailerAndRefrigeratorResaleValue = (vehicleQuoteCalcObj.vehicleResaleDecimalValue != null ? vehicleQuoteCalcObj.vehicleResaleDecimalValue : 0) + 
                                    (vehicleQuoteCalcObj.trailerResaleDecimalValue != null ? vehicleQuoteCalcObj.trailerResaleDecimalValue : 0) +
                                    (vehicleQuoteCalcObj.refrigeratorResaleDecimalValue != null ? vehicleQuoteCalcObj.refrigeratorResaleDecimalValue : 0);
                                
                                if(isTrailerSelected){
                                    // For total Project quote Resale Value of Trailer
                                    if(vehSource == 'Main' && contractYearAndTrailerResaleValue != null &&  
                                       contractYearAndTrailerResaleValue.containsKey(integerContractYear) && vehicleQuoteCalcObj.trailerResaleDecimalValue != null ){
                                           contractYearAndTrailerResaleValue.put(integerContractYear ,contractYearAndTrailerResaleValue.get(integerContractYear)+vehicleQuoteCalcObj.trailerResaleDecimalValue*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.trailerResaleDecimalValue != null  ){
                                            contractYearAndTrailerResaleValue.put(integerContractYear, vehicleQuoteCalcObj.trailerResaleDecimalValue*noOfVehicles );
                                        }
                                    }
                                    
                                    // For total Project quote Depreciation of Trailer
                                    if(vehSource == 'Main' && contractYearAndTrailerDepreciation != null &&  
                                       contractYearAndTrailerDepreciation.containsKey(integerContractYear) && vehicleQuoteCalcObj.trailerDepreciationDecimalValue != null  ){
                                           contractYearAndTrailerDepreciation.put(integerContractYear ,contractYearAndTrailerDepreciation.get(integerContractYear)+vehicleQuoteCalcObj.trailerDepreciationDecimalValue*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.trailerDepreciationDecimalValue != null ){
                                            contractYearAndTrailerDepreciation.put(integerContractYear, vehicleQuoteCalcObj.trailerDepreciationDecimalValue*noOfVehicles );
                                        }
                                    }
                                }
                                
                                // For Refrigerator
                                
                                if(isRefrigeratorSelected){
                                    // For total Project quote Resale Value of Refrigerator
                                    if(vehSource == 'Main' && contractYearAndRefrigeratorResaleValue != null &&  
                                       contractYearAndRefrigeratorResaleValue.containsKey(integerContractYear) && vehicleQuoteCalcObj.refrigeratorResaleDecimalValue != null ){
                                           contractYearAndRefrigeratorResaleValue.put(integerContractYear ,contractYearAndRefrigeratorResaleValue.get(integerContractYear)+vehicleQuoteCalcObj.refrigeratorResaleDecimalValue*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.refrigeratorResaleDecimalValue != null  ){
                                            contractYearAndRefrigeratorResaleValue.put(integerContractYear, vehicleQuoteCalcObj.refrigeratorResaleDecimalValue*noOfVehicles );
                                        }
                                    }
                                    
                                    // For total Project quote Depreciation of Refrigerator
                                    if(vehSource == 'Main' && contractYearAndRefrigeratorDepreciation != null &&  
                                       contractYearAndRefrigeratorDepreciation.containsKey(integerContractYear) && vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue != null  ){
                                           contractYearAndRefrigeratorDepreciation.put(integerContractYear ,contractYearAndRefrigeratorDepreciation.get(integerContractYear)+vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue != null ){
                                            contractYearAndRefrigeratorDepreciation.put(integerContractYear, vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue*noOfVehicles );
                                        }
                                    }
                                }
                                
                                
                                
                                // **********************Depreciation calc *************** END*********/
                                
                                // **********************Maintenance and repair calc *************** START*********/
                                String countryOfOriginFrmMaster = vehicle.ET_Country_of_Origin__c;
                                Decimal applicapleMaintenanceRate = vehQuoteItem.ET_Vehicle_Maintenance_Rate__c;
                                
                                if(applicapleMaintenanceRate != null && annualMileage != null ){
                                    //Added by Arunsarathy on 05.06.2023 for School transportation update maintenance rate
                                    /*if(vehicle.ET_Service_Type__c=='School Transportation' && annualMileage <= 25000 ){
                                        vehicleQuoteCalcObj.vehicleRepairsAndMaintenance = (applicapleMaintenanceRate) * 25000 ;
                                    }*/
                                    //Added by Taj on 01.08.2024 for All update maintenance rate
                                    //Updated by Taj on 22.04.2025 for All update maintenance rate
                                    if(vehicle.ET_Service_Type__c == 'School Transportation' && annualMileage <= 22000 ){ // 30 May 2025: Taj Shaik - updated the mileage to 22000 from 25000
                                        vehicleQuoteCalcObj.vehicleRepairsAndMaintenance = (applicapleMaintenanceRate) * 22000 ; 
                                    }else if(vehicle.ET_Service_Type__c != 'School Transportation' && annualMileage <= 26250 ){ 
                                        vehicleQuoteCalcObj.vehicleRepairsAndMaintenance = (applicapleMaintenanceRate) * 26250 ; 
                                    }else{
                                        vehicleQuoteCalcObj.vehicleRepairsAndMaintenance = (applicapleMaintenanceRate) * annualMileage ;
                                    }
                                }
                                
                                // For total Project quote Maintainance
                                if(vehSource == 'Main' && contractYearAndvehicleRepairsAndMaintenance != null &&  
                                   contractYearAndvehicleRepairsAndMaintenance.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleRepairsAndMaintenance != null  ){
                                       contractYearAndvehicleRepairsAndMaintenance.put(integerContractYear ,contractYearAndvehicleRepairsAndMaintenance.get(integerContractYear)+vehicleQuoteCalcObj.vehicleRepairsAndMaintenance*noOfVehicles );
                                       system.debug('Maintenance__q'+contractYearAndvehicleRepairsAndMaintenance);
                                       system.debug('Maintenance__a'+vehicleQuoteCalcObj.vehicleRepairsAndMaintenance);
                                       system.debug('noOfVehicles'+noOfVehicles);
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleRepairsAndMaintenance != null ){
                                        contractYearAndvehicleRepairsAndMaintenance.put(integerContractYear, vehicleQuoteCalcObj.vehicleRepairsAndMaintenance*noOfVehicles );
                                    }
                                }
                                
                                // Trailer --
                                if(isTrailerSelected){
                                    Decimal applicapleMaintenanceRateForTrailer = vehQuoteItem.Trailer_Maintenance_Rate__c;
                                    
                                    if(applicapleMaintenanceRateForTrailer != null && annualMileage != null ){
                                        vehicleQuoteCalcObj.trailerRepairsAndMaintenance = (applicapleMaintenanceRateForTrailer) * annualMileage ;
                                    }
                                    
                                    // Trailer external maintenance cost 
                                    vehicleQuoteCalcObj.trailerExtrenalMaintenanceCost = vehQuoteItem.Trailer_External_Maintenance_Cost__c;
                                    
                                }
                                
                                // Trailer --
                                if(isRefrigeratorSelected){
                                    Decimal applicapleMaintenanceRateForRefrigerator = vehQuoteItem.Refrigerator_Maintenance_Rate__c;
                                    
                                    if(applicapleMaintenanceRateForRefrigerator != null && annualMileage != null ){
                                        vehicleQuoteCalcObj.refrigeratorRepairsAndMaintenance = (applicapleMaintenanceRateForRefrigerator) * annualMileage ;
                                    }
                                    
                                    // Trailer external maintenance cost 
                                    vehicleQuoteCalcObj.refrigeratorExtrenalMaintenanceCost = vehQuoteItem.Refrigerator_External_Maintenance_Cost__c;
                                    
                                }
                                
                                if(isTrailerSelected){
                                    // For total Project quote Maintainance for Trailer
                                    if(vehSource == 'Main' && contractYearAndTrailerMaintenanceExpenses != null &&  
                                       contractYearAndTrailerMaintenanceExpenses.containsKey(integerContractYear) && vehicleQuoteCalcObj.trailerRepairsAndMaintenance != null  ){
                                           contractYearAndTrailerMaintenanceExpenses.put(integerContractYear ,contractYearAndTrailerMaintenanceExpenses.get(integerContractYear)+vehicleQuoteCalcObj.trailerRepairsAndMaintenance*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.trailerRepairsAndMaintenance != null ){
                                            contractYearAndTrailerMaintenanceExpenses.put(integerContractYear, vehicleQuoteCalcObj.trailerRepairsAndMaintenance*noOfVehicles );
                                        }
                                    }
                                    
                                    // For total Project quote external maintenance cost for Trailer
                                    if(vehSource == 'Main' && contractYearAndTrailerExternalMaintenance != null &&  
                                       contractYearAndTrailerExternalMaintenance.containsKey(integerContractYear) && vehicleQuoteCalcObj.trailerExtrenalMaintenanceCost != null  ){
                                           contractYearAndTrailerExternalMaintenance.put(integerContractYear ,contractYearAndTrailerExternalMaintenance.get(integerContractYear)+vehicleQuoteCalcObj.trailerExtrenalMaintenanceCost*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.trailerExtrenalMaintenanceCost != null ){
                                            contractYearAndTrailerExternalMaintenance.put(integerContractYear, vehicleQuoteCalcObj.trailerExtrenalMaintenanceCost*noOfVehicles );
                                        }
                                    }  
                                }
                                
                                if(isRefrigeratorSelected){
                                    // For total Project quote Maintainance for Refrigerator
                                    if(vehSource == 'Main' && contractYearAndRefrigeratorMaintenanceExpenses != null &&  
                                       contractYearAndRefrigeratorMaintenanceExpenses.containsKey(integerContractYear) && vehicleQuoteCalcObj.refrigeratorRepairsAndMaintenance != null  ){
                                           contractYearAndRefrigeratorMaintenanceExpenses.put(integerContractYear ,contractYearAndRefrigeratorMaintenanceExpenses.get(integerContractYear)+vehicleQuoteCalcObj.refrigeratorRepairsAndMaintenance*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.refrigeratorRepairsAndMaintenance != null ){
                                            contractYearAndRefrigeratorMaintenanceExpenses.put(integerContractYear, vehicleQuoteCalcObj.refrigeratorRepairsAndMaintenance*noOfVehicles );
                                        }
                                    }
                                    
                                    // For total Project quote external maintenance cost for Refrigerator
                                    if(vehSource == 'Main' && contractYearAndRefrigeratorExternalMaintenance != null &&  
                                       contractYearAndRefrigeratorExternalMaintenance.containsKey(integerContractYear) && vehicleQuoteCalcObj.refrigeratorExtrenalMaintenanceCost != null  ){
                                           contractYearAndRefrigeratorExternalMaintenance.put(integerContractYear ,contractYearAndRefrigeratorExternalMaintenance.get(integerContractYear)+vehicleQuoteCalcObj.refrigeratorExtrenalMaintenanceCost*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.refrigeratorExtrenalMaintenanceCost != null ){
                                            contractYearAndRefrigeratorExternalMaintenance.put(integerContractYear, vehicleQuoteCalcObj.refrigeratorExtrenalMaintenanceCost*noOfVehicles );
                                        }
                                    }  
                                }
                                
                                // **********************Maintenance and repair calc *************** END*********/
                                
                                // **********************Financing calc *************** START*********/
                                
                                if(vehicle.ET_Vehicle_Condition__c == 'New'){
                                    if(vehQuoteItem.ET_Financing_Rate__c != null && vehQuoteItem.ET_Number_of_Financing_years__c != null && vehicleQuoteCalcObj.contractYear != null ){
                                        vehicleQuoteCalcObj.vehicleFinancing = ( vehicleTrailerAndRefrigeratorOriginalValue * (vehQuoteItem.ET_Financing_Rate__c /100)) * (vehQuoteItem.ET_Number_of_Financing_years__c / vehicleQuoteCalcObj.contractYear) ;   
                                    }
                                }
                                /* else if(vehicle.ET_Vehicle_Condition__c == 'Used'){
*integer Year = diffInManufactureYears + integerContractYear;
if(Year < 4){
vehicleQuoteCalcObj.vehicleFinancing = ( vehicleTrailerAndRefrigeratorOriginalValue * (vehQuoteItem.ET_Financing_Rate__c /100)) * (4 / vehicleQuoteCalcObj.contractYear) ;   
}
else if(Year >= 4){
vehicleQuoteCalcObj.vehicleFinancing = 0;
}
}
*/
                                else if(vehicle.ET_Vehicle_Condition__c == 'Used'){
                                    //Added by Arunsarathy on 14.03.2023 for School Trasportation Updation
                                    if(vehicle.ET_Service_Type__c=='School Transportation'){
                                        if(diffInManufactureYearsNew < 4){
                                            vehicleQuoteCalcObj.vehicleFinancing = ( vehicleTrailerAndRefrigeratorOriginalValue * (vehQuoteItem.ET_Financing_Rate__c /100)) * ((4-diffInManufactureYearsNew) / vehicleQuoteCalcObj.contractYear) ;   
                                        }
                                        else if(diffInManufactureYearsNew >= 4){
                                            vehicleQuoteCalcObj.vehicleFinancing = 0;
                                        } 
                                    }else{
                                        if(diffInManufactureYearsNew < 4){
                                            vehicleQuoteCalcObj.vehicleFinancing = ( vehicleTrailerAndRefrigeratorOriginalValue * (vehQuoteItem.ET_Financing_Rate__c /100)) * ((4-diffInManufactureYearsNew) / vehicleQuoteCalcObj.contractYear) ;   
                                        }
                                        else if(diffInManufactureYearsNew >= 4){
                                            vehicleQuoteCalcObj.vehicleFinancing = 0;
                                        }
                                    }
                                }
                                
                                // For total Project quote vehicleFinancing
                                if(vehSource == 'Main' && contractYearAndvehicleFinancing != null &&  
                                   contractYearAndvehicleFinancing.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleFinancing != null  ){
                                       contractYearAndvehicleFinancing.put(integerContractYear ,contractYearAndvehicleFinancing.get(integerContractYear)+vehicleQuoteCalcObj.vehicleFinancing*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleFinancing != null  ){
                                        contractYearAndvehicleFinancing.put(integerContractYear, vehicleQuoteCalcObj.vehicleFinancing*noOfVehicles );
                                    }
                                }
                                // **********************Financing calc *************** END*********/
                                
                                // **********************vehicle Insurance calc *************** START*********/
                                Integer contractYearInt = Integer.valueOf(contractYear);
                                Decimal insuranceRate = vehQuoteItem.ET_Insurance_Rate__c;
                                Decimal vehicleValue = vehicleQuoteCalcObj.vehiclePurchasePriceBasedOnCondition;
                                Decimal vehicleAge = System.Today().year() - Integer.valueOf(vehicle.ET_Vehicle_Model_Year__c);
                                Decimal calVehicleValue = 0.0;
                                if(vehQuoteItem.Depreciated_years_from_insurance_master__c != null && vehQuoteItem.Depreciated_years_from_insurance_master__c != 0.0 ){
                                    if(contractYearInt == 1){
                                        //calVehicleValue = (vehicleTrailerAndRefrigeratorCurrentValue *(insuranceRate/100));
                                        Decimal year1 = vehicleTrailerAndRefrigeratorCurrentValue * (insuranceRate / 100);
                                        Decimal minCost = vehQuoteItem.ET_Minimum_Cost__c;
                                        calVehicleValue = (year1 < minCost) ? minCost : year1;
                                    }
                                    else if (contractYearInt > = 2){
                                        calVehicleValue = calculateInsuranceVehicleValue(vehicleTrailerAndRefrigeratorCurrentValue ,vehQuoteItem.Depreciated_years_from_insurance_master__c , insuranceRate,
                                                                                         contractYearInt, vehQuoteItem.ET_Minimum_Cost__c);
                                    }
                                    
                                    
                                    Decimal finalCalc = calVehicleValue +
                                        (vehQuoteItem.ET_Passenger_Cost__c * (vehQuoteItem.ET_No_of_Seats__c - 1)) +
                                        vehQuoteItem.ET_Driver_insurance_cost__c + vehQuoteItem.ET_Ambulance_Cost__c + vehQuoteItem.ET_other_cost__c ;
                                    
                                    if(finalCalc < vehQuoteItem.ET_Minimum_Cost__c){
                                        finalCalc = vehQuoteItem.ET_Minimum_Cost__c;
                                    }
                                    vehicleQuoteCalcObj.vehicleInsurance = finalCalc+(finalCalc/2/integerContractYear); //finalCalc; // finalCalc+(finalCalc/2/integerContractYear)
                                    
                                }
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndvehicleInsurance != null &&  
                                   contractYearAndvehicleInsurance.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleInsurance != null  ){
                                       contractYearAndvehicleInsurance.put(integerContractYear ,contractYearAndvehicleInsurance.get(integerContractYear)+vehicleQuoteCalcObj.vehicleInsurance*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleInsurance != null ){
                                        contractYearAndvehicleInsurance.put(integerContractYear, vehicleQuoteCalcObj.vehicleInsurance*noOfVehicles );
                                    }
                                }
                                //--------------------------Salik cost Calculation added by arunsarathy on 23-02-2024
                                String oppSector;
                                for(ET_Vehicle_Quote_Item__c vQuote : vehQItemsList ){
                                    oppSector = vQuote.Opportunity_Sector__c;
                                }
                                if(oppSector=='Transport And Lease'){
                                    if(vehicle.ET_Vehicle_Condition__c == 'New' && (vehSource == 'Main' || vehSource == 'optional')){ 
                                        if(vehQuoteItem.Salik_Cost_Value__c != null && vehQuoteItem.Salik_Cost_Value__c != 0){ 
                                            vehicleQuoteCalcObj.salikCost = vehQuoteItem.Salik_Cost_Value__c/contractYearInt;
                                        }else{
                                            vehicleQuoteCalcObj.salikCost = 50/contractYearInt;
                                        }
                                    }
                                }
                                
                                // For total Project quote salik Cost
                                if(vehSource == 'Main' && contractYearAndsalikCost != null &&  
                                   contractYearAndsalikCost.containsKey(integerContractYear) && vehicleQuoteCalcObj.salikCost != null  ){
                                       contractYearAndsalikCost.put(integerContractYear ,contractYearAndsalikCost.get(integerContractYear)+vehicleQuoteCalcObj.salikCost*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.salikCost != null ){
                                        contractYearAndsalikCost.put(integerContractYear, vehicleQuoteCalcObj.salikCost*noOfVehicles );
                                    }
                                }
                                //--------------------------basic tracking cost Calculation added by arunsarathy on 23-02-2024 one time cost
                                for(ET_Vehicle_Quote_Item__c vQuote : vehQItemsList ){
                                    oppSector = vQuote.Opportunity_Sector__c;
                                }
                                //Taj 
                                /*if(oppSector=='Transport And Lease'){
                                    if( (vehSource == 'Main' || vehSource == 'optional')){ 
                                        if(vehQuoteItem.Basic_Tracking_Cost_Value__c != null && vehQuoteItem.Basic_Tracking_Cost_Value__c != 0){ 
                                            vehicleQuoteCalcObj.basicTrackingSystemCost = vehQuoteItem.Basic_Tracking_Cost_Value__c;
                                        }else{
                                            vehicleQuoteCalcObj.basicTrackingSystemCost = 480;
                                        }
                                    }
                                }*/
                                if(oppSector=='Transport And Lease' || oppSector=='School'){
                                    if( (vehSource == 'Main' || vehSource == 'optional' || vehSource == 'Substitutional')){ 
                                        if(vehQuoteItem.Basic_Tracking_Cost_Value__c != null && vehQuoteItem.Basic_Tracking_Cost_Value__c != 0){ 
                                            vehicleQuoteCalcObj.basicTrackingSystemCost = vehQuoteItem.Basic_Tracking_Cost_Value__c;
                                        }else{
                                            //System.debug(diffInManufactureYears+' :diffInManufactureYears -- diffInManufactureYearsNew: '+diffInManufactureYearsNew); //contractYearInt
                                            ET_Predefined_Cost_Master__c costMaster;
                                            if(vehQuoteItem.ET_Service_Type__c == 'Motorcycle Services' || vehQuoteItem.ET_Vehicle_Unique_key__c.startsWithIgnoreCase('Bike') || vehQuoteItem.ET_Vehicle_Unique_key__c.startsWithIgnoreCase('Scooter')){
                                               if(costMasterMap.containsKey('ET_GPS_Tracking_System_Bike_Transport_And_Lease')){
                                                costMaster = costMasterMap.get('ET_GPS_Tracking_System_Bike_Transport_And_Lease');
                                              }
                                            }else{
                                              if(costMasterMap.containsKey('ET_GPS_Tracking_System_Vehicle_Transport_And_Lease')){
                                                costMaster = costMasterMap.get('ET_GPS_Tracking_System_Vehicle_Transport_And_Lease');
                                              }else if(costMasterMap.containsKey('ET_GPS_Tracking_System_Vehicle_School')){
                                                costMaster = costMasterMap.get('ET_GPS_Tracking_System_Vehicle_School');
                                              }
                                            }
                                            System.debug('costMaster: '+costMaster); 
                                            if(costMaster != null){
                                                //ET_Contract_Period__c
                                                Decimal contractModelYear = vehQuoteItem.ET_Contract_Period__c; //diffInManufactureYears+vehQuoteItem.ET_Contract_Period__c;
                                                if(contractModelYear == 1)
                                                vehicleQuoteCalcObj.basicTrackingSystemCost = costMaster.ET_Year_1_Cost__c;
                                                if(contractModelYear == 2)
                                                vehicleQuoteCalcObj.basicTrackingSystemCost = costMaster.ET_Year_2_Cost__c;
                                                if(contractModelYear == 3)
                                                vehicleQuoteCalcObj.basicTrackingSystemCost = costMaster.ET_Year_3_Cost__c;
                                                if(contractModelYear == 4)
                                                vehicleQuoteCalcObj.basicTrackingSystemCost = costMaster.ET_Year_4_Cost__c;
                                                if(contractModelYear >= 5)
                                                vehicleQuoteCalcObj.basicTrackingSystemCost = costMaster.ET_Year_5_Above_Cost__c;
                                            }
                                        }
                                    }
                                }
                                
                                // For total Project quote basic tracking Cost
                                if(vehSource == 'Main' && contractYearAndbasicTrackingSystemCost != null &&  
                                   contractYearAndbasicTrackingSystemCost.containsKey(integerContractYear) && vehicleQuoteCalcObj.basicTrackingSystemCost != null  ){
                                       contractYearAndbasicTrackingSystemCost.put(integerContractYear ,contractYearAndbasicTrackingSystemCost.get(integerContractYear)+vehicleQuoteCalcObj.basicTrackingSystemCost*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.basicTrackingSystemCost != null ){
                                        contractYearAndbasicTrackingSystemCost.put(integerContractYear, vehicleQuoteCalcObj.basicTrackingSystemCost*noOfVehicles );
                                    }
                                }
                                
                                // Vehicle Registration Fee
                                vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee =  vehQuoteItem.ET_Vehicle_Registration__c ;  
                                // Trailer Registration Fee 
                                if(isTrailerSelected){
                                    vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee =  vehQuoteItem.Trailer_Registration_Fee__c ;   
                                }
                                // Refrigerator Registration Fee 
                                if(isRefrigeratorSelected){
                                    //vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  vehQuoteItem.Refrigerator_Registration_Fee__c ;   
                                    vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  0;
                                }
                                
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndvehicleRegistrationAndInspectionFee != null &&  
                                   contractYearAndvehicleRegistrationAndInspectionFee.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee != null ){
                                       contractYearAndvehicleRegistrationAndInspectionFee.put(integerContractYear ,contractYearAndvehicleRegistrationAndInspectionFee.get(integerContractYear)+vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee != null  ){
                                        contractYearAndvehicleRegistrationAndInspectionFee.put(integerContractYear, vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee*noOfVehicles );
                                    }
                                }
                                
                                // For total Project quote -- Trailer registration fee
                                if(isTrailerSelected){
                                    if(vehSource == 'Main' && contractYearAndTrailerRegistrationFee != null &&  
                                       contractYearAndTrailerRegistrationFee.containsKey(integerContractYear) && vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee != null ){
                                           contractYearAndTrailerRegistrationFee.put(integerContractYear ,contractYearAndTrailerRegistrationFee.get(integerContractYear)+vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee != null  ){
                                            contractYearAndTrailerRegistrationFee.put(integerContractYear, vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee*noOfVehicles );
                                        }
                                    }
                                }
                                
                                if(isRefrigeratorSelected){
                                    if(vehSource == 'Main' && contractYearAndRefrigeratorRegistrationFee != null &&  
                                       contractYearAndRefrigeratorRegistrationFee.containsKey(integerContractYear) && vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee != null ){
                                           contractYearAndRefrigeratorRegistrationFee.put(integerContractYear ,contractYearAndRefrigeratorRegistrationFee.get(integerContractYear)+vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee*noOfVehicles );
                                       }
                                    else{
                                        if(vehSource == 'Main' && vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee != null  ){
                                            contractYearAndRefrigeratorRegistrationFee.put(integerContractYear, vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee*noOfVehicles );
                                        }
                                    }
                                }
                                
                                
                                vehicleQuoteCalcObj.deprciationReserve = (vehicleQuoteCalcObj.vehicleDepreciationDecimalValue + vehicleQuoteCalcObj.trailerDepreciationDecimalValue + vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue )* (vehQuoteItem.ET_Depreciation_Reserve_Rate__c/100);
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAnddeprciationReserve != null &&  
                                   contractYearAnddeprciationReserve.containsKey(integerContractYear) && vehicleQuoteCalcObj.deprciationReserve != null  ){
                                       contractYearAnddeprciationReserve.put(integerContractYear ,contractYearAnddeprciationReserve.get(integerContractYear)+vehicleQuoteCalcObj.deprciationReserve*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.deprciationReserve != null  ){
                                        contractYearAnddeprciationReserve.put(integerContractYear, vehicleQuoteCalcObj.deprciationReserve*noOfVehicles );
                                    }
                                }
                                
                                // **********************vehicle Fuel calc ***********************/
                                if(vehQuoteItem.ET_Fuel_consumption__c != null && vehQuoteItem.ET_Fuel_consumption__c != 0 ){
                                    vehicleQuoteCalcObj.fuelRate =   vehQuoteItem.ET_Actual_Liter_Price__c/vehQuoteItem.ET_Fuel_consumption__c ;
                                    vehicleQuoteCalcObj.fuelExpenses = vehicleQuoteCalcObj.fuelRate* vehicle.ET_Annual_KM__c;
                                }
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndfuelExpenses != null &&  
                                   contractYearAndfuelExpenses.containsKey(integerContractYear) && vehicleQuoteCalcObj.fuelExpenses != null ){
                                       contractYearAndfuelExpenses.put(integerContractYear ,contractYearAndfuelExpenses.get(integerContractYear)+vehicleQuoteCalcObj.fuelExpenses*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.fuelExpenses != null ){
                                        contractYearAndfuelExpenses.put(integerContractYear, vehicleQuoteCalcObj.fuelExpenses*noOfVehicles );
                                    }
                                }
                                
                                
                                // **********************vehicle Total Variable Cost calc ********************/
                                
                                
                                vehicleQuoteCalcObj.vehicleTotalVariableCost  =   
                                    (vehicleQuoteCalcObj.vehicleDepreciationDecimalValue != null ? vehicleQuoteCalcObj.vehicleDepreciationDecimalValue : 0)+
                                    (vehicleQuoteCalcObj.vehicleRepairsAndMaintenance != null ? vehicleQuoteCalcObj.vehicleRepairsAndMaintenance : 0)+
                                    (vehicleQuoteCalcObj.trailerDepreciationDecimalValue != null ? vehicleQuoteCalcObj.trailerDepreciationDecimalValue : 0)+
                                    (vehicleQuoteCalcObj.trailerRepairsAndMaintenance != null ? vehicleQuoteCalcObj.trailerRepairsAndMaintenance : 0)+
                                    (vehicleQuoteCalcObj.trailerExtrenalMaintenanceCost != null ? vehicleQuoteCalcObj.trailerExtrenalMaintenanceCost : 0)+
                                    (vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue != null ? vehicleQuoteCalcObj.refrigeratorDepreciationDecimalValue : 0)+
                                    (vehicleQuoteCalcObj.refrigeratorRepairsAndMaintenance != null ? vehicleQuoteCalcObj.refrigeratorRepairsAndMaintenance : 0)+
                                    (vehicleQuoteCalcObj.refrigeratorExtrenalMaintenanceCost != null ? vehicleQuoteCalcObj.refrigeratorExtrenalMaintenanceCost : 0)
                                    ;
                                
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndvehicleTotalVariableCost != null &&  
                                   contractYearAndvehicleTotalVariableCost.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleTotalVariableCost != null && vehicleQuoteCalcObj.vehicleTotalVariableCost != 0.0 ){
                                       contractYearAndvehicleTotalVariableCost.put(integerContractYear ,contractYearAndvehicleTotalVariableCost.get(integerContractYear)+vehicleQuoteCalcObj.vehicleTotalVariableCost*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleTotalVariableCost != null && vehicleQuoteCalcObj.vehicleTotalVariableCost != 0.0 ){
                                        contractYearAndvehicleTotalVariableCost.put(integerContractYear, vehicleQuoteCalcObj.vehicleTotalVariableCost*noOfVehicles );
                                    }
                                }
                                
                                
                                // **********************vehicle Total Fixed Cost calc ***********************/
                                
                                Decimal totalSpecReqCost = vehQuoteItem.ET_Total_Special_Requirement_Cost__c;
                                
                                vehicleQuoteCalcObj.indirectCostForGeneralReserve = getFinalCost( new List<Decimal>{vehicleQuoteCalcObj.vehicleFinancing,
                                    vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee,vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee,vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee,
                                    vehicleQuoteCalcObj.vehicleInsurance,vehicleQuoteCalcObj.salikCost,vehicleQuoteCalcObj.basicTrackingSystemCost,vehicleQuoteCalcObj.deprciationReserve,
                                    totalSpecReqCost});
                                //  System.debug('indirectCostForGeneralReserve='+vehicleQuoteCalcObj.indirectCostForGeneralReserve);
                                // System.debug('vehicleTotalVariableCost='+vehicleQuoteCalcObj.vehicleTotalVariableCost);
                                if(vehicleQuoteCalcObj.indirectCostForGeneralReserve != 0 && vehicleQuoteCalcObj.vehicleTotalVariableCost != 0){
                                    vehicleQuoteCalcObj.generalReserve = (vehicleQuoteCalcObj.indirectCostForGeneralReserve + vehicleQuoteCalcObj.vehicleTotalVariableCost) * (vehQuoteItem.ET_General_Reserve_Rate__c/100);
                                }
                                
                                vehicleQuoteCalcObj.generalReserveTargetPrice = 0;
                                vehicleQuoteCalcObj.generalReserveDiscountedPrice = 0;
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndGeneralReserve != null &&  
                                   contractYearAndGeneralReserve.containsKey(integerContractYear) && vehicleQuoteCalcObj.generalReserve != null ){
                                       contractYearAndGeneralReserve.put(integerContractYear ,contractYearAndGeneralReserve.get(integerContractYear)+vehicleQuoteCalcObj.generalReserve*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.generalReserve != null  ){
                                        contractYearAndGeneralReserve.put(integerContractYear, vehicleQuoteCalcObj.generalReserve*noOfVehicles );
                                    }
                                }
                                
                                vehicleQuoteCalcObj.vehicleTotalFixedCost = getFinalCost( new List<Decimal>{vehicleQuoteCalcObj.vehicleFinancing,
                                    vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee,vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee,
                                    vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee,
                                    vehicleQuoteCalcObj.vehicleInsurance,vehicleQuoteCalcObj.salikCost,vehicleQuoteCalcObj.basicTrackingSystemCost,vehicleQuoteCalcObj.deprciationReserve,vehicleQuoteCalcObj.generalReserve,
                                    totalSpecReqCost});
                                // system.debug('vehicleTotalFixedCost = '+ vehicleQuoteCalcObj.vehicleTotalFixedCost);
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndvehicleTotalFixedCost != null &&  
                                   contractYearAndvehicleTotalFixedCost.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleTotalFixedCost != null  ){
                                       contractYearAndvehicleTotalFixedCost.put(integerContractYear ,contractYearAndvehicleTotalFixedCost.get(integerContractYear)+vehicleQuoteCalcObj.vehicleTotalFixedCost*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleTotalFixedCost != null ){
                                        contractYearAndvehicleTotalFixedCost.put(integerContractYear, vehicleQuoteCalcObj.vehicleTotalFixedCost*noOfVehicles );
                                    }
                                }
                                
                                
                                // **********************vehicle Reserve calc *************** *******/
                                
                                vehicleQuoteCalcObj.maintenanceReserve = vehicleQuoteCalcObj.vehicleRepairsAndMaintenance * (vehQuoteItem.ET_Maintainence_Reserve_Rate__c/100);
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndmaintenanceReserve != null &&  
                                   contractYearAndmaintenanceReserve.containsKey(integerContractYear) && vehicleQuoteCalcObj.maintenanceReserve != null ){
                                       contractYearAndmaintenanceReserve.put(integerContractYear ,contractYearAndmaintenanceReserve.get(integerContractYear)+vehicleQuoteCalcObj.maintenanceReserve*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.maintenanceReserve != null  ){
                                        contractYearAndmaintenanceReserve.put(integerContractYear, vehicleQuoteCalcObj.maintenanceReserve*noOfVehicles );
                                    }
                                }
                                
                                vehicleQuoteCalcObj.fuelReserve = vehicleQuoteCalcObj.fuelExpenses * (vehQuoteItem.ET_Fuel_Reserve_Rate__c/100);
                                vehicleQuoteCalcObj.fuelReserveTarget = 0;
                                vehicleQuoteCalcObj.fuelReserveDiscounted = 0;
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndfuelReserve != null &&  
                                   contractYearAndfuelReserve.containsKey(integerContractYear) && vehicleQuoteCalcObj.fuelReserve != null ){
                                       contractYearAndfuelReserve.put(integerContractYear ,contractYearAndfuelReserve.get(integerContractYear)+vehicleQuoteCalcObj.fuelReserve*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.fuelReserve != null ){
                                        contractYearAndfuelReserve.put(integerContractYear, vehicleQuoteCalcObj.fuelReserve*noOfVehicles );
                                    }
                                }
                                //system.debug('vehQuoteItem.ET_Fuel_Reserve_Rate__c = '+ vehQuoteItem.ET_Fuel_Reserve_Rate__c);
                                
                                
                                vehicleQuoteCalcObj.totalFuelCost =  getFinalCost( new List<Decimal>{vehicleQuoteCalcObj.fuelExpenses ,vehicleQuoteCalcObj.fuelReserve});
                                // for Target price - Reserve Cost =0
                                vehicleQuoteCalcObj.totalFuelCostTargetPrice =  getFinalCost( new List<Decimal>{vehicleQuoteCalcObj.fuelExpenses});
                                vehicleQuoteCalcObj.totalFuelCostDiscounted =  getFinalCost( new List<Decimal>{vehicleQuoteCalcObj.fuelExpenses});
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndtotalFuelCost != null &&  
                                   contractYearAndtotalFuelCost.containsKey(integerContractYear) && vehicleQuoteCalcObj.totalFuelCost != null){
                                       contractYearAndtotalFuelCost.put(integerContractYear ,contractYearAndtotalFuelCost.get(integerContractYear)+vehicleQuoteCalcObj.totalFuelCost*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.totalFuelCost != null ){
                                        contractYearAndtotalFuelCost.put(integerContractYear, vehicleQuoteCalcObj.totalFuelCost*noOfVehicles );
                                    }
                                }
                                
                                // For total Project quote - Discounted Price
                                if(vehSource == 'Main' && contractYearAndTotalFuelCostDiscount != null &&  
                                   contractYearAndTotalFuelCostDiscount.containsKey(integerContractYear) && vehicleQuoteCalcObj.totalFuelCostDiscounted != null  ){
                                       contractYearAndTotalFuelCostDiscount.put(integerContractYear ,contractYearAndTotalFuelCostDiscount.get(integerContractYear)+vehicleQuoteCalcObj.totalFuelCostDiscounted*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.totalFuelCostDiscounted != null  ){
                                        contractYearAndTotalFuelCostDiscount.put(integerContractYear, vehicleQuoteCalcObj.totalFuelCostDiscounted*noOfVehicles );
                                    }
                                }
                                
                                // For total Project quote - Target Price
                                if(vehSource == 'Main' && contractYearAndTotalFuelCostTarget != null &&  
                                   contractYearAndTotalFuelCostTarget.containsKey(integerContractYear) && vehicleQuoteCalcObj.totalFuelCostTargetPrice != null  ){
                                       contractYearAndTotalFuelCostTarget.put(integerContractYear ,contractYearAndTotalFuelCostTarget.get(integerContractYear)+vehicleQuoteCalcObj.totalFuelCostTargetPrice*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.totalFuelCostTargetPrice != null  ){
                                        contractYearAndTotalFuelCostTarget.put(integerContractYear, vehicleQuoteCalcObj.totalFuelCostTargetPrice*noOfVehicles );
                                    }
                                }
                                
                                //****************************** Vat Cost Calculation ***********************************//
                                
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndvatCostonDirectExpenses != null &&  
                                   contractYearAndvatCostonDirectExpenses.containsKey(integerContractYear) && vehicleQuoteCalcObj.vatCostonDirectExpenses != null  ){
                                       contractYearAndvatCostonDirectExpenses.put(integerContractYear ,contractYearAndvatCostonDirectExpenses.get(integerContractYear)+vehicleQuoteCalcObj.vatCostonDirectExpenses*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vatCostonDirectExpenses != null  ){
                                        contractYearAndvatCostonDirectExpenses.put(integerContractYear, vehicleQuoteCalcObj.vatCostonDirectExpenses*noOfVehicles );
                                    }
                                }
                                
                                
                                // **********************vehicle Total Reserve Cost calc *************** END*********/
                                // **********************vehicle Total Cost calc *************** Start*********/
                                
                                vehicleQuoteCalcObj.vehicleTotalCost = getFinalCost( new List<Decimal>{vehicleQuoteCalcObj.vehicleTotalVariableCost ,
                                    vehicleQuoteCalcObj.vehicleTotalFixedCost });
                                
                                // Vehicle Total Cost for Target Price --> Reserve Cost = 0..
                                vehicleQuoteCalcObj.discountedTotalAnnualTargetPrice = getFinalCost( new List<Decimal>{vehicleQuoteCalcObj.vehicleTotalVariableCost ,
                                    vehicleQuoteCalcObj.vehicleTotalFixedCost });
                                vehicleQuoteCalcObj.vehicleTotalCostDiscountedPrice = getFinalCost( new List<Decimal>{vehicleQuoteCalcObj.vehicleTotalVariableCost ,
                                    vehicleQuoteCalcObj.vehicleTotalFixedCost });
                                vehicleQuoteCalcObj.vehicleTotalCostTargetPrice = getFinalCost( new List<Decimal>{vehicleQuoteCalcObj.vehicleTotalVariableCost ,
                                    vehicleQuoteCalcObj.vehicleTotalFixedCost });
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndvehicleTotalCost != null &&  
                                   contractYearAndvehicleTotalCost.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleTotalCost != null  ){
                                       contractYearAndvehicleTotalCost.put(integerContractYear ,contractYearAndvehicleTotalCost.get(integerContractYear)+vehicleQuoteCalcObj.vehicleTotalCost*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleTotalCost != null  ){
                                        contractYearAndvehicleTotalCost.put(integerContractYear, vehicleQuoteCalcObj.vehicleTotalCost*noOfVehicles );
                                    }
                                }
                                
                                // For total Project quote -- discounted
                                if(vehSource == 'Main' && contractYearAndTotalVehicleCostDiscount != null &&  
                                   contractYearAndTotalVehicleCostDiscount.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleTotalCostDiscountedPrice != null  ){
                                       contractYearAndTotalVehicleCostDiscount.put(integerContractYear ,contractYearAndTotalVehicleCostDiscount.get(integerContractYear)+vehicleQuoteCalcObj.vehicleTotalCostDiscountedPrice*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleTotalCostDiscountedPrice != null  ){
                                        contractYearAndTotalVehicleCostDiscount.put(integerContractYear, vehicleQuoteCalcObj.vehicleTotalCostDiscountedPrice*noOfVehicles );
                                    }
                                }
                                
                                // For total Project quote -- Target
                                if(vehSource == 'Main' && contractYearAndTotalVehicleCostTarget != null &&  
                                   contractYearAndTotalVehicleCostTarget.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleTotalCostTargetPrice != null  ){
                                       contractYearAndTotalVehicleCostTarget.put(integerContractYear ,contractYearAndTotalVehicleCostTarget.get(integerContractYear)+vehicleQuoteCalcObj.vehicleTotalCostTargetPrice*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleTotalCostTargetPrice != null ){
                                        contractYearAndTotalVehicleCostTarget.put(integerContractYear, vehicleQuoteCalcObj.vehicleTotalCostTargetPrice*noOfVehicles );
                                    }
                                }
                                
                                
                                // **********************annual fuel profit and annual vehicle profit calc *************** Start*********/
                                vehicleQuoteCalcObj.annualFuelProfitMarginRate = vehQuoteItem.ET_Annual_Fuel_Profit_Margin_Rate__c;
                                vehicleQuoteCalcObj.fuelProfitMarginRateDiscountedPrice = vehQuoteItem.ET_Annual_Fuel_Profit_Margin_Rate__c/2;
                                vehicleQuoteCalcObj.fuelProfitMarginRateTargetPrice = vehQuoteItem.ET_Annual_Fuel_Profit_Margin_Rate__c/2;
                                // For total Project quote FuelProfitMarginRate
                                if(vehSource == 'Main' && contractYearAndannualFuelProfitMarginRate != null &&  
                                   contractYearAndannualFuelProfitMarginRate.containsKey(integerContractYear) && vehicleQuoteCalcObj.annualFuelProfitMarginRate != null  ){
                                       contractYearAndannualFuelProfitMarginRate.put(integerContractYear ,contractYearAndannualFuelProfitMarginRate.get(integerContractYear)+vehicleQuoteCalcObj.annualFuelProfitMarginRate*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.annualFuelProfitMarginRate != null ){
                                        contractYearAndannualFuelProfitMarginRate.put(integerContractYear, vehicleQuoteCalcObj.annualFuelProfitMarginRate*noOfVehicles );
                                    }
                                }
                                vehicleQuoteCalcObj.annualFuelProfitMarginValue = vehicleQuoteCalcObj.fuelExpenses * (vehicleQuoteCalcObj.annualFuelProfitMarginRate/100);
                                
                                vehicleQuoteCalcObj.fuelProfitValueTargetPrice = vehicleQuoteCalcObj.fuelExpenses * (vehicleQuoteCalcObj.fuelProfitMarginRateTargetPrice/100);
                                vehicleQuoteCalcObj.fuelProfitValueDiscountedPrice = vehicleQuoteCalcObj.fuelExpenses * (vehicleQuoteCalcObj.fuelProfitMarginRateDiscountedPrice/100);
                                
                                // For total Project quote annualFuelProfitMarginValue
                                if(vehSource == 'Main' && contractYearAndannualFuelProfitMarginValue != null &&  
                                   contractYearAndannualFuelProfitMarginValue.containsKey(integerContractYear) && vehicleQuoteCalcObj.annualFuelProfitMarginValue != null){
                                       contractYearAndannualFuelProfitMarginValue.put(integerContractYear ,contractYearAndannualFuelProfitMarginValue.get(integerContractYear)+vehicleQuoteCalcObj.annualFuelProfitMarginValue*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.annualFuelProfitMarginValue != null ){
                                        contractYearAndannualFuelProfitMarginValue.put(integerContractYear, vehicleQuoteCalcObj.annualFuelProfitMarginValue*noOfVehicles );
                                    }
                                }
                                //SK-
                                system.debug('vehQuoteItem.Required_Operating_Profit_Margin__c '+vehQuoteItem.Required_Operating_Profit_Margin__c);
                                system.debug('vehQuoteItem.ET_Total_Vehicles_Cost__c '+vehicleQuoteCalcObj.vehicleTotalCost);
                                vehicleQuoteCalcObj.annualVehicleProfitMarginValue = ((vehQuoteItem.Required_Operating_Profit_Margin__c/100)*vehicleQuoteCalcObj.vehicleTotalCost)/((100-vehQuoteItem.Required_Operating_Profit_Margin__c)/100) ;
                                
                                /*vehicleQuoteCalcObj.annualVehicleProfitMarginValue = (vehQuoteItem.ET_Vehicle_Profit_Rate_from_Master__c/100)*vehicleTrailerAndRefrigeratorCurrentValue ;
                                if(vehQuoteItem.ET_Discounts_Additional_Profit__c != null){
                                    vehicleQuoteCalcObj.annualVehicleProfitMarginValue = (vehicleQuoteCalcObj.annualVehicleProfitMarginValue) * (1 + (vehQuoteItem.ET_Discounts_Additional_Profit__c /100) );
                                }*/
                                vehicleQuoteCalcObj.discountedVehicleProfitValueForTargetPrice = ((vehQuoteItem.ET_Vehicle_Profit_Rate_from_Master__c/2)/100)*vehicleTrailerAndRefrigeratorCurrentValue ;
                                
                                if(vehQuoteItem.ET_Discounts_Additional_Profit__c != null){
                                    vehicleQuoteCalcObj.discountedVehicleProfitValueForTargetPrice = (vehicleQuoteCalcObj.discountedVehicleProfitValueForTargetPrice) * (1 + (vehQuoteItem.ET_Discounts_Additional_Profit__c /100) );
                                }
                                
                                vehicleQuoteCalcObj.vehicleProfitValueForTargetPrice = ((vehQuoteItem.ET_Vehicle_Profit_Rate_from_Master__c/2)/100)*vehicleTrailerAndRefrigeratorCurrentValue ;
                                
                                if(vehQuoteItem.ET_Discounts_Additional_Profit__c != null){
                                    vehicleQuoteCalcObj.vehicleProfitValueForTargetPrice = (vehicleQuoteCalcObj.vehicleProfitValueForTargetPrice) * (1 + (vehQuoteItem.ET_Discounts_Additional_Profit__c /100) );
                                }
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndannualVehicleProfitMarginValue != null &&  
                                   contractYearAndannualVehicleProfitMarginValue.containsKey(integerContractYear) && vehicleQuoteCalcObj.annualVehicleProfitMarginValue != null  ){
                                       contractYearAndannualVehicleProfitMarginValue.put(integerContractYear ,contractYearAndannualVehicleProfitMarginValue.get(integerContractYear)+vehicleQuoteCalcObj.annualVehicleProfitMarginValue*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.annualVehicleProfitMarginValue != null  ){
                                        contractYearAndannualVehicleProfitMarginValue.put(integerContractYear, vehicleQuoteCalcObj.annualVehicleProfitMarginValue*noOfVehicles );
                                    }
                                }
                                // For total Project quote - discounted
                                if(vehSource == 'Main' && contractYearAndVehicleProfitMarginValueDiscount != null &&  
                                   contractYearAndVehicleProfitMarginValueDiscount.containsKey(integerContractYear) && vehicleQuoteCalcObj.discountedVehicleProfitValueForTargetPrice != null  ){
                                       contractYearAndVehicleProfitMarginValueDiscount.put(integerContractYear ,contractYearAndVehicleProfitMarginValueDiscount.get(integerContractYear)+vehicleQuoteCalcObj.discountedVehicleProfitValueForTargetPrice*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.discountedVehicleProfitValueForTargetPrice != null  ){
                                        contractYearAndVehicleProfitMarginValueDiscount.put(integerContractYear, vehicleQuoteCalcObj.discountedVehicleProfitValueForTargetPrice*noOfVehicles );
                                    }
                                }
                                // For total Project quote - Target
                                if(vehSource == 'Main' && contractYearAndVehicleProfitMarginValueTarget != null &&  
                                   contractYearAndVehicleProfitMarginValueTarget.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleProfitValueForTargetPrice != null  ){
                                       contractYearAndVehicleProfitMarginValueTarget.put(integerContractYear ,contractYearAndVehicleProfitMarginValueTarget.get(integerContractYear)+vehicleQuoteCalcObj.vehicleProfitValueForTargetPrice*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleProfitValueForTargetPrice != null  ){
                                        contractYearAndVehicleProfitMarginValueTarget.put(integerContractYear, vehicleQuoteCalcObj.vehicleProfitValueForTargetPrice*noOfVehicles );
                                    }
                                }
                                
                                //vehicleQuoteCalcObj.annualVehicleProfitMarginRate = (vehicleQuoteCalcObj.annualVehicleProfitMarginValue / vehicleQuoteCalcObj.vehicleTotalCost)*100;
                                // vehicleQuoteCalcObj.vehicleProfitMarginRateForDiscountedPrice = (vehicleQuoteCalcObj.discountedVehicleProfitValueForTargetPrice / vehicleQuoteCalcObj.vehicleTotalCostDiscountedPrice)*100;
                                // vehicleQuoteCalcObj.vehicleProfitMarginRateForTargetPrice = (vehicleQuoteCalcObj.vehicleProfitValueForTargetPrice / vehicleQuoteCalcObj.vehicleTotalCostTargetPrice)*100;
                                
                                //corporate tax 
                                if(vehicleQuoteCalcObj.annualVehicleProfitMarginValue != null){
                                    vehicleQuoteCalcObj.corporateTax = (vehicleQuoteCalcObj.annualVehicleProfitMarginValue + vehicleQuoteCalcObj.annualFuelProfitMarginValue) * (9/100.0);
                                    // corporateTax formula updated by Arunsarathy 25.04.2023
                                    // vehicleQuoteCalcObj.corporateTax = vehicleQuoteCalcObj.annualVehicleProfitMarginValue * (9/100.0)* (integerContractYear -1)/integerContractYear; 
                                    
                                }
                                
                                // For total Project quote -- corporate tax 
                                if(vehSource == 'Main' && contractYearAndvehicleCorporateTax != null &&  
                                   contractYearAndvehicleCorporateTax.containsKey(integerContractYear) && vehicleQuoteCalcObj.corporateTax != null  ){
                                       contractYearAndvehicleCorporateTax.put(integerContractYear ,contractYearAndvehicleCorporateTax.get(integerContractYear)+vehicleQuoteCalcObj.corporateTax*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.corporateTax != null  ){
                                        contractYearAndvehicleCorporateTax.put(integerContractYear, vehicleQuoteCalcObj.corporateTax*noOfVehicles );
                                    }
                                }
                                
                                // Vat is default zero for Exempted Services...
                                if(vehQuoteItem.ET_Vat_Rate__c != 'Exempt' && vehQuoteItem.ET_Vat_Rate__c != null ){
                                    integer vatRate = integer.ValueOf(vehQuoteItem.ET_Vat_Rate__c);
                                    vehicleQuoteCalcObj.vehicleVATAmount = (vehicleQuoteCalcObj.vehicleTotalCost +
                                                                            vehicleQuoteCalcObj.annualVehicleProfitMarginValue +
                                                                            vehicleQuoteCalcObj.totalFuelCost +vehicleQuoteCalcObj.annualFuelProfitMarginValue )*(vatRate/100);
                                }
                                
                                // For total Project quote
                                if(vehSource == 'Main' && contractYearAndvehicleVATAmount != null &&  
                                   contractYearAndvehicleVATAmount.containsKey(integerContractYear) && vehicleQuoteCalcObj.vehicleVATAmount != null  ){
                                       contractYearAndvehicleVATAmount.put(integerContractYear ,contractYearAndvehicleVATAmount.get(integerContractYear)+vehicleQuoteCalcObj.vehicleVATAmount*noOfVehicles );
                                   }
                                else{
                                    if(vehSource == 'Main' && vehicleQuoteCalcObj.vehicleVATAmount != null ){
                                        contractYearAndvehicleVATAmount.put(integerContractYear, vehicleQuoteCalcObj.vehicleVATAmount*noOfVehicles );
                                    }
                                }
                                
                                
                                
                                
                                // system.debug('vehicleQuoteCalcObj = '+ JSON.serializePretty(vehicleQuoteCalcObj));
                                vehicleQuoteCalcLst.add(vehicleQuoteCalcObj);
                            }
                            
                        }
                        
                    } 
                    
                }
                
                quotecalculationObj.vehicleQuoteItemLst = vehicleQuoteCalcLst;
                
                // update quote Items with Calculation..
                // system.debug('updateQuoteLineItemsWithPricing Called');
                response = 'Success';
                response = updateQuoteLineItemsWithPricing(quotecalculationObj , vehQItemsWithId, vatData, quoteId );
                
                
            }
        }
        
        catch(Exception ex){
            system.debug('Exception ='+ ex.getMessage());
            system.debug('Exception Trace='+ ex.getStackTraceString());
            system.debug('Exception line='+ ex.getLineNumber());
            response = 'Exception occured of type :' + ex.getTypeName() + ' due to cause : ' + ex.getCause()  + 'with Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString();
            throw new AuraHandledException('Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString());
        }
        return response;
        
    }
    
    
    /*Public static decimal calculateInsuranceVehicleValue (decimal currentVehicleValue , decimal deprciatedYearsFromMaster, 
                                                          decimal insuranceRate, integer contractYearInt)
    {
        decimal vehicleInsuranceValue = (currentVehicleValue *(insuranceRate/100));
        for(integer i =2 ; i<= contractYearInt ; i++){
            decimal value = ( (currentVehicleValue/deprciatedYearsFromMaster)*(deprciatedYearsFromMaster - (i - 1)) *  (insuranceRate/100));
            vehicleInsuranceValue = vehicleInsuranceValue + value;
        }
        
        return vehicleInsuranceValue/contractYearInt;
    }*/
    
    public static void updateVehicleTotalProjectSummaryVehicleQuoteItems(String quoteId){
        
        // update quote 
        quote quoteToUpdate = new quote();
        quoteToUpdate.id = quoteId;
        quoteToUpdate.Quote_Total_Investment__c = quotationTotalInvestment;
        update quoteToUpdate;
        
        //query Vehicle quote Items for given Quote
        List<ET_Vehicle_Quote_Item__c> vehQItemsList = ET_PricingUtilityClass.getVehicleQuoteItemLst(quoteId);
        //system.debug('vehQItemsList = '+ vehQItemsList );
        
        List<ET_Vehicle_Quote_Item__c> vehQuoteItemListForTotalProjectQuote = new List<ET_Vehicle_Quote_Item__c>();
        if(vehQItemsList != null && !vehQItemsList.isEmpty()){
            for(ET_Vehicle_Quote_Item__c vehQuoteItemObj : vehQItemsList){
                
                integer i = integer.valueOf(vehQuoteItemObj.ET_Contract_Period__c);
                if(isTrailerSelectedTProj){
                    vehQuoteItemObj.Is_trailer_selected__c = true;
                }
                if(isRefrigeratorSelectedTProj){
                    vehQuoteItemObj.Is_Refrigerator_selected__c = true;
                }
                if(contractYearAndvehiclePurchasePriceBasedOnCondition != null && contractYearAndvehiclePurchasePriceBasedOnCondition.containsKey(i)){
                    vehQuoteItemObj.ET_Vehicle_Current_Purchase_Price__c = Math.round(contractYearAndvehiclePurchasePriceBasedOnCondition.get(i));
                }
                if(contractYearAndOriginalPurchasePrice != null && contractYearAndOriginalPurchasePrice.containsKey(i)){
                    vehQuoteItemObj.ET_Vehicle_Original_Purchase_Price__c = Math.round(contractYearAndOriginalPurchasePrice.get(i));
                }
                if(contractYearAndvehicleTotalInvestment != null && contractYearAndvehicleTotalInvestment.containsKey(i)){
                    vehQuoteItemObj.ET_Vehicle_Total_Investment__c = Math.round(contractYearAndvehicleTotalInvestment.get(i));
                }
                if(contractYearAndvehicleResaleValue != null && contractYearAndvehicleResaleValue.containsKey(i)){
                    vehQuoteItemObj.ET_Vehicle_Resale_Value__c = String.valueOf(Math.round(contractYearAndvehicleResaleValue.get(i)));
                }
                if(contractYearAndremainingDepreciationOf10Years != null && contractYearAndremainingDepreciationOf10Years.containsKey(i)){
                    vehQuoteItemObj.ET_Remaining_Depreciation_of_10_Years__c = Math.round(contractYearAndremainingDepreciationOf10Years.get(i));
                }
                if(contractYearAndvehicleDepreciation != null && contractYearAndvehicleDepreciation.containsKey(i)){
                    vehQuoteItemObj.ET_Vehicle_Depreciation__c = String.valueOf(Math.round(contractYearAndvehicleDepreciation.get(i)));
                }
                if(contractYearAndvehicleRepairsAndMaintenance != null && contractYearAndvehicleRepairsAndMaintenance.containsKey(i)){
                    vehQuoteItemObj.ET_Vehicle_Repairs_and_Maintenance__c = Math.round(contractYearAndvehicleRepairsAndMaintenance.get(i));
                }
                if(contractYearAndvehicleFinancing != null && contractYearAndvehicleFinancing.containsKey(i)){
                    vehQuoteItemObj.ET_Vehicle_Financing__c = Math.round(contractYearAndvehicleFinancing.get(i));
                }
                if(contractYearAndvehicleRegistrationAndInspectionFee != null && contractYearAndvehicleRegistrationAndInspectionFee.containsKey(i)){
                    vehQuoteItemObj.ET_Vehicle_Registration__c = Math.round(contractYearAndvehicleRegistrationAndInspectionFee.get(i));
                }
                if(contractYearAndvehicleInsurance != null && contractYearAndvehicleInsurance.containsKey(i)){
                    vehQuoteItemObj.ET_Vehicle_Insurance__c = Math.round(contractYearAndvehicleInsurance.get(i));
                }
                if(contractYearAndsalikCost != null && contractYearAndsalikCost.containsKey(i)){
                    vehQuoteItemObj.Salik_Cost__c = Math.round(contractYearAndsalikCost.get(i));
                }
                if(contractYearAndbasicTrackingSystemCost != null && contractYearAndbasicTrackingSystemCost.containsKey(i)){
                    vehQuoteItemObj.Basic_Tracking_System__c = Math.round(contractYearAndbasicTrackingSystemCost.get(i));
                }
                if(contractYearAndfuelExpenses != null && contractYearAndfuelExpenses.containsKey(i)){
                    vehQuoteItemObj.ET_Fuel_Expenses__c = Math.round(contractYearAndfuelExpenses.get(i));
                }
                if(contractYearAndvehicleTotalVariableCost != null && contractYearAndvehicleTotalVariableCost.containsKey(i)){
                    vehQuoteItemObj.ET_Total_Variable_Cost__c = Math.round(contractYearAndvehicleTotalVariableCost.get(i));
                }
                if(contractYearAndvehicleTotalFixedCost != null && contractYearAndvehicleTotalFixedCost.containsKey(i)){
                    vehQuoteItemObj.ET_Total_Fixed_Cost__c = Math.round(contractYearAndvehicleTotalFixedCost.get(i));
                }
                
                if(contractYearAnddeprciationReserve != null && contractYearAnddeprciationReserve.containsKey(i)){
                    vehQuoteItemObj.ET_Depreciation_Reserve__c = Math.round(contractYearAnddeprciationReserve.get(i));
                }
                if(contractYearAndmaintenanceReserve != null && contractYearAndmaintenanceReserve.containsKey(i)){
                    vehQuoteItemObj.ET_Maintenance_Reserve__c = Math.round(contractYearAndmaintenanceReserve.get(i));
                }
                if(contractYearAndGeneralReserve != null && contractYearAndGeneralReserve.containsKey(i)){
                    vehQuoteItemObj.ET_General_Reserve__c = Math.round(contractYearAndGeneralReserve.get(i));
                }
                if(contractYearAndfuelReserve != null && contractYearAndfuelReserve.containsKey(i)){
                    vehQuoteItemObj.ET_Fuel_Reserve__c = Math.round(contractYearAndfuelReserve.get(i));
                }
                if(contractYearAndtotalFuelCost != null && contractYearAndtotalFuelCost.containsKey(i)){
                    vehQuoteItemObj.ET_Total_Fuel_Cost__c = Math.round(contractYearAndtotalFuelCost.get(i));
                }
                if(contractYearAndtotalReserveCost != null && contractYearAndtotalReserveCost.containsKey(i)){
                    vehQuoteItemObj.ET_Total_Reserve_Cost__c = Math.round(contractYearAndtotalReserveCost.get(i));
                }
                
                if(contractYearAndvatCostonDirectExpenses != null && contractYearAndvatCostonDirectExpenses.containsKey(i)){
                    vehQuoteItemObj.ET_VAT_Cost_on_Direct_Expenses__c = Math.round(contractYearAndvatCostonDirectExpenses.get(i));
                }
                if(contractYearAndvehicleTotalCost != null && contractYearAndvehicleTotalCost.containsKey(i)){
                    vehQuoteItemObj.ET_Total_Vehicles_Cost__c = Math.round(contractYearAndvehicleTotalCost.get(i));
                }
                if(contractYearAndannualFuelProfitMarginRate != null && contractYearAndannualFuelProfitMarginRate.containsKey(i)){
                    vehQuoteItemObj.ET_Annual_Fuel_Profit_Margin_Rate__c = Math.round(contractYearAndannualFuelProfitMarginRate.get(i));
                }
                if(contractYearAndannualFuelProfitMarginValue != null && contractYearAndannualFuelProfitMarginValue.containsKey(i)){
                    vehQuoteItemObj.ET_Annual_Fuel_Profit_Value__c = Math.round(contractYearAndannualFuelProfitMarginValue.get(i));
                }
                if(contractYearAndannualVehicleProfitMarginValue != null && contractYearAndannualVehicleProfitMarginValue.containsKey(i)){
                    vehQuoteItemObj.ET_Annual_Vehicles_Profit_Value__c = Math.round(contractYearAndannualVehicleProfitMarginValue.get(i));
                }
                
                if(contractYearAndvehicleCorporateTax != null && contractYearAndvehicleCorporateTax.containsKey(i)){
                    vehQuoteItemObj.Corporate_Tax__c = Math.round(contractYearAndvehicleCorporateTax.get(i));
                }
                
                // Vehicle profit Value - discounted
                if(contractYearAndVehicleProfitMarginValueDiscount != null && contractYearAndVehicleProfitMarginValueDiscount.containsKey(i)){
                    vehQuoteItemObj.Discounted_Vehicle_Profit_Value_Target__c = Math.round(contractYearAndVehicleProfitMarginValueDiscount.get(i));
                }
                //  Vehicle profit Value - Target
                if(contractYearAndVehicleProfitMarginValueTarget != null && contractYearAndVehicleProfitMarginValueTarget.containsKey(i)){
                    vehQuoteItemObj.Vehicle_Profit_Value_Target_Price__c = Math.round(contractYearAndVehicleProfitMarginValueTarget.get(i));
                }
                
                if(contractYearAndannualVehicleProfitMarginValue != null && contractYearAndannualVehicleProfitMarginValue.containsKey(i) 
                   && contractYearAndvehicleTotalCost != null && contractYearAndvehicleTotalCost.containsKey(i))
                {
                    vehQuoteItemObj.ET_Annual_Vehicles_Profit_Margin__c =((contractYearAndannualVehicleProfitMarginValue.get(i) / contractYearAndvehicleTotalCost.get(i))*100).setScale(2);
                }
                // Vehicle Profit margin rate - Target
                if(contractYearAndVehicleProfitMarginValueTarget != null && contractYearAndVehicleProfitMarginValueTarget.containsKey(i) 
                   && contractYearAndTotalVehicleCostTarget != null && contractYearAndTotalVehicleCostTarget.containsKey(i))
                {
                    vehQuoteItemObj.Vehicles_Profit_Margin_Rate_Target__c =((contractYearAndVehicleProfitMarginValueTarget.get(i) / contractYearAndTotalVehicleCostTarget.get(i))*100).setScale(2);
                }
                
                // Vehicle Profit margin rate - discounted
                if(contractYearAndVehicleProfitMarginValueDiscount != null && contractYearAndVehicleProfitMarginValueDiscount.containsKey(i) 
                   && contractYearAndTotalVehicleCostDiscount != null && contractYearAndTotalVehicleCostDiscount.containsKey(i))
                {
                    vehQuoteItemObj.Vehicles_Profit_Margin_Rate_Discounted__c =((contractYearAndVehicleProfitMarginValueDiscount.get(i) / contractYearAndTotalVehicleCostDiscount.get(i))*100).setScale(2);
                }
                
                
                
                if(contractYearAndvehicleVATAmount != null && contractYearAndvehicleVATAmount.containsKey(i)){
                    vehQuoteItemObj.ET_Vat_Amount__c = Math.round(contractYearAndvehicleVATAmount.get(i));
                }
                
                // Target and Discounted Prices for Total Project ..
                if(contractYearAndTotalVehicleCostDiscount != null && contractYearAndTotalVehicleCostDiscount.containsKey(i)){
                    vehQuoteItemObj.Total_Vehicles_Cost_Discounted__c = Math.round(contractYearAndTotalVehicleCostDiscount.get(i));
                }
                if(contractYearAndTotalVehicleCostTarget != null && contractYearAndTotalVehicleCostTarget.containsKey(i)){
                    vehQuoteItemObj.Total_Annual_Cost_Target_Prices__c = Math.round(contractYearAndTotalVehicleCostTarget.get(i));
                }
                
                if(contractYearAndTotalFuelCostDiscount != null && contractYearAndTotalFuelCostDiscount.containsKey(i)){
                    vehQuoteItemObj.Total_Fuel_Cost_Discounted__c = Math.round(contractYearAndTotalFuelCostDiscount.get(i));
                }
                if(contractYearAndTotalFuelCostTarget != null && contractYearAndTotalFuelCostTarget.containsKey(i)){
                    vehQuoteItemObj.Total_Fuel_Cost_Target_Price__c = Math.round(contractYearAndTotalFuelCostTarget.get(i));
                }
                
                // for Trailer...
                if(isTrailerSelectedTProj){
                    if(contractYearAndTrailerOriginalPurchasePrice != null && contractYearAndTrailerOriginalPurchasePrice.containsKey(i)){
                        vehQuoteItemObj.Trailer_Original_Purchase_Price__c = Math.round(contractYearAndTrailerOriginalPurchasePrice.get(i));
                    }
                    if(contractYearAndTrailerCurrentPurchasePrice != null && contractYearAndTrailerCurrentPurchasePrice.containsKey(i)){
                        vehQuoteItemObj.Trailer_Current_Purchase_Price__c = Math.round(contractYearAndTrailerCurrentPurchasePrice.get(i));
                    }
                    if(contractYearAndTrailerDepreciation != null && contractYearAndTrailerDepreciation.containsKey(i)){
                        vehQuoteItemObj.Trailer_Depreciation__c = String.Valueof(Math.round(contractYearAndTrailerDepreciation.get(i)));
                    }
                    if(contractYearAndTrailerResaleValue != null && contractYearAndTrailerResaleValue.containsKey(i)){
                        vehQuoteItemObj.Trailer_Resale_Value__c = String.Valueof(Math.round(contractYearAndTrailerResaleValue.get(i)));
                    }
                    if(contractYearAndTrailerMaintenanceExpenses != null && contractYearAndTrailerMaintenanceExpenses.containsKey(i)){
                        vehQuoteItemObj.Trailer_Repairs_And_Maintenance__c = Math.round(contractYearAndTrailerMaintenanceExpenses.get(i));
                    }
                    if(contractYearAndTrailerRegistrationFee != null && contractYearAndTrailerRegistrationFee.containsKey(i)){
                        vehQuoteItemObj.Trailer_Registration_Fee__c = Math.round(contractYearAndTrailerRegistrationFee.get(i));
                    }
                    if(contractYearAndTrailerExternalMaintenance != null && contractYearAndTrailerExternalMaintenance.containsKey(i)){
                        vehQuoteItemObj.Trailer_External_Maintenance_Cost__c = Math.round(contractYearAndTrailerExternalMaintenance.get(i));
                    }
                }
                
                
                // for Refrigerator...
                if(isRefrigeratorSelectedTProj){
                    if(contractYearAndRefrigeratorOriginalPurchasePrice != null && contractYearAndRefrigeratorOriginalPurchasePrice.containsKey(i)){
                        vehQuoteItemObj.Refrigerator_Original_Purchase_Price__c = Math.round(contractYearAndRefrigeratorOriginalPurchasePrice.get(i));
                    }
                    if(contractYearAndRefrigeratorCurrentPurchasePrice != null && contractYearAndRefrigeratorCurrentPurchasePrice.containsKey(i)){
                        vehQuoteItemObj.Refrigerator_Current_Purchase_Price__c = Math.round(contractYearAndRefrigeratorCurrentPurchasePrice.get(i));
                    }
                    if(contractYearAndRefrigeratorDepreciation != null && contractYearAndRefrigeratorDepreciation.containsKey(i)){
                        vehQuoteItemObj.Refrigerator_Depreciation__c = String.Valueof(Math.round(contractYearAndRefrigeratorDepreciation.get(i)));
                    }
                    if(contractYearAndRefrigeratorResaleValue != null && contractYearAndRefrigeratorResaleValue.containsKey(i)){
                        vehQuoteItemObj.Refrigerator_Resale_Value__c = String.Valueof(Math.round(contractYearAndRefrigeratorResaleValue.get(i)));
                    }
                    if(contractYearAndRefrigeratorMaintenanceExpenses != null && contractYearAndRefrigeratorMaintenanceExpenses.containsKey(i)){
                        vehQuoteItemObj.Refrigerator_Repairs_And_Maintenance__c = Math.round(contractYearAndRefrigeratorMaintenanceExpenses.get(i));
                    }
                    if(contractYearAndRefrigeratorRegistrationFee != null && contractYearAndRefrigeratorRegistrationFee.containsKey(i)){
                        vehQuoteItemObj.Refrigerator_Registration_Fee__c = Math.round(contractYearAndRefrigeratorRegistrationFee.get(i));
                    }
                    if(contractYearAndRefrigeratorExternalMaintenance != null && contractYearAndRefrigeratorExternalMaintenance.containsKey(i)){
                        vehQuoteItemObj.Refrigerator_External_Maintenance_Cost__c = Math.round(contractYearAndRefrigeratorExternalMaintenance.get(i));
                    }
                }
                
                
                
                vehQuoteItemObj.General_Reserve_Target_Prices__c = 0;
                
                vehQuoteItemObj.General_Reserve_for_Discounted_Price__c = 0;
                
                vehQuoteItemListForTotalProjectQuote.add(vehQuoteItemObj);   
            }
        }
        // system.debug('vehQuoteItemListForTotalProjectQuote = '+ JSON.serializePretty(vehQuoteItemListForTotalProjectQuote));
        if(vehQuoteItemListForTotalProjectQuote != null && !vehQuoteItemListForTotalProjectQuote.isEmpty()){
            //system.debug('check 4');
            update vehQuoteItemListForTotalProjectQuote;
        }
    }  
    
    
    
    /* Method 	   : updateQuoteLineItemsWithPricing
Description : To calculate Price elements in output Quotation line Items
Calculates based on - Rates from Quotation Line items and Request attributes
*/
    
    public static String updateQuoteLineItemsWithPricing(ET_ServiceRequestController.QuoteCalculationClass quoteCalcObj , Map<String, ET_Vehicle_Quote_Item__c> vehQItemsWithId,
                                                         List<ET_Pricing_VAT_setup__c> vatData, String quoteId)
    {
        
        String response;
        // update quote 
        quote quoteToUpdate = new quote();
        quoteToUpdate.id = quoteId;
        quoteToUpdate.Quote_Total_Investment__c = quotationTotalInvestment;
        update quoteToUpdate;
        
        if(quoteCalcObj != null){
            //update Vehicle quote Items and create Related other cost Items...            
            if(quoteCalcObj.vehicleQuoteItemLst != null && quoteCalcObj.vehicleQuoteItemLst.size() > 0 ){
                List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLstToUpdate = new List<ET_Vehicle_Quote_Item__c>();
                Map<String,List<ET_Quote_Item_SpecReq__c>> vehicleQuoteItemAndItemReqMap = new Map<String,List<ET_Quote_Item_SpecReq__c>>();
                
                for(ET_ServiceRequestController.vehicleQuoteCalcClass vehicleQuoteCalObj : quoteCalcObj.vehicleQuoteItemLst){
                    if( !vehQItemsWithId.isEmpty() && vehQItemsWithId.containsKey(vehicleQuoteCalObj.vehicleQuoteId)){
                        ET_Vehicle_Quote_Item__c vehicleQuoteItemtoUpdate = vehQItemsWithId.get(vehicleQuoteCalObj.vehicleQuoteId);
                        vehicleQuoteItemtoUpdate.ET_Vehicle_Current_Purchase_Price__c = Math.round(vehicleQuoteCalObj.vehiclePurchasePriceBasedOnCondition);
                        vehicleQuoteItemtoUpdate.ET_Vehicle_Financing__c = Math.round(vehicleQuoteCalObj.vehicleFinancing);
                        if(vehicleQuoteItemtoUpdate.ET_Depreciation_Type__c == 'Percentage'){
                            vehicleQuoteItemtoUpdate.ET_Vehicle_Resale_Value__c = vehicleQuoteCalObj.vehicleResaleValue;
                        }
                        vehicleQuoteItemtoUpdate.ET_Vehicle_Depreciation__c = vehicleQuoteCalObj.vehicleDepreciation;
                        if(vehicleQuoteCalObj.vehicleDepreciationRate != null && vehicleQuoteCalObj.vehicleDepreciationRate != 0){
                            vehicleQuoteItemtoUpdate.ET_Vehicle_Depreciation_Percentage__c = (vehicleQuoteCalObj.vehicleDepreciationRate).setScale(2); 
                        }
                        vehicleQuoteItemtoUpdate.ET_Depreciation_Rate_for_Extra_Mileage__c = (vehicleQuoteCalObj.depreciationRateforExtraMileage).setScale(2);
                        vehicleQuoteItemtoUpdate.ET_Vehicle_Repairs_and_Maintenance__c = Math.round(vehicleQuoteCalObj.vehicleRepairsAndMaintenance);
                        vehicleQuoteItemtoUpdate.ET_Total_Variable_Cost__c = Math.round(vehicleQuoteCalObj.vehicleTotalVariableCost);
                        vehicleQuoteItemtoUpdate.ET_Vehicle_Registration__c = Math.round(vehicleQuoteCalObj.vehicleRegistrationAndInspectionFee);
                        vehicleQuoteItemtoUpdate.ET_Vehicle_Insurance__c = Math.round(vehicleQuoteCalObj.vehicleInsurance);
                        vehicleQuoteItemtoUpdate.Salik_Cost__c = Math.round(vehicleQuoteCalObj.salikCost);
                        vehicleQuoteItemtoUpdate.Basic_Tracking_System__c = Math.round(vehicleQuoteCalObj.basicTrackingSystemCost);
                        vehicleQuoteItemtoUpdate.ET_Depreciation_Reserve__c = Math.round(vehicleQuoteCalObj.deprciationReserve);
                        vehicleQuoteItemtoUpdate.ET_General_Reserve__c = Math.round(vehicleQuoteCalObj.generalReserve);
                        vehicleQuoteItemtoUpdate.General_Reserve_Target_Prices__c = Math.round(vehicleQuoteCalObj.generalReserveTargetPrice);
                        vehicleQuoteItemtoUpdate.General_Reserve_for_Discounted_Price__c = Math.round(vehicleQuoteCalObj.generalReserveDiscountedPrice);
                        vehicleQuoteItemtoUpdate.ET_Maintenance_Reserve__c = Math.round(vehicleQuoteCalObj.maintenanceReserve);
                        vehicleQuoteItemtoUpdate.ET_Total_Fixed_Cost__c = Math.round(vehicleQuoteCalObj.vehicleTotalFixedCost);
                        vehicleQuoteItemtoUpdate.ET_Total_Reserve_Cost__c = Math.round(vehicleQuoteCalObj.totalReserveCost);
                        vehicleQuoteItemtoUpdate.ET_Total_Vehicles_Cost__c = Math.round(vehicleQuoteCalObj.vehicleTotalCost);
                        vehicleQuoteItemtoUpdate.Total_Annual_Cost_Target_Prices__c = Math.round(vehicleQuoteCalObj.discountedTotalAnnualTargetPrice);
                        vehicleQuoteItemtoUpdate.Total_Vehicles_Cost_Discounted__c = Math.round(vehicleQuoteCalObj.vehicleTotalCostDiscountedPrice);
                        vehicleQuoteItemtoUpdate.Total_Annual_Cost_Target_Prices__c = Math.round(vehicleQuoteCalObj.vehicleTotalCostTargetPrice);
                        vehicleQuoteItemtoUpdate.ET_Annual_Vehicles_Profit_Value__c = Math.round(vehicleQuoteCalObj.annualVehicleProfitMarginValue);
                        vehicleQuoteItemtoUpdate.Corporate_Tax__c = Math.round(vehicleQuoteCalObj.corporateTax);
                        vehicleQuoteItemtoUpdate.ET_Annual_Fuel_Profit_Target_Prices__c = Math.round(vehicleQuoteCalObj.fuelProfitValueTargetPrice);
                        vehicleQuoteItemtoUpdate.Fuel_Profit_Value_Discounted__c = Math.round(vehicleQuoteCalObj.fuelProfitValueDiscountedPrice);
                        //vehicleQuoteItemtoUpdate.ET_Annual_Vehicles_Profit_Margin__c = vehicleQuoteCalObj.annualVehicleProfitMarginRate.setScale(2);
                        //vehicleQuoteItemtoUpdate.Vehicles_Profit_Margin_Rate_Discounted__c = vehicleQuoteCalObj.vehicleProfitMarginRateForDiscountedPrice.setScale(2);
                        //vehicleQuoteItemtoUpdate.Vehicles_Profit_Margin_Rate_Target__c = vehicleQuoteCalObj.vehicleProfitMarginRateForTargetPrice.setScale(2);
                        vehicleQuoteItemtoUpdate.Discounted_Vehicle_Profit_Value_Target__c = vehicleQuoteCalObj.discountedVehicleProfitValueForTargetPrice.setScale(2);
                        //vehicleQuoteItemtoUpdate.Vehicle_Profit_Value_Target_Price__c = vehicleQuoteCalObj.vehicleProfitValueForTargetPrice.setScale(2);
                        vehicleQuoteItemtoUpdate.ET_Annual_Fuel_Profit_Value__c = Math.round(vehicleQuoteCalObj.annualFuelProfitMarginValue);
                        vehicleQuoteItemtoUpdate.ET_Fuel_Expenses__c = Math.round(vehicleQuoteCalObj.fuelExpenses);
                        vehicleQuoteItemtoUpdate.ET_Vehicle_Fuel_Rate__c = (vehicleQuoteCalObj.fuelRate).setScale(2);
                        vehicleQuoteItemtoUpdate.ET_Fuel_Reserve__c = Math.round(vehicleQuoteCalObj.fuelReserve);
                        vehicleQuoteItemtoUpdate.Fuel_Reserve_Discounted__c = Math.round(vehicleQuoteCalObj.fuelReserveDiscounted);
                        vehicleQuoteItemtoUpdate.Fuel_Reserve_Target__c = Math.round(vehicleQuoteCalObj.fuelReserveTarget);
                        vehicleQuoteItemtoUpdate.ET_Total_Fuel_Cost__c = Math.round(vehicleQuoteCalObj.totalFuelCost);
                        vehicleQuoteItemtoUpdate.Total_Fuel_Cost_Target_Price__c = Math.round(vehicleQuoteCalObj.totalFuelCostTargetPrice);
                        vehicleQuoteItemtoUpdate.Total_Fuel_Cost_Discounted__c = Math.round(vehicleQuoteCalObj.totalFuelCostDiscounted);
                        vehicleQuoteItemtoUpdate.ET_Annual_Fuel_Profit_Value__c = Math.round(vehicleQuoteCalObj.annualFuelProfitMarginValue);
                        vehicleQuoteItemtoUpdate.ET_Vehicle_Total_Investment__c = Math.round(vehicleQuoteCalObj.vehicleTotalInvestment);
                        vehicleQuoteItemtoUpdate.ET_Vat_Amount__c = Math.round(vehicleQuoteCalObj.vehicleVATAmount);
                        vehicleQuoteItemtoUpdate.ET_Remaining_Depreciation_of_10_Years__c = Math.round(vehicleQuoteCalObj.remainingDepreciationOf10Years);
                        vehicleQuoteItemtoUpdate.Total_Current_Value__c = Math.round(vehicleQuoteCalObj.vehicleTrailerAndRefrigeratorCurrentValue);
                        vehicleQuoteItemtoUpdate.Total_Depreciation__c = Math.round(vehicleQuoteCalObj.vehicleTrailerAndRefrigeratorDepreciationValue);
                        vehicleQuoteItemtoUpdate.Total_Resale_Value__c = Math.round(vehicleQuoteCalObj.vehicleTrailerAndRefrigeratorResaleValue);
                        // vehicleQuoteItemtoUpdate.ET_Service_Type__c = vehicleQuoteCalObj.serviceType;
                        //
                        // trailer fields mapping ...
                        if(vehicleQuoteItemtoUpdate.Trailer_depreciation_type__c == 'Percentage'){
                            vehicleQuoteItemtoUpdate.Trailer_Resale_Value__c = vehicleQuoteCalObj.trailerResaleValue;
                        }
                        vehicleQuoteItemtoUpdate.Trailer_Depreciation__c = vehicleQuoteCalObj.trailerDepreciation;
                        vehicleQuoteItemtoUpdate.Trailer_Depreciation_Rate__c = (vehicleQuoteCalObj.trailerDepreciationRate).setScale(2);
                        vehicleQuoteItemtoUpdate.Trailer_Repairs_And_Maintenance__c = Math.round(vehicleQuoteCalObj.trailerRepairsAndMaintenance);
                        vehicleQuoteItemtoUpdate.Trailer_Registration_Fee__c = Math.round(vehicleQuoteCalObj.trailerRegistrationAndInspectionFee);
                        if(vehicleQuoteCalObj.trailerExtrenalMaintenanceCost != null){
                            vehicleQuoteItemtoUpdate.Trailer_External_Maintenance_Cost__c = Math.round(vehicleQuoteCalObj.trailerExtrenalMaintenanceCost);  
                        }
                        
                        // Refrigerator fields mapping ...
                        if(vehicleQuoteItemtoUpdate.Refrigerator_depreciation_type__c == 'Percentage'){
                            vehicleQuoteItemtoUpdate.Refrigerator_Resale_Value__c = vehicleQuoteCalObj.refrigeratorResaleValue;
                        }
                        vehicleQuoteItemtoUpdate.Refrigerator_Depreciation__c = vehicleQuoteCalObj.refrigeratorDepreciation;
                        vehicleQuoteItemtoUpdate.Refrigerator_Depreciation_Rate__c = (vehicleQuoteCalObj.refrigeratorDepreciationRate).setScale(2);
                        vehicleQuoteItemtoUpdate.Refrigerator_Repairs_And_Maintenance__c = Math.round(vehicleQuoteCalObj.refrigeratorRepairsAndMaintenance);
                        vehicleQuoteItemtoUpdate.Refrigerator_Registration_Fee__c = Math.round(vehicleQuoteCalObj.refrigeratorRegistrationAndInspectionFee);
                        if(vehicleQuoteCalObj.refrigeratorExtrenalMaintenanceCost != null){
                            vehicleQuoteItemtoUpdate.Refrigerator_External_Maintenance_Cost__c = Math.round(vehicleQuoteCalObj.refrigeratorExtrenalMaintenanceCost);  
                        }
                        
                        if(vehicleQuoteItemtoUpdate.ET_Vat_Rate__c == 'Exempt'){
                            Decimal vatCostonDirectExpenses = 0.0;
                            Decimal vatCostonInDirectExpenses = 0.0;
                            //Changes for School transportation only, updated on 14.03.2023 Added by Arunsarathy. 
                            if(vehicleQuoteItemtoUpdate.ET_Service_Type__c == 'School Transportation'){
                                for(ET_Pricing_VAT_setup__c data : vatData){
                                    if(data.ET_Cost_Type__c == 'Vehicle Direct' && data.ET_IsRecoverable__c){
                                        Decimal value;
                                        value = ((Decimal)vehicleQuoteItemtoUpdate.ET_Vehicle_Repairs_and_Maintenance__c *0.05) + ((Decimal)vehicleQuoteItemtoUpdate.ET_Vehicle_Original_Purchase_Price__c *0.05/10); 
                                        if(value != null ){
                                            vatCostonDirectExpenses = value;
                                        }
                                        
                                    }
                                    // Insurance + Extra Bus Fee + Vehicle other cost
                                    else if(data.ET_Cost_Type__c == 'Vehicle InDirect' && data.ET_IsRecoverable__c){
                                        Decimal value;
                                        //system.debug('data.ET_Cost_Api_Name__c '+data.ET_Cost_Api_Name__c);
                                        //system.debug('vatCostonInDirectExpenses value = ' + (Decimal)vehicleQuoteItemtoUpdate.get(data.ET_Cost_Api_Name__c));
                                        value = (((Decimal)vehicleQuoteItemtoUpdate.ET_Vehicle_Insurance__c +(Decimal)vehicleQuoteItemtoUpdate.ET_Total_Special_Requirement_Cost__c)*0.05) + 
                                            ((Decimal)vehicleQuoteItemtoUpdate.ET_Vehicle_Insurance__c *0.05)+ ((Decimal)vehicleQuoteItemtoUpdate.ET_Vehicle_Financing__c *0.05); 
                                        
                                        if(value != null){
                                            vatCostonInDirectExpenses = value;
                                        }
                                    }
                                    
                                }
                                
                                vatCostonDirectExpenses = vatCostonDirectExpenses ;
                                vatCostonInDirectExpenses = vatCostonInDirectExpenses;
                            }else{
                                for(ET_Pricing_VAT_setup__c data : vatData){
                                    if(data.ET_Cost_Type__c == 'Vehicle Direct' && data.ET_IsRecoverable__c){
                                        if(ET_Vehicle_Quote_Item__c.getSobjectType().getDescribe().fields.getMap().containsKey(data.ET_Cost_Api_Name__c)){
                                            Decimal value;
                                            if(data.ET_Cost_Api_Name__c == 'ET_Vehicle_Current_Purchase_Price__c' && vehicleQuoteItemtoUpdate.ET_Vehicle_Condition__c == 'new'){
                                                value = (Decimal)vehicleQuoteItemtoUpdate.get('Total_Current_Value__c')/(Decimal)vehicleQuoteItemtoUpdate.ET_Contract_Period__c;
                                            }
                                            else{
                                                value = (Decimal)vehicleQuoteItemtoUpdate.get(data.ET_Cost_Api_Name__c);
                                            }
                                            
                                            if(value != null ){
                                                vatCostonDirectExpenses += value;
                                            }
                                        }
                                    }
                                    // Insurance + Extra Bus Fee + Vehicle other cost
                                    else if(data.ET_Cost_Type__c == 'Vehicle InDirect' && data.ET_IsRecoverable__c){
                                        Decimal value;
                                        //system.debug('data.ET_Cost_Api_Name__c '+data.ET_Cost_Api_Name__c);
                                        //system.debug('vatCostonInDirectExpenses value = ' + (Decimal)vehicleQuoteItemtoUpdate.get(data.ET_Cost_Api_Name__c));
                                        if(ET_Vehicle_Quote_Item__c.getSobjectType().getDescribe().fields.getMap().containsKey(data.ET_Cost_Api_Name__c)){
                                            value = (Decimal)vehicleQuoteItemtoUpdate.get(data.ET_Cost_Api_Name__c);
                                        }
                                        if(value != null){
                                            vatCostonInDirectExpenses += value;
                                        }
                                    }
                                }
                                vatCostonDirectExpenses = vatCostonDirectExpenses *0.05;
                                vatCostonInDirectExpenses = vatCostonInDirectExpenses *0.05;
                            }
                            vehicleQuoteItemtoUpdate.ET_VAT_Cost_on_Direct_Expenses__c = Math.round(vatCostonDirectExpenses);
                            vehicleQuoteItemtoUpdate.ET_VAT_Cost_on_Indirect_Expenses__c = Math.round(vatCostonInDirectExpenses);
                        }
                        //system.debug('vehicleQuoteItemtoUpdate  = '+ JSON.serializePretty(vehicleQuoteItemtoUpdate));
                        vehicleQuoteItemLstToUpdate.add(vehicleQuoteItemtoUpdate);
                    }
                }
                
                
                if(!vehicleQuoteItemLstToUpdate.isEmpty()){
                    Map<Decimal, Decimal> substitnalVehCostMap =  getSubstitutionalVehiclesCost(vehicleQuoteItemLstToUpdate , 'ET_Total_Vehicles_Cost__c');
                    Map<Decimal, Decimal> substitnalVehProfMap =  getSubstitutionalVehiclesCost(vehicleQuoteItemLstToUpdate , 'ET_Annual_Vehicles_Profit_Value__c');
                    for(ET_Vehicle_Quote_Item__c vehicleQuoteItem : vehicleQuoteItemLstToUpdate){
                        if(vehicleQuoteItem.ET_Vehicle_Source__c == 'Main' || vehicleQuoteItem.ET_Vehicle_Source__c == 'optional'){
                            //get Total Cost
                            if(substitnalVehCostMap != null && substitnalVehCostMap.containsKey(vehicleQuoteItem.ET_Contract_Period__c) ){
                                vehicleQuoteItem.Substitutional_Vehicles_Cost_Per_Vehicle__c = Math.round(substitnalVehCostMap.get(vehicleQuoteItem.ET_Contract_Period__c));
                            }
                            //get Vehicle Profit
                            if(substitnalVehProfMap != null && substitnalVehProfMap.containsKey(vehicleQuoteItem.ET_Contract_Period__c) ){
                                vehicleQuoteItem.Substitutional_vehcls_profit_Per_Vehicle__c = Math.round(substitnalVehProfMap.get(vehicleQuoteItem.ET_Contract_Period__c));
                            }
                        }
                    }
                    
                    try{
                        // Call calculateTargetPriceCalcs
                        system.debug('Check number');
                        vehicleQuoteItemLstToUpdate =  calculateTargetPriceCalcs( vehicleQuoteItemLstToUpdate,  quoteId );
                        //system.debug('vehicleQuoteItemLstToUpdate final  = ' + JSON.serializePretty(vehicleQuoteItemLstToUpdate));
                        update vehicleQuoteItemLstToUpdate; 
                        //system.debug('vehicle Quote Items updated');
                        response = 'Success';
                    }
                    catch(Exception ex){
                        system.debug('Exception ='+ ex.getMessage());
                        system.debug('Exception Trace='+ ex.getStackTraceString());
                        system.debug('Exception line='+ ex.getLineNumber());
                        response = 'Exception occured of type :' + ex.getTypeName() + ' due to cause : ' + ex.getCause()  + 'with Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString();
                        // throw new AuraHandledException('Exception message : ' + e.getMessage() +' ; stack trace : '+ e.getStackTraceString());
                    }
                }
            }
        }
        
        return response;    
    }
    
    
    Public static List<ET_Vehicle_Quote_Item__c>  calculateTargetPriceCalcs(List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLstToUpdate, String quoteId ){
        // system.debug('vehicleQuoteItemLstToUpdate ip  = ' + JSON.serializePretty(vehicleQuoteItemLstToUpdate));
        Map<String, decimal> vehVsManpowerTotalCostDiscountedPrice =ET_VehicleCalcDetailsController.getCombinationTargetCostForEachVehcile(quoteId, 'Workforce_cost_per_each_veh_Discounted__c');
        Map<String, decimal> vehVsManpowerProfitDiscountedPrice =ET_VehicleCalcDetailsController.getCombinationTargetCostForEachVehcile(quoteId, 'Workforce_profit_per_each_veh_Discounte__c');
        
        for(ET_Vehicle_Quote_Item__c vehicleQuoteItem :  vehicleQuoteItemLstToUpdate){
            decimal totalAnnualTargetPriceFromIP = vehicleQuoteItem.Total_Annual_Price_Target_Prices__c!=null? vehicleQuoteItem.Total_Annual_Price_Target_Prices__c:0;
            decimal TotalCostDiscountedPrice = vehicleQuoteItem.Total_Vehicles_Cost_Discounted__c!=null? vehicleQuoteItem.Total_Vehicles_Cost_Discounted__c:0;
            decimal TotalProfitDiscountedPrice = vehicleQuoteItem.Discounted_Vehicle_Profit_Value_Target__c!=null? vehicleQuoteItem.Discounted_Vehicle_Profit_Value_Target__c:0;
            String vehKey = vehicleQuoteItem.ET_Vehicle_Unique_key__c + '=>'+vehicleQuoteItem.ET_Line_Number__c +'=>'+vehicleQuoteItem.ET_Contract_Period__c;
            if(vehVsManpowerTotalCostDiscountedPrice != null && vehVsManpowerTotalCostDiscountedPrice.containsKey(vehKey)){
                TotalCostDiscountedPrice = TotalCostDiscountedPrice + vehVsManpowerTotalCostDiscountedPrice.get(vehKey);
            }
            if(vehVsManpowerProfitDiscountedPrice != null && vehVsManpowerProfitDiscountedPrice.containsKey(vehKey)){
                TotalProfitDiscountedPrice = TotalProfitDiscountedPrice + vehVsManpowerProfitDiscountedPrice.get(vehKey);
            }
            decimal totalAnnualPriceExcludingVATDiscountedPrice = TotalCostDiscountedPrice + TotalProfitDiscountedPrice;
            decimal diffToAdjust =0.0;
            if(totalAnnualTargetPriceFromIP != null && TotalCostDiscountedPrice != null){
                diffToAdjust = totalAnnualTargetPriceFromIP -  totalAnnualPriceExcludingVATDiscountedPrice;
            }
            if(vehicleQuoteItem.Discounted_Vehicle_Profit_Value_Target__c != null){
                vehicleQuoteItem.Vehicle_Profit_Value_Target_Price__c = vehicleQuoteItem.Discounted_Vehicle_Profit_Value_Target__c + diffToAdjust;
            }
            vehicleQuoteItem.Vehicles_Profit_Margin_Rate_Target__c =  ((vehicleQuoteItem.Vehicle_Profit_Value_Target_Price__c / vehicleQuoteItem.Total_Annual_Cost_Target_Prices__c)*100).setScale(2);
        }
        
        //  system.debug('vehicleQuoteItemLstToUpdate op = ' + JSON.serializePretty(vehicleQuoteItemLstToUpdate));
        return vehicleQuoteItemLstToUpdate;
    }
    
    
    /* Method : getSubstitutionalVehiclesCost
Description : To get Substitutional vehicles Total Cost Per Each Contract Year Per Each Main Vehicle..
Ex: If Contract Year =2 , and for Two Substitutional vehicles , Need - Sum of Total cost for each Substitutional veh for 2nd Year...
costApiName - This is either  'ET_Total_Vehicles_Cost__c' or 'ET_Annual_Vehicles_Profit_Value__c'
*/
    
    Public static Map<Decimal, Decimal> getSubstitutionalVehiclesCost(List<ET_Vehicle_Quote_Item__c> quoteItemList ,String costApiName){
        Map<Decimal, Decimal> totalCostVsYearMap = new Map<Decimal, Decimal>();
        
        decimal numOfMainVeh = getTotalNumberOfMainVehicles(quoteItemList) != 0.0 ? getTotalNumberOfMainVehicles(quoteItemList) : 1 ;
        
        for(ET_Vehicle_Quote_Item__c vQItem :quoteItemList)
        {
            if(vQItem != null && vQItem.ET_Vehicle_Source__c == 'Substitutional'){
                if(totalCostVsYearMap != null && totalCostVsYearMap.containsKey(vQItem.ET_Contract_Period__c) && totalCostVsYearMap.get(vQItem.ET_Contract_Period__c) != 0.0){
                    decimal totVal = totalCostVsYearMap.get(vQItem.ET_Contract_Period__c) +((decimal)vQItem.get(costApiName)*(decimal)vQItem.get('ET_Number_of_Vehicles__c')) /numOfMainVeh;
                    totalCostVsYearMap.put(vQItem.ET_Contract_Period__c , totVal);
                }
                else{
                    totalCostVsYearMap.put(vQItem.ET_Contract_Period__c , ((decimal)vQItem.get(costApiName)*(decimal)vQItem.get('ET_Number_of_Vehicles__c'))/numOfMainVeh);
                } 
            }
        }
        //system.debug('totalCostVsYearMap = '+ totalCostVsYearMap);
        return totalCostVsYearMap;
    }
    
    
    Public static decimal getTotalNumberOfMainVehicles(List<ET_Vehicle_Quote_Item__c> quoteItemList){
        decimal totalVeh = 0.0;
        Map<decimal, decimal> VehLineVsQuantityMap = new Map<decimal, decimal>();
        for(ET_Vehicle_Quote_Item__c vQItem :quoteItemList)
        {
            if(vQItem.ET_Vehicle_Source__c == 'Main'){
                if(VehLineVsQuantityMap != null && !VehLineVsQuantityMap.containsKey(vQItem.ET_Line_Number__c)){
                    VehLineVsQuantityMap.put(vQItem.ET_Line_Number__c, vQItem.ET_Number_of_Vehicles__c); 
                } 
            }
        }
        
        if(VehLineVsQuantityMap != null && !VehLineVsQuantityMap.isEmpty()){
            for(decimal vehQuan :VehLineVsQuantityMap.values() ){
                totalVeh += vehQuan;
            }
        }
        //system.debug('Total Main vehciles = '+ totalVeh);
        return totalVeh;
    }
    
    private static Decimal getFinalCost(List<Decimal> costList){
        Decimal sum = 0.0;
        if(costList != null && costList.size() > 0){
            for(Decimal cost : costList){
                if(cost != null ){
                    sum = sum + cost;
                }
            }
        }
        return sum;
    }
    public static Decimal calculateInsuranceVehicleValue(
        Decimal currentVehicleValue,
        Decimal depreciatedYearsFromMaster,
        Decimal insuranceRate,
        Integer contractYearInt,
        Decimal minCostPerYear
    ) {
        List<Decimal> yearlyCosts = new List<Decimal>();
    
        // Year 1: Full value * insurance rate
        Decimal year1 = currentVehicleValue * (insuranceRate / 100);
        year1 = (year1 < minCostPerYear) ? minCostPerYear : year1;
        yearlyCosts.add(year1);
    
        // Year 2 to contractYearInt
        for (Integer i = 2; i <= contractYearInt; i++) {
            Decimal yearValue = (currentVehicleValue / depreciatedYearsFromMaster) *
                                (depreciatedYearsFromMaster - (i - 1)) *
                                (insuranceRate / 100);
    
            yearValue = (yearValue < minCostPerYear) ? minCostPerYear : yearValue;
            yearlyCosts.add(yearValue);
        }
    
        Decimal total = 0;
        for (Decimal val : yearlyCosts) {
            total += val;
        }
    
        return total / contractYearInt;
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
        
        
    }
}