@isTest
public class ET_PicklistValueControllerTest {
    @isTest
    public static void testCase1(){
        ET_PicklistValueController.getPicklistvalues(null, null);
        ET_PicklistValueController.getPicklistvalues('ET_Work_force__c', new List<String>{'ET_Special_Requirements__c'});
    }

}