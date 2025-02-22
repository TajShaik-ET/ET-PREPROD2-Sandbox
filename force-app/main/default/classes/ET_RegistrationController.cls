public class ET_RegistrationController {
    @AuraEnabled public static void saveRegistration(ET_Registration_Request__c newRegistration) {
        System.debug('newRegistration:'+newRegistration);
        try{
            insert newRegistration;
        }catch(Exception e){
            System.debug('ex:'+e.getMessage());
        }
        
    }
    @AuraEnabled
    public static Registrationwrapper getDetails() {
        Registrationwrapper wrapperInstance=new Registrationwrapper();
        
        List<String> field_apinames=new  List<String>{'ET_Organization_Type__c','ET_Preferred_Location__c'};
            Map<String, List<Schema.PicklistEntry>>  fieldFinalMap=ETST_PicklistValueController.getPicklistvalues('ET_Registration_Request__c',field_apinames);
        if(fieldFinalMap == null) {
            return null;
        }
        List<String> optionlist = new List<String>();
        for(String fieldVal : fieldFinalMap.keySet()){
            for(Schema.PicklistEntry pv : fieldFinalMap.get(fieldVal)) {
                optionlist.add(pv.getValue());
            }
            if(fieldVal=='ET_Organization_Type__c'){
                wrapperInstance.orgList.addAll(optionlist);
            }else if(fieldVal=='ET_Preferred_Location__c'){
                wrapperInstance.locList.addAll(optionlist);
                
                
            } 
            optionlist.clear();          
        }
        System.debug('orgList' +wrapperInstance.orgList);
        return wrapperInstance;
    }
    public static void notifyAction (List<ET_Registration_Request__c> reqList){
        System.debug('reqList-->'+reqList);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Map<String,String> emailMap=new Map<String,String>();
        for(Registration_Emails__mdt req:[select Location__c,Service__c,Email_Id__c from Registration_Emails__mdt]){
            emailMap.put(req.Location__c+'-'+req.Service__c,req.Email_Id__c);
        }
        if(emailMap.size() == null || emailMap.size() == 0) {return;}
        List<string> toAddress = new List<string>(); 
        if(!reqList.isEmpty()){
            for(ET_Registration_Request__c inv :reqList){
                
                if(Test.isRunningTest()){
                    toAddress.add('test@gmail.com');
                }else{
                    toAddress.addall(emailMap.get(inv.ET_Preferred_Location__c+'-'+inv.ET_Organization_Type__c).split(',')); 
                
                }
                //EmailTemplate et = [Select Id,Subject, Body from EmailTemplate where developerName = 'ETST_Invoice_Email_Template'];            
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                String url=System.Label.SFUrl+inv.Id;
                mail.setSubject('New B2B Registration'); 
                mail.setHtmlBody('Hello Team, <br/><br/>'+inv.ET_Organization_Name__c+' is requested for new account activation. Please click <a href='+url+'>here</a> to check the details. <br/><br/><br/>Thanks,<br/>Emirates Transport');
                
                mail.setSaveAsActivity(false);
                mail.setTreatTargetObjectAsRecipient(false);//Not to send the email to target guest if email is edited
                //mail.setTargetObjectId(inv.Service_Request__r.ET_Account__r.personcontactId); 
                // mail.setWhatId(inv.Service_Request__r.ET_Account__c);
                mail.setToAddresses(toAddress);
                mails.add(mail);
            }
        }
        if(!mails.isEmpty()){
            if(!system.Test.isRunningTest()){
                Messaging.SendEmailResult [] results = Messaging.sendEmail(mails);  
                System.debug('results-->'+results); 
                //insert invoiceAttachments;
            }
        }
    }  
    public class registrationwrapper{
        @AuraEnabled 
        public  list<string> orgList=new list<String>();
        @AuraEnabled 
        public  list<string> locList=new list<String>();
    }
    /*Author:Janardhan
*Desc: create community user if the request status is Approved.
*Modified Date: 04/11/21
*/
    @AuraEnabled
    Public static void createCommunityUser(string ReqId){
        
        ET_Registration_Request__c regReq = [Select id,ET_Email_Id__c,ET_First_name__c,
                                             ET_Last_name__c,ET_Mobile_Number__c,
                                             ET_Organization_Name__c,
                                             ET_Organization_Type__c,ET_Preferred_Location__c,
                                             ET_TRN_Number__c,
                                             Request_Status__c
                                             from ET_Registration_Request__c where Id=:ReqId];
       
        Savepoint saveP = Database.setSavePoint();
        try{
            
            //Create Account 
            Account acc = new Account();
            acc.Name = regReq.ET_Organization_Name__c;
            acc.OwnerId = UserInfo.getUserId();
            //ETSALES_B2B_Account
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
            acc.ETSALES_TaxRegistrationNo__c = regReq.ET_TRN_Number__c;
            acc.ET_Preferred_Location__c =regReq.ET_Preferred_Location__c;
            acc.Registration_Request__c = regReq.id;
            acc.ETST_Account_Type__c = 'Private School';
            
            insert acc;
            
            system.debug('--acc'+acc.Id);
            //Create Contact
            Contact con  = new Contact();
            con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Business_B2B_Inspection').getRecordTypeId();
            con.LastName = regReq.ET_Last_name__c;
            con.FirstName = regReq.ET_First_name__c;
            con.Email = regReq.ET_Email_Id__c;
            con.MobilePhone = regReq.ET_Mobile_Number__c;
            con.Preferred_Language__c = 'English';
            con.ET_Preferred_Location__c = regReq.ET_Preferred_Location__c;
            con.AccountId = acc.Id;
            
            insert con;
            
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name='OneET Business Partner Login User' Limit 1];
            
            //Create user
            User u = new User();
            u.ProfileId = portalProfile.Id;
            u.FirstName = regReq.ET_First_name__c;
            u.LastName =  regReq.ET_Last_name__c;
            u.Email = regReq.ET_Email_Id__c;
            u.ContactId = con.Id;
            u.TimeZoneSidKey = 'Asia/Dubai';
            u.LocaleSidKey = 'en_US';
            u.LanguageLocaleKey = 'en_US';
            u.CommunityNickname = regReq.ET_Last_name__c+string.valueOf(math.random()).substring(0,6);
            u.MobilePhone = regReq.ET_Mobile_Number__c;
            u.EmailEncodingKey ='UTF-8';
            u.Alias =regReq.ET_Last_name__c.Left(5);
            u.Username = regReq.ET_Email_Id__c+'.et';
            
            insert u;
            
            // once all account, contact and user created -- Make the Request as Approved..
            regReq.Request_Status__c = 'Approved';
            update regReq;
            system.debug('--user--'+u);
        }catch(Exception e){
            String expMsg = 'Unknown Error. Please contact system admin.';
            Database.rollback(saveP);
            if(e.getMessage() != null && e.getMessage().contains('Account with the same name')){
                expMsg = 'Account with same name exists. Please reuse the same account.';
            }
            
            else if(e.getMessage() != null && e.getMessage().contains('DUPLICATE_USERNAME')){
                expMsg = 'User already exists in system with same user name.';
            }
            else{
                expMsg = e.getMessage();
            }
            
            throw new AuraHandledException(expMsg); 
        }
    }
    
    @AuraEnabled
    Public static ET_Registration_Request__c queryRegistrationRecord(string ReqId){
        return [select id,Request_Status__c from ET_Registration_Request__c where Id=:ReqId];
    }
}