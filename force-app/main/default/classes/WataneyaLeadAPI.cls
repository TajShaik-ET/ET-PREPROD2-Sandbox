@RestResource(urlMapping='/WATANEYALEAD/*')
global with sharing class WataneyaLeadAPI {
    @HttpPost
    global static void doPost(){
        System.debug('In do post>>>>');
        string jsonRequestStr = RestContext.request.requestBody.toString();
        string msgStr;
        boolean success;
        String LedId;
        String response;
        RequestWrapper wrapper = RequestWrapper.parse(jsonRequestStr);
        
        try{
            System.debug('In Try>>>>');
            // Get the record type ID for lead
            String leadRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Wataneya' LIMIT 1].Id;
            // Create Lead
            Lead ld = new Lead();
            ld.FirstName = wrapper.firstName;
            ld.LastName = wrapper.lastName;
            ld.Email = wrapper.email;
            ld.Phone = wrapper.mobile;
            ld.Subject__c = wrapper.subject;
            ld.LeadSource = 'Website';
            ld.contactMethod__c = wrapper.contactMethod;
            ld.Description  = wrapper.description;
            ld.RecordTypeId = leadRecordTypeId;
            System.debug('wrapper.serviceType>>>>'+ wrapper.serviceType);
            if(wrapper.serviceType == 'Direct Sale' || wrapper.serviceType == 'Car Detailing' || wrapper.serviceType == 'Road-side Assistance' || wrapper.serviceType == 'Auto Inspections' || wrapper.serviceType == 'Maintenance & Repairs')
            {   
                ld.Service_Type__c = wrapper.serviceType;
            }
            else
            {
                ld.Service_Type__c = 'General Inquiry';
            }
            insert ld;
            
            LedId = ld.Id;
            success = true;
            msgStr = 'Lead Created Successfully'; 
            
        }catch(Exception ex) {
            LedId = '';
            success = false;
            msgStr = ex.getMessage();
            
            ET_Error_Logs__c err = new ET_Error_Logs__c();
            err.ET_Exception_Message__c	 =  msgStr;
            err.ET_Module__c = 'Wataneya Lead API';            
            insert err;
            
        }
        
        //Get Response
        response = getResponse(success,LedId,msgStr);
        //Send Response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = blob.valueOf(response);
    }
    
    //Request Wrapper
    public class RequestWrapper {
		public String firstName;    
        public String lastName;
		public String email;
        public String mobile;
        public String subject;
        public String contactMethod;
        public String description;
        public string serviceType;
        
    }
    //Parse - Deseriliaze Request
    public static RequestWrapper parse(String json){
        return (RequestWrapper) System.JSON.deserialize(json, RequestWrapper.class);
    }
    //Response Wrapper
    public class ResponseWrapper {
        public boolean success;
        public String LeadId;
        public String message;
        
    }
    //Create Response
    public static string getResponse(boolean success,string led,string msg){

        ResponseWrapper respWrapper = new ResponseWrapper();
        respWrapper.success = success;
        respWrapper.LeadId = led;
        respWrapper.message = msg;     
        return JSON.serialize(respWrapper);
    }
    
}