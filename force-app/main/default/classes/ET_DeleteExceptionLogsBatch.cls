/*
* File Name:ET_DeleteExceptionLogsBatch
* Author : Noor Shaik
* CreatedDate : 27/01/2021
* Modification Purpose
* * 1. Noor Shaik: Created for Delete ExceptionLogs 
* * 2.
*/
global class ET_DeleteExceptionLogsBatch implements Database.Batchable<sObject>, Schedulable{  
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        string queryString='SELECT Id,CreatedDate FROM Exception_Log__c WHERE CreatedDate<LAST_N_MONTHS:1';
        return Database.getQueryLocator(queryString);
    }
    global void execute(Database.BatchableContext BC, List<Exception_Log__c> scope){
        delete scope;
    }
    global void finish(Database.BatchableContext BC){
            
    }  
    global void execute(SchedulableContext scon) {
        Database.executeBatch(new ET_DeleteExceptionLogsBatch());
    }
}