@isTest
global class CICO_Services_Mock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        
         HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        res.setBody('{"XxetFmsInspectionHdrStgCollection":{"XxetFmsInspectionHdrStg":[{"intimationId":4258,"grnDate":"2021-05-25T16:34:15.125","shippedDate":"2021-05-25T16:34:15.126","createdByGrn":"HARINATH34460","actualRcvdDate":"2021-05-25T16:34:15.126","inspectionId1":"28842","creationDate":"2021-05-25T16:34:15.126","interfaceFlag":"New","addColumn9":"Delivery Note","addColumn10":13323,"requestDate":"2021-05-25","xxetFmsInspectionLinesStgCollection":{"XxetFmsInspectionLinesStg":[{"interfaceFlag":"New","receivedQty":1,"intimationLineId":9270,"eligibilityPenality":"No","xxetFmsInspectionShipsStgCollection":{"XxetFmsInspectionShipsStg":[{"interfaceFlag":"New","chasisNo":"MMBMGU5H1MH003686","currentKmReading":500,"inspectionResult":"Approved","status":"PASS","remarks":"Testing"}]}}]}}]}}');
        res.setStatusCode(200);
       
        return res;
    }

}