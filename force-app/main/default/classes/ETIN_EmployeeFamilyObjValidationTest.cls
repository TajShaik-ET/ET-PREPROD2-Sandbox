@IsTest
public class ETIN_EmployeeFamilyObjValidationTest {
    private static testmethod void createEmpFam(){
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.ETIN_Employee_Id__c ='344243232';
       
        insert acc;
        
        ETIN_Employee_Family__c em = new ETIN_Employee_Family__c();
        
        em.Name = 'test3243343';
        em.EID_Application_No__c ='3423232';
        em.Employee__c = acc.Id;
        em.Relation__c ='Spouse';
        em.Place_of_Visa_Issuance__c ='Abu Dhabi';
        insert em;
        
        em.Relation__c='Child';
        update em;

    }
}