/**************************************************************************************************
* Class        : CaseOwnerBatchUpdate
* Author       : Karri Sagar 
* Test class   :CaseOwnerBatchUpdateTest
* CreatedDate  :
* Deployed Date: First Deployment on 27/03/2025
* Description : Used in ESE_SchoolUser_Case_Owner_Update (APEX CLASS)

* ----------------------------------------------------------------------------------------------- 
Sr.No.  version_DevInitials     Date               Author                  Details
1.          V1.0              27/03/2025		  Karri Sagar       	 Initial Version 
**************************************************************************************************/ 
global class CaseOwnerBatchUpdate implements Database.Batchable<sObject> {
    
    private Id newOwnerId;
    private List<Id> caseIds;

    // Constructor to receive caseIds and newOwnerId
    public CaseOwnerBatchUpdate(List<Id> caseIds, Id newOwnerId) {
        this.caseIds = caseIds;
        this.newOwnerId = newOwnerId;
    }

    // Query cases in batches
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, OwnerId FROM Case WHERE Id IN :caseIds]);
    }

    // Update OwnerId for each batch
    global void execute(Database.BatchableContext BC, List<Case> caseList) {
        for (Case c : caseList) {
            c.OwnerId = newOwnerId;
        }
        update caseList;
    }

    // Logs when batch is complete
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch process for updating Case Owners completed successfully!');
    }
}