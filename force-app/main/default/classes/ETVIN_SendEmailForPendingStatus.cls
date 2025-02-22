public class ETVIN_SendEmailForPendingStatus {
    // vehiclepolicytab  Cancellation  Correction  Claimpolicy  
      public static void sendEmailForpolciyPending(Map<Id,ETVIN_Vehicle_Insurance__c > OldMap,Map<Id,ETVIN_Vehicle_Insurance__c > NewMap){
       
        
        List<Messaging.SingleEmailMessage> mails =
            new List<Messaging.SingleEmailMessage>();
                    
           OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
          
          Map<String, List<String>> contactEmailMap = new Map<String, List<String>>();
          map<id, id> accountIds = new Map<id, id>();
          for(id veh : newMap.keyset()){
              ETVIN_Vehicle_Insurance__c  myContact = newMap.get(veh);
            
             
              if(myContact.ETVIN_Request_Status__c == 'Insurance Pending' )
              {
                 
                  if( myContact.ETVIN_Request_Status__c != OldMap.get(veh).ETVIN_Request_Status__c){
                      
                     accountIds.put(newMap.get(veh).ETVIN_Insurance_Company__c, veh);
                  }
              }
          }
           
          for(Contact con : [SELECT email, AccountId FROM Contact where ETVIN_Insurance_Portal_User__c = true AND accountid IN :accountIds.keySet()]){
              if(contactEmailMap.containsKey(con.AccountId)){
                  List<String> emaillist =  contactEmailMap.get(con.AccountId);
                  emaillist.add(con.Email);
                   contactEmailMap.put(con.AccountId, emaillist);
              }else{
                  contactEmailMap.put(con.AccountId, new List<String>{con.Email});  
              }
              
          }
          System.debug('----'+contactEmailMap);
          
        for(ETVIN_Vehicle_Insurance__c clm : [SELECT id, ETVIN_Insurance_Company__c, ETVIN_Request_Status__c, ETVIN_Insurance_Company__r.Name  FROM ETVIN_Vehicle_Insurance__c WHERE id IN : NewMap.keyset()]){
            ETVIN_Vehicle_Insurance__c  myContact = clm;
            System.debug(myContact);
            //&& myContact.RecordTypeId !=NULL && Schema.SObjectType.ETVIN_Vehicle_Insurance__c.getRecordTypeInfosById().get(myContact.RecordTypeId)!=NULL && Schema.SObjectType.ETVIN_Vehicle_Insurance__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL
            if(myContact.ETVIN_Request_Status__c == 'Insurance Pending' )
            {
               // string ContactRecordType = Schema.SObjectType.ETVIN_Vehicle_Insurance__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
                //System.debug('ClaimrecordType  ' + ContactRecordType);
                //ContactRecordType == 'Vehicle Insurance' &&
                if( myContact.ETVIN_Request_Status__c != OldMap.get(clm.id).ETVIN_Request_Status__c){
                    
                     list<String> sendTo = new  list<String>();
                   
                    if(contactEmailMap.containskey(clm.ETVIN_Insurance_Company__c)){
                        sendTo.addAll(contactEmailMap.get(clm.ETVIN_Insurance_Company__c) ); 
                    }    
                      Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    if(sendTo.size() > 0){
                     
                    
                    mail.setToAddresses(sendTo);
                    
                    list<String> ccTo = new  list<String>();
                   
                    mail.setCcAddresses(ccTo); 
                    
                    mail.setUseSignature(false);
                    if(owea != null && owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String htmlBody = '<p>Hi ' + clm.ETVIN_Insurance_Company__r.Name + ',</p>';
                    htmlBody+=   '<p>You have received a  request, please verify from ' + System.label.ETVIN_partnerPortalUrl+'?recordId=' + myContact.id + '&tab=Vehiclepolicy';
                    
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>Vehicle insurance Team</p>';
                    mail.setSubject('New Vehicle Insurance Policy');
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);  
                        
                    }
                    
                   
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        
                if(!test.isRunningTest())
                    {
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        system.debug(results);
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                            
                            
                        }  else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                            
                        }
                    }
                }
                //}
                
            }
        }
    }
    
    public static void sendEmailForpolciyAccept(Map<Id,ETVIN_Vehicle_Insurance__c > OldMap,Map<Id,ETVIN_Vehicle_Insurance__c > NewMap){
        
        
        List<Messaging.SingleEmailMessage> mails =
            new List<Messaging.SingleEmailMessage>();
       OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
          
        for(ETVIN_Vehicle_Insurance__c clm : [SELECT id, ETVIN_Request_Status__c  FROM ETVIN_Vehicle_Insurance__c WHERE id IN : NewMap.keyset()]){
            ETVIN_Vehicle_Insurance__c  myContact = clm;
            System.debug(myContact);
            //&& myContact.RecordTypeId !=NULL && Schema.SObjectType.ETVIN_Vehicle_Insurance__c.getRecordTypeInfosById().get(myContact.RecordTypeId)!=NULL && Schema.SObjectType.ETVIN_Vehicle_Insurance__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL
            if(myContact.ETVIN_Request_Status__c == 'Insurance Approved' )
            {
               // string ContactRecordType = Schema.SObjectType.ETVIN_Vehicle_Insurance__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
               // System.debug('ClaimrecordType  ' + ContactRecordType);
                //ContactRecordType == 'Vehicle Insurance' && 
                if(myContact.ETVIN_Request_Status__c != OldMap.get(clm.id).ETVIN_Request_Status__c){
                    
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    
                    list<String> sendTo = new  list<String>();
                    //sendTo.add('pritamraj.rits@gmail.com');
                    
                    sendTo.add(Userinfo.getUserEmail());
                    mail.setToAddresses(sendTo);
                    
                    list<String> ccTo = new  list<String>();
                    System.debug('CCAddress Is--- :: ' + ccTo);
                    mail.setCcAddresses(ccTo); 
                    
                    mail.setUseSignature(false);
                   if(owea != null && owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String htmlBody = '<p>Hi Team,</p>'; //+ Userinfo.getUserName()+ '
                    htmlBody+=   '<p>Your request has been approved, please click on below link to access the request. </p>';
                    htmlBody+=   System.label.ETVIN_OrgInstanceURL+ '/'+myContact.Id;
                    
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>Insurance Partner</p>';
                    mail.setSubject('Vehicle Policy Request - Accepted');
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        
                        if(!test.isRunningTest())
                    {
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        system.debug(results);
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                            
                            
                        }  else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                            
                        }
                    }
                }
                //}
                
            }
        }
        
    }
    public static void sendEmailForpolciyReject(Map<Id,ETVIN_Vehicle_Insurance__c > OldMap,Map<Id,ETVIN_Vehicle_Insurance__c > NewMap){
        
        
        List<Messaging.SingleEmailMessage> mails =
            new List<Messaging.SingleEmailMessage>();
       OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
        
        for(ETVIN_Vehicle_Insurance__c clm : [SELECT id, ETVIN_Request_Status__c  FROM ETVIN_Vehicle_Insurance__c WHERE id IN : NewMap.keyset()]){
            ETVIN_Vehicle_Insurance__c  myContact = clm;
            System.debug(myContact);
            // && myContact.RecordTypeId !=NULL && Schema.SObjectType.ETVIN_Vehicle_Insurance__c.getRecordTypeInfosById().get(myContact.RecordTypeId)!=NULL && Schema.SObjectType.ETVIN_Vehicle_Insurance__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL
            if(myContact.ETVIN_Request_Status__c == 'Insurance Rejected')
            {
               // string ContactRecordType = Schema.SObjectType.ETVIN_Vehicle_Insurance__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
               // System.debug('ClaimrecordType  ' + ContactRecordType);
                //ContactRecordType == 'Vehicle Insurance' && 
                if(myContact.ETVIN_Request_Status__c != OldMap.get(clm.id).ETVIN_Request_Status__c){
                    
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    
                    list<String> sendTo = new  list<String>();
                    //sendTo.add('pritamraj.rits@gmail.com');
                    
                     sendTo.add(Userinfo.getUserEmail() );
                    mail.setToAddresses(sendTo);
                    
                    list<String> ccTo = new  list<String>();
                    System.debug('CCAddress Is--- :: ' + ccTo);
                    mail.setCcAddresses(ccTo); 
                    
                    mail.setUseSignature(false);
                   if(owea != null && owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String htmlBody = '<p>Hi Team,</p>';//+ Userinfo.getUserName()+ 
                    htmlBody+=   '<p>Your request has been rejected, please click on below link to access request</p>';
                    htmlBody+= System.label.ETVIN_OrgInstanceURL+ '/'+myContact.Id; 
                    
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>Insurance Partner</p>';
                    mail.setSubject('Vehicle Policy Request - Rejected');
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        
                        if(!test.isRunningTest())
                    {
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        system.debug(results);
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                            
                            
                        }  else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                            
                        }
                    }
                }
                //}
                
            }
        }
    }
    
    
    /// Claims mail
    public static void sendEmailForClaimsPending(Map<Id,ETIN_Claim__c > OldMap,Map<Id,ETIN_Claim__c > NewMap){
        
        
        List<Messaging.SingleEmailMessage> mails =
            new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
        
        Map<String, List<String>> contactEmailMap = new Map<String, List<String>>();
        map<id, id> accountIds = new Map<id, id>();
        for(id veh : newMap.keyset()){
            ETIN_Claim__c  myContact = newMap.get(veh);
            System.debug(myContact);
            if(myContact.ETIN_Claim_Status__c == 'Pending' && myContact.RecordTypeId !=NULL && Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId)!=NULL && Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL)
            {
                string ContactRecordType = Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
                System.debug('ClaimrecordType  ' + ContactRecordType);
                if(ContactRecordType == 'Vehicle Insurance' && myContact.ETIN_Claim_Status__c != OldMap.get(veh).ETIN_Claim_Status__c){
                    
                    accountIds.put(newMap.get(veh).ETIN_Insurance_Partner__c, veh);
                }
            }
        }
        for(Contact con : [SELECT email, AccountId FROM Contact where ETVIN_Insurance_Portal_User__c = true AND accountid IN :accountIds.keySet()]){
            if(contactEmailMap.containsKey(con.AccountId)){
                List<String> emaillist =  contactEmailMap.get(con.AccountId);
                emaillist.add(con.Email);
                contactEmailMap.put(con.AccountId, emaillist);
            }else{
                contactEmailMap.put(con.AccountId, new List<String>{con.Email});  
            }
            
        }
        
        
        for(ETIN_Claim__c clm : [SELECT id, ETIN_Insurance_Partner__c,ETIN_Insurance_Partner__r.Name, ETIN_Claim_Status__c, Owner.Email, Owner.Name, RecordTypeId  FROM ETIN_Claim__c WHERE id IN : NewMap.keyset()]){
            ETIN_Claim__c  myContact = clm;
            System.debug(myContact);
            if(myContact.ETIN_Claim_Status__c == 'Pending' && myContact.RecordTypeId !=NULL && Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId)!=NULL && Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL)
            {
                string ContactRecordType = Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
                System.debug('ClaimrecordType  ' + ContactRecordType);
                System.debug('myContact.ETIN_Claim_Status__c  ' + myContact.ETIN_Claim_Status__c);
                System.debug('OldMap.get(clm.id).ETIN_Claim_Status__c ' + OldMap.get(clm.id).ETIN_Claim_Status__c);
                if(ContactRecordType == 'Vehicle Insurance' && myContact.ETIN_Claim_Status__c != OldMap.get(clm.id).ETIN_Claim_Status__c){
                    
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    
                    list<String> sendTo = new  list<String>();
                    if(contactEmailMap.containskey(myContact.ETIN_Insurance_Partner__c)){
                        sendTo.addAll(contactEmailMap.get(myContact.ETIN_Insurance_Partner__c) );
                    }
                    
                    mail.setToAddresses(sendTo);
                    
                    list<String> ccTo = new  list<String>();
                    System.debug('CCAddress Is--- :: ' + ccTo);
                    mail.setCcAddresses(ccTo); 
                    
                    mail.setUseSignature(false);
                    if(owea != null && owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String htmlBody = '<p>Hi ' + myContact.ETIN_Insurance_Partner__r.Name + ',</p>';
                    htmlBody+=   '<p>You have received a  request, please verify from ' + System.label.ETVIN_partnerPortalUrl+'?recordId=' + myContact.id + '&tab=Claimpolicy';
                    
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>Vehicle insurance Team</p>';
                    mail.setSubject('New Vehicle Claim Request');
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        
                        if(!test.isRunningTest())
                    {
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        system.debug(results);
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                            
                            
                        }  else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                            
                        }
                    }
                }
                //}
                
            }
        }
    }
    
    public static void sendEmailForClaimsAccept(Map<Id,ETIN_Claim__c > OldMap,Map<Id,ETIN_Claim__c > NewMap){
        
        
        List<Messaging.SingleEmailMessage> mails =
            new List<Messaging.SingleEmailMessage>();
       OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
        
        for(ETIN_Claim__c clm : [SELECT id, ETIN_Claim_Status__c, Owner.Email, Owner.Name, RecordTypeId   FROM ETIN_Claim__c WHERE id IN : NewMap.keyset()]){
            ETIN_Claim__c  myContact = clm;
            System.debug(myContact);
            if(myContact.ETIN_Claim_Status__c == 'Approved' && myContact.RecordTypeId !=NULL && Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId)!=NULL && Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL)
            {
                string ContactRecordType = Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
                System.debug('ClaimrecordType  ' + ContactRecordType);
                if(ContactRecordType == 'Vehicle Insurance' && myContact.ETIN_Claim_Status__c != OldMap.get(clm.id).ETIN_Claim_Status__c){
                    
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    
                    list<String> sendTo = new  list<String>();
                  //  sendTo.add('pritamraj.rits@gmail.com');
                    sendTo.add(myContact.Owner.Email );
                    mail.setToAddresses(sendTo);
                    
                    list<String> ccTo = new  list<String>();
                    System.debug('CCAddress Is--- :: ' + ccTo);
                    mail.setCcAddresses(ccTo); 
                    
                    mail.setUseSignature(false);
                    if(owea != null && owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String htmlBody = '<p>Hi Team,</p>'; //+ myContact.Owner.Name+ '
                    htmlBody+=   '<p>Your request has been approved, please click on below link to access request.</p>';
                    htmlBody+= System.label.ETVIN_OrgInstanceURL+ '/'+myContact.Id;
                    
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>Insurance Partner</p>';
                    mail.setSubject('Vehicle Claim Request - Accepted');
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        
                        if(!test.isRunningTest())
                    {
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        system.debug(results);
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                            
                            
                        }  else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                            
                        }
                    }
                }
                //}
                
            }
        }
    }
    public static void sendEmailForClaimsReject(Map<Id,ETIN_Claim__c > OldMap,Map<Id,ETIN_Claim__c > NewMap){
        
        
        List<Messaging.SingleEmailMessage> mails =
            new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];

        for(ETIN_Claim__c clm : [SELECT id, ETIN_Claim_Status__c, Owner.Email, Owner.Name, RecordTypeId  FROM ETIN_Claim__c WHERE id IN : NewMap.keyset()]){
            ETIN_Claim__c  myContact = clm;
            System.debug(myContact);
            if(myContact.ETIN_Claim_Status__c == 'Rejected' && myContact.RecordTypeId !=NULL && Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId)!=NULL && Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL)
            {
                string ContactRecordType = Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
                System.debug('ClaimrecordType  ' + ContactRecordType);
                if(ContactRecordType == 'Vehicle Insurance' && myContact.ETIN_Claim_Status__c != OldMap.get(clm.id).ETIN_Claim_Status__c){
                    
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    
                    list<String> sendTo = new  list<String>();
                    //sendTo.add('pritamraj.rits@gmail.com');
                     sendTo.add(myContact.Owner.Email );
                    mail.setToAddresses(sendTo);
                    
                    list<String> ccTo = new  list<String>();
                    System.debug('CCAddress Is--- :: ' + ccTo);
                    mail.setCcAddresses(ccTo); 
                    
                    mail.setUseSignature(false);
                   if(owea != null && owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String htmlBody = '<p>Hi ' + myContact.Owner.Name+ ',</p>';
                    htmlBody+=   '<p>Your request has been rejected, please click on below link to access request </p> ';// + 'https://etdev-oneet.cs127.force.com/partnerportal';
                    htmlBody+= System.label.ETVIN_OrgInstanceURL+ '/'+myContact.Id;
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>Insurance Partner</p>';
                    mail.setSubject('Vehicle Calim Request - Rejected ');
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        
                        if(!test.isRunningTest())
                    {
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        system.debug(results);
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                            
                            
                        }  else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                            
                        }
                    }
                }
                //}
                
            }
        }
    }
    
    
     /// Claims mail
    public static void sendEmailForClaimsScrabbedTheft(Map<Id,ETIN_Claim__c > newMap){
        String profileName = 'ETVIN_FixedAssestDept' ;
         // List<profile> proList = [SELECT id FROM Profile WHERE name = :profileName];
         /* if(proList.size() > 0){
                for(User   u : [SELECT email FROM USER WHERE ProfileId = :proList[0].id]){
                    toaddress.add(u.email);
                }
            }*/
        
        if(profileName != null && profileName != ''){
            String body = '<p>&nbsp;Hi Team,</p>';
            body += '<p>Please find below all the Claim with &apos;Scrapped Vehicle Theft&apos;</p>';
            body += '<table><tr><th>Claim Name</th></tr>';
            String baseUrl = System.label.ETVIN_OrgInstanceURL;
            System.debug(baseUrl);
            boolean isrecordAvilable = false;
            for(id key : newMap.keyset()){
                ETIN_Claim__c clm  = newMap.get(key);
                if(clm.Claim_for__c == 'Scrapped Vehicle Theft'){
                    body += '<tr><td><a href="' + baseUrl + '/' +clm.id + '">' + clm.Name+ '</a></td> </tr>';
                    isrecordAvilable = true;
                }
            }
            body 	+= '</table>';
            body	+=   '<br/><p>Thank you and best regards,</p>';
            body	+=   '<p>Insurance Partner</p>';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            //'lahari.m@smaartt.com'
            string [] toaddress= New string[]{'lahari.m@smaartt.com'};
             
            email.setSubject('Claims with Scrapped Vehicle Theft');
            email.setHtmlBody(body);
            email.setToAddresses(toaddress);
            if(body != '' && toaddress.Size() > 0 && isrecordAvilable ){//&& proList.size() > 0
                Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email}); 
            }
            
        }
    }
    
    // Vehicle Request email notification to insurance partner when status is pending
    // Modified By Janardhan
    public static void sendEmailForCorrectionPending(Map<Id,Correction_Cancel_Request__c > OldMap,Map<Id,Correction_Cancel_Request__c > NewMap){
         
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];

          Map<String, List<String>> contactEmailMap = new Map<String, List<String>>();
          map<id, id> accountIds = new Map<id, id>();
        
          for(id veh : newMap.keyset()){
              Correction_Cancel_Request__c  myContact = newMap.get(veh);
              
              if(myContact.Request_Status__c == 'Insurance Pending' && myContact.RecordTypeId !=NULL && Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL)
              {
                  string ContactRecordType = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
                
                  if( myContact.Request_Status__c != OldMap.get(veh).Request_Status__c){
                      
                      accountIds.put(newMap.get(veh).Insurance_Company__c, veh);
                  }
              }
          }
         
          for(Contact con : [SELECT email, AccountId FROM Contact where ETVIN_Insurance_Portal_User__c = true AND accountid IN :accountIds.keySet()]){
               
              if(contactEmailMap.containsKey(con.AccountId)){
                  
                  List<String> emaillist =  contactEmailMap.get(con.AccountId);
                  emaillist.add(con.Email);
                  contactEmailMap.put(con.AccountId, emaillist);
              }else{
                  
                  contactEmailMap.put(con.AccountId, new List<String>{con.Email});  
              }
              
          }
           
        for(Correction_Cancel_Request__c clm : NewMap.values()){
            Correction_Cancel_Request__c  myContact = clm;

            if(myContact.Request_Status__c == 'Insurance Pending' && myContact.RecordTypeId !=NULL && Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL)
            {
                string ContactRecordType = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
                
                
                if( myContact.Request_Status__c != OldMap.get(clm.id).Request_Status__c){
                    
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    
                    list<String> sendTo = new  list<String>();
                                   
                    sendTo.addAll(contactEmailMap.get(myContact.Insurance_Company__c) );
                    mail.setToAddresses(sendTo);
                    
                   if(owea != null && owea.size() > 0){
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    
                    String htmlBody = '<p>Dear Insurance Partner,</p>';
                    string subjectVal = 'New Request';
                    if(ContactRecordType == 'Correction Request' ){
                       htmlBody+=   '<p>You have received a  request, please verify from ' + System.label.ETVIN_partnerPortalUrl+'?recordId=' + myContact.id + '&tab=Correction';
                       subjectVal = 'New Correction Request';
                    }else if(ContactRecordType != 'Available for Mulkiya'){
                          htmlBody+=   '<p>You have received a  request, please verify from ' +System.label.ETVIN_partnerPortalUrl +'?recordId=' + myContact.id + '&tab=Cancellation';
                          subjectVal = 'New Cancellation Request';
                    }                   
                   
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>Vehicle insurance Team</p>';
                    mail.setSubject(subjectVal);
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
                    
                    if(ContactRecordType != 'Available for Mulkiya'){
                        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                            
                            if(!test.isRunningTest())
                        {
                            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                            system.debug(results);
                            if (results[0].success) {
                                System.debug('The email was sent successfully.');
                                
                                
                            }  else {
                                System.debug('The email failed to send: ' + results[0].errors[0].message);
                                
                            }
                        }
                    }
                }
                
                
            }
        }
    }
    
    public static void sendEmailForCorrectionAccept(Map<Id,Correction_Cancel_Request__c > OldMap,Map<Id,Correction_Cancel_Request__c > NewMap){
         
        
        List<Messaging.SingleEmailMessage> mails =
            new List<Messaging.SingleEmailMessage>();
       
      OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
 
        for(Correction_Cancel_Request__c clm : [SELECT id, Request_Status__c, Owner.Email, Owner.Name, RecordTypeId  FROM Correction_Cancel_Request__c WHERE id IN : NewMap.keyset()]){
            Correction_Cancel_Request__c  myContact = clm;
          
            if(myContact.Request_Status__c == 'Insurance Approved' && myContact.RecordTypeId !=NULL && Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId)!=NULL && Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL)
            {
                string ContactRecordType = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
               
                if( myContact.Request_Status__c != OldMap.get(clm.id).Request_Status__c){
                    
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    
                    list<String> sendTo = new  list<String>();
                  
                    sendTo.add(myContact.Owner.Email );
                    mail.setToAddresses(sendTo);
                    if(owea != null && owea.size() > 0){
                       // mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String htmlBody = '<p>Hi Team,</p>';
                    htmlBody+=   '<p>Your request has been approved, please click on below link to access the request</p> ';//+ 'https://etdev-oneet.cs127.force.com/partnerportal';
                    htmlBody+= System.label.ETVIN_OrgInstanceURL+ '/'+myContact.Id;
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>Insurance Partner</p>';
                    if(ContactRecordType == 'Correction Request' ){
                        mail.setSubject('Vehicle Correction Request - Approved');
                    }else if(ContactRecordType == 'Available for Mulkiya'){
                        mail.setSubject('Vehicle available Online Request - Approved');
                    }else{
                        mail.setSubject('Vehicle Cancellation Request - Approved');
                    }
                   
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        
                        if(!test.isRunningTest())
                    {
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        system.debug(results);
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                            
                            
                        }  else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                            
                        }
                    }
                }
                //}
                
            }
        }
    }
    public static void sendEmailForCorrectionReject(Map<Id,Correction_Cancel_Request__c > OldMap,Map<Id,Correction_Cancel_Request__c > NewMap){
        
        
        List<Messaging.SingleEmailMessage> mails =
            new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea;
        
        if(!test.isRunningTest())
        owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];

       
        for(Correction_Cancel_Request__c clm : [SELECT id, Request_Status__c, Owner.Email, Owner.Name, RecordTypeId  FROM Correction_Cancel_Request__c WHERE id IN : NewMap.keyset()]){
            Correction_Cancel_Request__c  myContact = clm;
            System.debug(myContact);
            if(myContact.Request_Status__c == 'Insurance Rejected' && myContact.RecordTypeId !=NULL && Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId)!=NULL && Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname()!=NULL)
            {
                string ContactRecordType = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(myContact.RecordTypeId).getname();
               
                
                if( myContact.Request_Status__c != OldMap.get(clm.id).Request_Status__c){
                    
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    
                    list<String> sendTo = new  list<String>();
                   
                    sendTo.add(myContact.Owner.Email );
                    mail.setToAddresses(sendTo);
                    
                    if(!test.isRunningTest()){
                        if(owea != null && owea.size() > 0){
                            //mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        
                    }
                    String htmlBody = '<p>Hi Team,</p>';
                    htmlBody+=   '<p>Your request has been rejected, please click on below link to access the request.</p>' ;
                    htmlBody+= System.label.ETVIN_OrgInstanceURL+ '/'+myContact.Id;
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>Insurance Partner</p>';
                    if(ContactRecordType == 'Correction Request' ){
                        mail.setSubject('Vehicle Correction Request - Accepted');
                    }else if(ContactRecordType == 'Available for Mulkiya'){
                        mail.setSubject('Vehicle available Online Request - Accepted');
                    }else{
                        mail.setSubject('Vehicle Cancellation Request - Accepted');
                    }
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        
                        if(!test.isRunningTest())
                    {
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                        system.debug(results);
                        if (results[0].success) {
                            System.debug('The email was sent successfully.');
                            
                            
                        }  else {
                            System.debug('The email failed to send: ' + results[0].errors[0].message);
                            
                        }
                    }
                }
                //}
                
            }
        }
    }
    
    public static void createClaimsForScrappedVehicleTheft(List<Correction_Cancel_Request__c> correctCanList){
        id claimsrecordTypeId = Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosByName().get('Vehicle Insurance').getRecordTypeId();
        //System.debug(ContactRecordType);
        List<ETIN_Claim__c> clmList = new List<ETIN_Claim__c>();
        for(Correction_Cancel_Request__c canCor : correctCanList){
            if(canCor.Reason_for_Cancellation__c == 'Scrapped Vehicle Theft'){
                ETIN_Claim__c clm = new ETIN_Claim__c();
                clm.Claim_Amount__c = 100;
                clm.Claim_for__c = 'Scrapped Vehicle Theft';
                clm.ETIN_Claim_Status__c = 'New';
                clm.ETIN_Insurance_Partner__c = canCor.Insurance_Company__c;
                clm.Vehicle_Master__c = canCor.Vehicle_Master__c;
                clm.RecordTypeId = claimsrecordTypeId;
                clm.ETVIN_Vehicle_Insurance__c = canCor.Vehicle_Insurance_Policy__c;
                clmList.add(clm);
                
            }  
        }
        if(clmList.size() > 0){
           /// System.debug('###1');
            insert clmList;
          //  System.debug('###2' + clmList);
            Integer i = 0;
            for(Correction_Cancel_Request__c canCor : correctCanList){
               // System.debug('###3');
                if(canCor.Reason_for_Cancellation__c == 'Scrapped Vehicle Theft'){
                    //System.debug('@@###################   ' + clmList[i].id);
                    canCor.Claim__c = clmList[i].id;
                    i++;
                }
            }
            //update correctCanList;
        }  
       
    }
    
    public static void sendEmailForDebit(Map<id, ETIN_Insurance_Transactions__c> newMap){
        
       // List<ETIN_Insurance_Transactions__c> transList = [SELECT Owner.Email FROM ETIN_Insurance_Transactions__c WHERE id = :transca.id];
       /*
        Map<String, List<String>> contactEmailMap = new Map<String, List<String>>();
        map<id, id> accountIds = new Map<id, id>();
        for(id veh : newMap.keyset()){
            ETIN_Insurance_Transactions__c  myContact = newMap.get(veh);
            System.debug(myContact);
            if(myContact.ETIN_AP_Type__c == 'Debit Note' L)
            {
                //ContactRecordType == 'Correction Request' &&
                if( myContact.ETIN_AP_Type__c != OldMap.get(veh).ETIN_AP_Type__c){
                    
                    accountIds.put(newMap.get(veh).Insurance_Company__c, veh);
                }
            }
        }
        
        for(Contact con : [SELECT email, AccountId FROM Contact where accountid IN :accountIds.keySet()]){
            System.debug('###0');
            if(contactEmailMap.containsKey(con.AccountId)){
                System.debug('###1');
                List<String> emaillist =  contactEmailMap.get(con.AccountId);
                emaillist.add(con.Email);
                contactEmailMap.put(con.AccountId, emaillist);
            }else{
                System.debug('###2');
                contactEmailMap.put(con.AccountId, new List<String>{con.Email});  
            }
            
        }
       
        list<String> sendTo = new  list<String>();
        sendTo.add(transList[0].Owner.Email);
        for(Contact con : [SELECT email, AccountId FROM Contact where accountid = :accountId]){
            sendTo.add(con.Email);  
        } */
        
        for(ETIN_Insurance_Transactions__c debitrans : [SELECT id, Name, ETIN_AP_Type__c, Owner.Email, Owner.Name FROM ETIN_Insurance_Transactions__c WHERE id IN : NewMap.keyset()]){
            ETIN_Insurance_Transactions__c  myContact = debitrans;
            System.debug(myContact);
            if(myContact.ETIN_AP_Type__c == 'Debit Note')
            {
                list<String> sendTo = new  list<String>();
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                //sendTo.add('pritamraj.rits@gmail.com');
                sendTo.add(myContact.Owner.Email);
                mail.setToAddresses(sendTo);
                mail.setUseSignature(false);
                String htmlBody = '<p>Hi ' + myContact.owner.Name + ',</p>';
                htmlBody+=   '<p>You have received debit note with Name ' + myContact.Name;
                
                htmlBody+=   '<p>Thank you and best regards,</p>';
                htmlBody+=   '<p>Vehicle insurance Team</p>';
                mail.setSubject('Claims Debit Note');
                mail.setHtmlBody(htmlBody);
                mail.setSaveAsActivity(false);
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                    
                    if(!test.isRunningTest())
                {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    system.debug(results);
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                        
                        
                    }  else {
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                        
                    }
                }
            }
        }
        
    }
    
    /* Method Name: sendEmailForMulkiya
     * Description: Send an email to insurance partner on creation and status is pending
     * Author:Janardhan
     */
    public static void sendEmailForMulkiya(map<id,Correction_Cancel_Request__c> newMap){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
        
        Map<String, List<String>> accIDVsEmailList = new Map<String, List<String>>();
        map<id, id> insCmpnyIDvsVehReqId = new Map<id, id>();
        
        for(id veh : newMap.keyset()){
            
            Correction_Cancel_Request__c  req = newMap.get(veh);
            string RecordTypeName = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(req.RecordTypeId).getname();
            
            if(req.Request_Status__c == 'Insurance Pending' && RecordTypeName == 'Available for Mulkiya'){
                
                insCmpnyIDvsVehReqId.put(newMap.get(veh).Insurance_Company__c, veh);
            }
            
        }
        
        for(Contact con : [SELECT email, AccountId FROM Contact where ETVIN_Insurance_Portal_User__c = true AND accountid IN :insCmpnyIDvsVehReqId.keySet()]){
            
            if(accIDVsEmailList.containsKey(con.AccountId)){
                
                List<String> emaillist =  accIDVsEmailList.get(con.AccountId);
                emaillist.add(con.Email);
                accIDVsEmailList.put(con.AccountId, emaillist);
            }else{
                
                accIDVsEmailList.put(con.AccountId, new List<String>{con.Email});  
            }
            
        }
        
        for(Correction_Cancel_Request__c req : newMap.values()){
            
            string RecordTypeName = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosById().get(req.RecordTypeId).getname();
            
            
            if(req.Request_Status__c == 'Insurance Pending' && RecordTypeName=='Available for Mulkiya' ){
                
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                
                list<String> sendTo = new  list<String>();
                
                sendTo.addAll(accIDVsEmailList.get(req.Insurance_Company__c) );
                mail.setToAddresses(sendTo);
                
                if(owea != null && owea.size() > 0){
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                
                String htmlBody = '<p>Dear Insurance Partner,</p>';
                string subjectVal = 'New Request for Insurance available in Online';
                
                htmlBody+=   '<p>You have received a  request, please verify from ' + System.label.ETVIN_partnerPortalUrl+'?recordId=' + req.id + '&tab=Mulkiya';
                
                htmlBody+=   '<p>Thank you and best regards,</p>';
                htmlBody+=   '<p>Vehicle Insurance Team</p>';
                mail.setSubject(subjectVal);
                mail.setHtmlBody(htmlBody);
                mail.setSaveAsActivity(false);
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                    
                    if(!test.isRunningTest())
                {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    system.debug(results);
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                        
                        
                    }  else {
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                        
                    }
                    
                }
            }
        }
    }
}