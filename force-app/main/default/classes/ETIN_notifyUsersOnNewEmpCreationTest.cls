@isTest
public class ETIN_notifyUsersOnNewEmpCreationTest {

    public static testmethod void notifyUser(){
         ETSALES_Location__c lo = new ETSALES_Location__c();
        lo.Name ='test';
        lo.Location_Code__c='123';
        lo.GL_Zone__c ='Zone A';
        insert lo;
        
           Profile p = [SELECT Id FROM Profile WHERE Name='ETIN_InsuranceZone']; 
        User u = new User(Alias = 'standt', Email='standaxne9768@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, ETSALES_Employee_Zone__c='Zone A',
            TimeZoneSidKey='America/Los_Angeles', UserName='standaxne9768@testorg.com');

       
         Account acc = new Account();
         acc.LastName = 'test';
         acc.Type='Employee'; 
         acc.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
         acc.ETIN_Location_Code__c ='123';
         insert acc;
       
        
    }
}