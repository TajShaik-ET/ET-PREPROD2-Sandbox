@isTest
private class WorkOrderApi_Test {
    @isTest
    static void testHttpPost() {
        // Create a test RequestWrapper JSON string
        String jsonRequest = '{"serviceNumber": "123456", "workOrder": "WO123", "workOrderStatus": "InProgress"}';
        
        // Create a test RestRequest
        RestRequest request = new RestRequest();
        request.requestURI = URL.getOrgDomainUrl().toExternalForm()+'/services/apexrest/WORKORDER/'; // Replace with the appropriate URL
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(jsonRequest);
        
        // Create a test RestContext
        RestContext.request = request;
        RestContext.response = new RestResponse();
        
        // Call the doPost method in WorkOrderApi
        Test.startTest();
        WorkOrderApi.doPost();
        WorkOrderApi.testCoverage();
        Test.stopTest();
        
    }
}