/*
* File Name:ETPaymentTriggerHandler
* Author : Sagar Kambli
* CreatedDate : 14/04/2020
* Modification Purpose
* * 1. Sagar: Created for Payment Trigger Handler class
* * 2.
*/
public class ETPaymentTriggerHandler {
    
    public static void processReceiptForOnPremisePayment(Map<Id,ETST_Payment__c> newmap){
        ETPaymentTriggerHelper.processReceiptForOnPremisePayment(newmap);
    }

   /* public static void processReceiptForPayment(Map<Id,ETST_Payment__c> newmap){
        //ETPaymentTriggerHelper.processReceiptForPayment(newmap);
    }*/
}