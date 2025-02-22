public class ETC_PaymentTriggerHandler {
    
    public static void updateServiceRequestAndVehicleBookStatus(Map<Id,ETST_Payment__c> newMap, Map<Id,ETST_Payment__c> oldMap){
        Set<Id> serviceReqIds = new Set<Id>();
        Set<Id> miscellaneousServiceReqIds = new Set<Id>();
        Id recordTypeId =Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
        Id payRecordTypeId=Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Miscellaneous_Payment').getRecordTypeId();
        List<ET_Service_Request__c> serReqList = new List<ET_Service_Request__c>();
        for(ETST_Payment__c pay:newMap.values()){
            if(pay.RecordTypeId != payRecordTypeId && pay.ETST_Payment_State__c == ET_Common_Util.PAYMENT_CAPTURED && (oldMap == null || oldMap.get(pay.Id).ETST_Payment_State__c != pay.ETST_Payment_State__c)){
                serviceReqIds.add(pay.ET_Service_Request__c);
            }else if(pay.RecordTypeId == payRecordTypeId && pay.ETST_Payment_State__c == ET_Common_Util.PAYMENT_CAPTURED && (oldMap == null || oldMap.get(pay.Id).ETST_Payment_State__c != pay.ETST_Payment_State__c)){
                miscellaneousServiceReqIds.add(pay.ET_Service_Request__c);
            }
        }
        if(!serviceReqIds.isempty()){
            for(ET_Service_Request__c req:[Select Id,Name,ETC_Payment_Status__c,(Select Id,Name,ETCAR_Status__c from Service_Request_Line_Items__r) 
                                           From ET_Service_Request__c where Id IN:serviceReqIds and RecordTypeId=:recordTypeId]){
                                               req.ETC_Payment_Status__c='Payment Success';
                                               req.ETC_Payment_Date__c = system.now();
                                               serReqList.add(req);
                                               
                                           }
        }
        if(!miscellaneousServiceReqIds.isempty()){
            for(ET_Service_Request__c req:[Select Id,Name,ETC_Payment_Status__c,(Select Id,Name,ETCAR_Status__c from Service_Request_Line_Items__r) 
                                           From ET_Service_Request__c where Id IN:miscellaneousServiceReqIds and RecordTypeId=:recordTypeId]){
                                               req.ETC_Miscellaneous_Payment_Status__c='Payment Success';
                                               req.ETC_Miscellaneous_Payment_Date__c = system.now();
                                               serReqList.add(req);
                                               
                                           }
        }
        if(serReqList!=null && serReqList.size()>0){
            update serReqList;
        }							   
        
    }
    
    public static void createReceiptForPayment(Map<Id,ETST_Payment__c> newMap, Map<Id,ETST_Payment__c> oldMap){
        
        Set<Id> serviceReqIds = new Set<Id>();    
        List<ET_Receipt__c> receipts = new List<ET_Receipt__c>();
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.ET_Receipt__c.getRecordTypeInfosByDeveloperName().get('ET_Car_Services').getRecordTypeId();
        
        //Create Receipt for only those payments of type online and offline on Create and Update
        for(ETST_Payment__c payment: [Select Id,Name,ETST_Payment_Mode__c,ETST_Payment_State__c,ETST_Amount__c,ET_Service_Request__c,ET_Service_Request__r.RecordTypeId
            FROM ETST_Payment__c WHERE ET_Service_Request__r.RecordTypeId =:srRecordTypeId AND Id IN:newMap.keyset()]){
                system.debug('payment***'+payment);
                if(payment.ETST_Payment_State__c == ET_Common_Util.PAYMENT_CAPTURED && (oldMap == null || oldMap.get(payment.Id).ETST_Payment_State__c != payment.ETST_Payment_State__c)){ 
                    ET_Receipt__c receipt = new ET_Receipt__c();
                    receipt.ET_Service_Request__c = payment.ET_Service_Request__c;
                    receipt.Payment_Mode__c = payment.ETST_Payment_Mode__c;
                    receipt.RecordTypeId = recordTypeId;
                    receipt.ET_Payment__c=payment.Id;
                    if(payment.ETST_Amount__c!=null) receipt.ET_Amount__c = payment.ETST_Amount__c;
                    receipts.add(receipt);  
                }
            }
        if(receipts.size()>0) if(receipts.size()>0) insert receipts;
    }
      
}