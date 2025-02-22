@isTest
global class SendSMSCalloutMock implements WebServiceMock{
  global void doInvoke(
            Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        ET_SendSMS_API_Paramter.Output response_x = new ET_SendSMS_API_Paramter.Output();
        response_x.Status = 'S';
        response_x.Message = 'Sent Successfully';    
        // end
        response.put('response_x', response_x); 
   }
}