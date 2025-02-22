public class ETIN_notifyUsersOnNewEmployeeCreation {
    
    public static void notifyInsuranceUsers(Map<Id,account> trgNewMap){
        
       //Deactiving this feature by business request-JANARDHAN
      /*  map<string,string> accIdvsZone = new map<string,string>();
        set<string> zonesSet = new set<string>();
        map<string,list<string>> zoneVsEmails = new map<string,list<string>>();
        
         for(account acc : trgNewMap.values()){
             if(acc.ETIN_Employee_Zone__c != null && acc.Type=='Employee'){
                 
               accIdvsZone.put(acc.Id,acc.ETIN_Employee_Zone__c);
               zonesSet.add(acc.ETIN_Employee_Zone__c);
             }
           
        }
        
         for(user u : [select id,name,email,ETSALES_Employee_Zone__c from user where ETSALES_Employee_Zone__c =:zonesSet AND isactive=True AND profile.Name=:System.Label.INS_ZoneCordProfileName]){
            
            if(!zoneVsEmails.containsKey(u.ETSALES_Employee_Zone__c)) {
                zoneVsEmails.put(u.ETSALES_Employee_Zone__c, new List<string>());
            }
            zoneVsEmails.get(u.ETSALES_Employee_Zone__c).add(u.email);
        }
        
       OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
      EmailTemplate template = [SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName ='ETIN_newEmpCreationNotification'];
        
        
          Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>(); 
             
        for(account acc : trgNewMap.values()){
            
            if(acc.ETIN_Employee_Zone__c != null && zoneVsEmails.containskey(acc.ETIN_Employee_Zone__c)){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(template.Id,null,acc.Id);
                
                email.toAddresses = zoneVsEmails.get(acc.ETIN_Employee_Zone__c);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                email.setSubject('New Health Insurance Request - '+acc.ETIN_Employee_Id__c);
                //email.setWhatId(acc.Id);
                //email.setTemplateId(template.Id);           
                email.setSaveAsActivity(false);
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                
                emailList.add(email);
            }
           
        }  
        
         //send an email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
   
        */
    }

}