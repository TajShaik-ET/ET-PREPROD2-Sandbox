global class ETIN_BulkHealthApprovalBatchCls implements Database.Batchable<sObject>,Database.Stateful{
    
   
    set<Id> accIdList = new  set<Id>();
    set<string> emailIds = new set<string>();
    set<Id> insertedRecordsId = new set<id>();
    private string accid;
    private string prcname;
        
     public ETIN_BulkHealthApprovalBatchCls(string PartnerId,string Prcs) {
        accid = PartnerId;
        prcname =Prcs;
       
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'select Id,Employee_Family__c,Plan__c,Insurance_Company_Email__c,Card_Number__c,RecordTypeId,Insurance_Policy_Number__c,Principal_Reference__c,Enrollment_Date__c,Insurance_Company__c,Insurance_Current_Status__c,Gross_Salary__c,EmployeeAcc__r.ETIN_Gross_Salary__c,Visa_Emirates__c,EmployeeAcc__c from ETIN_Insurance__c where Renew_Status__c= false AND Employee_Status__c=\'Active\' AND Insurance_Current_Status__c=\'Active\' AND RecordType.Name=\'Health Insurance\'';
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<ETIN_Insurance__c> scope) {
        
        list<ETIN_Insurance__c> newInsList = new list<ETIN_Insurance__c>();
        list<ETIN_Insurance__c> updateInsList = new list<ETIN_Insurance__c>();
       
        
        List<InsurancePlansMaster__c> masterPanelList = [select id,Name,Plans__c,Condition__c,Salary__c,Emirates__c from InsurancePlansMaster__c];
        
        for(ETIN_Insurance__c et : scope){
            
             string plan ='';
            
            for(InsurancePlansMaster__c plm : masterPanelList){
                
                if( plm.Emirates__c == et.Visa_Emirates__c && et.EmployeeAcc__r.ETIN_Gross_Salary__c <= plm.Salary__c  && plm.Condition__c == 'Less or Equal' ){
                    
                    plan =   plm.Plans__c;                    
                }
                if( plm.Emirates__c == et.Visa_Emirates__c && et.EmployeeAcc__r.ETIN_Gross_Salary__c > plm.Salary__c  && plm.Condition__c == 'More' ){
                    
                    plan =   plm.Plans__c;                    
                }
            }
            
            
            emailIds.add(et.Insurance_Company_Email__c);
            
            ETIN_Insurance__c etNew = new ETIN_Insurance__c();
            
            etNew.Previous_Insurance__c = et.Id;
            
            etNew.EmployeeAcc__c = et.EmployeeAcc__c;
            
            if(prcname =='new'){
                 etNew.Insurance_Company__c = accid;
            }else {
                 etNew.Insurance_Company__c = et.Insurance_Company__c;
            }
           
            etNew.Enrollment_Date__c = system.today();
            etNew.RecordTypeId = et.RecordTypeId;
            etNew.Plan__c = plan;
            etNew.Gross_Salary__c = et.Gross_Salary__c;
            etNew.Status__c = 'New';
            etNew.Member_Status__c ='Existing';
            //etNew.Member_Number__c = et.Insurance_Policy_Number__c;
            etNew.Principal_Reference__c = et.Principal_Reference__c;
            etNew.Old_Package_Name__c = et.Plan__c;
            etNew.Renew_Request__c = True;
            etNew.ETIN_Bulk_Process__c=True;
            etNew.Employee_Family__c = et.Employee_Family__c;
            //etNew.Card_Number__c = et.Card_Number__c;
            //etNew.Insurance_Policy_Number__c = et.Insurance_Policy_Number__c;
            
            newInsList.add(etNew);
            system.debug('------------'+etNew);
            
            
        /*    ETIN_Insurance__c etNew1 = new ETIN_Insurance__c();
            
            etNew1.Previous_Insurance__c = et.Id;
            
            etNew1.EmployeeAcc__c = et.EmployeeAcc__c;
            
            if(prcname =='new'){
                 etNew1.Insurance_Company__c = accid;
            }else {
                 etNew1.Insurance_Company__c = et.Insurance_Company__c;
            }
           
            etNew1.Enrollment_Date__c = system.today();
            etNew1.RecordTypeId = et.RecordTypeId;
            etNew1.Plan__c = plan;
            etNew1.Gross_Salary__c = et.Employee__r.ETIN_Gross_Salary__c;
            etNew1.Status__c = 'New';
            etNew1.Member_Status__c ='Existing';
            etNew1.Member_Number__c = et.Insurance_Policy_Number__c;
            etNew1.Principal_Reference__c = et.Principal_Reference__c;
            etNew1.Old_Package_Name__c = et.Plan__c;
            etNew1.Renew_Request__c = True;
            etNew1.ETIN_Bulk_Process__c=True;
            etNew1.Card_Number__c = et.Card_Number__c;
            etNew1.Insurance_Policy_Number__c = et.Insurance_Policy_Number__c;*/
        }
        try{  
            if(newInsList.size()>0) {
                Database.SaveResult[] srList = Database.insert(newInsList);
                
                for (Database.SaveResult sr : srList) {
                    
                    if (sr.isSuccess()) {
                
                       insertedRecordsId.add(sr.getId());
                       
                    }
                    
                }
                
            }
            
        }catch(Exception e){
            system.debug('Inseration Error:'+e);
        }
        
        //Querying recently created records to get prevoius insurance rec id 
        //
        for (ETIN_Insurance__c etRecent : [select Previous_Insurance__c from ETIN_Insurance__c where Id=:insertedRecordsId]){
            
            ETIN_Insurance__c et = new ETIN_Insurance__c();
            
            et.Id= etRecent.Previous_Insurance__c;
            et.Renew_Status__c = True;
            updateInsList.add(et);
            
        }
        
        try{
            if(updateInsList.size()>0) {
                Database.SaveResult[] srList = Database.update(updateInsList);
            }
        } catch(Exception e){
            
            system.debug('Updation Error:'+e);
        }
        
        
        /*   list<Approval.ProcessSubmitRequest> appReqList = new list<Approval.ProcessSubmitRequest>();
if(insertedRecIds.size()>0) {

for(Id ap : insertedRecIds){

Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
req.setComments('Bulk Renew Process');
req.setObjectId(ap);
appReqList.add(req);

}

}
Approval.ProcessResult[] approvalResult = Approval.process(appReqList);
*/
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
        
        List<String> listStrings = new List<String>();
        
      /*  for(user u : [SELECT Id, Email FROM User where Profile.name ='ETIN_InsuranceAdmin']){
            listStrings.add(u.Email);
        }*/
         for(user u : [SELECT Id, Email FROM User where Id=:UserInfo.getUserId()]){
            listStrings.add(u.Email);
         }
        Id emailTemplate = [select Id, Body  from EmailTemplate where DeveloperName = 'ETIN_BulkRenewPrcssEmailNotification'].Id;
        
        if(insertedRecordsId.size()>0 && listStrings.size()>0){
       
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        email.setToAddresses(listStrings);
        email.setSaveAsActivity(false);
        email.setTargetObjectId(UserInfo.getUserId());
        email.setTemplateId(emailTemplate);
        emailList.add(email);
        
        
        //send an email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        }
    }
    
}