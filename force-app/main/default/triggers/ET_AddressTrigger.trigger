/*
* File Name:ET_AddressTrigger
* Author : Sagar Kambli
* CreatedDate : 10th May 2020
* Modification Purpose
* * 1. Sagar: AddressTrigger
* * 2.
*/
trigger ET_AddressTrigger on ETST_Address__c (before insert, before update, after delete) {
    
    if(Trigger.isInsert || Trigger.isUpdate){
        if(Trigger.isBefore){
            ETST_AddressTriggerHandler.updatePrimaryAddressForAccount(Trigger.new);
        }
    }

    if(Trigger.isDelete){
        if(Trigger.isAfter){
            ETST_AddressTriggerHandler.updatePrimaryAddressForAccountOnDelete(Trigger.oldMap);
        }
    }
}