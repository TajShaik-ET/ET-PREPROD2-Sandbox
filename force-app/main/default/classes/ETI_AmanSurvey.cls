/***********************************************************************************************************************
* Name               : ETI_AmanSurvey                                                                                  *
* Test Class         : ETI_AmanSurvey_Test                                                                             *
* Description        : Apex Class to fetch Aman receipt and update in Salesforce                                       *
* Created Date       : 04/Mar/2025                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   04/Mar/2025         Initial Draft.                                                             *
***********************************************************************************************************************/
public class ETI_AmanSurvey {
    
    @auraEnabled
    public static ResponseWrapper getAmanSurvey(string recpNo){
        System.debug('recpNo >>> ' + recpNo);
        ResponseWrapper responseWrp = New ResponseWrapper();
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('amanSurveyStatus');
        Blob beforeblob = Blob.valueOf(connection.Username__c + ':' + connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        HttpRequest request = new HttpRequest();
        if (ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c + '?Reference=' + recpNo);
        } else{
            request.setEndpoint(connection.LiveEndpoint_c__c + '?Reference=' + recpNo);
        }
        request.setMethod('GET');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic ' + paramvalue);
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug('response Body >>> ' + response.getBody());
        if (response.getStatusCode() == 200){
            responseWrp = (ResponseWrapper)JSON.deserialize(response.getBody(), ResponseWrapper.class);
            if (responseWrp.Status == 'S' && responseWrp.Message == 'Response from AMAN received.'){
                system.debug('responseWrp >>> ' + responseWrp);
            }
        }
        return responseWrp;
    }
    
    @auraEnabled
    public static ResponseWrapper postAmanSurvey(String Reference, String SatisfactionLevel, String Comments, String SurveyCompleted){
        System.debug('Reference >>> '+Reference+' SatisfactionLevel >>> '+SatisfactionLevel+' Comments >>> '+Comments+' SurveyCompleted >>> '+SurveyCompleted);
        ResponseWrapper responseWrp = New ResponseWrapper();
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('amanSurveyUpdate');
        Blob beforeblob = Blob.valueOf(connection.Username__c + ':' + connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        HttpRequest request = new HttpRequest();
        if (ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c + '?Reference=' + Reference+ '&SatisfactionLevel=' + SatisfactionLevel+'&Comments='+Comments+'&SurveyCompleted='+SurveyCompleted);
        } else{
            request.setEndpoint(connection.LiveEndpoint_c__c + '?Reference=' + Reference+ '&SatisfactionLevel=' + SatisfactionLevel+'&Comments='+Comments+'&SurveyCompleted='+SurveyCompleted);
        }
        request.setMethod('GET');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic ' + paramvalue);
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug('response Body >>> ' + response.getBody());
        if (response.getStatusCode() == 200){
            responseWrp = (ResponseWrapper)JSON.deserialize(response.getBody(), ResponseWrapper.class);
            if (responseWrp.Status == 'S'){
                system.debug('responseWrp >>> ' + responseWrp);
            }
        }
        return responseWrp;
    }
    
    public class ResponseWrapper{
        @auraEnabled public String Status;
        @auraEnabled public String Message;
        @auraEnabled public String IfReferenceExists;
        @auraEnabled public String TestResultsLink;
    }
}