global class ETST_DeactiveTransportRequestsScheduler implements schedulable {
  global void execute(SchedulableContext sc)
    {
       ETST_DeactiveTransportRequestsBatch batch = new ETST_DeactiveTransportRequestsBatch();  
       database.executebatch(batch);
    }
    
  
}