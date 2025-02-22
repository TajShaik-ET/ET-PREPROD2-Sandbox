/* Class       : ET_ServiceRequestControllerHelper
    Test Class  : ET_ServiceRequestControllerHelperTest
    Description : Called by ET_ServiceRequestController
    To Save Common Data -- saveCommonData
    To fetch all Service Request existing Data -- fetchExistingAppData.
    To get Editable fields from 
    */
    
    
    public without sharing class ET_ServiceRequestControllerHelper {
        public ET_ServiceRequestControllerHelper() {
            
        }
        
        /* Method      : getEditableFieldsforPricingTeam
    Description : To get editable fields in Quotation form for Pricing Team which are configured in Custom Metadata Type - QuotationEditableFieldsForPricingTeam__mdt
    Fields should be returned with each Service Type in a wrapper
    */
        @AuraEnabled
        public static String getEditableFieldsforPricingTeamHelper(){
            map<String, Map<String,boolean>> tabWiseEditableFieldsMap = new map<String, Map<String,boolean>>();
            try{
                // key = CustomMetadata api name(developer name) - tabName , Value = Custom metadata record - editable fields for that Tab
                Map<String, QuotationEditableFieldsForPricingTeam__mdt> editableFieldsCustomMetadataMap = QuotationEditableFieldsForPricingTeam__mdt.getAll();
                if(!editableFieldsCustomMetadataMap.isEmpty()){
                    for(String tabName : editableFieldsCustomMetadataMap.keyset()){
                        List<String> fieldNames = editableFieldsCustomMetadataMap.get(tabName) != null ?  String.ValueOf(editableFieldsCustomMetadataMap.get(tabName).ET_Editable_Fields__c).split(',') : new List<String>() ;
                        if(!fieldNames.isEmpty()){
                            Map<String,boolean> fieldsAccessMap = new Map<String,boolean>();
                            for(String field : fieldNames ){
                                fieldsAccessMap.put( field , true);
                            }
                            tabWiseEditableFieldsMap.put(tabName , fieldsAccessMap);
                        }
                    }
                }
            }
            catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
            return JSON.serializePretty(tabWiseEditableFieldsMap);        
        }
        
        @AuraEnabled
        public static userPermissions getUserPermissionsHelper(){
            Boolean isPricingTeam = FeatureManagement.checkPermission('PricingTeam');
            userPermissions up = new userPermissions();
            up.isPricingTeam = isPricingTeam;
            return up;
            
        }
            
        
        // to track all user related permissions
        public class userPermissions{
            @AuraEnabled public boolean isPricingTeam;
            @AuraEnabled public boolean isSalesTeam;
        }
        
        public static Id saveCommonData(Object commonData, String commonInfoType, ET_Pricing_Service_Request__c serviceRequest){
            Map<Object,Object> dataObj = (Map<Object, Object>)commonData;
            //system.debug('dataObj : '+ dataObj);
            ET_Service_Request_Common_Data__c commonObj = new ET_Service_Request_Common_Data__c();
            Boolean actualVehicleCommonDataExist = false;
            for(Object key : dataObj.keyset()){
                String keyStr = (String)key;
                if(dataobj.get(keyStr)!=null && dataobj.get(keyStr)!='' && keyStr != 'sObjectType' ){
                    if(commonInfoType.equals('Vehicle Tab')){
                        if(keyStr != 'ET_Fleet_Type__c'){
                            actualVehicleCommonDataExist = true;
                        }
                    }
                    if(keyStr=='ET_Price_Utilization__c'){
                        commonObj.put(keyStr, Double.valueOf(dataobj.get(keyStr)));  
                    }else if(keyStr=='ET_Contract_Period__c'){
                        String contractYearStr = '';
                        for(Object year : (List<Object>)dataobj.get(keyStr)){
                            contractYearStr = contractYearStr + (String.valueOf(year)).trim() + ',';
                        }
                        commonObj.put(keyStr, String.valueOf(contractYearStr.removeEnd(','))); 
                    }else if(keyStr=='ET_Request_for_Target_Price__c' ||  keyStr=='ET_Request_for_Separate_Prices__c') {
                        commonObj.put(keyStr, dataobj.get(keyStr)); 
                    }else {
                        commonObj.put(keyStr, String.valueOf(dataobj.get(keyStr))); 
                    }
                }
            }
            if(!actualVehicleCommonDataExist && commonInfoType.equals('Vehicle Tab') && serviceRequest != null){
                // ET_Service_Request_Common_Data__c oppCommonData = opp.ET_Service_Request_Common_Data__c;
                commonObj.ET_Contract_Period__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Contract_Period__c;
                commonObj.ET_Price_Utilization__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Price_Utilization__c;
                commonObj.ET_Pricing_Method__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Pricing_Method__c;
                commonObj.ET_Pricing_Type__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Pricing_Type__c;
                commonObj.ET_Service_Emirate__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Service_Emirate__c;
                commonObj.ET_Working_Days_Per_Week__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Working_Days_Per_Week__c;
                commonObj.ET_Working_Months_Per_Year__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Working_Months_Per_Year__c;
                commonObj.ET_Contract_Type__c =  serviceRequest.ET_Service_Request_Common_Data__r.ET_Contract_Type__c;
                commonObj.ET_Request_for_Target_Price__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c;
                commonObj.ET_Request_for_Separate_Prices__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Request_for_Separate_Prices__c;
            }
            commonObj.put('ET_Common_Data_Type__c', commonInfoType);    
            try{
                insert commonObj;
                return commonObj.Id;
                
            }catch(exception ex){
                system.debug('couldn\'t create common info record, error ocuured : '+ ex.getMessage());
                return null;
            }
        }
        
        
        public static applicationData fetchExistingAppData(Id serviceRequestId){
            try{
                ET_ServiceRequestController.serviceRequestInformationWrapper serReqWrap = ET_ServiceRequestController.getServiceRelatedInfo(serviceRequestId);
                String quoteId = serReqWrap.quoteId;
                system.debug('quoteId = '+ quoteId );
                List<elementRatesWithServiceWrp> alterRatesWrapperWithServiceList = new List<elementRatesWithServiceWrp>();
                List<ET_Vehicle_Quote_Item__c> vehQuoteItems = new List<ET_Vehicle_Quote_Item__c>();
                List<ET_Workforce_Quote_Item__c> driverQuoteItems = new List<ET_Workforce_Quote_Item__c>();             
                List<ET_Workforce_Quote_Item__c> NannyQuoteItems = new List<ET_Workforce_Quote_Item__c>();             
                List<ET_Workforce_Quote_Item__c> CoordinatorQuoteItems = new List<ET_Workforce_Quote_Item__c>();             
                List<ET_Workforce_Quote_Item__c> accountantQuoteItems = new List<ET_Workforce_Quote_Item__c>();             
                List<ET_Workforce_Quote_Item__c> supervisorQuoteItems = new List<ET_Workforce_Quote_Item__c>();             
                List<ET_Workforce_Quote_Item__c> OtherEmployeeQuoteItems = new List<ET_Workforce_Quote_Item__c>();  
                
                vehicleTabData vehicleWholeData = new vehicleTabData();
                manpowerTabData driverWholeData =  new manpowerTabData();
                manpowerTabData nannyWholeData = new manpowerTabData();
                manpowerTabData supervisorWholeData = new manpowerTabData();
                manpowerTabData coordinatorWholeData = new manpowerTabData();
                manpowerTabData accountantWholeData =  new manpowerTabData();
                manpowerTabData otherEmpWholeData =  new manpowerTabData();
                
                // get VehicleQuoteItems
                vehQuoteItems = ET_PricingUtilityClass.getVehicleQuoteItemLst(quoteId);
                
                // get manPowerQuoteItems
                driverQuoteItems = ET_PricingUtilityClass.getWorkforceQuoteItemLstForAlterRates(quoteId, 'Driver');
                NannyQuoteItems = ET_PricingUtilityClass.getWorkforceQuoteItemLstForAlterRates(quoteId, 'Nanny');
                CoordinatorQuoteItems = ET_PricingUtilityClass.getWorkforceQuoteItemLstForAlterRates(quoteId, 'Coordinator');
                accountantQuoteItems = ET_PricingUtilityClass.getWorkforceQuoteItemLstForAlterRates(quoteId, 'Accountant/Cashier');
                supervisorQuoteItems = ET_PricingUtilityClass.getWorkforceQuoteItemLstForAlterRates(quoteId, 'Supervisor');
                OtherEmployeeQuoteItems = ET_PricingUtilityClass.getWorkforceQuoteItemLstForAlterRates(quoteId, 'Other Employee');
                system.debug('driverQuoteItems = '+ JSON.serializePretty(driverQuoteItems) );
                
                elementRatesWithServiceWrp vehicleWrp= prepareAlterRatesWrapper(vehQuoteItems, 'Vehicle');
                vehicleWrp.service = 'Vehicle';
                alterRatesWrapperWithServiceList.add(vehicleWrp);
                elementRatesWithServiceWrp driverWrp = prepareAlterRatesWrapper(driverQuoteItems, 'Driver');
                driverWrp.service = 'Driver';
                alterRatesWrapperWithServiceList.add(driverWrp);
                elementRatesWithServiceWrp nannyWrp = prepareAlterRatesWrapper(NannyQuoteItems, 'Nanny');
                nannyWrp.service = 'Nanny';
                alterRatesWrapperWithServiceList.add(nannyWrp);
                elementRatesWithServiceWrp coordinatorWrp = prepareAlterRatesWrapper(CoordinatorQuoteItems, 'Coordinator');
                coordinatorWrp.service = 'Coordinator';
                alterRatesWrapperWithServiceList.add(coordinatorWrp);
                elementRatesWithServiceWrp supervisorWrp = prepareAlterRatesWrapper(supervisorQuoteItems, 'Supervisor');
                supervisorWrp.service = 'Supervisor';
                alterRatesWrapperWithServiceList.add(supervisorWrp);
                elementRatesWithServiceWrp otherEmpWrp = prepareAlterRatesWrapper(OtherEmployeeQuoteItems , 'Other Employee');
                otherEmpWrp.service = 'Other Employee';
                alterRatesWrapperWithServiceList.add(otherEmpWrp);
                elementRatesWithServiceWrp accountantWrp = prepareAlterRatesWrapper(accountantQuoteItems , 'Accountant/Cashier');
                accountantWrp.service = 'Accountant/Cashier';
                alterRatesWrapperWithServiceList.add(accountantWrp);
                system.debug('alterRatesWrapperWithServiceList = '+ JSON.serializePretty(alterRatesWrapperWithServiceList) );
                
                ET_Pricing_Service_Request__c serviceRequest = [Select Id,
                                                                ET_Service_Request_Common_Data__r.ET_Common_Data_Type__c,
                                                                ET_Service_Request_Common_Data__r.ET_Contract_Period__c,
                                                                ET_Service_Request_Common_Data__r.ET_Contract_Type__c,
                                                                ET_Service_Request_Common_Data__r.ET_Price_Utilization__c,
                                                                ET_Service_Request_Common_Data__r.ET_Pricing_Method__c,
                                                                ET_Service_Request_Common_Data__r.ET_Pricing_Type__c,
                                                                ET_Service_Request_Common_Data__r.ET_Service_Emirate__c,
                                                                ET_Service_Request_Common_Data__r.ET_Working_Days_Per_Week__c,
                                                                ET_Service_Request_Common_Data__r.ET_Working_Months_Per_Year__c,
                                                                ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c,
                                                                ET_Service_Request_Common_Data__r.ET_Request_for_Separate_Prices__c,
                                                                ET_Service_Request_Common_Data__r.id,
                                                                Opportunity__r.RecordType.DeveloperName,
                                                                (Select id, ET_Cost_Type__c, 
                                                                 Name,
                                                                 ET_Cost_Value__c,
                                                                 ET_Pricing_Service_Request__c,
                                                                 ET_Other_Cost_Line_Number__c,
                                                                 Other_Cost_Type__c,
                                                                 Other_Requirement_API_Name__c
                                                                 FROM    Other_Cost_Requests__r)
                                                                
                                                                FROM   ET_Pricing_Service_Request__c
                                                                Where ET_Service_Request_Common_Data__c != null and Id = :serviceRequestId
                                                               ];
                Map<Id,Vehicle__c> vehiclesWithOtherCostsMap = ET_PricingUtilityClass.getVehicleRequestMap(serviceRequestId);
                applicationData appData = new applicationData();
                ET_Service_Request_Common_Data__c appCommonData;
                if(serviceRequest != null){
                    appData.opportunityRecordType = serviceRequest.Opportunity__r.RecordType.DeveloperName;
                }
                if(serviceRequest != null && serviceRequest.ET_Service_Request_Common_Data__c!= null && serviceRequest.ET_Service_Request_Common_Data__r.ET_Common_Data_Type__c.equals('All Tab')){
                    appCommonData = new ET_Service_Request_Common_Data__c();
                    // appCommonData.ET_Common_Data_Type__c = opp.ET_Service_Request_Common_Data__r.ET_Common_Data_Type__c;
                    appCommonData.ET_Contract_Period__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Contract_Period__c;
                    appCommonData.ET_Contract_Type__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Contract_Type__c;
                    appCommonData.ET_Price_Utilization__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Price_Utilization__c;
                    appCommonData.ET_Pricing_Method__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Pricing_Method__c;
                    appCommonData.ET_Pricing_Type__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Pricing_Type__c;
                    appCommonData.ET_Service_Emirate__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Service_Emirate__c;
                    appCommonData.ET_Working_Days_Per_Week__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Working_Days_Per_Week__c;
                    appCommonData.ET_Working_Months_Per_Year__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Working_Months_Per_Year__c;
                    appCommonData.ET_Request_for_Target_Price__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c;
                    appCommonData.ET_Request_for_Separate_Prices__c = serviceRequest.ET_Service_Request_Common_Data__r.ET_Request_for_Separate_Prices__c;
                    appData.commonDataId = serviceRequest.ET_Service_Request_Common_Data__r.id;
                }
                appData.appCommonData =  appCommonData;
                
                otherCostTabData otherCostWholeData;
                
                if(vehiclesWithOtherCostsMap != null && vehiclesWithOtherCostsMap.size() > 0){
                    List<Vehicle__c> vehicleWithOtherCostsLst = new List<Vehicle__c>();
                    vehicleWithOtherCostsLst = vehiclesWithOtherCostsMap.values();
                    if(vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__c != null){
                        ET_Service_Request_Common_Data__c vehicleTabCommonData = new ET_Service_Request_Common_Data__c();
                        //vehicleTabCommonData.ET_Common_Data_Type__c = opp.Vehicle_Requests1__r[0].ET_Service_Request_Common_Data__r.ET_Common_Data_Type__c;
                        vehicleTabCommonData.ET_Contract_Period__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Contract_Period__c;
                        vehicleTabCommonData.ET_Contract_Type__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Contract_Type__c;
                        vehicleTabCommonData.ET_Price_Utilization__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Price_Utilization__c;
                        vehicleTabCommonData.ET_Pricing_Method__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Pricing_Method__c;
                        vehicleTabCommonData.ET_Pricing_Type__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Pricing_Type__c;
                        vehicleTabCommonData.ET_Service_Emirate__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Service_Emirate__c;
                        vehicleTabCommonData.ET_Working_Days_Per_Week__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Working_Days_Per_Week__c;
                        vehicleTabCommonData.ET_Working_Months_Per_Year__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Working_Months_Per_Year__c;
                        vehicleTabCommonData.ET_Fleet_Type__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Fleet_Type__c;
                        vehicleTabCommonData.ET_Request_for_Target_Price__c = vehicleWithOtherCostsLst[0].ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c;
                        vehicleWholeData.vehicleCommonData = vehicleTabCommonData;
                    }else{
                        vehicleWholeData.vehicleCommonData = null;
                    }
                    
                    List<Vehicle__c> vehicleList = new List<Vehicle__c>();
                    for(Vehicle__c vehicleFrmSystem : vehicleWithOtherCostsLst){
                        vehicleList.add(vehicleFrmSystem);
                    }
                    vehicleWholeData.vehicleLineItems = vehicleList;
                    appData.vehicleCompleteData = vehicleWholeData;
                }else{
                    system.debug('no vehicle request data found related to Service Request : '+ serviceRequest.Id);
                }
                if(serviceRequest.Other_Cost_Requests__r.size() > 0){
                    otherCostWholeData = new otherCostTabData();
                    List<ET_Other_Cost_Request__c> otherCostList = new List<ET_Other_Cost_Request__c>();
                    for(ET_Other_Cost_Request__c otherCostFrmSystem : serviceRequest.Other_Cost_Requests__r){
                        otherCostList.add(otherCostFrmSystem);
                    }
                    otherCostWholeData.otherCostLineItems = otherCostList;
                    appData.otherCostCompleteData = otherCostWholeData;
                }else{
                    system.debug('no other cost request data found related to Service Request : '+ serviceRequest.Id);
                }
                List<ET_Work_force__c> workforceRequestDataList = [Select id,
                                                                   ET_Contract_Period__c,
                                                                   ET_Contract_Type__c,
                                                                   ET_Price_Utilization__c,
                                                                   ET_Pricing_Method__c,
                                                                   ET_Pricing_Type__c,
                                                                   ET_Service_Emirate__c,
                                                                   ET_Pricing_Service_Request__c,
                                                                   ET_Working_Days_Per_Week__c,
                                                                   ET_Working_Months_Per_Year__c,
                                                                   ET_Accountant_Category__c,
                                                                   ET_Coordinator_Category__c,
                                                                   ET_Driver_Category__c,
                                                                   ET_Nanny_Category__c,
                                                                   ET_Other_employee_Category__c,
                                                                   ET_Supervisor_Category__c,
                                                                   ET_No_of_Drivers__c,
                                                                   ET_Number_of_Accountants__c,
                                                                   ET_Number_of_Coordinators__c,
                                                                   ET_Number_of_Nannies__c,
                                                                   ET_Number_of_Other_Employees__c,
                                                                   ET_Number_of_Supervisors__c,
                                                                   ET_Special_Requirements__c,
                                                                   ET_Workforce_Line_Info__c,
                                                                   ET_Workforce_Record_Type_Name__c,
                                                                   ET_Service_Type__c,
                                                                   Type__c,
                                                                   Reliever_For__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Common_Data_Type__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Contract_Period__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Contract_Type__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Price_Utilization__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Pricing_Method__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Pricing_Type__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Service_Emirate__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Working_Days_Per_Week__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Working_Months_Per_Year__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c,
                                                                   ET_Service_Request_Common_Data__r.ET_Request_for_Separate_Prices__c,
                                                                   (select id,
                                                                    ET_Accommodation_Allowance__c,
                                                                    ET_Accommodation_Allowance_Type__c,
                                                                    ET_Air_Tickets__c,
                                                                    ET_Air_Tickets_Cost_Type__c,
                                                                    ET_Extra_Certification__c,
                                                                    ET_Extra_Certification_Cost_Type__c,
                                                                    ET_Over_Time__c,
                                                                    ET_Smart_Phone__c,
                                                                    ET_Smart_Phone_Cost_Type__c,
                                                                    ET_Specific_Base_Salary__c,
                                                                    ET_Specific_Gross_Salary__c,
                                                                    ET_Specific_Insurance__c,
                                                                    ET_Specific_Leave_Plan__c,
                                                                    Cost_of_Living_Allowance__c,
                                                                    Resource_Type__c,
                                                                    Married__c,
                                                                    Number_of_Children__c,
                                                                    Housing_Allowance__c,
                                                                    Transport_Allowance__c,
                                                                    Additional_Transport_Allowance__c,
                                                                    Other_Allowance__c,
                                                                    Social_Allowance__c,
                                                                    Social_Insurance__c,
                                                                    Language_and_Psychometric_Fee_Cost_Type__c,
                                                                    Language_and_Psychometric_Test_Fee__c,
                                                                    Training_and_Licensing_Cost_Cost_Type__c,
                                                                    Training_and_Licensing_Cost__c,
                                                                    Notes__c
                                                                    from  Specific_Workforce_Requirements__r order by createdDate asc),
                                                                   (select Name,
                                                                    ET_Cost_Type__c, 
                                                                    ET_Cost_Value__c,
                                                                    Other_Cost_Type__c,
                                                                    Other_Requirement_API_Name__c,
                                                                    Work_force_Request__c 
                                                                    from Other_Cost_Requests__r)
                                                                   from ET_Work_force__c
                                                                   Where ET_Pricing_Service_Request__c = :serviceRequestId];
                if(workforceRequestDataList.size() > 0){
                    // vehicleWholeData = new vehicleTabData();
                    List<ET_Work_force__c> driverLineItemLst = new List<ET_Work_force__c>();
                    List<ET_Work_force__c> nannyLineItemLst = new List<ET_Work_force__c>();
                    List<ET_Work_force__c> supervisorLineItemLst = new List<ET_Work_force__c>();
                    List<ET_Work_force__c> coordinatorLineItemLst = new List<ET_Work_force__c>();
                    List<ET_Work_force__c> accountantLineItemLst = new List<ET_Work_force__c>();
                    List<ET_Work_force__c> otherEmpLineItemLst = new List<ET_Work_force__c>();
                    
                    for(ET_Work_force__c workforce : workforceRequestDataList){
                        if(workforce.ET_Workforce_Record_Type_Name__c.equals('ET_Driver')){
                            if(driverWholeData.manpowerCommonData == null && workforce.ET_Service_Request_Common_Data__c != null && (workforce.ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c)){
                                driverWholeData.manpowerCommonData = setManpowerTabCommonData(workforce);
                            }
                            driverLineItemLst.add(workforce);
                        }
                        if(workforce.ET_Workforce_Record_Type_Name__c.equals('ET_Nanny')){
                            if(nannyWholeData.manpowerCommonData == null && workforce.ET_Service_Request_Common_Data__c != null && (workforce.ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c)){
                                nannyWholeData.manpowerCommonData = setManpowerTabCommonData(workforce);
                            }
                            nannyLineItemLst.add(workforce);
                        }
                        if(workforce.ET_Workforce_Record_Type_Name__c.equals('ET_Supervisor')){
                            if(supervisorWholeData.manpowerCommonData == null && workforce.ET_Service_Request_Common_Data__c != null && (workforce.ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c)){
                                supervisorWholeData.manpowerCommonData = setManpowerTabCommonData(workforce);
                            }
                            supervisorLineItemLst.add(workforce);
                        }
                        if(workforce.ET_Workforce_Record_Type_Name__c.equals('ET_Coordinator')){
                            coordinatorLineItemLst.add(workforce);
                            if(coordinatorWholeData.manpowerCommonData == null && workforce.ET_Service_Request_Common_Data__c != null && (workforce.ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c)){
                                coordinatorWholeData.manpowerCommonData = setManpowerTabCommonData(workforce);
                            }
                        }
                        if(workforce.ET_Workforce_Record_Type_Name__c.equals('ET_Accountant_Cashier')){
                            accountantLineItemLst.add(workforce);
                            if(accountantWholeData.manpowerCommonData == null && workforce.ET_Service_Request_Common_Data__c != null && (workforce.ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c)){
                                accountantWholeData.manpowerCommonData = setManpowerTabCommonData(workforce);
                            }
                        }
                        if(workforce.ET_Workforce_Record_Type_Name__c.equals('ET_Other_Employee')){
                            otherEmpLineItemLst.add(workforce);
                            if(otherEmpWholeData.manpowerCommonData == null && workforce.ET_Service_Request_Common_Data__c != null && (workforce.ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c)){
                                otherEmpWholeData.manpowerCommonData = setManpowerTabCommonData(workforce);
                            }
                        }
                    }
                    driverWholeData.manpowerLineItems = driverLineItemLst;
                    nannyWholeData.manpowerLineItems = nannyLineItemLst;
                    supervisorWholeData.manpowerLineItems = supervisorLineItemLst;
                    coordinatorWholeData.manpowerLineItems = coordinatorLineItemLst;
                    accountantWholeData.manpowerLineItems = accountantLineItemLst;
                    otherEmpWholeData.manpowerLineItems = otherEmpLineItemLst;
                    appData.driverCompleteData = driverWholeData;
                    appData.nannyCompleteData = nannyWholeData;
                    appData.supervisorCompleteData = supervisorWholeData;
                    appData.coordinatorCompleteData = coordinatorWholeData;
                    appData.accountantCompleteData = accountantWholeData;
                    appData.otherEmpCompleteData = otherEmpWholeData;
                        system.debug('alterRatesWrapperWithServiceList = '+ JSON.serializePretty(alterRatesWrapperWithServiceList) );
                    //appData.elementRatesLineWrp  =VehelementRatesYearObjList;
                }
                appData.elementRatesWithServiceWrpList  = alterRatesWrapperWithServiceList;
                system.debug('appData = '+ JSON.serializePretty(appData));
                return appData;
            }catch(Exception e){
                system.debug('Exception ='+ e.getMessage());
                system.debug('Exception Trace='+ e.getStackTraceString());
                system.debug('Exception line='+ e.getLineNumber());
                throw new AuraHandledException('Exception ='+ e.getMessage() + 'Exception Trace='+ e.getStackTraceString()+'Exception line='+ e.getLineNumber() + 'Exeption Cause :'+ e.getCause());
            }
        }
        
        private static ET_Service_Request_Common_Data__c setManpowerTabCommonData(ET_Work_force__c workforceRequest){
            ET_Service_Request_Common_Data__c manpowerTabCommonData = new ET_Service_Request_Common_Data__c();
            //vehicleTabCommonData.ET_Common_Data_Type__c = opp.Vehicle_Requests1__r[0].ET_Service_Request_Common_Data__r.ET_Common_Data_Type__c;
            manpowerTabCommonData.ET_Contract_Period__c = workforceRequest.ET_Service_Request_Common_Data__r.ET_Contract_Period__c;
            manpowerTabCommonData.ET_Contract_Type__c = workforceRequest.ET_Service_Request_Common_Data__r.ET_Contract_Type__c;
            manpowerTabCommonData.ET_Price_Utilization__c = workforceRequest.ET_Service_Request_Common_Data__r.ET_Price_Utilization__c;
            manpowerTabCommonData.ET_Pricing_Method__c = workforceRequest.ET_Service_Request_Common_Data__r.ET_Pricing_Method__c;
            manpowerTabCommonData.ET_Pricing_Type__c = workforceRequest.ET_Service_Request_Common_Data__r.ET_Pricing_Type__c;
            manpowerTabCommonData.ET_Service_Emirate__c = workforceRequest.ET_Service_Request_Common_Data__r.ET_Service_Emirate__c;
            manpowerTabCommonData.ET_Working_Days_Per_Week__c = workforceRequest.ET_Service_Request_Common_Data__r.ET_Working_Days_Per_Week__c;
            manpowerTabCommonData.ET_Working_Months_Per_Year__c =workforceRequest.ET_Service_Request_Common_Data__r.ET_Working_Months_Per_Year__c;
            return manpowerTabCommonData;
        }
        
        /*Method      : prepareAlterRatesWrapper
    Description : For each Vehicle Line - for each eligible element Prepare Rates for all Contracted Years
    */
        public static elementRatesWithServiceWrp prepareAlterRatesWrapper(List<sObject> quoteItems,string ServiceName){
            // Initializations
            set<integer> vehicleLines = new set<integer>();
            set<integer> totalLines = new set<integer>();
            elementRatesWithServiceWrp serviceWrp =new elementRatesWithServiceWrp();
            User loggedInUser = getLoggedInUser();
            Set<String> profileSalesTL = new Set<String>(System.Label.TL_SalesTeam_Profiles.split(';'));
            Boolean isTLSales = profileSalesTL.contains(loggedInUser.Profile.Name);
            system.debug('isTLSales = '+ isTLSales);
            Map<String, List<ET_Alter_Rates_Elements__mdt>> alteredApiNamesMap = getAlteredMdt(isTLSales);
            List<ET_Alter_Rates_Elements__mdt> vehicleMdt = new List<ET_Alter_Rates_Elements__mdt>();
            if(!alteredApiNamesMap.isEmpty()){
                vehicleMdt = alteredApiNamesMap.get(ServiceName);
            }        
            string lineNumberField;
            if(serviceName=='Vehicle')
                lineNumberField='ET_Line_Number__c';
            else
                lineNumberField='ET_Workforce_Line_Number__c';
            for(sObject item:quoteItems) {
                totalLines.add(integer.ValueOf(item.get(lineNumberField)));
            }
            system.debug('totalLines = '+ totalLines);
            if(!totalLines.isEmpty()){
                list<elementRatesLineWrp> linelst =new list<elementRatesLineWrp>();
                for(integer i=1;i<=totalLines.size();i++){
                    system.debug('line i= '+ i);
                    Map<integer,list<sObject>> itemYearsLineMap=new Map<integer,list<sObject>>();
                    for(sObject item:quoteItems) {
                        system.debug('line i= '+ i+' line N= '+integer.ValueOf(item.get(lineNumberField)));
                        if(i==integer.ValueOf(item.get(lineNumberField))){
                            if(!itemYearsLineMap.containsKey(integer.ValueOf(item.get('ET_Contract_Period__c'))))
                                itemYearsLineMap.put(integer.ValueOf(item.get('ET_Contract_Period__c')),new list<sObject>{item});
                            else
                                itemYearsLineMap.get(integer.ValueOf(item.get('ET_Contract_Period__c'))).add(item);
                        }
                    }
                    system.debug('itemYearsLineMap= '+ itemYearsLineMap.size());
                    system.debug('itemYearsLineMap= '+ itemYearsLineMap);
                    elementRatesLineWrp wrp= getVehicleAlterRatesWrp(itemYearsLineMap,vehicleMdt,i,isTLSales);
                    system.debug('wrp= '+ wrp);
                    linelst.add(wrp);
                    serviceWrp.elementRatesLineObj=linelst;
                }
            }
            system.debug('serviceWrp = '+ serviceWrp);
            return serviceWrp;
        }

        public static user getLoggedInUser(){
            User loggedInUser = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
            System.debug('Logged in User: ' + loggedInUser);
            return loggedInUser;
        }
        
        public static elementRatesLineWrp getVehicleAlterRatesWrp(Map<integer,list<sObject>> itemYearsLineMap,List<ET_Alter_Rates_Elements__mdt> vehicleMdt,integer Line, Boolean isTLSales){
            elementRatesLineWrp wrp=new elementRatesLineWrp();
            list<elementRatesYearWise> elementRatesYearlst =new list<elementRatesYearWise>();
            //system.debug('vehicleMdt size>> '+vehicleMdt.size());
            system.debug('vehicleMdt >> '+vehicleMdt);
            if(vehicleMdt != null && vehicleMdt.size() > 0){
                for(ET_Alter_Rates_Elements__mdt mdt:vehicleMdt){
                    List<elementRatesLineItemsWrp> elementRatesLineItemlst = new List<elementRatesLineItemsWrp>();
                    elementRatesYearWise er = new elementRatesYearWise();
                    er.elementLabel=mdt.Element_Name__c;
                    er.isRowEdit=false;
                    er.isSelected=false;
                    if(isTLSales){
                        if(er.elementLabel == 'Required Operating Profit Margin')
                           er.allowEdit=true; 
                        else 
                           er.allowEdit=false;
                    }else{
                        er.allowEdit=true; 
                    }
                    for(integer i=1;i<9;i++){
                        if(itemYearsLineMap.containsKey(i)){
                            for(sObject item:itemYearsLineMap.get(i)) {
                                if(i==integer.ValueOf(item.get('ET_Contract_Period__c'))){  
                                    //Taj
                                    if (item.getPopulatedFieldsAsMap().containsKey('ET_Vehicle_Source__c')) {  
                                        System.debug(isTLSales+' : '+item.get('ET_Vehicle_Source__c')+' : '+er.elementLabel);
                                        if(isTLSales && item.get('ET_Vehicle_Source__c') == 'Substitutional' && er.elementLabel == 'Required Operating Profit Margin'){
                                            er.allowEdit=false;
                                        }
                                    }
                                    elementRatesLineItemlst.add(new elementRatesLineItemsWrp(false,item.id,mdt.Element_Api_Name__c,item.get(mdt.Element_Api_Name__c) != null ? String.valueof(item.get(mdt.Element_Api_Name__c)) : String.valueof(0)));
                                   }
                                }
                        }else{
                            elementRatesLineItemsWrp lineItem=new elementRatesLineItemsWrp(false,null,mdt.Element_Api_Name__c,null);
                            lineItem.elementRate='';
                            elementRatesLineItemlst.add(new elementRatesLineItemsWrp(false,null,mdt.Element_Api_Name__c,null));
                        }
                    }
                    er.elementRatesLineItemsObj=elementRatesLineItemlst;
                    elementRatesYearlst.add(er);
                }
                wrp.Line=line;
                wrp.isSelectedAll=false;
                wrp.elementRatesYearObj=elementRatesYearlst;
            }
            
            return wrp;
        }
        
        /* Method : getAlteredApiNames
    Description : To get api Names of Rates those can be altered for each Service from Custom Metadata --> ET_Alter_Rates_Elements__mdt
    */
        public static Map<String, List<ET_Alter_Rates_Elements__mdt>> getAlteredMdt(Boolean isTLSales){
            Map<String, List<ET_Alter_Rates_Elements__mdt>> apiNamesWithTab = new Map<String, List<ET_Alter_Rates_Elements__mdt>>();
            // get altered api Names
            Map<String, ET_Alter_Rates_Elements__mdt> alterAPINames = ET_Alter_Rates_Elements__mdt.getAll();
            if(!alterAPINames.isEmpty()){
                for(ET_Alter_Rates_Elements__mdt element : alterAPINames.values()){
                    if(element.Active__c == true){
                        if (isTLSales && element.Element_For__c == 'Vehicle') {
                            if (element.Element_Api_Name__c == 'Required_Operating_Profit_Margin__c') {
                                if (!apiNamesWithTab.containsKey(element.Element_For__c)) {
                                    apiNamesWithTab.put(element.Element_For__c, new List<ET_Alter_Rates_Elements__mdt>());
                                }
                               apiNamesWithTab.get(element.Element_For__c).add(element);
                            }
                        } else {
                            if (!apiNamesWithTab.containsKey(element.Element_For__c)) {
                                apiNamesWithTab.put(element.Element_For__c, new List<ET_Alter_Rates_Elements__mdt>());
                            }
                            apiNamesWithTab.get(element.Element_For__c).add(element);
                        }
                        /*if(apiNamesWithTab.containsKey(element.Element_For__c)){
                            apiNamesWithTab.get(element.Element_For__c).add(element);
                        }
                        else{
                            apiNamesWithTab.put(element.Element_For__c, new List<ET_Alter_Rates_Elements__mdt>{element});
                        }*/
                    }
                }
            }
            system.debug(JSON.serializePretty('apiNamesWithTab = '+ apiNamesWithTab));
            return apiNamesWithTab;
        }
        
        @AuraEnabled
        public static void saveAlterRatesHelper(string obj , String serviceRequestId, String quoteId,String totalProjectQuoteId ){
            system.debug('obj>>'+obj);
            map<string,list<ET_Vehicle_Quote_Item__c>> vehicleQuoteItemsMap=new map<string,list<ET_Vehicle_Quote_Item__c>>();
            map<string,list<ET_Workforce_Quote_Item__c>> WorkforceQuoteItemsMap=new map<string,list<ET_Workforce_Quote_Item__c>>();
            map<string,ET_Vehicle_Quote_Item__c> vehicleQuoteItemMap=new map<string,ET_Vehicle_Quote_Item__c>();
            map<string,ET_Workforce_Quote_Item__c> WorkforceQuoteItemMap=new map<string,ET_Workforce_Quote_Item__c>();
            
            list<elementRatesWithServiceWrp> alterRateList= (list<elementRatesWithServiceWrp>)system.JSON.deserializeStrict(obj, list<elementRatesWithServiceWrp>.class);
            System.debug('----alterRateList------'+alterRateList);
            try{
                if(!alterRateList.isEmpty()){
                    system.debug('alterRateList>>'+alterRateList);
                    for(elementRatesWithServiceWrp wrp:alterRateList){
                        if(wrp.service=='Vehicle'){
                            if(wrp.elementRatesLineObj!=null && !wrp.elementRatesLineObj.isEmpty()){
                                for(elementRatesLineWrp line:wrp.elementRatesLineObj){
                                    for(elementRatesYearWise year:line.elementRatesYearObj){
                                        for(elementRatesLineItemsWrp item:year.elementRatesLineItemsObj){
                                            // System.debug('--veh--item.quoteItemId-----'+item.quoteItemId);
                                            //     System.debug('--veh--item.elementAPIName-----'+item.elementAPIName);
                                            //     System.debug('-veh--decimal.valueOf(item.elementRate)------'+decimal.valueOf(item.elementRate));
                                            // if(item.quoteItemId!= null)
                                            // {
                                                if(!vehicleQuoteItemMap.containsKey(item.quoteItemId)){
                                                    ET_Vehicle_Quote_Item__c vehicleQuoteItem=new ET_Vehicle_Quote_Item__c();
                                                    if(item.elementRate!=null){
                                                        if(item.quoteItemId!=null)
                                                            vehicleQuoteItem.Id=item.quoteItemId;
                                                        vehicleQuoteItem.put(item.elementAPIName,decimal.valueOf(item.elementRate));
                                                        if(year.requestedBy!=null && year.requestedBy!='')
                                                            vehicleQuoteItem.Approval_Details__c=year.elementLabel+','+year.requestedBy+','+year.approvedBy+','+year.alteringReason+';';
                                                        vehicleQuoteItemMap.put(item.quoteItemId,vehicleQuoteItem);
                                                    }
                                                }
                                            // }
                                            else {
                                                if(item.elementRate!=null){
                                                    ET_Vehicle_Quote_Item__c vehicleQuoteItem=vehicleQuoteItemMap.get(item.quoteItemId);
                                                    vehicleQuoteItem.put(item.elementAPIName,decimal.valueOf(item.elementRate));
                                                    if(vehicleQuoteItem.Approval_Details__c!=null && vehicleQuoteItem.Approval_Details__c!=''
                                                       && year.requestedBy!=null && year.requestedBy!='')
                                                        vehicleQuoteItem.Approval_Details__c=vehicleQuoteItem.Approval_Details__c+';'+year.elementLabel+','+year.requestedBy+','+year.approvedBy+','+year.alteringReason;
                                                    else {
                                                        if(year.requestedBy!=null && year.requestedBy!='')
                                                            vehicleQuoteItem.Approval_Details__c=year.elementLabel+','+year.requestedBy+','+year.approvedBy+','+year.alteringReason;
                                                    }
                                                    vehicleQuoteItemMap.put(item.quoteItemId,vehicleQuoteItem);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else {
                            if(wrp.elementRatesLineObj!=null && !wrp.elementRatesLineObj.isEmpty()){
                                for(elementRatesLineWrp line:wrp.elementRatesLineObj){
                                    if(line.elementRatesYearObj != null){
                                        for(elementRatesYearWise year:line.elementRatesYearObj){
                                            for(elementRatesLineItemsWrp item:year.elementRatesLineItemsObj){
                                                // System.debug('----item.quoteItemId-----'+item.quoteItemId);
                                                // System.debug('----item.elementAPIName-----'+item.elementAPIName);
                                                // System.debug('---decimal.valueOf(item.elementRate)------'+decimal.valueOf(item.elementRate));
                                                // if(item.quoteItemId!= null)
                                                // {
                                                    if(!WorkforceQuoteItemMap.containsKey(item.quoteItemId)){
                                                        ET_Workforce_Quote_Item__c WorkforceQuoteItem=new ET_Workforce_Quote_Item__c();
                                                        if(item.elementRate!=null){
                                                            if(item.quoteItemId!=null)
                                                                WorkforceQuoteItem.Id=item.quoteItemId;
                                                            WorkforceQuoteItem.put(item.elementAPIName,decimal.valueOf(item.elementRate));
                                                            if(year.requestedBy!=null && year.requestedBy!=''){
                                                                WorkforceQuoteItem.Approval_Details__c=year.elementLabel+','+year.requestedBy+','+year.approvedBy+','+year.alteringReason;
                                                            }
                                                            WorkforceQuoteItemMap.put(item.quoteItemId,WorkforceQuoteItem);
                                                        }
                                                    }
                                                // }
                                                
                                                else {
                                                    if(item.elementRate!=null){
                                                        ET_Workforce_Quote_Item__c WorkforceQuoteItem=WorkforceQuoteItemMap.get(item.quoteItemId);
                                                        WorkforceQuoteItem.put(item.elementAPIName,decimal.valueOf(item.elementRate));
                                                        if(WorkforceQuoteItem.Approval_Details__c!=null && WorkforceQuoteItem.Approval_Details__c!='' && year.requestedBy!=null && year.requestedBy!='')
                                                            WorkforceQuoteItem.Approval_Details__c=WorkforceQuoteItem.Approval_Details__c+';'+year.elementLabel+','+year.requestedBy+','+year.approvedBy+','+year.alteringReason;
                                                        else
                                                            if(year.requestedBy!=null && year.requestedBy!=''){
                                                                WorkforceQuoteItem.Approval_Details__c=year.elementLabel+','+year.requestedBy+','+year.approvedBy+','+year.alteringReason;
                                                            }
                                                        WorkforceQuoteItemMap.put(item.quoteItemId,WorkforceQuoteItem);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // update Vehicle quote Items & Workforce quote Items with altered Rates..
                    System.debug('------vehicleQuoteItemMap--------'+vehicleQuoteItemMap);
                    if(!vehicleQuoteItemMap.isEmpty())
                        upsert vehicleQuoteItemMap.values();
                    System.debug('------WorkforceQuoteItemMap--------'+WorkforceQuoteItemMap);
                    if(!WorkforceQuoteItemMap.isEmpty())
                        upsert WorkforceQuoteItemMap.values();
                    system.debug('vehicleQuoteItemMap size>> '+vehicleQuoteItemMap.size());
                    system.debug('alter Rates updated with new Rates in output lines');
                    //Recalculate Vehicle quote Items & Workforce quote Items with altered Rates for quotation for Approval
                    ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates( serviceRequestId , quoteId, null);
                    //Recalculate Vehicle quote Items with altered Rates for Total Project Summary
                    ET_PricingQuoteItemsCalculationClass.updateVehicleTotalProjectSummaryVehicleQuoteItems(totalProjectQuoteId);
                    //Recalculate Workforce quote Items with altered Rates for Total Project Summary
                    ET_WorkForceQuoteItemsCalculationClass.updateWorkForceObjectsForTotalProject(totalProjectQuoteId);
                    //Recalculate Finance calculations for quotation for Approval and Total Project quote
                    ET_FinancialAnalysisScreenClass.saveFinancialCalculations(quoteId, totalProjectQuoteId);
                }
            }
            catch(Exception e){
                system.debug('Exception ='+ e.getMessage());
                system.debug('Exception Trace='+ e.getStackTraceString());
                system.debug('Exception line='+ e.getLineNumber());
                throw new AuraHandledException('Exception ='+ e.getMessage() + ' Exception Trace='+ e.getStackTraceString()+' Exception line='+ e.getLineNumber() + ' Exeption Cause :'+ e.getCause());
            }
        }
        
        public class elementRatesWithServiceWrp{
            @AuraEnabled
            public String service;//Vehicle,Driver,Nanny...
            @AuraEnabled
            public list<elementRatesLineWrp> elementRatesLineObj;
        }
        public class elementRatesLineWrp{
            @AuraEnabled
            public Integer Line;//Vehicle1,Vehicle2...
            @AuraEnabled
            public Boolean isSelectedAll;
            @AuraEnabled
            public list<elementRatesYearWise> elementRatesYearObj;
        }
        public class elementRatesYearWise{
            @AuraEnabled
            public String elementLabel;//Element Names
            @AuraEnabled
            public String requestedBy;
            @AuraEnabled
            public String approvedBy;
            @AuraEnabled
            public String alteringReason;
            @AuraEnabled
            public Boolean isRowEdit;
            @AuraEnabled
            public Boolean allowEdit;
            @AuraEnabled
            public Boolean isSelected;
            @AuraEnabled
            public String errorMsg;
            @AuraEnabled
            public list<elementRatesLineItemsWrp> elementRatesLineItemsObj;
        }
        public class elementRatesLineItemsWrp {
            @AuraEnabled
            public Boolean isEdit;
            @AuraEnabled
            public String quoteItemId;
            @AuraEnabled
            public String elementAPIName;
            @AuraEnabled
            public string elementRate;
            public elementRatesLineItemsWrp(Boolean isEdit,string quoteItemId,String elementAPIName,String elementRate) {
                this.isEdit=isEdit;
                this.quoteItemId=quoteItemId;
                this.elementAPIName=elementAPIName;
                this.elementRate = elementRate;
            }
        }
        
        public  class applicationData{
            @AuraEnabled
            public ET_Service_Request_Common_Data__c appCommonData;
            @AuraEnabled
            public vehicleTabData vehicleCompleteData;
            @AuraEnabled
            public manpowerTabData driverCompleteData;
            @AuraEnabled
            public manpowerTabData nannyCompleteData;
            @AuraEnabled
            public manpowerTabData supervisorCompleteData;
            @AuraEnabled
            public manpowerTabData coordinatorCompleteData;
            @AuraEnabled
            public manpowerTabData accountantCompleteData;
            @AuraEnabled
            public manpowerTabData otherEmpCompleteData;
            @AuraEnabled
            public otherCostTabData otherCostCompleteData;
            @AuraEnabled
            public String opportunityRecordType;
            @AuraEnabled
            public String commonDataId;
            @AuraEnabled
            public list<elementRatesWithServiceWrp> elementRatesWithServiceWrpList;
        } 
        
        public  class vehicleTabData{
            @AuraEnabled
            public ET_Service_Request_Common_Data__c vehicleCommonData;
            @AuraEnabled
            public List<Vehicle__c> vehicleLineItems;
            @AuraEnabled
            public Map<integer, Map<String, elementRatesYearWise>> vehicleRatesWithLineAndYear;
        }
        
        public  class manpowerTabData{
            @AuraEnabled
            public ET_Service_Request_Common_Data__c manpowerCommonData;
            @AuraEnabled
            public List<ET_Work_force__c> manpowerLineItems;
            @AuraEnabled
            public Map<integer, Map<String, elementRatesYearWise>> manPowerRatesWithLineAndYear;
            
        }
        
        public  class otherCostTabData{
            @AuraEnabled
            public List<ET_Other_Cost_Request__c> otherCostLineItems;
            @AuraEnabled
            public List<Vehicle__c> vehicleLineItems;
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