/**
*Author: Srihari Koyila
*Calling Class: ET_REST_Authorize_Helper
*Calling Class: GetReceiptResponseWrapper
*Test Class: ETST_CreateRefundTest
*/


public class ETST_CreateRefund {
    
    @AuraEnabled
    /*Get all receipts for invoice*/
    public static List<WrapperPayment>  getReceipts(string recordid){
        //system.debug('recordid'+recordid);
        List<String> parcelist = new List<String>();
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('GetReceipt');
        Blob beforeblob = Blob.valueOf(connection.Username__c+':'+connection.Password__c);
        
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        
        Http httpProtocol = new Http();
        String result = Null;
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization','Basic '+paramvalue); 
        request.setMethod('GET');
        
        ET_Refund__c recep = [select id,ET_Refund_Amount__c,Oracle_Invoice_No__c,OracleAPInvoiceId__c,Oracle_Receipt_No__c,Bank_Name__c,IBAN__c,Payee_Name__c,ET_Service_Request__c  from ET_Refund__c where id=: recordId];
        
        ET_Receipt__c RClist=[select id,School_Oracle_Invoice_No__c from ET_Receipt__c where ET_Service_Request__c=: recep.ET_Service_Request__c limit 1];
        system.debug('RClist '+RClist);
        String oracleInvNo =RClist.School_Oracle_Invoice_No__c;
        if (String.isBlank(oracleInvNo)) {
            String ErrororacleInvNo ='Integration Message : Invoice No is null';
            throw new CustomException(ErrororacleInvNo);
        }
        if(ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c+oracleInvNo);
            system.debug(connection.Dev_Endpoint__c+oracleInvNo);
        }else{
            request.setEndpoint(connection.LiveEndpoint_c__c+oracleInvNo);
        }  
        system.debug('request Get'+request);
        request.setTimeout(90000);
        request.setHeader('Content-Type', 'application/json');
        response = httpProtocol.send(request);
        system.debug(response.getBody());
        System.debug('response-' + JSON.serializePretty(response.getBody()));
        List<WrapperPayment> lstWrap= new List<WrapperPayment>();
        GetReceiptResponseWrapper invlst = GetReceiptResponseWrapper.parse(response.getBody());
        GetReceiptResponseWrapper.ReceiptList invoiceRecipient = new GetReceiptResponseWrapper.ReceiptList();
        invoiceRecipient = invlst.ReceiptList;
        
