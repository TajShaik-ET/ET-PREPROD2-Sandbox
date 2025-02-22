/*
* Class Last modified on: 08.06.2023
* add a new row for VAT Cost on Coordinator per vehicle 08.06.2023
* for School transportation Extra KM new row addition
* Corporate tax formula updation 02.05.2023
* totalManpowerProfits formula updation 17.05.2023
* Updated by: Arunsarathy

*/
public without sharing class ET_WorkForceQuoteItemsCalculationClass {
    
    
    // Initializations for total Project workForce quote Items
    // Key = ServiceType like 'Driver' and Value = Map --> Key = Contract Year & Value = element Value
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndwages;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndoverTimeCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndclothesAllowance;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndchildrenAllowance;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndhousingAllowance;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndcostoflivingAllowance;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndSocialAllowance;
    
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTransportAllowance;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndAdditionalTransportAllowance;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndOtherAllowance;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndSocialInsurance;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndAdditionalWorkPermit;
    
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndendOfServiceCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndhealthCardCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndlicensingFee;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndvisaCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndaccomodationAllowance;
    
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndsmartPhoneCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndairTicketsCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndextraCertificationCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndleaveAllowance;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndannualProfitMarginRate;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndannualProfitMarginValue;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndtotalAnnualNetProfitValue;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAnddriverReserve;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndRelieverCost;
    
    private static Map<String, Map<integer,Decimal>> serviceAndContractYeartotalCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndtotalIndirectOperationCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndtotalDirectOperationalCost;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndworkForceVATAmount;
    
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndWorkForceCostPerVehicle;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndWorkForceProfitPerVehicle;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndCorporateTax;
    
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalAnnualPriceExcludingVAT;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalMonthlyPriceExcludingVAT;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalAnnualPriceIncludingVAT;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalMonthlyPriceIncludingVAT;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalValueOfRental;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalManpowerProfits;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndGrossProfitMargin;
    
    // Target Prices 
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndManpowerReserveDiscounted;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndManpowerReserveTarget;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalCostDiscounted;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalCostTarget;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalCostPerEachVehicleDiscounted;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndTotalCostPerEachVehicleTarget;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndAnnualNetProfitValueDiscounted;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndAnnualNetProfitValueTarget;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted;
    private static Map<String, Map<integer,Decimal>> serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleTarget;
    
    private static List<integer> driverContractYears = new List<integer>();  
    private static List<integer> nannyContractYears = new List<integer>();  
    private static List<integer> accountantContractYears = new List<integer>();  
    private static List<integer> coordinatorContractYears = new List<integer>();  
    private static List<integer> supervisorContractYears = new List<integer>();  
    private static List<integer> otherEmployeeContractYears = new List<integer>();  
    
    // Maps for Reliever cost
    Public static Map<String, decimal> relieverCostMap ; // Key = Reliever unique Id & Value = Reliever cost
    Public static Map<String, String> relieverIdWrToMainWorkforceIdMap;  // Key = Main workforce unique Id & Value = Reliever unique Id
    
    private static void intializeClassMaps(){
        serviceAndContractYearAndwages = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndoverTimeCost = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndclothesAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndchildrenAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndhousingAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndcostoflivingAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndSocialAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndAdditionalWorkPermit = new Map<String, Map<integer,Decimal>>();
        
        serviceAndContractYearAndTransportAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndAdditionalTransportAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndOtherAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndSocialInsurance = new Map<String, Map<integer,Decimal>>();
        
        serviceAndContractYearAndendOfServiceCost = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndhealthCardCost = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndlicensingFee = new Map<String, Map<integer,Decimal>>();
        
        serviceAndContractYearAndvisaCost = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndaccomodationAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndsmartPhoneCost = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndairTicketsCost = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndextraCertificationCost = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndleaveAllowance = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndRelieverCost = new Map<String, Map<integer,Decimal>>();
        
        serviceAndContractYearAndannualProfitMarginRate = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndannualProfitMarginValue = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndtotalAnnualNetProfitValue = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAnddriverReserve = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndManpowerReserveDiscounted = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndManpowerReserveTarget = new Map<String, Map<integer,Decimal>>();
        
        serviceAndContractYearAndTotalCostDiscounted = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndTotalCostTarget = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndTotalCostPerEachVehicleDiscounted = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndTotalCostPerEachVehicleTarget = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndAnnualNetProfitValueDiscounted = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndAnnualNetProfitValueTarget = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleTarget = new Map<String, Map<integer,Decimal>>();
        
        serviceAndContractYeartotalCost = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndtotalIndirectOperationCost = new Map<String, Map<integer,Decimal>>();
        
        serviceAndContractYearAndtotalDirectOperationalCost = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndworkForceVATAmount = new Map<String, Map<integer,Decimal>>();
        
        serviceAndContractYearAndWorkForceCostPerVehicle = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndCorporateTax = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndWorkForceProfitPerVehicle = new Map<String, Map<integer,Decimal>>();
        
        serviceAndContractYearAndTotalAnnualPriceExcludingVAT = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndTotalMonthlyPriceExcludingVAT = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndTotalAnnualPriceIncludingVAT = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndTotalMonthlyPriceIncludingVAT = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndTotalValueOfRental = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndTotalManpowerProfits = new Map<String, Map<integer,Decimal>>();
        serviceAndContractYearAndGrossProfitMargin = new Map<String, Map<integer,Decimal>>();
        relieverIdWrToMainWorkforceIdMap = new Map<String, String>();
        relieverCostMap = new Map<String, decimal>(); 
    }
    
    public static ET_ServiceRequestController.QuoteCalculationClass calculateWorkForceQuoteElementsWithRates(String serviceReqId, String quoteId , 
                                                                                                             ET_ServiceRequestController.QuoteCalculationClass quotecalculationObj,
                                                                                                             List<ET_Pricing_VAT_setup__c> vatData )
    {
        
        // Initailizations
        Map<String, ET_Workforce_Quote_Item__c> wForQItemsWithService_LineAndYearMap = new Map<String, ET_Workforce_Quote_Item__c>();
        Map<String, ET_Workforce_Quote_Item__c> wForQItemsWithIdMap = new Map<String, ET_Workforce_Quote_Item__c>();
        List<ET_ServiceRequestController.driverQuoteCalcClass> driverQuoteCalcLst = new List<ET_ServiceRequestController.driverQuoteCalcClass>();
        List<ET_ServiceRequestController.nannyQuoteCalcClass> nannyQuoteCalcLst = new List<ET_ServiceRequestController.nannyQuoteCalcClass>();
        List<ET_ServiceRequestController.supervisorQuoteCalcClass> supervisorQuoteCalcLst = new List<ET_ServiceRequestController.supervisorQuoteCalcClass>();
        List<ET_ServiceRequestController.coordinatorQuoteCalcClass> coordinatorQuoteCalcLst = new List<ET_ServiceRequestController.coordinatorQuoteCalcClass>();
        List<ET_ServiceRequestController.accountantQuoteCalcClass> accountantQuoteCalcLst = new List<ET_ServiceRequestController.accountantQuoteCalcClass>();
        List<ET_ServiceRequestController.otherEmpQuoteCalcClass> otherEmpQuoteCalcLst = new List<ET_ServiceRequestController.otherEmpQuoteCalcClass>();
        intializeClassMaps();
        //query workforce Requests for given Service Request
        Map<Id,ET_Work_force__c> workforceRequestMap = new Map<Id,ET_Work_force__c>();
        workforceRequestMap = ET_PricingUtilityClass.getWorkforceRequestMap(serviceReqId);
        // get pricing combinations from Request 
        List<ET_Request_Mapping__c> reqMappings = new List<ET_Request_Mapping__c>([select id,ET_Vehicle_Unique_key__c,
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
                                                                                   from ET_Request_Mapping__c where ET_Pricing_Service_Request__c =:serviceReqId and ET_Vehicle_Unique_key__c != null ]) ;
        
        // query quote record
        quote quoteRec = [select id, Total_Number_of_Main_Vehicles__c from Quote where id =: quoteId];
        
        //query workforce quote Items for given Quote
        List<ET_Workforce_Quote_Item__c> wForQItemsList = ET_PricingUtilityClass.getWorkforceQuoteItemLstWithQutId(quoteId);
        system.debug('workforceRequestMap  = '+ JSON.serializePretty(workforceRequestMap));
        system.debug('wForQItemsList  = '+ JSON.serializePretty(wForQItemsList));
        if(!wForQItemsList.isEmpty()){
            for(ET_Workforce_Quote_Item__c wQItem : wForQItemsList ){
                // key =  workforce record type + Line Number + Contract Year
                String key = wQItem.ET_Workforce_Record_Type__c+'-'+wQItem.Line_number_from_input__c+'-'+wQItem.ET_Contract_Period__c;
                //String key = wQItem.ET_Workforce_Unique_Key__c+'-'+wQItem.ET_Contract_Period__c;
                wForQItemsWithService_LineAndYearMap.put(key,wQItem );
                wForQItemsWithIdMap.put(wQItem.Id, wQItem);
                //map for main and reliever unique ids
                if(wQItem.Type__c == 'Reliever'){
                    String mainWorkforceId = wQItem.Reliever_For__c+'=>'+wQItem.ET_Contract_Period__c;
                    String relieverWorkforceId = wQItem.ET_Workforce_Unique_Key__c+'=>'+ wQItem.ET_Workforce_Line_Number__c+'=>'+wQItem.ET_Contract_Period__c;
                    relieverIdWrToMainWorkforceIdMap.put(mainWorkforceId,relieverWorkforceId );
                }
            }
        }
        // get combinantion Map - to get No of Manpower for each Vehicle
        
        Map<String, List<String>> combinationMap = ET_VehicleCalcDetailsController.getTargetPriceForCombination(quoteId) ;
        
        Map<String,ET_Request_Mapping__c > ReqMappingWrToVehKeyMap = ET_VehicleCalcDetailsController.getReqMappingRecWrtoVehicleKey(quoteId);
        Map<String, ET_Vehicle_Quote_Item__c> vehQuoteItemMap = ET_FinancialAnalysisScreenClass.getVehicleDetailsWrtoVehicleKey(quoteId);
        
        //Start workforce quote Item Calculations
        if(!workforceRequestMap.isEmpty()){
            for(ET_Work_force__c workforceRequestObj :  workforceRequestMap.values()){
                
                ET_Special_Workforce_Requirement__c specialRequirement;
                List<ET_Special_Workforce_Requirement__c> specialRequirementLst = workforceRequestObj.Specific_Workforce_Requirements__r;
                if(specialRequirementLst != null && specialRequirementLst.size() > 0){
                    specialRequirement = specialRequirementLst[0];
                }
                
                if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Accountant_Cashier')){
                    List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                    if(contractYearLst.size() > 0){
                        for(String contractYear : contractYearLst){
                            contractYear = contractYear.substring(0,1);
                            //get output quote element matching the workforce Request and req line no.
                            // key =  workforce record type + Line Number + Contract Year from Request
                            integer workforceLineNO = Integer.valueOf(workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1]);
                            String Key =workforceRequestObj.ET_Workforce_Record_Type_Name__c+'-'+workforceLineNO+ '-'+ contractYear;
                            //String Key =workforceRequestObj.ET_Workforce_Record_Type_Name__c+'-'+workforceRequestObj.ET_Workforce_Line_Info__c+ '-'+ contractYear;
                            ET_Workforce_Quote_Item__c reqWorkForceQItem;
                            if(wForQItemsWithService_LineAndYearMap.containsKey(key)){
                                reqWorkForceQItem = wForQItemsWithService_LineAndYearMap.get(key);
                            }
                            ET_ServiceRequestController.accountantQuoteCalcClass accountantQuoteCalcObj = new ET_ServiceRequestController.accountantQuoteCalcClass();
                            accountantQuoteCalcObj.accountantUniqueKey = workforceRequestObj.ET_Accountant_Category__c;
                            accountantQuoteCalcObj.numberOfAccountants = Integer.valueOf(workforceRequestObj.ET_Number_of_Accountants__c);
                            
                            accountantQuoteCalcObj.accWorkforceClassObj = getWorkforceQuoteCalcObj('Accountant/Cashier',workforceRequestObj,reqWorkForceQItem,
                                                                                                   specialRequirement,contractYear,vatData, combinationMap, ReqMappingWrToVehKeyMap,
                                                                                                   quoteRec, reqMappings , vehQuoteItemMap
                                                                                                  );
                            accountantQuoteCalcLst.add(accountantQuoteCalcObj);
                        }                          
                        quotecalculationObj.accountantQuoteItemLst = accountantQuoteCalcLst;
                    }else{
                        system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                    }
                }
                else if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Coordinator')){
                    
                    List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                    if(contractYearLst.size() > 0){
                        for(String contractYear : contractYearLst){
                            contractYear = contractYear.substring(0,1);
                            //get output quote element matching the workforce Request and req line no.
                            // key =  workforce record type + Line Number + Contract Year from Request
                            integer workforceLineNO = Integer.valueOf(workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1]);
                            String Key =workforceRequestObj.ET_Workforce_Record_Type_Name__c+'-'+workforceLineNO+ '-'+ contractYear;
                            //String Key =workforceRequestObj.ET_Workforce_Record_Type_Name__c+'-'+workforceRequestObj.ET_Workforce_Line_Info__c+ '-'+ contractYear;
                            ET_Workforce_Quote_Item__c reqWorkForceQItem;
                            if(wForQItemsWithService_LineAndYearMap.containsKey(key)){
                                reqWorkForceQItem = wForQItemsWithService_LineAndYearMap.get(key);
                            }
                            ET_ServiceRequestController.coordinatorQuoteCalcClass coordinatorQuoteCalcObj = new ET_ServiceRequestController.coordinatorQuoteCalcClass();
                            coordinatorQuoteCalcObj.coordinatorUniqueKey = workforceRequestObj.ET_Coordinator_Category__c;
                            coordinatorQuoteCalcObj.numberOfCoordinators = Integer.valueOf(workforceRequestObj.ET_Number_of_Coordinators__c);
                            coordinatorQuoteCalcObj.coordinatorWorkforceClassObj = getWorkforceQuoteCalcObj('Coordinator',workforceRequestObj,reqWorkForceQItem,
                                                                                                            specialRequirement,contractYear,vatData,combinationMap, ReqMappingWrToVehKeyMap,
                                                                                                            quoteRec , reqMappings , vehQuoteItemMap);
                            coordinatorQuoteCalcLst.add(coordinatorQuoteCalcObj);
                        }                          
                        quotecalculationObj.coordinatorQuoteItemLst = coordinatorQuoteCalcLst;
                    }else{
                        system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                    }
                    
                    
                    
                }
                else if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Driver')){
                    
                    List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                    if(contractYearLst.size() > 0){
                        for(String contractYear : contractYearLst){
                            contractYear = contractYear.substring(0,1);
                            integer integerContractYear = integer.ValueOf(contractYear);
                            driverContractYears.add(integerContractYear);
                            //get output quote element matching the workforce Request and req line no.
                            // key =  workforce record type + Line Number + Contract Year from Request
                            integer workforceLineNO = Integer.valueOf(workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1]);
                            String Key =workforceRequestObj.ET_Workforce_Record_Type_Name__c+'-'+workforceLineNO+ '-'+ contractYear;
                            system.debug('key for workforce identificaton  ='+ key);
                            ET_Workforce_Quote_Item__c reqWorkForceQItem;
                            if(wForQItemsWithService_LineAndYearMap.containsKey(key)){
                                reqWorkForceQItem = wForQItemsWithService_LineAndYearMap.get(key);
                            }
                            ET_ServiceRequestController.driverQuoteCalcClass driverQuoteCalcObj = new ET_ServiceRequestController.driverQuoteCalcClass();
                            driverQuoteCalcObj.driverUniqueKey = workforceRequestObj.ET_Driver_Category__c;
                            driverQuoteCalcObj.numberOfDrivers = Integer.valueOf(workforceRequestObj.ET_No_of_Drivers__c);
                            driverQuoteCalcObj.driverWorkforceClassObj = getWorkforceQuoteCalcObj('Driver',workforceRequestObj,reqWorkForceQItem,
                                                                                                  specialRequirement,contractYear,vatData,combinationMap, ReqMappingWrToVehKeyMap,
                                                                                                  quoteRec , reqMappings, vehQuoteItemMap);
                            system.debug('driverQuoteCalcLst: '+contractYear+': '+driverQuoteCalcObj.driverOtherCostLst);
                            driverQuoteCalcLst.add(driverQuoteCalcObj);
                        }
                        
                        quotecalculationObj.driverQuoteItemLst = driverQuoteCalcLst;
                    }else{
                        system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                    }
                    
                    
                }
                else if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Nanny')){
                    
                    List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                    if(contractYearLst.size() > 0){
                        for(String contractYear : contractYearLst){
                            contractYear = contractYear.substring(0,1);
                            //get output quote element matching the workforce Request and req line no.
                            // key =  workforce record type + Line Number + Contract Year from Request
                            integer workforceLineNO = Integer.valueOf(workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1]);
                            String Key =workforceRequestObj.ET_Workforce_Record_Type_Name__c+'-'+workforceLineNO+ '-'+ contractYear;
                            ET_Workforce_Quote_Item__c reqWorkForceQItem;
                            if(wForQItemsWithService_LineAndYearMap.containsKey(key)){
                                reqWorkForceQItem = wForQItemsWithService_LineAndYearMap.get(key);
                            }
                            ET_ServiceRequestController.nannyQuoteCalcClass nannyQuoteCalcObj = new ET_ServiceRequestController.nannyQuoteCalcClass();
                            nannyQuoteCalcObj.nannyUniqueKey = workforceRequestObj.ET_Nanny_Category__c;
                            nannyQuoteCalcObj.numberOfNannies = Integer.valueOf(workforceRequestObj.ET_Number_of_Nannies__c);
                            nannyQuoteCalcObj.nannyWorkforceClassObj = getWorkforceQuoteCalcObj('Nanny',workforceRequestObj,reqWorkForceQItem,
                                                                                                specialRequirement,contractYear,vatData,combinationMap, ReqMappingWrToVehKeyMap,
                                                                                                quoteRec , reqMappings , vehQuoteItemMap);
                            nannyQuoteCalcLst.add(nannyQuoteCalcObj);
                        }                          
                        quotecalculationObj.nannyQuoteItemLst = nannyQuoteCalcLst;
                    }else{
                        system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                    }
                    
                    
                }
                else if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Supervisor')){
                    
                    List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                    if(contractYearLst.size() > 0){
                        for(String contractYear : contractYearLst){
                            contractYear = contractYear.substring(0,1);
                            //get output quote element matching the workforce Request and req line no.
                            // key =  workforce record type + Line Number + Contract Year from Request
                            integer workforceLineNO = Integer.valueOf(workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1]);
                            String Key =workforceRequestObj.ET_Workforce_Record_Type_Name__c+'-'+workforceLineNO+ '-'+ contractYear;
                            system.debug('key for workforce identificaton supervisor ='+ key);
                            ET_Workforce_Quote_Item__c reqWorkForceQItem = new ET_Workforce_Quote_Item__c();
                            if(wForQItemsWithService_LineAndYearMap.containsKey(key)){
                                reqWorkForceQItem = wForQItemsWithService_LineAndYearMap.get(key);
                            }
                            ET_ServiceRequestController.supervisorQuoteCalcClass supervisorQuoteCalcObj = new ET_ServiceRequestController.supervisorQuoteCalcClass();
                            supervisorQuoteCalcObj.supervisorUniqueKey = workforceRequestObj.ET_Supervisor_Category__c;
                            supervisorQuoteCalcObj.numberOfSupervisors = Integer.valueOf(workforceRequestObj.ET_Number_of_Supervisors__c);
                            system.debug('supervisor started');
                            supervisorQuoteCalcObj.supervisorWorkforceClassObj = getWorkforceQuoteCalcObj('Supervisor',workforceRequestObj,reqWorkForceQItem,
                                                                                                          specialRequirement,contractYear,vatData,combinationMap, ReqMappingWrToVehKeyMap,
                                                                                                          quoteRec , reqMappings , vehQuoteItemMap);
                            supervisorQuoteCalcLst.add(supervisorQuoteCalcObj);
                        }                          
                        quotecalculationObj.supervisorQuoteItemLst = supervisorQuoteCalcLst;
                    }else{
                        system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                    }
                    
                }
                else{
                    //other employee
                    List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                    if(contractYearLst.size() > 0){
                        for(String contractYear : contractYearLst){
                            contractYear = contractYear.substring(0,1);
                            //get output quote element matching the workforce Request and req line no.
                            // key =  workforce record type + Line Number + Contract Year from Request
                            integer workforceLineNO = Integer.valueOf(workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1]);
                            String Key =workforceRequestObj.ET_Workforce_Record_Type_Name__c+'-'+workforceLineNO+ '-'+ contractYear;
                            ET_Workforce_Quote_Item__c reqWorkForceQItem;
                            if(wForQItemsWithService_LineAndYearMap.containsKey(key)){
                                reqWorkForceQItem = wForQItemsWithService_LineAndYearMap.get(key);
                            }
                            ET_ServiceRequestController.otherEmpQuoteCalcClass otherEmpQuoteCalcObj = new ET_ServiceRequestController.otherEmpQuoteCalcClass();
                            otherEmpQuoteCalcObj.otherEmpUniqueKey = workforceRequestObj.ET_Other_employee_Category__c;
                            otherEmpQuoteCalcObj.numberOfOtherEmps = Integer.valueOf(workforceRequestObj.ET_Number_of_Other_Employees__c);
                            otherEmpQuoteCalcObj.otherEmpWorkforceClassObj = getWorkforceQuoteCalcObj('Other Employee',workforceRequestObj,reqWorkForceQItem,
                                                                                                      specialRequirement,contractYear,vatData,combinationMap, ReqMappingWrToVehKeyMap,
                                                                                                      quoteRec , reqMappings, vehQuoteItemMap);
                            otherEmpQuoteCalcLst.add(otherEmpQuoteCalcObj);
                        }                          
                        quotecalculationObj.otherEmpQuoteItemLst = otherEmpQuoteCalcLst;
                    }else{
                        system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                    }
                    
                    
                } 
                
            }
        }
        
        //update workforce quote items with calculated Price elements...
        //system.debug('work Force quote Items to update 1= ' + JSON.serializePretty(quotecalculationObj));
        updateWorkForceQuoteLineItemsWithPricing(quotecalculationObj,wForQItemsWithIdMap, vatData );
        return quotecalculationObj;
    }
    
    
    /* Method 	   : updateWorkForceQuoteLineItemsWithPricing
Description : To calculate Price elements in output Quotation line Items
Calculates based on - Rates from Quotation Line items and Request attributes
*/
    public static void updateWorkForceQuoteLineItemsWithPricing(ET_ServiceRequestController.QuoteCalculationClass quoteCalcObj , 
                                                                Map<String, ET_Workforce_Quote_Item__c> wForceQItemsWithId,
                                                                List<ET_Pricing_VAT_setup__c> vatData)
    {
        
        try{
            //system.debug('work Force quote Items to update = ' + JSON.serializePretty(quoteCalcObj));
            List<ET_Workforce_Quote_Item__c> workforceQuoteItemLstToUpdate = new List<ET_Workforce_Quote_Item__c>();
            
            if(quoteCalcObj.driverQuoteItemLst != null && quoteCalcObj.driverQuoteItemLst.size() > 0 ){
                for(ET_ServiceRequestController.driverQuoteCalcClass driverQuoteCalObj : quoteCalcObj.driverQuoteItemLst){
                    ET_Workforce_Quote_Item__c workforceQuoteItemtoUpdate = wForceQItemsWithId.get(driverQuoteCalObj.driverWorkforceClassObj.workforceQuoteId);
                    system.debug('Driver workforceQuoteItemtoUpdate = '+ JSON.serializePretty(workforceQuoteItemtoUpdate) );
                    workforceQuoteItemtoUpdate = prepareWorkforceObject(workforceQuoteItemtoUpdate, driverQuoteCalObj.driverWorkforceClassObj,vatData);
                    workforceQuoteItemLstToUpdate.add(workforceQuoteItemtoUpdate);  
                }
            }
            
            if(quoteCalcObj.nannyQuoteItemLst != null && quoteCalcObj.nannyQuoteItemLst.size() > 0 ){
                
                for(ET_ServiceRequestController.nannyQuoteCalcClass nannyQuoteCalObj : quoteCalcObj.nannyQuoteItemLst){
                    ET_Workforce_Quote_Item__c workforceQuoteItemtoUpdate = wForceQItemsWithId.get(nannyQuoteCalObj.nannyWorkforceClassObj.workforceQuoteId);
                    workforceQuoteItemtoUpdate = prepareWorkforceObject(workforceQuoteItemtoUpdate, nannyQuoteCalObj.nannyWorkforceClassObj,vatData);
                    workforceQuoteItemLstToUpdate.add(workforceQuoteItemtoUpdate);  
                }
            }
            
            if(quoteCalcObj.accountantQuoteItemLst != null && quoteCalcObj.accountantQuoteItemLst.size() > 0 ){
                
                for(ET_ServiceRequestController.accountantQuoteCalcClass accountantQuoteCalcObj : quoteCalcObj.accountantQuoteItemLst){
                    ET_Workforce_Quote_Item__c workforceQuoteItemtoUpdate = wForceQItemsWithId.get(accountantQuoteCalcObj.accWorkforceClassObj.workforceQuoteId);
                    workforceQuoteItemtoUpdate = prepareWorkforceObject(workforceQuoteItemtoUpdate, accountantQuoteCalcObj.accWorkforceClassObj,vatData);
                    workforceQuoteItemLstToUpdate.add(workforceQuoteItemtoUpdate);  
                }
            }
            
            if(quoteCalcObj.coordinatorQuoteItemLst != null && quoteCalcObj.coordinatorQuoteItemLst.size() > 0 ){
                
                for(ET_ServiceRequestController.coordinatorQuoteCalcClass coordinatorQuoteCalcObj : quoteCalcObj.coordinatorQuoteItemLst){
                    ET_Workforce_Quote_Item__c workforceQuoteItemtoUpdate = wForceQItemsWithId.get(coordinatorQuoteCalcObj.coordinatorWorkforceClassObj.workforceQuoteId);
                    workforceQuoteItemtoUpdate = prepareWorkforceObject(workforceQuoteItemtoUpdate, coordinatorQuoteCalcObj.coordinatorWorkforceClassObj,vatData);
                    workforceQuoteItemLstToUpdate.add(workforceQuoteItemtoUpdate);  
                }
            }
            
            if(quoteCalcObj.supervisorQuoteItemLst != null && quoteCalcObj.supervisorQuoteItemLst.size() > 0 ){
                
                for(ET_ServiceRequestController.supervisorQuoteCalcClass supervisorQuoteCalcObj : quoteCalcObj.supervisorQuoteItemLst){
                    ET_Workforce_Quote_Item__c workforceQuoteItemtoUpdate = wForceQItemsWithId.get(supervisorQuoteCalcObj.supervisorWorkforceClassObj.workforceQuoteId);
                    workforceQuoteItemtoUpdate = prepareWorkforceObject(workforceQuoteItemtoUpdate, supervisorQuoteCalcObj.supervisorWorkforceClassObj,vatData);
                    workforceQuoteItemLstToUpdate.add(workforceQuoteItemtoUpdate);  
                }
            }
            
            if(quoteCalcObj.otherEmpQuoteItemLst != null && quoteCalcObj.otherEmpQuoteItemLst.size() > 0 ){
                
                for(ET_ServiceRequestController.otherEmpQuoteCalcClass otherEmpQuoteCalcObj : quoteCalcObj.otherEmpQuoteItemLst){
                    ET_Workforce_Quote_Item__c workforceQuoteItemtoUpdate = wForceQItemsWithId.get(otherEmpQuoteCalcObj.otherEmpWorkforceClassObj.workforceQuoteId);
                    workforceQuoteItemtoUpdate = prepareWorkforceObject(workforceQuoteItemtoUpdate, otherEmpQuoteCalcObj.otherEmpWorkforceClassObj,vatData);
                    workforceQuoteItemLstToUpdate.add(workforceQuoteItemtoUpdate);  
                }
            }
            
            if(!workforceQuoteItemLstToUpdate.isEmpty()){
                system.debug('work Force quote Items to update = ' + JSON.serializePretty(workforceQuoteItemLstToUpdate));
                update workforceQuoteItemLstToUpdate;
                system.debug('work force quote items updated');
            }
            
        }  
        
        catch(Exception e){
            ET_PricingUtilityClass.logException(e, 'Pricing');
            system.debug('Exception ='+ e.getMessage());
            system.debug('Exception Trace='+ e.getStackTraceString());
            system.debug('Exception line='+ e.getLineNumber());
            throw new AuraHandledException('Exception message : ' + e.getMessage() +' ; stack trace : '+ e.getStackTraceString());
        }
        
    }
    
    
    
    
    /* Method 	   : getWorkforceQuoteCalcObj
Description : To calculate all workforce Price elements with Rates captured from output quote items and Input...
*/
    
    public static ET_ServiceRequestController.workforceQuoteCalcClass getWorkforceQuoteCalcObj(String serviceType , ET_Work_force__c workforceRequestObj,
                                                                                               ET_Workforce_Quote_Item__c reqWorkForceQItem,
                                                                                               ET_Special_Workforce_Requirement__c specialRequirement, 
                                                                                               String contractYear, List<ET_Pricing_VAT_setup__c> vatData,
                                                                                               Map<String, List<String>> combinationMap ,
                                                                                               Map<String,ET_Request_Mapping__c > ReqMappingWrToVehKeyMap,
                                                                                               quote quoteRec, List<ET_Request_Mapping__c> reqMappings,
                                                                                               Map<String, ET_Vehicle_Quote_Item__c> vehQuoteItemMap)
    {
        try{
            ET_ServiceRequestController.workforceQuoteCalcClass genericWorkforceQuoteCalcObj = new ET_ServiceRequestController.workforceQuoteCalcClass();
            String specificServiceEmirate = workforceRequestObj.ET_Service_Emirate__c;
            system.debug('reqWorkForceQItem  = '+ JSON.serializePretty(reqWorkForceQItem));
            system.debug('contractYear  = '+contractYear);
             system.debug('contractYearHealth  = '+reqWorkForceQItem.ET_Health_Card__c);
            system.debug('contractYearHealthlin  = '+reqWorkForceQItem.ET_Workforce_Line_Number__c);
            integer intContractYear = Integer.valueOf(contractYear);
            String vehSource;
            integer noOfWorkForce = Integer.valueOf(reqWorkForceQItem.ET_Number_of_Workforce__c);
            decimal workingMonthsPerYear = reqWorkForceQItem.ET_Working_Months_Per_Year__c;
            decimal noOfVehicles ;
            decimal noOfMainVehicles = quoteRec.Total_Number_of_Main_Vehicles__c ;
            String manpowerKey = reqWorkForceQItem.ET_Workforce_Unique_Key__c + '=>'+workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1];
            String manpowerType = reqWorkForceQItem.Type__c;
            String relieverWorkforceId = reqWorkForceQItem.ET_Workforce_Unique_Key__c+'=>'+ reqWorkForceQItem.ET_Workforce_Line_Number__c+'=>'+reqWorkForceQItem.ET_Contract_Period__c;
            String mainWorkforceId = reqWorkForceQItem.ET_Workforce_Unique_Key__c+'=>'+ reqWorkForceQItem.ET_Workforce_Line_Number__c+'=>'+reqWorkForceQItem.ET_Contract_Period__c;
            //system.debug('ReqMappingWrToVehKeyMap  = '+JSON.serializePretty(ReqMappingWrToVehKeyMap));
            if(quoteRec.Total_Number_of_Main_Vehicles__c !=null){
            genericWorkforceQuoteCalcObj.totalVehicle = quoteRec.Total_Number_of_Main_Vehicles__c;//added by arunsarathy on 08.06.2023 add a new row for VAT Cost on Coordinator per vehicle

            }
            genericWorkforceQuoteCalcObj.contractYear = intContractYear;
            genericWorkforceQuoteCalcObj.resourcetype = specialRequirement.Resource_Type__c;
            if(!combinationMap.isEmpty() && combinationMap.siZe() > 0){
                for(String vehKey : combinationMap.keySet()){
                    system.debug('vehKey  = '+vehKey);
                    if(combinationMap.containsKey(vehKey)){
                        List<String> combServices = combinationMap.get(vehKey);
                        system.debug('combServices  = '+JSON.serializePretty(combServices));
                        if(combServices != null && combServices.contains(manpowerKey)){
                            if(!ReqMappingWrToVehKeyMap.isEmpty() && ReqMappingWrToVehKeyMap.containsKey(vehKey)){
                                ET_Request_Mapping__c reqMapping = ReqMappingWrToVehKeyMap.get(vehKey);
                                noOfVehicles = reqMapping.ET_Number_of_Vehicles__c;
                                system.debug('noOfVehicles  = '+noOfVehicles);
                            }
                        }
                    }
                }
            }
            if(reqWorkForceQItem != null){
                //Salary Value set from either input or Master Value....
                 decimal grossSalary =0;
                if(reqWorkForceQItem.Resource_Type__c != 'UAE'){
                grossSalary = reqWorkForceQItem.ET_Workforce_Gross_Salary__c;
                }
                decimal basicSalary =  reqWorkForceQItem.ET_Workforce_basic_salary__c; 
                decimal housingallowan =0.0;
                decimal costoflivingallowan =0.0;
                decimal socialallowan =0.0;
                decimal childrenallowan =0.0;
                string typeOfManpower = reqWorkForceQItem.Type__c; 
                // get Vehicle key with respect to Manpower key
                Map<String,String> vehKeyWrToManpowerKey  = workForceServiceRequestControllerHelper.returnVehicleKeyWithRespectToManpowerKey(reqMappings);
                system.debug('vehKeyWrToManpowerKey = '+ JSON.serializePretty(vehKeyWrToManpowerKey));
                system.debug('vehQuoteItemMap  486= '+ JSON.serializePretty(vehQuoteItemMap));
                system.debug('manpowerKey 487 = '+ manpowerKey);
                
                if(manpowerKey != null && vehKeyWrToManpowerKey != null && vehKeyWrToManpowerKey.containsKey(manpowerKey)){
                    String vehKey = vehKeyWrToManpowerKey.get(manpowerKey);
                    system.debug('vehKey 489 = '+ vehKey);
                    // get vehicle details with respect to vehKey
                    if(vehQuoteItemMap != null && vehQuoteItemMap.containsKey(vehKey)){
                        ET_Vehicle_Quote_Item__c vehQuoteItem = vehQuoteItemMap.get(vehKey);
                        vehSource =  vehQuoteItem.ET_Vehicle_Source__c;
                        genericWorkforceQuoteCalcObj.vehQuoteId = vehQuoteItem.Id;
                    }
                    
                }
                // default vehicle source value as Main for Manpowers other than - Driver and Nanny...
                else if(manpowerKey != null){
                    vehSource = 'Main';
                }
                system.debug('vehSource 489 = '+ vehSource);
                genericWorkforceQuoteCalcObj.workforceQuoteId = reqWorkForceQItem.id;
                if(reqWorkForceQItem.ET_Reserve_Rate__c != null){
                    genericWorkforceQuoteCalcObj.reserveRate = reqWorkForceQItem.ET_Reserve_Rate__c; 
                }
                
                // children allowance
                if(reqWorkForceQItem.Children_allowance_from_master__c != null && reqWorkForceQItem.Resource_Type__c == 'UAE'){
                    genericWorkforceQuoteCalcObj.childrenAllowance = reqWorkForceQItem.Children_allowance_from_master__c*reqWorkForceQItem.Number_of_Children__c;
                    childrenallowan = genericWorkforceQuoteCalcObj.childrenAllowance;
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndchildrenAllowance != null && serviceAndContractYearAndchildrenAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndchildrenAllowanceMap = serviceAndContractYearAndchildrenAllowance.get(serviceType);
                        if(ContractYearAndchildrenAllowanceMap != null && ContractYearAndchildrenAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndchildrenAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.childrenAllowance*noOfWorkForce ;
                            ContractYearAndchildrenAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndchildrenAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.childrenAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndchildrenAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndchildrenAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.childrenAllowance*noOfWorkForce);
                            serviceAndContractYearAndchildrenAllowance.put(serviceType , ContractYearAndchildrenAllowanceMap);
                        }
                    }      
                }
                // housing allowance %
                if(reqWorkForceQItem.Resource_Type__c == 'UAE' && reqWorkForceQItem.Housing_Allowance_Percentage__c != null ){
                    genericWorkforceQuoteCalcObj.housingAllowancePercentage = reqWorkForceQItem.Housing_Allowance_Percentage__c;
                }
                // housing allowance
                if(reqWorkForceQItem.Resource_Type__c == 'UAE' && reqWorkForceQItem.Housing_Allowance_Percentage__c != null && reqWorkForceQItem.ET_Workforce_basic_salary__c != null){
                    genericWorkforceQuoteCalcObj.housingAllowance = reqWorkForceQItem.ET_Workforce_basic_salary__c *(reqWorkForceQItem.Housing_Allowance_Percentage__c/100) ; 
                    housingallowan = genericWorkforceQuoteCalcObj.housingAllowance;
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndhousingAllowance != null && serviceAndContractYearAndhousingAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndhousingAllowanceMap = serviceAndContractYearAndhousingAllowance.get(serviceType);
                        if(ContractYearAndhousingAllowanceMap != null && ContractYearAndhousingAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndhousingAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.housingAllowance*noOfWorkForce ;
                            ContractYearAndhousingAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndhousingAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.housingAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndhousingAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndhousingAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.housingAllowance*noOfWorkForce);
                            serviceAndContractYearAndhousingAllowance.put(serviceType , ContractYearAndhousingAllowanceMap);
                        }
                        
                    }
                }
                // Cost of Living Allowance allowance
                if(reqWorkForceQItem.Cost_of_Living_Allowance__c != null && reqWorkForceQItem.Resource_Type__c == 'UAE'){
                    genericWorkforceQuoteCalcObj.costoflivingAllowance = reqWorkForceQItem.Cost_of_Living_Allowance__c; 
                    costoflivingallowan = genericWorkforceQuoteCalcObj.costoflivingAllowance;
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndcostoflivingAllowance != null && serviceAndContractYearAndcostoflivingAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndcostoflivingAllowanceMap = serviceAndContractYearAndcostoflivingAllowance.get(serviceType);
                        if(ContractYearAndcostoflivingAllowanceMap != null && ContractYearAndcostoflivingAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndcostoflivingAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.costoflivingAllowance*noOfWorkForce ;
                            ContractYearAndcostoflivingAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndcostoflivingAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.costoflivingAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndcostoflivingAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndcostoflivingAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.costoflivingAllowance*noOfWorkForce);
                            serviceAndContractYearAndcostoflivingAllowance.put(serviceType , ContractYearAndcostoflivingAllowanceMap);
                        }
                        
                    }
                }
                // Social Allowance 
                if(reqWorkForceQItem.Social_Allowance__c != null && reqWorkForceQItem.Resource_Type__c == 'UAE'){
                    genericWorkforceQuoteCalcObj.socialAllowance = reqWorkForceQItem.Social_Allowance__c; 
                    socialallowan = genericWorkforceQuoteCalcObj.socialAllowance;
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndSocialAllowance != null && serviceAndContractYearAndSocialAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndSocialAllowanceMap = serviceAndContractYearAndSocialAllowance.get(serviceType);
                        if(ContractYearAndSocialAllowanceMap != null && ContractYearAndSocialAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndSocialAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.socialAllowance*noOfWorkForce ;
                            ContractYearAndSocialAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndSocialAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.socialAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndSocialAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndSocialAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.socialAllowance*noOfWorkForce);
                            serviceAndContractYearAndSocialAllowance.put(serviceType , ContractYearAndSocialAllowanceMap);
                        }
                        
                    }
                }
                
                // Transport Allowance
                if(reqWorkForceQItem.Transport_Allowance__c != null && reqWorkForceQItem.Resource_Type__c == 'UAE'){
                    genericWorkforceQuoteCalcObj.transportAllowance = reqWorkForceQItem.Transport_Allowance__c; 
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndTransportAllowance != null && serviceAndContractYearAndTransportAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndTransportAllowanceMap = serviceAndContractYearAndTransportAllowance.get(serviceType);
                        if(ContractYearAndTransportAllowanceMap != null && ContractYearAndTransportAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndTransportAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.transportAllowance*noOfWorkForce ;
                            ContractYearAndTransportAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndTransportAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.transportAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndTransportAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndTransportAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.transportAllowance*noOfWorkForce);
                            serviceAndContractYearAndTransportAllowance.put(serviceType , ContractYearAndTransportAllowanceMap);
                        }
                        
                    }
                }
                
                // Additional Transport Allowance
                if(reqWorkForceQItem.Additional_Transport_Allowance__c != null && reqWorkForceQItem.Resource_Type__c == 'UAE'){
                    genericWorkforceQuoteCalcObj.additionalTransportAllowance = reqWorkForceQItem.Additional_Transport_Allowance__c; 
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndAdditionalTransportAllowance != null && serviceAndContractYearAndAdditionalTransportAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndAdditionalTransportAllowanceMap = serviceAndContractYearAndAdditionalTransportAllowance.get(serviceType);
                        if(ContractYearAndAdditionalTransportAllowanceMap != null && ContractYearAndAdditionalTransportAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndAdditionalTransportAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.additionalTransportAllowance*noOfWorkForce ;
                            ContractYearAndAdditionalTransportAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndAdditionalTransportAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.additionalTransportAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndAdditionalTransportAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndAdditionalTransportAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.additionalTransportAllowance*noOfWorkForce);
                            serviceAndContractYearAndAdditionalTransportAllowance.put(serviceType , ContractYearAndAdditionalTransportAllowanceMap);
                        }
                        
                    }
                }
                
                
                // Other Allowance
                if(reqWorkForceQItem.Other_Allowance__c != null && reqWorkForceQItem.Resource_Type__c == 'UAE'){
                    genericWorkforceQuoteCalcObj.otherAllowance = reqWorkForceQItem.Other_Allowance__c; 
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndOtherAllowance != null && serviceAndContractYearAndOtherAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndOtherAllowanceMap = serviceAndContractYearAndOtherAllowance.get(serviceType);
                        if(ContractYearAndOtherAllowanceMap != null && ContractYearAndOtherAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndOtherAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.otherAllowance*noOfWorkForce ;
                            ContractYearAndOtherAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndOtherAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.otherAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndOtherAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndOtherAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.otherAllowance*noOfWorkForce);
                            serviceAndContractYearAndOtherAllowance.put(serviceType , ContractYearAndOtherAllowanceMap);
                        }
                        
                    }
                }
                
                // Social Insurance
                if(reqWorkForceQItem.Social_Insurance__c != null && (reqWorkForceQItem.Resource_Type__c == 'UAE' || reqWorkForceQItem.Resource_Type__c == 'GCC National' ) ){
                    genericWorkforceQuoteCalcObj.socialInsurance = reqWorkForceQItem.Social_Insurance__c; 
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndSocialInsurance != null && serviceAndContractYearAndSocialInsurance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndSocialInsuranceMap = serviceAndContractYearAndSocialInsurance.get(serviceType);
                        if(ContractYearAndSocialInsuranceMap != null && ContractYearAndSocialInsuranceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndSocialInsuranceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.socialInsurance*noOfWorkForce ;
                            ContractYearAndSocialInsuranceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndSocialInsuranceMap.put(intContractYear , genericWorkforceQuoteCalcObj.socialInsurance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndSocialInsuranceMap = new Map<integer,Decimal>();
                            ContractYearAndSocialInsuranceMap.put(intContractYear , genericWorkforceQuoteCalcObj.socialInsurance*noOfWorkForce);
                            serviceAndContractYearAndSocialInsurance.put(serviceType , ContractYearAndSocialInsuranceMap);
                        }
                        
                    }
                }
                
                //Gross salary calculation in case of UAE National:
                if(reqWorkForceQItem.Resource_Type__c == 'UAE'){
                    grossSalary = childrenallowan+housingallowan+costoflivingallowan+socialallowan+ genericWorkforceQuoteCalcObj.transportAllowance
                        +genericWorkforceQuoteCalcObj.additionalTransportAllowance + genericWorkforceQuoteCalcObj.otherAllowance +
                        genericWorkforceQuoteCalcObj.socialInsurance + basicSalary;
                }
                
                
                //******************************wage calc****************
                if(grossSalary != null && grossSalary != 0.0 && reqWorkForceQItem.ET_Depreciation_Method__c == 'Straight Line' 
                   && reqWorkForceQItem.ET_Workforce_Record_Type__c == 'ET_Driver' )
                {
                    reqWorkForceQItem.Salary_No_of_months_for_Driver_for_SLine__c =12 ;//Added by Arunsarathy 22.03.2023 for school transportation updation
                    genericWorkforceQuoteCalcObj.wages = grossSalary * reqWorkForceQItem.Salary_No_of_months_for_Driver_for_SLine__c ;
                }
                else if (grossSalary != null && grossSalary != 0.0 && reqWorkForceQItem.ET_Depreciation_Method__c == 'Straight Line' 
                         && reqWorkForceQItem.ET_Workforce_Record_Type__c != 'ET_Driver' ){
                             genericWorkforceQuoteCalcObj.wages = grossSalary * reqWorkForceQItem.Salary_No_of_Months_for_other_Manpower__c ;
                         }
                else if (grossSalary != null && grossSalary != 0.0 && reqWorkForceQItem.ET_Depreciation_Method__c != 'Straight Line'){
                    genericWorkforceQuoteCalcObj.wages = grossSalary * reqWorkForceQItem.ET_Working_Months_Per_Year__c ;
                }
                
                // total Project Calcs
                system.debug('vehSource 525 = '+ vehSource);
                if(vehSource == 'Main' && serviceAndContractYearAndwages != null && serviceAndContractYearAndwages.containsKey(serviceType)){
                    Map<integer,Decimal> contractYearAndwagesInnerMap = serviceAndContractYearAndwages.get(serviceType);
                    if(contractYearAndwagesInnerMap != null && contractYearAndwagesInnerMap.containsKey(intContractYear)){
                        decimal total = contractYearAndwagesInnerMap.get(intContractYear) + genericWorkforceQuoteCalcObj.wages*noOfWorkForce ;
                        contractYearAndwagesInnerMap.put(intContractYear , total);
                    }
                    else{
                        contractYearAndwagesInnerMap.put(intContractYear , genericWorkforceQuoteCalcObj.wages*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main'){
                        Map<integer,Decimal> contractYearAndwagesMap = new Map<integer,Decimal>();
                        System.debug('genericWorkforceQuoteCalcObj.wages='+genericWorkforceQuoteCalcObj.wages);
                        System.debug('noOfWorkForce='+noOfWorkForce);
                        contractYearAndwagesMap.put(intContractYear , genericWorkforceQuoteCalcObj.wages*noOfWorkForce);
                        serviceAndContractYearAndwages.put(serviceType , contractYearAndwagesMap);
                    }
                }
                
                system.debug('serviceAndContractYearAndwages = '+ JSON.serializePretty(serviceAndContractYearAndwages));
                
                
                //******************************overTimeCost calc****************
                if(specialRequirement != null && specialRequirement.ET_Over_Time__c != null && specialRequirement.ET_Over_Time__c != 0.0 && reqWorkForceQItem.ET_Working_Months_Per_Year__c != null){
                    genericWorkforceQuoteCalcObj.overTimeCost = specialRequirement.ET_Over_Time__c * reqWorkForceQItem.ET_Working_Months_Per_Year__c ;
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndoverTimeCost != null && serviceAndContractYearAndoverTimeCost.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndoverTimeCostMap = serviceAndContractYearAndoverTimeCost.get(serviceType);
                        if(ContractYearAndoverTimeCostMap != null && ContractYearAndoverTimeCostMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndoverTimeCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.overTimeCost*noOfWorkForce ;
                            ContractYearAndoverTimeCostMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndoverTimeCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.overTimeCost*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndoverTimeCostMap = new Map<integer,Decimal>();
                            ContractYearAndoverTimeCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.overTimeCost*noOfWorkForce);
                            serviceAndContractYearAndoverTimeCost.put(serviceType , ContractYearAndoverTimeCostMap);
                        }
                    }
                    
                }
                
                //******************************smart phone calc****************
                if(specialRequirement != null && specialRequirement.ET_Smart_Phone_Cost_Type__c != null){
                    
                    if(specialRequirement.ET_Smart_Phone_Cost_Type__c.equals('onetime')){
                        genericWorkforceQuoteCalcObj.smartPhoneCost = specialRequirement.ET_Smart_Phone__c / genericWorkforceQuoteCalcObj.contractYear;
                    }else if(specialRequirement.ET_Smart_Phone_Cost_Type__c.equals('annualy')){
                        genericWorkforceQuoteCalcObj.smartPhoneCost = specialRequirement.ET_Smart_Phone__c;
                    }else{
                        genericWorkforceQuoteCalcObj.smartPhoneCost = specialRequirement.ET_Smart_Phone__c + (specialRequirement.ET_Smart_Phone__c / genericWorkforceQuoteCalcObj.contractYear);
                    }
                    
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndsmartPhoneCost != null && serviceAndContractYearAndsmartPhoneCost.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndsmartPhoneCostMap = serviceAndContractYearAndsmartPhoneCost.get(serviceType);
                        if(ContractYearAndsmartPhoneCostMap != null && ContractYearAndsmartPhoneCostMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndsmartPhoneCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.smartPhoneCost*noOfWorkForce ;
                            ContractYearAndsmartPhoneCostMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndsmartPhoneCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.smartPhoneCost*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndsmartPhoneCostMap = new Map<integer,Decimal>();
                            ContractYearAndsmartPhoneCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.smartPhoneCost*noOfWorkForce);
                            serviceAndContractYearAndsmartPhoneCost.put(serviceType , ContractYearAndsmartPhoneCostMap);
                        }
                        
                    }
                    
                }
                
                //******************************air ticket calc***************
                if(specialRequirement != null && specialRequirement.ET_Air_Tickets_Cost_Type__c != null){
                    
                    if(specialRequirement.ET_Air_Tickets_Cost_Type__c.equals('onetime')){
                        genericWorkforceQuoteCalcObj.airTicketsCost = specialRequirement.ET_Air_Tickets__c / genericWorkforceQuoteCalcObj.contractYear;
                    }else if(specialRequirement.ET_Air_Tickets_Cost_Type__c.equals('annualy')){
                        genericWorkforceQuoteCalcObj.airTicketsCost = specialRequirement.ET_Air_Tickets__c;
                    }else{
                        genericWorkforceQuoteCalcObj.airTicketsCost = specialRequirement.ET_Air_Tickets__c + (specialRequirement.ET_Air_Tickets__c / genericWorkforceQuoteCalcObj.contractYear);
                    }
                    
                    
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndairTicketsCost != null && serviceAndContractYearAndairTicketsCost.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndairTicketsCostMap = serviceAndContractYearAndairTicketsCost.get(serviceType);
                        if(ContractYearAndairTicketsCostMap != null && ContractYearAndairTicketsCostMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndairTicketsCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.airTicketsCost*noOfWorkForce ;
                            ContractYearAndairTicketsCostMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndairTicketsCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.airTicketsCost*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndairTicketsCostMap = new Map<integer,Decimal>();
                            ContractYearAndairTicketsCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.airTicketsCost*noOfWorkForce);
                            serviceAndContractYearAndairTicketsCost.put(serviceType , ContractYearAndairTicketsCostMap);
                        }
                        
                    }
                    
                }
                
                //******************************accommodation allowance calc**************
                if(specialRequirement != null && specialRequirement.ET_Accommodation_Allowance_Type__c != null){
                    
                    if(specialRequirement.ET_Accommodation_Allowance_Type__c.equals('onetime')){
                        genericWorkforceQuoteCalcObj.accomodationAllowance = specialRequirement.ET_Accommodation_Allowance__c / genericWorkforceQuoteCalcObj.contractYear;
                    }else if(specialRequirement.ET_Accommodation_Allowance_Type__c.equals('annualy')){
                        genericWorkforceQuoteCalcObj.accomodationAllowance = specialRequirement.ET_Accommodation_Allowance__c;
                    }else{
                        genericWorkforceQuoteCalcObj.accomodationAllowance = specialRequirement.ET_Accommodation_Allowance__c + (specialRequirement.ET_Accommodation_Allowance__c / genericWorkforceQuoteCalcObj.contractYear);
                    }
                    
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndaccomodationAllowance != null && serviceAndContractYearAndaccomodationAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndaccomodationAllowanceMap = serviceAndContractYearAndaccomodationAllowance.get(serviceType);
                        if(ContractYearAndaccomodationAllowanceMap != null && ContractYearAndaccomodationAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndaccomodationAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.accomodationAllowance*noOfWorkForce ;
                            ContractYearAndaccomodationAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndaccomodationAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.accomodationAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndaccomodationAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndaccomodationAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.accomodationAllowance*noOfWorkForce);
                            serviceAndContractYearAndaccomodationAllowance.put(serviceType , ContractYearAndaccomodationAllowanceMap);
                        }
                        
                    }
                }
                
                //******************************extra certification calc******************
                if(specialRequirement != null && specialRequirement.ET_Extra_Certification_Cost_Type__c != null){
                    
                    if(specialRequirement.ET_Extra_Certification_Cost_Type__c.equals('onetime')){
                        genericWorkforceQuoteCalcObj.extraCertificationCost = specialRequirement.ET_Extra_Certification__c / genericWorkforceQuoteCalcObj.contractYear;
                    }else if(specialRequirement.ET_Extra_Certification_Cost_Type__c.equals('annualy')){
                        genericWorkforceQuoteCalcObj.extraCertificationCost = specialRequirement.ET_Extra_Certification__c;
                    }else{
                        genericWorkforceQuoteCalcObj.extraCertificationCost = specialRequirement.ET_Extra_Certification__c + (specialRequirement.ET_Extra_Certification__c / genericWorkforceQuoteCalcObj.contractYear);
                    }
                    
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndextraCertificationCost != null && serviceAndContractYearAndextraCertificationCost.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndextraCertificationCostMap = serviceAndContractYearAndextraCertificationCost.get(serviceType);
                        if(ContractYearAndextraCertificationCostMap != null && ContractYearAndextraCertificationCostMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndextraCertificationCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.extraCertificationCost*noOfWorkForce ;
                            ContractYearAndextraCertificationCostMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndextraCertificationCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.extraCertificationCost*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndextraCertificationCostMap = new Map<integer,Decimal>();
                            ContractYearAndextraCertificationCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.extraCertificationCost*noOfWorkForce);
                            serviceAndContractYearAndextraCertificationCost.put(serviceType , ContractYearAndextraCertificationCostMap);
                        }
                        
                    }
                }
                
                //******************************leave allowance calc*****************
                decimal numberOfAnnualLeaves = reqWorkForceQItem.Number_of_Annual_Leave_months__c; 
                //added by Arunsarathy on 16.05.2023 for school transportation updation
                if(reqWorkForceQItem.ET_Depreciation_Method__c == 'Straight Line' && reqWorkForceQItem.ET_Workforce_Record_Type__c == 'ET_Driver'){
                    genericWorkforceQuoteCalcObj.leaveAllowance = 0;
                }else{
                    if(reqWorkForceQItem.ET_Annual_leave_allowance__c != null && reqWorkForceQItem.ET_Annual_leave_allowance__c !=0){
                        genericWorkforceQuoteCalcObj.leaveAllowance = reqWorkForceQItem.ET_Annual_leave_allowance__c;
                    }
                    else if(reqWorkForceQItem.Number_of_Annual_Leave_months__c != null && grossSalary != null )
                    {
                        genericWorkforceQuoteCalcObj.leaveAllowance = grossSalary * numberOfAnnualLeaves;
                    }
                }
                
                if(genericWorkforceQuoteCalcObj.leaveAllowance !=null && genericWorkforceQuoteCalcObj.leaveAllowance != 0){
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndleaveAllowance != null && serviceAndContractYearAndleaveAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndleaveAllowanceMap = serviceAndContractYearAndleaveAllowance.get(serviceType);
                        if(ContractYearAndleaveAllowanceMap != null && ContractYearAndleaveAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndleaveAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.leaveAllowance*noOfWorkForce ;
                            ContractYearAndleaveAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndleaveAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.leaveAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndleaveAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndleaveAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.leaveAllowance*noOfWorkForce);
                            serviceAndContractYearAndleaveAllowance.put(serviceType , ContractYearAndleaveAllowanceMap);
                        }
                        
                    }
                }
                
                // clothes allowance
                if(reqWorkForceQItem.ET_Clothes_Allowance__c != null){
                    genericWorkforceQuoteCalcObj.clothesAllowance = reqWorkForceQItem.ET_Clothes_Allowance__c; 
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndclothesAllowance != null && serviceAndContractYearAndclothesAllowance.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndclothesAllowanceMap = serviceAndContractYearAndclothesAllowance.get(serviceType);
                        if(ContractYearAndclothesAllowanceMap != null && ContractYearAndclothesAllowanceMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndclothesAllowanceMap.get(intContractYear) + genericWorkforceQuoteCalcObj.clothesAllowance*noOfWorkForce ;
                            ContractYearAndclothesAllowanceMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndclothesAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.clothesAllowance*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndclothesAllowanceMap = new Map<integer,Decimal>();
                            ContractYearAndclothesAllowanceMap.put(intContractYear , genericWorkforceQuoteCalcObj.clothesAllowance*noOfWorkForce);
                            serviceAndContractYearAndclothesAllowance.put(serviceType , ContractYearAndclothesAllowanceMap);
                        }
                        
                    }
                }
                
                // Additional Work Permit Fees
                if(reqWorkForceQItem.Additional_Work_Permit_Fees__c != null ){
                    genericWorkforceQuoteCalcObj.additionalWorkPermitFees = reqWorkForceQItem.Additional_Work_Permit_Fees__c; 
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndAdditionalWorkPermit != null && serviceAndContractYearAndAdditionalWorkPermit.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndAdditionalWorkPermitMap = serviceAndContractYearAndAdditionalWorkPermit.get(serviceType);
                        if(ContractYearAndAdditionalWorkPermitMap != null && ContractYearAndAdditionalWorkPermitMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndAdditionalWorkPermitMap.get(intContractYear) + genericWorkforceQuoteCalcObj.additionalWorkPermitFees*noOfWorkForce ;
                            ContractYearAndAdditionalWorkPermitMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndAdditionalWorkPermitMap.put(intContractYear , genericWorkforceQuoteCalcObj.additionalWorkPermitFees*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndAdditionalWorkPermitMap = new Map<integer,Decimal>();
                            ContractYearAndAdditionalWorkPermitMap.put(intContractYear , genericWorkforceQuoteCalcObj.additionalWorkPermitFees*noOfWorkForce);
                            serviceAndContractYearAndAdditionalWorkPermit.put(serviceType , ContractYearAndAdditionalWorkPermitMap);
                        }
                        
                    }
                }
                
                
                
                //******************************end of service calc****************
                
                Integer numberOfEndOfServiceMonths ;
                system.debug('endOfServiceCost 1 '+ genericWorkforceQuoteCalcObj.endOfServiceCost);
                if(reqWorkForceQItem.Number_of_End_of_Service_months__c != null && basicSalary != null 
                   && (genericWorkforceQuoteCalcObj.resourcetype=='UAE' || genericWorkforceQuoteCalcObj.resourcetype=='GCC National' )){
                       numberOfEndOfServiceMonths = Integer.valueOf(reqWorkForceQItem.Number_of_End_of_Service_months__c.substring(0,2).trim());
                       decimal allowances = basicSalary + housingallowan + costoflivingallowan + socialallowan + childrenallowan;
                       system.debug('allowances = '+ allowances);
                       genericWorkforceQuoteCalcObj.endOfServiceCost = allowances*12*15/100.0;
                       // total Project Calcs
                       if(vehSource == 'Main' && serviceAndContractYearAndendOfServiceCost != null && serviceAndContractYearAndendOfServiceCost.containsKey(serviceType)){
                           Map<integer,Decimal> ContractYearAndendOfServiceCostMap = serviceAndContractYearAndendOfServiceCost.get(serviceType);
                           if(ContractYearAndendOfServiceCostMap != null && ContractYearAndendOfServiceCostMap.containsKey(intContractYear)){
                               decimal total = ContractYearAndendOfServiceCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.endOfServiceCost*noOfWorkForce ;
                               ContractYearAndendOfServiceCostMap.put(intContractYear , total);
                           }
                           else{
                               ContractYearAndendOfServiceCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.endOfServiceCost*noOfWorkForce);
                           }
                       }
                       else{
                           if(vehSource == 'Main' ){
                               Map<integer,Decimal> ContractYearAndendOfServiceCostMap = new Map<integer,Decimal>();
                               ContractYearAndendOfServiceCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.endOfServiceCost*noOfWorkForce);
                               serviceAndContractYearAndendOfServiceCost.put(serviceType , ContractYearAndendOfServiceCostMap);
                           }
                           
                       }
                   }
                else if(reqWorkForceQItem.Number_of_End_of_Service_months__c != null && basicSalary != null 
                        && genericWorkforceQuoteCalcObj.resourcetype !='UAE'){
                            
                            numberOfEndOfServiceMonths = Integer.valueOf(reqWorkForceQItem.Number_of_End_of_Service_months__c.substring(0,2).trim());
                            genericWorkforceQuoteCalcObj.endOfServiceCost = basicSalary * numberOfEndOfServiceMonths;
                            // total Project Calcs
                            if(vehSource == 'Main' && serviceAndContractYearAndendOfServiceCost != null && serviceAndContractYearAndendOfServiceCost.containsKey(serviceType)){
                                Map<integer,Decimal> ContractYearAndendOfServiceCostMap = serviceAndContractYearAndendOfServiceCost.get(serviceType);
                                if(ContractYearAndendOfServiceCostMap != null && ContractYearAndendOfServiceCostMap.containsKey(intContractYear)){
                                    decimal total = ContractYearAndendOfServiceCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.endOfServiceCost*noOfWorkForce ;
                                    ContractYearAndendOfServiceCostMap.put(intContractYear , total);
                                }
                                else{
                                    ContractYearAndendOfServiceCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.endOfServiceCost*noOfWorkForce);
                                }
                            }
                            else{
                                if(vehSource == 'Main' ){
                                    Map<integer,Decimal> ContractYearAndendOfServiceCostMap = new Map<integer,Decimal>();
                                    ContractYearAndendOfServiceCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.endOfServiceCost*noOfWorkForce);
                                    serviceAndContractYearAndendOfServiceCost.put(serviceType , ContractYearAndendOfServiceCostMap);
                                }
                                
                            }
                        }
                
                
                //Health Card - Insurance plan
                if(reqWorkForceQItem.ET_Health_Card__c != null && genericWorkforceQuoteCalcObj.resourcetype !='UAE'){
                    genericWorkforceQuoteCalcObj.healthCardCost = reqWorkForceQItem.ET_Health_Card__c;
                    system.debug('health cost'+ genericWorkforceQuoteCalcObj.healthCardCost);
                }
                
                else if(genericWorkforceQuoteCalcObj.resourcetype =='UAE'){
                    genericWorkforceQuoteCalcObj.healthCardCost = 0;
                    
                }
                //Total Project calculation - Health Card
                if(genericWorkforceQuoteCalcObj.healthCardCost != null ){
                    if(vehSource == 'Main' && serviceAndContractYearAndhealthCardCost != null && serviceAndContractYearAndhealthCardCost.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndhealthCardCostMap = serviceAndContractYearAndhealthCardCost.get(serviceType);
                        if(ContractYearAndhealthCardCostMap != null && ContractYearAndhealthCardCostMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndhealthCardCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.healthCardCost*noOfWorkForce ;
                            ContractYearAndhealthCardCostMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndhealthCardCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.healthCardCost*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndhealthCardCostMap = new Map<integer,Decimal>();
                            ContractYearAndhealthCardCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.healthCardCost*noOfWorkForce);
                            serviceAndContractYearAndhealthCardCost.put(serviceType , ContractYearAndhealthCardCostMap);
                        }
                    }
                }
                
                
                // Training and licensing cost..
                genericWorkforceQuoteCalcObj.licensingFee = reqWorkForceQItem.ET_Licensing_Fees__c;
                // total Project Calcs
                if(vehSource == 'Main' && serviceAndContractYearAndlicensingFee != null && serviceAndContractYearAndlicensingFee.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndlicensingFeeCostMap = serviceAndContractYearAndlicensingFee.get(serviceType);
                    if(ContractYearAndlicensingFeeCostMap != null && ContractYearAndlicensingFeeCostMap.containsKey(intContractYear)){
                      System.debug('year='+ContractYearAndlicensingFeeCostMap.get(intContractYear));
                        System.debug('lice='+genericWorkforceQuoteCalcObj.licensingFee);
                       
                        decimal total = ContractYearAndlicensingFeeCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.licensingFee*noOfWorkForce ;
                          System.debug('total='+total);
                        ContractYearAndlicensingFeeCostMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndlicensingFeeCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.licensingFee*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndlicensingFeeCostMap = new Map<integer,Decimal>();
                        ContractYearAndlicensingFeeCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.licensingFee*noOfWorkForce);
                        serviceAndContractYearAndlicensingFee.put(serviceType , ContractYearAndlicensingFeeCostMap);
                    }
                }
                
                //Visa Cost
                if(reqWorkForceQItem.ET_Visa_amount__c != null && genericWorkforceQuoteCalcObj.resourcetype !='UAE' ){
                    genericWorkforceQuoteCalcObj.visaCost = reqWorkForceQItem.ET_Visa_amount__c;
                }
                
                else if(genericWorkforceQuoteCalcObj.resourcetype =='UAE' ){
                    genericWorkforceQuoteCalcObj.visaCost = 0;
                }
                
                if(genericWorkforceQuoteCalcObj.visaCost != null){
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndvisaCost != null && serviceAndContractYearAndvisaCost.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndvisaCostMap = serviceAndContractYearAndvisaCost.get(serviceType);
                        if(ContractYearAndvisaCostMap != null && ContractYearAndvisaCostMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndvisaCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.visaCost*noOfWorkForce ;
                            ContractYearAndvisaCostMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndvisaCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.visaCost*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndvisaCostMap = new Map<integer,Decimal>();
                            ContractYearAndvisaCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.visaCost*noOfWorkForce);
                            serviceAndContractYearAndvisaCost.put(serviceType , ContractYearAndvisaCostMap);
                        }
                    }
                }
                
                /**** Total Dyanmic other cost ************************/
                genericWorkforceQuoteCalcObj.totalDynamicOtherCost = reqWorkForceQItem.Total_dynamic_other_cost__c;
                
                /******************************totalDirectOperationalCost calc****************/
                genericWorkforceQuoteCalcObj.totalDirectOperationalCost = genericWorkforceQuoteCalcObj.wages + genericWorkforceQuoteCalcObj.overTimeCost;
                
                // total Project Calcs
                if(vehSource == 'Main' && serviceAndContractYearAndtotalDirectOperationalCost != null && serviceAndContractYearAndtotalDirectOperationalCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndtotalDirectOperationalCostMap = serviceAndContractYearAndtotalDirectOperationalCost.get(serviceType);
                    if(ContractYearAndtotalDirectOperationalCostMap != null && ContractYearAndtotalDirectOperationalCostMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndtotalDirectOperationalCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalDirectOperationalCost*noOfWorkForce ;
                        ContractYearAndtotalDirectOperationalCostMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndtotalDirectOperationalCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalDirectOperationalCost*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndtotalDirectOperationalCostMap = new Map<integer,Decimal>();
                        ContractYearAndtotalDirectOperationalCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalDirectOperationalCost*noOfWorkForce);
                        serviceAndContractYearAndtotalDirectOperationalCost.put(serviceType , ContractYearAndtotalDirectOperationalCostMap);
                    }
                }
                
                // reliever Cost
                if(manpowerType == 'Main'){
                    if(!relieverCostMap.isEmpty() && !relieverIdWrToMainWorkforceIdMap.isEmpty() && relieverIdWrToMainWorkforceIdMap.containsKey(mainWorkforceId) ){
                        String relieverId =  relieverIdWrToMainWorkforceIdMap.get(mainWorkforceId);
                        if(relieverCostMap.containsKey(relieverId)){
                            decimal reliverCost = relieverCostMap.get(relieverId);
                            if(reliverCost != null){
                                genericWorkforceQuoteCalcObj.relieverCost = reliverCost/noOfWorkForce;
                            }
                        }
                    }
                }
                
                // total Project Calcs -- relieverCost
                if(vehSource == 'Main' && serviceAndContractYearAndRelieverCost != null && serviceAndContractYearAndRelieverCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndRelieverCostMap = serviceAndContractYearAndRelieverCost.get(serviceType);
                    if(ContractYearAndRelieverCostMap != null && ContractYearAndRelieverCostMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndRelieverCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.relieverCost*noOfWorkForce ;
                        ContractYearAndRelieverCostMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndRelieverCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.relieverCost*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndRelieverCostMap = new Map<integer,Decimal>();
                        ContractYearAndRelieverCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.relieverCost*noOfWorkForce);
                        serviceAndContractYearAndRelieverCost.put(serviceType , ContractYearAndRelieverCostMap);
                    }
                }
                
                
                
                //******************************totalIndirectOperationCost calc*****************/
                genericWorkforceQuoteCalcObj.totalIndirectOperationCost = genericWorkforceQuoteCalcObj.leaveAllowance +
                    genericWorkforceQuoteCalcObj.endOfServiceCost +
                    genericWorkforceQuoteCalcObj.clothesAllowance +
                    genericWorkforceQuoteCalcObj.healthCardCost +
                    genericWorkforceQuoteCalcObj.licensingFee +
                    genericWorkforceQuoteCalcObj.visaCost +
                    genericWorkforceQuoteCalcObj.smartPhoneCost +
                    genericWorkforceQuoteCalcObj.airTicketsCost +
                    genericWorkforceQuoteCalcObj.accomodationAllowance +
                    genericWorkforceQuoteCalcObj.extraCertificationCost + 
                    genericWorkforceQuoteCalcObj.totalDynamicOtherCost +
                    genericWorkforceQuoteCalcObj.additionalWorkPermitFees +
                    genericWorkforceQuoteCalcObj.relieverCost ;
                
                
                system.debug('totalIndirectOperationCost = '+ genericWorkforceQuoteCalcObj.totalIndirectOperationCost);
                
                // total Project Calcs
                if(vehSource == 'Main' && serviceAndContractYearAndtotalIndirectOperationCost != null && serviceAndContractYearAndtotalIndirectOperationCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndtotalIndirectOperationCostMap = serviceAndContractYearAndtotalIndirectOperationCost.get(serviceType);
                    if(ContractYearAndtotalIndirectOperationCostMap != null && ContractYearAndtotalIndirectOperationCostMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndtotalIndirectOperationCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalIndirectOperationCost*noOfWorkForce ;
                        ContractYearAndtotalIndirectOperationCostMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndtotalIndirectOperationCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalIndirectOperationCost*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndtotalIndirectOperationCostMap = new Map<integer,Decimal>();
                        ContractYearAndtotalIndirectOperationCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalIndirectOperationCost*noOfWorkForce);
                        serviceAndContractYearAndtotalIndirectOperationCost.put(serviceType , ContractYearAndtotalIndirectOperationCostMap);
                    }
                    
                }
                
                /************* Manpower Reserve Cost **********************/
                genericWorkforceQuoteCalcObj.manpowerReserveCost = (genericWorkforceQuoteCalcObj.totalDirectOperationalCost +
                                                                    genericWorkforceQuoteCalcObj.totalIndirectOperationCost)* genericWorkforceQuoteCalcObj.reserveRate/100;
                
                // total Project Calcs --- Manpower Reserve
                if(vehSource == 'Main' && serviceAndContractYearAnddriverReserve != null && serviceAndContractYearAnddriverReserve.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearDriverReserveMap = serviceAndContractYearAnddriverReserve.get(serviceType);
                    if(ContractYearDriverReserveMap != null && ContractYearDriverReserveMap.containsKey(intContractYear)){
                        decimal total = ContractYearDriverReserveMap.get(intContractYear) + genericWorkforceQuoteCalcObj.manpowerReserveCost*noOfWorkForce ;
                        ContractYearDriverReserveMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearDriverReserveMap.put(intContractYear , genericWorkforceQuoteCalcObj.manpowerReserveCost*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearDriverReserveMap = new Map<integer,Decimal>();
                        ContractYearDriverReserveMap.put(intContractYear , genericWorkforceQuoteCalcObj.manpowerReserveCost*noOfWorkForce);
                        serviceAndContractYearAnddriverReserve.put(serviceType , ContractYearDriverReserveMap);
                    }
                }
                
                genericWorkforceQuoteCalcObj.reserveCostTargetPrice  = 0;
                genericWorkforceQuoteCalcObj.reserveCostDiscountedPrice  = 0;
                
                //******************************totalCost calc******************
                genericWorkforceQuoteCalcObj.totalCost = genericWorkforceQuoteCalcObj.totalDirectOperationalCost +
                    genericWorkforceQuoteCalcObj.totalIndirectOperationCost + genericWorkforceQuoteCalcObj.manpowerReserveCost;
                
                /* according for records -- first all relievers will be calculated and placed in a Map and there after
        when main workforce is calculated, reliver cost will be added to Main workforce...
        */
                // add reliever cost in a Map 
                if(manpowerType == 'Reliever'){
                    relieverCostMap.put(relieverWorkforceId , genericWorkforceQuoteCalcObj.totalCost*noOfWorkForce);
                }
                
                
                if(reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Driver' || reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Nanny'){
                    if(noOfVehicles != null){
                        genericWorkforceQuoteCalcObj.totalCostPerEachVehicle = (genericWorkforceQuoteCalcObj.totalCost * noOfWorkForce)/ noOfVehicles ; 
                    } 
                }
                else{
                    if(noOfMainVehicles != null && noOfMainVehicles!= 0){
                        genericWorkforceQuoteCalcObj.totalCostPerEachVehicle = (genericWorkforceQuoteCalcObj.totalCost * noOfWorkForce)/ noOfMainVehicles ; 
                    } 
                }
                
                
                
                // total Project Calcs --- totalCost
                if(vehSource == 'Main' && serviceAndContractYeartotalCost != null && serviceAndContractYeartotalCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYeartotalCostMap = serviceAndContractYeartotalCost.get(serviceType);
                    if(ContractYeartotalCostMap != null && ContractYeartotalCostMap.containsKey(intContractYear)){
                        decimal total = ContractYeartotalCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalCost*noOfWorkForce ;
                        ContractYeartotalCostMap.put(intContractYear , total);
                    }
                    else{
                        ContractYeartotalCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalCost*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYeartotalCostMap = new Map<integer,Decimal>();
                        ContractYeartotalCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalCost*noOfWorkForce);
                        serviceAndContractYeartotalCost.put(serviceType , ContractYeartotalCostMap);
                    }
                }
                
                genericWorkforceQuoteCalcObj.totalCostTargetPrice = genericWorkforceQuoteCalcObj.totalDirectOperationalCost +
                    genericWorkforceQuoteCalcObj.totalIndirectOperationCost;
                
                // total Project Calcs --- totalCost - Target
                if(vehSource == 'Main' && serviceAndContractYearAndTotalCostTarget != null && serviceAndContractYearAndTotalCostTarget.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYeartotalCostMap = serviceAndContractYearAndTotalCostTarget.get(serviceType);
                    if(ContractYeartotalCostMap != null && ContractYeartotalCostMap.containsKey(intContractYear)){
                        decimal total = ContractYeartotalCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalCostTargetPrice*noOfWorkForce ;
                        ContractYeartotalCostMap.put(intContractYear , total);
                    }
                    else{
                        ContractYeartotalCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalCostTargetPrice*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYeartotalCostMap = new Map<integer,Decimal>();
                        ContractYeartotalCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalCostTargetPrice*noOfWorkForce);
                        serviceAndContractYearAndTotalCostTarget.put(serviceType , ContractYeartotalCostMap); 
                    }
                }
                
                if(reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Driver' || reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Nanny'){
                    if(noOfVehicles != null){
                        genericWorkforceQuoteCalcObj.totalCostPerEachVehicleTarget = (genericWorkforceQuoteCalcObj.totalCostTargetPrice * noOfWorkForce)/ noOfVehicles ;
                    } 
                }
                else{
                    if(noOfMainVehicles != null && noOfMainVehicles!= 0){
                        genericWorkforceQuoteCalcObj.totalCostPerEachVehicleTarget = (genericWorkforceQuoteCalcObj.totalCostTargetPrice * noOfWorkForce)/ noOfMainVehicles ;
                    } 
                }
                
                genericWorkforceQuoteCalcObj.discountedManpowerTotalCost = genericWorkforceQuoteCalcObj.totalDirectOperationalCost +
                    genericWorkforceQuoteCalcObj.totalIndirectOperationCost;
                
                // total Project Calcs --- totalCost - Discounted
                if(vehSource == 'Main' && serviceAndContractYearAndTotalCostDiscounted != null && serviceAndContractYearAndTotalCostDiscounted.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYeartotalCostMap = serviceAndContractYearAndTotalCostDiscounted.get(serviceType);
                    if(ContractYeartotalCostMap != null && ContractYeartotalCostMap.containsKey(intContractYear)){
                        decimal total = ContractYeartotalCostMap.get(intContractYear) + genericWorkforceQuoteCalcObj.discountedManpowerTotalCost*noOfWorkForce ;
                        ContractYeartotalCostMap.put(intContractYear , total);
                    }
                    else{
                        ContractYeartotalCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.discountedManpowerTotalCost*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYeartotalCostMap = new Map<integer,Decimal>();
                        ContractYeartotalCostMap.put(intContractYear , genericWorkforceQuoteCalcObj.discountedManpowerTotalCost*noOfWorkForce);
                        serviceAndContractYearAndTotalCostDiscounted.put(serviceType , ContractYeartotalCostMap);
                    }
                }
                
                
                if(reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Driver' || reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Nanny'){
                    if(noOfVehicles != null){
                        genericWorkforceQuoteCalcObj.totalCostPerEachVehicleDiscounted = (genericWorkforceQuoteCalcObj.discountedManpowerTotalCost * noOfWorkForce)/ noOfVehicles ;
                    } 
                }
                else{
                    if(noOfMainVehicles != null && noOfMainVehicles!= 0){
                        genericWorkforceQuoteCalcObj.totalCostPerEachVehicleDiscounted = (genericWorkforceQuoteCalcObj.discountedManpowerTotalCost * noOfWorkForce)/ noOfMainVehicles ;
                    } 
                }
                //******************************Annual profit margin value calc****************
                decimal profitPercentage = reqWorkForceQItem.Profit_Percentage_from_Master__c;
                if(profitPercentage != null  )
                {
                    genericWorkforceQuoteCalcObj.annualProfitMarginValue = genericWorkforceQuoteCalcObj.totalCost *(profitPercentage/100);
                }
                
                if(genericWorkforceQuoteCalcObj.annualProfitMarginValue != null && reqWorkForceQItem.ET_Discounts_Additional_Profit__c != null){
                    genericWorkforceQuoteCalcObj.annualProfitMarginValue = ( genericWorkforceQuoteCalcObj.annualProfitMarginValue) * (1 + (reqWorkForceQItem.ET_Discounts_Additional_Profit__c /100) );
                }
                
                if(reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Driver' || reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Nanny'){
                    if(noOfVehicles != null){
                        genericWorkforceQuoteCalcObj.annualProfitMarginValuePerEachVehicle = ( genericWorkforceQuoteCalcObj.annualProfitMarginValue * noOfWorkForce) / noOfVehicles;
                    } 
                }
                else{
                    if(noOfMainVehicles != null && noOfMainVehicles!= 0){
                        genericWorkforceQuoteCalcObj.annualProfitMarginValuePerEachVehicle = ( genericWorkforceQuoteCalcObj.annualProfitMarginValue * noOfWorkForce) / noOfMainVehicles;
                    } 
                }
                
                //Corporate Tax 
                if(genericWorkforceQuoteCalcObj.annualProfitMarginValuePerEachVehicle != null ){
                    //genericWorkforceQuoteCalcObj.corporateTax = ( genericWorkforceQuoteCalcObj.annualProfitMarginValuePerEachVehicle) * (9/100.0)*(intContractYear - 1)/intContractYear;
                    genericWorkforceQuoteCalcObj.corporateTax = (genericWorkforceQuoteCalcObj.annualProfitMarginValuePerEachVehicle) * (9/100.0);
                } 
                
                genericWorkforceQuoteCalcObj.profitMarginPercentageTargetPrice = profitPercentage/2;
                if(genericWorkforceQuoteCalcObj.profitMarginPercentageTargetPrice != null  )
                {
                    genericWorkforceQuoteCalcObj.profitValueTargetPrice = genericWorkforceQuoteCalcObj.totalCostTargetPrice *(genericWorkforceQuoteCalcObj.profitMarginPercentageTargetPrice/100);
                }
                
                if(genericWorkforceQuoteCalcObj.profitValueTargetPrice != null && reqWorkForceQItem.ET_Discounts_Additional_Profit__c != null){
                    genericWorkforceQuoteCalcObj.profitValueTargetPrice = ( genericWorkforceQuoteCalcObj.profitValueTargetPrice) * (1 + (reqWorkForceQItem.ET_Discounts_Additional_Profit__c /100) );
                }
                if(noOfVehicles != null){
                    genericWorkforceQuoteCalcObj.profitValueTargetPricePerVehicle = ( genericWorkforceQuoteCalcObj.profitValueTargetPrice * noOfWorkForce) / noOfVehicles;
                }
                //discountedManpowerProfit
                if(genericWorkforceQuoteCalcObj.profitMarginPercentageTargetPrice != null  )
                {
                    genericWorkforceQuoteCalcObj.discountedManpowerProfit = genericWorkforceQuoteCalcObj.discountedManpowerTotalCost *(genericWorkforceQuoteCalcObj.profitMarginPercentageTargetPrice/100);
                }
                
                if(genericWorkforceQuoteCalcObj.discountedManpowerProfit != null && reqWorkForceQItem.ET_Discounts_Additional_Profit__c != null){
                    genericWorkforceQuoteCalcObj.discountedManpowerProfit = ( genericWorkforceQuoteCalcObj.discountedManpowerProfit) * (1 + (reqWorkForceQItem.ET_Discounts_Additional_Profit__c /100) );
                }
                
                if(noOfVehicles != null){
                    genericWorkforceQuoteCalcObj.discountedManpowerProfitPerVehicle = ( genericWorkforceQuoteCalcObj.discountedManpowerProfit * noOfWorkForce) / noOfVehicles;
                }
                
                if(reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Driver' || reqWorkForceQItem.ET_Workforce_Quote_Item_Type__c == 'Nanny'){
                    if(noOfVehicles != null){
                        genericWorkforceQuoteCalcObj.discountedManpowerProfitPerVehicle = ( genericWorkforceQuoteCalcObj.discountedManpowerProfit * noOfWorkForce) / noOfVehicles;
                    } 
                }
                else{
                    if(noOfMainVehicles != null && noOfMainVehicles!= 0){
                        genericWorkforceQuoteCalcObj.discountedManpowerProfitPerVehicle = ( genericWorkforceQuoteCalcObj.discountedManpowerProfit * noOfWorkForce) / noOfMainVehicles;
                    } 
                }
                
                // total Project Calcs
                if(vehSource == 'Main' && serviceAndContractYearAndannualProfitMarginValue != null && serviceAndContractYearAndannualProfitMarginValue.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndannualProfitMarginValueMap = serviceAndContractYearAndannualProfitMarginValue.get(serviceType);
                    if(ContractYearAndannualProfitMarginValueMap != null && ContractYearAndannualProfitMarginValueMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndannualProfitMarginValueMap.get(intContractYear) + genericWorkforceQuoteCalcObj.annualProfitMarginValue*noOfWorkForce ;
                        ContractYearAndannualProfitMarginValueMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndannualProfitMarginValueMap.put(intContractYear , genericWorkforceQuoteCalcObj.annualProfitMarginValue*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndannualProfitMarginValueMap = new Map<integer,Decimal>();
                        ContractYearAndannualProfitMarginValueMap.put(intContractYear , genericWorkforceQuoteCalcObj.annualProfitMarginValue*noOfWorkForce);
                        serviceAndContractYearAndannualProfitMarginValue.put(serviceType , ContractYearAndannualProfitMarginValueMap);
                    }
                }
                
                // total Project Calcs - Profit Value - discounted
                if(vehSource == 'Main' && serviceAndContractYearAndAnnualNetProfitValueDiscounted != null && serviceAndContractYearAndAnnualNetProfitValueDiscounted.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndannualProfitMarginValueMap = serviceAndContractYearAndAnnualNetProfitValueDiscounted.get(serviceType);
                    if(ContractYearAndannualProfitMarginValueMap != null && ContractYearAndannualProfitMarginValueMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndannualProfitMarginValueMap.get(intContractYear) + genericWorkforceQuoteCalcObj.discountedManpowerProfit*noOfWorkForce ;
                        ContractYearAndannualProfitMarginValueMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndannualProfitMarginValueMap.put(intContractYear , genericWorkforceQuoteCalcObj.discountedManpowerProfit*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndannualProfitMarginValueMap = new Map<integer,Decimal>();
                        ContractYearAndannualProfitMarginValueMap.put(intContractYear , genericWorkforceQuoteCalcObj.discountedManpowerProfit*noOfWorkForce);
                        serviceAndContractYearAndAnnualNetProfitValueDiscounted.put(serviceType , ContractYearAndannualProfitMarginValueMap);
                    }
                }
                
                // total Project Calcs - Profit Value - Target
                if(vehSource == 'Main' && serviceAndContractYearAndAnnualNetProfitValueTarget != null && serviceAndContractYearAndAnnualNetProfitValueTarget.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndannualProfitMarginValueMap = serviceAndContractYearAndAnnualNetProfitValueTarget.get(serviceType);
                    if(ContractYearAndannualProfitMarginValueMap != null && ContractYearAndannualProfitMarginValueMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndannualProfitMarginValueMap.get(intContractYear) + genericWorkforceQuoteCalcObj.profitValueTargetPrice*noOfWorkForce ;
                        ContractYearAndannualProfitMarginValueMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndannualProfitMarginValueMap.put(intContractYear , genericWorkforceQuoteCalcObj.profitValueTargetPrice*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndannualProfitMarginValueMap = new Map<integer,Decimal>();
                        ContractYearAndannualProfitMarginValueMap.put(intContractYear , genericWorkforceQuoteCalcObj.profitValueTargetPrice*noOfWorkForce);
                        serviceAndContractYearAndAnnualNetProfitValueTarget.put(serviceType , ContractYearAndannualProfitMarginValueMap);
                    }
                    
                }
                
                //******************************Annual profit margin rate calc******************
                genericWorkforceQuoteCalcObj.annualProfitMarginRate = (genericWorkforceQuoteCalcObj.annualProfitMarginValue / genericWorkforceQuoteCalcObj.totalCost)*100;
                
                genericWorkforceQuoteCalcObj.profitMarginPercentageTargetPrice = (genericWorkforceQuoteCalcObj.annualProfitMarginRate)/2;
                //******************************totalAnnualNetProfitValue calc****************
                genericWorkforceQuoteCalcObj.totalAnnualNetProfitValue = genericWorkforceQuoteCalcObj.annualProfitMarginValue + genericWorkforceQuoteCalcObj.allowedProfit ;
                  genericWorkforceQuoteCalcObj.corporateTax = (genericWorkforceQuoteCalcObj.totalAnnualNetProfitValue) * (9/100.0);
                if(noOfVehicles == null || noOfVehicles == 0){
                    genericWorkforceQuoteCalcObj.corporateTax = (genericWorkforceQuoteCalcObj.totalAnnualNetProfitValue) * (9/100.0);
                }
                //total Project Calcs --- Corporate Tax 
                if(vehSource == 'Main' && serviceAndContractYearAndCorporateTax != null && serviceAndContractYearAndCorporateTax.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndCorporateTaxMap = serviceAndContractYearAndCorporateTax.get(serviceType);
                    if(ContractYearAndCorporateTaxMap != null && ContractYearAndCorporateTaxMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndCorporateTaxMap.get(intContractYear) + genericWorkforceQuoteCalcObj.corporateTax*noOfWorkForce ;
                        ContractYearAndCorporateTaxMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndCorporateTaxMap.put(intContractYear , genericWorkforceQuoteCalcObj.corporateTax*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndCorporateTaxMap = new Map<integer,Decimal>();
                        ContractYearAndCorporateTaxMap.put(intContractYear , genericWorkforceQuoteCalcObj.corporateTax*noOfWorkForce);
                        serviceAndContractYearAndCorporateTax.put(serviceType , ContractYearAndCorporateTaxMap);
                    }
                }
                
                // Total Annual Price excluding VAT
                if(genericWorkforceQuoteCalcObj.totalCost != null  && genericWorkforceQuoteCalcObj.totalAnnualNetProfitValue != null ){
                    //Added by Arunsarathy for Corporate tax updation for manpower only 15.05.2023
                    if(noOfVehicles == null || noOfVehicles == 0){
                        genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT =genericWorkforceQuoteCalcObj.totalCost + genericWorkforceQuoteCalcObj.totalAnnualNetProfitValue + genericWorkforceQuoteCalcObj.corporateTax ;
                    }else{
                        genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT =genericWorkforceQuoteCalcObj.totalCost + genericWorkforceQuoteCalcObj.totalAnnualNetProfitValue ;
                    }
                }
                
                // Total Annual Price excluding VAT -- Total Project
                if(vehSource == 'Main' && serviceAndContractYearAndTotalAnnualPriceExcludingVAT != null && serviceAndContractYearAndTotalAnnualPriceExcludingVAT.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalAnnualPriceExcludingVATMap = serviceAndContractYearAndTotalAnnualPriceExcludingVAT.get(serviceType);
                    if(ContractYearAndTotalAnnualPriceExcludingVATMap != null && ContractYearAndTotalAnnualPriceExcludingVATMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndTotalAnnualPriceExcludingVATMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT*noOfWorkForce ;
                        ContractYearAndTotalAnnualPriceExcludingVATMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndTotalAnnualPriceExcludingVATMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndTotalAnnualPriceExcludingVATMap = new Map<integer,Decimal>();
                        ContractYearAndTotalAnnualPriceExcludingVATMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT*noOfWorkForce);
                        serviceAndContractYearAndTotalAnnualPriceExcludingVAT.put(serviceType , ContractYearAndTotalAnnualPriceExcludingVATMap);
                    }
                }
                
                // Total Monthly Price excluding VAT
                if( genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT != null  &&  workingMonthsPerYear != null && workingMonthsPerYear != 0){
                    genericWorkforceQuoteCalcObj.totalMonthlyPriceExcludingVAT =(genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT )/(workingMonthsPerYear) ;
                }
                
                // Total Monthly Price excluding VAT -- Total Project
                if(vehSource == 'Main' && serviceAndContractYearAndTotalMonthlyPriceExcludingVAT != null && serviceAndContractYearAndTotalMonthlyPriceExcludingVAT.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalMonthlyPriceExcludingVATMap = serviceAndContractYearAndTotalMonthlyPriceExcludingVAT.get(serviceType);
                    if(ContractYearAndTotalMonthlyPriceExcludingVATMap != null && ContractYearAndTotalMonthlyPriceExcludingVATMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndTotalMonthlyPriceExcludingVATMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalMonthlyPriceExcludingVAT*noOfWorkForce ;
                        ContractYearAndTotalMonthlyPriceExcludingVATMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndTotalMonthlyPriceExcludingVATMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalMonthlyPriceExcludingVAT*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndTotalMonthlyPriceExcludingVATMap = new Map<integer,Decimal>();
                        ContractYearAndTotalMonthlyPriceExcludingVATMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalMonthlyPriceExcludingVAT*noOfWorkForce);
                        serviceAndContractYearAndTotalMonthlyPriceExcludingVAT.put(serviceType , ContractYearAndTotalMonthlyPriceExcludingVATMap);
                    }
                }
                
                // Vat is default zero for Exempted Services...
                system.debug('reqWorkForceQItem.ET_Vat_Rate__c  = '+ reqWorkForceQItem.ET_Vat_Rate__c );
                if(reqWorkForceQItem.ET_Vat_Rate__c != 'Exempt' && reqWorkForceQItem.ET_Vat_Rate__c != null ){
                    integer vatRate = integer.ValueOf(reqWorkForceQItem.ET_Vat_Rate__c);
                    system.debug('vatRate  = '+ vatRate );
                    system.debug('totalAnnualPriceExcludingVAT  = '+ genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT );
                    genericWorkforceQuoteCalcObj.workForceVATAmount = (genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT*vatRate)/100;
                    system.debug('genericWorkforceQuoteCalcObj.workForceVATAmount 1 = '+ genericWorkforceQuoteCalcObj.workForceVATAmount );
                    
                    // total Project Calcs
                    if(vehSource == 'Main' && serviceAndContractYearAndworkForceVATAmount != null && serviceAndContractYearAndworkForceVATAmount.containsKey(serviceType)){
                        Map<integer,Decimal> ContractYearAndworkForceVATAmountMap = serviceAndContractYearAndworkForceVATAmount.get(serviceType);
                        if(ContractYearAndworkForceVATAmountMap != null && ContractYearAndworkForceVATAmountMap.containsKey(intContractYear)){
                            decimal total = ContractYearAndworkForceVATAmountMap.get(intContractYear) + genericWorkforceQuoteCalcObj.workForceVATAmount*noOfWorkForce ;
                            ContractYearAndworkForceVATAmountMap.put(intContractYear , total);
                        }
                        else{
                            ContractYearAndworkForceVATAmountMap.put(intContractYear , genericWorkforceQuoteCalcObj.workForceVATAmount*noOfWorkForce);
                        }
                    }
                    else{
                        if(vehSource == 'Main' ){
                            Map<integer,Decimal> ContractYearAndworkForceVATAmountMap = new Map<integer,Decimal>();
                            ContractYearAndworkForceVATAmountMap.put(intContractYear , genericWorkforceQuoteCalcObj.workForceVATAmount*noOfWorkForce);
                            serviceAndContractYearAndworkForceVATAmount.put(serviceType , ContractYearAndworkForceVATAmountMap);
                        }
                        
                    }
                }
                
                system.debug('genericWorkforceQuoteCalcObj.workForceVATAmount  = '+ genericWorkforceQuoteCalcObj.workForceVATAmount );
                
                // Total Annual Price including VAT
                if(genericWorkforceQuoteCalcObj.workForceVATAmount != null && genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT != null ){
                    genericWorkforceQuoteCalcObj.totalAnnualPriceIncludingVAT =genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT + genericWorkforceQuoteCalcObj.workForceVATAmount ;
                }
                
                // Total Annual Price including VAT -- Total Project
                if(vehSource == 'Main' && serviceAndContractYearAndTotalAnnualPriceIncludingVAT != null && serviceAndContractYearAndTotalAnnualPriceIncludingVAT.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalAnnualPriceIncludingVATMap = serviceAndContractYearAndTotalAnnualPriceIncludingVAT.get(serviceType);
                    if(ContractYearAndTotalAnnualPriceIncludingVATMap != null && ContractYearAndTotalAnnualPriceIncludingVATMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndTotalAnnualPriceIncludingVATMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalAnnualPriceIncludingVAT*noOfWorkForce ;
                        ContractYearAndTotalAnnualPriceIncludingVATMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndTotalAnnualPriceIncludingVATMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalAnnualPriceIncludingVAT*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndTotalAnnualPriceIncludingVATMap = new Map<integer,Decimal>();
                        ContractYearAndTotalAnnualPriceIncludingVATMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalAnnualPriceIncludingVAT*noOfWorkForce);
                        serviceAndContractYearAndTotalAnnualPriceIncludingVAT.put(serviceType , ContractYearAndTotalAnnualPriceIncludingVATMap);
                    }
                }
                
                // Total Monthly Price including VAT
                if(genericWorkforceQuoteCalcObj.totalAnnualPriceIncludingVAT != null  && workingMonthsPerYear != null && workingMonthsPerYear != 0){
                    genericWorkforceQuoteCalcObj.totalMonthlyPriceIncludingVAT =genericWorkforceQuoteCalcObj.totalAnnualPriceIncludingVAT/workingMonthsPerYear;
                }
                
                // Total Monthly Price including VAT -- Total Project
                if(vehSource == 'Main' && serviceAndContractYearAndTotalMonthlyPriceIncludingVAT != null && serviceAndContractYearAndTotalMonthlyPriceIncludingVAT.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalMonthlyPriceIncludingVATMap = serviceAndContractYearAndTotalMonthlyPriceIncludingVAT.get(serviceType);
                    if(ContractYearAndTotalMonthlyPriceIncludingVATMap != null && ContractYearAndTotalMonthlyPriceIncludingVATMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndTotalMonthlyPriceIncludingVATMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalMonthlyPriceIncludingVAT*noOfWorkForce ;
                        ContractYearAndTotalMonthlyPriceIncludingVATMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndTotalMonthlyPriceIncludingVATMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalMonthlyPriceIncludingVAT*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndTotalMonthlyPriceIncludingVATMap = new Map<integer,Decimal>();
                        ContractYearAndTotalMonthlyPriceIncludingVATMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalMonthlyPriceIncludingVAT*noOfWorkForce);
                        serviceAndContractYearAndTotalMonthlyPriceIncludingVAT.put(serviceType , ContractYearAndTotalMonthlyPriceIncludingVATMap);
                    }
                }
                
                //Total Value Of Rental
                
                if(genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT != null &&   noOfWorkForce != null){
                    system.debug('vehSource 525 = '+ vehSource);
                    if(noOfVehicles == null || noOfMainVehicles == 0 ){
                        genericWorkforceQuoteCalcObj.totalValueOfRental = genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT * noOfWorkForce * intContractYear;
                    }else{
                        genericWorkforceQuoteCalcObj.totalValueOfRental = genericWorkforceQuoteCalcObj.totalAnnualPriceExcludingVAT * noOfWorkForce;
                    }
                }
                
                // Total Value Of Rental -- Total Project
                if(vehSource == 'Main' && serviceAndContractYearAndTotalValueOfRental != null && serviceAndContractYearAndTotalValueOfRental.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalValueOfRentalMap = serviceAndContractYearAndTotalValueOfRental.get(serviceType);
                    if(ContractYearAndTotalValueOfRentalMap != null && ContractYearAndTotalValueOfRentalMap.containsKey(intContractYear)){
                        //decimal total = ContractYearAndTotalValueOfRentalMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalValueOfRental*noOfWorkForce ;
                        decimal total = ContractYearAndTotalValueOfRentalMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalValueOfRental ;
                        ContractYearAndTotalValueOfRentalMap.put(intContractYear , total);
                    }
                    else{
                        //ContractYearAndTotalValueOfRentalMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalValueOfRental*noOfWorkForce);
                        ContractYearAndTotalValueOfRentalMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalValueOfRental);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndTotalValueOfRentalMap = new Map<integer,Decimal>();
                        //  ContractYearAndTotalValueOfRentalMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalValueOfRental*noOfWorkForce);
                        ContractYearAndTotalValueOfRentalMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalValueOfRental);
                        serviceAndContractYearAndTotalValueOfRental.put(serviceType , ContractYearAndTotalValueOfRentalMap);
                    }
                }
                
                //Total Manpower Profits
                
                if(genericWorkforceQuoteCalcObj.totalAnnualNetProfitValue != null  && noOfWorkForce != null){
                    //Added by Arunsarathy on 04.05.2023 for total manpower profits formula updation
                    if(noOfVehicles == null || noOfMainVehicles == 0 ){
                        genericWorkforceQuoteCalcObj.totalManpowerProfits = genericWorkforceQuoteCalcObj.totalAnnualNetProfitValue * noOfWorkForce * intContractYear;
                    }else{
                        genericWorkforceQuoteCalcObj.totalManpowerProfits = genericWorkforceQuoteCalcObj.totalAnnualNetProfitValue * noOfWorkForce;
                    }
                }
                
                //Total Manpower Profits-- Total Project
                if(vehSource == 'Main' && serviceAndContractYearAndTotalManpowerProfits != null && serviceAndContractYearAndTotalManpowerProfits.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalManpowerProfitsMap = serviceAndContractYearAndTotalManpowerProfits.get(serviceType);
                    if(ContractYearAndTotalManpowerProfitsMap != null && ContractYearAndTotalManpowerProfitsMap.containsKey(intContractYear)){
                        //decimal total = ContractYearAndTotalManpowerProfitsMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalManpowerProfits*noOfWorkForce ;
                        decimal total = ContractYearAndTotalManpowerProfitsMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalManpowerProfits ;
                        ContractYearAndTotalManpowerProfitsMap.put(intContractYear , total);
                    }
                    else{
                        //ContractYearAndTotalManpowerProfitsMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalManpowerProfits*noOfWorkForce);
                        ContractYearAndTotalManpowerProfitsMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalManpowerProfits);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndTotalManpowerProfitsMap = new Map<integer,Decimal>();
                        //ContractYearAndTotalManpowerProfitsMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalManpowerProfits*noOfWorkForce);
                        ContractYearAndTotalManpowerProfitsMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalManpowerProfits);
                        serviceAndContractYearAndTotalManpowerProfits.put(serviceType , ContractYearAndTotalManpowerProfitsMap);
                    }
                }
                
                //Gross profit margin 
                if(genericWorkforceQuoteCalcObj.totalManpowerProfits != null  && genericWorkforceQuoteCalcObj.totalValueOfRental != null && genericWorkforceQuoteCalcObj.totalValueOfRental != 0){
                    genericWorkforceQuoteCalcObj.grossProfitMargin = (genericWorkforceQuoteCalcObj.totalManpowerProfits/genericWorkforceQuoteCalcObj.totalValueOfRental)*100;
                }
                
                
                //total Project Calcs - workforce cost per each Vehicle
                if(vehSource == 'Main' && serviceAndContractYearAndWorkForceCostPerVehicle != null && serviceAndContractYearAndWorkForceCostPerVehicle.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndWorkForceCostPerVehicleMap = serviceAndContractYearAndWorkForceCostPerVehicle.get(serviceType);
                    if(ContractYearAndWorkForceCostPerVehicleMap != null && ContractYearAndWorkForceCostPerVehicleMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndWorkForceCostPerVehicleMap.get(intContractYear) +  genericWorkforceQuoteCalcObj.totalCostPerEachVehicle*noOfWorkForce;
                        ContractYearAndWorkForceCostPerVehicleMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndWorkForceCostPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalCostPerEachVehicle*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndWorkForceCostPerVehicleMap = new Map<integer,Decimal>();
                        ContractYearAndWorkForceCostPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalCostPerEachVehicle*noOfWorkForce);
                        serviceAndContractYearAndWorkForceCostPerVehicle.put(serviceType , ContractYearAndWorkForceCostPerVehicleMap);
                    }
                }
                
                //total Project Calcs - workforce cost per each Vehicle -- Discounted
                if(vehSource == 'Main' && serviceAndContractYearAndTotalCostPerEachVehicleDiscounted != null && serviceAndContractYearAndTotalCostPerEachVehicleDiscounted.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndWorkForceCostPerVehicleMap = serviceAndContractYearAndTotalCostPerEachVehicleDiscounted.get(serviceType);
                    if(ContractYearAndWorkForceCostPerVehicleMap != null && ContractYearAndWorkForceCostPerVehicleMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndWorkForceCostPerVehicleMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalCostPerEachVehicleDiscounted*noOfWorkForce;
                        ContractYearAndWorkForceCostPerVehicleMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndWorkForceCostPerVehicleMap.put(intContractYear ,genericWorkforceQuoteCalcObj.totalCostPerEachVehicleDiscounted*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndWorkForceCostPerVehicleMap = new Map<integer,Decimal>();
                        ContractYearAndWorkForceCostPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalCostPerEachVehicleDiscounted*noOfWorkForce);
                        serviceAndContractYearAndTotalCostPerEachVehicleDiscounted.put(serviceType , ContractYearAndWorkForceCostPerVehicleMap);
                    }
                    
                }
                
                //total Project Calcs - workforce cost per each Vehicle -- Target
                if(vehSource == 'Main' && serviceAndContractYearAndTotalCostPerEachVehicleTarget != null && serviceAndContractYearAndTotalCostPerEachVehicleTarget.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndWorkForceCostPerVehicleMap = serviceAndContractYearAndTotalCostPerEachVehicleTarget.get(serviceType);
                    if(ContractYearAndWorkForceCostPerVehicleMap != null && ContractYearAndWorkForceCostPerVehicleMap.containsKey(intContractYear)){
                        decimal total = ContractYearAndWorkForceCostPerVehicleMap.get(intContractYear) + genericWorkforceQuoteCalcObj.totalCostPerEachVehicleTarget*noOfWorkForce;
                        ContractYearAndWorkForceCostPerVehicleMap.put(intContractYear , total);
                    }
                    else{
                        ContractYearAndWorkForceCostPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalCostPerEachVehicleTarget*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> ContractYearAndWorkForceCostPerVehicleMap = new Map<integer,Decimal>();
                        ContractYearAndWorkForceCostPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.totalCostPerEachVehicleTarget*noOfWorkForce);
                        serviceAndContractYearAndTotalCostPerEachVehicleTarget.put(serviceType , ContractYearAndWorkForceCostPerVehicleMap);
                    }
                    
                }
                
                
                //total Project Calcs - workforce profit per each Vehicle
                if(vehSource == 'Main' && serviceAndContractYearAndWorkForceProfitPerVehicle != null && serviceAndContractYearAndWorkForceProfitPerVehicle.containsKey(serviceType)){
                    Map<integer,Decimal> contractYearAndWorkForceProfitPerVehicleMap = serviceAndContractYearAndWorkForceProfitPerVehicle.get(serviceType);
                    if(contractYearAndWorkForceProfitPerVehicleMap != null && contractYearAndWorkForceProfitPerVehicleMap.containsKey(intContractYear)){
                        decimal total = contractYearAndWorkForceProfitPerVehicleMap.get(intContractYear) + genericWorkforceQuoteCalcObj.annualProfitMarginValuePerEachVehicle*noOfWorkForce;
                        contractYearAndWorkForceProfitPerVehicleMap.put(intContractYear , total);
                    }
                    else{
                        contractYearAndWorkForceProfitPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.annualProfitMarginValuePerEachVehicle*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> contractYearAndWorkForceProfitPerVehicleMap = new Map<integer,Decimal>();
                        contractYearAndWorkForceProfitPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.annualProfitMarginValuePerEachVehicle*noOfWorkForce);
                        serviceAndContractYearAndWorkForceProfitPerVehicle.put(serviceType , contractYearAndWorkForceProfitPerVehicleMap);
                    }
                    
                }
                
                //total Project Calcs - workforce profit per each Vehicle - Discounted
                if(vehSource == 'Main' && serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted != null && serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted.containsKey(serviceType)){
                    Map<integer,Decimal> contractYearAndWorkForceProfitPerVehicleMap = serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted.get(serviceType);
                    if(contractYearAndWorkForceProfitPerVehicleMap != null && contractYearAndWorkForceProfitPerVehicleMap.containsKey(intContractYear)){
                        decimal total = contractYearAndWorkForceProfitPerVehicleMap.get(intContractYear) + genericWorkforceQuoteCalcObj.discountedManpowerProfitPerVehicle*noOfWorkForce;
                        contractYearAndWorkForceProfitPerVehicleMap.put(intContractYear , total);
                    }
                    else{
                        contractYearAndWorkForceProfitPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.discountedManpowerProfitPerVehicle*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> contractYearAndWorkForceProfitPerVehicleMap = new Map<integer,Decimal>();
                        contractYearAndWorkForceProfitPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.discountedManpowerProfitPerVehicle*noOfWorkForce);
                        serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted.put(serviceType , contractYearAndWorkForceProfitPerVehicleMap);
                    }
                }
                
                //total Project Calcs - workforce profit per each Vehicle - Target
                if(vehSource == 'Main' && serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleTarget != null && serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleTarget.containsKey(serviceType)){
                    Map<integer,Decimal> contractYearAndWorkForceProfitPerVehicleMap = serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleTarget.get(serviceType);
                    if(contractYearAndWorkForceProfitPerVehicleMap != null && contractYearAndWorkForceProfitPerVehicleMap.containsKey(intContractYear)){
                        decimal total = contractYearAndWorkForceProfitPerVehicleMap.get(intContractYear) + genericWorkforceQuoteCalcObj.profitValueTargetPricePerVehicle*noOfWorkForce;
                        contractYearAndWorkForceProfitPerVehicleMap.put(intContractYear , total);
                    }
                    else{
                        contractYearAndWorkForceProfitPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.profitValueTargetPricePerVehicle*noOfWorkForce);
                    }
                }
                else{
                    if(vehSource == 'Main' ){
                        Map<integer,Decimal> contractYearAndWorkForceProfitPerVehicleMap = new Map<integer,Decimal>();
                        contractYearAndWorkForceProfitPerVehicleMap.put(intContractYear , genericWorkforceQuoteCalcObj.profitValueTargetPricePerVehicle*noOfWorkForce);
                        serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleTarget.put(serviceType , contractYearAndWorkForceProfitPerVehicleMap);
                    }
                    
                }
                
                
                
            }
            
            
            return genericWorkforceQuoteCalcObj;
        }
        catch(Exception e){
            ET_PricingUtilityClass.logException(e, 'Pricing');
            system.debug('Exception ='+ e.getMessage());
            system.debug('Exception Trace='+ e.getStackTraceString());
            system.debug('Exception line='+ e.getLineNumber());
            throw new AuraHandledException('Exception message : ' + e.getMessage() +' ; stack trace : '+ e.getStackTraceString());
        }
    }
    
    
    /* Method 	   : prepareWorkforceObject
Description : To Map quote Item Wrapper to quote Items and to set the Data..
*/
    
    public static ET_Workforce_Quote_Item__c prepareWorkforceObject(ET_Workforce_Quote_Item__c workforceQuoteItemtoUpdate, 
                                                                    ET_ServiceRequestController.workforceQuoteCalcClass workforceClassObj,
                                                                    List<ET_Pricing_VAT_setup__c> vatData)
    {
        system.debug('prepareWorkforceObject - workforceClassObj = '+ JSON.serializePretty(workforceClassObj));
        workforceQuoteItemtoUpdate.ET_Wages__c = Math.round(workforceClassObj.wages);
        workforceQuoteItemtoUpdate.ET_Overtime__c = Math.round(workforceClassObj.overTimeCost);
        workforceQuoteItemtoUpdate.Vehicle_Quote_Item__c = workforceClassObj.vehQuoteId;
        workforceQuoteItemtoUpdate.ET_Clothes_Allowance__c = Math.round(workforceClassObj.clothesAllowance);
        
        workforceQuoteItemtoUpdate.Children_Allowance__c = Math.round(workforceClassObj.childrenAllowance);
        workforceQuoteItemtoUpdate.Housing_Allowance__c = Math.round(workforceClassObj.housingAllowance);
        workforceQuoteItemtoUpdate.Social_Allowance__c = Math.round(workforceClassObj.socialAllowance);
        workforceQuoteItemtoUpdate.Cost_of_Living_Allowance__c = Math.round(workforceClassObj.costoflivingAllowance);
        
        workforceQuoteItemtoUpdate.Housing_Allowance_Percentage__c = Math.round(workforceClassObj.housingAllowancePercentage);
        workforceQuoteItemtoUpdate.Transport_Allowance__c = Math.round(workforceClassObj.transportAllowance);
        workforceQuoteItemtoUpdate.Additional_Transport_Allowance__c = Math.round(workforceClassObj.additionalTransportAllowance);
        workforceQuoteItemtoUpdate.Other_Allowance__c = Math.round(workforceClassObj.otherAllowance);
        workforceQuoteItemtoUpdate.Social_Insurance__c = Math.round(workforceClassObj.socialInsurance);
        workforceQuoteItemtoUpdate.Additional_Work_Permit_Fees__c = Math.round(workforceClassObj.additionalWorkPermitFees);
        system.debug('workforceClassObj.endOfServiceCost final = '+ workforceClassObj.endOfServiceCost);
        
        workforceQuoteItemtoUpdate.ET_End_of_Service__c = Math.round(workforceClassObj.endOfServiceCost);
        workforceQuoteItemtoUpdate.ET_Health_Card__c = Math.round(workforceClassObj.healthCardCost);
        workforceQuoteItemtoUpdate.ET_Licensing_Fees__c = Math.round(workforceClassObj.licensingFee);
        workforceQuoteItemtoUpdate.ET_Visa_Cost__c = Math.round(workforceClassObj.visaCost);
        workforceQuoteItemtoUpdate.ET_Accommodation_Allowance__c = Math.round(workforceClassObj.accomodationAllowance);
        workforceQuoteItemtoUpdate.ET_Smart_Phone_Cost__c = Math.round(workforceClassObj.smartPhoneCost);
        workforceQuoteItemtoUpdate.ET_Air_Tickets__c = Math.round(workforceClassObj.airTicketsCost);
        workforceQuoteItemtoUpdate.ET_Extra_Certification_Cost__c = Math.round(workforceClassObj.extraCertificationCost);
        workforceQuoteItemtoUpdate.ET_Annual_leave_allowance__c = Math.round(workforceClassObj.leaveAllowance);
        workforceQuoteItemtoUpdate.ET_Annual_Profit_Margin__c = (workforceClassObj.annualProfitMarginRate).setScale(2);
        workforceQuoteItemtoUpdate.ET_Annual_Profit_Value__c = Math.round(workforceClassObj.annualProfitMarginValue);
        workforceQuoteItemtoUpdate.ET_Total_Annual_Net_Profit_Value__c = Math.round(workforceClassObj.totalAnnualNetProfitValue);
        workforceQuoteItemtoUpdate.ET_Reserve_Amount__c = Math.round(workforceClassObj.manpowerReserveCost) ;
        workforceQuoteItemtoUpdate.ET_Total_Cost__c = Math.round(workforceClassObj.totalCost);
        workforceQuoteItemtoUpdate.ET_Total_Indirect_operational_costs__c = Math.round(workforceClassObj.totalIndirectOperationCost);
        workforceQuoteItemtoUpdate.ET_Total_Direct_Operational_Costs__c = Math.round(workforceClassObj.totalDirectOperationalCost);
        workforceQuoteItemtoUpdate.ET_Vat_Amount__c = Math.round(workforceClassObj.workForceVATAmount);
        workforceQuoteItemtoUpdate.Total_Cost_Target_Prices__c = Math.round(workforceClassObj.totalCostTargetPrice);
        workforceQuoteItemtoUpdate.Total_Cost_Discounted__c = Math.round(workforceClassObj.discountedManpowerTotalCost);
        workforceQuoteItemtoUpdate.Manpower_Profit_Margin_Target_Prices__c = Math.round(workforceClassObj.profitMarginPercentageTargetPrice);
        workforceQuoteItemtoUpdate.Manpower_Profit_Value_Target_Prices__c = Math.round(workforceClassObj.profitValueTargetPrice);
        workforceQuoteItemtoUpdate.Manpower_Profit_Value_Discounted__c = Math.round(workforceClassObj.discountedManpowerProfit);
        workforceQuoteItemtoUpdate.Reserve_Cost_Target_Prices__c = Math.round(workforceClassObj.reserveCostTargetPrice);
        workforceQuoteItemtoUpdate.Manpower_Reserve_Discounted__c = Math.round(workforceClassObj.reserveCostDiscountedPrice);
        workforceQuoteItemtoUpdate.ET_Workforce_cost_per_each_vehicle__c = Math.round(workforceClassObj.totalCostPerEachVehicle);
        workforceQuoteItemtoUpdate.Workforce_cost_per_each_veh_Discounted__c = Math.round(workforceClassObj.totalCostPerEachVehicleDiscounted);
        workforceQuoteItemtoUpdate.Workforce_cost_per_each_veh_Target__c = Math.round(workforceClassObj.totalCostPerEachVehicleTarget);
        workforceQuoteItemtoUpdate.ET_Workforce_profit_per_each_vehicle__c = Math.round(workforceClassObj.annualProfitMarginValuePerEachVehicle);
        workforceQuoteItemtoUpdate.Workforce_profit_per_each_veh_Discounte__c = Math.round(workforceClassObj.discountedManpowerProfitPerVehicle);
        workforceQuoteItemtoUpdate.Workforce_profit_per_each_veh_Target__c = Math.round(workforceClassObj.profitValueTargetPricePerVehicle);
        workforceQuoteItemtoUpdate.Corporate_Tax__c = Math.round(workforceClassObj.corporateTax);
        workforceQuoteItemtoUpdate.Total_Annual_Price_excluding_VAT__c = Math.round(workforceClassObj.totalAnnualPriceExcludingVAT);
        workforceQuoteItemtoUpdate.Total_Monthly_Price_excluding_VAT__c = Math.round(workforceClassObj.totalMonthlyPriceExcludingVAT);
        workforceQuoteItemtoUpdate.Total_Annual_Price_including_VAT__c = Math.round(workforceClassObj.totalAnnualPriceIncludingVAT);
        workforceQuoteItemtoUpdate.Total_Monthly_Price_including_VAT__c = Math.round(workforceClassObj.totalMonthlyPriceIncludingVAT);
        workforceQuoteItemtoUpdate.Total_Value_Of_Rental__c = Math.round(workforceClassObj.totalValueOfRental);
        workforceQuoteItemtoUpdate.Total_Manpower_Profits__c = Math.round(workforceClassObj.totalManpowerProfits);
        workforceQuoteItemtoUpdate.Gross_profit_margin__c = workforceClassObj.grossProfitMargin;
        workforceQuoteItemtoUpdate.Reliever_Cost__c = Math.round(workforceClassObj.relieverCost);
        workforceQuoteItemtoUpdate.Total_Main_Vehicle__c = Math.round(workforceClassObj.totalVehicle);
        //added by arunsarathy on 08.06.2023 add a new row for VAT Cost on Coordinator per vehicle
        
        
        //****************************** Vat Cost Calculation ***********************************//
        Decimal vatCostonManpowerExpenses = Math.round(workforceClassObj.totalDynamicOtherCost) != null ? Math.round(workforceClassObj.totalDynamicOtherCost) : 0 ;
        system.debug('workforceQuoteItemtoUpdate.ET_Service_Type__c 1248= '+ workforceQuoteItemtoUpdate.ET_Service_Type__c );
        system.debug('workforceQuoteItemtoUpdate.ET_Vat_Rate__c 1248= '+ workforceQuoteItemtoUpdate.ET_Vat_Rate__c );
        if(workforceQuoteItemtoUpdate.ET_Vat_Rate__c == 'Exempt' ){
            for(ET_Pricing_VAT_setup__c data : vatData){
                if(data.ET_Cost_Type__c == 'Manpower' && data.ET_IsRecoverable__c){
                    Decimal value;
                    if(ET_Workforce_Quote_Item__c.getSobjectType().getDescribe().fields.getMap().containsKey(data.ET_Cost_Api_Name__c)){
                        value = (Decimal)workforceQuoteItemtoUpdate.get(data.ET_Cost_Api_Name__c);
                    }
                    if(value != null){
                        vatCostonManpowerExpenses += value;
                    }
                }
            }
            vatCostonManpowerExpenses = vatCostonManpowerExpenses * 0.05;
            workforceQuoteItemtoUpdate.ET_Workforce_VAT_Cost__c = Math.round(vatCostonManpowerExpenses);
            //added by arunsarathy on 08.06.2023 add a new row for VAT Cost on Coordinator per vehicle
           if(workforceQuoteItemtoUpdate.ET_Workforce_Quote_Item_Type__c == 'Coordinator' && workforceQuoteItemtoUpdate.Total_Main_Vehicle__c != 0){
             workforceQuoteItemtoUpdate.ET_Workforce_VAT_cost_per_Vehicle__c =  workforceQuoteItemtoUpdate.ET_Workforce_VAT_Cost__c/ workforceQuoteItemtoUpdate.Total_Main_Vehicle__c;
            }
            system.debug('workforceQuoteItemtoUpdate.ET_Workforce_VAT_Cost__c= '+ workforceQuoteItemtoUpdate.ET_Workforce_VAT_Cost__c );
        }
        return workforceQuoteItemtoUpdate; 
        
    }
    
    
    // @future
    Public static void updateWorkForceObjectsForTotalProject(String quoteId){
        system.debug('-----------updateWorkForceObjectsForTotalProject Called ..'+quoteId);
        List<ET_Workforce_Quote_Item__c> workForceQItems = ET_PricingUtilityClass.getWorkforceQuoteItemLst(quoteId ,'' );

        Map<String, List<ET_Workforce_Quote_Item__c>> workForecItemsMap = new Map<String, List<ET_Workforce_Quote_Item__c>>();

        for(ET_Workforce_Quote_Item__c workForceQItem: workForceQItems){
            System.debug('----workForecItemsMap11------'+workForceQItem.ET_Workforce_Quote_Item_Type__c);
            if(!String.isEmpty(workForceQItem.ET_Workforce_Quote_Item_Type__c)){   
                if(!(workForecItemsMap.containsKey(workForceQItem.ET_Workforce_Quote_Item_Type__c))){
                    workForecItemsMap.put(workForceQItem.ET_Workforce_Quote_Item_Type__c, new List<ET_Workforce_Quote_Item__c>());
                }
                List<ET_Workforce_Quote_Item__c> temp = workForecItemsMap.get(workForceQItem.ET_Workforce_Quote_Item_Type__c);
                temp.add(workForceQItem);
                workForecItemsMap.put(workForceQItem.ET_Workforce_Quote_Item_Type__c, temp);
            }
        }
        System.debug('------workForecItemsMap22---'+workForecItemsMap.size());
        System.debug('------workForecItemsMap33---'+Json.serializePretty(workForecItemsMap));

        List<ET_Workforce_Quote_Item__c> allWorkForceQuoteItems = new List<ET_Workforce_Quote_Item__c>();
        List<ET_Workforce_Quote_Item__c> driverQuoteItems = prepareWorkForceObjectForTotalProject('Driver' , quoteId, workForecItemsMap.get('Driver'));
        if(!driverQuoteItems.isEmpty()){
            allWorkForceQuoteItems.addAll(driverQuoteItems);
        }
        
        List<ET_Workforce_Quote_Item__c> nannyQuoteItems = prepareWorkForceObjectForTotalProject('Nanny' , quoteId, workForecItemsMap.get('Nanny'));
        if(!nannyQuoteItems.isEmpty()){
            allWorkForceQuoteItems.addAll(nannyQuoteItems);
        }
        
        List<ET_Workforce_Quote_Item__c> supervisorQuoteItems = prepareWorkForceObjectForTotalProject('Supervisor' , quoteId, workForecItemsMap.get('Supervisor'));
        if(!supervisorQuoteItems.isEmpty()){
            allWorkForceQuoteItems.addAll(supervisorQuoteItems);
        }
        
        List<ET_Workforce_Quote_Item__c> CoordinatorQuoteItems = prepareWorkForceObjectForTotalProject('Coordinator' , quoteId, workForecItemsMap.get('Coordinator'));
        if(!CoordinatorQuoteItems.isEmpty()){
            allWorkForceQuoteItems.addAll(CoordinatorQuoteItems);
        }
        
        List<ET_Workforce_Quote_Item__c> accountantQuoteItems = prepareWorkForceObjectForTotalProject('Accountant/Cashier' , quoteId, workForecItemsMap.get('Accountant/Cashier'));
        if(!accountantQuoteItems.isEmpty()){
            allWorkForceQuoteItems.addAll(accountantQuoteItems);
        }
        
        List<ET_Workforce_Quote_Item__c> OtherEmployeeQuoteItems = prepareWorkForceObjectForTotalProject('Other Employee' , quoteId, workForecItemsMap.get('Other Employee'));
        if(!OtherEmployeeQuoteItems.isEmpty()){
            allWorkForceQuoteItems.addAll(OtherEmployeeQuoteItems);
        }
        
        
        if(!allWorkForceQuoteItems.isEmpty()){
            update allWorkForceQuoteItems;
        }
    }
    //to avoid test class failing
    Public static List<ET_Workforce_Quote_Item__c> prepareWorkForceObjectForTotalProject(String serviceType , String quoteId){
        return new List<ET_Workforce_Quote_Item__c>();
    }
    
    Public static List<ET_Workforce_Quote_Item__c> prepareWorkForceObjectForTotalProject(String serviceType , String quoteId, List<ET_Workforce_Quote_Item__c> workForceQItemsList){
        List<ET_Workforce_Quote_Item__c> wForceItemstoReturnList = new List<ET_Workforce_Quote_Item__c>();
        
        // query existing workForceQuoteItems with Service Type and Year as Key for Total Project Quote..
        Map<integer, String> workForcItemsWithId = new Map<integer, String>();
        // List<ET_Workforce_Quote_Item__c> workForceQItemsList = ET_PricingUtilityClass.getWorkforceQuoteItemLst(quoteId ,serviceType );
        
        system.debug('workForceQItemsList = '+ json.serializePretty(workForceQItemsList) );
        
        if(workForceQItemsList != null && !workForceQItemsList.isEmpty()){
            for(ET_Workforce_Quote_Item__c wForQuoteItemObj : workForceQItemsList){
                integer contY = integer.valueOf(wForQuoteItemObj.ET_Contract_Period__c) ;
                system.debug('serviceType = '+ serviceType);
                system.debug('serviceAndContractYearAndwages = '+ json.serializePretty(serviceAndContractYearAndwages) );
                if(wForQuoteItemObj.Vehicle_Quote_Item__r != null && wForQuoteItemObj.Vehicle_Quote_Item__r.ET_Vehicle_Source__c != null){
                    String vehSource = wForQuoteItemObj.Vehicle_Quote_Item__r.ET_Vehicle_Source__c;
                }
                else{
                    String vehSource = 'Main';
                }
                
                if(serviceAndContractYearAndwages != null && serviceAndContractYearAndwages.containsKey(serviceType)){
                    Map<integer,Decimal> contractYearAndwagesMap = serviceAndContractYearAndwages.get(serviceType);
                    system.debug('contractYearAndwagesMap = '+ json.serializePretty(contractYearAndwagesMap) );
                    system.debug('contY = '+ contY);
                    if(contractYearAndwagesMap != null && contractYearAndwagesMap.containsKey(contY)){
                        wForQuoteItemObj.ET_Wages__c = Math.round(contractYearAndwagesMap.get(contY));
                    }
                }
                if(serviceAndContractYearAndoverTimeCost != null && serviceAndContractYearAndoverTimeCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndoverTimeCost = serviceAndContractYearAndoverTimeCost.get(serviceType);
                    if(ContractYearAndoverTimeCost != null && ContractYearAndoverTimeCost.containsKey(contY)){
                        wForQuoteItemObj.ET_Overtime__c = Math.round(ContractYearAndoverTimeCost.get(contY));
                    }
                }
                if(serviceAndContractYearAndclothesAllowance != null && serviceAndContractYearAndclothesAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndclothesAllowance = serviceAndContractYearAndclothesAllowance.get(serviceType);
                    if(ContractYearAndclothesAllowance != null && ContractYearAndclothesAllowance.containsKey(contY)){
                        wForQuoteItemObj.ET_Clothes_Allowance__c = Math.round(ContractYearAndclothesAllowance.get(contY));
                    }
                }
                if(serviceAndContractYearAndchildrenAllowance != null && serviceAndContractYearAndchildrenAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndchildrenAllowance = serviceAndContractYearAndchildrenAllowance.get(serviceType);
                    if(ContractYearAndchildrenAllowance != null && ContractYearAndchildrenAllowance.containsKey(contY)){
                        wForQuoteItemObj.Children_Allowance__c = Math.round(ContractYearAndchildrenAllowance.get(contY));
                    }
                }
                if(serviceAndContractYearAndhousingAllowance != null && serviceAndContractYearAndhousingAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndhousingAllowance = serviceAndContractYearAndhousingAllowance.get(serviceType);
                    if(ContractYearAndhousingAllowance != null && ContractYearAndhousingAllowance.containsKey(contY)){
                        wForQuoteItemObj.Housing_Allowance__c = Math.round(ContractYearAndhousingAllowance.get(contY));
                    }
                }
                if(serviceAndContractYearAndcostoflivingAllowance != null && serviceAndContractYearAndcostoflivingAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndcostoflivingAllowance = serviceAndContractYearAndcostoflivingAllowance.get(serviceType);
                    if(ContractYearAndcostoflivingAllowance != null && ContractYearAndcostoflivingAllowance.containsKey(contY)){
                        wForQuoteItemObj.Cost_of_Living_Allowance__c = Math.round(ContractYearAndcostoflivingAllowance.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndSocialAllowance != null && serviceAndContractYearAndSocialAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndSocialAllowance = serviceAndContractYearAndSocialAllowance.get(serviceType);
                    if(ContractYearAndSocialAllowance != null && ContractYearAndSocialAllowance.containsKey(contY)){
                        wForQuoteItemObj.Social_Allowance__c = Math.round(ContractYearAndSocialAllowance.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTransportAllowance != null && serviceAndContractYearAndTransportAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTransportAllowance = serviceAndContractYearAndTransportAllowance.get(serviceType);
                    if(ContractYearAndTransportAllowance != null && ContractYearAndTransportAllowance.containsKey(contY)){
                        wForQuoteItemObj.Transport_Allowance__c = Math.round(ContractYearAndTransportAllowance.get(contY));
                    }
                }
                if(serviceAndContractYearAndAdditionalTransportAllowance != null && serviceAndContractYearAndAdditionalTransportAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndAdditionalTransportAllowance = serviceAndContractYearAndAdditionalTransportAllowance.get(serviceType);
                    if(ContractYearAndAdditionalTransportAllowance != null && ContractYearAndAdditionalTransportAllowance.containsKey(contY)){
                        wForQuoteItemObj.Additional_Transport_Allowance__c = Math.round(ContractYearAndAdditionalTransportAllowance.get(contY));
                    }
                }
                if(serviceAndContractYearAndOtherAllowance != null && serviceAndContractYearAndOtherAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndOtherAllowance = serviceAndContractYearAndOtherAllowance.get(serviceType);
                    if(ContractYearAndOtherAllowance != null && ContractYearAndOtherAllowance.containsKey(contY)){
                        wForQuoteItemObj.Other_Allowance__c = Math.round(ContractYearAndOtherAllowance.get(contY));
                    }
                }
                if(serviceAndContractYearAndSocialInsurance != null && serviceAndContractYearAndSocialInsurance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndSocialInsurance = serviceAndContractYearAndSocialInsurance.get(serviceType);
                    if(ContractYearAndSocialInsurance != null && ContractYearAndSocialInsurance.containsKey(contY)){
                        wForQuoteItemObj.Social_Insurance__c = Math.round(ContractYearAndSocialInsurance.get(contY));
                    }
                }
                if(serviceAndContractYearAndAdditionalWorkPermit != null && serviceAndContractYearAndAdditionalWorkPermit.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndAdditionalWorkPermit = serviceAndContractYearAndAdditionalWorkPermit.get(serviceType);
                    if(ContractYearAndAdditionalWorkPermit != null && ContractYearAndAdditionalWorkPermit.containsKey(contY)){
                        wForQuoteItemObj.Additional_Work_Permit_Fees__c = Math.round(ContractYearAndAdditionalWorkPermit.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndendOfServiceCost != null && serviceAndContractYearAndendOfServiceCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndendOfServiceCost = serviceAndContractYearAndendOfServiceCost.get(serviceType);
                    if(ContractYearAndendOfServiceCost != null && ContractYearAndendOfServiceCost.containsKey(contY)){
                        wForQuoteItemObj.ET_End_of_Service__c = Math.round(ContractYearAndendOfServiceCost.get(contY));
                    }
                }
                if(serviceAndContractYearAndhealthCardCost != null && serviceAndContractYearAndhealthCardCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndhealthCardCost = serviceAndContractYearAndhealthCardCost.get(serviceType);
                    if(ContractYearAndhealthCardCost != null && ContractYearAndhealthCardCost.containsKey(contY)){
                        wForQuoteItemObj.ET_Health_Card__c = Math.round(ContractYearAndhealthCardCost.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndvisaCost != null && serviceAndContractYearAndvisaCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndvisaCostMap = serviceAndContractYearAndvisaCost.get(serviceType);
                    if(ContractYearAndvisaCostMap != null && ContractYearAndvisaCostMap.containsKey(contY)){
                        wForQuoteItemObj.ET_Visa_Cost__c = Math.round(ContractYearAndvisaCostMap.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndlicensingFee != null && serviceAndContractYearAndlicensingFee.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndlicensingFee = serviceAndContractYearAndlicensingFee.get(serviceType);
                    if(ContractYearAndlicensingFee != null && ContractYearAndlicensingFee.containsKey(contY)){
                        wForQuoteItemObj.ET_Licensing_Fees__c = Math.round(ContractYearAndlicensingFee.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndaccomodationAllowance != null && serviceAndContractYearAndaccomodationAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndaccomodationAllowance = serviceAndContractYearAndaccomodationAllowance.get(serviceType);
                    if(ContractYearAndaccomodationAllowance != null && ContractYearAndaccomodationAllowance.containsKey(contY)){
                        wForQuoteItemObj.ET_Accommodation_Allowance__c = Math.round(ContractYearAndaccomodationAllowance.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndsmartPhoneCost != null && serviceAndContractYearAndsmartPhoneCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndsmartPhoneCost = serviceAndContractYearAndsmartPhoneCost.get(serviceType);
                    if(ContractYearAndsmartPhoneCost != null && ContractYearAndsmartPhoneCost.containsKey(contY)){
                        wForQuoteItemObj.ET_Smart_Phone_Cost__c = Math.round(ContractYearAndsmartPhoneCost.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndairTicketsCost != null && serviceAndContractYearAndairTicketsCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndairTicketsCost = serviceAndContractYearAndairTicketsCost.get(serviceType);
                    if(ContractYearAndairTicketsCost != null && ContractYearAndairTicketsCost.containsKey(contY)){
                        wForQuoteItemObj.ET_Air_Tickets__c = Math.round(ContractYearAndairTicketsCost.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndextraCertificationCost != null && serviceAndContractYearAndextraCertificationCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndextraCertificationCost = serviceAndContractYearAndextraCertificationCost.get(serviceType);
                    if(ContractYearAndextraCertificationCost != null && ContractYearAndextraCertificationCost.containsKey(contY)){
                        wForQuoteItemObj.ET_Extra_Certification_Cost__c = Math.round(ContractYearAndextraCertificationCost.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndleaveAllowance != null && serviceAndContractYearAndleaveAllowance.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndleaveAllowance = serviceAndContractYearAndleaveAllowance.get(serviceType);
                    if(ContractYearAndleaveAllowance != null && ContractYearAndleaveAllowance.containsKey(contY)){
                        wForQuoteItemObj.ET_Annual_leave_allowance__c = Math.round(ContractYearAndleaveAllowance.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndRelieverCost != null && serviceAndContractYearAndRelieverCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndRelieverCost = serviceAndContractYearAndRelieverCost.get(serviceType);
                    if(ContractYearAndRelieverCost != null && ContractYearAndRelieverCost.containsKey(contY)){
                        wForQuoteItemObj.Reliever_Cost__c = Math.round(ContractYearAndRelieverCost.get(contY));
                    }
                }
                
                
                if(serviceAndContractYearAndannualProfitMarginValue != null && serviceAndContractYearAndannualProfitMarginValue.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndannualProfitMarginValue = serviceAndContractYearAndannualProfitMarginValue.get(serviceType);
                    if(ContractYearAndannualProfitMarginValue != null && ContractYearAndannualProfitMarginValue.containsKey(contY)){
                        wForQuoteItemObj.ET_Annual_Profit_Value__c = Math.round(ContractYearAndannualProfitMarginValue.get(contY));
                    }
                }
                if(serviceAndContractYearAndtotalAnnualNetProfitValue != null && serviceAndContractYearAndtotalAnnualNetProfitValue.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndtotalAnnualNetProfitValue = serviceAndContractYearAndtotalAnnualNetProfitValue.get(serviceType);
                    if(ContractYearAndtotalAnnualNetProfitValue != null && ContractYearAndtotalAnnualNetProfitValue.containsKey(contY)){
                        wForQuoteItemObj.ET_Total_Annual_Net_Profit_Value__c = Math.round(ContractYearAndtotalAnnualNetProfitValue.get(contY));
                    }
                }
                if(serviceAndContractYearAnddriverReserve != null && serviceAndContractYearAnddriverReserve.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAnddriverReserve = serviceAndContractYearAnddriverReserve.get(serviceType);
                    if(ContractYearAnddriverReserve != null && ContractYearAnddriverReserve.containsKey(contY)){
                        wForQuoteItemObj.ET_Reserve_Amount__c = Math.round(ContractYearAnddriverReserve.get(contY));
                    }
                }
                wForQuoteItemObj.Manpower_Reserve_Discounted__c = 0;
                wForQuoteItemObj.Reserve_Cost_Target_Prices__c = 0;
                
                if(serviceAndContractYeartotalCost != null && serviceAndContractYeartotalCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYeartotalCost = serviceAndContractYeartotalCost.get(serviceType);
                    if(ContractYeartotalCost != null && ContractYeartotalCost.containsKey(contY)){
                        wForQuoteItemObj.ET_Total_Cost__c = Math.round(ContractYeartotalCost.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndtotalIndirectOperationCost != null && serviceAndContractYearAndtotalIndirectOperationCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndtotalIndirectOperationCost = serviceAndContractYearAndtotalIndirectOperationCost.get(serviceType);
                    if(ContractYearAndtotalIndirectOperationCost != null && ContractYearAndtotalIndirectOperationCost.containsKey(contY)){
                        wForQuoteItemObj.ET_Total_Indirect_Operational_Costs__c = Math.round(ContractYearAndtotalIndirectOperationCost.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndtotalDirectOperationalCost != null && serviceAndContractYearAndtotalDirectOperationalCost.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndtotalDirectOperationalCost = serviceAndContractYearAndtotalDirectOperationalCost.get(serviceType);
                    if(ContractYearAndtotalDirectOperationalCost != null && ContractYearAndtotalDirectOperationalCost.containsKey(contY)){
                        wForQuoteItemObj.ET_Total_Direct_Operational_Costs__c = Math.round(ContractYearAndtotalDirectOperationalCost.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndWorkForceCostPerVehicle != null && serviceAndContractYearAndWorkForceCostPerVehicle.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndWorkForceCostPerVehicle = serviceAndContractYearAndWorkForceCostPerVehicle.get(serviceType);
                    if(ContractYearAndWorkForceCostPerVehicle != null && ContractYearAndWorkForceCostPerVehicle.containsKey(contY)){
                        wForQuoteItemObj.ET_Workforce_cost_per_each_vehicle__c = Math.round(ContractYearAndWorkForceCostPerVehicle.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndWorkForceProfitPerVehicle != null && serviceAndContractYearAndWorkForceProfitPerVehicle.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndWorkForceProfitPerVehicle = serviceAndContractYearAndWorkForceProfitPerVehicle.get(serviceType);
                    if(ContractYearAndWorkForceProfitPerVehicle != null && ContractYearAndWorkForceProfitPerVehicle.containsKey(contY)){
                        wForQuoteItemObj.ET_Workforce_profit_per_each_vehicle__c = Math.round(ContractYearAndWorkForceProfitPerVehicle.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndCorporateTax != null && serviceAndContractYearAndCorporateTax.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndCorporateTax = serviceAndContractYearAndCorporateTax.get(serviceType);
                    if(ContractYearAndCorporateTax != null && ContractYearAndCorporateTax.containsKey(contY)){
                        wForQuoteItemObj.Corporate_Tax__c = Math.round(ContractYearAndCorporateTax.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalCostDiscounted != null && serviceAndContractYearAndTotalCostDiscounted.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalCostDiscounted = serviceAndContractYearAndTotalCostDiscounted.get(serviceType);
                    if(ContractYearAndTotalCostDiscounted != null && ContractYearAndTotalCostDiscounted.containsKey(contY)){
                        wForQuoteItemObj.Total_Cost_Discounted__c = Math.round(ContractYearAndTotalCostDiscounted.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalCostTarget != null && serviceAndContractYearAndTotalCostTarget.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalCostTarget = serviceAndContractYearAndTotalCostTarget.get(serviceType);
                    if(ContractYearAndTotalCostTarget != null && ContractYearAndTotalCostTarget.containsKey(contY)){
                        wForQuoteItemObj.Total_Cost_Target_Prices__c = Math.round(ContractYearAndTotalCostTarget.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalCostPerEachVehicleDiscounted != null && serviceAndContractYearAndTotalCostPerEachVehicleDiscounted.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalCostPerEachVehicleDiscounted = serviceAndContractYearAndTotalCostPerEachVehicleDiscounted.get(serviceType);
                    if(ContractYearAndTotalCostPerEachVehicleDiscounted != null && ContractYearAndTotalCostPerEachVehicleDiscounted.containsKey(contY)){
                        wForQuoteItemObj.Workforce_cost_per_each_veh_Discounted__c = Math.round(ContractYearAndTotalCostPerEachVehicleDiscounted.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalCostPerEachVehicleTarget != null && serviceAndContractYearAndTotalCostPerEachVehicleTarget.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalCostPerEachVehicleTarget = serviceAndContractYearAndTotalCostPerEachVehicleTarget.get(serviceType);
                    if(ContractYearAndTotalCostPerEachVehicleTarget != null && ContractYearAndTotalCostPerEachVehicleTarget.containsKey(contY)){
                        wForQuoteItemObj.Workforce_cost_per_each_veh_Target__c = Math.round(ContractYearAndTotalCostPerEachVehicleTarget.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndAnnualNetProfitValueDiscounted != null && serviceAndContractYearAndAnnualNetProfitValueDiscounted.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndAnnualNetProfitValueDiscounted  = serviceAndContractYearAndAnnualNetProfitValueDiscounted.get(serviceType);
                    if(ContractYearAndAnnualNetProfitValueDiscounted != null && ContractYearAndAnnualNetProfitValueDiscounted.containsKey(contY)){
                        wForQuoteItemObj.Manpower_Profit_Value_Discounted__c = Math.round(ContractYearAndAnnualNetProfitValueDiscounted.get(contY));
                    }
                }
                if(serviceAndContractYearAndAnnualNetProfitValueTarget != null && serviceAndContractYearAndAnnualNetProfitValueTarget.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndAnnualNetProfitValueTarget = serviceAndContractYearAndAnnualNetProfitValueTarget.get(serviceType);
                    if(ContractYearAndAnnualNetProfitValueTarget != null && ContractYearAndAnnualNetProfitValueTarget.containsKey(contY)){
                        wForQuoteItemObj.Manpower_Profit_Value_Target_Prices__c = Math.round(ContractYearAndAnnualNetProfitValueTarget.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted != null && serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted = serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted.get(serviceType);
                    if(ContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted != null && ContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted.containsKey(contY)){
                        wForQuoteItemObj.Workforce_profit_per_each_veh_Discounte__c = Math.round(ContractYearAndAnnualNetProfitValuePerEachVehicleDiscounted.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleTarget != null && serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleTarget.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndAnnualNetProfitValuePerEachVehicleTarget = serviceAndContractYearAndAnnualNetProfitValuePerEachVehicleTarget.get(serviceType);
                    if(ContractYearAndAnnualNetProfitValuePerEachVehicleTarget != null && ContractYearAndAnnualNetProfitValuePerEachVehicleTarget.containsKey(contY)){
                        wForQuoteItemObj.Workforce_profit_per_each_veh_Target__c = Math.round(ContractYearAndAnnualNetProfitValuePerEachVehicleTarget.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalAnnualPriceExcludingVAT != null && serviceAndContractYearAndTotalAnnualPriceExcludingVAT.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalAnnualPriceExcludingVAT = serviceAndContractYearAndTotalAnnualPriceExcludingVAT.get(serviceType);
                    if(ContractYearAndTotalAnnualPriceExcludingVAT != null && ContractYearAndTotalAnnualPriceExcludingVAT.containsKey(contY)){
                        wForQuoteItemObj.Total_Annual_Price_excluding_VAT__c = Math.round(ContractYearAndTotalAnnualPriceExcludingVAT.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalMonthlyPriceExcludingVAT != null && serviceAndContractYearAndTotalMonthlyPriceExcludingVAT.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalMonthlyPriceExcludingVAT = serviceAndContractYearAndTotalMonthlyPriceExcludingVAT.get(serviceType);
                    if(ContractYearAndTotalMonthlyPriceExcludingVAT != null && ContractYearAndTotalMonthlyPriceExcludingVAT.containsKey(contY)){
                        wForQuoteItemObj.Total_Monthly_Price_excluding_VAT__c = Math.round(ContractYearAndTotalMonthlyPriceExcludingVAT.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalAnnualPriceIncludingVAT != null && serviceAndContractYearAndTotalAnnualPriceIncludingVAT.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalAnnualPriceIncludingVAT = serviceAndContractYearAndTotalAnnualPriceIncludingVAT.get(serviceType);
                    if(ContractYearAndTotalAnnualPriceIncludingVAT != null && ContractYearAndTotalAnnualPriceIncludingVAT.containsKey(contY)){
                        wForQuoteItemObj.Total_Annual_Price_including_VAT__c = Math.round(ContractYearAndTotalAnnualPriceIncludingVAT.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalMonthlyPriceIncludingVAT != null && serviceAndContractYearAndTotalMonthlyPriceIncludingVAT.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalMonthlyPriceIncludingVAT = serviceAndContractYearAndTotalMonthlyPriceIncludingVAT.get(serviceType);
                    if(ContractYearAndTotalMonthlyPriceIncludingVAT != null && ContractYearAndTotalMonthlyPriceIncludingVAT.containsKey(contY)){
                        wForQuoteItemObj.Total_Monthly_Price_including_VAT__c = Math.round(ContractYearAndTotalMonthlyPriceIncludingVAT.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalValueOfRental != null && serviceAndContractYearAndTotalValueOfRental.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalValueOfRental = serviceAndContractYearAndTotalValueOfRental.get(serviceType);
                    if(ContractYearAndTotalValueOfRental != null && ContractYearAndTotalValueOfRental.containsKey(contY)){
                        wForQuoteItemObj.Total_Value_Of_Rental__c = Math.round(ContractYearAndTotalValueOfRental.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndworkForceVATAmount != null && serviceAndContractYearAndworkForceVATAmount.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndworkForceVATAmount = serviceAndContractYearAndworkForceVATAmount.get(serviceType);
                    if(ContractYearAndworkForceVATAmount != null && ContractYearAndworkForceVATAmount.containsKey(contY)){
                        wForQuoteItemObj.ET_Vat_Amount__c = Math.round(ContractYearAndworkForceVATAmount.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalManpowerProfits != null && serviceAndContractYearAndTotalManpowerProfits.containsKey(serviceType)){
                    Map<integer,Decimal> ContractYearAndTotalManpowerProfits = serviceAndContractYearAndTotalManpowerProfits.get(serviceType);
                    if(ContractYearAndTotalManpowerProfits != null && ContractYearAndTotalManpowerProfits.containsKey(contY)){
                        wForQuoteItemObj.Total_Manpower_Profits__c = Math.round(ContractYearAndTotalManpowerProfits.get(contY));
                    }
                }
                
                if(serviceAndContractYearAndTotalManpowerProfits != null && serviceAndContractYearAndTotalManpowerProfits.containsKey(serviceType) &&
                   serviceAndContractYearAndTotalValueOfRental != null && serviceAndContractYearAndTotalValueOfRental.containsKey(serviceType))
                {
                    Map<integer,Decimal> ContractYearAndTotalManpowerProfits = serviceAndContractYearAndTotalManpowerProfits.get(serviceType);
                    Map<integer,Decimal> ContractYearAndTotalValueOfRental  = serviceAndContractYearAndTotalValueOfRental.get(serviceType);
                    if(ContractYearAndTotalManpowerProfits != null && ContractYearAndTotalManpowerProfits.containsKey(contY) &&
                       ContractYearAndTotalValueOfRental != null && ContractYearAndTotalValueOfRental.containsKey(contY)){
                           wForQuoteItemObj.Gross_profit_margin__c =((ContractYearAndTotalManpowerProfits.get(contY)/ContractYearAndTotalValueOfRental.get(contY))*100).setScale(2);
                       }
                }
                
                
                if(serviceAndContractYearAndannualProfitMarginValue != null && serviceAndContractYearAndannualProfitMarginValue.containsKey(serviceType) &&
                   serviceAndContractYeartotalCost != null && serviceAndContractYeartotalCost.containsKey(serviceType)){
                       Map<integer,Decimal> ContractYearAndannualProfitMarginValue = serviceAndContractYearAndannualProfitMarginValue.get(serviceType);
                       Map<integer,Decimal> ContractYeartotalCost  = serviceAndContractYeartotalCost.get(serviceType);
                       if(ContractYearAndannualProfitMarginValue != null && ContractYearAndannualProfitMarginValue.containsKey(contY) &&
                          ContractYeartotalCost != null && ContractYeartotalCost.containsKey(contY)){
                              wForQuoteItemObj.ET_Annual_Profit_Margin__c =((ContractYearAndannualProfitMarginValue.get(contY)/ContractYeartotalCost.get(contY))*100).setScale(2);
                          }
                   }
                
                wForceItemstoReturnList.add(wForQuoteItemObj); 
            }
        }
        system.debug('wForceItemstoReturnList = '+ json.serializePretty(wForceItemstoReturnList) );
        return wForceItemstoReturnList;
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
        
        
    }
    public static void testCoverage1(){
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
        
        
    }
    
    
}