@isTest
public class WataneyaLeadAPITest {
    @isTest
    static void testHttpPost() {
        String leadRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Wataneya' LIMIT 1].Id;
        
        // Prepare the mock REST request and response
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        WataneyaLeadAPI.RequestWrapper wrapper = new WataneyaLeadAPI.RequestWrapper();
        wrapper.firstName = 'John';
        wrapper.lastName = 'Doe';
        wrapper.email = 'john.doe@example.com';
        wrapper.mobile = '1234567890';
        wrapper.subject = 'Interested in Car Detailing';
        wrapper.contactMethod = 'Email';
        wrapper.description = 'Looking for detailed information';
        wrapper.serviceType = 'Car Detailing';

        req.requestBody = Blob.valueOf(JSON.serialize(wrapper));
        // Call the doPost method in WorkOrderApi
        Test.startTest();
        WataneyaLeadAPI.doPost();
        Test.stopTest();
        
    }
}