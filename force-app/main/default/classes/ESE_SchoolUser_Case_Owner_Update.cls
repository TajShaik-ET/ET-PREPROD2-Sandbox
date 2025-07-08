/**************************************************************************************************
* Class        : ESE_SchoolUser_Case_Owner_Update
* Author       : Karri Sagar 
* Test class   :ESE_SchoolUser_Case_Owner_Update_Test
* CreatedDate  :
* Deployed Date: First Deployment on 27/03/2025
* Description : Controller for eSE_School_User_case_Owner_Update

* ----------------------------------------------------------------------------------------------- 
Sr.No.  version_DevInitials     Date               Author                  Details
1.          V1.0              27/03/2025		  Karri Sagar       	 Initial Version 
**************************************************************************************************/ 
public with sharing class ESE_SchoolUser_Case_Owner_Update {
    @AuraEnabled
    public static CombinedWrapper getCaseData(String accountName, Date startDate, Date endDate, String status) {
        CombinedWrapper combinedData = new CombinedWrapper();
        String caseQuery = 'SELECT Id, CaseNumber, Status, Owner.Name, CreatedDate, Account.Name, AccountId, (SELECT CaseId, OldValue, NewValue, CreatedDate FROM Histories WHERE Field = \'Owner\' AND DataType = \'Text\' ORDER BY CreatedDate DESC LIMIT 1) FROM Case WHERE Account.Name LIKE :accountName';
        if (startDate != null && endDate != null) {
            caseQuery += ' AND CreatedDate >= :startDate AND CreatedDate <= :endDate';
        }
        if (startDate != null && endDate == null) {
            caseQuery += ' AND CreatedDate >= :startDate';
        }
        if (startDate == null && endDate != null) {
            caseQuery += ' AND CreatedDate <= :endDate';
        }
        if (String.isNotEmpty(status)) {
            caseQuery += ' AND Status = :status';
        }
        List<Case> cases = Database.query(caseQuery);
        System.debug('Number of cases retrieved: ' + cases.size());
        for (Case c : cases) {
            combinedData.cases.add(new CaseWrapper(c));
            for (CaseHistory ch : c.Histories) {
                combinedData.caseHistories.add(new CaseHistoryWrapper(ch));
            }
        }
        combinedData.users = new List<OwnerWrapper>();
        return combinedData;
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsByNameOrCode(String accountNameOrCode) {
        return [SELECT Id, Name, School_Code__c FROM Account WHERE School_Code__c = :accountNameOrCode OR Name LIKE :('%' + accountNameOrCode + '%') LIMIT 10];
    }
    public static String govtProfileName = System.Label.Govt_School_Partner;
    
    @AuraEnabled(cacheable=true)
    public static List<OwnerWrapper> getUserList(String searchKey) {
        List<OwnerWrapper> owners = new List<OwnerWrapper>();
        //String govtProfileName = System.Label.Govt_School_Partner;
        List<String> profileNames = new List<String>();
        for(String name : govtProfileName.split(',')) {
            profileNames.add(name.trim());
        }
        List<User> users = [SELECT Id, Name FROM User WHERE Name LIKE :('%' + searchKey + '%') AND IsActive = true AND Profile.Name = :profileNames ];                        
        for (User u : users) {
            owners.add(new OwnerWrapper(u.Id, u.Name, 'User'));
        }
        return owners;
    }
    
    @AuraEnabled
    public static void updateCaseOwnersBatch(List<Id> caseIds, Id newOwnerId) {
        CaseOwnerBatchUpdate batchJob = new CaseOwnerBatchUpdate(caseIds, newOwnerId);
        Database.executeBatch(batchJob, 500);
    }
    // Combined wrapper to return cases, histories, and owners.
    public class CombinedWrapper {
        @AuraEnabled public List<CaseWrapper> cases { get; set; }
        @AuraEnabled public List<CaseHistoryWrapper> caseHistories { get; set; }
        @AuraEnabled public List<OwnerWrapper> users { get; set; }
        public CombinedWrapper() {
            cases = new List<CaseWrapper>();
            caseHistories = new List<CaseHistoryWrapper>();
            users = new List<OwnerWrapper>();
        }
    }

    public class CaseWrapper {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public String caseNumber { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String ownerName { get; set; }
        @AuraEnabled public Datetime createdDate { get; set; }
        @AuraEnabled public String accountName { get; set; }
        @AuraEnabled public Id accountId { get; set; }
        
        public CaseWrapper(Case c) {
            this.id = c.Id;
            this.caseNumber = c.CaseNumber;
            this.status = c.Status;
            this.ownerName = c.Owner != null ? c.Owner.Name : null;
            this.createdDate = c.CreatedDate;
            this.accountName = c.Account != null ? c.Account.Name : null;
            this.accountId = c.AccountId;
        }
    }
    public class CaseHistoryWrapper {
        @AuraEnabled public Id caseId { get; set; }
        @AuraEnabled public String oldValue { get; set; }
        @AuraEnabled public String newValue { get; set; }
        @AuraEnabled public Datetime createdDate { get; set; }

        public CaseHistoryWrapper(CaseHistory ch) {
            this.caseId = ch.CaseId;
            this.oldValue = (String) ch.OldValue; 
            this.newValue = (String) ch.NewValue; 
            this.createdDate = ch.CreatedDate;
        }
    }
    public class OwnerWrapper {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String type { get; set; } // e.g., "User" or "Queue"

        public OwnerWrapper(Id id, String name, String type) {
            this.id = id;
            this.name = name;
            this.type = type;
        }
    }
}