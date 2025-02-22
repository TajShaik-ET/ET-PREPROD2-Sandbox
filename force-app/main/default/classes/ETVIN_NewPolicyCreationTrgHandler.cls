/***
Class       : ETVIN_NewPolicyCreationTrgHandler
Author      : 
Description : 
TestClass  : ETVIN_NewPolicyCreationTrgHandlerTest
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials        Date          updated by             Details							

****************************************************************************************************************/
public class ETVIN_NewPolicyCreationTrgHandler {
    
    public static void createNewVehPolicy(list<Vehicle_Master__c> trgVal){
        list<ETVIN_Vehicle_Insurance__c> newIns  = new list<ETVIN_Vehicle_Insurance__c>();
        for(Vehicle_Master__c vm: trgVal){
            ETVIN_Vehicle_Insurance__c vi = new ETVIN_Vehicle_Insurance__c();
            vi.Vehicle__c = vm.Id;
            vi.ETVIN_TCF_No__c = vm.TC_Number__c;
            vi.Amount__c = vm.Amount__c;
            newIns.add(vi);          
        }
        if(newIns != null && newIns.size()>0){
            try {
                insert newIns;
            }
            catch (Exception e) {
                
                system.debug('Something went wrong: '+ e.getMessage());    
            }
        } 
    }
    
    //Added by Arunsarathy on 05.03.2024
    public static void handleAfterUpdate(List<Vehicle_Master__c> newVehicles, Map<Id, Vehicle_Master__c> oldMap) {
        Map<Id, Boolean> alreadyProcessedMap = new Map<Id, Boolean>();
        
        for (Vehicle_Master__c vehicle : newVehicles) {
            Vehicle_Master__c oldVehicle = oldMap.get(vehicle.Id);
            
            if (vehicle.TC_Number__c != null && (oldVehicle == null || oldVehicle.TC_Number__c != vehicle.TC_Number__c)) {
                // Check if trigger has already executed for this record
                if (!alreadyProcessedMap.containsKey(vehicle.Id)) {
                    alreadyProcessedMap.put(vehicle.Id, true);
                    processVehicle(vehicle);
                }
            }
        }
    }

    // Method to process each vehicle
    public static void processVehicle(Vehicle_Master__c vehicle) {
        // Check if a related ETVIN_Vehicle_Insurance__c record already exists
        Integer existingInsuranceCount = [SELECT COUNT() FROM ETVIN_Vehicle_Insurance__c WHERE Vehicle__c = :vehicle.Id];
        if (existingInsuranceCount == 0) {
            // Call method to create a new ETVIN_Vehicle_Insurance__c record if condition is met
            createNewVehPolicy(new List<Vehicle_Master__c>{vehicle});
        } else {
            // Update the TC_Number__c field in the existing ETVIN_Vehicle_Insurance__c record
            updateExistingInsurance(vehicle);
        }
    }

    // Method to update existing ETVIN_Vehicle_Insurance__c record
    public static void updateExistingInsurance(Vehicle_Master__c vehicle) {
        ETVIN_Vehicle_Insurance__c existingInsurance = [SELECT Id, ETVIN_TCF_No__c, ETVIN_Insurance_Company__c FROM ETVIN_Vehicle_Insurance__c WHERE Vehicle__c = :vehicle.Id LIMIT 1];
        if(existingInsurance.ETVIN_Insurance_Company__c != null){ 
        existingInsurance.ETVIN_TCF_No__c = vehicle.TC_Number__c;
        }
        update existingInsurance;
    }
    //changes end by Arunsarathy
}