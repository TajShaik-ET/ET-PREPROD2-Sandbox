/*
* File Name:ETI_ServiceRequestHandler
* Author : Noor Shaik
* CreatedDate : 10/08/2020
* Modification Purpose
* * 1. Noor Shaik: To define data sharing
* * 2.
*/
Public class ETI_ServiceRequestHandler{
    static id B2BRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
    static id B2CRecordtypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(Label.ETI_Person_B2C).getRecordTypeId();
    Public static void srManualShare(Map<Id, ET_Service_Request__c> newMap, Map<Id,ET_Service_Request__c> oldMap){
        list<ET_Service_Request__c> srList=new list<ET_Service_Request__c>();
        list<ETI_Booking__c> bookingList=new list<ETI_Booking__c>();
        list<ETI_Location_Group_Mapping__mdt> queueMappings=new list<ETI_Location_Group_Mapping__mdt>();
        set<id> srIds=new set<id>();
        map<string,string> locationQueueMap=new map<string,string>();
        map<id,list<string>> srLocationMap=new map<id,list<string>>();
        try{
            Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
            system.debug('recordTypeId>> '+srRecordTypeId);
            if(srRecordTypeId!=null){
                for(ET_Service_Request__c sr:newMap.values()){
                    if(sr.recordTypeId==srRecordTypeId && newMap.get(sr.Id).Payment_Status__c != oldMap.get(sr.Id).Payment_Status__c
                        && sr.Payment_Status__c==system.label.ETI_ServiceRequest_Payment_Status)
                        srIds.add(sr.Id);
                }
                system.debug('srIds>> '+srIds);
                if(!srIds.isEmpty()){
                    for(ETI_Location_Group_Mapping__mdt mdt: [SELECT Label, Group_Id__c FROM ETI_Location_Group_Mapping__mdt]){
                        locationQueueMap.put(mdt.Label,mdt.Group_Id__c);
                    }
                    system.debug('locationQueueMap >> '+locationQueueMap);
                    if(!locationQueueMap.isEmpty()){
                        for(ETI_Booking__c bkng:[Select Id,Name,Service_Request__c,ET_Location__c,ET_Location__r.Location_Code__c from ETI_Booking__c Where Service_Request__c IN: srIds]){
                            if(locationQueueMap.containsKey(bkng.ET_Location__r.Location_Code__c)){
                                if(!srLocationMap.containsKey(bkng.Service_Request__c))
                                    srLocationMap.put(bkng.Service_Request__c,new list<string>{locationQueueMap.get(bkng.ET_Location__r.Location_Code__c)});
                                else 
                                    srLocationMap.get(bkng.Service_Request__c).add(locationQueueMap.get(bkng.ET_Location__r.Location_Code__c));
            
                            }
                        }
                    }
                    system.debug('srLocationMap >> '+srLocationMap);
                    List<ET_Service_Request__Share > sharesToCreate = new List<ET_Service_Request__Share >();
            
                    if(!srLocationMap.isEmpty()){
                        for(string srId: srLocationMap.keySet()){
                            for(string groupId:srLocationMap.get(srId)){
                                ET_Service_Request__Share srShare= new ET_Service_Request__Share();
                                srShare.ParentId = srId;
                                srShare.UserOrGroupId = groupId;
                                srShare.AccessLevel = 'Edit';
                                srShare.RowCause = Schema.ET_Service_Request__Share.RowCause.Manual;
                                sharesToCreate.add(srShare);
                            }
                            
                        }
                    }
                    system.debug('sharesToCreate>> '+sharesToCreate);
                    if(!sharesToCreate.isEmpty()){
                         Database.SaveResult[] sr = Database.insert(sharesToCreate,false);
                         system.debug('sr>> '+sr);
                    }
                }
            }
        }catch(exception e){
            System.debug('Exception '+e.getMessage());
            System.debug('Exception line '+e.getLineNumber());
            logException(e, 'ETI srManualShare');
        }
    }
    
    Public static void createInvoice(Map<Id, ET_Service_Request__c> newMap, Map<Id,ET_Service_Request__c> oldMap){
        List<Invoice__c> invList=new List<Invoice__c>();
        List<Invoice__c> invUpdateList=new List<Invoice__c>();
        List<ET_Invoice_Line_Item__c> invLineItemList=new List<ET_Invoice_Line_Item__c>();
        map<string,Invoice__c> srInoviceMap=new map<string,Invoice__c>();
        set<Id> srIds=new set<Id>();
        set<Id> srUpdateIds=new set<Id>();
        set<Id> invIds=new set<Id>();
        List<Task> lstTask=new List<Task>();
        List<ET_Service_Request__c> srUpdateList=new List<ET_Service_Request__c>();
        map<string,List<ETI_Booking__c>> srBookingMap=new map<string,List<ETI_Booking__c>>();
        map<string,List<User>> usersMap=new map<string,List<User>>();
        list<Contact> contacts=new list<Contact>();    
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        Id invRecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        Id bkngExtRecordTypeId = Schema.SObjectType.ETI_Booking__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();
        //Payment Status get Update with "Payment Success" in the case of Zero Fee.
        if(srRecordTypeId!=null && invRecordTypeId!=null){
            for(ET_Service_Request__c sr:newMap.values()){
                if(sr.recordTypeId==srRecordTypeId && newMap.get(sr.Id).Payment_Status__c != oldMap.get(sr.Id).Payment_Status__c){
                    if( sr.Payment_Status__c == 'Payment Pending' ||  sr.Payment_Status__c == 'Payment Success')
                        srIds.add(sr.Id);
                }
            }
            system.debug('srIds>> '+srIds);
            try{ 
                if(!srIds.isEmpty()){
                    for(ET_Service_Request__c sr:[Select Id,Name,Total_Amount__c,ETI_Payment_Type__c,ET_Account__c,Payment_Status__c,ET_Account__r.PersonMobilePhone,
                        (SELECT Id FROM Invoices__r Where ETST_Active__c = true) From ET_Service_Request__c Where Id IN:srIds]){
                        if(sr.Invoices__r.size() == 0){
                            Invoice__c invoice=new Invoice__c();
                            invoice.recordTypeId=invRecordTypeId;
                            invoice.fromDate__c=Date.today();
                            if(sr.ETI_Payment_Type__c!=null && sr.ETI_Payment_Type__c!=''){
                                if(sr.ETI_Payment_Type__c=='Online')
                                    invoice.ETST_Type__c = 'Card';
                                else   
                                    invoice.ETST_Type__c = sr.ETI_Payment_Type__c; 
                            }
                            invoice.Service_Request__c=sr.Id;
                            invoice.Customer__c=sr.ET_Account__c;
                            invoice.Total_Inv_Amount__c=sr.Total_Amount__c ;
                            invoice.Customer_Number__c=sr.ET_Account__r.PersonMobilePhone;
                            invoice.Payment_Status__c=sr.Payment_Status__c;
                            invoice.ETST_Active__c = true;
                            invList.add(invoice);
                        }
                    }   
                    if(!invList.isEmpty()){
                        Database.SaveResult[] insertResult =Database.insert(invList,false);
                        for(Integer i=0;i<insertResult.size();i++){
                            if(insertResult.get(i).isSuccess()){
                                invIds.add(insertResult.get(i).getId());
                            }
                        }
                        if(!invIds.isEmpty()){
                            for(Invoice__c inv: [SELECT Id,Customer__c,Total_Inv_Amount__c,Service_Request__c FROM Invoice__c Where Id IN:invIds]){
                                srInoviceMap.put(inv.Service_Request__c,inv);
                            }
                        }
                        If(!srInoviceMap.isEmpty()){
                            for(ETI_Booking__c bkng:[Select Id,Name,Service_Request__c,ET_Location__c,Total_Amount__c,Requested_Services_Count__c,
                                                            Service_Type__c,Total_Tax__c from ETI_Booking__c Where Service_Request__c IN: srInoviceMap.KeySet()]){
                                ET_Invoice_Line_Item__c invItem=new ET_Invoice_Line_Item__c();
                                invItem.Invoice__c=srInoviceMap.get(bkng.Service_Request__c).Id;
                                invItem.Amount__c=bkng.Total_Amount__c;
                                invItem.Tax_Amount__c=bkng.Total_Tax__c;
                                invItem.ET_Location__c=bkng.ET_Location__c;
                                invItem.Quantity__c=string.valueOf(bkng.Requested_Services_Count__c);
                                invItem.Service_Type__c=bkng.Service_Type__c;
                                invLineItemList.add(invItem);
                            }
                        }
                        if(!invLineItemList.isEmpty())
                            insert invLineItemList;
                    }
                    //Create Task to notify external bookings to interanl users
                    if(bkngExtRecordTypeId!=null){
                        for(ETI_Booking__c bkng:[Select Id,Name,User__c,User__r.Name,Customer_Vehicle__r.Contact__c,Booking_Date__c,Service_Request__c,ET_Location__c,ET_Location__r.Location_Code__c,Payment_Status__c from ETI_Booking__c Where Service_Request__c IN: srIds AND recordTypeId =:bkngExtRecordTypeId AND Service_Request__r.ETI_Is_External_Bookings_Notified__c =false AND Booking_Status__c='Booked'  limit 1]){
                            if(!srBookingMap.containsKey(bkng.ET_Location__r.Location_Code__c))
                                srBookingMap.put(bkng.ET_Location__r.Location_Code__c,new List<ETI_Booking__c>{bkng});
                            else 
                                srBookingMap.get(bkng.ET_Location__r.Location_Code__c).add(bkng);
                        }
                        if(!srBookingMap.isEmpty()){
                            for(User obj:[Select id,Name,ETI_Inspection_Center__c from User Where ETI_Inspection_Center__c IN: srBookingMap.keySet() AND isActive=true]){
                                if(!usersMap.containsKey(obj.ETI_Inspection_Center__c))
                                    usersMap.put(obj.ETI_Inspection_Center__c,new List<User>{obj});
                                else 
                                    usersMap.get(obj.ETI_Inspection_Center__c).add(obj);
                            }
                            if(!usersMap.isEmpty()){
                                for(String obj: srBookingMap.keyset())
                                {
                                    for(ETI_Booking__c bkng:srBookingMap.get(obj)){
                                        if(bkng.User__r.Name!=null && bkng.User__r.Name!=''){
                                            srUpdateList.add(new ET_Service_Request__c (Id=bkng.Service_Request__c,ETI_Is_External_Bookings_Notified__c =true));
                                            for(User str:usersMap.get(obj)){
                                                Task objTask = new Task(); 
                                                objTask.OwnerId = str.Id;
                                                objTask.Subject = bkng.User__r.Name+' created new Bookings.';
                                                objTask.Priority = 'Normal';
                                                objTask.Status = 'Not Started';
                                                objTask.ActivityDate = bkng.Booking_Date__c; //Due Date
                                                objTask.WhatID = bkng.Service_Request__c;
                                                objTask.Description = 'Please take necessary actions';
                                                objTask.IsReminderSet=true;
                                                objTask.reminderdatetime=system.now();
                                                lstTask.add(objTask);
                                            }
                                        }
                                     }
                                 }
                                 system.debug('lstTask>> '+lstTask);
                                 system.debug('srUpdateList>> '+srUpdateList);
                                 if(!lstTask.isEmpty())
                                     insert lstTask;
                                 If(!srUpdateList.isEmpty())
                                     update srUpdateList;
                             }
                        }
                    }
                }
            }catch(DMLException ex){
                system.debug('Error '+ex.getMessage());
                system.debug('Error line '+ex.getLineNumber());
                logException(ex, 'ETI CreateInvoice');
            }   
        }     
    }
    Public static void updateInvoice(Map<Id, ET_Service_Request__c> newMap, Map<Id,ET_Service_Request__c> oldMap){
        List<Invoice__c> updateInvList=new List<Invoice__c>();
        set<Id> srIds=new set<Id>();
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        Id invRecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        if(srRecordTypeId!=null && invRecordTypeId!=null){
            for(ET_Service_Request__c sr:newMap.values()){
                if(sr.recordTypeId==srRecordTypeId && (newMap.get(sr.Id).Total_Amount__c != oldMap.get(sr.Id).Total_Amount__c 
                    || (newMap.get(sr.Id).Payment_Status__c != oldMap.get(sr.Id).Payment_Status__c 
                        && (sr.Payment_Status__c == 'Payment Pending' ||  sr.Payment_Status__c == 'Payment Success'))))
                srIds.add(sr.Id);
            }
            try{ 
                if(!srIds.isEmpty()){
                    for(Invoice__c inv: [SELECT Id,Total_Inv_Amount__c,Payment_Status__c,ETST_Type__c,Service_Request__c,Service_Request__r.Total_Amount__c, Service_Request__r.Payment_Status__c,Service_Request__r.ETI_Payment_Type__c  FROM Invoice__c Where Service_Request__c IN:srIds AND ETST_Active__c=true order by createdDate desc]){
                        inv.Id=inv.Id;
                        if(inv.Service_Request__r.Total_Amount__c!=null && inv.Service_Request__r.Total_Amount__c!=inv.service_Request__r.Total_Amount__c)
                            inv.Total_Inv_Amount__c = inv.Service_Request__r.Total_Amount__c;
                        if(inv.Service_Request__r.Payment_Status__c!=null && inv.Service_Request__r.Payment_Status__c!=inv.Payment_Status__c)
                            inv.Payment_Status__c = inv.Service_Request__r.Payment_Status__c;
                        if(inv.Service_Request__r.ETI_Payment_Type__c!=null && inv.Service_Request__r.ETI_Payment_Type__c!=''){
                            if(inv.Service_Request__r.ETI_Payment_Type__c=='Online')
                                inv.ETST_Type__c = 'Card';
                            else   
                                inv.ETST_Type__c = inv.Service_Request__r.ETI_Payment_Type__c; 
                        }
                        updateInvList.add(inv);
                    }
                }
                system.debug('updateInvList>> '+updateInvList);
                If(!updateInvList.isEmpty())
                    update updateInvList;
            }catch(DMLException e){
                system.debug('Error in creating Contact'+e.getMessage());
                logException(e, 'ETI UpdateInvoice');
            }
        }
    }
    
    public static void sendEmailNotification(Set<Id> allRequestid){
        try{
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
            if(allRequestid!=null){
                Id srRecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
                list<Contact> contacts=new list<Contact>();                                                   
                list<ET_Service_Request__c> lstServiceRequest= new list<ET_Service_Request__c>();                                                     
                Map<id,  String>  sendNotificationMap = new Map<id, String>();
                set<Id> receiptNotSynchedIds = new set<Id>();
                Map<id,Boolean> recieptNotSynchedMap=new Map<id,Boolean>();
                Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
                list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Booking_Confirmation' limit 1];
                contacts = [select id, Email from Contact where email !=null limit 1];
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
                system.debug('contacts>> '+contacts);
                if(!contacts.isEmpty()){
                    for(ETI_Service_Line_Item__c service: [SELECT Id,AMAN_Receipt_No__c,Booking__r.Service_Request__c,(Select Id,AMAN_Receipt_No__c From Receipts__r Where AMAN_Receipt_No__c!=null) FROM ETI_Service_Line_Item__c WHERE Booking__r.Service_Request__c IN :allRequestid]){
                        system.debug('service>> '+service);
                        if(service.Receipts__r ==null ||  service.Receipts__r.size() ==0){
                            receiptNotSynchedIds.add(service.Booking__r.Service_Request__c);
                            break;
                        }
                    }
                    System.debug('EmailTemplates ' + EmailTemplates);
                    System.debug('receiptNotSynchedIds ' + receiptNotSynchedIds);
                    for(ET_Service_Request__c sr:[Select Id,Name,ET_Account__r.PersonEmail, ET_Account__r.recordtypeid, CreatedBy.Contact.Email, ETI_Is_booking_Confirmed_Notified__c,ETI_Is_Invoice_Sent__c,ETI_Is_Receipt_Sent__c, (SELECT Name, Total_Inv_Amount__c
                                                         FROM Invoices__r WHERE recordTypeId=:srRecordTypeId AND ETST_Active__c=true order by createdDate desc limit 1) From ET_Service_Request__c Where Id IN:allRequestid]){
                            System.debug('sr.CreatedBy.Contact.Email  ' + sr.CreatedBy.Contact.Email + ' sr.ET_Account__r.recordtypeid  ' + sr.ET_Account__r.recordtypeid  + '  B2CRecordtypeId   ' + B2BRecordtypeId);
                            if(EmailTemplates!=NULL && EmailTemplates.size()>0 && sr.ET_Account__r.PersonEmail!=null && sr.ET_Account__r.PersonEmail!='' && sr.ET_Account__r.recordtypeid == B2CRecordtypeId){
                            string subject = EmailTemplates[0].Subject;
                            string emailcontent = EmailTemplates[0].HtmlValue;
                            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                            system.debug(receiptNotSynchedIds.contains(sr.Id));
                            system.debug('Invoices>> '+sr.Invoices__r);
                            system.debug('Email>> '+sr.CreatedBy.Contact.Email);
                            system.debug('recordtypeid>> '+sr.ET_Account__r.recordtypeid);
                            string emailBody ;
                            emailBody = 'Your booking has been confirmed with reference number '+sr.Name+'.';
                            if(!receiptNotSynchedIds.isEmpty() && !receiptNotSynchedIds.contains(sr.Id)){
                                emailBody = emailBody +'<br/><br/> Please find your receipt in attachment.';
                                Blob blobData = createReceiptAttachment(sr.Id,'b2c');
                                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                                attach.setFileName(sr.Name);
                                attach.setBody(blobData);
                                attach.ContentType='application/pdf';
                                msg.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                                sr.ETI_Is_Receipt_Sent__c=true;
                            }else if(sr.Invoices__r!=null && sr.Invoices__r.size()>0 
                                && sr.Invoices__r[0].Total_Inv_Amount__c != null && sr.Invoices__r[0].Total_Inv_Amount__c != 0){
                                emailBody = emailBody +'<br/><br/> Please find your invoice in attachment.';
                                Blob blobData = createInvoiceAttachment(sr.Id,'b2c');
                                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                                attach.setFileName(sr.Name);
                                attach.setBody(blobData);
                                attach.ContentType='application/pdf';
                                msg.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                                sr.ETI_Is_Invoice_Sent__c=true;
                            } 
                            sr.ETI_Is_booking_Confirmed_Notified__c=true;
                            lstServiceRequest.add(sr);
                            msg.setWhatId(sr.Id);
                            msg.setTargetObjectId(contacts[0].id);
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
                        }else if(EmailTemplates!=NULL && EmailTemplates.size()>0 && sr.CreatedBy.Contact.Email !=null && sr.CreatedBy.Contact.Email !='' && sr.ET_Account__r.recordtypeid == B2BRecordtypeId){
                            string subject = EmailTemplates[0].Subject;
                            string emailcontent = EmailTemplates[0].HtmlValue;
                            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                            system.debug(receiptNotSynchedIds.contains(sr.Id));
                            string emailBody ;
                            emailBody = 'Your booking has been confirmed with reference number '+sr.Name+'.';
                            if(!receiptNotSynchedIds.isEmpty() && !receiptNotSynchedIds.contains(sr.Id)){
                                emailBody = emailBody +'<br/><br/> Please find your receipt in attachment.';
                                Blob blobData = createReceiptAttachment(sr.Id,'b2b');
                                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                                attach.setFileName(sr.Name);
                                attach.setBody(blobData);
                                attach.ContentType='application/pdf';
                                msg.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                                sr.ETI_Is_Receipt_Sent__c=true;
                            }else 
                            if(sr.Invoices__r!=null && sr.Invoices__r.size()>0 
                                && sr.Invoices__r[0].Total_Inv_Amount__c != null && sr.Invoices__r[0].Total_Inv_Amount__c != 0){
                                emailBody = emailBody +'<br/><br/> Please find your invoice in attachment.';
                                Blob blobData = createInvoiceAttachment(sr.Id,'b2b');
                                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                                attach.setFileName(sr.Name);
                                attach.setBody(blobData);
                                attach.ContentType='application/pdf';
                                msg.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                                sr.ETI_Is_Invoice_Sent__c=true;
                            } 
                            sr.ETI_Is_booking_Confirmed_Notified__c=true;
                            lstServiceRequest.add(sr);
                            msg.setWhatId(sr.Id);
                            msg.setTargetObjectId(contacts[0].id);
                            msg.setToAddresses(new List<string>{sr.CreatedBy.Contact.Email});
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
                    System.debug('emailToSend  ' + emailToSend);
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailToSend);
                    System.debug(results);
                    if(!lstServiceRequest.isEmpty())
                        update lstServiceRequest;
                 }
            }
        }catch(exception e){
            System.debug('Exception '+e.getMessage());
            System.debug('Exception line '+e.getLineNumber());
            logException(e, 'ETI EmailNotification');
        }
    }
    public static blob createInvoiceAttachment(id serviceid,string pageName){
        PageReference pref;
        if(pageName == 'b2c')
            pref = page.ETI_Invoice;
        else 
            pref = page.ETI_B2BInvoice;
        pref.getParameters().put('id',serviceid);
        pref.setRedirect(true);
        blob pdfBody;
        if(Test.isRunningTest()) { 
            pdfBody = blob.valueOf('Unit.Test');
        } else {
            system.debug('getContent>> '+ pref.getContent());
            pdfBody = pref.getContent();
        }
        system.debug('pdfBody>> '+pdfBody);
        return pdfBody;
    }
    public static blob createReceiptAttachment(id serviceid,string pageName){
        PageReference pref;
        if(pageName == 'b2c')
            pref = page.ETI_Receipt;
        else 
            pref = page.ETI_B2BReceipt;
        pref.getParameters().put('id',serviceid);
        pref.setRedirect(true);
        blob pdfBody;
        if(Test.isRunningTest()) { 
            pdfBody = blob.valueOf('Unit.Test');
        } else {
            system.debug('getContent>> '+ pref.getContent());
            pdfBody = pref.getContent();
        }
        system.debug('pdfBody>> '+pdfBody);
        return pdfBody;
    }
    public static void sendData(Set<Id> recIds,String vSerLineItemRecId,String vBookingId,String receiptId){
        ET_SOA_Services.sendDatatoAman(recIds,vSerLineItemRecId,vBookingId,receiptId);
    }
    
    /** Method     :logException
        Description: To log Apex Exceptions in Custom object 'ET_Error_Logs__c'
    **/
    Public static void logException(Exception e , String module){
        ET_Error_Logs__c err = new ET_Error_Logs__c();
        err.ET_Exception_Message__c = e.getMessage();
        err.ET_Exception_Trace__c = e.getStackTraceString();
        err.ET_Exception_Line_Number__c = String.valueOf(e.getLineNumber());
        err.ET_Exception_Type__c = e.getTypeName();
        err.ET_Module__c = module; //shoulde be text field
        try{
            insert err;
        }
        catch(Exception exc){
            system.debug('exception  ='+ exc.getMessage());
            system.debug('Trace = '+ exc.getStackTraceString());
        }
    }
  
}