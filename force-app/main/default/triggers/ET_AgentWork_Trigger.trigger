trigger ET_AgentWork_Trigger on AgentWork (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        Map<Id, Id> caseandUserIds = new Map<Id, Id>();
        for(AgentWork agent : Trigger.New){
              caseandUserIds.put(agent.workItemId, agent.userId);
        }
        if(caseandUserIds.keyset().size()>0){
            CaseTriggerHandler.updateCaseManagerEmail(caseandUserIds);
        }
    }
}