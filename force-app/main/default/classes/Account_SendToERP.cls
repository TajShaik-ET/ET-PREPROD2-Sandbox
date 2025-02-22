/**
*Author: Janardhan Muddana
*Calling Class: syncWithOracleBtnCtrl
*Test Class: Account_SendToERP_Test
*/

public class Account_SendToERP implements Queueable,Database.AllowsCallouts {
    
    public Id accID;
    
    public Account_SendToERP(Id AccountId){
        this.accID=AccountId;
    }
    
    public void execute(QueueableContext con){
        system.debug('inside account queue handler');
        Account accCheck = [Select id,RecordType.Name  from Account where Id =:accID];   
        Account acc = new Account();
        String QueryString='';  
        String Name='';
        String accRecordTypeName = ''; 
        string integResponse ='';
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
            'ETSALES_Profile_Class__c,ETSALES_Payment_Terms__c,TR_Effective_Start_Date__c,TR_Effective_End_Date__c,Strategic_Account_Manager__r.Name,'+
            'ETSALES_Account_Type__c,RecordType.Name ,ETSALES_Payment_Term_Id__c,LastModifiedBy.EmployeeNumber,ETT_First_Name__c,ETSALES_Status__c,'+
            'PersonTitle from Account where Id =:accID';
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
        String TradeLicenseNo = (acc.ETSALES_Trade_License_Number__c !=null)?('"'+acc.ETSALES_Trade_License_Number__c +'"'):null;
        Date expirydate = acc.ETSALES_Trade_License_Expiry_Date__c;
        Date effStartDate = acc.TR_Effective_Start_Date__c;
        Date effEndDate = acc.TR_Effective_End_Date__c;
        String TradeLicenseExpiryDate= null;
        String effStartDateVal= null;
        String effEndDateVal= null;
        if(expirydate!=null)
        {
            TradeLicenseExpiryDate = '"'+DateTime.newInstance(expirydate.year(), expirydate.month(), expirydate.day()).format('yyyy-MM-dd')+'"'; 
        }
         if(effStartDate!=null)
        {
            effStartDateVal = '"'+DateTime.newInstance(effStartDate.year(), effStartDate.month(), effStartDate.day()).format('yyyy-MM-dd')+'"'; 
        }
         if(effEndDate!=null)
        {
            effEndDateVal = '"'+DateTime.newInstance(effEndDate.year(), effEndDate.month(), effEndDate.day()).format('yyyy-MM-dd')+'"'; 
        }
        
        String TaxRegistrationNo = (acc.ETSALES_TaxRegistrationNo__c!=null)?('"'+acc.ETSALES_TaxRegistrationNo__c+'"'):null;
        String ProfileClass = (acc.ETSALES_Profile_Class__c!=null)?('"'+acc.ETSALES_Profile_Class__c+'"'):null;
        String PaymentTerm = (acc.ETSALES_Payment_Terms__c !=null)?('"'+acc.ETSALES_Payment_Terms__c +'"'):null;
        String AccountManager = (acc.Strategic_Account_Manager__r.Name!=null)?('"'+acc.Strategic_Account_Manager__r.Name+'"'):null;
        String AccountType = (acc.ETSALES_Account_Type__c!=null)?('"'+acc.ETSALES_Account_Type__c+'"'):null;
        String SFDC_ID =(acc.id!=null)?('"'+acc.id+'"'):null;
        //String PaymentTermId = (acc.ETSALES_Payment_Term_Id__c!=null)?('"'+acc.ETSALES_Payment_Term_Id__c+'"'):null;
        String PaymentTermId =null;
        String LastModifiedByFinNum =acc.LastModifiedBy.EmployeeNumber!=null?('"'+acc.LastModifiedBy.EmployeeNumber+'"'):'';
		String AccountStatus = (acc.ETSALES_Status__c!=null)?('"'+acc.ETSALES_Status__c+'"'):null;
        
        String body ='';
        
        HttpRequest request = new HttpRequest();
        
        body = '{"AccountNo":'+AccountNo+',"CustomerName":'+CustomerName+',"User":'+LastModifiedByFinNum+','+
            '"CustomerType":'+CustomerType+','+'"CustomerIndustry":'+CustomerIndustry+','+
            '"TradeLicenseNo":'+TradeLicenseNo+','+'"TradeLicenseExpiryDate":'+TradeLicenseExpiryDate+','+
            '"TaxRegistrationNo":'+TaxRegistrationNo+','+'"ProfileClass":'+ProfileClass+','+
            '"PaymentTerm":'+PaymentTerm+','+'"AccountManager":'+AccountManager+','+
            '"AccountType":'+AccountType+','+'"SFDC_ID":'+SFDC_ID+','+
            '"PaymentTermId":'+PaymentTermId+','+'"FirstName":'+FirstName+','+
            '"LastName":'+LastName+','+'"MiddleName":'+MiddleName+','+'"Title": '+Title +','+'"TaxRegistrationFromDate":'+effStartDateVal+','+'"TaxRegistrationToDate":'+effEndDateVal+','+'"AccountStatus":'+AccountStatus+'}';
        
        
        System.debug('body='+body);
        request.setEndpoint(Label.ETSOA_End_Point +'/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Account');
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        
        request.setBody(body);      
        
        
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
          
            responseResult = null;             
            acc.Integration_Message__c  ='Unable to send request to ERP';
        }
        else{
            if(response.getStatusCode() == 200){
                System.debug('Sucess ');
                Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                responseResult =result;
                system.debug('--res--'+responseResult);
                if(string.valueOf(result.get('Status')) =='E'){
                    
                acc.Integration_Status__c = 'Error';
                acc.Integration_Message__c = string.valueOf(result.get('Message'));
                update acc;  
                   
                }
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
                string  respcustomerAccountId =(String)responseResult.get('CustAccountId');
                system.debug('---'+respcustomerAccountId);
                acc.AccountNumber =(String)responseResult.get('AccountNo');
                acc.ETSALES_Customer_Account_Id__c = respcustomerAccountId;
                acc.Integration_Status__c = 'Success';
                acc.Integration_Message__c = 'Customer is created successfully in ERP';
                update acc;
                if(!test.isRunningTest())
                system.enqueueJob(new Address_SendToERPQueueableCtrl(accID,respcustomerAccountId));
            }
            
            
        }
    }
    
}