trigger ETC_VehicleBookingTrigger on ETCAR_Service_Request_Line_Item__c (before insert , before update, after update) {
    
    switch on Trigger.operationType{
        /*when AFTER_INSERT {
            // ETC_VehicleBookingTriggerHandler.updateReceiptsForModifiedBookings(Trigger.new, Trigger.oldMap);
        } */
        when BEFORE_UPDATE {
            ETC_VehicleBookingTriggerHandler.recalculateVehiclePriceOnZoneUpdation(Trigger.new, Trigger.oldMap);
            
        }
        when AFTER_UPDATE {
          if(!ETC_VehicleBookingTriggerHandler.updateRemarksRunning)  ETC_VehicleBookingTriggerHandler.updateRemarks(Trigger.newMap);
            ETC_VehicleBookingTriggerHandler.recalculateVehiclePriceOnRental(Trigger.newMap, Trigger.oldMap);
        }
    }
}