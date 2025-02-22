public class ETSALES_OpportunityTriggerHandler {
    
    @InvocableMethod
    public static void stageChangeValidation(List<Opportunity> newOpportunity){
        Set<Id> oopIdset = new Set<Id>();
        for(Opportunity oopty : newOpportunity){
            oopIdset.add(oopty.Id);
        }
        if(!oopIdset.isEmpty()){
            List<Quote> oppQuote = [SELECT Id,IsActive__c FROM Quote where IsActive__c= TRUE and OpportunityId In: oopIdset];
            
            for(Quote quoteItem : oppQuote){
                quoteItem.IsActive__c =FALSE;
            }
            update oppQuote;
        }
        
    }      
   /* Author        : Srihari Koyila
    * Calling class : MOTO_SendPersonAccountToERP
    * Trigger       : ETSALES_OpportunityTrigger
    * Commented by janardhan on 14/04/23
    * */
    /*Public static void AccountSendtoERP(List<Opportunity> trgNew, map<Id,Opportunity> trgOldMap){
       
        //Id vehInqRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Dealership_Vehicle_Inquiry_Trade_In').getRecordTypeId();
        //Id VehPurchaseRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Dealership_Veh_Purchase').getRecordTypeId();
        Id AutoCenterBodyShopRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Automotive_Service_CenterBodyShop').getRecordTypeId();
       
        for(Opportunity Opp: [Select id, RecordTypeId,StageName,AccountId ,Account.AccountNumber from Opportunity where Id =:trgNew]){
            
            if(AutoCenterBodyShopRecTypeId == Opp.RecordTypeId && Opp.StageName=='Vehicle Check-In'  && Opp.StageName!=trgOldMap.get(Opp.id).StageName){
                MOTO_SendPersonAccountToERP.sendAccToERP(Opp.AccountId,Opp.Id);
               
            }
        }
        
    }*/
}