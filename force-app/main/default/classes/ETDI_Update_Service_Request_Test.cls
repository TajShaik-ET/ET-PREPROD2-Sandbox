@isTest
public class ETDI_Update_Service_Request_Test {

    @isTest
    public static void codecoverage1()
    {
        ETDI_Service_Request__c serReq = new ETDI_Service_Request__c(Service_Request_Num__c='235314');
        insert serReq;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
   req.requestURI = '/services/apexrest/updateServiceRequest/';
        req.httpMethod = 'POST';

        String requestBody = '{"serviceRequestNumber":"235314","Status":"Approved"}';
        system.debug('requestBody '+String.valueOf(blob.valueOf(requestBody)) );

 

        req.requestBody = blob.valueOf(requestBody); 
        RestContext.request = req;
        RestContext.response = res;               
        Test.startTest();         
        ETDI_Update_Service_Request.updateServiceRequestStatus();
        Test.stopTest();
        //Http http = new Http();
        //HttpResponse response = http.send(request);
        
        

    }
    
    @isTest
    public static void codecoverage2()
    {
        ETDI_Service_Request__c serReq = new ETDI_Service_Request__c(Service_Request_Num__c='235314');
        insert serReq;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
   req.requestURI = '/services/apexrest/updateServiceRequest/';
        req.httpMethod = 'POST';

        String requestBody = '{"serviceRequestNumber":"235314","Status":"not present"}';
        system.debug('requestBody '+String.valueOf(blob.valueOf(requestBody)) );

 

        req.requestBody = blob.valueOf(requestBody); 
        RestContext.request = req;
        RestContext.response = res;               
        Test.startTest();         
        ETDI_Update_Service_Request.updateServiceRequestStatus();
        Test.stopTest();
        //Http http = new Http();
        //HttpResponse response = http.send(request);
        
        

    }
    
     @isTest
    public static void codecoverage3()
    {
        ETDI_Service_Request__c serReq = new ETDI_Service_Request__c(Service_Request_Num__c='235314');
        insert serReq;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
   req.requestURI = '/services/apexrest/updateServiceRequest/';
        req.httpMethod = 'POST';

        String requestBody = '{"serviceRequestNumber":"2352211314","Status":"Approved"}';
        system.debug('requestBody '+String.valueOf(blob.valueOf(requestBody)) );

 

        req.requestBody = blob.valueOf(requestBody); 
        RestContext.request = req;
        RestContext.response = res;               
        Test.startTest();         
        ETDI_Update_Service_Request.updateServiceRequestStatus();
        Test.stopTest();
        //Http http = new Http();
        //HttpResponse response = http.send(request);
        
        

    }
}