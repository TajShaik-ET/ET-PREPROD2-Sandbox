@isTest
public class ETI_CallRefundServiceScheduledTest {
    
    private static testmethod void testmethodRefund(){
        ETI_TestUtilityClass.testUserCreation();
        ETI_TestUtilityClass.testAccountCreation();
        ETI_TestUtilityClass.testCustomerVehicle();
        ETI_TestUtilityClass.testServiceRequest();
        ETI_TestUtilityClass.testBookings();
        ETI_TestUtilityClass.tesPaymentData();
        ETI_TestUtilityClass.tesRefundData();
    
        test.startTest();
        ETI_CallRefundServiceScheduled etbb =new ETI_CallRefundServiceScheduled(new set<id>{ETI_TestUtilityClass.objRefund.Id});
        String sch ='0 48 * * * ?'; 
        System.schedule('Schedule CallRefundServiceScheduled', sch,etbb);
        ETI_CallRefundServiceBatch etbb1 =new ETI_CallRefundServiceBatch(new set<id>{ETI_TestUtilityClass.objRefund.Id});
        Database.executeBatch(etbb1,1);
        ETI_CallRefundServiceBatch.utilityMethod();
        test.stopTest();
    }
}