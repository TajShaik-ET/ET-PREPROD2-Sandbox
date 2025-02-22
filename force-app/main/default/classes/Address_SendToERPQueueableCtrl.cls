/**
Author: Janardhan Muddana
Test Class: Account_SendToERP_Test
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date     Author           Details
1.          V1.0                         Janardhan	    Initial Version 
2.          v2.0			17/04/2023   Janardhan    	logic is implemented to handle mutiple addresss
****************************************************************************************************************/

public class Address_SendToERPQueueableCtrl implements Queueable,Database.AllowsCallouts{
    
    public Id accID;
    public string ERPAccId;
    
    public Address_SendToERPQueueableCtrl(Id AccountId,string ERPAccId){
        this.accID=AccountId;
        this.ERPAccId = ERPAccId;
    }
    
    
    public void execute(QueueableContext con){        
        
        List<ETSALES_Address__c> addressObjList = [Select id,ETSALES_Address1__c,ETSALES_Address2__c,
                                                   ETSALES_Address3__c,ETSALES_Address4__c,ETSALES_City__c,ETSALES_Country__c,Oracle_Account_ID__c,
                                                   ETSALES_Location_ID__c,Postal_code__c,ETSALES_State__c,Integration_Message__c,Integration_Status__c
                                                   from ETSALES_Address__c where ETSALES_Account__c =:accID];  
      
        for(ETSALES_Address__c addr : addressObjList){
            
            String CountryName=''; 
            if(addr.ETSALES_Country__c!=null) {
                String CountryCode = addr.ETSALES_Country__c;
                
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
            createAddressInERP(accID,ERPAccId,addr.ETSALES_Address1__c,addr.ETSALES_Address2__c,addr.ETSALES_Address3__c,addr.ETSALES_Address4__c,addr.ETSALES_City__c,addr.ETSALES_State__c,addr.Postal_code__c,CountryName,addr.id,addr.ETSALES_Location_ID__c);
            
        }
       
    }
    
    @Future(callout=true)
    public static void createAddressInERP(string accID,string ERPAccId,string Add1,string Add2,string Add3,string Add4,string cityVal,string stateVal,string psCode,string countryName,string addId,string locId){       
             
            
            String CustAccountId = ERPAccId;//(addressObj[0].Oracle_Account_ID__c!=null)?(''+addressObj[0].Oracle_Account_ID__c+''):null;
            String Address1 = (Add1!=null)?('"'+Add1+'"'):null;
            String Address2 =(Add2!=null)?('"'+Add2+'"'):null;
            String Address3 = (Add3!=null)?('"'+Add3+'"'):null;
            String Address4 = (Add4!=null)?('"'+Add4+'"'):null;
            String City = (cityVal!=null)?('"'+cityVal+'"'):null;       
            String State = (stateVal!=null)?('"'+stateVal+'"'):null;       
            String PostalCode = (psCode!=null)?('"'+psCode+'"'):null;
            String Country = (countryName!='')?('"'+countryName+'"'):null;       
            String SFDC_ID = (addId!=null)?('"'+addId+'"'):null;
            String LocationId = locId!=null ?('"'+locId+'"'):null;
            
            
            String body ='';
            
            ETSALES_Address__c addUpdate = new ETSALES_Address__c();
            addUpdate.Id = addId;
            HttpRequest request = new HttpRequest();
            
            body = '{"CustAccountId":'+CustAccountId+',"Address1":'+Address1+','+
                '"Address2":'+Address2+','+'"Address3":'+Address3+','+
                '"Address4":'+Address4+','+'"City":'+City+','+
                '"State":'+State+','+'"PostalCode":'+PostalCode+','+
                '"Country":'+Country+','+'"SFDC_ID":'+SFDC_ID+','+
                '"LocationId":'+LocationId+ '}';
            
            
            System.debug('body='+body);
            
            request.setEndpoint(Label.ETSOA_End_Point +'/soa-infra/resources/SalesForceIntegration/ArkanCustomerAPI/ArkanCustomerApiRest/Location');
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
                Integration_Log__c log = new Integration_Log__c();
                log.Process_Name__c	='Send Account Site to ERP';
                log.Integration_Type__c ='OUTBOUND';
                log.Source_System__c ='Salesforce';
                log.Target_System__c ='Oracle';
                log.Json_Response__c =response.getBody();
                insert log;
                responseResult = null;             
                addUpdate.Integration_Status__c ='Failed';
            }
            else{
                if(response.getStatusCode() == 200){
                    System.debug('Sucess ');
                    Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    responseResult =result;
                    system.debug('--res--'+result);
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
                    
                    addUpdate.ETSALES_Location_ID__c =(String)responseResult.get('LocationId');      
                    addUpdate.Integration_Status__c ='Success';
                    if(!test.isRunningTest())
                        system.enqueueJob(new AccountSite_SendToERPQueueableCtrl(accID,ERPAccId,addUpdate.ETSALES_Location_ID__c)); 
                }
            }
           
            update addUpdate;
        }
      
}