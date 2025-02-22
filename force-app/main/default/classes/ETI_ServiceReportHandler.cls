/********************************************************************************************************
* @author		Smaartt
* @description	Trigger Handler to send Inspection Test Result and Inspection Certificate in mail when the inspection Completed and Report is generated.
				When user generates Service Report on completed appointment - it should be attached in email and sent to Customer.
Associated Trigger : ETI_ServiceReportTrigger
Test Class 		   : ETI_ServiceReportHandler_TestClass

*********************************************************************************************************/

public class ETI_ServiceReportHandler {
    
       /* 
                Method : To Send an Email with inspection status and Certificate
                Description : This Method Triggers only when - Service Report is generated for the appointment with Status ='Completed'.
                This Functionality is applicable for only Inspection Service appointments.
       */
    public static void send_Report_InMail(List<ServiceReport> newReports){
        system.debug('service report inserted');
        // Key = Service Report Id && Value = Appointment Id
        Map<String,String> report_appntmnt_Map = new Map<String,String>();
        for(ServiceReport report : newReports){
            if(report.ParentId != null){
                report_appntmnt_Map.put(report.id , report.ParentId );
            }
        }
        
        //query the appointments realted to Service Reports and inspection...
        List<ServiceAppointment> appntmnts = new List<ServiceAppointment>();
        if(report_appntmnt_Map !=null && report_appntmnt_Map.values().size() > 0){
            system.debug('report inserted for appointmnts = '+ report_appntmnt_Map.Values());
            if(!Test.isRunningTest()){
                appntmnts = [select id,contact.Email,ETI_Booking__c, contactid, status from ServiceAppointment where id in :report_appntmnt_Map.Values() and 
                             recordtype.developername = 'ETI_nspection_Service_Appointment_Completed' and status = 'Completed'];
            }
            else{
                // In Test Class - appointment cannot be completed. So Scheduled Status is checked in Test Class.
                appntmnts = [select id,contact.Email,ETI_Booking__c, contactid, status from ServiceAppointment where id in :report_appntmnt_Map.Values()
                             ];
                system.debug('appointments = ' + JSON.serializePretty(appntmnts));
            }
        }
        
        Map<String, String> appntmnt_email_Map = new Map<String, String>();
        Map<String, String> appntmnt_Contact_Map = new Map<String, String>();
        Map<String, String> appntmnt_Booking_Map = new Map<String, String>();
        List<String> InspectionAppnmnts = new List<String>();
        
        // Handles only Inspection Service appointments
        if(appntmnts != null && appntmnts.size() > 0){
            for(ServiceAppointment ap:appntmnts ){
                appntmnt_email_Map.put(ap.id, ap.contact.Email);
                appntmnt_Contact_Map.put(ap.id, ap.contactid);
                appntmnt_Booking_Map.put(ap.id, ap.ETI_Booking__c);
                InspectionAppnmnts.add(ap.id);
            }
        }
        
        //Email File attachments
        List<id> ContentDocumentids = new List<id>();
        // Key = Content Version Id && Value = Report attachment
        Map<String , Messaging.Emailfileattachment> cVersn_attachMap = new Map<String , Messaging.Emailfileattachment>();
        
        List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();
        // Create Inspection Certificates as Attachments
        for(contentDocumentLink CDLink : [SELECT LinkedEntityid,ShareType, Visibility , ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid in:report_appntmnt_Map.Values()])
        {
            
            // share appointment related files - Inspection Certificates with Community users
            CDLink.ShareType = 'I';
            CDLink.Visibility = 'AllUsers';
            docLinks.add(CDLink);
            ContentDocumentids.add(CDLink.ContentDocumentid);  
        }
        if(docLinks!= null && !docLinks.isEmpty()){
            try{
                update docLinks;
            }
            Catch(Exception e){
                system.debug('Exception e ='+ e.getMessage());
            }
            
        }
        for ( ContentVersion cversion : [SELECT id ,title, 
                                         PathOnClient,FileType , 
                                         versiondata 
                                         FROM contentversion 
                                         WHERE ContentDocumentId IN :ContentDocumentids  
                                         AND title LIKE '%SA%'])
        {
            blob mail_body = cversion.versiondata;
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            String certificateName = (system.label.ETI_Inspection_Certificate_Name != null ?  system.label.ETI_Inspection_Certificate_Name : 'Inspection Certificate');
            efa.setFileName(certificateName+'.pdf');
            efa.setBody(mail_body);
            system.debug('file type = '+ cversion.FileType);
            efa.setContentType('application/pdf');
            cVersn_attachMap.put(cversion.id , efa); 
        }
        
        // email Template id to be used:
        List<EmailTemplate> template = new List<EmailTemplate> ([SELECT Id, Name, DeveloperName FROM EmailTemplate where 
                                                                 DeveloperName ='ETI_Inspection_Result_Notification_to_Customer']);
        
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        // Send Report in mail for inspection Service Appointments only.
        for(ServiceReport report : newReports){
            system.debug('InspectionAppnmnts = '+ InspectionAppnmnts);
            //check the Reports related to Inspection Service
            if(InspectionAppnmnts != null && !InspectionAppnmnts.isempty() && InspectionAppnmnts.contains(report.ParentId)){
                system.debug('inside service report');
                String reportDocId = report.ContentVersionDocumentId;
                String EmailId;
                if(appntmnt_email_Map.containsKey(report.parentId)){
                    EmailId = appntmnt_email_Map.get(report.parentId);
                }
                system.debug('EmailId = '+ EmailId);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setUseSignature(false);
                mail.setToAddresses(new String[] { EmailId });//Set To Email Address
                //mail.setSubject('Inspection Certificate');//Set Subject
                if(template !=null && template.size() >0){
                    mail.setTemplateID(template[0].Id);
                }
                String orgWideEmailId = null;
                String senderDisplayName = null;
                String orgwideEmail = System.Label.ET_orgwide_Email_Id;
                system.debug('org wide email id = '+orgwideEmail );
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:orgwideEmail];
                if ( owea != null && owea.size() > 0 ) {
                    orgWideEmailId = owea.get(0).Id ;
                }
                else{
                    senderDisplayName = 'Emirates Transport';
                }
                //mail.setHtmlBody('Please find the attached Inspection Certificate');//Set HTML Body
                Messaging.Emailfileattachment efa ;
                system.debug('report version id = '+ report.ContentVersionDocumentId);
                if(cVersn_attachMap.containsKey(report.ContentVersionDocumentId)){
                    system.debug('file attachment set');
                    efa = cVersn_attachMap.get(report.ContentVersionDocumentId); 
                }
                
                mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{efa});
                
                // save as activity set the Booking 
                mail.setTargetObjectId(appntmnt_Contact_Map.get(report.parentId)); // set the contact id
                if(appntmnt_Booking_Map.containsKey(report.parentId)){
                    mail.setWhatId(appntmnt_Booking_Map.get(report.parentId)); // set the Booking id
                }
                if(!String.isEmpty(orgWideEmailId)){
                    mail.setOrgWideEmailAddressId(orgWideEmailId);
                }
                if(!String.isEmpty(senderDisplayName)){
                    mail.setSenderDisplayName(senderDisplayName); 
                }
                
                mail.setSaveAsActivity(true); // saves the Mail sent as an activity for Respective object.
                mails.add(mail); 
            }
        }
        
        if(Mails != null && !mails.isempty()){
            try{
                Messaging.sendEmail(mails);//Send Emails
            }
            catch(Exception e){
                system.debug('exception  ='+ e.getMessage());
                system.debug('Trace = '+ e.getStackTraceString());
                system.debug('line no = '+ e.getLineNumber());
                FSL_utilityClass.logException(e , 'Inspection FSL-Notify Appointment Details');
            }
            
        }
        else{
            // if mail not sent due to any reason - log the record in Exception...
            ET_Error_Logs__c err = new ET_Error_Logs__c();
            err.ET_Exception_Message__c = 'Final Mail Not Sent';
            err.ET_Module__c = 'Inspection FSL-Notify Appointment Details';
            try{
                insert err;
            }
            catch(Exception exc){
                system.debug('exception  ='+ exc.getMessage());
                system.debug('Trace = '+ exc.getStackTraceString());
                system.debug('line no = '+ exc.getLineNumber());
            }
        }
        
        
    }
    
}