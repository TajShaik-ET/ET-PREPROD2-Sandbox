global class Common_ScheduleSandboxRefreshBatch implements Schedulable {
    global String objectApiName;
    global Set<String> fieldsListToMask;
    
    global Common_ScheduleSandboxRefreshBatch(String objectApiName,Set<String> fieldsListToMask){
        this.objectApiName=objectApiName;
        this.fieldsListToMask=fieldsListToMask;
    }
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new Common_UpdateSobjectBatch(objectApiName,fieldsListToMask));        
        System.abortJob(sc.getTriggerID());
    }
}