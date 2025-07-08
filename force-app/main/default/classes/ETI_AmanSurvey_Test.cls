/***********************************************************************************************************************
* Name               : ETI_AmanSurvey                                                                                  *
* Test Class         : ETI_AmanSurvey_Test                                                                             *
* Description        : Apex Class to fetch Aman receipt and update in Salesforce                                       *
* Created Date       : 04/Mar/2025                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   04/Mar/2025         Initial Draft.                                                             *
***********************************************************************************************************************/
@isTest
private class ETI_AmanSurvey_Test {
    
    // Mock class for GET callout (getAmanSurvey)
    private class GetSurveyMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Status": "S", "Message": "Response from AMAN received.", "IfReferenceExists": "true", "TestResultsLink": "http://example.com"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    // Mock class for POST callout (postAmanSurvey)
    private class PostSurveyMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Status": "S", "Message": "Survey submitted successfully.", "IfReferenceExists": "true", "TestResultsLink": "http://example.com"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void testGetAmanSurvey() {
        // Register mock
        Test.setMock(HttpCalloutMock.class, new GetSurveyMock());
        
        // Simulate MDT configuration
        ET_Oracle_REST_Endpoints__mdt mockMDT = new ET_Oracle_REST_Endpoints__mdt(
            DeveloperName = 'amanSurveyStatus',
            MasterLabel = 'amanSurveyStatus',
            Username__c = 'testUser',
            Password__c = 'testPass',
            Dev_Endpoint__c = 'https://mock.dev.endpoint',
            LiveEndpoint_c__c = 'https://mock.live.endpoint'
        );
        // insert mockMDT;
        
        Test.startTest();
        ETI_AmanSurvey.ResponseWrapper result = ETI_AmanSurvey.getAmanSurvey('12345');
        Test.stopTest();
        
        System.assertEquals('S', result.Status);
        System.assertEquals('Response from AMAN received.', result.Message);
    }
    
    @isTest
    static void testPostAmanSurvey() {
        // Register mock
        Test.setMock(HttpCalloutMock.class, new PostSurveyMock());
        
        // Simulate MDT configuration
        ET_Oracle_REST_Endpoints__mdt mockMDT = new ET_Oracle_REST_Endpoints__mdt(
            DeveloperName = 'amanSurveyUpdate',
            MasterLabel = 'amanSurveyUpdate',
            Username__c = 'testUser',
            Password__c = 'testPass',
            Dev_Endpoint__c = 'https://mock.dev.endpoint',
            LiveEndpoint_c__c = 'https://mock.live.endpoint'
        );
        //  insert mockMDT;
        
        Test.startTest();
        ETI_AmanSurvey.ResponseWrapper result = ETI_AmanSurvey.postAmanSurvey('12345', 'Very Satisfied', 'Everything was great', 'Yes');
        Test.stopTest();
        
        System.assertEquals('S', result.Status);
        System.assertEquals('Survey submitted successfully.', result.Message);
    }
}