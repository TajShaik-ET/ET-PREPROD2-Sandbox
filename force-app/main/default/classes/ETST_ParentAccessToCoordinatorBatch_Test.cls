@isTest
public class ETST_ParentAccessToCoordinatorBatch_Test {
    
    @isTest static void testbathc(){
        id profileId = [Select Id from Profile where Name='School Coordinator' limit 1].Id;
        user coordinator = [Select Id,Name from User where Profileid=:profileId  and isactive=true limit 1];
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com',etst_coordinator__c=userinfo.getUserId());
        insert acc; 
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId(); 
        Account acc1 = new Account(RecordTypeId=schoolRecordTypeId,Name='Test',etst_coordinator__c=coordinator.Id);
        insert acc1;
        ET_Sales_Agreement__c agr = new ET_Sales_Agreement__c(Salesforce_Customer__c=acc1.Id);
        insert agr;        
        ETST_School__c schl = new ETST_School__c(Name='Test', Customer__c = acc1.Id,ETST_Sales_Agreement__c=agr.Id,ETST_Account_Type__c='University');
        insert schl;
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_School_Name__c=schl.Id,
                                                    ETST_Account_Name__c=acc.Id,ETST_School__c=acc1.Id,ETST_Parent_Access_Granted__c=false);
        insert stdnt;
        
        ETST_ParentAccessToCoordinatorBatch sh1 = new ETST_ParentAccessToCoordinatorBatch(); 
        Database.executeBatch(sh1);
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        
    }
    
}