public class ETSALES_SocialPostTriggerHandler {
    
    public static void updateLeadRecordType(Map<Id, SocialPost> newMap){
        
        Set<Id> leadIds = new Set<Id>();
        for(SocialPost sp : newMap.values()){
            if(sp.WhoId != null && String.valueOf(sp.WhoId).startsWith('00Q') && ( sp.TopicProfileName.contains('emiratesmoto') || sp.TopicProfileName.contains('Emirates Moto') ) ){
                leadIds.add(sp.WhoId); 
            } 
        }
        Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ETSALES_Automotive_Dealership').getRecordTypeId();
        List<lead> leadList = new List<lead>();
        for(Lead ld : [Select Id, RecordTypeId FROM Lead WHERE Id In:leadIds]){
            ld.RecordTypeId = recTypeId;
            ld.Email = 'dummy@gmail.com';
            ld.MobilePhone = '123456789';
            ld.ETSALES_Lead_Type__c = 'Enquiry';
            ld.ETSALES_Lead_Rating__c = 'Hot';
            leadList.add(ld);
        }
        if(leadList.size() > 0){
            update leadList;
        }
    }
    
}