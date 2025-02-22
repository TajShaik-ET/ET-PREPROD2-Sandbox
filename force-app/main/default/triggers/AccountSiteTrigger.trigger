/**
 *  Test Class: Oracle_Integration_Services_Test
 *  Modified by : Janardhan - 16/02/23 : Commented code
 *                Janardhan - 21/03/23 : uncommented code
 * 				  Sreelakshmi SK - 9/6/23: Commented method calling in after update
 * 
 * */
trigger AccountSiteTrigger on ETSALES_Account_Sites__c (after insert,after update) {

      
    if(Trigger.isAfter&&Trigger.isInsert){
        
        Oracle_Integration_Services.integrateAccountSiteToOracleFromTrigger(Trigger.New);
    }
    if(Trigger.isAfter&&Trigger.isUpdate){
      
        if(!System.isFuture()&&!System.isBatch())
        {
            //commented by Sreelakshmi SK -- 9/6/23
           // Oracle_Integration_Services.integrateAccountSiteToOracleFromTrigger(Trigger.New);
        }
         

    }
   
  
}