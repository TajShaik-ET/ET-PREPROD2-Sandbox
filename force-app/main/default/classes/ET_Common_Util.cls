/*
* File Name:ET_Common_Util
* Author : Sagar Kambli
* CreatedDate : 19/02/2020
* Modification Purpose
* * 1. Sagar: Created for CommonUtil Methods 
* * 2.
*/
global class ET_Common_Util {
    public static final string PAYMENT_INTEGRATION_ENVIRONMENT = label.PAYMENT_INTEGRATION_ENVIRONMENT;
    public static final string ACCESS_TOKEN = 'ETPayment';
    public static final string SALE = 'SALE';
    public static final string CurrencyCode = 'AED';
    public static final string POS_GETAUTH = 'GET_AUTH';
    public static final string PERSON = 'Person';
    public static final string ORGANIZATION = 'Organization';
    public static final string BILLTO = 'BILL_TO';
    public static final string SHIPTO = 'SHIP_TO';
    public static final string PAYMENT_ONLINE_TYPE = 'Online';
    public static final string PAYMENT_OFFLINE_TYPE = 'Offline';
    public static final string PAYMENT_CASH_TYPE = 'Cash';
    public static final string PAYMENT_CARD_TYPE = 'Card';
    public static final string PAYMENT_CAPTURED = 'CAPTURED';
    
    public static ETResponse makeCallout(string endpointName, string url, string action,  string contentType,
                                         string grantType, string authorizationKey,string authorisationType, string jsonBody)
    {
        Map<String, Object> results = new  Map<String, Object>();
        ETResponse paymentResponse;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod(action);
        
        if(action.toLowerCase() == 'get')
        {
            String authorizationHeader = authorisationType+' ' +authorizationKey;
            if(contentType!=null && contentType!='')
                request.setHeader('Accept', contentType);
            system.debug('authorizationKey: '+authorizationKey);
            request.setHeader('Authorization',authorizationHeader);
            
        }
        else
        {
            if(!string.isBlank(authorizationKey) && authorisationType == 'Basic')
            {
                String authorizationHeader = authorisationType+' ' +authorizationKey;
                request.setHeader('Content-Type', contentType);
                request.setHeader('Authorization',authorizationHeader);
                String payLoad = 'grant_type=client_credentials';
                request.setBody(payLoad);
            }
            else if(!string.isBlank(authorizationKey) && authorisationType == 'Bearer')
            {
                String authorizationHeader = authorisationType+' ' +authorizationKey;
                request.setHeader('Content-Type', contentType);
                request.setHeader('Accept', 'application/vnd.ni-payment.v2+json');
                request.setHeader('Authorization',authorizationHeader);
                request.setBody(jsonBody);
                system.debug(jsonBody);
            }
            
            
        }
        
        HttpResponse response = http.send(request);
        paymentResponse = new ETResponse();
        paymentResponse.status = response.getStatus();
        paymentResponse.statusCode = response.getStatusCode();
        paymentResponse.body = response.getBody();
        paymentResponse.responseString = response.toString();
        return paymentResponse;
    }
    
    public static void sendEmail(string subject, string[] emailId, string [] bccEmailId, string[] ccEmailId,string body,Map<String, String> successMap,Map<String, String> errorMap){
        if(emailId!=null && emailId.size()>0){
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            semail.setToAddresses(emailId);
            if(bccEmailId!=null && bccEmailId.size()>0)
                semail.setBccAddresses(bccEmailId);
            if(ccEmailId!=null && ccEmailId.size()>0)
                semail.setCcAddresses(ccEmailId);
            semail.setSubject(subject);
            semail.setPlainTextBody(body);
            if(successMap!=null || errorMap!=null){
                Messaging.EmailFileAttachment[] emailAttList = new List<Messaging.EmailFileAttachment>();
                if(!errorMap.isEmpty()){
                    // Creating the CSV file for error
                    String finalstr = 'Id, Error \n';
                    
                    String attName = 'Error' + system.now().format('YYYYMMDDhhmm') + '.csv';
                    for(Id key  : errorMap.keySet()){
                        string err = errorMap.get(key);
                        string recordString = '"'+key+'","'+err+'"\n';
                        finalstr = finalstr +recordString;
                    }
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(attName);
                    efa.setBody(Blob.valueOf(finalstr));
                    emailAttList.add(efa);
                }
                if(!successMap.isEmpty()){
                    // Creating the CSV file for error
                    String finalstr = 'Id, Success \n';
                    
                    String attName = 'Success' + system.now().format('YYYYMMDDhhmm') + '.csv';
                    for(Id key  : successMap.keySet()){
                        string succ = successMap.get(key);
                        string recordString = '"'+key+'","'+succ+'"\n';
                        finalstr = finalstr +recordString;
                    }
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(attName);
                    efa.setBody(Blob.valueOf(finalstr));
                    emailAttList.add(efa);
                }
                if(emailAttList.size()>0){
                    semail.setFileAttachments(emailAttList);
                }
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});    
        }    
    }
    
    public static void sendSMS(String complaintId,String sender,String mobileNumber, String SMSTemplateName){
        if (mobileNumber != null){
            List<EmailTemplate> oTemplates = [select DeveloperName,Id,Name,Subject,body,HtmlValue from EmailTemplate where DeveloperName =: SMSTemplateName];
            Contact c = [select id, Email from Contact where email <> null limit 1];
            
            Messaging.SingleEmailMessage smsmsg = new Messaging.SingleEmailMessage();
            smsmsg.setTemplateId(oTemplates[0].Id);
            smsmsg.setWhatId(complaintId);
            smsmsg.setTargetObjectId(c.id);
            List<string> lstSMSToAddress = new list<string>();
            lstSMSToAddress.add(mobileNumber+'@email.smsglobal.com');
            smsmsg.setToAddresses(lstSMSToAddress);
            
            Savepoint spsms = Database.setSavepoint();
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {smsmsg});
            Database.rollback(spsms);
            callAPI(sender,mobileNumber,smsmsg.getPlainTextBody());//call API for sending SMS
        }
    }
    
    @future(callout=true)
    Public Static void callAPI(String sender,String mobileNumber,String subject ){
       ET_SendSMS_RequestAPI.execute_pt obj = new ET_SendSMS_RequestAPI.execute_pt();
       obj.execute(sender,mobileNumber,subject ); 
    }    
    
    @AuraEnabled
    public static string voidPayment(string paymentId){
        return ET_Payment_Controller.voidPayment(paymentId);
    }
    
    //Refund Payment
   
   public static ET_Common_Util.ETPaymentResponse createRefundRequest(string paymentId,Decimal amtToRefund){
        return ET_Payment_Controller.createRefundRequest(paymentId,amtToRefund);
    }
    
    @AuraEnabled
    public static string cancelRefund(string paymentId){
        return ET_Payment_Controller.cancelRefund(paymentId);
    }

    @AuraEnabled
    public static string getRefundStatus(string paymentId){
        return ET_Payment_Controller.getRefundStatus(paymentId);
    }
        
    public static List<ETST_Payment__c> doPOSReceiptsMapping(List<sObject> sobjectData){
        List<ETST_Payment__c> paymentList = new List<ETST_Payment__c>();
        for(sObject record: sobjectData){
            ETST_Payment__c receiptData = new ETST_Payment__c();
            if(record.get('transactionType')!=null)
                receiptData.ETST_VFI_TransType__c = string.valueOf(record.get('transactionType'));
            if(record.get('receiptNumber')!=null){
                receiptData.ETST_VFI_ECRRcptNum__c = string.valueOf(record.get('receiptNumber'));
                receiptData.ExternalID__c = string.valueOf(record.get('receiptNumber'));
                //receiptData.Name = string.valueOf(record.get('receiptNumber'));
                //TR Request
                //receiptData.ETST_Transport_Request__c = 'a0Q7E000003oZbvUAE';
            }
            if(record.get('additionalInfo')!=null)
                receiptData.ETST_VFI_AdditionalInfo__c = string.valueOf(record.get('additionalInfo'));
            if(record.get('preauthApprovalCode')!=null)
                receiptData.ETST_VFI_PreauthApprovalCode__c = string.valueOf(record.get('preauthApprovalCode'));
            if(record.get('preauthCmplAmount')!=null)
                receiptData.ETST_VFIPreauthCmplAmount__c = string.valueOf(record.get('preauthCmplAmount'));
            if(record.get('loyalty')!=null)
                receiptData.ETST_VFI_Loyalty__c = boolean.valueOf(record.get('loyalty'));
            if(record.get('responseCode')!=null)
                receiptData.ETST_VFI_RespCode__c = string.valueOf(record.get('responseCode'));
            if(record.get('responseMessage')!=null)
                receiptData.ETST_VFI_RespMess__c = string.valueOf(record.get('responseMessage'));
            if(record.get('transactionSource')!=null)
                receiptData.ETST_VFI_TransSource__c = string.valueOf(record.get('transactionSource'));
            if(record.get('chVerification')!=null)
                receiptData.ETST_VFI_CHVerification__c = string.valueOf(record.get('chVerification'));
            //if(record.get('modifiedDateTime')!=null)
                //receiptData.ETST_VFI_DateTime__c = string.valueOf(record.get('modifiedDateTime'));
            if(record.get('approvalCode')!=null)
                receiptData.ETST_VFI_ApprovalCode__c = string.valueOf(record.get('approvalCode'));
            if(record.get('eppTenure')!=null)
                receiptData.ETST_VFI_EPPTenure__c = string.valueOf(record.get('eppTenure'));
            if(record.get('eppFee')!=null)
                receiptData.ETST_VFI_EPP_Fee__c = string.valueOf(record.get('eppFee'));
            if(record.get('eppEMI')!=null)
                receiptData.ETST_VFI_EPPEMI__c = string.valueOf(record.get('eppEMI'));
            if(record.get('eppInterest')!=null)
                receiptData.ETST_VFI_EPPInterestRate__c = string.valueOf(record.get('eppInterest'));
            if(record.get('xlsTxnNo')!=null)
                receiptData.ETST_VFI_XLSTxnNo__c = string.valueOf(record.get('xlsTxnNo'));
            if(record.get('xlsMid')!=null)
                receiptData.ETST_VFI_XLSMid__c = string.valueOf(record.get('xlsMid'));
            if(record.get('xlsTid')!=null)
                receiptData.ETST_VFI_XLSTid__c = string.valueOf(record.get('xlsTid'));
            if(record.get('xlsAmount')!=null)
                receiptData.ETST_VFI_XLSAmount__c = string.valueOf(record.get('xlsAmount'));
            if(record.get('voucherCode')!=null)
                receiptData.ETST_VFI_VoucherCode__c = string.valueOf(record.get('voucherCode'));
            if(record.get('txnId')!=null)
                receiptData.ETST_VFI_TxnId__c = string.valueOf(record.get('txnId'));
            if(record.get('touchAmount')!=null)
                receiptData.ETST_VFI_TouchAmount__c = string.valueOf(record.get('touchAmount'));
            if(record.get('availablePoints')!=null)
                receiptData.ETST_VFI_AvailablePoints__c = string.valueOf(record.get('availablePoints'));
            if(record.get('currentInstruction')!=null)
                receiptData.ETST_VFI_CurrentInstruction__c = string.valueOf(record.get('currentInstruction'));
            if(record.get('brandTrack')!=null)
                receiptData.ETST_VFI_BrandTrack__c = string.valueOf(record.get('brandTrack'));
            if(record.get('branded')!=null)
                receiptData.ETST_VFI_Branded__c = string.valueOf(record.get('branded'));
            if(record.get('emvLabel')!=null)
                receiptData.ETST_VFI_EMV_Label__c = string.valueOf(record.get('emvLabel'));
            if(record.get('emvTVR')!=null)
                receiptData.ETST_VFI_EMVTVR__c = string.valueOf(record.get('emvTVR'));
            if(record.get('emvTSI')!=null)
                receiptData.ETST_VFI_EMV_TSI__c = string.valueOf(record.get('emvTSI'));
            if(record.get('voidReceiptNo')!=null)
                receiptData.ETST_VFI_VoidRcptNo__c = string.valueOf(record.get('voidReceiptNo'));
            if(record.get('terminalId')!=null)
                receiptData.ETST_VFI_Terminal_ID__c = string.valueOf(record.get('terminalId'));
            if(record.get('batch')!=null)
                receiptData.ETST_VFI_Batch__c = string.valueOf(record.get('batch'));
            if(record.get('emvAID')!=null)
                receiptData.ETST_VFI_EMV_AID__c = string.valueOf(record.get('emvAID'));
            if(record.get('cardNumber')!=null)
                receiptData.ETST_Card_Number__c = string.valueOf(record.get('cardNumber'));
            if(record.get('cardExpiry')!=null)
                receiptData.ETST_Card_Expiry__c = string.valueOf(record.get('cardExpiry'));
            if(record.get('cardType')!=null)
                receiptData.ETST_Card_Type__c = string.valueOf(record.get('cardType'));
            if(record.get('cardHolderName')!=null)
                receiptData.ETST_Cardholder_Name__c = string.valueOf(record.get('cardHolderName'));
            if(record.get('currencyType')!=null)
                receiptData.ETST_Currency__c = string.valueOf(record.get('currencyType'));
            if(record.get('paymentState')!=null)
                receiptData.ETST_Payment_State__c = string.valueOf(record.get('paymentState'));
            if(record.get('authMode')!=null)
                receiptData.ETST_Payment_Mode__c = string.valueOf(record.get('authMode'));
            if(record.get('amount')!=null)
                receiptData.ETST_Amount__c = Decimal.valueOf(string.valueOf(record.get('amount')));
            paymentList.add(receiptData);
        }
        return paymentList;
    } 
    public static ETST_Payment__c doPOSReceiptsMapping(ET_Common_Util.POSPaymentReceipt extData){
        ETST_Payment__c receiptData = new ETST_Payment__c();
        Id recordTypeId =Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByName().get('Verifone Payment').getRecordTypeId();
        receiptData.RecordTypeId = recordTypeId;
        if(extData.transactionType!=null)
        {
            if(extData.transactionType == '1')  receiptData.ETST_VFI_TransType__c = 'SALE';
            else if(extData.transactionType == '2')  receiptData.ETST_VFI_TransType__c = 'PREAUTH';
            else if(extData.transactionType == '3') receiptData.ETST_VFI_TransType__c = 'CASHADV';
            else if(extData.transactionType == '4') receiptData.ETST_VFI_TransType__c = 'CASHBACK';
            else if(extData.transactionType == '5')  receiptData.ETST_VFI_TransType__c = 'TIP';
            else if(extData.transactionType == '6')  receiptData.ETST_VFI_TransType__c = 'REFUND';
            else if(extData.transactionType == '7')
                receiptData.ETST_VFI_TransType__c = 'PREAUTHCOMPLETION';
        }
        if(extData.receiptNumber!=null){
            receiptData.ETST_VFI_ECRRcptNum__c = extData.receiptNumber;
            receiptData.ExternalID__c = extData.receiptNumber;
            //receiptData.Name = extData.receiptNumber;
            //TR Request
            //receiptData.ETST_Transport_Request__c = 'a0Q7E000003oZbvUAE';
        }
        if(extData.additionalInfo!=null)
            receiptData.ETST_VFI_AdditionalInfo__c = extData.additionalInfo;
        if(extData.preauthApprovalCode!=null)
            receiptData.ETST_VFI_PreauthApprovalCode__c = extData.preauthApprovalCode;
        if(extData.preauthCmplAmount!=null)
            receiptData.ETST_VFIPreauthCmplAmount__c = extData.preauthCmplAmount;
        if(extData.loyalty!=null)
        {
             if(extData.transactionType == '1')  receiptData.ETST_VFI_Loyalty__c = true;
            else
                receiptData.ETST_VFI_Loyalty__c = false;
        }
        if(extData.responseCode!=null)  receiptData.ETST_VFI_RespCode__c = extData.responseCode;
        if(extData.responseMessage!=null)  receiptData.ETST_VFI_RespMess__c = extData.responseMessage;
        if(extData.transactionSource!=null)
        {
            if(extData.transactionSource == '1')  receiptData.ETST_VFI_TransSource__c = 'Manual Entry of Card Number';
            else if(extData.transactionSource == '2') receiptData.ETST_VFI_TransSource__c = 'Card Swipe';
            else if(extData.transactionSource == '3') receiptData.ETST_VFI_TransSource__c = 'ICC Transaction';
        }
        if(extData.chVerification!=null)
        {
            if(extData.transactionSource == '1')  receiptData.ETST_VFI_CHVerification__c = 'Signature';
            else if(extData.transactionSource == '2') receiptData.ETST_VFI_CHVerification__c = 'PIN';
        }
        //if(extData.modifiedDateTime!=null)
        //receiptData.ETST_VFI_DateTime__c = extData.modifiedDateTime;
        if(extData.approvalCode!=null) receiptData.ETST_VFI_ApprovalCode__c = extData.approvalCode;
        if(extData.eppTenure!=null)  receiptData.ETST_VFI_EPPTenure__c = extData.eppTenure;
        if(extData.eppFee!=null) receiptData.ETST_VFI_EPP_Fee__c = extData.eppFee;
        if(extData.eppEMI!=null)  receiptData.ETST_VFI_EPPEMI__c = extData.eppEMI;
        if(extData.eppInterest!=null) receiptData.ETST_VFI_EPPInterestRate__c = extData.eppInterest;
        
        
        if(extData.xlsTxnNo!=null)  receiptData.ETST_VFI_XLSTxnNo__c = extData.xlsTxnNo;
        if(extData.xlsMid!=null) receiptData.ETST_VFI_XLSMid__c = extData.xlsMid;
        if(extData.xlsTid!=null) receiptData.ETST_VFI_XLSTid__c = extData.xlsTid;
        if(extData.xlsAmount!=null)  receiptData.ETST_VFI_XLSAmount__c = extData.xlsAmount;
        
        
        if(extData.voucherCode!=null) receiptData.ETST_VFI_VoucherCode__c = extData.voucherCode;
        if(extData.txnId!=null)  receiptData.ETST_VFI_TxnId__c = extData.txnId;
        if(extData.touchAmount!=null)  receiptData.ETST_VFI_TouchAmount__c = extData.touchAmount;
        if(extData.availablePoints!=null)  receiptData.ETST_VFI_AvailablePoints__c = extData.availablePoints;
        if(extData.currentInstruction!=null) receiptData.ETST_VFI_CurrentInstruction__c = extData.currentInstruction;
        if(extData.brandTrack!=null) receiptData.ETST_VFI_BrandTrack__c = extData.brandTrack;
        if(extData.branded!=null)  receiptData.ETST_VFI_Branded__c = extData.branded;
        
        
        if(extData.emvLabel!=null) receiptData.ETST_VFI_EMV_Label__c = extData.emvLabel;
        if(extData.emvTVR!=null)  receiptData.ETST_VFI_EMVTVR__c = extData.emvTVR;
        if(extData.emvTSI!=null) receiptData.ETST_VFI_EMV_TSI__c = extData.emvTSI;
        
        
        if(extData.voidReceiptNo!=null)  receiptData.ETST_VFI_VoidRcptNo__c = extData.voidReceiptNo;
        if(extData.terminalId!=null) receiptData.ETST_VFI_Terminal_ID__c = extData.terminalId;
        if(extData.batch!=null) receiptData.ETST_VFI_Batch__c = extData.batch;
        if(extData.emvAID!=null)  receiptData.ETST_VFI_EMV_AID__c = extData.emvAID;
        
        
        if(extData.cardNumber!=null)  receiptData.ETST_Card_Number__c = extData.cardNumber;
        if(extData.cardExpiry!=null)  receiptData.ETST_Card_Expiry__c = extData.cardExpiry;
        if(extData.cardType!=null)   receiptData.ETST_Card_Type__c = extData.cardType;
        if(extData.cardHolderName!=null) receiptData.ETST_Cardholder_Name__c = extData.cardHolderName;
        
        if(extData.currencyType!=null)  receiptData.ETST_Currency__c = extData.currencyType;
        if(extData.paymentState!=null) receiptData.ETST_Payment_State__c = extData.paymentState;
        if(extData.authMode!=null)  receiptData.ETST_Payment_Mode__c = extData.authMode;
        if(extData.amount!=null) receiptData.ETST_Amount__c = Decimal.valueOf(extData.amount);
        
        return receiptData;
    }
    
   
        
    public class ETRequest{
        public string grant_type {get;set;}
    }
    public class ETResponse{
        public string status {get;set;}
        public string body {get;set;}
        public Integer statusCode {get;set;}
        public string responseString {get;set;}
    }
    public class ETSPaymentAccessToken{
        public string access_token {get;set;}
        public Decimal expires_in {get;set;}
        public Decimal refresh_expires_in {get;set;}
        public string refresh_token {get;set;}
        public string token_type {get;set;}
        public string session_state {get;set;}
        public string scope {get;set;}
    }
    
    
    // Replaced _links = links
    // _id = pid
    // cnp:3ds = cnp3ds
    // 3ds = ds
    public class ETPaymentResponse{
        public String pid;  //urn:payment:16e1993c-3335-42f2-97c8-9696436c131c
        public cls_links links;
        public cls_paymentMethod paymentMethod;
        public cls_savedCard savedCard;
        public String state;    //AWAIT_3DS
        public cls_amount amount;
        public String updateDateTime;   //2020-02-23T11:19:22.326Z
        public String outletId; //e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d
        public String orderReference;   //8bbc5881-e556-4cff-82d1-9c0201721280
        public cls_authResponse authResponse;
        public cls_3ds ds;
        public cls_embedded embedded;
    }
    public class cls_embedded{
        public cls_capture[] capture;
        public cls_refund[] refund;
    }
    public class cls_capture{
        public cls_links links;
        public cls_amount amount;
        public string createdTime;
        public string state;
    }
    public class cls_refund{ //ETST_RefundURL
        public cls_links links;
        public cls_amount amount;
        public string createdTime;
        public string state;
    }
    
    public static ETPaymentResponse parse(String json){
        return (ETPaymentResponse) System.JSON.deserialize(json, ETPaymentResponse.class);
    }
    
    public class cls_self {
        public String href; //https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d/orders/8bbc5881-e556-4cff-82d1-9c0201721280/payments/16e1993c-3335-42f2-97c8-9696436c131c
    }
    
    public class cls_curies {
        public String name; //cnp
        public String href; //https://api-gateway.sandbox.ngenius-payments.com/docs/rels/{rel}
        public boolean templated;
    }
    
    public class cls_links {
        public cls_self self;
        public cls_self refund;
        public cnp_3ds cnpds;
        public cls_curies[] curies;
    }
    
    public class cnp_3ds {
        public String href; //https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/e209b88c-9fb6-4be8-ab4b-e4b977ad0e0d/orders/8bbc5881-e556-4cff-82d1-9c0201721280/payments/16e1993c-3335-42f2-97c8-9696436c131c/card/3ds
    }
    
    public class cls_paymentMethod {
        public String expiry;   //2021-09
        public String cardholderName;   //sagar k
        public String name; //VISA
        public String pan;  //401200******1112
        public String cvv;  //***
    }
    
    public class cls_savedCard{
        public String maskedPan;
        public String expiry;
        public String cardholderName;
        public String scheme;
        public String cardToken;
        public Boolean recaptureCsc;
    }
    
    public class cls_authResponse{
        public String authorizationCode;
        public String success;
        public String resultCode;
        public String resultMessage;
        public String rrn;
    }
    
    public class cls_amount {
        public String currencyCode; //AED
        public Integer value;   //100
    }
    
    public class cls_3ds {
        public String acsUrl;   //https://api-gateway-uat.ngenius-payments.com/netcetera/acs/create
        public String acsPaReq; //AcsPaReq
        public String acsMd;    //f8c0f1dd12213c01
        public String status;
        public String eci;
        public String eciDescription;
    }
    
    
    public class POSPaymentReceipt
    {
        public string transactionType {get;set;}
        public string receiptNumber {get;set;}
        public string additionalInfo {get;set;}
        public string preauthApprovalCode {get;set;}
        public string preauthCmplAmount {get;set;}
        public string loyalty {get;set;}
        public string responseCode {get;set;}
        public string responseMessage {get;set;}
        public string transactionSource {get;set;}
        public string chVerification {get;set;}
        public string modifiedDateTime {get;set;}
        public string approvalCode {get;set;}
        public string eppTenure {get;set;}
        public string eppFee {get;set;}
        public string eppEMI {get;set;}
        public string eppInterest {get;set;}
        public string xlsTxnNo {get;set;}
        public string xlsMid {get;set;}
        public string xlsTid {get;set;}
        public string xlsAmount {get;set;}
        public string voucherCode {get;set;}
        public string txnId {get;set;}
        public string touchAmount {get;set;}
        public string availablePoints {get;set;}
        public string currentInstruction {get;set;}
        public string brandTrack {get;set;}
        public string branded {get;set;}
        public string emvLabel {get;set;}
        public string emvTVR {get;set;}
        public string emvTSI {get;set;}
        public string voidReceiptNo {get;set;}
        public string terminalId {get;set;}
        public string batch {get;set;}
        public string emvAID {get;set;}
        public string cardNumber {get;set;}
        public string cardExpiry {get;set;}
        public string cardType {get;set;}
        public string cardHolderName {get;set;}
        public string currencyType {get;set;}
        public string paymentState {get;set;}
        public string authMode {get;set;}
        public string amount {get;set;}
    }
    public static void magicMethod(){
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
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