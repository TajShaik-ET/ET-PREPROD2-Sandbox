@isTest
public class ETIN_InsuranceHelperTest {
    
    private static testmethod void insurnaceTrg(){
        
        Account acc = new Account();
        acc.Name = 'ts3232';
        acc.Type = 'Employee';
        acc.ETIN_Employee_Id__c ='232231';
        acc.ETIN_Place_of_Visa_Issuance__c = 'Abu Dhabi';
        insert acc;
       
        
        list<ETIN_Insurance__c> insList = new List<ETIN_Insurance__c>();
        ETIN_Insurance__c et = new ETIN_Insurance__c();
        et.EmployeeAcc__c = acc.Id;
        et.Insurance_Company__c = acc.Id;
        et.Card_Number__c = '24343';
        et.Status__c ='New';
        
        insert et;
        
        ETIN_Insurance__c et2 = new ETIN_Insurance__c();
        et2.EmployeeAcc__c = acc.Id;
        et2.Card_Number__c = '24343';
        et2.Insurance_Policy_Number__c ='2343434';   
        et2.Status__c ='New';
        et2.Insurance_Current_Status__c='Active';
        et2.Status__c ='Completed';
        et2.Renew_Request__c = true;
        et2.Renew_Status__c =false;
        et2.Previous_Insurance__c=et.Id;
        insert et2;
        
       // insList.add(et);
        
    }

}