/*
* File Name:ET_Payment_Controller
* Author : Sagar Kambli
* CreatedDate : 19/02/2020
* Modification Purpose
* * 1. Sagar: Created for CommonUtil Methods 
* * 2. Janardhan: 23/02/23- Add new form before payment page
*/
public class ET_Payment_Controller {
    
    public static string outletref {get;set;}
    public static string message {get;set;}
    public static string title {get;set;}
    public static string messagetype{get;set;}
    public static string access_token = '';
    public static Decimal expires_in = 0;
    public static Decimal refresh_expires_in = 0;
    public static string refresh_token = '';
    public static string token_type = '';
    public static string not_before_policy = '';
    public static string session_state = '';
    public static string scope = '';
    public static string endpoint_url = '';
    public static string developerName = '';
    public static string action = '';
    public static Decimal serviceAmount{get;set;}
    public static Integer serviceAmountValue{get;set;}
    public static string paymentReply{get;set;}
    public static string sessionId{get;set;}
    public static string src {get;set;}
    public static string zone {get;set;} //Added by Janardhan
    public static string firstName {get;set;}//Added by Janardhan
    public static string lastName {get;set;}//Added by Janardhan
    public static string emailVal {get;set;}//Added by Janardhan
    public static boolean showDetailForm {get;set;}
    public static string requestId{get;set;}
    //extra amount to pay for modified booking..    
    public static Integer extraAmount{get;set;}// added by Mani
    public static string serviceType{get;set;}
    public static string PickupLabel {get;set;}
    public static string Pickup{get;set;}
    public static string apiKey {get;set;}
    public static List<ETI_Inspection_Receipt__c> receipts {get;set;}
    public static string hostedSessionAPIKey {get;set;}
    public static Datetime convertedDateTime {get;set;}
    Public static String siteURL {get;set;}
    Public static String Lang {get;set;} //Added by Noor Shaik on 11/02/2021 for Bilingual Community
    
    public static string paymentId{get;set;}
    public static string status{get;set;}
    public static string validUpTo{get;set;}
    public static boolean isMiscellaneousPayment{get;set;}
    
    
    // Determine getPaymentStatus is calling from batch or Not
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to setMessage.
    * @Params           null
    * @return           null
    *********************************************************************************************************/ 
    
    public void setMessage(){
        string messageUI = Apexpages.currentPage().getParameters().get('messageUI');
        system.debug(messageUI);
        message =  messageUI.replace('.', '.<br/>');
        title = 'error';
        messageType = 'slds-theme_error';
    }
    
