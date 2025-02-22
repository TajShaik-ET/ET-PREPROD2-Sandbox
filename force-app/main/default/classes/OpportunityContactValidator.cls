public class OpportunityContactValidator {
    public static void validateContactsOnOpportunity(List<Opportunity> oppList) {
        Set<String> validationRecordTypes = new Set<String>{
                'ETSALES_Leasing',
                'ETSALES_Manpower',
                'ETSALES_Transportation',
                'ETSALES_Logistics',
                'ETSALES_Rental_B2B',
                'ETSALES_Maintainance'
                };
             Set<Id> recordTypeIds = new Set<Id>();
        for (Opportunity opp : oppList) {
            if (opp.RecordTypeId != null) {
                recordTypeIds.add(opp.RecordTypeId);
            }
        }
        Map<Id, String> recordTypeDeveloperNames = new Map<Id, String>();
        if (!recordTypeIds.isEmpty()) {
            for (RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE Id IN :recordTypeIds]) {
                recordTypeDeveloperNames.put(rt.Id, rt.DeveloperName);
            }
        }
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : oppList) {
            String developerName = recordTypeDeveloperNames.get(opp.RecordTypeId);
            if (opp.AccountId != null && validationRecordTypes.contains(developerName)) {
                accountIds.add(opp.AccountId);
            }
        }
        if (!accountIds.isEmpty()) {
            Map<Id, Integer> accountContactsCount = new Map<Id, Integer>();
            for (AggregateResult result : [
                SELECT AccountId, COUNT(Id) totalContacts 
                FROM Contact 
                WHERE AccountId IN :accountIds 
                GROUP BY AccountId
            ]) {
                accountContactsCount.put((Id) result.get('AccountId'), (Integer) result.get('totalContacts'));
            }
            for (Opportunity opp : oppList) {
                String developerName = recordTypeDeveloperNames.get(opp.RecordTypeId);
                if (validationRecordTypes.contains(developerName)) {
                    if (opp.AccountId != null &&
                        (!accountContactsCount.containsKey(opp.AccountId) || 
                         accountContactsCount.get(opp.AccountId) == 0)) {
                         opp.addError('You cannot create an Opportunity for an Account that has no Contacts for Record Type');
                    }
                }
            }
        }
    }
}