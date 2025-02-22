/***
Class       : ETVIN_VehicleInsuranceHandler
Author      : ARUNSARATHY
Description : 
TestClass  : ETVIN_VehicleInsuranceHandlerTest
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials        Date          updated by             Details							

****************************************************************************************************************/

public class ETVIN_VehicleInsuranceHandler {
    public static void handleInsuranceRecords(List<ETVIN_Vehicle_Insurance__c> insuranceRecords, Map<Id, ETVIN_Vehicle_Insurance__c> oldInsuranceMap) {
        system.debug('nur01'+insuranceRecords);
        List<ETVIN_Insurance_Policy_Numbers__c> policyNumberList = [SELECT Id, Name, Location__c,Activity_Center__c FROM ETVIN_Insurance_Policy_Numbers__c WHERE Active__c = true];
        List<ETVIN_Vehicle_Insurance__c> recordsToUpdate = new List<ETVIN_Vehicle_Insurance__c>();
        for (ETVIN_Vehicle_Insurance__c insurance : insuranceRecords) {
            Vehicle_Master__c vm = [SELECT Id, Activity_Center__c, Plate_Type__c FROM Vehicle_Master__c WHERE Id = :insurance.Vehicle__c];
            system.debug('nur0'+vm);
            
            if (insurance.Vehicle__c != null) {
                system.debug('nu');
                for (ETVIN_Insurance_Policy_Numbers__c policyNumber : policyNumberList) {
                    system.debug('nu1');
                    system.debug('nur'+vm.Plate_Type__c);
                    system.debug('nur1'+policyNumber.Activity_Center__c);
                    if(insurance.ETVIN_Insurance_Company__c != null){ 
                    if (vm.Plate_Type__c != null && policyNumber.Activity_Center__c != null &&
                        vm.Plate_Type__c.contains('Police') && policyNumber.Activity_Center__c.contains('Police')) {
                            system.debug('nu2');
                            system.debug('nur'+vm.Plate_Type__c);
                            system.debug('nur1'+policyNumber.Activity_Center__c);
                            insurance.ETVIN_Insurance_Policy_Number__c = policyNumber.Id;
                            insurance.ETVIN_Request_Status__c = 'Insurance Pending';
                            recordsToUpdate.add(insurance);
                        }
                    else if (vm.Activity_Center__c != null && policyNumber.Activity_Center__c != null &&
                             vm.Activity_Center__c == policyNumber.Activity_Center__c){
                                 insurance.ETVIN_Insurance_Policy_Number__c = policyNumber.Id;
                                 insurance.ETVIN_Request_Status__c = 'Insurance Pending';
                                 recordsToUpdate.add(insurance);
                                 break;
                             }
                    }
                }
            }
        }
        try {
            update recordsToUpdate;
        } catch (Exception e) {
            system.debug('Error'+e);
        }
        
    }
}