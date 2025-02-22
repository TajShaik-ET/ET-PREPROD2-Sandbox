public without sharing class ET_PicklistValueController {
    public static  Map<String, List<Schema.PicklistEntry>> getPicklistvalues(String objectName, List<String> field_apinames){
        if(objectName == null || field_apinames ==null) {
            return null;
        }
        Map<String,Schema.SObjectType> globalDesc = Schema.getGlobalDescribe(); 
        if (globalDesc ==null){
            return null;
        }
        Map<String, Schema.SObjectField> field_map = globalDesc.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        if (field_map ==null){
            return null;
        }
        system.debug('field_map = '+ field_map);
        Map<String, List<Schema.PicklistEntry>> fieldFinalMap=new Map<String, List<Schema.PicklistEntry>> () ;
        
        for(String fieldVal : field_apinames){
            System.debug('fieldVal-->'+fieldVal);
            if(field_map != null && field_map.containsKey(fieldVal)){
                fieldFinalMap.put(fieldVal,field_map.get(fieldVal).getDescribe().getPickListValues());
            }
           }
        System.debug('fieldFinalMap-->'+fieldFinalMap);
        return fieldFinalMap;
    }
}