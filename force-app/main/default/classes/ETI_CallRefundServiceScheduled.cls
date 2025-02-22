global class ETI_CallRefundServiceScheduled Implements Schedulable,Database.AllowsCallouts
{
    public Set<Id> recordIds = new Set<Id>();
    global ETI_CallRefundServiceScheduled (set<Id> recIds){
        if(recIds!=null && recIds.size()>0){
            recordIds.addAll(recIds);
        }
    }
    global void execute(SchedulableContext sc)
    {
       if(!recordIds.isEmpty()){
           ETI_CallRefundServiceBatch callRefundService = new ETI_CallRefundServiceBatch(recordIds);
           Database.executeBatch(callRefundService,1);
       }
    }
}