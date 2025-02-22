@isTest
public class ET_DeleteExceptionLogsBatchTest {

    private static testmethod void testmethodExceptionLogs(){
        test.startTest();
        Exception_Log__c newrec=new Exception_Log__c(Application_Name__c='test');
        insert newrec;
        ET_DeleteExceptionLogsBatch excBatch=new ET_DeleteExceptionLogsBatch();
        String sch = '0 0 23 * * ?';
        system.schedule('Test DeleteExceptionLogs', sch, excBatch);
        test.stopTest();
    }
}