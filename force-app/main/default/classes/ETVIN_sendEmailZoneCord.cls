public class ETVIN_sendEmailZoneCord {

    public static void sendEmailToCord(list<ETVIN_Vehicle_Insurance__c> trgnew){
        
       map<string,string> insIdvsZone = new map<string,string>();
        set<string> zonesSet = new set<string>();
        map<string,list<string>> zoneVsEmails = new map<string,list<string>>();
        
        
        for(ETVIN_Vehicle_Insurance__c vi : trgnew){
           
            insIdvsZone.put(vi.Id,vi.Zone__c);
            zonesSet.add(vi.Zone__c);
        }
        
        for(user u : [select id,name,email,ETSALES_Employee_Zone__c from user where Isactive=True AND ETSALES_Employee_Zone__c =:zonesSet AND profile.Name=:System.Label.VIN_ZoneProfileName]){
            
            if(!zoneVsEmails.containsKey(u.ETSALES_Employee_Zone__c)) {
                zoneVsEmails.put(u.ETSALES_Employee_Zone__c, new List<string>());
            }
            zoneVsEmails.get(u.ETSALES_Employee_Zone__c).add(u.email);
        }
        system.debug('---zoneVsEmail'+zoneVsEmails);
        
         OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
         EmailTemplate template = [SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName ='ETVIN_NotifyZoneCord'];
        
        
          Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>(); 
             
        for(ETVIN_Vehicle_Insurance__c vin : trgnew){
            
            if(vin.Zone__c != null && zoneVsEmails.containskey(vin.Zone__c)){
                
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(template.Id,null,vin.Id);
                
                email.toAddresses = zoneVsEmails.get(vin.Zone__c);
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                // email.setSenderDisplayName('Emirates Transport');
                email.setSubject('New Vehicle Insurance Policy '+vin.Name);
                //email.setHtmlBody(template.HTMLValue);
               
                email.setSaveAsActivity(false);
                //email.setWhatId(vin.Id);
                //email.setTemplateId(template.Id);
                email.setTargetObjectId(userinfo.getUserId());
                email.setTreatTargetObjectAsRecipient(false);
                
                emailList.add(email);
            }
           
        }  
        
         //send an email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
    }
    
    public static void deactiveExistingPolicies(list<ETVIN_Vehicle_Insurance__c> trgnew){
        //Adding Default Insurance company in same method - 03/08/22
        if(trigger.isInsert){
           Id partnerId =  [select id,Account_ID__c from Veh_Default_Insurance_partner__c].Account_ID__c;
            for(ETVIN_Vehicle_Insurance__c veh : trgnew){
                
                   veh.ETVIN_Insurance_Company__c = partnerId;                
            }
            
        }
        
        /*When ever new policy is activated then exisiting vehicle policy will be inactive*/
        set<id> policyIDs = new set<id>();
        set<string> vehInternalNoSet = new set<string>();
        set<id> policyOldIds = new set<id>();
        list<ETVIN_Vehicle_Insurance__c> vehInsUpdatelist = new list<ETVIN_Vehicle_Insurance__c>();
        for(ETVIN_Vehicle_Insurance__c veh : trgnew){
            if(veh.ETVIN_Insurance_Status__c == 'Active'){
                vehInternalNoSet.add(veh.ETVIN_Internal_Number__c);
                policyIDs.add(veh.Id);
            }
            
        }
        
        for(ETVIN_Vehicle_Insurance__c vehOld : [select id from ETVIN_Vehicle_Insurance__c where Vehicle__r.Name=:vehInternalNoSet AND ETVIN_Insurance_Status__c='Active']){
            policyOldIds.add(vehOld.Id);
        }
        
        system.debug('--po--'+policyIDs);
         system.debug('--veh--'+vehInternalNoSet);
        system.debug('-all-'+policyOldIds);
        policyOldIds.removeAll(policyIDs);
        system.debug('-remain-'+policyOldIds);
        
        for(id idval : policyOldIds){
            
            ETVIN_Vehicle_Insurance__c newUpdate = new ETVIN_Vehicle_Insurance__c();
            newUpdate.Id = idval;
            newUpdate.ETVIN_Insurance_Status__c  ='Inactive';
            vehInsUpdatelist.add(newUpdate);
        }
        
        update vehInsUpdatelist;
    }
}