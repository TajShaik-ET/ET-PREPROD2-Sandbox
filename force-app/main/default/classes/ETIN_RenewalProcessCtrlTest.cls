@isTest
public class ETIN_RenewalProcessCtrlTest {
    private static testmethod void renewRecord(){
           Profile p = [SELECT Id FROM Profile WHERE Name=:System.Label.INS_ZoneCordProfileName]; 
        User u = new User(Alias = 'standt', Email='standaxne9768@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ETSALES_Employee_Zone__c='Zone A',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standaxne9798968@testorg.com');
        
        InsurancePlansMaster__c plan = new InsurancePlansMaster__c();
        plan.Emirates__c ='Abu Dhabi';
        plan.Name='2323';
        plan.Condition__c ='More';
        plan.Salary__c=5000;
        plan.Plans__c='Basic';
        insert plan;
       System.runAs(u){   
        Account acc = new Account();
        acc.Name = 'ts3232';
        acc.Type = 'Employee';
        acc.ETIN_Employee_Id__c ='232231';
        acc.ETIN_Place_of_Visa_Issuance__c = 'Abu Dhabi';
        //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
      
        insert acc;
        
     
        
        Id HealthNewRecTyID = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
      
        Integer thisYear = system.today().year();
        date customDate =  date.newinstance(thisYear, 12, 31);
        
        list<ETIN_Insurance__c> insList = new List<ETIN_Insurance__c>();
        ETIN_Insurance__c et = new ETIN_Insurance__c();
        et.EmployeeAcc__c = acc.Id;
        et.RecordTypeId =HealthNewRecTyID;
        et.Card_Number__c = '24343';
        et.Status__c ='Under Process';
        et.Renew_Status__c = False;
        et.Expiry_Date__c = customDate;
        insert et;  
        insList.add(et);
        
        
        ETIN_RenewalProcessCtrl.getTotalRecords('Abu Dhabi');
        ETIN_RenewalProcessCtrl.getCurrentInsRecords(1, 1, 'Abu Dhabi');
        ETIN_RenewalProcessCtrl.fetchUser();
        ETIN_RenewalProcessCtrl.updateInsurance(insList);
      
             ETIN_RenewalProcessCtrl.RenewProcess(insList);
        }
       
            
    }
}