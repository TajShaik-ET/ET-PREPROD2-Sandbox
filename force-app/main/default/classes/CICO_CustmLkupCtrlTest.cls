@isTest
public class CICO_CustmLkupCtrlTest {
    
 private static testmethod void TestMethod1(){
     
     Account acc = new Account();
     acc.Name = 'test233232';
     acc.ETIN_Employee_Id__c = '';
     acc.Type ='Employee';
     insert acc;
        
     CICO_CustmLkupCtrl.getAcctFilterList('test233232');
     
    }

}