/*
* File Name: ETI_PaymentTriggerHandler
* Author : Noor Shaik
* CreatedDate : 18/05/2021
* Modification Purpose
* * 1. Noor Shaik: Created to update Service Request Payment Status
* * 2.
*/
Public class ETI_PaymentTriggerHandler{
    //update Payment Status
    Public static void updatePaymentStatus(Map<Id, ETST_Payment__c> newMap, Map<Id,ETST_Payment__c> oldMap){
        List<ET_Service_Request__c> serviceReqUpdateList=new List<ET_Service_Request__c>();
        Set<Id> serviceRequestIds=new Set<Id>();
        try{
            for(ETST_Payment__c etb:newMap.values()){
                if((oldMap!=null && newMap.get(etb.Id).ETST_Payment_State__c != oldMap.get(etb.Id).ETST_Payment_State__c
                   && newMap.get(etb.Id).ETST_Payment_State__c =='CAPTURED') || newMap.get(etb.Id).ETST_Payment_State__c =='CAPTURED'){
                     serviceRequestIds.add(etb.ET_Service_Request__c);
                }
            }
            if(!serviceRequestIds.isEmpty()){
                Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
                for(ET_Service_Request__c sr:[Select Id,Payment_Status__c From ET_Service_Request__c Where Id IN:serviceRequestIds AND recordTypeId=:recordTypeId AND Payment_Status__c != 'Payment Success']){
                    sr.Payment_Status__c = 'Payment Success';
                    serviceReqUpdateList.add(sr);
                }
                if(!serviceReqUpdateList.isEmpty())
                    update serviceReqUpdateList;
            }
        }catch(DMLException ex){
            ETI_ServiceRequestHandler.logException(ex, 'ETI UpdatePaymentStatus');
        }   
    }
}