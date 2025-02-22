trigger ETI_workOrderTrigger on WorkOrder (after update) {
    // invoke Trigger after update
    if(trigger.isafter && trigger.isUpdate){
        ETI_workOrderTriggerHandler.update_Inspctn_StatusOn_AMAN(trigger.oldMap, trigger.newmap);
    }
}