trigger ET_InvoiceTrigger on Invoice__c (before insert, after insert, after update) {
    
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            System.debug('Before Insert');
            ETST_ShareAccountsWithCoordinator.populateCoordinatorandLocation(Trigger.new);
        }
        when AFTER_INSERT {
            //ETST_ShareAccountsWithCoordinator.populateCoordinatorandLocation(Trigger.newMap);
          /*  if(!System.isBatch()){
                String jsonString = json.serialize(Trigger.new);
                ETST_Global_Handler.invoiceEmailtoCustomer(jsonString);
            }
		 */
        }
        when AFTER_UPDATE {
            System.debug('After Update');
        }
        when else{
            System.debug('Something went wrong');
        }
    } 
}