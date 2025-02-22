public with sharing class CaseDisputes {
    @AuraEnabled
    public static String updateDisputeConfirmation(Id caseId) {
        Case caseRecord2 = [SELECT Id, Dispute_conformations__c FROM Case WHERE Id = :caseId LIMIT 1];
        if (caseRecord2.Dispute_conformations__c == true) {
            return 'Already you have updated dispute fields.';
        } else {
            caseRecord2.Dispute_conformations__c = true; 
            update caseRecord2;
            return 'Dispute Confirmation updated successfully.';
        }
    }
}