public without sharing class ET_WorkforceController {
    @AuraEnabled(cacheable=true)
    public static commonDataWrapper getPicklistvalues(String objectName, List<String> field_apinames, String workforceType){
        if(objectName == null || field_apinames ==null) {
            return null;
        }
        Map<String, List<Schema.PicklistEntry>>  fieldFinalMap=ET_PicklistValueController.getPicklistvalues(objectName,field_apinames);
        if(fieldFinalMap == null) {
            return null;
        }
        List<String> optionlist = new List<String>();
        commonDataWrapper wrap=new commonDataWrapper();
        // dependent picklist  (ET_Work_force__c.ET_Pricing_Type__c.getDescribe().getSObjectField(),ET_Work_force__c.ET_Pricing_Method__c.getDescribe().getSObjectField()));
        Map<String,List<String>> pricingMethodAndTypeLstMap = ET_FieldDescribeUtil.getDependentOptionsImpl(ET_Work_force__c.ET_Pricing_Type__c.getDescribe().getSObjectField(),ET_Work_force__c.ET_Pricing_Method__c.getDescribe().getSObjectField());
        if(pricingMethodAndTypeLstMap != null){
            wrap.pricingMethodAndDependentTypeMap = pricingMethodAndTypeLstMap;
        }
        system.debug('fieldFinalMap>> '+fieldFinalMap);
        for(String fieldVal : fieldFinalMap.keySet()){
            for (Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
                optionlist.add(pv.getValue());
            }
            system.debug('fieldVal>> '+fieldVal);
            switch on workforceType {
                when 'Driver' {
                    if(fieldVal=='ET_Driver_Category__c'){
                        wrap.workforceCategory.addAll(getWorkForceCategories('Driver'));
                        wrap.serviceTypes.addAll(ET_getServiceTypes());
                    }
                }
                when 'Nanny' {
                    if(fieldVal=='ET_Nanny_Category__c'){
                        wrap.workforceCategory.addAll(getWorkForceCategories('Nanny'));
                        wrap.serviceTypes.addAll(ET_getServiceTypes());
                    }
                }
                when 'Coordinator' {
                    if(fieldVal=='ET_Coordinator_Category__c'){
                        wrap.workforceCategory.addAll(getWorkForceCategories('Coordinator'));
                        wrap.serviceTypes.addAll(ET_getServiceTypes());
                    }
                }
                when 'Supervisor' {
                    if(fieldVal=='ET_Supervisor_Category__c'){
                        wrap.workforceCategory.addAll(getWorkForceCategories('Supervisor'));
                        wrap.serviceTypes.addAll(ET_getServiceTypes());
                    }
                }
                when 'Accountant' {
                    if(fieldVal=='ET_Accountant_Category__c'){
                        wrap.workforceCategory.addAll(getWorkForceCategories('Accountant/Cashier'));
                        wrap.serviceTypes.addAll(ET_getServiceTypes());
                    }
                }
                when 'Other Employee' {
                    if(fieldVal=='ET_Other_employee_Category__c'){
                        wrap.workforceCategory.addAll(getWorkForceCategories('Other Employee'));
                        wrap.serviceTypes.addAll(ET_getServiceTypes());
                    }
                }
            }
            
            
            if(fieldVal=='ET_Special_requirements__c'){
                wrap.specRequirement.addAll(optionlist);
            }/*else if(fieldVal=='ET_Contract_Period__c'){
wrap.contractPeriods.addAll(optionlist);
}*/
            else if(fieldVal=='ET_Contract_Type__c'){
                wrap.contractTypes.addAll(optionlist);
            }
            else if(fieldVal=='ET_Service_Emirate__c'){
                wrap.serviceEmirates.addAll(optionlist);
            }
            else if(fieldVal=='Type__c'){
                wrap.Types.addAll(optionlist);
            }
            else if(fieldVal=='ET_Pricing_Method__c'){
                for(Integer i = 0; i < optionlist.size(); i++){
                    if(optionlist[i].equalsIgnoreCase('Comprehensive Price per Quotation')){
                        optionlist.remove(i);
                    }
                }
                wrap.pricingMethods.addAll(optionlist);
            }
            /*else if(fieldVal=='ET_Pricing_Type__c'){
wrap.pricingTypes.addAll(optionlist);
}*/
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
        
        
        
        return wrap;
        
    }
    public class commonDataWrapper{
        @AuraEnabled public List<String> serviceTypes=new List<String>();
        @AuraEnabled public List<String> Types=new List<String>();
        @AuraEnabled public List<String> workforceCategory=new List<String>();
        @AuraEnabled public List<String> specRequirement=new List<String>();
        @AuraEnabled public List<String> contractTypes=new List<String>();
        @AuraEnabled public List<String> serviceEmirates=new List<String>();
        @AuraEnabled public List<String> pricingMethods=new List<String>();
        //@AuraEnabled public List<String> pricingTypes=new List<String>();
        @AuraEnabled public List<String> contractPeriods=new List<String>();
        @AuraEnabled public Map<String,List<String>> pricingMethodAndDependentTypeMap = new Map<String,List<String>>();
    }
    @AuraEnabled(cacheable=true)
    public static List<string> ET_getServiceTypes(){
        Map<String, List<Schema.PicklistEntry>> fuelTypePickListMap = ET_PicklistValueController.getPicklistvalues('Vehicle__c', new List<String>{'ET_Service_Type__c'});
        if(fuelTypePickListMap != null){
            List<String> optionlist = new List<String>();
            for (Schema.PicklistEntry pv : fuelTypePickListMap.get('ET_Service_Type__c')) {
                optionlist.add(pv.getValue());
            }
            return optionlist;
        }
        else{
            system.debug('Service Type Picklist is empty in Vehicle Request Data');
            return null;
        }
    }
    
    public static List<string> ET_Types(){
        Map<String, List<Schema.PicklistEntry>> TypePickListMap = ET_PicklistValueController.getPicklistvalues('ET_Special_Workforce_Requirement__c', new List<String>{'Type__c'});
        if(TypePickListMap != null){
            List<String> optionlist = new List<String>();
            for (Schema.PicklistEntry pv : TypePickListMap.get('Type__c')) {
                optionlist.add(pv.getValue());
            }
            return optionlist;
        }
        else{
            return null;
        }
    }
    
    public static List<String> getWorkForceCategories(String workForceType){
        List<Workforce_Master__c> workforceMaterData = [Select ET_Workforce_Category__c from Workforce_Master__c where  Workforce_Type__c = :workForceType];
        if(workforceMaterData != null && workforceMaterData.size() > 0){
            List<String> categoriesLst = new List<String>();
            for(Workforce_Master__c workforceMaster : workforceMaterData){
                categoriesLst.add(workforceMaster.ET_Workforce_Category__c);
            }
            return categoriesLst;
        }
        return null;     
    }
    
}