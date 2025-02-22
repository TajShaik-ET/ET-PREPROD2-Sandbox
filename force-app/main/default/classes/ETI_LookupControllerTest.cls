@isTest
public class ETI_LookupControllerTest {
    private static testmethod void testmethodInspection(){
        list<string> ReturnFields = new list<string>{'Name','PersonHomePhone'};
        ETI_TestUtilityClass.testUserCreation();
        ETI_TestUtilityClass.testAccountCreation();
        ETI_LookupController.findObjectIcon('Account');
        ETI_LookupController.GetRecentRecords('Account', ReturnFields, 1);
        ETI_LookupController.SearchRecords('Account',ReturnFields,ReturnFields,'test',null,null,1,null);
        ETI_LookupController.GetRecord('Account',ReturnFields,ETI_TestUtilityClass.objAccount.id);
        ETI_LookupController.getObjectDetails('Account');
        
        //Negative
        ETI_LookupController.GetRecentRecords('Account', null, 1);
        ETI_LookupController.SearchRecords('Account',null,null,null,'Name',null,null,null);
        ETI_LookupController.findObjectIcon('ETI_Booking__c');
        ETI_LookupController.GetRecord('Account',null,ETI_TestUtilityClass.objAccount.id);
    }
}