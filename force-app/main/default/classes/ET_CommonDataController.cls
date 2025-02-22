public without sharing class ET_CommonDataController {
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
        // dependent picklist  (Opportunity.ET_Pricing_Type__c.getDescribe().getSObjectField(),Opportunity.ET_Pricing_Method__c.getDescribe().getSObjectField()));
        Map<String,List<String>> pricingMethodAndTypeLstMap = ET_FieldDescribeUtil.getDependentOptionsImpl(ET_Service_Request_Common_Data__c.ET_Pricing_Type__c.getDescribe().getSObjectField(),ET_Service_Request_Common_Data__c.ET_Pricing_Method__c.getDescribe().getSObjectField());
        if(pricingMethodAndTypeLstMap != null){
            wrap.pricingMethodAndDependentTypeMap = pricingMethodAndTypeLstMap;
        }
        //
        for(String fieldVal : fieldFinalMap.keySet()){
            for (Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
                optionlist.add(pv.getValue());
            }
            System.debug('optionlist-->'+optionlist);
            System.debug('fieldVal inner-->'+fieldVal);
            if(fieldVal=='ET_Contract_Type__c'){
                wrap.contractTypes.addAll(optionlist);
            }else if(fieldVal=='ET_Service_Emirate__c'){
                wrap.serviceEmirates.addAll(optionlist);
            }
            else if(fieldVal=='ET_Pricing_Method__c'){
                wrap.pricingMethods.addAll(optionlist);
            }
            /*else if(fieldVal=='ET_Pricing_Type__c'){
wrap.pricingTypes.addAll(optionlist);
}
/*else if(fieldVal=='ET_Contract_Period__c'){
wrap.contractPeriods.addAll(optionlist);
}*/
            
            optionlist.clear();
        }
        //fetch contract years and add it to the wrap object
        ET_Service_Contract_Years__c contractYearsCustomSetting = ET_Service_Contract_Years__c.getInstance('Pricing Contract Years');
        //Mani
        List<String> contractPeriods2 = new List<String>();
        List<String> contractPeriods3 = new List<String>();
        contractPeriods2 = contractYearsCustomSetting.ET_Contract_Years__c.split(',');
        if(contractPeriods2 != null && contractPeriods2.size() > 0){
            for(String year : contractPeriods2){
                if(year != 'Multiple'){
                    contractPeriods3.add(year); 
                }
            }
        }
        if(contractPeriods3 != null && contractPeriods3.size() > 0){
            wrap.contractPeriods2 = contractPeriods3;
        }
        if(contractYearsCustomSetting != null){
            wrap.contractPeriods.addAll(contractYearsCustomSetting.ET_Contract_Years__c.split(','));
            
        }else{
            system.debug(' \'Pricing Contract Years\' custom setting is missing');
        }
        return wrap;
    }
    public class commonDataWrapper{
        @AuraEnabled public List<String> contractTypes=new List<String>();
        @AuraEnabled public List<String> serviceEmirates=new List<String>();
        @AuraEnabled public List<String> pricingMethods=new List<String>();
        @AuraEnabled public List<String> pricingTypes=new List<String>();
        @AuraEnabled public List<String> contractPeriods=new List<String>();
        @AuraEnabled public List<String> contractPeriods2=new List<String>();
        @AuraEnabled public Map<String,List<String>> pricingMethodAndDependentTypeMap = new Map<String,List<String>>();
    }
    
}