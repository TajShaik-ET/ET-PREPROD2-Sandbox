/*
* File Name:ET_Map_Controller
* Author : Sagar Kambli
* CreatedDate : 19 May 2020
* Modification Purpose
* * 1. Sagar: Controller to locate vehicles on map
* * 2.
*/ 
public class ET_Map_Controller {
    
    @AuraEnabled
    public static List<mapMarkers> loadVehiclesByPlateNo(string PlateNo,boolean isAllVehicles){
        List<mapMarkers> markers = new List<mapMarkers>();
        HttpResponse response = makeIOTRequest(PlateNo,isAllVehicles);
        if (response!=null && response.getStatusCode() == 200) {
            //ET_Common_Util.sendEmail('Test Etisalat Response', new string[]{'sagar.kambli@smaartt.com'}, null, null, response.getBody());
            ET_IOTLocations locations = ET_IOTLocations.parse(response.getBody());
            for(ET_IOTLocations.Rows row: locations.rows){
                mapMarkers marker = new mapMarkers();
                LocationAttr locationObj = new LocationAttr();
                locationObj.Longitude = string.valueOf(row.Longitude);
                locationObj.Latitude = string.valueOf(row.Latitude);
                marker.title = row.ObjectName;
                
                string status = '';
                if(row.IgnitionStatus == 0)
                    status = 'OFF';
                else if(row.IgnitionStatus == 1)
                    status = 'ON';
                    
                //marker.icon = 'utility:salesforce1';
                marker.description = 'Ignition: '+ status +', Odometer: '+row.Odometer+', Speed: '+row.Speed;
                marker.location =locationObj;
                markers.add(marker);
            }
        }
        return markers;
    }
    
    @AuraEnabled
    public static List<mapMarkers> loadETLocations(){
        List<mapMarkers> markers = new List<mapMarkers>();
		List<ET_Location__c> etLocations= getETLocations();
        if (etLocations!=null && etLocations.size() >0) {
            for(ET_Location__c row: etLocations){
                mapMarkers marker = new mapMarkers();
                LocationAttr locationObj = new LocationAttr();
                locationObj.Longitude = string.valueOf(row.Longitude__c);
                locationObj.Latitude = string.valueOf(row.Latitude__c);
                marker.title = row.Name;
                marker.description = 'ET Location';
                marker.location =locationObj;
                markers.add(marker);
            }
        }
        return markers;
    }
    
    public static List<ET_Location__c> getETLocations(){
        return [SELECT Id, Name, Latitude__c, Longitude__c FROM ET_Location__c where Latitude__c !=null];
    }
    public static HttpResponse makeIOTRequest(string PlateNo, boolean isAllVehicles){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        if(isAllVehicles)
        	request.setEndpoint('https://iotmobility.etisalatdigital.ae/Thingworx/Things/EmiratesAirlines_API_V1/Services/RealTimeLocationData');
        else
            request.setEndpoint('https://iotmobility.etisalatdigital.ae/Thingworx/Things/EmiratesAirlines_API_V1/Services/RealTimeLocationDataByPlateNo?PlateNo='+PlateNo);
        request.setMethod('POST');
        request.setHeader('appKey', 'bd1e721e-61c3-42f5-8d71-724630f34abc');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Cache-Control', 'no-cache');
        request.setHeader('Accept', 'application/json');
        HttpResponse response = http.send(request);
        return response;
    }
    
    public class mapMarkers{
        //@AuraEnabled
        //public string icon {get;set;}
        @AuraEnabled
        public string title {get;set;}
        @AuraEnabled
        public string description {get;set;}
        @AuraEnabled
        public LocationAttr location {get;set;}
    }
    
    public class LocationAttr{
        @AuraEnabled
        public string Latitude {get;set;}
        @AuraEnabled
        public string Longitude {get;set;}
		@AuraEnabled
        public string Street {get;set;}
        @AuraEnabled
        public string City {get;set;}  
        @AuraEnabled
        public string PostalCode {get;set;}  
        @AuraEnabled
        public string State {get;set;}  
        @AuraEnabled
        public string Country {get;set;}          
    }
}