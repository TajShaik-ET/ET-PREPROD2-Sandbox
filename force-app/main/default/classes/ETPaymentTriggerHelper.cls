/*
* File Name:ETPaymentTriggerHelper
* Author : Sagar Kambli
* CreatedDate : 14/04/2020
* Modification Purpose
* * 1. Sagar: Created for Payment Trigger helper class
* * 2.
*/
public class ETPaymentTriggerHelper {
    /*
    public static void processReceiptForPayment(Map<Id,ETST_Payment__c> newmap){
        Set<Id> serviceIds = new Set<Id>();
        
        //Create Receipt for only those payments of type online and offline on Create and Update
        for(ETST_Payment__c payment: newmap.values()){
            if(payment.ETST_AuthorizationCode__c!=null && payment.ETST_Payment_State__c == ET_Common_Util.PAYMENT_CAPTURED || 
            (payment.ETST_Payment_Mode__c.toLowerCase() == ET_Common_Util.PAYMENT_OFFLINE_TYPE.toLowerCase()))
            {
                serviceIds.add(payment.ET_Service_Request__c);
            }
        }
    }*/
    
  


  
    public static void processReceiptForOnPremisePayment(Map<Id,ETST_Payment__c> newmap){
        Id recordTypeId =Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByName().get('On Premise Payment').getRecordTypeId();
        List<ETI_Inspection_Receipt__c> receipts = new List<ETI_Inspection_Receipt__c>();
        Map<Id,List<ETST_Payment__c>> servicePaymentMap = new Map<Id,List<ETST_Payment__c>>();
        
        for(String key: newmap.keyset()){
            if(newmap.get(key).recordtypeId ==  recordTypeId)
            {
                if(servicePaymentMap.get(newmap.get(key).ET_Service_Request__c) == null)
                    servicePaymentMap.put(newmap.get(key).ET_Service_Request__c,new List<ETST_Payment__c>{newmap.get(key)});
                else
                    servicePaymentMap.get(newmap.get(key).ET_Service_Request__c).add(newmap.get(key));
            }
        }
        
        if(servicePaymentMap.size() > 0){
             List<ET_Service_Request__c> services = [SELECT Id, Name,ET_Account__c, ETST_Parent__r.Name, 
                                                          (SELECT Id,Name, Booking_Date__c, 
                                                          Amount__c, Customer_Vehicle__r.Chassis_No__c from Bookings__r) 
                                                          FROM 
                                                          ET_Service_Request__c where Id in:servicePaymentMap.keyset()];
            //List<ETI_Booking__c> bookings = new List<ETI_Booking__c>();
            if(services!=null && services.size()>0){
                for(ET_Service_Request__c service: services){
                //bookings = new List<ETI_Booking__c>();
               //bookings = service.Bookings__r;
                Decimal totalAmount=0;
                    System.debug('@@@@1  ' + service.Bookings__r.size());
                if(service.Bookings__r!=null && service.Bookings__r.size()>0){
                  for(ETI_Booking__c booking: service.Bookings__r){
                    ETI_Inspection_Receipt__c receipt = new ETI_Inspection_Receipt__c();
                    receipt.Bookings__c = booking.Id;
                    receipt.ETI_Account__c = service.ET_Account__c;
                    receipt.Service_Request__c = service.Id;
                      System.debug('@@@@1  ' + booking);
                    if(booking.Amount__c!=null)
                    {
                        System.debug('@@@@@@@@@@@@@@@@@@@@@@@   ' + servicePaymentMap.get(service.Id)[0].ETST_Amount__c);
                        totalAmount += booking.Amount__c;
                        receipt.ETI_Amount__c = servicePaymentMap.get(service.Id)[0].ETST_Amount__c;
                        receipt.Auth_Code__c = servicePaymentMap.get(service.Id)[0].ETST_AuthorizationCode__c;
                    }
                    receipts.add(receipt);
                }      
                }
                
                
                if(servicePaymentMap.get(service.Id)!=null){
                    for(ETST_Payment__c payment: servicePaymentMap.get(service.Id)){
                        system.debug(payment);
                        if(totalAmount < payment.ETST_Amount__c)
                            payment.addError('Amount must be less than equal to booking payment');
                    }
                }
                //if(totalAmount)
            }
            }
            system.debug('###################   ' +receipts );
            if(receipts.size()>0)
                insert receipts;
        }
    }
    
   
}