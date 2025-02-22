/*
* File Name:ETI_BulkPayment_AWAIT_3DS_Batch
* Author : Lahari
* CreatedDate : 09/5/2021
* Modification Purpose
* * 1. Lahari: To Update payment status
* * 2.Janardhan: Updated on 18-08-2021
*/
global class ETI_BulkPayment_AWAIT_3DS_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{  
     global String queryString;
     
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        queryString='SELECT Id, ET_Service_Request__c, ETST_Payment_State__c,ExternalID__c FROM ETST_Payment__c WHERE  ((ETST_Payment_State__c=\'AWAIT_3DS\' OR ETST_Payment_State__c=null) AND ExternalId__c!=null) AND ETI_IsUpdatedByBatch__c = false';
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext BC, List<ETST_Payment__c> scope){
        System.debug('list of records ::'+scope.size());
        for(ETST_Payment__c pay : scope)
        {	
            if(!test.isRunningTest()){
            ETI_On_Premise_Payment_Ctrl.isFirstTime = true;
            ET_Payment_Controller.getPaymentStatus(pay.ExternalId__c, true);
            }
        }
        
    }
    global void finish(Database.BatchableContext BC){
       
    }  
   
}