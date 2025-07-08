/***
Class       : CaseTriggerHandler
Author      :Smaartt
Description : 
TestClass  : CaseTriggerHandler_Test
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date         Developer        Details
1.          V1.0                                            Initial Version 
2.          V2.0             14/06/2023     Sreelaskhmi     SendFeedbackEmail - new method is added
****************************************************************************************************************/


public class CaseTriggerHandler{
    public static Boolean isFirstTime = true;
    
    public static void validatePendingActivies(List<case> modifyCases){
        system.debug('###############'+modifyCases);
        Map<Id, Task> taskMap = new Map<Id, Task>();
        for(Task t : [SELECT Id, WhatId FROM Task WHERE IsClosed=false AND WhatId IN :modifyCases])
        {
            system.debug('###############'+t);
            taskMap.put(t.WhatId, t);
        }
        system.debug('###############'+taskMap);        
        for(Case c : modifyCases)
        {
            //check if the case has any open tasks and has just been changed to closed
            if(taskMap.containsKey(c.Id))
                c.addError('please finish the pending activites before closing the case');
        }
    }
    
    public static void updateMilestones(List<case> modifyCases){
        system.debug('######Case@@#########'+modifyCases);
        Map<Id, Task> taskMap = new Map<Id, Task>();
        Map<Id, CaseMilestone> MapcmsToUpdate = new Map<Id, CaseMilestone>();
        List<CaseMilestone> cmsToUpdate = new   List<CaseMilestone>();
        for(Task t : [SELECT Id, WhatId FROM Task WHERE IsClosed=false AND WhatId IN :modifyCases])
        {
            system.debug('###############'+t);
            taskMap.put(t.WhatId, t);
        }
        for(CaseMilestone cmil : [select z.caseId, z.completionDate
                                  from CaseMilestone z 
                                  where caseId in :modifyCases 
                                  and completionDate = null]){
                                      MapcmsToUpdate.put(cmil.caseid,cmil);
                                  }
        system.debug('######Map@@#########'+MapcmsToUpdate);
        for(Case c : modifyCases)
        {
            system.debug('######Map@@#########'+MapcmsToUpdate.containskey(c.id));
            //check if the case has any open tasks and has just been changed to closed
            if(taskMap.containsKey(c.Id)){
                c.addError('please finish the pending activites before closing the case');
            }
            else if(MapcmsToUpdate.containskey(c.id)){
                system.debug('---->Insideelseif'+MapcmsToUpdate.get(c.id).completionDate);
                MapcmsToUpdate.get(c.id).completionDate=system.now();
                system.debug('---->Insideelseif'+MapcmsToUpdate.get(c.id).completionDate);
            }
        }
        system.debug('###############'+MapcmsToUpdate);        
        if( MapcmsToUpdate.values().size()>0) update MapcmsToUpdate.values();
    }
    
    public static void validateEntitlement(List<case> modifyCases){
        List <Entitlement> entls = [Select Name,StartDate, Id, EndDate, AccountId, AssetId From Entitlement];
        if(!entls.isEmpty()){
            for(Case c : modifyCases) {
                //if(c.EntitlementId == null && c.AccountId != null){
                for(Entitlement e:entls){
                    if(e.Name == c.Priority){
                        c.EntitlementId = e.Id;
                    }
                }
            }
        }
    }
    
    public static void updateCaseManagerEmail(Map<Id, Id> newMap){
        List<Case> updateCases = new List<Case>();
        Map<Id,User> mapofUsers = new Map<Id, User>([Select Id, Manager.Email from User WHERE Id IN:newMap.values()]);
        for(Case cs : [Select Id,OwnerId,Case_Manager_Email__c FROM Case WHERE Id IN:newMap.keySet() AND Status != 'Closed']){
            cs.Case_Manager_Email__c = mapofUsers.get(cs.OwnerId).Manager.Email;
            updateCases.add(cs);
        }
        if(!updateCases.isEmpty()){
            update updateCases;
        } 
    }
    
