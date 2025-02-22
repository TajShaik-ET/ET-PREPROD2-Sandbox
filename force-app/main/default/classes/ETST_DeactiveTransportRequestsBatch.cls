/*******************************************************************************************************************
Class       : ETST_DeactiveTransportRequestsBatch
Author      : Kamal Mahammad
Description :  
TestClass  : ETST_DeactiveTransportRequestsBatchTest
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date             Changed By                        Details
1.          V1               
1.          V2               Jan 20th, 2022     Sreelakshmi SK        In execute method-- added the code to check the status
*******************************************************************************************************************/

global class ETST_DeactiveTransportRequestsBatch implements Database.Batchable<sObject> {
    public Date dateValue= System.today().toStartOfMonth();
    public Date today = Date.today();
    
    List<string> reqStatus = System.Label.ETST_DeactiveBatchStatus.Split(', '); 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('----Start---');
        String query = 'select Id,ETST_Pick_Up_End_Date__c ,ETST_Pick_Up_Start_Date__c,ETST_Status__c,ETST_Is_Active__c,ETST_Student__r.ETST_Account_Name__r.PersonEmail,ETST_Student__r.ETST_Account_Name__r.PersonContactId from ET_Service_Request__c';
        query += ' where (ETST_Pick_Up_Start_Date__c >=:dateValue AND ETST_Is_Active__c=false AND ETST_Status__c NOT IN:reqStatus ) OR (ETST_Pick_Up_End_Date__c<=:dateValue AND ETST_Is_Active__c=true)';
        System.debug('----query---' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute( Database.BatchableContext BC,List<ET_Service_Request__c> scope ) {
        for (ET_Service_Request__c request : scope) {
            if (request.ETST_Pick_Up_Start_Date__c >= dateValue && !request.ETST_Is_Active__c) {
                request.ETST_Is_Active__c = true;
            }
            
            else if (request.ETST_Pick_Up_End_Date__c <= dateValue && request.ETST_Is_Active__c && request.ETST_Status__c != 'Under Review' ){ //Added the condition to check whether status is 'Under Review'-added by Sreelakshmi SK
                if(request.ETST_Status__c != 'Service Confirmed'){ //Added the condition to check whether status is 'Service Confirmed'-added by Sreelakshmi SK
                    request.ETST_Is_Active__c = false;
                }
                    
            }
        }
        try {
            Database.update(scope, false);
        } catch (DMLException ex) {
            System.debug('--Failed to Update the requests' + ex.getMessage());
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('----finish---');
    }   
}