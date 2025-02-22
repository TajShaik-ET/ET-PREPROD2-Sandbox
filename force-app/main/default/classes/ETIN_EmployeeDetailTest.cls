@isTest
public class ETIN_EmployeeDetailTest {

    private static testmethod void insuranceEmployee(){
        
        
        Account acc = new Account();
        acc.lastname='test';
        acc.ETIN_Place_of_Visa_Issuance__c = 'Abu Dhabi';
       
        insert acc;
         
        ETIN_Insurance__c et = new ETIN_Insurance__c();
        
        et.Insurance_Policy_Number__c='1213';
        et.EmployeeAcc__c = acc.Id;
        et.Insurance_Company__c = acc.Id;
        et.RecordTypeId = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
        
        insert et;
        
        Case ca = new case();
        
        ca.ETIN_Employee_Requested__c = true;
        ca.Insurance__c =et.id;
            
        Insert ca;
       
        ETIN_EmployeeDetailCtrl.saveTheFile('test', 'hdsahdsd', '.pdf', et.Id);
        ETIN_EmployeeDetailCtrl.geDetails(userInfo.getUserId());
        ETIN_EmployeeDetailCtrl.getContactLoginId(userInfo.getUserId());
        ETIN_EmployeeDetailCtrl.geDetails(userInfo.getUserId());
        ETIN_EmployeeDetailCtrl.getLoginContactId(userInfo.getUserId());
        ETIN_EmployeeDetailCtrl.getEmpInsDetails(userInfo.getUserId());
        ETIN_EmployeeDetailCtrl.getRecordTypeId('Contact', 'ET_Employees');
        ETIN_EmployeeDetailCtrl.getEmpFamilyID(et.Id);
        //ETIN_EmployeeDetailCtrl.getLoginUserVisaEmirates(userInfo.getUserId());
       
    }
}