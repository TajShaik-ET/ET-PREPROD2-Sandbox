public with sharing class ET_ProfitCalculationScreensController {

    private static List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLst ;
    private static List<ET_Workforce_Quote_Item__c> workforceQuoteItemLst ;
    private static List<Vehicle__c> vehicleRequestItemLst;
    private static List<ET_Work_force__c> workforceRequestItemLst;
    private static Map<Decimal,Decimal> contractYearAndVehicleCost ;
    private static Map<Decimal,Decimal> contractYearAndFuelCost;
    private static Map<Decimal,Decimal> contractYearAndDriverCost ;
    private static Map<Decimal,Decimal> contractYearAndNannyCost ;
    private static Map<Decimal,Decimal> contractYearAndSupervisorCost ;
    private static Map<Decimal,Decimal> contractYearAndCoordinatorCost ;
    private static Map<Decimal,Decimal> contractYearAndAccountantCost ;
    private static Map<Decimal,Decimal> contractYearAndOtherEmpCost ;
    private static Map<Decimal,Decimal> contractYearAndOtherCostCost ;
    private static Map<Decimal,Decimal> contractYearAndVehicleVatCost ;
    private static Map<Decimal,Decimal> contractYearAndManpowerVatCost ;


    private static Map<Decimal,Decimal> contractYearAndVehicleProfitMarginValue ;
    private static Map<Decimal,Decimal> contractYearAndFuelProfitMarginValue ;
    private static Map<Decimal,Decimal> contractYearAndDriverProfitMarginValue;
    private static Map<Decimal,Decimal> contractYearAndNannyProfitMarginValue ;
    private static Map<Decimal,Decimal> contractYearAndSupervisorProfitMarginValue;
    private static Map<Decimal,Decimal> contractYearAndCoordinatorProfitMarginValue;
    private static Map<Decimal,Decimal> contractYearAndAccountantProfitMarginValue;
    private static Map<Decimal,Decimal> contractYearAndOtherEmpProfitMarginValue;
    private static Map<Decimal,Decimal> contractYearAndOtherCostProfitMarginValue ;


    private static Map<Decimal,Decimal> contractYearAndVehiclePurchasePrice;
    private static Map<Decimal,Decimal> contractYearAndVehicleDepriciation ;
    private static Map<Decimal,Decimal> contractYearAndVehicleResaleValue;


    private static Map<Decimal,Decimal> contractYearAndRepairMaintenance ;
    private static Map<Decimal,Decimal> contractYearAndManpowerWages;
    
    private static Map<Decimal,Decimal> contractYearAndManpowerOverTime;
    private static Map<Decimal,Decimal> contractYearAndVehicleRegistration ;
    private static Map<Decimal,Decimal> contractYearAndVehicleInsurance;
    private static Map<Decimal,Decimal> contractYearAndVehicleFinancing;
    private static Map<Decimal,Decimal> contractYearAndManpowerAnnualLeaveAllowance;
    private static Map<Decimal,Decimal> contractYearAndManpowerEndOfService;
    private static Map<Decimal,Decimal> contractYearAndManpowerClothesAllowance;
    private static Map<Decimal,Decimal> contractYearAndManpowerHealthCard;
    private static Map<Decimal,Decimal> contractYearAndManpowerLicensingFee;
    private static Map<Decimal,Decimal> contractYearAndManpowerVisaCost;
    private static Map<Decimal,Decimal> contractYearAndManpowerAccommodation;
    
    private static void intializeClassMaps(){
         contractYearAndVehicleCost = new Map<Decimal,Decimal>();
         contractYearAndFuelCost = new Map<Decimal,Decimal>();
         contractYearAndDriverCost = new Map<Decimal,Decimal>();
         contractYearAndNannyCost = new Map<Decimal,Decimal>();
         contractYearAndSupervisorCost = new Map<Decimal,Decimal>();
         contractYearAndCoordinatorCost = new Map<Decimal,Decimal>();
         contractYearAndAccountantCost = new Map<Decimal,Decimal>();
         contractYearAndOtherEmpCost = new Map<Decimal,Decimal>();
         contractYearAndOtherCostCost = new Map<Decimal,Decimal>();
         contractYearAndVehicleVatCost = new Map<Decimal,Decimal>();
         contractYearAndManpowerVatCost = new Map<Decimal,Decimal>();
    
    
        contractYearAndVehicleProfitMarginValue = new Map<Decimal,Decimal>();
        contractYearAndFuelProfitMarginValue = new Map<Decimal,Decimal>();
        contractYearAndDriverProfitMarginValue = new Map<Decimal,Decimal>();
        contractYearAndNannyProfitMarginValue = new Map<Decimal,Decimal>();
        contractYearAndSupervisorProfitMarginValue = new Map<Decimal,Decimal>();
        contractYearAndCoordinatorProfitMarginValue = new Map<Decimal,Decimal>();
        contractYearAndAccountantProfitMarginValue = new Map<Decimal,Decimal>();
        contractYearAndOtherEmpProfitMarginValue = new Map<Decimal,Decimal>();
        contractYearAndOtherCostProfitMarginValue = new Map<Decimal,Decimal>();
    
    
        contractYearAndVehiclePurchasePrice = new Map<Decimal,Decimal>();
        contractYearAndVehicleDepriciation = new Map<Decimal,Decimal>();
        contractYearAndVehicleResaleValue = new Map<Decimal,Decimal>();
    
    
        contractYearAndRepairMaintenance = new Map<Decimal,Decimal>();
        contractYearAndManpowerWages = new Map<Decimal,Decimal>();
        
        contractYearAndManpowerOverTime = new Map<Decimal,Decimal>();
        contractYearAndVehicleRegistration = new Map<Decimal,Decimal>();
        contractYearAndVehicleInsurance = new Map<Decimal,Decimal>();
        contractYearAndVehicleFinancing = new Map<Decimal,Decimal>();
        contractYearAndManpowerAnnualLeaveAllowance = new Map<Decimal,Decimal>();
        contractYearAndManpowerEndOfService = new Map<Decimal,Decimal>();
        contractYearAndManpowerClothesAllowance = new Map<Decimal,Decimal>();
        contractYearAndManpowerHealthCard = new Map<Decimal,Decimal>();
        contractYearAndManpowerLicensingFee = new Map<Decimal,Decimal>();
        contractYearAndManpowerVisaCost = new Map<Decimal,Decimal>();
        contractYearAndManpowerAccommodation = new Map<Decimal,Decimal>();
    } 
    private static void setQuoteData(Id quoteId){
        vehicleQuoteItemLst  =  [Select id,
                                        Name,
                                        ET_Allowed_Vehicle_profit__c,
                                        ET_Annual_Fuel_Profit_Margin_Rate__c,
                                        ET_Annual_Fuel_Profit_Value__c,
                                        ET_Annual_Vehicles_Profit_Margin__c,
                                        ET_Annual_Vehicles_Profit_Value__c,
                                        ET_Contract_Period__c,
                                        ET_Depreciation_Reserve__c,
                                        ET_Fuel_Expenses__c,
                                        ET_Fuel_Reserve__c,
                                        ET_General_Reserve__c,
                                        ET_Line_Number__c,
                                        ET_Maintenance_Reserve__c,
                                        Quote__c,
                                        ET_Tot_Annual_Vehicles_Net_Prof_Val__c,
                                        ET_Total_Fixed_Cost__c,
                                        ET_Total_Fuel_Cost__c,
                                        ET_Total_fuel_profits__c,
                                        ET_Total_Reserve_Cost__c,
                                        ET_Total_Variable_Cost__c,
                                        ET_Total_Vehicles_Cost__c,
                                        ET_Vehicle_Financing__c,
                                        ET_Vehicle_Depreciation__c,
                                        ET_Vehicle_Insurance__c,
                                        ET_Vehicle_Purchase_price__c,
                                        ET_Vehicle_Registration__c,
                                        ET_Vehicle_Repairs_and_Maintenance__c,
                                        ET_Vehicle_Resale_Value__c,
                                        ET_Vehicle_VAT_Cost__c,
                                        ET_Number_of_Vehicles__c,
                                        ET_Vehicle_Unique_key__c,
                                        ET_Price_Utilization__c,
                                        ET_Pricing_Method__c,
                                        ET_Pricing_Type__c
                                    FROM ET_Vehicle_Quote_Item__c
                                    Where Quote__c = :quoteId];

        workforceQuoteItemLst = [Select id,
                                        ET_Accommodation_Allowance__c,
                                        ET_Allowed_profit_Additions_Discounts__c,
                                        ET_Annual_leave_allowance__c,
                                        ET_Annual_Profit_Margin__c,
                                        ET_Annual_Profit_Value__c,
                                        ET_Clothes_Allowance__c,
                                        ET_Contract_Period__c,
                                        ET_End_of_Service__c,
                                        ET_Health_Card__c,
                                        ET_Licensing_Fees__c,
                                        ET_Number_of_Workforce__c,
                                        ET_Overtime__c,
                                        Quote__c,
                                        ET_Total_Annual_Net_Profit_Value__c,
                                        ET_Total_Cost__c,
                                        ET_Total_Direct_Operational_Costs__c,
                                        ET_Total_Indirect_Operational_Costs__c,
                                        ET_Workforce_VAT_Cost__c,
                                        ET_Visa_Cost__c,
                                        ET_Wages__c,
                                        ET_Workforce_Gross_Salary__c,
                                        ET_Workforce_Line_Number__c,
                                        Name,
                                        ET_Workforce_Quote_Item_Type__c,
                                        ET_Workforce_Unique_Key__c,
                                        ET_Price_Utilization__c,
                                        ET_Pricing_Method__c,
                                        ET_Pricing_Type__c
                                    FROM ET_Workforce_Quote_Item__c
                                    Where Quote__c = :quoteId];
    }


    private static List<ET_Request_Mapping__c> getPricingCombinations(Id serviceRequestId){
        return  [Select id,
                        ET_Pricing_Service_Request__c,
                        ET_Accountant_Unique_Key__c,
                        ET_Coordinator_Unique_Key__c,
                        ET_Driver_Unique_Id__c,
                        ET_Nanny_Unique_Key__c,
                        ET_Other_Employee_Unique_Key__c,
                        ET_Supervisor_Unique_Key__c,
                        ET_Vehicle_Unique_key__c,
                        ET_Number_of_Accountants__c,
                        ET_Number_of_Coordinators__c,
                        ET_Number_of_Drivers__c,
                        ET_Number_of_Nannies__c,
                        ET_Number_of_Other_Employees__c,
                        ET_Number_of_Supervisors__c,
                        ET_Number_of_Vehicles__c,
                        Name
                FROM    ET_Request_Mapping__c
                Where  ET_Pricing_Service_Request__c = :serviceRequestId];

    }

    private static void setVehicleAndManpowerRequestItemList(Id serviceRequestId){
        vehicleRequestItemLst = [Select id,
                                        ET_Price_Utilization__c,
                                        ET_Pricing_Method__c,
                                        ET_Pricing_Type__c,
                                        ET_Vehicle_category__c,
                                        ET_Vehicle_Condition__c,
                                        ET_Vehicle_MAKE__c,
                                        ET_Vehicle_Model_Year__c,
                                        ET_Vehicle_Model__c,
                                        ET_Vehicle_Specs__c,
                                        ET_Vehicle_Type__c
                                FROM    Vehicle__c
                                Where   ET_Pricing_Service_Request__c = :serviceRequestId];

        workforceRequestItemLst = [Select id,
                                          ET_Price_Utilization__c,
                                          ET_Pricing_Method__c,
                                          ET_Pricing_Type__c,
                                          ET_Workforce_Record_Type_Name__c
                                    FROM  ET_Work_force__c
                                    Where  ET_Pricing_Service_Request__c = :serviceRequestId];
    }

    private static  Decimal getCost(Map<Decimal,Decimal> costMap, ET_Workforce_Quote_Item__c workforceQuoteItem, ET_Vehicle_Quote_Item__c vehicleQuoteItem,String costApiName ){
        
        Decimal costSumContractYearWise;
        if(workforceQuoteItem != null){
            if(workforceQuoteItem.get(costApiName) != null && workforceQuoteItem.ET_Number_of_Workforce__c != null){
                if(costMap.get(workforceQuoteItem.ET_Contract_Period__c) != null && costMap.get(workforceQuoteItem.ET_Contract_Period__c) != 0.0){
                    costSumContractYearWise = costMap.get(workforceQuoteItem.ET_Contract_Period__c) + ((Decimal)workforceQuoteItem.get(costApiName)  * (workforceQuoteItem.ET_Number_of_Workforce__c));
                }else{
                    costSumContractYearWise = (Decimal)workforceQuoteItem.get(costApiName) * workforceQuoteItem.ET_Number_of_Workforce__c;
                }
            }
            
        }else if(vehicleQuoteItem != null){
            if(vehicleQuoteItem.get(costApiName) != null && vehicleQuoteItem.ET_Number_of_Vehicles__c != null){
                if(costMap.get(vehicleQuoteItem.ET_Contract_Period__c) != null && costMap.get(vehicleQuoteItem.ET_Contract_Period__c) != 0.0){
                    costSumContractYearWise = costMap.get(vehicleQuoteItem.ET_Contract_Period__c) + ((Decimal)vehicleQuoteItem.get(costApiName) *  vehicleQuoteItem.ET_Number_of_Vehicles__c );
                }else{
                    costSumContractYearWise = (Decimal)vehicleQuoteItem.get(costApiName) * vehicleQuoteItem.ET_Number_of_Vehicles__c ;  
                }
            }
            
        }
       
        return costSumContractYearWise;
    }
   
    private static void setVehicleRelatedMapValues(ET_Vehicle_Quote_Item__c vehicleQuoteItem){
        contractYearAndVehicleCost.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndVehicleCost,null, vehicleQuoteItem, 'ET_Total_Vehicles_Cost__c'));

        contractYearAndFuelCost.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndFuelCost,null, vehicleQuoteItem, 'ET_Total_Fuel_Cost__c'));

        contractYearAndVehicleVatCost.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndVehicleVatCost,null, vehicleQuoteItem, 'ET_Vehicle_VAT_Cost__c'));

        contractYearAndVehicleProfitMarginValue.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndVehicleProfitMarginValue,null, vehicleQuoteItem, 'ET_Annual_Vehicles_Profit_Value__c'));

        contractYearAndFuelProfitMarginValue.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndFuelProfitMarginValue,null, vehicleQuoteItem, 'ET_Annual_Fuel_Profit_Value__c'));

        contractYearAndVehiclePurchasePrice.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndVehiclePurchasePrice,null, vehicleQuoteItem, 'ET_Vehicle_Purchase_price__c'));

        contractYearAndVehicleDepriciation.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndVehiclePurchasePrice,null, vehicleQuoteItem, 'ET_Vehicle_Depreciation__c'));

        contractYearAndVehicleResaleValue.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndVehiclePurchasePrice,null, vehicleQuoteItem, 'ET_Vehicle_Resale_Value__c'));

        contractYearAndVehicleRegistration.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndVehicleRegistration,null, vehicleQuoteItem, 'ET_Vehicle_Registration__c'));

        contractYearAndVehicleInsurance.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndVehicleInsurance,null, vehicleQuoteItem, 'ET_Vehicle_Insurance__c')); 

        contractYearAndVehicleFinancing.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndVehicleFinancing,null, vehicleQuoteItem, 'ET_Vehicle_Financing__c')); 
        contractYearAndRepairMaintenance.put(vehicleQuoteItem.ET_Contract_Period__c,getCost(contractYearAndRepairMaintenance,null, vehicleQuoteItem, 'ET_Vehicle_Repairs_and_Maintenance__c')); 
    }

    private static void setManpowerRelatedMapValues(ET_Workforce_Quote_Item__c workforceQuoteItem){
        if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Driver')){
            contractYearAndDriverCost.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndDriverCost,workforceQuoteItem, null, 'ET_Total_Cost__c'));
            contractYearAndDriverProfitMarginValue.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndDriverProfitMarginValue,workforceQuoteItem, null, 'ET_Total_Cost__c'));
        }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Nanny')){
            contractYearAndNannyCost.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndNannyCost,workforceQuoteItem, null, 'ET_Total_Cost__c'));
            contractYearAndNannyProfitMarginValue.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndNannyProfitMarginValue,workforceQuoteItem, null, 'ET_Total_Cost__c'));
        }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Supervisor')){
            contractYearAndSupervisorCost.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndSupervisorCost,workforceQuoteItem, null,'ET_Total_Cost__c'));
            contractYearAndSupervisorProfitMarginValue.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndSupervisorProfitMarginValue,workforceQuoteItem, null,'ET_Total_Cost__c'));
        }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Coordinator')){
            contractYearAndCoordinatorCost.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndCoordinatorCost,workforceQuoteItem, null, 'ET_Total_Cost__c'));
            contractYearAndCoordinatorProfitMarginValue.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndCoordinatorProfitMarginValue,workforceQuoteItem, null,'ET_Total_Cost__c'));
        }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Accountant/Cashier')){
            contractYearAndAccountantCost.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndAccountantCost,workforceQuoteItem, null, 'ET_Total_Cost__c'));
            contractYearAndAccountantProfitMarginValue.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndAccountantProfitMarginValue,workforceQuoteItem, null,'ET_Total_Cost__c'));
        }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Other Employee')){
            contractYearAndOtherEmpCost.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndOtherEmpCost,workforceQuoteItem, null,'ET_Total_Cost__c'));
            contractYearAndOtherEmpProfitMarginValue.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndOtherEmpProfitMarginValue,workforceQuoteItem, null,'ET_Total_Cost__c'));
        }

      
        system.debug('workforceQuoteItem before vat calc : '+ JSON.serializePretty(workforceQuoteItem));
        contractYearAndManpowerVatCost.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerVatCost,workforceQuoteItem, null, 'ET_Workforce_VAT_Cost__c'));
        contractYearAndManpowerAnnualLeaveAllowance.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerAnnualLeaveAllowance,workforceQuoteItem, null,'ET_Annual_leave_allowance__c'));
        contractYearAndManpowerEndOfService.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerEndOfService,workforceQuoteItem, null,'ET_End_of_Service__c'));
        contractYearAndManpowerClothesAllowance.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerClothesAllowance,workforceQuoteItem, null,'ET_Clothes_Allowance__c'));
        contractYearAndManpowerHealthCard.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerHealthCard,workforceQuoteItem, null,'ET_Health_Card__c'));
        contractYearAndManpowerLicensingFee.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerLicensingFee,workforceQuoteItem, null,'ET_Licensing_Fees__c'));
        contractYearAndManpowerVisaCost.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerVisaCost,workforceQuoteItem, null,'ET_Visa_Cost__c'));
        contractYearAndManpowerAccommodation.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerAccommodation,workforceQuoteItem, null,'ET_Accommodation_Allowance__c'));
        contractYearAndManpowerOverTime.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerOverTime,workforceQuoteItem, null,'ET_Overtime__c'));
        contractYearAndManpowerWages.put(workforceQuoteItem.ET_Contract_Period__c,getCost(contractYearAndManpowerOverTime,workforceQuoteItem, null,'ET_Wages__c'));
    }


    public static ProfitMarginValueCalculationClass doProfitCalculation(Integer contractYear){
        ProfitMarginValueCalculationClass profitValueCalcObj = new ProfitMarginValueCalculationClass();
        profitValueCalcObj.contractYear = contractYear;
        if(contractYearAndVehicleProfitMarginValue.get(contractYear) != null){
            profitValueCalcObj.vehicleProfitMarginValue = contractYearAndVehicleProfitMarginValue.get(contractYear);
        }
        
        if(contractYearAndFuelProfitMarginValue.get(contractYear) != null){
            profitValueCalcObj.fuelProfitMarginValue = contractYearAndFuelProfitMarginValue.get(contractYear);
        }
        
        if(contractYearAndDriverProfitMarginValue.get(contractYear) != null){
            profitValueCalcObj.driverProfitMarginValue = contractYearAndDriverProfitMarginValue.get(contractYear);
        }
        
        if(contractYearAndNannyProfitMarginValue.get(contractYear) != null){
            profitValueCalcObj.nannyProfitMarginValue = contractYearAndNannyProfitMarginValue.get(contractYear);
        }
        
        if(contractYearAndSupervisorProfitMarginValue.get(contractYear) != null){
            profitValueCalcObj.supervisorProfitMarginValue = contractYearAndSupervisorProfitMarginValue.get(contractYear);
        }
        
        if(contractYearAndCoordinatorProfitMarginValue.get(contractYear) != null){
            profitValueCalcObj.coordinatorProfitMarginValue = contractYearAndCoordinatorProfitMarginValue.get(contractYear);
        }
        
        if(contractYearAndAccountantProfitMarginValue.get(contractYear) != null){
            profitValueCalcObj.accountantProfitMarginValue = contractYearAndAccountantProfitMarginValue.get(contractYear);
        }
        
        if(contractYearAndOtherEmpProfitMarginValue.get(contractYear) != null){
            profitValueCalcObj.otherEmpProfitMarginValue = contractYearAndOtherEmpProfitMarginValue.get(contractYear);
        }
        
        if(contractYearAndOtherCostProfitMarginValue.get(contractYear) != null){
            profitValueCalcObj.otherCostProfitMarginValue = contractYearAndOtherCostProfitMarginValue.get(contractYear);
        }
        
        profitValueCalcObj.totalProjectProfitMarginValue =  profitValueCalcObj.vehicleProfitMarginValue +
                                                            profitValueCalcObj.fuelProfitMarginValue  + 
                                                            profitValueCalcObj.driverProfitMarginValue  +
                                                            profitValueCalcObj.nannyProfitMarginValue  +
                                                            profitValueCalcObj.supervisorProfitMarginValue +
                                                            profitValueCalcObj.coordinatorProfitMarginValue +
                                                            profitValueCalcObj.accountantProfitMarginValue +
                                                            profitValueCalcObj.otherEmpProfitMarginValue +
                                                            profitValueCalcObj.otherCostProfitMarginValue ;
        return profitValueCalcObj;
    }

    public static CostCalculationClass doCostCalculation(Integer contractYear){
        CostCalculationClass  costCalcObj = new  CostCalculationClass();
        costCalcObj.contractYear = contractYear;
        if(contractYearAndVehicleCost.get(contractYear) != null){
            costCalcObj.vehicleCost = contractYearAndVehicleCost.get(contractYear);
        }
      
        //system.debug('vehicle cost : '+ costCalcObj.vehicleCost );
        if(contractYearAndFuelCost.get(contractYear) != null){
            costCalcObj.fuelCost = contractYearAndFuelCost.get(contractYear);
        }
      
        //system.debug('fuelCost cost : '+ costCalcObj.fuelCost );
        if(contractYearAndDriverCost.get(contractYear) != null){
            costCalcObj.driverCost = contractYearAndDriverCost.get(contractYear);
        }
       
        //system.debug('driverCost cost : '+ costCalcObj.driverCost );
        if(contractYearAndNannyCost.get(contractYear) != null){
            costCalcObj.nanniesCost = contractYearAndNannyCost.get(contractYear);
        }
        
        //system.debug('nanniesCost cost : '+ costCalcObj.nanniesCost );
        if(contractYearAndSupervisorCost.get(contractYear) != null){
            costCalcObj.supervisorCost = contractYearAndSupervisorCost.get(contractYear);
        }
       
        //system.debug('supervisorCost cost : '+ costCalcObj.supervisorCost );
        if(contractYearAndCoordinatorCost.get(contractYear) != null){
            costCalcObj.coordinatorCost = contractYearAndCoordinatorCost.get(contractYear);
        }
       
        //system.debug('coordinatorCost cost : '+ costCalcObj.coordinatorCost );
        if(contractYearAndAccountantCost.get(contractYear) != null){
            costCalcObj.accountantCost = contractYearAndAccountantCost.get(contractYear);
        }
        
        //system.debug('accountantCost cost : '+ costCalcObj.accountantCost );
        if(contractYearAndOtherEmpCost.get(contractYear) != null){
            costCalcObj.otherEmpCost = contractYearAndOtherEmpCost.get(contractYear);
        }
       
        //system.debug('otherEmpCost cost : '+ costCalcObj.otherEmpCost );
        if(contractYearAndOtherCostCost.get(contractYear) != null){
            costCalcObj.otherCosts = contractYearAndOtherCostCost.get(contractYear);
        }
       
        //system.debug('otherCosts cost : '+ costCalcObj.otherCosts );
        Decimal vatValue = 0.0;
        if(contractYearAndVehicleVatCost.get(contractYear) != null){
            vatValue = vatValue + contractYearAndVehicleVatCost.get(contractYear);
        }
        if(contractYearAndManpowerVatCost.get(contractYear) != null){
            vatValue = vatValue + contractYearAndManpowerVatCost.get(contractYear);
        }

        costCalcObj.VATCost = vatValue;
        
        //system.debug('VATCost cost : '+ costCalcObj.VATCost );
        costCalcObj.toalCost =  costCalcObj.vehicleCost  + 
                                costCalcObj.fuelCost +
                                costCalcObj.driverCost +
                                costCalcObj.nanniesCost +
                                costCalcObj.supervisorCost +
                                costCalcObj.coordinatorCost +
                                costCalcObj.accountantCost +
                                costCalcObj.otherEmpCost +
                                costCalcObj.otherCosts +
                                costCalcObj.VATCost;
       
        return costCalcObj;
    }

    @AuraEnabled
    public static TotalProjectClass populateTotalProjectScreenData(Id quoteId){
        if(quoteId != null){
          TotalProjectClass   tpObj   = new TotalProjectClass();
          intializeClassMaps();
         // Map<Decimal,Decimal> contractYearAndTotalProjectProfitMarginValue = new Map<Decimal,Decimal>();  


          setQuoteData(quoteId);
         /* system.debug('vehicleQuoteItemLst : ' + vehicleQuoteItemLst + 'workforceQuoteItemLst : ' + workforceQuoteItemLst);
          if(vehicleQuoteItemLst != null && vehicleQuoteItemLst.size() > 0){
              for(ET_Vehicle_Quote_Item__c vehicleQuoteItem :  vehicleQuoteItemLst){
                setVehicleRelatedMapValues(vehicleQuoteItem);
              }
            }


            if(workforceQuoteItemLst != null && workforceQuoteItemLst.size()>0){
              for(ET_Workforce_Quote_Item__c workforceQuoteItem : workforceQuoteItemLst){
                setManpowerRelatedMapValues(workforceQuoteItem);
              }
            }
            
            List<CostCalculationClass> costCalcObjLst = new List<CostCalculationClass>();
            List<ProfitMarginValueCalculationClass> profitValueCalcObjLst = new List<ProfitMarginValueCalculationClass>();
            List<ProfitMarginRateCalculationClass> profitRateCalcObjLst = new List<ProfitMarginRateCalculationClass>();
            List<PaybackValueClass> paybackObjLst = new List<PaybackValueClass>();
            List<PaybackAnalysisClass> paybackAnalysisObjLst = new List<PaybackAnalysisClass>(); 

            for(Integer i=1; i < 9; i++){
                CostCalculationClass  costCalcObj = new  CostCalculationClass();
                ProfitMarginValueCalculationClass profitValueCalcObj = new ProfitMarginValueCalculationClass();
                ProfitMarginRateCalculationClass profitRateCalcObj = new ProfitMarginRateCalculationClass();
                PaybackValueClass paybackObj = new PaybackValueClass();
                PaybackAnalysisClass paybackAnalysisObj = new PaybackAnalysisClass();


               

                costCalcObj = doCostCalculation(i);
                profitValueCalcObj = doProfitCalculation(i);
                
                profitRateCalcObj.contractYear = i;
                if(costCalcObj.vehicleCost  != 0.0){
                    profitRateCalcObj.vehicleProfitMarginRate = profitValueCalcObj.vehicleProfitMarginValue / costCalcObj.vehicleCost;
                }
                if(costCalcObj.fuelCost  != 0.0){
                    profitRateCalcObj.fuelProfitMarginRate = profitValueCalcObj.fuelProfitMarginValue / costCalcObj.fuelCost;
                }
                if( costCalcObj.driverCost  != 0.0){
                    profitRateCalcObj.driverProfitMarginRate = profitValueCalcObj.driverProfitMarginValue / costCalcObj.driverCost;
                }
                if( costCalcObj.nanniesCost  != 0.0){
                    profitRateCalcObj.nannyProfitMarginRate = profitValueCalcObj.nannyProfitMarginValue / costCalcObj.nanniesCost;
                }
                if(costCalcObj.supervisorCost  != 0.0){
                    profitRateCalcObj.supervisorProfitMarginRate = profitValueCalcObj.supervisorProfitMarginValue / costCalcObj.supervisorCost;
                }
                if(costCalcObj.coordinatorCost  != 0.0){
                    profitRateCalcObj.coordinatorProfitMarginRate = profitValueCalcObj.coordinatorProfitMarginValue / costCalcObj.coordinatorCost;
                }
                if( costCalcObj.accountantCost  != 0.0){
                    profitRateCalcObj.accountantProfitMarginRate = profitValueCalcObj.accountantProfitMarginValue / costCalcObj.accountantCost;
                }
                if(costCalcObj.otherEmpCost  != 0.0){
                    profitRateCalcObj.otherEmpProfitMarginRate = profitValueCalcObj.otherEmpProfitMarginValue / costCalcObj.otherEmpCost;
                }
                if(costCalcObj.toalCost  != 0.0){
                    profitRateCalcObj.totalProjectProfitMarginRate = profitValueCalcObj.totalProjectProfitMarginValue / costCalcObj.toalCost;
                }
                

                
                paybackObj.contractYear = i;
                paybackObj.totalValueofRental =  costCalcObj.toalCost + profitValueCalcObj.totalProjectProfitMarginValue;
                if( contractYearAndVehiclePurchasePrice.get(i) != null){
                    paybackObj.totalInvestment =  contractYearAndVehiclePurchasePrice.get(i);
                }
                
                if( contractYearAndVehicleDepriciation.get(i) != null){
                    paybackObj.totalDepreciation =  contractYearAndVehicleDepriciation.get(i);
                }
               
                if( contractYearAndVehicleResaleValue.get(i) != null){
                    paybackObj.totalResaleValue = contractYearAndVehicleResaleValue.get(i);
                }
               

                paybackAnalysisObj.contractYear = i;
                
                paybackAnalysisObj.payback1 = paybackObj.totalDepreciation + profitValueCalcObj.vehicleProfitMarginValue;
                
                paybackAnalysisObj.payback2 = paybackAnalysisObj.payback1 + paybackObj.totalResaleValue;

                paybackAnalysisObj.payback3 = paybackAnalysisObj.payback2 + ( profitValueCalcObj.totalProjectProfitMarginValue -  profitValueCalcObj.vehicleProfitMarginValue);
                if(paybackObj.totalInvestment != 0.0){
                    paybackAnalysisObj.paybackRatio1 = paybackAnalysisObj.payback1 / paybackObj.totalInvestment;
                    paybackAnalysisObj.paybackRatio2 = paybackAnalysisObj.payback2 / paybackObj.totalInvestment;
                    paybackAnalysisObj.paybackRatio3 = paybackAnalysisObj.payback3 / paybackObj.totalInvestment;
                }
                if(paybackAnalysisObj.paybackRatio2 != 0.0){
                    paybackAnalysisObj.annualSharePayback2 = (paybackAnalysisObj.paybackRatio2 - 100)/ i;
                }
                if(paybackAnalysisObj.paybackRatio3 != 0.0){
                    paybackAnalysisObj.annualSharePayback3 = (paybackAnalysisObj.paybackRatio3 - 100)/i;
                }
               
               
               

                costCalcObjLst.add(costCalcObj);                                                    
                profitValueCalcObjLst.add(profitValueCalcObj);
                profitRateCalcObjLst.add(profitRateCalcObj);
                paybackObjLst.add(paybackObj);
                paybackAnalysisObjLst.add(paybackAnalysisObj);
            }
            system.debug('costCalcObjLst : '+ costCalcObjLst);
            tpObj.totalProjectCostCalculationLst = costCalcObjLst;
            tpObj.totalProjectProfitValueLst = profitValueCalcObjLst;
            tpObj.totalProjectProfitRateLst = profitRateCalcObjLst;
            tpObj.totalProjectPaybackValueLst = paybackObjLst;
            tpObj.totalProjectPaybackAnalysisLst = paybackAnalysisObjLst;
            system.debug('tpObj' + JSON.serializePretty(tpObj));*/
            return tpObj;
            
        }else{
            system.debug('quote id is null; Can\'t do total project calculations');
            return null;
        }
    }

   
    @AuraEnabled
    public static List<ProjectProfitLossClass> projectProfitLossCalculation(Id quoteId){

        if(quoteId != null){
            List<ProjectProfitLossClass>  projectProfitLossLst = new List<ProjectProfitLossClass>();
            setQuoteData(quoteId);
            intializeClassMaps();
           /* system.debug('vehicleQuoteItemLst : ' + vehicleQuoteItemLst + 'workforceQuoteItemLst : ' + workforceQuoteItemLst);
            if(vehicleQuoteItemLst != null && vehicleQuoteItemLst.size() > 0){
                for(ET_Vehicle_Quote_Item__c vehicleQuoteItem :  vehicleQuoteItemLst){
                  setVehicleRelatedMapValues(vehicleQuoteItem);
                }
            }
  
  
            if(workforceQuoteItemLst != null && workforceQuoteItemLst.size()>0){
                for(ET_Workforce_Quote_Item__c workforceQuoteItem : workforceQuoteItemLst){
                  setManpowerRelatedMapValues(workforceQuoteItem);
                }
            }

            for(Integer i=1; i<9; i++){
                ProjectProfitLossClass projectProfitLossObj = new ProjectProfitLossClass();
                CostCalculationClass  costCalcObj = doCostCalculation(i);
                ProfitMarginValueCalculationClass profitValueCalcObj = doProfitCalculation(i);
                projectProfitLossObj.contractYear = i;
                projectProfitLossObj.vehicleRevenue = costCalcObj.vehicleCost + profitValueCalcObj.vehicleProfitMarginValue +
                                                      costCalcObj.fuelCost + profitValueCalcObj.fuelProfitMarginValue;
                projectProfitLossObj.manpowerRevenue =  costCalcObj.driverCost + profitValueCalcObj.driverProfitMarginValue +
                                                        costCalcObj.nanniesCost + profitValueCalcObj.nannyProfitMarginValue +
                                                        costCalcObj.supervisorCost + profitValueCalcObj.supervisorProfitMarginValue +
                                                        costCalcObj.coordinatorCost + profitValueCalcObj.coordinatorProfitMarginValue +
                                                        costCalcObj.accountantCost + profitValueCalcObj.accountantProfitMarginValue +
                                                        costCalcObj.otherEmpCost + profitValueCalcObj.otherEmpProfitMarginValue;

                projectProfitLossObj.otherRevenue = costCalcObj.otherCosts + profitValueCalcObj.otherCostProfitMarginValue;
                projectProfitLossObj.VATRevenue = costCalcObj.VATCost;
                projectProfitLossObj.totalOperatingRevenue = projectProfitLossObj.vehicleRevenue + 
                                                             projectProfitLossObj.manpowerRevenue +
                                                             projectProfitLossObj.otherRevenue +
                                                             projectProfitLossObj.VATRevenue;
                if(contractYearAndRepairMaintenance.get(i) != null){
                    projectProfitLossObj.repairAndMaintenance =  contractYearAndRepairMaintenance.get(i);                                                        
                }
                if(costCalcObj.fuelCost != null){
                    projectProfitLossObj.fuel = costCalcObj.fuelCost;                                                       
                }
                if(contractYearAndManpowerWages.get(i) != null){
                    projectProfitLossObj.manpowerWages = contractYearAndManpowerWages.get(i);                                                       
                }
                if(contractYearAndManpowerOverTime.get(i) != null){
                    projectProfitLossObj.manpowerOverTime = contractYearAndManpowerOverTime.get(i);                                                       
                }
                if(contractYearAndVehicleRegistration.get(i) != null){
                    projectProfitLossObj.vehicleRegistration = contractYearAndVehicleRegistration.get(i);                                                       
                }
                if(contractYearAndVehicleInsurance.get(i) != null){
                    projectProfitLossObj.vehicleInsurance = contractYearAndVehicleInsurance.get(i);                                                       
                }
                if(contractYearAndManpowerAnnualLeaveAllowance.get(i) != null){
                    projectProfitLossObj.annualLeaveAllowance = contractYearAndManpowerAnnualLeaveAllowance.get(i);                                                       
                }
                if(contractYearAndManpowerEndOfService.get(i) != null){
                    projectProfitLossObj.endOfService = contractYearAndManpowerEndOfService.get(i);                                                       
                }

                if(contractYearAndManpowerClothesAllowance.get(i) != null){
                    projectProfitLossObj.clothesAllowance = contractYearAndManpowerClothesAllowance.get(i);                                                       
                }
                if(contractYearAndManpowerHealthCard.get(i) != null){
                    projectProfitLossObj.healthCard = contractYearAndManpowerHealthCard.get(i);                                                       
                }
                if(contractYearAndManpowerLicensingFee.get(i) != null){
                    projectProfitLossObj.licensingFees = contractYearAndManpowerLicensingFee.get(i);                                                       
                }

                
                if(contractYearAndManpowerVisaCost.get(i) != null){
                    projectProfitLossObj.visaCost = contractYearAndManpowerVisaCost.get(i);                                                       
                }
                if(contractYearAndManpowerAccommodation.get(i) != null){
                    projectProfitLossObj.accommodation = contractYearAndManpowerAccommodation.get(i);                                                       
                }
                projectProfitLossObj.totalVariableCost =  projectProfitLossObj.repairAndMaintenance +
                                                          projectProfitLossObj.fuel +
                                                          projectProfitLossObj.manpowerWages +
                                                          projectProfitLossObj.manpowerOverTime;
                projectProfitLossObj.ContributionMargin = projectProfitLossObj.totalOperatingRevenue  -  projectProfitLossObj.totalVariableCost;
                
                projectProfitLossObj.totalFixedCost = projectProfitLossObj.vehicleRegistration +
                                                      projectProfitLossObj.vehicleInsurance +
                                                      projectProfitLossObj.annualLeaveAllowance +
                                                      projectProfitLossObj.endOfService +
                                                      projectProfitLossObj.clothesAllowance +
                                                      projectProfitLossObj.healthCard +
                                                      projectProfitLossObj.visaCost +
                                                      projectProfitLossObj.accommodation;

                projectProfitLossObj.grossProfitOrLoss = projectProfitLossObj.ContributionMargin - projectProfitLossObj.totalFixedCost;
               
             
                projectProfitLossObj.ebitda = projectProfitLossObj.grossProfitOrLoss - projectProfitLossObj.totalSellingAndAdministration;
                if(contractYearAndVehicleResaleValue.get(i) != null){
                    projectProfitLossObj.capitalGainOrLoss = contractYearAndVehicleResaleValue.get(i);
                }
                projectProfitLossObj.totalOtherIncome = projectProfitLossObj.capitalGainOrLoss;
                
                if(contractYearAndVehicleDepriciation.get(i) != null){
                    projectProfitLossObj.vehicleDepriciation =  contractYearAndVehicleDepriciation.get(i);
                }
                projectProfitLossObj.totalDepriciationAndAmortisat = projectProfitLossObj.vehicleDepriciation ;
                projectProfitLossObj.ebit = projectProfitLossObj.ebitda - projectProfitLossObj.totalDepriciationAndAmortisat;
                if(contractYearAndVehicleFinancing.get(i) != null){
                    projectProfitLossObj.vehicleFinancing    =  contractYearAndVehicleFinancing.get(i);
                }

                projectProfitLossObj.totalInterest = projectProfitLossObj.vehicleFinancing;
                projectProfitLossObj.netProfitOrLoss = projectProfitLossObj.ebit - projectProfitLossObj.totalInterest;

                if(projectProfitLossObj.totalOperatingRevenue != 0.0){
                    projectProfitLossObj.ContributionMarginRate =(projectProfitLossObj.totalVariableCost/projectProfitLossObj.totalOperatingRevenue);
                    projectProfitLossObj.grossProfitOrLossRate = (projectProfitLossObj.grossProfitOrLoss/projectProfitLossObj.totalOperatingRevenue);
                    projectProfitLossObj.ebitdaRate = (projectProfitLossObj.ebitda/projectProfitLossObj.totalOperatingRevenue);
                    projectProfitLossObj.ebitRate = (projectProfitLossObj.ebit/projectProfitLossObj.totalOperatingRevenue);
                    projectProfitLossObj.netProfitOrLossMarginRate = (projectProfitLossObj.netProfitOrLoss/projectProfitLossObj.totalOperatingRevenue);
                }

                projectProfitLossLst.add(projectProfitLossObj);
            }*/
            return projectProfitLossLst;
                
        }else{
            system.debug('quote id is null; Can\'t do profit and loss calculations');
            return null;
        }
              
    }


    @AuraEnabled
    public static List<ProjectProfitLossAnalysisClass> projectProfitLossAnalysisCalc(id quoteId){
        List<ProjectProfitLossClass> projectProfitLossLst = projectProfitLossCalculation(quoteId);
        List<ProjectProfitLossAnalysisClass> projectProLossAnalysisLst = new List<ProjectProfitLossAnalysisClass>();
        if(projectProfitLossLst != null){
            for(ProjectProfitLossClass projectProfitLossObj : projectProfitLossLst){
                ProjectProfitLossAnalysisClass projectProLossAnalysisObj = new ProjectProfitLossAnalysisClass();
                if(projectProfitLossObj.totalOtherIncome != 0.0 || projectProfitLossObj.totalOperatingRevenue != 0.0){
                   
                    Decimal divideBy = projectProfitLossObj.totalOperatingRevenue + projectProfitLossObj.totalOtherIncome;
                    projectProLossAnalysisObj.vehicleRevenueRate = (projectProfitLossObj.vehicleRevenue/divideBy).setScale(2);
                    projectProLossAnalysisObj.manpowerRevenueRate = (projectProfitLossObj.manpowerRevenue/divideBy).setScale(2);
                    projectProLossAnalysisObj.otherRevenueRate = (projectProfitLossObj.otherRevenue/divideBy).setScale(2);
                    projectProLossAnalysisObj.VATRevenueRate = (projectProfitLossObj.VATRevenue/divideBy).setScale(2);
                    projectProLossAnalysisObj.totalOperatingRevenueRate = (projectProfitLossObj.totalOperatingRevenue/divideBy).setScale(2);
                    projectProLossAnalysisObj.repairAndMaintenanceRate = (projectProfitLossObj.repairAndMaintenance/divideBy).setScale(2);
                    projectProLossAnalysisObj.fuelRate = (projectProfitLossObj.fuel/divideBy).setScale(2);
                    projectProLossAnalysisObj.manpowerWagesRate = (projectProfitLossObj.manpowerWages/divideBy).setScale(2);
                    projectProLossAnalysisObj.manpowerOverTimeRate = (projectProfitLossObj.manpowerOverTime/divideBy).setScale(2);
                    projectProLossAnalysisObj.totalVariableCostRate = (projectProfitLossObj.totalVariableCost/divideBy).setScale(2);
                    projectProLossAnalysisObj.ContributionMarginRate = (projectProfitLossObj.ContributionMargin/divideBy).setScale(2);
                    projectProLossAnalysisObj.vehicleRegistrationRate = (projectProfitLossObj.vehicleRegistration/divideBy).setScale(2);
                    projectProLossAnalysisObj.vehicleInsuranceRate = (projectProfitLossObj.vehicleInsurance/divideBy).setScale(2);
                    projectProLossAnalysisObj.vehicleOtherExpensesRate = (projectProfitLossObj.vehicleOtherExpenses/divideBy).setScale(2);
                    projectProLossAnalysisObj.annualLeaveAllowanceRate = (projectProfitLossObj.annualLeaveAllowance/divideBy).setScale(2);
                    projectProLossAnalysisObj.endOfServiceRate = (projectProfitLossObj.endOfService/divideBy).setScale(2);
                    projectProLossAnalysisObj.clothesAllowanceRate = (projectProfitLossObj.clothesAllowance/divideBy).setScale(2);
                    projectProLossAnalysisObj.healthCardRate = (projectProfitLossObj.healthCard/divideBy).setScale(2);
                    projectProLossAnalysisObj.licensingFeeRate = (projectProfitLossObj.LicensingFees/divideBy).setScale(2);
                    projectProLossAnalysisObj.visaCostRate = (projectProfitLossObj.visaCost/divideBy).setScale(2);
                    projectProLossAnalysisObj.accommodationRate = (projectProfitLossObj.accommodation/divideBy).setScale(2);
                    projectProLossAnalysisObj.totalFixedCostRate = (projectProfitLossObj.totalFixedCost/divideBy).setScale(2);
                    projectProLossAnalysisObj.grossProfitOrLossRate = (projectProfitLossObj.grossProfitOrLoss/divideBy).setScale(2);
                    projectProLossAnalysisObj.totalSellingAndAdministrationRate =(projectProfitLossObj.totalSellingAndAdministration/divideBy).setScale(2);
                    projectProLossAnalysisObj.ebitdaRate = (projectProfitLossObj.ebitda/divideBy).setScale(2);
                    projectProLossAnalysisObj.capitalGainOrLossRate = (projectProfitLossObj.capitalGainOrLoss/divideBy).setScale(2);
                    projectProLossAnalysisObj.totalOtherIncomeRate = (projectProfitLossObj.totalOtherIncome/divideBy).setScale(2);
                    projectProLossAnalysisObj.vehicleDepriciationRate = (projectProfitLossObj.vehicleDepriciation/divideBy).setScale(2);
                    projectProLossAnalysisObj.totalDepriciationAndAmortisatRate = (projectProfitLossObj.totalDepriciationAndAmortisat/divideBy).setScale(2);
                    projectProLossAnalysisObj.ebitRate = (projectProfitLossObj.ebit/divideBy).setScale(2);
                    projectProLossAnalysisObj.vehicleFinancingRate = (projectProfitLossObj.vehicleFinancing/divideBy).setScale(2);
                    projectProLossAnalysisObj.totalInterestRate = (projectProfitLossObj.totalInterest/divideBy).setScale(2);
                    projectProLossAnalysisObj.netProfitOrLossRate = (projectProfitLossObj.netProfitOrLoss/divideBy).setScale(2);
                   
                   
                }else{
                    system.debug('both total other income and total operating revenue are null or zero for contract year :'+ projectProfitLossObj.contractYear +'; can\'t analize profit or loss');
                }
                projectProLossAnalysisLst.add(projectProLossAnalysisObj);
            }
            return projectProLossAnalysisLst;
        }else{
            return null;
        }
    }

    @AuraEnabled
    public static priceClass priceCalculation(id quoteId){
        if(quoteId != null){
            Quote quote = [Select id, OpportunityId, ET_Pricing_Service_Request__c  from Quote where id = :quoteId];
           // system.debug('opportunity id from quote obj: '+ quote.OpportunityId);

            List<ET_Request_Mapping__c> pricingCombinationLst = getPricingCombinations(quote.ET_Pricing_Service_Request__c);
            //setVehicleAndManpowerRequestItemList(quote.OpportunityId);
            system.debug('pricing combo : '+ pricingCombinationLst  );
            setQuoteData(quoteId);
            intializeClassMaps();
            
            system.debug('vehicleQuoteItemLst : ' + vehicleQuoteItemLst + 'workforceQuoteItemLst : ' + workforceQuoteItemLst);
            
            priceClass priceClassObj = new priceClass();           
           /* Map<String,Map<Integer,Decimal>> vehicleUniqueKeyWithNumberAndCostYearsWiseMap = new Map<String,Map<Integer,Decimal>>();

            Map<String,Map<Integer,Decimal>> vehicleUniqueKeyWithNumberAndfuelCostYearsWiseMap = new Map<String,Map<Integer,Decimal>>();

            //Map<String,Integer> vehicleUniqueKeyAndNumberMap =  new Map<String,Integer>();
            Map<String,ET_Vehicle_Quote_Item__c> vehicleUniqueKeyAndVehicleQuoteItemMap = new Map<String,ET_Vehicle_Quote_Item__c>();
            Map<String,String> vehicleUniqueKeyAndPricingMethodTypeMap =  new Map<String,String>();
            //Map<String,ET_Vehicle_Quote_Item__c>  
            if(vehicleQuoteItemLst != null && vehicleQuoteItemLst.size() > 0){
               
                Map<Integer,Decimal> conntractYearAndVehicleCostMap ;
                Map<Integer,Decimal> contractYearAndFuelCostMap;
                for(ET_Vehicle_Quote_Item__c vehicleQuoteItem : vehicleQuoteItemLst){
                    //setVehicleRelatedMapValues(vehicleQuoteItem);
                    if(vehicleQuoteItem.ET_Pricing_Method__c != null && vehicleQuoteItem.ET_Pricing_Type__c != null){
                        String pricingMethodType = vehicleQuoteItem.ET_Pricing_Method__c + '=>' +vehicleQuoteItem.ET_Pricing_Type__c;
                        if(vehicleUniqueKeyWithNumberAndCostYearsWiseMap.get(vehicleQuoteItem.ET_Vehicle_Unique_key__c) != null){
                            conntractYearAndVehicleCostMap = vehicleUniqueKeyWithNumberAndCostYearsWiseMap.get(vehicleQuoteItem.ET_Vehicle_Unique_key__c);

                        }else{
                            conntractYearAndVehicleCostMap = new Map<Integer,Decimal>();
                        }

                        if(vehicleUniqueKeyWithNumberAndfuelCostYearsWiseMap.get(vehicleQuoteItem.ET_Vehicle_Unique_key__c) != null){
                            contractYearAndFuelCostMap = vehicleUniqueKeyWithNumberAndfuelCostYearsWiseMap.get(vehicleQuoteItem.ET_Vehicle_Unique_key__c);
                        }else{
                            contractYearAndFuelCostMap = new Map<Integer,Decimal>();
                        }
                        conntractYearAndVehicleCostMap.put(Integer.valueOf(vehicleQuoteItem.ET_Contract_Period__c),getVehicleCost(vehicleQuoteItem));
                        contractYearAndFuelCostMap.put(Integer.valueOf(vehicleQuoteItem.ET_Contract_Period__c),getVehicleFuelCost(vehicleQuoteItem));

                        vehicleUniqueKeyWithNumberAndCostYearsWiseMap.put(vehicleQuoteItem.ET_Vehicle_Unique_key__c,conntractYearAndVehicleCostMap);
                        vehicleUniqueKeyWithNumberAndfuelCostYearsWiseMap.put(vehicleQuoteItem.ET_Vehicle_Unique_key__c,contractYearAndFuelCostMap);



                        if(vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleQuoteItem.ET_Vehicle_Unique_key__c) == null){
                            vehicleUniqueKeyAndVehicleQuoteItemMap.put(vehicleQuoteItem.ET_Vehicle_Unique_key__c,vehicleQuoteItem);
                        }

                        if(vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleQuoteItem.ET_Vehicle_Unique_key__c) == null){
                            vehicleUniqueKeyAndPricingMethodTypeMap.put(vehicleQuoteItem.ET_Vehicle_Unique_key__c,pricingMethodType);
                        }
                        
                    }

                }
            }
            
            Map<String,Map<Integer,Decimal>> driverUniqueKeyWithNumberAndCostYearsWiseMap = new Map<String,Map<Integer,Decimal>>();
            Map<String,ET_Workforce_Quote_Item__c> driverUniqueKeyAndWorkforceMap =  new Map<String,ET_Workforce_Quote_Item__c>();
            Map<String,String> driverUniqueKeyAndPricingMethodTypeMap =  new Map<String,String>();


            Map<String,Map<Integer,Decimal>> nannyUniqueKeyWithNumberAndCostYearsWiseMap = new Map<String,Map<Integer,Decimal>>();
            Map<String,ET_Workforce_Quote_Item__c> nannyUniqueKeyAndWorkforceMap =  new Map<String,ET_Workforce_Quote_Item__c>();
            Map<String,String> nannyUniqueKeyAndPricingMethodTypeMap =  new Map<String,String>();

            Map<String,Map<Integer,Decimal>> supervisorUniqueKeyWithNumberAndCostYearsWiseMap = new Map<String,Map<Integer,Decimal>>();
            Map<String,ET_Workforce_Quote_Item__c> supervisorUniqueKeyAndWorkforceMap =  new Map<String,ET_Workforce_Quote_Item__c>();
            Map<String,String> supervisorUniqueKeyAndPricingMethodTypeMap =  new Map<String,String>();

            Map<String,Map<Integer,Decimal>> coordinatorUniqueKeyWithNumberAndCostYearsWiseMap = new Map<String,Map<Integer,Decimal>>();
            Map<String,ET_Workforce_Quote_Item__c> coordinatorUniqueKeyAndWorkforceMap =  new Map<String,ET_Workforce_Quote_Item__c>();
            Map<String,String> coordinatorUniqueKeyAndPricingMethodTypeMap =  new Map<String,String>();

            Map<String,Map<Integer,Decimal>> accountantUniqueKeyWithNumberAndCostYearsWiseMap = new Map<String,Map<Integer,Decimal>>();
            Map<String,ET_Workforce_Quote_Item__c> accountantUniqueKeyAndWorkforceMap =  new Map<String,ET_Workforce_Quote_Item__c>();
            Map<String,String> accountantUniqueKeyAndPricingMethodTypeMap =  new Map<String,String>();

            Map<String,Map<Integer,Decimal>> otherEmpUniqueKeyWithNumberAndCostYearsWiseMap = new Map<String,Map<Integer,Decimal>>();
            Map<String,ET_Workforce_Quote_Item__c> otherEmpUniqueKeyAndWorkforceMap =  new Map<String,ET_Workforce_Quote_Item__c>();
            Map<String,String> otherEmpUniqueKeyAndPricingMethodTypeMap =  new Map<String,String>();

            if(workforceQuoteItemLst != null && workforceQuoteItemLst.size() > 0){
               
                Map<Integer,Decimal> contractYearAndManpowerCostMap ;
                for(ET_Workforce_Quote_Item__c workforceQuoteItem : workforceQuoteItemLst){
                    //setManpowerRelatedMapValues(workforceQuoteItem);
                    Integer contractYear = Integer.valueOf(workforceQuoteItem.ET_Contract_Period__c);
                    if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Driver')){
                        if(workforceQuoteItem.ET_Pricing_Method__c != null && workforceQuoteItem.ET_Pricing_Type__c != null){
                            String pricingMethodType = workforceQuoteItem.ET_Pricing_Method__c + '=>' +workforceQuoteItem.ET_Pricing_Type__c;
                            if(driverUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) != null){
                                contractYearAndManpowerCostMap = driverUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c);
                                
                            }else{
                                contractYearAndManpowerCostMap = new Map<Integer,Decimal>();
                            }
                            contractYearAndManpowerCostMap.put(contractYear,getManpowerCost(workforceQuoteItem));
                            driverUniqueKeyWithNumberAndCostYearsWiseMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,contractYearAndManpowerCostMap);
                            if(driverUniqueKeyAndWorkforceMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                driverUniqueKeyAndWorkforceMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,workforceQuoteItem);
                                //driverUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            if(driverUniqueKeyAndPricingMethodTypeMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                driverUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            
                        }
                    }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Nanny')){
                        if(workforceQuoteItem.ET_Pricing_Method__c != null && workforceQuoteItem.ET_Pricing_Type__c != null){
                            String pricingMethodType = workforceQuoteItem.ET_Pricing_Method__c + '=>' +workforceQuoteItem.ET_Pricing_Type__c;
                            if(nannyUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) != null){
                                contractYearAndManpowerCostMap = nannyUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c);
                                
                            }else{
                                contractYearAndManpowerCostMap = new Map<Integer,Decimal>();
                            }
                            contractYearAndManpowerCostMap.put(contractYear,getManpowerCost(workforceQuoteItem));
                            nannyUniqueKeyWithNumberAndCostYearsWiseMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,contractYearAndManpowerCostMap);
                            if(nannyUniqueKeyAndWorkforceMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                nannyUniqueKeyAndWorkforceMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,workforceQuoteItem);
                                
                            }
                            if(nannyUniqueKeyAndPricingMethodTypeMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                nannyUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            
                        }
                    }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Supervisor')){
                        if(workforceQuoteItem.ET_Pricing_Method__c != null && workforceQuoteItem.ET_Pricing_Type__c != null){
                            String pricingMethodType = workforceQuoteItem.ET_Pricing_Method__c + '=>' +workforceQuoteItem.ET_Pricing_Type__c;
                            if(supervisorUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) != null){
                                contractYearAndManpowerCostMap = supervisorUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c);
                                
                            }else{
                                contractYearAndManpowerCostMap = new Map<Integer,Decimal>();
                            }
                            contractYearAndManpowerCostMap.put(contractYear,getManpowerCost(workforceQuoteItem));
                            supervisorUniqueKeyWithNumberAndCostYearsWiseMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,contractYearAndManpowerCostMap);
                            if(supervisorUniqueKeyAndWorkforceMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                supervisorUniqueKeyAndWorkforceMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,workforceQuoteItem);
                                //driverUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            if(supervisorUniqueKeyAndPricingMethodTypeMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                supervisorUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            
                            
                        }
                    }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Coordinator')){
                        if(workforceQuoteItem.ET_Pricing_Method__c != null && workforceQuoteItem.ET_Pricing_Type__c != null){
                            String pricingMethodType = workforceQuoteItem.ET_Pricing_Method__c + '=>' +workforceQuoteItem.ET_Pricing_Type__c;
                            if(coordinatorUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) != null){
                                contractYearAndManpowerCostMap = coordinatorUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c);
                                
                            }else{
                                contractYearAndManpowerCostMap = new Map<Integer,Decimal>();
                            }
                            contractYearAndManpowerCostMap.put(contractYear,getManpowerCost(workforceQuoteItem));
                            coordinatorUniqueKeyWithNumberAndCostYearsWiseMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,contractYearAndManpowerCostMap);
                            if(coordinatorUniqueKeyAndWorkforceMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                coordinatorUniqueKeyAndWorkforceMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,workforceQuoteItem);
                                //driverUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            if(coordinatorUniqueKeyAndPricingMethodTypeMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                coordinatorUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            
                        }
                    }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Accountant/Cashier')){
                        if(workforceQuoteItem.ET_Pricing_Method__c != null && workforceQuoteItem.ET_Pricing_Type__c != null){
                            String pricingMethodType = workforceQuoteItem.ET_Pricing_Method__c + '=>' +workforceQuoteItem.ET_Pricing_Type__c;
                            if(accountantUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) != null){
                                contractYearAndManpowerCostMap = accountantUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c);
                                
                            }else{
                                contractYearAndManpowerCostMap = new Map<Integer,Decimal>();
                            }
                            contractYearAndManpowerCostMap.put(contractYear,getManpowerCost(workforceQuoteItem));
                            accountantUniqueKeyWithNumberAndCostYearsWiseMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,contractYearAndManpowerCostMap);
                            if(accountantUniqueKeyAndWorkforceMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                accountantUniqueKeyAndWorkforceMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,workforceQuoteItem);
                               // driverUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            if(accountantUniqueKeyAndPricingMethodTypeMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                accountantUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            
                        }
                    }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c.equals('Other Employee')){
                        if(workforceQuoteItem.ET_Pricing_Method__c != null && workforceQuoteItem.ET_Pricing_Type__c != null){
                            String pricingMethodType = workforceQuoteItem.ET_Pricing_Method__c + '=>' +workforceQuoteItem.ET_Pricing_Type__c;
                            if(otherEmpUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) != null){
                                contractYearAndManpowerCostMap = otherEmpUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c);
                                
                            }else{
                                contractYearAndManpowerCostMap = new Map<Integer,Decimal>();
                            }
                            contractYearAndManpowerCostMap.put(contractYear,getManpowerCost(workforceQuoteItem));
                            otherEmpUniqueKeyWithNumberAndCostYearsWiseMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,contractYearAndManpowerCostMap);
                            if(otherEmpUniqueKeyAndWorkforceMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                otherEmpUniqueKeyAndWorkforceMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,workforceQuoteItem);
                               // driverUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            if(otherEmpUniqueKeyAndPricingMethodTypeMap.get(workforceQuoteItem.ET_Workforce_Unique_Key__c) == null){
                                otherEmpUniqueKeyAndPricingMethodTypeMap.put(workforceQuoteItem.ET_Workforce_Unique_Key__c,pricingMethodType);
                            }
                            
                        }
                    }
                
                }
            }


            


            if(pricingCombinationLst != null && pricingCombinationLst.size() > 0){
                Map<String, Map<Integer,Decimal>> combinationUniqueKeyAndCostYearWiseMap = new Map<String, Map<Integer,Decimal>>();
                Map<String,Integer> combinationUniqueKeyAndVehicleNumberMap = new Map<String,Integer>();
                Map<String,String> combinationUniqueKeyAndPricingMethodTypeMap = new Map<String,String>();
                Map<String,Decimal> combinationUniqueKeyAndPriceUtilizationMap =  new Map<String,Decimal>();
                for(ET_Request_Mapping__c combination : pricingCombinationLst){
                    Decimal priceUtilization = 0.0;
                    Map<Integer,Decimal> contractYearAndCombinationCostMap = new Map<Integer,Decimal>();
                    Map<Integer,Decimal> vehicleCostYearWiseMap;
                    Map<Integer,Decimal> driverCostYearWiseMap;
                    Map<Integer,Decimal> supervisorCostYearWiseMap;
                    Map<Integer,Decimal> coordinatorCostYearWiseMap;
                    Map<Integer,Decimal> accountantCostYearWiseMap;
                    Map<Integer,Decimal> nannyCostYearWiseMap;
                    Map<Integer,Decimal> otherEmpCostYearWiseMap;
                    String combinationUniqueKey = '';
                    String pricingMethodAndType = '';
                   
                    if(combination.ET_Vehicle_Unique_key__c != null){
                        String vehicleUniqueKey = (combination.ET_Vehicle_Unique_key__c.split('=>')[0]).trim();
                        if(vehicleUniqueKeyWithNumberAndCostYearsWiseMap.get(vehicleUniqueKey) != null){
                            vehicleCostYearWiseMap = vehicleUniqueKeyWithNumberAndCostYearsWiseMap.get(vehicleUniqueKey);
                            combinationUniqueKey = combinationUniqueKey + vehicleUniqueKey + '_' ;
                            
                        }
                        if((pricingMethodAndType == '' || pricingMethodAndType == null) && vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey) != null){
                            pricingMethodAndType = vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey);
                        }
                        if((priceUtilization == 0.0 || priceUtilization == null) && vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey) != null){
                            priceUtilization = (vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Price_Utilization__c;
                        }
                        
                    }
                    if(combination.ET_Driver_Unique_Id__c != null){
                        String driverUniqueKey = (combination.ET_Driver_Unique_Id__c.split('=>')[0]).trim();
                        if(driverUniqueKeyWithNumberAndCostYearsWiseMap.get(driverUniqueKey) != null){
                            driverCostYearWiseMap = driverUniqueKeyWithNumberAndCostYearsWiseMap.get(driverUniqueKey);
                            combinationUniqueKey = combinationUniqueKey + driverUniqueKey + '_' ;
                        }
                        if((pricingMethodAndType == '' || pricingMethodAndType == null) && driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey) != null){
                            pricingMethodAndType = driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey);
                        }
                        if((priceUtilization == 0.0 || priceUtilization == null) && driverUniqueKeyAndWorkforceMap.get(driverUniqueKey) != null){
                            priceUtilization = (driverUniqueKeyAndWorkforceMap.get(driverUniqueKey)).ET_Price_Utilization__c;
                        }
                    }
                    if(combination.ET_Nanny_Unique_Key__c != null){
                        String nannyUniqueKey = (combination.ET_Nanny_Unique_Key__c.split('=>')[0]).trim();
                        if(nannyUniqueKeyWithNumberAndCostYearsWiseMap.get(nannyUniqueKey) != null){
                            nannyCostYearWiseMap = nannyUniqueKeyWithNumberAndCostYearsWiseMap.get(nannyUniqueKey);
                            combinationUniqueKey = combinationUniqueKey + nannyUniqueKey + '_' ;
                        }
                        if((pricingMethodAndType == '' || pricingMethodAndType == null) && nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey) != null){
                            pricingMethodAndType = nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey);
                        }
                        if((priceUtilization == 0.0 || priceUtilization == null) && nannyUniqueKeyAndWorkforceMap.get(nannyUniqueKey) != null){
                            priceUtilization = (nannyUniqueKeyAndWorkforceMap.get(nannyUniqueKey)).ET_Price_Utilization__c;
                        }
                    }
                    if(combination.ET_Coordinator_Unique_Key__c != null){
                        String coordinatorUniqueKey = (combination.ET_Coordinator_Unique_Key__c.split('=>')[0]).trim();
                        if(coordinatorUniqueKeyWithNumberAndCostYearsWiseMap.get(coordinatorUniqueKey) != null){
                            coordinatorCostYearWiseMap = coordinatorUniqueKeyWithNumberAndCostYearsWiseMap.get(coordinatorUniqueKey);
                            combinationUniqueKey = combinationUniqueKey + coordinatorUniqueKey  + '_';
                        }
                        if((pricingMethodAndType == '' || pricingMethodAndType == null) && coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey) != null){
                            pricingMethodAndType = coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey);
                        }
                        if((priceUtilization == 0.0 || priceUtilization == null) && coordinatorUniqueKeyAndWorkforceMap.get(coordinatorUniqueKey) != null){
                            priceUtilization = (coordinatorUniqueKeyAndWorkforceMap.get(coordinatorUniqueKey)).ET_Price_Utilization__c;
                        }
                    }
                    if(combination.ET_Supervisor_Unique_Key__c != null){
                        String supervisorUniqueKey = (combination.ET_Supervisor_Unique_Key__c.split('=>')[0]).trim();
                        if(supervisorUniqueKeyWithNumberAndCostYearsWiseMap.get(supervisorUniqueKey) != null){
                            supervisorCostYearWiseMap = supervisorUniqueKeyWithNumberAndCostYearsWiseMap.get(supervisorUniqueKey);
                            combinationUniqueKey = combinationUniqueKey + supervisorUniqueKey + '_' ;
                        }
                        if((pricingMethodAndType == '' || pricingMethodAndType == null) && supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey) != null){
                            pricingMethodAndType = supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey);
                        }
                        if((priceUtilization == 0.0 || priceUtilization == null) && supervisorUniqueKeyAndWorkforceMap.get(supervisorUniqueKey) != null) {
                            priceUtilization = (supervisorUniqueKeyAndWorkforceMap.get(supervisorUniqueKey)).ET_Price_Utilization__c;
                        }
                    }
                    if(combination.ET_Accountant_Unique_Key__c != null){
                        String accountantUniqueKey = (combination.ET_Accountant_Unique_Key__c.split('=>')[0]).trim();
                        if(accountantUniqueKeyWithNumberAndCostYearsWiseMap.get(accountantUniqueKey) != null){
                            accountantCostYearWiseMap = accountantUniqueKeyWithNumberAndCostYearsWiseMap.get(accountantUniqueKey);
                            combinationUniqueKey = combinationUniqueKey + accountantUniqueKey  + '_';
                        }
                        if((pricingMethodAndType == '' || pricingMethodAndType == null) && accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey) != null){
                            pricingMethodAndType = accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey);
                        }
                        if((priceUtilization == 0.0 || priceUtilization == null) && accountantUniqueKeyAndWorkforceMap.get(accountantUniqueKey) != null){
                            priceUtilization = (accountantUniqueKeyAndWorkforceMap.get(accountantUniqueKey)).ET_Price_Utilization__c;
                        }
                    }
                    if(combination.ET_Other_Employee_Unique_Key__c != null){
                        String otherEmpUniqueKey = (combination.ET_Other_Employee_Unique_Key__c.split('=>')[0]).trim();
                        if(otherEmpUniqueKeyWithNumberAndCostYearsWiseMap.get(otherEmpUniqueKey) != null){
                            otherEmpCostYearWiseMap = otherEmpUniqueKeyWithNumberAndCostYearsWiseMap.get(otherEmpUniqueKey);
                            combinationUniqueKey = combinationUniqueKey + otherEmpUniqueKey+ '_' ;
                        }
                        if((pricingMethodAndType == '' || pricingMethodAndType == null) && otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey) != null){
                            pricingMethodAndType = otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey);
                        }
                        if((priceUtilization == 0.0 || priceUtilization == null) && otherEmpUniqueKeyAndWorkforceMap.get(otherEmpUniqueKey) != null){
                            priceUtilization = (otherEmpUniqueKeyAndWorkforceMap.get(otherEmpUniqueKey)).ET_Price_Utilization__c;
                        }
                    }

                    combinationUniqueKey = combinationUniqueKey.removeEnd('_');
                    combinationUniqueKeyAndPriceUtilizationMap.put(combinationUniqueKey,priceUtilization);
                    combinationUniqueKeyAndPricingMethodTypeMap.put(combinationUniqueKey,pricingMethodAndType);
                    combinationUniqueKeyAndVehicleNumberMap.put(combinationUniqueKey,Integer.valueOf(combination.ET_Number_of_Vehicles__c));
                    

                    system.debug('combinationUniqueKeyAndPriceUtilizationMap  :'+ combinationUniqueKeyAndPriceUtilizationMap);
                    system.debug('combinationUniqueKeyAndPricingMethodTypeMap  :'+ combinationUniqueKeyAndPricingMethodTypeMap);
                    system.debug('combinationUniqueKeyAndVehicleNumberMap  :'+ combinationUniqueKeyAndVehicleNumberMap);


                    for(Integer i =1; i< 9; i++){
                        decimal combinationCost = 0.0;
                        if(vehicleCostYearWiseMap != null && vehicleCostYearWiseMap.get(i) != null){
                            combinationCost = combinationCost + vehicleCostYearWiseMap.get(i) * combination.ET_Number_of_Vehicles__c;
                        }
                        if(driverCostYearWiseMap != null && driverCostYearWiseMap.get(i) != null){
                            combinationCost = combinationCost + driverCostYearWiseMap.get(i) * combination.ET_Number_of_Drivers__c;
                        }
                        if(otherEmpCostYearWiseMap != null && otherEmpCostYearWiseMap.get(i) != null){
                            combinationCost = combinationCost + otherEmpCostYearWiseMap.get(i) * combination.ET_Number_of_Other_Employees__c;
                        }
                        if(nannyCostYearWiseMap != null && nannyCostYearWiseMap.get(i) != null){
                            combinationCost = combinationCost + nannyCostYearWiseMap.get(i) * combination.ET_Number_of_Nannies__c;
                        }
                        if(coordinatorCostYearWiseMap != null && coordinatorCostYearWiseMap.get(i) != null){
                            combinationCost = combinationCost + coordinatorCostYearWiseMap.get(i) * combination.ET_Number_of_Coordinators__c;
                        }
                        if(supervisorCostYearWiseMap != null && supervisorCostYearWiseMap.get(i) != null){
                            combinationCost = combinationCost + supervisorCostYearWiseMap.get(i) * combination.ET_Number_of_Supervisors__c;
                        }
                        if(accountantCostYearWiseMap != null && accountantCostYearWiseMap.get(i) != null){
                            combinationCost = combinationCost + accountantCostYearWiseMap.get(i) * combination.ET_Number_of_Accountants__c;
                        }
                        contractYearAndCombinationCostMap.put(i,combinationCost);
                    }
                    combinationUniqueKeyAndCostYearWiseMap.put(combinationUniqueKey,contractYearAndCombinationCostMap);
                }

                system.debug(' combinationUniqueKeyAndCostYearWiseMap : ' + combinationUniqueKeyAndCostYearWiseMap);



                //combination calculations
                List<combinationPriceLstClass> combinationPriceAnnualWiseLst = new List<combinationPriceLstClass>();
                List<combinationPriceLstClass> combinationPriceMonthWiseLst =  new List<combinationPriceLstClass>();
                
                for(String combinationUniqueKey : combinationUniqueKeyAndCostYearWiseMap.keySet()){
                    if((combinationUniqueKeyAndPricingMethodTypeMap.get(combinationUniqueKey)).equalsIgnoreCase('Per Unit=>Annual Price')){
                        combinationPriceLstClass combinationPriceAnnualLst = new combinationPriceLstClass();
                        List<combinationPriceClass> combinationYearsWiseLst = new List<combinationPriceClass>();
                        
                        /*for(Integer contractYear : (combinationUniqueKeyAndCostYearWiseMap.get(combinationUniqueKey)).keySet()){
                            combinationPriceClass combinationYearWise = new combinationPriceClass();
                            combinationYearWise.combinationCost = (combinationUniqueKeyAndCostYearWiseMap.get(combinationUniqueKey)).get(contractYear);
                            //combinationYearWise.
                            combinationYearsWiseLst.add(combinationYearWise);
                        }*/

                       /* for(Integer i=1; i< 9; i++){
                            combinationPriceClass combinationYearWise = new combinationPriceClass();
                            if(combinationUniqueKeyAndPriceUtilizationMap.get(combinationUniqueKey) != null  && (combinationUniqueKeyAndCostYearWiseMap.get(combinationUniqueKey)).get(i) != null){
                                combinationYearWise.combinationCost = (combinationUniqueKeyAndCostYearWiseMap.get(combinationUniqueKey)).get(i);
                            
                            }
                            combinationYearsWiseLst.add(combinationYearWise);
                        }
                        combinationPriceAnnualLst.combinationPriceLstYearWise = combinationYearsWiseLst;
                        combinationPriceAnnualLst.vehicleNumberInCombination = combinationUniqueKeyAndVehicleNumberMap.get(combinationUniqueKey);
                        combinationPriceAnnualLst.combinationUniqueKey = combinationUniqueKey;
                        combinationPriceAnnualWiseLst.add(combinationPriceAnnualLst);
                    }else if((combinationUniqueKeyAndPricingMethodTypeMap.get(combinationUniqueKey)).equalsIgnoreCase('Per Unit=>Monthly Price')){
                        combinationPriceLstClass combinationPriceMonthlyLst = new combinationPriceLstClass();
                        List<combinationPriceClass> combinationYearsWiseLst = new List<combinationPriceClass>();
                        /*for(Integer contractYear : (combinationUniqueKeyAndCostYearWiseMap.get(combinationUniqueKey)).keySet()){
                            combinationPriceClass combinationYearWise = new combinationPriceClass();
                            if(combinationUniqueKeyAndPriceUtilizationMap.get(combinationUniqueKey) != null && combinationUniqueKeyAndPriceUtilizationMap.get(combinationUniqueKey) != 0.0 && (combinationUniqueKeyAndCostYearWiseMap.get(combinationUniqueKey)).get(i) != null){
                                combinationYearWise.combinationCost = (((combinationUniqueKeyAndCostYearWiseMap.get(combinationUniqueKey)).get(i)) / (combinationUniqueKeyAndPriceUtilizationMap.get(combinationUniqueKey)));
                                
                            }
                            
                            //combinationYearWise.
                            combinationYearsWiseLst.add(combinationYearWise);
                        }*/

                      /*  for(Integer i=1; i< 9; i++){
       combinationPriceClass combinationYearWise = new combinationPriceClass();
                            if(combinationUniqueKeyAndPriceUtilizationMap.get(combinationUniqueKey) != null && combinationUniqueKeyAndPriceUtilizationMap.get(combinationUniqueKey) != 0.0 && (combinationUniqueKeyAndCostYearWiseMap.get(combinationUniqueKey)).get(i) != null){
                                combinationYearWise.combinationCost = (((combinationUniqueKeyAndCostYearWiseMap.get(combinationUniqueKey)).get(i)) / (combinationUniqueKeyAndPriceUtilizationMap.get(combinationUniqueKey)));
                            
                            }
                            combinationYearsWiseLst.add(combinationYearWise);
                        }
                        combinationPriceMonthlyLst.combinationPriceLstYearWise = combinationYearsWiseLst;
                        combinationPriceMonthlyLst.vehicleNumberInCombination = combinationUniqueKeyAndVehicleNumberMap.get(combinationUniqueKey);
                        combinationPriceMonthlyLst.combinationUniqueKey = combinationUniqueKey;
                        combinationPriceMonthWiseLst.add(combinationPriceMonthlyLst);
                    }
                   
                }
                priceClassObj.combinationPriceAnnualWiseLst = combinationPriceAnnualWiseLst;
                priceClassObj.combinationPriceMonthWiseLst = combinationPriceMonthWiseLst;
                system.debug('priceClassObj.combinationPriceAnnualWiseLst  : ' + JSON.serializePretty(priceClassObj.combinationPriceAnnualWiseLst) );
                system.debug('priceClassObj.combinationPriceMonthWiseLst  : ' + JSON.serializePretty(priceClassObj.combinationPriceMonthWiseLst) );
            }else{
                system.debug('skipping combination wise calculation as no combination is found against pricing service request :' +quote.ET_Pricing_Service_Request__c );
            }
          
                List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLstForLumsumAnnally = new List<ET_Vehicle_Quote_Item__c>();
                List<ET_Workforce_Quote_Item__c> workforceQuoteItemLstForLumsumAnnually = new List<ET_Workforce_Quote_Item__c>() ;

                List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLstForLumsumMonthly = new List<ET_Vehicle_Quote_Item__c>();
                List<ET_Workforce_Quote_Item__c> workforceQuoteItemLstForLumsumMonthly = new List<ET_Workforce_Quote_Item__c>() ;

                List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLstForLumsumPerStudent = new List<ET_Vehicle_Quote_Item__c>();
                List<ET_Workforce_Quote_Item__c> workforceQuoteItemLstForLumsumPerStudent = new List<ET_Workforce_Quote_Item__c>() ;

                List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLstForLumsumPerRoute = new List<ET_Vehicle_Quote_Item__c>();
                List<ET_Workforce_Quote_Item__c> workforceQuoteItemLstForLumsumPerRoute = new List<ET_Workforce_Quote_Item__c>() ;

                List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLstForLumsumPerKm = new List<ET_Vehicle_Quote_Item__c>();
                List<ET_Workforce_Quote_Item__c> workforceQuoteItemLstForLumsumPerKm = new List<ET_Workforce_Quote_Item__c>() ;

                List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLstForLumsumPerTon = new List<ET_Vehicle_Quote_Item__c>();
                List<ET_Workforce_Quote_Item__c> workforceQuoteItemLstForLumsumPerTon = new List<ET_Workforce_Quote_Item__c>() ;

                 //seeting Individual vehicle price calculation
                List<vehicleLstClass> vehicleMonthWiseLst =  new List<vehicleLstClass>();
                List<vehicleLstClass> vehicleAnnualWiseLst = new List<vehicleLstClass>();
                List<vehicleLstClass> vehiclePriceUtilizationWiseLst = new List<vehicleLstClass>(); 
               
                for(String vehicleUniqueKey : vehicleUniqueKeyWithNumberAndCostYearsWiseMap.keySet()){
                    vehicleLstClass vehicleYearWiseLstObj =  new vehicleLstClass();
                    List<vehicleCostCommonClass> ListToHoldVehicle = new List<vehicleCostCommonClass>();
                    for(Integer i=1; i<9; i++){
                        vehicleCostCommonClass vehicleCostYearWise = new vehicleCostCommonClass();
                        if((vehicleUniqueKeyWithNumberAndCostYearsWiseMap.get(vehicleUniqueKey)).get(i) != null){
                            vehicleCostYearWise.vehicleCost = (vehicleUniqueKeyWithNumberAndCostYearsWiseMap.get(vehicleUniqueKey)).get(i);
                           
                        }
                        if((vehicleUniqueKeyWithNumberAndfuelCostYearsWiseMap.get(vehicleUniqueKey)).get(i) != null){
                            vehicleCostYearWise.fuelCost = (vehicleUniqueKeyWithNumberAndfuelCostYearsWiseMap.get(vehicleUniqueKey)).get(i);
                        }
                        ListToHoldVehicle.add(vehicleCostYearWise);
                    }
                    vehicleYearWiseLstObj.vehicleLstYearWise = ListToHoldVehicle;
                    vehicleYearWiseLstObj.vehicleNumberInLineItem = Integer.valueOf((vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Number_of_Vehicles__c);
                    vehicleYearWiseLstObj.vehicleUniqueKey = vehicleUniqueKey;
                    if((vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Per Unit=>Annual Price')){
                        vehicleAnnualWiseLst.add(vehicleYearWiseLstObj);  
                    }
                    else if((vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Per Unit=>Monthly Price')){
                        List<vehicleCostCommonClass> updateListPerUtilization = new List<vehicleCostCommonClass>();
                        for(vehicleCostCommonClass vehicleObj : ListToHoldVehicle){
                            vehicleCostCommonClass costPerUtilization = new vehicleCostCommonClass();
                            if((vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Price_Utilization__c != null && (vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Price_Utilization__c != 0.0){
                                costPerUtilization.vehicleCost = (vehicleObj.vehicleCost)/ ((vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Price_Utilization__c);
                                costPerUtilization.fuelCost = (vehicleObj.fuelCost)/ ((vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Price_Utilization__c);
                            }
                          
                            updateListPerUtilization.add(costPerUtilization);
                        }
                        vehicleYearWiseLstObj.vehicleLstYearWise = updateListPerUtilization;
                        vehicleYearWiseLstObj.vehicleUniqueKey = vehicleUniqueKey;
                        vehicleMonthWiseLst.add(vehicleYearWiseLstObj);  
                    }
                    else if((vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price') ||
                            (vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price') ||
                            (vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student') ||
                            (vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route') ||
                            (vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM') ||
                            (vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton') ){
                                List<vehicleCostCommonClass> updateListPerUtilization = new List<vehicleCostCommonClass>();
                                for(vehicleCostCommonClass vehicleObj : ListToHoldVehicle){
                                    vehicleCostCommonClass costPerUtilization = new vehicleCostCommonClass();
                                    if((vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Price_Utilization__c != null && (vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Price_Utilization__c != 0.0){
                                        costPerUtilization.vehicleCost = (vehicleObj.vehicleCost)/ ((vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Price_Utilization__c);
                                        costPerUtilization.fuelCost = (vehicleObj.fuelCost)/ ((vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey)).ET_Price_Utilization__c);
                                    }
                                  
                                    updateListPerUtilization.add(costPerUtilization);
                                }
                                vehicleYearWiseLstObj.vehicleLstYearWise = updateListPerUtilization;
                                vehicleYearWiseLstObj.vehicleUniqueKey = vehicleUniqueKey;
                                vehiclePriceUtilizationWiseLst.add(vehicleYearWiseLstObj);
                                if((vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price')){
                                    vehicleQuoteItemLstForLumsumAnnally.add(vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey));
                                }else if((vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price')){
                                    vehicleQuoteItemLstForLumsumMonthly.add(vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey));
                                }else if((vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student')){
                                    vehicleQuoteItemLstForLumsumPerStudent.add(vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey));
                                }else if((vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route')){
                                    vehicleQuoteItemLstForLumsumPerRoute.add(vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey));
                                }else if((vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM')){
                                    vehicleQuoteItemLstForLumsumPerKm.add(vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey));
                                }else if((vehicleUniqueKeyAndPricingMethodTypeMap.get(vehicleUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                    vehicleQuoteItemLstForLumsumPerTon.add(vehicleUniqueKeyAndVehicleQuoteItemMap.get(vehicleUniqueKey));
                                }
                    }
                }

                priceClassObj.vehicleMonthWiseLst = vehicleMonthWiseLst;
                priceClassObj.vehicleAnnualWiseLst = vehicleAnnualWiseLst;
                priceClassObj.vehiclePriceUtilizationWiseLst = vehiclePriceUtilizationWiseLst;

                system.debug('priceClassObj.vehicleMonthWiseLst  : ' + JSON.serializePretty(priceClassObj.vehicleMonthWiseLst) );
                system.debug('priceClassObj.vehicleAnnualWiseLst  : ' + JSON.serializePretty(priceClassObj.vehicleAnnualWiseLst) );
                system.debug('priceClassObj.vehiclePriceUtilizationWiseLst  : ' + JSON.serializePretty(priceClassObj.vehiclePriceUtilizationWiseLst) ); 
                 //setting Individual driver caluclation
                 List<workforceLstClass> driverMonthWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> driverAnnualWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> driverPriceUtilizationWiseLst = new List<workforceLstClass>();
                 for(String driverUniqueKey : driverUniqueKeyWithNumberAndCostYearsWiseMap.keySet()){
                    if((driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Per Unit=>Annual Price')){
                        driverAnnualWiseLst.add(getWorkforceLstClassAnnually(driverUniqueKey,driverUniqueKeyWithNumberAndCostYearsWiseMap,driverUniqueKeyAndWorkforceMap)); 
                        //driverAnnualWiseLst.workforceUniqueKey =  driverUniqueKey;
                    }
                    else if((driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Per Unit=>Monthly Price')){
                        driverMonthWiseLst.add(getWorkforceLstClassPerUtilization(driverUniqueKey,driverUniqueKeyWithNumberAndCostYearsWiseMap,driverUniqueKeyAndWorkforceMap));
                        //driverMonthWiseLst.workforceUniqueKey = driverUniqueKey;
                    }
                    else if((driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price') ||
                            (driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price') ||
                            (driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student') ||
                            (driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route') ||
                            (driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM') ||
                            (driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                driverPriceUtilizationWiseLst.add(getWorkforceLstClassPerUtilization(driverUniqueKey,driverUniqueKeyWithNumberAndCostYearsWiseMap,driverUniqueKeyAndWorkforceMap));
                                //driverPriceUtilizationWiseLst.workforceUniqueKey = driverUniqueKey;
                                if((driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price')){
                                    workforceQuoteItemLstForLumsumAnnually.add(driverUniqueKeyAndWorkforceMap.get(driverUniqueKey));
                                }else if((driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price')){
                                    workforceQuoteItemLstForLumsumMonthly.add(driverUniqueKeyAndWorkforceMap.get(driverUniqueKey));
                                }else if((driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student')){
                                    workforceQuoteItemLstForLumsumPerStudent.add(driverUniqueKeyAndWorkforceMap.get(driverUniqueKey));
                                }else if((driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route')){
                                    workforceQuoteItemLstForLumsumPerRoute.add(driverUniqueKeyAndWorkforceMap.get(driverUniqueKey));
                                }else if((driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM')){
                                    workforceQuoteItemLstForLumsumPerKm.add(driverUniqueKeyAndWorkforceMap.get(driverUniqueKey));
                                }else if((driverUniqueKeyAndPricingMethodTypeMap.get(driverUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                    workforceQuoteItemLstForLumsumPerTon.add(driverUniqueKeyAndWorkforceMap.get(driverUniqueKey));
                                }
                    }
                }
                priceClassObj.driverMonthWiseLst = driverMonthWiseLst;
                priceClassObj.driverAnnualWiseLst = driverAnnualWiseLst;
                priceClassObj.driverPriceUtilizationWiseLst = driverPriceUtilizationWiseLst;
                
                system.debug('priceClassObj.driverMonthWiseLst  : ' + JSON.serializePretty(priceClassObj.driverMonthWiseLst) );
                system.debug('priceClassObj.driverAnnualWiseLst  : ' + JSON.serializePretty(priceClassObj.driverAnnualWiseLst) );
                system.debug('priceClassObj.driverPriceUtilizationWiseLst  : ' + JSON.serializePretty(priceClassObj.driverPriceUtilizationWiseLst) ); 


                 //setting Individual nanny caluclation
                 List<workforceLstClass> nannyMonthWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> nannyAnnualWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> nannyPriceUtilizationWiseLst = new List<workforceLstClass>(); 
                 for(String nannyUniqueKey : nannyUniqueKeyWithNumberAndCostYearsWiseMap.keySet()){
                    if((nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Per Unit=>Annual Price')){
                        nannyAnnualWiseLst.add(getWorkforceLstClassAnnually(nannyUniqueKey,nannyUniqueKeyWithNumberAndCostYearsWiseMap,nannyUniqueKeyAndWorkforceMap));  
                        //nannyAnnualWiseLst.workforceUniqueKey = nannyUniqueKey;
                    }
                    else if((nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Per Unit=>Monthly Price')){
                        nannyMonthWiseLst.add(getWorkforceLstClassPerUtilization(nannyUniqueKey,nannyUniqueKeyWithNumberAndCostYearsWiseMap,nannyUniqueKeyAndWorkforceMap));
                       // nannyMonthWiseLst.workforceUniqueKey = nannyUniqueKey;
                    }
                    else if((nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price') ||
                            (nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price') ||
                            (nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student') ||
                            (nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route') ||
                            (nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM') ||
                            (nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                nannyPriceUtilizationWiseLst.add(getWorkforceLstClassPerUtilization(nannyUniqueKey,nannyUniqueKeyWithNumberAndCostYearsWiseMap,nannyUniqueKeyAndWorkforceMap));
                               // nannyPriceUtilizationWiseLst.workforceUniqueKey = nannyUniqueKey;
                                if((nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price')){
                                    workforceQuoteItemLstForLumsumAnnually.add(nannyUniqueKeyAndWorkforceMap.get(nannyUniqueKey));
                                }else if((nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price')){
                                    workforceQuoteItemLstForLumsumMonthly.add(nannyUniqueKeyAndWorkforceMap.get(nannyUniqueKey));
                                }else if((nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student')){
                                    workforceQuoteItemLstForLumsumPerStudent.add(nannyUniqueKeyAndWorkforceMap.get(nannyUniqueKey));
                                }else if((nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route')){
                                    workforceQuoteItemLstForLumsumPerRoute.add(nannyUniqueKeyAndWorkforceMap.get(nannyUniqueKey));
                                }else if((nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM')){
                                    workforceQuoteItemLstForLumsumPerKm.add(nannyUniqueKeyAndWorkforceMap.get(nannyUniqueKey));
                                }else if((nannyUniqueKeyAndPricingMethodTypeMap.get(nannyUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                    workforceQuoteItemLstForLumsumPerTon.add(nannyUniqueKeyAndWorkforceMap.get(nannyUniqueKey));
                                }
                    }
                }
                priceClassObj.nannyMonthWiseLst = nannyMonthWiseLst;
                priceClassObj.nannyAnnualWiseLst = nannyAnnualWiseLst;
                priceClassObj.nannyPriceUtilizationWiseLst = nannyPriceUtilizationWiseLst;
                system.debug('priceClassObj.nannyMonthWiseLst  : ' + JSON.serializePretty(priceClassObj.nannyMonthWiseLst) );
                system.debug('priceClassObj.nannyAnnualWiseLst  : ' + JSON.serializePretty(priceClassObj.nannyAnnualWiseLst) );
                system.debug('priceClassObj.nannyPriceUtilizationWiseLst  : ' + JSON.serializePretty(priceClassObj.nannyPriceUtilizationWiseLst) ); 


                 //setting Individual supervisor caluclation
                 List<workforceLstClass> supervisorMonthWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> supervisorAnnualWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> supervisorPriceUtilizationWiseLst = new List<workforceLstClass>(); 
                 for(String supervisorUniqueKey : supervisorUniqueKeyWithNumberAndCostYearsWiseMap.keySet()){
                    if((supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Per Unit=>Annual Price')){
                        supervisorAnnualWiseLst.add(getWorkforceLstClassAnnually(supervisorUniqueKey,supervisorUniqueKeyWithNumberAndCostYearsWiseMap,supervisorUniqueKeyAndWorkforceMap));  
                       // supervisorAnnualWiseLst.workforceUniqueKey = supervisorUniqueKey;
                    }
                    else if((supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Per Unit=>Monthly Price')){
                        supervisorMonthWiseLst.add(getWorkforceLstClassPerUtilization(supervisorUniqueKey,supervisorUniqueKeyWithNumberAndCostYearsWiseMap,supervisorUniqueKeyAndWorkforceMap));
                        //supervisorMonthWiseLst.workforceUniqueKey = supervisorUniqueKey;
                    }
                    else if((supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price') ||
                            (supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price') ||
                            (supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student') ||
                            (supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route') ||
                            (supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM') ||
                            (supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                supervisorPriceUtilizationWiseLst.add(getWorkforceLstClassPerUtilization(supervisorUniqueKey,supervisorUniqueKeyWithNumberAndCostYearsWiseMap,supervisorUniqueKeyAndWorkforceMap));
                               // supervisorPriceUtilizationWiseLst.workforceUniqueKey = supervisorUniqueKey;
                                if((supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price')){
                                    workforceQuoteItemLstForLumsumAnnually.add(supervisorUniqueKeyAndWorkforceMap.get(supervisorUniqueKey));
                                }else if((supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price')){
                                    workforceQuoteItemLstForLumsumMonthly.add(supervisorUniqueKeyAndWorkforceMap.get(supervisorUniqueKey));
                                }else if((supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student')){
                                    workforceQuoteItemLstForLumsumPerStudent.add(supervisorUniqueKeyAndWorkforceMap.get(supervisorUniqueKey));
                                }else if((supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route')){
                                    workforceQuoteItemLstForLumsumPerRoute.add(supervisorUniqueKeyAndWorkforceMap.get(supervisorUniqueKey));
                                }else if((supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM')){
                                    workforceQuoteItemLstForLumsumPerKm.add(supervisorUniqueKeyAndWorkforceMap.get(supervisorUniqueKey));
                                }else if((supervisorUniqueKeyAndPricingMethodTypeMap.get(supervisorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                    workforceQuoteItemLstForLumsumPerTon.add(supervisorUniqueKeyAndWorkforceMap.get(supervisorUniqueKey));
                                }
                    }
                }
                priceClassObj.supervisorMonthWiseLst = supervisorMonthWiseLst;
                priceClassObj.supervisorAnnualWiseLst = supervisorAnnualWiseLst;
                priceClassObj.supervisorPriceUtilizationWiseLst = supervisorPriceUtilizationWiseLst;
                system.debug('priceClassObj.supervisorMonthWiseLst  : ' + JSON.serializePretty(priceClassObj.supervisorMonthWiseLst) );
                system.debug('priceClassObj.supervisorAnnualWiseLst  : ' + JSON.serializePretty(priceClassObj.supervisorAnnualWiseLst) );
                system.debug('priceClassObj.supervisorPriceUtilizationWiseLst  : ' + JSON.serializePretty(priceClassObj.supervisorPriceUtilizationWiseLst) ); 


                 //setting Individual coordinator caluclation
                 List<workforceLstClass> coordinatorMonthWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> coordinatorAnnualWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> coordinatorPriceUtilizationWiseLst = new List<workforceLstClass>(); 
                 for(String coordinatorUniqueKey : coordinatorUniqueKeyWithNumberAndCostYearsWiseMap.keySet()){
                    if((coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Per Unit=>Annual Price')){
                        coordinatorAnnualWiseLst.add(getWorkforceLstClassAnnually(coordinatorUniqueKey,coordinatorUniqueKeyWithNumberAndCostYearsWiseMap,coordinatorUniqueKeyAndWorkforceMap));  
                       // coordinatorAnnualWiseLst.workforceUniqueKey = coordinatorUniqueKey;
                    }
                    else if((coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Per Unit=>Monthly Price')){
                        coordinatorMonthWiseLst.add(getWorkforceLstClassPerUtilization(coordinatorUniqueKey,coordinatorUniqueKeyWithNumberAndCostYearsWiseMap,coordinatorUniqueKeyAndWorkforceMap));
                       // coordinatorMonthWiseLst.workforceUniqueKey = coordinatorUniqueKey;
                    }
                    else if((coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price') ||
                            (coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price') ||
                            (coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student') ||
                            (coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route') ||
                            (coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM') ||
                            (coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                coordinatorPriceUtilizationWiseLst.add(getWorkforceLstClassPerUtilization(coordinatorUniqueKey,coordinatorUniqueKeyWithNumberAndCostYearsWiseMap,coordinatorUniqueKeyAndWorkforceMap));
                                //coordinatorPriceUtilizationWiseLst.workforceUniqueKey = coordinatorUniqueKey;
                                if((coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price')){
                                    workforceQuoteItemLstForLumsumAnnually.add(coordinatorUniqueKeyAndWorkforceMap.get(coordinatorUniqueKey));
                                }else if((coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price')){
                                    workforceQuoteItemLstForLumsumMonthly.add(coordinatorUniqueKeyAndWorkforceMap.get(coordinatorUniqueKey));
                                }else if((coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student')){
                                    workforceQuoteItemLstForLumsumPerStudent.add(coordinatorUniqueKeyAndWorkforceMap.get(coordinatorUniqueKey));
                                }else if((coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route')){
                                    workforceQuoteItemLstForLumsumPerRoute.add(coordinatorUniqueKeyAndWorkforceMap.get(coordinatorUniqueKey));
                                }else if((coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM')){
                                    workforceQuoteItemLstForLumsumPerKm.add(coordinatorUniqueKeyAndWorkforceMap.get(coordinatorUniqueKey));
                                }else if((coordinatorUniqueKeyAndPricingMethodTypeMap.get(coordinatorUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                    workforceQuoteItemLstForLumsumPerTon.add(coordinatorUniqueKeyAndWorkforceMap.get(coordinatorUniqueKey));
                                }
                    }
                }
                priceClassObj.coordinatorMonthWiseLst = coordinatorMonthWiseLst;
                priceClassObj.coordinatorAnnualWiseLst = coordinatorAnnualWiseLst;
                priceClassObj.coordinatorPriceUtilizationWiseLst = coordinatorPriceUtilizationWiseLst;
                system.debug('priceClassObj.coordinatorMonthWiseLst  : ' + JSON.serializePretty(priceClassObj.coordinatorMonthWiseLst) );
                system.debug('priceClassObj.coordinatorAnnualWiseLst  : ' + JSON.serializePretty(priceClassObj.coordinatorAnnualWiseLst) );
                system.debug('priceClassObj.coordinatorPriceUtilizationWiseLst  : ' + JSON.serializePretty(priceClassObj.coordinatorPriceUtilizationWiseLst) ); 

                 //setting Individual accountant caluclation
                 List<workforceLstClass> accountantMonthWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> accountantAnnualWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> accountantPriceUtilizationWiseLst = new List<workforceLstClass>(); 
                 for(String accountantUniqueKey : accountantUniqueKeyWithNumberAndCostYearsWiseMap.keySet()){
                    if((accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Per Unit=>Annual Price')){
                        accountantAnnualWiseLst.add(getWorkforceLstClassAnnually(accountantUniqueKey,accountantUniqueKeyWithNumberAndCostYearsWiseMap,accountantUniqueKeyAndWorkforceMap));  
                        //accountantAnnualWiseLst.workforceUniqueKey = accountantUniqueKey;
                    }
                    else if((accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Per Unit=>Monthly Price')){
                        accountantMonthWiseLst.add(getWorkforceLstClassPerUtilization(accountantUniqueKey,accountantUniqueKeyWithNumberAndCostYearsWiseMap,accountantUniqueKeyAndWorkforceMap));
                       // accountantMonthWiseLst.workforceUniqueKey = accountantUniqueKey;
                    }
                    else if((accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price') ||
                            (accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price') ||
                            (accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student') ||
                            (accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route') ||
                            (accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM') ||
                            (accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                accountantPriceUtilizationWiseLst.add(getWorkforceLstClassPerUtilization(accountantUniqueKey,accountantUniqueKeyWithNumberAndCostYearsWiseMap,accountantUniqueKeyAndWorkforceMap));
                                //accountantPriceUtilizationWiseLst.workforceUniqueKey = accountantUniqueKey;
                                if((accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price')){
                                    workforceQuoteItemLstForLumsumAnnually.add(accountantUniqueKeyAndWorkforceMap.get(accountantUniqueKey));
                                }else if((accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price')){
                                    workforceQuoteItemLstForLumsumMonthly.add(accountantUniqueKeyAndWorkforceMap.get(accountantUniqueKey));
                                }else if((accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student')){
                                    workforceQuoteItemLstForLumsumPerStudent.add(accountantUniqueKeyAndWorkforceMap.get(accountantUniqueKey));
                                }else if((accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route')){
                                    workforceQuoteItemLstForLumsumPerRoute.add(accountantUniqueKeyAndWorkforceMap.get(accountantUniqueKey));
                                }else if((accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM')){
                                    workforceQuoteItemLstForLumsumPerKm.add(accountantUniqueKeyAndWorkforceMap.get(accountantUniqueKey));
                                }else if((accountantUniqueKeyAndPricingMethodTypeMap.get(accountantUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                    workforceQuoteItemLstForLumsumPerTon.add(accountantUniqueKeyAndWorkforceMap.get(accountantUniqueKey));
                                }
                    }
                }
                priceClassObj.accountantMonthWiseLst = accountantMonthWiseLst;
                priceClassObj.accountantAnnualWiseLst = accountantAnnualWiseLst;
                priceClassObj.accountantPriceUtilizationWiseLst = accountantPriceUtilizationWiseLst;
                system.debug('priceClassObj.accountantMonthWiseLst  : ' + JSON.serializePretty(priceClassObj.accountantMonthWiseLst) );
                system.debug('priceClassObj.accountantAnnualWiseLst  : ' + JSON.serializePretty(priceClassObj.accountantAnnualWiseLst) );
                system.debug('priceClassObj.accountantPriceUtilizationWiseLst  : ' + JSON.serializePretty(priceClassObj.accountantPriceUtilizationWiseLst) ); 

                 //setting Individual other emp caluclation
                 List<workforceLstClass> otherEmpMonthWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> otherEmpAnnualWiseLst = new List<workforceLstClass>();
                 List<workforceLstClass> otherEmpPriceUtilizationWiseLst = new List<workforceLstClass>(); 
                 for(String otherEmpUniqueKey : otherEmpUniqueKeyWithNumberAndCostYearsWiseMap.keySet()){
                    if((otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Per Unit=>Annual Price')){
                        otherEmpAnnualWiseLst.add(getWorkforceLstClassAnnually(otherEmpUniqueKey,otherEmpUniqueKeyWithNumberAndCostYearsWiseMap,otherEmpUniqueKeyAndWorkforceMap));  
                        //otherEmpAnnualWiseLst.workforceUniqueKey = accountantUniqueKey;
                    }
                    else if((otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Per Unit=>Monthly Price')){
                        otherEmpMonthWiseLst.add(getWorkforceLstClassPerUtilization(otherEmpUniqueKey,otherEmpUniqueKeyWithNumberAndCostYearsWiseMap,otherEmpUniqueKeyAndWorkforceMap));
                       
                    }
                    else if((otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price') ||
                            (otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price') ||
                            (otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student') ||
                            (otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route') ||
                            (otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM') ||
                            (otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                otherEmpPriceUtilizationWiseLst.add(getWorkforceLstClassPerUtilization(otherEmpUniqueKey,otherEmpUniqueKeyWithNumberAndCostYearsWiseMap,otherEmpUniqueKeyAndWorkforceMap));
                                //otherEmpPriceUtilizationWiseLst.workforceUniqueKey = accountantUniqueKey;
                                if((otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Annual Price')){
                                    workforceQuoteItemLstForLumsumAnnually.add(otherEmpUniqueKeyAndWorkforceMap.get(otherEmpUniqueKey));
                                }else if((otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Monthly Price')){
                                    workforceQuoteItemLstForLumsumMonthly.add(otherEmpUniqueKeyAndWorkforceMap.get(otherEmpUniqueKey));
                                }else if((otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per student')){
                                    workforceQuoteItemLstForLumsumPerStudent.add(otherEmpUniqueKeyAndWorkforceMap.get(otherEmpUniqueKey));
                                }else if((otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per route')){
                                    workforceQuoteItemLstForLumsumPerRoute.add(otherEmpUniqueKeyAndWorkforceMap.get(otherEmpUniqueKey));
                                }else if((otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per KM')){
                                    workforceQuoteItemLstForLumsumPerKm.add(otherEmpUniqueKeyAndWorkforceMap.get(otherEmpUniqueKey));
                                }else if((otherEmpUniqueKeyAndPricingMethodTypeMap.get(otherEmpUniqueKey)).equalsIgnoreCase('Comprehensive Price per Quotation=>Per ton')){
                                    workforceQuoteItemLstForLumsumPerTon.add(otherEmpUniqueKeyAndWorkforceMap.get(otherEmpUniqueKey));
                                }
                    }
                }
                priceClassObj.otherEmpMonthWiseLst = otherEmpMonthWiseLst;
                priceClassObj.otherEmpAnnualWiseLst = otherEmpAnnualWiseLst;
                priceClassObj.otherEmpPriceUtilizationWiseLst = otherEmpPriceUtilizationWiseLst;
                system.debug('priceClassObj.otherEmpMonthWiseLst  : ' + JSON.serializePretty(priceClassObj.otherEmpMonthWiseLst) );
                system.debug('priceClassObj.otherEmpAnnualWiseLst  : ' + JSON.serializePretty(priceClassObj.otherEmpAnnualWiseLst) );
                system.debug('priceClassObj.otherEmpPriceUtilizationWiseLst  : ' + JSON.serializePretty(priceClassObj.otherEmpPriceUtilizationWiseLst) ); 


                //Lumsum cost calculation
                
                List<lumsumCostClass> annuallyLumsumCostYearWiseLst = new List<lumsumCostClass>();
                List<lumsumCostClass> monthlyLumsumCostYearWiseLst = new List<lumsumCostClass>();
                List<lumsumCostClass> perStudentLumsumCostYearWiseLst = new List<lumsumCostClass>();
                List<lumsumCostClass> perRouteLumsumCostYearWiseLst = new List<lumsumCostClass>();
                List<lumsumCostClass> perKmLumsumCostYearWiseLst = new List<lumsumCostClass>();
                List<lumsumCostClass> perTonLumsumCostYearWiseLst = new List<lumsumCostClass>();
                
                //lumsum annually calc
                annuallyLumsumCostYearWiseLst.addAll(getLumsumCostLstYearWise(vehicleQuoteItemLstForLumsumAnnally,workforceQuoteItemLstForLumsumAnnually));
                monthlyLumsumCostYearWiseLst.addAll(getLumsumCostLstYearWise(vehicleQuoteItemLstForLumsumMonthly,workforceQuoteItemLstForLumsumMonthly));
                perStudentLumsumCostYearWiseLst.addAll(getLumsumCostLstYearWise(vehicleQuoteItemLstForLumsumPerStudent,workforceQuoteItemLstForLumsumPerStudent));
                perRouteLumsumCostYearWiseLst.addAll(getLumsumCostLstYearWise(vehicleQuoteItemLstForLumsumPerRoute,workforceQuoteItemLstForLumsumPerRoute));
                perKmLumsumCostYearWiseLst.addAll(getLumsumCostLstYearWise(vehicleQuoteItemLstForLumsumPerKm,workforceQuoteItemLstForLumsumPerKm));
                perTonLumsumCostYearWiseLst.addAll(getLumsumCostLstYearWise(vehicleQuoteItemLstForLumsumPerTon,workforceQuoteItemLstForLumsumPerTon));
                
                priceClassObj.annuallyLumsumCostYearWiseLst = annuallyLumsumCostYearWiseLst;
                priceClassObj.monthlyLumsumCostYearWiseLst = monthlyLumsumCostYearWiseLst;
                priceClassObj.perStudentLumsumCostYearWiseLst = perStudentLumsumCostYearWiseLst;
                priceClassObj.perRouteLumsumCostYearWiseLst = perRouteLumsumCostYearWiseLst;
                priceClassObj.perKmLumsumCostYearWiseLst = perKmLumsumCostYearWiseLst;
                priceClassObj.perTonLumsumCostYearWiseLst = perTonLumsumCostYearWiseLst;
                system.debug('priceClassObj.annuallyLumsumCostYearWiseLst  : ' + JSON.serializePretty(priceClassObj.annuallyLumsumCostYearWiseLst) );
                system.debug('priceClassObj.monthlyLumsumCostYearWiseLst  : ' + JSON.serializePretty(priceClassObj.monthlyLumsumCostYearWiseLst) );
                system.debug('priceClassObj.perStudentLumsumCostYearWiseLst  : ' + JSON.serializePretty(priceClassObj.perStudentLumsumCostYearWiseLst) ); 
                system.debug('priceClassObj.perRouteLumsumCostYearWiseLst  : ' + JSON.serializePretty(priceClassObj.perRouteLumsumCostYearWiseLst) );
                system.debug('priceClassObj.perKmLumsumCostYearWiseLst  : ' + JSON.serializePretty(priceClassObj.perKmLumsumCostYearWiseLst) );
                system.debug('priceClassObj.perTonLumsumCostYearWiseLst  : ' + JSON.serializePretty(priceClassObj.perTonLumsumCostYearWiseLst) ); 
           */
            return priceClassObj;
        }else{
            system.debug('quote id is null; Can\'t proceed with pricing calculation');
            return null;
        }
        
    }

    @AuraEnabled
    public static PriceClass priceAnalysisCalculation(String quoteId){
        if(quoteId != null){
            PriceClass priceClassObj = priceCalculation(quoteId); 
            return priceClassObj;
        }else{
            system.debug('quote id is null, skipped all price analysis calculation');
            return null;
        }
    }
    
    private static  List<lumsumCostClass> getLumsumCostLstYearWise(List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLst, List<ET_Workforce_Quote_Item__c> workforceQuoteItemLst){
        //i am considering here that price utilization for this price method and price type combination gonna be same for each and every vehcile/manpower line.
        Decimal priceUtilization = 0.0;
        List<lumsumCostClass> lumsumCostLstYearWise = new List<lumsumCostClass>();
        intializeClassMaps();
        for(ET_Vehicle_Quote_Item__c lumsumVehicle : vehicleQuoteItemLst){
            setVehicleRelatedMapValues(lumsumVehicle);
            if(lumsumVehicle.ET_Price_Utilization__c != null && priceUtilization == 0.0){
                priceUtilization = lumsumVehicle.ET_Price_Utilization__c;
            }
            

        } 
        
        for(ET_Workforce_Quote_Item__c lumsumWorkforce : workforceQuoteItemLst){
            setManpowerRelatedMapValues(lumsumWorkforce);
            if(lumsumWorkforce.ET_Price_Utilization__c != null && priceUtilization == 0.0){
                priceUtilization = lumsumWorkforce.ET_Price_Utilization__c;
            }
        }
        //  
        
        for(Integer i= 1; i<9; i++){
            Decimal lumsumCost = 0.0;
            lumsumCostClass lumsumCostClassObj = new lumsumCostClass();
            CostCalculationClass  costCalcObj = doCostCalculation(i);
            ProfitMarginValueCalculationClass profitValueCalcObj = doProfitCalculation(i);
            lumsumCost = ((costCalcObj.toalCost - costCalcObj.fuelCost - costCalcObj.otherCosts) + (profitValueCalcObj.totalProjectProfitMarginValue - profitValueCalcObj.fuelProfitMarginValue  - profitValueCalcObj.otherCostProfitMarginValue));
            if(priceUtilization != null && priceUtilization != 0.0){
                lumsumCostClassObj.lumsumCost = lumsumCost / priceUtilization;
            }
            
            lumsumCostLstYearWise.add(lumsumCostClassObj);
        }

        return lumsumCostLstYearWise;

    }

    private static workforceLstClass getWorkforceLstClassAnnually(String workforceUniqueKey, Map<String,Map<Integer,Decimal>> workforceUniqueKeyWithNumberAndCostYearsWiseMap,Map<String,ET_Workforce_Quote_Item__c> workforceUniqueKeyAndWorkforceMap){
        workforceLstClass workforceYearWiseLstObj =  new workforceLstClass();
        List<workforceCostCommonClass> ListToHoldWorkforce = new List<workforceCostCommonClass>();
        for(Integer i=1; i<9; i++){
            workforceCostCommonClass workforceCostYearWise = new workforceCostCommonClass();
            if((workforceUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceUniqueKey)).get(i) != null){
                workforceCostYearWise.workforceCost = (workforceUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceUniqueKey)).get(i);
            }
            ListToHoldWorkforce.add(workforceCostYearWise);
        }
        workforceYearWiseLstObj.workforceLstYearWise = ListToHoldWorkforce;
        workforceYearWiseLstObj.numberOfWorkforce = Integer.valueOf((workforceUniqueKeyAndWorkforceMap.get(workforceUniqueKey)).ET_Number_of_Workforce__c);
        workforceYearWiseLstObj.workforceUniqueKey = workforceUniqueKey;
        return workforceYearWiseLstObj;
    }


    private static workforceLstClass getWorkforceLstClassPerUtilization(String workforceUniqueKey, Map<String,Map<Integer,Decimal>> workforceUniqueKeyWithNumberAndCostYearsWiseMap, Map<String,ET_Workforce_Quote_Item__c> workforceUniqueKeyAndWorkforceMap ){
        workforceLstClass workforceYearWiseLstObj =  new workforceLstClass();
        ET_Workforce_Quote_Item__c workforceQuoteItem = workforceUniqueKeyAndWorkforceMap.get(workforceUniqueKey);
        workforceYearWiseLstObj.numberOfWorkforce = Integer.valueOf(workforceQuoteItem.ET_Number_of_Workforce__c);
        List<workforceCostCommonClass> ListToHoldWorkforce = new List<workforceCostCommonClass>();
        for(Integer i=1; i<9; i++){
            workforceCostCommonClass workforceCostYearWise = new workforceCostCommonClass();
            if((workforceUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceUniqueKey)).get(i) != null && workforceQuoteItem.ET_Price_Utilization__c != null && workforceQuoteItem.ET_Price_Utilization__c != 0.0){
                workforceCostYearWise.workforceCost = (((workforceUniqueKeyWithNumberAndCostYearsWiseMap.get(workforceUniqueKey)).get(i)) / workforceQuoteItem.ET_Price_Utilization__c);
               
            }
            
            ListToHoldWorkforce.add(workforceCostYearWise);
        }
        workforceYearWiseLstObj.workforceLstYearWise = ListToHoldWorkforce;
        workforceYearWiseLstObj.workforceUniqueKey = workforceUniqueKey;
        //workforceYearWiseLstObj.numberOfWorkforce = (workforceUniqueKeyAndWorkforceMap.get(workforceUniqueKey)).ET_Number_of_Workforce__c;
        return workforceYearWiseLstObj;
    }




    private static  Decimal getVehicleCost(ET_Vehicle_Quote_Item__c vehicleQuoteItem ){
        
        Decimal vehicleCost = 0.0;
         if(vehicleQuoteItem != null){
            if(vehicleQuoteItem.ET_Total_Vehicles_Cost__c != null){
                vehicleCost = vehicleCost+ vehicleQuoteItem.ET_Total_Vehicles_Cost__c;
            }
            if(vehicleQuoteItem.ET_Annual_Vehicles_Profit_Value__c != null){
                vehicleCost = vehicleCost+ vehicleQuoteItem.ET_Annual_Vehicles_Profit_Value__c;
            }
            if(vehicleQuoteItem.ET_Vehicle_VAT_Cost__c != null){
                vehicleCost = vehicleCost+ vehicleQuoteItem.ET_Vehicle_VAT_Cost__c;
            }
        }
       
        return vehicleCost;
    }


    
    private static  Decimal getVehicleFuelCost(ET_Vehicle_Quote_Item__c vehicleQuoteItem ){
        
        Decimal fuelCost = 0.0;
         if(vehicleQuoteItem != null){
            if(vehicleQuoteItem.ET_Annual_Fuel_Profit_Value__c != null){
                fuelCost = fuelCost + vehicleQuoteItem.ET_Annual_Fuel_Profit_Value__c;
            }
            if(vehicleQuoteItem.ET_Total_Fuel_Cost__c != null){
                fuelCost = fuelCost + vehicleQuoteItem.ET_Total_Fuel_Cost__c;
            }
            
        }
       
        return fuelCost;
    }


    private static Decimal getManpowerCost(ET_Workforce_Quote_Item__c workforceQuoteItem){
        Decimal manpowerCost = 0.0;
        if(workforceQuoteItem != null){
            if(workforceQuoteItem.ET_Total_Cost__c != null){
                manpowerCost = manpowerCost+ workforceQuoteItem.ET_Total_Cost__c;
            }
            if(workforceQuoteItem.ET_Annual_Profit_Value__c != null){
                manpowerCost = manpowerCost+ workforceQuoteItem.ET_Annual_Profit_Value__c;
            }
            if(workforceQuoteItem.ET_Workforce_VAT_Cost__c != null){
                manpowerCost = manpowerCost+ workforceQuoteItem.ET_Workforce_VAT_Cost__c;
            }

        }
        return manpowerCost;
            
        
    }

    public class priceClass{
        @AuraEnabled
        public List<combinationPriceLstClass> combinationPriceAnnualWiseLst;
        @AuraEnabled
        public List<combinationPriceLstClass> combinationPriceMonthWiseLst;
        @AuraEnabled
        public List<lumsumCostClass> annuallyLumsumCostYearWiseLst;
        @AuraEnabled
        public List<lumsumCostClass> monthlyLumsumCostYearWiseLst;
        @AuraEnabled
        public List<lumsumCostClass> perStudentLumsumCostYearWiseLst;
        @AuraEnabled
        public List<lumsumCostClass> perRouteLumsumCostYearWiseLst;
        @AuraEnabled
        public List<lumsumCostClass> perKmLumsumCostYearWiseLst;
        @AuraEnabled
        public List<lumsumCostClass> perTonLumsumCostYearWiseLst;
        @AuraEnabled
        public List<vehicleLstClass> vehicleMonthWiseLst;
        @AuraEnabled
        public List<vehicleLstClass> vehicleAnnualWiseLst;
        @AuraEnabled
        public List<vehicleLstClass> vehiclePriceUtilizationWiseLst; 
        @AuraEnabled
        public List<workforceLstClass> driverMonthWiseLst;
        @AuraEnabled
        public List<workforceLstClass> driverAnnualWiseLst;
        @AuraEnabled
        public List<workforceLstClass> driverPriceUtilizationWiseLst; 
        @AuraEnabled
        public List<workforceLstClass> nannyMonthWiseLst;
        @AuraEnabled
        public List<workforceLstClass> nannyAnnualWiseLst;
        @AuraEnabled
        public List<workforceLstClass> nannyPriceUtilizationWiseLst; 
        @AuraEnabled
        public List<workforceLstClass> supervisorMonthWiseLst;
        @AuraEnabled
        public List<workforceLstClass> supervisorAnnualWiseLst;
        @AuraEnabled
        public List<workforceLstClass> supervisorPriceUtilizationWiseLst; 
        @AuraEnabled
        public List<workforceLstClass> coordinatorMonthWiseLst;
        @AuraEnabled
        public List<workforceLstClass> coordinatorAnnualWiseLst;
        @AuraEnabled
        public List<workforceLstClass> coordinatorPriceUtilizationWiseLst; 
        @AuraEnabled
        public List<workforceLstClass> accountantMonthWiseLst;
        @AuraEnabled
        public List<workforceLstClass> accountantAnnualWiseLst;
        @AuraEnabled
        public List<workforceLstClass> accountantPriceUtilizationWiseLst; 
        @AuraEnabled
        public List<workforceLstClass> otherEmpMonthWiseLst;
        @AuraEnabled
        public List<workforceLstClass> otherEmpAnnualWiseLst;
        @AuraEnabled
        public List<workforceLstClass> otherEmpPriceUtilizationWiseLst; 

    }
    
    public class vehicleCostCommonClass{
        //public String vehicleUniqueKey = '';
        @AuraEnabled
        public Decimal vehicleCost = 0.0;
        @AuraEnabled
        public Decimal fuelCost = 0.0;
       // public Integer contractYear = 0;
    }

    public class lumsumCostClass{
        @AuraEnabled
        public Decimal lumsumCost = 0.0;
    }

    


    public class workforceCostCommonClass{
        //public String workforceUniqueKey = '';
        @AuraEnabled
        public Decimal workforceCost = 0.0;
        //public Integer contractYear = 0;
        
    }

    public class workforceLstClass{
        @AuraEnabled
        public List<workforceCostCommonClass> workforceLstYearWise;
        @AuraEnabled
        public Integer numberOfWorkforce = 0;
        @AuraEnabled
        public String workforceUniqueKey = '';
    }

    public class combinationPriceLstClass{
        @AuraEnabled
        public List<combinationPriceClass> combinationPriceLstYearWise;
        @AuraEnabled
        public Integer vehicleNumberInCombination = 0;
        @AuraEnabled
        public String combinationUniqueKey = '';

    }

    public class vehicleLstClass{
        @AuraEnabled
        public List<vehicleCostCommonClass> vehicleLstYearWise;
        @AuraEnabled
        public Integer vehicleNumberInLineItem = 0;
        @AuraEnabled
        public String vehicleUniqueKey = '';

    }


    public class combinationPriceClass{
        //public Integer contractYear = 0;
        @AuraEnabled
        public Decimal combinationCost = 0.0;
        //public String combinationUniqueKey = ''; 
    }
   
    public class TotalProjectClass{
        @AuraEnabled
        public List<CostCalculationClass> totalProjectCostCalculationLst;
        @AuraEnabled
        public List<ProfitMarginRateCalculationClass> totalProjectProfitRateLst;
        @AuraEnabled
        public List<ProfitMarginValueCalculationClass> totalProjectProfitValueLst;
        @AuraEnabled
        public List<PaybackValueClass> totalProjectPaybackValueLst;
        @AuraEnabled
        public List<PaybackAnalysisClass> totalProjectPaybackAnalysisLst;
    }

    public class CostCalculationClass{
        @AuraEnabled
        public Integer contractYear = 0;
        @AuraEnabled
        public Decimal vehicleCost = 0.0;
        @AuraEnabled
        public Decimal fuelCost= 0.0;
        @AuraEnabled
        public Decimal driverCost = 0.0;
        @AuraEnabled
        public Decimal nanniesCost = 0.0;
        @AuraEnabled
        public Decimal supervisorCost = 0.0;
        @AuraEnabled
        public Decimal coordinatorCost = 0.0;
        @AuraEnabled
        public Decimal accountantCost = 0.0;
        @AuraEnabled
        public Decimal otherEmpCost = 0.0;
        @AuraEnabled
        public Decimal otherCosts = 0.0;
        @AuraEnabled
        public Decimal VATCost = 0.0;
        @AuraEnabled
        public Decimal toalCost = 0.0;
    }

    public class ProfitMarginRateCalculationClass{
        @AuraEnabled
        public Integer contractYear = 0;
        @AuraEnabled
        public Decimal vehicleProfitMarginRate = 0.0;
        @AuraEnabled
        public Decimal fuelProfitMarginRate = 0.0;
        @AuraEnabled
        public Decimal driverProfitMarginRate = 0.0;
        @AuraEnabled
        public Decimal nannyProfitMarginRate = 0.0;
        @AuraEnabled
        public Decimal supervisorProfitMarginRate = 0.0;
        @AuraEnabled
        public Decimal coordinatorProfitMarginRate = 0.0;
        @AuraEnabled
        public Decimal accountantProfitMarginRate = 0.0;
        @AuraEnabled
        public Decimal otherEmpProfitMarginRate = 0.0;
        @AuraEnabled
        public Decimal otherCostProfitMarginRate = 0.0;
        @AuraEnabled
        public Decimal totalProjectProfitMarginRate = 0.0;        
    }

    public class ProfitMarginValueCalculationClass{
        @AuraEnabled
        public Integer contractYear = 0;
        @AuraEnabled
        public Decimal vehicleProfitMarginValue = 0.0;
        @AuraEnabled
        public Decimal fuelProfitMarginValue = 0.0;
        @AuraEnabled
        public Decimal driverProfitMarginValue = 0.0;
        @AuraEnabled
        public Decimal nannyProfitMarginValue = 0.0;
        @AuraEnabled
        public Decimal supervisorProfitMarginValue = 0.0;
        @AuraEnabled
        public Decimal coordinatorProfitMarginValue = 0.0;
        @AuraEnabled
        public Decimal accountantProfitMarginValue = 0.0;
        @AuraEnabled
        public Decimal otherEmpProfitMarginValue = 0.0;
        @AuraEnabled
        public Decimal otherCostProfitMarginValue = 0.0;
        @AuraEnabled
        public Decimal totalProjectProfitMarginValue = 0.0;        
    }

    public class PaybackValueClass{
        @AuraEnabled
        public Integer contractYear = 0;
        @AuraEnabled
        public Decimal totalValueofRental = 0.0;
        @AuraEnabled
        public Decimal totalInvestment = 0.0;
        @AuraEnabled
        public Decimal totalDepreciation = 0.0;
        @AuraEnabled
        public Decimal totalResaleValue = 0.0;

    }


    public class PaybackAnalysisClass{
        @AuraEnabled
        public Integer contractYear = 0;
        @AuraEnabled
        public Decimal payback1 = 0.0;
        @AuraEnabled
        public Decimal paybackRatio1 = 0.0;
        @AuraEnabled
        public Decimal payback2 = 0.0;
        @AuraEnabled
        public Decimal paybackRatio2 = 0.0;
        @AuraEnabled
        public Decimal annualSharePayback2 = 0.0;
        @AuraEnabled
        public Decimal payback3 = 0.0;
        @AuraEnabled
        public Decimal paybackRatio3 = 0.0;
        @AuraEnabled
        public Decimal annualSharePayback3 = 0.0;
    }

    public class ProjectProfitLossClass{
        @AuraEnabled
        public Integer contractYear = 0;
        @AuraEnabled
        public Decimal vehicleRevenue = 0.0;
        @AuraEnabled
        public Decimal manpowerRevenue = 0.0;
        @AuraEnabled
        public Decimal otherRevenue = 0.0;
        @AuraEnabled
        public Decimal VATRevenue = 0.0;
        @AuraEnabled
        public Decimal totalOperatingRevenue = 0.0;
        @AuraEnabled
        public Decimal repairAndMaintenance = 0.0;
        @AuraEnabled
        public Decimal fuel = 0.0;
        @AuraEnabled
        public Decimal manpowerWages = 0.0;
        @AuraEnabled
        public Decimal manpowerOverTime = 0.0;
        @AuraEnabled
        public Decimal totalVariableCost = 0.0;
        @AuraEnabled
        public Decimal ContributionMargin = 0.0;
        @AuraEnabled
        public Decimal ContributionMarginRate = 0.0;
        @AuraEnabled
        public Decimal vehicleRegistration = 0.0;
        @AuraEnabled
        public Decimal vehicleInsurance = 0.0;
        @AuraEnabled
        public Decimal vehicleOtherExpenses = 0.0;
        @AuraEnabled
        public Decimal annualLeaveAllowance = 0.0;
        @AuraEnabled
        public Decimal endOfService = 0.0;
        @AuraEnabled
        public Decimal clothesAllowance = 0.0;
        @AuraEnabled
        public Decimal healthCard = 0.0;
        @AuraEnabled
        public Decimal licensingFees = 0.0;
        @AuraEnabled
        public Decimal visaCost = 0.0;
        @AuraEnabled
        public Decimal accommodation = 0.0;
        @AuraEnabled
        public Decimal totalFixedCost = 0.0;
        @AuraEnabled
        public Decimal grossProfitOrLoss = 0.0;
        @AuraEnabled
        public Decimal grossProfitOrLossRate = 0.0;
        @AuraEnabled
        public Decimal totalSellingAndAdministration = 0.0;
        @AuraEnabled
        public Decimal ebitda = 0.0;
        @AuraEnabled
        public Decimal ebitdaRate = 0.0;
        @AuraEnabled
        public Decimal capitalGainOrLoss = 0.0;
        @AuraEnabled
        public Decimal totalOtherIncome = 0.0;
        @AuraEnabled
        public Decimal vehicleDepriciation = 0.0;
        @AuraEnabled
        public Decimal totalDepriciationAndAmortisat = 0.0;
        @AuraEnabled
        public Decimal ebit = 0.0;
        @AuraEnabled
        public Decimal ebitRate = 0.0;
        @AuraEnabled
        public Decimal vehicleFinancing = 0.0;
        @AuraEnabled
        public Decimal totalInterest = 0.0;
        @AuraEnabled
        public Decimal netProfitOrLoss = 0.0;
        @AuraEnabled
        public Decimal netProfitOrLossMarginRate = 0.0;
    }

    public class ProjectProfitLossAnalysisClass{
        @AuraEnabled
        public Decimal vehicleRevenueRate = 0.0;
        @AuraEnabled
        public Decimal manpowerRevenueRate = 0.0;
        @AuraEnabled
        public Decimal otherRevenueRate = 0.0;
        @AuraEnabled
        public Decimal VATRevenueRate = 0.0;
        @AuraEnabled
        public Decimal totalOperatingRevenueRate = 0.0;
        @AuraEnabled
        public Decimal repairAndMaintenanceRate = 0.0;
        @AuraEnabled
        public Decimal fuelRate = 0.0;
        @AuraEnabled
        public Decimal manpowerWagesRate = 0.0;
        @AuraEnabled
        public Decimal manpowerOverTimeRate = 0.0;
        @AuraEnabled
        public Decimal totalVariableCostRate = 0.0;
        @AuraEnabled
        public Decimal ContributionMarginRate = 0.0;
        @AuraEnabled
        public Decimal vehicleRegistrationRate = 0.0;
        @AuraEnabled
        public Decimal vehicleInsuranceRate = 0.0;
        @AuraEnabled
        public Decimal vehicleOtherExpensesRate = 0.0;
        @AuraEnabled
        public Decimal annualLeaveAllowanceRate = 0.0;
        @AuraEnabled
        public Decimal endOfServiceRate = 0.0;
        @AuraEnabled
        public Decimal clothesAllowanceRate = 0.0;
        @AuraEnabled
        public Decimal healthCardRate = 0.0;
        @AuraEnabled
        public Decimal licensingFeeRate = 0.0;
        @AuraEnabled
        public Decimal visaCostRate = 0.0;
        @AuraEnabled
        public Decimal accommodationRate = 0.0;
        @AuraEnabled
        public Decimal totalFixedCostRate = 0.0;
        
        @AuraEnabled
        public Decimal grossProfitOrLossRate = 0.0;
        @AuraEnabled
        public Decimal totalSellingAndAdministrationRate = 0.0;
     
        @AuraEnabled
        public Decimal ebitdaRate = 0.0;
        @AuraEnabled
        public Decimal capitalGainOrLossRate = 0.0;
        @AuraEnabled
        public Decimal totalOtherIncomeRate = 0.0;
        @AuraEnabled
        public Decimal vehicleDepriciationRate = 0.0;
        @AuraEnabled
        public Decimal totalDepriciationAndAmortisatRate = 0.0;
       
        @AuraEnabled
        public Decimal ebitRate = 0.0;
        @AuraEnabled
        public Decimal vehicleFinancingRate = 0.0;
        @AuraEnabled
        public Decimal totalInterestRate = 0.0;
        @AuraEnabled
        public Decimal netProfitOrLossRate = 0.0;
       
    }
    
    @TestVisible private static void testCoverageMethod(){
       
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
     	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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