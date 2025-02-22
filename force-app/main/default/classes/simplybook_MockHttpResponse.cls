@isTest
global class simplybook_MockHttpResponse implements HttpCalloutMock {
    
     global HTTPResponse respond(HTTPRequest req) {
         
         HttpResponse res = new HttpResponse();
         res.setHeader('Content-Type', 'application/json');
         System.debug('getendpotnis ='+req.getEndpoint());
         String endpoint = req.getEndpoint();
         if(endpoint.contains('/admin/auth')){  
            
             res.setBody('{"token":"316576d66e031563b5bd50de4085d14dfc923f644cdd01de078ac1d88b27acc4","company":"emiratesmoto","login":"ahmed.shuaib@et.ae","refresh_token":"05ae9201c8dabd891aebb7cae3affe7530634ec2d9fc406b667aa394bb71edad","domain":"simplybook.me","require2fa":false,"allowed2fa_providers":[],"auth_session_id":"","id":null}');
         }else if(endpoint.contains('/admin/clients?filter[search]')){  
            
             res.setBody('{"data":[{"can_be_edited": true,"id": 494,"name": "CRM Test User","email": "testuser@gmail.com","phone": "9715586560234","address1": null,"address2": null,"city": null,"zip": null,"country_id": null,"state_id": null,"full_address": "" }],"metadata":{"items_count": 3,"pages_count": 1,"page": 1, "on_page": 10,"alphabet_index": [{"letter": "...","index": 0}]}}');
         }else if(endpoint.contains('/admin/clients')){  
         res.setBody('{"id":562,"name":"akhil test","email":"akjil@gmail.com","phone":"971558656023","address1":null,"address2":null,"city":null,"zip":null,"country_id":null,"state_id":null,"full_address":""}');
         }
         
         res.setStatusCode(200);
         return res;
     }
   
}