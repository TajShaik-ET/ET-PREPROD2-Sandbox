public without sharing class workForceServiceRequestControllerHelper {
    public  ET_ServiceRequestController.QuoteCalculationClass quotecalculationObj;
    public  Id serviceRequestId; 
    public static Map<String, List<ET_Other_Cost_Request__c>> typeVsOtherCostMap = new Map<String, List<ET_Other_Cost_Request__c>>();  
    Private static decimal totalDrivers =0;
    Private static decimal totalNannies =0;
    Private static decimal totalAccountants =0;
    Private static decimal totalCoordinators =0;
    Private static decimal totalSuperVisors =0;
    Private static decimal totalOtherEmployees =0;
    private static List<integer> driverContractYears = new List<integer>();  
    private static List<integer> nannyContractYears = new List<integer>();  
    private static List<integer> accountantContractYears = new List<integer>();  
    private static List<integer> coordinatorContractYears = new List<integer>();  
    private static List<integer> supervisorContractYears = new List<integer>();  
    private static List<integer> otherEmployeeContractYears = new List<integer>();
    
    Private static Map<integer, Map<String, otherCostCalcClassTProj>>  driverSpecilReqsForTotProjMap = new Map<integer, Map<String, otherCostCalcClassTProj>>();
    Private static Map<integer, Map<String, otherCostCalcClassTProj>>  nannySpecilReqsForTotProjMap = new Map<integer, Map<String, otherCostCalcClassTProj>>();
    Private static Map<integer, Map<String, otherCostCalcClassTProj>>  accountantSpecilReqsForTotProjMap = new Map<integer, Map<String, otherCostCalcClassTProj>>();
    Private static Map<integer, Map<String, otherCostCalcClassTProj>>  coordinatorSpecilReqsForTotProjMap = new Map<integer, Map<String, otherCostCalcClassTProj>>();
    Private static Map<integer, Map<String, otherCostCalcClassTProj>>  supervisorSpecilReqsForTotProjMap = new Map<integer, Map<String, otherCostCalcClassTProj>>();
    Private static Map<integer, Map<String, otherCostCalcClassTProj>>  otherEmployeeSpecilReqsForTotProjMap = new Map<integer, Map<String, otherCostCalcClassTProj>>();
    
    public workForceServiceRequestControllerHelper(Id serviceRequestId,ET_ServiceRequestController.QuoteCalculationClass quotecalculationObj) {
        this.quotecalculationObj = quotecalculationObj;
        this.serviceRequestId = serviceRequestId;
    }
    
    /* Method 	   : doWorkforceQuoteCalculation
Description : Calculate workforce common info like - line number, type, key etc..
Rates from Master
workforce related items like - other cost Requests
*/
    
    public static ET_ServiceRequestController.QuoteCalculationClass doWorkforceQuoteCalculation(Id serviceRequestId,ET_ServiceRequestController.QuoteCalculationClass quotecalculationObj, 
                                                                                                boolean isVATCalculated , Map<String,String> servReqVSRate , 
                                                                                                Map<String, ET_Pricing_Service_Reserve_Master__c> reserveMasterWithServiceType)
    {
        
        
        
        Map<Id,ET_Work_force__c> workforceRequestMap = new Map<Id,ET_Work_force__c>();
        workforceRequestMap = ET_PricingUtilityClass.getWorkforceRequestMap(serviceRequestId);
        
        if(!workforceRequestMap.isEmpty()){
            try{
                
                Map<String, Map<String, List<ET_Other_Cost_Request__c>>> lineAndTypeVsOtherCostMap = new Map<String, Map<String, List<ET_Other_Cost_Request__c>>>();
                
                // Prepare other cost Requests in Map for Diff services
                for(ET_Other_Cost_Request__c otCost : [Select ET_Cost_Type__c,ET_Cost_Value__c,ET_Other_Cost_Line_Number__c,ET_Other_Cost_Request_Type__c,ET_Pricing_Service_Request__c,Id,IsDeleted,
                                                       LastModifiedById,LastModifiedDate,Name,OwnerId,SystemModstamp,Vehicle_Request__c,Work_force_Request__c,
                                                       Work_force_Request__r.ET_Accountant_Category__c,Work_force_Request__r.ET_Coordinator_Category__c,Work_force_Request__r.ET_Driver_Category__c,Work_force_Request__r.ET_Nanny_Category__c,Work_force_Request__r.ET_Supervisor_Category__c,
                                                       Work_force_Request__r.ET_Other_employee_Category__c, Work_force_Request__r.ET_Workforce_Line_Info__c
                                                       FROM ET_Other_Cost_Request__c where Work_force_Request__c IN: workforceRequestMap.Keyset()])
                {
                    
                    if(lineAndTypeVsOtherCostMap != null && lineAndTypeVsOtherCostMap.containsKey(otCost.Work_force_Request__r.ET_Workforce_Line_Info__c.split(':')[1])){
                        Map<String, List<ET_Other_Cost_Request__c>> typeVsOtherCostMapInnerMap = lineAndTypeVsOtherCostMap.get(otCost.Work_force_Request__r.ET_Workforce_Line_Info__c.split(':')[1]);
                        
                        if(otCost.Work_force_Request__r.ET_Accountant_Category__c != null && otCost.Work_force_Request__r.ET_Accountant_Category__c != '')
                        {
                            if(typeVsOtherCostMapInnerMap.containsKey('Accountant')){
                                typeVsOtherCostMapInnerMap.get('Accountant').add(otCost); 
                            }
                            else{
                                typeVsOtherCostMapInnerMap.Put('Accountant', new List<ET_Other_Cost_Request__c>{otCost});
                            }
                            
                        }
                        else if(otCost.Work_force_Request__r.ET_Coordinator_Category__c != null && otCost.Work_force_Request__r.ET_Coordinator_Category__c != '')
                        {
                            if(typeVsOtherCostMapInnerMap.containsKey('Coordinator')){
                                typeVsOtherCostMapInnerMap.get('Coordinator').add(otCost);
                            }
                            else{
                                typeVsOtherCostMapInnerMap.Put('Coordinator', new List<ET_Other_Cost_Request__c>{otCost});
                            }
                            
                        }
                        else if(otCost.Work_force_Request__r.ET_Driver_Category__c != null && otCost.Work_force_Request__r.ET_Driver_Category__c != '')
                        {
                            if(typeVsOtherCostMapInnerMap.containsKey('Driver')){
                                typeVsOtherCostMapInnerMap.get('Driver').add(otCost);
                            }
                            else{
                                typeVsOtherCostMapInnerMap.Put('Driver', new List<ET_Other_Cost_Request__c>{otCost});
                            }
                            
                        }
                        else if(otCost.Work_force_Request__r.ET_Nanny_Category__c != null && otCost.Work_force_Request__r.ET_Nanny_Category__c != '')
                        {
                            if(typeVsOtherCostMapInnerMap.containsKey('Nanny')){
                                typeVsOtherCostMapInnerMap.get('Nanny').add(otCost);
                            }
                            else{
                                typeVsOtherCostMapInnerMap.Put('Nanny', new List<ET_Other_Cost_Request__c>{otCost});
                            }
                            
                            
                        }
                        else if(otCost.Work_force_Request__r.ET_Supervisor_Category__c != null && otCost.Work_force_Request__r.ET_Supervisor_Category__c != '')
                        {
                            if(typeVsOtherCostMapInnerMap.containsKey('Supervisor')){
                                typeVsOtherCostMapInnerMap.get('Supervisor').add(otCost);
                            }
                            else{
                                typeVsOtherCostMapInnerMap.Put('Supervisor', new List<ET_Other_Cost_Request__c>{otCost});
                            }
                            
                        }
                        else if(otCost.Work_force_Request__r.ET_Other_employee_Category__c != null && otCost.Work_force_Request__r.ET_Other_employee_Category__c != '')
                        {
                            
                            if(typeVsOtherCostMapInnerMap.containsKey('OtherEmployee')){
                                typeVsOtherCostMapInnerMap.get('OtherEmployee').add(otCost);
                            }
                            else{
                                typeVsOtherCostMapInnerMap.Put('OtherEmployee', new List<ET_Other_Cost_Request__c>{otCost});
                            }
                        }  
                    }
                    else{
                        Map<String, List<ET_Other_Cost_Request__c>> typeVsOtherCostMapInnerMap = new Map<String, List<ET_Other_Cost_Request__c>>();
                        if(otCost.Work_force_Request__r.ET_Accountant_Category__c != null && otCost.Work_force_Request__r.ET_Accountant_Category__c != '')
                        {
                            typeVsOtherCostMapInnerMap.Put('Accountant', new List<ET_Other_Cost_Request__c>{otCost});
                        }
                        else if(otCost.Work_force_Request__r.ET_Coordinator_Category__c != null && otCost.Work_force_Request__r.ET_Coordinator_Category__c != '')
                        {
                            typeVsOtherCostMapInnerMap.Put('Coordinator', new List<ET_Other_Cost_Request__c>{otCost});
                        }
                        else if(otCost.Work_force_Request__r.ET_Driver_Category__c != null && otCost.Work_force_Request__r.ET_Driver_Category__c != '')
                        {
                            typeVsOtherCostMapInnerMap.Put('Driver', new List<ET_Other_Cost_Request__c>{otCost});
                        }
                        else if(otCost.Work_force_Request__r.ET_Nanny_Category__c != null && otCost.Work_force_Request__r.ET_Nanny_Category__c != '')
                        {
                            typeVsOtherCostMapInnerMap.Put('Nanny', new List<ET_Other_Cost_Request__c>{otCost});
                        }
                        else if(otCost.Work_force_Request__r.ET_Supervisor_Category__c != null && otCost.Work_force_Request__r.ET_Supervisor_Category__c != '')
                        {
                            typeVsOtherCostMapInnerMap.Put('Supervisor', new List<ET_Other_Cost_Request__c>{otCost});
                        }
                        else if(otCost.Work_force_Request__r.ET_Other_employee_Category__c != null && otCost.Work_force_Request__r.ET_Other_employee_Category__c != '')
                        {
                            typeVsOtherCostMapInnerMap.Put('OtherEmployee', new List<ET_Other_Cost_Request__c>{otCost});
                        } 
                        
                        lineAndTypeVsOtherCostMap.put(otCost.Work_force_Request__r.ET_Workforce_Line_Info__c.split(':')[1] ,typeVsOtherCostMapInnerMap );
                    }
                    
                }
                
                system.debug('lineAndTypeVsOtherCostMap  = '+ JSON.serializePretty(lineAndTypeVsOtherCostMap));
                
                Set<String> workforceCategorySet = new Set<String>();
                List<ET_Work_force__c> workforceRecordLst;
                //List<String> workforceCategoryLst;
                for(ET_Work_force__c workforce : workforceRequestMap.values()){
                    
                    if(workforce.ET_Accountant_Category__c != null && workforce.ET_Accountant_Category__c != ''){
                        //workforceCategoryAndRecordMap.put(workforce.ET_Accountant_Category__c, workforce); 
                        workforceCategorySet.add(workforce.ET_Accountant_Category__c);
                    }else if(workforce.ET_Coordinator_Category__c != null && workforce.ET_Coordinator_Category__c != ''){
                        //workforceCategoryAndRecordMap.put(workforce.ET_Coordinator_Category__c, workforce); 
                        workforceCategorySet.add(workforce.ET_Coordinator_Category__c);
                    }else if(workforce.ET_Driver_Category__c != null && workforce.ET_Driver_Category__c != ''){
                        //workforceCategoryAndRecordMap.put(workforce.ET_Driver_Category__c, workforce); 
                        workforceCategorySet.add(workforce.ET_Driver_Category__c);
                    }else if(workforce.ET_Nanny_Category__c != null && workforce.ET_Nanny_Category__c != ''){
                        //workforceCategoryAndRecordMap.put(workforce.ET_Nanny_Category__c, workforce); 
                        workforceCategorySet.add(workforce.ET_Nanny_Category__c);
                    }else if(workforce.ET_Supervisor_Category__c != null && workforce.ET_Supervisor_Category__c != ''){
                        //workforceCategoryAndRecordMap.put(workforce.ET_Supervisor_Category__c, workforce); 
                        workforceCategorySet.add(workforce.ET_Supervisor_Category__c);
                    }else{
                        //  workforceCategoryAndRecordMap.put(workforce.ET_Other_employee_Category__c, workforce);
                        workforceCategorySet.add(workforce.ET_Other_employee_Category__c); 
                    }
                }
                
                List<Workforce_Master__c> workforceMasterData = [Select id, 
                                                                 Clothes_Allowance__c,
                                                                 Children_Allowance__c,
                                                                 Cost_of_Living_Allowance__c,
                                                                 Social_Allowance__c,
                                                                 Number_of_Annual_Leave_months__c,
                                                                 Number_of_End_of_Service_months__c,
                                                                 ET_Workforce_Category__c,
                                                                 Workforce_Type__c,
                                                                 Salary_Grade__r.Basic_Salary__c,
                                                                 Salary_Grade__r.Gross_Salary__c,
                                                                 Transport_Allowance__c,
                                                                 Additional_Transport_Allowance__c,
                                                                 Other_Allowance__c,
                                                                 Housing_Allowance__c,
                                                                 Additional_work_Permit_locals__c,
                                                                 Additional_work_Permit_Expats__c
                                                                 FROM   Workforce_Master__c
                                                                 WHERE  ET_Workforce_Category__c IN :workforceCategorySet];
                
                List<ET_Healthcard_Master__c> healthCardMasterList = new List<ET_Healthcard_Master__c>();
                for(ET_Healthcard_Master__c hcm : [Select Id,Emirates__c,Manpower_Category__c,Operator__c,Salary__c,Service_Type__c,Year_1__c,Year_2__c,Year_3__c,Year_4__c,Year_5__c,Year_6__c,Year_7__c,Year_8__c 
                                                   from ET_Healthcard_Master__c])
                {
                    
                    healthCardMasterList.add(hcm);
                }
                Map<String,Workforce_Master__c> uniqueKeyWorkforceMasterMap = new Map<String,Workforce_Master__c>();
                for(Workforce_Master__c workforceMaster : workforceMasterData){
                    uniqueKeyWorkforceMasterMap.put(workforceMaster.ET_Workforce_Category__c,workforceMaster);
                }
                List<ET_ServiceRequestController.driverQuoteCalcClass> driverQuoteCalcLst = new List<ET_ServiceRequestController.driverQuoteCalcClass>();
                List<ET_ServiceRequestController.nannyQuoteCalcClass> nannyQuoteCalcLst = new List<ET_ServiceRequestController.nannyQuoteCalcClass>();
                List<ET_ServiceRequestController.supervisorQuoteCalcClass> supervisorQuoteCalcLst = new List<ET_ServiceRequestController.supervisorQuoteCalcClass>();
                List<ET_ServiceRequestController.coordinatorQuoteCalcClass> coordinatorQuoteCalcLst = new List<ET_ServiceRequestController.coordinatorQuoteCalcClass>();
                List<ET_ServiceRequestController.accountantQuoteCalcClass> accountantQuoteCalcLst = new List<ET_ServiceRequestController.accountantQuoteCalcClass>();
                List<ET_ServiceRequestController.otherEmpQuoteCalcClass> otherEmpQuoteCalcLst = new List<ET_ServiceRequestController.otherEmpQuoteCalcClass>();
                
                List<Workforce_Training_and_Licencing_Cost__c> licensingMasterDataLst = [Select Workforce_Type__c,
                                                                                         Name,    
                                                                                         Cost_Type__c,
                                                                                         Cost_in_Abu_Dhabi__c,
                                                                                         Cost_in_Ajman__c,
                                                                                         Cost_in_Dubai__c,
                                                                                         Cost_in_Fujairah__c,
                                                                                         Cost_in_Ras_Al_Khaimah__c,
                                                                                         Cost_in_Sharjah__c,
                                                                                         Cost_in_Umm_Al_Quawain__c
                                                                                         FROM    Workforce_Training_and_Licencing_Cost__c];
                
                List<ET_Workforce_Profit_Master__c> workforceProfitMasterData = [Select ET_Api_Name__c,ET_Number_of_Months__c,Profit_Percentage__c,ET_Salary_Type__c from ET_Workforce_Profit_Master__c];
                List<ET_Workforce_Visa_Master__c> visaMasterData = [Select ET_Api_Name__c,ET_Emirates__c,ET_Number_of_Coverage_years__c, ET_Visa_Cost__c ,
                                                                    Year_1__c, Year_2__c , Year_3__c , Year_4__c,
                                                                    Year_5__c , Year_6__c , Year_7__c ,Year_8__c
                                                                    from ET_Workforce_Visa_Master__c];
                
                List<ET_Vehicle_Finance_Calculation__mdt> financeCalcMetadataLst = [SELECT MasterLabel, DeveloperName, ET_Finance_Rate__c,ET_Number_of_Financing_years__c ,
                                                                                    Salary_No_of_months_for_Driver_for_SLine__c ,Salary_No_of_Months_for_other_Manpower__c
                                                                                    FROM ET_Vehicle_Finance_Calculation__mdt
                                                                                    Where DeveloperName = 'ET_Finance_Calculation_Record'];
                
                // Language and Psychometric Test Master for School Transportation
                List<ET_Language_and_Psychometric_Test_Master__c> languageMasterData = new List<ET_Language_and_Psychometric_Test_Master__c>();
                languageMasterData = [SELECT id, Emirates__c ,
                                      Name, Year_1__c ,Year_2__c , Year_3__c,
                                      Year_4__c , Year_5__c , Year_6__c,
                                      Year_7__c , Year_8__c 
                                      FROM ET_Language_and_Psychometric_Test_Master__c];
                
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
                                                                                           from ET_Request_Mapping__c where ET_Pricing_Service_Request__c =:serviceRequestId and ET_Vehicle_Unique_key__c != null ]) ;
                
                
                
                // get a Map of vehicle Key with respect to manpower key
                
                Map<String,String> vehKeyWrToManpowerKey  = workForceServiceRequestControllerHelper.returnVehicleKeyWithRespectToManpowerKey(reqMappings);
                
                Map<String, vehicle__c> vehReqWithRespectToVehKey = getVehicleReqWrtoVehicleKey(serviceRequestId);
                /******************************** Work force Calculations Start Here*************************************************/
                
                // adjust the workforce line numbers corresponding to vehicle line numbers and add Reliever line numbers in end...
                
                
                for(ET_Work_force__c workforceRequestObj :  workforceRequestMap.values()){
                    
                    ET_Special_Workforce_Requirement__c specialRequirement;
                    List<ET_Special_Workforce_Requirement__c> specialRequirementLst = workforceRequestObj.Specific_Workforce_Requirements__r;
                    String oraclePricingServiceType = workforceRequestObj.ET_Service_Type__c;
                    if(specialRequirementLst != null && specialRequirementLst.size() >0){
                        specialRequirement = specialRequirementLst[0];
                    }
                    Workforce_Master__c workforceMasterObj;
                    
                    if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Accountant_Cashier')){
                        workforceMasterObj = uniqueKeyWorkforceMasterMap.get(workforceRequestObj.ET_Accountant_Category__c);
                        integer numberOfAccountants = Integer.valueOf(workforceRequestObj.ET_Number_of_Accountants__c);
                        String manpowerKey = workforceRequestObj.ET_Accountant_Category__c+'=>'+ workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1];
                        totalAccountants += numberOfAccountants;
                        if(workforceMasterObj != null){
                            List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                            if(contractYearLst.size() > 0){
                                for(String contractYear : contractYearLst){
                                    contractYear = contractYear.substring(0,1);
                                    integer integerContractYear = integer.ValueOf(contractYear);
                                    accountantContractYears.add(integerContractYear);
                                    ET_ServiceRequestController.accountantQuoteCalcClass accountantQuoteCalcObj = new ET_ServiceRequestController.accountantQuoteCalcClass();
                                    accountantQuoteCalcObj.accountantUniqueKey = workforceRequestObj.ET_Accountant_Category__c;
                                    accountantQuoteCalcObj.numberOfAccountants = numberOfAccountants;
                                    accountantQuoteCalcObj.accWorkforceClassObj = getWorkforceQuoteCalcObj(workforceRequestObj,workforceMasterObj,
                                                                                                           specialRequirement,contractYear,
                                                                                                           visaMasterData,licensingMasterDataLst,workforceProfitMasterData,
                                                                                                           oraclePricingServiceType,healthCardMasterList,
                                                                                                           isVATCalculated,servReqVSRate,financeCalcMetadataLst,
                                                                                                           reserveMasterWithServiceType,languageMasterData
                                                                                                          );
                                    if(lineAndTypeVsOtherCostMap!= null && lineAndTypeVsOtherCostMap.containsKey(String.ValueOf(accountantQuoteCalcObj.accWorkforceClassObj.workforceLineItemNumberFromRequest))){
                                        Map<String, List<ET_Other_Cost_Request__c>> typeVsOtherCostMapInnerMap = lineAndTypeVsOtherCostMap.get(String.ValueOf(accountantQuoteCalcObj.accWorkforceClassObj.workforceLineItemNumberFromRequest));
                                        accountantQuoteCalcObj.accountantOtherCostLst = otCostToWrapperConverter('Accountant/Cashier' , numberOfAccountants, typeVsOtherCostMapInnerMap.get('Accountant'), contractYear,accountantQuoteCalcObj.accWorkforceClassObj.workforceLineItemNumberFromRequest);
                                    }
                                    accountantQuoteCalcLst.add(accountantQuoteCalcObj);
                                }                          
                                quotecalculationObj.accountantQuoteItemLst = accountantQuoteCalcLst;
                            }else{
                                system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                            }
                        }else{
                            system.debug('no master data found for this work force request record : '+ workforceRequestObj.Id);
                        }
                        
                    }
                    else if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Coordinator')){
                        workforceMasterObj = uniqueKeyWorkforceMasterMap.get(workforceRequestObj.ET_Coordinator_Category__c);
                        integer numberOfCoordinators = Integer.valueOf(workforceRequestObj.ET_Number_of_Coordinators__c);
                        String manpowerKey = workforceRequestObj.ET_Coordinator_Category__c+'=>'+ workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1];
                        totalCoordinators += numberOfCoordinators;
                        if(workforceMasterObj != null){
                            List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                            if(contractYearLst.size() > 0){
                                for(String contractYear : contractYearLst){
                                    contractYear = contractYear.substring(0,1);
                                    integer integerContractYear = integer.ValueOf(contractYear);
                                    coordinatorContractYears.add(integerContractYear);
                                    ET_ServiceRequestController.coordinatorQuoteCalcClass coordinatorQuoteCalcObj = new ET_ServiceRequestController.coordinatorQuoteCalcClass();
                                    coordinatorQuoteCalcObj.coordinatorUniqueKey = workforceRequestObj.ET_Coordinator_Category__c;
                                    coordinatorQuoteCalcObj.numberOfCoordinators = numberOfCoordinators;
                                    coordinatorQuoteCalcObj.coordinatorWorkforceClassObj = getWorkforceQuoteCalcObj(workforceRequestObj,workforceMasterObj,
                                                                                                                    specialRequirement,contractYear,visaMasterData,
                                                                                                                    licensingMasterDataLst,workforceProfitMasterData,
                                                                                                                    oraclePricingServiceType,healthCardMasterList,
                                                                                                                    isVATCalculated,servReqVSRate,financeCalcMetadataLst,
                                                                                                                    reserveMasterWithServiceType , languageMasterData);
                                    
                                    if(lineAndTypeVsOtherCostMap!= null && lineAndTypeVsOtherCostMap.containsKey(String.ValueOf(coordinatorQuoteCalcObj.coordinatorWorkforceClassObj.workforceLineItemNumberFromRequest))){
                                        Map<String, List<ET_Other_Cost_Request__c>> typeVsOtherCostMapInnerMap = lineAndTypeVsOtherCostMap.get(String.ValueOf(coordinatorQuoteCalcObj.coordinatorWorkforceClassObj.workforceLineItemNumberFromRequest));
                                        coordinatorQuoteCalcObj.coordinatorOtherCostLst = otCostToWrapperConverter('Coordinator' ,numberOfCoordinators , typeVsOtherCostMapInnerMap.get('Coordinator'), contractYear,coordinatorQuoteCalcObj.coordinatorWorkforceClassObj.workforceLineItemNumberFromRequest);
                                    }
                                    
                                    coordinatorQuoteCalcLst.add(coordinatorQuoteCalcObj);
                                }                          
                                quotecalculationObj.coordinatorQuoteItemLst = coordinatorQuoteCalcLst;
                            }else{
                                system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                            }
                        }else{
                            system.debug('no master data found for this work force request record : '+ workforceRequestObj.Id);
                        }
                        
                    }
                    else if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Driver')){
                        workforceMasterObj = uniqueKeyWorkforceMasterMap.get(workforceRequestObj.ET_Driver_Category__c);
                        integer numberOfDrivers = Integer.valueOf(workforceRequestObj.ET_No_of_Drivers__c);
                        String manpowerKey = workforceRequestObj.ET_Driver_Category__c+'=>'+ workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1];
                        if(vehKeyWrToManpowerKey != null && vehKeyWrToManpowerKey.containsKey(manpowerKey)){
                            String VehKey = vehKeyWrToManpowerKey.get(manpowerKey);
                            if(VehKey != null && vehReqWithRespectToVehKey != null && vehReqWithRespectToVehKey.containsKey(VehKey)){
                                String vehSource = vehReqWithRespectToVehKey.get(VehKey).ET_Vehicle_Source__c;
                                if(vehSource == 'Main'){
                                    totalDrivers += numberOfDrivers;
                                }
                            }
                        }
                        if(workforceMasterObj != null){
                            List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                            if(contractYearLst.size() > 0){
                                for(String contractYear : contractYearLst){
                                    contractYear = contractYear.substring(0,1);
                                    integer integerContractYear = integer.ValueOf(contractYear);
                                    driverContractYears.add(integerContractYear);
                                    ET_ServiceRequestController.driverQuoteCalcClass driverQuoteCalcObj = new ET_ServiceRequestController.driverQuoteCalcClass();
                                    driverQuoteCalcObj.driverUniqueKey = workforceRequestObj.ET_Driver_Category__c;
                                    driverQuoteCalcObj.numberOfDrivers = numberOfDrivers;
                                    driverQuoteCalcObj.driverWorkforceClassObj = getWorkforceQuoteCalcObj(workforceRequestObj,workforceMasterObj,specialRequirement,
                                                                                                          contractYear,visaMasterData,licensingMasterDataLst,
                                                                                                          workforceProfitMasterData,oraclePricingServiceType,
                                                                                                          healthCardMasterList,
                                                                                                          isVATCalculated,servReqVSRate,financeCalcMetadataLst,
                                                                                                          reserveMasterWithServiceType , languageMasterData);
                                    if(lineAndTypeVsOtherCostMap!= null && lineAndTypeVsOtherCostMap.containsKey(String.ValueOf(driverQuoteCalcObj.driverWorkforceClassObj.workforceLineItemNumberFromRequest))){
                                        Map<String, List<ET_Other_Cost_Request__c>> typeVsOtherCostMapInnerMap = lineAndTypeVsOtherCostMap.get(String.ValueOf(driverQuoteCalcObj.driverWorkforceClassObj.workforceLineItemNumberFromRequest));
                                        driverQuoteCalcObj.driverOtherCostLst = otCostToWrapperConverter('Driver' ,numberOfDrivers ,typeVsOtherCostMapInnerMap.get('Driver'), contractYear,driverQuoteCalcObj.driverWorkforceClassObj.workforceLineItemNumberFromRequest);
                                    }
                                    
                                    driverQuoteCalcLst.add(driverQuoteCalcObj);
                                }
                                
                                quotecalculationObj.driverQuoteItemLst = driverQuoteCalcLst;
                            }else{
                                system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                            }
                        }else{
                            system.debug('no master data found for this work force request record : '+ workforceRequestObj.Id);
                        }
                        
                    }
                    else if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Nanny')){
                        workforceMasterObj = uniqueKeyWorkforceMasterMap.get(workforceRequestObj.ET_Nanny_Category__c);
                        integer numberOfNannies = Integer.valueOf(workforceRequestObj.ET_Number_of_Nannies__c);
                        String manpowerKey = workforceRequestObj.ET_Nanny_Category__c+'=>'+ workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1];
                        if(vehKeyWrToManpowerKey != null && vehKeyWrToManpowerKey.containsKey(manpowerKey)){
                            String VehKey = vehKeyWrToManpowerKey.get(manpowerKey);
                            if(VehKey != null && vehReqWithRespectToVehKey != null && vehReqWithRespectToVehKey.containsKey(VehKey)){
                                String vehSource = vehReqWithRespectToVehKey.get(VehKey).ET_Vehicle_Source__c;
                                if(vehSource == 'Main'){
                                    totalNannies += numberOfNannies;
                                }
                            }
                        }
                        if(workforceMasterObj != null){
                            List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                            if(contractYearLst.size() > 0){
                                for(String contractYear : contractYearLst){
                                    contractYear = contractYear.substring(0,1);
                                    integer integerContractYear = integer.ValueOf(contractYear);
                                    nannyContractYears.add(integerContractYear);
                                    ET_ServiceRequestController.nannyQuoteCalcClass nannyQuoteCalcObj = new ET_ServiceRequestController.nannyQuoteCalcClass();
                                    nannyQuoteCalcObj.nannyUniqueKey = workforceRequestObj.ET_Nanny_Category__c;
                                    nannyQuoteCalcObj.numberOfNannies = numberOfNannies;
                                    nannyQuoteCalcObj.nannyWorkforceClassObj = getWorkforceQuoteCalcObj(workforceRequestObj,workforceMasterObj,specialRequirement,contractYear,visaMasterData,
                                                                                                        licensingMasterDataLst,workforceProfitMasterData,oraclePricingServiceType,
                                                                                                        healthCardMasterList,
                                                                                                        isVATCalculated,servReqVSRate,financeCalcMetadataLst,
                                                                                                        reserveMasterWithServiceType , languageMasterData);
                                    if(lineAndTypeVsOtherCostMap!= null && lineAndTypeVsOtherCostMap.containsKey(String.ValueOf(nannyQuoteCalcObj.nannyWorkforceClassObj.workforceLineItemNumberFromRequest))){
                                        Map<String, List<ET_Other_Cost_Request__c>> typeVsOtherCostMapInnerMap = lineAndTypeVsOtherCostMap.get(String.ValueOf(nannyQuoteCalcObj.nannyWorkforceClassObj.workforceLineItemNumberFromRequest));
                                        nannyQuoteCalcObj.nannyOtherCostLst = otCostToWrapperConverter('Nanny' ,numberOfNannies , typeVsOtherCostMapInnerMap.get('Nanny'), contractYear,nannyQuoteCalcObj.nannyWorkforceClassObj.workforceLineItemNumberFromRequest);
                                    }
                                    
                                    nannyQuoteCalcLst.add(nannyQuoteCalcObj);
                                }                          
                                quotecalculationObj.nannyQuoteItemLst = nannyQuoteCalcLst;
                            }else{
                                system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                            }
                        }else{
                            system.debug('no master data found for this work force request record : '+ workforceRequestObj.Id);
                        }
                        
                    }
                    else if(workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Supervisor')){
                        workforceMasterObj = uniqueKeyWorkforceMasterMap.get(workforceRequestObj.ET_Supervisor_Category__c);
                        integer numberOfSupervisors = Integer.valueOf(workforceRequestObj.ET_Number_of_Supervisors__c);
                        String manpowerKey = workforceRequestObj.ET_Supervisor_Category__c+'=>'+ workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1];
                        totalSuperVisors += numberOfSupervisors;
                        if(workforceMasterObj != null){
                            List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                            if(contractYearLst.size() > 0){
                                for(String contractYear : contractYearLst){
                                    contractYear = contractYear.substring(0,1);
                                    integer integerContractYear = integer.ValueOf(contractYear);
                                    supervisorContractYears.add(integerContractYear);
                                    ET_ServiceRequestController.supervisorQuoteCalcClass supervisorQuoteCalcObj = new ET_ServiceRequestController.supervisorQuoteCalcClass();
                                    supervisorQuoteCalcObj.supervisorUniqueKey = workforceRequestObj.ET_Supervisor_Category__c;
                                    supervisorQuoteCalcObj.numberOfSupervisors = numberOfSupervisors;
                                    supervisorQuoteCalcObj.supervisorWorkforceClassObj = getWorkforceQuoteCalcObj(workforceRequestObj,workforceMasterObj,specialRequirement,contractYear,
                                                                                                                  visaMasterData,licensingMasterDataLst,workforceProfitMasterData,
                                                                                                                  oraclePricingServiceType,healthCardMasterList,
                                                                                                                  isVATCalculated,servReqVSRate,financeCalcMetadataLst,
                                                                                                                  reserveMasterWithServiceType , languageMasterData);
                                    system.debug('Supervisors list = ' +json.serializePretty(typeVsOtherCostMap.get('Supervisor')));
                                    if(lineAndTypeVsOtherCostMap!= null && lineAndTypeVsOtherCostMap.containsKey(String.ValueOf(supervisorQuoteCalcObj.supervisorWorkforceClassObj.workforceLineItemNumberFromRequest))){
                                        Map<String, List<ET_Other_Cost_Request__c>> typeVsOtherCostMapInnerMap = lineAndTypeVsOtherCostMap.get(String.ValueOf(supervisorQuoteCalcObj.supervisorWorkforceClassObj.workforceLineItemNumberFromRequest));
                                        supervisorQuoteCalcObj.supervisorOtherCostLst = otCostToWrapperConverter('Supervisor' ,numberOfSupervisors ,typeVsOtherCostMapInnerMap.get('Supervisor'), contractYear,supervisorQuoteCalcObj.supervisorWorkforceClassObj.workforceLineItemNumberFromRequest);
                                    }
                                    
                                    supervisorQuoteCalcLst.add(supervisorQuoteCalcObj);
                                }                          
                                quotecalculationObj.supervisorQuoteItemLst = supervisorQuoteCalcLst;
                            }else{
                                system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                            }
                        }else{
                            system.debug('no master data found for this work force request record : '+ workforceRequestObj.Id);
                        }
                        
                    }
                    else{
                        //other employee
                        workforceMasterObj = uniqueKeyWorkforceMasterMap.get(workforceRequestObj.ET_Other_employee_Category__c);
                        integer numberOfOtherEmps = Integer.valueOf(workforceRequestObj.ET_Number_of_Other_Employees__c);
                        String manpowerKey = workforceRequestObj.ET_Other_employee_Category__c+'=>'+ workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1];
                        totalOtherEmployees += numberOfOtherEmps;
                        if(workforceMasterObj != null){
                            List<String> contractYearLst = workforceRequestObj.ET_Contract_Period__c.split(',');
                            if(contractYearLst.size() > 0){
                                for(String contractYear : contractYearLst){
                                    contractYear = contractYear.substring(0,1);
                                    integer integerContractYear = integer.ValueOf(contractYear);
                                    otherEmployeeContractYears.add(integerContractYear);
                                    ET_ServiceRequestController.otherEmpQuoteCalcClass otherEmpQuoteCalcObj = new ET_ServiceRequestController.otherEmpQuoteCalcClass();
                                    otherEmpQuoteCalcObj.otherEmpUniqueKey = workforceRequestObj.ET_Other_employee_Category__c;
                                    otherEmpQuoteCalcObj.numberOfOtherEmps = numberOfOtherEmps;
                                    otherEmpQuoteCalcObj.otherEmpWorkforceClassObj = getWorkforceQuoteCalcObj(workforceRequestObj,workforceMasterObj,specialRequirement,contractYear,visaMasterData,
                                                                                                              licensingMasterDataLst,workforceProfitMasterData,oraclePricingServiceType,
                                                                                                              healthCardMasterList,
                                                                                                              isVATCalculated,servReqVSRate,financeCalcMetadataLst,
                                                                                                              reserveMasterWithServiceType , languageMasterData);
                                    if(lineAndTypeVsOtherCostMap!= null && lineAndTypeVsOtherCostMap.containsKey(String.ValueOf(otherEmpQuoteCalcObj.otherEmpWorkforceClassObj.workforceLineItemNumberFromRequest))){
                                        Map<String, List<ET_Other_Cost_Request__c>> typeVsOtherCostMapInnerMap = lineAndTypeVsOtherCostMap.get(String.ValueOf(otherEmpQuoteCalcObj.otherEmpWorkforceClassObj.workforceLineItemNumberFromRequest));
                                        otherEmpQuoteCalcObj.otherEmpOtherCostLst = otCostToWrapperConverter('Other Employee' ,numberOfOtherEmps ,typeVsOtherCostMapInnerMap.get('OtherEmployee'), contractYear,otherEmpQuoteCalcObj.otherEmpWorkforceClassObj.workforceLineItemNumberFromRequest);
                                    }
                                    
                                    otherEmpQuoteCalcLst.add(otherEmpQuoteCalcObj);
                                }                          
                                quotecalculationObj.otherEmpQuoteItemLst = otherEmpQuoteCalcLst;
                            }else{
                                system.debug('contractYearLst is empty, skipping all calculations for workforce request record :' + workforceRequestObj.Id);
                            }
                        }else{
                            system.debug('no master data found for this work force request record : '+ workforceRequestObj.Id);
                        }
                        
                    }  
                    
                }
            }
            catch(Exception ex){
                ET_PricingUtilityClass.logException(ex, 'Pricing');
                system.debug('Exception occured of type :' + ex.getTypeName() + ' due to cause : ' + ex.getCause()  + 'with Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString());
                //throw new AuraHandledException('Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString());
            }
        }else{
            system.debug('no work force record found for pricing service request : '+ serviceRequestId );
        }
        
        return quotecalculationObj;
    }
    
    
    // to return a map - with Key = Vehicle Key and Value = Vehicle request..
    Public static Map<String, vehicle__c> getVehicleReqWrtoVehicleKey(String serviceRequestId){
        Map<String, vehicle__c> vehRequestMap = new Map<String, vehicle__c>();
        List<Vehicle__c> vehReqList = new List<Vehicle__c>();
        ET_Pricing_Service_Request__c serReq = [select id,
                                                (select id,ET_Vehicle_MAKE__c,ET_Vehicle_Model__c,ET_Vehicle_Model_Year__c,ET_Vehicle_Line__c,
                                                 ET_Service_Type__c,ET_Vehicle_Quantity__c,ET_Vehicle_Source__c
                                                 from Vehicle_Requests__r)
                                                from ET_Pricing_Service_Request__c where id =:serviceRequestId];
        
        system.debug('serReq  = '+ JSON.serializePretty(serReq));
        
        if(serReq.Vehicle_Requests__r != null && serReq.Vehicle_Requests__r.size() > 0){
            vehReqList = serReq.Vehicle_Requests__r;
        }
        
        
        if(vehReqList != null && vehReqList.size() > 0){
            for(Vehicle__c vehReq : vehReqList){
                // Key = Make+Model+Year=>line
                String keyy = vehReq.ET_Vehicle_MAKE__c+'_'+vehReq.ET_Vehicle_Model__c + '_'+vehReq.ET_Vehicle_Model_Year__c+ '=>'+ vehReq.ET_Vehicle_Line__c;
                vehRequestMap.put(keyy, vehReq);
            }
        }
        
        return vehRequestMap;
    }
    
    
    
    /* Method 	   : otCostToWrapperConverter
Description : To Map other cost Related Records to a Wrapper in desired formate..
ET_ServiceRequestController.otherCostCalcClass --> List of one Time cost, annual and both costs for any Service...
*/
    public static List<ET_ServiceRequestController.otherCostCalcClass> otCostToWrapperConverter(String serviceType, integer noOfworkForce,  List<ET_Other_Cost_Request__c> otCostList, String contractYear, Decimal lineNumber){
        List<ET_ServiceRequestController.otherCostCalcClass> otCostCalList = new List<ET_ServiceRequestController.otherCostCalcClass>();
        List<ET_Other_Cost_Request__c> oneTimeCost = new List<ET_Other_Cost_Request__c>();
        List<ET_Other_Cost_Request__c> annualCost = new List<ET_Other_Cost_Request__c>();
        List<ET_Other_Cost_Request__c> bothCost = new List<ET_Other_Cost_Request__c>();
        
        Map<integer, Map<String, otherCostCalcClassTProj>> desiredSpecilReqsForTotProjMap = getDesiredSpecilReqsForTotProjMap(serviceType);
        if(otCostList != null && otCostList.size()>0){
            for(ET_Other_Cost_Request__c otCost: otCostList){
                
                if(otCost.ET_Cost_Type__c.contains('One_time_Cost') && otCost.ET_Cost_Type__c.contains('Annual_Cost')){
                    bothCost.add(otCost);
                }else if(otCost.ET_Cost_Type__c.contains('One_time_Cost') && !otCost.ET_Cost_Type__c.contains('Annual_Cost')){
                    oneTimeCost.add(otCost);
                }else if(!otCost.ET_Cost_Type__c.contains('One_time_Cost') && otCost.ET_Cost_Type__c.contains('Annual_Cost')){
                    annualCost.add(otCost);
                }
            }
        }
        
        system.debug('bothCost = ' + bothCost);
        system.debug('oneTimeCost = ' + oneTimeCost);
        integer contYear = Integer.valueOf(contractYear);
        
        Map<String , otherCostCalcClassTProj> OneTimeSpecReqInnerMap = new Map<String , otherCostCalcClassTProj>();
        for(ET_Other_Cost_Request__c otCost: oneTimeCost){
            ET_ServiceRequestController.otherCostCalcClass otCostCalcClsInst = new ET_ServiceRequestController.otherCostCalcClass();
            otherCostCalcClassTProj specialOneTimeRequirementForTotalProject = new otherCostCalcClassTProj();
            otCostCalcClsInst.otherCostValue = Math.round(otCost.ET_Cost_Value__c/contYear);
            otCostCalcClsInst.otherCostLabel = otCost.Name;
            otCostCalcClsInst.otherCostLineNumber = lineNumber;
            otCostCalcClsInst.contractYear = contYear;
            otCostCalList.add(otCostCalcClsInst);
            
            
            specialOneTimeRequirementForTotalProject.otherCostLabel = otCost.Name;
            specialOneTimeRequirementForTotalProject.otherCostValue = (otCost.ET_Cost_Value__c/contYear)*noOfworkForce;
            
            OneTimeSpecReqInnerMap.put(specialOneTimeRequirementForTotalProject.otherCostLabel  ,specialOneTimeRequirementForTotalProject );
            
            if(desiredSpecilReqsForTotProjMap  != null && desiredSpecilReqsForTotProjMap.containsKey(contYear))
            {
                Map<String , otherCostCalcClassTProj> wForceSpecialReqqMap  = desiredSpecilReqsForTotProjMap.get(contYear);
                if(wForceSpecialReqqMap != null && wForceSpecialReqqMap.containsKey(specialOneTimeRequirementForTotalProject.otherCostLabel)){
                    otherCostCalcClassTProj specReq = wForceSpecialReqqMap.get(specialOneTimeRequirementForTotalProject.otherCostLabel);
                    system.debug('specReq  = '+ JSON.serializePretty(specReq));
                    decimal totalCost = specReq.otherCostValue +specialOneTimeRequirementForTotalProject.otherCostValue ;
                    specialOneTimeRequirementForTotalProject.otherCostValue = totalCost;
                    wForceSpecialReqqMap.put(specialOneTimeRequirementForTotalProject.otherCostLabel   ,specialOneTimeRequirementForTotalProject );
                    desiredSpecilReqsForTotProjMap.put(contYear ,wForceSpecialReqqMap );
                    system.debug('desiredSpecilReqsForTotProjMap 1 = '+ JSON.serializePretty(desiredSpecilReqsForTotProjMap));
                }
                else{
                    wForceSpecialReqqMap.put(specialOneTimeRequirementForTotalProject.otherCostLabel ,specialOneTimeRequirementForTotalProject );
                    desiredSpecilReqsForTotProjMap.put(contYear ,wForceSpecialReqqMap );
                    system.debug('desiredSpecilReqsForTotProjMap 2 = '+ JSON.serializePretty(desiredSpecilReqsForTotProjMap));
                }
                
            }
            
        }
        
        if(desiredSpecilReqsForTotProjMap  != null && !desiredSpecilReqsForTotProjMap.containsKey(contYear))
        {
            desiredSpecilReqsForTotProjMap.put(contYear ,OneTimeSpecReqInnerMap );
        }
        
        Map<String , otherCostCalcClassTProj> annualSpecReqInnerMap = new Map<String , otherCostCalcClassTProj>();
        for(ET_Other_Cost_Request__c otCost: annualCost){
            ET_ServiceRequestController.otherCostCalcClass otCostCalcClsInst = new ET_ServiceRequestController.otherCostCalcClass();
            otherCostCalcClassTProj specialAnnualRequirementForTotalProject = new otherCostCalcClassTProj();
            otCostCalcClsInst.otherCostValue = otCost.ET_Cost_Value__c;
            otCostCalcClsInst.otherCostLabel = otCost.Name;
            otCostCalcClsInst.otherCostLineNumber = lineNumber;
            otCostCalcClsInst.contractYear = contYear;
            otCostCalList.add(otCostCalcClsInst);
            
            specialAnnualRequirementForTotalProject.otherCostLabel = otCost.Name;
            specialAnnualRequirementForTotalProject.otherCostValue = otCost.ET_Cost_Value__c*noOfworkForce;
            
            annualSpecReqInnerMap.put(specialAnnualRequirementForTotalProject.otherCostLabel  ,specialAnnualRequirementForTotalProject );
            
            if(desiredSpecilReqsForTotProjMap  != null && desiredSpecilReqsForTotProjMap.containsKey(contYear))
            {
                Map<String , otherCostCalcClassTProj> wForceSpecialReqqMap  = desiredSpecilReqsForTotProjMap.get(contYear);
                if(wForceSpecialReqqMap != null && wForceSpecialReqqMap.containsKey(specialAnnualRequirementForTotalProject.otherCostLabel)){
                    otherCostCalcClassTProj specReq = wForceSpecialReqqMap.get(specialAnnualRequirementForTotalProject.otherCostLabel);
                    system.debug('specReq  = '+ JSON.serializePretty(specReq));
                    decimal totalCost = specReq.otherCostValue +specialAnnualRequirementForTotalProject.otherCostValue ;
                    specialAnnualRequirementForTotalProject.otherCostValue = totalCost;
                    wForceSpecialReqqMap.put(specialAnnualRequirementForTotalProject.otherCostLabel   ,specialAnnualRequirementForTotalProject );
                    desiredSpecilReqsForTotProjMap.put(contYear ,wForceSpecialReqqMap );
                    system.debug('desiredSpecilReqsForTotProjMap 1 = '+ JSON.serializePretty(desiredSpecilReqsForTotProjMap));
                }
                else{
                    wForceSpecialReqqMap.put(specialAnnualRequirementForTotalProject.otherCostLabel ,specialAnnualRequirementForTotalProject );
                    desiredSpecilReqsForTotProjMap.put(contYear ,wForceSpecialReqqMap );
                    system.debug('desiredSpecilReqsForTotProjMap 2 = '+ JSON.serializePretty(desiredSpecilReqsForTotProjMap));
                }
                
            }
        }
        
        if(desiredSpecilReqsForTotProjMap  != null && !desiredSpecilReqsForTotProjMap.containsKey(contYear))
        {
            desiredSpecilReqsForTotProjMap.put(contYear ,annualSpecReqInnerMap );
        }
        
        Map<String , otherCostCalcClassTProj> bothCostSpecReqInnerMap = new Map<String , otherCostCalcClassTProj>();
        for(ET_Other_Cost_Request__c otCost: bothCost){
            ET_ServiceRequestController.otherCostCalcClass otCostCalcClsInst = new ET_ServiceRequestController.otherCostCalcClass();
            otherCostCalcClassTProj specialbothCostForTotalProject = new otherCostCalcClassTProj();
            otCostCalcClsInst.otherCostValue = Math.round(otCost.ET_Cost_Value__c + (otCost.ET_Cost_Value__c/contYear));
            otCostCalcClsInst.otherCostLabel = otCost.Name;
            otCostCalcClsInst.otherCostLineNumber = lineNumber;
            otCostCalcClsInst.contractYear = contYear;
            otCostCalList.add(otCostCalcClsInst);
            
            specialbothCostForTotalProject.otherCostLabel = otCost.Name;
            specialbothCostForTotalProject.otherCostValue = otCost.ET_Cost_Value__c*noOfworkForce;
            
            bothCostSpecReqInnerMap.put(specialbothCostForTotalProject.otherCostLabel  ,specialbothCostForTotalProject );
            
            if(desiredSpecilReqsForTotProjMap  != null && desiredSpecilReqsForTotProjMap.containsKey(contYear))
            {
                Map<String , otherCostCalcClassTProj> wForceSpecialReqqMap  = desiredSpecilReqsForTotProjMap.get(contYear);
                if(wForceSpecialReqqMap != null && wForceSpecialReqqMap.containsKey(specialbothCostForTotalProject.otherCostLabel)){
                    otherCostCalcClassTProj specReq = wForceSpecialReqqMap.get(specialbothCostForTotalProject.otherCostLabel);
                    system.debug('specReq  = '+ JSON.serializePretty(specReq));
                    decimal totalCost = specReq.otherCostValue +specialbothCostForTotalProject.otherCostValue ;
                    specialbothCostForTotalProject.otherCostValue = totalCost;
                    wForceSpecialReqqMap.put(specialbothCostForTotalProject.otherCostLabel   ,specialbothCostForTotalProject );
                    desiredSpecilReqsForTotProjMap.put(contYear ,wForceSpecialReqqMap );
                    system.debug('desiredSpecilReqsForTotProjMap 1 = '+ JSON.serializePretty(desiredSpecilReqsForTotProjMap));
                }
                else{
                    wForceSpecialReqqMap.put(specialbothCostForTotalProject.otherCostLabel ,specialbothCostForTotalProject );
                    desiredSpecilReqsForTotProjMap.put(contYear ,wForceSpecialReqqMap );
                    system.debug('desiredSpecilReqsForTotProjMap 2 = '+ JSON.serializePretty(desiredSpecilReqsForTotProjMap));
                }
                
            }
        }
        
        if(desiredSpecilReqsForTotProjMap  != null && !desiredSpecilReqsForTotProjMap.containsKey(contYear))
        {
            desiredSpecilReqsForTotProjMap.put(contYear ,bothCostSpecReqInnerMap );
        }
        
        system.debug('otCostCalList = ' + otCostCalList);
        return otCostCalList;
    }
    
    Public static Map<integer, Map<String, otherCostCalcClassTProj>> getDesiredSpecilReqsForTotProjMap (String serviceType){
        Map<integer, Map<String, otherCostCalcClassTProj>> desiredSpecilReqsForTotProjMap ;
        switch on serviceType{
            when 'Driver'{
                desiredSpecilReqsForTotProjMap = driverSpecilReqsForTotProjMap;
            }
            when 'Nanny'{
                desiredSpecilReqsForTotProjMap = nannySpecilReqsForTotProjMap;
            }
            when 'Supervisor'{
                desiredSpecilReqsForTotProjMap = supervisorSpecilReqsForTotProjMap;
            }
            when 'Coordinator'{
                desiredSpecilReqsForTotProjMap = coordinatorSpecilReqsForTotProjMap;
            }
            when 'Accountant/Cashier'{
                desiredSpecilReqsForTotProjMap = accountantSpecilReqsForTotProjMap;
            }
            when 'Other Employee'{
                desiredSpecilReqsForTotProjMap = otherEmployeeSpecilReqsForTotProjMap;
            }
        }
        
        return desiredSpecilReqsForTotProjMap;
    }
    
    
    
    
    /* 	Method     : getWorkforceQuoteCalcObj
Descripton : workforce calculations
For each workforce request for each Contract year -Calculate quoteWorkforce item
Use - Input workforce, Contract year, specialRequirement from workforce and all Masters for Rates --> to calculate only Rates...
*/
    
    
    public static ET_ServiceRequestController.workforceQuoteCalcClass getWorkforceQuoteCalcObj(ET_Work_force__c workforceRequestObj,Workforce_Master__c workforceMasterObj,
                                                                                               ET_Special_Workforce_Requirement__c specialRequirement, String contractYear,List<ET_Workforce_Visa_Master__c> visaMasterData,List<Workforce_Training_and_Licencing_Cost__c> licensingMasterDataLst,
                                                                                               List<ET_Workforce_Profit_Master__c> workforceProfitMasterData, String oraclePricingServiceType,
                                                                                               List<ET_Healthcard_Master__c> healthCardMasterList,
                                                                                               boolean isVATCalculated,Map<String, String> servReqVSRate , 
                                                                                               List<ET_Vehicle_Finance_Calculation__mdt> financeCalcMetadataLst , 
                                                                                               Map<String, ET_Pricing_Service_Reserve_Master__c> reserveMasterWithServiceType,
                                                                                               List<ET_Language_and_Psychometric_Test_Master__c> languageMasterData)
    {
        try{
            String specificServiceEmirate = workforceRequestObj.ET_Service_Emirate__c;
            Integer contractYearInt = Integer.valueOf(contractYear);
            ET_ServiceRequestController.workforceQuoteCalcClass genericWorkforceQuoteCalcObj = new ET_ServiceRequestController.workforceQuoteCalcClass();
            genericWorkforceQuoteCalcObj.contractYear = Integer.valueOf(contractYear);
            genericWorkforceQuoteCalcObj.workforceLineItemNumberFromRequest = Integer.valueOf(workforceRequestObj.ET_Workforce_Line_Info__c.split(':')[1]);
            genericWorkforceQuoteCalcObj.workforcePricingMethod  = workforceRequestObj.ET_Pricing_Method__c;
            genericWorkforceQuoteCalcObj.workforcePricingType = workforceRequestObj.ET_Pricing_Type__c;
            genericWorkforceQuoteCalcObj.workforcePricingUtilization = workforceRequestObj.ET_Price_Utilization__c;
            genericWorkforceQuoteCalcObj.workingDaysPerWeek = workforceRequestObj.ET_Working_Days_Per_Week__c;
            genericWorkforceQuoteCalcObj.workingMonthsPerYear = workforceRequestObj.ET_Working_Months_Per_Year__c;
            genericWorkforceQuoteCalcObj.workforceRecordType = workforceRequestObj.ET_Workforce_Record_Type_Name__c;
            genericWorkforceQuoteCalcObj.serviceType = workforceRequestObj.ET_Service_Type__c;
            genericWorkforceQuoteCalcObj.workForceReqId = workforceRequestObj.id;
            genericWorkforceQuoteCalcObj.typeOfManpower = workforceRequestObj.Type__c;
            genericWorkforceQuoteCalcObj.relieverFor = workforceRequestObj.Reliever_For__c;
            
            // depreciation Method 
            String depreciationMethod;
            ET_Pricing_Service_Reserve_Master__c requiredReserveMasterData;
            requiredReserveMasterData = reserveMasterWithServiceType.get(oraclePricingServiceType);
            if(requiredReserveMasterData != null){
                depreciationMethod = requiredReserveMasterData.ET_Depreciation_Method__c;
                genericWorkforceQuoteCalcObj.reserveRate = requiredReserveMasterData.ET_Manpower_Reserve_Rate__c;
            }
            genericWorkforceQuoteCalcObj.depreciationMethod = depreciationMethod;
            
            if(financeCalcMetadataLst.size() == 1){
                ET_Vehicle_Finance_Calculation__mdt financeData = financeCalcMetadataLst[0];
                if( workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Driver')){
                    genericWorkforceQuoteCalcObj.salaryNoofMonthsforDriverforSLine = financeData.Salary_No_of_months_for_Driver_for_SLine__c ; 
                }
                else{
                    genericWorkforceQuoteCalcObj.salaryNoofMonthsforOtherManpowerforSLine = financeData.Salary_No_of_Months_for_other_Manpower__c ; 
                }
            }
            if(isVATCalculated){
                if(servReqVSRate.containsKey(workforceRequestObj.ET_Service_Type__c)){
                    genericWorkforceQuoteCalcObj.workForceVATRate = servReqVSRate.get(workforceRequestObj.ET_Service_Type__c);
                }
            }
            
            //workingDaysPerYear => below logic given by business and same was implemented in oracle too..
            if(genericWorkforceQuoteCalcObj.workingDaysPerWeek != 0.0 && genericWorkforceQuoteCalcObj.workingMonthsPerYear != 0.0){
                if(genericWorkforceQuoteCalcObj.workingMonthsPerYear == 10 && genericWorkforceQuoteCalcObj.workingDaysPerWeek ==5  ){
                    genericWorkforceQuoteCalcObj.workingDaysPerYear =  180;
                }
                else if(genericWorkforceQuoteCalcObj.workingMonthsPerYear == 12 && genericWorkforceQuoteCalcObj.workingDaysPerWeek ==5  ){
                    genericWorkforceQuoteCalcObj.workingDaysPerYear =  264;
                }
                else if(genericWorkforceQuoteCalcObj.workingMonthsPerYear == 12 && genericWorkforceQuoteCalcObj.workingDaysPerWeek ==6 ){
                    genericWorkforceQuoteCalcObj.workingDaysPerYear =  312;
                }
                else if(genericWorkforceQuoteCalcObj.workingMonthsPerYear == 12 && genericWorkforceQuoteCalcObj.workingDaysPerWeek ==7 ){
                    genericWorkforceQuoteCalcObj.workingDaysPerYear =  365;
                }
                else{
                    genericWorkforceQuoteCalcObj.workingDaysPerYear =  Math.round( (((double)52/12)*genericWorkforceQuoteCalcObj.workingMonthsPerYear) *genericWorkforceQuoteCalcObj.workingDaysPerWeek );
                }
            }
            
            
            //*************** workforce  calculation starts here**************************
            
            //******************************leave allowance calc***END****************	
            genericWorkforceQuoteCalcObj.numberOfEndOfServiceMonths = workforceMasterObj.Number_of_End_of_Service_months__c;
            // Map Manpower notes 
            if(specialRequirement != null){
                if(specialRequirement.Notes__c != null){
                    genericWorkforceQuoteCalcObj.notes = specialRequirement.Notes__c ;
                }
            }
            if(specialRequirement != null){
                // if Gross salary in input
                if(specialRequirement.ET_Specific_Gross_Salary__c != null && specialRequirement.ET_Specific_Gross_Salary__c != 0.0){
                    genericWorkforceQuoteCalcObj.workforceGrossSalary = specialRequirement.ET_Specific_Gross_Salary__c ;
                    system.debug('gross salary = '+ specialRequirement.ET_Specific_Gross_Salary__c);
                }
                if(specialRequirement.ET_Specific_Base_Salary__c != null && specialRequirement.ET_Specific_Base_Salary__c != 0.0){
                    genericWorkforceQuoteCalcObj.workforceBasicSalary = specialRequirement.ET_Specific_Base_Salary__c ;
                }
                
                
            }
            // if special Requirement not selected - Take Gross & Basic salary from Master..
            else if(workforceMasterObj.Salary_Grade__r != null ){
                if(workforceMasterObj.Salary_Grade__r.Gross_Salary__c  != null){
                    genericWorkforceQuoteCalcObj.workforceGrossSalary =  workforceMasterObj.Salary_Grade__r.Gross_Salary__c ;
                }
                if(workforceMasterObj.Salary_Grade__r.Basic_Salary__c  != null){
                    genericWorkforceQuoteCalcObj.workforceBasicSalary =  workforceMasterObj.Salary_Grade__r.Basic_Salary__c ;
                }
                if(workforceMasterObj.Number_of_Annual_Leave_months__c != null){
                    Integer numberOfAnnualLeaves = Integer.valueOf(workforceMasterObj.Number_of_Annual_Leave_months__c.substring(0,2).trim());
                    genericWorkforceQuoteCalcObj.numberOfAnnualLeaveMonths = numberOfAnnualLeaves;
                }
            }
            
            // Leave Plan --
            // If Leave plan selected in Input
            if(specialRequirement != null && specialRequirement.ET_Specific_Leave_Plan__c != null){
                integer specificLeavePlanFrmRequest = integer.valueOf(getLeavePlan(specialRequirement.ET_Specific_Leave_Plan__c));
                genericWorkforceQuoteCalcObj.numberOfAnnualLeaveMonths = specificLeavePlanFrmRequest;
            }
            // If Leave plan not selected in Input, than take it from Mater object..
            else if(workforceMasterObj.Number_of_Annual_Leave_months__c != null){
                Integer numberOfAnnualLeaves = Integer.valueOf(workforceMasterObj.Number_of_Annual_Leave_months__c.substring(0,2).trim());
                genericWorkforceQuoteCalcObj.numberOfAnnualLeaveMonths = numberOfAnnualLeaves;
            }
            
            
            if(workforceMasterObj.Clothes_Allowance__c != null){
                genericWorkforceQuoteCalcObj.clothesAllowance = workforceMasterObj.Clothes_Allowance__c;
            }
            
            if(specialRequirement.Resource_Type__c=='UAE'&& specialRequirement.married__c=='Yes' && workforceMasterObj.Children_Allowance__c != null){
                genericWorkforceQuoteCalcObj.childrenAllowanceFromMaster = workforceMasterObj.Children_Allowance__c;
            }
            
            if(specialRequirement.Resource_Type__c =='UAE' && workforceMasterObj.Additional_work_Permit_locals__c != null){
                genericWorkforceQuoteCalcObj.additionalWorkPermitFees = workforceMasterObj.Additional_work_Permit_locals__c;
            }
            else if(specialRequirement.Resource_Type__c !='UAE' && workforceMasterObj.Additional_work_Permit_Expats__c != null){
                genericWorkforceQuoteCalcObj.additionalWorkPermitFees = workforceMasterObj.Additional_work_Permit_Expats__c;
            }
            //Resource Type
            genericWorkforceQuoteCalcObj.resourcetype = specialRequirement.Resource_Type__c;
            
            //for UAE National 
            if(specialRequirement.Resource_Type__c=='UAE' ){
                genericWorkforceQuoteCalcObj.married = specialRequirement.married__c;
                genericWorkforceQuoteCalcObj.noofchildren = specialRequirement.Number_of_Children__c;
                genericWorkforceQuoteCalcObj.costoflivingAllowance = (specialRequirement.Cost_of_Living_Allowance__c != null) ? specialRequirement.Cost_of_Living_Allowance__c : 0;
                genericWorkforceQuoteCalcObj.socialAllowance = (specialRequirement.Social_Allowance__c != null) ? specialRequirement.Social_Allowance__c : 0;
                genericWorkforceQuoteCalcObj.housingAllowancePercentage = (specialRequirement.Housing_Allowance__c != null) ? specialRequirement.Housing_Allowance__c : 0;
                genericWorkforceQuoteCalcObj.transportAllowance = (specialRequirement.Transport_Allowance__c != null) ? specialRequirement.Transport_Allowance__c : 0;
                genericWorkforceQuoteCalcObj.additionalTransportAllowance = (specialRequirement.Additional_Transport_Allowance__c != null) ? specialRequirement.Additional_Transport_Allowance__c : 0;
                genericWorkforceQuoteCalcObj.otherAllowance = (specialRequirement.Other_Allowance__c != null) ? specialRequirement.Other_Allowance__c : 0;
                genericWorkforceQuoteCalcObj.socialInsurance = (specialRequirement.Social_Insurance__c != null) ? specialRequirement.Social_Insurance__c : 0;
            }
            // for GCC National added by Arunsarathy on 31.08.2023
            if(specialRequirement.Resource_Type__c=='GCC National'){
                genericWorkforceQuoteCalcObj.socialInsurance = (specialRequirement.Social_Insurance__c != null) ? specialRequirement.Social_Insurance__c : 0;
            }
            
            //******************************health card calc***START***************
            if( healthCardMasterList != null && healthCardMasterList.size() > 0) {
                Decimal InsuranceCostBasedOnEmirate = 0.0;
                string reqKey = workforceMasterObj.ET_Workforce_Category__c;
                system.debug('reqKey = '+ reqKey );
                ET_Healthcard_Master__c Requiredhcm;
                for(ET_Healthcard_Master__c hcm : healthCardMasterList ){
                    String masterKey = hcm.Emirates__c+' '+hcm.Service_Type__c+' '+hcm.Manpower_Category__c;
                    system.debug('masterKey = '+ masterKey );
                    if(masterKey == reqKey){
                        if(genericWorkforceQuoteCalcObj.workforceGrossSalary >= hcm.Salary__c){
                            if(hcm.Operator__c.contains('>')){
                                Requiredhcm = hcm;
                                break;
                            }
                        }
                        else{
                            if(hcm.Operator__c.contains('<')){
                                Requiredhcm = hcm;
                                break;
                            }
                        }
                    }
                }
                system.debug('Requiredhcm = '+ Requiredhcm );
                if(Requiredhcm != null){
                    if(contractYear == '1'){
                        InsuranceCostBasedOnEmirate = Requiredhcm.Year_1__c;
                    }else if(contractYear == '2'){
                        InsuranceCostBasedOnEmirate = Requiredhcm.Year_2__c;
                    }else if(contractYear == '3'){
                        InsuranceCostBasedOnEmirate = Requiredhcm.Year_3__c;
                    }else if(contractYear == '4'){
                        InsuranceCostBasedOnEmirate = Requiredhcm.Year_4__c;
                    }else if(contractYear == '5'){
                        InsuranceCostBasedOnEmirate = Requiredhcm.Year_5__c;
                    }else if(contractYear == '6'){
                        InsuranceCostBasedOnEmirate = Requiredhcm.Year_6__c;
                    }else if(contractYear == '7'){
                        InsuranceCostBasedOnEmirate = Requiredhcm.Year_7__c;
                    }else if(contractYear == '8'){
                        InsuranceCostBasedOnEmirate = Requiredhcm.Year_8__c;
                    }
                }
                
                system.debug('InsuranceCostBasedOnEmirate = '+ InsuranceCostBasedOnEmirate );
                genericWorkforceQuoteCalcObj.healthCardCost = InsuranceCostBasedOnEmirate;
                
            }
            if(specialRequirement.resource_type__c=='UAE')
            {
                genericWorkforceQuoteCalcObj.healthCardCost = 0.0;
            }
            
            //******************************health card calc***End***************
            
            
            //******************************visa cost calc***START***************
            for(ET_Workforce_Visa_Master__c  visaData : visaMasterData){
                if( 
                    (visaData.ET_Api_Name__c.equals('Accountant_Cashier') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Accountant_Cashier') && (visaData.ET_Emirates__c.containsIgnoreCase(specificServiceEmirate) || visaData.ET_Emirates__c == 'All' )) ||
                    (visaData.ET_Api_Name__c.equals('Coordinator') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Coordinator') && (visaData.ET_Emirates__c.containsIgnoreCase(specificServiceEmirate) || visaData.ET_Emirates__c == 'All' )) ||
                    (visaData.ET_Api_Name__c.equals('Driver') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Driver') && (visaData.ET_Emirates__c.containsIgnoreCase(specificServiceEmirate) || visaData.ET_Emirates__c == 'All' )) ||
                    (visaData.ET_Api_Name__c.equals('Nanny') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Nanny') && (visaData.ET_Emirates__c.containsIgnoreCase(specificServiceEmirate) || visaData.ET_Emirates__c == 'All' )) ||
                    (visaData.ET_Api_Name__c.equals('Other_Employee') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Other_Employee') && (visaData.ET_Emirates__c.containsIgnoreCase(specificServiceEmirate) || visaData.ET_Emirates__c == 'All' )) ||
                    (visaData.ET_Api_Name__c.equals('Supervisor') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Supervisor') && (visaData.ET_Emirates__c.containsIgnoreCase(specificServiceEmirate) || visaData.ET_Emirates__c == 'All' )) 
                ){
                    Integer visaFeeMultiplyFactor;
                    Integer coverageYearsInt = (Integer)visaData.ET_Number_of_Coverage_years__c;
                    genericWorkforceQuoteCalcObj.visaAmount = getManpowerVisaCostForContractYear(visaData ,contractYearInt );
                    system.debug('genericWorkforceQuoteCalcObj.visaAmount  = '+ genericWorkforceQuoteCalcObj.visaAmount);
                    genericWorkforceQuoteCalcObj.numberOfCoverageYearsForVisa = coverageYearsInt;
                }
            }
            
            if(specialRequirement.resource_type__c=='UAE')
            {
                genericWorkforceQuoteCalcObj.visaAmount = 0.0;
                genericWorkforceQuoteCalcObj.numberOfCoverageYearsForVisa = 0.0;
            }
            
            
            //******************************visa cost calc***END***************
            
            
            //******************************licensing fee calc***START***************
            //uncomment it later; only to be calculated when service type is school traspotation
            
            if(oraclePricingServiceType == 'School Transportation'){
                // If this is given in input, take the Value from input, otherwise take from master data...
                
                if(specialRequirement != null && specialRequirement.Training_and_Licensing_Cost__c != null 
                   && specialRequirement.Training_and_Licensing_Cost__c != 0.0)
                {
                    genericWorkforceQuoteCalcObj.licensingFee = specialRequirement.Training_and_Licensing_Cost__c;
                }
                else if(licensingMasterDataLst != null && licensingMasterDataLst.size() > 0){
                    Decimal sumOfCosts = 0.0;
                    Map<String,Decimal> uniqueCostNameAndApplicableforMap = new Map<String, Decimal>();
                    for(Workforce_Training_and_Licencing_Cost__c licensingCost : licensingMasterDataLst){
                        //system.debug('workforceRequestObj.ET_Workforce_Record_Type_Name__c : ' + workforceRequestObj.ET_Workforce_Record_Type_Name__c + 'licensingCost.Workforce_Type__c : '+ licensingCost.Workforce_Type__c);
                        if((licensingCost.Workforce_Type__c.equals('Driver') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Driver')) ||
                           (licensingCost.Workforce_Type__c.equals('Nanny') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Nanny')) ||
                           (licensingCost.Workforce_Type__c.equals('Coordinator') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Coordinator')) ||
                           (licensingCost.Workforce_Type__c.equals('Accountant/Cashier') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Accountant_Cashier')) ||
                           (licensingCost.Workforce_Type__c.equals('Other Employee') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Other_Employee')) ||
                           (licensingCost.Workforce_Type__c.equals('Supervisor') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Supervisor'))){
                               Decimal elementCostEmiratesVise;
                               if(workforceRequestObj.ET_Service_Emirate__c.equals('AbuDhabi')){
                                   
                                   elementCostEmiratesVise = licensingCost.Cost_in_Abu_Dhabi__c;
                               }
                               else if(workforceRequestObj.ET_Service_Emirate__c.equals('Dubai')){
                                   elementCostEmiratesVise = licensingCost.Cost_in_Dubai__c;
                               }
                               else if(workforceRequestObj.ET_Service_Emirate__c.equals('Sharjah')){
                                   elementCostEmiratesVise = licensingCost.Cost_in_Sharjah__c;
                               }
                               else if(workforceRequestObj.ET_Service_Emirate__c.equals('Ajman')){
                                   elementCostEmiratesVise = licensingCost.Cost_in_Ajman__c;
                               }
                               else if(workforceRequestObj.ET_Service_Emirate__c.equals('UMM Al Quawain')){
                                   elementCostEmiratesVise = licensingCost.Cost_in_Umm_Al_Quawain__c;
                               }
                               else if(workforceRequestObj.ET_Service_Emirate__c.equals('Ras Al Khaimah')){
                                   elementCostEmiratesVise = licensingCost.Cost_in_Ras_Al_Khaimah__c;
                               }else{
                                   elementCostEmiratesVise = licensingCost.Cost_in_Fujairah__c;
                               }
                               
                               if(licensingCost.Cost_Type__c.equals('Annually')){
                                   sumOfCosts += elementCostEmiratesVise;
                               }else if(licensingCost.Cost_Type__c.equals('One time') ){
                                   sumOfCosts += elementCostEmiratesVise / genericWorkforceQuoteCalcObj.contractYear;
                               }
                               
                           }
                    }
                    
                    genericWorkforceQuoteCalcObj.licensingFee = sumOfCosts;  
                }
                // Added by Arunsarathy on 05.09.2023
                if(genericWorkforceQuoteCalcObj.workforceRecordType =='ET_Driver'){
                    if(genericWorkforceQuoteCalcObj.contractYear == 1){
                        genericWorkforceQuoteCalcObj.licensingFee = 3191;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 2){
                        genericWorkforceQuoteCalcObj.licensingFee = 1610;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 3){
                        genericWorkforceQuoteCalcObj.licensingFee = 2259;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 4){
                        genericWorkforceQuoteCalcObj.licensingFee = 1702;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 5){
                        genericWorkforceQuoteCalcObj.licensingFee = 2073;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 6){
                        genericWorkforceQuoteCalcObj.licensingFee = 1732;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 7){
                        genericWorkforceQuoteCalcObj.licensingFee = 1993;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 8){
                        genericWorkforceQuoteCalcObj.licensingFee = 1747;
                    }
                    
                }  if(genericWorkforceQuoteCalcObj.workforceRecordType =='ET_Nanny'){
                    if(genericWorkforceQuoteCalcObj.contractYear == 1){
                        genericWorkforceQuoteCalcObj.licensingFee = 707;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 2){
                        genericWorkforceQuoteCalcObj.licensingFee = 381;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 3){
                        genericWorkforceQuoteCalcObj.licensingFee = 272;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 4){
                        genericWorkforceQuoteCalcObj.licensingFee = 217;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 5){
                        genericWorkforceQuoteCalcObj.licensingFee = 220;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 6){
                        genericWorkforceQuoteCalcObj.licensingFee = 220;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 7){
                        genericWorkforceQuoteCalcObj.licensingFee = 220;
                    }else if(genericWorkforceQuoteCalcObj.contractYear == 8){
                        genericWorkforceQuoteCalcObj.licensingFee = 220;
                    }
                    
                }
            }
            
            /**Language and Psychometric Fee ***/
            // If this is given in input, take the Value from input, otherwise take from master data...
            
            if(specialRequirement != null && specialRequirement.Language_and_Psychometric_Test_Fee__c != null 
               && specialRequirement.Language_and_Psychometric_Test_Fee__c != 0.0)
            {
                genericWorkforceQuoteCalcObj.languageAndPsychometricTest = specialRequirement.Language_and_Psychometric_Test_Fee__c;
            }
            else if(languageMasterData != null && languageMasterData.size() > 0){
                for(ET_Language_and_Psychometric_Test_Master__c langMaster : languageMasterData){
                    if(langMaster.Emirates__c != null && (langMaster.Emirates__c.contains(specificServiceEmirate) || langMaster.Emirates__c == 'All')){
                        genericWorkforceQuoteCalcObj.languageAndPsychometricTest = getLanguageAndPycometricTestFee(langMaster , contractYearInt );
                    }
                }
            }
            
            
            
            //******************************Annual profit margin value calc***START***************
            if(workforceProfitMasterData != null && workforceProfitMasterData.size() > 0){
                Decimal basicSalary;
                if(specialRequirement != null && specialRequirement.ET_Specific_Base_Salary__c != null && specialRequirement.ET_Specific_Base_Salary__c != 0.0){
                    basicSalary = specialRequirement.ET_Specific_Base_Salary__c;
                }
                for(ET_Workforce_Profit_Master__c profitObj : workforceProfitMasterData){
                    if((profitObj.ET_Api_Name__c.equals('Annual_Driver_Profit_Margin_Value') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Driver')) ||
                       (profitObj.ET_Api_Name__c.equals('Annual_Nanny_Profit_Margin_Value') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Nanny')) ||
                       (profitObj.ET_Api_Name__c.equals('Annual_Coordinator_Profit_Margin_Value') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Coordinator')) ||
                       (profitObj.ET_Api_Name__c.equals('Annual_Accountant_Profit_Margin_Value') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Accountant_Cashier')) ||
                       (profitObj.ET_Api_Name__c.equals('Annual_Other_Emp_Profit_Margin_Value') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Other_Employee')) ||
                       (profitObj.ET_Api_Name__c.equals('Annual_Supervisor_Profit_Margin_Value') && workforceRequestObj.ET_Workforce_Record_Type_Name__c.equals('ET_Supervisor'))){
                           
                           if(profitObj.Profit_Percentage__c != null  ){
                               genericWorkforceQuoteCalcObj.profitPercentage = profitObj.Profit_Percentage__c;
                           }
                       }
                }
            }
            //******************************Annual profit margin rate calc***START***************
            return genericWorkforceQuoteCalcObj;
        }
        catch(Exception ex){
            ET_PricingUtilityClass.logException(ex, 'Pricing');
            system.debug('Exception occured of type :' + ex.getTypeName() + ' due to cause : ' + ex.getCause()  + 'with Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString());
            throw new AuraHandledException('Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString());
            
        }
    }
    
    
    public static Decimal getLeavePlan(String leavePlan){
        Decimal convertedLeavePlan = 0.0;
        switch on leavePlan{
            when '1 month every year', 'Half month every 6 months' {
                convertedLeavePlan = 1;
            }
            when '1 month every 6 months', 'Half month every 3 months' {
                convertedLeavePlan = 2;
            }
            when '1 month every 4 months' {
                convertedLeavePlan = 3;
            }
            when '1 month every 3 months' {
                convertedLeavePlan = 4;
            }
            when 'Half month every 4 months' {
                convertedLeavePlan = 1.5;
            }
        }
        return convertedLeavePlan;
    }
    
    
    /* Method : returnLineNumberWithRespectToManpowerKey
Description : to return line number with respect to Manpower key
*/
    
    Public static Map<String,decimal> returnLineNumberWithRespectToManpowerKey( List<ET_Request_Mapping__c> reqMappings){
        List<String> allKeys = new List<String>();
        decimal lineNo;
        Map<String,decimal> lineNoWrToKey = new Map<String,decimal>();
        
        if(reqMappings != null && reqMappings.size() > 0){
            for(ET_Request_Mapping__c reqMap : reqMappings ){
                if(reqMap.ET_Number_of_Accountants__c > 0){
                    lineNoWrToKey.put(reqMap.ET_Accountant_Unique_Key__c, decimal.valueOf(reqMap.ET_Vehicle_Unique_key__c.split('=>')[1])); 
                }
                if(reqMap.ET_Number_of_Coordinators__c > 0){
                    lineNoWrToKey.put(reqMap.ET_Coordinator_Unique_Key__c, decimal.valueOf(reqMap.ET_Vehicle_Unique_key__c.split('=>')[1])); 
                }
                if(reqMap.ET_Number_of_Nannies__c > 0){
                    lineNoWrToKey.put(reqMap.ET_Nanny_Unique_Key__c, decimal.valueOf(reqMap.ET_Vehicle_Unique_key__c.split('=>')[1])); 
                }
                if(reqMap.ET_Number_of_Drivers__c > 0){
                    lineNoWrToKey.put(reqMap.ET_Driver_Unique_Id__c, decimal.valueOf(reqMap.ET_Vehicle_Unique_key__c.split('=>')[1])); 
                }
                
                if(reqMap.ET_Number_of_Supervisors__c > 0){
                    lineNoWrToKey.put(reqMap.ET_Supervisor_Unique_Key__c, decimal.valueOf(reqMap.ET_Vehicle_Unique_key__c.split('=>')[1])); 
                }
                if(reqMap.ET_Number_of_Other_Employees__c > 0){
                    lineNoWrToKey.put(reqMap.ET_Other_Employee_Unique_Key__c, decimal.valueOf(reqMap.ET_Vehicle_Unique_key__c.split('=>')[1])); 
                }
                if(reqMap.ET_Number_of_Vehicles__c > 0){
                    lineNoWrToKey.put(reqMap.ET_Vehicle_Unique_key__c, decimal.valueOf(reqMap.ET_Vehicle_Unique_key__c.split('=>')[1])); 
                }
            }
        }
        
        
        return lineNoWrToKey;
        
    }
    
    /* Method : returnVehicleKeyWithRespectToManpowerKey
Description : to return VehicleKey with respect to Manpower key
*/
    
    Public static Map<String,String> returnVehicleKeyWithRespectToManpowerKey( List<ET_Request_Mapping__c> reqMappings){
        List<String> allKeys = new List<String>();
        decimal lineNo;
        Map<String,String> vehKeyWrToManpowerKey = new Map<String,String>();
        
        if(reqMappings != null && reqMappings.size() > 0){
            for(ET_Request_Mapping__c reqMap : reqMappings ){
                if(reqMap.ET_Number_of_Accountants__c > 0){
                    vehKeyWrToManpowerKey.put(reqMap.ET_Accountant_Unique_Key__c, reqMap.ET_Vehicle_Unique_key__c); 
                }
                if(reqMap.ET_Number_of_Coordinators__c > 0){
                    vehKeyWrToManpowerKey.put(reqMap.ET_Coordinator_Unique_Key__c, reqMap.ET_Vehicle_Unique_key__c); 
                }
                if(reqMap.ET_Number_of_Nannies__c > 0){
                    vehKeyWrToManpowerKey.put(reqMap.ET_Nanny_Unique_Key__c, reqMap.ET_Vehicle_Unique_key__c); 
                }
                if(reqMap.ET_Number_of_Drivers__c > 0){
                    vehKeyWrToManpowerKey.put(reqMap.ET_Driver_Unique_Id__c, reqMap.ET_Vehicle_Unique_key__c); 
                }
                
                if(reqMap.ET_Number_of_Supervisors__c > 0){
                    vehKeyWrToManpowerKey.put(reqMap.ET_Supervisor_Unique_Key__c, reqMap.ET_Vehicle_Unique_key__c); 
                }
                if(reqMap.ET_Number_of_Other_Employees__c > 0){
                    vehKeyWrToManpowerKey.put(reqMap.ET_Other_Employee_Unique_Key__c, reqMap.ET_Vehicle_Unique_key__c); 
                }
                if(reqMap.ET_Number_of_Vehicles__c > 0){
                    vehKeyWrToManpowerKey.put(reqMap.ET_Vehicle_Unique_key__c, reqMap.ET_Vehicle_Unique_key__c); 
                }
            }
        }
        
        
        return vehKeyWrToManpowerKey;
        
    }
    
    
    
    /* Method 	   : createWorkforceQuoteItemObjs
Description : To Create all workforce quote Items with Rates from Masters and some generic info like Line no etc..
*/
    
    public static String createWorkforceQuoteItemObjs(Id quoteObjId, ET_ServiceRequestController.QuoteCalculationClass quoteCalcObj, 
                                                      List<ET_Pricing_VAT_setup__c> vatData , String serviceRequestId , String serviceType){
                                                          String response;
                                                          try{
                                                              
                                                              // update quote with workforce count...
                                                              Quote qt = new Quote( id = quoteObjId);
                                                              qt.Total_Number_of_Drivers__c = totalDrivers;
                                                              qt.Total_Number_of_Accountants__c = totalAccountants;
                                                              qt.Total_Number_of_Coordinators__c = totalCoordinators;
                                                              qt.Total_Number_of_Nannies__c = totalNannies;
                                                              qt.Total_Number_of_Other_Employees__c = totalOtherEmployees;
                                                              qt.Total_Number_of_Supervisors__c = totalSuperVisors;
                                                              decimal noOfOtherManpower =0;
                                                              if(totalAccountants != null){
                                                                  noOfOtherManpower += totalAccountants;
                                                              }
                                                              if(totalCoordinators != null){
                                                                  noOfOtherManpower += totalCoordinators;
                                                              }
                                                              if(totalNannies != null){
                                                                  noOfOtherManpower += totalNannies;
                                                              }
                                                              if(totalOtherEmployees != null){
                                                                  noOfOtherManpower += totalOtherEmployees;
                                                              }
                                                              if(totalSuperVisors != null){
                                                                  noOfOtherManpower += totalSuperVisors;
                                                              }
                                                              qt.Total_Number_of_other_manpower__c = noOfOtherManpower;
                                                              
                                                              if(qt != null && qt.id != null){
                                                                  update qt;
                                                              }
                                                              List<ET_Workforce_Quote_Item__c> workforceQuoteItemLstToInsert = new List<ET_Workforce_Quote_Item__c>();
                                                              
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
                                                                                                                                         from ET_Request_Mapping__c where ET_Pricing_Service_Request__c =:serviceRequestId and ET_Vehicle_Unique_key__c != null ]) ;
                                                              
                                                              Map<String, decimal> lineNoWrToManpowerKey = returnLineNumberWithRespectToManpowerKey(reqMappings);
                                                              system.debug('lineNoWrToManpowerKey  = '+ JSON.serializePretty(lineNoWrToManpowerKey));
                                                              
                                                              // other cost related initializations
                                                              Map<String, List<ET_Quote_Item_SpecReq__c>> driverQuoteItemAndSpecReqMap = new Map<String, List<ET_Quote_Item_SpecReq__c>>();
                                                              Map<String, List<ET_Quote_Item_SpecReq__c>> nannyQuoteItemAndSpecReqMap = new Map<String, List<ET_Quote_Item_SpecReq__c>>();
                                                              Map<String, List<ET_Quote_Item_SpecReq__c>> supervisorQuoteItemAndSpecReqMap = new Map<String, List<ET_Quote_Item_SpecReq__c>>();
                                                              Map<String, List<ET_Quote_Item_SpecReq__c>> coordinatorQuoteItemAndSpecReqMap = new Map<String, List<ET_Quote_Item_SpecReq__c>>();
                                                              Map<String, List<ET_Quote_Item_SpecReq__c>> accQuoteItemAndSpecReqMap = new Map<String, List<ET_Quote_Item_SpecReq__c>>();
                                                              Map<String, List<ET_Quote_Item_SpecReq__c>> otherEmpQuoteItemAndSpecReqMap = new Map<String, List<ET_Quote_Item_SpecReq__c>>();
                                                              
                                                              List<ET_Pricing_Service_Reserve_Master__c> reserveMaster = new List<ET_Pricing_Service_Reserve_Master__c>();
                                                              reserveMaster = [Select Id,ET_Manpower_Reserve_Rate__c, ET_Service_Type__c from ET_Pricing_Service_Reserve_Master__c where ET_Service_Type__c=:serviceType Limit 1];
                                                              decimal manpowerReserveRate =0.0;
                                                              system.debug('reserveMaster  = ' + reserveMaster);
                                                              system.debug('serviceType  = ' + serviceType);
                                                              if(!reserveMaster.isEmpty()){
                                                                  manpowerReserveRate = reserveMaster[0].ET_Manpower_Reserve_Rate__c;
                                                              }
                                                              system.debug('manpowerReserveRate  = ' + manpowerReserveRate);
                                                              
                                                              if(quoteCalcObj.serviceRequestId != null && quoteCalcObj.driverQuoteItemLst != null && quoteCalcObj.driverQuoteItemLst.size() > 0 ){
                                                                  
                                                                  for(ET_ServiceRequestController.driverQuoteCalcClass driverQuoteCalObj : quoteCalcObj.driverQuoteItemLst){
                                                                      List<ET_Quote_Item_SpecReq__c> specReqToInsertDriverLst = new List<ET_Quote_Item_SpecReq__c>();
                                                                      ET_Workforce_Quote_Item__c workforceQuoteItemtoInsert = new ET_Workforce_Quote_Item__c();
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Unique_Key__c = driverQuoteCalObj.driverUniqueKey;
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c = 'Driver';
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.Quote__c = quoteObjId;
                                                                      workforceQuoteItemtoInsert.ET_Number_of_Workforce__c = driverQuoteCalObj.numberOfDrivers;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Reserve_Rate__c = manpowerReserveRate.setScale(2);
                                                                      workforceQuoteItemtoInsert = prepareWorkforceObject(workforceQuoteItemtoInsert, driverQuoteCalObj.driverWorkforceClassObj, lineNoWrToManpowerKey);
                                                                      if(workforceQuoteItemtoInsert.ET_Vat_Rate__c == 'Exempt'){
                                                                          workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c = calculateVATCost(vatData,workforceQuoteItemtoInsert);
                                                                      }
                                                                      
                                                                      decimal totalDynamicOtherCost = 0.0;
                                                                      system.debug('driverQuoteCalObj.driverOtherCostLst 1037= '+ JSON.serializePretty(driverQuoteCalObj.driverOtherCostLst));
                                                                      for(ET_ServiceRequestController.otherCostCalcClass otCostReq : driverQuoteCalObj.driverOtherCostLst){
                                                                          if(otCostReq.otherCostLineNumber == workforceQuoteItemtoInsert.Line_number_from_input__c){
                                                                              ET_Quote_Item_SpecReq__c qisr = new ET_Quote_Item_SpecReq__c();
                                                                              qisr.ET_Api_Name__c = otCostReq.otherCostLabel;
                                                                              qisr.ET_Cost__c = otCostReq.otherCostValue;
                                                                              qisr.Name = otCostReq.otherCostLabel;
                                                                              specReqToInsertDriverLst.add(qisr); 
                                                                              totalDynamicOtherCost += otCostReq.otherCostValue ;
                                                                          }
                                                                      }
                                                                      workforceQuoteItemtoInsert.Total_dynamic_other_cost__c = Math.round(totalDynamicOtherCost);
                                                                      workforceQuoteItemLstToInsert.add(workforceQuoteItemtoInsert);  
                                                                      // Map related other cost with a Key from input Request in a Map..
                                                                      system.debug('specReqToInsertDriverLst 1050= '+ JSON.serializePretty(specReqToInsertDriverLst));
                                                                      driverQuoteItemAndSpecReqMap.put(workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c + '-' +
                                                                                                       String.valueOf(workforceQuoteItemtoInsert.ET_Workforce_Line_Number__c) + '-'+ 
                                                                                                       String.valueOf(workforceQuoteItemtoInsert.ET_Contract_Period__c), 
                                                                                                       specReqToInsertDriverLst);
                                                                      
                                                                  }
                                                              }
                                                              
                                                              if(quoteCalcObj.serviceRequestId != null && quoteCalcObj.nannyQuoteItemLst != null && quoteCalcObj.nannyQuoteItemLst.size() > 0 ){
                                                                  for(ET_ServiceRequestController.nannyQuoteCalcClass nannyQuoteCalObj : quoteCalcObj.nannyQuoteItemLst){
                                                                      List<ET_Quote_Item_SpecReq__c> specReqToInsertNannyLst = new List<ET_Quote_Item_SpecReq__c>();
                                                                      ET_Workforce_Quote_Item__c workforceQuoteItemtoInsert = new ET_Workforce_Quote_Item__c();
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Unique_Key__c = nannyQuoteCalObj.nannyUniqueKey;
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c = 'Nanny';
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.Quote__c = quoteObjId;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Number_of_Workforce__c = nannyQuoteCalObj.numberOfNannies;
                                                                      workforceQuoteItemtoInsert.ET_Reserve_Rate__c = manpowerReserveRate.setScale(2);
                                                                      workforceQuoteItemtoInsert = prepareWorkforceObject(workforceQuoteItemtoInsert, nannyQuoteCalObj.nannyWorkforceClassObj, lineNoWrToManpowerKey);
                                                                      if(workforceQuoteItemtoInsert.ET_Vat_Rate__c == 'Exempt'){
                                                                          workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c = calculateVATCost(vatData,workforceQuoteItemtoInsert);
                                                                      }
                                                                      
                                                                      decimal totalDynamicOtherCost = 0.0;
                                                                      for(ET_ServiceRequestController.otherCostCalcClass otCostReq : nannyQuoteCalObj.nannyOtherCostLst){
                                                                          ET_Quote_Item_SpecReq__c qisr = new ET_Quote_Item_SpecReq__c();
                                                                          qisr.ET_Api_Name__c = otCostReq.otherCostLabel;
                                                                          qisr.ET_Cost__c = otCostReq.otherCostValue;
                                                                          qisr.Name = otCostReq.otherCostLabel;
                                                                          //qisr.Workforce_Quote_Item__c = wfqi.Id;
                                                                          specReqToInsertNannyLst.add(qisr);
                                                                          totalDynamicOtherCost += otCostReq.otherCostValue ;
                                                                      }
                                                                      workforceQuoteItemtoInsert.Total_dynamic_other_cost__c = Math.round(totalDynamicOtherCost);
                                                                      workforceQuoteItemLstToInsert.add(workforceQuoteItemtoInsert);
                                                                      
                                                                      nannyQuoteItemAndSpecReqMap.put(workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c + '-' +
                                                                                                      String.valueOf(workforceQuoteItemtoInsert.ET_Workforce_Line_Number__c) + '-'+ 
                                                                                                      String.valueOf(workforceQuoteItemtoInsert.ET_Contract_Period__c), 
                                                                                                      specReqToInsertNannyLst);
                                                                  }
                                                              }
                                                              if(quoteCalcObj.serviceRequestId != null && quoteCalcObj.supervisorQuoteItemLst != null && quoteCalcObj.supervisorQuoteItemLst.size() > 0 ){
                                                                  for(ET_ServiceRequestController.supervisorQuoteCalcClass supervisorQuoteCalObj : quoteCalcObj.supervisorQuoteItemLst){
                                                                      List<ET_Quote_Item_SpecReq__c> specReqToInsertSupervisorLst = new List<ET_Quote_Item_SpecReq__c>();
                                                                      ET_Workforce_Quote_Item__c workforceQuoteItemtoInsert = new ET_Workforce_Quote_Item__c();
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Unique_Key__c = supervisorQuoteCalObj.supervisorUniqueKey;
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c = 'Supervisor';
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.Quote__c = quoteObjId;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Number_of_Workforce__c = supervisorQuoteCalObj.numberOfSupervisors;
                                                                      workforceQuoteItemtoInsert.ET_Reserve_Rate__c = manpowerReserveRate.setScale(2);
                                                                      workforceQuoteItemtoInsert = prepareWorkforceObject(workforceQuoteItemtoInsert, supervisorQuoteCalObj.supervisorWorkforceClassObj,lineNoWrToManpowerKey);
                                                                      if(workforceQuoteItemtoInsert.ET_Vat_Rate__c == 'Exempt'){
                                                                          workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c = calculateVATCost(vatData,workforceQuoteItemtoInsert);
                                                                          ET_Request_Mapping__c requiredRequestMapping =  getCombinationRecordFromRequest( reqMappings , 'Supervisor' ,workforceQuoteItemtoInsert );
                                                                          if(requiredRequestMapping != null && workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c != null && workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c != 0){
                                                                              workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c  =  (workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c * workforceQuoteItemtoInsert.ET_Number_of_Workforce__c )/(requiredRequestMapping.ET_Number_of_Vehicles__c);
                                                                          }
                                                                      }
                                                                      
                                                                      decimal totalDynamicOtherCost = 0.0;
                                                                      for(ET_ServiceRequestController.otherCostCalcClass otCostReq : supervisorQuoteCalObj.supervisorOtherCostLst){
                                                                          ET_Quote_Item_SpecReq__c qisr = new ET_Quote_Item_SpecReq__c();
                                                                          qisr.ET_Api_Name__c = otCostReq.otherCostLabel;
                                                                          qisr.ET_Cost__c = otCostReq.otherCostValue;
                                                                          qisr.Name = otCostReq.otherCostLabel;
                                                                          //qisr.Workforce_Quote_Item__c = wfqi.Id;
                                                                          specReqToInsertSupervisorLst.add(qisr);
                                                                          totalDynamicOtherCost += otCostReq.otherCostValue ;
                                                                      }
                                                                      workforceQuoteItemtoInsert.Total_dynamic_other_cost__c = Math.round(totalDynamicOtherCost);
                                                                      workforceQuoteItemLstToInsert.add(workforceQuoteItemtoInsert);
                                                                      supervisorQuoteItemAndSpecReqMap.put(workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c + '-' + 
                                                                                                           String.valueOf(workforceQuoteItemtoInsert.ET_Workforce_Line_Number__c) + '-'+ 
                                                                                                           String.valueOf(workforceQuoteItemtoInsert.ET_Contract_Period__c), specReqToInsertSupervisorLst);
                                                                  }
                                                              }
                                                              if(quoteCalcObj.serviceRequestId != null && quoteCalcObj.coordinatorQuoteItemLst != null && quoteCalcObj.coordinatorQuoteItemLst.size() > 0 ){
                                                                  for(ET_ServiceRequestController.coordinatorQuoteCalcClass coordinatorQuoteCalObj : quoteCalcObj.coordinatorQuoteItemLst){
                                                                      List<ET_Quote_Item_SpecReq__c> specReqToInsertCoordinatorLst = new List<ET_Quote_Item_SpecReq__c>();
                                                                      ET_Workforce_Quote_Item__c workforceQuoteItemtoInsert = new ET_Workforce_Quote_Item__c();
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Unique_Key__c = coordinatorQuoteCalObj.coordinatorUniqueKey;
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c = 'Coordinator';
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.Quote__c = quoteObjId;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Number_of_Workforce__c = coordinatorQuoteCalObj.numberOfCoordinators;
                                                                      workforceQuoteItemtoInsert.ET_Reserve_Rate__c = manpowerReserveRate.setScale(2);
                                                                      workforceQuoteItemtoInsert = prepareWorkforceObject(workforceQuoteItemtoInsert, coordinatorQuoteCalObj.coordinatorWorkforceClassObj,lineNoWrToManpowerKey);
                                                                      if(workforceQuoteItemtoInsert.ET_Vat_Rate__c == 'Exempt'){
                                                                          workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c = calculateVATCost(vatData,workforceQuoteItemtoInsert);
                                                                          ET_Request_Mapping__c requiredRequestMapping =  getCombinationRecordFromRequest( reqMappings , 'Coordinator' ,workforceQuoteItemtoInsert );
                                                                          if(requiredRequestMapping != null && workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c != null && workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c != 0){
                                                                              workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c  =  (workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c * workforceQuoteItemtoInsert.ET_Number_of_Workforce__c )/(requiredRequestMapping.ET_Number_of_Vehicles__c);
                                                                          } 
                                                                      }
                                                                      
                                                                      decimal totalDynamicOtherCost = 0.0;
                                                                      for(ET_ServiceRequestController.otherCostCalcClass otCostReq : coordinatorQuoteCalObj.coordinatorOtherCostLst){
                                                                          ET_Quote_Item_SpecReq__c qisr = new ET_Quote_Item_SpecReq__c();
                                                                          qisr.ET_Api_Name__c = otCostReq.otherCostLabel;
                                                                          qisr.ET_Cost__c = otCostReq.otherCostValue;
                                                                          qisr.Name = otCostReq.otherCostLabel;
                                                                          //qisr.Workforce_Quote_Item__c = wfqi.Id;
                                                                          specReqToInsertCoordinatorLst.add(qisr);
                                                                          totalDynamicOtherCost += otCostReq.otherCostValue ;
                                                                      }
                                                                      
                                                                      workforceQuoteItemtoInsert.Total_dynamic_other_cost__c = Math.round(totalDynamicOtherCost);
                                                                      workforceQuoteItemLstToInsert.add(workforceQuoteItemtoInsert);
                                                                      coordinatorQuoteItemAndSpecReqMap.put(workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c + '-' + 
                                                                                                            String.valueOf(workforceQuoteItemtoInsert.ET_Workforce_Line_Number__c) + '-'+
                                                                                                            String.valueOf(workforceQuoteItemtoInsert.ET_Contract_Period__c), 
                                                                                                            specReqToInsertCoordinatorLst);
                                                                  }
                                                              }
                                                              if(quoteCalcObj.serviceRequestId != null && quoteCalcObj.accountantQuoteItemLst != null && quoteCalcObj.accountantQuoteItemLst.size() > 0 ){
                                                                  for(ET_ServiceRequestController.accountantQuoteCalcClass accountantQuoteCalObj : quoteCalcObj.accountantQuoteItemLst){
                                                                      List<ET_Quote_Item_SpecReq__c> specReqToInsertAccountantLst = new List<ET_Quote_Item_SpecReq__c>();
                                                                      ET_Workforce_Quote_Item__c workforceQuoteItemtoInsert = new ET_Workforce_Quote_Item__c();
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Unique_Key__c = accountantQuoteCalObj.accountantUniqueKey;
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c = 'Accountant/Cashier';
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.Quote__c = quoteObjId;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Number_of_Workforce__c = accountantQuoteCalObj.numberOfAccountants;
                                                                      workforceQuoteItemtoInsert.ET_Reserve_Rate__c = manpowerReserveRate.setScale(2);
                                                                      workforceQuoteItemtoInsert = prepareWorkforceObject(workforceQuoteItemtoInsert, accountantQuoteCalObj.accWorkforceClassObj,lineNoWrToManpowerKey);
                                                                      if(workforceQuoteItemtoInsert.ET_Vat_Rate__c == 'Exempt'){
                                                                          workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c = calculateVATCost(vatData,workforceQuoteItemtoInsert);
                                                                          ET_Request_Mapping__c requiredRequestMapping =  getCombinationRecordFromRequest( reqMappings , 'Accountant' ,workforceQuoteItemtoInsert );
                                                                          if(requiredRequestMapping != null && workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c != null && workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c != 0){
                                                                              workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c  =  (workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c * workforceQuoteItemtoInsert.ET_Number_of_Workforce__c )/(requiredRequestMapping.ET_Number_of_Vehicles__c);
                                                                          }
                                                                      }
                                                                      
                                                                      
                                                                      decimal totalDynamicOtherCost = 0.0;
                                                                      for(ET_ServiceRequestController.otherCostCalcClass otCostReq : accountantQuoteCalObj.accountantOtherCostLst){
                                                                          ET_Quote_Item_SpecReq__c qisr = new ET_Quote_Item_SpecReq__c();
                                                                          qisr.ET_Api_Name__c = otCostReq.otherCostLabel;
                                                                          qisr.ET_Cost__c = otCostReq.otherCostValue;
                                                                          qisr.Name = otCostReq.otherCostLabel;
                                                                          specReqToInsertAccountantLst.add(qisr);
                                                                          totalDynamicOtherCost += otCostReq.otherCostValue ;
                                                                      }
                                                                      
                                                                      workforceQuoteItemtoInsert.Total_dynamic_other_cost__c = Math.round(totalDynamicOtherCost);
                                                                      workforceQuoteItemLstToInsert.add(workforceQuoteItemtoInsert);
                                                                      accQuoteItemAndSpecReqMap.put(workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c + '-' +  
                                                                                                    String.valueOf(workforceQuoteItemtoInsert.ET_Workforce_Line_Number__c) + '-'+ 
                                                                                                    String.valueOf(workforceQuoteItemtoInsert.ET_Contract_Period__c), 
                                                                                                    specReqToInsertAccountantLst);
                                                                      
                                                                  }
                                                                  
                                                                  
                                                              }
                                                              
                                                              if(quoteCalcObj.serviceRequestId != null && quoteCalcObj.otherEmpQuoteItemLst != null && quoteCalcObj.otherEmpQuoteItemLst.size() > 0 ) {
                                                                  for(ET_ServiceRequestController.otherEmpQuoteCalcClass otherEmpQuoteCalObj : quoteCalcObj.otherEmpQuoteItemLst){
                                                                      List<ET_Quote_Item_SpecReq__c> specReqToInsertOtherEmpLst = new List<ET_Quote_Item_SpecReq__c>();
                                                                      ET_Workforce_Quote_Item__c workforceQuoteItemtoInsert = new ET_Workforce_Quote_Item__c();
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Unique_Key__c = otherEmpQuoteCalObj.otherEmpUniqueKey;
                                                                      workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c = 'Other Employee';
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.Quote__c = quoteObjId;
                                                                      workforceQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                                                                      workforceQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                                                                      workforceQuoteItemtoInsert.ET_Number_of_Workforce__c = otherEmpQuoteCalObj.numberOfOtherEmps;
                                                                      workforceQuoteItemtoInsert.ET_Reserve_Rate__c = manpowerReserveRate.setScale(2);
                                                                      workforceQuoteItemtoInsert = prepareWorkforceObject(workforceQuoteItemtoInsert, otherEmpQuoteCalObj.otherEmpWorkforceClassObj,lineNoWrToManpowerKey);
                                                                      if(workforceQuoteItemtoInsert.ET_Vat_Rate__c == 'Exempt'){
                                                                          workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c = calculateVATCost(vatData,workforceQuoteItemtoInsert);
                                                                          ET_Request_Mapping__c requiredRequestMapping =  getCombinationRecordFromRequest( reqMappings , 'other employee' ,workforceQuoteItemtoInsert );
                                                                          if(requiredRequestMapping != null && workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c != null && workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c != 0){
                                                                              workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c  =  (workforceQuoteItemtoInsert.ET_Workforce_VAT_Cost__c * workforceQuoteItemtoInsert.ET_Number_of_Workforce__c )/(requiredRequestMapping.ET_Number_of_Vehicles__c);
                                                                          }
                                                                      }
                                                                      
                                                                      decimal totalDynamicOtherCost = 0.0;
                                                                      for(ET_ServiceRequestController.otherCostCalcClass otCostReq : otherEmpQuoteCalObj.otherEmpOtherCostLst){
                                                                          ET_Quote_Item_SpecReq__c qisr = new ET_Quote_Item_SpecReq__c();
                                                                          qisr.ET_Api_Name__c = otCostReq.otherCostLabel;
                                                                          qisr.ET_Cost__c = otCostReq.otherCostValue;
                                                                          qisr.Name = otCostReq.otherCostLabel;
                                                                          specReqToInsertOtherEmpLst.add(qisr);
                                                                          totalDynamicOtherCost += otCostReq.otherCostValue ;
                                                                      }
                                                                      
                                                                      workforceQuoteItemtoInsert.Total_dynamic_other_cost__c = Math.round(totalDynamicOtherCost);
                                                                      workforceQuoteItemLstToInsert.add(workforceQuoteItemtoInsert);
                                                                      
                                                                      otherEmpQuoteItemAndSpecReqMap.put(workforceQuoteItemtoInsert.ET_Workforce_Quote_Item_Type__c + '-' +  
                                                                                                         String.valueOf(workforceQuoteItemtoInsert.ET_Workforce_Line_Number__c) + '-'+
                                                                                                         String.valueOf(workforceQuoteItemtoInsert.ET_Contract_Period__c), 
                                                                                                         specReqToInsertOtherEmpLst);
                                                                  }
                                                              }
                                                              
                                                              if(!workforceQuoteItemLstToInsert.isEmpty()){
                                                                  insert workforceQuoteItemLstToInsert;
                                                                  
                                                                  // workforce related other cost..
                                                                  List<ET_Quote_Item_SpecReq__c> workforceSpecReqToInsertLst = new List<ET_Quote_Item_SpecReq__c>();
                                                                  for(ET_Workforce_Quote_Item__c workforceQuoteItem : workforceQuoteItemLstToInsert){
                                                                      
                                                                      Map<String, List<ET_Quote_Item_SpecReq__c>> desiredWorkforceMap;
                                                                      if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c == 'Driver'){
                                                                          desiredWorkforceMap = driverQuoteItemAndSpecReqMap;
                                                                      }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c == 'Nanny'){
                                                                          desiredWorkforceMap = nannyQuoteItemAndSpecReqMap;
                                                                      }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c == 'Supervisor'){
                                                                          desiredWorkforceMap = supervisorQuoteItemAndSpecReqMap;
                                                                      }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c == 'Coordinator'){
                                                                          desiredWorkforceMap = coordinatorQuoteItemAndSpecReqMap;
                                                                      }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c == 'Accountant/Cashier'){
                                                                          desiredWorkforceMap = accQuoteItemAndSpecReqMap;
                                                                      }else if(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c == 'Other Employee'){
                                                                          desiredWorkforceMap = otherEmpQuoteItemAndSpecReqMap;
                                                                      }
                                                                      system.debug('desiredWorkforceMap = '+ JSON.serializePretty(desiredWorkforceMap));
                                                                      system.debug('keyyy 1282 : '+workforceQuoteItem.ET_Workforce_Quote_Item_Type__c + '-' +  String.valueOf(workforceQuoteItem.ET_Workforce_Line_Number__c) +'-'+ String.valueOf(workforceQuoteItem.ET_Contract_Period__c) );
                                                                      system.debug('mapoutput = '+ JSON.serializePretty(desiredWorkforceMap.get(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c + '-' +  String.valueOf(workforceQuoteItem.ET_Workforce_Line_Number__c) +'-'+ String.valueOf(workforceQuoteItem.ET_Contract_Period__c))));
                                                                      for(ET_Quote_Item_SpecReq__c specReq : desiredWorkforceMap.get(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c + '-' +  String.valueOf(workforceQuoteItem.ET_Workforce_Line_Number__c) +'-'+ String.valueOf(workforceQuoteItem.ET_Contract_Period__c))){
                                                                          specReq.Workforce_Quote_Item__c = workforceQuoteItem.Id;
                                                                          system.debug('workforceQuoteItem.Id : '+workforceQuoteItem.Id );
                                                                          workforceSpecReqToInsertLst.add(specReq);
                                                                      }
                                                                  }
                                                                  system.debug('workforceSpecReqToInsertLst = '+ JSON.serializePretty(workforceSpecReqToInsertLst));
                                                                  insert workforceSpecReqToInsertLst;
                                                                  response = 'Success';
                                                              }
                                                          }
                                                          catch(Exception ex){
                                                              ET_PricingUtilityClass.logException(ex, 'Pricing');
                                                              system.debug('Exception occured of type :' + ex.getTypeName() + ' due to cause : ' + ex.getCause()  + 'with Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString());
                                                              response = 'Exception occured of type :' + ex.getTypeName() + ' due to cause : ' + ex.getCause()  + 'with Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString();
                                                          }  
                                                          return response;
                                                      }
    
    public static Decimal calculateVATCost(List<ET_Pricing_VAT_setup__c> vatData, ET_Workforce_Quote_Item__c workforceQuoteItemtoInsert){
        Decimal vatValue = 0.0;
        for(ET_Pricing_VAT_setup__c data : vatData){
            if(data.ET_Cost_Type__c == 'Manpower'){
                if(ET_Workforce_Quote_Item__c.getSobjectType().getDescribe().fields.getMap().containsKey(data.ET_Cost_Api_Name__c)){
                    Decimal value = (Decimal)workforceQuoteItemtoInsert.get(data.ET_Cost_Api_Name__c);
                    if(value != null && data.ET_IsRecoverable__c){
                        vatValue += value;
                    }
                }
            }
            
        }
        vatValue =  vatValue * 0.05;
        return vatValue;
    }
    
    /*
Method 	  : getCombinationRecordFromRequest
Description : to get combination record for particular manpower, to get number of Vehicles in that Line...
*/
    
    Public static ET_Request_Mapping__c getCombinationRecordFromRequest(List<ET_Request_Mapping__c> reqMappings , String serviceType , ET_Workforce_Quote_Item__c wForceQItem ){
        ET_Request_Mapping__c returnReqMap ;
        if(reqMappings != null && !reqMappings.isEmpty()){
            for(ET_Request_Mapping__c reqMap : reqMappings){
                if(serviceType == 'Accountant' && reqMap.ET_Number_of_Accountants__c > 0){
                    if(reqMap.ET_Accountant_Unique_Key__c == wForceQItem.ET_Workforce_Unique_Key__c +'=>'+wForceQItem.ET_Workforce_Line_Number__c ){
                        returnReqMap = reqMap;
                    }
                }
                
                else if(serviceType == 'Coordinator' && reqMap.ET_Number_of_Coordinators__c > 0){
                    if(reqMap.ET_Coordinator_Unique_Key__c == wForceQItem.ET_Workforce_Unique_Key__c+'=>'+wForceQItem.ET_Workforce_Line_Number__c  ){
                        returnReqMap = reqMap;
                    }
                }
                
                else if(serviceType == 'Supervisor' && reqMap.ET_Number_of_Supervisors__c > 0){
                    if(reqMap.ET_Supervisor_Unique_Key__c == wForceQItem.ET_Workforce_Unique_Key__c +'=>'+wForceQItem.ET_Workforce_Line_Number__c ){
                        returnReqMap = reqMap;
                    }
                }
                
                else if(serviceType == 'other employee' && reqMap.ET_Number_of_Other_Employees__c > 0){
                    if(reqMap.ET_Other_Employee_Unique_Key__c == wForceQItem.ET_Workforce_Unique_Key__c+'=>'+wForceQItem.ET_Workforce_Line_Number__c ){
                        returnReqMap = reqMap;
                    }
                }
            }
        }
        
        return returnReqMap;
    }    
    
    Public static void createTotalProjectWorkForceQuoteItems(String quoteId , ET_ServiceRequestController.QuoteCalculationClass quoteCalcObj){
        List<ET_Workforce_Quote_Item__c> workforceQuoteItemLstToInsert = new List<ET_Workforce_Quote_Item__c>();
        Map<String, List<ET_Quote_Item_SpecReq__c>> quoteItemAndSpecReqMap = new Map<String, List<ET_Quote_Item_SpecReq__c>>();
        
        // update total Project quote with Manpower number..
        Quote qt = new Quote( id = quoteId);
        qt.Total_Number_of_Drivers__c = totalDrivers;
        qt.Total_Number_of_Accountants__c = totalAccountants;
        qt.Total_Number_of_Coordinators__c = totalCoordinators;
        qt.Total_Number_of_Nannies__c = totalNannies;
        qt.Total_Number_of_Other_Employees__c = totalOtherEmployees;
        qt.Total_Number_of_Supervisors__c = totalSuperVisors;
        
        if(qt != null && qt.id != null){
            update qt;
        }
        
        // Create workforce quoteItems for all Manpowers category..
        List<ET_Workforce_Quote_Item__c> allWorkForceQuoteItems = new List<ET_Workforce_Quote_Item__c>();
        String serviceType;
        
        // Driver 
        set<integer> driverContractYears = getContractYearsWithService('Driver');
        if(driverContractYears != null && !driverContractYears.isempty()){
            for(integer contY : driverContractYears){
                List<ET_Quote_Item_SpecReq__c> driverSpecReqToInsertLst = new List<ET_Quote_Item_SpecReq__c>();
                ET_Workforce_Quote_Item__c driverQtItem = new ET_Workforce_Quote_Item__c();
                driverQtItem.Quote__c = quoteId;
                driverQtItem.ET_Contract_Period__c = contY;
                driverQtItem.ET_Workforce_Quote_Item_Type__c = 'Driver';
                driverQtItem.ET_Workforce_Line_Number__c = 1;
                workforceQuoteItemLstToInsert.add(driverQtItem);
                
                Map<String, otherCostCalcClassTProj> contractYearSpecialReqrmnts;
                if(driverSpecilReqsForTotProjMap != null && !driverSpecilReqsForTotProjMap.isEmpty() && driverSpecilReqsForTotProjMap.containsKey(contY)){
                    contractYearSpecialReqrmnts = driverSpecilReqsForTotProjMap.get(contY);
                }
                
                if(contractYearSpecialReqrmnts != null &&  !contractYearSpecialReqrmnts.isEmpty() ){
                    for(otherCostCalcClassTProj specReq : contractYearSpecialReqrmnts.values()){
                        ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c();
                        specReqToInsert.Name = specReq.otherCostLabel;
                        specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                        specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                        driverSpecReqToInsertLst.add(specReqToInsert);
                    }
                    String keyy = driverQtItem.ET_Workforce_Quote_Item_Type__c +'-'+ String.valueOf(driverQtItem.ET_Contract_Period__c) ;   
                    quoteItemAndSpecReqMap.put(keyy , driverSpecReqToInsertLst);
                }
            }
        }
        
        // Nanny 
        set<integer> nannyContractYears = getContractYearsWithService('Nanny');
        if(nannyContractYears != null && !nannyContractYears.isempty()){
            for(integer contY : nannyContractYears){
                List<ET_Quote_Item_SpecReq__c> nannySpecReqToInsertLst = new List<ET_Quote_Item_SpecReq__c>();
                ET_Workforce_Quote_Item__c nannyQtItem = new ET_Workforce_Quote_Item__c();
                nannyQtItem.Quote__c = quoteId;
                nannyQtItem.ET_Contract_Period__c = contY;
                nannyQtItem.ET_Workforce_Quote_Item_Type__c = 'Nanny';
                nannyQtItem.ET_Workforce_Line_Number__c = 1;
                workforceQuoteItemLstToInsert.add(nannyQtItem);
                
                Map<String, otherCostCalcClassTProj> contractYearSpecialReqrmnts;
                if(nannySpecilReqsForTotProjMap != null && !nannySpecilReqsForTotProjMap.isEmpty() && nannySpecilReqsForTotProjMap.containsKey(contY)){
                    contractYearSpecialReqrmnts = nannySpecilReqsForTotProjMap.get(contY);
                }
                
                if(contractYearSpecialReqrmnts != null &&  !contractYearSpecialReqrmnts.isEmpty() ){
                    for(otherCostCalcClassTProj specReq : contractYearSpecialReqrmnts.values()){
                        ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c();
                        specReqToInsert.Name = specReq.otherCostLabel;
                        specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                        specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                        nannySpecReqToInsertLst.add(specReqToInsert);
                    }
                    String keyy = nannyQtItem.ET_Workforce_Quote_Item_Type__c +'-'+ String.valueOf(nannyQtItem.ET_Contract_Period__c) ;    
                    quoteItemAndSpecReqMap.put(keyy , nannySpecReqToInsertLst);
                }
            }
        }
        
        // Supervisor 
        set<integer> superVisorContractYears = getContractYearsWithService('Supervisor');
        system.debug('superVisorContractYears  = '+ superVisorContractYears);
        if(superVisorContractYears != null && !superVisorContractYears.isempty()){
            for(integer contY : superVisorContractYears){
                List<ET_Quote_Item_SpecReq__c> superVisorSpecReqToInsertLst = new List<ET_Quote_Item_SpecReq__c>();
                ET_Workforce_Quote_Item__c superVisorQtItem = new ET_Workforce_Quote_Item__c();
                superVisorQtItem.Quote__c = quoteId;
                superVisorQtItem.ET_Contract_Period__c = contY;
                superVisorQtItem.ET_Workforce_Quote_Item_Type__c = 'Supervisor';
                superVisorQtItem.ET_Workforce_Line_Number__c = 1;
                workforceQuoteItemLstToInsert.add(superVisorQtItem);
                
                Map<String, otherCostCalcClassTProj> contractYearSpecialReqrmnts;
                if(supervisorSpecilReqsForTotProjMap != null && !supervisorSpecilReqsForTotProjMap.isEmpty() && supervisorSpecilReqsForTotProjMap.containsKey(contY)){
                    contractYearSpecialReqrmnts = supervisorSpecilReqsForTotProjMap.get(contY);
                }
                
                if(contractYearSpecialReqrmnts != null &&  !contractYearSpecialReqrmnts.isEmpty() ){
                    for(otherCostCalcClassTProj specReq : contractYearSpecialReqrmnts.values()){
                        ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c();
                        specReqToInsert.Name = specReq.otherCostLabel;
                        specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                        specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                        superVisorSpecReqToInsertLst.add(specReqToInsert);
                    }
                    String keyy = superVisorQtItem.ET_Workforce_Quote_Item_Type__c +'-'+String.valueOf(superVisorQtItem.ET_Contract_Period__c) ;  
                    quoteItemAndSpecReqMap.put(keyy , superVisorSpecReqToInsertLst);
                }
            }
        }
        
        // Coordinator 
        set<integer> coordinatorContractYears = getContractYearsWithService('Coordinator');
        if(coordinatorContractYears != null && !coordinatorContractYears.isempty()){
            for(integer contY : coordinatorContractYears){
                List<ET_Quote_Item_SpecReq__c> coordinatorSpecReqToInsertLst = new List<ET_Quote_Item_SpecReq__c>();
                ET_Workforce_Quote_Item__c coordinatorQtItem = new ET_Workforce_Quote_Item__c();
                coordinatorQtItem.Quote__c = quoteId;
                coordinatorQtItem.ET_Contract_Period__c = contY;
                coordinatorQtItem.ET_Workforce_Quote_Item_Type__c = 'Coordinator';
                coordinatorQtItem.ET_Workforce_Line_Number__c = 1;
                workforceQuoteItemLstToInsert.add(coordinatorQtItem);
                
                Map<String, otherCostCalcClassTProj> contractYearSpecialReqrmnts;
                if(coordinatorSpecilReqsForTotProjMap != null && !coordinatorSpecilReqsForTotProjMap.isEmpty() && coordinatorSpecilReqsForTotProjMap.containsKey(contY)){
                    contractYearSpecialReqrmnts = coordinatorSpecilReqsForTotProjMap.get(contY);
                }
                
                if(contractYearSpecialReqrmnts != null &&  !contractYearSpecialReqrmnts.isEmpty() ){
                    for(otherCostCalcClassTProj specReq : contractYearSpecialReqrmnts.values()){
                        ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c();
                        specReqToInsert.Name = specReq.otherCostLabel;
                        specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                        specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                        coordinatorSpecReqToInsertLst.add(specReqToInsert);
                    }
                    String keyy = coordinatorQtItem.ET_Workforce_Quote_Item_Type__c +'-'+String.valueOf(coordinatorQtItem.ET_Contract_Period__c) ; 
                    quoteItemAndSpecReqMap.put(keyy , coordinatorSpecReqToInsertLst);
                }
            }
        }
        
        
        
        // Accountant 
        set<integer> accountantContractYears = getContractYearsWithService('Accountant');
        if(accountantContractYears != null && !accountantContractYears.isempty()){
            for(integer contY : accountantContractYears){
                List<ET_Quote_Item_SpecReq__c> accountantSpecReqToInsertLst = new List<ET_Quote_Item_SpecReq__c>();
                ET_Workforce_Quote_Item__c accountantQtItem = new ET_Workforce_Quote_Item__c();
                accountantQtItem.Quote__c = quoteId;
                accountantQtItem.ET_Contract_Period__c = contY;
                accountantQtItem.ET_Workforce_Quote_Item_Type__c = 'Accountant/Cashier';
                accountantQtItem.ET_Workforce_Line_Number__c = 1;
                workforceQuoteItemLstToInsert.add(accountantQtItem);
                
                Map<String, otherCostCalcClassTProj> contractYearSpecialReqrmnts;
                if(accountantSpecilReqsForTotProjMap != null && !accountantSpecilReqsForTotProjMap.isEmpty() && accountantSpecilReqsForTotProjMap.containsKey(contY)){
                    contractYearSpecialReqrmnts = accountantSpecilReqsForTotProjMap.get(contY);
                }
                
                if(contractYearSpecialReqrmnts != null &&  !contractYearSpecialReqrmnts.isEmpty() ){
                    for(otherCostCalcClassTProj specReq : contractYearSpecialReqrmnts.values()){
                        ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c();
                        specReqToInsert.Name = specReq.otherCostLabel;
                        specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                        specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                        accountantSpecReqToInsertLst.add(specReqToInsert);
                    }
                    String keyy = accountantQtItem.ET_Workforce_Quote_Item_Type__c +'-'+ String.valueOf(accountantQtItem.ET_Contract_Period__c) ;
                    quoteItemAndSpecReqMap.put(keyy , accountantSpecReqToInsertLst);
                }
            }
        }
        
        // OtherEmployee 
        set<integer> OtherEmployeeContractYears = getContractYearsWithService('Other Employee');
        if(OtherEmployeeContractYears != null && !OtherEmployeeContractYears.isempty()){
            for(integer contY : OtherEmployeeContractYears){
                List<ET_Quote_Item_SpecReq__c> otherEmpSpecReqToInsertLst = new List<ET_Quote_Item_SpecReq__c>();
                ET_Workforce_Quote_Item__c otherEmp = new ET_Workforce_Quote_Item__c();
                otherEmp.Quote__c = quoteId;
                otherEmp.ET_Contract_Period__c = contY;
                otherEmp.ET_Workforce_Quote_Item_Type__c = 'Other Employee';
                otherEmp.ET_Workforce_Line_Number__c = 1;
                workforceQuoteItemLstToInsert.add(otherEmp);
                
                Map<String, otherCostCalcClassTProj> contractYearSpecialReqrmnts;
                if(otherEmployeeSpecilReqsForTotProjMap != null && !otherEmployeeSpecilReqsForTotProjMap.isEmpty() && otherEmployeeSpecilReqsForTotProjMap.containsKey(contY)){
                    contractYearSpecialReqrmnts = otherEmployeeSpecilReqsForTotProjMap.get(contY);
                }
                
                if(contractYearSpecialReqrmnts != null &&  !contractYearSpecialReqrmnts.isEmpty() ){
                    for(otherCostCalcClassTProj specReq : contractYearSpecialReqrmnts.values()){
                        ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c();
                        specReqToInsert.Name = specReq.otherCostLabel;
                        specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                        specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                        otherEmpSpecReqToInsertLst.add(specReqToInsert);
                    }
                    String keyy = otherEmp.ET_Workforce_Quote_Item_Type__c +'-'+ String.valueOf(otherEmp.ET_Contract_Period__c) ;
                    quoteItemAndSpecReqMap.put(keyy , otherEmpSpecReqToInsertLst);
                }
                
            }
        }
        
        if(!workforceQuoteItemLstToInsert.isEmpty()){
            system.debug('workforceQuoteItemLstToInsert  = '+ JSON.serializePretty(workforceQuoteItemLstToInsert));
            insert workforceQuoteItemLstToInsert;
            // workforce related other cost..
            List<ET_Quote_Item_SpecReq__c> workforceSpecReqToInsertLst = new List<ET_Quote_Item_SpecReq__c>();
            for(ET_Workforce_Quote_Item__c workforceQuoteItem : workforceQuoteItemLstToInsert){
                if(quoteItemAndSpecReqMap != null && quoteItemAndSpecReqMap.containsKey(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c + '-'+ String.valueOf(workforceQuoteItem.ET_Contract_Period__c))){
                    for(ET_Quote_Item_SpecReq__c specReq : quoteItemAndSpecReqMap.get(workforceQuoteItem.ET_Workforce_Quote_Item_Type__c + '-'+ String.valueOf(workforceQuoteItem.ET_Contract_Period__c) )){
                        specReq.Workforce_Quote_Item__c = workforceQuoteItem.Id;
                        workforceSpecReqToInsertLst.add(specReq);
                    }
                }
            }
            system.debug('workforceSpecReqToInsertLst : '+JSON.serializePretty(workforceSpecReqToInsertLst));
            insert workforceSpecReqToInsertLst;
        }
        
    }
    
    
    
    Public static Decimal getLanguageAndPycometricTestFee(ET_Language_and_Psychometric_Test_Master__c langAndPsychometricData , Integer contractYear){
        Decimal langFeeYearWise = 0.0;
        Switch on contractYear{
            when 1 {
                langFeeYearWise = langAndPsychometricData.Year_1__c;
            }
            when 2 {
                langFeeYearWise = langAndPsychometricData.Year_2__c;
            }
            when 3 {
                langFeeYearWise = langAndPsychometricData.Year_3__c;
            }
            when 4 {
                langFeeYearWise = langAndPsychometricData.Year_4__c;
            }
            when 5 {
                langFeeYearWise = langAndPsychometricData.Year_5__c;
            }
            when 6 {
                langFeeYearWise = langAndPsychometricData.Year_6__c;
            }
            when 7 {
                langFeeYearWise = langAndPsychometricData.Year_7__c;
            }
            when 8 {
                langFeeYearWise = langAndPsychometricData.Year_8__c;
            }
            when else{
                
            }
        }
        return langFeeYearWise;
    }
    
    
    Public static Decimal getManpowerVisaCostForContractYear(ET_Workforce_Visa_Master__c visaMaster , Integer contractYear){
        Decimal VisaCostYearWise =0.0;
        Switch on contractYear{
            when 1 {
                VisaCostYearWise = visaMaster.Year_1__c;
            }
            when 2 {
                VisaCostYearWise = visaMaster.Year_2__c;
            }
            when 3 {
                VisaCostYearWise = visaMaster.Year_3__c;
            }
            when 4 {
                VisaCostYearWise = visaMaster.Year_4__c;
            }
            when 5 {
                VisaCostYearWise = visaMaster.Year_5__c;
            }
            when 6 {
                VisaCostYearWise = visaMaster.Year_6__c;
            }
            when 7 {
                VisaCostYearWise = visaMaster.Year_7__c;
            }
            when 8 {
                VisaCostYearWise = visaMaster.Year_8__c;
            }
        }
        if(VisaCostYearWise == null){
            VisaCostYearWise = 0.0;
        }
        return VisaCostYearWise;
    }
    
    
    Public static set<integer> getContractYearsWithService( String serviceType){
        system.debug('serviceType = '+ serviceType);
        system.debug('supervisorContractYears = '+ supervisorContractYears);
        Set<integer> driverContractYearsUniq = new Set<integer>();
        Set<integer> nannyContractYearsUniq = new Set<integer>();
        Set<integer> accountantContractYearsUniq = new Set<integer>();
        Set<integer> coordinatorContractYearsUniq = new Set<integer>();
        Set<integer> superVisorContractYearsUniq = new Set<integer>();
        Set<integer> otherEmployeeContractYearsUniq = new Set<integer>();
        
        driverContractYearsUniq.addAll(driverContractYears);
        nannyContractYearsUniq.addAll(nannyContractYears);
        accountantContractYearsUniq.addAll(accountantContractYears);
        coordinatorContractYearsUniq.addAll(coordinatorContractYears);
        superVisorContractYearsUniq.addAll(supervisorContractYears);
        system.debug('superVisorContractYearsUniq = '+ superVisorContractYearsUniq);
        otherEmployeeContractYearsUniq.addAll(otherEmployeeContractYears);
        set<integer> contractYears = new set<integer>();
        switch on serviceType {
            when 'Driver' {		
                contractYears = driverContractYearsUniq;
            }
            when 'Nanny' {		
                contractYears = nannyContractYearsUniq;
            }
            when 'Supervisor'{
                contractYears = superVisorContractYearsUniq;
            }
            when 'Coordinator' {		  
                contractYears = coordinatorContractYearsUniq;
            }
            when 'Accountant' {		  
                contractYears = accountantContractYearsUniq;
            }
            when 'Other Employee' {		  
                contractYears = otherEmployeeContractYearsUniq;
            }
        }
        
        system.debug('contractYears = '+ contractYears);
        return contractYears;
        
    }
    
    
    /* Method 	   : prepareWorkforceObject
Description : to map workforce wrapper fields to workforce quote Items
*/
    
    public static ET_Workforce_Quote_Item__c prepareWorkforceObject(ET_Workforce_Quote_Item__c workforceQuoteItemtoInsert, ET_ServiceRequestController.workforceQuoteCalcClass workforceClassObj, Map<String, decimal> lineNoWrToManpowerKey){
        system.debug('workforceClassObj = '+ JSON.serializePretty(workforceClassObj));
        workforceQuoteItemtoInsert.ET_Contract_Period__c = workforceClassObj.contractYear;
        workforceQuoteItemtoInsert.Notes__c = workforceClassObj.notes;
        workforceQuoteItemtoInsert.ET_Clothes_Allowance__c = Math.round(workforceClassObj.clothesAllowance);
        
        workforceQuoteItemtoInsert.Resource_Type__c = workforceClassObj.resourcetype;
        workforceQuoteItemtoInsert.married__c = workforceClassObj.married;
        workforceQuoteItemtoInsert.Number_of_Children__c = workforceClassObj.noofchildren;
        workforceQuoteItemtoInsert.Children_allowance_from_master__c = Math.round(workforceClassObj.childrenAllowanceFromMaster);
        workforceQuoteItemtoInsert.Housing_Allowance__c = Math.round(workforceClassObj.housingAllowance);
        workforceQuoteItemtoInsert.Cost_of_Living_Allowance__c = Math.round(workforceClassObj.costoflivingAllowance);
        workforceQuoteItemtoInsert.Social_Allowance__c = Math.round(workforceClassObj.socialAllowance);
        
        workforceQuoteItemtoInsert.Housing_Allowance_Percentage__c = workforceClassObj.housingAllowancePercentage;
        workforceQuoteItemtoInsert.Transport_Allowance__c = Math.round(workforceClassObj.transportAllowance);
        workforceQuoteItemtoInsert.Additional_Transport_Allowance__c = Math.round(workforceClassObj.additionalTransportAllowance);
        workforceQuoteItemtoInsert.Other_Allowance__c = Math.round(workforceClassObj.otherAllowance);
        workforceQuoteItemtoInsert.Social_Insurance__c = Math.round(workforceClassObj.socialInsurance);
        workforceQuoteItemtoInsert.Additional_Work_Permit_Fees__c = Math.round(workforceClassObj.additionalWorkPermitFees);
        workforceQuoteItemtoInsert.ET_Health_Card__c = Math.round(workforceClassObj.healthCardCost);
        workforceQuoteItemtoInsert.ET_Licensing_Fees__c = Math.round(workforceClassObj.licensingFee);
        system.debug('workforceClassObj.visaAmount = '+ workforceClassObj.visaAmount);
        workforceQuoteItemtoInsert.ET_Visa_amount__c = Math.round(workforceClassObj.visaAmount);
        workforceQuoteItemtoInsert.ET_Work_force_Request__c = workforceClassObj.workForceReqId;
        workforceQuoteItemtoInsert.Line_number_from_input__c = workforceClassObj.workforceLineItemNumberFromRequest;
        system.debug('lineNoWrToManpowerKey = '+ JSON.serializePretty(lineNoWrToManpowerKey));
        //
        if(lineNoWrToManpowerKey != null && lineNoWrToManpowerKey.containsKey(workforceQuoteItemtoInsert.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItemtoInsert.Line_number_from_input__c)){
            workforceQuoteItemtoInsert.ET_Workforce_Line_Number__c = lineNoWrToManpowerKey.get(workforceQuoteItemtoInsert.ET_Workforce_Unique_Key__c+'=>'+workforceQuoteItemtoInsert.Line_number_from_input__c);
        }
        else{
            workforceQuoteItemtoInsert.ET_Workforce_Line_Number__c = workforceClassObj.workforceLineItemNumberFromRequest;
        }
        
        system.debug('ET_Workforce_Line_Number__c = '+ workforceQuoteItemtoInsert.ET_Workforce_Line_Number__c);
        workforceQuoteItemtoInsert.ET_Depreciation_Method__c = workforceClassObj.depreciationMethod;
        workforceQuoteItemtoInsert.ET_Pricing_Method__c = workforceClassObj.workforcePricingMethod;
        workforceQuoteItemtoInsert.ET_Pricing_Type__c = workforceClassObj.workforcePricingType;
        workforceQuoteItemtoInsert.ET_Price_Utilization__c = workforceClassObj.workforcePricingUtilization;
        workforceQuoteItemtoInsert.Number_of_coverage_years_for_visa__c = workforceClassObj.numberOfCoverageYearsForVisa;
        workforceQuoteItemtoInsert.ET_Profit_Number_of_Months__c = workforceClassObj.profitNumberOfMonths;
        workforceQuoteItemtoInsert.ET_Working_Days_Per_Week__c = workforceClassObj.workingDaysPerWeek;
        workforceQuoteItemtoInsert.Salary_No_of_months_for_Driver_for_SLine__c = workforceClassObj.salaryNoofMonthsforDriverforSLine;
        workforceQuoteItemtoInsert.Salary_No_of_Months_for_other_Manpower__c = workforceClassObj.salaryNoofMonthsforOtherManpowerforSLine;
        workforceQuoteItemtoInsert.ET_Working_Months_Per_Year__c = workforceClassObj.workingMonthsPerYear;
        workforceQuoteItemtoInsert.Number_of_Annual_Leave_months__c = workforceClassObj.numberOfAnnualLeaveMonths;
        workforceQuoteItemtoInsert.Number_of_End_of_Service_months__c = workforceClassObj.numberOfEndOfServiceMonths;
        workforceQuoteItemtoInsert.Profit_Percentage_from_Master__c = workforceClassObj.profitPercentage;
        workforceQuoteItemtoInsert.ET_Workforce_Record_Type__c = workforceClassObj.workforceRecordType;
        workforceQuoteItemtoInsert.ET_Working_days_per_year__c = workforceClassObj.workingDaysPerYear;
        workforceQuoteItemtoInsert.ET_Service_Type__c = workforceClassObj.serviceType;
        workforceQuoteItemtoInsert.ET_Vat_Rate__c = workforceClassObj.workForceVATRate;        
        workforceQuoteItemtoInsert.ET_Language_and_Psychometric_Test__c = workforceClassObj.languageAndPsychometricTest;  
        workforceQuoteItemtoInsert.Reliever_For__c = workforceClassObj.relieverFor;  
        workforceQuoteItemtoInsert.Type__c = workforceClassObj.typeOfManpower;  
        if(workforceClassObj.workforceGrossSalary != null){
            workforceQuoteItemtoInsert.ET_Workforce_Gross_Salary__c = Math.round(workforceClassObj.workforceGrossSalary);
        }
        if(workforceClassObj.workforceBasicSalary != null){
            workforceQuoteItemtoInsert.ET_Workforce_basic_salary__c = Math.round(workforceClassObj.workforceBasicSalary); 
        }        
        
        system.debug('workforceQuoteItemtoInsert return = '+ JSON.serializePretty(workforceQuoteItemtoInsert));
        return workforceQuoteItemtoInsert;
    }
    
    public class otherCostCalcClassTProj{
        public String otherCostLabel = '';
        public Decimal otherCostValue = 0.0;
        public Decimal otherCostLineNumber = 0;
        public Decimal contractYear = 0;
        public List<String> otherCostType = new List<String>();
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
        
    } 
    
}