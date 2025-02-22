public class AccountSitesUpdateHelper {
     
    public static void updateAccountSites(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
                Set<Id> accountIdsToUpdate = new Set<Id>();
        for (Account acc : newAccounts) {
            Account oldAcc = oldAccountMap.get(acc.Id);
            if (acc.ETSALES_TaxRegistrationNo__c != oldAcc.ETSALES_TaxRegistrationNo__c || 
                acc.ETSALES_Profile_Class__c != oldAcc.ETSALES_Profile_Class__c) {
                accountIdsToUpdate.add(acc.Id);
            }
        }
        if (!accountIdsToUpdate.isEmpty()) {
                        List<ETSALES_Account_Sites__c> relatedSites = [
                SELECT Id, Customer_TRN__c, ETSALES_Site_Profile_Class__c, ETSALES_Account__c
                FROM ETSALES_Account_Sites__c
                WHERE ETSALES_Account__c IN :accountIdsToUpdate
            ];
            Map<Id, Account> accountMap = new Map<Id, Account>(newAccounts);
            List<ETSALES_Account_Sites__c> sitesToUpdate = new List<ETSALES_Account_Sites__c>();
            for (ETSALES_Account_Sites__c site : relatedSites) {
                Account acc = accountMap.get(site.ETSALES_Account__c);
                    if (acc != null) {
                    if (acc.ETSALES_TaxRegistrationNo__c != null) {
                        site.Customer_TRN__c = acc.ETSALES_TaxRegistrationNo__c;
                    }
                    if (acc.ETSALES_Profile_Class__c != null) {
                        site.ETSALES_Site_Profile_Class__c = acc.ETSALES_Profile_Class__c;
                    }
                    sitesToUpdate.add(site);
                }
            }
            if (!sitesToUpdate.isEmpty()) {
                update sitesToUpdate;
            }
        }
    }
}