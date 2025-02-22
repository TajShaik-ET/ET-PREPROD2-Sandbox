trigger LeadConversionTrigger on Lead (after update, after insert) {
    if(!LeadConversionTriggerHandler.isTriggerFired && trigger.isUpdate){
        LeadConversionTriggerHandler.isTriggerFired = true;
        LeadConversionTriggerHandler.updateOpportunityCreatedFromLead(Trigger.new, Trigger.oldmap);
        //LeadConversionTriggerHandler.bindTestDriveRecordsToOpp(Trigger.new, Trigger.old);//Commented By Janardhan-22/07/22
        //LeadConversionTriggerHandler.createEventonUpdate(Trigger.new, Trigger.oldmap);//Commented By Janardhan-22/07/22
    }
    if(Trigger.isAfter && Trigger.isInsert){
       // LeadConversionTriggerHandler.createEventonInsert(Trigger.new); //Commented By Janardhan-22/07/22
    }
   
}