@isTest
private class LeadTriggerHandler_Test {
    
    @isTest private static void method1(){
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('New_Business').getRecordTypeId(); 
        Lead l = new Lead(FirstName='Test First Name',MobilePhone = '971500000000',LastName='Test LastName', recordTypeId=recordTypeId, Request_Category__c ='General Inquiry', Preferred_Location__c = 'Dubai');
        Test.startTest();
        insert l;
        l.LeadSource = 'Website';
        update l;
        Test.stopTest();
     }
}