@isTest
public class ETI_Batch_Vehicle_ServiceTest {
    private static testmethod void testmethodInspection(){
        
        ETI_Batch_Vehicle_Service etbb = new ETI_Batch_Vehicle_Service('23232','2323');
       
        
        test.startTest();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Database.executeBatch(etbb);
        Test.stopTest();
    }
    
}