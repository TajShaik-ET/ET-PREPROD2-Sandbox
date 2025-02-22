/*
* File Name:ETI_BookingInspectionHandler
* Author : Noor Shaik
* CreatedDate : 09/05/2020
* Modification Purpose
* * 1. Noor Shaik: Created for Send notifications
* * 2.
*/
Public class ETI_BookingInspectionHandler{
    //update receipt status
    Public static void cancelReceipt(Map<Id, ETI_Booking__c> newMap, Map<Id,ETI_Booking__c> oldMap){
        Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
        List<ETI_Inspection_Receipt__c> reciptUpdateList=new List<ETI_Inspection_Receipt__c>();
        Set<Id> ids=new Set<Id>();
        try{
            for(ETI_Booking__c etb:newMap.values()){
                if(newMap.get(etb.Id).Booking_Status__c != oldMap.get(etb.Id).Booking_Status__c
                   && newMap.get(etb.Id).Booking_Status__c =='Cancelled' && !newMap.get(etb.Id).Is_Auto_Cancelled__c
                   && etb.Service_Type__c !='SPEA Inspection'){
                     ids.add(etb.Id);
                }
            }
            if(!ids.isEmpty()){
                for(ETI_Inspection_Receipt__c receipt:[Select Id,ET_Status__c From ETI_Inspection_Receipt__c Where Bookings__c IN:ids AND ET_Status__c != 'Cancelled']){
                    receipt.ET_Status__c = 'Cancelled';
                    reciptUpdateList.add(receipt);
                }
                if(!reciptUpdateList.isEmpty())
                    update reciptUpdateList;
            }
        }catch(DMLException ex){
            system.debug('Error '+ex.getMessage());
            ETI_ServiceRequestHandler.logException(ex, 'ETI UpdateReceipt');
        }   
    }
    //Send Test Result email notification
    Public static void SendTestResultCustomer(Map<Id, ETI_Booking__c> newMap, Map<Id,ETI_Booking__c> oldMap){
        Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
        List<ETI_Booking__c> bookingList=new List<ETI_Booking__c>();
        list<Contact> contacts=new list<Contact>();
        Set<Id> ids=new Set<Id>();
        List<string> lstToAddress = new list<string>();                                                     
        Contact objContact;
        ID fromid;
        list<String> toaddress;
        ETI_Booking__c booking=new ETI_Booking__c();
        try{
            for(ETI_Booking__c etb:newMap.values()){
                if(newMap.get(etb.Id).Test_Result__c != oldMap.get(etb.Id).Test_Result__c 
                   && newMap.get(etb.Id).Test_Result__c!='Pending' && newMap.get(etb.Id).Test_Result__c!='No Show' && newMap.get(etb.Id).Service_Type__c != 'SPEA Inspection'){
                       ids.add(etb.Id);
                   }
            }
            contacts = [select id, Email from Contact where email !=null limit 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
            if(!contacts.isEmpty() && !ids.isEmpty()){
                list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Test_Result_Notification' limit 1];
                if(EmailTemplates!=NULL && EmailTemplates.size()>0){
                    string subject = EmailTemplates[0].Subject;
                    string emailcontent = EmailTemplates[0].HtmlValue;
                    for(ETI_Booking__c  etb:[Select Id,User__r.PersonEmail,User__r.ETSALES_Email__c,Customer_Vehicle__r.Customer_Email__c,Chassis_No__c,Plate_No__c,Plate_Color__c,Booking_Date__c,ET_Location__r.Name,Vehicle_Number__c,Test_Result__c,(Select Id, Name,Service_Name__c,Test_Result__c,Description__c From Services__r) From ETI_Booking__c Where Id IN: ids])
                    {
                        if(etb.User__r.PersonEmail!=null || etb.Customer_Vehicle__r.Customer_Email__c!=null || etb.User__r.ETSALES_Email__c!=null){
                            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                            if(subject.contains('{!ETI_Booking__c.Vehicle_Number__c}') && etb.Vehicle_Number__c!=null && etb.Vehicle_Number__c!=''){
                                subject = subject.replace('{!ETI_Booking__c.Vehicle_Number__c}', etb.Vehicle_Number__c);
                            }
                            msg.setWhatId(etb.Id);
                            msg.setTargetObjectId(contacts[0].id);
                            if(etb.User__r.PersonEmail!=null)
                                msg.setToAddresses(new List<string>{etb.User__r.PersonEmail});
                            else if(etb.Customer_Vehicle__r.Customer_Email__c!=null)
                                msg.setToAddresses(new List<string>{etb.Customer_Vehicle__r.Customer_Email__c});
                            else if(etb.User__r.ETSALES_Email__c!=null)
                                msg.setToAddresses(new List<string>{etb.User__r.ETSALES_Email__c});
                            msg.setSubject(subject);
                            if(emailcontent.contains('{!ETI_Booking__c.Vehicle_Number__c}') && etb.Vehicle_Number__c!=null && etb.Vehicle_Number__c!='')
                            {
                                emailcontent = emailcontent.replace('{!ETI_Booking__c.Vehicle_Number__c}', etb.Vehicle_Number__c);   
                            }
                            if(emailcontent.contains('{!ETI_Booking__c.Test_Result__c}'))
                            {
                                emailcontent = emailcontent.replace('{!ETI_Booking__c.Test_Result__c}', etb.Test_Result__c);   
                            }
                            integer index=1;
                            string resultdetails = '<table width="100%" cellpadding="3"  cellspacing="2" style="font-family:Calibri;font-size:14px;border-collapse:collapse;"  >'+
                                '<tr class="one" style="background-color: #C9C9C9; color: black;border: 1px solid black;border-collapse:collapse; font-family:Calibri;font-size:14px;text-align:center;">'+
                                '<td class="one" width="5%" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;"><b>S. No</b></td>'+
                                '<td class="one" width="15%" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;"><b>Chassis No</b></td>'+
                                '<td class="one" width="25%" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;"><b>Service Name</b></td>'+
                                '<td class="one" width="10%" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;"><b>Location</b></td>'+
                                '<td class="one" width="10%" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;"><b>Booking Date</b></td>'+
                                '<td class="one" width="10%" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;"><b>Test Result</b></td></tr>';
                            
                            for(ETI_Service_Line_Item__c item:etb.Services__r){
                                string bookingdate = datetime.newInstance(etb.Booking_Date__c, time.newInstance(0,0,0,0)).format('dd/MM/yyyy');
                                string result;
                                string chassis;
                                if(item.Description__c!=null && item.Description__c!=''){
                                    if(item.Description__c.contains('link')){
                                        string link=item.Description__c.split('link')[1];
                                        result=item.Description__c.split('link')[0]+'link ';
                                        result+='<a href="' + link + '" target="_blank">Result</a>';
                                    }else 
                                        result=item.Description__c;
                                }else 
                                    result=item.Test_Result__c;
                                if(etb.Plate_No__c!=null && etb.Plate_Color__c!=null)
                                    chassis=etb.Plate_Color__c+'-'+etb.Plate_No__c;
                                else 
                                    chassis=etb.Chassis_No__c;
                                resultdetails = resultdetails+'<tr class="one" style="background-color: #ffffff; color: #black;border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;">'+
                                    '<td class="one" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;">'+index+'</td>'+
                                    '<td class="one" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;">'+chassis+'</td>'+
                                    '<td class="one" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;">'+item.Service_Name__c+'</td>'+
                                    '<td class="one" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;">'+etb.ET_Location__r.Name+'</td>'+
                                    '<td class="one" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;">'+bookingdate +'</td>'+
                                    '<td class="one" style="border: 1px solid black;border-collapse:collapse;font-family:Calibri;font-size:14px;">'+result+'</td>'+
                                    '</tr>';
                                index=index+1;
                            }
                            resultdetails=resultdetails+'</table>';
                            emailcontent = emailcontent.Replace('{!bookingResult}',resultdetails);
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
                            emailToSend.add(sEmail);
                        }
                    }
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailToSend);
                }
            }
        }catch(Exception ex){
            system.debug('Error '+ex.getMessage());
            ETI_ServiceRequestHandler.logException(ex, 'ETI SendTestResultCustomer');
        }  
    }
    
    //Booking confirmation along with payment Reciept 
    //Commented by Noor Shaik on 21/02/2021
    /*Public static void SendBookingConfirmationtoCustomer(Map<Id, ETI_Booking__c> newMap, Map<Id,ETI_Booking__c> oldMap){
        Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
        List<ET_Service_Request__c> serviceRequestList=new List<ET_Service_Request__c>();
        list<Contact> contacts=new list<Contact>();
        Set<Id> ids=new Set<Id>();
        List<string> lstToAddress = new list<string>();                                                     
        Contact objContact;
        ID fromid;
        list<String> toaddress;
        ETI_Booking__c booking=new ETI_Booking__c();
        try{
            for(ETI_Booking__c etb:newMap.values()){
                if(newMap.get(etb.Id).Booking_Status__c != oldMap.get(etb.Id).Booking_Status__c 
                   && newMap.get(etb.Id).Booking_Status__c =='Booked'){
                       ids.add(etb.Service_Request__c);
                   }
            }
            contacts = [select id, Email from Contact where email !=null limit 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
            if(!contacts.isEmpty() && !ids.isEmpty()){
                list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Inspection_Booking_Notification1' limit 1];
                map<Id,Attachment > attachmentMap=new map<Id,Attachment >();
                for(Attachment attach:[Select Id,Name,Body,Description,parentId from Attachment where parentId IN:ids order by createdDate desc]){
                    if(!attachmentMap.containsKey(attach.parentId))
                        attachmentMap.put(attach.parentId,attach);
                }
                for(ET_Service_Request__c  obj:[Select Id,ETI_Is_booking_Confirmed_Notified__c,(Select Id,User__r.PersonEmail,User__r.ETSALES_Email__c From Bookings__r) From ET_Service_Request__c Where Id IN: ids AND ETI_Is_booking_Confirmed_Notified__c=false]){
                    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                    msg.setTemplateId(EmailTemplates[0].Id);
                    if(owea.size() > 0) {
                        msg.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    msg.setWhatId(obj.ID);
                    msg.setTargetObjectId(contacts[0].id);
                    if(obj.Bookings__r[0].User__r.PersonEmail!=null)
                        msg.setToAddresses(new List<string>{obj.Bookings__r[0].User__r.PersonEmail});
                    else
                        if(obj.Bookings__r[0].User__r.ETSALES_Email__c!=null)
                    msg.setToAddresses(new List<string>{obj.Bookings__r[0].User__r.ETSALES_Email__c});
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
                    if(attachmentMap.size() > 0){    
                        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                        efa.body = attachmentMap.get(obj.Id).body;
                        efa.filename = attachmentMap.get(obj.Id).name;            
                        sEmail.setFileAttachments(new List<Messaging.Emailfileattachment>{efa});
                    }
                    emailToSend.add(sEmail);
                    serviceRequestList.add(new ET_Service_Request__c(Id=obj.Id,ETI_Is_booking_Confirmed_Notified__c=true));
                }
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailToSend);
                update serviceRequestList;
            }
        }catch(DMLException ex){
            system.debug('Error '+ex.getMessage());
            ETI_ServiceRequestHandler.logException(ex, 'ETI BkngConfirmationtoCustomer');
        }  
    }*/

    //Booking confirmation for External 
    Public static void SendBookingConfirmationforExternal(Map<Id, ETI_Booking__c> newMap, Map<Id,ETI_Booking__c> oldMap){
        Id recordTypeIdB2B = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.ETI_Business_B2B_Inspection).getRecordTypeId();
        Id recordTypeIdB2C = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.ETI_Person_B2C).getRecordTypeId();
        Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
        list<Contact> contacts=new list<Contact>();
        Set<Id> bookingIds=new Set<Id>();
        List<string> lstToAddress = new list<string>();                                                     
        Contact objContact;
        ID fromid;
        list<String> toaddress;
        ETI_Booking__c booking=new ETI_Booking__c();
        Map<id, List<Contact>> b2bContactMap = new Map<id, List<Contact>>();
        try{
            for(Contact con: [SELECT AccountId, Id, Email, MobilePhone FROM Contact WHERE (AccountId != null AND Email != null ) AND Account.RecordTypeId =:recordTypeIdB2B]){
                if(b2bContactMap.containsKey(con.AccountId)){
                    List<Contact> conTempList = b2bContactMap.get(con.AccountId);
                    conTempList.add(con);
                    b2bContactMap.put(con.AccountId, conTempList);
                }else{
                    b2bContactMap.put(con.AccountId, new List<Contact>{con});
                }
            }
            for(ETI_Booking__c etb:newMap.values()){          
                if(etb.Is_booking_Confirmed__c != oldMap.get(etb.Id).Is_booking_Confirmed__c && etb.Is_booking_Confirmed__c==true){
                    bookingIds.add(etb.id);
                }
            }
            contacts = [select id, Email from Contact where email !=null limit 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
            if(!contacts.isEmpty()){
                list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName IN('Booking_Confirmation_External','Booking_Confirmation_to_Inspector')];
                map<Id,Attachment > attachmentMap=new map<Id,Attachment >();
                for(Attachment attach:[Select Id,Name,Body,Description,parentId from Attachment where parentId IN:bookingIds order by createdDate desc]){
                    if(!attachmentMap.containsKey(attach.parentId))
                        attachmentMap.put(attach.parentId,attach);
                }
                if(!bookingIds.isEmpty()){
                    for(ETI_Booking__c obj:[Select Id, User__c, User__r.Phone, User__r.Name, User__r.Recordtypeid, User__r.PersonEmail, User__r.ETSALES_Email__c, Inspector__r.Name,Inspector__r.ETI_Email_Id__c, Booking_Date_Time__c, ETI_Pick_Up_Location__c, Service_Request__r.Name From ETI_Booking__c Where Id IN:bookingIds AND Is_booking_Confirmed__c=true]){
                        //Notification to customer
                        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                        msg.setTemplateId(EmailTemplates[0].Id);
                        msg.setWhatId(obj.ID);
                        msg.setTargetObjectId(contacts[0].id);
                       
                         
                        //Notification to Inspector
                        Messaging.SingleEmailMessage msg1 = new Messaging.SingleEmailMessage();
                       // msg1.setTemplateId(EmailTemplates[1].Id);
                        msg1.setWhatId(obj.ID);
                        msg1.setTargetObjectId(contacts[0].id);
                        String inspectorBody = '<p>Dear&nbsp;'+ obj.Inspector__r.Name +', </p>';
                        inspectorBody += '<p>This is to inform you that vehicle inspection request is confirmed.</p>';
                        inspectorBody += '<p>Booking Date &amp; Time :&nbsp;' +obj.Booking_Date_Time__c + ' </p>';
                        inspectorBody += '<p>Equipment Location :&nbsp;' +obj.ETI_Pick_Up_Location__c + ' </p>';
                        inspectorBody += '<p>Account Name :&nbsp;' +obj.User__r.Name + ' </p>';
                       
                       
                       
                        if(obj.User__r.Recordtypeid == recordTypeIdB2C){
                            inspectorBody += '<p>Email :&nbsp;' +obj.User__r.PersonEmail + ' </p>';
                            inspectorBody += '<p>Phone :&nbsp;' +obj.User__r.Phone + ' </p>';
                            //For Customer
                            if(obj.User__r.PersonEmail!=null)
                                msg.setToAddresses(new List<string>{obj.User__r.PersonEmail});
                            else
                                if(obj.User__r.ETSALES_Email__c!=null)
                                msg.setToAddresses(new List<string>{obj.User__r.ETSALES_Email__c});
                        } else{
                            if(b2bContactMap.containsKey(obj.User__c)){
                                String tempEmailList = '';
                                String tempPhoneList = '';
                                for(Contact con : b2bContactMap.get(obj.User__c)){
                                    tempEmailList += con.Email + ', ';
                                    tempPhoneList += con.MobilePhone + ', ';
                                    msg.setToAddresses(new List<string>{con.Email});
                                }
                                inspectorBody += '<p>Email :&nbsp;' +tempEmailList + ' </p>';
                                inspectorBody += '<p>Phone :&nbsp;' +tempPhoneList + ' </p>';
                            }
                            
                            
                        }
                        inspectorBody += '<p>Service Request :&nbsp;' +obj.Service_Request__r.Name + ' </p>';
                        inspectorBody += '<p></p><p><label>Regards.</label><br><label>ET Inspection Team</label> </p>';
                        
                        msg1.setHtmlBody(inspectorBody);
                        if(obj.Inspector__r.ETI_Email_Id__c!=null)
                            msg1.setToAddresses(new List<string>{obj.Inspector__r.ETI_Email_Id__c});
                        Savepoint sp = Database.setSavepoint();
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg});
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {msg1});
                        Database.rollback(sp);
                        Messaging.SingleEmailMessage sEmail = new Messaging.SingleEmailMessage();
                        if(owea.size() > 0) {
                            sEmail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        sEmail.setToAddresses(msg.getToAddresses());
                        sEmail.setPlainTextBody(msg.getPlainTextBody());
                        sEmail.setHTMLBody(msg.getHTMLBody());
                        sEmail.setSubject(msg.getSubject());
                        if(attachmentMap.size() > 0){    
                            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                            efa.body = attachmentMap.get(obj.Id).body;
                            efa.filename = attachmentMap.get(obj.Id).name;            
                            sEmail.setFileAttachments(new List<Messaging.Emailfileattachment>{efa});
                        }
                        emailToSend.add(sEmail);
                        
                        Messaging.SingleEmailMessage sEmail1 = new Messaging.SingleEmailMessage();
                        if(owea.size() > 0) {
                            sEmail1.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        sEmail1.setToAddresses(msg1.getToAddresses());
                        sEmail1.setPlainTextBody(msg.getPlainTextBody());
                        sEmail1.setHTMLBody(msg1.getHTMLBody());
                        sEmail1.setSubject(msg1.getSubject());
                        emailToSend.add(sEmail1);
                    }
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailToSend);
                }
            }
        }catch(Exception ex){
            system.debug('Error '+ex.getMessage());
            ETI_ServiceRequestHandler.logException(ex, 'ETI BkngConfirmationforExternal');
        }  
    }
    //Send Booking Cancellation email notification
    Public static void BookingCancellationNotification(Map<Id, ETI_Booking__c> newMap, Map<Id,ETI_Booking__c> oldMap){
        Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
        List<ETI_Booking__c> bookingList=new List<ETI_Booking__c>();
        list<Contact> contacts=new list<Contact>();
        Set<Id> ids=new Set<Id>();
        List<string> lstToAddress = new list<string>();                                                     
        Contact objContact;
        ID fromid;
        list<String> toaddress;
        ETI_Booking__c booking=new ETI_Booking__c();
        try{
            for(ETI_Booking__c etb:newMap.values()){
                if(newMap.get(etb.Id).Booking_Status__c!= oldMap.get(etb.Id).Booking_Status__c
                   && newMap.get(etb.Id).Booking_Status__c=='Cancelled'){
                   if(!newMap.get(etb.Id).Is_Auto_Cancelled__c)
                       ids.add(etb.Id);
                   else if(newMap.get(etb.Id).Is_Auto_Cancelled__c && oldMap.get(etb.Id).Booking_Status__c!='Draft')
                       ids.add(etb.Id);
                }
            }
            contacts = [select id, Email from Contact where email !=null limit 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
            if(!contacts.isEmpty() && !ids.isEmpty()){
                list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Booking_Cancellation' limit 1];
                if(EmailTemplates!=NULL && EmailTemplates.size()>0){
                    string subject = EmailTemplates[0].Subject;
                    string emailcontent = EmailTemplates[0].HtmlValue;
                    for(ETI_Booking__c  etb:[Select Id,User__r.PersonEmail,User__r.ETSALES_Email__c,Customer_Vehicle__r.Customer_Email__c,Chassis_No__c,Plate_No__c,Plate_Color__c,Booking_Date__c,ET_Location__r.Name,Vehicle_Number__c,Test_Result__c,Selected_Services__c,Cancellation_Reason__c From ETI_Booking__c Where Id IN: ids])
                    {
                        if(etb.User__r.PersonEmail!=null || etb.Customer_Vehicle__r.Customer_Email__c!=null || etb.User__r.ETSALES_Email__c!=null){
                            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                            if(subject.contains('{!ETI_Booking__c.Vehicle_Number__c}') && etb.Vehicle_Number__c!=null && etb.Vehicle_Number__c!=''){
                                subject = subject.replace('{!ETI_Booking__c.Vehicle_Number__c}', etb.Vehicle_Number__c);
                            }
                            msg.setWhatId(etb.Id);
                            msg.setTargetObjectId(contacts[0].id);
                            string emailBody;
                            emailBody = 'Your Vehicle Inspection Booking for Vehicle Number '+etb.Vehicle_Number__c+' is Cancelled.';
                            if(etb.User__r.PersonEmail!=null)
                                msg.setToAddresses(new List<string>{etb.User__r.PersonEmail});
                            else if(etb.Customer_Vehicle__r.Customer_Email__c!=null)
                                msg.setToAddresses(new List<string>{etb.Customer_Vehicle__r.Customer_Email__c});
                            else if(etb.User__r.ETSALES_Email__c!=null)
                                msg.setToAddresses(new List<string>{etb.User__r.ETSALES_Email__c});
                            msg.setSubject(subject);
                            if(emailcontent.contains('{!ETI_Booking__c.Vehicle_Number__c}') && etb.Vehicle_Number__c!=null && etb.Vehicle_Number__c!='')
                            {
                                emailcontent = emailcontent.replace('{!ETI_Booking__c.Vehicle_Number__c}', etb.Vehicle_Number__c);   
                            }
                            if(etb.Selected_Services__c!=null && etb.Selected_Services__c!=''){
                                emailBody = emailBody+'<br/><br/><b>Service Type:</b> '+etb.Selected_Services__c;
                            }
                          /*  if(etb.Cancellation_Reason__c!=null && etb.Cancellation_Reason__c!=''){
                                emailBody = emailBody+'<br/><b>Reason/Inspector Comments:</b> '+etb.Cancellation_Reason__c;
                            }*/
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
                            emailToSend.add(sEmail);
                        }
                    }
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailToSend);
                }
            }
        }catch(Exception ex){
            system.debug('Error '+ex.getMessage());
            ETI_ServiceRequestHandler.logException(ex, 'ETI SendBookingCancellation');
        }  
    }
    //Booking confirmation along with payment Reciept 
    /*Public static void SendBookingConfirmationtoCustomer1(Map<Id, ET_Service_Request__c> newMap, Map<Id,ET_Service_Request__c> oldMap){
        Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
        Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        List<ET_Service_Request__c> bookingList=new List<ET_Service_Request__c>();
        Set<Id> ids=new Set<Id>();
        List<string> lstToAddress = new list<string>();                                                     
        Contact objContact;
        ID fromid;
        list<String> toaddress;
        ET_Service_Request__c booking=new ET_Service_Request__c();
        for(ET_Service_Request__c obj:newMap.values()){
        if(newMap.get(etb.Id).Booking_Status__c != oldMap.get(etb.Id).Booking_Status__c 
        && newMap.get(etb.Id).Booking_Status__c =='Booked'){
        ids.add(etb.Id);
        }
        }
        Contact c = [select id, Email from Contact where email ='noor.shaik@smaartt.com' limit 1];
        list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Inspection_Booking_Notification1' limit 1];
        map<Id,Attachment > attachmentMap=new map<Id,Attachment >();
        for(Attachment attach:[Select Id,Name,Body,Description,parentId from Attachment where parentId IN:ids order by createdDate desc]){
        if(!attachmentMap.containsKey(attach.parentId))
        attachmentMap.put(attach.parentId,attach);
        }
        for(ET_Service_Request__c etb:[Select Id,User__r.PersonEmail,User__r.ETSALES_Email__c From ET_Service_Request__c Where Id IN: ids]){
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setTemplateId(EmailTemplates[0].Id);
        msg.setWhatId(etb.ID);
        msg.setTargetObjectId(c.id);
        msg.setToAddresses(new List<string>{etb.User__r.ETSALES_Email__c});
        //msg.setSubject(EmailTemplates[0].Subject);
        //msg.setHTMLBody(EmailTemplates[0].HtmlValue);
        msg.setBccAddresses(new List<string>{'noorshaik28@gmail.com'});
        if(attachmentMap.size() > 0){    
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.body = attachmentMap.get(etb.Id).body;
        efa.filename = attachmentMap.get(etb.Id).name;            
        msg.setFileAttachments(new List<Messaging.Emailfileattachment>{efa});
        }
        emailToSend.add(msg);
        }
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailToSend);
    }*/
    
    Public static void updateEncrypted(Map<Id, ETI_Booking__c> newMap){
        list<ETI_Booking__c> bookingList=new list<ETI_Booking__c>();
        set<id> ids=new set<id>();
        try{
            for(ETI_Booking__c etb :newMap.values()){
                ids.add(etb.Id);
            }
            
            if(!ids.isEmpty()){
                for(ETI_Booking__c etb :[Select Id,Encrypted_Id__c from ETI_Booking__c  Where ID IN:ids]){
                    etb.Encrypted_Id__c=ETI_VehicleController.getEncryptedData(etb.Id);
                    bookingList.add(etb);
                }
            }
            if(!bookingList.isEmpty())
                update bookingList;
        }catch(DMLException ex){
            system.debug('Error '+ex.getMessage());
            ETI_ServiceRequestHandler.logException(ex, 'ETI UpdateEncrypted');
        }  
    }
   
}