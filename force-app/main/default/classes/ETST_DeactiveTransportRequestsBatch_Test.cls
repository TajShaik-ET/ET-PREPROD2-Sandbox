@isTest
public class ETST_DeactiveTransportRequestsBatch_Test{
    
    public static testmethod void ETST_DeactiveTransportRequestsBatchTest(){
        System.Test.StartTest();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com');
        insert acc;
        
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_Account_Name__c=acc.Id);
        insert stdnt;
        
        List<ET_Service_Request__c> srList = new List<ET_Service_Request__c>();
        
        For(Integer i=0;i<10;i++){
            ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Pick_Up_End_Date__c=System.today()-5,
                                                                     ETST_Academic_Year_End_Date__c=System.today()+30,ETST_Paid_By__c = 'Self',ETST_Is_Active__c=true);
            srList.add(etreq);
        }
        insert srList;
        
        ETST_DeactiveTransportRequestsBatch bat = new ETST_DeactiveTransportRequestsBatch();
        DataBase.executeBatch(bat);
        
        ETST_DeactiveTransportRequestsScheduler sh1 = new ETST_DeactiveTransportRequestsScheduler();

        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        System.Test.stopTest();
    }
}