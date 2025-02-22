@isTest
global class ET_ValidateVehicleInfoServiceMock7 implements WebServiceMock {
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
      	  ET_ValidateVehicleInfo.ArrayOfViolationInformation  obj = new ET_ValidateVehicleInfo.ArrayOfViolationInformation();
          ET_ValidateVehicleInfo.GetViolationInspectionInformationResponse_element response_x= new ET_ValidateVehicleInfo.GetViolationInspectionInformationResponse_element();
        response_x.GetViolationInspectionInformationResult = obj;
        response.put('response_x', response_x); 
   }
}