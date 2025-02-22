global class ETST_ParentAccessToCoordinatorBatch implements Database.Batchable<sObject>, Schedulable{
    
    global string queryString;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        queryString = 'Select Id,ETST_School__c,ETST_Account_Name__c,ETST_School__r.ETST_Coordinator__c';
        queryString += ' from ETST_Student__c WHERE ETST_Parent_Access_Granted__c= false';
        return Database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext bc, List<ETST_Student__c> scope){
        Set<Id> accIds = new Set<Id>();
        for(ETST_Student__c stdnt: scope){
            accIds.add(stdnt.ETST_Account_Name__c);  
        }
        Map<Id, set<Id>> accessMap = new map<Id, set<Id>>();
        for(AccountShare shr : [Select Id,AccountId,UserOrGroupId from AccountShare where accountId In:accIds]){
            if(!accessMap.containskey(shr.AccountId)){
                accessMap.put(shr.AccountId, new set<id>());
            }
            accessMap.get(shr.AccountId).add(shr.UserOrGroupId);
        }
        List<ETST_Student__c> studentsListToUpdate = new List<ETST_Student__c>();
        List<AccountShare> accshrList  = new List<AccountShare>();  
        for(ETST_Student__c std : scope){ 
            if(!accessMap.containskey(std.ETST_Account_Name__c) || !accessMap.get(std.ETST_Account_Name__c).contains(std.ETST_School__r.ETST_Coordinator__c)){
                AccountShare accshr=new AccountShare();
                accshr.accountId = std.ETST_Account_Name__c;
                accshr.UserOrGroupId =std.ETST_School__r.ETST_Coordinator__c;
                accshr.AccountAccessLevel = System.label.ETST_ParentAccessLevel;
                accshr.OpportunityAccessLevel = System.label.ETST_ParentAccessLevel;
                accshr.RowCause = Schema.AccountShare.RowCause.Manual;
                accshrList.add(accshr);
                std.ETST_Parent_Access_Granted__c = true;
                studentsListToUpdate.add(std);
            }
        } 
        try{
            insert accshrList;
            update studentsListToUpdate;
        }catch(DMLException ex){
            System.debug('Sharing records with Coordinator failed'+ex.getMessage());
        } 
    }
    
    global void finish(Database.BatchableContext bc){
    }    
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new ETST_ParentAccessToCoordinatorBatch());
    }
    
}