/********************************************************************************************************************
Trigger Class : CustomerAddressTrigger
Author        : 
Description   : Description
TestClass     : Oracle_Integration_Services_Test
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date        Author            Details                                        
1.           v1.0             16/02/23     Janardhan        Commented code  
2.           v2.0             25/04/23     Janardhan        Uncommented the code
3.           v3.0             01/05/23     Janardhan        Added custom meta data skip logic
*******************************************************************************************************************/

trigger CustomerAddressTrigger on ETSALES_Address__c (before insert,after insert,after update) {
    
    Skip_Execution__mdt sk = Skip_Execution__mdt.getInstance('customerAddress');
   
    if(Trigger.isAfter&&Trigger.isInsert && !sk.Skip_Code__c){
      
      Oracle_Integration_Services.integrateAddressToOracleFromTrigger(Trigger.New);
        
 
    }
    
    if(Trigger.isAfter&&Trigger.isUpdate && !sk.Skip_Code__c){
        if(!System.isFuture()&&!System.isBatch())
        {
          Oracle_Integration_Services.integrateAddressToOracleFromTrigger(Trigger.New);  
        }
          
    }
    
   
}