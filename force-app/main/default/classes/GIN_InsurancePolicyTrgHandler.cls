/*
* File Name:GIN_InsurancePolicyTrgHandler
* Author : Janardhan
* CreatedDate : 08/09/2021
* Modification Purpose
* * 
* * 
*/
public class GIN_InsurancePolicyTrgHandler {
    
    public static void updateRecordStatus(Map<Id,GI_General_Insurance_Policy__c> trgnewMap){
        
                 
        set<id> oldPolicyIds = new set<id>();
        List<GI_General_Insurance_Policy__c> newUpdateList = new List<GI_General_Insurance_Policy__c>();
        
         for(GI_General_Insurance_Policy__c gipNew  : trgnewMap.values())
         {
             if(gipNew.Status__c == 'Active' && gipNew.Last_Insurance_Policy__c != null){
                 
                 oldPolicyIds.add(gipNew.Last_Insurance_Policy__c);
             }
         }        
      
        for(GI_General_Insurance_Policy__c gipOld : [select id,Status__c from GI_General_Insurance_Policy__c where Id=:oldPolicyIds AND Status__c ='Active']){
            
            GI_General_Insurance_Policy__c tempPolicy = new GI_General_Insurance_Policy__c();
            tempPolicy.Id = gipOld.Id;
            tempPolicy.Status__c = 'Inactive';
            newUpdateList.add(tempPolicy);
            
        }
        
        if(newUpdateList != null && newUpdateList.size()>0){
            try {
                update newUpdateList;
             }
            catch (Exception e) {
                
               system.debug('Something went wrong: '+ e.getMessage());    
            }
        } 
        
        
    }

}