public class TaxNumberHandler {

    public static Id accOrganizationRecordTypeI = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();


    public static void handleAccounts(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        Map<String, Account> matchingParents = new Map<String, Account>();
        Set<String> childCombinations = new Set<String>();

        List<Account> existingAccountList; 
        
        if(oldAccountMap != null && !oldAccountMap.isEmpty()){
           existingAccountList = [SELECT ETSALES_TaxRegistrationNo__c FROM Account WHERE ETSALES_TaxRegistrationNo__c != null  AND RecordTypeId =:accOrganizationRecordTypeI AND ID NOT IN:oldAccountMap.keySet() AND ParentId = null];
        }else{
            existingAccountList = [SELECT ETSALES_TaxRegistrationNo__c FROM Account WHERE ETSALES_TaxRegistrationNo__c != null AND RecordTypeId =:accOrganizationRecordTypeI AND ParentId = null];   
        } 

        // Query for existing Accounts with the same unique combinations
        for (Account existingAccount : existingAccountList) {
            String combination = existingAccount.ETSALES_TaxRegistrationNo__c + '-' + existingAccount.ETSALES_TaxRegistrationNo__c;
            childCombinations.add(combination);
        }

        for (Account newAccount : newAccounts) {
            if(newAccount.RecordTypeId == accOrganizationRecordTypeI){
                String combination = newAccount.ETSALES_TaxRegistrationNo__c + '-' + newAccount.ETSALES_TaxRegistrationNo__c;
                if (newAccount.ParentId != null) {
                    if (matchingParents.containsKey(combination)) {
                        newAccount.ParentId = matchingParents.get(combination).Id;
                    }
                } else {
                    if (childCombinations.contains(combination)) {
                        newAccount.addError('Duplicate matching Tax Registration numbers.');
                    }
                }
            }   

        }

        /*for (Account newAccount : newAccounts) {
            String combination = newAccount.ETSALES_TaxRegistrationNo__c + '-' + newAccount.ETSALES_Trade_License_Number__c;

            List<Account> parentRecords = [SELECT Id, ETSALES_TaxRegistrationNo__c, ETSALES_Trade_License_Number__c FROM Account WHERE ETSALES_TaxRegistrationNo__c = :newAccount.ETSALES_TaxRegistrationNo__c AND ETSALES_Trade_License_Number__c = :newAccount.ETSALES_Trade_License_Number__c];

            if (parentRecords.size() > 0) {
                matchingParents.put(combination, parentRecords[0]);
            }
        }*/
    }
}