public class ETIN_EmployeeSync {
    
    @Auraenabled
    public static string syncWithERP( string empNumber){
        string msg;
        JSON2EmpSyncRes objResponse = new JSON2EmpSyncRes();
        if( empNumber !=null && empNumber != '')
        {
            ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('EmployeeSync');
            system.debug('empNumber---->'+empNumber);
            
            HttpRequest request = new HttpRequest(); 
            HttpResponse response = new HttpResponse();  
            Http http = new Http();
            Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
            
            string paramvalue = EncodingUtil.base64Encode(beforeblob);
            if(ET_REST_Authorize_Helper.runningInASandbox()){
                request.setEndpoint(connection.Dev_Endpoint__c +'?EmpNo='+Integer.valueOf(empNumber));
            }else{
                request.setEndpoint(connection.LiveEndpoint_c__c +'?EmpNo='+Integer.valueOf(empNumber));
            }
            
            request.setHeader('Authorization','Basic '+paramvalue);          
            request.setHeader('Content-Type','application/json'); 
            request.setMethod('PUT');
            System.debug('--URL--->'+connection.LiveEndpoint_c__c +'?EmpNo='+Integer.valueOf(empNumber));
            
            response = http.send(request);
                 System.debug('----response GetBody--->'+response.getBody());
			objResponse = (JSON2EmpSyncRes)JSON.deserialize(response.getBody(), JSON2EmpSyncRes.class);
            System.debug('--response--->'+response);
            // Parse the JSON response
            if (response.getStatusCode() == 204 || response.getStatusCode() == 200) {
                msg=msg= objResponse.Message+'@Success';
                
            } else {
                msg=objResponse.Message+'@Failed';
                System.debug('The status code returned was not expected: ' +
                             response.getStatusCode() + ' ' + response.getStatus());
                System.debug(response.getBody());
            }
            
        }
        return msg;
        
    }
    
    
}