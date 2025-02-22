@isTest
public class ET_DeleteIntegrationLogsBatchTest {

    private static testmethod void testmethodExceptionLogs(){
        test.startTest();
        Integration_Log__c newrec=new Integration_Log__c(Source_System__c='test');
        insert newrec;
        ET_DeleteIntegrationLogsBatch intgBatch=new ET_DeleteIntegrationLogsBatch();
        String sch = '0 0 23 * * ?';
        system.schedule('Test DeleteIntegrationLogs', sch, intgBatch);
        test.stopTest();
    }
}