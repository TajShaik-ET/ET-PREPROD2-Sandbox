global class ETI_SendReschedule_Mail_to_Customer implements FSL.CustomGanttServiceAppointmentAction {
    /* Method 	     : action
	   Description   : Send Revised Appointment Details when appointment is Rescheduled and Send Revised Email button is clicked on Gantt chart.
                     appointments in Scheduled / dispatched status - allowed to reschedule.
                     If send Email Button clicked on any appointment with any status - Show appropriate message to Admnin.

	  Error/warning Handling : In Case of error - Return error in 'message' attribute...
	*/
    
    global String action(List<Id> serviceAppointmentsIds, Datetime ganttStartDate, Datetime ganttEndDate, Map<String, Object> additionalParameters) {
        
        Id recordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByDeveloperName().get('Inspection_Service_Appointment').getRecordTypeId();
        
        List<ServiceAppointment> saList =new List<ServiceAppointment>([SELECT id,ContactId,ETI_send_reschedule_Mail__c,ETI_isScheduleMailSent__c, AppointmentNumber FROM ServiceAppointment 
                                                                       WHERE Id in : serviceAppointmentsIds AND Status !='Completed' 
                                                                       AND recordtypeId =:recordTypeId]) ;
        String message ='' ;
        if(saList != null && saList.size() > 0){
            for(ServiceAppointment sa :saList ){
                if(sa.ETI_isScheduleMailSent__c){
                    //sa.ETI_send_reschedule_Mail__c = true; // when appointment scheduled to some available resource - appointment info sent to customer. This checkbox is checked 
                    //while sending email to Customer. 
                    String template = 'ETI_Notify_Customer_with_Revised_Appointment_Information';
                    String targetId = sa.ContactId;
                    String whatId = sa.id;
                    String module = 'Inspection FSL-Notify Appointment Details';
                    String orgWideEmailId = null;
                    String senderDisplayName = null;
                    String orgwideEmail = System.Label.ET_orgwide_Email_Id;
                    if(sa.contactId == null){
                        message = 'Mail sent Failed! Appointment does not have any contact';
                    }
                    system.debug('org wide email id = '+orgwideEmail );
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:orgwideEmail];
                    if ( owea != null && owea.size() > 0 ) {
                        orgWideEmailId = owea.get(0).Id ;
                    }
                    else{
                        senderDisplayName = 'Emirates Transport';
                    }
                    //FSL_utilityClass.sendEmail(emails, emailTemplateName, whatId, targetId, saveAsActity, orgWideEmail);
                    boolean ismailsent = FSL_utilityClass.sendEmail(null, template, whatId, targetId, true, orgWideEmailId,senderDisplayName,module);
                    if(ismailsent){
                        message = 'Mail sent with New Appointment details to customer';
                    }
                    else{
                        message = 'Mail Sent Failed! Please check with Support';
                    }
                    
                }
                else{
                    message = 'Mail Sent Failed! Please check with Support';
                }
                system.debug('appointment = '+ sa.id);
            }
            try{
                update saList;
            }
            catch(Exception e){
                system.debug('Exception ='+ e.getMessage());
                system.debug('Exception Trace='+ e.getStackTraceString());
                system.debug('Exception line='+ e.getLineNumber());
                FSL_utilityClass.logException(e , 'Inspection FSL');
            }
            
        }
        else{
            message = 'This Appointment is already Completed. It cannot be Rescheduled.';
        }
        
        return message;
    }
    
    
    
}