public class CICO_IntimationTrgHandler {
    
    public static void processIntimation(list<CICO_Intimation__c> trgNew){
        map<string,string> intimationNoVsLocationcode = new map<string,string>();
        set<string> locationCodeSet = new set<string>();//to avoid multiple duplicate values in mapset
        map<string,list<string>> locationCodeVsEmails_OPER = new map<string,list<string>>();
        map<string,list<string>> locationCodeVsEmails_TECH = new map<string,list<string>>();
        
        for(CICO_Intimation__c inti : trgNew){
            intimationNoVsLocationcode.put(inti.Intimation_No__c,inti.Location_Code__c);
            locationCodeSet.add(inti.Location_Code__c);
        }
        
              
        for(user u : [select id,name,email,ETI_Inspection_Center__c,Grade__c  from user where ETI_Inspection_Center__c=:locationCodeSet AND IsActive=True]){
            
            if(u.Grade__c =='OPER'){
                if(!locationCodeVsEmails_OPER.containsKey(u.ETI_Inspection_Center__c)) {
                    locationCodeVsEmails_OPER.put(u.ETI_Inspection_Center__c, new List<string>());
                }
                locationCodeVsEmails_OPER.get(u.ETI_Inspection_Center__c).add(u.email);
            }
            if(u.Grade__c =='TECH'){
                if(!locationCodeVsEmails_TECH.containsKey(u.ETI_Inspection_Center__c)) {
                    locationCodeVsEmails_TECH.put(u.ETI_Inspection_Center__c, new List<string>());
                }
                locationCodeVsEmails_TECH.get(u.ETI_Inspection_Center__c).add(u.email);
            }
            
        }
        
         OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
         EmailTemplate template = [SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName ='CICO_NotifyUserOnNewIntimation'];
        
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>(); 
        
        for(CICO_Intimation__c inti : trgNew){
             list<string> toAddList = new list<string>();
            if(inti.Location_Code__c != null ){
               
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                if(inti.Inspected_By__c =='TECH'){
                     toAddList = locationCodeVsEmails_TECH.get(inti.Location_Code__c);
                }else if(inti.Inspected_By__c =='OPER'){
                    toAddList = locationCodeVsEmails_OPER.get(inti.Location_Code__c);
                }
                email.toAddresses = toAddList;
                            
                
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                // email.setSenderDisplayName('Emirates Transport');
                email.setSubject(template.Subject);
                //email.setHtmlBody(template.HTMLValue);
                email.setSaveAsActivity(false);
                email.setWhatId(inti.Id);
                email.setTemplateId(template.Id);
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                
                if(toAddList != null){
                     emailList.add(email);
                }
               
            }
            
        //send an email
        if(emailList.size()>0)
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
            
        }
        
       
    }

}