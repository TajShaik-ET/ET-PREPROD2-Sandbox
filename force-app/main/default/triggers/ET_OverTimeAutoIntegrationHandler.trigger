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
trigger ET_OverTimeAutoIntegrationHandler on OverTime_Sheets__c (before insert,before update,after insert,after update,before delete) {
    
     
    if(trigger.isUpdate && trigger.isAfter){ 
        for(OverTime_Sheets__c mtd: trigger.new){
            OverTime_Sheets__c oldMtd = Trigger.oldMap.get(mtd.Id);
            if(mtd.Status__c == 'Approved' && oldMtd.Status__c != 'Approved'){
                ET_OverTimeAutoIntegration.getOverTimeData(mtd.Id);
            }
            
        }
    }
    
    
}