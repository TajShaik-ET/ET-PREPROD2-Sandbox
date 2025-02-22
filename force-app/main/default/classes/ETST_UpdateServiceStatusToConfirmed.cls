public class ETST_UpdateServiceStatusToConfirmed {
  @InvocableMethod
    public static void updateServiceRequests(List<Id> serviceRequestIds) {
        
        Set<Id> studentIds = new Set<Id>();
        for(ET_Service_Request__c req: [SELECT ETST_Student__c FROM ET_Service_Request__c WHERE Id IN :serviceRequestIds]){
            studentIds.add(req.ETST_Student__c);
        }
        
        Map<Id, ET_Service_Request__c> activeRecordsMap = new Map<Id, ET_Service_Request__c>();
        for(ET_Service_Request__c req : [SELECT Name,ETST_Pick_Up_From__c,ETST_Is_Active__c,ETST_Drop_Off_To__c,ETST_Service_Type__c,ETST_Transport_Type__c,ETST_Student__c
                                         FROM ET_Service_Request__c WHERE ETST_Student__c IN :studentIds and ETST_Is_Active__c=true]){
                                             activeRecordsMap.put(req.ETST_Student__c , req);
                                         }
        
        List<ET_Service_Request__c> renewalList = new List<ET_Service_Request__c>();
        for(ET_Service_Request__c req : [SELECT Name,ETST_Pick_Up_From__c,ETST_Is_Active__c,ETST_Drop_Off_To__c,ETST_Service_Type__c,ETST_Transport_Type__c,ETST_Student__c
                                         FROM ET_Service_Request__c WHERE Id IN :serviceRequestIds]){
                                             
                                             if((activeRecordsMap.get(req.ETST_Student__c).ETST_Transport_Type__c != req.ETST_Transport_Type__c)||
                                                (activeRecordsMap.get(req.ETST_Student__c).ETST_Pick_Up_From__c != req.ETST_Pick_Up_From__c)||
                                                (activeRecordsMap.get(req.ETST_Student__c).ETST_Drop_Off_To__c != req.ETST_Drop_Off_To__c)){
                                                    req.ETST_Status__c = System.Label.ETST_Under_Review;
                                                }else{
                                                    req.ETST_Status__c = System.Label.ETST_Service_Confirmed;
                                                }
                                             renewalList.add(req);                                             
                                         }
        
        if(renewalList.size()>0){
            update renewalList;
        }
        
        
    }
}