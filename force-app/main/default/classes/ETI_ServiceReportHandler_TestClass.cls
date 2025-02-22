/********************************************************************************************************
* @author		Smaartt
* @description	Trigger Handler to send Inspection Test Result and Inspection Certificate in mail when the inspection Completed and Report is generated.
  Associated Trigger : ETI_ServiceReportTrigger
  Test Class 		 : ETI_SendReschedule_Mail_to_Customer_test

*********************************************************************************************************/
@isTest
public class ETI_ServiceReportHandler_TestClass {
    
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
        appnt.FSL__Auto_Schedule__c = false;
        appnt.RecordTypeId = appntrecordTypeId;
        appnt.SchedStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
            datetime enddate = wo.StartDate !=null ? wo.StartDate.addDays(1) :Date.today().addDays(1);
        appnt.EarliestStartTime = wo.StartDate !=null ? (wo.StartDate ):(Date.today());
            appnt.DueDate =  wo.StartDate !=null ? wo.StartDate.addDays(2) :Date.today().addDays(2);
        appnt.SchedEndTime = enddate;
        
        insert appnt;
    }
    
    @isTest static void testMethod1() {
        workOrder wo = [select id,Subject from workOrder where Subject='Inspection' ];
        ServiceAppointment appnt = [select id, status, recordtype.developername from ServiceAppointment where status = 'Scheduled'];
        // Create service Report Programatically
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = WO.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        Test.startTest();
        Integer emailbefore = Limits.getEmailInvocations(); 
        system.debug('emails before = '+ emailbefore );
        ServiceReport sr = new ServiceReport();
        //sr.ContentVersionDocumentId = documents[0].Id ;
        sr.DocumentBody = Blob.valueOf('Test Content') ; 
        sr.DocumentContentType ='application/pdf';
        sr.DocumentName='Test';
        sr.ParentId = appnt.Id ; 
        insert sr ;
        Integer emailAfter = Limits.getEmailInvocations();
        system.debug('emails after = '+ emailAfter );
        //system.assertNotEquals(emailbefore,emailAfter,'should have Increased');
        Test.stopTest();
    }
}