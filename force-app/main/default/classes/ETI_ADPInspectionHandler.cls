/***********************************************************************************************************************
* Name               : ETI_ADPInspectionHandler                                                                        *
* Test Class         : ETI_ADPInspectionHandlerTest                                                                    *
* Description        : Handler for ETI_ADP_Inspection Trigger                                                          *
* Created Date       : 24/Apr/2025                                                                                     *
* Created By         : Akash (SMAARTT)                                                                                 *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Akash       24/Apr/2025         Initial Draft.                                                             *
***********************************************************************************************************************/
public class ETI_ADPInspectionHandler {
    public static void handleBeforeInsert(List<ADP_Inspection__c> newAdpList) {
        try {
            // Step 1: Collect potential match keys
            Set<String> receiptKeys = new Set<String>();
            for (ADP_Inspection__c adp : newAdpList) {
                if (adp.Name != null) receiptKeys.add(adp.Name);
                if (adp.Receipt_Number__c != null) receiptKeys.add(adp.Receipt_Number__c);
            }
            if (receiptKeys.isEmpty()) return;
            
            // Step 2: Query matching Observations in ONE SOQL call
            Map<String, Id> receiptToObservationId = new Map<String, Id>();
            List<ETI_Inspection_Observation__c> observations = [
                SELECT Id, AMAN_Receipt_No__c 
                FROM ETI_Inspection_Observation__c 
                WHERE AMAN_Receipt_No__c IN :receiptKeys
            ];
            if(!observations.isEmpty()){
                for (ETI_Inspection_Observation__c obs : observations) {
                    if (obs.AMAN_Receipt_No__c != null) {
                        receiptToObservationId.put(obs.AMAN_Receipt_No__c, obs.Id);
                    }
                }
            }
            
            // Step 3: Match and Set Field or Show Error
            for (ADP_Inspection__c adp : newAdpList) {
                Id matchedObservationId = null;
                if (receiptToObservationId.containsKey(adp.Name)) {
                    matchedObservationId = receiptToObservationId.get(adp.Name);
                } else if (receiptToObservationId.containsKey(adp.Receipt_Number__c)) {
                    matchedObservationId = receiptToObservationId.get(adp.Receipt_Number__c);
                }
                
                if (matchedObservationId != null) {
                    adp.Inspection_Observation__c = matchedObservationId;
                } else {
                    //adp.addError('No matching ETI Inspection Observation found for ADP Name or Receipt Number: ' + adp.Name);
                    System.debug('No matching ETI Inspection Observation found for ADP Name or Receipt Number: ' + adp.Name);
                }
            }
            
        } catch (Exception e) {
            for (ADP_Inspection__c adp : newAdpList) {
                adp.addError('Unexpected error: ' + e.getMessage());
            }
            ET_PricingUtilityClass.logException(e, 'ADPInspectionHandler.handleBeforeInsert');
        }
    }
    
    public static void handleBeforeUpdate(Map<Id, ADP_Inspection__c> newMap, Map<Id, ADP_Inspection__c> oldMap) {
        try {
            Set<String> receiptKeys = new Set<String>();
            List<ADP_Inspection__c> changedAdps = new List<ADP_Inspection__c>();
            
            // Identify records where Receipt_Number__c has changed
            for (Id adpId : newMap.keySet()) {
                ADP_Inspection__c newAdp = newMap.get(adpId);
                ADP_Inspection__c oldAdp = oldMap.get(adpId);
                
                if (newAdp.Receipt_Number__c != oldAdp.Receipt_Number__c) {
                    changedAdps.add(newAdp);
                    if (newAdp.Name != null) receiptKeys.add(newAdp.Name);
                    if (newAdp.Receipt_Number__c != null) receiptKeys.add(newAdp.Receipt_Number__c);
                }
            }
            
            if (receiptKeys.isEmpty()) return;
            
            // Get related observations
            Map<String, Id> receiptToObservationId = new Map<String, Id>();
            List<ETI_Inspection_Observation__c> observations = [
                SELECT Id, AMAN_Receipt_No__c 
                FROM ETI_Inspection_Observation__c 
                WHERE AMAN_Receipt_No__c IN :receiptKeys
            ];
            if(!observations.isEmpty()){
                for (ETI_Inspection_Observation__c obs : observations) {
                    if (obs.AMAN_Receipt_No__c != null) {
                        receiptToObservationId.put(obs.AMAN_Receipt_No__c, obs.Id);
                    }
                }
            }
            
            // Update Inspection_Observation__c if match found
            for (ADP_Inspection__c adp : changedAdps) {
                Id matchedObservationId = null;
                
                if (receiptToObservationId.containsKey(adp.Name)) {
                    matchedObservationId = receiptToObservationId.get(adp.Name);
                } else if (receiptToObservationId.containsKey(adp.Receipt_Number__c)) {
                    matchedObservationId = receiptToObservationId.get(adp.Receipt_Number__c);
                }
                
                if (matchedObservationId != null) {
                    if (adp.Inspection_Observation__c != matchedObservationId) {
                        adp.Inspection_Observation__c = matchedObservationId;
                    }
                } else {
                    //adp.addError('No matching ETI Inspection Observation found for ADP Name or Receipt Number: ' + adp.Name);
                    System.debug('No matching ETI Inspection Observation found for ADP Name or Receipt Number: ' + adp.Name);
                }
            }
            
        } catch (Exception e) {
            for (ADP_Inspection__c adp : newMap.values()) {
                adp.addError('Unexpected error occurred: ' + e.getMessage());
            }
            ET_PricingUtilityClass.logException(e, 'ADPInspectionHandler.handleBeforeUpdate');
        }
    }
}