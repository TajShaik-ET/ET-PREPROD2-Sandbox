@isTest
public class ETIN_ContactInsuranceValidationTest {
    
      private static testmethod void testvalidation(){
       
    Id ContRecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETIN_Employee_Family').getRecordTypeId();
    Id AccRecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Employee').getRecordTypeId();
    Id ConEmpRecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ET_Employees').getRecordTypeId();
      
          test.startTest();
       Account acc =  new Account();
       acc.Name = 'test';
       
       acc.RecordTypeId = AccRecType;
       insert acc;
       
       Contact con1  = new contact();
       con1.LastName = 'test om';
       con1.Email = 'sendemail2@gmail.com';
       con1.RecordTypeId = ConEmpRecType;
       insert con1;
       
       list<contact> conlist = new list<contact>();
       Contact con  = new contact();
       con.LastName = 'test';
       con.Email = 'sendemail@gmail.com';
       con.RecordTypeId = ContRecType;
       con.ETIN_Relation__c ='Child';
       con.ETIN_Employee__c =con1.Id;
       //con.AccountId = acc.Id;
       
       conlist.add(con);
       
         
       insert conlist;
       
       con.LastName = 'updateCon';
       
       update con;
        test.stopTest();   
      //ETIN_ContactInsuranceValidation.ContactValidation(conlist);
      //ETIN_ContactInsuranceValidation.updateContactAccount(conlist);
       
   }    

}