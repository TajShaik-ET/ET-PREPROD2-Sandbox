trigger ETvehicleMasterTrg on Vehicle_Master__c (before insert,before update,after insert, after update) {
    
    if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore){
        ETVIN_VehicleMasterTrgHandler.updateGLDetails(trigger.New);
        
    }
    
    /* if(trigger.isInsert && trigger.isAfter){
ETVIN_NewPolicyCreationTrgHandler.createNewVehPolicy(trigger.New);
}*/
    
    if ((trigger.isInsert) && trigger.isAfter) {
        Set<Id> recordsToProcess = new Set<Id>();
        for (Vehicle_Master__c vehicle : trigger.New) {
            if (vehicle.TC_Number__c != null) {
                recordsToProcess.add(vehicle.Id);
            }
        }
        if (!recordsToProcess.isEmpty()) {
            ETVIN_NewPolicyCreationTrgHandler.createNewVehPolicy([SELECT Id, TC_Number__c,Amount__c FROM Vehicle_Master__c WHERE Id IN :recordsToProcess]);
        }
    }
    
    if (trigger.isUpdate && trigger.isAfter) {
        ETVIN_NewPolicyCreationTrgHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
    
}