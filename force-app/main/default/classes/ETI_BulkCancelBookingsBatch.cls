/*
* File Name:ETI_BulkCancelBookingsBatch
* Author : Noor Shaik
* CreatedDate : 3/5/2021
* Modification Purpose
* * 1. Noor Shaik: To Update Service Request status
* * 2.
*/
global class ETI_BulkCancelBookingsBatch implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts, Database.Stateful{  
    
    global String queryString;
    public Set<Id> recordIds = new Set<Id>();
    public string cancellationReason;
    public Id serviceReqId;
    global ETI_BulkCancelBookingsBatch(list<Id> recIds,string cancelReason){
        if(recIds!=null && recIds.size()>0){
            recordIds.addAll(recIds);
        }
        if(cancelReason!=null)
            cancellationReason=cancelReason;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        queryString='SELECT Id,Name,Service_Request__c FROM ETI_Booking__c WHERE Id IN:recordIds';
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext BC, List<ETI_Booking__c> scope){
        ETI_VehicleController.cancelBooking(new List<Id>{scope[0].Id},cancellationReason);
        if(serviceReqId==null)
            serviceReqId=scope[0].Service_Request__c;
    }
    global void finish(Database.BatchableContext BC){
        if(serviceReqId!=null){
            list<ET_Service_Request__c> serviceReqUpdate=new list<ET_Service_Request__c>();
            for(ET_Service_Request__c sr:[Select Id,Payment_Status__c From ET_Service_Request__c Where Id=:serviceReqId AND Total_Amount__c=0]){
                if(sr.Payment_Status__c!='Refund Requested'){
                    sr.Payment_Status__c='Refund Requested';
                    serviceReqUpdate.add(sr);
                }
            }
            if(!serviceReqUpdate.isEmpty())
                update serviceReqUpdate;
        }
    }  
    global void execute(SchedulableContext scon) {
        Database.executeBatch(new ETI_BulkCancelBookingsBatch(null,null));
    }
}