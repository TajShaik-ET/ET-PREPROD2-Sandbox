public class CICO_checkOutSendEmailCtrl {
    
    @AuraEnabled
    public static void sendEmailToCustomer(string emails,string RecId){
        
        system.debug('---'+RecId);
        string docNo = [select id,Document_No__c from CICO_Check_Out__c where Id=:RecId].Document_No__c;
        
        list<string> toEmails = new list<string>(emails.split(';'));

         OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];
         EmailTemplate template = [SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName ='CICO_SendEmailToCustomerCheckOut'];
     try {
         PageReference pdf = page.CICO_CheckOutPdf;
         pdf.getParameters().put('id',RecId);
         pdf.setRedirect(true); 
         
         Blob pdfContent;
         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
          Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
         
                pdfContent = (Test.isRunningTest()) ? Blob.valueOf('Test') : pdf.getContent();
                string fileName= 'CheckoutDocument_'+docNo+'.pdf';
                att.setFileName(fileName);
                att.setBody(pdfContent);                
               
                message.toAddresses = toEmails;
                if ( owea != null && owea.size() > 0 ) {
                    message.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                // message.setSenderDisplayName('Emirates Transport');
                message.setSubject(template.Subject);
                message.setHtmlBody(template.HTMLValue);
                message.setSaveAsActivity(false);
                message.setWhatId(RecId);
                message.setTargetObjectId(userinfo.getUserId());
                message.setTreatTargetObjectAsRecipient(false);
                message.setFileAttachments(new Messaging.EmailFileAttachment[] {att});
               
         Messaging.SendEmailResult[] results = Messaging.sendEmail(new list<Messaging.SingleEmailMessage>{message});
         
         if (results[0].success) {
             System.debug('The email was sent successfully.');
             
         } else {
             System.debug('The email failed to send: '
                          + results[0].errors[0].message);
            
         }
         
     }catch (VisualforceException e) {
         System.debug('exc '+e);
         throw new AuraHandledException(e.getMessage());
         
     }
     
        
    } 

}