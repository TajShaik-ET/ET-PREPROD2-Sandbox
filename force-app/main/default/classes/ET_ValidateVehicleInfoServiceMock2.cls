@isTest
global class ET_ValidateVehicleInfoServiceMock2 implements WebServiceMock {
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
        ET_ValidateVehicleInfo.ArrayOfVehicleCheckList obj = new ET_ValidateVehicleInfo.ArrayOfVehicleCheckList();
        ET_ValidateVehicleInfo.GetLatestVehicleInspectionChecklistResponse_element response_x = new ET_ValidateVehicleInfo.GetLatestVehicleInspectionChecklistResponse_element();
        response_x.GetLatestVehicleInspectionChecklistResult = obj;
        response.put('response_x', response_x); 
   }
}