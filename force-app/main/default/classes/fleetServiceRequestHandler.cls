/***
Class       : fleetServiceRequestHandler
Author      : Janardhan Muddana
Description : create fleet service request in oracle
TestClass  : fleetServiceRequestHandlerTest
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              27/03/23           Initial Version 
****************************************************************************************************************/

public class fleetServiceRequestHandler {
    
    public static void processServiceRequest(list<Fleet_Service_Request__c> trgNew){
        
        for(Fleet_Service_Request__c fsr : [select id,name,Customer_Vehicle__r.Internal_No__c,Workshop_Location__r.Location_Code__c,Odometer_Km__c,Description__c,Account__r.AccountNumber from Fleet_Service_Request__c where Id=:trgNew ]){
            string interNo = fsr.Customer_Vehicle__r.Internal_No__c!=null?string.valueOf(fsr.Customer_Vehicle__r.Internal_No__c):null;
            string wrkshp = fsr.Workshop_Location__r.Location_Code__c!=null?string.valueOf(fsr.Workshop_Location__r.Location_Code__c):null;
            string customerNo = fsr.Account__r.AccountNumber!=null?string.valueOf(fsr.Account__r.AccountNumber):null;
            string Odometer = string.valueOf(fsr.Odometer_Km__c);
            string recId = string.valueOf(fsr.id);
            
            fleetServiceRequestHandler.createServiceReqInOracle(recId,interNo,wrkshp,fsr.Description__c,Odometer,customerNo,fsr.Name);
        }
        
    }
    @future(callout = true) 
    public static void createServiceReqInOracle(String recId,String interNo,String wrkshp,String Descr,String Odometer,String customer,string Name){
        
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('CreateFleetServiceRequest');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('InternalNumber',interNo);
        gen.writeStringField('Workshop',wrkshp);
        gen.writeStringField('Reference',Name);
        gen.writeStringField('Description',Descr);
        gen.writeStringField('OdometerReading',Odometer);
        gen.writeStringField('CustomerNumber',customer);    
        gen.writeEndObject();
        
        String jsonData = gen.getAsString();
        System.debug('jsonData');
        HttpRequest request = new HttpRequest();
        System.debug('body='+jsonData);
        
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c);
            system.debug(connection.Dev_Endpoint__c);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c);
        }  
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonData);      
        request.setHeader('Authorization','Basic '+paramvalue);   
        Http http = new Http();
        HttpResponse response = http.send(request);
        Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        Fleet_Service_Request__c fsr = new Fleet_Service_Request__c();
        fsr.Id = recId;
        if (response.getStatusCode() == 200) {
            if(string.valueOf(result.get('Status')) =='S'){
               fsr.Integration_Status__c ='Success'; 
                fsr.Service_Number__c = string.valueOf(result.get('ServiceNumber'));
            }else{
                fsr.Integration_Status__c ='Error';  
                fsr.Service_Number__c = string.valueOf(result.get('Message'));
            }
            fsr.Integration_Message__c =string.valueOf(result.get('Message'));
            
            
            update fsr;
        }
        else{
            fsr.Integration_Message__c =string.valueOf(result.get('Message'));
            fsr.Integration_Status__c ='Error';
            update fsr;
        }
        
            
    }

}