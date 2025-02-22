public without sharing class ET_VehicleCalcDetailsController {
    
    Private static Map<String, List<String>> combinationServicesMap = new Map<String, List<String>>();
    
    @AuraEnabled
    public static String ET_getvehicleCalcDetails(String quoteId){
        System.debug('quoteId-->'+quoteId);
        ET_VehicleCalcDetailsWrapper mainWrapperObj = new ET_VehicleCalcDetailsWrapper();
        List<Quote> quoteList =[Select id,Is_Target_Price_Required__c, Total_Number_of_Accountants__c , 
                                Total_Number_of_Coordinators__c,  Total_Number_of_Drivers__c,
                                Total_Number_of_Nannies__c , Total_Number_of_Other_Employees__c,
                                Total_Number_of_Supervisors__c, Total_Number_of_Vehicles__c,
                                ET_Type__c
                                From Quote Where Id=:quoteId];
        
        boolean isTargetPriceRequired = false;
        quoteDetails quoteDetailsWrapper = new quoteDetails();
        if(quoteList!=null && quoteList.size()>0){
            isTargetPriceRequired = quoteList[0].Is_Target_Price_Required__c;
            quoteDetailsWrapper.quotetype = quoteList[0].ET_Type__c;
            quoteDetailsWrapper.totalNumberOfVehicles = quoteList[0].Total_Number_of_Vehicles__c;
            quoteDetailsWrapper.totalNumberOfDrivers = quoteList[0].Total_Number_of_Drivers__c;
            quoteDetailsWrapper.totalNumberOfNannies = quoteList[0].Total_Number_of_Nannies__c;
            quoteDetailsWrapper.totalNumberOfAccountants = quoteList[0].Total_Number_of_Accountants__c;
            quoteDetailsWrapper.totalNumberOfCoordinators = quoteList[0].Total_Number_of_Coordinators__c;
            quoteDetailsWrapper.totalNumberOfSupervisors = quoteList[0].Total_Number_of_Supervisors__c;
            quoteDetailsWrapper.totalNumberOfOtherManpower = quoteList[0].Total_Number_of_Other_Employees__c;
        }
        quoteDetailsWrapper.isTargetPriceRequired = isTargetPriceRequired;
        
        
        
        
        mainWrapperObj.quoteDetailsWrapper = quoteDetailsWrapper;
        List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLst = ET_PricingUtilityClass.getVehicleQuoteItemLst(quoteId);
        string appovalDetails;
        //wrap.lstQuoteCalcDetails.addAll( 
        system.debug('vehicleQuoteItemLst : '+ vehicleQuoteItemLst);
        List<ET_ServiceRequestController.vehicleQuoteCalcClass> vehicleQuoteCalcLst = new List<ET_ServiceRequestController.vehicleQuoteCalcClass>();
        for(ET_Vehicle_Quote_Item__c vehicleQuoteItem :  vehicleQuoteItemLst){
            ET_ServiceRequestController.vehicleQuoteCalcClass vehicleQuoteCalObj = new ET_ServiceRequestController.vehicleQuoteCalcClass();
            vehicleQuoteCalObj.vehicleLineItemNumberFromRequest = Integer.valueOf(vehicleQuoteItem.ET_Line_Number__c);
            vehicleQuoteCalObj.contractYear = Integer.valueOf(vehicleQuoteItem.ET_Contract_Period__c);
            vehicleQuoteCalObj.vehiclePurchasePriceBasedOnCondition = vehicleQuoteItem.ET_Vehicle_Current_Purchase_Price__c;
            vehicleQuoteCalObj.vehicleResaleValue = vehicleQuoteItem.ET_Vehicle_Resale_Value__c;
            vehicleQuoteCalObj.vehicleDepreciation = vehicleQuoteItem.ET_Vehicle_Depreciation__c ;
            vehicleQuoteCalObj.vehicleRepairsAndMaintenance = vehicleQuoteItem.ET_Vehicle_Repairs_and_Maintenance__c;
            vehicleQuoteCalObj.vehicleFinancing = vehicleQuoteItem.ET_Vehicle_Financing__c;
            vehicleQuoteCalObj.vehicleRegistrationAndInspectionFee = vehicleQuoteItem.ET_Vehicle_Registration__c;
            vehicleQuoteCalObj.vehicleInsurance = vehicleQuoteItem.ET_Vehicle_Insurance__c;
            vehicleQuoteCalObj.deprciationReserve = vehicleQuoteItem.ET_Depreciation_Reserve__c;
            vehicleQuoteCalObj.maintenanceReserve = vehicleQuoteItem.ET_Maintenance_Reserve__c;
            vehicleQuoteCalObj.generalReserve = vehicleQuoteItem.ET_General_Reserve__c;
            vehicleQuoteCalObj.annualVehicleProfitMarginRate = vehicleQuoteItem.ET_Annual_Vehicles_Profit_Margin__c;
            vehicleQuoteCalObj.annualVehicleProfitMarginValue = vehicleQuoteItem.ET_Annual_Vehicles_Profit_Value__c;
            vehicleQuoteCalObj.fuelExpenses = vehicleQuoteItem.ET_Fuel_Expenses__c;
            vehicleQuoteCalObj.fuelReserve = vehicleQuoteItem.ET_Fuel_Reserve__c;
            vehicleQuoteCalObj.annualFuelProfitMarginRate = vehicleQuoteItem.ET_Annual_Fuel_Profit_Margin_Rate__c;
            vehicleQuoteCalObj.annualFuelProfitMarginValue = vehicleQuoteItem.ET_Annual_Fuel_Profit_Value__c;
            vehicleQuoteCalObj.vehicleTotalCost = vehicleQuoteItem.ET_Total_Vehicles_Cost__c;
            vehicleQuoteCalObj.vehicleTotalFixedCost = vehicleQuoteItem.ET_Total_Fixed_Cost__c;
            vehicleQuoteCalObj.vehicleTotalVariableCost = vehicleQuoteItem.ET_Total_Variable_Cost__c;
            vehicleQuoteCalObj.totalFuelCost = vehicleQuoteItem.ET_Total_Fuel_Cost__c;
            vehicleQuoteCalObj.totalReserveCost = vehicleQuoteItem.ET_Total_Reserve_Cost__c;
            vehicleQuoteCalObj.numberOfVehicles = vehicleQuoteItem.ET_Number_of_Vehicles__c !=0 ? integer.Valueof(vehicleQuoteItem.ET_Number_of_Vehicles__c): 0 ;
            vehicleQuoteCalObj.vehicleLineUniqueKey = vehicleQuoteItem.ET_Vehicle_Unique_key__c;
            vehicleQuoteCalObj.noOfSeats = vehicleQuoteItem.ET_No_of_Seats__c;
            vehicleQuoteCalObj.dailyMileage = vehicleQuoteItem.ET_Daily_Mileage__c;
            vehicleQuoteCalObj.totalAnnualMileage = vehicleQuoteItem.ET_Total_Annual_Mileage__c;
            vehicleQuoteCalObj.vehicleCurrentPurchasePrice = vehicleQuoteItem.ET_Vehicle_Current_Purchase_Price__c;
            vehicleQuoteCalObj.vehicleLatestNewPurchasePrice = vehicleQuoteItem.ET_Vehicle_Original_Purchase_Price__c;
            vehicleQuoteCalObj.vehicleDepreciationRate = vehicleQuoteItem.ET_Vehicle_Depreciation_Percentage__c;
            vehicleQuoteCalObj.depreciationRateforExtraMileage = vehicleQuoteItem.ET_Depreciation_Rate_for_Extra_Mileage__c ;
            vehicleQuoteCalObj.vehicleMaintenanceRate = vehicleQuoteItem.ET_Vehicle_Maintenance_Rate__c;
            vehicleQuoteCalObj.workingMonthsPerYear = vehicleQuoteItem.ET_Working_Months_per_year__c;
            vehicleQuoteCalObj.workingDaysPerWeek = vehicleQuoteItem.ET_Working_days_per_week__c;
            vehicleQuoteCalObj.vehicleSource = vehicleQuoteItem.ET_Vehicle_Source__c;
            vehicleQuoteCalObj.serviceType = vehicleQuoteItem.ET_Service_Type__c;
            vehicleQuoteCalObj.workingDaysPerYear = vehicleQuoteItem.ET_Working_days_per_year__c;
            vehicleQuoteCalObj.extraBusFeesForSchoolTransportation = vehicleQuoteItem.ET_Extra_Bus_Fees__c;
            vehicleQuoteCalObj.fuelRate = vehicleQuoteItem.ET_Vehicle_Fuel_Rate__c;
            vehicleQuoteCalObj.priceUtilization = vehicleQuoteItem.ET_Price_Utilization__c;
            vehicleQuoteCalObj.pricingType = vehicleQuoteItem.ET_Pricing_Type__c;
            vehicleQuoteCalObj.pricingMethod = vehicleQuoteItem.ET_Pricing_Method__c;
            vehicleQuoteCalObj.vehicleVATRate = vehicleQuoteItem.ET_Vat_Rate__c;
            vehicleQuoteCalObj.fuelRequired = vehicleQuoteItem.ET_Fuel_Required__c;
            vehicleQuoteCalObj.vatCostonDirectExpenses = vehicleQuoteItem.ET_VAT_Cost_on_Direct_Expenses__c ;
            vehicleQuoteCalObj.vatCostonInDirectExpenses = vehicleQuoteItem.ET_VAT_Cost_on_Indirect_Expenses__c;
            vehicleQuoteCalObj.discountOrAdditionalProfit = vehicleQuoteItem.ET_Discounts_Additional_Profit__c;
            vehicleQuoteCalObj.substitutionalVehiclesCostPerVehicle = vehicleQuoteItem.Substitutional_Vehicles_Cost_Per_Vehicle__c;
            vehicleQuoteCalObj.substitutionalVehiclesProfitPerVehicle =vehicleQuoteItem.Substitutional_vehcls_profit_Per_Vehicle__c;
            // If Target Price is Required - than Calculate total annualCost for Target Prices for each year = Veh+fuel+Manpower...
            
            if(isTargetPriceRequired){
                // annual target Price - given by User ...
                vehicleQuoteCalObj.generalReserveDiscountedPrice = vehicleQuoteItem.General_Reserve_for_Discounted_Price__c;
                vehicleQuoteCalObj.generalReserveTargetPrice = vehicleQuoteItem.General_Reserve_Target_Prices__c;
                vehicleQuoteCalObj.fuelReserveDiscounted = vehicleQuoteItem.Fuel_Reserve_Discounted__c;
                vehicleQuoteCalObj.fuelReserveTarget = vehicleQuoteItem.Fuel_Reserve_Target__c;
                vehicleQuoteCalObj.totalFuelCostDiscounted = vehicleQuoteItem.Total_Fuel_Cost_Discounted__c;
                vehicleQuoteCalObj.totalFuelCostTargetPrice = vehicleQuoteItem.Total_Fuel_Cost_Target_Price__c;
                vehicleQuoteCalObj.fuelProfitValueDiscountedPrice = vehicleQuoteItem.Fuel_Profit_Value_Discounted__c;
                vehicleQuoteCalObj.fuelProfitValueTargetPrice = vehicleQuoteItem.ET_Annual_Fuel_Profit_Target_Prices__c;
                vehicleQuoteCalObj.vehicleTotalCostDiscountedPrice = vehicleQuoteItem.Total_Vehicles_Cost_Discounted__c;
                vehicleQuoteCalObj.vehicleTotalCostTargetPrice = vehicleQuoteItem.Total_Annual_Cost_Target_Prices__c;
                vehicleQuoteCalObj.vehicleProfitMarginRateForDiscountedPrice = vehicleQuoteItem.Vehicles_Profit_Margin_Rate_Discounted__c;
                
                vehicleQuoteCalObj.discountedVehicleProfitValueForTargetPrice =vehicleQuoteItem.Discounted_Vehicle_Profit_Value_Target__c;
                
                
                vehicleQuoteCalObj.totalAnnualTargetPrice = vehicleQuoteItem.Total_Annual_Price_Target_Prices__c!=null? vehicleQuoteItem.Total_Annual_Price_Target_Prices__c:0;
                vehicleQuoteCalObj.vehicleProfitValueForTargetPrice = vehicleQuoteItem.Vehicle_Profit_Value_Target_Price__c;
                vehicleQuoteCalObj.vehicleProfitMarginRateForTargetPrice  = vehicleQuoteItem.Vehicles_Profit_Margin_Rate_Target__c;
                
                //vehTotalCostTargetPrice - targetPriceFor Vehicle
                /* decimal vehTotalCostTargetPrice = vehicleQuoteItem.Total_Annual_Cost_Target_Prices__c!=null? vehicleQuoteItem.Total_Annual_Cost_Target_Prices__c:0;

String vehKey = vehicleQuoteItem.ET_Vehicle_Unique_key__c + '=>'+vehicleQuoteItem.ET_Line_Number__c +'=>'+vehicleQuoteItem.ET_Contract_Period__c;
// get total target Price for  all Services in Combination..
Map<String, decimal> vehVsTotalCostTargetPrice = getCombinationTargetCostForEachVehcile(quoteId);
if(vehVsTotalCostTargetPrice != null && vehVsTotalCostTargetPrice.containsKey(vehKey)){
vehTotalCostTargetPrice = vehTotalCostTargetPrice + vehVsTotalCostTargetPrice.get(vehKey);
}
vehicleQuoteCalObj.discountedTotalAnnualTargetPrice = vehTotalCostTargetPrice;
if(vehicleQuoteItem.Discounted_Vehicle_Profit_Value_Target__c != null &&  vehicleQuoteCalObj.totalAnnualTargetPrice != null && vehicleQuoteCalObj.discountedTotalAnnualTargetPrice != null){
vehicleQuoteCalObj.vehicleProfitValueForTargetPrice =vehicleQuoteItem.Discounted_Vehicle_Profit_Value_Target__c + (vehicleQuoteCalObj.totalAnnualTargetPrice - vehicleQuoteCalObj.discountedTotalAnnualTargetPrice);
}
if(vehicleQuoteCalObj.vehicleProfitValueForTargetPrice!=null && vehicleQuoteCalObj.vehicleProfitValueForTargetPrice!=0 
&& vehicleQuoteCalObj.discountedTotalAnnualTargetPrice!=null && vehicleQuoteCalObj.discountedTotalAnnualTargetPrice!=0)
{
vehicleQuoteCalObj.vehicleProfitMarginRateForTargetPrice =((vehicleQuoteCalObj.vehicleProfitValueForTargetPrice / vehicleQuoteCalObj.discountedTotalAnnualTargetPrice)*100).setScale(2); 
}*/
            }
            
            List<ET_ServiceRequestController.vehicleSpecialRequirement> requirementLst = new List<ET_ServiceRequestController.vehicleSpecialRequirement>();
            system.debug('vehicleQuoteItem.Vehicle_Quote_Item_SpecRequests__r : '+ vehicleQuoteItem.Vehicle_Quote_Item_SpecRequests__r.toString());
            for(ET_Quote_Item_SpecReq__c vehicleQuoteItemRequest : vehicleQuoteItem.Vehicle_Quote_Item_SpecRequests__r ){
                ET_ServiceRequestController.vehicleSpecialRequirement specReq = new ET_ServiceRequestController.vehicleSpecialRequirement();
                specReq.specificRequirementLabel = vehicleQuoteItemRequest.Name;
                specReq.specificRequirementCost = vehicleQuoteItemRequest.ET_Cost__c;
                requirementLst.add(specReq);
            }
            system.debug('requirementLst : '+ requirementLst.toString());
            vehicleQuoteCalObj.vehicleSpecialRequirementLst = requirementLst;
            vehicleQuoteCalcLst.add(vehicleQuoteCalObj);
            if((appovalDetails=='' || appovalDetails==null) && vehicleQuoteItem.Approval_Details__c!=null && vehicleQuoteItem.Approval_Details__c!='')
                appovalDetails=vehicleQuoteItem.Approval_Details__c;
        }
        system.debug('vehicleQuoteCalcLst : '+ vehicleQuoteCalcLst );
        mainWrapperObj.vehicleQuoteWrapper = vehicleQuoteCalcLst;
        if(appovalDetails!=null && appovalDetails!=''){
            list<vehicleApprovalDetails> ApprovalDetailsWrp=new list<vehicleApprovalDetails>();
            for(string yearDetails:appovalDetails.split(';')){
                if(yearDetails!=null && yearDetails!=''){
                    integer yearDetailsSize=yearDetails.split(',').size();
                    if(yearDetails.split(',').size()>0 && yearDetails.split(',').size()==4){
                        if(yearDetails.split(',')[1]!=null && yearDetails.split(',')[1]!=''){
                            vehicleApprovalDetails wrp=new vehicleApprovalDetails();
                            wrp.element=yearDetails.split(',')[0];
                            wrp.requestedBy=yearDetails.split(',')[1];
                            wrp.approvedby=yearDetails.split(',')[2];
                            wrp.reason=yearDetails.split(',')[3];
                            ApprovalDetailsWrp.add(wrp);
                        }
                    }
                }
            }
            mainWrapperObj.vehicleApprovalDetailsWrp = ApprovalDetailsWrp;
        }
        mainWrapperObj.noOfVehicleLinesInRequest=(integer)[select count_distinct(ET_Line_Number__c) noOfLines 
                                                           from ET_Vehicle_Quote_Item__c  where ET_Quote_Item_Type__c = 'Vehicle' and Quote__c=:quoteId][0].get('noOfLines');  
        return JSON.serialize(mainWrapperObj,true);
    }
    
    /* Method      : getCombinationTargetCostForEachVehcile
Description : To get Total Cost for Target Prices for each Vehicle withRespect to it's line nd Contract Year
Map< String, decimal > ==> Key = VehicleKey+line+Year , Value = Total Cost for target Prices for Vehicle Related Combination...
*/
    
    Public Static Map<String, decimal> getCombinationTargetCostForEachVehcile(String quoteId, String costApiName){
        Map<String, decimal> vehVsTotalCostTargetPrice = new Map<String, decimal>();
        // get Vehicles from Request Mapping..
        Map<String, List<String>> vehWithCombinationMap = getTargetPriceForCombination(quoteId);
        Map<String, decimal> targetPriceMapWithService = getTargetPriceMapWithService(quoteId,costApiName);
        if(vehWithCombinationMap != null && !vehWithCombinationMap.isEmpty()){
            for(String vehK : vehWithCombinationMap.keyset()){
                for(integer i=1 ; i<=8 ; i++){
                    String vehKey = vehK+'=>'+i;
                    List<String> serCombinats = vehWithCombinationMap.get(vehK);
                    decimal totalValue =0;
                    if(serCombinats != null && serCombinats.size() > 0){
                        for(string serv :serCombinats ){
                            String serKey = serv+ '=>'+i;
                            if(targetPriceMapWithService.containsKey(serKey)){
                                totalValue += targetPriceMapWithService.get(serKey);
                            }
                        }
                    }
                    vehVsTotalCostTargetPrice.put(vehKey,totalValue);
                }
            }
        }
        
        return vehVsTotalCostTargetPrice;
    }
    
    
    /* Method : getSubstitutionalVehiclesCost
Description : To get Substitutional vehicles Total Cost Per Each Contract Year Per Each Main Vehicle..
Ex: If Contract Year =2 , and for Two Substitutional vehicles , Need - Sum of Total cost for each Substitutional veh for 2nd Year...
costApiName - This is either  'ET_Total_Vehicles_Cost__c' or 'ET_Annual_Vehicles_Profit_Value__c'
*/
    
    Public static Map<Decimal, Decimal> getSubstitutionalVehiclesCost(String quoteId ,String costApiName){
        Map<Decimal, Decimal> totalCostVsYearMap = new Map<Decimal, Decimal>();
        
        decimal numOfMainVeh = getTotalNumberOfMainVehicles(quoteId) != 0.0 ? getTotalNumberOfMainVehicles(quoteId) : 1 ;
        
        for(ET_Vehicle_Quote_Item__c vQItem :[select ET_Contract_Period__c, ET_Line_Number__c, 
                                              ET_Number_of_Vehicles__c , ET_Total_Vehicles_Cost__c,
                                              ET_Annual_Vehicles_Profit_Value__c
                                              FROM ET_Vehicle_Quote_Item__c
                                              where ET_Vehicle_Source__c = 'Substitutional' AND
                                              Quote__c =:	quoteId  ])
        {
            if(vQItem != null){
                if(totalCostVsYearMap != null && totalCostVsYearMap.containsKey(vQItem.ET_Contract_Period__c) && totalCostVsYearMap.get(vQItem.ET_Contract_Period__c) != 0.0){
                    decimal totVal = totalCostVsYearMap.get(vQItem.ET_Contract_Period__c) +((decimal)vQItem.get(costApiName)*(decimal)vQItem.get('ET_Number_of_Vehicles__c')) /numOfMainVeh;
                    totalCostVsYearMap.put(vQItem.ET_Contract_Period__c , totVal);
                }
                else{
                    totalCostVsYearMap.put(vQItem.ET_Contract_Period__c , ((decimal)vQItem.get(costApiName)*(decimal)vQItem.get('ET_Number_of_Vehicles__c'))/numOfMainVeh);
                } 
            }
        }
        system.debug('totalCostVsYearMap = '+ totalCostVsYearMap);
        return totalCostVsYearMap;
    }
    
    Public static decimal getTotalNumberOfMainVehicles(String quoteId){
        decimal totalVeh = 0.0;
        Map<decimal, decimal> VehLineVsQuantityMap = new Map<decimal, decimal>();
        for(ET_Vehicle_Quote_Item__c vQItem :[select ET_Contract_Period__c, ET_Line_Number__c, ET_Number_of_Vehicles__c
                                              FROM ET_Vehicle_Quote_Item__c
                                              where ET_Vehicle_Source__c = 'Main' AND
                                              Quote__c =:	quoteId  ])
        {
            if(VehLineVsQuantityMap != null && !VehLineVsQuantityMap.containsKey(vQItem.ET_Line_Number__c)){
                VehLineVsQuantityMap.put(vQItem.ET_Line_Number__c, vQItem.ET_Number_of_Vehicles__c); 
            }  
        }
        
        if(VehLineVsQuantityMap != null && !VehLineVsQuantityMap.isEmpty()){
            for(decimal vehQuan :VehLineVsQuantityMap.values() ){
                totalVeh += vehQuan;
            }
        }
        system.debug('Total Main vehciles = '+ totalVeh);
        return totalVeh;
    }
    
    Public static Map<String, List<String>> getCombinationServicesMap(String quoteId){
        getTargetPriceForCombination(quoteId);
        return combinationServicesMap;
    }
    
    
    Public static Map<String,ET_Request_Mapping__c >  getReqMappingRecWrtoVehicleKey(String quoteId){
        Map<String,ET_Request_Mapping__c > vehKeyAndReqMappingMap = new Map<String,ET_Request_Mapping__c>();
        
        String servReqId = [select id, ET_Pricing_Service_Request__c from Quote where id =:quoteId].ET_Pricing_Service_Request__c;
        List<ET_Request_Mapping__c> reqMappings = [select id,ET_Vehicle_Unique_key__c,
                                                   ET_Accountant_Unique_Key__c,
                                                   ET_Coordinator_Unique_Key__c,
                                                   ET_Driver_Unique_Id__c,
                                                   ET_Nanny_Unique_Key__c,
                                                   ET_Supervisor_Unique_Key__c,
                                                   ET_Other_Employee_Unique_Key__c,
                                                   ET_Number_of_Accountants__c,ET_Number_of_Coordinators__c,
                                                   ET_Number_of_Drivers__c,ET_Number_of_Nannies__c,
                                                   ET_Number_of_Other_Employees__c,ET_Number_of_Supervisors__c,
                                                   ET_Number_of_Vehicles__c
                                                   from ET_Request_Mapping__c where ET_Pricing_Service_Request__c =:servReqId ];
        
        if(reqMappings != null && !reqMappings.isEmpty()){
            
            for(ET_Request_Mapping__c reqMap : reqMappings ){
                vehKeyAndReqMappingMap.put(reqMap.ET_Vehicle_Unique_key__c,reqMap );
            }
        }
        return vehKeyAndReqMappingMap;
        
    }
    
    
    /* Method      : getTargetPriceForCombination
Description : To get Sum of Annual Total Cost of Target Prices for Given Combination with Vehicle
Retune type :Map<String, List<String>>
// Key = Toyota_Yaris_GLX_2020=>1, Values = Abudhabi School Driver=>1,Nanny=>1....
*/
    Public static Map<String, List<String>> getTargetPriceForCombination(String quoteId){
        //get the list of 'Main Vehicles' from Vehicle Request and Separate Vehicles which are not the in the combination List
        
        List<Vehicle__c> mainVehRequests = new List<Vehicle__c>();
        List<String> mainVehicleKeys = new List<String>();
        List<String> CombinationVehicleKeys = new List<String>(); // all vehicle keys in request mapppings
        List<String> independentVehicleKeys = new List<String>();
        Map<String, decimal> vehQuantityWrToKey = new Map<String, decimal>(); // Key = Vehicle Key and Value = Vehicle quantity from Pricing Vehicle requests.
        // get Request Mappings related to - Pricing service Request of given Quote..
        String servReqId = [select id, ET_Pricing_Service_Request__c from Quote where id =:quoteId].ET_Pricing_Service_Request__c;
        List<String> vehSources = new List<String>{'Main', 'optional'};
            
            mainVehRequests = [select id, ET_Vehicle_MAKE__c , ET_Vehicle_Specs__c ,ET_Vehicle_Model__c , ET_Vehicle_Model_Year__c ,
                               ET_Vehicle_Line__c , ET_Vehicle_Quantity__c
                               FROM  Vehicle__c where ET_Vehicle_Source__c in :vehSources AND ET_Pricing_Service_Request__c =:servReqId ];
        if(!mainVehRequests.isEmpty()){
            for(Vehicle__c veh : mainVehRequests ){
                // mainVehicleKeys.add(veh.ET_Vehicle_MAKE__c+'_'+veh.ET_Vehicle_Model__c+'_'+veh.ET_Vehicle_Specs__c+'_'+veh.ET_Vehicle_Model_Year__c+'=>'+veh.ET_Vehicle_Line__c);
                mainVehicleKeys.add(veh.ET_Vehicle_MAKE__c+'_'+veh.ET_Vehicle_Model__c+'_'+veh.ET_Vehicle_Model_Year__c+'=>'+veh.ET_Vehicle_Line__c);
                vehQuantityWrToKey.put(veh.ET_Vehicle_MAKE__c+'_'+veh.ET_Vehicle_Model__c+'_'+veh.ET_Vehicle_Model_Year__c+'=>'+veh.ET_Vehicle_Line__c , veh.ET_Vehicle_Quantity__c );
            }
        }
        
        
        //Key = vehicle Key and Values = Manpower Keys of that particular line...
        Map<String, List<String>> vehWithCombinationMap = new Map<String, List<String>>(); 
        
        
        List<ET_Request_Mapping__c> reqMappings = [select id,ET_Vehicle_Unique_key__c,
                                                   ET_Accountant_Unique_Key__c,
                                                   ET_Coordinator_Unique_Key__c,
                                                   ET_Driver_Unique_Id__c,
                                                   ET_Nanny_Unique_Key__c,
                                                   ET_Supervisor_Unique_Key__c,
                                                   ET_Other_Employee_Unique_Key__c,
                                                   ET_Number_of_Accountants__c,ET_Number_of_Coordinators__c,
                                                   ET_Number_of_Drivers__c,ET_Number_of_Nannies__c,
                                                   ET_Number_of_Other_Employees__c,ET_Number_of_Supervisors__c,
                                                   ET_Number_of_Vehicles__c
                                                   from ET_Request_Mapping__c where ET_Pricing_Service_Request__c =:servReqId ];
        
        if(reqMappings != null && !reqMappings.isEmpty()){
            
            for(ET_Request_Mapping__c reqMap : reqMappings ){
                if(!vehWithCombinationMap.containskey(reqMap.ET_Vehicle_Unique_key__c) && reqMap.ET_Vehicle_Unique_key__c!= null ){
                    vehWithCombinationMap.put(reqMap.ET_Vehicle_Unique_key__c, new list<String>{});
                    combinationServicesMap.put(reqMap.ET_Vehicle_Unique_key__c, new list<String>{}); // Key = vehicle key and Values = Manpowers available for given vehicle key..
                    CombinationVehicleKeys.add(reqMap.ET_Vehicle_Unique_key__c);
                }
            }
            
            integer i =0;
            for(ET_Request_Mapping__c reqMap : reqMappings ){
                if(reqMap.ET_Number_of_Vehicles__c >0){
                    if(vehWithCombinationMap.containskey(reqMap.ET_Vehicle_Unique_key__c)){
                        if(reqMap.ET_Number_of_Accountants__c >0){
                            vehWithCombinationMap.get(reqMap.ET_Vehicle_Unique_key__c).add(reqMap.ET_Accountant_Unique_Key__c); 
                            combinationServicesMap.get(reqMap.ET_Vehicle_Unique_key__c).add('Accountant');  
                        }
                        if(reqMap.ET_Number_of_Coordinators__c >0){
                            vehWithCombinationMap.get(reqMap.ET_Vehicle_Unique_key__c).add(reqMap.ET_Coordinator_Unique_Key__c); 
                            combinationServicesMap.get(reqMap.ET_Vehicle_Unique_key__c).add('Coordinator');  
                        }
                        if(reqMap.ET_Number_of_Drivers__c >0){
                            vehWithCombinationMap.get(reqMap.ET_Vehicle_Unique_key__c).add(reqMap.ET_Driver_Unique_Id__c);
                            combinationServicesMap.get(reqMap.ET_Vehicle_Unique_key__c).add('Driver');  
                        }
                        if(reqMap.ET_Number_of_Nannies__c >0){
                            vehWithCombinationMap.get(reqMap.ET_Vehicle_Unique_key__c).add(reqMap.ET_Nanny_Unique_Key__c); 
                            combinationServicesMap.get(reqMap.ET_Vehicle_Unique_key__c).add('Nanny');  
                        }
                        if(reqMap.ET_Number_of_Other_Employees__c >0){
                            vehWithCombinationMap.get(reqMap.ET_Vehicle_Unique_key__c).add(reqMap.ET_Other_Employee_Unique_Key__c); 
                            combinationServicesMap.get(reqMap.ET_Vehicle_Unique_key__c).add('other employee');  
                        }
                        if(reqMap.ET_Number_of_Supervisors__c >0){
                            vehWithCombinationMap.get(reqMap.ET_Vehicle_Unique_key__c).add(reqMap.ET_Supervisor_Unique_Key__c); 
                            combinationServicesMap.get(reqMap.ET_Vehicle_Unique_key__c).add('Supervisor');  
                        }
                    }
                }
                
                else if(reqMap.ET_Number_of_Vehicles__c == 0){
                    i++;
                    String mapKey = 'no vehicle'+string.valueOf(i);
                    if(reqMap.ET_Number_of_Accountants__c >0){
                        if(!combinationServicesMap.isEmpty() && combinationServicesMap.size() > 0 && combinationServicesMap.containsKey(mapKey)){
                            combinationServicesMap.get(mapKey).add('Accountant');  
                        }
                        else{
                            combinationServicesMap.put(mapKey, new list<String>{'Accountant'}); 
                        }
                        
                    }
                    if(reqMap.ET_Number_of_Coordinators__c >0){
                        if(!combinationServicesMap.isEmpty() && combinationServicesMap.size() > 0  && combinationServicesMap.containsKey(mapKey)){
                            combinationServicesMap.get(mapKey).add('Coordinator');  
                        }
                        else{
                            combinationServicesMap.put(mapKey, new list<String>{'Coordinator'}); 
                        }
                    }
                    if(reqMap.ET_Number_of_Drivers__c >0){
                        if(!combinationServicesMap.isEmpty() && combinationServicesMap.size() > 0  && combinationServicesMap.containsKey(mapKey)){
                            combinationServicesMap.get(mapKey).add('Driver');  
                        }
                        else{
                            combinationServicesMap.put(mapKey, new list<String>{'Driver'}); 
                        }
                    }
                    if(reqMap.ET_Number_of_Nannies__c >0){
                        if(!combinationServicesMap.isEmpty() && combinationServicesMap.size() > 0 && combinationServicesMap.containsKey(mapKey)){
                            combinationServicesMap.get(mapKey).add('Nanny');  
                        }
                        else{
                            combinationServicesMap.put(mapKey, new list<String>{'Nanny'}); 
                        }
                    }
                    if(reqMap.ET_Number_of_Other_Employees__c >0){
                        if(!combinationServicesMap.isEmpty() && combinationServicesMap.size() > 0 && combinationServicesMap.containsKey(mapKey)){
                            combinationServicesMap.get(mapKey).add('other employee');  
                        }
                        else{
                            combinationServicesMap.put(mapKey, new list<String>{'other employee'}); 
                        }
                    }
                    if(reqMap.ET_Number_of_Supervisors__c >0){
                        if(!combinationServicesMap.isEmpty() && combinationServicesMap.size() > 0 && combinationServicesMap.containsKey(mapKey)){
                            combinationServicesMap.get(mapKey).add('Supervisor');  
                        }
                        else{
                            combinationServicesMap.put(mapKey, new list<String>{'Supervisor'}); 
                        }
                    }
                }
            }
        }
        //get independent Vehicle Keys 
        system.debug('mainVehicleKeys 438 = '+ mainVehicleKeys);
        for(String mainKey : mainVehicleKeys){
            if(CombinationVehicleKeys != null && !CombinationVehicleKeys.contains(mainKey)){
                independentVehicleKeys.add(mainKey);
            }
            else if(CombinationVehicleKeys == null || CombinationVehicleKeys.isempty()){
                independentVehicleKeys.add(mainKey);
            }
        }
        system.debug('independentVehicleKeys  = '+ independentVehicleKeys);
        
        // add independent Keys in CombinationsMap
        List<ET_Request_Mapping__c> reqMappingsWithVehOnlyList = new List<ET_Request_Mapping__c>();
        if(independentVehicleKeys != null && !independentVehicleKeys.isEmpty()){
            for(String vehKey :independentVehicleKeys ){
                ET_Request_Mapping__c reqMappingsWithVehOnly = new ET_Request_Mapping__c();
                reqMappingsWithVehOnly.ET_Vehicle_Unique_key__c = vehKey;
                reqMappingsWithVehOnly.ET_Pricing_Service_Request__c = servReqId;
                if(vehQuantityWrToKey != null && vehQuantityWrToKey.containsKey(vehKey)){
                    reqMappingsWithVehOnly.ET_Number_of_Vehicles__c = vehQuantityWrToKey.get(vehKey);
                    reqMappingsWithVehOnlyList.add(reqMappingsWithVehOnly);
                }
                vehWithCombinationMap.put(vehKey, new list<String>{});
                combinationServicesMap.put(vehKey, new list<String>{});
            }
            
            if(reqMappingsWithVehOnlyList != null && !reqMappingsWithVehOnlyList.isempty()){
                insert reqMappingsWithVehOnlyList;
            }
        } 
        system.debug('vehWithCombinationMap 458 = '+ json.serializePretty(vehWithCombinationMap));
        system.debug('combinationServicesMap  = '+ json.serializePretty(combinationServicesMap));
        return vehWithCombinationMap;
    }
    
    /* Method : getTargetPriceMapWithService
Description : To get Total Cost Target Price with Respect to Service like - Driver and other Manpower etc.. for each Line and Year..
*/
    
    public static Map<String, decimal> getTargetPriceMapWithService(String quoteId, String costApiName){
        //Key= workforceKey+'=>'+workforceLine + => + Contract Year = Abudhabi School Driver=>1=>1,    
        //Value = Total_Cost_Target_Prices__c
        Map<String, decimal> targetPriceMapWithService = new Map<String, decimal>();
        for(ET_Workforce_Quote_Item__c wQItem : [select id, ET_Workforce_Line_Number__c, ET_Workforce_Unique_Key__c, ET_Contract_Period__c,
                                                 Total_Cost_Target_Prices__c,Total_Cost_Discounted__c,Manpower_Profit_Value_Discounted__c,
                                                 Workforce_cost_per_each_veh_Discounted__c,Workforce_profit_per_each_veh_Discounte__c
                                                 FROM ET_Workforce_Quote_Item__c where quote__c = : quoteId ])
        {
            String mapKey = wQItem.ET_Workforce_Unique_Key__c + '=>' +wQItem.ET_Workforce_Line_Number__c + '=>' + wQItem.ET_Contract_Period__c ;
            targetPriceMapWithService.put(mapKey,decimal.ValueOf(String.ValueOf(wQItem.get(costApiName))));
        }
        
        return targetPriceMapWithService;
        
    }
    
    
    public class ET_VehicleCalcDetailsWrapper{
        @AuraEnabled
        public Boolean isTargetPriceRequired;
        @AuraEnabled
        public List<ET_ServiceRequestController.vehicleQuoteCalcClass> vehicleQuoteWrapper;
        @AuraEnabled
        public List<vehicleApprovalDetails> vehicleApprovalDetailsWrp;
        @AuraEnabled
        public integer noOfVehicleLinesInRequest=0;    
        @AuraEnabled
        public quoteDetails quoteDetailsWrapper;
    }
    
    public class quoteDetails{
        @AuraEnabled
        public Boolean isTargetPriceRequired;
        @AuraEnabled
        public String quotetype;
        @AuraEnabled
        public decimal totalNumberOfVehicles;
        @AuraEnabled
        public decimal totalNumberOfDrivers;
        @AuraEnabled
        public decimal totalNumberOfNannies;
        @AuraEnabled
        public decimal totalNumberOfAccountants;
        @AuraEnabled
        public decimal totalNumberOfCoordinators;
        @AuraEnabled
        public decimal totalNumberOfSupervisors;
        @AuraEnabled
        public decimal totalNumberOfOtherManpower;
        
    }
    
    public class vehicleApprovalDetails{
        @AuraEnabled
        public string element;
        @AuraEnabled
        public string requestedBy;
        @AuraEnabled
        public string approvedby;
        @AuraEnabled
        public string reason;
    }
}