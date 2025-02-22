@isTest
global class ET_ValidateVehicleInfoServiceMock4 implements WebServiceMock {
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
      	 ET_ValidateVehicleInfo.StatusConfirmation obj = new ET_ValidateVehicleInfo.StatusConfirmation();
         ET_ValidateVehicleInfo.ExportPaymentInformationResponse_element response_x = new  ET_ValidateVehicleInfo.ExportPaymentInformationResponse_element();
        response_x.ExportPaymentInformationResult = obj;
        response.put('response_x', response_x); 
   }
}