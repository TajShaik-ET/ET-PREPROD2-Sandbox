trigger ETVIN_sendMailForDebitNote on ETIN_Insurance_Transactions__c (after insert) {
ETVIN_SendEmailForPendingStatus.sendEmailForDebit(Trigger.newmap);
}