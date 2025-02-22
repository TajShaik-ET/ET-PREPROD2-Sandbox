@IsTest
public class ETIN_BulkAddResUploadCtrlTest {
   
    private static testmethod void getInsuranceDetails(){
        
         Id AccRecTypeId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        Account acc = new account();
        acc.Name = 'test';
        acc.RecordTypeId = AccRecTypeId;
        
        insert acc;
        
        Contact co = new contact();
        co.AccountId = acc.Id;
        co.LastName = 'lastname';
        insert co;
        
        ETIN_Insurance__c et = new ETIN_Insurance__c();
        et.RecordTypeId=Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
        et.Card_Number__c = '3243';
        et.EmployeeAcc__c = acc.Id;
        et.Plan__c ='Basic';
        et.Insurance_Company__c = acc.Id;
        et.Effective_Date__c = system.today();
        et.Expiry_Date__c = system.today()+30;
                  
        insert et;
        
        ETIN_Insurance__c etVa = [select name,Card_Number__c from ETIN_Insurance__c where id=:et.Id];
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('InsRefNumber', etVa.Name);
        gen.writeStringField('CardNumber', '244322');
         gen.writeStringField('PolicyNumber', '244322');
        gen.writeEndObject();
        gen.writeEndArray();
        String jsonData = gen.getAsString();
        
        ETIN_BulkAddResUploadCtrl.updateData(jsonData);
        ETIN_BulkAddResUploadCtrl.updateRenewalData(jsonData);
    }
}