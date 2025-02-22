@isTest
public class ET_LookupController_Test{
    
    public static testmethod void testData(){
        system.Test.startTest();
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User u=[select id from user where profileId=:profile1.Id and isactive=true LIMIT 1];
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId(); 
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,ET_Preferred_Location__c='Abu Dhabi',FirstName = 'Test',LastName = 'Test',PersonEmail='testestt@test.com',etst_coordinator__c=userinfo.getUserId());
        System.runAs(u){
            insert acc; 
        }
        User portalUser=[select id,ContactId from user where contactId=:acc.PersonContactId and isActive=true LIMIT 1];
        System.debug('portalUser-->'+portalUser.contactId);
        Id accSchoolRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='School Coordinator']; 
        User coordinator = new User(Alias = 'cordu', Email='coordinatoruser@testorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p.Id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='coordinatoruser@testorg.com');
        insert coordinator;       
        Account schoolAccount = new Account(Name='Test Schoolxxx',RecordTypeId=accSchoolRecordType, 
                                            ETST_Account_Type__c='Private School',ETSALES_Trade_License_Number__c='11211',ETST_SchoolRefID__c='110011',
                                            ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(365),ETST_Coordinator__c=coordinator.Id);
        insert schoolAccount;
        ETST_School__c school = new ETST_School__c(Name='Test Schoolxxx', ETST_Account_Type__c='Private School',Customer__c=schoolAccount.id);
        insert school;
        System.runAs(portalUser){
        ET_LookupController.fetchLookUpValues('Test School','ETST_School__c', 'Private School',null,'en');
        ET_LookupController.fetchLookUpValues('Test School','ETST_School__c', 'Private School',null,'ar');
        }
        system.Test.stopTest();
    }
}