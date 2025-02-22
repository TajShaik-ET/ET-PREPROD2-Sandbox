@isTest
public class ETI_BulkPayment_AWAIT_3DS_ScheduleTest {
  public static testMethod void testschedule() {
		Test.StartTest();
		ETI_BulkPayment_AWAIT_3DS_Schedule testsche = new ETI_BulkPayment_AWAIT_3DS_Schedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}