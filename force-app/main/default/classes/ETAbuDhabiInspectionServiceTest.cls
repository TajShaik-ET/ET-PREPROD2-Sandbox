@isTest
public class ETAbuDhabiInspectionServiceTest {
    
    @isTest
    private static void abudhabiTest(){
        ETAbuDhabiInspectionService.GetLookupRequest lk = new ETAbuDhabiInspectionService.GetLookupRequest();
        
        ETAbuDhabiInspectionService.CheckVehicleWantedRequest rw = new ETAbuDhabiInspectionService.CheckVehicleWantedRequest();
        
        ETAbuDhabiInspectionService.ArrayOfPlateRecord aP = new ETAbuDhabiInspectionService.ArrayOfPlateRecord();
        ETAbuDhabiInspectionService.ArrayOfVehicleReferencesRecord aV = new ETAbuDhabiInspectionService.ArrayOfVehicleReferencesRecord();
        ETAbuDhabiInspectionService.PlateRecord plateRec = new ETAbuDhabiInspectionService.PlateRecord();
        ETAbuDhabiInspectionService.VehicleDetails vD = new ETAbuDhabiInspectionService.VehicleDetails();
        ETAbuDhabiInspectionService.insertFailureCause_element iFC = new ETAbuDhabiInspectionService.insertFailureCause_element();
        ETAbuDhabiInspectionService.CheckVehicleWantedResponse cVW = new ETAbuDhabiInspectionService.CheckVehicleWantedResponse();
        ETAbuDhabiInspectionService.getVehicleDetails_element getVD = new ETAbuDhabiInspectionService.getVehicleDetails_element();
        ETAbuDhabiInspectionService.getVehicleDetailsResponse_element getVDR = new ETAbuDhabiInspectionService.getVehicleDetailsResponse_element();
        ETAbuDhabiInspectionService.setInspectionResultResponse_element sIRE = new ETAbuDhabiInspectionService.setInspectionResultResponse_element();
        ETAbuDhabiInspectionService.getVehicleColorsResponse_element getaP = new ETAbuDhabiInspectionService.getVehicleColorsResponse_element();
        ETAbuDhabiInspectionService.GetLookupResponse getLR = new ETAbuDhabiInspectionService.GetLookupResponse();
        ETAbuDhabiInspectionService.ArrayOfLookupRecord aLR = new ETAbuDhabiInspectionService.ArrayOfLookupRecord();
        ETAbuDhabiInspectionService.PlateKey PlateKe = new ETAbuDhabiInspectionService.PlateKey();
        ETAbuDhabiInspectionService.Ticket Tic = new ETAbuDhabiInspectionService.Ticket();
        ETAbuDhabiInspectionService.GetVehicleTicketsResponse gVTR = new ETAbuDhabiInspectionService.GetVehicleTicketsResponse();
        ETAbuDhabiInspectionService.setInspectionResult_element setIns = new ETAbuDhabiInspectionService.setInspectionResult_element();
        ETAbuDhabiInspectionService.SetInspectionResultResponse setINR = new ETAbuDhabiInspectionService.SetInspectionResultResponse();
        ETAbuDhabiInspectionService.InsertFailureCauseRequest iFCR = new ETAbuDhabiInspectionService.InsertFailureCauseRequest();
        ETAbuDhabiInspectionService.getLookup_element getLE = new ETAbuDhabiInspectionService.getLookup_element();
        ETAbuDhabiInspectionService.getLookupResponse_element getLRE = new ETAbuDhabiInspectionService.getLookupResponse_element();
        ETAbuDhabiInspectionService.GetVehicleColorsRequest getVCR = new ETAbuDhabiInspectionService.GetVehicleColorsRequest();
        ETAbuDhabiInspectionService.getVehicleReferencesResponse_element getVRRE = new ETAbuDhabiInspectionService.getVehicleReferencesResponse_element();
        ETAbuDhabiInspectionService.LookupRecord lR = new ETAbuDhabiInspectionService.LookupRecord();
        ETAbuDhabiInspectionService.VehicleReferencesRecord vRRE = new ETAbuDhabiInspectionService.VehicleReferencesRecord();
        ETAbuDhabiInspectionService.GetVehicleColorsResponse getVCRes = new ETAbuDhabiInspectionService.GetVehicleColorsResponse();
        
        ETAbuDhabiInspectionService.getVehicleTickets_element getVeTic = new ETAbuDhabiInspectionService.getVehicleTickets_element();
        ETAbuDhabiInspectionService.getPlateCombinations_element getPlCo = new ETAbuDhabiInspectionService.getPlateCombinations_element();
        ETAbuDhabiInspectionService.UserIdentifierSoapHeaderIn usIdc = new ETAbuDhabiInspectionService.UserIdentifierSoapHeaderIn();
        ETAbuDhabiInspectionService.GetPlateCombinationsResponse getPlCombi = new ETAbuDhabiInspectionService.GetPlateCombinationsResponse();
        ETAbuDhabiInspectionService.ArrayOfTicket aOT = new ETAbuDhabiInspectionService.ArrayOfTicket();
        ETAbuDhabiInspectionService.getVehicleColors_element getVehCol = new ETAbuDhabiInspectionService.getVehicleColors_element();
        ETAbuDhabiInspectionService.GetVehicleTicketsRequest getVeTiR = new ETAbuDhabiInspectionService.GetVehicleTicketsRequest();
        ETAbuDhabiInspectionService.getVehicleReferences_element getVeREf = new ETAbuDhabiInspectionService.getVehicleReferences_element();
        ETAbuDhabiInspectionService.SetInspectionResultRequest setIR = new ETAbuDhabiInspectionService.SetInspectionResultRequest();
        ETAbuDhabiInspectionService.insertFailureCauseResponse_element iFailCauR = new ETAbuDhabiInspectionService.insertFailureCauseResponse_element();
        ETAbuDhabiInspectionService.GetVehicleDetailsRequest getVhDe = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
        ETAbuDhabiInspectionService.getPlateCombinationsResponse_element getPlCom = new ETAbuDhabiInspectionService.getPlateCombinationsResponse_element();
        ETAbuDhabiInspectionService.execute_pt exePt = new ETAbuDhabiInspectionService.execute_pt();
        
        
        ETAbuDhabiInspectionService.GetVehicleReferencesResponse vre = new ETAbuDhabiInspectionService.GetVehicleReferencesResponse();
        ETAbuDhabiInspectionService.ErrorHeader err = new ETAbuDhabiInspectionService.ErrorHeader();
        ETAbuDhabiInspectionService.checkVehicleWanted_element cvwe = new ETAbuDhabiInspectionService.checkVehicleWanted_element();
        ETAbuDhabiInspectionService.GetVehicleReferencesRequest gvrfr = new ETAbuDhabiInspectionService.GetVehicleReferencesRequest();
        ETAbuDhabiInspectionService.SetInspectionResultRequest sirr = new ETAbuDhabiInspectionService.SetInspectionResultRequest();
        ETAbuDhabiInspectionService.getVehicleTicketsResponse_element gvtre = new ETAbuDhabiInspectionService.getVehicleTicketsResponse_element();
        
        
        
        
        ETAbuDhabiInspectionService.GetPlateCombinationsRequest plate = new ETAbuDhabiInspectionService.GetPlateCombinationsRequest();
        ETAbuDhabiInspectionService.checkVehicleWantedResponse_element vwer = new ETAbuDhabiInspectionService.checkVehicleWantedResponse_element();
        
        ETAbuDhabiInspectionService.getVehicleDetailsResponse_element getvDRes = new ETAbuDhabiInspectionService.getVehicleDetailsResponse_element();
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        
        
    }
    static testmethod void testExecute() {
         Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.GetVehicleDetailsRequest request = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
        Test.startTest();
        ETAbuDhabiInspectionService.getVehicleDetailsResponse_element response = executePt.execute(request);
         ETAbuDhabiInspectionService.testCoverage();
        Test.stopTest();
        
    }
  /*  static testmethod void testSetInspectionResultMethod() {
        Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.SetInspectionResultRequest request = new ETAbuDhabiInspectionService.SetInspectionResultRequest();
        ETAbuDhabiInspectionService.SetInspectionResultResponse response = executePt.setInspectionResult(request);
        
    }
    static testmethod void testSetInspectionResultMethod1() {
        Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.GetVehicleColorsRequest req1 = new ETAbuDhabiInspectionService.GetVehicleColorsRequest();
        ETAbuDhabiInspectionService.GetVehicleColorsResponse res1 = executePt.getVehicleColors(req1);
        
    }
    static testmethod void testSetInspectionResultMethod2() {
        Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.CheckVehicleWantedRequest req2 = new ETAbuDhabiInspectionService.CheckVehicleWantedRequest();
        ETAbuDhabiInspectionService.CheckVehicleWantedResponse res2 = executePt.checkVehicleWanted(req2);
    }
    static testmethod void testSetInspectionResultMethod3() {
        Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.GetVehicleTicketsRequest req2 = new ETAbuDhabiInspectionService.GetVehicleTicketsRequest();
        ETAbuDhabiInspectionService.GetVehicleTicketsResponse res2 = executePt.getVehicleTickets(req2);
    }*/
    static testmethod void testSetInspectionResultMethod4() {
        Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.GetVehicleDetailsRequest request = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
        ETAbuDhabiInspectionService.getVehicleDetailsResponse_element response = executePt.getVehicleDetails(request);
    }
   /* static testmethod void testSetInspectionResultMethod5() {
        Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.GetPlateCombinationsRequest request = new ETAbuDhabiInspectionService.GetPlateCombinationsRequest();
        ETAbuDhabiInspectionService.GetPlateCombinationsResponse response = executePt.getPlateCombinations(request);
    }
    static testmethod void testSetInspectionResultMethod6() {
        Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.GetVehicleReferencesRequest request = new ETAbuDhabiInspectionService.GetVehicleReferencesRequest();
        ETAbuDhabiInspectionService.GetVehicleReferencesResponse response = executePt.getVehicleReferences(request);
    }
    static testmethod void testSetInspectionResultMethod7() {
        Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.GetLookupRequest request = new ETAbuDhabiInspectionService.GetLookupRequest();
        ETAbuDhabiInspectionService.GetLookupResponse response = executePt.getLookup(request);
    }*/
    static testmethod void testSetInspectionResultMethod8() {
        Test.setMock(WebServiceMock.class, new MockWebServiceMockImpl());
        ETAbuDhabiInspectionService.execute_pt executePt = new ETAbuDhabiInspectionService.execute_pt();
        ETAbuDhabiInspectionService.InsertFailureCauseRequest request = new ETAbuDhabiInspectionService.InsertFailureCauseRequest();
         executePt.insertFailureCause(request);
    }
    
    
}