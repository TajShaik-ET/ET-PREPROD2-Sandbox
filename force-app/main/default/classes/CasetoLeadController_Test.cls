@isTest 
public class CasetoLeadController_Test {
    
    @isTest public static void fetchContactList() {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId();
        Account a = new Account(Name='Test Account Name');
        a.RecordTypeId = devRecordTypeId;
        insert a;
        Case c= New case();
        insert c;
        Test.startTest();
        CasetoLeadController.fetchContactList(c.Id);
        CasetoLeadController.updateCase(c);
        Test.stopTest();
           
    }
    
}