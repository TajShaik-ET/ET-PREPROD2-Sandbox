@isTest
global class ET_UAEPASSTestHttpCalloutTest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        String json=		'{'+
            '"sub":"904a019b-112a-4007-a657-acb609dff023",'+
            ' "gender":"Male",'+
            '"nationalityEN":"IND",'+
            '"firstnameEN":"ABCD",'+
            '"mobile":"971550098765",'+
            '"lastnameEN":"EFGH",'+
            '"fullnameEN":"ABCD EFGH",'+
            '"userType":"SOP1",'+
            '"nationalityAR":"هندى",'+
            '"uuid":"904a019b-112a-4007-a657-acb609dff023",'+
            '"email":"janardhan.25@gmail.com"'+
            '}';
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
         response.setBody(json);
        response.setStatusCode(200);
        System.debug('response---->' +response.getBody());
        return response; 
    }
}