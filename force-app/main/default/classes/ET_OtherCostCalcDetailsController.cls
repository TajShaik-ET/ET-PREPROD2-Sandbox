public without sharing class ET_OtherCostCalcDetailsController {

    @AuraEnabled
    public static String ET_getotherCostCalcDetail(String quoteId){
        List<ET_Quote_Item_SpecReq__c> quoteItemList = [Select Name, ET_Cost__c, Line_Item_Number__c,Quote_Contract_Year__c from ET_Quote_Item_SpecReq__c where Quote__c =:quoteId Order by Quote_Contract_Year__c ASC, Line_Item_Number__c ASC];
        system.debug('xquoteItemList: '+quoteItemList);
        if(quoteItemList != null){
        	return JSON.serialize(quoteItemList,true);
        }else{
            return null;
        }
    }
}