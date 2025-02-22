@isTest
public class ETI_BulkPayment_AWAIT_3DS_BatchTest {
    
    
    public static testmethod void AwaitBatch(){
        
        ETST_Payment__c et = new ETST_Payment__c();
        et.ETST_Payment_State__c ='AWAIT_3DS';
        et.ETI_IsUpdatedByBatch__c =false;
        et.ExternalId__c ='0000';
        
        insert et;
        test.startTest();
        ETI_BulkPayment_AWAIT_3DS_Batch ba = new ETI_BulkPayment_AWAIT_3DS_Batch();
        Database.executeBatch(ba,1);
        
        test.stopTest();
    }
    

}