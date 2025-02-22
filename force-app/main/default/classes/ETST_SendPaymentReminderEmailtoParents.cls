global class ETST_SendPaymentReminderEmailtoParents implements Database.Batchable<sObject>{
       
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('----Start---');
        String query;
        List<ETST_System_Variables__mdt> ETST_System_Variables=[SELECT ETST_Renewal_Reminder_1__c FROM ETST_System_Variables__mdt 
                                                                where DeveloperName='ETST_System_Variables'];
        if(ETST_System_Variables!=null && ETST_System_Variables.size()>0) {
            //query = 'select Id,ETST_Student__r.ETST_Account_Name__r.PersonEmail,ETST_Student__r.ETST_Account_Name__r.PersonContactId from ET_Service_Request__c where ETST_Is_Active__c=true and ETST_Service_Duration_in_Days__c< '+ETST_System_Variables[0].ETST_Renewal_Reminder_1__c+' and ETST_Service_Duration_in_Days__c != null';
            query = 'select Id,ETST_Is_Monthly_Renewal_Opened__c,ETST_Is_Monthly_Renewal_Email_Sent__c,ETST_Student__r.ETST_Account_Name__r.PersonEmail,ETST_Student__r.ETST_Account_Name__r.PersonContactId from ET_Service_Request__c where ETST_Is_Active__c=true AND (ETST_Is_Renewal_Opened__c=true OR ETST_Is_Monthly_Renewal_Opened__c=true)';
        }         
        return Database.getQueryLocator(query);        
    }
    
    global void execute(Database.BatchableContext BC, List<ET_Service_Request__c> scope) {
        List<ET_Service_Request__c> lstServices = new List<ET_Service_Request__c>();
        EmailTemplate emailTemplate = [select Id, Body  from EmailTemplate where DeveloperName = 'ETST_Renewal_Reminder_Email'];
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName ='School Transport Sender Email'];        
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();        
        for(ET_Service_Request__c request : scope){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();            
            if(owea.size() > 0) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            email.setToAddresses(new String[] {request.ETST_Student__r.ETST_Account_Name__r.PersonEmail});
            email.setSaveAsActivity(true);
            email.setTargetObjectId(request.ETST_Student__r.ETST_Account_Name__r.PersonContactId);
            email.setTemplateId(emailTemplate.Id);           
            emailList.add(email);
            if(request.ETST_Is_Monthly_Renewal_Opened__c==true){
                request.ETST_Is_Monthly_Renewal_Email_Sent__c = true;
                lstServices.add(request);
            }           
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList); 
        if(!lstServices.isEmpty()) Update lstServices;
    }   
    
    global void finish(Database.BatchableContext BC) {
        System.debug('----finish---');
        /*OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName ='System User'];

AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where id=:BC.getJobId()];

if(a.Status == 'Failed') {

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

String[] toAddresses = new String[] {a.CreatedBy.Email};

mail.setToAddresses(toAddresses);
if (owea.size() > 0) {
mail.setOrgWideEmailAddressId(owea.get(0).Id);
}
mail.setSubject('Automatically closing Leads after 6 months - Status: '+ a.Status);
mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures. ExtendedStatus: ' + a.ExtendedStatus+'. Please check with System Administrator');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

}

}
*/
    }
    
   
}