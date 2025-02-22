global class ETST_UpdateAccountAddressScheduler implements schedulable {
  global void execute(SchedulableContext sc)
    {
       ETST_UpdateAccountAddressBatchClass batch = new ETST_UpdateAccountAddressBatchClass();  
       database.executebatch(batch);
    }
    
   }