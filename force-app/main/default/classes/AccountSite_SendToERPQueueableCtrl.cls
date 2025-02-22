/**
Author: Janardhan Muddana
Test Class: Account_SendToERP_Test
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date     Author           Details
1.          V1.0                         Janardhan	    Initial Version 
2.          v2.0			17/04/2023   Janardhan    	logic is implemented to handle mutiple sites
****************************************************************************************************************/

public class AccountSite_SendToERPQueueableCtrl implements Queueable,Database.AllowsCallouts {
    
    public Id accID;
    public string ERPAccId;
    public string locationId;
    
    public AccountSite_SendToERPQueueableCtrl(Id AccountId,string ERPAccId,string locationId){
        
        this.accID=AccountId;
        this.ERPAccId = ERPAccId;
        this.locationId =locationId;
        
    }
    
    public void execute(QueueableContext con){
        
        list<ETSALES_Account_Sites__c> siteObjList = [Select id,Organization_ID__c,Location_ID__c,
                                                      Oracle_Account_ID__c,ETSALES_Business_Purpose__c,ETSALES_Site_Profile_Class__c,Operation_Manager__c,
                                                      ETSALES_Overall_Credit_Limit__c,ETSALES_Site_Payment_Terms__c,ETSALES_Party_Site_Id__c,ETSALES_Party_Site_Number__c,Traffic_Fine__c,Salik_Service_Charges__c,ETSALES_Site_Use_Id__c,lastModifiedby.EmployeeNumber from ETSALES_Account_Sites__c where ETSALES_Account__c=:accID];   
        
        
        for(ETSALES_Account_Sites__c si: siteObjList){
            
             createSitesInERP(accID,ERPAccId,locationId,si.Organization_ID__c,si.ETSALES_Business_Purpose__c,si.ETSALES_Site_Profile_Class__c,si.ETSALES_Site_Payment_Terms__c,String.valueOf(si.ETSALES_Overall_Credit_Limit__c),si.Id,si.ETSALES_Site_Use_Id__c,String.valueOf(si.Traffic_Fine__c),String.valueOf(si.Salik_Service_Charges__c),si.lastModifiedby.EmployeeNumber);
            
        }
    }
        
        @Future(callout=true)
        public static void createSitesInERP(string accID,string ERPAccId,string locId,string orgId,string busiPur,string profCls,string payTerms,string credLimit,string siteId,string siteExtId,string trafficFine,string salikChar,string empId){
                     
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('CustAccountId',ERPAccId);
            gen.writeStringField('Org_id',orgId!=null?orgId:'');
            gen.writeStringField('LocationId',locId);
            gen.writeStringField('BusinessPurpose',busiPur!=null?busiPur:'');
            gen.writeStringField('ProfileClass',profCls!= null?profCls:'');
            gen.writeStringField('AccountManager','');
            gen.writeStringField('PaymentTerm',payTerms != null?payTerms:'');
            gen.writeStringField('CreditLimit',credLimit!=null?credLimit:'');  
            gen.writeStringField('PaymentTermId','');
            gen.writeStringField('SiteUseId',siteExtId!=null?siteExtId:'');
            gen.writeStringField('SFDC_ID',siteId!=null?siteId:'');
            gen.writeStringField('TrafficFine',trafficFine!=null?trafficFine:'');
            gen.writeStringField('SalikFine',salikChar!=null?salikChar:'');
            gen.writeStringField('User',empId!=null?empId:'');
            
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            
           
            ETSALES_Account_Sites__c siteUpdate = new ETSALES_Account_Sites__c();
            siteUpdate.Id = siteId;
            HttpRequest request = new HttpRequest();
            
          
            System.debug('body='+jsonData);
            
            request.setEndpoint(Label.ETSOA_End_Point +'/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Site');
            request.setMethod('POST');
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(jsonData);  
            
            Arkani_API_Credentials__mdt	credentialsMetadata=[Select Password__c,UserName__c from Arkani_API_Credentials__mdt where DeveloperName = 'Arkani_Credential'];                 
            String Username = credentialsMetadata.UserName__c;
            String password = credentialsMetadata.Password__c;    
            
            String combined = Username+':'+password;
            Blob beforeblob = Blob.valueOf(combined);
            
            string base64Key = EncodingUtil.base64Encode(beforeblob);
            System.debug('paramvalue='+base64Key);
            String AuthroizationValue = 'Basic '+base64Key;
            request.setHeader('Authorization', AuthroizationValue);   
            Map<String, Object> responseResult =new Map<String, Object>();
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            System.debug('response body='+response.getBody());
            if (response.getStatusCode() != 200) {
                
                System.debug('Failed ');          
            }
            else{
                if(response.getStatusCode() == 200){
                    System.debug('Sucess ');
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    if(string.valueOf(result.get('Status')) =='E'){
                        
                        Exception_Log__c log = new Exception_Log__c();
                        log.Application_Name__c = 'Send Account Site to ERP';
                        log.Class_Name__c ='Account_SendToERP';
                        log.Exception_Details__c ='Record Id -'+siteId;
                        log.Error_Message__c =string.valueOf(result.get('Message'));
                        insert log;
                        
                    }
                    responseResult =result;
                    system.debug('--AccSite_res--'+result);
                }
                
            }
            if(responseResult!=null)
            {
                String ResponseMessage =(String)responseResult.get('Message');
                String ResponseStatus =(String)responseResult.get('Status');
                System.debug('ResponseStatus='+ResponseStatus);
                System.debug('ResponseMessage='+ResponseMessage);
                if(ResponseStatus.contains('S'))
                {
                    siteUpdate.ETSALES_Site_Use_Id__c	 = String.valueOf(responseResult.get('SiteUseId'));  
                    siteUpdate.ETSALES_Party_Site_Number__c = String.valueOf(responseResult.get('PartySiteNumber'));  
                    siteUpdate.Integration_Status__c = 'Success';
                    if(!test.isRunningTest())
                        system.enqueueJob(new Contact_SendToERP(accID,ERPAccId,siteUpdate.ETSALES_Site_Use_Id__c)); 
                    
                }
            }
            
            update  siteUpdate;            
        }        
     
}