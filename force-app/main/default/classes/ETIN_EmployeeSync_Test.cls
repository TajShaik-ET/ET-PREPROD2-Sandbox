@isTest
public class ETIN_EmployeeSync_Test {
    
    @isTest
    public static void unitTest1()
    {
        Test.setMock(HttpCalloutMock.class, new EmpSyncMock_cls());
        EmpSyncMock_cls.unitTest1();
        ETIN_EmployeeSync.syncWithERP('1234');
        
    }
    
}