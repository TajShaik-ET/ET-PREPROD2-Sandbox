trigger ET_FuelConsumptionUpdateSALineVehicleMonth on Fuel_Consumption__c (after insert, after update, after delete) {

    // Set to track SALine_Assigned_Vehicle__c IDs
    Set<Id> vehicleIds = new Set<Id>();
    
    // Capture all vehicle IDs from new or updated Fuel_Consumption__c records
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Fuel_Consumption__c fc : Trigger.new) {
            if (fc.Vehicle_Number__c != null) {
                vehicleIds.add(fc.Vehicle_Number__c);
            }
        }
    }
    
    // Handle the deletion case
    if (Trigger.isDelete) {
        for (Fuel_Consumption__c fc : Trigger.old) {
            if (fc.Vehicle_Number__c != null) {
                vehicleIds.add(fc.Vehicle_Number__c);
            }
        }
    }

    // Query to get the latest Month__c from Fuel_Consumption__c records for each SALine_Assigned_Vehicle__c
    List<SALine_Assigned_Vehicle__c> vehiclesToUpdate = new List<SALine_Assigned_Vehicle__c>();
    
    for (Id vehicleId : vehicleIds) {
        // Get the latest Fuel_Consumption__c record (based on CreatedDate) for this vehicle
        List<Fuel_Consumption__c> latestFuelConsumption = [SELECT Month__c,Fuel_Consumption__c FROM Fuel_Consumption__c 
                                                           WHERE Vehicle_Number__c = :vehicleId
                                                           ORDER BY CreatedDate DESC 
                                                           LIMIT 1];
                                                           
        if (!latestFuelConsumption.isEmpty()) {
            // Update SALine_Assigned_Vehicle__c record with the latest Month
            vehiclesToUpdate.add(new SALine_Assigned_Vehicle__c(
                Id = vehicleId,
                Fuel_Consumption_Month__c = latestFuelConsumption[0].Month__c +' '+latestFuelConsumption[0].Fuel_Consumption__c
            ));
        }
    }
    
    // Perform the update if there are records to update
    if (!vehiclesToUpdate.isEmpty()) {
        update vehiclesToUpdate;
    }
}