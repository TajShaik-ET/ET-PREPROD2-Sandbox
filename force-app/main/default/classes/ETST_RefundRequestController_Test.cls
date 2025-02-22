@isTest
public class ETST_RefundRequestController_Test {
    @isTest
    static void testRefund() {
         ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Paid_By__c = 'Self');
        insert etreq;
        
        ET_Refund__c refund = new ET_Refund__c();
        refund.RecordTypeId = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Refund_Record_Type').getRecordTypeId();
        refund.ET_Refund_Amount__c = 100;
        refund.ET_Service_Request__c = etreq.Id;
        insert refund;
        ETST_RefundRequestController.getRefundRequests('REF','Name','asc');
    }
}