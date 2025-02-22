@isTest
        private class ReportExporterTest {
       // CRON expression: midnight on March 15. Because this is a test, job executes immediately after Test.stopTest().
       // =========================================================================
       public static String CRON_EXP = '0 0 0 15 10 ? 2023';
       static testmethod void test() {
          Report_Exporter__c e = new Report_Exporter__c();
            e.Name = 'Test Exporter Record';
            e.Report_ID__c = '00O3z000009I6xt';
            e.Attachment_Name__c = 'Test Attachment Name.xlsx';
            e.Email_Subject__c = 'Test Email Subject';
            e.Email_Body__c = 'Test Email Body';
            e.Email_Recipients__c = 'abc@abc.com';
            e.Frequency__c='Weekly';
            e.Weekly_Days__c='Friday';
            //e.Schedule_Time__c='Batch2-1AM';
          Insert(e);
           
          Test.startTest();
     
          // Schedule the test job
          String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP, new ReportExporter());
              
          // Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
     
          // Verify the expressions are the same
         System.assertEquals(CRON_EXP,ct.CronExpression);
     
          // Verify the job has not run
         System.assertEquals(0, ct.TimesTriggered);
     
          // Verify the next time the job will run
          //System.assertEquals('2022-10-15 00:00:00',
           //  String.valueOf(ct.NextFireTime));
          Test.stopTest();
     
       }
    }