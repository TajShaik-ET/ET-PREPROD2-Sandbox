global class ETC_CallRefundServiceScheduled Implements Schedulable,Database.AllowsCallouts{
    
    public Set<Id> recordIds = new Set<Id>();
    global ETC_CallRefundServiceScheduled (set<Id> recIds){
        if(recIds!=null && recIds.size()>0){
            recordIds.addAll(recIds);
        }
    }
    global void execute(SchedulableContext sc)
    {
        if(!recordIds.isEmpty())
            ETC_RefundController.callRefundRequest(recordIds);   
    }
}