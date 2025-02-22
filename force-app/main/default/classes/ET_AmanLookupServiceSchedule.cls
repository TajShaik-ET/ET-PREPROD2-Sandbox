/*
* File Name:ET_AmanLookupServiceSchedule
* Author : Smaartt
* CreatedDate : 08/08/2020
* Modification Purpose
* * 1. Waseem: Schedulable class to load all Aman Service Lookup Values.
* * 2.
*/ 
global class ET_AmanLookupServiceSchedule implements Schedulable,Database.AllowsCallouts {
   
   public static ET_Lookup.Output lookupResult {get;set;}

   global void execute(SchedulableContext SC) {
      
      Set<String> lookupValues = new Set<String>();
      for(Aman_Lookup_Settings__mdt lookupMetadata: [SELECT Id, DeveloperName,  Label FROM Aman_Lookup_Settings__mdt]){
         lookupValues.add(lookupMetadata.DeveloperName);
      }
      if(lookupValues.size()>0){
         for(string lookupType:lookupValues){
            sendSyncRequest(lookupType, '');
         }
      }
   }

   // Invoke Asynchronous method to get lookup value.
   @future(callout=true)
   public static void sendSyncRequest(String lookupType, string lookupCode){
      getLookupValueSync( lookupType,  lookupCode);
   }

   public static void getLookupValueSync(String lookupType, string lookupCode){
       ET_Lookup_Service.execute_pt service = new ET_Lookup_Service.execute_pt();
       lookupResult = service.execute(lookupType, lookupCode);
       if(lookupResult!=null)
       {
           List<ETI_Aman_Lookup__c> lookupValuesToInsert = doMappingLookupMaster(lookupResult,lookupType);
           system.debug('lookupValuesToInsert>> '+lookupValuesToInsert.size());
           if(lookupValuesToInsert.size()>0)
           {
               upsert lookupValuesToInsert ETI_External_ID__c; 
           } 
       } 
   }

   
   //perform mapping for Lookup Master
   public static List<ETI_Aman_Lookup__c> doMappingLookupMaster(ET_Lookup.Output result,String lookupType){
      Map<String, ETI_Aman_Lookup__c> mapExtIdToLookupValues = new  Map<String, ETI_Aman_Lookup__c>();
          Set<String> lookupExtIds = new Set<String>();
       //Query AMAN lookup from salesforce and mark them inactive if deactivated in AMAN.
       
      
      List<ETI_Aman_Lookup__c> lookupValuesToInsert = new List<ETI_Aman_Lookup__c>();
      if(result.Status.toLowerCase() == 's'){
            ET_Lookup.AmanLookupValuesCollection lookupData = result.Data;
            if(lookupData!=null && lookupData.AmanLookupValues.size() > 0){
               for(ET_Lookup.AmanLookupValues row:lookupData.AmanLookupValues){
                  ETI_Aman_Lookup__c lookup = new ETI_Aman_Lookup__c();
                  lookup.Name = row.lookupName;
                  lookup.ETI_LookupType__c = row.lookupType;
                  lookup.ETI_LookupCode__c = row.lookupCode;
                  lookup.ETI_ArabicName__c = row.lookupNameAr;
                  lookup.ETI_External_ID__c = row.lookupType + ':' + row.lookupCode;
                  //lookup.isActive__c=true;
                  lookupExtIds.add(lookup.ETI_External_ID__c );
                  lookupValuesToInsert.add(lookup);
               }
                for(ETI_Aman_Lookup__c lookup:[SELECT Id, ETI_External_ID__c,isActive__c 
                                               FROM ETI_Aman_Lookup__c 
                                               WHERE ETI_External_ID__c Not In:lookupExtIds AND ETI_LookupType__c=:lookupType]){
                        lookup.isActive__c=false;
                        lookupValuesToInsert.add(lookup);
                }
            }
          
      }
      return lookupValuesToInsert;
   }
}