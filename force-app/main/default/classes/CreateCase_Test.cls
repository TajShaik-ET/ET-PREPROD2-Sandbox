@isTest
public class CreateCase_Test {
    
    static testMethod void testCreateCase(){
        string jsonBody = '[ { "type":"Accident/Emergency","assignedVehicle": "C0043464","driverName": "test","origin": "test","activityLocation": "test","description": "test","arkaniIncidentId":117,"contactPerson":"1234"} ]';   
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonBody);
        RestContext.request = request;
        Vehicle_Master__c vehicleMasterList=new Vehicle_Master__c();
        vehicleMasterList.Name='C0043464';
        vehicleMasterList.Internal_No__c='122';
        insert vehicleMasterList;
        
        Account acc=new Account();
        acc.Name='Internal ET Account';
        insert acc;
        
        Test.startTest();
        CreateCase.doPost();
        Test.stopTest();
    }
}