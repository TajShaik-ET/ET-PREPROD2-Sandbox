@isTest
public class ETST_ShareAccountsWithCoordinator_Test {
    public static testmethod void  shareAccountsTest(){
        Profile profile1=[select id from profile where name='School Coordinator'];
        System.Test.startTest();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId(); 
        User coordinator = new User(
            //UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'test2', 
            Email='test2.test2@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='test2',
            Lastname='test2',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(coordinator);
        Set<Id> recordIds = new Set<Id>();
        
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com');
        insert acc;
        
        Account acc1 = new Account(RecordTypeId=schoolRecordTypeId,Name='Test',etst_coordinator__c=coordinator.Id);
        insert acc1;
        
        recordIds.add(acc.Id);
        recordIds.add(acc1.Id);
        
        ETST_ShareAccountsWithCoordinator.ShareAccountsWithCoordinator(recordIds);
        
        ETST_School__c schl = new ETST_School__c(Name='Test', Customer__c = acc.Id);
        insert schl;
        
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_Account_Name__c=acc.Id);
        insert stdnt;
        
        ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Paid_By__c = 'Self');
        insert etreq;
        
        Invoice__c inv = new Invoice__c(ETST_Active__c=true,ETST_Type__c='Online',Service_Request__c=etreq.Id);
        insert inv;
        
        List<Invoice__c> invList = [SELECT Id,Name,Service_Request__c,ETST_Type__c FROM Invoice__c];
        
        ETST_ShareAccountsWithCoordinator.populateCoordinatorandLocation(invList);
        
       // ETST_ShareAccountsWithCoordinator.testData();
        system.Test.stopTest();
    }
}