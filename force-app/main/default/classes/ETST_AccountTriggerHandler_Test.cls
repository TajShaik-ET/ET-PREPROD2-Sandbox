@isTest
Private class ETST_AccountTriggerHandler_Test {
    Private Static TestMethod Void testAccountTrigger() {
        Id accSchoolRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        Try{
            Profile p = [SELECT Id FROM Profile WHERE Name='School Coordinator']; 
            User coordinator = new User(Alias = 'cordu', Email='coordinatoruser@testorg.com', 
                                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                        LocaleSidKey='en_US', ProfileId = p.Id, 
                                        TimeZoneSidKey='America/Los_Angeles', UserName='coordinatoruser@testorg.com');
            insert coordinator;
            Account schoolAccount = new Account(Name='Test School',RecordTypeId=accSchoolRecordType,
                                                ETST_Account_Type__c='Private School',ETSALES_Trade_License_Number__c='11211',ETST_SchoolRefID__c='110011',
                                                ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(365),ETST_Coordinator__c=coordinator.Id);
            insert schoolAccount;
            Account schoolAccount2 = new Account(Name='Test School',RecordTypeId=accSchoolRecordType,
                                                 ETST_Account_Type__c='Private School',ETSALES_Trade_License_Number__c='11211',ETST_SchoolRefID__c='110011',
                                                 ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(365),ETST_Coordinator__c=coordinator.Id);
            insert schoolAccount2;
            schoolAccount2.Name = 'Test';
            update schoolAccount2;
        }Catch(Exception e){
            
        } 
    }
    @isTest
    public static void testCase1(){
        Id accSchoolRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='School Coordinator']; 
        User coordinator = new User(Alias = 'cordu', Email='coordinatoruser@testorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p.Id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='coordinatoruser@testorg.com');
        insert coordinator;
        Account schoolAccount2 = new Account(Name='Test School',RecordTypeId=accSchoolRecordType,
                                             ETST_Account_Type__c='Private School',ETSALES_Trade_License_Number__c='11211',ETST_SchoolRefID__c='110011',
                                             ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(365),ETST_Coordinator__c=coordinator.Id);
        insert schoolAccount2;
        schoolAccount2.Name = 'Test';
        update schoolAccount2;
    }
}