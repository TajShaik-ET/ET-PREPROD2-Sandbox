/*
* File Name:ETPaymentTrigger
* Author : Sagar Kambli
* CreatedDate : 14/04/2020
* Modification Purpose
*/
trigger ETPaymentTrigger on ETST_Payment__c (after insert,after update) {
    switch on Trigger.operationType{
        when AFTER_INSERT{
            //ETST_Global_Handler.processReceiptForPayment(Trigger.newMap, null);
            ETI_PaymentTriggerHandler.updatePaymentStatus(Trigger.newMap, null);
            //ET Limo Services
            ETC_PaymentTriggerHandler.createReceiptForPayment(Trigger.newMap, Trigger.oldMap);
            ETC_PaymentTriggerHandler.updateServiceRequestAndVehicleBookStatus(Trigger.newMap, Trigger.oldMap);
        }
        when AFTER_UPDATE{
            ETST_Global_Handler.processReceiptForPayment(Trigger.newMap, Trigger.oldMap);
            ETI_PaymentTriggerHandler.updatePaymentStatus(Trigger.newMap, Trigger.oldMap);
            //ET Limo Services
            ETC_PaymentTriggerHandler.updateServiceRequestAndVehicleBookStatus(Trigger.newMap, Trigger.oldMap);
            ETC_PaymentTriggerHandler.createReceiptForPayment(Trigger.newMap, Trigger.oldMap);
        }
        when else{
            System.debug('Something went wrong');
        }
    }
}