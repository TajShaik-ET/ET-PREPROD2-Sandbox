@isTest
public class ETIN_BulkHealthApprovalBatchClsTest {

    public TestMethod static void Class_Test_Method(){
         Account acc = new account();
        acc.Name = 'test';
        acc.ETIN_Employee_Status__c = 'Active';
        
        insert acc;
      Id empRecTypeId2 = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('ETIN_Employee_Family').getRecordTypeId();   
        Contact co = new contact();
        co.AccountId = acc.Id;
        co.LastName = 'lastname';
        co.RecordTypeId = empRecTypeId2;
        co.ETIN_Insurance_Card_Number__c = '213';
        insert co;
        
        Id insHealthRecID  = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
        ETIN_Insurance__c et = new ETIN_Insurance__c();
        et.Insurance_Policy_Number__c = '133323';
        et.Insurance_Current_Status__c = 'Active';
        et.Insurance_Company_Email__c='test@gmail.com';
        et.Card_Number__c = '112121212';
        et.EmployeeAcc__c = acc.Id;
        et.Renew_Request__c = false;
        
        et.Insurance_Current_Status__c ='Active';
        et.RecordTypeId =insHealthRecID;
        
        insert et;
        
        Test.startTest();
        ETIN_BulkHealthApprovalBatchCls etb = new ETIN_BulkHealthApprovalBatchCls(acc.Id,'');
         Database.executeBatch(etb);
         Test.stopTest();
    }
          
}