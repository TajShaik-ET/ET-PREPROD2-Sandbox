/*
* File Name:ETVIN_Corr_Can_Req_Trg_Handler
* Author : Janardhan Muddana
* CreatedDate : 11/2/2020
* Modification Purpose
* * 1. Janardhan Muddana: Created for Send notifications
* * 2.
*/
public class ETVIN_Corr_Can_Req_Trg_Handler {
  
    public static void sendNotification(list<Correction_Cancel_Request__c> trgNew ,Map<Id, Correction_Cancel_Request__c> oldMap){
        
      EmailTemplate emailTemplate = [select Id, Body,HtmlValue  from EmailTemplate where DeveloperName = 'Vehicle_PoliceReport_Notification'];
      EmailTemplate emailTemplate1 = [select Id, Body,HtmlValue  from EmailTemplate where DeveloperName = 'Vehicle_ProveTheft_Notification'];
       set<id> accountIds = new set<id>();
       map<id,list<string>> accidVsConEmails = new map<id,list<string>>();
       list<ETIN_Claim__c> claimCreateList = new list<ETIN_Claim__c>();
        
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
        
        for(Correction_Cancel_Request__c crr : trgNew){
            
            accountIds.add(crr.Insurance_Company__c);
        }
        for(contact con : [select id,AccountId,email from contact where ETVIN_Insurance_Portal_User__c = true AND AccountId=:accountIds]){
            if(!accidVsConEmails.containsKey(con.AccountId)) {
                accidVsConEmails.put(con.AccountId,new list<string>{con.Email});          
            }else{
                
                accidVsConEmails.get(con.AccountId).add(con.Email); 
            }
           
        }
        
        //system.debug('--emails--'+accidVsConEmails);
        
        for(Correction_Cancel_Request__c crr : trgNew){
            
            if(crr.Police_Report__c == True && oldMap.get(crr.Id).Police_Report__c != crr.Police_Report__c){
                
              /*  String htmlBody = emailTemplate.HtmlValue; 
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(accidVsConEmails.get(crr.Insurance_Company__c));
                email.setSaveAsActivity(false);
                email.setSubject('Police Report');
                email.setTargetObjectId(UserInfo.getUserId());//
                email.setTemplateId(emailTemplate.Id);
                htmlBody = htmlBody.replace('{!Correction_Cancel_Request__c.Id}', crr.Id);
          
               email.setHtmlBody(htmlBody);
                
                emailList.add(email);*/
                
               //update journey status
               crr.Journey_Status__c = 'Police Report Attached';
               
              
            }
            
             if(crr.Prove_Theft_certificate__c == True && oldMap.get(crr.Id).Prove_Theft_certificate__c != crr.Prove_Theft_certificate__c){
               
                 String htmlBody = emailTemplate1.HtmlValue; 
                 Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                 email.setToAddresses(accidVsConEmails.get(crr.Insurance_Company__c));
                 email.setSaveAsActivity(false);
                 email.setSubject('Prove Theft Certificate');
                 email.setTargetObjectId(UserInfo.getUserId());//
                 email.setTemplateId(emailTemplate1.Id);
                 htmlBody = htmlBody.replace('{!Correction_Cancel_Request__c.Id}', crr.Id);
                 
                 email.setHtmlBody(htmlBody);
                 
                 emailList.add(email);
               //update journey status
               crr.Journey_Status__c = 'Prove Theft Report Attached';
               //Creating Claim 
               ETIN_Claim__c cl = new ETIN_Claim__c();
                 cl.Claim_for__c = crr.Reason_for_Cancellation__c;
                 cl.Claim_Amount__c = 100;
                 cl.ETIN_Insurance_Partner__c = crr.Insurance_Company__c;
                 cl.ETVIN_Vehicle_Insurance__c = crr.Vehicle_Insurance_Policy__c;
                 cl.Vehicle_Master__c = crr.Vehicle_Master__c;
                 cl.ETIN_Claim_Status__c = 'New';
                 cl.Accident_Date__c = crr.Vehicle_Theft_Date__c;
                 cl.Cancel_Request__c = crr.Id;
               
                 cl.RecordTypeId = SObjectType.ETIN_Claim__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Insurance').getRecordTypeId();
                 
                 claimCreateList.add(cl);
                 
                  crr.Journey_Status__c = 'Compensation/Claim Created';
                 
             }
            if(crr.Transfer_Profession_Certificate__c == True && oldMap.get(crr.Id).Transfer_Profession_Certificate__c != crr.Transfer_Profession_Certificate__c){
              
                 Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                 email.setToAddresses(accidVsConEmails.get(crr.Insurance_Company__c));
                 email.setSaveAsActivity(false);
                 email.setTargetObjectId(UserInfo.getUserId());//
                String htmlBody = '<p>Hi Team,</p>';
                htmlBody+=   '<p>Transfer profession certificate added to the cancellation request, please click on below link to access the request.</p>' ;
                htmlBody+=   System.label.ETVIN_partnerPortalUrl+'?recordId='+ crr.id +'&tab=Cancellation';
                
                htmlBody+=   '<p>Thank you and best regards,</p>';
                htmlBody+=   '<p>Insurance Team</p>';
                email.setSubject('Transfer Profession Certificate');
                  
                 
                 email.setHtmlBody(htmlBody);
                 
                 emailList.add(email);
            
             }
             if(crr.Insurance_Cancellation_Letter__c == True && oldMap.get(crr.Id).Insurance_Cancellation_Letter__c != crr.Insurance_Cancellation_Letter__c){
              
                 Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                 email.setToAddresses(accidVsConEmails.get(crr.Insurance_Company__c));
                 email.setSaveAsActivity(false);
                 email.setTargetObjectId(UserInfo.getUserId());//
                String htmlBody = '<p>Hi Team,</p>';
                htmlBody+=   '<p>Insurance cancellation letter added to the cancellation request, please click on below link to access the request.</p>' ;
                htmlBody+=   System.label.ETVIN_partnerPortalUrl+'?recordId='+ crr.id +'&tab=Cancellation';
                
                htmlBody+=   '<p>Thank you and best regards,</p>';
                htmlBody+=   '<p>Insurance Team</p>';
                email.setSubject('Insurance Cancellation Letter');
                  
                 
                 email.setHtmlBody(htmlBody);
                 
                 emailList.add(email);
            
             }
        }  
       
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList); 
        
