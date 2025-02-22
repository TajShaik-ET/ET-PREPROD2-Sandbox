@isTest
global  class ETC_CabmanBookingsUpdateMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       // System.assertEquals('http://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        // 11:30:44:477 USER_DEBUG [96]|DEBUG|response>> ETPaymentResponse:[=null, authResponse=null, ds=null, embedded=null, links=null, orderReference=null, outletId=null, paymentMethod=null, pid=null, savedCard=null, state=null, updateDateTime=null]
        string jsonBody = '{ "amount": "400","authResponse": "true","paymentMethod": "Online" }';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonBody);
        res.setStatusCode(201);
        res.setStatus('true');
        return res;
    }
}