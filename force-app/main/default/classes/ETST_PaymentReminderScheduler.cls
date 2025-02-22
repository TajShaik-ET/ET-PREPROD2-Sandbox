global class ETST_PaymentReminderScheduler implements schedulable {
  global void execute(SchedulableContext sc)
    {
       ETST_SendPaymentReminderEmailtoParents batch = new ETST_SendPaymentReminderEmailtoParents();  
       database.executebatch(batch);
    }
    
}