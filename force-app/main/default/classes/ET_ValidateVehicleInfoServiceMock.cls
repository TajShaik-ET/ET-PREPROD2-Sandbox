@isTest
global class ET_ValidateVehicleInfoServiceMock implements WebServiceMock {
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
        ET_ValidateVehicleInfo.ArrayOfLookup obj = new ET_ValidateVehicleInfo.ArrayOfLookup();
        ET_ValidateVehicleInfo.GetLookupValuesResponse_element response_x= new ET_ValidateVehicleInfo.GetLookupValuesResponse_element();
        response_x.GetLookupValuesResult = obj;
        response.put('response_x', response_x); 
   }
}