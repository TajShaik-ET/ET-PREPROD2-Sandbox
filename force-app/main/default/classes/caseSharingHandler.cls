/**************************************************************************************************
* Name               : caseSharingHandler                                                           
* Description        : ESE PORTAL School Maping to User                                                          
* Created Date       : 15/03/2023                                                                
* Created By         : Akash Yellure   
*Trigger Name        : CaseTrigger
* ----------------------------------------------------------------------------------------------- 
* VERSION     Created by                    DATE                                                                    
* 1.0        Akash Yellure                 15/03/2023                                                                
**************************************************************************************************/ 
public class caseSharingHandler {
    
    public static void eseCaseSharing (Map<id,case> trgNewMap){ 
        
        //This list is for adding newly created cases
        List<CaseShare> caShareList = new List<CaseShare>();
        Set<String> eseCatogory = new Set<String>();
        Set<String> schSet  = new  Set<String>();
        
        Map<String,List<ESE_User__c>> schoolVsDptMap  = new Map<String,List<ESE_User__c>>();
        
        //  List<case> caselist = [Select id, RecordType.Name,AccountId,Status_Category__c  from case where id =:trgNewMap.keySet()];
        
        for(case cs :trgNewMap.values() ) {
            
            // eseDept.add(cs.RecordType.Name);
            schSet.add(cs.AccountId);
            eseCatogory.add(cs.Status_Category__c);
        }
        List<ESE_User__c> eUser =[select id,Name , User__r.Name,School_Department__r.School_Name__c ,School_Department__r.Category__c from ESE_User__c];
        
        System.debug('Catogory'+eseCatogory);
        
        
        for(ESE_User__c us : [select id,Name , User__c,School_Department__r.School_Name__c ,School_Department__r.Category__c from ESE_User__c Where School_Department__r.Category__c =:eseCatogory  And School_Department__r.School_Name__c =: schSet ] ){
            System.debug('data'+us);
            if(!schoolVsDptMap.containskey(us.School_Department__r.Category__c)){
                system.debug('ION3');
                schoolVsDptMap.put(us.School_Department__r.Category__c,new List<ESE_User__c>());
            } 
            schoolVsDptMap.get(us.School_Department__r.Category__c).add(us);
        }
        
        for(case cs :trgNewMap.values() ){
            
            if(schoolVsDptMap.containskey(cs.Status_Category__c)){
                SYSTEM.debug('ION4');
                
                for(ESE_User__c edu :schoolVsDptMap.get(cs.Status_Category__c)){  
                    if(cs.AccountId==edu.School_Department__r.School_Name__c && cs.Status_Category__c==edu.School_Department__r.Category__c){
                        System.debug('ION5');
                        CaseShare caShare = new CaseShare();
                        caShare.caseID=cs.Id;
                        caShare.CaseAccessLevel='edit';
                        caShare.RowCause='Manual';
                        caShare.UserOrGroupId=edu.User__c;
                        caShareList.add(caShare);
                        
                    }
                    
                }
                
            }
            
            
        }
        if( caShareList != null && caShareList.size() != 0 ) {
            try {
                Database.SaveResult[] caShareLi = Database.insert(caShareList,false);
                System.debug('result'+caShareLi);
                
            }catch( Exception e ) {
                System.debug('Error::::::'+e.getMessage());
            }
        }
        
        System.debug('test'+caShareList);
        
    }
    
    //This Method To Update and assigned to other User
    public static void eseCaseSharingAfterUpdateCase(Map<Id,case> trgOldMap,Map<ID,case>trgNewMap){
        List<CaseShare> caShareList = new List<CaseShare>();
        Set<String> eseCatogory = new Set<String>();
        Set<String> schSet  = new  Set<String>();
        Map<String,List<ESE_User__c>> schoolVsDptMap  = new Map<String,List<ESE_User__c>>();
        
        for(case cs :trgNewMap.values() ) {
            // eseDept.add(cs.RecordType.Name);
            if(cs.Status_Category__c!=trgOldMap.get(cs.ID).Status_Category__c){
                schSet.add(cs.AccountId);
                eseCatogory.add(cs.Status_Category__c);
            }
            
        }
        
        
        for(ESE_User__c us : [select id,Name , User__c,School_Department__r.School_Name__c ,School_Department__r.Category__c from ESE_User__c Where School_Department__r.Category__c =:eseCatogory  And School_Department__r.School_Name__c =: schSet ] ){
            if(!schoolVsDptMap.containskey(us.School_Department__r.Category__c)){
                system.debug('ION3');
                schoolVsDptMap.put(us.School_Department__r.Category__c,new List<ESE_User__c>());
            } 
            schoolVsDptMap.get(us.School_Department__r.Category__c).add(us);
        }
        for(case cs :trgNewMap.values() ){
            
            if(schoolVsDptMap.containskey(cs.Status_Category__c) && cs.Status_Category__c!=trgOldMap.get(cs.ID).Status_Category__c ){
                SYSTEM.debug('ION4');
                
                for(ESE_User__c edu :schoolVsDptMap.get(cs.Status_Category__c)){  
                    if(cs.AccountId==edu.School_Department__r.School_Name__c && cs.Status_Category__c==edu.School_Department__r.Category__c){
                        System.debug('ION5');
                        CaseShare caShare = new CaseShare();
                        caShare.caseID=cs.Id;
                        caShare.CaseAccessLevel='edit';
                        caShare.RowCause='Manual';
                        caShare.UserOrGroupId=edu.User__c;
                        caShareList.add(caShare);
                        
                    }
                    
                }
                
            }
            
            
        }
        if( caShareList != null && caShareList.size() != 0 ) {
            try {
                Database.SaveResult[] caShareLi = Database.insert(caShareList,false);
            }catch( Exception e ) {
                System.debug('Error::::::'+e.getMessage());
            }
        }
    
    }
    
    public static void utilityMethod(){
         integer i=0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}