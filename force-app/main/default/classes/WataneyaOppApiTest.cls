@isTest
public class WataneyaOppApiTest {
    @isTest
    static void testDoPost_Success() {
        String accRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Person_B2C' LIMIT 1].Id;
        String oppRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND DeveloperName = 'Al_Wataneya_Sell_a_Car' LIMIT 1].Id;
        
        // Create a mock request
        WataneyaOppApi.RequestWrapper requestWrapper = new WataneyaOppApi.RequestWrapper();
        requestWrapper.clientId = '12345';
        requestWrapper.firstName = 'John';
        requestWrapper.lastName = 'Doe';
        requestWrapper.email = 'johndoe@example.com';
        requestWrapper.mobile = '1234567890';
        requestWrapper.fax = '0987654321';
        requestWrapper.poBox = 'PO123';
        requestWrapper.emiratesID = 'EID12345';
        requestWrapper.passportNum = 'P12345';
        requestWrapper.customerCategory = 'Gold';
        requestWrapper.customerCategoryImp = 'High';
        requestWrapper.trnNumber = 'TRN12345';
        requestWrapper.bodyType = 'SUV';
        requestWrapper.vehBrand = 'Toyota';
        requestWrapper.vehModel = 'Camry';
        requestWrapper.vehPlateNum = '123ABC';
        requestWrapper.vehModelYear = '2020';
        requestWrapper.vehMileage = '5000';
        requestWrapper.vehChassisNum = 'CH12345';
        requestWrapper.vehType = 'Private';
        requestWrapper.commision = '500';
        requestWrapper.auctionFee = '100';
        requestWrapper.accidented = 'No';
        requestWrapper.customerMinimumSelling = '20000';
        requestWrapper.recovery = 'Yes';
        requestWrapper.vehInspection = 'Passed';
        requestWrapper.bodyPolishing = 'Yes';
        requestWrapper.bankName = 'Bank A';
        requestWrapper.bankAccountNum = '12345678';
        requestWrapper.bankIBAN = 'AE1234567890';
        requestWrapper.bankAddress = 'Street 123';
        requestWrapper.bankSwiftCode = 'SWFT123';
        requestWrapper.bankCustomerName = 'John Doe';

        String jsonRequest = JSON.serialize(requestWrapper);
        RestContext.request = new RestRequest();
        RestContext.request.requestBody = Blob.valueOf(jsonRequest);
        RestContext.response = new RestResponse();

        // Test the doPost method
        Test.startTest();
        WataneyaOppApi.doPost();
        Test.stopTest();
    }
}