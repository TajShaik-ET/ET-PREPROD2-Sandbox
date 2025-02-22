trigger ET_SalesAgreementTrigger on ET_Sales_Agreement__c (before insert,after insert, after update) {
      switch on Trigger.operationType{
        when BEFORE_INSERT {
            System.debug('Before Insert');
        }
        when AFTER_INSERT{
            //String jsonString = json.serialize(Trigger.new);
            ETST_Global_Handler.UpdateSchoolSalesAgreement(Trigger.newMap, null);
        }
        when AFTER_UPDATE{
            System.debug('Before Insert');
        }
         when else{
             System.debug('Something went wrong');
         }
     }
}