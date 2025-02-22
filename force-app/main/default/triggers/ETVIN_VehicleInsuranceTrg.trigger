trigger ETVIN_VehicleInsuranceTrg on ETVIN_Vehicle_Insurance__c (after update,after insert,before insert,before update) {
    
    if(trigger.Isupdate && trigger.isAfter){
        ETVIN_SendEmailForPendingStatus.sendEmailForpolciyPending(Trigger.oldMap, Trigger.newMap);
        ETVIN_SendEmailForPendingStatus.sendEmailForpolciyAccept(Trigger.oldMap, Trigger.newMap);
        ETVIN_SendEmailForPendingStatus.sendEmailForpolciyReject(Trigger.oldMap, Trigger.newMap);
    }
    
    if(trigger.isInsert && trigger.isAfter){
        if(UserInfo.getLastName() != system.label.LoggedInUserLastName){ 
            ETVIN_sendEmailZoneCord.sendEmailToCord(trigger.new);
        }
    }
    
    if((trigger.isInsert ||trigger.isUpdate)  && trigger.isBefore){
        
        ETVIN_sendEmailZoneCord.deactiveExistingPolicies(trigger.New);
        
    }
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            try {
                ETVIN_VehicleInsuranceHandler.handleInsuranceRecords(Trigger.new, Trigger.oldMap);
            } catch (Exception e) {
                System.debug('Exception occurred: ' + e.getMessage());
                // Add custom handling or error messaging as needed
            }
        }
    }
    
}