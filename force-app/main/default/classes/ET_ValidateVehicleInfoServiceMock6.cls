@isTest
global class ET_ValidateVehicleInfoServiceMock6 implements WebServiceMock {
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
          ET_ValidateVehicleInfo.StatusConfirmation  obj = new ET_ValidateVehicleInfo.StatusConfirmation();
          ET_ValidateVehicleInfo.CheckViolationResponse_element response_x = new ET_ValidateVehicleInfo.CheckViolationResponse_element();
        response_x.CheckViolationResult = obj;
        response.put('response_x', response_x); 
   }
}