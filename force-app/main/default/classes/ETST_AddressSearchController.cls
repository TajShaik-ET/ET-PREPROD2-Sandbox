public with sharing class ETST_AddressSearchController {
    //Final static String envType='UAT';
    public static ET_External_Endpoint__mdt getAPIDetails(String DeveloperName){
        return [SELECT Id,DeveloperName, MasterLabel, URL__c, Authorization__c FROM ET_External_Endpoint__mdt  
                where  DeveloperName=:DeveloperName  LIMIT 1];
        
    }    
    //Method to call google API and fetch the address recommendations 
    @AuraEnabled
    public static String getAddressSet(String SearchText){  
        system.debug('enter');
        ET_External_Endpoint__mdt googleEndpoint=getAPIDetails('ETST_googleAutoCompleteAPI');
        String result = null;
        String APIKey = googleEndpoint.Authorization__c;
        String url = googleEndpoint.URL__c;
        system.debug('SearchText is ' + SearchText);
        try{
            if(SearchText != null){
                String APIUrl = url + SearchText.replace(' ', '%20') + '&&components=country:AE&key='+APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    result = res.getBody();
                    system.debug('Address'+result);
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
        }
        return result;
    }
    
    //Method to call google API and fetch the address details by addressID 
    @AuraEnabled
    public static String getAddressDetailsByPlaceId(String PlaceID){
        ET_External_Endpoint__mdt googleEndpoint=getAPIDetails('ETST_googlePlacesAPI');
        
        String  APIKey = googleEndpoint.Authorization__c;
        String  url = googleEndpoint.URL__c;
        String result = null;
        system.debug('SearchText is place id ' + PlaceID);
        try{
            if(PlaceID != null){
                String APIUrl = url + PlaceId.replace(' ', '%20') + '&key='+APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    result = res.getBody();
                    system.debug('result'+result);
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
        }
        return result;
    }
    
    
}