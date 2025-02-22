/********************************************************************************************************************
Trigger Class : salesVehicleInventory
Author        : Akash
Description   : Description
TestClass     : 
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date        Author            Details                                        
1.           v1.0             07/04/2023    Akash    
2.           v2.0             27/04/2023    Manisha         Commented Insert logic
*******************************************************************************************************************/
trigger salesVehicleInventory   on ETM_Sales_Vehicle_Inventory__c (after update,after insert) {
    
  if(trigger.isUpdate)
  SalesVehicalInventoryTrgHandler.handleFieldChanges(Trigger.new, Trigger.oldMap);
  
  /* if(trigger.isInsert)
  SalesVehicalInventoryTrgHandler.handleOnInsert(Trigger.new);  */
    
}