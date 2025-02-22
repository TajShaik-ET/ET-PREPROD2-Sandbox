@isTest
public class ETST_PicklistValueController_Test {
    
    public static testMethod void ETST_PicklistValueControllerTest(){
        
        List<String> field_apinames = new List<String>();
        field_apinames.add('Name');
        String objectName = null;
        
        ETST_PicklistValueController.getPicklistvalues('ETST_Student__c', field_apinames);       
        ETST_PicklistValueController.getPicklistvalues(objectName,field_apinames);
        
    }
}