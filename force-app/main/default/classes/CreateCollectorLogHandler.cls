/*********************************************************************************
Class       : CreateCollectorLogHandler
Author      : Srihari Koyila
Test Class  : CreateCollectorLogHandlerTest
Description : Get the customer amount details of collector log along this disposition codes.
--------------------------------------------------------------------
History     : 
Sr.No.  version_DevInitials     Date                Details
1        V.1                  05/01/2023           Initial Version - verified by Janardhan
*********************************************************************************/
public class CreateCollectorLogHandler {
    @auraEnabled
    public static list<Disposition_Code__c> getDispositionInfo(){
        return [select id,name,Remark__c from Disposition_Code__c];
    }
    @auraEnabled
    public static customerAmountWrapper getCustomerAmountDetails(Id accID){
        try{
            
            Account acc = [Select id,AccountNumber,ETSALES_Customer_Account_Id__c  from Account where Id =:accID];   
            if(acc.AccountNumber!=Null){
                
                ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('GetCustomerAgingTransaction');
                Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
                string paramvalue = EncodingUtil.base64Encode(beforeblob);
                
                Http httpProtocol = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Accept', 'application/json');
                request.setHeader('Authorization','Basic '+paramvalue); 
                request.setMethod('GET');
                
                if(ET_REST_Authorize_Helper.runningInASandbox()){
                    request.setEndpoint(connection.Dev_Endpoint__c+acc.AccountNumber);
                    system.debug(connection.Dev_Endpoint__c+acc.AccountNumber);
                }else{
                    request.setEndpoint(connection.LiveEndpoint_c__c+acc.AccountNumber);
                }  
                system.debug('request'+request);
                request.setTimeout(90000);
                request.setHeader('Content-Type', 'application/json');
                response = httpProtocol.send(request);
                
                Map<String, Object> responseResult =new Map<String, Object>();
                Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                
                customerAmountWrapper cswp =new customerAmountWrapper();
                if(result!=Null){
                    cswp.totalAmountOriginal=string.valueOf(result.get('totalAmountOriginal'));
                    cswp.totalReceivable=string.valueOf(result.get('totalReceivable'));
                    cswp.errorMessage=string.valueOf(result.get('message'));
                }
                return cswp;
            }
            return null;
        }
        catch(Exception e){               //throw all other exception message            
            throw new AuraHandledException(e.getMessage());}
    }
    
    Public class customerAmountWrapper{
        @AuraEnabled
        Public string totalAmountOriginal{get;set;}
        @AuraEnabled
        Public string totalReceivable{get;set;}  
        @AuraEnabled
        Public string errorMessage{get;set;}  
    }
}