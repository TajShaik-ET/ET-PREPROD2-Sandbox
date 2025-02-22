/*
* File Name:GIN_General_Ins_Policy_trg 
* Author : Janardhan
* CreatedDate : 08/09/2021
* Modification Purpose
* * 
* * 
*/
trigger GIN_General_Ins_Policy_trg on GI_General_Insurance_Policy__c (before update) {
    
    GIN_InsurancePolicyTrgHandler.updateRecordStatus(trigger.newMap);

}