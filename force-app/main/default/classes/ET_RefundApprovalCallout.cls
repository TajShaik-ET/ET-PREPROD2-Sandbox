/**
 * @description       : 
 * @author            : Srihari.Koyila@Smaartt.com-SK
 * @group             : 
 * @last modified on  : 08-07-2024 
 * @last modified by  : Srihari.Koyila@Smaartt.com-SK
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   08-06-2024   Srihari.Koyila@Smaartt.com-SK   Initial Version
**/
public class ET_RefundApprovalCallout {
 @AuraEnabled @Future(callout=true)
    public static void processRefund(string recordid){
         ETST_CreateRefund.processReceiptsAndPost(recordid);
    }
}