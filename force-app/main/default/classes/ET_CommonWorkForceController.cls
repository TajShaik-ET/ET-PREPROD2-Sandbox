public without sharing class ET_CommonWorkForceController {
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
        for(String fieldVal : fieldFinalMap.keySet()){
        for (Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
            optionlist.add(pv.getValue());
        }
       
        if(objectName=='ET_Special_Workforce_Requirement__c'){
            if(fieldVal=='ET_Specific_Leave_Plan__c'){
                wrap.specLeavePlan.addAll(optionlist);
            }/*else if(fieldVal=='ET_Specific_Insurance__c'){
                wrap.specInsurance.addAll(optionlist);
            }*/
         
        }
        optionlist.clear();
        }
        return wrap;
    }
    public class commonDataWrapper{
            @AuraEnabled public List<String> specLeavePlan=new List<String>();
            //@AuraEnabled public List<String> specInsurance=new List<String>();
    }
    
}