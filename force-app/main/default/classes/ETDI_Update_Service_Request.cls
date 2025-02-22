@RestResource(urlMapping='/updateServiceRequest/*')
global class ETDI_Update_Service_Request {
    
  
    @HttpPost
    global static updateServiceRequestResult updateServiceRequestStatus(){
        updateServiceRequestResult responseWrapper = new updateServiceRequestResult();
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            system.debug('req.requestBody.tostring() '+req.requestBody.tostring());
            Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(req.requestBody.tostring());
            system.debug('responseMap '+responseMap);
            system.debug(' SSS '+responseMap.containsKey('serviceRequestNumber'));
            String serviceRequestNumber ='';
			//String serviceRequestStatus = '';            
            String status = '';           
            String errorMessage = '';
            Boolean hasError = false;
            
            if(responseMap.containsKey('serviceRequestNumber')){
                serviceRequestNumber = (String) responseMap.get('serviceRequestNumber');
            }else{
                errorMessage =+ 'serviceRequestNumber Is missing. | ';
                hasError = true;
            }           
           
            if(responseMap.containsKey('Status')){
                status = (String) responseMap.get('Status');
            }else{
                errorMessage =+ 'Please enter Service Request status. | ';
                hasError = true;
            }               
            
            List<ETDI_Service_Request__c> servicerequestList = [Select id,Name from ETDI_Service_Request__c where Service_Request_Num__c =:serviceRequestNumber];
            
            Map<String, String> serviceRequestStatusoptions = new Map<String, String>();
            Schema.DescribeFieldResult fieldResult = ETDI_Service_Request__c.Status__c.getDescribe();
            system.debug('fieldResult - '+fieldResult);
            List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
            system.debug('getProdcutCategory - '+pList);
            for (Schema.PicklistEntry p: pList) {    
               
                    serviceRequestStatusoptions.put(p.getValue(), p.getLabel());                  
            }  
            
            if(!serviceRequestStatusoptions.containsKey(status))
            {
                 errorMessage =+ 'Please provide correct Status. | ';
                errorMessage = errorMessage.trim();
                errorMessage = errorMessage.remove('|');
                return returnWrapper(errorMessage,300,'FAILURE');
			}
            if(hasError){
                errorMessage = errorMessage.trim();
                errorMessage = errorMessage.remove('|');
                return returnWrapper(errorMessage,300,'FAILURE');
            }else if(servicerequestList.size()<=0)
            {
                errorMessage =+ 'Service Request Number is not present in Salesforce. | ';
                errorMessage = errorMessage.trim();
                errorMessage = errorMessage.remove('|');
                return returnWrapper(errorMessage,300,'FAILURE');
			}
            else{              
                ETDI_Service_Request__c serviceRequest = servicerequestList[0];                
                serviceRequest.Status__c = status;
  
                Update serviceRequest;                                
              
                return  returnWrapper('Updated successfully!',200,'SUCCESS');
            }
            
        }catch(Exception e){
            system.debug('EXCEPTION '+ e.getStackTraceString());
            responseWrapper.statusCode = 300;
            responseWrapper.status = 'FAILURE';
            responseWrapper.message = e.getMessage();
            return responseWrapper;
        }
    }
    
    public static updateServiceRequestResult returnWrapper(String errorMessage,Integer statusCode,String status){
        updateServiceRequestResult responseWrapper = new updateServiceRequestResult();
        responseWrapper.statusCode = statusCode;
        responseWrapper.status = status;
        responseWrapper.message = errorMessage;
        return responseWrapper;
    }
    
    global Class updateServiceRequestResult{
        Integer statusCode;
        String message;
        String status;
    }
}