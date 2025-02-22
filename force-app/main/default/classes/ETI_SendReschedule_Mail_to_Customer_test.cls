@isTest
public class ETI_SendReschedule_Mail_to_Customer_test {
    
    
    // Test Data Setup
    @testSetup static void setup() {
        Contact con = new Contact();
        con.LastName = 'Manikanta';
        con.Email = 'manikanta.sinisetti@gmail.com';
        insert con;
        
        // Create work Orders
        workOrder wo = new workOrder();
        Id recordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Inspection_Work_Order').getRecordTypeId();
        wo.StartDate = Datetime.Now(); 
        wo.Subject = 'Inspection';
        wo.ContactId = con.id;
        //wo.ETI_Schedule_Appointment__c = true;  
        wo.Street  = 'Alfahidhi';
        wo.City = 'Dubai';
        wo.PostalCode = '531116';
        wo.Country ='United Arab Emirates';
        
        insert wo;
        
        // Create Service Appointment
        ServiceAppointment appnt = new ServiceAppointment();
        String appntrecordTypeId = Schema.SObjectType.ServiceAppointment.getRecordTypeInfosByDeveloperName().get('ETI_nspection_Service_Appointment_Completed').getRecordTypeId();
        appnt.ParentRecordId = wo.Id;
        appnt.status = 'Scheduled';
        appnt.ContactId = con.id;
        appnt.ETI_isScheduleMailSent__c = True;
        appnt.FSL__Auto_Schedule__c = false;
        appnt.RecordTypeId = appntrecordTypeId;
        appnt.SchedStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
            datetime enddate = wo.StartDate !=null ? wo.StartDate.addDays(1) :Date.today().addDays(1);
        appnt.EarliestStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
            appnt.DueDate =  wo.StartDate !=null ? wo.StartDate.addDays(2) :Date.today().addDays(2);
        appnt.SchedEndTime = enddate;
        
        insert appnt;
    }
    
    @isTest static void testMethod1(){
        ServiceAppointment appnt = [select id from ServiceAppointment where status ='Scheduled'];
        List<String> appntIds = new List<String>();
        appntIds.add(appnt.Id);
        ETI_SendReschedule_Mail_to_Customer ReschMail = new ETI_SendReschedule_Mail_to_Customer();
        ReschMail.action(appntIds, null, null, null);
    }
}