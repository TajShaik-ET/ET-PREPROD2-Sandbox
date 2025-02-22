public without sharing class ET_VehicleController {
    @AuraEnabled
    public static commonDataWrapper getPicklistvalues(String objectName, List<String> field_apinames){
        if(objectName == null || field_apinames ==null) {
            return null;
        }
        Map<String, List<Schema.PicklistEntry>>  fieldFinalMap=ET_PicklistValueController.getPicklistvalues(objectName,field_apinames);
        if(fieldFinalMap == null) {
            return null;
        }
        List<String> optionlist = new List<String>();
        commonDataWrapper wrap=new commonDataWrapper();
        wrap.serviceTypes.addAll(ET_getServiceTypes());
        wrap.vehicleTypes.addAll(ET_getVehicleTypes());
        wrap.InsuranceCategoryList.addAll(ET_getInsuranceCategoryList());
        wrap.vehicleSource.addAll(ET_getVehicleSource());
        wrap.vehicleMake.addAll(ET_getVehicleMakes());
        wrap.vehicleOrigin.addAll(ET_getVehicleOrigins());
        wrap.vehicleModelYears.addAll(ET_getVehicleModelYears());
		wrap.maxvehicleModelYears.addAll(ET_getVehicleMaxModelYears());
        wrap.trailerModels.addAll(getTrailerModels());
        wrap.trailerSubTypes.addAll(getTrailerSubTypes());
        wrap.refrigeratorModels.addAll(getRefrigeratorModels());
        wrap.refrigeratorSubTypes.addAll(getRefrigeratorSubTypes());
        if(getSpecRequirements() != null){
            wrap.specRequirementMap.putAll(getSpecRequirements());
        }
        
        Map<String,List<String>> pricingMethodAndTypeLstMap = ET_FieldDescribeUtil.getDependentOptionsImpl(Vehicle__c.ET_Pricing_Type__c.getDescribe().getSObjectField(),Vehicle__c.ET_Pricing_Method__c.getDescribe().getSObjectField());
        if(pricingMethodAndTypeLstMap != null){
            wrap.pricingMethodAndDependentTypeMap = pricingMethodAndTypeLstMap;
        }
        
        for(String fieldVal : fieldFinalMap.keySet()){
            for (Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
                optionlist.add(pv.getValue());
            }
            if(fieldVal=='ET_Specific_requirements__c'){
                wrap.specRequirement.addAll(optionlist);
            }
            else if(fieldVal=='ET_Vehicle_Condition__c'){
                wrap.vehicleCondition.addAll(optionlist);
            }
            else if(fieldVal=='ET_Insurance_Coverage__c'){
                wrap.insuranceCoverage.addAll(optionlist);
            }
            else if(fieldVal=='ET_Contract_Type__c'){
                wrap.contractTypes.addAll(optionlist);
            }
            else if(fieldVal=='ET_Service_Emirate__c'){
                wrap.serviceEmirates.addAll(optionlist);
            }
            else if(fieldVal=='ET_Pricing_Method__c'){
                for(Integer i = 0; i < optionlist.size(); i++){
                    if(optionlist[i].equalsIgnoreCase('Comprehensive Price per Quotation')){
                        optionlist.remove(i);
                    }
                }
                wrap.pricingMethods.addAll(optionlist);
            }
            else if(fieldVal=='ET_Fleet_Type__c'){
                wrap.fleetTypes.addAll(optionlist);
            }  
            optionlist.clear();
        }
        //fetch contract years and add it to the wrap object
        ET_Service_Contract_Years__c contractYearsCustomSetting = ET_Service_Contract_Years__c.getInstance('Pricing Contract Years');
        if(contractYearsCustomSetting != null){
            List<String> yearsLst = contractYearsCustomSetting.ET_Contract_Years__c.split(',');
            yearsLst.remove(yearsLst.indexOf('Multiple'));
            wrap.contractPeriods.addAll(yearsLst);
        }else{
            system.debug(' \'Pricing Contract Years\' custom setting is missing');
        }
        
        // tret
        
        system.debug('wrap = '+ JSON.serializePretty(wrap));
        return wrap;
        
    }
    
    
    /* Description : To return Vehicle Master Data
Key = Vehicle Make + Model + Specs
*/
    @AuraEnabled
    public static vehicleMasterDataWrapper getVehicleMasterData(String vehicleMake,
                                                                String vehicleModel, 
                                                                boolean isSettingStoredData,
                                                                String vehicleSubType,
                                                                String vehicleFuelType){
        ET_Vehicle_Master__c retVehMaster = new ET_Vehicle_Master__c();
        List<String> vehicleModelYears = new List<String>();
        List<ET_Vehicle_Master__c> vehMasterList  =  ET_PricingUtilityClass.getVehicleMasterData();
        if(!vehMasterList.isEmpty()){
            for(ET_Vehicle_Master__c vehMast :vehMasterList ){
                if(vehMast.ET_Vehicle_Make__c == vehicleMake && vehMast.ET_Model__c == vehicleModel  && 
                  vehMast.ET_Vehicle_Sub_Type__c == vehicleSubType &&  vehMast.ET_Fuel_Type__c == vehicleFuelType){
                    retVehMaster = vehMast;
                }
            }
            
            if(retVehMaster != null){
                Integer currentYear = system.today().year();
                ET_Vehicle_Model_Base_Year__c baseYearCustomSetting = ET_Vehicle_Model_Base_Year__c.getInstance('Base Model Year');
                if(baseYearCustomSetting != null){
                    Integer baseYear = Integer.valueOf(baseYearCustomSetting.ET_Year_Value__c);
                    for(Integer i = baseYear ; i <= currentYear+1; i++){
                        vehicleModelYears.add(String.valueOf(i));
                    }
                }
            }
        }
        vehicleMasterDataWrapper vMastWr = new vehicleMasterDataWrapper();
        if(!isSettingStoredData){
            vMastWr.vehicleMasterRecord = retVehMaster; 
        }
        vMastWr.vehicleModelYears = vehicleModelYears;
        return vMastWr;
    }
    
    /* Description : Wrap all necessary details for vehicle details
// Add any extra info in this wrapper

*/
    public class vehicleMasterDataWrapper{
        @AuraEnabled
        public ET_Vehicle_Master__c vehicleMasterRecord;
        @AuraEnabled
        Public List<String> vehicleModelYears;
    }
    @AuraEnabled
    public static List<string> ET_getServiceTypes(){
        Map<String, List<Schema.PicklistEntry>> serviceTypePickListMap = ET_PicklistValueController.getPicklistvalues('Vehicle__c', new List<String>{'ET_Service_Type__c'});
        if(serviceTypePickListMap != null){
            List<String> optionlist = new List<String>();
            for (Schema.PicklistEntry pv : serviceTypePickListMap.get('ET_Service_Type__c')) {
                optionlist.add(pv.getValue());
            }
            return optionlist;
        }
        else{
            system.debug('Service Type Picklist is empty in Vehicle Request Data');
            return null;
        }
    }
    
    @AuraEnabled
    public static List<string> ET_getVehicleTypes(){
        List<String> vehTypesList  = new List<String>();
        List<ET_Vehicle_Type_Master__c> vehTypeMaster = [select id, ET_Vehicle_Type__c , ET_Vehicle_Sub_Type__c FROM ET_Vehicle_Type_Master__c where ET_Vehicle_Type__c !=null];
        
        if(vehTypeMaster!= null && !vehTypeMaster.isEmpty()){
            for(ET_Vehicle_Type_Master__c typeMas : vehTypeMaster ){
                if(vehTypesList != null && !vehTypesList.contains(typeMas.ET_Vehicle_Type__c)){
                    vehTypesList.add(typeMas.ET_Vehicle_Type__c);
                }
            }
        }
        
        return vehTypesList;
    }
    
     @AuraEnabled
    public static List<string> ET_getInsuranceCategoryList(){
        Map<String, List<Schema.PicklistEntry>> insuranceCategoryList = ET_PicklistValueController.getPicklistvalues('ET_Extra_Depreciation_Rate__c', new List<String>{'Insurance_Category__c'});
        if(insuranceCategoryList != null){
            List<String> optionlist = new List<String>();
            for (Schema.PicklistEntry pv : insuranceCategoryList.get('Insurance_Category__c')) {
                optionlist.add(pv.getValue());
            }
            return optionlist;
        }
        else{
            system.debug('Insurance Category Picklist is empty in Vehicle Request Data');
            return null;
        }
    }
    
    
    @AuraEnabled
    public static List<string> ET_getVehicleSource(){
        Map<String, List<Schema.PicklistEntry>> vehSourcePickListMap = ET_PicklistValueController.getPicklistvalues('Vehicle__c', new List<String>{'ET_Vehicle_Source__c'});
        if(vehSourcePickListMap != null){
            List<String> optionlist = new List<String>();
            for (Schema.PicklistEntry pv : vehSourcePickListMap.get('ET_Vehicle_Source__c')) {
                optionlist.add(pv.getValue());
            }
            return optionlist;
        }
        else{
            system.debug('Vehicle Source Picklist is empty in Vehicle Request Data');
            return null;
        }
    }
    
    public static List<String> ET_getVehicleMakes() {
        List<string> lstMakevalues=new list<String>();
        List<AggregateResult> aggList= [SELECT  ET_Vehicle_Make__c FROM ET_Vehicle_Master__c group by ET_Vehicle_Make__c order by ET_Vehicle_Make__c];
        for(AggregateResult aggr:aggList ){ 
            lstMakevalues.add((String)aggr.get('ET_Vehicle_Make__c'));
        }
        system.debug('vehicle makes : '+ lstMakevalues );
        return lstMakevalues;
    }
    
    // to get all models of Trailer 
    
    public static list<String> getTrailerModels(){
        List<string> lstTrailerModels=new list<String>();
        for(ET_Vehicle_Master__c vehMaster : [SELECT  ET_Vehicle_Make__c,Type__c,ET_Model__c FROM ET_Vehicle_Master__c  where Type__c = 'Trailer']){
            lstTrailerModels.add(vehMaster.ET_Model__c);
        }
        
        return lstTrailerModels;
    }
    
    // to get all subtypes of Trailer 
    
    public static list<String> getTrailerSubTypes(){
        List<string> lstTrailerSubTypes=new list<String>();
        for(ET_Vehicle_Type_Master__c vehTypeMaster : [SELECT  ET_Vehicle_Sub_Type__c,ET_Vehicle_Type__c,Type__c
                                                   FROM ET_Vehicle_Type_Master__c  
                                                   where Type__c = 'Trailer']){
            lstTrailerSubTypes.add(vehTypeMaster.ET_Vehicle_Sub_Type__c);
        }
        
        return lstTrailerSubTypes;
    }
    
    
    // to get all models of Refrigerator 
    
    public static list<String> getRefrigeratorModels(){
        List<string> lstRefrigeratorModels=new list<String>();
        for(ET_Vehicle_Master__c vehMaster : [SELECT  ET_Vehicle_Make__c,Type__c,ET_Model__c FROM ET_Vehicle_Master__c  where Type__c = 'Refrigerator']){
            lstRefrigeratorModels.add(vehMaster.ET_Model__c);
        }
        
        return lstRefrigeratorModels;
    }
    
    // to get all subtypes of Refrigerator 
    
    public static list<String> getRefrigeratorSubTypes(){
        List<string> lstRefrigeratorSubTypes=new list<String>();
        for(ET_Vehicle_Type_Master__c vehTypeMaster : [SELECT  ET_Vehicle_Sub_Type__c,ET_Vehicle_Type__c,Type__c
                                                   FROM ET_Vehicle_Type_Master__c  
                                                   where Type__c = 'Refrigerator']){
            lstRefrigeratorSubTypes.add(vehTypeMaster.ET_Vehicle_Sub_Type__c);
        }
        
        return lstRefrigeratorSubTypes;
    }
    
    
    public static List<String> ET_getVehicleModelYears(){
        List<String> vehicleModelYears = new List<String>();
        Integer currentYear = system.today().year();
        ET_Vehicle_Model_Base_Year__c baseYearCustomSetting = ET_Vehicle_Model_Base_Year__c.getInstance('Base Model Year');
        if(baseYearCustomSetting != null){
            Integer baseYear = Integer.valueOf(baseYearCustomSetting.ET_Year_Value__c);
            for(Integer i = baseYear ; i <= currentYear+1; i++){
                vehicleModelYears.add(String.valueOf(i));
            }
        }
        
        return vehicleModelYears ;
    }
	public static List<String> ET_getVehicleMaxModelYears(){
        List<String> MaxvehicleModelYears = new List<String>();
		ET_Vehicle_Model_Base_Year__c baseYearCustomSetting = ET_Vehicle_Model_Base_Year__c.getInstance('Base Model Year');
        ET_Vehicle_Model_Base_Year__c MaxbaseYearCustomSetting = ET_Vehicle_Model_Base_Year__c.getInstance('Max Model Year');
        if(baseYearCustomSetting != null && MaxbaseYearCustomSetting!=null){
            Integer baseYear = Integer.valueOf(baseYearCustomSetting.ET_Year_Value__c);
			Integer maxYear = Integer.valueOf(MaxbaseYearCustomSetting.ET_Year_Value__c);
            for(Integer i = baseYear ; i <= maxYear; i++){
                MaxvehicleModelYears.add(String.valueOf(i));
            }
        }
        return MaxvehicleModelYears ;
    }
    
    public static List<String> ET_getVehicleOrigins(){
        List<string> lstOriginvalues=new list<String>();
        List<AggregateResult> aggList= [SELECT ET_Country_Of_Origin__c FROM ET_Vehicle_Master__c group by ET_Country_Of_Origin__c order by ET_Country_Of_Origin__c];
        for(AggregateResult aggr:aggList ){ 
            lstOriginvalues.add((String)aggr.get('ET_Country_Of_Origin__c'));
        }
        system.debug('vehicle origin : '+ lstOriginvalues );
        return lstOriginvalues;
    }
    public static Map<String,String> getSpecRequirements(){ 
        Map<String,String> specReqMap = new Map<String,String>();
        List<ET_Vehicle_Predefined_Other_Cost_Master__c> specialRequirementMetadataLst = [Select Name,ET_Api_Name__c,Category__c 
                                                                                          From ET_Vehicle_Predefined_Other_Cost_Master__c Where isActive__c=true order by Category__c ASC,Name ASC ];                                                                             
        if(specialRequirementMetadataLst.size() > 0){
            for(ET_Vehicle_Predefined_Other_Cost_Master__c specReq : specialRequirementMetadataLst){
                specReqMap.put(specReq.Name, specReq.ET_Api_Name__c);
            }
            return specReqMap;
            
        }
        
        return null;
    }
    
    
    @AuraEnabled
    public static List<String> ET_getVehicleModels(String vehicleMake) {
        system.debug('vehicleMake : '+ vehicleMake);
        List<string> modelValuesLst=new list<String>();
        List<AggregateResult> aggList= [SELECT ET_Model__c   FROM ET_Vehicle_Master__c 
                                        where ET_Vehicle_Make__c =:vehicleMake and ET_Model__c!=null
                                        group by ET_Model__c order by ET_Model__c];
        system.debug('aggList : '+ aggList);
        for(AggregateResult aggr:aggList ){ 
            modelValuesLst.add((String)aggr.get('ET_Model__c'));
        }
        system.debug('modelValuesLst : '+ modelValuesLst);
        return modelValuesLst;
    }
    
    @AuraEnabled
    public static List<String> ET_getVehicleSpecs(String vehicleMake,String model) {
        List<string> lstTypevalues=new list<String>();
        List<AggregateResult> aggList= [SELECT ET_Specs__c FROM ET_Vehicle_Master__c 
                                        where ET_Vehicle_Make__c=:vehicleMake and ET_Model__c=:model and ET_Model__c!=null
                                        group by ET_Specs__c order by ET_Specs__c];
        for(AggregateResult aggr:aggList ){ 
            lstTypevalues.add((String)aggr.get('ET_Specs__c'));
        }
        return lstTypevalues;
    }
    
   @AuraEnabled
    public static List<String> ET_getvehicleSubTypes(String vehicleType) {
        List<string> lstsubTypeValues=new list<String>();
        List<ET_Vehicle_Type_Master__c> vehTypeMaster= new List<ET_Vehicle_Type_Master__c>([SELECT ET_Vehicle_Sub_Type__c FROM ET_Vehicle_Type_Master__c 
                                        where ET_Vehicle_Type__c=:vehicleType and ET_Vehicle_Sub_Type__c != null]) ;
        
        for(ET_Vehicle_Type_Master__c veh:vehTypeMaster ){ 
            if(!lstsubTypeValues.contains(veh.ET_Vehicle_Sub_Type__c)){
                lstsubTypeValues.add(veh.ET_Vehicle_Sub_Type__c);
            }
        }
        return lstsubTypeValues;
    }
    
    @AuraEnabled
    public static List<String> ET_getvehicleFuelTypes(String vehicleMake , String model , String vehicleSpec ,  String vehicleSubType ) {
        List<string> lstFuelTypeValues=new list<String>();
        List<ET_Vehicle_Master__c> vehMasterList= [SELECT ET_Fuel_Type__c FROM ET_Vehicle_Master__c 
                                        where ET_Vehicle_Make__c=:vehicleMake and ET_Model__c=:model and ET_Model__c!=null and 
                                        ET_Specs__c =:vehicleSpec and ET_Specs__c != null and ET_Vehicle_Sub_Type__c =:vehicleSubType 
                                        and ET_Vehicle_Sub_Type__c != null];
        
        for(ET_Vehicle_Master__c veh:vehMasterList ){ 
            if(!lstFuelTypeValues.contains(veh.ET_Fuel_Type__c)){
                lstFuelTypeValues.add(veh.ET_Fuel_Type__c);
            }
        }
        return lstFuelTypeValues;
    }
    
    @AuraEnabled
    public static List<string> getFuelTypes(){
        Map<String, List<Schema.PicklistEntry>> fuelTypePickListMap = ET_PicklistValueController.getPicklistvalues('ET_Vehicle_Fuel_Master__c', new List<String>{'ET_Fuel_Type__c'});
        if(fuelTypePickListMap != null){
            List<String> optionlist = new List<String>();
            
            for (Schema.PicklistEntry pv : fuelTypePickListMap.get('ET_Fuel_Type__c')) {
                optionlist.add(pv.getValue());
            }
            return optionlist;
        }
        else{
            system.debug('fuel Type Picklist is empty in Fuel Master Data');
            return null;
        }
    }
    
    public class commonDataWrapper{
        @AuraEnabled public List<String> serviceTypes=new List<String>();
        @AuraEnabled public List<String> vehicleMake=new List<String>();
        @AuraEnabled public List<String> vehicleSource=new List<String>();
        @AuraEnabled public List<String> vehicleCondition=new List<String>();
        @AuraEnabled public List<String> InsuranceCategoryList=new List<String>();
        @AuraEnabled public List<String> insuranceCoverage=new List<String>();
        @AuraEnabled public List<String> contractPeriods=new List<String>();
        @AuraEnabled public List<String> specRequirement=new List<String>();
        @AuraEnabled public List<String> contractTypes=new List<String>();
        @AuraEnabled public List<String> serviceEmirates=new List<String>();
        @AuraEnabled public List<String> pricingMethods=new List<String>();
        @AuraEnabled public List<String> vehicleOrigin=new List<String>();
        @AuraEnabled public List<String> fleetTypes=new List<String>();
        @AuraEnabled public List<String> vehicleTypes=new List<String>();
        @AuraEnabled public List<String> vehicleModelYears=new List<String>();
		 @AuraEnabled public List<String> maxvehicleModelYears=new List<String>();
        @AuraEnabled public List<String> trailerModels=new List<String>();
        @AuraEnabled public List<String> trailerSubTypes=new List<String>();
        @AuraEnabled public List<String> refrigeratorModels=new List<String>();
        @AuraEnabled public List<String> refrigeratorSubTypes=new List<String>();
        @AuraEnabled public Map<String,String> specRequirementMap = new Map<String,String>();
        @AuraEnabled public Map<String,List<String>> pricingMethodAndDependentTypeMap = new Map<String,List<String>>();
    }
    // Added by Arunsarathy to get opportunity details on 12.10.2023 for filtering service type
    @AuraEnabled
    public static String getOppRecord(String oppId) {
        try {
            // Query the Opportunity record by ID
            List<Opportunity> opportunityList = [SELECT Id, Name, Amount, CloseDate, ETSALES_Sector__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
            if(opportunityList.Size()>0){
                return opportunityList[0].ETSALES_Sector__c;
            }
            else {
                return null;
            }
        } catch (Exception e) {
            // Handle any exceptions here
            throw new AuraHandledException('Error retrieving opportunity: ' + e.getMessage());
        }
    }
	
}