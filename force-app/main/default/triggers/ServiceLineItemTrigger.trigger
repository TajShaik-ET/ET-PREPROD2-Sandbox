trigger ServiceLineItemTrigger on ETI_Service_Line_Item__c (after update) {
    if(trigger.isAfter){
        if(trigger.isUpdate){
            ETI_ServiceLineItemHandler.updateTestResult(trigger.new,trigger.oldMap);
        }
    }
}