@isTest
public class ETST_ShareSchoolAccountstoCommunity_Test {
    
    public static testMethod void manualShareReadTest(){
        
        System.Test.startTest();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test');
        insert acc;
        
        ETST_ShareSchoolAccountstoCommunityUsers.manualShareRead(acc.Id, userinfo.getUserId());
        
        System.Test.stopTest();
    }
}