    public static void updateCaseManagerEmailfromQueue(Map<Id, Case> newMap){
        List<Case> trafficfine = new List<Case>();
        Map<Id, Id> mapOfUsers = new Map<Id, Id>();
        Map<Id, Id> mapOfQueue = new Map<Id, Id>();
        Map<Id,User> newMapOfUsers = new Map<Id,User>();
        Map<Id,Group> newMapOfQueues = new Map<Id,Group>();
        List<Case> updateCases = new List<Case>();
        for(case c: newMap.values()){
            if(c.recordTypeId != System.label.MRO_Case_Record_Type_Id){
                string str = String.valueof(c.OwnerId);
                if(str.startsWith('00G')){
                    mapOfQueue.put(c.Id, c.OwnerId);
                } else{
                    mapOfUsers.put(c.Id, c.OwnerId);
                }
            }
        }
        system.debug('mapOfQueue***'+mapOfQueue);
        system.debug('mapOfUsers***'+mapOfUsers);
        if(!mapOfUsers.isEmpty()){
            newMapOfUsers = new Map<Id, User>([Select Id, Manager.Email from User WHERE Id IN:mapOfUsers.values()]);
        }
        if(!mapOfQueue.isEmpty()){
            newMapOfQueues = new Map<Id, Group>([SELECT Id, Name, Email FROM Group WHERE Id IN:mapOfQueue.values()]);
        }
        for(Case cs : [Select Id,OwnerId,Case_Manager_Email__c,recordTypeId FROM Case WHERE Status != 'Closed' AND Id IN:newMap.keySet()]){
            if(cs.recordTypeId != System.label.MRO_Case_Record_Type_Id){
                String strOwnerId = String.valueof(cs.OwnerId);
                if(strOwnerId.startsWith('00G')){
                    cs.Case_Manager_Email__c = newMapOfQueues.get(cs.OwnerId).Email;
                } else{
                    cs.Case_Manager_Email__c = newMapOfUsers.get(cs.OwnerId).Manager.Email;
                }
                updateCases.add(cs);
            }
        }
        if(!updateCases.isEmpty()){
            try{
                update updateCases;
            }
            catch(Exception ex){
                //throw new AuraHandledException(ex.getMessage());
                //adderror('Your Message');\
                for(case c: newMap.values()){
                    c.adderror(ex.getMessage());
                }
            }
        } 
    } 
    
