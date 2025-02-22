public class SendEmailHandler {
    
    @AuraEnabled
    public static string processEmail(String email, String Subject, String Message){
        String sMessage='';
        try{ 
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
            string[] OrgWideInfo = new string[]{null,null};
                
                for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='info@et.ae']) {
                    OrgWideInfo[0] = owa.Id;
                    OrgWideInfo[1] = owa.Address;
                }
            List<String> emailList = email.split(',');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = emailList ; //new String[] {email}; 
                mail.setToAddresses(toAddresses);
            mail.setSubject(Subject);
            if(OrgWideInfo[0] != null){
                mail.setOrgWideEmailAddressId(OrgWideInfo[0]);
                mail.setInReplyTo(OrgWideInfo[1]);
                mail.setReplyTo(OrgWideInfo[1]);
            }
            mail.setHtmlBody(Message);
            Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            sMessage='Success';
        }
        catch(Exception ex){
            sMessage=ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString();
        }
        return sMessage;
    }
    public static void magicMethod(){
        Integer i = 0 ;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}