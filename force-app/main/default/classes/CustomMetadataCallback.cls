public class CustomMetadataCallback implements Metadata.DeployCallback {
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {
                             
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug('success: '+ result);
        } else {
           String fileString='Name,Id,Errors\n';
           
            // Deployment was not successful
            System.debug('fail: '+ result);
            if(result.details!=null && result.details.componentFailures!=null && result.details.componentFailures.size() >0){
                for(Metadata.DeployMessage d:result.details.componentFailures){
                    if(d.componentType!=null){
                        fileString+=d.fileName+','+d.id+','+d.problem+'\n';
                    }
               }
               OrgWideEmailAddress orgWideAddress=[select id, Address,DisplayName from OrgWideEmailAddress where DisplayName='Emirates Transport'];         
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();   
               email.setSubject('Exception while processing class Common_PostprocessingSandboxActivities for custom metadata');
               email.setOrgWideEmailAddressId(orgWideAddress.id);
               email.setToAddresses( new String[] {Userinfo.getUserEmail(),'kumaresan.m@smaartt.com'});
               email.setHTMLBody('Please go to "Deployment Status" under Admin Setup to view more information on errors.');
               
               List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
               Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
               efa.setFileName('Error file.csv');
               efa.setBody(blob.ValueOf(fileString));
               efa.setContentType('text/csv');
               attachments.add(efa);                          
               email.setFileAttachments(attachments);
               
               Messaging.SendEmailResult [] emailResults=Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
        }
        
    }
}