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
trigger ET_RefundApproval on ET_Refund__c (before insert,before update,after insert,after update,before delete) {
    
     
    // if(trigger.isUpdate && trigger.isAfter){ 
    // for(ET_Refund__c mtd: trigger.new){
    // ET_Refund__c oldMtd = Trigger.oldMap.get(mtd.Id);
    //if(mtd.Approval_Status__c == 'Approved' && oldMtd.Approval_Status__c != 'Approved'){
    //  ET_RefundApprovalCallout.processRefund(mtd.Id);
    // if(mtd.Integration_Status__c == 'Success' && oldMtd.Integration_Status__c != 'Success'){
    //     mtd.addError('Integration is Unsuccessfull');
    // }
    // }
    
    
    //  }
    //  }
     if(Trigger.isUpdate && Trigger.isAfter){
        RefundTriggerHandler.sendEmailWithAttachments(Trigger.new, Trigger.oldMap);
    }
    
}