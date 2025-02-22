trigger ETVIN_Corr_Canc_ReqTrg on Correction_Cancel_Request__c (before update,before insert,after insert) {
    
    
    //same  object has another trigger with name --> sendStatusEmailAndCreateClaimsForScrappe
    
   if(trigger.isUpdate && trigger.isBefore){
            
       ETVIN_Corr_Can_Req_Trg_Handler.sendNotification(Trigger.new,Trigger.OldMap);
      
   }
    
    if(trigger.isInsert && trigger.isBefore){
        
        ETVIN_Corr_Can_Req_Trg_Handler.sendNotificationToPRO(Trigger.new);
    }
    
    if(trigger.isInsert && trigger.isAfter){
        ETVIN_SendEmailForPendingStatus.sendEmailForMulkiya(Trigger.newMap);
    }
}