        for(GetReceiptResponseWrapper.GetReceiptByInvoiceOutput pp : invoiceRecipient.GetReceiptByInvoiceOutput){
            System.debug('recep.ET_Refund_Amount__c'+recep.ET_Refund_Amount__c+'pp.AMOUNT_APPLIED '+pp.AMOUNT_APPLIED);
           
            if(recep.ET_Refund_Amount__c < pp.AMOUNT_APPLIED){
                system.debug('AMOUNT_APPLIED '+pp.AMOUNT_APPLIED);
                WrapperPayment  w  = new WrapperPayment();
                w.amount= pp.AMOUNT_APPLIED;
                w.receiptnumber =pp.RECEIPT_NUMBER;
                w.CUSTOMERNAME =pp.CUSTOMER_NAME;
                w.oracleInvId  = pp.CUSTOMER_TRX_ID;
                w.oracleInvNumber  =pp.TRX_NUMBER;
                w.oracleReceiptId = pp.CASH_RECEIPT_ID;
                w.radio = false;
                lstWrap.add(w);
               
                break;
            }else if(recep.ET_Refund_Amount__c > pp.AMOUNT_APPLIED){
                Decimal RefundAmount = recep.ET_Refund_Amount__c;
                Decimal AMOUNTAPPLIED = pp.AMOUNT_APPLIED;
                throw new CustomException('Refund Amount is: ' + RefundAmount + ' as Refund Amount is Greater than Amount Applied: as ' + AMOUNTAPPLIED);
            }
        } 
        system.debug('lstWrap '+lstWrap);
        return lstWrap;
    }
    
	public class CustomException extends Exception {}    
    @AuraEnabled
    /*Posting the selected invoice to oracle*/
    public static string postInvoiceReceipt (list<ETST_CreateRefund.WrapperPayment> LstReceipt, string recordId){
       try{
            ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('CancelReceipt');
            
            ETST_CreateRefund.WrapperPayment selectedRow = new ETST_CreateRefund.WrapperPayment();
           system.debug('lstReceipt '+lstReceipt);
            for(ETST_CreateRefund.WrapperPayment loopvar :lstReceipt){
                selectedRow = loopvar;
            }
            
            ET_Refund__c recep = [select id,ET_Refund_Amount__c,Oracle_Invoice_No__c,OracleAPInvoiceId__c,Oracle_Receipt_No__c,Bank_Name__c,IBAN__c,Payee_Name__c,ET_Service_Request__c  from ET_Refund__c where id=: recordId];
            
            list<ET_Receipt__c> RClist=[select id,School_Oracle_Invoice_No__c from ET_Receipt__c where ET_Service_Request__c=: recep.ET_Service_Request__c limit 1];
            
            decimal refund=recep.ET_Refund_Amount__c;
            String varrefund = String.valueOf(refund);
            string varpayeename=recep.Payee_Name__c;
            string varBankName=recep.Bank_Name__c;
            string varIBAN=recep.IBAN__c;
            System.debug('selectedRow '+selectedRow);
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('OracleInvoiceId', String.valueOf(selectedRow.oracleInvId));
            gen.writeStringField('OracleInvoiceNumber',String.valueOf(selectedRow.oracleInvNumber));
            gen.writeStringField('OracleReceiptId',String.valueOf(selectedRow.oracleReceiptId));
            gen.writeStringField('RefundAmount',varrefund);
            gen.writeStringField('PayeeName',varpayeename);
            gen.writeStringField('IBAN',varIBAN);
            gen.writeStringField('BankName', varBankName);
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            System.debug('jsonData '+jsonData);
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            
            if(ET_REST_Authorize_Helper.runningInASandbox()){
                request.setEndpoint(connection.Dev_Endpoint__c);
                system.debug(connection.Dev_Endpoint__c);
            }else{
                request.setEndpoint(connection.LiveEndpoint_c__c);
            }  
            
            request.setHeader('Content-Type', 'application/json');
            request.setTimeout(90000);
            request.setMethod('POST');
            request.setbody(jsonData);
            response = httpProtocol.send(request);
            system.debug('request Post'+request);
            System.debug('response.getBody() '+response.getBody());
            map<string,string> responseData  = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
            System.debug('responseData '+responseData);
            if(responseData.get('Status') == 'S'){
                
                ET_Refund__c rct =new ET_Refund__c();
                rct.Id = recep.Id;
                rct.Payee_Name__c = recep.Payee_Name__c;
                rct.IBAN__c =  recep.IBAN__c;
                rct.Bank_Name__c=recep.Bank_Name__c;
                //rct.ET_Refund_Status__c= 'AP Invoice Created';  
                rct.Oracle_Receipt_No__c=selectedRow.receiptnumber;
                rct.OracleAPInvoiceId__c =responseData.get('OracleAPInvoiceId');
                rct.Oracle_Invoice_No__c= responseData.get('OracleAPInvoiceNumber'); 
				rct.ET_Integration_Message__c =responseData.get('Message');
                rct.Integration_Status__c ='Success';
   
                update rct;
            }else{
                ET_Refund__c rct =new ET_Refund__c();
                rct.Id = recep.Id;
                rct.ET_Integration_Message__c =responseData.get('Message');
                rct.Integration_Status__c ='Error';
                rct.ET_Refund_Status__c= 'Failed';  
                
                update rct;
                // rct.addError(responseData.get('Message'));
                system.debug('error:'+response.getStatusCode());
                throw new CustomException(responseData.get('Message'));
                
                
            }
            return response.getBody();
            
        }catch(Exception e){
            system.debug(e.getMessage());
            //throw all other exception message
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    Public class WrapperPayment{
        @AuraEnabled
        Public String receiptnumber{get;set;}
        @AuraEnabled
        Public String CUSTOMERNAME{get;set;}
        @AuraEnabled
        Public decimal amount{get;set;}
        @AuraEnabled
        public boolean radio {get; set;}
        @AuraEnabled
        public integer oracleInvId {get; set;}
        @AuraEnabled
        public String oracleInvNumber {get; set;}
        @AuraEnabled
        public integer oracleReceiptId {get; set;}
    } 

    @AuraEnabled
    public static String processReceiptsAndPost(String recordId) {
        List<WrapperPayment> receipts = getReceipts(recordId);
        return postInvoiceReceipt(receipts, recordId);
    }
}