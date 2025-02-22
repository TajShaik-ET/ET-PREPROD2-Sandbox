/*
 Developer Name - Swarendra Singh
 Developed Date - 25 July 2021
 Class Name - Oracle_Integration_Services
 Test Class - Oracle_Integration_Services_Test
 Class purpose - this class will contains the functions which will call the api to push the data into Oracle from salesforce.
 * Janardhan - 21/03/23 - updated accountsite parameters
 * Janardhan- 11/04/23 - added locationId in address integration for update operation
 * Janardhan - 13/04/23 - Added person account RecType Id in if condition to skip this process
*/
public class Oracle_Integration_Services {

    public static void integrateUpdateAccountToOracleFromTrigger(List<Account> accList)
    {        
        Set<Id> accids = new Set<Id>();
        Id personAccId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        for(Account acc:accList)
        {
            if(acc.ETSALES_Customer_Account_Id__c!=null&&acc.ETSALES_Customer_Account_Id__c!='' && acc.RecordTypeId !=personAccId)
            {
                accids.add(acc.id);
                
            }
        }
        if(accids.size()<100)
        {
            for(Id accid:accids)
            {
             integrateUpdateAccountToOracle(accid);   
            }
             
        }
    }
    @future(callout = true) 
    public static void integrateUpdateAccountToOracle(Id AccountID)
    {
     
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
            
            QueryString = 'Select id,'+Name+',Integration_Message__c,AccountNumber,ETSALES_Customer_Account_Id__c,Industry,ETSALES_Trade_License_Number__c,ETSALES_Trade_License_Expiry_Date__c,ETSALES_TaxRegistrationNo__c,'+
                'ETSALES_Profile_Class__c,ETSALES_Payment_Terms__c ,Strategic_Account_Manager__r.Name,'+
                'ETSALES_Account_Type__c,RecordType.Name ,ETSALES_Payment_Term_Id__c,ETT_First_Name__c,'+
                'PersonTitle,LastModifiedBy.EmployeeNumber from Account where Id =:AccountID';
            acc = Database.query(QueryString);
            
            
            String AccountNo = (acc.AccountNumber!=null)?('"'+acc.AccountNumber+'"'):null;
            String CustomerName = '';
            String FirstName ='';
            String LastName = '';
            String MiddleName = '';
            String Title = '';
            String CustomerType='';
            String LastModifiedByFinNum =acc.LastModifiedBy.EmployeeNumber!=null?('"'+acc.LastModifiedBy.EmployeeNumber+'"'):'';

            if(acc.RecordType.Name=='Organization')
            {
                CustomerName = (acc.Name!=null)?('"'+acc.Name+'"'):null; 
                FirstName = null;
                LastName =null;
                MiddleName = null;
                Title = null;
                CustomerType = (acc.RecordType.Name!=null)?('"'+acc.RecordType.Name+'"'):null;
            }
            else{
                CustomerName = (acc.LastName!=null)?('"'+acc.LastName+'"'):null;
                FirstName = (acc.FirstName!=null)?('"'+acc.FirstName+'"'):null;
                LastName = (acc.LastName!=null)?('"'+acc.LastName+'"'):null;
                MiddleName = (acc.MiddleName!=null)?('"'+acc.MiddleName+'"'):null;
                Title = (acc.PersonTitle!=null)?('"'+acc.PersonTitle+'"'):null;
                CustomerType = '"Person"';
            }
            
            
            String CustomerIndustry = '"CUSTOMER"';
            String TradeLicenseNo = (acc.ETSALES_Trade_License_Number__c !=null)?('"'+acc.ETSALES_Trade_License_Number__c +'"'):null;
            Date expirydate = acc.ETSALES_Trade_License_Expiry_Date__c;
            String TradeLicenseExpiryDate= null;
            if(expirydate!=null)
            {
                TradeLicenseExpiryDate = '"'+DateTime.newInstance(expirydate.year(), expirydate.month(), expirydate.day()).format('yyyy-MM-dd')+'"'; 
            }
                    
            String TaxRegistrationNo = (acc.ETSALES_TaxRegistrationNo__c!=null)?('"'+acc.ETSALES_TaxRegistrationNo__c+'"'):null;
            String ProfileClass = (acc.ETSALES_Profile_Class__c!=null)?('"'+acc.ETSALES_Profile_Class__c+'"'):null;
            String PaymentTerm = (acc.ETSALES_Payment_Terms__c !=null)?('"'+acc.ETSALES_Payment_Terms__c +'"'):null;
            String AccountManager = (acc.Strategic_Account_Manager__r.Name!=null)?('"'+acc.Strategic_Account_Manager__r.Name+'"'):null;
            String AccountType = (acc.ETSALES_Account_Type__c!=null)?('"'+acc.ETSALES_Account_Type__c+'"'):null;
            String SFDC_ID =(acc.id!=null)?('"'+acc.id+'"'):null;
            //String PaymentTermId = (acc.ETSALES_Payment_Term_Id__c!=null)?('"'+acc.ETSALES_Payment_Term_Id__c+'"'):null;
            String PaymentTermId =null;
            
            String body ='';
            
            HttpRequest request = new HttpRequest();
            
            body = '{"AccountNo":'+AccountNo+',"CustomerName":'+CustomerName+',"User":'+LastModifiedByFinNum+','+
                '"CustomerType":'+CustomerType+','+'"CustomerIndustry":'+CustomerIndustry+','+
                '"TradeLicenseNo":'+TradeLicenseNo+','+'"TradeLicenseExpiryDate":'+TradeLicenseExpiryDate+','+
                '"TaxRegistrationNo":'+TaxRegistrationNo+','+'"ProfileClass":'+ProfileClass+','+
                '"PaymentTerm":'+PaymentTerm+','+'"AccountManager":'+AccountManager+','+
                '"AccountType":'+AccountType+','+'"SFDC_ID":'+SFDC_ID+','+
                '"PaymentTermId":'+PaymentTermId+','+'"FirstName":'+FirstName+','+
                '"LastName":'+LastName+','+'"MiddleName":'+MiddleName+','+'"Title": '+Title + '}';
            
            
            System.debug('body='+body);
            
            request= createRequest('POST', '/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Account');		
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
            }
        
    }    
    @AuraEnabled
    public static boolean integrateAccountToOracleButton(Id AccountID)
    {
        Boolean integrationSuccess = false;
        try{
            Account_Sync_From_Batch accBatch = new Account_Sync_From_Batch(AccountID);
            Database.executeBatch(accBatch,1);
        }catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());   
        }
        integrationSuccess = true;
        return integrationSuccess;        
    }     
    public static void integrateAddressToOracleFromTrigger(List<ETSALES_Address__c> NewAddressList)
    {        
        Set<Id> addressIds = new Set<Id>();
        for(ETSALES_Address__c address:NewAddressList)
        {   
                if(address.Oracle_Account_ID__c!=null&&address.Oracle_Account_ID__c!='')
                {
                    addressIds.add(address.id);
                    
                }

        }
        if(addressIds.size()<100)
        {
            for(Id addressid:addressIds)
            {
                
                     integrateAddressToOracle(addressid);
                
                
            }
        }
    } 

    @future(callout = true)
    public static void integrateAddressToOracle(Id AddressID)
    {
     
            String OracleIntegrationMessage = '';
            
            ETSALES_Address__c addressObj = [Select id,ETSALES_Address1__c,ETSALES_Address2__c,
                                             ETSALES_Address3__c,ETSALES_Address4__c,ETSALES_City__c,ETSALES_Country__c,Oracle_Account_ID__c,
                                             ETSALES_Location_ID__c,Postal_code__c,ETSALES_State__c,Integration_Message__c,Integration_Status__c
                                             from ETSALES_Address__c where Id =:AddressID];   
            
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
            String LocationId = addressObj.ETSALES_Location_ID__c!=null ?('"'+addressObj.ETSALES_Location_ID__c+'"'):null;
            
            
            String body ='';
            
            HttpRequest request = new HttpRequest();
            
            body = '{"CustAccountId":'+CustAccountId+',"Address1":'+Address1+','+
                '"Address2":'+Address2+','+'"Address3":'+Address3+','+
                '"Address4":'+Address4+','+'"City":'+City+','+
                '"State":'+State+','+'"PostalCode":'+PostalCode+','+
                '"Country":'+Country+','+'"SFDC_ID":'+SFDC_ID+','+
                '"LocationId":'+LocationId+ '}';
            
            
            System.debug('body='+body);
            
            
            request= createRequest('POST', '/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Location');		
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
    public static void integrateAccountSiteToOracleFromTrigger(List<ETSALES_Account_Sites__c> NewAccountSiteList)
    {   
        Set<Id> accontSiteIds = new Set<Id>();
        for(ETSALES_Account_Sites__c accountSite:[Select id,Oracle_Account_ID__c,Location_ID__c from ETSALES_Account_Sites__c where Id IN:NewAccountSiteList])
        {
              if(accountSite.Oracle_Account_ID__c!=null&&accountSite.Oracle_Account_ID__c!=''&&
                   accountSite.Location_ID__c!=null&&accountSite.Location_ID__c!='')
                {
                    accontSiteIds.add(accountSite.id);
                    
                }
        
        }
       if(accontSiteIds.size()<100)
       {
           for(Id siteId:accontSiteIds)
           {               
                 integrateAccountSiteToOracle(siteId);       
              
           }
           
       }
        
    }
 
      @future(callout = true)
    public static void integrateAccountSiteToOracle(Id AccountSiteID)
    {
        System.debug('Inside accountsite function');
            String OracleIntegrationMessage = '';
            
            ETSALES_Account_Sites__c siteObj = [Select id,Organization_ID__c,Location_ID__c,
                                                Oracle_Account_ID__c,ETSALES_Business_Purpose__c,ETSALES_Site_Profile_Class__c,Operation_Manager__c,ETSALES_Site_Use_Id__c,
                                                ETSALES_Overall_Credit_Limit__c,ETSALES_Site_Payment_Terms__c,ETSALES_Party_Site_Id__c,ETSALES_Party_Site_Number__c from ETSALES_Account_Sites__c where Id =:AccountSiteID];   
            
            
            
            String CustAccountId = (siteObj.Oracle_Account_ID__c!=null)?(''+siteObj.Oracle_Account_ID__c+''):null;
            String Org_id = (siteObj.Organization_ID__c!=null)?(''+siteObj.Organization_ID__c+''):null;
            String LocationId =(siteObj.Location_ID__c!=null)?(''+siteObj.Location_ID__c+''):null;
            String BusinessPurpose = (siteObj.ETSALES_Business_Purpose__c!=null)?('"'+siteObj.ETSALES_Business_Purpose__c+'"'):null;
            String ProfileClass = (siteObj.ETSALES_Site_Profile_Class__c!=null)?('"'+siteObj.ETSALES_Site_Profile_Class__c+'"'):null;
            String AccountManager =null;       
            String PaymentTerm =(siteObj.ETSALES_Site_Payment_Terms__c!=null)?('"'+siteObj.ETSALES_Site_Payment_Terms__c+'"'):null;      
            String CreditLimit = (siteObj.ETSALES_Overall_Credit_Limit__c!=null)?(''+siteObj.ETSALES_Overall_Credit_Limit__c+''):null;
            String PaymentTermId =null;           
            String SiteUseId = (siteObj.ETSALES_Site_Use_Id__c!=null)?(''+siteObj.ETSALES_Site_Use_Id__c+''):null;           
            
            String SFDC_ID = (siteObj.id!=null)?('"'+siteObj.id+'"'):null;
            
            
            
            String body ='';
            
            HttpRequest request = new HttpRequest();
            
            body = '{"CustAccountId":'+CustAccountId+',"Org_id":'+Org_id+','+
                '"LocationId":'+LocationId+','+'"BusinessPurpose":'+BusinessPurpose+','+
                '"ProfileClass":'+ProfileClass+','+'"AccountManager":'+AccountManager+','+
                '"PaymentTerm":'+PaymentTerm+','+'"CreditLimit":'+CreditLimit+','+
                '"PaymentTermId":'+PaymentTermId+','+'"SiteUseId":'+SiteUseId+','+'"SFDC_ID":'+SFDC_ID+ '}';
            
            
            System.debug('body='+body);
            
            
            request= createRequest('POST', '/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Site');		
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
                        siteObj.ETSALES_Site_Profile_Id__c= String.valueOf((Integer)responseResult.get('SiteProfileId'));
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
               
                
                siteObj.Integration_Message__c = OracleIntegrationMessage;
                update siteObj;
                System.debug('update successgull='+siteObj);
            }
                      
    }
     public static void integrateContactToOracleFromTrigger(List<Contact> NewContactList)
    {       
        Set<Id> contactIds = new Set<Id>();
        for(Contact con:NewContactList)
        {
            if(con.Oracle_Account_ID__c!=null&&con.Oracle_Account_ID__c!=''&&
               (con.ETSales_Contact_Person_Id__c==null||con.ETSales_Contact_Phone_Id__c==null
                ||con.ETSales_Contact_Email_Id__c==null||con.ETSales_Contact_Mobile_Id__c==null))
            {
                contactIds.add(con.id);
              
            }
        
        }
        
        if(contactIds.size()<100)
        {
            for(Id conId:contactIds)
            {
                  
                 integrateContactToOracle(conId);
            }
        }
    }
    @future(callout = true)
    public static void integrateContactToOracle(Id contactID)
    {
      
            String OracleIntegrationMessage = '';
            
            Contact Con = [Select id,FirstName,MiddleName,Salutation,LastName,Title,Email,Phone_Country_Code__c,Phone,
                           ETSALES_Mob_Country_Code__c,MobilePhone,Site_Use_Id__c,Oracle_Account_ID__c,
                           Integration_Message__c,Integration_Status__c,ETSales_Contact_Person_Id__c,
                           ETSales_Contact_Email_Id__c,ETSales_Contact_Phone_Id__c,ETSales_Phone__c,
                           ETSales_Contact_Mobile_Id__c from Contact where Id =:contactID];   

            String CustAccountId = (Con.Oracle_Account_ID__c!=null)?(''+Con.Oracle_Account_ID__c+''):null;
            String SiteUseId = (Con.Site_Use_Id__c!=null)?(''+Con.Site_Use_Id__c+''):null;
            String Salute =(Con.Salutation!=null)?('"'+Con.Salutation+'"'):null;
            String FirstName = (Con.FirstName!=null)?('"'+Con.FirstName+'"'):null;
            String MiddleName = (Con.MiddleName!=null)?('"'+Con.MiddleName+'"'):null;
            String LastName =(Con.LastName!=null)?('"'+Con.LastName+'"'):null;      
            String Title =(Con.Title!=null)?('"'+Con.Title+'"'):null;       
            String PhoneCountryCode = (Con.Phone_Country_Code__c!=null)?('"'+Con.Phone_Country_Code__c+'"'):null;
            String Phone =(Con.ETSales_Phone__c!=null)?('"'+Con.ETSales_Phone__c+'"'):null;           
            String PhonePurpose = '"BUSINESS"';     
            String MobileCountryCode = (Con.ETSALES_Mob_Country_Code__c!=null)?('"'+Con.ETSALES_Mob_Country_Code__c+'"'):null;     
            String Mobile = (Con.MobilePhone!=null)?('"'+Con.MobilePhone+'"'):null;    
              String MobilePurpose ='"BUSINESS"';    
            String EMail = (Con.Email!=null)?('"'+Con.Email+'"'):null; 
            
            String SFDC_ID = (Con.id!=null)?('"'+Con.id+'"'):null;
            
            if(MobileCountryCode!=null&&MobileCountryCode.contains('(')&&MobileCountryCode.contains(')'))
            {
                Integer startindex= MobileCountryCode.indexOf('(');
                Integer endindex= MobileCountryCode.indexOf(')');
                MobileCountryCode = MobileCountryCode.substring(startindex+1,endindex);
                MobileCountryCode = '"' + MobileCountryCode + '"';
            }
        
     	   if(PhoneCountryCode!=null&&PhoneCountryCode.contains('(')&&PhoneCountryCode.contains(')'))
            {
                Integer startindex= PhoneCountryCode.indexOf('(');
                Integer endindex= PhoneCountryCode.indexOf(')');
                PhoneCountryCode = PhoneCountryCode.substring(startindex+1,endindex);
                PhoneCountryCode = '"' + PhoneCountryCode + '"';
               
            }
            
            String body ='';
            
            HttpRequest request = new HttpRequest();
            
            body = '{"CustAccountId":'+CustAccountId+',"SiteUseId":'+SiteUseId+','+
                '"Salute":'+Salute+','+'"FirstName":'+FirstName+','+
                '"MiddleName":'+MiddleName+','+'"LastName":'+LastName+','+
                '"Title":'+Title+','+'"PhoneCountryCode":'+PhoneCountryCode+','+
                '"Phone":'+Phone+','+'"PhonePurpose":'+PhonePurpose+','+
                '"MobileCountryCode":'+MobileCountryCode+','+'"Mobile":'+Mobile+','+
                '"MobilePurpose":'+MobilePurpose+','+'"EMail":'+EMail+','+
                '"SFDC_ID":'+SFDC_ID+ '}';
            
            
            System.debug('body='+body);
            
            
            request= createRequest('POST', '/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Contact');		
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
                        OracleIntegrationMessage = 'Customer Contact is Successfully Synced with Oracle.';
                    }
                    Integer respPersonId =0;       
                    Integer respPersonPhoneId =0; 
                    Integer respPersonMobileId =0; 
                    Integer respPersonEmailId =0;
                    Boolean PersonIdProvided = false;
                    try{
                         respPersonPhoneId =(Integer)responseResult.get('PersonPhoneId'); 
                    }catch(Exception e){}
                    try{
                         respPersonMobileId =(Integer)responseResult.get('PersonMobileId'); 
                    }catch(Exception e){}
                    try{
                         respPersonEmailId =(Integer)responseResult.get('PersonEmailId'); 
                    }catch(Exception e){}
                      try{
                          respPersonId =(Integer)responseResult.get('PersonId'); 
                          PersonIdProvided = true;
                    }catch(Exception e){}
                  
                    if(PersonIdProvided)
                    {
                        if(respPersonId!=null||respPersonPhoneId!=null||respPersonMobileId!=null||respPersonEmailId!=null)
                    {
                     
                        if(respPersonEmailId!=0)
                        {
                              Con.ETSales_Contact_Email_Id__c	 = String.valueOf(respPersonEmailId);  
                      
                        }
                        if(respPersonPhoneId!=0)
                        {
                             Con.ETSales_Contact_Phone_Id__c = String.valueOf(respPersonPhoneId); 
                         
                        }
                        if(respPersonMobileId!=0)
                        {
                              Con.ETSales_Contact_Mobile_Id__c	 = String.valueOf(respPersonMobileId); 
                        }
                      
                        Con.ETSales_Contact_Person_Id__c = String.valueOf(respPersonId); 
                        Con.Integration_Status__c = 'Success';
                        //   update acc;
                    }
                    }
                    else
                    {
                       
                         Con.Integration_Status__c = 'Failed';
                    OracleIntegrationMessage = 'Integration Failed. Unable to retrieve Person Id from response.';
                    }
                    
                    
                }
                else
                {
                    Con.Integration_Status__c = 'Failed';
                    OracleIntegrationMessage = ResponseMessage;
                }
                
            }
            else{
                Integer statuscode = response.getStatusCode();
                String ErrorMessage = 'Status Code = '+statuscode+' ,'+ 'Error Message = '+response.getBody();
                OracleIntegrationMessage = ErrorMessage;
                Con.Integration_Status__c = 'Failed';
            }
            
            
            if(OracleIntegrationMessage!='')
            {
                //   System.debug('acc.Integration_Message__c='+siteObj.Integration_Message__c);
                System.debug('con.ETSales_Contact_Person_Id__c='+Con.ETSales_Contact_Person_Id__c);
                System.debug('con.ETSales_Contact_Mobile_Id__c='+Con.ETSales_Contact_Mobile_Id__c);
                System.debug('con.Integration_Satus__c='+Con.Integration_Status__c);
                
                Con.Integration_Message__c = OracleIntegrationMessage;
                update Con;
                System.debug('update successfull='+Con);
            }
        
        
    }
    @AuraEnabled
    public static ETSALES_Address__c getAddressDetails(Id AddressID)
    {
        System.debug('inside getting accoutn details');
        return [Select id,Name,Integration_Status__c,ETSALES_Location_ID__c,Oracle_Account_ID__c from ETSALES_Address__c where id=:AddressID];
    }
    @AuraEnabled
    public static ETSALES_Account_Sites__c getAccountSiteDetails(Id AccountSiteID)
    {
        System.debug('inside getting accoutn details');
        return [Select id,Name,Integration_Status__c,Oracle_Account_ID__c,Location_ID__c from ETSALES_Account_Sites__c where id=:AccountSiteID];
    }
    @AuraEnabled
    public static Account getAccountDetails(Id AccountID)
    {
        System.debug('inside getting accoutn details');
        return [Select id,Name,Integration_Status__c,ETSALES_Customer_Account_Id__c from Account where id=:AccountID];
    }
    
    @AuraEnabled
    public static Contact getContactDetails(Id contactID)
    {
        System.debug('inside getting accoutn details');
        return [Select id,Name,Integration_Status__c,Oracle_Account_ID__c,ETSales_Contact_Person_Id__c from Contact where id=:contactID];
    }
    
    public static HttpRequest createRequest(final String method, final String path) {
        
        final HttpRequest req = new HttpRequest();
        //  System.debug(' path in fucntion ='+path);
        //  req.setEndpoint('callout:ETDI_Staging_Endpoint' + path);
          req.setEndpoint(Label.ETSOA_End_Point + path);
      //  req.setEndpoint('https://etdevsoa.et.gov.ae' + path);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');
        
        return req;
    }
}