@isTest
public class ETIN_InsuranceFilePreviewCtrlTest {

    private static testmethod void previewFiel(){
    Account acc = new Account();
    acc.Name = 'ts3232';
    acc.Type = 'Employee';
    acc.ETIN_Employee_Id__c ='232231';
    acc.ETIN_Place_of_Visa_Issuance__c = 'Abu Dhabi';
    insert acc;
    ETIN_InsuranceFilePreviewCtrl.getFiles(acc.id);
        
        
    }
   
    
    
}