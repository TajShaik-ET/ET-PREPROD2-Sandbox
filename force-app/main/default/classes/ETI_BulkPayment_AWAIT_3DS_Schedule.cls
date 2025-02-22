/*
* File Name:ETI_BulkPayment_AWAIT_3DS_Schedule
* Author : Janardhan
* CreatedDate : 18/08/2021
* Modification Purpose
* * 
* * 
*/
global class ETI_BulkPayment_AWAIT_3DS_Schedule implements Schedulable {
  
    global void execute(SchedulableContext ctx){
        
        ETI_BulkPayment_AWAIT_3DS_Batch cls = new ETI_BulkPayment_AWAIT_3DS_Batch();
        ID batchprocessid = Database.executeBatch(cls,1);
    }
}