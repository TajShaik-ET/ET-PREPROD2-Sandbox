trigger ETI_CustomerVehicle_Trigger on ET_Customer_Vehicle__c (after update) {
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            System.debug('Before Insert');
        }
        when AFTER_INSERT {
            System.debug('After Insert');
            ETI_CustomerVehicleHandler.tcfNoChangedNotification(Trigger.newMap, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            ETI_CustomerVehicleHandler.updateChassisNumber(Trigger.newMap, Trigger.oldMap);
            ETI_CustomerVehicleHandler.tcfNoChangedNotification(Trigger.newMap, Trigger.oldMap);
        }
        when else{
            System.debug('Something went wrong');
        }
    }
}