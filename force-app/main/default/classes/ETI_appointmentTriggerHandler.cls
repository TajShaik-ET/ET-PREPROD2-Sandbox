/********************************************************************************************************
* @author		Smaartt
* @description	Method to create Service appointment with predefined details. Like - Scheduling Policy, due date and record type
* Related components : ETI_AppointmentTrigger
* Test Class 		 : ETI_appointmentTriggerTestClass
*********************************************************************************************************/

/* Method 	   : ETI_appointmentTriggerHandler
   Description : Exceuted in Before Trigger to pre populate few Values before creation of appointment
   Default Values      : Scheduling Policy, work type, due date
   From Work Order     : EarliestStartTime, Appointment Duration, Booking, auto Schedule, Scheduling Policy.

*/

public class ETI_appointmentTriggerHandler {
    public static void populateValuesinAppointment(List<ServiceAppointment> newAppntmnts){
        // get the work order ids from appointments
        List<String> wOrderIds = new List<String>();
        // get the recordtypeId for appointment of Inspection Type & do opeations for inspection Type only
        Id recordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByDeveloperName().get('Inspection_Service_Appointment').getRecordTypeId();
        
        for(ServiceAppointment appntmnt : newAppntmnts){
            system.debug('appntmnt = ' + JSON.serializePretty(appntmnt));
            system.debug('appntmnt.RecordTypeId = ' + appntmnt.RecordTypeId);
            if(appntmnt.ParentRecordId != null ){
                wOrderIds.add(appntmnt.ParentRecordId);
            }
        }
        
        // get the workOrders & query required fields
        List<workOrder> wOrders = new List<workOrder>();
        
        // filter only inspection work orders
        if(wOrderIds != null && wOrderIds.size() > 0){
            wOrders = [select id, ETI_Schedule_Appointment__c, StartDate, booking__c ,booking__r.Latitude__c , booking__r.Longitude__c,
                       WorkType.durationinminutes
                       from workOrder where id in :wOrderIds AND 
                       RecordType.developername ='Inspection_Work_Order'];
            system.debug('workOrders size = '+ wOrders.size());
        }
        
        //workOrderMap -- Key = workOrderId && Value = WorkOrder record
        Map<id , workOrder> workOrderMap = new Map<id , workOrder>(wOrders);
        
        //get the Scheduling Policy used for inspection module
        List<FSL__Scheduling_Policy__c > policies = new List<FSL__Scheduling_Policy__c>([select id , name from FSL__Scheduling_Policy__c 
                                                                                         where name =: system.label.ETI_Inspection_Scheduling_Policy]);
        String policyId;
        if(policies != null && policies.size() > 0){
            policyId = policies[0].id;
        }
        //get the Due Date from Work Type
        List<workType> Wtypes = new list<workType>([select id , ETI_Due_Date__c from workType where Name =: system.label.ETI_Inspection_work_Type]);
        integer dueDate = 7;
        
        if(Wtypes != null && Wtypes.size() > 0){
            if(Wtypes[0].ETI_Due_Date__c != null){
                dueDate = integer.valueOf(Wtypes[0].ETI_Due_Date__c);
            }
            system.debug('dueDate = '+ dueDate);
        }
        
        // iterate over inserting appointments and populate values before insert
        for(ServiceAppointment appntmnt : newAppntmnts){
            if(workOrderMap.containsKey(appntmnt.ParentRecordId)){
                workorder wo = workOrderMap.get(appntmnt.ParentRecordId);
                appntmnt.EarliestStartTime = wo.StartDate;
                appntmnt.DueDate = wo.StartDate.addDays(dueDate);
                appntmnt.ETI_Booking__c = wo.Booking__c;
                if(wo.WorkType != null && wo.WorkType.durationinminutes != null){
                    appntmnt.Duration = wo.WorkType.durationinminutes;
                    appntmnt.DurationType = 'Minutes';
                }
                appntmnt.RecordTypeId =recordTypeId; // Create appointmens with Inspection Record Type only..
                if(wo.ETI_Schedule_Appointment__c == true){
                    system.debug('in auto Schedule');
                    appntmnt.FSL__Auto_Schedule__c = true;
                    appntmnt.FSL__Scheduling_Policy_Used__c = policyId;
                }
            }
        }
        
    }
    
    /* Method 	   : handleAfterAppointmentInsert
       Description : Send email to Customer with appointment details
       Conditions checking : Status should change to - 'Scheduled' & ETI_isScheduleMailSent__c == false && Inspection Record type
	   Contact is Mandatory in appointment to send an email..
	   Sending email from org wide email id..
	   'ETI_isScheduleMailSent__c ' - This is True - once mail sent is successful.
	*/
    
    public static void handleAfterAppointmentInsert(map<id,ServiceAppointment> oldAppntmnts ,map<id,ServiceAppointment> newAppntmnts ){
        system.debug('after trigger fired');
        List<ServiceAppointment> appList_u = new List<ServiceAppointment>();
        String appntmntRecTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByDeveloperName().get('Inspection_Service_Appointment').getRecordTypeId();
        for(ServiceAppointment app : newAppntmnts.values()){
            String template;
            if(oldAppntmnts.containsKey(app.id)){
                if(oldAppntmnts.get(app.id).Status != app.status && app.status =='Scheduled' && app.ETI_isScheduleMailSent__c == false && app.RecordTypeId == appntmntRecTypeId){
                    system.debug('Conditions matched to fire email');
                    if(app.EarliestStartTime != app.SchedStartTime){
                        template = 'ETI_Notify_Customer_with_Appointment_Information_Diff_Times';
                    }
                    else{
                        template = 'ETI_Notify_Customer_with_Appointment_Information';
                    }
                    
                    String targetId = app.ContactId;
                    String whatId = app.id;
                    String module = 'Inspection FSL-Notify Appointment Details';
                    String orgWideEmailId = null;
                    String senderDisplayName = null;
                    String orgwideEmail = System.Label.ET_orgwide_Email_Id;
                    system.debug('org wide email id = '+orgwideEmail );
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:orgwideEmail];
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if ( owea != null && owea.size() > 0 ) {
                        orgWideEmailId = owea.get(0).Id ;
                    }
                    else{
                        senderDisplayName = 'Emirates Transport';
                    }
                    //FSL_utilityClass.sendEmail(emails, emailTemplateName, whatId, targetId, saveAsActity, orgWideEmail);
                    boolean ismailsent = FSL_utilityClass.sendEmail(null, template, whatId, targetId, true, orgWideEmailId,senderDisplayName,module);
                    if(ismailsent){
                        ServiceAppointment appnt_u = new ServiceAppointment();
                        appnt_u.id = app.id;
                        appnt_u.ETI_isScheduleMailSent__c = true;
                        appList_u.add(appnt_u);
                    }
                    
                }
            }
        }
        
        if(!appList_u.isEmpty()){
            try{
                update appList_u;
            }
            catch(Exception e){
                system.debug('exception  ='+ e.getMessage());
                system.debug('Trace = '+ e.getStackTraceString());
                system.debug('line no = '+ e.getLineNumber());
                FSL_utilityClass.logException(e , 'Inspection FSL');
            }
            
        }
    }
}