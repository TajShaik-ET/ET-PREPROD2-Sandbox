public class ET_CreateMaintainanceController {
    
    @AuraEnabled
    public static Boolean createMaintenanceRequestRecord(List<Maintenance_Request__c> maintenanceRequestList,String opportunityId,Maintenance_Questionnaire__c maintenanceQuestionnaire ){
        Boolean returnValue = true ;
        system.debug('maintenanceRequestList = '+maintenanceRequestList);
        system.debug('opportunityId = '+opportunityId);
        system.debug('maintenanceQuestionnaire = '+maintenanceQuestionnaire);
        try{
            insert maintenanceQuestionnaire;
            
            for(Maintenance_Request__c mr :maintenanceRequestList){
                mr.Opportunity__c = opportunityId;
                mr.Maintenance_Questionnaire__c = maintenanceQuestionnaire.Id;
            }
            system.debug('maintenanceRequestList after opp and Questionnaire update = '+maintenanceRequestList);
            insert maintenanceRequestList;
        }catch(Exception e){
            system.debug('maintenanceRequest Error = '+e.getMessage());
            returnValue= false;
        }
        return returnValue;
    }
    
}