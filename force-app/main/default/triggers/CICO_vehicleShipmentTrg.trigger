trigger CICO_vehicleShipmentTrg on CICO_Vehicle_Spec__c (after update) {
    
    if(!CICO_recursiveCheck.runOnce) {
         CICO_recursiveCheck.runOnce = true;
         CICO_vehicleShipmentsTrgHandler.updateShipmentDetails(trigger.New,Trigger.OldMap);
    }
}