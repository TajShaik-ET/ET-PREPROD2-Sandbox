@isTest
public class ETST_UpdateAccountAddressBatchClass_Test{

  public static testmethod void updateAcctBatchClsTestData(){
  
        Id accParentRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        Id accSchoolRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='School Coordinator']; 
        User coordinator = new User(Alias = 'cordu', Email='coordinatoruser@testorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US',ProfileId = p.Id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='coordinatoruser@testorg.com');
        insert coordinator;
        
        Account parentAccount = new Account(FirstName = 'Test',LastName = 'Test',RecordTypeId=accParentRecordType,
                                            //ETSALES_Emirates_Passport__c='784-1272-8373838-3',
                                            Phone='971581484471',
                                            PersonEmail='vinod.test@test.com',
                                            ETSALES_Customer_Type__c='Person');
        insert parentAccount;
        
        Account schoolAccount = new Account(Name='Test School',RecordTypeId=accSchoolRecordType,
                                            ETST_Account_Type__c='Private School',ETSALES_Trade_License_Number__c='11211',ETST_SchoolRefID__c='110011',
                                            ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(365),ETST_Coordinator__c=coordinator.Id);
        insert schoolAccount;
        
        system.runas(coordinator){
          ETST_UpdateAccountAddressBatchClass objBatchCls = new ETST_UpdateAccountAddressBatchClass();
          Database.executeBatch(objBatchCls);
          
        }
  } 
  
 
 
 }