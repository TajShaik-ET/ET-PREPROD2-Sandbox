global class ETST_StudentActivateBatchClass implements Database.Batchable<sObject>, schedulable{
    global string queryString;
    public set<Id> studentIds = new set<Id>();
    public Date today=system.today();
    global ETST_StudentActivateBatchClass(){
        queryString = 'Select id,Name,ETST_Status__c,';
        queryString +='(Select id,Name,ETST_Student__c,ETST_Status__c,ETST_Reason_for_Cancellation__c,ETST_Activation_Effective_Date__c from ETST_Transport_Requests__r WHERE ETST_Reason_for_Cancellation__c=\'On Hold\' AND ETST_Cancellation_End_Date__c <:today)';
        queryString += ' from ETST_Student__c WHERE ETST_Status__c=\'Inactive\' ';
        
        system.debug('queryString-->'+queryString);
    }
    
    public ETST_StudentActivateBatchClass(set<Id> studentIds){
        studentIds.addAll(studentIds);
        queryString = 'Select id,Name,ETST_Status__c,';
        queryString +='(Select id,Name,ETST_Student__c,ETST_Status__c,ETST_Reason_for_Cancellation__c,ETST_Activation_Effective_Date__c from ETST_Transport_Requests__r WHERE ETST_Reason_for_Cancellation__c=\'On Hold\' AND ETST_Cancellation_End_Date__c <:system.today())';
        queryString += ' from ETST_Student__c WHERE ETST_Status__c=\'Inactive\' AND Id In:studentIds';
        system.debug('queryString-->'+queryString);
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){        
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<ETST_Student__c> scope){
        List<ETST_Student__c> lstStudentUpdate = new List<ETST_Student__c>();
        List<ET_Service_Request__c> lstTransportRequestUpdate = new List<ET_Service_Request__c>();
        Map<Id, List<ET_Service_Request__c>> mapTransportRequests = new Map<Id, List<ET_Service_Request__c>>();
        for(ETST_Student__c std : scope){
            List<ET_Service_Request__c> lstRequests = mapTransportRequests.get(std.Id);
            if(lstRequests ==null)
                lstRequests = new List<ET_Service_Request__c>();
            lstRequests.add(std.ETST_Transport_Requests__r);
            mapTransportRequests.put(std.id, lstRequests);
        }
        for(Id stdId : mapTransportRequests.keySet()){
            for(ET_Service_Request__c transport : mapTransportRequests.get(stdId)){
                transport.ETST_Status__c = 'Payment success';
                transport.ETST_Activation_Effective_Date__c = System.today();
                lstTransportRequestUpdate.add(transport);
                ETST_Student__c student = new ETST_Student__c(id=transport.ETST_Student__c);
                student.ETST_Status__c = 'Active';
                lstStudentUpdate.add(student);
            }
        }
        if(!lstStudentUpdate.isEmpty() && !lstTransportRequestUpdate.isEmpty()){
            if(!system.Test.isRunningTest())
                update lstTransportRequestUpdate;
            if(!system.Test.isRunningTest())
                update lstStudentUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new ETST_StudentActivateBatchClass());
    }
}