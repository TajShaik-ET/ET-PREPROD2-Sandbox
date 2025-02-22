/*
* File Name:ET_REST_Authorize_Helper
* Author : Smaartt
* CreatedDate : 30/05/2021
* Modification Purpose
* * 1. Janardhan: Utility class to available for all the Check in check out services
*/
public class ET_REST_Authorize_Helper {
    
     public static ET_Oracle_REST_Endpoints__mdt getSOAPEndpointFromMetadata(string DeveloperName){
       
        return [SELECT Id,Dev_Endpoint__c,LiveEndpoint_c__c,Password__c,Username__c FROM ET_Oracle_REST_Endpoints__mdt where DeveloperName=:DeveloperName];
    }
    
    public static boolean runningInASandbox(){
        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    
  

}