public with sharing class ESE_SchoolUser_Case_Owner_Update {
    @AuraEnabled(cacheable=true)
    public static List<Case> getCasesByAccountName(String accountName, Date startDate, Date endDate, String status) {
        String query = 'SELECT Id, CaseNumber, Status, Owner.Name, CreatedDate, Account.Name FROM Case WHERE Account.Name LIKE :accountName';
        if (startDate != null && endDate != null) {
            query += ' AND CreatedDate >= :startDate AND CreatedDate <= :endDate';
        }
        if (String.isNotEmpty(status)) {
            query += ' AND Status = :status';
        }
        //query += ' ORDER BY CreatedDate DESC LIMIT :limitSize OFFSET :offsetValue';
        return Database.query(query);
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsByNameOrCode(String accountNameOrCode) {
        return [SELECT Id, Name, School_Code__c FROM Account WHERE School_Code__c = :accountNameOrCode OR Name LIKE :('%' + accountNameOrCode + '%') LIMIT 10];
    }

    @AuraEnabled
    public static List<CaseHistory> getCaseOwnerHistory(List<Id> caseIds) {
        // Query Case History for case owner changes
        List<CaseHistory> caseHistories = [
            SELECT CaseId, OldValue, NewValue, CreatedDate
            FROM CaseHistory
            WHERE CaseId IN :caseIds AND Field = 'Owner'
            ORDER BY CreatedDate DESC
        ];
        return caseHistories;
    }
    @AuraEnabled(cacheable=true)
    public static List<User> getUsersByIds(List<Id> userIds) {
        // Fetch user names based on a list of user IDs
        return [SELECT Id, Name FROM User WHERE Id IN :userIds];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<User> getUserList(String searchKey) {
        return [SELECT Id, Name FROM User WHERE Name LIKE :('%' + searchKey + '%') LIMIT 10];
    }
    
    @AuraEnabled
    public static void updateCaseOwnersBatch(List<Id> caseIds, Id newOwnerId) {
        /*if (caseIds.isEmpty() || newOwnerId == null) {
            //throw new AuraHandledException('Invalid request: Case IDs or New Owner ID is missing.');
        }*/
        CaseOwnerBatchUpdate batchJob = new CaseOwnerBatchUpdate(caseIds, newOwnerId);
        Database.executeBatch(batchJob, 500);
    }
}