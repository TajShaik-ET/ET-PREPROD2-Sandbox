trigger ET_TrafficFineTrg on Traffic_Fine__c (before insert) {
   
    ET_TrafficFineTrgHandler.updateAssignedVehicle(trigger.new);
}