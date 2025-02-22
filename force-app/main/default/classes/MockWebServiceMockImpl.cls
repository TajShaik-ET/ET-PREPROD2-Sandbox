@isTest

    
     public class MockWebServiceMockImpl implements WebServiceMock {
        
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            // Check the request name and provide appropriate mock response
            if (requestName == 'getVehicleDetails') {
              
                ETAbuDhabiInspectionService.getVehicleDetailsResponse_element mockResponse = new ETAbuDhabiInspectionService.getVehicleDetailsResponse_element();
                response.put('response_x', mockResponse);
            } else if (requestName == 'setInspectionResult') {
                ETAbuDhabiInspectionService.SetInspectionResultResponse mockResponse = new ETAbuDhabiInspectionService.SetInspectionResultResponse();
               response.put('response_x', mockResponse);
            } else if (requestName == 'getVehicleColors') {
                Map<String, ETAbuDhabiInspectionService.getVehicleColorsResponse_element> responseMap = new Map<String, ETAbuDhabiInspectionService.getVehicleColorsResponse_element>();
                ETAbuDhabiInspectionService.getVehicleColorsResponse_element responseElement = new ETAbuDhabiInspectionService.getVehicleColorsResponse_element();
                responseMap.put('response_x', responseElement);
                
                //ETAbuDhabiInspectionService.GetVehicleColorsResponse mockResponse = new ETAbuDhabiInspectionService.GetVehicleColorsResponse();
                //response.put('response_x', mockResponse);
            }else if (requestName == 'checkVehicleWanted') {
                Map<String, ETAbuDhabiInspectionService.checkVehicleWantedResponse_element> responseMap = new Map<String, ETAbuDhabiInspectionService.checkVehicleWantedResponse_element>();
                ETAbuDhabiInspectionService.checkVehicleWantedResponse_element responseElement = new ETAbuDhabiInspectionService.checkVehicleWantedResponse_element();
                responseMap.put('response_x', responseElement);
                
                // ETAbuDhabiInspectionService.CheckVehicleWantedResponse mockResponse = new ETAbuDhabiInspectionService.CheckVehicleWantedResponse();
                //response.put('response_x', mockResponse);
            } else if (requestName == 'getVehicleTickets') {
                ETAbuDhabiInspectionService.GetVehicleTicketsResponse mockResponse = new ETAbuDhabiInspectionService.GetVehicleTicketsResponse();
               response.put('response_x', mockResponse);
            } else if (requestName == 'getVehicleDetails') {
                ETAbuDhabiInspectionService.getVehicleDetailsResponse_element mockResponse = new ETAbuDhabiInspectionService.getVehicleDetailsResponse_element();
               response.put('response_x', mockResponse);
            }else if (requestName == 'getPlateCombinations') {
                ETAbuDhabiInspectionService.GetPlateCombinationsResponse mockResponse = new ETAbuDhabiInspectionService.GetPlateCombinationsResponse();
                response.put('response_x', mockResponse);
            }else if (requestName == 'getVehicleReferences') {
                ETAbuDhabiInspectionService.GetVehicleReferencesResponse mockResponse = new ETAbuDhabiInspectionService.GetVehicleReferencesResponse();
                response.put('response_x', mockResponse);
            }else if (requestName == 'getLookup') {
                Map<String, ETAbuDhabiInspectionService.getLookupResponse_element> responseMap = new Map<String, ETAbuDhabiInspectionService.getLookupResponse_element>();
                ETAbuDhabiInspectionService.getLookupResponse_element responseElement = new ETAbuDhabiInspectionService.getLookupResponse_element();
                if (responseElement != null) {
                     responseMap.put('response_x', responseElement);
                } else {
                  responseMap.put('response_x', null);
                }
              
                
                // ETAbuDhabiInspectionService.GetLookupResponse mockResponse = new ETAbuDhabiInspectionService.GetLookupResponse();
                // response.put('response_x', mockResponse);
            }
            
            
        }
    }