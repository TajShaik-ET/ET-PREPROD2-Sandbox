/******************************************************************************************************************************

Trigger : LeadAssignmentTrigger
Hanlder : LeadAssignmentTriggerHandler
Description : 

Version 1  : When Creating Lead , if Leads Company Name already Exist as an Account in salesforce , Account owner should be 
the Lead Owner.
company Name is matched with Case Insensitive.

********************************************************************************************************************************/


trigger ETSALES_LeadTrigger on Lead (before insert , before update,after update,after insert ) {
    //Disable Trigger for Data Admin User through Custom Settings for Bypassing Trigger - During Data Loading...
    
    Disable_Rules_And_Triggers__c instance = Disable_Rules_And_Triggers__c.getInstance();  
    system.debug('---------->'+instance);
    if (instance != null && !(instance.Disable_Triggers__c) ) {
        system.debug('---------->'+trigger.new);
        
        //Before Insert
        if(trigger.isbefore){
            List<Lead> ownerUpdateList = new List<Lead>();
            //LeadAssignmentTriggerHandler.leadOwnerAssignment(trigger.new);
            if(trigger.isInsert){
               
                ETSALES_LeadTriggerHandler.glDetailsUpdation(trigger.new);
                ETSALES_LeadTriggerHandler.glDetailsUpdation1(trigger.new);
                ETSALES_LeadTriggerHandler.updateVehicleInfo(trigger.new); //Added by Janardhan Muddana
            }else if(trigger.isUpdate){
                //ETSALES_LeadTriggerHandler.updateVehicleInfo(trigger.new); 
                for(Lead ld : trigger.new){
                     
                    if(ld.OwnerId != trigger.OldMap.get(ld.Id).OwnerId){
                        ownerUpdateList.add(ld);
                    }
                }
            }
            if(!ownerUpdateList.isEmpty()){
                ETSALES_LeadTriggerHandler.glDetailsUpdation(ownerUpdateList); 
                ETSALES_LeadTriggerHandler.glDetailsUpdation1(ownerUpdateList); 

            }  
        }
        if(Trigger.isAfter && Trigger.isInsert){
            if(LeadTriggerHandler.isFirstTime){
                LeadTriggerHandler.isFirstTime = false;
                LeadTriggerHandler.callLeadAssignmentRules(Trigger.newMap);
            }
        }
    }
}