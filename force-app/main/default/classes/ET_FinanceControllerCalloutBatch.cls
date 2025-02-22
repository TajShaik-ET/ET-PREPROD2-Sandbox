/************************************************************************************************************************
 * Name               : ET_FinanceControllerCalloutBatch                                                                *
 * Test Class		  : ET_FinanceControllerBatchTest                                                                   *
 * Description        : Apex Class for automate to publish finance documents                                            *
 * Created Date       : 02/Feb/2024                                                                                    *
 * Created By         : Taj Shaik(SMAARTT)                                                                              *
 * -----------------------------------------------------------------------------------------------                      *
 * VERSION   AUTHOR      DATE                COMMENTS                                                                   *
 * 1.0       Taj Shaik   02/Feb/2024         Initial Draft.                                                             *
 ***********************************************************************************************************************/
global class ET_FinanceControllerCalloutBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    global String invoiceType;
    global List<Id> recIds;
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query='SELECT Id FROM ET_Finance_Document__c WHERE Id IN: recIds';
        system.debug('query: '+query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<ET_Finance_Document__c> docList){
        system.debug('docList Size: '+docList.Size());
        ET_Invoice_Header__mdt invHeader = [SELECT MasterLabel,developerName,ET_BatchSource__c,ET_BillToCustomerNumber__c,ET_Comments__c,ET_CustTrxType__c,ET_PaymentMethod__c,ET_TransactionCurrency__c FROM ET_Invoice_Header__mdt WHERE developerName =: invoiceType LIMIT 1];
        for(ET_Finance_Document__c finDoc: docList){
            ET_SOA_Services.syncInvoicesToEBSNew(finDoc.Id, invHeader);
        }
    }
    global void finish(Database.BatchableContext bc){
    }
}