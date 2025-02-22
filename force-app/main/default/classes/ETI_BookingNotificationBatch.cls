global class ETI_BookingNotificationBatch implements Database.Batchable<sObject>, Database.Stateful,Schedulable
{
    public static id B2BRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
    public static id B2CRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Person_B2C).getRecordTypeId();

    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        Id vRecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        String query='Select Id,Name,Payment_Status__c,ETI_Is_booking_Confirmed_Notified__c,ETI_Is_Invoice_Sent__c,ETI_Is_Receipt_Sent__c,ET_Account__r.PersonEmail,ET_Account__r.recordtypeid, CreatedBy.Contact.Email From ET_Service_Request__c';
               query+=' Where recordTypeId=:srRecordTypeId AND Payment_Status__c IN (\'Payment Success\') AND ETI_Is_Receipt_Sent__c=false AND LastModifiedDate = LAST_N_DAYS: 20';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<ET_Service_Request__c> scope)
    {
        try{
            set<Id> paymentSuccessSRIds = new set<Id>();
            list<ET_Service_Request__c> lstServiceRequest= new list<ET_Service_Request__c>();  
            list<Contact> contacts=new list<Contact>();
            Map<id,Boolean> receiptNotSynchedMap=new Map<id,Boolean>();
            Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
            contacts = [select id, Email from Contact where email !=null limit 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
            if(!contacts.isEmpty()){
                list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Booking_Confirmation' limit 1];
                for(ET_Service_Request__c sr: scope){
                    if(sr.Payment_Status__c=='Payment Success' && sr.ETI_Is_Receipt_Sent__c==false){
                        paymentSuccessSRIds.add(sr.id);
                    }
                }
                for(ETI_Service_Line_Item__c service: [SELECT Id,AMAN_Receipt_No__c,Booking__r.Service_Request__c,(Select Id,AMAN_Receipt_No__c From Receipts__r Where AMAN_Receipt_No__c!=null AND ET_Status__c ='Active') FROM ETI_Service_Line_Item__c WHERE Booking__r.Service_Request__c IN :paymentSuccessSRIds AND Booking__r.Booking_Status__c='Booked']){
                    receiptNotSynchedMap.put(service.Booking__r.Service_Request__c,false);
                    if(service.Receipts__r ==null ||  service.Receipts__r.size() ==0){
                        receiptNotSynchedMap.put(service.Booking__r.Service_Request__c,true);
                        break;
                    }
                }
                for(ET_Service_Request__c sr: scope){
                     if(EmailTemplates!=NULL && EmailTemplates.size()>0 && sr.ETI_Is_Receipt_Sent__c==false && ((sr.ET_Account__r.PersonEmail!=null && sr.ET_Account__r.PersonEmail!='') || (sr.CreatedBy.Contact.Email !=null && sr.CreatedBy.Contact.Email !=''))){
                        string subject = EmailTemplates[0].Subject;
                        string emailcontent = EmailTemplates[0].HtmlValue;
                        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        if(!receiptNotSynchedMap.isEmpty() && !receiptNotSynchedMap.containsKey(sr.Id)){//&& !receiptNotSynchedMap.get(sr.Id)
                            string emailBody = 'Your booking has been confirmed with reference number '+sr.Name+'.';
                            emailBody = emailBody +'<br/><br/> Please find your receipt in attachment.';
                            Blob blobData;
                            if(sr.ET_Account__r.recordtypeid == B2BRecordtypeId)
                                blobData = ETI_ServiceRequestHandler.createReceiptAttachment(sr.Id,'b2b');
                            else 
                                blobData = ETI_ServiceRequestHandler.createReceiptAttachment(sr.Id,'b2c');
                            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                            attach.setFileName(sr.Name);
                            attach.setBody(blobData);
                            attach.ContentType='application/pdf';
                            msg.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                            sr.ETI_Is_Receipt_Sent__c=true;
                            sr.ETI_Is_booking_Confirmed_Notified__c=true;
                            lstServiceRequest.add(sr);
                            msg.setWhatId(sr.Id);
                            msg.setTargetObjectId(contacts[0].id);
                            if(sr.ET_Account__r.recordtypeid == B2BRecordtypeId)
                                msg.setToAddresses(new List<string>{sr.CreatedBy.Contact.Email});
                            else 
                                msg.setToAddresses(new List<string>{sr.ET_Account__r.PersonEmail});
                            msg.setSubject(subject);
                            if(emailcontent.contains('{!emailContent}'))
                                 emailcontent = emailcontent.Replace('{!emailContent}',emailBody);
                            emailcontent=emailcontent.replace(']]>','');
                            msg.setHTMLBody(emailcontent);
                            Savepoint sp = Database.setSavepoint();
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg});
                            Database.rollback(sp);
                            Messaging.SingleEmailMessage sEmail = new Messaging.SingleEmailMessage();
                            if(owea.size() > 0) {
                                sEmail.setOrgWideEmailAddressId(owea.get(0).Id);
                            }
                            sEmail.setToAddresses(msg.getToAddresses());
                            sEmail.setPlainTextBody(msg.getPlainTextBody());
                            sEmail.setHTMLBody(msg.getHTMLBody());
                            sEmail.setSubject(msg.getSubject());
                            sEmail.setFileAttachments(msg.getFileAttachments());
                            emailToSend.add(sEmail);
                        }
                    }
                }
                if(!emailToSend.isEmpty()){
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailToSend);
                    System.debug(results);
                    if(!lstServiceRequest.isEmpty())
                        Database.update(lstServiceRequest,false);
                }
            }
        }catch(exception e){
            System.debug('Exception '+e.getMessage());
            System.debug('Exception line '+e.getLineNumber());
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }  
    global void execute(SchedulableContext scon) {
        Database.executeBatch(new ETI_BookingNotificationBatch(),10);
    }
}