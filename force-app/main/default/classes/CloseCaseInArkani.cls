public class CloseCaseInArkani {
    
    @Future(callout=true)
    public static void updateArkaniIdUponCaseClosure(Id CaseID)
    {
        String isArkaniUpdated = '';
        
        //  Id caseidcheck = '5002z000001aUj1AAE';
        
        Case cs = [Select id,Arkani_Incident_ID__c,Status,Arkani_Integration_Status__c from Case where id=:CaseID];
        
        String arkaniId = cs.Arkani_Incident_ID__c;
        system.debug('arkaniId'+arkaniId);
        Integer arkaniIdInt = 0;  
        if(arkaniId==null||arkaniId=='')
        {
            cs.Arkani_Integration_Status__c = 'Arkani Incident Id is not provided';
            update cs;
        }
        else
        {
            Boolean conversionNotFailed = true;
            try
            {
                arkaniIdInt = Integer.valueOf(arkaniId);   
                system.debug('arkaniIdInt'+arkaniIdInt);
                conversionNotFailed = true;
            }catch(Exception e)
            {
                cs.Arkani_Integration_Status__c = 'Please provide arkani ID in Numeric';
                update cs;
                conversionNotFailed = false;
            }
            
            if(conversionNotFailed)
            {
                HttpRequest request = new HttpRequest();
            String body = '';
            body = '{"IncidentId": "'+arkaniIdInt + '"}';
            
            
            request= createRequest('POST', '/soa-infra/resources/FMS_Interfaces/ArkanyIncident/IncidentRest');
            request.setBody(body);
                
            Arkani_API_Credentials__mdt	credentialsMetadata=[Select Password__c,UserName__c from Arkani_API_Credentials__mdt where DeveloperName = 'Arkani_Credential'];                 
            //String Username = 'Salesforce';
            //String password = 'salesforce123';
            String Username = credentialsMetadata.UserName__c;
            String password = credentialsMetadata.Password__c;    
            
            String combined = Username+':'+password;
            Blob beforeblob = Blob.valueOf(combined);
            
            string base64Key = EncodingUtil.base64Encode(beforeblob);
            System.debug('paramvalue='+base64Key);
            String AuthroizationValue = 'Basic '+base64Key;
            request.setHeader('Authorization', AuthroizationValue);   
            request.setTimeout(120000);
            Map<String, Object> responseResult =new Map<String, Object>();
            Http http = new Http();               
            HttpResponse response = http.send(request);
                
            
            if (response.getStatusCode() != 200) {
                
                System.debug('Failed ');
                responseResult = null;
                isArkaniUpdated = 'Integration Failed';
                cs.Arkani_Integration_Status__c = 'Integration Failed';
                update cs;
                //   System.debug('Error in Request. Error Body = '+response.getBody());
                // System.debug('Error in Request. Error Response = '+response.getStatusCode());
            }
            else{
                if(response.getStatusCode() == 200){
                    System.debug('Sucess ');
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    responseResult =result;
                }
                
            }
            
            if(responseResult!=null)
            {
               
                String ResponseMessage =(String)responseResult.get('Message');
                String ResponseStatus =(String)responseResult.get('Status');
                System.debug('ResponseStatus='+ResponseStatus);
                System.debug('ResponseMessage='+ResponseMessage);
                if(ResponseStatus=='S')
                {
                    cs.Arkani_Integration_Status__c = 'Sucessfully Closed Case in Arkani';
                    update cs;
                }
                else
                {
                    cs.Arkani_Integration_Status__c = ResponseMessage;
                    update cs;
                }
            }  
            }
        }
    }
	@Future(callout=true)
    public static void updateArkaniIdUponCase(Id CaseID)
    {
        String isArkaniUpdated = '';
        
        Case cs = [Select id,Arkani_Incident_ID__c,Status,Arkani_Integration_Status__c,casenumber,Solution_Completed_Date__c,SiteVisitTimestamp__c from Case where id=:CaseID];
        
        String arkaniId = cs.Arkani_Incident_ID__c;
        system.debug('arkaniId'+arkaniId);
        Integer arkaniIdInt = 0;  
        if(arkaniId==null||arkaniId=='')
        {
            cs.Arkani_Integration_Status__c = 'Arkani Incident Id is not provided';
            update cs;
        }
        else
        {
            Boolean conversionNotFailed = true;
            try
            {
                arkaniIdInt = Integer.valueOf(arkaniId);   
                system.debug('arkaniIdInt'+arkaniIdInt);
                conversionNotFailed = true;
            }catch(Exception e)
            {
                cs.Arkani_Integration_Status__c = 'Please provide arkani ID in Numeric';
                update cs;
                conversionNotFailed = false;
            }
            if(conversionNotFailed)
            {
                HttpRequest request = new HttpRequest();
            String body = '';
                String solcompdate='';
                if(cs.Solution_Completed_Date__c!=null)
                  solcompdate=''+ Datetime.valueOf(cs.Solution_Completed_Date__c);
			String sitevist= '';
                if(cs.SiteVisitTimestamp__c!=null)
             sitevist=''+Datetime.valueOf(cs.SiteVisitTimestamp__c);
            body = '{"IncidentId": "'+arkaniIdInt + '", "CaseNumber": "'+cs.casenumber+ '", "Status": "'+cs.status +'", "SiteVisitTimestamp": "'+ sitevist +'", "ExpectedClosureDate": "'+ solcompdate +'"}';
            request= createRequest('POST', '/soa-infra/resources/FMS_Interfaces/ArkanyIncident/IncidentRest');
            request.setBody(body);
                
            Arkani_API_Credentials__mdt	credentialsMetadata=[Select Password__c,UserName__c from Arkani_API_Credentials__mdt where DeveloperName = 'Arkani_Credential'];                 
            String Username = credentialsMetadata.UserName__c;
            String password = credentialsMetadata.Password__c;    
            
            String combined = Username+':'+password;
            Blob beforeblob = Blob.valueOf(combined);
            
            string base64Key = EncodingUtil.base64Encode(beforeblob);
            System.debug('paramvalue='+base64Key);
            String AuthroizationValue = 'Basic '+base64Key;
            request.setHeader('Authorization', AuthroizationValue);   
            Map<String, Object> responseResult =new Map<String, Object>();
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() != 200) {
                
                System.debug('Failed ');
                responseResult = null;
                isArkaniUpdated = 'Integration Failed';
                cs.Arkani_Integration_Status__c = 'Integration Failed';
                update cs;
            }
            else{
                if(response.getStatusCode() == 200){
                    System.debug('Sucess ');
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    responseResult =result;
                }
            }
            if(responseResult!=null)
            {
               
                String ResponseMessage =(String)responseResult.get('Message');
                String ResponseStatus =(String)responseResult.get('Status');
                System.debug('ResponseStatus='+ResponseStatus);
                System.debug('ResponseMessage='+ResponseMessage);
                if(ResponseStatus=='S')
                {
                    cs.Arkani_Integration_Status__c = 'Sucessfully updated Case in Arkani';
                    update cs;
                }
                else
                {
                    cs.Arkani_Integration_Status__c = ResponseMessage;
                    update cs;
                }
            }  
            }
        }
    }
    
    public static HttpRequest createRequest(final String method, final String path) {
        
        final HttpRequest req = new HttpRequest();
        //  System.debug(' path in fucntion ='+path);
        //  req.setEndpoint('callout:ETDI_Staging_Endpoint' + path);
        //  req.setEndpoint(Label.ETDI_End_Point_Domain + path);
        //req.setEndpoint('https://etdevsoa.et.gov.ae' + path);
        req.setEndpoint(Label.caseEndPointURL + path);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');
        
        return req;
    }
    
}