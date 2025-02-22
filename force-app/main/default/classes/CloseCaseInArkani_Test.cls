@isTest
public class CloseCaseInArkani_Test {
    @isTest public static void codeCoverage() {
        Test.startTest();
        case cs = new case();
        cs.Status = 'New';
        cs.Arkani_Incident_ID__c ='';
        cs.Arkani_Integration_Status__c = 'In Progress to Closed';
        Insert cs;
        
        case cs1 = new case();
        cs1.Status = 'New';
        cs1.Arkani_Incident_ID__c ='12345';
        cs1.Arkani_Integration_Status__c = 'In Progress to Closed';
        Insert cs1;
        
        case cs2 = new case();
        cs2.Status = 'New';
        cs2.Arkani_Incident_ID__c ='tste';
        cs2.Arkani_Integration_Status__c = 'In Progress to Closed';
        Insert cs2;

        
        Test.setMock(HttpCalloutMock.class, new CloseCaseArkani_mockTest()); 
        CloseCaseInArkani.updateArkaniIdUponCaseClosure(cs.Id);
        CloseCaseInArkani.updateArkaniIdUponCase(cs2.Id);
        CloseCaseInArkani.updateArkaniIdUponCase(cs1.Id);
        CloseCaseInArkani.updateArkaniIdUponCase(cs.Id);
        CloseCaseInArkani.updateArkaniIdUponCaseClosure(cs1.Id);
        CloseCaseInArkani.updateArkaniIdUponCaseClosure(cs2.Id);
        
        Test.stopTest();
        
    }
      
/*@isTest 
private class Test_class {

    private class createRequest implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = 'your Json Response';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    static testMethod void service_call() {

        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();

        //your web service call code

        Test.StopTest();


    }
}*/
    
}