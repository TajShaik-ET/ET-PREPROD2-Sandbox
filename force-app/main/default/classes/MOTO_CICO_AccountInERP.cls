/*
 Developer Name - Srihari Koyila
 Developed Date - 08 June 2023
 Class Name     - MOTO_CICO_AccountInERP
 Class purpose  - this class contains Post method functions which will call the api to push the data into Oracle from salesforce.
 Test Class     - MOTO_IntegrationTest , Oracle_Integration_Mock 


        -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              08 June 2023           Initial Version 
****************************************************************************************************************/
public without sharing class MOTO_CICO_AccountInERP {
    
   @AuraEnabled
    public static string sendAccToERP(string accID, String OppId) {
        system.debug('---'+accID);
        string resVal = null;
        Account accCheck = [Select id,Name, FirstName, LastName, RecordType.Name  from Account where Id =:accID];   
        Account acc = new Account();
        String Name='';
        String accRecordTypeName = ''; 
        accRecordTypeName =accCheck.RecordType.Name ;
        if(accRecordTypeName.contains('Person'))    
        {
            System.debug('Person');
            Name = accCheck.FirstName+' '+accCheck.LastName;
        }
        else
        {
            Name = accCheck.Name;
        }
        System.debug('Name>>>>>' + Name);
        string QueryString = 'Select id,Integration_Message__c,PersonMobilePhone,PersonEmail,Phone,AccountNumber,ETSALES_Customer_Account_Id__c,Industry,ETSALES_Trade_License_Number__c,ETSALES_Trade_License_Expiry_Date__c,ETSALES_TaxRegistrationNo__c,'+
            'ETSALES_Profile_Class__c,ETSALES_Payment_Terms__c ,Strategic_Account_Manager__r.Name,'+
            'ETSALES_Account_Type__c,RecordType.Name ,ETSALES_Payment_Term_Id__c,ETT_First_Name__c,'+
            'PersonTitle,LastModifiedBy.Email from Account where Id =:accID';
        acc = Database.query(QueryString);
        
        String AccountNo = acc.AccountNumber!=null?acc.AccountNumber:'';
        String CustomerName =Name!=null?Name:'';
        String PersonMobilePhone =acc.PersonMobilePhone!=null?acc.PersonMobilePhone:'';
        String PersonEmail = acc.PersonEmail!=null?acc.PersonEmail:'';
        String Phone =acc.Phone!=null?acc.Phone:'';
        String LastModifiedByEmail =acc.LastModifiedBy.Email!=null?acc.LastModifiedBy.Email:'';
        
        
        
        
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('MOTO_CreatePersonAccount');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('AccountNo',String.valueOf(AccountNo));
        gen.writeStringField('SFDC_ID',String.valueOf(acc.Id));
        gen.writeStringField('CustomerName',CustomerName);
        gen.writeStringField('PhoneCountryCode','+971');
        gen.writeStringField('Phone',String.valueOf(Phone));
        gen.writeStringField('Mobile',PersonMobilePhone.right(9));
        gen.writeStringField('MobileCountryCode','+971');
        gen.writeStringField('EMail',String.valueOf(PersonEmail)); 
      //  gen.writeStringField('USER',LastModifiedByEmail); 

        gen.writeEndObject();
        String jsonData = gen.getAsString();
        System.debug('jsonData');
        HttpRequest request = new HttpRequest();
        System.debug('body='+jsonData);
        
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c);
            system.debug(connection.Dev_Endpoint__c);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c);
        }  
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonData);      
        request.setHeader('Authorization','Basic '+paramvalue);   
        Map<String, Object> responseResult =new Map<String, Object>();
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        System.debug('response body='+response.getBody());
        if (response.getStatusCode() != 200) {
            
            System.debug('Failed ');
            
            responseResult = null;             
            acc.Integration_Message__c  ='Unable to send request to ERP';
            resVal ='Error';
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
                    resVal ='Error';
                }
            }
          
        
        if(responseResult!=null) {
            String ResponseMessage =(String)responseResult.get('Message');
            String ResponseStatus =(String)responseResult.get('Status');
            System.debug('ResponseStatus='+ResponseStatus);
            System.debug('ResponseMessage='+ResponseMessage);
            if(ResponseStatus.contains('S')){
                string  respcustomerAccountId =(String)responseResult.get('CustAccountId');
                system.debug('---'+respcustomerAccountId);
                if(respcustomerAccountId!=null){
                    acc.AccountNumber =(String)responseResult.get('AccountNo');
                    acc.ETSALES_Customer_Account_Id__c = respcustomerAccountId;
                }
                acc.Integration_Status__c = 'Success';
                acc.Integration_Message__c = 'Customer is created successfully in ERP';
                        
                update acc;
                resVal ='Success';
                
                System.debug(acc.AccountNumber);
                System.debug(OppId);
               /* if(AccountNo==null){
                    system.enqueueJob(new PrivateVehIntegration(acc.AccountNumber,OppId));
                    
                }else{
                    system.enqueueJob(new PrivateVehIntegration(AccountNo,OppId));
                    
                }*/
                 
            }
            
            
        }
       }
        return resVal;
    }
    
    
}