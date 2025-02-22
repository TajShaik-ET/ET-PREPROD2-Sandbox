global class Account_Sync_From_Batch implements Database.Batchable<sObject>,Database.Stateful,   Database.AllowsCallouts {

    public boolean integrationSuccess;
 public String AccountID  ;  
    public String oracleId;
 public  Account_Sync_From_Batch(String AccountID)
 {
     this.AccountID = AccountID;
     this.integrationSuccess = false;
     this.oracleId = '';
 }
 public String query = 'Select ID, Name from Account Where Id=:AccountID';
 global Database.QueryLocator start(Database.BatchableContext BC) {
     oracleId = '';
    return Database.getQueryLocator(query);
 }

     global void execute(Database.BatchableContext BC, List<Account> records) {         
        String endpoint;        
    
       try{
            String OracleIntegrationMessage = '';
            
            Account accCheck = [Select id,RecordType.Name  from Account where Id =:AccountID];   
            Account acc = new Account();
            String QueryString='';  
            String Name='';
            String accRecordTypeName = ''; 
            accRecordTypeName =accCheck.RecordType.Name ;
            if(accRecordTypeName.contains('Person'))    
            {
                
                Name = 'FirstName,LastName,MiddleName';
            }
            else
            {
                Name = 'Name';
            }
            
            QueryString = 'Select id,'+Name+',Integration_Message__c,AccountNumber,ETSALES_Customer_Account_Id__c,Industry,ETSALES_Trade_License_Number__c,ETT_Trade_License_Number__c,ETSALES_Trade_License_Expiry_Date__c,ETSALES_TaxRegistrationNo__c,'+
                'ETSALES_Profile_Class__c,ETT_Payment_Term__c,Strategic_Account_Manager__r.Name,'+
                'ETSALES_Account_Type__c,RecordType.Name ,ETSALES_Payment_Term_Id__c,ETT_First_Name__c,'+
                'PersonTitle from Account where Id =:AccountID';
            acc = Database.query(QueryString);
            
            
            String AccountNo = (acc.AccountNumber!=null)?('"'+acc.AccountNumber+'"'):null;
            String CustomerName = '';
            String FirstName ='';
            String LastName = '';
            String MiddleName = '';
            String Title = '';
            if(acc.RecordType.Name=='Organization')
            {
                CustomerName = (acc.Name!=null)?('"'+acc.Name+'"'):null; 
                FirstName = null;
                LastName =null;
                MiddleName = null;
                Title = null;
            }
            else{
                CustomerName = null;
                FirstName = (acc.FirstName!=null)?('"'+acc.FirstName+'"'):null;
                LastName = (acc.LastName!=null)?('"'+acc.LastName+'"'):null;
                MiddleName = (acc.MiddleName!=null)?('"'+acc.MiddleName+'"'):null;
                Title = (acc.PersonTitle!=null)?('"'+acc.PersonTitle+'"'):null;
            }
            
            String CustomerType = (acc.RecordType.Name!=null)?('"'+acc.RecordType.Name+'"'):null;
            String CustomerIndustry = '"CUSTOMER"';
            String TradeLicenseNo = (acc.ETT_Trade_License_Number__c!=null)?('"'+acc.ETT_Trade_License_Number__c+'"'):null;
            Date expirydate = acc.ETSALES_Trade_License_Expiry_Date__c;
            String TradeLicenseExpiryDate= null;
            if(expirydate!=null)
            {
                TradeLicenseExpiryDate = '"'+DateTime.newInstance(expirydate.year(), expirydate.month(), expirydate.day()).format('yyyy-MM-dd')+'"'; 
            }
            
            String TaxRegistrationNo = (acc.ETSALES_TaxRegistrationNo__c!=null)?('"'+acc.ETSALES_TaxRegistrationNo__c+'"'):null;
            String ProfileClass = (acc.ETSALES_Profile_Class__c!=null)?('"'+acc.ETSALES_Profile_Class__c+'"'):null;
            String PaymentTerm = (acc.ETT_Payment_Term__c!=null)?('"'+acc.ETT_Payment_Term__c+'"'):null;
            String AccountManager = (acc.Strategic_Account_Manager__r.Name!=null)?('"'+acc.Strategic_Account_Manager__r.Name+'"'):null;
            String AccountType = (acc.ETSALES_Account_Type__c!=null)?('"'+acc.ETSALES_Account_Type__c+'"'):null;
            String SFDC_ID =(acc.id!=null)?('"'+acc.id+'"'):null;
            //String PaymentTermId = (acc.ETSALES_Payment_Term_Id__c!=null)?('"'+acc.ETSALES_Payment_Term_Id__c+'"'):null;
            String PaymentTermId =null;
            
            String body ='';
            
            HttpRequest request = new HttpRequest();
            
            body = '{"AccountNo":'+AccountNo+',"CustomerName":'+CustomerName+','+
                '"CustomerType":'+CustomerType+','+'"CustomerIndustry":'+CustomerIndustry+','+
                '"TradeLicenseNo":'+TradeLicenseNo+','+'"TradeLicenseExpiryDate":'+TradeLicenseExpiryDate+','+
                '"TaxRegistrationNo":'+TaxRegistrationNo+','+'"ProfileClass":'+ProfileClass+','+
                '"PaymentTerm":'+PaymentTerm+','+'"AccountManager":'+AccountManager+','+
                '"AccountType":'+AccountType+','+'"SFDC_ID":'+SFDC_ID+','+
                '"PaymentTermId":'+PaymentTermId+','+'"FirstName":'+FirstName+','+
                '"LastName":'+LastName+','+'"MiddleName":'+MiddleName+','+'"Title": '+Title + '}';
            
            
            System.debug('body='+body);
            
            
            request= Oracle_Integration_Services.createRequest('POST', '/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Account');		
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
                    System.debug('response.getBody()'+response.getBody());
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
                    
                    if(!OracleIntegrationMessage.contains('Customer account has been updated successfully'))
                    {
                        String respcustomerAccountId ='';
                        String respAccountNo ='';
                        try{
                            respcustomerAccountId =(String)responseResult.get('CustAccountId');
                            
                        }catch(Exception e){}
                        try{
                            respAccountNo =(String)responseResult.get('AccountNo');
                        }catch(Exception e){}
                        
                        if(respAccountNo!=''&&respcustomerAccountId!='')
                        {
                            
                            integrationSuccess = true;
                            acc.AccountNumber = respAccountNo;
                            acc.ETSALES_Customer_Account_Id__c = respcustomerAccountId;
                            acc.Integration_Status__c = 'Success';
                                                        
                            //   update acc;
                        }
                        else
                        {
                            acc.Integration_Status__c = 'Failed';
                            OracleIntegrationMessage = 'Unable to retrieve AccountNo and CustAccountId from Response.';
                        }   
                    }
                    else
                    {
                        // for account update successfuly
                        integrationSuccess = true;                        
                        acc.Integration_Status__c = 'Success';                    
                    }
                  
                    
                }
                else
                {
                    acc.Integration_Status__c = 'Failed';
                    OracleIntegrationMessage = ResponseMessage;
                }
                
            }
            else{
                Integer statuscode = response.getStatusCode();
                String ErrorMessage = 'Status Code = '+statuscode+' ,'+ 'Error Message = '+response.getBody();
                OracleIntegrationMessage = ErrorMessage;
                acc.Integration_Status__c = 'Failed';
            }
            
            if(OracleIntegrationMessage!='')
            {
                System.debug('acc.Integration_Message__c='+acc.Integration_Message__c);
                System.debug('acc.AccountNumber='+acc.AccountNumber);
                System.debug('acc.Integration_Satus__c='+acc.Integration_Status__c);
                
                acc.Integration_Message__c = OracleIntegrationMessage;
                update acc;
                System.debug('update successgull='+acc);    
                if(acc.ETSALES_Customer_Account_Id__c!=null)
                {   System.debug('update oralce id='+acc.ETSALES_Customer_Account_Id__c); 
                    oracleId = acc.ETSALES_Customer_Account_Id__c;
                 System.debug('oralceid='+oracleId);
                }
                
            }
        }
          catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
          }
       
    }   

    global void finish(Database.BatchableContext BC){    
        System.debug('oracle id Test'+oracleId);
        if(oracleId!='')
        {
              System.debug('call address batch');
            Customer_Address_Sync_From_Batch addressBatch = new Customer_Address_Sync_From_Batch(this.oracleId);
            Database.executeBatch(addressBatch,1);
        }
    }


}