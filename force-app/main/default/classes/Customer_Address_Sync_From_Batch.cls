global class Customer_Address_Sync_From_Batch implements Database.Batchable<sObject>,Database.Stateful,   Database.AllowsCallouts {

    public boolean integrationSuccess;
 public String accountOracleId  ;  
 public Set<id> addressSync;   
 public  Customer_Address_Sync_From_Batch(String accountOracleId)
 {
     this.accountOracleId = accountOracleId;
     this.integrationSuccess = false;
 }
 public String query = 'Select id,ETSALES_Address1__c,ETSALES_Address2__c,ETSALES_Address3__c,ETSALES_Address4__c,'+
                       'ETSALES_City__c,ETSALES_Country__c,Oracle_Account_ID__c,ETSALES_Location_ID__c,Postal_code__c,'+
                       'ETSALES_State__c,Integration_Message__c,Integration_Status__c from ETSALES_Address__c'+
                       ' where Oracle_Account_ID__c=:accountOracleId AND ETSALES_Location_ID__c=null';
 global Database.QueryLocator start(Database.BatchableContext BC) {
    addressSync = new Set<Id>();
    return Database.getQueryLocator(query);
 }

     global void execute(Database.BatchableContext BC, List<ETSALES_Address__c> records) {         
        String endpoint;        
    
         for(ETSALES_Address__c addressObj:records)
         {
             try{
              String OracleIntegrationMessage = '';                    
            
            String CountryCode = addressObj.ETSALES_Country__c;
            String CountryName='';       
            if(addressObj.ETSALES_Country__c!=null)
            {
                
                Schema.sObjectType objType = ETSALES_Address__c.getSObjectType();
                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
                list < Schema.PicklistEntry > values = fieldMap.get('ETSALES_Country__c').getDescribe().getPickListValues();
                
                for (Schema.PicklistEntry a: values) {
                    if(a.getValue()==CountryCode)
                    {
                        CountryName = a.getLabel();
                        break;
                    }
                    
                }
                
            }
            
            
            String CustAccountId = (addressObj.Oracle_Account_ID__c!=null)?(''+addressObj.Oracle_Account_ID__c+''):null;
            String Address1 = (addressObj.ETSALES_Address1__c!=null)?('"'+addressObj.ETSALES_Address1__c+'"'):null;
            String Address2 =(addressObj.ETSALES_Address2__c!=null)?('"'+addressObj.ETSALES_Address2__c+'"'):null;
            String Address3 = (addressObj.ETSALES_Address3__c!=null)?('"'+addressObj.ETSALES_Address3__c+'"'):null;
            String Address4 = (addressObj.ETSALES_Address4__c!=null)?('"'+addressObj.ETSALES_Address4__c+'"'):null;
            String City = (addressObj.ETSALES_City__c!=null)?('"'+addressObj.ETSALES_City__c+'"'):null;       
            String State = (addressObj.ETSALES_State__c!=null)?('"'+addressObj.ETSALES_State__c+'"'):null;       
            String PostalCode = (addressObj.Postal_code__c!=null)?('"'+addressObj.Postal_code__c+'"'):null;
            String Country = (CountryName!='')?('"'+CountryName+'"'):null;           
            
            String SFDC_ID = (addressObj.id!=null)?('"'+addressObj.id+'"'):null;
            String LocationId = null;
            
            
            String body ='';
            
            HttpRequest request = new HttpRequest();
            
            body = '{"CustAccountId":'+CustAccountId+',"Address1":'+Address1+','+
                '"Address2":'+Address2+','+'"Address3":'+Address3+','+
                '"Address4":'+Address4+','+'"City":'+City+','+
                '"State":'+State+','+'"PostalCode":'+PostalCode+','+
                '"Country":'+Country+','+'"SFDC_ID":'+SFDC_ID+','+
                '"LocationId":'+LocationId+ '}';
            
            
            System.debug('body='+body);
            
            
            request= Oracle_Integration_Services.createRequest('POST', '/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Location');		
            request.setBody(body);  
            
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
                        OracleIntegrationMessage = 'Customer Address is successfully integrated with Oracle.';
                    }
                    String respLocationId ='';
                    try{
                        respLocationId =(String)responseResult.get('LocationId');   
                    }catch(Exception e){}
                     
                    if(respLocationId!='')
                    {
                        
                        addressObj.ETSALES_Location_ID__c = respLocationId;                       
                        addressObj.Integration_Status__c = 'Success';
                        addressSync.add(addressObj.id);
                             System.debug('add address'+addressSync);
                        
                    }
                    else
                    {
                        addressObj.Integration_Status__c = 'Failed'; 
                         OracleIntegrationMessage = 'Unable to retrieve LocationId from response.';
                    }
                    
                }
                else
                {
                    addressObj.Integration_Status__c = 'Failed';
                    OracleIntegrationMessage = ResponseMessage;
                }
                
            }
            else{
                Integer statuscode = response.getStatusCode();
                String ErrorMessage = 'Status Code = '+statuscode+' ,'+ 'Error Message = '+response.getBody();
                OracleIntegrationMessage = ErrorMessage;
                addressObj.Integration_Status__c = 'Failed';
            }
            
            if(OracleIntegrationMessage!='')
            {
                //    System.debug('acc.Integration_Message__c='+addressObj.Integration_Message__c);
                System.debug('acc.AccountNumber='+addressObj.ETSALES_Location_ID__c);
                System.debug('acc.Integration_Satus__c='+addressObj.Integration_Status__c);
                
                addressObj.Integration_Message__c = OracleIntegrationMessage;
                update addressObj;
                System.debug('update successgull='+addressObj);
            }
         }
          catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
          }
		}
         
       
    }   

    global void finish(Database.BatchableContext BC){ 
        System.debug('address Sync Test'+addressSync);
        if(addressSync.size()>0)
        {
                 System.debug('address Sync Test1'+addressSync);
            Account_Site_Syn_from_Batch sitebatch = new Account_Site_Syn_from_Batch(addressSync);
            Database.executeBatch(sitebatch,1);
        }
    }



}