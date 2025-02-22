/*
* File Name:ET_SOA_Authorize
* Author : Sagar Kambli
* CreatedDate : 13 May 2020
* Modification Purpose
* * 1. Sagar: WSS Header Class
* * 2.
*/

public class ET_SOA_Authorize {
    
    public static ET_Lookup.SecurityInfo securityInfo; 
    public static ETAECustomer.AuthInfo authInfo = new ETAECustomer.AuthInfo();
    public static string username {get;set;}
    public static string password {get;set;}
    public static string sourceSystem {get;set;}
    public static string webserviceURL {get;set;}
    public static string endpointURL {get;set;}
    public static integer orgId{get;set;}
   
    public static final string EMPLOYEE_SERVICE_TYPE = 'AR_Employee';
    public static final string CUSTOMER_SERVICE_TYPE = 'AR_Customer';
    public static final string SUPPLIER_SERVICE_TYPE = 'AR_Supplier';
    public static final string LOOKUP_SERVICE_TYPE = 'LOOK_UP';
    public static final string FEE_SERVICE_TYPE = 'FEES';
    public static final string AMAN_TEST_RESULT = 'AMAN_Test_Result';
    public static final string CANCELLATION_SERVICE_TYPE = 'CANCEL_INSPECTION';
    public static final string CREATE_SERVICE_TYPE = 'CREATE_INSPECTION';  
    public static final string ERP_VEHICLE_SERVICE = 'ERP_VEHICLES';
    public static final string SERVICE_FAILURE = 'Service Failure';
    public static final string SERVICE_SUCCESS = 'Service Success';
    public static final string CRM_CUSTOMER_NO = '1790';
    public static final string REG_VEHICLE = 'registered';
    public static final string UNREG_VEHICLE = 'un-registered';


    //Establish security for soa services - Lookup
    public static ET_Lookup.SecurityInfo initializeSecurityForLookup(){
        List<ET_SOA_Endpoint__mdt> connectionDetails = ET_SOA_Services.getSOAPEndpointFromMetadata(LOOKUP_SERVICE_TYPE);
        if(connectionDetails.size()==1){
            ET_SOA_Endpoint__mdt connection = connectionDetails[0];
            username = connection.Username__c;
            password = connection.Password__c;
            sourceSystem = connection.Source_System__c;
            orgId = Integer.valueOf(connection.OrgID__c);
            if(!connection.isLive__c) // not live - ie test environment
            {
                webserviceURL = connection.Test_URL__c;
                endpointURL = connection.TestEndpoint__c;
            }
            else 
            {
                webserviceURL = connection.Live_URL__c;
                endpointURL = connection.LiveEndpoint__c;
            }
            
            securityInfo = new ET_Lookup.SecurityInfo();
            securityInfo.SourceSystem = sourceSystem;
            securityInfo.Username = username;
            securityInfo.Password = password;
            return securityInfo;
            
        }
        return securityInfo;
    }

    
    public static ET_Lookup.SecurityInfo initializeDynamicSecurity(string service_type){
        List<ET_SOA_Endpoint__mdt> connectionDetails = ET_SOA_Services.getSOAPEndpointFromMetadata(service_type);
        if(connectionDetails.size()==1){
            ET_SOA_Endpoint__mdt connection = connectionDetails[0];
            username = connection.Username__c;
            password = connection.Password__c;
            sourceSystem = connection.Source_System__c;
            orgId = Integer.valueOf(connection.OrgID__c);
            if(!connection.isLive__c) // not live - ie test environment
            {
                webserviceURL = connection.Test_URL__c;
                endpointURL = connection.TestEndpoint__c;
            }
            else 
            {
                webserviceURL = connection.Live_URL__c;
                endpointURL = connection.LiveEndpoint__c;
            }
            
            securityInfo = new ET_Lookup.SecurityInfo();
            securityInfo.SourceSystem = sourceSystem;
            securityInfo.Username = username;
            securityInfo.Password = password;
            return securityInfo;
            
        }
        return securityInfo;
    }
}