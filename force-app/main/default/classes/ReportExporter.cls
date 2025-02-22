/* 
** Author: Gonsalvas
** Created date: 22-08-2022
** Description: To schedule and send reports to users who doesn't have any salesforce user account
** Janardhan - 13-02-2023 - Added Org wide email address with custom label
*/
global class ReportExporter implements System.Schedulable{
global void execute(SchedulableContext sc) {
    ReportExporter.rptscheduler();
    }
    
@future(callout=true) 
public static void rptscheduler()
{  
   Map <ID,Blob> attachbody=new Map <ID,Blob>();
   List<Report_Exporter__c> exportList = new List<Report_Exporter__c>{};
 exportList = [Select Id, Name, Report_ID__c, Attachment_Name__c,Email_Body__c, Email_Subject__c, Email_Recipients__c, Frequency__c, Weekly_Days__c, Monthly_Days__c from Report_Exporter__c ];
  
    ReportExporter.sendAndAttachcsv(exportList);
 }
 
 public static void sendAndAttachcsv(List<Report_Exporter__c> exportList){
   Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
   Date d = Date.today();
   Date firstDate = d.toStartOfMonth();
   Date lastDay = firstDate.addDays(Date.daysInMonth(d.year(), d.month())-1);
   List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
   OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.CICO_OrgWideEmail];

   for(Report_Exporter__c e : exportList)
    {   
         
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        ApexPages.PageReference report = new ApexPages.PageReference('/servlet/PrintableViewDownloadServlet?isdtp=p1&reportId=' + e.Report_ID__c);
        blob content;
        if(Test.isRunningTest()) { 
         content = blob.valueOf('Unit.Test');
        } else {
         content = report.getContent();
        }

        // Blob content = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : report.getContent();
        Boolean process = Test.isRunningTest() ? true : false;
       

        process = e.Frequency__c == 'Weekly' && e.Weekly_Days__c.contains(dt.format('EEEE')) ? true : process;
        system.debug('Calling_Systemweekly'+process);
        process = e.Frequency__c == 'Monthly' && (e.Monthly_Days__c == String.valueOf(d.day()) || e.Monthly_Days__c == 'last' && d == lastDay || lastDay.day() <= Integer.valueOf(e.Monthly_Days__c)) ? true : process;
        system.debug('Calling_System1'+process);
       if(process)
       {
          System.debug('Starting message processing for: ' + e.Name);
          attachment.setFileName(e.Attachment_Name__c);
          attachment.setBody(content);
          //attachment.setContentType('text/csv');
           attachment.setContentType('application/vnd.oasis.opendocument.spreadsheet');
          Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
          message.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
           if ( owea != null && owea.size() > 0 ) {
               message.setOrgWideEmailAddressId(owea.get(0).Id);
           }
           
          message.setSubject(e.Email_Subject__c);
          message.setPlainTextBody(e.Email_Body__c);
          String[] emailRecipients = e.Email_Recipients__c.split(',');
          message.setToAddresses(emailRecipients);
         // Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
          System.debug('Completed message processing for: ' + e.Name);
          mails.add(message);
        }
     }
     Messaging.sendEmail(mails);
 }

}