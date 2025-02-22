@isTest
public class ETI_BulkCancelBookingsBatchTest {
    private static testmethod void testBulkCancelBookingsBatch(){
        ETI_TestUtilityClass.testUserCreation();
        ETI_TestUtilityClass.testAccountCreation();
        ETI_TestUtilityClass.testCustomerVehicle();
        ETI_TestUtilityClass.testServiceRequest();
        ETI_TestUtilityClass.testBookings();
        test.startTest();
            ETI_BulkCancelBookingsBatch etbb= new ETI_BulkCancelBookingsBatch(new list<Id>{ETI_TestUtilityClass.bookingList[0].Id},'Test Cancel');
            Database.executeBatch(etbb,1);
            String sch ='0 48 * * * ?'; 
            System.schedule('Schedule BulkCancelBookingsBatch', sch,etbb);
        test.stopTest();    
    }
}