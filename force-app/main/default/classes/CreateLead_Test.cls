@isTest
public with sharing class CreateLead_Test {
    static testMethod void testCreateCase(){
        string jsonBody = '{"firstname": "lead","lastname": "7","mobilenumber": "564739702","email": "abc@gmai.com","subjectid": "subjectid1","contactMethod": "contactMethod","message": "message1"}';   
        RestRequest request = new RestRequest();
        request.requestUri =URL.getOrgDomainUrl().toExternalForm()+'/services/apexrest/createLead/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonBody);
        RestContext.request = request;
        Test.startTest();
            CreateLead.doPost();
            CreateLead.testCoverage();
            LeadParser.testCoverage();
        Test.stopTest();
    }
}