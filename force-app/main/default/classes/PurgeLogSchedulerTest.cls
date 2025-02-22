/**
  * @author        Saumil Bapat
  * @date          10/31/2016
  * @description   Test class for PurgeLogs batch jobs
*/
@isTest
private class PurgeLogSchedulerTest {

   // CRON expression: midnight on March 15.
   // Because this is a test, job executes
   // immediately after Test.stopTest().
   public static String CRON_EXP = '0 0 0 15 3 ? 2050';

   
}