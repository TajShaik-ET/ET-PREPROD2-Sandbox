@isTest
public class ETST_CreateRefundTest{
    @isTest
    public static void ETST_RefundTest(){
        
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        GetReceiptResponseWrapper.GetReceiptByInvoiceOutput fsonj =new   GetReceiptResponseWrapper.GetReceiptByInvoiceOutput();
        
        ET_Finance_Document__c ETF = New ET_Finance_Document__c();
        ETF.Document_External_Id__c='20170813004';
        insert ETF;
        //system.debug(ETF.id);
      
        ET_Service_Request__c ETSR = New ET_Service_Request__c();
        ETSR.ETST_Service_Type__c='Yearly';
        ETSR.ETST_Payee__c='Parent';
        insert ETSR;
        //system.debug(ETSR.id);
       
        ET_Refund__c ETRF = New ET_Refund__c();
        ETRF.ET_Service_Request__c=ETSR.id;
        ETRF.Payee_Name__c='payeeYea';
        ETRF.IBAN__c='Parentiban';
        ETRF.Bank_Name__c='Parentbank';
        ETRF.ET_Refund_Amount__c=100;
        insert ETRF;
        //system.debug(ETRF.id);
        
        ET_Receipt__c ETRCT = New ET_Receipt__c();
        ETRCT.ET_Service_Request__c=ETSR.id;
        ETRCT.ET_Amount__c=100;
        ETRCT.ET_Finance_Document__c=ETF.id;
        
        insert ETRCT;
        //system.debug(ETRCT.id);
        
        List<ETST_CreateRefund.WrapperPayment> lobj = new List<ETST_CreateRefund.WrapperPayment>();
        ETST_CreateRefund.WrapperPayment obj = new ETST_CreateRefund.WrapperPayment();
        obj.receiptnumber='110259074/129081.27/2/10167';
        obj.oracleInvId=6037927;
        obj.oracleInvNumber='20170813004';
        obj.oracleReceiptId=3952785;
        lobj.add(obj);
        
        Test.startTest();
        ET_RefundApprovalCallout.processRefund(ETRF.id);
        Test.stopTest();
    }
    
     @isTest
     Public static void WrapperPayment_TGN_TEST(){
        ETST_CreateRefund.WrapperPayment obj = new ETST_CreateRefund.WrapperPayment();
    }
   
}