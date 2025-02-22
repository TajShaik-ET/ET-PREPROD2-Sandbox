public without sharing class RefundTriggerHandler {
    public static void triggerApprovalProcess(List<ET_Service_Request__c> refunds) {
    for (ET_Service_Request__c refund : refunds) {
        if (refund.ETST_Status__c == 'Refund Under Approval') {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting refund for approval via Apex.');
                req.setObjectId(refund.Id);
                req.setProcessDefinitionNameOrId('04aQz000000GzHFIA0');
                req.setSubmitterId(UserInfo.getUserId()); 
                req.setSkipEntryCriteria(false);
 
                Approval.ProcessResult result = Approval.process(req);
                System.debug('Approval process result: ' + result);
        }
    }
}
 
    
    public static void sendEmailWithAttachments(List<ET_Refund__c> recordIds, Map<Id, ET_Refund__c> oldRefunds) {
    Set<Id> sRIds = new Set<Id>();
    Set<Id> refundIds = new Set<Id>();
 
    for (ET_Refund__c refund : recordIds) {
        if (refund.ET_Service_Request__c != null) {
            sRIds.add(refund.ET_Service_Request__c);
        }
    }
 
    Map<Id, String> sRMap = new Map<Id, String>();
    List<ET_Service_Request__c> srRecs = [SELECT Id, Name FROM ET_Service_Request__c WHERE Id = :sRIds];
 
    for (ET_Service_Request__c srRec : srRecs) {
        sRMap.put(srRec.Id, srRec.Name);
    }
 
    for (ET_Refund__c refund : recordIds) {
        ET_Refund__c oldRef = oldRefunds.get(refund.Id);
 
        if (refund.ET_Service_Request__c != null) {
            sRIds.add(refund.ET_Service_Request__c);
        }
 
        /*if (oldRef.Approval_Status__c != 'Approved' && refund.Approval_Status__c == 'Approved')*/
        if (refund.Oracle_Invoice_No__c != oldRef.Oracle_Invoice_No__c && refund.Approval_Status__c == 'Approved'){
 
            
            List<ContentDocumentLink> links = [SELECT ContentDocumentId 
                                               FROM ContentDocumentLink 
                                               WHERE LinkedEntityId = :refund.Id];
 
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
 
            for (ContentDocumentLink link : links) {
                List<ContentVersion> versions = [SELECT VersionData, Title, FileType 
                                                  FROM ContentVersion 
                                                  WHERE ContentDocumentId = :link.ContentDocumentId
                                                  AND FileType = 'PDF' 
                                                  LIMIT 1];
                for (ContentVersion version : versions) {
                    Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                    attachment.setFileName(version.Title + '.pdf');
                    attachment.setBody(version.VersionData);
                    attachments.add(attachment);
                }
            }
             String baseURL = System.URL.getOrgDomainUrl().toExternalForm();
                String recordLink = baseURL + '/' + refund.Id;
            String emailBody = 'Dear Omar,\n\n' +
                               'Refund has been processed. Here are the details:\n\n' +
                               'Service Request  : ' + sRMap.get(refund.ET_Service_Request__c) + '\n' +
                               'Refund Ref : ' + refund.Name + '\n' +
                               'Refund Amount : ' + refund.ET_Refund_Amount__c + '\n' +
                               'Payee Name : ' + refund.Payee_Name__c + '\n' +
                               'Bank Name : ' + refund.Bank_Name__c + '\n' +
                               'IBAN : ' + refund.IBAN__c + '\n' +
                               'Oracle Invoice No : ' + refund.Oracle_Invoice_No__c + '\n' +
                               'OracleAPInvoiceId : ' + refund.OracleAPInvoiceId__c + '\n\n' +
                               'You can view the refund record by clicking the link below:\n' +
                                   recordLink + '\n\n' +
                               'Regards,\n' +
                               'ET School Transport';
 
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { Label.Refund_Approved_To_Get_Mail_Notification });
            email.setSubject('Refund Processed - Details for ' + refund.Name);
            email.setPlainTextBody(emailBody);
            email.setFileAttachments(attachments);
            email.setOrgWideEmailAddressId('0D23z000000brblCAA');
 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
    }
}
}