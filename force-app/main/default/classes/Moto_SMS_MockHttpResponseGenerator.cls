/**
* Author: Janardhan Muddana
* CreatedDate: 18/07/2022
* Desc: this is used to send sms msg to customer using smsshastra api.
* 
* */
@isTest
global class Moto_SMS_MockHttpResponseGenerator implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {
             
        HttpResponse res = new HttpResponse();        
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);        
        return res;
        
    }
    
}