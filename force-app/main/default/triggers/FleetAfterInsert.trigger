trigger FleetAfterInsert on ETT_Fleet_Analysis_Request__c (after insert) {
if(Trigger.isafter)
{
    // Map<Id, ETT_Fleet_Analysis_Request__c> updatePartyTypeMap  = new Map<Id, ETT_Fleet_Analysis_Request__c>{};
    List<ETT_Fleet_Analysis_Request__c> updateFleetAnalysisList = new  List<ETT_Fleet_Analysis_Request__c>();
    for(ETT_Fleet_Analysis_Request__c newFleet:[Select id,name,ETT_Customer_Name__c,ETT_Account__c,Lead__c,Party_Type__c,
                                                ETT_Account__r.Party_Type__c,ETT_Account__r.Name,Lead__r.ETT_Party_Type__c,Lead__r.Name 
                                                from ETT_Fleet_Analysis_Request__c where ID IN:trigger.new] )   
     {
         if(newFleet.ETT_Account__c!=null)   
         {
           List<Contact> conList = [Select id,Name,Phone from Contact where AccountId=:newFleet.ETT_Account__c];
             if(conList.size()>0)
             {
                 String contname = conList[0].Name;
                 String contPhone = conList[0].Phone;
                  ETT_Fleet_Analysis_Request__c fleetAnalysisReqObj  = newFleet;
                 fleetAnalysisReqObj.Contact_Person__c = contname;
                 fleetAnalysisReqObj.Phone__c = contPhone;
                 updateFleetAnalysisList.add(fleetAnalysisReqObj);
                 
             }
        /*    if(newFleet.Party_Type__c==null&&newFleet.ETT_Customer_Name__c==null)
            {
               ETT_Fleet_Analysis_Request__c fleetAnalysisReqObj  = newFleet;
                fleetAnalysisReqObj.Party_Type__c = newFleet.ETT_Account__r.Party_Type__c;
                 fleetAnalysisReqObj.ETT_Customer_Name__c = newFleet.ETT_Account__r.Name;
                
                updatePartyTypeList.add(fleetAnalysisReqObj);
            }*/
         } 
        /* if(newFleet.Lead__c!=null)
         {
              if(newFleet.Party_Type__c==null&&newFleet.ETT_Customer_Name__c==null)
            {
                 ETT_Fleet_Analysis_Request__c fleetAnalysisReqObj  = newFleet;
                fleetAnalysisReqObj.Party_Type__c = newFleet.Lead__r.ETT_Party_Type__c;
                 fleetAnalysisReqObj.ETT_Customer_Name__c = newFleet.Lead__r.Name;
                updatePartyTypeList.add(fleetAnalysisReqObj);
            }
             
         }*/
     }
    
    if(updateFleetAnalysisList.size()>0)
    {
        update updateFleetAnalysisList;
    }
    
}
}