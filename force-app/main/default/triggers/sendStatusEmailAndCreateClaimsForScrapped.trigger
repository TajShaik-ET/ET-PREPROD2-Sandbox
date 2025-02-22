trigger sendStatusEmailAndCreateClaimsForScrapped on Correction_Cancel_Request__c (after update, before insert) {
if(Trigger.isUpdate){
ETVIN_SendEmailForPendingStatus.sendEmailForCorrectionPending(Trigger.oldMap, Trigger.newMap);
ETVIN_SendEmailForPendingStatus.sendEmailForCorrectionAccept(Trigger.oldMap, Trigger.newMap);
ETVIN_SendEmailForPendingStatus.sendEmailForCorrectionReject(Trigger.oldMap, Trigger.newMap);
}
if(Trigger.isInsert){
ETVIN_SendEmailForPendingStatus.createClaimsForScrappedVehicleTheft(Trigger.new);
}

}