    public static void caseDeleteValidation(List<Case> oldCases){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName);
        for(case cs : oldCases){
            if(profileName != 'System Administrator'){
                cs.addError('You are not allowed to delete case. Please contact system administrator');
            }
        }
    }
    
    //Method Name: SendClosedCaseEmail
    //Description: Send an email to person accounts once Arkan cases are closed.
    //Author: Sreelakshmi SK
    public static void SendClosedCaseEmail(List<Case> trgNew,map<Id,Case> trgOldMap){
        OrgWideEmailAddress owa = [select id, Address from OrgWideEmailAddress where Address =: System.Label.Orgwide_NoReplay];
        //EmailTemplate emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName='Arkan_Case_Closed_Email_Template'];        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
        for(Case ca : [select id,casenumber,Account.PersonEmail,Status, RecordType.DeveloperName, Account.Name from case where Id=:trgNew]){
            if(ca.status=='Closed' && trgOldMap.get(ca.Id).Status != ca.status && ca.Account.PersonEmail != null && (ca.RecordType.DeveloperName=='Vehicle_Breakdown' || ca.RecordType.DeveloperName=='Vehicle_Device_Issue' || ca.RecordType.DeveloperName=='Vehicle_Visual_Defect')){
                //Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                EmailTemplate emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName='Arkan_Case_Closed_Email_Template'];
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate.Id,null,ca.Id);
                email.setTemplateId(emailTemplate.Id);
                String[] toAddresses = new String[] {ca.Account.PersonEmail};
                    email.setToAddresses(toAddresses);
                email.setOrgWideEmailAddressId(owa.id);
                email.setSaveAsActivity(false);
                email.setTargetObjectId(userinfo.getUserId());
                emails.add(email); 
            }
        }
        try{
            // Send the emails 
            Messaging.sendEmail(emails);
        }catch(Exception e) {
            system.debug(e.getMessage());
        }
    }
    
    //Method Name: SendCaseCreationEmail
    //Description: Send an email to person accounts once arkan cases are created.
    //Author: Sreelakshmi SK
    public static void SendCaseCreationEmail(List<Case> trgNew){
        // Get all cases that is created newly 
        OrgWideEmailAddress owa = [select id, Address from OrgWideEmailAddress where Address =: System.Label.Orgwide_NoReplay];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
        for(Case ca : [select id,casenumber,Account.PersonEmail,RecordType.DeveloperName, Status from case where Id=:trgNew]){
            if(ca.Account.PersonEmail != null && (ca.RecordType.DeveloperName=='Vehicle_Breakdown' || ca.RecordType.DeveloperName=='Vehicle_Device_Issue' || ca.RecordType.DeveloperName=='Vehicle_Visual_Defect')){
                //Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                EmailTemplate emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName= 'Arkan_Case_Creation_Email_Template'];
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate.Id,null,ca.Id);
                email.setTemplateId(emailTemplate.Id);
                String[] toAddresses = new String[] {ca.Account.PersonEmail};
                    System.debug('ToAddress '+ toAddresses);
                email.setToAddresses(toAddresses);
                email.setOrgWideEmailAddressId(owa.id);
                email.setSaveAsActivity(false);
                email.setTargetObjectId(userinfo.getUserId());
                emails.add(email); 
            }
        }
        try{
            // Send the emails 
            Messaging.sendEmail(emails);
        }catch(Exception e) {
            system.debug(e.getMessage());
        }
    }
    
    //Method Name         : SendFeedbackEmail
    //Description         : Survey Email after case closure -- Email sent only if contact email field not empty and skipped for all ESE case record types and cases with subject 'Arkani Request'
    //Author              : Sreelakshmi SK
    //Created Date        : 9 May 23
    //Last Modified by    : Sreelakshmi SK
    //Last modified Date  : 13 June 23
    public static void SendFeedbackEmail(List<Case> trgNew,map<Id,Case> trgOldMap){ 
        List<Survey__c>survey=new List<Survey__c>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress owa = [select id, Address from OrgWideEmailAddress where Address =: System.Label.Orgwide_NoReplay]; 
        for(Case ca : [select id,casenumber,Account.PersonEmail,Status, RecordType.DeveloperName, Account.Name,ContactEmail,Subject,Created_By_Profile__c from case where Id=:trgNew]){
            // Added case record types-- Sreelakshmi SK 11/5/23
            // Added condition to check if contact email is null, subject is Arkani Request and  record types transport and leasing  to exclude ESE case record types ---- Sreelakshmi SK 13/6/23
            if(ca.status=='Closed' && trgOldMap.get(ca.Id).Status != ca.status && ca.ContactEmail != null && ca.Subject!='Arkani Request' && ca.RecordType.DeveloperName!='Handicap_Services_Transport_or_Nanny_Request' && ca.RecordType.DeveloperName!='Request_for_the_Companian_Handicap_Transportation' && ca.RecordType.DeveloperName!='Requests_for_trips_activities_events' && ca.RecordType.DeveloperName!='Growth_Request' && ca.RecordType.DeveloperName!='Request_for_the_awareness_sessions'  &&  ca.Created_By_Profile__c!='T&L - Account Manager' && ca.RecordType.DeveloperName!='Accident_Emergency_Transport_and_Leasing'
               && ca.RecordType.DeveloperName!='Add_Service_TL'  && ca.RecordType.DeveloperName!='Cancel_Services_TL' && ca.RecordType.DeveloperName!='Driver_Complaint_TL' && ca.RecordType.DeveloperName!='Feedback_and_appreciation_Transport_and_Leasing' && ca.RecordType.DeveloperName!='Financial_Services_Transport_and_Leasing'  && ca.RecordType.DeveloperName!='Inquiry_and_Notices_Transport_and_Leasing' 
               && ca.RecordType.DeveloperName!='New_Business_Transport_and_Leasing' && ca.RecordType.DeveloperName!='Online_Services_TL'&& ca.RecordType.DeveloperName!='Request_Transport_and_Leasing'&& ca.RecordType.DeveloperName!='Safety_Issues_TL'&& ca.RecordType.DeveloperName!='Service_Complaint_TL'&& ca.RecordType.DeveloperName!='Service_Environment_Transport_and_Leasing'
               && ca.RecordType.DeveloperName!='Service_Quality_TL' && ca.RecordType.DeveloperName!='Staff_Behavior_Transport_and_Leasing' && ca.RecordType.DeveloperName!='Theft_Transport_and_Leasing'&& ca.RecordType.DeveloperName!='Traffic_Violation_Transport_and_Leasing')
            {
                EmailTemplate emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName='Survey_FeedBack_Email'];
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate.Id,null,ca.Id);
                email.setTemplateId(emailTemplate.Id);
                String[] toAddresses = new String[] {ca.ContactEmail};
                    email.setToAddresses(toAddresses);
                email.setOrgWideEmailAddressId(owa.id);
                email.setSaveAsActivity(false);
                //email.setTargetObjectId(userinfo.getUserId());
                emails.add(email); 
            }
            // Added condition to check if contact email is null, subject is Arkani Request and  record types transport and leasing and send email attachments and survey feed back email t&l
            else if (ca.status=='Closed' && trgOldMap.get(ca.Id).Status != ca.status && ca.ContactEmail != null  &&
                     ca.Subject!='Arkani Request' && (ca.RecordType.DeveloperName=='Accident_Emergency_Transport_and_Leasing' || ca.RecordType.DeveloperName=='Add_Service_TL' || ca.RecordType.DeveloperName=='Cancel_Services_TL' || ca.RecordType.DeveloperName=='Driver_Complaint_TL'
                                                      || ca.RecordType.DeveloperName=='Feedback_and_appreciation_Transport_and_Leasing' || ca.RecordType.DeveloperName=='Financial_Services_Transport_and_Leasing' || ca.RecordType.DeveloperName=='Inquiry_and_Notices_Transport_and_Leasing' 
                                                      || ca.RecordType.DeveloperName=='New_Business_Transport_and_Leasing' || ca.RecordType.DeveloperName=='Online_Services_TL' || ca.RecordType.DeveloperName=='Request_Transport_and_Leasing' || ca.RecordType.DeveloperName=='Safety_Issues_TL'
                                                      || ca.RecordType.DeveloperName=='Service_Complaint_TL' || ca.RecordType.DeveloperName=='Service_Environment_Transport_and_Leasing' || ca.RecordType.DeveloperName=='Service_Quality_TL' || ca.RecordType.DeveloperName=='Staff_Behavior_Transport_and_Leasing'
                                                      || ca.RecordType.DeveloperName=='Theft_Transport_and_Leasing' || ca.RecordType.DeveloperName=='Traffic_Violation_Transport_and_Leasing'))
            {
                List<ContentDocumentLink> attachments = [SELECT Id, LinkedEntityId, ContentDocumentId 
                                                         FROM ContentDocumentLink WHERE LinkedEntityId =: ca.Id];
                //System.debug('Id :'+attachments[0].Id);
                List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();
                if (!attachments.isEmpty()) {
                    for (ContentDocumentLink links : attachments) {
                        List<ContentVersion> fileVersions = [SELECT Id, Title, VersionData, FileType
                                                             FROM ContentVersion 
                                                             WHERE ContentDocumentId = :links.ContentDocumentId
                                                             ORDER BY CreatedDate DESC];
                        for (ContentVersion cv : fileVersions) {
                            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                            efa.setFileName(cv.Title);
                            efa.setBody(cv.VersionData);                                    
                            if (cv.FileType == 'PDF') {
                                efa.setContentType('application/pdf');
                            } else if (cv.FileType == 'PNG') {
                                efa.setContentType('image/png');
                            } else if (cv.FileType == 'JPEG') {
                                efa.setContentType('image/jpeg');
                            } else {
                                efa.setContentType('application/octet-stream');
                            }
                            emailAttachments.add(efa);
                        }
                    }
                }
                //System.debug('emailAttachments :'+emailAttachments);
                EmailTemplate emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName='Survey_FeedBack_Email_t_L'];
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate.Id,null,ca.Id);
                email.setTemplateId(emailTemplate.Id);
                String[] toAddresses = new String[] {ca.ContactEmail};
                    email.setToAddresses(toAddresses);
                email.setOrgWideEmailAddressId(owa.id);
                email.setSaveAsActivity(false);
                email.setFileAttachments(emailAttachments);//added 31-03-2024
                //email.setTargetObjectId(userinfo.getUserId());
                emails.add(email); 
            }
            // Added condition to check if contact email is null, subject is Arkani Request and  record types created by profile ='T&L - Account Manager'
            else if(ca.status=='Closed' && trgOldMap.get(ca.Id).Status != ca.status && ca.ContactEmail != null && ca.Created_By_Profile__c=='T&L - Account Manager' &&
                    ca.Subject!='Arkani Request')
            {
                //sending attachments with emil case created by profile T&L - Account Manager and record types are t&L  
                List<ContentDocumentLink> attachments = [SELECT Id, LinkedEntityId, ContentDocumentId 
                                                         FROM ContentDocumentLink WHERE LinkedEntityId =: ca.Id];
                //System.debug('Id :'+attachments[0].Id);
                List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();
                if (!attachments.isEmpty()) {                              
                    for (ContentDocumentLink links : attachments) {
                        List<ContentVersion> fileVersions = [SELECT Id, Title, VersionData, FileType
                                                             FROM ContentVersion 
                                                             WHERE ContentDocumentId = :links.ContentDocumentId
                                                             ORDER BY CreatedDate DESC];
                        for (ContentVersion cv : fileVersions) {
                            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                            efa.setFileName(cv.Title);
                            efa.setBody(cv.VersionData);
                            if (cv.FileType == 'PDF') {
                                efa.setContentType('application/pdf');
                            } else if (cv.FileType == 'PNG') {
                                efa.setContentType('image/png');
                            } else if (cv.FileType == 'JPEG') {
                                efa.setContentType('image/jpeg');
                            } else {
                                efa.setContentType('application/octet-stream');
                            }
                            emailAttachments.add(efa);
                        }
                    }
                }
                //System.debug('emailAttachments :'+emailAttachments);
                EmailTemplate emailTemplate = [Select Id,name,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where DeveloperName='Survey_FeedBack_Email_t_L'];
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplate.Id,null,ca.Id);
                email.setTemplateId(emailTemplate.Id);
                String[] toAddresses = new String[] {ca.ContactEmail};
                    email.setToAddresses(toAddresses);
                email.setOrgWideEmailAddressId(owa.id);
                email.setSaveAsActivity(false);
                email.setFileAttachments(emailAttachments);//added 31-03-2024
                //email.setTargetObjectId(userinfo.getUserId());
                emails.add(email); 
            }
        }
        try{
            Messaging.sendEmail(emails);
        }catch(Exception e) {
            system.debug(e.getMessage());
        }
    }
}