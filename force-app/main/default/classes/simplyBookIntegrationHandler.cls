/***
Class       : simplyBookIntegrationHandler
Author      : Janardhan Muddana
Description : create booking request in Simplybook(3rd party website)
TestClass  : simplyBookIntegrationHandlerTest
HelperClass: simplyBook_getClientInfoWrapper
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date       Author          Details
1.          V1.0              12/06/23    Janardhan      Initial Version 
****************************************************************************************************************/
public class simplyBookIntegrationHandler {
    public static string accessToken;
    public static string endpointUrl;
    public static string username;
    public static string password;   
    
    
    @AuraEnabled
    public static string createSimplybookRequest(Lead leadDetails){
        string dateVal;
        string categoryId;
        string serviceId;
        string providerId;
        
        accessToken = getAccessToken();
        
        if(accessToken != 'Error'){
            if(leadDetails.Appointment_Date__c != null)
                dateVal= leadDetails.Appointment_Date__c.format('yyyy-MM-dd h:mm a');  
            list<Simplybook_Configuration__mdt> configList = [select id,MasterLabel,Simplybook_Id__c from Simplybook_Configuration__mdt];
            
            if(leadDetails.Preferred_Location__c != null){
                for(Simplybook_Configuration__mdt sim : configList ){
                    
                    if(sim.MasterLabel == leadDetails.Preferred_Location__c){
                        providerId = sim.Simplybook_Id__c;  
                        break;
                    }
                }
            }
            if(leadDetails.Campaign__c!= null){
                categoryId = leadDetails.Campaign__c == null?'':leadDetails.Campaign__r.Simplybook_Category_Id__c;
                serviceId = leadDetails.Campaign__c == null?'':leadDetails.Campaign__r.Simplybook_Service_Id__c;
                
            }else if(leadDetails.List_of_Required_Services__c != null && leadDetails.Service_Cateogry__c!= null){  
                list<string> serviceList =leadDetails.List_of_Required_Services__c.split(';');
                list<string> cateogryList =leadDetails.Service_Cateogry__c.split(';');
                
                for(Simplybook_Configuration__mdt sim : configList ){
                    
                    if(sim.MasterLabel == serviceList[0]){
                        serviceId = sim.Simplybook_Id__c;                        
                    }
                    if(sim.MasterLabel == cateogryList[0]){
                        categoryId = sim.Simplybook_Id__c;                        
                    }
                    
                }
            }
            
            system.debug(leadDetails);
            system.debug(dateVal);
            system.debug(providerId);
            system.debug(categoryId);
            system.debug(serviceId);
            system.debug(accessToken);
            
            string clientId;
            clientId = checkAndGetClientId(leadDetails.Name,leadDetails.Email,leadDetails.MobilePhone);
            
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeNumberField('count',1);
            gen.writeStringField('start_datetime',dateVal);
            gen.writeNumberField('category_id',Integer.valueOf(categoryId)); //service Category
            gen.writeNumberField('provider_id',Integer.valueOf(providerId)); //Location
            gen.writeNumberField('service_id',Integer.valueOf(serviceId)); //Campaign
            gen.writeNumberField('client_id',Integer.valueOf(clientId)); //Customer Info
            gen.writeFieldName('additional_fields');
            gen.writeStartArray();       
            gen.writeStartObject();
            gen.writeStringField('field','4f4ad78731ca366ef5655b795ccefd56');//Car Brand
            gen.writeStringField('value',leadDetails.Vehicle_Brand__r.Name);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('field','e68cc0fcb504ebd3c07995a1b8b70ad0');//Model Type
            gen.writeStringField('value',leadDetails.Moto_Vehicle_Model__r.Name);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('field','4dd902d3429c0f70d3d0a8b44e9086f5');//Model Year
            gen.writeStringField('value',leadDetails.ETM_Vehicle_Model__c);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('field','fcea8fc4697f099484670f6ed177f944');//CRM link
            gen.writeStringField('value',URL.getSalesforceBaseUrl().toExternalForm()+'/'+leadDetails.Id);
            gen.writeEndObject();
            gen.writeStartObject();
            gen.writeStringField('field','2ac2c51d917444301cd90f494d5c2655');//Notes
          
            string camp = leadDetails.Campaign__c==null?'':leadDetails.Campaign__r.Name;
            string description ='Owner:'+leadDetails.Owner.Name+'\n Vehicle Info:'+leadDetails.Vehicle_Brand__r.Name+'-'+leadDetails.Moto_Vehicle_Model__r.Name+'-'+leadDetails.ETM_Vehicle_Model__c+'\n Chassis No.:'+leadDetails.Vehicle_Chassis__c+'\n Plate No:'+leadDetails.Vehicle_Plate_Number__c+'\n Service Type:'+leadDetails.Type_of_Services__c+'-'+leadDetails.List_of_Required_Services__c+'\n Campaign:'+camp+'\n Desc:'+leadDetails.Description;
         
            system.debug(description);
            gen.writeStringField('value',description);
            gen.writeEndObject();
            gen.writeEndArray();
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            
            system.debug(jsonData); 
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpointUrl+'/admin/bookings');
            request.setMethod('POST');
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('X-Company-Login','emiratesmoto');
            request.setHeader('X-Token',accessToken);
            request.setBody(jsonData); 
            if(!test.isRunningTest()){
                HttpResponse response = http.send(request);
                system.debug(response.getBody());
                Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                return response.getBody();
               
            }else{
                return null;
            }
            
            
        }else{
            return 'Error';
        }
    }
    
    public static string checkAndGetClientId(string fulName,string email,string phone){
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointUrl+'/admin/clients?filter[search]='+phone);
        request.setMethod('GET');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('X-Company-Login','emiratesmoto');
      
            system.debug('accc'+accessToken);
            request.setHeader('X-Token',accessToken);
            
            HttpResponse response = http.send(request);
            system.debug(response.getBody());
            if (response.getStatusCode() == 200) {
                simplyBook_getClientInfoWrapper dataInfo = simplyBook_getClientInfoWrapper.parse(response.getBody());
                if(dataInfo.data != null && dataInfo.data.size()>0){
                    //system.debug(dataInfo.data[0].id);
                    return string.valueOf(dataInfo.data[0].id);
                }else{
                    return createClient(fulName,email,phone);
                }
                
            }else{
                return 'Error';
            }
        
    }
    public static string createClient(string fullName,string email,string phone){
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('name',fullName);
        gen.writeStringField('email',email);
        gen.writeStringField('phone',phone);        
        gen.writeEndObject();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointUrl+'/admin/clients');
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('X-Company-Login','emiratesmoto');
        request.setHeader('X-Token',accessToken);
       
            request.setBody(gen.getAsString());  
            HttpResponse response = http.send(request);
                system.debug(response.getBody());
            if (response.getStatusCode() == 200) {
               
                Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                return string.valueOf(result.get('id'));
            }else{
                return 'Error';
            }
       
    }
   
    public static string getAccessToken(){
       
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('MOTO_SimplyBook');
        
        username = connection.Username__c;
        password = connection.Password__c;
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            endpointUrl = connection.Dev_Endpoint__c;            
        }else{
            endpointUrl =connection.LiveEndpoint_c__c;
        }        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('company','emiratesmoto');
        gen.writeStringField('login',username);
        gen.writeStringField('password',password);        
        gen.writeEndObject();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointUrl+'/admin/auth');
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(gen.getAsString());  
       
            HttpResponse response = http.send(request);
            system.debug(response.getBody());
            if (response.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                return string.valueOf(result.get('token'));
            }else{
                return 'Error';
            }
        
        
    }
}