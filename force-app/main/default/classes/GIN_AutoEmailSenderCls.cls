/* Name:GIN_AutoEmailSenderCls
 * Developer: Janardhan
 * Date:27/09/21
 * Description: This cls is created to send email on configurable date and email id
 * */
global class GIN_AutoEmailSenderCls implements schedulable{
    
    global void execute(schedulableContext ctx){
        
        list<InsuranceAutoTriggerEmails__c> insList = [select Id,Email_ID__c,Trigger_Date__c,Email_Template_Name__c from InsuranceAutoTriggerEmails__c where Active__c = true];
        List<Messaging.SingleEmailMessage> mailsList =  new List<Messaging.SingleEmailMessage>();
        set<string> emailtempNames = new set<string>();
        map<string,string> nameVsId = new map<string,string>();
        
        for(InsuranceAutoTriggerEmails__c insTemp : insList){
            emailtempNames.add(insTemp.Email_Template_Name__c);
        }
        
        for(EmailTemplate em :[SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName =:emailtempNames]){
            nameVsId.put(em.DeveloperName,em.Id);
        }
        
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
    
        for(InsuranceAutoTriggerEmails__c ins : insList){
            if(ins.Email_ID__c != null && ins.Trigger_Date__c !=null && ins.Email_Template_Name__c !=null ){
                
                date todayDate = date.today();
                
                if(todayDate.month() == ins.Trigger_Date__c.month() && todayDate.day()== ins.Trigger_Date__c.day()){
                    list<string> toList = ins.Email_ID__c.split(',');
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    mail.toAddresses = toList;
                    if ( owea != null && owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.setTemplateId(nameVsId.get(ins.Email_Template_Name__c)); 
                    mail.setSaveAsActivity(false);
                    mail.setTargetObjectId(userinfo.getUserId());
                    mail.setTreatTargetObjectAsRecipient(false);
                    
                    mailsList.add(mail);
                    
                }
            }            
            
            
        }
        
        try{
            //send an email
            Messaging.SendEmailResult[] results = Messaging.sendEmail(mailsList);
        }catch(System.EmailException ex){
            system.debug('---Err--'+ex.getMessage());
        }  
          
    }

}