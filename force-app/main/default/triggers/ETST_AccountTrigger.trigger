Trigger ETST_AccountTrigger on Account (before insert,after insert, after update, before delete,before update) {
    /* Employee Insurance related logic - start */  
    // Added By Boddh : get custom metadata with getInstance();
    TriggerExcecutionControl__mdt  accountTriggerCheck = [ SELECT MasterLabel, DisableAccountTrigger__c FROM TriggerExcecutionControl__mdt where MasterLabel='Account' ];
    System.debug('----->'+accountTriggerCheck.DisableAccountTrigger__c);
    
    if( accountTriggerCheck.DisableAccountTrigger__c )
    {
        if((trigger.isInsert || trigger.isUpdate)&& trigger.isBefore){ 
            
            ETIN_UpdateEmployeeGLDetails.updateGLDetails(trigger.new);  
        }   
        /*  Employee Insurance related logic - end*/    
        
        switch on Trigger.operationType{
            when BEFORE_INSERT {
                ETST_AccountTriggerHandler.restrictDupliateAccount(Trigger.new);
            }
            when AFTER_INSERT{
                if(!System.isBatch()){
                    System.debug('After Insert');
                    String jsonString = json.serialize(Trigger.new);
                    ETST_Global_Handler.createETSTCommunityUsers(jsonString); // commented this code as in produciton it was commented
                    ETST_Global_Handler.createorUpdateSchool(Trigger.newMap, null);
                    ETST_ShareAccountsWithCoordinator.ShareAccountsWithCoordinator(Trigger.newMap.keyset());
                    ETIN_notifyUsersOnNewEmployeeCreation.notifyInsuranceUsers(trigger.newMap);//Added by Jana for health Insurance
                }
                //if(Trigger.newMap!=null)
                //ET_Account_Integration_Handler.syncAccountsWithOracleOnCreation(Trigger.newMap.keySet());
            }
            when AFTER_UPDATE{
                if(!System.isBatch()){
                    ETST_Global_Handler.createorUpdateSchool(Trigger.newMap, Trigger.oldMap);
                    ETST_ShareAccountsWithCoordinator.ShareAccountsWithCoordinator(Trigger.newMap.keyset());  
                    ETST_Global_Handler.onChangeCoordinatorOnSchool(Trigger.newMap, Trigger.oldMap);
                    //Commented by Janardhan - 09/06/2023
                    /* if(!System.isFuture())
{
Oracle_Integration_Services.integrateUpdateAccountToOracleFromTrigger(Trigger.New); 

}*/
                    
                }
            }
            When BEFORE_DELETE{
                if(!System.isBatch()){
                    ETST_Global_Handler.deleteSchoolRecord(Trigger.old);
                }
            }
            when else{
                System.debug('Something went wrong');
            }
        }
      }
    // add by santosh 10/10/2024
    if (Trigger.isAfter && Trigger.isUpdate) {
        AccountSitesUpdateHelper.updateAccountSites(Trigger.new, Trigger.oldMap);
    }
    
    
}