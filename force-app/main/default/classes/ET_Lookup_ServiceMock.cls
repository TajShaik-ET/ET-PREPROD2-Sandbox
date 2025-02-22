@isTest
global class ET_Lookup_ServiceMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json');
        res.setBody('{"animal": {"id":2, "name":"Test"}}');
        res.setStatusCode(200);
        return res; 
    }
}