public class ETC_UtilityClass {
    /* Method : To get Base URL
	*/
	 public static string getBaseURL(){
        String baseurl = System.Url.getSalesforceBaseURL().toExternalForm();
        return baseurl;
    }
    
    
    
    /* Method: to get User details
     
     */
    
    public static string getAccountId(){
        string accountId;
        list<user> users=new list<user>([select accountId from user where id=:userInfo.getUserId() AND accountId !=NULL limit 1]);
        if(users !=NULL && users.size()>0)
            accountId=users[0].accountId;
        return accountId;
    }
    
    /* Method: To get logged in user details
     */
    
    public static userdetails getUserDetails(){
        List<User> userList=[select accountId,contactId from user where id=:userInfo.getUserId() limit 1];  
        //Account acc=[select id from Account where id=:userAccountId];
        userdetails ud = new userdetails();
        ud.accountId = userList[0].accountId;
        ud.contactId = userList[0].contactId;
        ud.userId = userInfo.getUserId();
        
        return ud;
    }
    
    /* Method : Wrapper class to return logged in user account, user and adderss details
     */
    
    public class userdetails{
        public String accountId;
        public String userId;
        public String contactId;
    }
    
    /* Method      : sendEmail 
       Description : 
    */
    
    
  /*  public static boolean sendEmail(List<String> emails ,String emailTemplateName , String whatId, String targetId, Boolean saveAsActity , 
                                    String orgWideEmail, String senderDisplayName , String module){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        boolean ismailsent = false;
        if(emails!= null && !emails.isEmpty()){
            mail.setToAddresses(emails);//Set To Email Address
        }
        
        List<EmailTemplate> template = new List<EmailTemplate> ([SELECT Id, Name, DeveloperName, Subject,HtmlValue FROM EmailTemplate where 
                                                                 DeveloperName =: emailTemplateName]);
        if(!template.isEmpty()){
            mail.setTemplateID(template[0].Id);
        }
        //mail.setHtmlBody();//Set HTML Body
        //mail.setSubject('Greeting from Janbask Training');
        //mail.setPlainTextBody('Janbask Training Career counselling');
        //mail.setSenderDisplayName('JanaBask Training');
        //
        //mail.setTreatTargetObjectAsRecipient(param1);
        if(orgWideEmail != null){
            mail.setOrgWideEmailAddressId(orgWideEmail);
        }
        if(targetId != null){
            mail.setTargetObjectId(targetId); // can set ids of User/contact/Lead
        }
        if(whatId != null){
            mail.setWhatId(whatId); // can set any object id - to set bind Variables of email content.
        }
        if(saveAsActity != null){
            mail.setSaveAsActivity(saveAsActity); // saves the Mail sent as an activity for Respective object.
        }
        
        if(senderDisplayName  != null){
            mail.setSenderDisplayName(senderDisplayName);
        }
        
        
        if(mail !=null){
            try{
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});//Send Emails
                ismailsent = true;
                system.debug('Mail sent Successfully');
            }
            catch(Exception e){
                system.debug('exception  ='+ e.getMessage());
                system.debug('Trace = '+ e.getStackTraceString());
                system.debug('line no = '+ e.getLineNumber());
                ETC_utilityClass.logException(e , module);
                
            }
            
        }
        return ismailsent;
    }

*/
    
/** Method     :logException
        Description: To log Apex Exceptions in Custom object 'ET_Error_Logs__c'
	**/
     
    //ETC_utilityClass.logException(e , 'Inspection FSL');
    Public static void logException(Exception e , String module){
        ET_Error_Logs__c err = new ET_Error_Logs__c();
        if(e != null){
            err.ET_Exception_Message__c = e.getMessage();
            err.ET_Exception_Trace__c = e.getStackTraceString();
            err.ET_Exception_Line_Number__c = String.valueOf(e.getLineNumber());
            err.ET_Exception_Type__c = e.getTypeName();
            err.ET_Module__c = module;
        }
        
        try{
            insert err;
        }
        catch(Exception exc){
            system.debug('exception  ='+ exc.getMessage());
            system.debug('Trace = '+ exc.getStackTraceString());
            system.debug('line no = '+ exc.getLineNumber());
        }
        
    }
    
    /* Mobile formatting 
	*/
    public static string mobileRegex(String mobile){
        system.debug('mobile>> '+mobile);
        if (mobile.StartsWith('00'))
            mobile = mobile.replaceFirst('00','971');
        if (mobile.StartsWith('0'))
            mobile = mobile.replaceFirst('0','971');
        if (mobile.StartsWith('+971')){
            mobile = mobile.replaceFirst('\\+971','971');
        }
        mobile = mobile.replaceAll( '\\s+', '');
        mobile = mobile.remove('-');
        mobile = mobile.remove('+');
        system.debug('mobile111>> '+mobile);
        return mobile;
    }    
    
}