public class ETDI_Service_Requests {
    
    public static HttpRequest createRequest(final String method, final String path) {
        
        final HttpRequest req = new HttpRequest();
      //  System.debug(' path in fucntion ='+path);
      //  req.setEndpoint('callout:ETDI_Staging_Endpoint' + path);
       // req.setEndpoint('https://rtainterface.et.gov.ae' + path);
         req.setEndpoint('https://etdi.gov.ae' + path);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');

        return req;
    }
    
    public static Map<String, Object> getTokenUsingMobileNumber(Id AccountId){
        
        Account acc= [Select id , ETIN_Mobile_Number__c,PersonMobilePhone,Phone from Account where id=:AccountId];
        String body ='';
        String MobileNumber = '';
        if(acc.PersonMobilePhone!=null)
        {
            MobileNumber = acc.PersonMobilePhone; 
        }
      /* else if(acc.ETIN_Mobile_Number__c!=null)
        {
             MobileNumber = acc.ETIN_Mobile_Number__c; 
        }
        */
        if(MobileNumber.contains('+'))
        {
            MobileNumber = MobileNumber.replace('+', '');
		}
        
        HttpRequest request = new HttpRequest();
        
        body = '{"mobile": "'+MobileNumber + '"}';
        
     
        request= ETDI_Service_Requests.createRequest('POST', '/ETASWApi/api/WebApi/doGetAuthroizedTokenByMobile');
		   request.setBody(body);
        
       System.debug('entered getTokenUsingMobileNumber');
        Map<String, Object> responseResult =new Map<String, Object>();
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {


            responseResult = null;
            System.debug('Error in Request. Error Body = '+response.getBody());
            System.debug('Error in Request. Error Response = '+response.getStatusCode());
        }
        else{
            if(response.getStatusCode() == 200){
            Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
          //  List<Object> objectNames = (List<Object>)result.get('Data');
         //   System.debug('objectname='+objectNames);
        //    responseResult = (Map<String, Object>)objectNames[0];
            responseResult =result;
            //System.debug('Tokens='+getTokenMap.get('Token'));
          //  responseResult = (String)getTokenMap.get('Token');
       				System.debug('Success');
                    System.debug('Response Body='+response.getBody());
             //   responseResult = String.valueOf( JSON.deserializeUntyped(response.getBody()) );
                }
                
            }
        
       return responseResult;
    }        
           
    public static Map<String, Object> getTokenUsingTFN(Id AccountId){
        
        Account acc= [Select id ,TFN_Number__c from Account where id=:AccountId];
        String body ='';
        String TFNNumber = String.valueOf(acc.TFN_Number__c);
        System.debug('TFNNUmber ='+TFNNumber);
        HttpRequest request = new HttpRequest();
        
        
        request= createRequest('GET', '/ETASWApi/api/WebApi/doGetAuthroizedTokenByTFN');
        //	   request.setBody(body);
        request.setHeader('TFN', TFNNumber);	   
        
        System.debug('entered getTokenUsingTFNStaging');
        Map<String, Object> responseResult =new Map<String, Object>();
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            
            
            responseResult = null;
            System.debug('Error in Request. Error Body = '+response.getBody());
            System.debug('Error in Request. Error Response = '+response.getStatusCode());
        }
        else{
            if(response.getStatusCode() == 200){
                Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                //  List<Object> objectNames = (List<Object>)result.get('Data');
                //   System.debug('objectname='+objectNames);
                //    responseResult = (Map<String, Object>)objectNames[0];
                responseResult =result;
                //System.debug('Tokens='+getTokenMap.get('Token'));
                //  responseResult = (String)getTokenMap.get('Token');
                System.debug('Success');
                System.debug('Response Body='+response.getBody());
                //   responseResult = String.valueOf( JSON.deserializeUntyped(response.getBody()) );
            }
            
        }
        
