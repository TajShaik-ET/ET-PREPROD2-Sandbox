global class Account_Site_Syn_from_Batch implements Database.Batchable<sObject>,   Database.AllowsCallouts {

 public Set<Id> addressIds  ;  
 public  Account_Site_Syn_from_Batch(Set<Id> addressIds)
 {
     this.addressIds = addressIds;
 }
 public String query  = 'Select id,Organization_ID__c,Location_ID__c,Oracle_Account_ID__c,ETSALES_Business_Purpose__c,'+
  			            'ETSALES_Site_Profile_Class__c,Operation_Manager__c,ETSALES_Overall_Credit_Limit__c,'+
              			'ETSALES_Party_Site_Id__c,ETSALES_Party_Site_Number__c from ETSALES_Account_Sites__c '+
             			 'where ETSALES_Address__c IN:addressIds AND  '+
                         '(ETSALES_Party_Site_Number__c=null OR ETSALES_Site_Use_Id__c=null )';
    global Database.QueryLocator start(Database.BatchableContext BC) {
     //   addressIds = new Set<Id>();
    return Database.getQueryLocator(query);
 }

     global void execute(Database.BatchableContext BC, List<ETSALES_Account_Sites__c> records) {         
        String endpoint;        

        for (ETSALES_Account_Sites__c siteObj: records){
         try {                  
        System.debug('Inside accountsite function');
            String OracleIntegrationMessage = '';                   
            
            String CustAccountId = (siteObj.Oracle_Account_ID__c!=null)?(''+siteObj.Oracle_Account_ID__c+''):null;
            String Org_id = (siteObj.Organization_ID__c!=null)?(''+siteObj.Organization_ID__c+''):null;
            String LocationId =(siteObj.Location_ID__c!=null)?(''+siteObj.Location_ID__c+''):null;
            String BusinessPurpose = (siteObj.ETSALES_Business_Purpose__c!=null)?('"'+siteObj.ETSALES_Business_Purpose__c+'"'):null;
            String ProfileClass = null;
            String AccountManager =null;       
            String PaymentTerm =null;       
            String CreditLimit = (siteObj.ETSALES_Overall_Credit_Limit__c!=null)?(''+siteObj.ETSALES_Overall_Credit_Limit__c+''):null;
            String PaymentTermId =null;           
            String SiteUseId = null;           
            
            String SFDC_ID = (siteObj.id!=null)?('"'+siteObj.id+'"'):null;
            
            
            
            String body ='';
            
            HttpRequest request = new HttpRequest();
            
            body = '{"CustAccountId":'+CustAccountId+',"Org_id":'+Org_id+','+
                '"LocationId":'+LocationId+','+'"BusinessPurpose":'+BusinessPurpose+','+
                '"ProfileClass":'+ProfileClass+','+'"AccountManager":'+AccountManager+','+
                '"PaymentTerm":'+PaymentTerm+','+'"CreditLimit":'+CreditLimit+','+
                '"PaymentTermId":'+PaymentTermId+','+'"SiteUseId":'+SiteUseId+','+'"SFDC_ID":'+SFDC_ID+ '}';
            
            
            System.debug('body='+body);
            
            
            request= Oracle_Integration_Services.createRequest('POST', '/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Site');		
            request.setBody(body);  
            request.setTimeout(120000);
               Arkani_API_Credentials__mdt	credentialsMetadata=[Select Password__c,UserName__c from Arkani_API_Credentials__mdt where DeveloperName = 'Arkani_Credential'];                 
            //String Username = 'Salesforce';
            //String password = 'salesforce123';
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
                responseResult = null;             
                
            }
            else{
                if(response.getStatusCode() == 200){
                    System.debug('Sucess ');
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    responseResult =result;
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
                    OracleIntegrationMessage = ResponseMessage;
                    if(ResponseMessage==null||ResponseMessage=='')
                    {
                        OracleIntegrationMessage = 'Customer Account Site is successfully integrated with Oracle.';
                    }
                    Integer respSiteUseId =0;       
                    Integer respPartySiteNumber =0;   
                    try{
                         respSiteUseId =(Integer)responseResult.get('SiteUseId');    
                    }catch(Exception e){}
                        try{
                       respPartySiteNumber =(Integer)responseResult.get('PartySiteNumber');    
                    }catch(Exception e){}
                   
                    if(respSiteUseId!=0||respPartySiteNumber!=0)
                    {
                   
                        siteObj.ETSALES_Site_Use_Id__c	 = String.valueOf(respSiteUseId);  
                        siteObj.ETSALES_Party_Site_Number__c = String.valueOf(respPartySiteNumber);  
                        siteObj.Integration_Status__c = 'Success';
                        //   update acc;
                    }
                    else
                    {
                        siteObj.Integration_Status__c = 'Failed';
                         OracleIntegrationMessage = 'Unable to retrieve SiteUseId and PartySiteNumber from Response.';
                    }
                    
                }
                else
                {
                    siteObj.Integration_Status__c = 'Failed';
                    OracleIntegrationMessage = ResponseMessage;
                }
                
            }
            else{
                Integer statuscode = response.getStatusCode();
                String ErrorMessage = 'Status Code = '+statuscode+' ,'+ 'Error Message = '+response.getBody();
                OracleIntegrationMessage = ErrorMessage;
                siteObj.Integration_Status__c = 'Failed';
            }
            
            
            if(OracleIntegrationMessage!='')
            {
                //   System.debug('acc.Integration_Message__c='+siteObj.Integration_Message__c);
                System.debug('acc.ETSALES_Party_Site_Id__c='+siteObj.ETSALES_Party_Site_Id__c);
                System.debug('acc.ETSALES_Party_Site_Number__c='+siteObj.ETSALES_Party_Site_Number__c);
                System.debug('acc.Integration_Satus__c='+siteObj.Integration_Status__c);
                
                siteObj.Integration_Message__c = OracleIntegrationMessage;
                update siteObj;
                System.debug('update successgull='+siteObj);
            }          
          }
          catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
          }
       }
    }   

    global void finish(Database.BatchableContext BC){    
        System.debug('finsh block of Account Site');
    }

}