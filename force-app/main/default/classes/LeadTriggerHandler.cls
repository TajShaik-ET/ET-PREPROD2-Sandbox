public class LeadTriggerHandler {
    public static Boolean isFirstTime = true;
    
    public static void callLeadAssignmentRules(Map<Id, Lead> newMap){
        List<Lead> leadstoUpdate = new List<Lead>();       
        Set<ID> leadUserId = new Set<Id>();        
        for(Lead l : newMap.values()){
            leadUserId.add(l.Id);
        }       
        for(Lead l : [Select Id, Request_Category__c, Preferred_Location__c From Lead WHERE Id in: leadUserId]) {
            if(l.Request_Category__c !=null && l.Preferred_Location__c !=null){
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule  = true;
                l.setOptions(dmo);
                leadstoUpdate.add(l);
            }
        }        
        if(!leadstoUpdate.isEmpty()){
            update leadstoUpdate;
        }
    }
}