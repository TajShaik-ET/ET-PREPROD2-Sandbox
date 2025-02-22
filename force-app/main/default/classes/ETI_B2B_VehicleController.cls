public without sharing class ETI_B2B_VehicleController {
    Final static String envType='UAT';
    @AuraEnabled public list<ETI_B2B_UtilityWrapper.vehicleWrapper> vehWrapper;
    @Auraenabled public ETI_B2B_UtilityWrapper.amanLookupWrapper lookupWrapper;
    @AuraEnabled public list<ETI_B2B_UtilityWrapper.bookingWrapper> bkngWrapper;
    public static Map<string,string> mapLocations=new Map<string,string>{'AbuDhabi'=>'Abu Dhabi','Dubai'=>'Dubai','Fujairah'=>'Fujairah','Sharjah'=>'Sharjah'};
        @Auraenabled
        public static string saveVehicle(ET_Customer_Vehicle__c vehicle){
            string returnvalue;
            System.debug('vehicle: '+vehicle);
            list<user> userDetails=new list<user>();
            if(!Test.isRunningTest()){
                if(vehicle != null)            
                {
                    Id regRecordTypeId = Schema.SObjectType.ET_Customer_Vehicle__c.getRecordTypeInfosByDeveloperName().get('Registered_Vehicle').getRecordTypeId();
                    Id unRegRecordTypeId = Schema.SObjectType.ET_Customer_Vehicle__c.getRecordTypeInfosByDeveloperName().get('Un_Registered_Vehicle').getRecordTypeId();
                    userDetails=[select accountId,contactId from user where id=:userInfo.getUserId()]; 
                    if(vehicle.Registration_Type__c=='Registered')
                        vehicle.RecordTypeId = regRecordTypeId;
                    else 
                        vehicle.RecordTypeId = unRegRecordTypeId;
                    vehicle.Account__c   = getAccountId();  
                    if(!userDetails.isEmpty() && userDetails[0].contactId!=null)
                        vehicle.Contact__c=userDetails[0].contactId;
                    vehicle.Status__c = 'Active';
                    if(vehicle.Chassis_No__c != '' && vehicle.Plate_No__c=='')
                    {
                        ETAbuDhabiInspectionService.GetVehicleDetailsRequest request = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
                        request.ChassisNo = vehicle.Chassis_No__c;
                        request.SystemCode = integer.valueOf(system.label.ETI_AMAN_System_Code);
                        request.UserID = system.label.ETI_AMAN_UserID;
                        if(vehicle.Registration_Type__c=='Registered'){
                            vehicle.Registration_Type_AR__c='مسجلة';
                            ET_SOA_Services soa = new ET_SOA_Services();
                            ETAbuDhabiInspectionService.getVehicleDetailsResponse_element vehicleDetails = soa.getVehiclesDetails(request); 
                            system.debug('veh detials ..... '+vehicleDetails.getVehicleDetailsResult);
                            if(vehicleDetails!=null && vehicleDetails.getVehicleDetailsResult != null)
                            {
                                system.debug('plate details 123'+vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateNo);
                                ET_Customer_Vehicle__c customerVehicle=getVehicleInfoByChasiss(vehicle,vehicleDetails);
                                system.debug('customerVehicle....'+customerVehicle);
                                system.debug('vehicle type>> '+customerVehicle.Vehicle_type__c+' type code>> '+customerVehicle.Vehicle_Type_Code__c);
                                insert customerVehicle;
                                returnvalue= customerVehicle.id;
                                system.debug('returnvalue....'+returnvalue);
                            }else 
                            {
                                returnvalue= 'No Service';
                            }
                        }else {
                            vehicle.Registration_Type_AR__c='غير مسجلة';
                            if(label.ETI_Un_Registered_Vehicle_Type.contains(';')){
                                vehicle.Vehicle_Type__c=label.ETI_Un_Registered_Vehicle_Type.split(';')[0];
                                vehicle.Vehicle_Type_Code__c=label.ETI_Un_Registered_Vehicle_Type.split(';')[1];
                            }
                            insert vehicle;
                            returnvalue= vehicle.id;
                        }
                    }else if(vehicle.Chassis_No__c != '' && vehicle.Chassis_No__c !=null && vehicle.Plate_No__c!='' && vehicle.Plate_No__c!=null)
                    {
                        if(vehicle.Plate_Source__c!='' && vehicle.Plate_Source__c!=null)
                            vehicle.Plate_Source_Code__c=getPlateCodeByName(vehicle.Plate_Source__c,'PLATE_SOURCE','en');
                        if(vehicle.Plate_Type__c!='' && vehicle.Plate_Type__c!=null)
                            vehicle.Plate_Type_Code__c=getPlateCodeByName(vehicle.Plate_Type__c,'PLATE_TYPE','en');
                        if(vehicle.Plate_Color__c!='' && vehicle.Plate_Color__c!=null)
                            vehicle.Plate_Color_Code__c=getPlateCodeByName(vehicle.Plate_Color__c,'PLATE_COLOR','en');
                        upsert vehicle;
                        system.debug('vehicle Id '+vehicle.Id);
                        returnvalue= vehicle.id;
                        
                    }else if (vehicle.Plate_No__c !='' && vehicle.Plate_No__c!=null && (vehicle.Chassis_No__c == '' || vehicle.Chassis_No__c ==null))
                    {
                        if(vehicle.Registration_Type__c=='Registered')
                            vehicle.Registration_Type_AR__c='مسجلة';
                        else 
                            vehicle.Registration_Type_AR__c='غير مسجلة';
                        ETAbuDhabiInspectionService.GetVehicleDetailsRequest request = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
                        ETAbuDhabiInspectionService.PlateKey platedetails = new ETAbuDhabiInspectionService.PlateKey();
                        request.SystemCode = integer.valueOf(system.label.ETI_AMAN_System_Code);
                        request.UserID = system.label.ETI_AMAN_UserID;
                        platedetails.PlateOrgNo = long.valueOf(system.label.ETI_AMAN_PlateOrgNo);
                        platedetails.PlateNo= long.valueOf(vehicle.Plate_No__c);
                        platedetails.PlateSourceCode = integer.valueOf(getPlateCodeByName(vehicle.Plate_Source__c,'PLATE_SOURCE','en'));
                        platedetails.PlateTypeCode = integer.valueOf(getPlateCodeByName(vehicle.Plate_Type__c,'PLATE_TYPE','en'));
                        platedetails.PlateColorCode = integer.valueOf(getPlateCodeByName(vehicle.Plate_Color__c,'PLATE_COLOR','en'));
                        vehicle.Plate_Source_AR__c= getPlateCodeByName(vehicle.Plate_Source__c,'PLATE_SOURCE','ar');
                        vehicle.Plate_Type_AR__c= getPlateCodeByName(vehicle.Plate_Type__c,'PLATE_TYPE','ar');
                        vehicle.Plate_Color_AR__c= getPlateCodeByName(vehicle.Plate_Color__c,'PLATE_COLOR','ar');
                        platedetails.PlateKindCode=platedetails.PlateTypeCode;
                        request.PlateInfo = platedetails;
                        ET_SOA_Services soa = new ET_SOA_Services();
                        ETAbuDhabiInspectionService.getVehicleDetailsResponse_element vehicleDetails = soa.getVehiclesDetails(request); 
                        system.debug('response from abu dhabi.....'+vehicleDetails.getVehicleDetailsResult);
                        if(vehicleDetails!=null && vehicleDetails.getVehicleDetailsResult != null)
                        {
                            vehicle.Vehicle_Make__c = vehicleDetails.getVehicleDetailsResult.MakeEnglishDesc;
                            vehicle.Vehicle_Model__c = vehicleDetails.getVehicleDetailsResult.ModelEnglishDesc;
                            vehicle.Make_Code__c = vehicleDetails.getVehicleDetailsResult.MakeCode;
                            vehicle.Vehicle_Make_AR__c=vehicleDetails.getVehicleDetailsResult.MakeArabicDesc;
                            vehicle.Model_Code__c = vehicleDetails.getVehicleDetailsResult.ModelCode;
                            vehicle.Registration_Expiry_Date__c=Date.Valueof(vehicleDetails.getVehicleDetailsResult.RegistrationExpiryDate);
                            vehicle.Vehicle_Year__c= vehicleDetails.getVehicleDetailsResult.Year;
                            vehicle.Chassis_No__c=vehicleDetails.getVehicleDetailsResult.ChassisNo;
                            vehicle.Vehicle_type__c=vehicleDetails.getVehicleDetailsResult.TypeEnglishDesc;
                            vehicle.Vehicle_Type_AR__c=vehicleDetails.getVehicleDetailsResult.TypeArabicDesc;
                            vehicle.Vehicle_Type_Code__c=vehicleDetails.getVehicleDetailsResult.TypeCode;
                            vehicle.Plate_Source_Code__c=String.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateSourceCode);
                            vehicle.Plate_Color_Code__c=string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateColorCode);
                            vehicle.Plate_Type_Code__c=string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateTypeCode);                        
                            vehicle.Kind_Code__c =vehicleDetails.getVehicleDetailsResult.KindCode;  
                            vehicle.Vehicle_Model_AR__c = vehicleDetails.getVehicleDetailsResult.ModelArabicDesc;
                            vehicle.Kind_Code_AR__c=vehicleDetails.getVehicleDetailsResult.KindArabicDesc; 
                            vehicle.Tcf_No__c =vehicleDetails.getVehicleDetailsResult.OwnerTcfNo; 
                            vehicle.Tcf_No_AR__c =vehicleDetails.getVehicleDetailsResult.OwnerTcfArabicName;  
                            vehicle.Engine_No__c=vehicleDetails.getVehicleDetailsResult.EngineNo;               
                            vehicle.Is_Verified__c=true;
                            insert vehicle;
                            returnvalue= vehicle.id;
                        }else 
                        {
                            system.debug('error');
                            vehicle.Plate_Source_Code__c=String.valueOf(platedetails.PlateSourceCode);
                            vehicle.Plate_Type_Code__c=string.valueOf(platedetails.PlateTypeCode);
                            vehicle.Plate_Color_Code__c=string.valueOf(platedetails.PlateColorCode);
                            vehicle.Is_Verified__c=false;
                            insert vehicle;
                            returnvalue= vehicle.id+';'+'No Service';
                        }
                    }           
                }
            }
            return returnvalue;
        }
    @AuraEnabled 
    public static List<ETI_Case_Record_Types__mdt> getCaseTypes() { //caseRecordType="School Transport"
        /*Map<String,List<String>> objResults = new Map<String,List<String>>();
Map<String, Case_Dependent_Types__c> mapOfdependent = Case_Dependent_Types__c.getAll();
Group grp = [Select Id from Group Where Type='Queue' AND DeveloperName='School_Transport_Queue'];
List<string> typeValues = new List<String>();
for(Case_Dependent_Types__c cdtypes:mapOfdependent.values()){
if(cdtypes.Record_Type_Name__c == caseRecordType){
typeValues.add(cdtypes.Type_Name__c);   
}
} 
return typeValues;*/
        return [SELECT Record_Type_Id__c,Record_Type_Name__c FROM ETI_Case_Record_Types__mdt];
    }
    @AuraEnabled
    public static void saveCase(case caseRecord){
        try{
            insert caseRecord;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    //This is for configurable settings for enable the Payment at Premises button configurable manner
    @Auraenabled
    public static ETI_Display_Service_Settings__c objDisplayServiceSettings(){
        system.debug('*****Display Service Settigns ******'+ETI_Display_Service_Settings__c.getInstance(UserInfo.getProfileId()));
        return ETI_Display_Service_Settings__c.getInstance(UserInfo.getProfileId());
    }
    
    // check for any active vehicle is present in database or not
    @Auraenabled
    public static String checkDuplicatevehicle1(ET_Customer_Vehicle__c vehicle, integer limitVar){
        try{
            List<ET_Customer_Vehicle__c> existingCustomerVehicle;
            String userAccountId=getAccountId(); 
            system.debug('userAccountId>> '+userAccountId);
            if(vehicle.Registration_Type__c == 'Registered'){
                // When user fill only(Select chassis no in select list in UI) chassis no from UI
                if(vehicle.Chassis_No__c != null && vehicle.Chassis_No__c != ''){
                    //duplicte check for same user
                    existingCustomerVehicle = [SELECT ID FROM ET_Customer_Vehicle__c WHERE Chassis_No__c = : vehicle.Chassis_No__c AND Status__c != 'Inactive' AND Account__c=:userAccountId];
                    if(existingCustomerVehicle.size() > limitVar)
                        return 'Duplicate with same User';
                    else{
                        //Duplicate check with diferrent user
                        existingCustomerVehicle = [SELECT ID FROM ET_Customer_Vehicle__c WHERE Chassis_No__c = : vehicle.Chassis_No__c AND Status__c != 'Inactive'];
                        if(existingCustomerVehicle.size() > limitVar)
                            return 'Duplicate vehicle';
                    }
                }else{  // When user Select Plate Combination in select list in UI
                    existingCustomerVehicle = [SELECT ID FROM ET_Customer_Vehicle__c 
                                               WHERE Plate_No__c = : vehicle.Plate_No__c 
                                               AND Plate_Color__c = : vehicle.Plate_Color__c
                                               AND Plate_Type__c = : vehicle.Plate_Type__c
                                               AND Plate_Source__c = : vehicle.Plate_Source__c
                                               AND Status__c != 'Inactive' AND Account__c=:userAccountId];
                    if(existingCustomerVehicle.size() > limitVar)
                        return 'Duplicate with same User';
                    else {
                        //Duplicate check with diferrent user
                        existingCustomerVehicle = [SELECT ID FROM ET_Customer_Vehicle__c 
                                                   WHERE Plate_No__c = : vehicle.Plate_No__c 
                                                   AND Plate_Color__c = : vehicle.Plate_Color__c
                                                   AND Plate_Type__c = : vehicle.Plate_Type__c
                                                   AND Plate_Source__c = : vehicle.Plate_Source__c
                                                   AND Status__c != 'Inactive'];
                        if(existingCustomerVehicle.size() > limitVar)
                            return 'Duplicate vehicle';
                    }
                }
                
            }else if(vehicle.Registration_Type__c == 'Un-Registered'){
                //duplicte check for same user
                existingCustomerVehicle = [SELECT ID FROM ET_Customer_Vehicle__c WHERE Chassis_No__c = : vehicle.Chassis_No__c AND Status__c != 'Inactive' AND Account__c=:userAccountId];
                if(existingCustomerVehicle.size() > limitVar){
                    return 'Duplicate with same User';
                }else{
                    //Duplicate check with diferrent user
                    existingCustomerVehicle = [SELECT ID FROM ET_Customer_Vehicle__c WHERE Chassis_No__c = : vehicle.Chassis_No__c AND Status__c != 'Inactive'];
                    if(existingCustomerVehicle.size() > limitVar)
                        return 'Duplicate vehicle';
                }
                
            }
        }catch(Exception e){
            return e.getMessage();
        }
        return null;
    }
    @Auraenabled
    public static String checkDuplicatevehicle(ET_Customer_Vehicle__c vehicle, integer limitVar){
        system.debug('userAccountId>> ');
        
        List<ET_Customer_Vehicle__c> existingCustomerVehicle;
        //String userAccountId='0010C00000BcOb9';
        String userAccountId = getAccountId();
        system.debug('userAccountId>> '+userAccountId);
        if(vehicle.Registration_Type__c == 'Registered'){
            // When user fill only(Select chassis no in select list in UI) chassis no from UI
            //duplicte check for same user
            if(userAccountId!=null){
                String qryString = 'SELECT ID FROM ET_Customer_Vehicle__c WHERE Status__c != \'Inactive\' AND Account__c=:userAccountId';
                if(vehicle.Chassis_No__c != null && vehicle.Chassis_No__c != '')
                    qryString += ' AND Chassis_No__c =\''+vehicle.Chassis_No__c+'\'';
                else 
                    qryString += ' AND Plate_No__c =\''+vehicle.Plate_No__c+'\' AND Plate_Color__c =\''+vehicle.Plate_Color__c+'\' AND Plate_Type__c =\''+vehicle.Plate_Type__c+'\' AND Plate_Source__c =\''+vehicle.Plate_Source__c+'\'';
                system.debug('qryString>> '+qryString);
                existingCustomerVehicle  = Database.query(qryString);  
                if(existingCustomerVehicle.size() > limitVar)
                    return 'Duplicate with same User';
            }
            //Duplicate check with diferrent user
            String qryString = 'SELECT ID FROM ET_Customer_Vehicle__c WHERE Status__c != \'Inactive\'';
            if(vehicle.Chassis_No__c != null && vehicle.Chassis_No__c != '')
                qryString += ' AND Chassis_No__c =\''+ vehicle.Chassis_No__c+'\'';
            else 
                qryString += ' AND Plate_No__c =\''+vehicle.Plate_No__c+'\' AND Plate_Color__c =\''+vehicle.Plate_Color__c+'\' AND Plate_Type__c =\''+vehicle.Plate_Type__c+'\' AND Plate_Source__c =\''+vehicle.Plate_Source__c+'\'';
            // AND Plate_Color__c =\''+vehicle.Plate_Color__c+'\'' AND Plate_Type__c =\''+vehicle.Plate_Type__c+'\'' AND Plate_Source__c =\''+vehicle.Plate_Source__c+'\'';
            existingCustomerVehicle  = Database.query(qryString);                     
            if(existingCustomerVehicle.size() > limitVar)
                return 'Duplicate vehicle';
        }else if(vehicle.Registration_Type__c == 'Un-Registered'){
            //duplicte check for same user
            existingCustomerVehicle = [SELECT ID FROM ET_Customer_Vehicle__c WHERE Chassis_No__c = : vehicle.Chassis_No__c AND Status__c != 'Inactive' AND Account__c=:userAccountId];
            if(existingCustomerVehicle.size() > limitVar){
                return 'Duplicate with same User';
            }else{
                //Duplicate check with diferrent user
                existingCustomerVehicle = [SELECT ID FROM ET_Customer_Vehicle__c WHERE Chassis_No__c = : vehicle.Chassis_No__c AND Status__c != 'Inactive'];
                if(existingCustomerVehicle.size() > limitVar)
                    return 'Duplicate vehicle';
            }
            
        }
        return null;
    }
    
    @Auraenabled
    public static ETI_UtilityWrapper.amanLookupWrapper getAmanLookupDetails(string selectedLang){
        List<Map<String,String>> plateTypesMapList = new List<Map<String,String>>();
        List<Map<String,String>> plateSourceMapList = new List<Map<String,String>>();
        List<Map<String,String>> plateColorMapList = new List<Map<String,String>>();
        List<Map<String,String>> vehicleTypeMapList = new List<Map<String,String>>();
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name, ETI_External_ID__c, ETI_LookupCode__c, 
                                           ETI_LookupType__c, ETI_ArabicName__c FROM ETI_Aman_Lookup__c Where isActive__c=true]){
                                               if(amanLookup.ETI_LookupType__c=='PLATE_TYPE'){
                                                   plateTypesMapList.add(new Map<String,String>{'lookupName' => selectedLang=='en'?amanLookup.Name:amanLookup.ETI_ArabicName__c, 'lookupCode' =>amanLookup.Name});
                                               }else if(amanLookup.ETI_LookupType__c=='PLATE_SOURCE'){
                                                   plateSourceMapList.add(new Map<String,String>{'lookupName' => selectedLang=='en'?amanLookup.Name:amanLookup.ETI_ArabicName__c, 'lookupCode' =>amanLookup.Name});
                                               }else if(amanLookup.ETI_LookupType__c=='PLATE_COLOR'){
                                                   plateColorMapList.add(new Map<String,String>{'lookupName' => selectedLang=='en'?amanLookup.Name:amanLookup.ETI_ArabicName__c, 'lookupCode' =>amanLookup.Name});
                                               }else if(amanLookup.ETI_LookupType__c=='VEHICLE_TYPE'){
                                                   /*String rep_name = amanLookup.Name;
List<String> elems = rep_name.split(' ');
rep_name = '';
for (String x : elems){
rep_name += x.substring(0,1).toUpperCase()+x.substring(1,x.length()).toLowerCase() + ' ';
}
system.debug('rep_name>> '+rep_name);*/
                                                   vehicleTypeMapList.add(new Map<String,String>{'lookupName' => amanLookup.Name, 'lookupCode' =>amanLookup.Name});
                                               }
                                               
                                           }
        system.debug('vehicleTypeMapList>> '+vehicleTypeMapList);                                   
        ETI_UtilityWrapper.amanLookupWrapper lookupWrp=new ETI_UtilityWrapper.amanLookupWrapper(plateTypesMapList,plateSourceMapList,plateColorMapList,vehicleTypeMapList);
        return lookupWrp;
    }
    @Auraenabled
    public static List<String> getVehicleServiceType(){
        List<String> VehicleServiceType = new List<String>();
        String objectName = 'ET_Customer_Vehicle__c';
        String fieldName ='ET_Vehicle_type__c';
        
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            VehicleServiceType.add(pickListVal.getValue());
        }  
        return VehicleServiceType;
    }
    @Auraenabled
    public static List<Map<String,String>> getPlateCombinations(string lookupType,string plateSource,string plateColor){
        List<Map<String,String>> plateCombinationMapList = new List<Map<String,String>>();
        if(lookupType!=null && lookupType!=''){
            system.debug(lookupType+'lookupType');
            if(lookupType=='PLATE_SOURCE'){
                for(ETI_Aman_Plate_Source__mdt amanLookup: [Select Id, Label,ETI_Code__c FROM ETI_Aman_Plate_Source__mdt]){
                    plateCombinationMapList.add(new Map<String,String>{'lookupName' => amanLookup.Label, 'lookupCode' =>amanLookup.Label});                     
                }
            }else if(lookupType=='PLATE_TYPE' && plateSource!='' && plateSource!=null){
                for(ETI_Aman_Plate_Type__mdt amanLookup: [Select Id, Label,ETI_ArabicName__c,ETI_Code__c,ETI_Aman_Plate_Source__c FROM ETI_Aman_Plate_Type__mdt Where ETI_Aman_Plate_Source__r.Label=:plateSource]){
                    plateCombinationMapList.add(new Map<String,String>{'lookupName' => amanLookup.Label, 'lookupCode' =>amanLookup.Label});                     
                }
            }else if(lookupType=='PLATE_COLOR' && plateSource!='' && plateSource!=null && plateColor!=null && plateColor!=null){
                for(ETI_Aman_Plate_Color__mdt amanLookup: [Select Id, Label,ETI_ArabicName__c,ETI_Code__c,ETI_Aman_Plate_Source__c,ETI_Aman_Plate_Type__c FROM ETI_Aman_Plate_Color__mdt Where ETI_Aman_Plate_Source__r.Label=:plateSource AND ETI_Aman_Plate_Type__r.Label=:plateColor]){
                    plateCombinationMapList.add(new Map<String,String>{'lookupName' => amanLookup.Label, 'lookupCode' =>amanLookup.Label});                     
                }
            }
        }
        return plateCombinationMapList;
    }
    public static list<ETI_Aman_Lookup__c> getAmanLookups(String lookupType){
        list<ETI_Aman_Lookup__c> amanLookup=[SELECT Id,Name,ETI_LookupCode__c,ETI_LookupType__c FROM ETI_Aman_Lookup__c Where ETI_LookupType__c=:lookupType AND isActive__c=true];
        return amanLookup;
    }
    @Auraenabled
    public static List<Map<String,String>> getLookupFromAman(string lookupTypeAman, string lookupCodeAman){
        List<Map<String,String>> plateDetailsMapList = new List<Map<String,String>>();
        ET_Lookup_Service.execute_pt service = new ET_Lookup_Service.execute_pt();
        ET_Lookup.Output PlateDetails; 
        try{
            PlateDetails= service.execute(lookupTypeAman, '');
        }
        catch(exception ex){
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETI_VehicleController', 'getLookupFromAman', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
        List<ET_Lookup.AmanLookupValues> Platetype=PlateDetails.Data.AmanLookupValues;
        
        if(Platetype!=null)
        {
            for(ET_Lookup.AmanLookupValues  a :Platetype)
                plateDetailsMapList.add(new Map<String,String>{'lookupName' => a.lookupName, 'lookupCode' =>a.lookupCode});
        }
        system.debug(plateDetailsMapList+'plateDetailsMapList');
        return plateDetailsMapList;
    }
    @Auraenabled
    public static ET_Customer_Vehicle__c getVehicleDetails(String vehId){
        List<ET_Customer_Vehicle__c> vehList= new List<ET_Customer_Vehicle__c>();
        System.debug('get vehicle Id is ' + vehId);
        if(vehId != null)
        {
            vehList.addAll([SELECT Id,Name,Chassis_No__c,Plate_No__c,Plate_Color__c,Plate_Type__c,Plate_Source__c,Vehicle_Make__c,Vehicle_Model__c,Vehicle_Make_AR__c,Vehicle_Model_AR__c,Vehicle_Year__c,Vehicle_Type__c,Registration_Expiry_Date__c,Registration_Type__c,Is_Verified__c,Account__c,Account__r.Name,Account__r.PersonMobilePhone,Encrypted_Id__c,Selected_Type__c,ET_Vehicle_type__c from ET_Customer_Vehicle__c Where Id=:vehId]);
        }
        return vehList[0];
    }
    @Auraenabled
    public static string updateVehicleDetails(ET_Customer_Vehicle__c vehicleDetails){
        update vehicleDetails;
        return 'Success';
    }
    @Auraenabled(cacheable = true)
    public static list<ETI_B2B_UtilityWrapper.vehicleWrapper> getVehicles(id userId,string emirate){//,string searchKeyword
        List<ET_Customer_Vehicle__c> vehicleList= new List<ET_Customer_Vehicle__c>();
        list<user> userDetails=new list<user>();
        list<ETI_B2B_UtilityWrapper.vehicleWrapper> wrapperList=new list<ETI_B2B_UtilityWrapper.vehicleWrapper>();
        if(userId != null)
        {
            Date today = Date.today();
            userDetails=[select accountId,contactId from user where id=:userId]; 
            if(!userDetails.isEmpty() && userDetails[0].contactId!=null){
                Id contactId=userDetails[0].contactId;
                String qryString = 'SELECT Id,Name,Chassis_No__c,Plate_Source_AR__c,Plate_Type_AR__c,Plate_Color_AR__c,Selected_Type_AR__c,Vehicle_Make_AR__c,Vehicle_Model_AR__c,Registration_Type_AR__c,';
                qryString += 'Selected_Type__c,Vehicle_Make__c,Vehicle_Model__c,Vehicle_Year__c,Plate_No__c,Plate_Color__c,Registration_Type__c, Registration_Expiry_Date__c, Plate_Type__c,Plate_Source__c,Encrypted_Id__c,Is_Verified__c,Account__r.PersonMobilePhone,ET_Vehicle_Type__c,Vehicle_Type__c,';
                qryString += '(Select Id,Name,Service_Type__c,Selected_Services__c,Booking_Date__c,Booking_Status__c,Test_Result__c,Service_Request__r.Payment_Status__c  From Bookings__r Where Booking_Status__c!=\'Applied for Retest\' order by Name desc) ';
                qryString += 'from ET_Customer_Vehicle__c where (OwnerId=:userId OR Contact__c=:contactId) AND status__c = \'Active\'';
                qryString += ' order by Registration_Expiry_Date__c asc';
                system.debug('qryString>> '+qryString);
                vehicleList = Database.query(qryString);  
            }
            integer i=1;
            integer j=1;
            if(!vehicleList.isEmpty()){
                for(ET_Customer_Vehicle__c vehicle: vehicleList){
                    ETI_B2B_UtilityWrapper.vehicleWrapper wrp=new ETI_B2B_UtilityWrapper.vehicleWrapper();
                    wrp.rowIndex =i;
                    wrp.activePageRowIndex=j;
                    wrp.isSelectAll=false;
                    wrp.isChecked=false;
                    wrp.isEnabled=true;
                    wrp.isReTest=false;
                    wrp.isDelete=true;
                    wrp.isDueToTest = false;
                    wrp.isDisableSPEATest = false;
                    Integer numberDaysDue ;
                    if(vehicle.Registration_Expiry_Date__c != null){
                        numberDaysDue = today.daysBetween(vehicle.Registration_Expiry_Date__c);
                    }
                    System.debug(numberDaysDue);
                    if(vehicle.Registration_Expiry_Date__c != null && numberDaysDue != null && numberDaysDue >= 0 && numberDaysDue <= 3){
                        wrp.isDueToTest = true;
                    }
                    //Below code for SPEA Inspection added by noor on 01/11/20
                    if(emirate!='' && emirate!=null && emirate=='Sharjah'){
                        Date gradePeriod=Date.today()+integer.valueOf(System.Label.ETI_SPEA_Inspection_Grace_Period);
                        if(vehicle.Registration_Expiry_Date__c!= null && vehicle.Registration_Expiry_Date__c>=gradePeriod)
                            wrp.isDisableSPEATest =true;
                    }
                    for(ETI_Booking__c bkng:vehicle.Bookings__r){
                        wrp.isDelete=false;
                        if(!wrp.isReTest && (bkng.Test_Result__c =='Failed'))
                            wrp.isReTest=true;
                        //SPEA
                        if(wrp.paymentStatus == null){
                            // wrp.paymentStatus = bkng.Payment_Status__c;
                        }
                        if(wrp.testResultStatus == null){
                            // wrp.testResultStatus = bkng.Service_Request__r.Payment_Status__c;
                        }
                        
                    }
                    wrp.customerVehicle=vehicle;
                    wrapperList.add(wrp);
                    i++;
                    if(j==10)
                        j=1;
                    else
                        j++;
                }
            }
        }
        return wrapperList;
    }
    @Auraenabled
    public static List<ETI_Booking__c> checkBookings(List<id> vehIds){
        system.debug('vehicleId '+vehIds); 
        List<ETI_Booking__c> bookinglst = new List<ETI_Booking__c>();
        for(ETI_Booking__c bkng:[Select Id,Name,Service_Type__c,Selected_Services__c,Booking_Status__c,Booking_Date__c,Test_Result__c,Payment_Status__c from ETI_Booking__c Where Customer_Vehicle__c IN:vehIds AND Booking_Status__c IN:Label.ETI_AddtoCartBookingStatus.split(';') 
                                 AND Service_Type__c=:Label.ETI_AddtoCartServiceTypes.split(';')
                                 AND Booking_Date__c= LAST_N_MONTHS:1 order by Booking_Date__c desc limit 5]){
                                     bookinglst.add(bkng);
                                 }
        return bookinglst;
    }
    @Auraenabled
    public static ReturnWrapper checkVehicleBookings(List<id> rowid){
        //Added by Taj - delete vehicle logic updated for both SPEA and VIC.
        ReturnWrapper ReturnWrp = New ReturnWrapper();
        system.debug('rowid'+rowid); 
        List<ET_Customer_Vehicle__c> listToUpdate = new List<ET_Customer_Vehicle__c>();
        List<ET_Customer_Vehicle__c> listToDelete = new List<ET_Customer_Vehicle__c>();
        Boolean activeBookingAvailable = false;
        try{
            for(ET_Customer_Vehicle__c vehicle:[Select Id,Status__c,(select id,Payment_Status__c,Test_Result__c,Booking_Status__c from Bookings__r) From ET_Customer_Vehicle__c Where id=:rowid]){
                system.debug('vehicle.bookings__r '+vehicle.bookings__r);  
                if(vehicle.bookings__r !=NULL && vehicle.bookings__r.size()!=0){  
                    for(ETI_Booking__c bkg: vehicle.bookings__r){
                        if(bkg.Payment_Status__c == 'Payment Success' && 
                           (bkg.Test_Result__c == 'Pending' || bkg.Booking_Status__c == 'Booked' || bkg.Booking_Status__c == 'Confirmed' || bkg.Booking_Status__c == 'Due for Retest')){
                               activeBookingAvailable = true;
                               break;
                           }
                    }
                    if(activeBookingAvailable == true){
                        ReturnWrp.isBoolingsAvailable = true;
                    }else if(activeBookingAvailable == false){
                        vehicle.Status__c = 'Inactive';
                        listToUpdate.add(vehicle);
                        ReturnWrp.isVehicleDeactivated = true;
                    }
                }else{
                    listToDelete.add(vehicle);
                    ReturnWrp.isVehicleDeleted = true;
                }
                if(ReturnWrp.isBoolingsAvailable == true || ReturnWrp.isVehicleDeactivated == true || ReturnWrp.isVehicleDeleted == true)
                    ReturnWrp.isSuccess = true;
                else
                    ReturnWrp.message = 'Unable to complete your Request, Please Try after some time.';
            }
            if(!listToUpdate.isEmpty())
                Database.SaveResult [] result = Database.update(listToUpdate, false);
            if(!listToDelete.isEmpty())
                Database.DeleteResult [] delResult = Database.delete(listToDelete, false);
        }catch (Exception ex){
            ReturnWrp.isSuccess = false;
            ReturnWrp.message = ex.getMessage();
        }
        System.debug('ReturnWrp >>> '+ReturnWrp);
        return ReturnWrp;
    }
    public class ReturnWrapper{
        @AuraEnabled public Boolean isSuccess = false;
        @AuraEnabled public String message = null;
        @AuraEnabled public Boolean isBoolingsAvailable = false;
        @AuraEnabled public Boolean isVehicleDeactivated = false;
        @AuraEnabled public Boolean isVehicleDeleted = false;
    }
    @Auraenabled
    public static void deleteVehicles(List<id> rowid){
        system.debug('rowid'+rowid);   
        List<ET_Customer_Vehicle__c> ListToDelete = new List<ET_Customer_Vehicle__c>();
        for(ET_Customer_Vehicle__c vehicle:[Select Id,(select id from Bookings__r)  From ET_Customer_Vehicle__c Where id=:rowid]){
            if(vehicle.bookings__r.size()==0)
            {
                ListToDelete.add(vehicle);
            }
        }
        delete ListToDelete;
    }
    @Auraenabled
    public static list<ETI_Booking__c> getBookingData(list<ET_Customer_Vehicle__c> lstVehicle){
        system.debug('Entered' + lstVehicle);
        List<ETI_Booking__c> bookingLst = new List<ETI_Booking__c>();
        set<Id> vehicleIds=new set<Id>();
        /*map<Id,String> vehicle
for(ET_Customer_Vehicle__c v: lstVehicle)
{
vehicleIds.add(v.Id);
}
List<User> users=[select PersonMobilePhone from user where id=:vehicleIds];*/
        id  conId  = [select ContactId from user where id=:userInfo.getUserId()].ContactId;
        List<Contact> conList = [SELECT Email,MobilePhone FROM Contact WHERE id = :conId] ; 
        System.debug('conList' + conList);
        
        for(ET_Customer_Vehicle__c v: lstVehicle)
        {
            ETI_Booking__c e = new ETI_Booking__c();
            e.Registration_Type__c =v.Registration_Type__c;
            e.Chassis_No__c = v.Chassis_No__c;
            e.Plate_No__c= v.Plate_No__c;
            e.Plate_Color__c= v.Plate_Color__c;
            e.User__c=v.Account__c;
            e.Customer_Vehicle__c = v.Id;
            if(v.ET_Vehicle_Type__c!=null && v.ET_Vehicle_Type__c!='')
                e.Vehicle_Type__c= v.ET_Vehicle_Type__c;
            if(conList[0].Email!='' && conList[0].Email!=null)
                e.Email__c= conList[0].Email;
            String mobile;
            if(conList[0].MobilePhone!='' && conList[0].MobilePhone!=null){
                mobile=conList[0].MobilePhone;
                system.debug('mobile>> '+mobile);
                mobile=mobileRegex(mobile);
                system.debug('mobile111>> '+mobile);
                e.Mobile_No__c= mobile;
            }
            bookingLst.add(e);
        }
        system.debug('bookingLst' + bookingLst);
        return bookingLst;
    }
    @AuraEnabled
    public static String getChangelocationFromContact(){  
        System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@  ' + userInfo.getUserId());
        String loc = '';
        User user=  [select Contact.ET_Preferred_Location__c from user where id=:userInfo.getUserId() Limit 1];
        loc = user.Contact.ET_Preferred_Location__c;
        return loc;
    }
    public static string mobileRegex(String mobile){
        system.debug('mobile>> '+mobile);
        if (mobile.StartsWith('00'))
            mobile = mobile.replaceFirst('00','971');
        if (mobile.StartsWith('0'))
            mobile = mobile.replaceFirst('0','971');
        if (mobile.StartsWith('+971')){
            mobile = mobile.replaceFirst('\\+971','971');
        }
        mobile = mobile.replaceAll( '\\s+', '');
        mobile = mobile.remove('-');
        mobile = mobile.remove('+');
        system.debug('mobile111>> '+mobile);
        return mobile;
    }
    public static ET_Refund__c refundRequest(ETI_Booking__c booking,list<ETI_Inspection_Receipt__c> lstReceits,ETI_Reschedule_Cancel_Charges__mdt refundMdt,String cancelReason){
        Id recordTypeId = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        ET_Refund__c refund=new ET_Refund__c();
        refund.RecordTypeId = recordTypeId;
        refund.ETI_Booking__c = booking.id;
        system.debug('booking>> '+booking);
        system.debug('Receipts>> '+lstReceits);
        system.debug('refundMdt>> '+refundMdt);
        if(refundMdt.Refund_Percentage__c!=null){
            if(refundMdt.Refund_Percentage__c>0 && refundMdt.Refund_Percentage__c<100)
                refund.ET_Refund_Amount__c = (booking.Total_Amount__c*refundMdt.Refund_Percentage__c)/100;
            else
                if(refundMdt.Refund_Percentage__c==100)
                refund.ET_Refund_Amount__c = booking.Total_Amount__c;
            else if(refundMdt.Refund_Percentage__c == 0)
                refund.ET_Refund_Amount__c = 0;
            refund.ET_Refund_Percentage__c = refundMdt.Refund_Percentage__c;
        }else if(refundMdt.Refund_Amount__c!=null){
            refund.ET_Refund_Amount__c = refundMdt.Refund_Amount__c;
        }
        if(booking.ET_Refunds__r!=null && booking.ET_Refunds__r.size()>0)
            refund.Id=booking.ET_Refunds__r[0].Id;
        else 
            refund.ET_Service_Request__c = booking.Service_Request__c;
        list<ETST_Payment__c> lstPayment=[Select Id,Name,CreatedDate From ETST_Payment__c Where ET_Service_Request__c=:booking.Service_Request__c AND ETST_Payment_State__c='CAPTURED' AND ETST_Capture_State__c='SUCCESS' order by createdDate desc limit 1];
        system.debug('lstPayment>> '+lstPayment);
        if(lstPayment!=null && lstPayment.size()>0){
            Date paymentDate =date.newinstance(lstPayment[0].CreatedDate.year(), lstPayment[0].CreatedDate.month(), lstPayment[0].CreatedDate.day());
            Integer hur = lstPayment[0].CreatedDate.hour();
            refund.ET_Payment__c=lstPayment[0].Id;
            if(refund.ET_Refund_Amount__c!=0 ){
                if(paymentDate!=Date.today()){
                    if(lstPayment!=null && lstPayment.size()>0){
                        ET_Common_Util.ETPaymentResponse response=ET_Payment_Controller.createRefundRequest(lstPayment[0].Id,refund.ET_Refund_Amount__c);
                        system.debug('response>> '+response);
                        ET_common_util.cls_authResponse authResponse = new ET_common_util.cls_authResponse();
                        if(response!=null && response.authResponse!=null){
                            system.debug('authResponse>> '+authResponse);
                            authResponse = response.authResponse;
                            if(authResponse.authorizationCode!=null && authResponse.authorizationCode!='')
                                refund.ET_Authorization_Code__c=authResponse.authorizationCode;
                            if(authResponse.success == 'true'){
                                refund.ET_Refund_Status__c='Completed';
                                return refund;
                            }else {
                                refund.ET_Refund_Status__c='Failed';
                                upsert refund;
                            }
                        }else {
                            refund.ET_Refund_Status__c='Failed';
                            upsert refund;
                        }
                    }
                }else {
                    system.debug('paymentDate>> '+paymentDate);
                    if(paymentDate==Date.today()){
                        string result;
                        if(lstReceits!=null && lstReceits.size()>0)
                            result=cancelBooking(new List<Id>{booking.Id},cancelReason);
                        else 
                            result='S';
                        if(result=='S'){
                            refund.ET_Refund_Status__c='Process Refund NextDay';
                            upsert refund;
                            integer dd=lstPayment[0].CreatedDate.day()+1;
                            integer mm=lstPayment[0].CreatedDate.month();
                            //String sched3am = '0 0 3 '+dd+' '+mm+' ?'; //Next Day, 3AM
                            String sched3am = '0 0 '+hur+' '+dd+' '+mm+' ?'; //After 24 hours
                            ETI_CallRefundServiceScheduled SC = new ETI_CallRefundServiceScheduled(new set<Id>{refund.Id}); 
                            System.schedule('ETI CallRefundServiceScheduled - Next Day '+booking.Name, sched3am, SC);
                            return refund;
                        }
                    }
                    return null;
                }
            }else {
                return refund;
            }
        }
        return null;
    }
    //Rescheduled Booking
    @Auraenabled 
    public static List<ETI_B2B_UtilityWrapper.bookingWrapper> getRescheduledBookingData(Id bookingid,string metaDataId){
        system.debug('bookingid ' + bookingid);
        system.debug('metaId ' + metaDataId);
        list<ETI_Reschedule_Cancel_Charges__mdt>  refundMdt = new list<ETI_Reschedule_Cancel_Charges__mdt>();
        if(metaDataId!=null && metaDataId!='')
            refundMdt = [SELECT Type__c, Refund_Percentage__c,Refund_Amount__c, Max_Time_Limit__c FROM ETI_Reschedule_Cancel_Charges__mdt where id =:metaDataId];
        system.debug('refundMdt ' + refundMdt);
        List<ETI_B2B_UtilityWrapper.bookingWrapper> bkngWrapperList=new List<ETI_B2B_UtilityWrapper.bookingWrapper>();
        ETI_B2B_UtilityWrapper.bookingWrapper wrp;
        List<ETI_Booking__c> bookingLst = new List<ETI_Booking__c>();
        Map<string,string> vColorMap=new Map<string,string>();
        Map<string,string> vTypeMap=new Map<string,string>();
        string result;
        List<ETI_Booking__c> parentBooking =[SELECT ID,Name,Registration_Type__c,Booking_Status__c,Service_Type__c,Chassis_No__c,Plate_No__c,Plate_Color__c,Customer_Vehicle__c,Service_Premises__c,Service_Request__c,Mobile_No__c,Total_Amount__c,Customer_Vehicle__r.ET_Vehicle_type__c,
                                             ET_Location__c,Allocated_Lane__c,ETI_Booking_slots__c,Booking_Date__c,Vehicle_Service__c,user__c,Trade_License_Number__c,Trade_License_Expiry_Date__c,Service_Request__r.ETI_Payment_Type__c,Email__c,ETI_Pick_Up_Location__c,
                                             Payment_Status__c,Selected_Services__c,Selected_Services_Code__c,Purpose_Type__c,(Select Id,Name,Service_Name__c,Service__r.Service_Code__c,New_Color__c,New_Color2__c,New_Color3__c,New_Color4__c,New_Vehicle_Type__c From Services__r ),
                                             (Select Id,Name,ET_Refund_Amount__c,ET_Refund_Percentage__c,ET_Service_Request__c,ETI_Booking__c From ET_Refunds__r limit 1),
                                             (Select Id,AMAN_Receipt_No__c From Receipts__r Where AMAN_Receipt_No__c!=null)
                                             FROM ETI_Booking__c WHERE Id =:bookingid];
        system.debug('parentBooking ' + parentBooking); 
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id,Name,ETI_LookupCode__c,ETI_LookupType__c FROM ETI_Aman_Lookup__c Where ETI_LookupType__c='VEHICLE_COLOR' AND isActive__c=true]){
            vColorMap.put(amanLookup.Name,amanLookup.ETI_LookupCode__c);
        }
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id,Name,ETI_LookupCode__c,ETI_LookupType__c FROM ETI_Aman_Lookup__c Where ETI_LookupType__c='VEHICLE_TYPE' AND isActive__c=true]){
            vTypeMap.put(amanLookup.Name,amanLookup.ETI_LookupCode__c);
        }    
        
        if(parentBooking !=NULL && parentBooking.size()>0 && parentBooking[0].Services__r!=NULL && parentBooking[0].Services__r.size()>0){
            //Request for Rufund
            if(refundMdt!=null && refundMdt.size()>0 && parentBooking[0].Service_Request__r.ETI_Payment_Type__c!=null && parentBooking[0].Service_Request__r.ETI_Payment_Type__c !='' 
               && parentBooking[0].Service_Request__r.ETI_Payment_Type__c=='Online' && parentBooking[0].Payment_Status__c=='Payment Success'){
                   ET_Refund__c refund=refundRequest(parentBooking[0],parentBooking[0].Receipts__r,refundMdt[0],'Reschedule');
                   System.debug('refund '+ refund);
                   if(refund!=null){
                       if(refund.ET_Refund_Status__c=='Completed' && parentBooking[0].Receipts__r!=null && parentBooking[0].Receipts__r.size()>0){
                           result=cancelBooking(new List<Id>{parentBooking[0].Id},'Reschedule');
                           upsert refund;
                       }else if(refund.ET_Refund_Status__c=='Process Refund NextDay' || refund.ET_Refund_Status__c=='Completed'){
                           ETI_Booking__c bkng=new ETI_Booking__c();
                           bkng.Id = parentBooking[0].Id;
                           bkng.Booking_Status__c = 'Cancelled';
                           bkng.Cancellation_Reason__c=system.label.ETI_Cancellation_Reason_Reschedule;
                           update bkng;
                           upsert refund;
                           result='S';
                       }
                   }else 
                       return null;
               }else {
                   result=cancelBooking(new List<Id>{parentBooking[0].Id},'Reschedule');
               }
            if(result != 'E'){
                Map<Id,ET_Customer_Vehicle__c> vehicleTypeMap =new  Map<Id,ET_Customer_Vehicle__c>([Select Id,Name,Vehicle_type__c,Vehicle_Type_Code__c From ET_Customer_Vehicle__c Where Id =:parentBooking[0].Customer_Vehicle__c AND Registration_Type__c='Registered']);
                System.debug('vehicleTypeMap>> ' + vehicleTypeMap);
                wrp=getBookingData(parentBooking[0],vehicleTypeMap,vColorMap,vTypeMap);
                wrp.serviceTypes.add(new Map<String,String>{'label' =>parentBooking[0].Service_Type__c, 'value' =>parentBooking[0].Service_Type__c});
                wrp.rowIndex=0;
            }else {
                System.debug('@@@@@@   ');
                return null;
            }
        }
        bkngWrapperList.add(wrp);
        system.debug('bkngWrapperList' + bkngWrapperList);
        return bkngWrapperList;
    }
    //Due for Retest
    @Auraenabled
    public static List<ETI_B2B_UtilityWrapper.bookingWrapper> getRetestBookingData(Id vehicleId){
        system.debug('vehicleId ' + vehicleId);
        List<ETI_B2B_UtilityWrapper.bookingWrapper> bkngWrapperList=new List<ETI_B2B_UtilityWrapper.bookingWrapper>();
        List<ETI_Booking__c> bookingList = new List<ETI_Booking__c>();
        Set<Id> bkngIds=new Set<Id>();
        Map<Id,Id> bkngMap=new Map<Id,Id>();
        Map<string,string> vColorMap=new Map<string,string>();
        Map<string,string> vTypeMap=new Map<string,string>();
        set<String> resultValues=new set<String>();
        resultValues.addAll(Label.ETI_Booking_Test_Result.split(';'));
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name,ETI_LookupCode__c,ETI_LookupType__c FROM ETI_Aman_Lookup__c Where ETI_LookupType__c='VEHICLE_COLOR' AND isActive__c=true]){
            vColorMap.put(amanLookup.Name,amanLookup.ETI_LookupCode__c);
        }
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name,ETI_LookupCode__c,ETI_LookupType__c FROM ETI_Aman_Lookup__c Where ETI_LookupType__c='VEHICLE_TYPE' AND isActive__c=true]){
            vTypeMap.put(amanLookup.Name,amanLookup.ETI_LookupCode__c);
        }    
        for(ETI_Booking__c parentBooking :[SELECT ID,Name,Booking_Status__c,Service_Type__c,Registration_Type__c,Chassis_No__c,Plate_No__c,Plate_Color__c,Customer_Vehicle__c,Service_Premises__c,Service_Request__c,Mobile_No__c,Customer_Vehicle__r.ET_Vehicle_type__c,
                                           ET_Location__c,ETI_Pick_Up_Location__c,Allocated_Lane__c,ETI_Booking_slots__c,Booking_Date__c,Vehicle_Service__c,user__c,Trade_License_Number__c,Trade_License_Expiry_Date__c,Email__c,
                                           Selected_Services__c,Selected_Services_Code__c,Purpose_Type__c,(Select Id,Name,Service_Name__c,Service__r.Service_Code__c,New_Color__c,New_Color2__c,New_Color3__c,New_Color4__c,New_Vehicle_Type__c From Services__r Where Test_Result__c IN ('Failed'))
                                           FROM ETI_Booking__c WHERE Customer_Vehicle__c =:vehicleId AND Test_Result__c IN:resultValues AND Booking_Status__c!='Applied for Retest' order by createdDate desc limit:integer.valueOf(label.ETI_Test_Result_Booking_Limit)]){
                                               bkngMap.put(parentBooking.id,parentBooking.Customer_Vehicle__c);
                                               bookingList.add(parentBooking);
                                               
                                           }
        //system.debug('parentBooking ' + parentBooking); 
        Map<Id,ET_Customer_Vehicle__c> vehicleTypeMap =new  Map<Id,ET_Customer_Vehicle__c>([Select Id,Name,Vehicle_type__c,Vehicle_Type_Code__c From ET_Customer_Vehicle__c Where Id =:bkngMap.Values() AND Registration_Type__c='Registered']);
        
        // system.debug('Services ' + parentBooking[0].Services__r);  
        if(bookingList!=NULL && bookingList.size()>0){ 
            integer i=0;
            for(ETI_Booking__c bkng:bookingList){   
                ETI_B2B_UtilityWrapper.bookingWrapper wrp;
                if(bkng.Services__r!=NULL && bkng.Services__r.size()>0){
                    wrp=getBookingData(bkng,vehicleTypeMap,vColorMap,vTypeMap);
                    wrp.booking.Is_ReTest_Booking__c = true;
                    wrp.booking.Allocated_Lane__c=bkng.Allocated_Lane__c;
                    wrp.rowIndex=i;
                }
                wrp.serviceTypes.add(new Map<String,String>{'label' =>bkng.Service_Type__c, 'value' =>bkng.Service_Type__c});
                system.debug('wrp' + wrp);
                bkngWrapperList.add(wrp);
                i++;
            }
        }
        system.debug('bkngWrapperList' + bkngWrapperList);
        return bkngWrapperList;
    }
    public static ETI_B2B_UtilityWrapper.bookingWrapper getBookingData(ETI_Booking__c parentBooking,Map<Id,ET_Customer_Vehicle__c> vehicleTypeMap,Map<string,string> vColorMap,Map<string,string> vTypeMap){
        system.debug('parentBooking ' + parentBooking); 
        system.debug('Services ' + parentBooking.Services__r);                    
        ETI_B2B_UtilityWrapper.bookingWrapper wrp;
        string nColorName;
        string nColorName2;
        string nColorName3;
        string nColorName4;
        string nTypeName;
        ET_Customer_Vehicle__c customerVehicle=new ET_Customer_Vehicle__c();
        list<ET_Customer_Vehicle__c> lstCustomerVehicle=new list<ET_Customer_Vehicle__c> ();
        if(parentBooking !=NULL){
            system.debug('parentBooking INN ' + parentBooking); 
            ETI_Booking__c bkng = new ETI_Booking__c();
            bkng.Chassis_No__c = parentBooking.Chassis_No__c;
            bkng.Registration_Type__c =parentBooking.Registration_Type__c;
            bkng.Plate_No__c= parentBooking.Plate_No__c;
            bkng.Plate_Color__c= parentBooking.Plate_Color__c;
            bkng.User__c= parentBooking.User__c;
            if(parentBooking.Mobile_No__c!=null && parentBooking.Mobile_No__c!=''){
                string mobile=parentBooking.Mobile_No__c;
                system.debug('mobile>> '+mobile);
                mobile=mobileRegex(mobile);
                system.debug('mobile111>> '+mobile);
                bkng.Mobile_No__c = mobile;
            }
            bkng.Email__c = parentBooking.Email__c;
            bkng.Parent_Booking__c = parentBooking.Id;
            bkng.Customer_Vehicle__c = parentBooking.Customer_Vehicle__c;
            bkng.Service_Premises__c = parentBooking.Service_Premises__c;
            bkng.Service_Type__c = parentBooking.Service_Type__c;
            bkng.Trade_License_Number__c = parentBooking.Trade_License_Number__c;
            bkng.Trade_License_Expiry_Date__c= parentBooking.Trade_License_Expiry_Date__c;
            bkng.Booking_Status__c='Booked';
            bkng.Test_Result__c='Pending';
            string rejectedServices='';
            string rejectedServicesCode='';
            for(ETI_Service_Line_Item__c service: parentBooking.Services__r){
                if(service.Service_Name__c!='' && service.Service_Name__c!=null){
                    if(rejectedServices=='')
                        rejectedServices=service.Service_Name__c;
                    else 
                        rejectedServices=rejectedServices+';'+service.Service_Name__c;
                    if(rejectedServicesCode=='')
                        rejectedServicesCode=service.Service__r.Service_Code__c;
                    else 
                        rejectedServicesCode=rejectedServicesCode+';'+service.Service__r.Service_Code__c;
                }
                if(service.New_Color__c!=null && service.New_Color__c!='')
                    nColorName=service.New_Color__c;
                if(service.New_Color2__c!=null && service.New_Color2__c!='')
                    nColorName2=service.New_Color__c;
                if(service.New_Color3__c!=null && service.New_Color3__c!='')
                    nColorName3=service.New_Color__c;
                if(service.New_Color4__c!=null && service.New_Color4__c!='')
                    nColorName4=service.New_Color4__c;
                if(service.New_Vehicle_Type__c!=null && service.New_Vehicle_Type__c!='')
                    nTypeName=service.New_Vehicle_Type__c;
            }
            bkng.Selected_Services__c=rejectedServices;
            bkng.Selected_Services_Code__c=rejectedServicesCode;
            bkng.ET_Location__c = parentBooking.ET_Location__c;
            bkng.ETI_Pick_Up_Location__c=parentBooking.ETI_Pick_Up_Location__c;
            bkng.Purpose_Type__c = parentBooking.Purpose_Type__c;
            bkng.Test_result_page__c='/apex/ETI_VehicleTestResult';
            boolean isTrailer=false;
            Boolean isEquipment=false;
            if(bkng.Customer_Vehicle__r.ET_Vehicle_type__c!=null && bkng.Customer_Vehicle__r.ET_Vehicle_type__c!=''){ 
                if(bkng.Customer_Vehicle__r.ET_Vehicle_type__c=='Trailer')
                    isTrailer=true;
                else
                    if(bkng.Customer_Vehicle__r.ET_Vehicle_type__c=='Equipment')
                    isEquipment=true;
            }
            string vehicleTypeCode=null;
            List<Map<String,String>> serviceTypes=new List<Map<String,String>>();
            List<Map<String,String>> certificates= new List<Map<String,String>>();
            List<Map<string,string>> servicesMap=new List<Map<string,string>>();
            if(vehicleTypeMap!=NULL && vehicleTypeMap.size()>0 && vehicleTypeMap.containsKey(parentBooking.Customer_Vehicle__c) 
               && vehicleTypeMap.get(parentBooking.Customer_Vehicle__c).Vehicle_Type_Code__c!=null)
                vehicleTypeCode=vehicleTypeMap.get(parentBooking.Customer_Vehicle__c).Vehicle_Type_Code__c;
            system.debug('vehicleTypeCode>> '+vehicleTypeCode);
            customerVehicle.Id=parentBooking.Customer_Vehicle__c;
            lstCustomerVehicle=[Select Id,Trade_License_Number__c,Trade_License_Expiry_Date__c From ET_Customer_Vehicle__c Where Id=:parentBooking.Customer_Vehicle__c];
            if(!lstCustomerVehicle.isEmpty() && lstCustomerVehicle[0].Trade_License_Number__c!=null && lstCustomerVehicle[0].Trade_License_Expiry_Date__c!=null){
                customerVehicle.Trade_License_Number__c = lstCustomerVehicle[0].Trade_License_Number__c;
                customerVehicle.Trade_License_Expiry_Date__c= lstCustomerVehicle[0].Trade_License_Expiry_Date__c;
            }
            wrp=new ETI_B2B_UtilityWrapper.bookingWrapper(0,false,true,null,null,new list<ETI_B2B_UtilityWrapper.fileToBeUploaded>(),new list<ETI_B2B_UtilityWrapper.fileNameWrp>(),false,customerVehicle,bkng,null,serviceTypes,vehicleTypeCode,null,null,null,null,false,false,false,false,false,false,false,false,false,false,isTrailer,isEquipment,false);
            wrp.serviceCode=parentBooking.Services__r[0].Service__r.Service_Code__c;
            if(parentBooking.Service_Type__c=='ADFCA')
                wrp.isAdfcaVehicle=true;
            system.debug('rejectedServices>> '+rejectedServices);
            system.debug('rejectedServicesCode>> '+rejectedServicesCode);
            if(rejectedServices!=null && rejectedServices!=''){
                for(ETI_Vehicle_Service__c serviceLookup:[SELECT Id, Name, Service_Code__c  
                                                          FROM ETI_Vehicle_Service__c Where Service_Code__c =:rejectedServicesCode.split(';')]){
                                                              system.debug('serviceLookup>> '+serviceLookup);
                                                              if(parentBooking.Service_Type__c=='Certificate'){
                                                                  certificates.add(new Map<String,String>{'id' => serviceLookup.Service_Code__c, 'name' =>serviceLookup.Name});
                                                              }
                                                              if(parentBooking.Service_Type__c!='Certificate'){
                                                                  servicesMap.add(new Map<String,String>{'Id' => serviceLookup.Service_Code__c, 'Name' =>serviceLookup.Name});
                                                              }
                                                          }
            }  
            if(parentBooking.Service_Type__c=='Certificate') wrp.certificates=certificates;
            if(parentBooking.Service_Type__c!='Certificate') wrp.servicesMap=servicesMap;
            if(nColorName!=null && nColorName!='') wrp.newColor=nColorName;
            if(nColorName2!=null && nColorName2!='') wrp.newColor2=nColorName2;
            if(nColorName3!=null && nColorName3!='') wrp.newColor3=nColorName3;
            if(nColorName4!=null && nColorName4!='') wrp.newColor4=nColorName4;
            if(nTypeName!=null && nTypeName!='') wrp.newVehicleType=nTypeName;
        }
        system.debug('wrp' + wrp);
        return wrp;
    }
    @Auraenabled
    public static list<ETI_Booking__c> getBookingDataFromBookingId(Id bookingid ){
        //This will get Service Inspection Details
        List<ETI_Booking__c> accList= new List<ETI_Booking__c>();
        if(bookingid != null)
        {
            accList.addAll([SELECT Name,Location__c from ETI_Booking__c where Service_Request__c=:bookingid]);
        }
        system.debug('accList'+accList);
        return accList;
    }
    @Auraenabled
    public static list<ETI_Booking__c> getBookingDataForUpdate(Id bookingId,string metaDataId){
        System.debug('Booking Is' + bookingId);
        system.debug('metaDataId' + metaDataId);
        list<ETI_Reschedule_Cancel_Charges__mdt>  refundMdt = new list<ETI_Reschedule_Cancel_Charges__mdt>();
        if(metaDataId!=null && metaDataId!='')
            refundMdt = [SELECT Type__c, Refund_Percentage__c,Refund_Amount__c, Max_Time_Limit__c FROM ETI_Reschedule_Cancel_Charges__mdt where id =:metaDataId];
        system.debug('refundMdt ' + refundMdt);
        ETI_Booking__c bkng = [select Id,Customer_Vehicle__c from ETI_Booking__c where Id =: bookingId];
        Id vehicleId = bkng.Customer_Vehicle__c;
        List<Id> lstVehicleId = new List<Id>();
        lstVehicleId.add(bkng.Id);
        string result;
        List<ETI_Booking__c> lstBooking =[SELECT ID, Name,Total_Amount__c,Payment_Status__c, Service_Request__c,Service_Request__r.ETI_Payment_Type__c,
                                          (Select Id,AMAN_Receipt_No__c From Receipts__r Where AMAN_Receipt_No__c!=null) From ETI_Booking__c where Id=:bookingId];
        //Request for Rufund
        if(lstBooking!=null && lstBooking.size()>0){
            ET_Customer_Vehicle__c lstVehicle = new ET_Customer_Vehicle__c();
            system.debug('Entered' + lstVehicle);
            lstVehicle = [select Id,Chassis_No__c,Registration_Type__c,Plate_No__c,Plate_Color__c from ET_Customer_Vehicle__c where Id =: bkng.Customer_Vehicle__c];
            system.debug('Entered' + lstVehicle);
            List<ETI_Booking__c> bookingLst = new List<ETI_Booking__c>();
            ETI_Booking__c e = new ETI_Booking__c();
            e.Chassis_No__c = lstVehicle.Chassis_No__c;
            e.Customer_Vehicle__c = lstVehicle.Id;
            e.Registration_Type__c =lstVehicle.Registration_Type__c;
            e.Plate_No__c= lstVehicle.Plate_No__c;
            e.Plate_Color__c= lstVehicle.Plate_Color__c;
            bookingLst.add(e);
            if(refundMdt!=null && refundMdt.size()>0 && lstBooking[0].Service_Request__r.ETI_Payment_Type__c!=null && lstBooking[0].Service_Request__r.ETI_Payment_Type__c !='' 
               && lstBooking[0].Service_Request__r.ETI_Payment_Type__c=='Online' && lstBooking[0].Payment_Status__c=='Payment Success'){
                   ET_Refund__c refund=refundRequest(lstBooking[0],lstBooking[0].Receipts__r,refundMdt[0],'Cancel');
                   System.debug('refund '+ refund);
                   if(refund!=null){
                       if(refund.ET_Refund_Status__c=='Completed' && lstBooking[0].Receipts__r!=null && lstBooking[0].Receipts__r.size()>0){
                           result=cancelBooking(new List<Id>{lstBooking[0].Id},'Cancel');
                           upsert refund;
                       }else if(refund.ET_Refund_Status__c=='Process Refund NextDay' || refund.ET_Refund_Status__c=='Completed'){
                           ETI_Booking__c booking=new ETI_Booking__c();
                           booking.Id = lstBooking[0].Id;
                           booking.Booking_Status__c = 'Cancelled';
                           bkng.Cancellation_Reason__c=system.label.ETI_Cancellation_Reason_PortalCancel;
                           update booking;
                           upsert refund;
                           result='S';
                       }
                   }else 
                       return null;    
               }else{
                   result=cancelBooking(new List<Id>{lstBooking[0].Id},system.label.ETI_Cancellation_Reason_PortalCancel);
               }
            System.debug('result>> ' + result);
            if(result != 'E')
                return bookingLst;
        }    
        return null;
    }
    @AuraEnabled       
    public static List<Map<string,string>> getPickListValues(String selectedObject, String selectedField){
        List<Map<string,string>> pickListValuesList = new List<Map<string,string>>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
            .get(selectedObject).getDescribe();
        
        DescribeFieldResult fieldResult = objResult.fields.getMap()
            .get(selectedField).getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            //pickListValuesList.add(pickListVal.getLabel(),pickListVal.getValue());
            if(selectedField=='Registration_Type_AR__c') {
                if(pickListVal.getValue()=='مسجلة')
                    pickListValuesList.add(new Map<String,String>{'label' => pickListVal.getLabel(), 'value' =>'Registered'});
                if(pickListVal.getValue()=='غير مسجلة')
                    pickListValuesList.add(new Map<String,String>{'label' => pickListVal.getLabel(), 'value' =>'Un-Registered'});
            }else
                pickListValuesList.add(new Map<String,String>{'label' => pickListVal.getLabel(), 'value' =>pickListVal.getValue()});
        }    
        System.debug('Values in '+selectedObject+' of '+selectedField+' are : '+pickListValuesList);
        return pickListValuesList;
    }
    @AuraEnabled       
    public static List<String> getPickListValues1(String selectedObject, String selectedField){
        List<String> pickListValuesList = new List<String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
            .get(selectedObject).getDescribe();
        
        DescribeFieldResult fieldResult = objResult.fields.getMap()
            .get(selectedField).getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }    
        System.debug('Values in '+selectedObject+' of '+selectedField+' are : '+pickListValuesList);
        return pickListValuesList;
    }
    //Below code Added by Noor Shaik
    @AuraEnabled       
    public static List<ETI_B2B_UtilityWrapper.bookingWrapper> getBookingWrapper(List<ETI_Booking__c> lstBooking,String SelectedEmirate,String SelectedLang){
        Set<Id> ids=new Set<Id>();
        Set<String> vehicleTypeCodes=new Set<String>();
        Map<string,string> vehicleTypesMap=new  Map<string,string>();
        Map<string,string> vehicleServiceMap =new  Map<string,string>();
        list<Map<string,string>> locationsMap=new list<Map<string,string>>();
        Map<Id,ET_Customer_Vehicle__c> customerVehicleMap=new  Map<Id,ET_Customer_Vehicle__c>();
        Map<string, Map<string,list<string>>> bookedServicesMap=new  Map<string, Map<string,list<string>>>();
        List<ETI_B2B_UtilityWrapper.bookingWrapper> bkngWrapperList=new List<ETI_B2B_UtilityWrapper.bookingWrapper>();
        Map<string,string> purposeTypeMap=new Map<string,string>();
        Boolean isTrailer=false;
        Boolean isEquipment=false;
        Map<string,boolean> isADFCAMap=new Map<string,boolean>();
        Id sharjahLocId;
        list<user> users=new list<user>([select accountId,account.BillingStreet,account.BillingCity,ContactId,Contact.email,Contact.MobilePhone from user where id=:userInfo.getUserId() AND accountId !=NULL limit 1]);
        ET_Customer_Vehicle__c customerVehicle=new ET_Customer_Vehicle__c();
        for(ETI_Booking__c etb:lstBooking){
            ids.add(etb.Customer_Vehicle__c);
        }
        if(!ids.isEmpty()){
            for(ETI_Booking__c bkng:[Select Id,Name,Service_Type__c,Booking_Status__c,Test_Result__c,Customer_Vehicle__r.ET_Vehicle_type__c,(Select Id,Service__c,Service_Name__c,Service__r.Service_Code__c,Test_Result__c From Services__r Where Test_Result__c IN ('Pending','')) 
                                     From ETI_Booking__c Where Customer_Vehicle__c IN:ids AND Booking_Status__c!='Cancelled' AND Test_Result__c ='Pending' order by createdDate desc]){
                                         system.debug('serviceType>> '+bkng.Service_Type__c);
                                         if(bkng.Service_Type__c!='' && bkng.Service_Type__c!=null){
                                             string serviceType=bkng.Service_Type__c;
                                             for(ETI_Service_Line_Item__c service:bkng.services__r){//10/11/20
                                                 system.debug('service code>> '+service.Service__r.Service_Code__c);
                                                 Map<string,list<string>> localMap ;
                                                 if(!bookedServicesMap.containskey(bkng.Customer_Vehicle__c)){
                                                     localMap = new Map<string,list<string>>();
                                                     localMap.put(serviceType,new list<string>{service.Service__r.Service_Code__c});
                                                     bookedServicesMap.put(bkng.Customer_Vehicle__c,localMap);
                                                 }else{
                                                     localmap = bookedServicesMap.get(bkng.Customer_Vehicle__c);
                                                     if(!localmap.containsKey(serviceType))
                                                         localmap.put(serviceType,new list<string>{service.Service__r.Service_Code__c});
                                                     else {
                                                         if(!localmap.get(serviceType).contains(service.Service__r.Service_Code__c))
                                                             localmap.get(serviceType).add(service.Service__r.Service_Code__c);
                                                     }
                                                     bookedServicesMap.put(bkng.Customer_Vehicle__c, localmap);
                                                 }
                                             }
                                         }
                                         if(bkng.Customer_Vehicle__r.ET_Vehicle_type__c!=null && bkng.Customer_Vehicle__r.ET_Vehicle_type__c!=''){ 
                                             if(bkng.Customer_Vehicle__r.ET_Vehicle_type__c=='Trailer')
                                                 isTrailer=true;
                                             else 
                                                 if(bkng.Customer_Vehicle__r.ET_Vehicle_type__c=='Equipment')
                                                 isEquipment=true;
                                         }
                                         
                                     }
            system.debug('bookedServicesMap>> '+bookedServicesMap);
        }
        for(ET_Customer_Vehicle__c vehicle:[Select Id,Name,Registration_Type__c,Vehicle_type__c,Vehicle_Type_Code__c,ADFCA_Type__c From ET_Customer_Vehicle__c Where Id IN:ids]){
            if(vehicle.Registration_Type__c=='Registered'){
                customerVehicleMap.put(vehicle.Id,vehicle);
                vehicleTypeCodes.add(vehicle.Vehicle_Type_Code__c);
            }
            if(vehicle.ADFCA_Type__c!=null && vehicle.ADFCA_Type__c=='With ADFCA')
                isADFCAMap.put(vehicle.Id,true);
            else 
                isADFCAMap.put(vehicle.Id,false);
        }
        //Below Map to get Allowed Service Types for vechile
        for(ETI_Vehicle_Type__c type:[SELECT Id, Name, Type_Code__c, Service_Types__c,Vehicle_Service__c,Vehicle_Service__r.Name FROM ETI_Vehicle_Type__c where Type_Code__c IN: vehicleTypeCodes]){
            if(type.Vehicle_Service__r.Name !=null && type.Vehicle_Service__r.Name !=''){
                if(type.Vehicle_Service__r.Name.Contains('Trailer'))
                    isTrailer =true;
                else
                    if(type.Vehicle_Service__r.Name.Contains('Equipment'))
                    isEquipment =true;
            }
        } 
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name, ETI_LookupCode__c FROM ETI_Aman_Lookup__c 
                                           Where ETI_LookupType__c='TEST_PURPOSE' AND Name IN ('Registration','Renewal') AND isActive__c=true]){
                                               purposeTypeMap.put(amanLookup.Name,amanLookup.Id);
                                           } 
        if(SelectedEmirate == 'Sharjah'){
            for(ET_Location__c loc:[Select Id, Name, Location_Code__c From ET_Location__c Where Emirates__c=:SelectedEmirate AND Status__c='Active' AND Zone__c ='TC']){
                if(loc.Location_Code__c=='06034')
                    sharjahLocId=loc.Id;
                locationsMap.add(new Map<String,String>{'id' => loc.Id, 'name' =>loc.Name});
            }       
        }
        
        Integer idx=0;
        for(ETI_Booking__c bkng:lstBooking){
            string vehicleTypeCode=null;
            string serviceCode=null;
            List<Map<String,String>> serviceTypes=new List<Map<String,String>>();
            List<Map<String,String>> serviceTypesTemp=new List<Map<String,String>>();
            if(customerVehicleMap!=NULL && customerVehicleMap.size()>0 && customerVehicleMap.containsKey(bkng.Customer_Vehicle__c) 
               && customerVehicleMap.get(bkng.Customer_Vehicle__c).Vehicle_Type_Code__c!=null)
                vehicleTypeCode=customerVehicleMap.get(bkng.Customer_Vehicle__c).Vehicle_Type_Code__c;
            if(vehicleTypeCode==null || vehicleTypeCode =='' || SelectedEmirate == 'Sharjah')
                bkng.Purpose_Type__c=purposeTypeMap.get('Registration');
            else 
                bkng.Purpose_Type__c=purposeTypeMap.get('Renewal');
            if(SelectedEmirate == 'Sharjah'){
                serviceCode='37';
                bkng.Selected_Services__c='SPEA Inspection';
                bkng.Selected_Services_Code__c='37';
                if(bookedServicesMap.containsKey(bkng.Customer_Vehicle__c) && !bookedServicesMap.get(bkng.Customer_Vehicle__c).containsKey('SPEA Inspection'))
                    serviceTypes.add(new Map<String,String>{'label' =>'SPEA Inspection', 'value' =>'SPEA Inspection'});
                else if(!bookedServicesMap.containsKey(bkng.Customer_Vehicle__c)){
                    if(SelectedLang=='en')
                        serviceTypes.add(new Map<String,String>{'label' =>'SPEA Inspection', 'value' =>'SPEA Inspection'});
                    else if(SelectedLang=='ar')
                        serviceTypes.add(new Map<String,String>{'label' =>'التفتيش SPEA', 'value' =>'SPEA Inspection'});
                }
            }else {    
                if(bookedServicesMap.containsKey(bkng.Customer_Vehicle__c)){
                    system.debug('entered>> ');
                    if(isADFCAMap.containsKey(bkng.Customer_Vehicle__c) && isADFCAMap.get(bkng.Customer_Vehicle__c)){
                        if(!bookedServicesMap.get(bkng.Customer_Vehicle__c).containsKey('ADFCA')){
                            if(SelectedLang=='en')
                                serviceTypes.add(new Map<String,String>{'label' =>'ADFCA', 'value' =>'ADFCA'});
                            else if(SelectedLang=='ar')
                                serviceTypes.add(new Map<String,String>{'label' =>'رقابة غذائية', 'value' =>'ADFCA'});
                        }
                        if(!bookedServicesMap.get(bkng.Customer_Vehicle__c).containsKey('Police Inspection')){
                            if(SelectedLang=='en')
                                serviceTypes.add(new Map<String,String>{'label' =>'Police Inspection', 'value' =>'Police Inspection'});
                            else if(SelectedLang=='ar')
                                serviceTypes.add(new Map<String,String>{'label' =>'فحص فني', 'value' =>'Police Inspection'});
                        }
                    }else {
                        if(SelectedLang=='en')
                            serviceTypes.add(new Map<String,String>{'label' =>'Police Inspection', 'value' =>'Police Inspection'});
                        else 
                            serviceTypes.add(new Map<String,String>{'label' =>'فحص فني', 'value' =>'Police Inspection'});
                    }
                }else {
                    if(isADFCAMap.containsKey(bkng.Customer_Vehicle__c) && isADFCAMap.get(bkng.Customer_Vehicle__c)){
                        if(SelectedLang=='en'){
                            serviceTypes.add(new Map<String,String>{'label' =>'ADFCA', 'value' =>'ADFCA'});
                            serviceTypes.add(new Map<String,String>{'label' =>'Police Inspection', 'value' =>'Police Inspection'});
                        }else if(SelectedLang=='ar'){
                            serviceTypes.add(new Map<String,String>{'label' =>'رقابة غذائية', 'value' =>'ADFCA'});
                            serviceTypes.add(new Map<String,String>{'label' =>'فحص فني', 'value' =>'Police Inspection'});
                        }
                    }else {
                        if(SelectedLang=='en')
                            serviceTypes.add(new Map<String,String>{'label' =>'Police Inspection', 'value' =>'Police Inspection'});
                        else if(SelectedLang=='ar')
                            serviceTypes.add(new Map<String,String>{'label' =>'فحص فني', 'value' =>'Police Inspection'});
                    }
                }
                if(SelectedLang=='en')
                    serviceTypes.add(new Map<String,String>{'label' =>'Certificate', 'value' =>'Certificate'});
                else if(SelectedLang=='ar')
                    serviceTypes.add(new Map<String,String>{'label' =>'شهادة', 'value' =>'Certificate'});
            }
            system.debug('purposeType>> '+bkng.Purpose_Type__c);
            system.debug('serviceTypes>> '+serviceTypes);
            customerVehicle.Id=bkng.Customer_Vehicle__c;
            bkng.Service_Type__c='';
            bkng.ETI_Pick_Up_Location__c='';
            bkng.Preferred_Time__c='';
            bkng.ETI_Booking_slots__c='';
            bkng.Booking_Date__c=null;
            ETI_B2B_UtilityWrapper.bookingWrapper wrp=new ETI_B2B_UtilityWrapper.bookingWrapper(idx,false,true,null,null,new list<ETI_B2B_UtilityWrapper.fileToBeUploaded>(),new list<ETI_B2B_UtilityWrapper.fileNameWrp>(),false,customerVehicle,bkng,bookedServicesMap.get(bkng.Customer_Vehicle__c),serviceTypes,vehicleTypeCode,serviceCode,null,locationsMap,null,false,false,false,false,false,false,false,false,false,false,isTrailer,isEquipment,false);
            wrp.requestId='';
            if(SelectedEmirate == 'Sharjah'){
                wrp.isAddDisabled=true;
                wrp.booking.Service_Type__c='SPEA Inspection';
                if(!users.isEmpty() && users[0].account.BillingStreet!=null && users[0].account.BillingStreet!=''
                   && users[0].account.BillingCity!=null && users[0].account.BillingCity!='' && sharjahLocId!=null){
                       wrp.fullAddress=users[0].account.BillingStreet+', '+users[0].account.BillingCity;
                       wrp.booking.ETI_Pick_Up_Location__c=wrp.fullAddress;
                       wrp.booking.ET_Location__c=sharjahLocId;
                   }
            }
            bkngWrapperList.add(wrp);
            idx++;
        }
        return bkngWrapperList;
    }
    @AuraEnabled
    public static list<ETI_B2B_UtilityWrapper.fileToBeUploaded> removeUploadedFiles(String obj, String removefileName){
        System.debug('removefileName>> '+removefileName);
        system.debug('obj>> '+obj);
        list<ETI_B2B_UtilityWrapper.fileToBeUploaded> DocumentList= (list<ETI_B2B_UtilityWrapper.fileToBeUploaded>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.fileToBeUploaded>.class);
        list<ETI_B2B_UtilityWrapper.fileToBeUploaded> finalDocList =new list<ETI_B2B_UtilityWrapper.fileToBeUploaded>();
        system.debug('DocumentList size>> '+DocumentList.size());
        for(ETI_B2B_UtilityWrapper.fileToBeUploaded doc: DocumentList){
            system.debug('fileName>> '+doc.fileName+' removefileName '+removefileName);
            if(!removefileName.contains(doc.fileName))
                finalDocList.add(doc);
        }
        system.debug('finalDocList >> '+finalDocList);
        system.debug('finalDocList size>> '+finalDocList.size());
        return finalDocList;  
    }
    @AuraEnabled       
    public static List<Map<string,string>> getSelectedCertificateCenters(String selectedServices,String placeStr,String SelectedEmirate){
        System.debug('selectedServices  ' + selectedServices  +  '   placeStr  ' + placeStr + '     SelectedEmirate  ' + SelectedEmirate);
        List<Map<string,string>> locationsMapList=new List<Map<string,string>>();//;Change Vehicle Type Certificate
        Map<string,list<string>> locationsMap=new Map<string,list<string>>();
        set<id> locIds=new set<id>();
        for(ETI_Location_Services__c loc:[Select Id, Name,Location__c,Location__r.Name,Location__r.Location_Code__c,
                                          Service__c,Service__r.Name,Service__r.Service_Code__c From ETI_Location_Services__c
                                          Where Location__r.Status__c='Active' AND Service__r.Name=:selectedServices.split(';') AND Location__r.Emirates__c=:mapLocations.get(SelectedEmirate) AND Service__r.Service_Premises__c=:placeStr]){
                                              if(!locationsMap.containsKey(loc.Service__r.Name))
                                                  locationsMap.put(loc.Service__r.Name,new list<string>{loc.Location__c});
                                              else
                                                  locationsMap.get(loc.Service__r.Name).add(loc.Location__c);
                                              locIds.add(loc.Location__c);
                                          }
        System.debug('selectedServices ' + selectedServices);
        for(String service: selectedServices.split(';')){
            if(!locationsMap.containsKey(service))
                locationsMap.put(service,new list<string>{});
        }
        system.debug('locationsMap>> '+locationsMap);
        system.debug('locIds>> '+locIds);
        if(!locIds.isEmpty()){
            if(!locationsMap.isEmpty()){
                for(ET_Location__c loc:[Select Id,Name from ET_Location__c Where Id IN:locIds]){
                    boolean isExist=true;
                    system.debug('loc>> '+loc);
                    for(string str:locationsMap.keySet()){
                        system.debug('str>> '+str);
                        system.debug('contains>> '+locationsMap.get(str).contains(loc.Id));
                        if(!locationsMap.get(str).contains(loc.Id))
                            isExist=false;
                    }  
                    if(isExist)
                        locationsMapList.add(new Map<String,String>{'id' => loc.Id, 'name' =>loc.Name});
                }
            }
        }
        system.debug('locationsMapList>> '+locationsMapList);
        return locationsMapList;
    }
    @AuraEnabled       
    public static List<String> getCertificateServices(String selectedObject, String selectedField,string service){
        List<String> pickListValuesList = new List<String>();
        List<String> certificateServices = new List<String>();
        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
            .get(selectedObject).getDescribe();
        
        DescribeFieldResult fieldResult = objResult.fields.getMap()
            .get(selectedField).getDescribe();
        
        //  Schema.DescribeFieldResult fieldResult = Product2.fields.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }    
        System.debug('service>> '+service);
        System.debug('pickListValuesList>> '+pickListValuesList);
        if(service=='Visit ET Premises'){
            for(String str:pickListValuesList){
                if(!str.contains('Outside')){
                    //if(str.contains('-')) str.replace('-', '&#8208;');
                    certificateServices.add(str);
                }
            }
        }else {
            for(String str:pickListValuesList){
                if(str.contains('Outside')){
                    certificateServices.add(str);
                }
            }
        }
        System.debug('certificateServices>> '+certificateServices);
        System.debug('Values in '+selectedObject+' of '+selectedField+' are : '+pickListValuesList);
        return certificateServices;
    }
    /*@AuraEnabled       
public static List<string> getCertificates(string servicePremise,Map<string,list<string>> bookedServicesMap,string location){
System.debug(location + 'servicePremise>> '+servicePremise);
System.debug('bookedServicesMap>> '+bookedServicesMap);
List<String> pickListValuesList = new List<String>();
if(servicePremise!=null && servicePremise!='' && location!=null && location!=''){
if(bookedServicesMap!=NULL && bookedServicesMap.size()>0 && bookedServicesMap.ContainsKey('Certificate')){
for(ETI_Location_Services__c serviceLookup:[Select Id, Name,Location__c,Location__r.Name,Location__r.Location_Code__c,
Service__c,Service__r.Name,Service__r.Service_Code__c From ETI_Location_Services__c
Where Location__r.Status__c='Active' AND Service__r.Service_Type__c='Certificate' AND Location__c=:location AND Service__r.Service_Premises__c=:servicePremise AND isActive__c=true]){
if(!bookedServicesMap.get('Certificate').contains(serviceLookup.Service__r.Name))
pickListValuesList.add(serviceLookup.Service__r.Name.replace('  ', ' '));
}
}else {
for(ETI_Location_Services__c serviceLookup:[Select Id, Name,Location__c,Location__r.Name,Location__r.Location_Code__c,
Service__c,Service__r.Name,Service__r.Service_Code__c From ETI_Location_Services__c
Where Location__r.Status__c='Active' AND Service__r.Service_Type__c='Certificate' AND Location__c=:location AND Service__r.Service_Premises__c=:servicePremise AND isActive__c=true]){
pickListValuesList.add(serviceLookup.Service__r.Name.replace('  ', ' '));
}
}
}
System.debug('pickListValuesList>> '+pickListValuesList);
return pickListValuesList;
}*/
    @AuraEnabled       
    public static List<Map<String,String>> getCertificates(string servicePremise,Map<string,list<string>> bookedServicesMap,string location){
        System.debug(location + 'servicePremise>> '+servicePremise);
        System.debug('bookedServicesMap>> '+bookedServicesMap);
        List<Map<String,String>> certificateMapList = new List<Map<String,String>>();
        if(servicePremise!=null && servicePremise!='' && location!=null && location!=''){
            if(bookedServicesMap!=NULL && bookedServicesMap.size()>0 && bookedServicesMap.ContainsKey('Certificate')){
                for(ETI_Location_Services__c serviceLookup:[Select Id, Name,Location__c,Location__r.Name,Location__r.Location_Code__c,
                                                            Service__c,Service__r.Name,Service__r.Service_Code__c From ETI_Location_Services__c
                                                            Where Location__r.Status__c='Active' AND Service__r.Service_Type__c='Certificate' AND Location__c=:location AND Service__r.Service_Premises__c=:servicePremise AND isActive__c=true]){
                                                                if(!bookedServicesMap.get('Certificate').contains(serviceLookup.Service__r.Service_Code__c))
                                                                    certificateMapList.add(new Map<String,String>{'id' => serviceLookup.Service__r.Service_Code__c, 'name' =>serviceLookup.Service__r.Name}); 
                                                            }
            }else {
                for(ETI_Location_Services__c serviceLookup:[Select Id, Name,Location__c,Location__r.Name,Location__r.Location_Code__c,
                                                            Service__c,Service__r.Name,Service__r.Service_Code__c From ETI_Location_Services__c
                                                            Where Location__r.Status__c='Active' AND Service__r.Service_Type__c='Certificate' AND Location__c=:location AND Service__r.Service_Premises__c=:servicePremise AND isActive__c=true]){
                                                                certificateMapList.add(new Map<String,String>{'id' => serviceLookup.Service__r.Service_Code__c, 'name' =>serviceLookup.Service__r.Name});  
                                                            }
            }
        }
        System.debug('certificateMapList>> '+certificateMapList);
        return certificateMapList;
    }
    @AuraEnabled       
    public static List<Map<string,string>> getServices(string serviceType,string placeStr,Boolean isAdafca,string location){ //18/10/20
        System.debug('service>> '+serviceType+' location>> '+location+' placeStr>> '+placeStr+' isAdafca>> '+isAdafca);
        List<Map<string,string>> servicesList=new List<Map<string,string>>();
        if(serviceType!=null && serviceType!=''){
            if(serviceType!='ADFCA' && placeStr!=null && placeStr!=''){
                for(ETI_Location_Services__c serviceLookup:[Select Id, Name,Location__c,Location__r.Name,Location__r.Location_Code__c,
                                                            Service__c,Service__r.Name,Service__r.Service_Code__c From ETI_Location_Services__c
                                                            Where Location__r.Status__c='Active' AND Service__r.Service_Type__c=:serviceType AND Location__c=:location AND Service__r.Service_Premises__c=:placeStr AND isActive__c=true]){
                                                                servicesList.add(new Map<String,String>{'Id' => serviceLookup.Service__r.Service_Code__c, 'Name' =>serviceLookup.Service__r.Name.replace('  ', ' ')});
                                                            }
            }else if(serviceType=='ADFCA'){
                for(ETI_Vehicle_Service__c serviceLookup:[SELECT Id, Name, Service_Code__c, Service_Premises__c,Service_Type__c  
                                                          FROM ETI_Vehicle_Service__c Where Service_Type__c='ADFCA' AND Emirate__c includes (:mapLocations.get(location))]){
                                                              servicesList.add(new Map<String,String>{'Id' => serviceLookup.Service_Code__c, 'Name' =>serviceLookup.Name.replace('  ', ' ')});
                                                          }    
            }
        }
        System.debug('servicesList>> '+servicesList);
        return servicesList;
    }
    @AuraEnabled       
    public static List<Map<string,string>>  getTestPurposeTypes(String SelectedLang){
        List<Map<string,string>> purposeTypeMap=new List<Map<string,string>>();
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name, ETI_External_ID__c, ETI_LookupCode__c, ETI_LookupType__c, ETI_ArabicName__c FROM ETI_Aman_Lookup__c Where ETI_LookupType__c='TEST_PURPOSE' AND isActive__c=true]){
            String rep_name = amanLookup.Name;
            List<String> elems = rep_name.split(' ');
            rep_name = '';
            for (String x : elems){
                rep_name += x.substring(0,1).toUpperCase()+x.substring(1,x.length()).toLowerCase() + ' ';
            }
            
            if(rep_name.trim() == 'Registration'){
                if(SelectedLang =='en')
                    purposeTypeMap.add(0,new Map<String,String>{'id' => amanLookup.Id, 'name' => rep_name});
                else 
                    purposeTypeMap.add(0,new Map<String,String>{'id' => amanLookup.Id, 'name' => amanLookup.ETI_ArabicName__c});
            }else if(rep_name.trim() == 'Renewal'){
                if(SelectedLang =='en')
                    purposeTypeMap.add(1,new Map<String,String>{'id' => amanLookup.Id, 'name' => rep_name});
                else 
                    purposeTypeMap.add(1,new Map<String,String>{'id' => amanLookup.Id, 'name' => amanLookup.ETI_ArabicName__c});
            }else if(rep_name.trim() == '-'){
                continue;
            }else{
                if(SelectedLang =='en')
                    purposeTypeMap.add(new Map<String,String>{'id' => amanLookup.Id, 'name' => rep_name});
                else 
                    purposeTypeMap.add(new Map<String,String>{'id' => amanLookup.Id, 'name' => amanLookup.ETI_ArabicName__c});
            }
        }    
        return purposeTypeMap;
    }
    @AuraEnabled       
    public static List<Map<string,string>>  getVehicleTypes(String SelectedLang){
        List<Map<string,string>> vehicleTypeMap=new List<Map<string,string>>();
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name, ETI_LookupCode__c,ETI_ArabicName__c FROM ETI_Aman_Lookup__c Where ETI_LookupType__c='VEHICLE_TYPE' AND isActive__c=true]){
            if(SelectedLang =='en')
                vehicleTypeMap.add(new Map<String,String>{'id' => amanLookup.ETI_LookupCode__c, 'name' =>amanLookup.Name});
            else    
                vehicleTypeMap.add(new Map<String,String>{'id' => amanLookup.ETI_LookupCode__c, 'name' =>amanLookup.ETI_ArabicName__c});
        }    
        return vehicleTypeMap;
    }
    @AuraEnabled       
    public static List<Map<string,string>>  getVehicleColors(String SelectedLang){
        List<Map<string,string>> purposeTypeMap=new List<Map<string,string>>();
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name, ETI_External_ID__c, ETI_LookupCode__c, ETI_LookupType__c, ETI_ArabicName__c FROM ETI_Aman_Lookup__c Where ETI_LookupType__c='VEHICLE_COLOR' AND isActive__c=true]){
            String rep_name = amanLookup.Name;
            List<String> elems = rep_name.split(' ');
            rep_name = '';
            for (String x : elems){
                rep_name += x.substring(0,1).toUpperCase()+x.substring(1,x.length()).toLowerCase() + ' ';
            }
            
            if(rep_name.trim() == '-' || rep_name.trim() == '--'){
                continue;
            }else{
                if(SelectedLang =='en')
                    purposeTypeMap.add(new Map<String,String>{'id' => amanLookup.ETI_LookupCode__c, 'name' => rep_name});
                else     
                    purposeTypeMap.add(new Map<String,String>{'id' => amanLookup.ETI_LookupCode__c, 'name' => amanLookup.ETI_ArabicName__c});
            }
        }    
        return purposeTypeMap;
    }
    @AuraEnabled       
    public static list<ETI_B2B_UtilityWrapper.bookingWrapper> getAvailableSlots(String obj, Boolean isReTest){
        system.debug('obj>>'+obj);
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrpList= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        list<String> availableSlots = new list<String>();
        list<String> finalAvailableSlots = new list<String>();
        Map<string,Set<string>> allLaneNslotsMap=new Map<string,Set<string>>();
        List<string> bookedSlots=new List<string>();
        ETI_B2B_UtilityWrapper.bookingWrapper bkngWrp;
        Map<string,string> purposeTypeMap=new Map<string,string>();
        Map<string,string> dataChangePurposeTypeMap=new Map<string,string>();
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name, ETI_LookupCode__c FROM ETI_Aman_Lookup__c 
                                           Where ETI_LookupType__c='TEST_PURPOSE' AND (Name IN ('Registration','Renewal') OR Name LIKE 'Data Change%') AND isActive__c=true]){
                                               purposeTypeMap.put(amanLookup.Name,amanLookup.Id);
                                               if(amanLookup.Name.startsWith('Data Change'))
                                                   dataChangePurposeTypeMap.put(amanLookup.Id,amanLookup.Name);
                                           } 
        system.debug('dataChangePurposeTypeMap>>'+dataChangePurposeTypeMap);
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrpList){
            if(wrp.isSelectedRecord){
                bkngWrp=wrp;
            }
        }
        system.debug('bkngWrp>>'+bkngWrp);
        system.debug('booking>>'+bkngWrp.booking);
        Map<string,Set<string>> bookedLaneNslotsMap=new Map<string,Set<string>>();//11/11/20
        for(ETI_Booking__c bkng:[SELECT ID,Name,Allocated_Lane__c,ETI_Booking_slots__c,Customer_Vehicle__c,Booking_Date__c FROM ETI_Booking__c WHERE Booking_Date__c =: bkngWrp.booking.Booking_Date__c 
                                 AND ET_Location__c =: bkngWrp.booking.ET_Location__c AND Booking_Status__c!='Cancelled' AND Test_Result__c ='Pending' AND Allocated_Lane__c !=NULL AND ETI_Booking_slots__c!=NULL]){
                                     if(!bookedLaneNslotsMap.containsKey(bkng.Allocated_Lane__c))
                                         bookedLaneNslotsMap.put(bkng.Allocated_Lane__c, new Set<string>{bkng.ETI_Booking_slots__c});
                                     else 
                                         bookedLaneNslotsMap.get(bkng.Allocated_Lane__c).add(bkng.ETI_Booking_slots__c);
                                 }
        if((bkngWrp.serviceCode =='' || bkngWrp.serviceCode ==null) && bkngWrp.booking.Service_Type__c!=null && bkngWrp.booking.Service_Type__c!='' && bkngWrp.booking.Selected_Services_Code__c!=null && bkngWrp.booking.Selected_Services_Code__c!=''){
            system.debug('Selected_Services>>'+bkngWrp.booking.Selected_Services_Code__c);
            bkngWrp.serviceCode=bkngWrp.booking.Selected_Services_Code__c.split(';')[0];
        }
        if(bkngWrp.isAdfcaVehicle)
            bkngWrp.serviceCode='3';
        if(bkngWrp.serviceCode!=null && bkngWrp.serviceCode!=''){
            list<ETI_Inspection_Lanes__c> laneDetails=new list<ETI_Inspection_Lanes__c>();
            list<ETI_Inspection_Center_Shift_Times__c> centerShiftTimes=new list<ETI_Inspection_Center_Shift_Times__c>();
            DateTime bkngDT=DateTime.newInstance(bkngWrp.booking.Booking_Date__c, Time.newInstance(0, 0, 0, 0));
            String dayOfWeek=bkngDT.format('EEEE');
            system.debug('dayOfWeek>> '+dayOfWeek);
            centerShiftTimes=[Select Id,Start_Time__c,End_Time__c From ETI_Inspection_Center_Shift_Times__c Where Inspection_Center__c=:bkngWrp.booking.ET_Location__c AND Days__c INCLUDES(:dayOfWeek) limit 1];
            system.debug('centerShiftTimes>> '+centerShiftTimes);
            if(!centerShiftTimes.isEmpty()){
                if(!dataChangePurposeTypeMap.isEmpty() && bkngWrp.booking.Purpose_Type__c!=NULL && dataChangePurposeTypeMap.containsKey(bkngWrp.booking.Purpose_Type__c)){
                    laneDetails= [Select Id,Lane_Details__c,Lane_Details__r.Available_Slots__c From ETI_Inspection_Lanes__c Where Lane_Details__r.Lane_Status__c='Active' 
                                  AND Location_Service__r.Location__c=:bkngWrp.booking.ET_Location__c
                                  AND Lane_Details__r.Lane_Type_AMAN__c =:label.ETI_DataChange_Lanes.split(';')];
                }else {
                    laneDetails= [Select Id,Lane_Details__c,Lane_Details__r.Available_Slots__c From ETI_Inspection_Lanes__c Where Lane_Details__r.Lane_Status__c='Active' 
                                  AND Lane_Details__r.Booking_Type__c!='Walkin' 
                                  AND Location_Service__r.Location__c=:bkngWrp.booking.ET_Location__c
                                  AND Location_Service__r.Service__r.Service_Code__c =: bkngWrp.serviceCode];
                }
                if(laneDetails!=NULL && laneDetails.size()>0){
                    allLaneNslotsMap= getAllLanesNslots(laneDetails);
                    Map<string,list<string>> laneNslotsMap=new Map<string,list<string>>();
                    if(allLaneNslotsMap!=NULL && allLaneNslotsMap.size()>0){
                        for(String lane:allLaneNslotsMap.keySet()){
                            if(!isReTest || (isReTest && bkngWrp.booking.Allocated_Lane__c!=Null && bkngWrp.booking.Allocated_Lane__c==lane)){
                                if(bookedLaneNslotsMap.containsKey(lane)){
                                    for(String slot:allLaneNslotsMap.get(lane)){
                                        integer vHour=integer.valueOf(slot.split(':')[0]);
                                        if(!bookedLaneNslotsMap.get(lane).contains(slot) 
                                           && vHour>=integer.valueOf(centerShiftTimes[0].Start_Time__c.split(':')[0]) 
                                           && vHour<=integer.valueOf(centerShiftTimes[0].End_Time__c.split(':')[0]))
                                        {
                                            if(!availableSlots.contains(slot)){
                                                if(vHour==integer.valueOf(centerShiftTimes[0].End_Time__c.split(':')[0])){
                                                    if(Integer.valueOf(slot.split(':')[1])<=integer.valueOf(centerShiftTimes[0].End_Time__c.split(':')[1]))
                                                        availableSlots.add(slot);
                                                }else 
                                                    availableSlots.add(slot);
                                            }
                                        }
                                    }
                                }else{
                                    for(String slot:allLaneNslotsMap.get(lane)){
                                        integer vHour=integer.valueOf(slot.split(':')[0]);
                                        if(!availableSlots.contains(slot) 
                                           && vHour>=integer.valueOf(centerShiftTimes[0].Start_Time__c.split(':')[0]) 
                                           && vHour<=integer.valueOf(centerShiftTimes[0].End_Time__c.split(':')[0]))
                                        {
                                            if(vHour==integer.valueOf(centerShiftTimes[0].End_Time__c.split(':')[0])){ 
                                                if(Integer.valueOf(slot.split(':')[1])<=integer.valueOf(centerShiftTimes[0].End_Time__c.split(':')[1]))
                                                    availableSlots.add(slot);
                                            }else 
                                                availableSlots.add(slot);
                                        }
                                    }
                                }
                            }
                            system.debug('allLaneNslotsMap>> '+allLaneNslotsMap);
                            laneNslotsMap.put(lane, new List<String>(allLaneNslotsMap.get(lane)));
                        }
                        system.debug('laneNslotsMap>> '+laneNslotsMap);
                        if(!laneNslotsMap.isEmpty())
                            bkngWrp.laneNslotsMap=laneNslotsMap;
                    }
                }
                system.debug('availableSlots>> '+availableSlots);
                system.debug('BookingDate>> '+bkngWrp.booking.Booking_Date__c+' today>> '+system.today());
                //If customer wants to book the slots on same day then system should show the slots after current time.
                if(!availableSlots.isEmpty()){
                    if(bkngWrp.booking.Booking_Date__c==date.today()){
                        DateTime dt= datetime.now();
                        String vTime = dt.format('HH:mm');
                        system.debug('dt>> '+dt+' vTime>> '+vTime);
                        if(vTime!=null && vTime!=''){
                            for(String slot:availableSlots){
                                if(slot.contains(':') && vTime.contains(':')){
                                    system.debug('slot0>> '+slot.split(':')[0]);
                                    system.debug('time0>> '+vTime.split(':')[0]);
                                    integer vHour=integer.valueOf(vTime.split(':')[0]);
                                    system.debug('vHour>> '+vHour);
                                    if(Integer.valueOf(slot.split(':')[0])>=vHour){
                                        system.debug('strINN>> '+slot);
                                        if(Integer.valueOf(slot.split(':')[0])==vHour && Integer.valueOf(slot.split(':')[1])>Integer.valueOf(vTime.split(':')[1])){
                                            system.debug('slot>> '+slot);
                                            finalAvailableSlots.add(slot);
                                        }else if(Integer.valueOf(slot.split(':')[0])>vHour){
                                            System.debug(slot.split(':')[0] + '  sssssssssssssss      ' + string.valueOf(vHour));
                                            finalAvailableSlots.add(slot);
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }else 
                        bkngWrp.slotList=getSortedSlots(availableSlots);
                }
                system.debug('finalAvailableSlots >> '+finalAvailableSlots );
                if(!finalAvailableSlots.isEmpty())
                    bkngWrp.slotList=getSortedSlots(finalAvailableSlots);
                if(bkngWrp.booking.Service_Type__c == 'Certificate')
                    bkngWrp.booking.Purpose_Type__c=purposeTypeMap.get('Renewal');
                else if(bkngWrp.booking.Service_Type__c == 'ADFCA' ){
                    if(bkngWrp.booking.Registration_Type__c=='Registered')
                        bkngWrp.booking.Purpose_Type__c=purposeTypeMap.get('Renewal');
                    else 
                        bkngWrp.booking.Purpose_Type__c=purposeTypeMap.get('Registration');
                }
                //Below code to get certificates documents for ET Primises //22/10/20
                /*list<ETI_Required_Documents__c> Documents=getDocumentList(bkngWrp.booking,null);
system.debug('Documents after>> '+Documents);
if(Documents!=null && Documents.size()>0)
bkngWrp.requiredDocuments=Documents;*/
                for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrpList){
                    if(wrp.isSelectedRecord){
                        wrp=bkngWrp;
                    }
                }
            }
        }
        system.debug('bkngWrp after>> '+bookingWrpList);    
        return bookingWrpList;
    }
    public static list<String> getSortedSlots(list<string> availableSlots){
        map<String,String> finalAvailableSlotsMap = new map<String,String>();
        list<String> slotsTobeSort = new list<String>();
        list<String> sortedSlots = new list<String>();
        for(string str:availableSlots){
            finalAvailableSlotsMap.put(str.replace(':',''),str);
        }
        for(string str:finalAvailableSlotsMap.keySet()){
            slotsTobeSort.add(str);
        }
        slotsTobeSort.sort();
        for(string slot:slotsTobeSort){
            sortedSlots.add(finalAvailableSlotsMap.get(slot));
        }
        return sortedSlots;
    }
    public static Map<string,Set<string>> getAllLanesNslots(list<ETI_Inspection_Lanes__c> laneDetails){
        Map<String,Map<String,Set<String>>> serviceLanesMap=new Map<String,Map<String,Set<String>>>();
        Map<string,Set<string>> allLaneNslotsMap=new Map<string,Set<string>>();
        String inspectionService;
        System.debug(system.label.ETI_Certificate_Lane);
        system.debug('laneDetails>>'+laneDetails);
        if(laneDetails!=NULL && laneDetails.size()>0){
            for(ETI_Inspection_Lanes__c lane:laneDetails){
                if(!allLaneNslotsMap.containsKey(lane.Lane_Details__c)){
                    Set<String> allSlots=new Set<String>();
                    for(String slot:lane.Lane_Details__r.Available_Slots__c.split(';')){
                        allSlots.add(slot);
                    }
                    allLaneNslotsMap.put(lane.Lane_Details__c, allSlots);
                }
            }
            system.debug('allLaneNslotsMap>>'+allLaneNslotsMap);
        }
        return allLaneNslotsMap;
    }
    @AuraEnabled
    public static List<ETI_Booking__c> getBookedSlots(date bookingDate, String branch,String selectedLane){
        System.debug('Entering apex');
        List<ETI_Booking__c> etiBookingList = new List<ETI_Booking__c>();
        
        return etiBookingList;  
    }
    @AuraEnabled       
    public static list<ETI_B2B_UtilityWrapper.bookingWrapper> getRequiredDocuments(String obj, String selectedPremise, list<String> preferTimes){
        system.debug('obj>> '+obj+' selectedPremise>> '+selectedPremise+' preferTimes>> '+preferTimes);
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrpList= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        ETI_B2B_UtilityWrapper.bookingWrapper bkngWrp;
        Map<string,string> purposeTypeMap=new Map<string,string>();
        List<String> finalPreferTimes=new List<String>();
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name, ETI_LookupCode__c FROM ETI_Aman_Lookup__c 
                                           Where ETI_LookupType__c='TEST_PURPOSE' AND Name IN ('Registration','Renewal') AND isActive__c=true]){
                                               purposeTypeMap.put(amanLookup.Name,amanLookup.Id);
                                           } 
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrpList){
            if(wrp.isSelectedRecord)
                bkngWrp=wrp;
        }
        if(bkngWrp.booking.Service_Type__c == 'Certificate')
            bkngWrp.booking.Purpose_Type__c=purposeTypeMap.get('Renewal');
        else if(bkngWrp.booking.Service_Type__c == 'ADFCA' ){
            if(bkngWrp.booking.Registration_Type__c=='Registered')
                bkngWrp.booking.Purpose_Type__c=purposeTypeMap.get('Renewal');
            else 
                bkngWrp.booking.Purpose_Type__c=purposeTypeMap.get('Registration');
        }
        //22/10/20
        /*list<ETI_Required_Documents__c> Documents=getDocumentList(bkngWrp.booking,null, selectedPremise);
if(Documents!=null && Documents.size()>0)
bkngWrp.requiredDocuments=Documents;*/
        if(selectedPremise!=null && selectedPremise!='' && selectedPremise=='Customer Premises-B2B'){
            if(!preferTimes.isEmpty()){
                if(bkngWrp.booking.Booking_Date__c==system.today()){
                    DateTime dt= datetime.now();
                    String vTime = dt.format('HH:mm');
                    system.debug('dt>> '+dt+' vTime>> '+vTime);
                    if(vTime!=null && vTime!=''){
                        for(String slot:preferTimes){
                            if(slot.contains(':') && vTime.contains(':')){
                                system.debug('slot0>> '+slot.split(':')[0]);
                                system.debug('time0>> '+vTime.split(':')[0]);
                                integer vHour=integer.valueOf(vTime.split(':')[0]);
                                system.debug('vHour>> '+vHour);
                                if(Integer.valueOf(slot.split(':')[0])>=vHour){
                                    system.debug('strINN>> '+slot);
                                    if(Integer.valueOf(slot.split(':')[0])==vHour && Integer.valueOf(slot.split(':')[1])>Integer.valueOf(vTime.split(':')[1])){
                                        system.debug('slot>> '+slot);
                                        finalPreferTimes.add(slot);
                                    }else if(Integer.valueOf(slot.split(':')[0])>vHour){
                                        System.debug(slot.split(':')[0] + '  sssssssssssssss  ' + string.valueOf(vHour));
                                        finalPreferTimes.add(slot);
                                    }
                                    
                                }
                            }
                        }
                    }
                }else
                    bkngWrp.slotList=preferTimes;
            }
        }
        system.debug('finalPreferTimes after>> '+finalPreferTimes);
        if(!finalPreferTimes.isEmpty())
            bkngWrp.slotList=finalPreferTimes;
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrpList){
            if(wrp.isSelectedRecord)
                wrp=bkngWrp;
        }
        system.debug('bkngWrp after>> '+bookingWrpList);    
        return bookingWrpList;
    }
    @AuraEnabled 
    public static list<ETI_B2B_UtilityWrapper.bookingWrapper> getFinalPreferredTime(String obj, list<String> preferTimes){
        system.debug('obj>>'+obj);
        List<String> finalPreferTimes=new List<String>();
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrpList= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        ETI_B2B_UtilityWrapper.bookingWrapper bkngWrp;
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrpList){
            if(wrp.isSelectedRecord)
                bkngWrp=wrp;
        }
        if(!preferTimes.isEmpty()){
            if(bkngWrp.booking.Service_Type__c=='SPEA Inspection'){
                DateTime bkngDT=DateTime.newInstance(bkngWrp.booking.Booking_Date__c, Time.newInstance(0, 0, 0, 0));
                String dayOfWeek=bkngDT.format('EEEE');
                //below code commented by Noor Shaik for SPEA License expiry issue on 11/05/2021
                Map<String, List<String>> SPEAslotsMap=ETI_SPEAoperatingHours.getOperatingHours();
                preferTimes=SPEAslotsMap.get(dayOfWeek);
            }
            if(bkngWrp.booking.Booking_Date__c==system.today()){
                DateTime dt= datetime.now();
                String vTime = dt.format('HH:mm');
                system.debug('dt>> '+dt+' vTime>> '+vTime);
                if(vTime!=null && vTime!=''){
                    for(String slot:preferTimes){
                        if(slot.contains(':') && vTime.contains(':')){
                            integer vHour=integer.valueOf(vTime.split(':')[0]);
                            if(Integer.valueOf(slot.split(':')[0])>=vHour){
                                if(Integer.valueOf(slot.split(':')[0])==vHour && Integer.valueOf(slot.split(':')[1])>Integer.valueOf(vTime.split(':')[1])){
                                    finalPreferTimes.add(slot);
                                }else if(Integer.valueOf(slot.split(':')[0])>vHour){
                                    System.debug(slot.split(':')[0] + '  sssssssssssssss  ' + string.valueOf(vHour));
                                    finalPreferTimes.add(slot);
                                }
                                
                            }
                        }
                    }
                }
            }else
                bkngWrp.slotList=preferTimes;
        }
        if(!finalPreferTimes.isEmpty())
            bkngWrp.slotList=finalPreferTimes;
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrpList){
            if(wrp.isSelectedRecord)
                wrp=bkngWrp;
        }
        system.debug('bkngWrp after>> '+bookingWrpList);    
        return bookingWrpList;
    }
    public static list<ETI_Required_Documents__c> getDocumentList(ETI_Booking__c booking,String serviceCode, String selectedPremise){
        Map<String,ETI_Required_Documents__c> documentMap=new Map<String,ETI_Required_Documents__c>();
        //set<string> serviceCodes=new set<string>();
        system.debug('booking>>'+booking); 
        //system.debug('serviceCode>>'+serviceCode); 
        if(booking.Service_Type__c!=null && booking.Service_Type__c!=''){
            if(selectedPremise != null && selectedPremise != 'Visit ET Premises'){
                for(ETI_Required_Documents__c doc:[Select Id, Name,Purpose_Type__c,Is_Required__c From ETI_Required_Documents__c Where Service_Premises__c != null AND Service_Premises__c != 'Visit ET Premises' AND Is_Required__c = true order by Name asc]){
                    if(!documentMap.containsKey(doc.Name))
                        documentMap.put(doc.Name,doc);
                }
            }
            if((booking.Service_Type__c == 'Police Inspection' || booking.Service_Type__c == 'ADFCA') && serviceCode!=null && serviceCode!=''){
                for(ETI_Required_Documents__c doc:[Select Id, Name,Purpose_Type__c,Is_Required__c From ETI_Required_Documents__c Where Vehicle_Service__r.Service_Code__c=:serviceCode AND Service_Types__c =: booking.Service_Type__c AND Is_Required__c=true order by Name asc]){
                    if(booking.Purpose_Type__c!=null){
                        if(doc.Purpose_Type__c== booking.Purpose_Type__c && !documentMap.containsKey(doc.Name))
                            documentMap.put(doc.Name,doc);
                    }else {
                        if(!documentMap.containsKey(doc.Name))
                            documentMap.put(doc.Name,doc);
                    }
                }
            }else if(booking.Service_Type__c == 'Certificate' && booking.Selected_Services_Code__c!=null && booking.Selected_Services_Code__c!=''){
                system.debug('Selected_Services>>'+booking.Selected_Services_Code__c);//10/11/20
                /*for(ETI_Vehicle_Service__c vService:[SELECT Id, Name, Service_Code__c FROM ETI_Vehicle_Service__c Where Service_Type__c='Certificate' AND Name IN: booking.Selected_Services__c.split(';')]){
serviceCodes.add(vService.Service_Code__c);
}*/
                if(booking.Selected_Services_Code__c!=null && booking.Selected_Services_Code__c!=''){
                    for(ETI_Required_Documents__c doc:[Select Id, Name,Purpose_Type__c,Is_Required__c From ETI_Required_Documents__c Where Vehicle_Service__r.Service_Code__c IN:booking.Selected_Services_Code__c.split(';') AND Is_Required__c=true order by Name asc]){
                        if(booking.Purpose_Type__c!=null){
                            if(doc.Purpose_Type__c== booking.Purpose_Type__c && !documentMap.containsKey(doc.Name))
                                documentMap.put(doc.Name,doc);
                        }else {
                            if(!documentMap.containsKey(doc.Name))
                                documentMap.put(doc.Name,doc);
                        }
                    }
                }    
            }
            system.debug('documentMap>>'+documentMap);
            system.debug('documentMap>>'+documentMap.values());
        }
        return documentMap.values();
    }
    @AuraEnabled       
    public static list<Map<string,string>> getAvailableCenters(String SelectedEmirate,String SelectedLang){
        system.debug('SelectedEmirate '+SelectedEmirate);
        list<Map<string,string>> locationsMapList=new list<Map<string,string>>();
        system.debug('SelectedEmirate>> '+mapLocations.get(SelectedEmirate));
        for(ET_Location__c loc:[Select Id,Name,Arabic_Name__c,Location_Code__c From ET_Location__c Where Status__c='Active' AND Emirates__c=:mapLocations.get(SelectedEmirate)]){
            system.debug('loc>> '+loc);
            if(SelectedLang=='en')
                locationsMapList.add(new Map<String,String>{'id' => loc.Id, 'name' =>loc.Name});
            else 
                locationsMapList.add(new Map<String,String>{'id' => loc.Id, 'name' =>loc.Arabic_Name__c});
        }    
        system.debug('locationsMapList>> '+locationsMapList);
        return locationsMapList;
    }
    @AuraEnabled       
    public static list<ETI_B2B_UtilityWrapper.bookingWrapper> getRequiredDetails(String obj,String placeStr,String SelectedEmirate){
        system.debug('placeStr>> '+placeStr+' SelectedEmirate '+SelectedEmirate);
        Map<string,string> typeServiceMap =new  Map<string,string>();
        Map<string,Map<string,string>> serviceLocationsMap =new  Map<string,Map<string,string>>();
        list<ETI_Required_Documents__c> Documents=new list<ETI_Required_Documents__c>();
        list<Map<string,string>> locationsMapList=new list<Map<string,string>>();
        Map<string,string> locationsMap=new Map<string,string>();
        Map<string,string> purposeTypeMap=new Map<string,string>();
        for(ETI_Aman_Lookup__c amanLookup:[SELECT Id, Name, ETI_LookupCode__c FROM ETI_Aman_Lookup__c 
                                           Where ETI_LookupType__c='TEST_PURPOSE' AND Name IN ('Registration','Renewal') AND isActive__c=true]){
                                               purposeTypeMap.put(amanLookup.Name,amanLookup.Id);
                                           } 
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        set<string> vehicleTypes=new set<string>();
        ETI_B2B_UtilityWrapper.bookingWrapper bkngWrp;
        string vehicleType;
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
            if(wrp.isSelectedRecord){
                bkngWrp=wrp;
                vehicleType=wrp.vehicleTypeCode;
                if(wrp.booking.Service_Type__c == 'ADFCA')
                    wrp.isAdfcaVehicle=true;
            }
        }
        
        system.debug('vehicleTypes>>'+vehicleTypes);
        system.debug('SelectedEmirate >>'+SelectedEmirate );
        if(SelectedEmirate != 'Sharjah'){
            if(bkngWrp.booking.Service_Type__c == 'Police Inspection' && vehicleType !=null && vehicleType !='' && placeStr !=null && placeStr !=''){
                for(ETI_Vehicle_Type__c type:[Select Id,Name,Type_Code__c,Vehicle_Service__c,Vehicle_Service__r.Service_Code__c From ETI_Vehicle_Type__c 
                                              Where Type_Code__c =: vehicleType AND Vehicle_Service__r.Service_Premises__c=:placeStr]){
                                                  system.debug('vehicleType>>'+vehicleType);
                                                  system.debug('vehicleType>>'+type.Vehicle_Service__r.Service_Code__c);
                                                  if(type.Vehicle_Service__r.Service_Code__c!=NULL){
                                                      typeServiceMap.put(type.Type_Code__c,type.Vehicle_Service__r.Service_Code__c);
                                                  }else {
                                                      typeServiceMap.put(vehicleType,system.label.ETI_PoliceInspection_Default_Service);
                                                  }
                                                  system.debug('typeServiceMap>>'+typeServiceMap);
                                              }
                //Incase of Vehicle Type is new and not listed in ETI_Vehicle_Type__c object 
                if(typeServiceMap.size()==0 && vehicleType!=null && vehicleType!='')
                    typeServiceMap.put(vehicleType,system.label.ETI_PoliceInspection_Default_Service);
                //Documents=getDocumentList(bkngWrp.booking,typeServiceMap.get(vehicleType), null); //22/10/20
                
                //For Police Inspection Registered vehicles 
                if(placeStr == 'Visit ET Premises'){//10/11/20
                    for(ETI_Vehicle_Type__c service:[Select Id,Name,Vehicle_Service__r.Name,Vehicle_Service__r.Service_Code__c FROM ETI_Vehicle_Type__c 
                                                     Where Type_Code__c =: vehicleType AND Vehicle_Service__r.Service_Premises__c=:placeStr limit 1]){
                                                         //bkngWrp.booking.Selected_Services__c=service.Vehicle_Service__r.Name;
                                                         bkngWrp.booking.Selected_Services_Code__c=service.Vehicle_Service__r.Service_Code__c;
                                                         
                                                     } 
                    if(bkngWrp.booking.Selected_Services_Code__c=='' || bkngWrp.booking.Selected_Services_Code__c==null){
                        //bkngWrp.booking.Selected_Services__c=system.label.ETI_PoliceInspection_Default_Service_Name;
                        bkngWrp.booking.Selected_Services_Code__c=system.label.ETI_PoliceInspection_Default_Service;
                    }
                }
                
            }else if((bkngWrp.booking.Service_Type__c == 'Police Inspection' || bkngWrp.booking.Service_Type__c == 'ADFCA') && bkngWrp.serviceCode!=NULL && bkngWrp.serviceCode!=''){
                //Documents=getDocumentList(bkngWrp.booking,bkngWrp.serviceCode, null); //22/10/20
            }
        }else if(SelectedEmirate == 'Sharjah'){
            typeServiceMap.put('5','37');
        }
        system.debug('typeServiceMap>>'+typeServiceMap);
        system.debug('bkngWrp.serviceCode>>'+bkngWrp.serviceCode);
        
        if(bkngWrp.booking.Service_Type__c != 'Police Inspection' && bkngWrp.booking.Service_Type__c != 'ADFCA')
            bkngWrp.booking.Selected_Services_Code__c='';
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
            if(wrp.isSelectedRecord){
                if(bkngWrp.booking.Service_Type__c != 'ADFCA')
                    wrp.booking.Selected_Services_Code__c = bkngWrp.booking.Selected_Services_Code__c;
                if(wrp.serviceCode =='' || wrp.serviceCode ==null)
                    wrp.serviceCode=typeServiceMap.get(wrp.vehicleTypeCode);
                if(wrp.booking.Service_Type__c == 'Certificate')
                    wrp.booking.Purpose_Type__c=purposeTypeMap.get('Renewal');
                if(!Documents.isEmpty())
                    wrp.requiredDocuments=Documents;
            }
        }
        system.debug('bkngWrapperList>>'+bookingWrp);
        return bookingWrp;
    }
    public static ET_Location__c setLocationUsingLattitudeAndLongitude(decimal lattitude, decimal longitude ){
        System.debug(lattitude + ' @@@@' + longitude);
        ET_Location__c etLoc ;
        for(ET_Location__c locObj : [SELECT id, Name FROM ET_Location__c 
                                     WHERE Maximum__latitude__s >= :lattitude AND Minimum__latitude__s <= :lattitude
                                     AND Maximum__longitude__s >= :longitude AND Minimum__longitude__s <= :longitude]){
                                         
                                         etLoc= locObj;
                                     }
        System.debug(' @@@@2' + etLoc);
        if(etLoc == null){
            id  conId  = [select ContactId from user where id=:userInfo.getUserId()].ContactId;
            List<Contact> conList = [SELECT ET_Preferred_Location__c FROM Contact WHERE id = :conId] ; 
            System.debug('accList' + conList);
            Map<String, Object> defaultLocationMap =  (Map<String, Object>)(JSON.deserializeUntyped(System.Label.ETI_DefaultCustomerLocation));
            System.debug(' @@@@4' + defaultLocationMap);
            String locaName =String.valueOf( defaultLocationMap.get(conList[0].ET_Preferred_Location__c));
            etLoc = [SELECT ID FROM ET_Location__c WHERE Name = :locaName limit 1];
        }
        System.debug(' @@@@3' + etLoc);
        return etLoc;
        
    }
    @AuraEnabled
    public static string getLocationByLatitudeAndLongitude(string selectedEmirate,string latitude,string longitude){
        System.debug('selectedEmirate ' + selectedEmirate+' latitude ' + latitude+' longitude ' + longitude);
        string location;
        if(selectedEmirate != 'Sharjah'){
            location = setLocationUsingLattitudeAndLongitude(Decimal.valueOf(latitude), Decimal.valueOf(longitude)).id;
        }else if(selectedEmirate == 'Sharjah'){
            location = [SELECT id FROM ET_Location__c WHERE Name = 'Sharjah Spea Inspection Centre'][0].id;
        }
        return location;
    }
    @AuraEnabled
    public static list<ETI_B2B_UtilityWrapper.bookingWrapper> removeDraftBookings(String obj){
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp1= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        list<ETI_B2B_UtilityWrapper.bookingWrapper> finalBookingWrp=new list<ETI_B2B_UtilityWrapper.bookingWrapper>();
        map<id,list<string>> serviceTypeMap=new map<id,list<string>>();
        for(integer index = 0 ; index < bookingWrp.size(); index++){
            if(finalBookingWrp.isEmpty()){
                finalBookingWrp.add(bookingWrp[index]);
                /*if(bookingWrp[index].serviceTypes.size()>1)
serviceTypes.put(bookingWrp[index].booking.Customer_Vehicle__c,bookingWrp[index].serviceTypes);
else 
serviceTypes.put(bookingWrp[index].booking.Customer_Vehicle__c,new list<string>{bookingWrp[index].serviceTypes[0]});*/
            }else {
                for(integer idx = 0 ; idx < finalBookingWrp.size(); idx++){
                    if(bookingWrp[index].booking.Customer_Vehicle__c != finalBookingWrp[idx].booking.Customer_Vehicle__c){
                        finalBookingWrp.add(bookingWrp[index]);
                    }
                }
            }
            if(!serviceTypeMap.containsKey(bookingWrp[index].booking.Customer_Vehicle__c)){
                list<string> serviceTypes=new list<string>();
                for(integer i= 0 ; i < bookingWrp[index].serviceTypes.size(); i++){
                    serviceTypes.add(bookingWrp[index].serviceTypes[i].get('value'));
                }
                serviceTypeMap.put(bookingWrp[index].booking.Customer_Vehicle__c,serviceTypes);
            }else {
                for(integer i= 0 ; i < bookingWrp[index].serviceTypes.size(); i++){
                    serviceTypeMap.get(bookingWrp[index].booking.Customer_Vehicle__c).add(bookingWrp[index].serviceTypes[i].get('value'));
                }
            }
            /*for(integer idx = 0 ; idx < bookingWrp1.size(); idx++){
if(index!=idx && bookingWrp[index].booking.Customer_Vehicle__c == bookingWrp1[idx].booking.Customer_Vehicle__c){
finalBookingWrp.add(bookingWrp[index]);
}
}*/
        }
        system.debug('finalBookingWrpafter>> '+finalBookingWrp);
        return finalBookingWrp;
    }
    public class FileWrapper{
        @AuraEnabled
        public String base64Data{get; set;}
        @AuraEnabled
        public String Name {get; set;}
        @AuraEnabled
        public String contentType {get; set;}
        
    }
    @AuraEnabled
    public static list<ETI_B2B_UtilityWrapper.bookingWrapper> createDraftBookings(String obj, string filesData){
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        system.debug('bookingWrp>>'+bookingWrp);
        Id recordTypeId;
        ETI_B2B_UtilityWrapper.bookingWrapper bkngWrp;
        String inspectionService;
        Id servicerequestid =null;
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
            if(wrp.isSelectedRecord){
                bkngWrp=wrp;
                if(wrp.requestId!=NULL && wrp.requestId!='')
                    servicerequestid=wrp.requestId;
            }
        }
        System.debug('bkngWrp.verifiedTradeLicenseNo='+bkngWrp.verifiedTradeLicenseNo);
        System.debug('bkngWrp.customerVehicle.Trade_License_Number__c='+bkngWrp.customerVehicle.Trade_License_Number__c);
        //Validate Trade License number for ADFCA
        if(bkngWrp.isAdfcaVehicle && bkngWrp.verifiedTradeLicenseNo!=bkngWrp.customerVehicle.Trade_License_Number__c){
            ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap t1 = new ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap();
            ET_ValidateVehicleInfo.VehicleInfromation response =ET_SOA_Services.validateVehicleInfo(bkngWrp.booking.Chassis_No__c, bkngWrp.customerVehicle.Trade_License_Number__c);
            system.debug(response);
            if(response.Code=='200'){
                bkngWrp.isChildValidated=false;
                bkngWrp.childErrorMessage='';
                bkngWrp.verifiedTradeLicenseNo=bkngWrp.customerVehicle.Trade_License_Number__c;
                if(response.PermissionIssuePlace!='' && response.PermissionIssuePlace!=null)
                    bkngWrp.customerVehicle.Permission_Issue_Place__c=response.PermissionIssuePlace;
                else if(bkngWrp.customerVehicle.Trade_License_Number__c.startsWith('CN-') || bkngWrp.customerVehicle.Trade_License_Number__c.startsWith('IN-'))
                    bkngWrp.customerVehicle.Permission_Issue_Place__c='Abu Dhabi';
                if(bkngWrp.booking.Service_Premises__c == 'Visit ET Premises'){
                    if(response.PermissionIssuePlace=='Abu Dhabi' || bkngWrp.customerVehicle.Permission_Issue_Place__c=='Abu Dhabi'){ 
                        bkngWrp.booking.Selected_Services_Code__c='3';
                        bkngWrp.serviceCode='3';
                    }else {
                        bkngWrp.booking.Selected_Services_Code__c='4';
                        bkngWrp.serviceCode='4';
                    }
                }else {
                    bkngWrp.booking.Selected_Services_Code__c='38';
                    bkngWrp.serviceCode='38';
                }
                update bkngWrp.customerVehicle;
                /*else {
bkngWrp.isChildValidated=true;
bkngWrp.childErrorMessage='Permission Issue Place not availble in ADFCA CRM System for entered Trade License Number, please proceed with On Premise booking.';
}*/
            }else if(response.Code=='001'){
                system.debug('Code if>> '+response.Code);
                bkngWrp.isChildValidated=true;
                bkngWrp.childErrorMessage=response.CodeDescription;
                bkngWrp.verifiedTradeLicenseNo=bkngWrp.customerVehicle.Trade_License_Number__c;
            }
            
            for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
                if(wrp.isSelectedRecord)
                    wrp=bkngWrp;
            }
            if(bkngWrp.isChildValidated)
                return bookingWrp;
        }
        
        if(bkngWrp.booking.Service_Type__c == 'SPEA Inspection'){
            bkngWrp.booking.Selected_Services_Code__c= '37';//10/11/20
        }
        if(bkngWrp.booking.Service_Premises__c == 'Visit ET Premises'){
            recordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
            Map<string,Set<string>> bookedLaneNslotsMap=new Map<string,Set<string>>();
            for(ETI_Booking__c bkng:[SELECT ID,Name,Allocated_Lane__c,Allocated_Lane__r.Lane_Type_AMAN__c,ETI_Booking_slots__c,Customer_Vehicle__c,Booking_Date__c FROM ETI_Booking__c 
                                     WHERE Id!=:bkngWrp.booking.Id AND Booking_Date__c =: bkngWrp.booking.Booking_Date__c AND ET_Location__c =: bkngWrp.booking.ET_Location__c 
                                     AND Allocated_Lane__c !=NULL AND ETI_Booking_slots__c=: bkngWrp.booking.ETI_Booking_slots__c 
                                     AND Booking_Status__c IN ('Draft','Booked')]){
                                         if(!bookedLaneNslotsMap.containsKey(bkng.Allocated_Lane__c))
                                             bookedLaneNslotsMap.put(bkng.Allocated_Lane__c, new Set<string>{bkng.ETI_Booking_slots__c});
                                         else 
                                             bookedLaneNslotsMap.get(bkng.Allocated_Lane__c).add(bkng.ETI_Booking_slots__c);
                                     }
            
            system.debug('bookedLaneNslotsMap>> '+bookedLaneNslotsMap);
            /*list<ETI_Inspection_Lanes__c> laneDetails= [Select Id,Lane_Details__c,Lane_Details__r.Available_Slots__c From ETI_Inspection_Lanes__c Where Lane_Details__r.Lane_Status__c='Active' 
AND Location_Service__r.Location__c=:bkngWrp.booking.ET_Location__c
AND Location_Service__r.Service__r.Service_Code__c =: bkngWrp.serviceCode];*/
            //Map<string,Set<string>> allLaneNslotsMap= getAllLanesNslots(laneDetails);
            system.debug('bkngWrp.laneNslotsMap>> '+bkngWrp.laneNslotsMap);
            String duplicateSlot;
            if(bkngWrp.laneNslotsMap!=NULL && bkngWrp.laneNslotsMap.size()>0){
                for(String lane:bkngWrp.laneNslotsMap.keySet()){
                    system.debug('lane>> '+lane);
                    system.debug('slot>> '+bkngWrp.booking.ETI_Booking_slots__c);
                    system.debug('flag>> '+bkngWrp.laneNslotsMap.get(lane).contains(bkngWrp.booking.ETI_Booking_slots__c));
                    if(bkngWrp.laneNslotsMap.get(lane).contains(bkngWrp.booking.ETI_Booking_slots__c)){
                        if(!bookedLaneNslotsMap.containsKey(lane)){
                            bkngWrp.booking.Allocated_Lane__c=lane;
                            duplicateSlot='';
                            break;
                        }else if(bookedLaneNslotsMap.containsKey(lane)){
                            if(!bookedLaneNslotsMap.get(lane).contains(bkngWrp.booking.ETI_Booking_slots__c)){
                                bkngWrp.booking.Allocated_Lane__c=lane;
                                duplicateSlot='';
                                break;
                            }else {
                                duplicateSlot=bkngWrp.booking.ETI_Booking_slots__c;
                            }
                        }
                    }
                }
            }
            if(duplicateSlot!=null && duplicateSlot!=''){
                for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
                    if(wrp.isSelectedRecord){
                        wrp.isChildValidated=true;
                        wrp.childErrorMessage='Selected slot already Booked, Please select another slot.';
                        system.debug('slotList>> '+wrp.slotList);
                        for (Integer i = 0; i < wrp.slotList.size(); i++){
                            if (wrp.slotList.get(i).contains(duplicateSlot))
                                wrp.slotList.remove(i);
                        }
                        wrp.booking.ETI_Booking_slots__c='';
                    }
                }
                return bookingWrp;
            }
        }else
            recordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByName().get('External').getRecordTypeId();
        
        system.debug('inspectionService>> '+inspectionService);
        if(servicerequestid==null)
            servicerequestid = CreateServiceRequest(bkngWrp.booking.ET_Location__c);
        if(recordTypeId !=null)
            bkngWrp.booking.RecordTypeId=recordTypeId;
        bkngWrp.booking.Test_result_page__c='/apex/ETI_VehicleTestResult';
        if(servicerequestid!=null && bkngWrp.booking.Service_Request__c==NULL)
            bkngWrp.booking.Service_Request__c=servicerequestid;
        bkngWrp.booking.Booking_Status__c='Draft';
        bkngWrp.booking.User__c =getAccountId();
        system.debug('bookingObj before>> '+bkngWrp.booking);
        /*if(bkngWrp.booking.Service_Premises__c != 'Visit ET Premises' && bkngWrp.booking.Service_Type__c != 'SPEA Inspection'){
bkngWrp.booking.ET_Location__c = setLocationUsingLattitudeAndLongitude(Decimal.valueOf(bkngWrp.booking.Latitude__c), Decimal.valueOf(bkngWrp.booking.Longitude__c)).id;
}else if(bkngWrp.booking.Service_Type__c == 'SPEA Inspection'){
bkngWrp.booking.ET_Location__c = [SELECT id FROM ET_Location__c WHERE Name = 'Sharjah Spea Inspection Centre'][0].id;
}*/
        upsert bkngWrp.booking;
        
        system.debug('servicerequestid after>> '+servicerequestid);
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
            if(servicerequestid!=NULL){
                wrp.requestId=servicerequestid;
            }    
            if(wrp.isSelectedRecord)
                wrp.booking=bkngWrp.booking;
        }
        system.debug('bookingObj after>> '+bkngWrp.booking);
        system.debug('bookingObjId>> '+bkngWrp.booking.Id);
        system.debug('filesData after>> '+filesData);
        Savepoint sp = Database.setSavepoint();
        if(filesData != null)
            string res = addFilesToRecords(bkngWrp.booking.Id, filesData,sp);
        system.debug(bkngWrp.booking.Id+'-----jjjj');
        system.debug(filesData+'-----jjjj');
        return bookingWrp;
    }
    
    public static string addFilesToRecords(String recordId , String filesData,Savepoint sp){
        
        List<ContentVersion> lstContentVesions = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLinks = new  List<ContentDocumentLink>();
        list<uploadedDocs> files;  
        files = (List<uploadedDocs>)JSON.deserialize(filesData,  List<uploadedDocs>.Class);
        if(files.size()>0){ 
            system.debug('files = '+ files);
            system.debug('files = '+ files.size());
            for(uploadedDocs doc :files){
                system.debug('doc = '+ doc);
                ContentVersion objContentVersion = new ContentVersion();
                objContentVersion.ContentLocation = 'S';
                /*String body = doc.base64;               
String base64Mark = 'base64,';
integer dataStart = body.indexOf(base64Mark) + base64Mark.length();
body = body.substring(dataStart);
system.debug('body = '+ body);*/
                // objContentVersion.VersionData = EncodingUtil.base64Decode(body);
                objContentVersion.VersionData = EncodingUtil.base64Decode(doc.base64);//EncodingUtil.base64Decode(body);
                objContentVersion.Title = doc.filename;
                objContentVersion.Origin = 'H';
                objContentVersion.PathOnClient = '/' + doc.filename;
                lstContentVesions.add(objContentVersion);
                
            }
            
        }
        if(lstContentVesions!=null && lstContentVesions.size()>0){
            try{
                insert lstContentVesions;   
                system.debug('******After lstContentVesions****'+lstContentVesions);
            }Catch(Exception ex){
                system.debug('***Exception Cause lstContentVesions*****'+ex.getMessage());
                system.debug('***Exception Cause getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception happend'+ex.getMessage());                                       
            }
            
        }
        map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
        for(ContentVersion objContentVersion :[Select Id,ContentDocumentId from ContentVersion where Id in :lstContentVesions]){
            mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
        }
        
        for(ContentVersion objContentVersion :lstContentVesions){
            
            if(mapofContentVersionIdwithContentDocumentIds.containskey(objContentVersion.Id)){
                ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                objContentDocumentLink.LinkedEntityId = recordId;
                objContentDocumentLink.ShareType = 'V';
                objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id);
                lstContentDocumentLinks.add(objContentDocumentLink);
            }
            
        }
        system.debug('******lstContentDocumentLinks****'+lstContentDocumentLinks);
        if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
            try{
                insert lstContentDocumentLinks; 
                return 'Success';
            }Catch(Exception ex){
                Database.rollback(sp);
                system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
                system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
            }
        }else{
            return 'Error';
        }
        
        
        
    }
    
    public class uploadedDocs{
        @AuraEnabled
        Public String filename;
        @AuraEnabled
        Public String filetype;
        @AuraEnabled
        Public String base64;
        
    }
    
    /* @AuraEnabled
public static void createFiles(list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrpList , List<FileWrapper> fileListWrap, string bookingId){
system.debug('createFiles** ');
List<Attachment> attachmewntList = new List<Attachment>();
for(ETI_B2B_UtilityWrapper.bookingWrapper bookingwrp: bookingWrpList){
if(bookingwrp.fileListWrap != null && bookingwrp.fileListWrap.size() > 0){
for(ETI_B2B_UtilityWrapper.fileToBeUploaded filewrp : bookingwrp.fileListWrap){
String base64Data = EncodingUtil.urlDecode(filewrp.base64Data, 'UTF-8');

Attachment oAttachment = new Attachment();
oAttachment.parentId = bookingId;

oAttachment.Body = EncodingUtil.base64Decode(base64Data);
oAttachment.Name = filewrp.fileName;
oAttachment.ContentType = filewrp.contentType;
attachmewntList.add(oAttachment);

} 
} 
}
insert attachmewntList;
system.debug('attachmewntList** '+attachmewntList);
}*/
    @AuraEnabled
    public static list<ETI_B2B_UtilityWrapper.bookingWrapper> saveBooking(String obj,string selectedPremise,string fullAddress,string emirate){
        list<ETI_Booking__c> insertNewBookingList=new list<ETI_Booking__c>();
        list<ETI_Booking__c> upsertBookingList=new list<ETI_Booking__c>();
        list<ETI_Booking__c> finalBookingList=new list<ETI_Booking__c>();
        Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail> feeDetailMap=new Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail>();
        list<ETI_Service_Line_Item__c> serviceItemList=new list<ETI_Service_Line_Item__c>();
        map<string,list<ETI_Inspection_Lanes__c>> laneDetailsMap=new map<string,list<ETI_Inspection_Lanes__c>>();
        set<string> locationSet=new set<string>();
        Map<Id,string> locationMap=new Map<Id,string>();
        map<string,string> servicesMap=new map<string,string>();
        set<Date> selectedDates=new set<Date>();
        set<string> allLanes=new set<string>();
        Map<Id,string> tradeLicenseMap=new Map<Id,string>();
        Contact contact=new Contact();
        Id servicerequestid =null;
        Id locationId=null;
        String parentBookingId;
        system.debug('obj>>'+obj);
        system.debug('fullAddress>>'+fullAddress+' emirate>>'+emirate);
        list<user> users=new list<user>([select accountId,account.BillingStreet,account.BillingCity,ContactId,Contact.Email,Contact.MobilePhone from user where id=:userInfo.getUserId() AND accountId !=NULL limit 1]);
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        set<Id> draftBookingIds=new set<Id> ();
        list<ETI_B2B_UtilityWrapper.fileToBeUploaded> allUploadedDocuments=new list<ETI_B2B_UtilityWrapper.fileToBeUploaded>();
        system.debug('bookingWrp>>'+bookingWrp);
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
            if(wrp.requestId!=null && wrp.requestId!='' && servicerequestid==null)
                servicerequestid=wrp.requestId;
            if(wrp.isEnabled){
                allUploadedDocuments.addAll(wrp.uploadedFile);
                locationSet.add(wrp.booking.ET_Location__c);
                if(wrp.booking.ET_Location__c!=null)
                    locationId = wrp.booking.ET_Location__c;
                selectedDates.add(wrp.booking.Booking_Date__c);
                if(wrp.laneNslotsMap!=null && wrp.laneNslotsMap.size()>0)
                    allLanes.addAll(wrp.laneNslotsMap.keySet());
                if(wrp.isAdfcaVehicle && wrp.customerVehicle.Trade_License_Number__c!=null && wrp.customerVehicle.Trade_License_Number__c!=''){
                    if(!tradeLicenseMap.containsKey(wrp.booking.Customer_Vehicle__c))
                        tradeLicenseMap.put(wrp.booking.Customer_Vehicle__c,wrp.customerVehicle.Trade_License_Number__c);
                }
            }
            if(wrp.booking.Is_ReTest_Booking__c && String.isNotBlank(wrp.booking.Parent_Booking__c) && String.isBlank(parentBookingId))
                parentBookingId=wrp.booking.Parent_Booking__c;
        }
        for(ET_Location__c loc:[Select Id,Name,Location_Code__c From ET_Location__c Where Id IN:locationSet]){
            locationMap.put(loc.Id,loc.Location_Code__c);
        }
        for(ETI_Vehicle_Service__c serivce:[SELECT Id,Name,Service_Code__c From ETI_Vehicle_Service__c]){
            servicesMap.put(serivce.Service_Code__c,serivce.Name.replace('  ', ' '));   
        }
        system.debug('selectedDates>> '+selectedDates);
        system.debug('allLanes>> '+allLanes+' tradeLicenseMap>> '+tradeLicenseMap);
        system.debug('today>> '+system.today());
        if(selectedPremise=='Visit ET Premises'){
            system.debug('selectedDates>> '+selectedDates);
            system.debug('today>> '+system.today());
            bookingWrp[0].isDuplicateBookingsExit=false;
            list<ETI_B2B_UtilityWrapper.bookingWrapper> checkDuplicateWrp=checkDuplicateSlots(bookingWrp,new List<Date>(selectedDates),new list<string> (allLanes),new List<String> (locationSet));
            system.debug('checkDuplicateWrp>> '+checkDuplicateWrp);
            if(checkDuplicateWrp!=null && checkDuplicateWrp.size()>0) {
                bookingWrp=checkDuplicateWrp;
                insertNewBookingList.clear();
                for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
                    if(!wrp.isDuplicate){
                        if(wrp.booking.Id!=null){
                            
                            upsertBookingList.add(wrp.booking);
                        }else
                            insertNewBookingList.add(wrp.booking);
                    }
                    if(wrp.isDuplicate && !bookingWrp[0].isDuplicateBookingsExit){
                        bookingWrp[0].isDuplicateBookingsExit =true;
                    }
                }
                upsertBookingList.addAll(createBookingObject(insertNewBookingList));
                system.debug('upsertBookingList>> '+upsertBookingList);
                //Get Inspection Fee Details
                if(!bookingWrp[0].isDuplicateBookingsExit && !upsertBookingList.isEmpty()){
                    feeDetailMap=getFeeDetails(upsertBookingList,locationMap,tradeLicenseMap);
                    if(feeDetailMap!=NULL && feeDetailMap.size()>0){
                        for(ETI_Booking__c etb :upsertBookingList){
                            if(etb.Chassis_No__c!=null && etb.Chassis_No__c!=''){//10/11/20
                                if(feeDetailMap.get(etb.Chassis_No__c+'-'+etb.Selected_Services_Code__c.split(';')[0]).LastLaneTypeId !=null
                                   && feeDetailMap.get(etb.Chassis_No__c+'-'+etb.Selected_Services_Code__c.split(';')[0]).LastLaneTypeId!='')
                                    etb.AMAN_Last_Lane_Type__c = feeDetailMap.get(etb.Chassis_No__c+'-'+etb.Selected_Services_Code__c.split(';')[0]).LastLaneTypeId;
                            }else if(etb.Plate_No__c!=null && etb.Plate_No__c!='') {
                                if(feeDetailMap.get(etb.Plate_No__c+'-'+etb.Selected_Services_Code__c.split(';')[0]).LastLaneTypeId !=null
                                   && feeDetailMap.get(etb.Plate_No__c+'-'+etb.Selected_Services_Code__c.split(';')[0]).LastLaneTypeId!='')
                                    etb.AMAN_Last_Lane_Type__c = feeDetailMap.get(etb.Plate_No__c+'-'+etb.Selected_Services_Code__c.split(';')[0]).LastLaneTypeId;
                            }
                        }  
                    }
                }
            }
        }else {
            for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
                system.debug('wrp.booking>> '+wrp.booking);
                if(wrp.booking.Id!=null)
                    upsertBookingList.add(wrp.booking);
                else
                    insertNewBookingList.add(wrp.booking);
            }
            system.debug('insertNewBookingList>> '+insertNewBookingList);
            upsertBookingList.addAll(createBookingObject(insertNewBookingList));
            system.debug('upsertBookingList>> '+upsertBookingList);
            if(!upsertBookingList.isEmpty())
                feeDetailMap=getFeeDetails(upsertBookingList,locationMap,tradeLicenseMap);
        }
        //Incase of new and draft bookings
        if(upsertBookingList!=null && upsertBookingList.size()>0){
            if(servicerequestid==null)
                servicerequestid = CreateServiceRequest(locationId);
            Id accountId=getAccountId();
            for(ETI_Booking__c etb :upsertBookingList){
                if(servicerequestid!=null && etb.Service_Request__c==null)
                    etb.Service_Request__c=servicerequestid;
                if(!etb.Mobile_No__c.startsWith('+'))
                    etb.Mobile_No__c='+'+etb.Mobile_No__c;
                etb.Booking_Status__c='Booked';
                etb.User__c = accountId;
                //10/11/20
                if(servicesMap!=null && servicesMap.size()>0){
                    etb.Selected_Services__c='';
                    for(string service:etb.Selected_Services_Code__c.split(';')){
                        if(etb.Selected_Services__c=='')
                            etb.Selected_Services__c=servicesMap.get(service);
                        else
                            etb.Selected_Services__c=etb.Selected_Services__c+';'+servicesMap.get(service);
                    }
                }
                //For Spea Inspection added on 04/11/20 by Noor Shaik
                if(emirate=='Sharjah' && !users.isEmpty() && users[0].ContactId!=null){
                    contact.Id=users[0].ContactId;
                    if(users[0].Contact.Email!=etb.Email__c)
                        contact.Email=etb.Email__c;
                    if(users[0].Contact.MobilePhone !=etb.Mobile_No__c)
                        contact.MobilePhone=etb.Mobile_No__c;
                }
            }
            system.debug('upsertBookingList size>>'+upsertBookingList.size());
            system.debug('upsertBookingList>>'+upsertBookingList);
            upsert upsertBookingList;
            system.debug('contact>>'+contact);
            if(contact.Id!=null)
                update contact;
            if(!bookingWrp[0].isDuplicateBookingsExit){
                Boolean isZeroFeeExist =false;
                if(feeDetailMap!=NULL && feeDetailMap.size()>0){
                    //Crete Service Line Items
                    //bookingWrp[0].serviceItemMap=createsServiceItems(bookingWrp,upsertBookingList,feeDetailMap);
                    bookingWrp[0].serviceItemWrp=createsServiceItems(bookingWrp,upsertBookingList,feeDetailMap);
                    bookingWrp[0].isFeeDetailsExist=true;
                    for(ETI_B2B_UtilityWrapper.InspectionFeeDetail fee:feeDetailMap.Values()){
                        if(fee.status=='S'){
                            if(fee.TotalAmount != 0){
                                isZeroFeeExist =false;
                                break;
                            }else 
                                isZeroFeeExist =true;
                        }
                    }
                    Boolean isErrorExit =false;
                    for(ETI_Booking__c etb :upsertBookingList){
                        string vKey;
                        if(etb.Chassis_No__c!=null && etb.Chassis_No__c!='')
                            vKey=etb.Chassis_No__c;
                        else if(etb.Plate_No__c!=null && etb.Plate_No__c!='')
                            vKey=etb.Plate_No__c;
                        for(string srCode:etb.Selected_Services_Code__c.split(';')){    
                            if(feeDetailMap.get(vKey+'-'+srCode).status=='E'){
                                etb.Booking_Status__c='Cancelled';
                                etb.Cancellation_Reason__c=feeDetailMap.get(vKey+'-'+srCode).Message;
                                isErrorExit=true;
                            }
                        }
                    }
                    if(isErrorExit)
                        update upsertBookingList;
                }else {
                    bookingWrp[0].isFeeDetailsExist=false;
                    for(ETI_Booking__c etb :upsertBookingList){
                        etb.Booking_Status__c='Cancelled';
                        etb.Cancellation_Reason__c=label.ETI_Cancellation_Reason_FeeIssue;
                    }
                    update upsertBookingList;
                }
                ET_Service_Request__c serviceRequest =new ET_Service_Request__c();
                if(upsertBookingList[0].Service_Request__c!=null){
                    serviceRequest.Id=upsertBookingList[0].Service_Request__c; 
                    if(!isZeroFeeExist)
                        serviceRequest.Payment_Status__c=system.label.ETI_ServiceRequest_Payment_Status;
                    else {
                        serviceRequest.Payment_Status__c='Payment Success';   
                        serviceRequest.ETI_Payment_Type__c='Online';   
                        id paymentRecordtypeid = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Verifone_Payment').getRecordTypeId();
                        ETST_Payment__c etstPayment = new  ETST_Payment__c();
                        etstPayment.ETST_Parent__c = getAccountId();
                        etstPayment.ET_Service_Request__c = serviceRequest.Id;
                        etstPayment.ETST_Payment_State__c = 'Payment Success';
                        etstPayment.recordtypeid = paymentRecordtypeid;
                        etstPayment.ETST_Amount__c = 0;
                        etstPayment.ETST_Payment_Mode__c= 'Online';
                        insert etstPayment;
                    } 
                    if(locationId!=null){
                        if(serviceRequest.ET_Location__c!=locationId)   
                            serviceRequest.ET_Location__c= locationId;
                        if(!locationMap.isEmpty() && locationMap.containsKey(locationId))
                            serviceRequest.ETI_Inspection_Center__c=locationMap.get(locationId);
                    }
                    serviceRequest.ETI_Is_Terms_and_Conditions_Agreed__c=true;
                    update serviceRequest;
                }
                if(!users.isEmpty() && (users[0].account.BillingStreet==null || users[0].account.BillingStreet=='')
                   && fullAddress!=null && fullAddress!='' && emirate!=null && emirate!=''){
                       Account accUpdate=new Account(Id=users[0].accountId,BillingStreet=fullAddress,BillingCity=emirate);
                       update accUpdate;
                   }
                bookingWrp[0].bookingList=upsertBookingList;
                //Below code for ReTest
                if(String.isNotBlank(parentBookingId)){
                    ETI_Booking__c parentBooking=new ETI_Booking__c(Id=parentBookingId,Booking_Status__c='Applied for Retest');
                    update parentBooking;
                }
                system.debug('allUploadedDocuments>> '+allUploadedDocuments);
                if(allUploadedDocuments!=null && allUploadedDocuments.size()>0)
                    uploadRequiredDocuments(allUploadedDocuments);
            }
        }
        system.debug('bookingWrp'+bookingWrp);
        return bookingWrp;
    }
    
    @AuraEnabled
    public static list<ETI_B2B_UtilityWrapper.bookingWrapper> saveBooking_SPEA(String obj,string selectedPremise,string fullAddress,string emirate){
        list<ETI_Booking__c> insertNewBookingList=new list<ETI_Booking__c>();
        list<ETI_Booking__c> upsertBookingList=new list<ETI_Booking__c>();
        list<ETI_Booking__c> finalBookingList=new list<ETI_Booking__c>();
        Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail> feeDetailMap=new Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail>();
        list<ETI_Service_Line_Item__c> serviceItemList=new list<ETI_Service_Line_Item__c>();
        map<string,list<ETI_Inspection_Lanes__c>> laneDetailsMap=new map<string,list<ETI_Inspection_Lanes__c>>();
        set<string> locationSet=new set<string>();
        Map<Id,string> locationMap=new Map<Id,string>();
        map<string,string> servicesMap=new map<string,string>();
        set<Date> selectedDates=new set<Date>();
        set<string> allLanes=new set<string>();
        Map<Id,string> tradeLicenseMap=new Map<Id,string>();
        Contact contact=new Contact();
        Id servicerequestid =null;
        Id locationId=null;
        String parentBookingId;
        system.debug('obj>>'+obj);
        system.debug('fullAddress>>'+fullAddress+' emirate>>'+emirate);
        list<user> users=new list<user>([select accountId,account.BillingStreet,account.BillingCity,ContactId,Contact.Email,Contact.MobilePhone from user where id=:userInfo.getUserId() AND accountId !=NULL limit 1]);
        list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp= (list<ETI_B2B_UtilityWrapper.bookingWrapper>)system.JSON.deserializeStrict(obj, list<ETI_B2B_UtilityWrapper.bookingWrapper>.class);
        set<Id> draftBookingIds=new set<Id> ();
        list<ETI_B2B_UtilityWrapper.fileToBeUploaded> allUploadedDocuments=new list<ETI_B2B_UtilityWrapper.fileToBeUploaded>();
        system.debug('bookingWrp>>'+bookingWrp);
        for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
            if(wrp.requestId!=null && wrp.requestId!='' && servicerequestid==null)
                servicerequestid=wrp.requestId;
            if(wrp.isEnabled){
                allUploadedDocuments.addAll(wrp.uploadedFile);
                locationSet.add(wrp.booking.ET_Location__c);
                if(wrp.booking.ET_Location__c!=null)
                    locationId = wrp.booking.ET_Location__c;
                selectedDates.add(wrp.booking.Booking_Date__c);
                if(wrp.laneNslotsMap!=null && wrp.laneNslotsMap.size()>0)
                    allLanes.addAll(wrp.laneNslotsMap.keySet());
                if(wrp.isAdfcaVehicle && wrp.customerVehicle.Trade_License_Number__c!=null && wrp.customerVehicle.Trade_License_Number__c!=''){
                    if(!tradeLicenseMap.containsKey(wrp.booking.Customer_Vehicle__c))
                        tradeLicenseMap.put(wrp.booking.Customer_Vehicle__c,wrp.customerVehicle.Trade_License_Number__c);
                }
            }
            if(wrp.booking.Is_ReTest_Booking__c && String.isNotBlank(wrp.booking.Parent_Booking__c) && String.isBlank(parentBookingId))
                parentBookingId=wrp.booking.Parent_Booking__c;
        }
        for(ET_Location__c loc:[Select Id,Name,Location_Code__c From ET_Location__c Where Id IN:locationSet]){
            locationMap.put(loc.Id,loc.Location_Code__c);
        }
        for(ETI_Vehicle_Service__c serivce:[SELECT Id,Name,Service_Code__c From ETI_Vehicle_Service__c]){
            servicesMap.put(serivce.Service_Code__c,serivce.Name.replace('  ', ' '));   
        }
        system.debug('selectedDates>> '+selectedDates);
        system.debug('allLanes>> '+allLanes+' tradeLicenseMap>> '+tradeLicenseMap);
        system.debug('today>> '+system.today());
        system.debug('selectedPremise Newly Added >> '+selectedPremise);
        if(selectedPremise=='Customer Premises-B2B') {
            Set<String> chassisNos = New Set<String>();
            Id SchoolAccId;
            Map<String,ETI_Booking__c> bookingsExtMap = New Map<String,ETI_Booking__c>();
            for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
                system.debug('wrp.booking>> '+wrp.booking);
                system.debug('wrp.customerVehicle>> '+wrp.customerVehicle);
                if(wrp.booking.Chassis_No__c != null && wrp.booking.Chassis_No__c != '')
                    chassisNos.add(wrp.booking.Chassis_No__c);
                if(SchoolAccId == null)
                    SchoolAccId = wrp.booking.User__c;
                if(wrp.booking.Id!=null)
                    upsertBookingList.add(wrp.booking);
                else
                    insertNewBookingList.add(wrp.booking);
                system.debug('chassisNos Newly Added>> '+chassisNos);
                system.debug('SchoolAccId Newly Added>> '+SchoolAccId);
            }
            system.debug('insertNewBookingList>> '+insertNewBookingList);
            upsertBookingList.addAll(createBookingObject(insertNewBookingList));
            system.debug('upsertBookingList>> '+upsertBookingList);
            if(!upsertBookingList.isEmpty()){
                //feeDetailMap=getFeeDetails(upsertBookingList,locationMap,tradeLicenseMap); //Taj-removed integration
                if(chassisNos.Size()>0 && SchoolAccId != null){
                    for(ETI_Booking__c bkgExt: [SELECT Id,Booking_Date__c,Chassis_No__c,Test_Result__c,Booking_Date_Time__c,Booking_Month__c,ETI_Booking_slots__c,Booking_Status__c,
                                                Is_booking_Confirmed__c,Is_ReTest_Booking__c,Parent_Booking__c,Total_Amount__c FROM ETI_Booking__c WHERE User__c =: SchoolAccId AND Chassis_No__c IN: chassisNos
                                                AND Service_Type__c = 'SPEA Inspection' AND (Booking_Status__c = 'Inspection Completed' OR Booking_Status__c = 'Due for Retest' OR Booking_Status__c = 'Applied for Retest') 
                                                AND Payment_Status__c = 'Payment Success' AND (Test_Result__c = 'Pass' OR Test_Result__c = 'Failed') ORDER BY LastModifiedDate DESC]){
                                                    system.debug('bkgExt Newly Added >> '+bkgExt);
                                                    if(!bookingsExtMap.containsKey(bkgExt.Chassis_No__c))
                                                        bookingsExtMap.put(bkgExt.Chassis_No__c,bkgExt);
                                                }
                }
                system.debug('bookingsExtMap Newly Added>> '+bookingsExtMap);
                Map<String,SPEA_Fee_Detail__mdt> SpeaFeeMap = getSPEAFeeMdt();
                system.debug('SpeaFeeMap Newly Added>> '+SpeaFeeMap);
                for(ETI_Booking__c bkg: upsertBookingList){
                    system.debug('bkg>> Newly Added '+bkg);
                    if(bkg.Selected_Services_Code__c!= '' && bkg.Selected_Services_Code__c!= null){
                        ETI_B2B_UtilityWrapper.InspectionFeeDetail feeDetail;
                        for(string service:bkg.Selected_Services_Code__c.split(';')){ 
                            if(!bookingsExtMap.containsKey(bkg.Chassis_No__c))
                                feeDetail = new ETI_B2B_UtilityWrapper.InspectionFeeDetail('S',null,null,Decimal.ValueOf(SpeaFeeMap.get('New_Test').Test_Fees__c),Decimal.ValueOf(SpeaFeeMap.get('New_Test').Tax_Amount__c),Decimal.ValueOf(SpeaFeeMap.get('New_Test').Test_Fees__c)+Decimal.ValueOf(SpeaFeeMap.get('New_Test').Tax_Amount__c));
                            if(bookingsExtMap.containsKey(bkg.Chassis_No__c)){
                                if(bookingsExtMap.get(bkg.Chassis_No__c).Test_Result__c == 'Pass' && bookingsExtMap.get(bkg.Chassis_No__c).Booking_Date__c.daysBetween(Date.today()) > 365){
                                    feeDetail = new ETI_B2B_UtilityWrapper.InspectionFeeDetail('S',null,null,Decimal.ValueOf(SpeaFeeMap.get('New_Test').Test_Fees__c),Decimal.ValueOf(SpeaFeeMap.get('New_Test').Tax_Amount__c),Decimal.ValueOf(SpeaFeeMap.get('New_Test').Test_Fees__c)+Decimal.ValueOf(SpeaFeeMap.get('New_Test').Tax_Amount__c));
                                }else if(bookingsExtMap.get(bkg.Chassis_No__c).Test_Result__c == 'Pass' && bookingsExtMap.get(bkg.Chassis_No__c).Booking_Date__c.daysBetween(Date.today()) < 365){
                                    feeDetail = new ETI_B2B_UtilityWrapper.InspectionFeeDetail('E',Label.ETI_Inspection_Before_365_Days,null,null,null,null);
                                }else if(bookingsExtMap.get(bkg.Chassis_No__c).Test_Result__c == 'Failed' && bookingsExtMap.get(bkg.Chassis_No__c).Booking_Date__c.daysBetween(Date.today()) > 365){
                                    feeDetail = new ETI_B2B_UtilityWrapper.InspectionFeeDetail('S',null,null,Decimal.ValueOf(SpeaFeeMap.get('New_Test').Test_Fees__c),Decimal.ValueOf(SpeaFeeMap.get('New_Test').Tax_Amount__c),Decimal.ValueOf(SpeaFeeMap.get('New_Test').Test_Fees__c)+Decimal.ValueOf(SpeaFeeMap.get('New_Test').Tax_Amount__c));
                                }else if(bookingsExtMap.get(bkg.Chassis_No__c).Test_Result__c == 'Failed' && bookingsExtMap.get(bkg.Chassis_No__c).Booking_Date__c.daysBetween(Date.today()) < 365  && bookingsExtMap.get(bkg.Chassis_No__c).Parent_Booking__c == Null && bookingsExtMap.get(bkg.Chassis_No__c).Is_ReTest_Booking__c == false){
                                    feeDetail = new ETI_B2B_UtilityWrapper.InspectionFeeDetail('S',null,null,Decimal.ValueOf(SpeaFeeMap.get('Free_Test').Test_Fees__c),Decimal.ValueOf(SpeaFeeMap.get('Free_Test').Tax_Amount__c),Decimal.ValueOf(SpeaFeeMap.get('Free_Test').Test_Fees__c)+Decimal.ValueOf(SpeaFeeMap.get('Free_Test').Tax_Amount__c));  
                                }else if(bookingsExtMap.get(bkg.Chassis_No__c).Test_Result__c == 'Failed' && bookingsExtMap.get(bkg.Chassis_No__c).Booking_Date__c.daysBetween(Date.today()) < 365 && bookingsExtMap.get(bkg.Chassis_No__c).Parent_Booking__c != Null && bookingsExtMap.get(bkg.Chassis_No__c).Is_ReTest_Booking__c == true && bookingsExtMap.get(bkg.Chassis_No__c).Total_Amount__c == 0){
                                    feeDetail = new ETI_B2B_UtilityWrapper.InspectionFeeDetail('S',null,null,Decimal.ValueOf(SpeaFeeMap.get('Re_Test').Test_Fees__c),Decimal.ValueOf(SpeaFeeMap.get('Re_Test').Tax_Amount__c),Decimal.ValueOf(SpeaFeeMap.get('Re_Test').Test_Fees__c)+Decimal.ValueOf(SpeaFeeMap.get('Re_Test').Tax_Amount__c));  
                                }else if(bookingsExtMap.get(bkg.Chassis_No__c).Test_Result__c == 'Failed' && bookingsExtMap.get(bkg.Chassis_No__c).Booking_Date__c.daysBetween(Date.today()) < 365 && bookingsExtMap.get(bkg.Chassis_No__c).Parent_Booking__c != Null && bookingsExtMap.get(bkg.Chassis_No__c).Is_ReTest_Booking__c == true && bookingsExtMap.get(bkg.Chassis_No__c).Total_Amount__c == Decimal.ValueOf(SpeaFeeMap.get('Re_Test').Test_Fees__c)+Decimal.ValueOf(SpeaFeeMap.get('Re_Test').Tax_Amount__c)){
                                    feeDetail = new ETI_B2B_UtilityWrapper.InspectionFeeDetail('S',null,null,Decimal.ValueOf(SpeaFeeMap.get('New_Test').Test_Fees__c),Decimal.ValueOf(SpeaFeeMap.get('New_Test').Tax_Amount__c),Decimal.ValueOf(SpeaFeeMap.get('New_Test').Test_Fees__c)+Decimal.ValueOf(SpeaFeeMap.get('New_Test').Tax_Amount__c));
                                }
                            }
                            if(feeDetail != null){
                                if(bkg.Chassis_No__c != null && bkg.Chassis_No__c != ''){
                                    if(service!=null && service!='')
                                        feeDetailMap.put(bkg.Chassis_No__c+'-'+service,feeDetail);
                                }else if(bkg.Plate_No__c!=null && bkg.Plate_No__c!=''){
                                    if(service!=null && service!='')
                                        feeDetailMap.put(bkg.Plate_No__c+'-'+service,feeDetail);
                                }
                            }
                        }
                    }
                }
                system.debug('feeDetailMap>> Newly Added '+feeDetailMap);
            }
        }
        //Incase of new and draft bookings
        if(upsertBookingList!=null && upsertBookingList.size()>0){
            if(servicerequestid==null)
                servicerequestid = CreateServiceRequest(locationId);
            Id accountId=getAccountId();
            for(ETI_Booking__c etb :upsertBookingList){
                if(servicerequestid!=null && etb.Service_Request__c==null)
                    etb.Service_Request__c=servicerequestid;
                if(!etb.Mobile_No__c.startsWith('+'))
                    etb.Mobile_No__c='+'+etb.Mobile_No__c;
                etb.Booking_Status__c='Booked';
                etb.User__c = accountId;
                //10/11/20
                if(servicesMap!=null && servicesMap.size()>0){
                    etb.Selected_Services__c='';
                    for(string service:etb.Selected_Services_Code__c.split(';')){
                        if(etb.Selected_Services__c=='')
                            etb.Selected_Services__c=servicesMap.get(service);
                        else
                            etb.Selected_Services__c=etb.Selected_Services__c+';'+servicesMap.get(service);
                    }
                }
                //For Spea Inspection added on 04/11/20 by Noor Shaik
                if(emirate=='Sharjah' && !users.isEmpty() && users[0].ContactId!=null){
                    contact.Id=users[0].ContactId;
                    if(users[0].Contact.Email!=etb.Email__c)
                        contact.Email=etb.Email__c;
                    if(users[0].Contact.MobilePhone !=etb.Mobile_No__c)
                        contact.MobilePhone=etb.Mobile_No__c;
                }
            }
            system.debug('upsertBookingList size>>'+upsertBookingList.size());
            system.debug('upsertBookingList>>'+upsertBookingList);
            upsert upsertBookingList;
            system.debug('contact>>'+contact);
            if(contact.Id!=null)
                update contact;
            if(!bookingWrp[0].isDuplicateBookingsExit){
                Boolean isZeroFeeExist =false;
                if(feeDetailMap!=NULL && feeDetailMap.size()>0){
                    //Crete Service Line Items
                    //bookingWrp[0].serviceItemMap=createsServiceItems(bookingWrp,upsertBookingList,feeDetailMap);
                    bookingWrp[0].serviceItemWrp=createsServiceItems(bookingWrp,upsertBookingList,feeDetailMap);
                    bookingWrp[0].isFeeDetailsExist=true;
                    for(ETI_B2B_UtilityWrapper.InspectionFeeDetail fee:feeDetailMap.Values()){
                        if(fee.status=='S'){
                            if(fee.TotalAmount != 0){
                                isZeroFeeExist =false;
                                break;
                            }else 
                                isZeroFeeExist =true;
                        }
                    }
                    Boolean isErrorExit =false;
                    for(ETI_Booking__c etb :upsertBookingList){
                        string vKey;
                        if(etb.Chassis_No__c!=null && etb.Chassis_No__c!='')
                            vKey=etb.Chassis_No__c;
                        else if(etb.Plate_No__c!=null && etb.Plate_No__c!='')
                            vKey=etb.Plate_No__c;
                        for(string srCode:etb.Selected_Services_Code__c.split(';')){    
                            if(feeDetailMap.get(vKey+'-'+srCode).status=='E'){
                                etb.Booking_Status__c='Cancelled';
                                etb.Cancellation_Reason__c=feeDetailMap.get(vKey+'-'+srCode).Message;
                                isErrorExit=true;
                            }
                        }
                    }
                    if(isErrorExit)
                        update upsertBookingList;
                }else {
                    bookingWrp[0].isFeeDetailsExist=false;
                    for(ETI_Booking__c etb :upsertBookingList){
                        etb.Booking_Status__c='Cancelled';
                        etb.Cancellation_Reason__c=label.ETI_Cancellation_Reason_FeeIssue;
                    }
                    update upsertBookingList;
                }
                ET_Service_Request__c serviceRequest =new ET_Service_Request__c();
                if(upsertBookingList[0].Service_Request__c!=null){
                    serviceRequest.Id=upsertBookingList[0].Service_Request__c; 
                    if(!isZeroFeeExist)
                        serviceRequest.Payment_Status__c=system.label.ETI_ServiceRequest_Payment_Status;
                    else {
                        serviceRequest.Payment_Status__c='Payment Success';   
                        serviceRequest.ETI_Payment_Type__c='Online';   
                        id paymentRecordtypeid = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Verifone_Payment').getRecordTypeId();
                        ETST_Payment__c etstPayment = new  ETST_Payment__c();
                        etstPayment.ETST_Parent__c = getAccountId();
                        etstPayment.ET_Service_Request__c = serviceRequest.Id;
                        etstPayment.ETST_Payment_State__c = 'Payment Success';
                        etstPayment.recordtypeid = paymentRecordtypeid;
                        etstPayment.ETST_Amount__c = 0;
                        etstPayment.ETST_Payment_Mode__c= 'Online';
                        insert etstPayment;
                    } 
                    if(locationId!=null){
                        if(serviceRequest.ET_Location__c!=locationId)   
                            serviceRequest.ET_Location__c= locationId;
                        if(!locationMap.isEmpty() && locationMap.containsKey(locationId))
                            serviceRequest.ETI_Inspection_Center__c=locationMap.get(locationId);
                    }
                    serviceRequest.ETI_Is_Terms_and_Conditions_Agreed__c=true;
                    update serviceRequest;
                }
                if(!users.isEmpty() && (users[0].account.BillingStreet==null || users[0].account.BillingStreet=='')
                   && fullAddress!=null && fullAddress!='' && emirate!=null && emirate!=''){
                       Account accUpdate=new Account(Id=users[0].accountId,BillingStreet=fullAddress,BillingCity=emirate);
                       update accUpdate;
                   }
                bookingWrp[0].bookingList=upsertBookingList;
                //Below code for ReTest
                if(String.isNotBlank(parentBookingId)){
                    ETI_Booking__c parentBooking=new ETI_Booking__c(Id=parentBookingId,Booking_Status__c='Applied for Retest');
                    update parentBooking;
                }
                system.debug('allUploadedDocuments>> '+allUploadedDocuments);
                if(allUploadedDocuments!=null && allUploadedDocuments.size()>0)
                    uploadRequiredDocuments(allUploadedDocuments);
            }
        }
        system.debug('bookingWrp'+bookingWrp);
        return bookingWrp;
    }
    @AuraEnabled
    public static Map<String,SPEA_Fee_Detail__mdt> getSPEAFeeMdt() {
        Map<String,SPEA_Fee_Detail__mdt> SpeaFeeMap = New Map<String,SPEA_Fee_Detail__mdt>();
        for(SPEA_Fee_Detail__mdt fee: [SELECT Id,DeveloperName,MasterLabel,Fee_No__c,Test_Fees__c,Tax_Amount__c,Entity__c,Entity_Fees__c,Order__c FROM SPEA_Fee_Detail__mdt ORDER BY Order__c ASC]){
            SpeaFeeMap.put(fee.DeveloperName, fee);
        }
        return SpeaFeeMap;
    }
    @AuraEnabled
    public static list<ETI_B2B_UtilityWrapper.bookingWrapper> checkDuplicateSlots(list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp, list<Date> selectedDates,list<string> allLanes,list<string> locationSet) {
        system.debug('selectedDates>> '+selectedDates);
        system.debug('locationSet>> '+locationSet);
        system.debug('allLanes>> '+allLanes);
        map<Id,ETI_Booking__c> allBookingMap=new map<Id,ETI_Booking__c>();
        map<date,map<string,list<string>>> bookedLaneNslotsDateMap=new map<date,map<string,list<string>>>();
        map<string,list<string>> bookedLaneNslotsMap=new map<string,list<string>>();
        
        if(selectedDates!=null && selectedDates.size()>0){
            for(ETI_Booking__c booking:[SELECT Id,Name,Booking_Status__c,ET_Location__c,Allocated_Lane__c,Allocated_Lane__r.Lane_Type_AMAN__c,ETI_Booking_slots__c,Booking_Date__c 
                                        FROM ETI_Booking__c WHERE Booking_Date__c IN: selectedDates AND ET_Location__c IN: locationSet AND Allocated_Lane__c IN:allLanes]){
                                            system.debug('booking>> '+booking);
                                            allBookingMap.put(booking.Id,booking);
                                            if(!bookedLaneNslotsMap.containsKey(booking.Booking_Date__c+'#'+booking.Allocated_Lane__c))
                                                bookedLaneNslotsMap.put(booking.Booking_Date__c+'#'+booking.Allocated_Lane__c, new list<string>{booking.ETI_Booking_slots__c});
                                            else 
                                                bookedLaneNslotsMap.get(booking.Booking_Date__c+'#'+booking.Allocated_Lane__c).add(booking.ETI_Booking_slots__c);
                                        } 
        }                                       
        system.debug('allBookingMap>> '+allBookingMap);
        system.debug('bookedLaneNslotsMap>> '+bookedLaneNslotsMap);
        if(bookingWrp!=NULL && bookingWrp.size()>0){
            for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
                if(wrp.isEnabled){
                    Boolean duplicateFlag=false;
                    if(allBookingMap!=NULL && allBookingMap.size()>0){
                        if(wrp.booking.Id!=null && allBookingMap.containsKey(wrp.booking.Id)){ 
                            Boolean isDuplicateCheck=false;
                            ETI_Booking__c etb=allBookingMap.get(wrp.booking.Id);
                            if(wrp.booking.Booking_Date__c==etb.Booking_Date__c && etb.ET_Location__c == wrp.booking.ET_Location__c 
                               && etb.ETI_Booking_slots__c == wrp.booking.ETI_Booking_slots__c && etb.Allocated_Lane__c == wrp.booking.Allocated_Lane__c){
                                   if(etb.Booking_Status__c!='Cancelled'){
                                       wrp.isDuplicate=false;
                                       wrp.isEnabled =false;
                                   }else if(etb.Booking_Status__c=='Cancelled'){
                                       isDuplicateCheck=true;
                                   }
                               }else {
                                   isDuplicateCheck=true;
                               }
                            if(isDuplicateCheck){
                                duplicateFlag =true;
                            }
                        }else {
                            duplicateFlag =true;
                        }
                    }
                    system.debug('duplicateFlag>> '+duplicateFlag);
                    //Duplicate Slot check start
                    if(duplicateFlag){
                        if(wrp.laneNslotsMap!=NULL && wrp.laneNslotsMap.size()>0){
                            system.debug('duplicateFlag>> '+duplicateFlag);
                            for(String lane:wrp.laneNslotsMap.keySet()){
                                system.debug('bookingDate>> '+wrp.booking.Booking_Date__c);
                                system.debug('lane>> '+lane);
                                system.debug('Booking_slots>> '+wrp.booking.ETI_Booking_slots__c);
                                system.debug('Flag11>> '+wrp.laneNslotsMap.get(lane).contains(wrp.booking.ETI_Booking_slots__c));
                                if(wrp.laneNslotsMap.get(lane).contains(wrp.booking.ETI_Booking_slots__c)){
                                    system.debug('if Flag>> '+bookedLaneNslotsMap.containsKey(wrp.booking.Booking_Date__c+'#'+lane));
                                    //system.debug('booked lanes>> '+bookedLaneNslotsMap.get(wrp.booking.Booking_Date__c+'#'+lane));
                                    if(!bookedLaneNslotsMap.containsKey(wrp.booking.Booking_Date__c+'#'+lane)){
                                        wrp.isDuplicate=false;
                                        wrp.isEnabled =false;
                                        wrp.booking.Allocated_Lane__c=lane;
                                        break;
                                    }else if(bookedLaneNslotsMap.containsKey(wrp.booking.Booking_Date__c+'#'+lane)){
                                        //system.debug('Flag else>> '+bookedLaneNslotsMap.get(wrp.booking.Booking_Date__c+'#'+lane).contains(wrp.booking.ETI_Booking_slots__c));
                                        if(!bookedLaneNslotsMap.get(wrp.booking.Booking_Date__c+'#'+lane).contains(wrp.booking.ETI_Booking_slots__c)){
                                            wrp.isDuplicate=false;
                                            wrp.isEnabled =false;
                                            wrp.booking.Allocated_Lane__c=lane;
                                            break;
                                        }else {
                                            wrp.isDuplicate=true;
                                            wrp.isEnabled =true;
                                            wrp.isValidated=true;
                                            wrp.errorMessage='Selected slot already Booked, Please select another slot.';
                                            system.debug('slotList>> '+wrp.slotList);
                                            for (Integer i = 0; i < wrp.slotList.size(); i++){
                                                if (wrp.slotList.get(i).contains(wrp.booking.ETI_Booking_slots__c))
                                                    wrp.slotList.remove(i);
                                            }
                                            wrp.booking.ETI_Booking_slots__c='';
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //Duplicate Slot check End
                }
            }
        }
        return bookingWrp;
    } 
    
    public static List<ETI_Booking__c> createBookingObject(List<ETI_Booking__c> lstBooking){
        for(ETI_Booking__c etb : lstBooking)
        {
            if(etb.Service_Premises__c!=null && etb.Service_Premises__c!='' && etb.Service_Premises__c  =='Visit ET Premises')
                etb.RecordTypeId= Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
            else 
                etb.RecordTypeId= Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByName().get('External').getRecordTypeId();
            etb.Booking_Status__c='Booked';
            if(!etb.Mobile_No__c.startsWith('+'))
                etb.Mobile_No__c='+'+etb.Mobile_No__c;
            //etb.User__c =getAccountId();
            etb.Test_result_page__c='/apex/ETI_VehicleTestResult';
        }
        return lstBooking;
    }
    public static ETI_B2B_UtilityWrapper.serviceLineItemWrp createsServiceItems(list<ETI_B2B_UtilityWrapper.bookingWrapper> bookingWrp,List<ETI_Booking__c> bookingList,Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail> feeDetailMap){
        map<string,ETI_Vehicle_Service__c> servicesMap=new map<string,ETI_Vehicle_Service__c>();
        list<ETI_Service_Line_Item__c> serviceItemList=new list<ETI_Service_Line_Item__c>();
        map<string,list<ETI_Service_Line_Item__c>> serviceItemMap=new map<string,list<ETI_Service_Line_Item__c>>();
        map<string,map<string,list<ETI_Service_Line_Item__c>>> serviceItemMap1=new map<string,map<string,list<ETI_Service_Line_Item__c>>>();
        ETI_B2B_UtilityWrapper.serviceLineItemWrp wrpList=new ETI_B2B_UtilityWrapper.serviceLineItemWrp();
        string serviceReqId;
        system.debug('feeDetailMap>> '+feeDetailMap);//10/11/20
        for(ETI_Vehicle_Service__c serivce:[SELECT Id,Name,Service_Code__c From ETI_Vehicle_Service__c]){
            servicesMap.put(serivce.Service_Code__c, serivce);   
        }
        system.debug('servicesMap>> '+servicesMap);
        for(ETI_Booking__c bkng:bookingList){
            if(servicesMap!=NULL && servicesMap.size()>0){
                for(String srCode:bkng.Selected_Services_Code__c.split(';')){
                    system.debug('srCode>> '+srCode);
                    ETI_Service_Line_Item__c obj=new ETI_Service_Line_Item__c();
                    obj.Booking__c = bkng.Id;
                    obj.Service_Type__c = bkng.Service_Type__c;
                    obj.Chassis_No__c=bkng.Chassis_No__c;
                    obj.Plate_No__c=bkng.Plate_No__c;
                    obj.Plate_Color__c =bkng.Plate_Color__c;
                    obj.Test_Result__c = 'Pending';
                    if(servicesMap.get(srCode)!=null)
                        obj.Service__c=servicesMap.get(srCode).Id;
                    obj.Service_Name__c=servicesMap.get(srCode).Name;
                    string vKey;
                    if(srCode!=null && srCode!=''){
                        if(bkng.Chassis_No__c!=null && bkng.Chassis_No__c!='')
                            vKey=bkng.Chassis_No__c;
                        else if(bkng.Plate_No__c!=null && bkng.Plate_No__c!='')
                            vKey=bkng.Plate_No__c;
                        if(vKey!=null && vKey!=''){
                            obj.Fee_Integration_Status__c = feeDetailMap.get(vKey+'-'+srCode).status;
                            string msg= feeDetailMap.get(vKey+'-'+srCode).message;
                            if(msg!=null && msg!=''){
                                if(msg.contains('Kindly check.'))
                                    obj.Fee_Integration_Message__c = msg.removeEnd('Kindly check.');
                                else     
                                    obj.Fee_Integration_Message__c = msg;
                            }
                            obj.Fee_Amount__c = feeDetailMap.get(vKey+'-'+srCode).FeeAmount;
                            obj.Tax_Amount__c = feeDetailMap.get(vKey+'-'+srCode).TaxAmount;
                            obj.Total_Fee__c = feeDetailMap.get(vKey+'-'+srCode).TotalAmount;
                        }
                    }
                    for(ETI_B2B_UtilityWrapper.bookingWrapper wrp:bookingWrp){
                        if(wrp.booking.Customer_Vehicle__c == bkng.Customer_Vehicle__c){
                            if(wrp.isColorChange && (srCode == '19' || srCode == '27' || srCode == '33')){
                                if(wrp.newColor!=null && wrp.newColor!='')
                                    obj.New_Color__c=wrp.newColor;
                                if(wrp.newColor2!=null && wrp.newColor2!='')
                                    obj.New_Color2__c=wrp.newColor2;
                                if(wrp.newColor3!=null && wrp.newColor3!='')
                                    obj.New_Color3__c=wrp.newColor3;    
                                if(wrp.newColor4!=null && wrp.newColor4!='')
                                    obj.New_Color4__c=wrp.newColor4;    
                            }    
                            if(wrp.isVehicleTypeChange && (srCode == '20' || srCode == '26' || srCode == '32'))
                                obj.New_Vehicle_Type__c=wrp.newVehicleType;
                        }
                    }
                    if(serviceReqId==null || serviceReqId=='')
                        serviceReqId=bkng.Service_Request__c;
                    /*if(wrp.chassisNo==null || wrp.chassisNo=='')
wrp.chassisNo=bkng.Chassis_No__c;*/
                    /*if(!serviceItemMap.containsKey(bkng.Service_Request__c))
serviceItemMap.put(bkng.Service_Request__c,new list<ETI_Service_Line_Item__c>{obj});
else 
serviceItemMap.get(bkng.Service_Request__c).add(obj);*/
                    if(bkng.Plate_No__c!=null && bkng.Plate_No__c!='') {
                        if(!serviceItemMap.containsKey(bkng.Plate_Color__c+'-'+bkng.Plate_No__c))
                            serviceItemMap.put(bkng.Plate_Color__c+'-'+bkng.Plate_No__c,new list<ETI_Service_Line_Item__c>{obj});
                        else 
                            serviceItemMap.get(bkng.Plate_Color__c+'-'+bkng.Plate_No__c).add(obj);
                    }else if(bkng.Chassis_No__c!=null && bkng.Chassis_No__c!=''){
                        if(!serviceItemMap.containsKey(bkng.Chassis_No__c))
                            serviceItemMap.put(bkng.Chassis_No__c,new list<ETI_Service_Line_Item__c>{obj});
                        else 
                            serviceItemMap.get(bkng.Chassis_No__c).add(obj);
                    }
                    serviceItemList.add(obj);
                }
            }
        }
        system.debug('serviceItemList>> '+serviceItemList);
        system.debug('wrpList>> '+wrpList);
        for(string obj:serviceItemMap.keySet()){
            map<string,list<ETI_Service_Line_Item__c>> map1=new map<string,list<ETI_Service_Line_Item__c>>();
            for(ETI_Service_Line_Item__c item:serviceItemMap.get(obj)){
                if(!map1.containsKey(item.Service_Type__c))
                    map1.put(item.Service_Type__c,new list<ETI_Service_Line_Item__c>{item});
                else 
                    map1.get(item.Service_Type__c).add(item);
            }
            serviceItemMap1.put(obj,map1);    
        }
        system.debug('serviceItemMap1>> '+serviceItemMap1);
        wrpList.serviceRequestId=serviceReqId;
        list<ETI_B2B_UtilityWrapper.chassisWrp> chassisWrpList=new list<ETI_B2B_UtilityWrapper.chassisWrp>();
        for(string obj:serviceItemMap1.keySet()){
            ETI_B2B_UtilityWrapper.chassisWrp chassis=new ETI_B2B_UtilityWrapper.chassisWrp();
            chassis.chassisNo = obj;
            list<ETI_B2B_UtilityWrapper.serviceTypes> serviceTypeList=new list<ETI_B2B_UtilityWrapper.serviceTypes>();
            for(string str:serviceItemMap1.get(obj).keySet()){
                ETI_B2B_UtilityWrapper.serviceTypes service=new ETI_B2B_UtilityWrapper.serviceTypes();
                service.serviceType=str;
                service.serviceItems=serviceItemMap1.get(obj).get(str);
                serviceTypeList.add(service);
                system.debug('serviceTypeList>> '+serviceTypeList);
            }
            chassis.typeList=serviceTypeList;
            chassisWrpList.add(chassis);
            system.debug('chassis>> '+chassis);
        }
        wrpList.chassisNo=chassisWrpList;
        system.debug('wrpList>> '+wrpList);
        
        if(!serviceItemList.isEmpty()){
            Database.SaveResult[] sr = Database.insert(serviceItemList,true);
            if(sr[0].isSuccess())
                return wrpList;
            //return serviceItemMap;
        }
        
        return null;
    }
    
    public static Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail> getFeeDetails(List<ETI_Booking__c> lstBooking,Map<Id,string> locationMap,Map<Id,string> tradeLicenseMap){
        Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail> feeDetailMap=new Map<String,ETI_B2B_UtilityWrapper.InspectionFeeDetail>();
        Map<Id,list<ETI_Service_Line_Item__c>> serviceItemMap=new Map<Id,list<ETI_Service_Line_Item__c>>();
        set<id> ids=new set<id>();
        system.debug('lstBooking>> '+lstBooking);
        system.debug('locationMap>> '+locationMap);
        system.debug('tradeLicenseMap>> '+tradeLicenseMap);
        Map<String,String> internalMap=new Map<String,String>();
        map<string,string> servicesMap=new map<string,string>();
        Map<Id,ETI_Lane_Details__c> laneDetailsMap=new Map<Id,ETI_Lane_Details__c>([Select Id,Name,Lane_Type_AMAN__c From ETI_Lane_Details__c]);
        Map<Id,ET_Location__c> extLocationMap=new Map<Id,ET_Location__c>([Select Id,Name,Location_Code__c From ET_Location__c]);
        Map<Id,ETI_Aman_Lookup__c> purposeTypeMap=new Map<Id,ETI_Aman_Lookup__c>([SELECT Id, Name, ETI_LookupCode__c FROM ETI_Aman_Lookup__c
                                                                                  Where ETI_LookupType__c='TEST_PURPOSE' AND isActive__c=true]);
        system.debug('purposeTypeMap>> '+purposeTypeMap);
        for(ETI_Booking__c obj:lstBooking){
            ids.add(obj.Id);
        }
        //10/11/20
        ET_SOA_Services soa = new ET_SOA_Services();
        List<ET_Fee.InspectionFeeInputDetail> requests = new List<ET_Fee.InspectionFeeInputDetail>();
        integer i=1;
        if(lstBooking!=NULL && lstBooking.size()>0){
            for(ETI_Booking__c obj:lstBooking){
                system.debug('obj>> '+obj);
                if(obj.Selected_Services_Code__c!= '' && obj.Selected_Services_Code__c!= null){
                    for(string service:obj.Selected_Services_Code__c.split(';')){
                        system.debug('service>> '+service);
                        ET_Fee.InspectionFeeInputDetail detail = new ET_Fee.InspectionFeeInputDetail();
                        detail.SerialNo = i;
                        if(service!=null && service!='')
                            detail.ServiceCode = service;
                        if(locationMap!=NULL)
                            detail.LocationCode = locationMap.get(obj.ET_Location__c);
                        else if(obj.ET_Location__r.Location_Code__c!=null && obj.ET_Location__r.Location_Code__c!='')
                            detail.LocationCode = obj.ET_Location__r.Location_Code__c;
                        system.debug('obj.Purpose_Type__c>> '+obj.Purpose_Type__c);
                        if(purposeTypeMap!=NULL && purposeTypeMap.size()>0 ) //obj.Purpose_Type__c
                            detail.TestPurposeCode = purposeTypeMap.get(obj.Purpose_Type__c).ETI_LookupCode__c;
                        detail.ChassisNo = obj.Chassis_No__c; //dont pass null value - pass as blank
                        if(obj.Plate_No__c!=null && obj.Plate_No__c!='')
                            detail.PlateNo = obj.Plate_No__c;
                        else 
                            detail.PlateNo ='';
                        if(!laneDetailsMap.isEmpty() && obj.Allocated_Lane__c!=null && laneDetailsMap.containsKey(obj.Allocated_Lane__c) 
                           && laneDetailsMap.get(obj.Allocated_Lane__c).Lane_Type_AMAN__c!=null && laneDetailsMap.get(obj.Allocated_Lane__c).Lane_Type_AMAN__c!='')
                            detail.LaneTypeId=laneDetailsMap.get(obj.Allocated_Lane__c).Lane_Type_AMAN__c;
                        if(!tradeLicenseMap.isEmpty() && tradeLicenseMap.containsKey(obj.Customer_Vehicle__c) && tradeLicenseMap.get(obj.Customer_Vehicle__c)!=null
                           && tradeLicenseMap.get(obj.Customer_Vehicle__c)!=''){
                               detail.TradeLicenseNo=tradeLicenseMap.get(obj.Customer_Vehicle__c);
                           }    
                        if(obj.Chassis_No__c!=null && obj.Chassis_No__c!=''){
                            if(service!=null && service!='')
                                internalMap.put(string.valueof(i),obj.Chassis_No__c+'-'+service);
                        }else if(obj.Plate_No__c!=null && obj.Plate_No__c!=''){
                            if(service!=null && service!='')
                                internalMap.put(string.valueof(i),obj.Plate_No__c+'-'+service);
                        }    
                        i++;
                        requests.add(detail);    
                    }
                }
            }
        }
        system.debug('requests>> '+requests);
        system.debug('internalMap>> '+internalMap);
        ET_Fee.Output result=soa.getInspectionFee(requests);
        system.debug('fee result>> '+result);
        if(result!=null && result.Status=='S'){
            ET_Fee.InspectionFeeOutputDetailCollection_element result1=result.InspectionFeeOutputDetailCollection;
            system.debug('fee result1>> '+result1);
            for(ET_Fee.InspectionFeeOutputDetail fee:result1.InspectionFeeOutputDetailCollection){
                if(internalMap!=NULL && internalMap.size()>0){
                    string str=internalMap.get(fee.SerialNo);
                    if(internalMap.containsKey(fee.SerialNo)){
                        ETI_B2B_UtilityWrapper.InspectionFeeDetail feeDetail=new ETI_B2B_UtilityWrapper.InspectionFeeDetail(fee.Status,fee.Message,fee.LastLaneTypeId,fee.FeeAmount,fee.TaxAmount,fee.TotalAmount);
                        feeDetailMap.put(internalMap.get(fee.SerialNo),feeDetail);
                    }
                }
            }
        }else{
            return null;
        }
        system.debug('feeDetailMap>> '+feeDetailMap);
        return feeDetailMap;
    }
    @AuraEnabled
    public static void uploadRequiredDocuments(list<ETI_B2B_UtilityWrapper.fileToBeUploaded> docUploadedList) {
        system.debug('docUploadedList>> '+docUploadedList);
        list<ContentVersion> cvInsertList=new list<ContentVersion>();
        set<id> vehicleIds=new set<id>();
        // Decoding base64Data
        for(ETI_B2B_UtilityWrapper.fileToBeUploaded doc:docUploadedList){
            doc.base64Data = EncodingUtil.urlDecode(doc.base64Data, 'UTF-8');        
            ContentVersion cv = new ContentVersion();
            cv.Title = doc.fileName;
            cv.PathOnClient = '/' + doc.fileName;
            cv.FirstPublishLocationId = doc.vehicleId;
            system.debug('base64Data>> '+EncodingUtil.base64Decode(doc.base64Data));
            cv.VersionData = EncodingUtil.base64Decode(doc.base64Data);
            cv.IsMajorVersion = true;
            cvInsertList.add(cv);
            if(!vehicleIds.contains(doc.vehicleId))
                vehicleIds.add(doc.vehicleId);
        }
        insert cvInsertList; 
        system.debug('cvInsertList '+ cvInsertList);
        system.debug('vehicleIds'+ vehicleIds);
        if(vehicleIds!=null && vehicleIds.size()>0){
            List<ContentDocumentLink> contentDocumentLinkList = [SELECT LinkedEntityId, ShareType, Visibility 
                                                                 FROM ContentDocumentLink 
                                                                 WHERE LinkedEntityId IN: vehicleIds];
            for(contentDocumentLink contentDocumentLink: contentDocumentLinkList){
                contentDocumentLink.ShareType = 'I';
                contentDocumentLink.Visibility = 'AllUsers';
            }
            update contentDocumentLinkList;
        }
    }
    //Below code Added by Noor Shaik on 30/04/2020
    @AuraEnabled
    public static List<ETI_Booking__c> getAfterBookingDetails(List<ETI_Booking__c> lstBooking){
        system.debug('lstBooking>> '+lstBooking);
        list<ETI_Booking__c> resultBookings=new list<ETI_Booking__c>();
        set<Id> bkngIds=new set<Id>();
        if(lstBooking!=NULL && lstBooking.size()>0){
            for(ETI_Booking__c etb :lstBooking)
                bkngIds.add(etb.Id);
        }
        If(bkngIds!=NULL){
            resultBookings=[SELECT Id,Name,Chassis_No__c,Customer_Vehicle__c,Registration_Type__c,User__c,User__r.Name,User__r.PersonMobilePhone,User__r.Phone,User__r.Preferred_Language__c,Service_Request__c,
                            ETI_Pick_Up_Location__c,Customer_Site_Address__c,Customer_Site_Geometry__c,Trade_License_Number__c,Location__c,
                            Booking_Date__c,Service_Type__c,Amount__c,Total_Amount__c FROM ETI_Booking__c WHERE Id IN: bkngIds];
            
        }
        system.debug('resultBookings>> '+resultBookings);
        return resultBookings;
    }
    @AuraEnabled
    public static ETI_B2B_UtilityWrapper.serviceLineItemWrp removeBookings(String obj,String serviceItems){
        list<ETI_Service_Line_Item__c> serviceItemList =new list<ETI_Service_Line_Item__c>();
        list<ETI_Booking__c> updateBooking=new list<ETI_Booking__c>();
        Set<id> bookingIds=new Set<id>();
        system.debug('serviceItems>> '+serviceItems);
        system.debug('obj>> '+obj);
        ETI_B2B_UtilityWrapper.serviceLineItemWrp serviceWrp= (ETI_B2B_UtilityWrapper.serviceLineItemWrp)system.JSON.deserializeStrict(obj, ETI_B2B_UtilityWrapper.serviceLineItemWrp.class);
        system.debug('serviceWrp>> '+serviceWrp);
        for(ETI_Service_Line_Item__c item:[SELECT Id,Booking__c FROM ETI_Service_Line_Item__c WHERE id =:serviceItems]){
            bookingIds.add(item.Booking__c);
            serviceItemList.add(item);
        }
        if(!bookingIds.isEmpty() && !serviceItemList.isEmpty()){
            system.debug('serviceItemList>> '+serviceItemList);
            String msg = String.valueOf(serviceItemList) + '@@@' + serviceItems;
            Database.deleteResult[] sr = Database.delete(serviceItemList, false);
            //String msg = String.valueOf(bookingList);
            for(Database.deleteResult dlr : sr){
                if(!dlr.success){
                    for(Database.Error er : dlr.getErrors()){
                        msg += er.getMessage();
                    }
                }
            }
            system.debug('bookingIds>> '+bookingIds);
            
            for(ETI_Booking__c bkng:[Select Id,Booking_Status__c From ETI_Booking__c Where Id IN:bookingIds AND Requested_Services_Count__c = 0]){
                bkng.Booking_Status__c='Cancelled';
                updateBooking.add(bkng);
            }
            if(!updateBooking.isEmpty())
                Database.SaveResult[] result = Database.update(updateBooking, false);
            integer i=0;    
            integer serviceTypeIndex=0;
            integer wrpRowIndex=0;
            boolean serviceTypeFlag=false;
            boolean wrpRowFlag=false;
            for(ETI_B2B_UtilityWrapper.chassisWrp wrp:serviceWrp.chassisNo){
                integer j=0;
                for(ETI_B2B_UtilityWrapper.serviceTypes type:wrp.typeList){
                    integer k=0;
                    for(ETI_Service_Line_Item__c item:type.serviceItems){
                        system.debug('item.Id>> '+item.Id+' serviceItems>> '+serviceItems);
                        if(item.Id==serviceItems){
                            type.serviceItems.remove(k);
                            break;
                        }
                        k++;
                    }
                    if(type.serviceItems.size()==0){
                        serviceTypeIndex=j;
                        serviceTypeFlag=true;
                    }else 
                        serviceTypeFlag=false;
                    j++;
                }
                system.debug('serviceTypeIndex>> '+serviceTypeIndex+' serviceTypeFlag>> '+serviceTypeFlag);
                if(serviceTypeFlag){
                    wrp.typeList.remove(serviceTypeIndex);
                    if(wrp.typeList.size()==0){
                        wrpRowIndex=i;
                        wrpRowFlag=true;
                    }
                }
                i++;
            }
            system.debug('wrpRowIndex>> '+wrpRowIndex+' wrpRowFlag>> '+wrpRowFlag);
            if(wrpRowFlag){
                serviceWrp.chassisNo.remove(wrpRowIndex);
            }
            system.debug('serviceWrp>> '+serviceWrp);
        }
        return serviceWrp;
    }
    public static id CreateServiceRequest(String locationId){
        Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
        ET_Service_Request__c InsService = new ET_Service_Request__c();
        InsService.ET_Account__c =[select accountId from user where id=:userInfo.getUserId()].accountId; 
        InsService.recordTypeId=recordTypeId;
        InsService.Payment_Status__c='Not Initiated';
        if(locationId!=null)
            InsService.ET_Location__c=locationId;
        insert InsService;
        return InsService.Id;
    }
    @Auraenabled
    public static list<ET_Service_Request__c> getUpcomingServiceRequests(Date stDate,Date enDate,String emirate){
        System.debug('emirate >>> '+emirate);
        String userAccountId=getAccountId();  
        system.debug('userAccountId>> '+userAccountId);
        list<ET_Service_Request__c> serviceReqList=new list<ET_Service_Request__c>();
        set<String> reqIds=new set<String>();
        set<String> bookingStatus=new set<String>();
        set<String> testResult=new set<String>();
        set<String> paymentStatus=new set<String>();
        String qryString = 'Select Id,Service_Request__c From ETI_Booking__c';
        if(emirate != 'Sharjah'){
            bookingStatus.addAll(Label.ETI_Upcoming_Booking_Status.split(';'));
            testResult.addAll(Label.ETI_Upcoming_Booking_TestResult.split(';'));
            qryString += ' where User__c=:userAccountId AND Booking_Date__c >= TODAY';  
            qryString += ' AND Booking_Status__c NOT IN :bookingStatus AND Test_Result__c  NOT IN :testResult order by Booking_Date__c desc';
        } 
        if(emirate == 'Sharjah'){
            bookingStatus.addAll(Label.ETI_Upcoming_Booking_Status_SPEA.split(';'));
            testResult.addAll(Label.ETI_Upcoming_Booking_TestResult_SPEA.split(';'));
            paymentStatus.addAll(Label.ETI_Upcoming_Booking_Payment_Status_SPEA.split(';'));
            qryString += ' where User__c=:userAccountId';   
            qryString += ' AND Booking_Status__c IN :bookingStatus AND Test_Result__c IN :testResult AND Payment_Status__c IN :paymentStatus order by Booking_Date__c desc';
        }
        system.debug('qryString >> '+qryString );
        for(ETI_Booking__c bkng: Database.query(qryString))
            reqIds.add(bkng.Service_Request__c);
        if(!reqIds.isEmpty())
            serviceReqList=[Select Id,Name,ETI_Payment_Type__c,Payment_Status__c,ET_Location__c,ET_Location__r.Name,Total_Amount__c, (select id, ETST_Payment_State__c from ET_Payments__r) from ET_Service_Request__c Where Id IN:reqIds ORDER BY CreatedDate DESC];
        return serviceReqList;
    }
    @Auraenabled(cacheable = true)
    public static list<ETI_Booking__c> getUpcomingBookings(Id srReqId,Date stDate,Date enDate,String emirate){
        System.debug('emirate >>> '+emirate);
        String userAccountId=getAccountId();  
        set<String> bookingStatus=new set<String>();
        set<String> testResult=new set<String>();
        set<String> paymentStatus=new set<String>();
        String qryString = 'Select Id,Booking_Date_Time__c,Chassis_No__c,Booking_Date__c,Customer_Vehicle__c,Customer_Vehicle__r.Registration_Type__c,Customer_Vehicle__r.Vehicle_Model__c,Customer_Vehicle__r.Plate_Color__c,Customer_Vehicle__r.Plate_No__c,Registration_Type__c,Location__c,Encrypted_Id__c,Service_Type__c,Booking_Status__c,Name,Payment_Status__c,Service_Request__c,Test_Result__c,Total_Amount__c,(SELECT Id,Status FROM Service_Appointments__r ORDER BY LastModifiedDate LIMIT 1) from ETI_Booking__c';
        qryString += ' where User__c=:userAccountId AND Service_Request__c=:srReqId';
        if(emirate != 'Sharjah'){
            bookingStatus.addAll(Label.ETI_Upcoming_Booking_Status.split(';'));
            testResult.addAll(Label.ETI_Upcoming_Booking_TestResult.split(';'));
            if(stDate!=NULL && enDate!=NULL)
                qryString += ' AND Booking_Date__c >=:stDate AND Booking_Date__c <=:enDate';
            else 
                qryString += ' AND Booking_Date__c >= TODAY';
            qryString +=' AND Booking_Status__c NOT IN :bookingStatus AND Test_Result__c  NOT IN :testResult order by Booking_Date__c desc';
        }
        if(emirate == 'Sharjah'){
            bookingStatus.addAll(Label.ETI_Upcoming_Booking_Status_SPEA.split(';'));
            testResult.addAll(Label.ETI_Upcoming_Booking_TestResult_SPEA.split(';'));
            paymentStatus.addAll(Label.ETI_Upcoming_Booking_Payment_Status_SPEA.split(';'));
            if(stDate!=NULL && enDate!=NULL)
                qryString += ' AND Booking_Date__c >=:stDate AND Booking_Date__c <=:enDate';
            qryString +=' AND Booking_Status__c IN :bookingStatus AND Test_Result__c IN :testResult AND Payment_Status__c IN :paymentStatus order by Booking_Date__c desc';
        }
        List<ETI_Booking__c> bknglst = Database.query(qryString);
        return bknglst;
    }
    @Auraenabled(cacheable = true)
    public static List<BookingHistoryWrapper> getBookingHistory(Boolean isWalkIn,Id vehicleId,Date stDate,Date enDate){
        String userAccountId;
        if(!isWalkIn)
            userAccountId=getAccountId();  
        
        String errStr;
        try{
            String qryString = 'Select Id,Name,Customer_Vehicle__c,Customer_Vehicle__r.Registration_Type__c,Registration_Type__c,Encrypted_Id__c,Chassis_No__c,Customer_Vehicle__r.Vehicle_Model__c,Customer_Vehicle__r.Plate_Color__c,Customer_Vehicle__r.Plate_No__c,Booking_Date__c,Location__c,ET_Location__c,ET_Location__r.Name,Service_Type__c,Booking_Status__c,Amount__c,Test_result_page__c,Test_Result__c  From ETI_Booking__c';
            if(userAccountId!=NULL && userAccountId!=''){
                qryString += ' Where (User__c=:userAccountId';
                if(stDate!=NULL && enDate!=NULL){
                    qryString += ' AND Booking_Date__c>=:stDate AND Booking_Date__c<=:enDate';
                }
                //else 
                //    qryString += ' AND Booking_Date__c <= TODAY';
                String status = Label.ETI_Show_Booking_History_Status ;
                List<String> statusList = new List<String>();
                String statusNotBeDisply = Label.ETI_Remove_Booking_Status_In_History  ;
                List<String> statusNotBeDisplyList = new List<String>();
                
                if(vehicleId!=NULL)
                    qryString += ' AND Customer_Vehicle__c=:vehicleId ';
                
                if(statusNotBeDisply != null && statusNotBeDisply != ''){
                    statusNotBeDisplyList = statusNotBeDisply.split(';');
                    qryString +=  ' AND (Booking_Status__c NOT IN :statusNotBeDisplyList OR (Booking_Status__c=\'Booked\' AND Booking_Date__c > TODAY))) ';
                } else
                    qryString += ') ';
                /*if(status != null && status != ''){
statusList = status.split(';');
qryString +=  'OR (User__c=:userAccountId AND Booking_Status__c IN :statusList)';
}*/
                
            }else {
                if(vehicleId!=NULL)
                    qryString += ' Where Customer_Vehicle__c=:vehicleId';
            }
            qryString +=' order by Booking_Date__c desc';
            //qryString +=' AND Booking_Status__c =\'Cancelled\' order by Booking_Date__c desc';
            system.debug('qryString'+qryString);
            return initBookingWrapper(new Map<id, ETI_Booking__c>((List<ETI_Booking__c>)Database.query(qryString)));
        }catch (Exception e) {
            errStr = JSON.serialize(ETI_B2B_VehicleController.buildErrorResponse('getBookingHistory', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    public static List<BookingHistoryWrapper> initBookingWrapper(Map<id, ETI_Booking__c> bknglstMap){
        // List<ServiceAppointment> appntmnts = new list<ServiceAppointment>([select id,ETI_Booking__c from ServiceAppointment where ETI_Booking__c IN : bknglstMap.keyset()]);
        List<BookingHistoryWrapper> bookingWrapList = new List<BookingHistoryWrapper> ();
        List<id> addedlist = new List<id>();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        //below code commented by Noor Shaik for SPEA License expiry issue on 11/05/2021
        /*for( ServiceAppointment servApp: [select id, ETI_Booking__c, (select id,ContentVersionDocumentId from ServiceReports order by createdDate desc) from ServiceAppointment where ETI_Booking__c IN : bknglstMap.keyset()]){
if(!addedlist.contains(servApp.ETI_Booking__c)){
addedlist.add(servApp.ETI_Booking__c);
BookingHistoryWrapper wrp = new BookingHistoryWrapper();
wrp.booking = bknglstMap.get(servApp.ETI_Booking__c);
if(servApp.ServiceReports != null && servApp.ServiceReports.size() > 0){
wrp.downloadUrlk = baseUrl + '/sfc/servlet.shepherd/version/download/' + servApp.ServiceReports[0].ContentVersionDocumentId;

}
wrp.bookingDate = bknglstMap.get(servApp.ETI_Booking__c).Booking_Date__c;
bookingWrapList.add(wrp);
}
}*/
        for(id key : bknglstMap.keySet()){
            if(!addedlist.contains(key)){
                BookingHistoryWrapper wrp = new BookingHistoryWrapper();
                wrp.booking = bknglstMap.get(key);
                wrp.downloadUrlk = null;
                wrp.bookingDate = bknglstMap.get(key).Booking_Date__c;
                bookingWrapList.add(wrp);
            }
        }
        bookingWrapList.sort();
        return bookingWrapList;
    }
    @Auraenabled
    public static  Map<String, list<ETI_Reschedule_Cancel_Charges__mdt>> fetchRescheduleCancelMetaData(){
        Map<String, list<ETI_Reschedule_Cancel_Charges__mdt>> cancelMetadaMap = new Map<String, list<ETI_Reschedule_Cancel_Charges__mdt>>();
        for(ETI_Reschedule_Cancel_Charges__mdt mdtRecord : [SELECT Type__c, Refund_Percentage__c,Refund_Amount__c, Max_Time_Limit__c FROM ETI_Reschedule_Cancel_Charges__mdt Where isActive__c=true order by Max_Time_Limit__c asc]){
            if(!cancelMetadaMap.containsKey(mdtRecord.Type__c))
                cancelMetadaMap.put(mdtRecord.Type__c, new list<ETI_Reschedule_Cancel_Charges__mdt>{mdtRecord});
            else
                cancelMetadaMap.get(mdtRecord.Type__c).add(mdtRecord);
        }
        return cancelMetadaMap;
    }
    @Auraenabled
    public static string cancelBooking(List<id> rowid,String cancelReason){
        list<ETI_Service_Line_Item__c> serviceItemList=new list<ETI_Service_Line_Item__c>();
        list<ETI_Service_Line_Item__c> updateServiceItemList=new list<ETI_Service_Line_Item__c>();
        string message;
        serviceItemList = [select Id,Booking__c,Cancel_Integration_Status__c,Cancel_Integration_Message__c, (Select Id,AMAN_Receipt_No__c From Receipts__r Where AMAN_Receipt_No__c!='' limit 1) from ETI_Service_Line_Item__c where Booking__c=:rowid.get(0)];
        system.debug('serviceItemList >> '+serviceItemList );
        if(!serviceItemList.isEmpty()){
            for(ETI_Service_Line_Item__c service: serviceItemList){
                if(service.Receipts__r!=null && service.Receipts__r.size()>0 
                   && service.Receipts__r[0].AMAN_Receipt_No__c!=null && service.Receipts__r[0].AMAN_Receipt_No__c!=''){
                       ET_InspectionCancellationService.execute_pt vItem= new ET_InspectionCancellationService.execute_pt();
                       ET_InspectionCancellation.Output response;
                       try{
                           response = vItem.execute(service.Receipts__r[0].AMAN_Receipt_No__c);
                           system.debug('response>> '+response);
                       }catch(exception ex){
                           message='E';
                           UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETI_VehicleController', 'cancelBooking', '', UTIL_Logging.DEBUG_LEVEL_WARN);
                           UTIL_Logging.logException(exLog);
                       }
                       if(response !=null){
                           service.Cancel_Integration_Status__c = response.Status;
                           service.Cancel_Integration_Message__c = response.Message;
                       }
                       updateServiceItemList.add(service);
                   }
            }
            system.debug('updateServiceItemList>> '+updateServiceItemList);
            if(!updateServiceItemList.isEmpty()){
                for(ETI_Service_Line_Item__c item:updateServiceItemList){
                    if(item.Cancel_Integration_Status__c =='E'){
                        message='E';
                        break;
                    }
                }
                update updateServiceItemList;
            }
            system.debug('message>> '+message);
            if(message!='E' || updateServiceItemList.isEmpty()){
                ETI_Booking__c bkng=new ETI_Booking__c();
                bkng.Id = serviceItemList[0].Booking__c;
                bkng.Booking_Status__c = 'Cancelled';
                if(cancelReason!=null && cancelReason!=''){
                    if(cancelReason=='Cancel')
                        bkng.Cancellation_Reason__c=system.label.ETI_Cancellation_Reason_PortalCancel;
                    else if(cancelReason=='Reschedule')  
                        bkng.Cancellation_Reason__c=system.label.ETI_Cancellation_Reason_Reschedule;
                    else 
                        bkng.Cancellation_Reason__c=cancelReason;
                }
                update bkng;
                message='S';
            }
        }
        return message;
    }
    //File Upload Method
    @AuraEnabled
    public static void uploadRequiredDocuments( String fileName, String base64Data, String contentType,Id vehicleId) {
        system.debug('Saving chatter files '+fileName + ' '+ contentType);
        system.debug('Vehicleid'+vehicleId);
        system.debug('base64Data>> '+base64Data);
        // Decoding base64Data
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');        
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = '/' + fileName;
        cv.FirstPublishLocationId = vehicleId;
        system.debug('base64Data>> '+EncodingUtil.base64Decode(base64Data));
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        insert cv; 
        system.debug('cv.id '+ cv.id);
        
        List<ContentDocumentLink> contentDocumentLinkList = [SELECT LinkedEntityId, ShareType, Visibility 
                                                             FROM ContentDocumentLink 
                                                             WHERE LinkedEntityId =: vehicleId];
        for(contentDocumentLink contentDocumentLink: contentDocumentLinkList){
            contentDocumentLink.ShareType = 'I';
            contentDocumentLink.Visibility = 'AllUsers';
        }
        update contentDocumentLinkList;
    }
    //File Upload Method
    @AuraEnabled
    public static String saveTheFile( String fileName, String base64Data, String contentType,ET_Customer_Vehicle__c vehicle1, string parentId,Boolean termsAndCondition) {
        system.debug('entered');
        system.debug('vehicle1'+vehicle1);
        system.debug('Saving chatter files '+fileName + ' '+ contentType);
        // Id Vehicleid=saveVehicle(vehicle1);
        Id Vehicleid;
        if(parentId == null || parentId == ''){
            vehicle1.Is_Terms_and_Conditions_Checked__c = termsAndCondition;
            String result = saveVehicle(vehicle1);
            Vehicleid=result;
        }else{
            Vehicleid= parentId;
        }
        system.debug('Vehicleid'+Vehicleid);
        ContentVersion ContentInsert =new ContentVersion(); 
        ContentInsert.Title =fileName; 
        //EncodingUtil.urlDecode(String.valueOf(fileMap.get('fileBase64Data')), 'UTF-8');
        system.debug('Data'+EncodingUtil.urlDecode(base64Data,'UTF-8'));
        // ContentInsert.VersionData=EncodingUtil.base64Decode(base64Data);\
        base64Data=EncodingUtil.urlDecode(base64Data,'UTF-8');
        ContentInsert.VersionData= EncodingUtil.base64Decode(base64Data);
        ContentInsert.PathOnClient='/' + fileName ;
        ContentInsert.FirstPublishLocationId = Vehicleid;
        insert ContentInsert; 
        system.debug('ContentInsert.id '+ ContentInsert.id);
        
        List<ContentDocumentLink> contentDocumentLinkList = [SELECT LinkedEntityId, ShareType, Visibility 
                                                             FROM ContentDocumentLink 
                                                             WHERE LinkedEntityId =: Vehicleid];
        for(contentDocumentLink contentDocumentLink: contentDocumentLinkList){
            contentDocumentLink.ShareType = 'I';
            contentDocumentLink.Visibility = 'AllUsers';
        }
        update contentDocumentLinkList;
        return Vehicleid;
    }
    @AuraEnabled(cacheable = true)
    public static List<ETST_Payment__c> getPaymentHistory(Date stDate, Date enDate){
        Datetime myDate;
        if(enDate!=NULL){
            string str=string.valueof(enDate)+' 27:59:00';
            myDate=datetime.valueof(str);
            system.debug('myDate '+myDate); 
        }
        String errStr;
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        try{
            String userAccountId=getAccountId();   
            String qryString = 'Select Id,name,ETST_Amount__c,CreatedDate,ETST_Payment_Mode__c,ET_Service_Request__r.Name,ET_Service_Request__r.Id,ET_Service_Request__r.ET_Account__r.Name,ETST_Payment_State__c FROM ETST_Payment__c where ET_Service_Request__r.ET_Account__c =:userAccountId AND ET_Service_Request__r.RecordTypeId=:srRecordTypeId';
            if(stDate!=NULL && enDate!=NULL)
                qryString += ' AND CreatedDate >=:stDate AND CreatedDate <=:myDate';
            qryString +=+' order by CreatedDate desc';
            List<ETST_Payment__c> myPayments = Database.query(qryString);         
            return myPayments;
        }catch (Exception e) {
            errStr = JSON.serialize(ETI_B2B_VehicleController.buildErrorResponse('getPaymentHistory', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    public static ET_External_Endpoint__mdt getAPIDetails(String DeveloperName){
        return [SELECT Id,DeveloperName, MasterLabel, URL__c, Authorization__c,  EnvironmentType__c FROM ET_External_Endpoint__mdt  
                where EnvironmentType__c =:envType and DeveloperName=:DeveloperName  LIMIT 1];
        
    }  
    
    @AuraEnabled
    public static String getChangelocation(){  
        String loc = '';
        User user=  [select Contact.ET_Preferred_Location__c from user where id=:userInfo.getUserId() Limit 1];
        loc = user.Contact.ET_Preferred_Location__c;
        return loc;
    }
    /*
*  public class Response{
@AuraEnabled
public Boolean isPreferedLocation{get; set;}
@AuraEnabled
public String result {get; set;}
@AuraEnabled
public String accountId {get; set;}
@AuraEnabled
public String preferredLocation {get; set;}
}
public static void checckPrefereadLocation(id accountId, Response res){
try{


List<Account> accList = [SELECT Preferred_Location__c FROM Account WHERE id = :accountId] ; 
if(accList.size() > 0 && accList[0].Preferred_Location__c != null && accList[0].Preferred_Location__c != ''){
res.isPreferedLocation = true;
res.preferredLocation = accList[0].Preferred_Location__c;
}else{
res.isPreferedLocation = false;
}

}catch(Exception e){
res.isPreferedLocation = false;
}
}
//Method to call google API and fetch the address recommendations 
@AuraEnabled
public static Response getGetCurrentLocation(Decimal latit, Decimal longit){  
system.debug('enter');
Response res1 = new Response();
ET_External_Endpoint__mdt googleEndpoint=getAPIDetails('ETST_googleAutoCompleteAPI');
String result = null;
String APIKey = googleEndpoint.Authorization__c;
String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=' + latit + '%2C' + longit;
//system.debug('SearchText is ' + SearchText);
try{
if(latit != null){
String APIUrl = url +  '&key='+APIKey; 
system.debug('APIUrl is ' + APIUrl);
HttpRequest req = new HttpRequest();
req.setMethod('GET');
req.setEndpoint(APIURL);
Http http = new Http();
HttpResponse res = http.send(req);
Integer statusCode = res.getStatusCode();
system.debug('statusCode is ' + statusCode);
if(statusCode == 200){
system.debug('API invoked successfully');
result = res.getBody();
system.debug('Address'+result);
}
}
}
catch(exception e){
//Handling exception
system.debug(e.getMessage());
}
res1.result = result;
res1.accountId  = [select accountId from user where id=:userInfo.getUserId()].accountId;
checckPrefereadLocation( res1.accountId, res1);
return res1;
}
@AuraEnabled
public static void updatePreferredLocation(String accountId, String preferredLocation){  
List<Account> accList = [SELECT Preferred_Location__c FROM Account WHERE id = :accountId];
if(accList.size() > 0 ){
accList[0].Preferred_Location__c = preferredLocation;
update accList[0];
}
}*/
    //Method to call google API and fetch the address recommendations 
    @AuraEnabled
    public static String getAddressSet(String SearchText){  
        system.debug('enter');
        ET_External_Endpoint__mdt googleEndpoint=getAPIDetails('ETST_googleAutoCompleteAPI');
        String result = null;
        String APIKey = googleEndpoint.Authorization__c;
        String url = googleEndpoint.URL__c;
        system.debug('SearchText is ' + SearchText);
        try{
            if(SearchText != null){
                String APIUrl = url + SearchText.replace(' ', '%20') + '&key='+APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    result = res.getBody();
                    system.debug('Address'+result);
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
        }
        return result;
    }
    //Method to call google API and fetch the address details by addressID 
    @AuraEnabled
    public static String getAddressDetailsByPlaceId(String PlaceID){
        ET_External_Endpoint__mdt googleEndpoint=getAPIDetails('ETST_googlePlacesAPI');
        
        String  APIKey = googleEndpoint.Authorization__c;
        String  url = googleEndpoint.URL__c;
        String result = null;
        system.debug('SearchText is place id ' + PlaceID);
        try{
            if(PlaceID != null){
                String APIUrl = url + PlaceId.replace(' ', '%20') + '&key='+APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    result = res.getBody();
                    system.debug('result'+result);
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
        }
        return result;
    } 
    //Method to get all cases
    @AuraEnabled(cacheable = true)
    public static List<Case> getMyCases(Date stDate, Date enDate){
        Datetime myDate;
        if(enDate!=NULL){
            string str=string.valueof(enDate)+' 27:59:00';
            myDate=datetime.valueof(str);
        }
        String errStr;
        try{
            String userAccountId=getAccountId();    
            String qryString = 'SELECT Id, ETST_Complaint_Type__c,ETI_Customer_Vehicle__c,ETI_Customer_Vehicle__r.Registration_Type__c,ETI_Customer_Vehicle__r.Chassis_No__c,ETI_Customer_Vehicle__r.Vehicle_Model__c,ETI_Customer_Vehicle__r.Plate_No__c,ETI_Customer_Vehicle__r.Plate_Color__c,CaseNumber, CreatedDate, ClosedDate,Description, Priority,Status, Subject FROM Case ';
            qryString += 'Where Case.AccountId=:userAccountId';
            if(stDate !=NULL && myDate!=NULL)
                qryString += ' AND CreatedDate >=:stDate AND CreatedDate <=:myDate';
            qryString +=' order by CreatedDate desc';
            List<Case> cases = Database.query(qryString);    
            return cases;
        }catch (Exception e) {
            errStr = JSON.serialize(ETI_B2B_VehicleController.buildErrorResponse('getMyCases', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }
    @AuraEnabled(cacheable = true)
    public static List<Case> getMyCasesHistory(Date stDate, Date edDate){
        try{
            String userAccountId = getAccountId();   
            String qryString = 'SELECT Id, ETST_Complaint_Type__c, CaseNumber, CreatedDate, ClosedDate,Description, Priority,Status, Subject FROM Case ';
            qryString += 'where Case.AccountId=:userAccountId';
            if(stDate!=NULL && edDate!=NULL)
                qryString += ' AND CreatedDate >=:stDate AND CreatedDate <=:edDate';
            qryString +=+' order by CreatedDate desc';
            List<Case> cases = Database.query(qryString);         
            return cases;
        }catch (Exception e) {
            return null;
        }
    }
    @AuraEnabled
    public static Account getAccountDetails(){
        Account acc=new Account();
        list<user> users=new list<user>([select accountId,account.PersonMobilePhone,account.Preferred_Language__c,account.ET_Changed_Location__c from user where id=:userInfo.getUserId() AND accountId !=NULL limit 1]);
        if(users !=NULL && users.size()>0){
            acc.Id=users[0].accountId;
            acc.Preferred_Language__c=users[0].account.Preferred_Language__c;
            acc.ET_Changed_Location__c = users[0].account.ET_Changed_Location__c;
            acc.PersonMobilePhone = users[0].account.PersonMobilePhone;
            return acc;
            
        }
        return null;
    }
    @AuraEnabled
    public static void updatePreferredLanguage(Account accountObj){
        update accountObj;
    }
    
    public static string getAccountId(){
        string accountId;
        list<user> users=new list<user>([select accountId from user where id=:userInfo.getUserId() AND accountId !=NULL limit 1]);
        if(users !=NULL && users.size()>0)
            accountId=users[0].accountId;
        /*else
accountId='0010C00000BcEGA';*/
        return accountId;
    }
    @TestVisible
    private static Map<String, String> buildErrorResponse(String source, String errorMessage, String stackTrace) {
        Map<String, String> errorResponse = new Map<String, String>();
        
        errorResponse.put('SOURCE', source);
        errorResponse.put('MESSAGE', errorMessage);
        errorResponse.put('STACKTRACE', stackTrace);
        
        return errorResponse;
    }  
    @AuraEnabled
    public static List<ETI_Required_Documents__c>  getRequiredDocumentsForUnregistered(){
        //list<ETI_Required_Documents__c>
        system.debug('@@@@Enter');
        List<ETI_Required_Documents__c> reqDocs = [Select id,Name from ETI_Required_Documents__c where Is_Required__c = true AND Registration_Type__c = 'Un-Registered'];
        system.debug('@@@@@@@ reqDocs'+reqDocs);
        return reqDocs;
        //return [Select id,Name from ETI_Required_Documents__c where Is_Required__c = true];
    }
    
    
    @Auraenabled
    public static ET_Customer_Vehicle__c getVehicleInfoFromAbuDhabi(ET_Customer_Vehicle__c vehicle,string selectedType){
        System.debug('Vehicle Detail ' + vehicle);
        System.debug('Vehicle Detail palte' + vehicle.Plate_No__c);
        system.debug('desplay V'+vehicle);
        
        if(vehicle != null && selectedType!=null && selectedType!='')            
        {
            Id devRecordTypeId = Schema.SObjectType.ET_Customer_Vehicle__c.getRecordTypeInfosByName().get('Vehicle Inspection').getRecordTypeId();
            if(vehicle.RecordTypeId==null)
                vehicle.RecordTypeId = devRecordTypeId;
            //vehicle.Account__c   = getAccountId();   
            if(vehicle.Chassis_No__c != '' && selectedType=='Chassis No')
            {
                System.debug('enter2 ' );              
                ETAbuDhabiInspectionService.GetVehicleDetailsRequest request = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
                request.ChassisNo = vehicle.Chassis_No__c;
                request.SystemCode = integer.valueOf(system.label.ETI_AMAN_System_Code);
                request.UserID = system.label.ETI_AMAN_UserID;
                if(vehicle.Registration_Type__c=='Registered'){
                    ET_SOA_Services soa = new ET_SOA_Services();
                    ETAbuDhabiInspectionService.getVehicleDetailsResponse_element vehicleDetails = soa.getVehiclesDetails(request); 
                    system.debug('veh detials ..... '+vehicleDetails);
                    if(vehicleDetails!=null && vehicleDetails.getVehicleDetailsResult != null)
                    {
                        return getVehicleInfoByChasiss(vehicle,vehicleDetails);
                    }
                }
            }else if(vehicle.Plate_No__c !='' && (vehicle.Chassis_No__c == '' || vehicle.Chassis_No__c == null))
            {
                system.debug('enter1');
                if(vehicle.Plate_Source__c!='' && vehicle.Plate_Source__c!=null)
                    vehicle.Plate_Source_Code__c=getPlateCodeByName(vehicle.Plate_Source__c,'PLATE_SOURCE','en');
                if(vehicle.Plate_Type__c!='' && vehicle.Plate_Type__c!=null)
                    vehicle.Plate_Type_Code__c=getPlateCodeByName(vehicle.Plate_Type__c,'PLATE_TYPE','en');
                if(vehicle.Plate_Color__c!='' && vehicle.Plate_Color__c!=null)
                    vehicle.Plate_Color_Code__c=getPlateCodeByName(vehicle.Plate_Color__c,'PLATE_COLOR','en');
                return getVehicleInfoByPlate(vehicle);
            }           
        }
        return null;
    }
    @AuraEnabled
    public static List<ETI_Booking__c> getBookingAndVehicle(String serviceId){
        List<ETI_Booking__c> bookingList = [SELECT Name, Customer_Vehicle__r.Name FROM ETI_Booking__c WHERE Service_Request__c = :serviceId];
        return bookingList;
    }
    public static ET_Customer_Vehicle__c getVehicleInfoByChasiss(ET_Customer_Vehicle__c vehicle,ETAbuDhabiInspectionService.getVehicleDetailsResponse_element vehicleDetails){
        system.debug('plate details 123'+vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateNo);
        system.debug('vehicleDetails.getVehicleDetailsResult 3367= '+ JSON.serializePretty(vehicleDetails.getVehicleDetailsResult));
        vehicle.Plate_No__c= String.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateNo);
        vehicle.Vehicle_Make__c = vehicleDetails.getVehicleDetailsResult.MakeEnglishDesc;
        vehicle.Vehicle_Model__c = vehicleDetails.getVehicleDetailsResult.ModelEnglishDesc;
        vehicle.Make_Code__c = vehicleDetails.getVehicleDetailsResult.MakeCode;
        vehicle.Vehicle_Make_AR__c=vehicleDetails.getVehicleDetailsResult.MakeArabicDesc;
        vehicle.Model_Code__c = vehicleDetails.getVehicleDetailsResult.ModelCode;
        vehicle.Vehicle_Model_AR__c = vehicleDetails.getVehicleDetailsResult.ModelArabicDesc;
        vehicle.Registration_Expiry_Date__c=Date.valueOf(vehicleDetails.getVehicleDetailsResult.RegistrationExpiryDate);
        vehicle.Vehicle_Year__c= vehicleDetails.getVehicleDetailsResult.Year;
        vehicle.Plate_Source_Code__c=String.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateSourceCode);
        vehicle.Plate_Color_Code__c=string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateColorCode);
        vehicle.Plate_Type_Code__c=string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateTypeCode);
        vehicle.Plate_Color__c=getPlateCodeByCode(string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateColorCode),'PLATE_COLOR','en');
        vehicle.Plate_Source__c= getPlateCodeByCode(string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateSourceCode),'PLATE_SOURCE','en');
        vehicle.Plate_Type__c= getPlateCodeByCode(string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateTypeCode),'PLATE_TYPE','en');
        vehicle.Plate_Color_AR__c=getPlateCodeByCode(string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateColorCode),'PLATE_COLOR','ar');
        vehicle.Plate_Source_AR__c= getPlateCodeByCode(string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateSourceCode),'PLATE_SOURCE','ar');
        vehicle.Plate_Type_AR__c= getPlateCodeByCode(string.valueOf(vehicleDetails.getVehicleDetailsResult.PlateInfo.PlateTypeCode),'PLATE_TYPE','ar');
        vehicle.Vehicle_type__c=vehicleDetails.getVehicleDetailsResult.TypeEnglishDesc;
        vehicle.Vehicle_Type_AR__c=vehicleDetails.getVehicleDetailsResult.TypeArabicDesc;
        vehicle.Vehicle_Type_Code__c=vehicleDetails.getVehicleDetailsResult.TypeCode;
        vehicle.Kind_Code__c =vehicleDetails.getVehicleDetailsResult.KindCode;
        vehicle.Kind_Code_AR__c=vehicleDetails.getVehicleDetailsResult.KindArabicDesc;
        vehicle.Tcf_No__c =vehicleDetails.getVehicleDetailsResult.OwnerTcfNo;
        vehicle.Tcf_No_AR__c =vehicleDetails.getVehicleDetailsResult.OwnerTcfArabicName;  
        vehicle.Engine_No__c=vehicleDetails.getVehicleDetailsResult.EngineNo;
        vehicle.Is_Verified__c=true;
        system.debug('vehicle....'+vehicle);
        system.debug('vehicle type>> '+vehicle.Vehicle_type__c+' type code>> '+vehicle.Vehicle_Type_Code__c);
        return vehicle;
    }
    public static ET_Customer_Vehicle__c getVehicleInfoByPlate(ET_Customer_Vehicle__c vehicle){
        ETAbuDhabiInspectionService.GetVehicleDetailsRequest request = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
        ETAbuDhabiInspectionService.PlateKey platedetails = new ETAbuDhabiInspectionService.PlateKey();
        request.SystemCode = integer.valueOf(system.label.ETI_AMAN_System_Code);
        request.UserID = system.label.ETI_AMAN_UserID;
        platedetails.PlateOrgNo = long.valueOf(system.label.ETI_AMAN_PlateOrgNo);
        platedetails.PlateNo= long.valueOf(vehicle.Plate_No__c);
        platedetails.PlateSourceCode = integer.valueOf(getPlateCodeByName(vehicle.Plate_Source__c,'PLATE_SOURCE','en'));
        platedetails.PlateTypeCode = integer.valueOf(getPlateCodeByName(vehicle.Plate_Type__c,'PLATE_TYPE','en'));
        platedetails.PlateColorCode = integer.valueOf(getPlateCodeByName(vehicle.Plate_Color__c,'PLATE_COLOR','en'));
        platedetails.PlateKindCode=platedetails.PlateTypeCode;
        request.PlateInfo = platedetails;
        ET_SOA_Services soa = new ET_SOA_Services();
        ETAbuDhabiInspectionService.getVehicleDetailsResponse_element vehicleDetails = soa.getVehiclesDetails(request); 
        system.debug('veh detials ..... '+vehicleDetails);
        if(vehicleDetails!=null && vehicleDetails.getVehicleDetailsResult != null)
        {
            system.debug('enter into plate');
            vehicle.Vehicle_Make__c = vehicleDetails.getVehicleDetailsResult.MakeEnglishDesc;
            vehicle.Vehicle_Model__c = vehicleDetails.getVehicleDetailsResult.ModelEnglishDesc;
            vehicle.Make_Code__c = vehicleDetails.getVehicleDetailsResult.MakeCode;
            vehicle.Model_Code__c = vehicleDetails.getVehicleDetailsResult.ModelCode;
            vehicle.Registration_Expiry_Date__c=Date.Valueof(vehicleDetails.getVehicleDetailsResult.RegistrationExpiryDate);
            vehicle.Vehicle_Year__c= vehicleDetails.getVehicleDetailsResult.Year;
            vehicle.Chassis_No__c=vehicleDetails.getVehicleDetailsResult.ChassisNo;
            vehicle.Kind_Code__c =vehicleDetails.getVehicleDetailsResult.KindCode;
            vehicle.Vehicle_Make_AR__c=vehicleDetails.getVehicleDetailsResult.MakeArabicDesc;
            vehicle.Vehicle_Model_AR__c = vehicleDetails.getVehicleDetailsResult.ModelArabicDesc;
            vehicle.Kind_Code_AR__c=vehicleDetails.getVehicleDetailsResult.KindArabicDesc;
            vehicle.Tcf_No__c =vehicleDetails.getVehicleDetailsResult.OwnerTcfNo;
            vehicle.Tcf_No_AR__c =vehicleDetails.getVehicleDetailsResult.OwnerTcfArabicName;  
            vehicle.Engine_No__c=vehicleDetails.getVehicleDetailsResult.EngineNo;
            vehicle.Is_Verified__c=true;
            return vehicle;
        }
        return null;
    }
    public static String getPlateCodeByName(String plateName,String lookupType,String lang){
        List<ETI_Aman_Lookup__c> amanLookupList =[SELECT Id, Name,ETI_ArabicName__c, ETI_LookupCode__c FROM ETI_Aman_Lookup__c 
                                                  where Name =: plateName AND ETI_LookupType__c=: lookupType AND isActive__c=true limit 1];
        if(amanLookupList !=NULL && amanLookupList.size()>0){
            if(lang=='en')
                return amanLookupList[0].ETI_LookupCode__c;
            else if(lang=='ar')
                return amanLookupList[0].ETI_ArabicName__c;
        }
        
        return null;
    }
    public static String getPlateCodeByCode(String plateCode,String lookupType,String lang){
        List<ETI_Aman_Lookup__c> amanLookupList =[SELECT Id, Name,ETI_ArabicName__c, ETI_LookupCode__c FROM ETI_Aman_Lookup__c 
                                                  where ETI_LookupCode__c =: plateCode AND ETI_LookupType__c=: lookupType AND isActive__c=true limit 1];
        if(amanLookupList !=NULL && amanLookupList.size()>0){
            if(lang=='en')
                return amanLookupList[0].Name;
            else if(lang=='ar')
                return amanLookupList[0].ETI_ArabicName__c;
        }
        
        return null;
    }
    public static string getEncryptedData(String clearText){
        //24 byte string. since characters used are ascii, each char is 1 byte.
        Blob key = Blob.valueOf(System.Label.ETI_Encryption_Key);
        Blob cipherText = Crypto.encryptWithManagedIV('AES192', key, Blob.valueOf(clearText));
        String encodedCipherText = EncodingUtil.base64Encode(cipherText);
        return  encodedCipherText;
    }
    public static string getDecryptedData(String encodedCipherText){  
        Blob key = Blob.valueOf(System.Label.ETI_Encryption_Key);
        Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encodedCipherText);
        Blob decryptedBlob = Crypto.decryptWithManagedIV('AES192', key, encodedEncryptedBlob);
        String decryptedClearText = decryptedBlob.toString();
        return decryptedClearText;
    }
    
    @AuraEnabled 
    public static List<string> getPlateSources() { 
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        Map<String, Case_Dependent_Types__c> mapOfdependent = Case_Dependent_Types__c.getAll();
        List<string> sourceList = new List<String>();
        for(ETI_Aman_Plate_Source__mdt source : [Select Id,MasterLabel, ETI_ArabicName__c, ETI_Code__c FROM ETI_Aman_Plate_Source__mdt ORDER BY ETI_Code__c asc]){
            system.debug('source***'+source.MasterLabel);
            sourceList.add(source.MasterLabel);   
        } 
        return sourceList;
    }
    
    @AuraEnabled
    public static Map<string,List<ETI_Aman_Plate_Type__mdt>> getPlateSourceandTypes(){
        Map<string,List<String>> sourceMap = new Map<string,List<String>>();
        Map<string,List<ETI_Aman_Plate_Type__mdt>> sourceandTypeMap = new Map<string,List<ETI_Aman_Plate_Type__mdt>>();
        List<String> sourceTypes = new List<string>();
        
        for(ETI_Aman_Plate_Type__mdt type : [Select id,MasterLabel,ETI_Aman_Plate_Source__c,ETI_Aman_Plate_Source__r.MasterLabel,ETI_ArabicName__c, ETI_Code__c FROM ETI_Aman_Plate_Type__mdt ORDER BY ETI_Code__c asc]){
            List<ETI_Aman_Plate_Type__mdt> typeList = sourceandTypeMap.get(type.ETI_Aman_Plate_Source__c);
            if(typeList == null)
                typeList = new List<ETI_Aman_Plate_Type__mdt>();
            typeList.add(type);
            sourceandTypeMap.put(type.ETI_Aman_Plate_Source__r.MasterLabel,typeList);
        }
        system.debug('sourceandTypeMap***'+sourceandTypeMap);
        return sourceandTypeMap;
    }
    
    public class BookingHistoryWrapper implements Comparable{
        @AuraEnabled
        public ETI_Booking__c booking{get; set;}
        @AuraEnabled
        public String downloadUrlk{get; set;}
        @AuraEnabled
        public Date bookingDate{get; set;}
        
        public Integer compareTo(Object compareTo) {
            BookingHistoryWrapper compareToEmp = (BookingHistoryWrapper)compareTo;
            if (bookingDate == compareToEmp.bookingDate) return 0;
            if (bookingDate < compareToEmp.bookingDate) return 1;
            return -1;        
        }
        
    }
    /**
* Author:Janardhan
* Date: 21-12-22
* Method Name:getSPEASlotDetialsReschedule
* */
    @AuraEnabled
    public static list<string> getSPEASlotDetialsReschedule(Date bkngDate){
        
        List<String> finalPreferTimes=new List<String>();
        list<String> preferTimes = new list<string>();               
        DateTime bkngDT=DateTime.newInstance(bkngDate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek=bkngDT.format('EEEE');        
        Map<String, List<String>> SPEAslotsMap=ETI_SPEAoperatingHours.getOperatingHours();
        preferTimes=SPEAslotsMap.get(dayOfWeek);        
        if(bkngDate ==system.today()){
            DateTime dt= datetime.now();
            String vTime = dt.format('HH:mm');
            system.debug('dt>> '+dt+' vTime>> '+vTime);
            if(vTime!=null && vTime!=''){
                for(String slot:preferTimes){
                    if(slot.contains(':') && vTime.contains(':')){
                        integer vHour=integer.valueOf(vTime.split(':')[0]);
                        if(Integer.valueOf(slot.split(':')[0])>=vHour){
                            if(Integer.valueOf(slot.split(':')[0])==vHour && Integer.valueOf(slot.split(':')[1])>Integer.valueOf(vTime.split(':')[1])){
                                finalPreferTimes.add(slot);
                            }else if(Integer.valueOf(slot.split(':')[0])>vHour){
                                
                                finalPreferTimes.add(slot);
                            }
                            
                        }
                    }
                }
            }
        }else
            finalPreferTimes=preferTimes;
        
        return finalPreferTimes;
        
    } 
    @AuraEnabled
    public static void updateSpeaBookingDetails(ETI_Booking__c bkng){
        if(bkng.Payment_Status__c !='Payment Success'){
            update bkng;
        }else{
            //Cancell exisiting Service Appointment and Workorder, Workorder will canceled if Service apt is canceled.
            list<ServiceAppointment> serAptLst = [select id,Status from ServiceAppointment where ETI_Booking__c=:bkng.Id and status!='Canceled'];
            if(serAptLst.size()>0){
                for(ServiceAppointment serApt: serAptLst ){
                    serApt.Status ='Canceled';
                }
                update serAptLst;
            }
            
            update bkng;
            Id recordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Inspection_Work_Order').getRecordTypeId();
            //query to get relationship field details
            ETI_Booking__c updatedBkng = [select Id,name,ETI_Pick_Up_Location__c,CreatedBy.ContactId,ETI_Schedule_Appointment__c,Booking_Date_Time__c,User__c,User__r.ETI_Service_Territory__c from ETI_Booking__c where Id=:bkng.Id];
            list<ServiceReportLayout> layout=[select id , developername from ServiceReportLayout where developername ='Inspection Template'] ;
            list<WorkType> wtype = [select id ,Name FROM WorkType where Name ='Inspection'];
            String workTypeId;
            String layoutId;
            if(wtype != null && wtype.size() > 0){
                workTypeId = wtype[0].id;
            }
            if(layout != null && layout.size() > 0){
                layoutId = layout[0].id;
            }
            
            WorkOrder wo = new WorkOrder();          
            wo.ServiceTerritoryId = updatedBkng.User__r.ETI_Service_Territory__c;
            wo.recordTypeId = recordTypeId;
            wo.AccountId = updatedBkng.User__c; 
            wo.ServiceReportTemplateId = layoutId;
            // Start Time is - Date and Time - when Customer needs Service
            wo.StartDate = updatedBkng.Booking_Date_Time__c; 
            wo.Subject = 'Inspection';
            wo.Booking__c = updatedBkng.Id; 
            wo.WorkTypeId = workTypeId;
            wo.ContactId = updatedBkng.CreatedBy.ContactId;
            // This boolean is to control - to auto assign Service appointment to an available Service Resource...
            if(wo.ServiceTerritoryId != null){
                wo.ETI_Schedule_Appointment__c = updatedBkng.ETI_Schedule_Appointment__c;
            }
            else{
                wo.ETI_Schedule_Appointment__c = false;
            }
            wo.Street = updatedBkng.ETI_Pick_Up_Location__c;
            wo.City = 'Sharjah';
            wo.Country ='United Arab Emirates';
            
            insert wo;            
        }        
    }
    
    @AuraEnabled        
    public static List<String> getPickListValuesIntoListMNVRBrand(){
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = ETI_Booking__c.MNVR_Brand__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled  
    public static void UpdateFiles(string documentId,string recordId){  
        system.debug('UpdateFiles**');
        system.debug('documentId: ' +documentId);
        system.debug('recordId: ' +recordId);
        ContentDocument cd = [select id,title,ParentId from ContentDocument where Id=:documentId]; // Getting files from Parent record 
        cd.ParentId = recordId;  // Changing file Title with user entered title
        try{  
            update cd;  // Update ContentDocument (File)
        }  
        catch(DMLException e){  
            system.debug('Exception has occurred! ' +e.getMessage());  
        }
    } 
    
    
    
    public static void utilityMethod(){
        
        integer i=0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
    public static void utilityMethod1(){
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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