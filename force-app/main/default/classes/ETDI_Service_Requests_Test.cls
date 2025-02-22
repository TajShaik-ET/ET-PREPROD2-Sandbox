@isTest
public class ETDI_Service_Requests_Test {
    
    @isTest
    public static void codecoverage()
    {
        Test.setMock(HttpCalloutMock.class, new ETDI_Services_Mock()); 
        Account acc = new Account(LastName = 'Test', Phone='971504111111');
        
        insert acc;
        
        ETDI_Service_Requests.createRequest('POST','test'); 
        Test.startTest();
        ETDI_Service_Requests.getTokenUsingMobileNumber(acc.id);   
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://etdi.gov.ae');                
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
           ETDI_Service_Requests.getServiceResult(req, 'Test');
        
        Test.stopTest();
	}

}