@istest
public class ETST_GetRelatedrResources_Test{
    
    public static testmethod void getRelatedListTest(){
        
        System.Test.StartTest();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test');
        insert acc;
        
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_Account_Name__c=acc.Id);
        insert stdnt;
        
        
        ETST_GetRelatedrResources.getRelatedList(stdnt.Id);
        
        System.Test.stopTest();
        
    }
}