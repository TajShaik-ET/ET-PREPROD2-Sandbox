@isTest
global class ET_ValidateVehicleInfoServiceMock5 implements WebServiceMock {
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
          ET_ValidateVehicleInfo.VehicleInfromation  obj = new ET_ValidateVehicleInfo.VehicleInfromation();
          ET_ValidateVehicleInfo.GetValidateVehicleInformationResponse_element response_x = new  ET_ValidateVehicleInfo.GetValidateVehicleInformationResponse_element();
        response_x.GetValidateVehicleInformationResult = obj;
        response.put('response_x', response_x); 
   }
}