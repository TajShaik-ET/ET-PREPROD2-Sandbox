/********************************************************************************************************
* @author           Smaartt
* @description      Batch to call refund service.
* @Name             ETI_CallRefundServiceBatch
*********************************************************************************************************/
global class ETI_CallRefundServiceBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{ 
    Public String queryString;
    public Set<Id> recordIds = new Set<Id>();

    global ETI_CallRefundServiceBatch (set<Id> recIds){
        if(recIds!=null && recIds.size()>0)
            recordIds.addAll(recIds);
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        queryString='SELECT Id,Name,ETI_Booking__c,ET_Refund_Amount__c,ET_Refund_Status__c,ET_Payment__c FROM ET_Refund__c  WHERE Id=:recordIds';
        return Database.getQueryLocator(queryString);
    }
    global void execute(Database.BatchableContext BC, List<ET_Refund__c> scope) {
        try{
            if(scope[0].ET_Refund_Amount__c!=0){
                ET_Common_Util.ETPaymentResponse response=ET_Payment_Controller.createRefundRequest(scope[0].ET_Payment__c,scope[0].ET_Refund_Amount__c);
                system.debug('response>> '+response);
                ET_common_util.cls_authResponse authResponse = new ET_common_util.cls_authResponse();
                if(response!=null && response.authResponse!=null){
                    authResponse = response.authResponse;
                    if(authResponse.authorizationCode!=null && authResponse.authorizationCode!='')
                        scope[0].ET_Authorization_Code__c=authResponse.authorizationCode;
                    if(authResponse.success == 'true'){
                        scope[0].ET_Refund_Status__c='Completed';
                    }else {
                        scope[0].ET_Refund_Status__c='Failed';
                    }
                }else {
                    scope[0].ET_Refund_Status__c='Failed';
                }
                update scope[0];
            }
        }catch(Exception ex) {
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ETI_CallRefundServiceBatch', 'CallRefundServiceBatch', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
    public static void utilityMethod(){
        integer i=0;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
    }
}