/*******************************************************************************************************************
Class       : ETSALES_OpportunityTrigger
Author      : 
Description : 
TestClass   : ETSALES_OpportunityTrigger_Handler_Test
----------------------------------------------------------------------------------------------------------------            
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version     Date      Modified By           Details
1.        V1                                    Initial Version
2.        V2       09/06/2023   Manisha T       Added the trigger on OppTypeValidationForInsert,OppTypeValidationForUpdate
3.        V3       16/11/2023   Arunsarathy     Commented the trigger on OppTypeValidationForInsert,OppTypeValidationForUpdate (Opp Type validation-using flow)

*******************************************************************************************************************/
trigger ETSALES_OpportunityTrigger on Opportunity (before insert, before Update, after insert, after update) {
    
      if(trigger.isBefore) {
        
        if(trigger.isInsert) {
            // Add by santosh 22/10/2024
            OpportunityContactValidator.validateContactsOnOpportunity(trigger.new);
                   }
      }
    
    if(trigger.isBefore){
         if(trigger.isInsert || trigger.isupdate){    
            // Added by Pricing Team - to update head of sales for opportunities..
            ETP_OpportunityTrigger_Handler.updateHeadOfSales(trigger.New);
            List<Opportunity> opptyInsert = new List<Opportunity>(); 
            
            for(Opportunity opt : trigger.New){
                system.debug('--->'+opt.isLeadConverted__c);
                if(!opt.isLeadConverted__c)
                {
                    opptyInsert.add(opt);
                }
            }
            if(opptyInsert.size()>0)ETSALES_OpportunityTrigger_Handler.glCodeAddition(trigger.New);
            if(opptyInsert.size()>0)ETSALES_OpportunityTrigger_Handler.glCodeAddition1(trigger.New);
            
            /*Tyre realted helper method */
            ETSALES_OpportunityTrigger_Handler.updateOppDetails(trigger.new);
             
            //Added By Manisha 09/06/2023
            //Commented by Arunsarathy on 16.11.2023,Opp Type validation- flow is being used
            //ETSALES_OpportunityTrigger_Handler.OppTypeValidationForInsert(trigger.new);
           
            
        }if(trigger.isUpdate){
            List<Opportunity> opptyUpdate = new List<Opportunity>();
            List<Opportunity> opptyTender = new List<Opportunity>();
            
            for(Opportunity oppty : trigger.New){
                if(oppty.OwnerId != trigger.OldMap.get(oppty.Id).OwnerId){
                    opptyUpdate.add(oppty);
                }
                system.debug('Opportunity Id : '+oppty.ETSALES_Tender__c+'@@'+ trigger.OldMap.get(oppty.Id).ETSALES_Tender__c);
                
                
                if(oppty.ETSALES_Tender__c != trigger.OldMap.get(oppty.Id).ETSALES_Tender__c && oppty.ETSALES_Tender__c!=null ){
                    system.debug('Opportunity Id23 : '+opptyTender );
                    
                    opptyTender.add(oppty);
                }
            }
            if(!opptyUpdate.isEmpty()){
                ETSALES_OpportunityTrigger_Handler.glCodeAddition(opptyUpdate);
                ETSALES_OpportunityTrigger_Handler.glCodeAddition1(opptyUpdate);
                
            }  
            
            system.debug('Opportunity Id : '+opptyTender );
            
            if(!opptyTender.isEmpty()){
                system.debug('Opportunity Id : '+opptyTender );
                
                ETSALES_OpportunityTrigger_Handler.gltenderLocation(opptyTender);
            }
            //Added By Akash 11/11/2022
            ETSALES_OpportunityTrigger_Handler.OppValidationOnStage(trigger.New);
            
            //Added By Akash 09/06/2023
            // Commented by Arunsarathy on 16.11.2023, Opp Type validation-flow is being used
            //ETSALES_OpportunityTrigger_Handler.OppTypeValidationForUpdate(trigger.new, trigger.oldMap);
            
            
            
        }
    }    
    if(trigger.isAfter && !trigger.isUpdate){
        //By Pass this method, when opportunity is updated because of changes in quote..
        //This is set to true in 'ET_QuoteApprovalController' class..
        if(!opportunityTriggerByPassClass.bypassTrigger){
            ETSALES_OpportunityTrigger_Handler.assignopportunityowner(trigger.New);
        }
    }
    
    if(trigger.isAfter && trigger.isUpdate){
        system.debug('after update');
        ETP_OpportunityTrigger_Handler.sendQuotationRequestToPricingTeam(trigger.oldMap, trigger.new);
        ETSALES_OpportunityTrigger_Handler.additionalGrowthFormula(trigger.newMap,trigger.oldMap); // Added by Sreelakshmi SK 06/03/2022 -- Trigger Handler: ETSALES_OpportunityTrigger_Handler
    }
    
    /*  Author          : srihari
     *  Trigger Handler : ETSALES_OpportunityTriggerHandler
     * 
     *  Commented by Janardhan to  be removed. moved to button ctrl event
    if(trigger.isAfter && trigger.isUpdate){
        ETSALES_OpportunityTriggerHandler.AccountSendtoERP(trigger.new,trigger.OldMap);
    }*/ 
    
  
    
}