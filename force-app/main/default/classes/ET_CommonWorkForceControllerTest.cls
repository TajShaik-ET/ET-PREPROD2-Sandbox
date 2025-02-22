@isTest(SeeAllData = false)
public class ET_CommonWorkForceControllerTest {
    @isTest 
    static void testCommonWorkForceController() {
        List<String> field_apinames = new List<String>();
        field_apinames.add('ET_Specific_Leave_Plan__c');
        Test.startTest();
        	ET_CommonWorkForceController.getPicklistvalues('ET_Special_Workforce_Requirement__c',field_apinames);
        Test.stoptest();
    }
}