        if(claimCreateList.size()>0)
        Database.SaveResult[] insertResults = Database.insert(claimCreateList,false);
        
    }
    
    public static void sendNotificationToPRO(list<Correction_Cancel_Request__c> trgNew){
        
      string ProEmail = [select id,Email__c  from VehicleInsEmailNotification__c where Label__c='PRO'].Email__c; 
        
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
        Id recordTypeId =  Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Theft_Request').getRecordTypeId();
        
        if(ProEmail != null )
        for(Correction_Cancel_Request__c cr : trgNew){
            
            if(recordTypeId == cr.RecordTypeId){
             Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                 email.setToAddresses(new String[] {ProEmail});
                 email.setSaveAsActivity(false);
                 email.setTargetObjectId(UserInfo.getUserId());
                String htmlBody = '<p>Dear Pro,</p>';
                htmlBody+=   '<p>Please find the below thefted vehicle details.</p>' ;
                htmlBody+= '<p> VIN Number -'+cr.Vehicle_Interanal_Number__c+'</p>';
                htmlBody+= '<p> Plate Number -'+cr.Plate_Number__c+'</p>';
               
                htmlBody+=   '<p>Thank you and best regards,</p>';
                htmlBody+=   '<p>Insurance Team</p>';
                email.setSubject('New Vehicle Theft Request');
                email.setHtmlBody(htmlBody);
            
                emailList.add(email);
            //update journey status
            cr.Journey_Status__c = 'PRO Notified';
            }
        }
          Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);    
      
    }
    
}