        return responseResult;
    }
  
    public static String changeRequestForETDI(httpRequest req,String Token){
        //System.debug('entered getTheorySchedule');
        String responseResult ='' ;
        Http http = new Http();
        req.setHeader('token', Token); 
        HttpResponse response = http.send(req);
        if (response.getStatusCode() != 200) {
            
            
            responseResult = '' ;
            System.debug('Error in Request. Error Body = '+response.getBody());
            System.debug('Error in Request. Error Response = '+response.getStatusCode());
        }
        else{
            if(response.getStatusCode() == 200){
                responseResult = response.getBody();
                System.debug('Success');
                System.debug('Response Body='+response.getBody());
                
            }
            
        }
        
        return responseResult;
    }
    
    public static Map<String, Object> getServiceResult(httpRequest req,String Token){
        System.debug('entered getTheorySchedule');
        Map<String, Object> responseResult =new Map<String, Object>();
        Http http = new Http();
        req.setHeader('token', Token); 
        HttpResponse response = http.send(req);
        if (response.getStatusCode() != 200) {
            
            
            responseResult = Null ;
            System.debug('Error in Request. Error Body = '+response.getBody());
            System.debug('Error in Request. Error Response = '+response.getStatusCode());
        }
        else{
            if(response.getStatusCode() == 200){
                responseResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                System.debug('Success');
                System.debug('Response Body='+response.getBody());
                
            }
            
        }
        
        return responseResult;
    }
    
    public static String checkTokenForMobileNumber(Id AccountId)
    {
        String Token='';
        String UserId='';
        String StudentID='';
        String TokenServiceMessage='';
        String finalvalue= '';
        
        Map<String,object> TokenserviceResponse = getTokenUsingMobileNumber(AccountId);
        
        
        if(TokenserviceResponse!=null)
        {
            TokenServiceMessage = (String)TokenserviceResponse.get('Message');
            if(TokenServiceMessage=='Authorized')
            {
                List<Object> objectNames = (List<Object>)TokenserviceResponse.get('Data');
                Map<String, Object> tokenservicemap = new Map<String, Object>();
                tokenservicemap = (Map<String, Object>)objectNames[0];
                Token = (String)tokenservicemap.get('Token');
                UserId = (String)tokenservicemap.get('UserId');
                StudentID = (String)tokenservicemap.get('StudentId');
                System.debug('Final Token='+tokenservicemap.get('Token'));
                System.debug('User Id='+tokenservicemap.get('UserId'));
                System.debug('StudentId ='+tokenservicemap.get('StudentId'));
                finalvalue = Token + ',' + UserId + ',' + StudentID;
                
            }
        }
        else
        {
            
            System.debug('came into else');
        }
        return finalvalue;
        
    }
    public static String checkTokenForTFN(Id AccountId)
    {
        String Token='';
        String UserId='';
        String StudentID='';
        String TokenServiceMessage='';
        String finalvalue= '';
        
        Map<String,object> TokenserviceResponse = getTokenUsingTFN(AccountId);
        
        
        if(TokenserviceResponse!=null)
        {
            TokenServiceMessage = (String)TokenserviceResponse.get('Message');
            if(TokenServiceMessage=='Authorized')
            {
                List<Object> objectNames = (List<Object>)TokenserviceResponse.get('Data');
                Map<String, Object> tokenservicemap = new Map<String, Object>();
                tokenservicemap = (Map<String, Object>)objectNames[0];
                Token = (String)tokenservicemap.get('Token');
                UserId = (String)tokenservicemap.get('UserId');
                StudentID = (String)tokenservicemap.get('StudentId');
                System.debug('Final Token='+tokenservicemap.get('Token'));
                System.debug('User Id='+tokenservicemap.get('UserId'));
                System.debug('StudentId ='+tokenservicemap.get('StudentId'));
                finalvalue = Token + ',' + UserId + ',' + StudentID;
                
            }
        }
        else
        {
            
            System.debug('came into else');
        }
        return finalvalue;
        
    }    
   
}