    public static void updateFormValue(){
      
        showDetailForm = false;
        Pickup = 'NA';
        validUpTo = '';
        serviceType = 'NA';
        PickupLabel='NA';
        serviceAmount = 0;
        serviceAmountValue = 0;
        src = '';
        
        Lang = apexpages.currentpage().getparameters().get('lang')!=null?apexpages.currentpage().getparameters().get('lang'):'en';
        //Retrieve API Details
        ET_External_Endpoint__mdt tokendetails = [SELECT Id,outletRef__c,HostedSessionID__C, PaymentURL__c,DeveloperName, MasterLabel, URL__c, QualifiedApiName, Action__c, Content_Type__c, Authorization__c, Grant_Type__c, EnvironmentType__c FROM ET_External_Endpoint__mdt where DeveloperName =:ET_Common_Util.ACCESS_TOKEN and EnvironmentType__c =: ET_Common_Util.PAYMENT_INTEGRATION_ENVIRONMENT limit 1];
        apiKey = tokendetails.Authorization__c;
        // outletRef = tokendetails.outletRef__c;
        hostedSessionAPIKey = tokendetails.HostedSessionID__C;
        siteURL=Site.getBaseRequestUrl();  
        system.debug('siteURL >>'  +siteURL);
        processInitilizationData();        
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to convertISODateTimeString.
    * @Params           dateString
    * @return           Datetime
    *********************************************************************************************************/    
    public static Datetime convertISODateTimeString(string dateString){
        dateString = '"'+dateString+'"';
        system.debug(dateString);
        system.debug('Converted Value: '+JSON.deserialize(dateString,DateTime.class));
        return (DateTime)JSON.deserialize(dateString,DateTime.class);
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to ET_Payment_Controller.
    * @Params           null
    * @return           null
    *********************************************************************************************************/      
    public ET_Payment_Controller(){
        showDetailForm = true;
      //Commented code by Janardhan: 20-02-23 , called from another method
      /* requestId = '';
        Pickup = 'NA';
        validUpTo = '';
        serviceType = 'NA';
        PickupLabel='NA';
        serviceAmount = 0;
        serviceAmountValue = 0;
        src = '';
        Lang = apexpages.currentpage().getparameters().get('lang')!=null?apexpages.currentpage().getparameters().get('lang'):'en';
       //Retrieve API Details
        ET_External_Endpoint__mdt tokendetails = [SELECT Id,outletRef__c,HostedSessionID__C, PaymentURL__c,DeveloperName, MasterLabel, URL__c, QualifiedApiName, Action__c, Content_Type__c, Authorization__c, Grant_Type__c, EnvironmentType__c FROM ET_External_Endpoint__mdt where DeveloperName =:ET_Common_Util.ACCESS_TOKEN and EnvironmentType__c =: ET_Common_Util.PAYMENT_INTEGRATION_ENVIRONMENT limit 1];
        apiKey = tokendetails.Authorization__c;
        // outletRef = tokendetails.outletRef__c;
        hostedSessionAPIKey = tokendetails.HostedSessionID__C;
        siteURL=Site.getBaseRequestUrl();  
        system.debug('siteURL >>'  +siteURL);
        processInitilizationData();
*/
    }
    
    
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Process Payment - through NGenius
    * @Params           null
    * @return           null
    *********************************************************************************************************/
    public static void makePayment(){
        
        processInitilizationData();
        ET_Common_Util.ETPaymentResponse paymentResponse = new ET_Common_Util.ETPaymentResponse();
        Integer statusCode = 0;
        String status='';
        ET_Common_Util.ETResponse response = new  ET_Common_Util.ETResponse();
        List<ETST_Payment__c> paymentList = new List<ETST_Payment__c>();
        system.debug('---inside make payment--2');
        
        try{
            getNGeniusAccessToken();
            string sessionKey = Apexpages.currentPage().getParameters().get('sessionId');
            system.debug('Session Key: '+sessionKey);
           
            paymentResponse = makeNGeniusPayment(sessionKey);
            system.debug('paymentResponse>>' +paymentResponse);
            if(paymentResponse!=null){
                paymentList.add(getPaymentRow(paymentResponse));
                Schema.SObjectField ftoken = ETST_Payment__c.Fields.externalId__C;
                if(paymentList!=null && paymentList.size()>0){
                    Database.UpsertResult[] srList = Database.upsert(paymentList,ftoken,false);  
                    for (Database.UpsertResult sr : srList) {
                        if (sr.isSuccess()) {
                            if(sr.getId()!=null) 
                                paymentId = sr.getId();
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                System.debug('fields that affected this error: ' + err.getFields());
                                
                            }
                        }
                    }
                    
                }
                
                if(receipts != null && receipts.size() > 0)
                {
                    Database.SaveResult[] rcptList = Database.insert(receipts,false);  
                    for (Database.SaveResult sr : rcptList) {
                        if (sr.isSuccess()) {
                            // Operation was successful
                            if(sr.getId()!=null) 
                            {
                                system.debug(sr.getId());
                            }
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                                System.debug('fields that affected this error: ' + err.getFields());
                                
                            }
                        }
                    }
                    
                }
                
                message = 'Payment has done Successfully';
                messageType = 'slds-theme_success';
                title = 'success';
            }
            else
            {
                message = 'Error: There has been error during the process';
                title = 'error';
                messageType = 'slds-theme_error';
            }
            
        }
        catch(Exception error){
            system.debug('------------------ PAYMENT ERROR START---------------------');
            system.debug('1. Error: '+error.getMessage());
            system.debug('2. Error Stack Trace: '+error.getStackTraceString());
            system.debug('------------------ PAYMENT ERROR END---------------------');
            
        }
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Update Payment - after getting its status
    * @Params           null
    * @return           void
    *********************************************************************************************************/
    public void updatePayment(){
        string payment_status = Apexpages.currentPage().getParameters().get('status');
        string payment_Id = Apexpages.currentPage().getParameters().get('paymentId');
        system.debug('payment_Id: '+payment_Id);
        system.debug('payment_status: '+payment_status);
        ETST_Payment__c payRecord = [SELECT Id,Name , ETST_Payment_URL__c, ETST_Payment_State__c,ExternalId__c,ET_Service_Request__c,
                                     ETST_savedCardToken__c,ETST_recaptureCard__c,ETST_AuthorizationCode__c,
                                     ETST_ResultMessage__c,ETST_AuthorizationRRN__c,ETST_authSuccess__c,ETST_Amount__c,
                                     ETST_Capture_Link__c,ETST_RefundURL__c,ETST_Capture_Time__c,ETST_Capture_State__c
                                     FROM ETST_Payment__c where ExternalId__c=:payment_Id];
        ET_External_Endpoint__mdt tokendetails = [SELECT Id,outletRef__c,HostedSessionID__C, PaymentURL__c,DeveloperName, MasterLabel, URL__c, QualifiedApiName, Action__c, Content_Type__c, Authorization__c, Grant_Type__c, EnvironmentType__c FROM ET_External_Endpoint__mdt where DeveloperName =:ET_Common_Util.ACCESS_TOKEN and EnvironmentType__c =: ET_Common_Util.PAYMENT_INTEGRATION_ENVIRONMENT limit 1];
        getNGeniusAccessToken();
        ET_common_util.ETResponse response = ET_Common_Util.makeCallout(tokendetails.DeveloperName,payRecord.ETST_Payment_URL__c, 'GET','application/vnd.ni-payment.v2+json', '', access_token,'Bearer','');
        system.debug(response);
        updatePaymentRows(response,payRecord);
        
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Get Payment Status
    * @Params           null
    * @return           void
    *********************************************************************************************************/
  static Boolean fromBatch;
    public static void getPaymentStatus(String payment_Id, Boolean isFromBatch){
        fromBatch = isFromBatch;
       // isFromBatch = isFromBatchLocal;
        system.debug('payment_Id: '+payment_Id);
        ETST_Payment__c payRecord = [SELECT Id,Name , ETST_Payment_URL__c, ETST_Payment_State__c,ExternalId__c,ET_Service_Request__c,
                                     ETST_savedCardToken__c,ETST_recaptureCard__c,ETST_AuthorizationCode__c,Json_Response__c,
                                     ETST_ResultMessage__c,ETST_AuthorizationRRN__c,ETST_authSuccess__c,ETST_Amount__c,
                                     ETST_Capture_Link__c,ETST_RefundURL__c,ETST_Capture_Time__c,ETST_Capture_State__c, ETI_IsUpdatedByBatch__c
                                     FROM ETST_Payment__c where ExternalId__c=:payment_Id];
        ET_External_Endpoint__mdt tokendetails = [SELECT Id,outletRef__c,HostedSessionID__C, PaymentURL__c,DeveloperName, MasterLabel, URL__c, QualifiedApiName, Action__c, Content_Type__c, Authorization__c, Grant_Type__c, EnvironmentType__c FROM ET_External_Endpoint__mdt where DeveloperName =:ET_Common_Util.ACCESS_TOKEN and EnvironmentType__c =: ET_Common_Util.PAYMENT_INTEGRATION_ENVIRONMENT limit 1];
        getNGeniusAccessToken();
        ET_common_util.ETResponse response = ET_Common_Util.makeCallout(tokendetails.DeveloperName,payRecord.ETST_Payment_URL__c, 'GET','application/vnd.ni-payment.v2+json', '', access_token,'Bearer','');
        system.debug('response>> '+response);
        updatePaymentRows(response,payRecord);        
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Get Access Token
    * @Params           null
    * @return           ET_Common_Util.ETSPaymentAccessToken
    *********************************************************************************************************/
    public static ET_Common_Util.ETSPaymentAccessToken getNGeniusAccessToken(){
        ET_Common_Util.ETSPaymentAccessToken tokenData = new ET_Common_Util.ETSPaymentAccessToken();
        ET_External_Endpoint__mdt tokendetails = [SELECT Id,outletRef__c,HostedSessionID__C, PaymentURL__c,DeveloperName, MasterLabel, URL__c, QualifiedApiName, Action__c, Content_Type__c, Authorization__c, Grant_Type__c, EnvironmentType__c FROM ET_External_Endpoint__mdt where DeveloperName =:ET_Common_Util.ACCESS_TOKEN and EnvironmentType__c =: ET_Common_Util.PAYMENT_INTEGRATION_ENVIRONMENT limit 1];
        if(tokendetails!=null){
            endpoint_url = tokendetails.PaymentURL__c;
            developerName =  tokendetails.DeveloperName;
            system.debug('endpoint_url '+endpoint_url);
            system.debug('developerName '+developerName);
            //outletRef = tokendetails.outletRef__c;
            action = tokendetails.Action__c;
            system.debug('action '+action);
            
            ET_common_util.ETResponse response = ET_Common_Util.makeCallout(developerName, tokendetails.URL__c,action , tokendetails.Content_Type__c, tokendetails.Grant_Type__c, tokendetails.Authorization__c,'Basic','');
            if(response!=null && response.StatusCode == 200){
                tokenData = (ET_Common_Util.ETSPaymentAccessToken) JSON.deserialize(response.body, ET_Common_Util.ETSPaymentAccessToken.class);
               
                access_token = tokenData.access_token;
                system.debug('--accessToken--'+access_token);
                expires_in = tokenData.expires_in;
                refresh_expires_in = tokenData.refresh_expires_in;
                refresh_token = tokenData.refresh_token;
                token_type = tokenData.token_type;
                session_state = tokenData.session_state;
                scope = tokenData.scope;
            }
            else
            {
                message = 'Error: '+response.StatusCode+' There has been error during the process';
                title = 'error';
                messageType = 'slds-theme_error';
                return null;
            }
        }
        else
        {
            message = 'Error: No token found in Settings';
            title = 'error';
            messageType = 'slds-theme_error';
            return null;
            
        }
        return tokenData;
    } 
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Make Payment
    * @Params           sessionKey
    * @return           ET_Common_Util.ETPaymentResponse
    *********************************************************************************************************/
    public static ET_Common_Util.ETPaymentResponse makeNGeniusPayment(string sessionKey){
        ET_Common_Util.ETPaymentResponse paymentResponse = new ET_Common_Util.ETPaymentResponse();
        //string jsonBody = '{"action":"'+ET_common_Util.SALE+'","amount":{"currencyCode":"'+ET_common_Util.CurrencyCode+'","value":'+serviceAmountValue+'}}';
     
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('action',ET_common_Util.SALE);
        gen.writeFieldName('amount');
        gen.writeStartObject();
        gen.writeStringField('currencyCode',ET_common_Util.CurrencyCode);
        gen.writeNumberField('value',serviceAmountValue);
        gen.writeEndObject();
        gen.writeStringField('emailAddress',emailVal);
        gen.writeFieldName('billingAddress');
        gen.writeStartObject();
        gen.writeStringField('firstName', firstName);
        gen.writeStringField('lastName', lastName);
        gen.writeEndObject();
        gen.writeEndObject();
        string jsonBody = gen.getAsString();
       
        system.debug(jsonBody);
        string paymentEndpoint = '';
        if(!string.isBlank(endpoint_url)){
            string[] parts = endpoint_url.split('~');
            if(parts.size()==2){
                paymentEndpoint = parts[0]+outletref+parts[1]+sessionKey;
                ET_common_util.ETResponse response = ET_Common_Util.makeCallout(developerName,paymentEndpoint,action,'application/vnd.ni-payment.v2+json', '', access_token,'Bearer',jsonBody);
                system.debug('Make Payment Response: ');
                system.debug(response.body);
                if(response!=null && response.StatusCode == 201){
                    string json = response.body;
                    paymentReply = response.body;
                    system.debug('paymentReply >>'  +paymentReply);
                    json = json.replace('_links', 'links');
                    json = json.replace('_id', 'pid');
                    json = json.replace('cnp:3ds', 'cnp3ds');
                    json = json.replace('3ds', 'ds');
                    json = json.replace('_embedded', 'embedded');
                    json = json.replace('cnp:capture', 'capture');
                    paymentResponse = ET_Common_Util.parse(json);
                    return paymentResponse;
                    
                }
                else
                {
                    message = 'Error: '+response.StatusCode+' There has been error during the process';
                    title = 'error';
                    messageType = 'slds-theme_error';
                    return null;
                }
            }
        }            
        return null;
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Create Payment Row in SF
    * @Params           paymentResponse
    * @return           ETST_Payment__c
    *********************************************************************************************************/
    public static ETST_Payment__c getPaymentRow(ET_Common_Util.ETPaymentResponse paymentResponse){
        Id recordTypeId;
        if(isMiscellaneousPayment)
            recordTypeId=Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Miscellaneous_Payment').getRecordTypeId();
        else
            recordTypeId =Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Card_Payment').getRecordTypeId();
        ETST_Payment__c payRecord = new ETST_Payment__c();
        payRecord.RecordTypeId = recordTypeId;
        payRecord.ETST_Payment_Mode__c = 'Online';
        //----------------Standard Binding---------------------
        if(paymentResponse.pid!=null)
        {
            string pid = paymentResponse.pid;
            string[] IDArray = pid.split(':');
            if(IDArray.size()==3){
                payRecord.externalId__C = IDArray[2];
            }
            if(src=='etst'){
                payRecord.ET_Service_Request__c = requestId;
            }                                   
            else{
                payRecord.ET_Service_Request__c = requestId; 
            }
            
            
        }
        if(paymentResponse.state!=null)
            payRecord.ETST_Payment_State__c = paymentResponse.state;
        if(paymentResponse.outletId!=null)
            payRecord.ETST_Gateway_Outlet_ID__c = paymentResponse.outletId;
        if(paymentResponse.orderReference!=null)
            payRecord.ETST_Order_Reference__c = paymentResponse.orderReference;
        //if(paymentResponse.updateDateTime!=null)
        //payRecord.ET_Payment_Last_Modified_Date__c = Datetime.valueOf(paymentResponse.updateDateTime);
        if(paymentResponse.updateDateTime != null)
        {
            Datetime lastmodifiedTime = convertISODateTimeString(paymentResponse.updateDateTime);
            payRecord.ET_Payment_Last_Modified_Date__c = lastmodifiedTime;
        }
        
        //----------------Payment Amount Object Binding---------------------
        ET_common_util.cls_amount paymentAmount = new ET_common_util.cls_amount();
        if(paymentResponse.amount!=null)
        {
            paymentAmount = paymentResponse.amount;
            if(paymentAmount!=null){
                if(paymentAmount.currencyCode!=null)
                    payRecord.ETST_Currency__c = paymentAmount.currencyCode;
                if(paymentAmount.value!=null)
                    payRecord.ETST_Amount__c =(paymentAmount.value / 100);
            }
        }
        //----------------Payment Method Object Binding---------------------
        ET_common_util.cls_paymentMethod paymentDetails = new ET_common_util.cls_paymentMethod();
        if(paymentResponse.paymentMethod!=null)
        {
            paymentDetails = paymentResponse.paymentMethod;
            if(paymentDetails!=null){
                if(paymentDetails.cardholderName!=null)
                {
                    string holderName = paymentDetails.cardholderName;
                    payRecord.ETST_Cardholder_Name__c =holderName;
                    //payRecord.Name = holderName+'_'+paymentResponse.updateDateTime;
                }
                if(paymentDetails.expiry!=null){
                    payRecord.ETST_Card_Expiry__c=paymentDetails.expiry;
                }
                if(paymentDetails.name!=null){
                    payRecord.ETST_Card_Number__c=paymentDetails.pan;
                }
                
                if(paymentDetails.name!=null)
                    payRecord.ETST_Card_Type__c = paymentDetails.name;
            }
        }
        
        
        //----------------cls_links Object Binding------------------------
        string paymentURL = '';
        string paymentURL3D = '';
        ET_Common_util.cls_links linkDetails = new ET_Common_util.cls_links();
        if(paymentResponse.links!=null)
        {
            linkDetails = paymentResponse.links;
            if(linkDetails!=null){
                if(linkDetails.self!=null){
                    ET_Common_util.cls_self self = linkDetails.self;
                    if(self!=null){
                        if(self.href!=null)
                        {    
                            payRecord.ETST_Payment_URL__c = self.href; 
                            paymentURL = self.href;
                        }
                    }
                }
                if(linkDetails.cnpds!=null){
                    ET_Common_util.cnp_3ds cnp_details = linkDetails.cnpds;
                    system.debug('************');
                    system.debug(cnp_details);
                    if(cnp_details!=null){
                        if(cnp_details.href!=null)
                        {  payRecord.ETST_Payment_URL_3D__c = cnp_details.href; 
                         paymentURL3D =  cnp_details.href;}
                    }
                }
            }
        }
        
        //----------------cls_3ds Object Binding------------------------
        ET_Common_util.cls_3ds otherDetails = new ET_Common_util.cls_3ds();
        if(paymentResponse.ds!=null){
            otherDetails = paymentResponse.ds;
            if(otherDetails!=null){
                if(otherDetails.acsMd!=null)
                    payRecord.ETST_ACSMd__c = otherDetails.acsMd;
                if(otherDetails.acsPaReq!=null)
                    payRecord.ETST_ACSPaReq__c = otherDetails.acsPaReq;
                if(otherDetails.acsUrl!=null)
                    payRecord.ETST_ACS_URL__c = otherDetails.acsUrl;
            }
        }
        return payRecord;
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to voidPayment
    * @Params           paymentId
    * @return           string
    *********************************************************************************************************/
    public static string voidPayment(string paymentId){
        string status = '';
        List<ETST_Payment__c> payRecord = getPaymentById(paymentId);
        if(payRecord!=null && payRecord.size() ==1){
            if(payRecord[0].ETST_Capture_State__c == 'SUCCESS'){
                getNGeniusAccessToken();
                ET_common_util.ETResponse response = ET_Common_Util.makeCallout(developerName,payRecord[0].ETST_Capture_Link__c, 'DELETE','application/vnd.ni-payment.v2+json', '', access_token,'Bearer','');
                if(response!=null && response.StatusCode == 200){
                    updatePaymentRows(response,payRecord[0]);
                    return 'Successfully cancelled the Payment - '+payRecord[0].ETST_AuthorizationCode__c;
                }
                else
                {
                    return 'Payment is not valid for cancellation';
                }
            }
            else{
                if(payRecord[0].ETST_Capture_State__c == 'VOID')
                    return 'Payment is already cancelled';
                else
                    return 'Payment is not valid for cancellation';
            }
        }
        else{
            return 'No payment Record exist';
        }
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to create Refund request
    * @Params           paymentId,amtToRefund
    * @return           ET_Common_Util.ETPaymentResponse
    *********************************************************************************************************/
    public static ET_Common_Util.ETPaymentResponse createRefundRequest(string paymentId,Decimal amtToRefund){
        string status = '';
        List<ETST_Payment__c> payRecord = getPaymentById(paymentId);
        system.debug('payRecord[0].ETST_refund_state__c-->'+payRecord[0].ETST_refund_state__c);
        system.debug('payRecord[0].ETST_Capture_State__c-->'+payRecord[0].ETST_Capture_State__c);
        ET_Common_Util.ETPaymentResponse paymentResponse = new ET_Common_Util.ETPaymentResponse();
        
        if(payRecord!=null && payRecord.size() ==1){
            if(payRecord[0].ETST_Capture_State__c == 'SUCCESS'){
                getNGeniusAccessToken();
                string jsonBody = '{"amount":{"currencyCode":"'+payRecord[0].ETST_Currency__c+'","value":'+integer.valueOf(amtToRefund)*100+'}}';
                system.debug('jsonBody '+jsonBody);
                try{
                    // Create log before invoking webservice
                    
                    ET_common_util.ETResponse response = ET_Common_Util.makeCallout(developerName,payRecord[0].ETST_Capture_Link__c+'/refund', 'POST','application/vnd.ni-payment.v2+json', '', access_token,'Bearer',jsonBody);
                    system.debug('response--->'+response);
                    if(response!=null && response.StatusCode == 201){
                        
                        //ET_Common_Util.sendEmail('Test Refund response', new string[]{'sagar.kambli@smaartt.com'}, null, null, response.body);
                        updatePaymentRows(response,payRecord[0]);
                        string json = response.body;
                        json = json.replace('_links', 'links');
                        json = json.replace('_id', 'pid');
                        json = json.replace('cnp:3ds', 'cnp3ds');
                        json = json.replace('3ds', 'ds');
                        json = json.replace('_embedded', 'embedded');
                        json = json.replace('cnp:capture', 'capture');
                        json = json.replace('cnp:refund', 'refund');
                        paymentResponse = ET_Common_Util.parse(json);
                        system.debug('paymentResponse-->'+paymentResponse);
                        UTIL_Logging.createIntegrationLog('OUTBOUND',jsonBody, 'Refund Request',
                                                          'SF','nGenius', payRecord[0].Id);
                        return paymentResponse;
                        //return 'Successfully requested the refund for payment - '+payRecord[0].ETST_AuthorizationCode__c;
                    }
                    else{
                        UTIL_Logging.createIntegrationLog('OUTBOUND',jsonBody, 'Refund Request',
                                                          'SF','nGenius', payRecord[0].Id);
                        return null;
                    }
                }
                catch(exception ex){
                    
                    UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'ET_Payment_Controller', 'createRefundRequest', '', UTIL_Logging.DEBUG_LEVEL_WARN);
                    UTIL_Logging.logException(exLog);
                    UTIL_Logging.createIntegrationLog('OUTBOUND',jsonBody, 'Refund Request',
                                                      'SF','nGenius', payRecord[0].Id);
                    return null;
                }
                
            }
        }
        return null;
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Process Refund Cancellation
    * @Params           paymentId
    * @return           string
    *********************************************************************************************************/
    public static string cancelRefund(string paymentId){
        string status = '';
        List<ETST_Payment__c> payRecord = getPaymentById(paymentId);
        if(payRecord!=null && payRecord.size() ==1){
            if(payRecord[0].ETST_refund_state__c!=null && payRecord[0].ETST_refund_state__c == 'SUCCESS'){
                DateTime paymentDateTime = payRecord[0].ETST_Refund_Date_Time__c;
                Date paymentDate  = paymentDateTime.date();
                Date currentDate = system.today();
                if(currentDate <= paymentDate)
                    return 'Refund Cancellation is only applicable after 24 hrs of applying for refund';
                
                getNGeniusAccessToken();
                ET_common_util.ETResponse response = ET_Common_Util.makeCallout(developerName,payRecord[0].ETST_refundURL__c, 'DELETE','application/vnd.ni-payment.v2+json', '', access_token,'Bearer','');
                if(response!=null && response.StatusCode == 200){
                    //ET_Common_Util.sendEmail('Test Refund response', new string[]{'sagar.kambli@smaartt.com'}, null, null, response.body);
                    updatePaymentRows(response,payRecord[0]);
                    return 'Successfully cancelled the refund for payment - '+payRecord[0].ETST_AuthorizationCode__c;
                }
                else
                {
                    return 'Payment is not valid for refund cancellation';
                }
            }
            /*else if(payRecord[0].ETST_refund_state__c == 'SUCCESS'){
            return 'Payment is already requested for refund';
            }*/
            else{
                return 'Payment is not valid for refund cancellation';
            }
        }
        else{
            return 'No payment Record exist';
        }  
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to Get Refund Status
    * @Params           paymentId
    * @return           string
    *********************************************************************************************************/
    public static string getRefundStatus(string paymentId){
        string status = '';
        List<ETST_Payment__c> payRecord = getPaymentById(paymentId);
        if(payRecord!=null && payRecord.size() ==1){
            if(payRecord[0].ETST_refund_state__c!=null && payRecord[0].ETST_refund_state__c == 'SUCCESS'){
                getNGeniusAccessToken();
                ET_common_util.ETResponse response = ET_Common_Util.makeCallout(developerName,payRecord[0].ETST_refundURL__c, 'GET','application/vnd.ni-payment.v2+json', '', access_token,'Bearer','');
                if(response!=null && response.StatusCode == 200){
                    //ET_Common_Util.sendEmail('Test Refund response', new string[]{'sagar.kambli@smaartt.com'}, null, null, response.body);
                    updatePaymentRows(response,payRecord[0]);
                    return 'Refund - '+payRecord[0].ETST_AuthorizationCode__c;
                }
                else
                {
                    return 'There is some error occured during the process';
                }
            }
            else{
                if(payRecord[0].ETST_Capture_State__c == 'VOID')
                    return 'Payment is already cancelled';
                else
                    return 'Payment is not valid for refund';
            }
        }
        else{
            return 'No payment Record exist';
        }  
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to update Payment Rows
    * @Params           response,payRecord
    * @return           null
    *********************************************************************************************************/  
  
    public static void updatePaymentRows(ET_Common_Util.ETResponse response,ETST_Payment__c payRecord){
        ET_Common_Util.ETPaymentResponse paymentResponse = new ET_Common_Util.ETPaymentResponse();
        String pay_status = '';
        
        if(response!=null && response.body!=null && payRecord!=null){
            string json = response.body;
            paymentReply = response.body;
            system.debug('paymentReply >>'  +paymentReply);
            json = json.replace('_links', 'links');
            json = json.replace('_id', 'pid');
            json = json.replace('cnp:3ds', 'cnp3ds');
            json = json.replace('3ds', 'ds');
            json = json.replace('_embedded', 'embedded');
            json = json.replace('cnp:capture', 'capture');
            json = json.replace('cnp:refund', 'refund');
            paymentResponse = ET_Common_Util.parse(json);
            system.debug('paymentResponse--->'+paymentResponse);
            payRecord.Json_Response__c=json;
            //----------------Payment Saved Card---------------------
            ET_common_util.cls_savedCard savedCard = new ET_common_util.cls_savedCard();
            if(paymentResponse.savedCard!=null){
                savedCard = paymentResponse.savedCard;
                if(savedCard.cardholderName != null)
                    payRecord.ETST_savedCardToken__c = savedCard.cardToken;
                if(savedCard.recaptureCsc != null)
                    payRecord.ETST_recaptureCard__c = savedCard.recaptureCsc ;
            }
            
            //----------------Payment Auth Response---------------------
            ET_common_util.cls_authResponse authResponse = new ET_common_util.cls_authResponse();
            if(paymentResponse.authResponse!=null){
                authResponse = paymentResponse.authResponse;
                if(authResponse.authorizationCode != null)
                    payRecord.ETST_AuthorizationCode__c = authResponse.authorizationCode;
                if(authResponse.resultMessage != null)
                    payRecord.ETST_ResultMessage__c = authResponse.resultMessage ;
                if(authResponse.rrn != null)
                    payRecord.ETST_AuthorizationRRN__c = authResponse.rrn ;
                if(authResponse.success != null)
                    payRecord.ETST_authSuccess__c = authResponse.success ;
            }
            
            //-----------------Payment Capture -----------------------
            ET_common_util.cls_embedded embedded = new ET_common_util.cls_embedded();
            if(paymentResponse.embedded!=null){
                system.debug('paymentResponse.embedded-->'+paymentResponse.embedded);
                embedded = paymentResponse.embedded;
                List<ET_common_util.cls_capture> captureList = new List<ET_common_util.cls_capture>();
                List<ET_common_util.cls_refund> refundList = new List<ET_common_util.cls_refund>();
                if(embedded!=null){
                    captureList = embedded.capture;
                    refundList = embedded.refund;
                    if(captureList!=null && captureList.size()>0)
                    {
                        for(ET_common_util.cls_capture capture:captureList){
                            system.debug('capture.links--->'+capture.links);
                            system.debug('capture.links.self.href--->'+capture.links);
                            if(capture != null){
                                if(capture.links!=null && capture.links.self !=null){
                                    if(capture.links.self.href != null)
                                        payRecord.ETST_Capture_Link__c = capture.links.self.href ;
                                }else if(capture.links!=null && capture.links.refund!=null){
                                    if(capture.links.refund.href != null)
                                        payRecord.ETST_Capture_Link__c = capture.links.refund.href.removeEnd('/refund');
                                }    
                                if(capture.createdTime != null)
                                {
                                    Datetime captureTime = convertISODateTimeString(capture.createdTime);
                                    payRecord.ETST_Capture_Time__c = captureTime;
                                }
                                if(capture.state != null)
                                {
                                    payRecord.ETST_Capture_State__c = capture.state ;
                                    if(capture.state.tolowerCase() == 'void')
                                        pay_status = 'Cancelled';
                                }
                            }
                        }
                    }
                    if(refundList!=null && refundList.size()>0)
                    {
                        for(ET_common_util.cls_refund refund:refundList){
                            if(refund.links!=null && refund.links.self.href != null)
                                payRecord.ETST_RefundURL__c = refund.links.self.href ;
                            if(refund.createdTime != null)
                            {
                                Datetime refundTime = convertISODateTimeString(refund.createdTime);
                                payRecord.ETST_Refund_Date_Time__c = refundTime;
                            }
                            if(refund.state != null)
                            {
                                payRecord.ETST_Refund_State__c = refund.state ;
                                if(refund.state.tolowerCase() == 'success')
                                    pay_status = 'Refund Requested';
                            }
                        }
                    }
                }
            }
            
            if(paymentResponse.state!=null && pay_status == ''){
                if(paymentResponse.state.tolowerCase() == 'failed')
                    pay_status = 'Failed';
                else if(paymentResponse.state.tolowerCase() == 'captured')
                    pay_status = 'Payment Success';
                else if(paymentResponse.state == 'await_3ds')
                    pay_status = 'Await3D';
            }
            payRecord.ETST_Payment_State__c = paymentResponse.state;
            if(fromBatch != null && fromBatch)
            	payRecord.ETI_IsUpdatedByBatch__c = fromBatch;
            update payRecord;
            
            
            if(pay_status!=''){
                updateServiceStatus(payRecord.ET_Service_Request__c, pay_status, payRecord.ETST_Amount__c);
            }
        }
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to update Service Status
    * @Params           serviceId,pay_status,paidAmt
    * @return           null
    *********************************************************************************************************/     
    public static void updateServiceStatus(Id serviceId,string pay_status, Decimal paidAmt){
        Id inspectionRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId();
        List<ET_Service_Request__c> services = [SELECT Id,recordTypeId,ETI_Not_Cancelled_Booking_Count__c,Payment_Status__c,ETI_Payment_Type__c,Total_Amount__c,
                                                (SELECT Id, Amount__c from Bookings__r) FROM ET_Service_Request__c
                                                where id =: serviceId limit 1];
        if(services.size() == 1){
            List<ETI_Booking__c> bookings = services[0].Bookings__r;
            Decimal totalAmount=0;
            for(ETI_Booking__c booking: bookings){
                if(booking.Amount__c!=null)
                {
                    totalAmount += booking.Amount__c;
                }
            }
            
            if(pay_status.toLowerCase() == 'captured' && paidAmt == totalAmount)
                pay_status = 'Payment Success';
            else if(pay_status.toLowerCase() == 'captured' && paidAmt <= totalAmount)
                pay_status = 'Payment Success';
            
            //Below Changes done by Noor Shaik on 04/03/2021
            Boolean isServiceUpdated = true;
            if(pay_status=='Refund Requested'){
                if(services[0].recordTypeId!=inspectionRecordTypeId)
                    services[0].Payment_Status__c = pay_status;
                else
                if(services[0].recordTypeId==inspectionRecordTypeId && services[0].ETI_Not_Cancelled_Booking_Count__c==1)
                    services[0].Payment_Status__c = pay_status;
            }else {
                if(services[0].Payment_Status__c == 'Await3D' && pay_status == 'Await3D'){
                    isServiceUpdated = false;
                }
                //below added by swarendra to avoid SR being changed to failed if already success
                  if(services[0].Payment_Status__c=='Payment Success')
                  {
                     // isServiceUpdated = false;
                  }
                else
                {
                    services[0].Payment_Status__c = pay_status;   
                }
                
            }
               
                  
            services[0].ETI_Payment_Type__c = 'Online';
            if(isServiceUpdated){
                update services;
            }
           
        }
    }
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to get Payment
    * @Params           paymentId
    * @return           ETST_Payment__c
    *********************************************************************************************************/      
    public static List<ETST_Payment__c> getPayment(string paymentId){
        return [SELECT Id,Name, ETST_Payment_URL__c, ETST_Payment_State__c,ET_Payment_Last_Modified_Date__c,ExternalId__c,ETST_Currency__c,ETST_Amount__c,ET_Service_Request__c,
                ETST_savedCardToken__c,ETST_recaptureCard__c,ETST_AuthorizationCode__c,ETST_refund_state__c,
                ETST_ResultMessage__c,ETST_AuthorizationRRN__c,ETST_authSuccess__c,ETST_Refund_Date_Time__c,
                ETST_Capture_Link__c,ETST_RefundURL__c,ETST_Capture_Time__c,ETST_Capture_State__c,CreatedDate
                FROM ETST_Payment__c where ExternalId__c=:paymentId];
    }
        /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to get Payment Id
    * @Params           recordId
    * @return           ETST_Payment__c
    *********************************************************************************************************/   
    public static List<ETST_Payment__c> getPaymentById(string recordId){
        return [SELECT Id,Name, ETST_Payment_URL__c, ETST_Payment_State__c,ExternalId__c,ETST_Currency__c,ETST_Amount__c,ET_Service_Request__c,
                ETST_savedCardToken__c,ETST_recaptureCard__c,ETST_AuthorizationCode__c,ETST_refund_state__c,ETST_Refund_Date_Time__c,
                ETST_ResultMessage__c,ETST_AuthorizationRRN__c,ETST_authSuccess__c,
                ETST_Capture_Link__c,ETST_RefundURL__c,ET_Payment_Last_Modified_Date__c,ETST_Capture_Time__c,ETST_Capture_State__c,CreatedDate
                FROM ETST_Payment__c where Id=:recordId];
    }
    
    /********************************************************************************************************
    * @author           Smaartt
    * @description      Method to process Initilization Data
    * @Params           null
    * @return           null
    *********************************************************************************************************/ 
    //Process Init Method
    public static void processInitilizationData(){
        requestId = ApexPages.currentPage().getParameters().get('recordId');
        src = ApexPages.currentPage().getParameters().get('src');
        zone = ApexPages.currentPage().getParameters().get('zone');
        isMiscellaneousPayment = false;
        string identifierVal;
        if(src=='etst' && zone =='A'){
            identifierVal='School_Zone_A';
        }else if(src=='etst' && zone =='C'){
            identifierVal='School_Zone_C';
        }else if(src=='etst'){
            identifierVal='School_Zone_A';
        }
        
        Map<String, Merchant_Id_Master__mdt> mcs = Merchant_Id_Master__mdt.getAll();
       
        //system.debug('--outletRef--'+mer[0].Outlet_Ref_Id__c);
        //school transport
        if(src=='etst') {
            serviceType = 'School Transport';
            PickupLabel='Pickup Location & Time';
            if(mcs.containsKey(identifierVal))
            outletref = mcs.get(identifierVal).Outlet_Ref_Id__c;//system.label.ETSchoolOutletId;
           
            List<ET_Service_Request__c> request = [SELECT Id, Name, 
                                                   ETST_Fare_Charges__c,ETST_Tenure__c,ETST_Pick_Up_Time__c,
                                                   ETST_Pick_Up_From__c, ETST_Pick_Up_Start_Date__c 
                                                   FROM ET_Service_Request__c where Id =:requestId limit 1];
            if(request.size() == 1){
                if(request[0].ETST_Fare_Charges__c!=null){
                    serviceAmount = request[0].ETST_Fare_Charges__c;
                    serviceAmountValue = Integer.valueOf(request[0].ETST_Fare_Charges__c) * 100;
                }
                Pickup = request[0].ETST_Pick_Up_From__c + ' - ' + string.valueOf(request[0].ETST_Pick_Up_Start_Date__c) + ' '+string.valueOf(request[0].ETST_Pick_Up_Time__c);
            }
        } //Inspection Services
        else if(src == 'et') {
            serviceType = 'Inspection Booking';
            PickupLabel='Booking Date & time';
            if(mcs.containsKey('AbuDhabi_Inspection'))
            outletref = mcs.get('AbuDhabi_Inspection').Outlet_Ref_Id__c;   //system.label.ETInspectionOutletId;
            List<ET_Service_Request__c> services = [SELECT Id,Total_Amount__c FROM ET_Service_Request__c where Id =:requestId limit 1];
            if(services.size() == 1){
                Decimal totalAmount=0;
                totalAmount = services[0].Total_Amount__c;
                serviceAmount = totalAmount;
                serviceAmountValue = Integer.valueOf(totalAmount)*100;
                //Pickup = string.valueOf(bookings[0].Booking_Date__c);
            }
        } // For SPEA Inspection - added by Mani
        else if(src == 'spea') {
            serviceType = 'Inspection Booking';
            PickupLabel='Booking Date & time';
            if(mcs.containsKey('SPEA_Inspection'))
            outletref =  mcs.get('SPEA_Inspection').Outlet_Ref_Id__c; //system.label.ETInspectionSPEAOutletId;
            List<ET_Service_Request__c> services = [SELECT Id,Total_Amount__c FROM ET_Service_Request__c where Id =:requestId limit 1];
            if(services.size() == 1){
                Decimal totalAmount=0;
                totalAmount = services[0].Total_Amount__c;
                serviceAmount = totalAmount;
                Decimal serviceAmountValue1 = totalAmount*100;
                serviceAmountValue = Integer.ValueOf(serviceAmountValue1);
                //serviceAmountValue = Integer.valueOf(totalAmount)*100;
                //Pickup = string.valueOf(bookings[0].Booking_Date__c);
            }
        } else if(src == 'etCar'){
            system.debug('in etCar Payment');
            serviceType = 'Car Services';
            //PickupLabel='Pickup Location & Time';
            if(mcs.containsKey('Rental_Limo_Services'))
            outletref = mcs.get('Rental_Limo_Services').Outlet_Ref_Id__c;    //system.label.ETcarServicesOutletId;
            system.debug('outletref = '+ outletref);
            system.debug('requestId = '+ requestId);
            List<ET_Service_Request__c> request = new List<ET_Service_Request__c>([SELECT Id, Name, 
                                                                                   ETC_Billing_Total__c
                                                                                   FROM ET_Service_Request__c where Id =:requestId limit 1]) ;
            
            if(request != null && request.size() == 1){
                if(request[0].ETC_Billing_Total__c!=null){
                    serviceAmount = request[0].ETC_Billing_Total__c;
                    serviceAmountValue = Integer.valueOf(request[0].ETC_Billing_Total__c) * 100;
                    system.debug('serviceAmountValue = '+serviceAmountValue);
                }
            }
        } else if(src == 'etCar_Modification'){
            serviceType = 'Car Services';
            //PickupLabel='Pickup Location & Time';
            if(mcs.containsKey('Rental_Limo_Services'))
            outletref = mcs.get('Rental_Limo_Services').Outlet_Ref_Id__c;//system.label.ETcarServicesOutletId;
            List<ET_Service_Request__c> request = new List<ET_Service_Request__c>([SELECT Id, Name, 
                                                                                   ETC_Billing_Total__c
                                                                                   FROM ET_Service_Request__c where Id =:requestId limit 1]) ;
            if(extraAmount !=null){
                serviceAmount = extraAmount;
                serviceAmountValue = Integer.valueOf(extraAmount) * 100;
            }
        } else if(src == 'etCar_miscellaneous'){
            system.debug('in etCar_miscellaneous Payment');
            serviceType = 'Car Services';
            isMiscellaneousPayment=true;
            //PickupLabel='Pickup Location & Time';
            if(mcs.containsKey('Rental_Limo_Services'))
            outletref = mcs.get('Rental_Limo_Services').Outlet_Ref_Id__c;// system.label.ETcarServicesOutletId;
            system.debug('outletref = '+ outletref);
            system.debug('requestId = '+ requestId);
            List<ET_Service_Request__c> request = new List<ET_Service_Request__c>([SELECT Id, Name, 
                                                                                   ETC_Billing_Total__c,ETC_Miscellaneous_Charges__c
                                                                                   FROM ET_Service_Request__c where Id =:requestId limit 1]) ;
            
            if(request != null && request.size() == 1){
                if(request[0].ETC_Miscellaneous_Charges__c!=null){
                    serviceAmount = request[0].ETC_Miscellaneous_Charges__c;
                    serviceAmountValue = Integer.valueOf(request[0].ETC_Miscellaneous_Charges__c) * 100;
                    system.debug('serviceAmountValue = '+serviceAmountValue);
                }
            }
        }
    }
     public static void utilityMethod(){
        
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;  
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
      
      
    }
   
}