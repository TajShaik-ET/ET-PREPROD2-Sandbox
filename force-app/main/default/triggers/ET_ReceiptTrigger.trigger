trigger ET_ReceiptTrigger on ET_Receipt__c (before insert, after insert, after update) {
    
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            System.debug('Before Insert');
        }
        when AFTER_INSERT {
            if(!System.isBatch()){
                String jsonString = json.serialize(Trigger.new);
                ETST_Global_Handler.receiptEmailtoCustomer(jsonString);
                //Limo Services - Sree - do not comment
                ETC_ServiceRequestHandler.sendReceiptToCustomer(Trigger.new);
            }
        }
        when AFTER_UPDATE {
            System.debug('After Update');
        }
        when else{
            System.debug('Something went wrong');
        }
    } 
}