trigger ETVIN_claimTrg on ETIN_Claim__c (after update, after insert,before insert,before update) {
   
    if(trigger.isAfter && trigger.isUpdate){
    ETVIN_SendEmailForPendingStatus.sendEmailForClaimsPending(Trigger.oldMap, Trigger.newMap);
    ETVIN_SendEmailForPendingStatus.sendEmailForClaimsAccept(Trigger.oldMap, Trigger.newMap);
    ETVIN_SendEmailForPendingStatus.sendEmailForClaimsReject(Trigger.oldMap, Trigger.newMap);
    }
    if(Trigger.isinsert && trigger.isAfter){
        ETVIN_SendEmailForPendingStatus.sendEmailForClaimsScrabbedTheft(Trigger.newMap);
    }
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        
        ETVIN_CompensatationInsuredCalHandler.calculateInsuredAndCompenstationVal(trigger.New,trigger.newMap,trigger.oldMap);
    }
    
}