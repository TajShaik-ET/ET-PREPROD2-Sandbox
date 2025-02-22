/********************************************************************************************************
* @author		Smaartt
* @description	Test Class for 'ETI_appointmentTriggerHandler'
*********************************************************************************************************/
@isTest
public class ETI_appointmentTriggerTestClass {
    
    // Create Test Data 
    @testSetup static void setup() {
        
        // Contact
        Contact con = new contact();
        con.lastname ='Mani';
        insert con;
        
        // work Type
        workType wType = new workType();
        //Id workType_recordTypeId = Schema.SObjectType.workType.getRecordTypeInfosByDeveloperName().get('ETI_Inspection_work_Type').getRecordTypeId();
        wType.ETI_Due_Date__c = 7;
        wType.DurationType = 'Minutes';
        wType.Name = 'Inspection';
        wType.EstimatedDuration = 30;
        //wType.RecordTypeId = workType_recordTypeId;
        insert wType;
        
        // workorder
         workOrder wo = new workOrder();
        Id recordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Inspection_Work_Order').getRecordTypeId();
        wo.StartDate = Datetime.Now(); 
        wo.Subject = 'Inspection';
        wo.ETI_Schedule_Appointment__c = true;  
        wo.Street  = 'Alfahidhi';
        wo.City = 'Dubai';
        wo.PostalCode = '531116';
        wo.Country ='United Arab Emirates';
        wo.ContactId = con.Id;
        wo.WorkTypeId = wType.Id;
        
        insert wo;
        
        
        // Create Service Appointment
        ServiceAppointment appnt = new ServiceAppointment();
        appnt.ParentRecordId = wo.Id;
        appnt.status = 'None';
        appnt.SchedStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
        datetime enddate = wo.StartDate !=null ? wo.StartDate.addDays(1) :Date.today().addDays(1);
        appnt.EarliestStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
        appnt.DueDate =  wo.StartDate !=null ? wo.StartDate.addDays(2) :Date.today().addDays(2);
        appnt.SchedEndTime = enddate;
        String appntmntRecTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByDeveloperName().get('Inspection_Service_Appointment').getRecordTypeId();
        appnt.RecordTypeId = appntmntRecTypeId;
        appnt.ETI_isScheduleMailSent__c = false;
        appnt.ContactId = con.Id;
      
        insert appnt;
    }
      
    // to cover method for - Send email to Customer with appointment details
    @isTest static void testMethod1(){
        List<ServiceAppointment> appnt = new List<ServiceAppointment>([select id, status from ServiceAppointment where status ='None']);
        system.debug('status = '+ appnt[0].status);
        appnt[0].status = 'Scheduled';
        update appnt[0];
    }
    
    
}