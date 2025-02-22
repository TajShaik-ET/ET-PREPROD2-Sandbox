@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
  

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
            if(req.getEndpoint() == 'https://iotmobility.etisalatdigital.ae/Thingworx/Things/EmiratesAirlines_API_V1/Services/RealTimeLocationData'){
                ET_IOTLocations locations = new ET_IOTLocations();
                locations.rows = new List<ET_IOTLocations.Rows>{new ET_IOTLocations.Rows()};
                res.setBody(JSON.serialize(locations));
            }else{
               res.setBody('{"example":"test"}'); 
            }
        
        res.setStatusCode(200);
        return res;
    }
}