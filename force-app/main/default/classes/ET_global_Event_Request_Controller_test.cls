@isTest
public class ET_global_Event_Request_Controller_test {

    @isTest
    static void testCreateCaseWithRequests() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
         
        Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testAccount.Id);
        insert testContact;

        RecordType testRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Global_Event_Request' LIMIT 1];
         // Create a dummy case to obtain a case ID
         Case dummyCase = new Case(
            AccountId = testAccount.Id,
            ContactId = testContact.Id,
            RecordTypeId = testRecordType.Id,
            Status_Category__c='Pending with ET',
            Subject = 'Dummy Case'
        );
        insert dummyCase;
        
        List<ESE_Request_Line__c> eseline = new List<ESE_Request_Line__c>();
        ESE_Request_Line__c ese = new ESE_Request_Line__c();
        ese.Case__c=dummyCase.Id;
        ese.School_Names__c=testAccount.Id;
        eseline.add(ese);
    
        Test.startTest();
        ET_global_Event_Request_Controller.createCaseWithRequests(testAccount.Id,
            testContact.Id,
            testRecordType.Id,
            'Test Type',
            'In Progress',
            'Pending with ET',
            'Test Subject',
            eseline);
        ET_global_Event_Request_Controller.setObjectToRecentItems(testAccount.Id);
        Test.stopTest();

    }
    

}