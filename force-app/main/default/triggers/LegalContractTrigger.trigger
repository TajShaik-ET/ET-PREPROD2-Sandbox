trigger LegalContractTrigger on Legal_Contract__c (before update,after insert,after update) {
    if(trigger.isBefore){
        if(trigger.isUpdate){
            ET_LegalContractController.updateOwner(trigger.new,trigger.oldMap);
        }
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            ET_LegalContractController.updateOppsStages(trigger.new);
        }
        if(trigger.isUpdate || trigger.isInsert){
            ET_LegalContractController.updateOppsLegal(trigger.new,trigger.oldMap,Trigger.isInsert);
        }
    }
}