public class ETST_ShareAccountsWithCoordinator {
    
    public static void ShareAccountsWithCoordinator(set<Id> recordIds){
        //string parentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId(); 
        string schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId(); 
        Map<Id,Id> AccUserMap=new Map<Id,Id>();
        for(account acc:[select id,etst_coordinator__c from account where id IN:recordIds and RecordTypeId=:schoolRecordTypeId]){//(RecordTypeId=:parentRecordTypeId or RecordTypeId=:schoolRecordTypeId)
            if(acc.etst_coordinator__c!=null){
                AccUserMap.put(acc.Id,acc.etst_coordinator__c);  
            }
            
        }
        system.debug('++AccUserMap++'+AccUserMap);
        if (AccUserMap.size() != null && AccUserMap.size()>0) {
            // Create new sharing object for the custom object Account.
            List<AccountShare> accshrList  = new List<AccountShare>();       
            for(Id id : AccUserMap.keyset()){
                AccountShare accshr=new AccountShare();
                // Set the ID of record being shared.
                accshr.accountId = Id;
                
                // Set the ID of user or group being granted access.
                accshr.UserOrGroupId =AccUserMap.get(Id) ;
                
                // Set the access level.
                accshr.AccountAccessLevel = 'Read';
                accshr.OpportunityAccessLevel = 'Read';
                
                // Set rowCause to 'manual' for manual sharing.
                // This line can be omitted as 'manual' is the default value for sharing objects.
                accshr.RowCause = Schema.AccountShare.RowCause.Manual;
                accshrList.add(accshr);
            }  
            
            try{
                System.debug('accshrList');
                insert accshrList;
            }catch(DMLException ex){
                System.debug('Sharing records with Coordinator failed'+ex.getMessage());
            } 
        }
    }
    
    public static void shareStudentsToCoordinator(Map<id, ETST_Student__c> newMap, Map<id, ETST_Student__c> oldMap){
        set<id> accountIds = new set<id>();
        Map<Id, Id> studentMap = new Map<Id, Id>();
        Map<Id, Id> parentMap = new Map<Id, Id>();
        List<AccountShare> parentshrList  = new List<AccountShare>();  
        List<ETST_Student__c> lstStudents = new List<ETST_Student__c>();
        for(ETST_Student__c student:[select id,ETST_Account_Name__c,ETST_School_Name__c,ETST_School_Name__r.Customer__r.ETST_Coordinator__c,ETST_School_Name__r.Customer__c,ETST_School__c,ETST_School__r.etst_coordinator__c,ETST_Coordinator__c from ETST_Student__c where Id IN:newMap.keyset()]){
            if(student.ETST_School_Name__r.Customer__c!=null){
                student.ETST_School__c = student.ETST_School_Name__r.Customer__c;
                student.OwnerId = student.ETST_School_Name__r.Customer__r.ETST_Coordinator__c;
                lstStudents.add(student);
            }
            
        }
        if(!lstStudents.isEmpty()){
            update lstStudents;
        }
        /*  for(ETST_Student__c student:[select id,ETST_Account_Name__c,ETST_School_Name__c,ETST_School_Name__r.Customer__c,ETST_School__c,ETST_School__r.etst_coordinator__c,ETST_Coordinator__c from ETST_Student__c where Id IN:lstStudents]){
if(student.ETST_Coordinator__c!=null){ 
parentMap.put(student.ETST_Account_Name__c, student.ETST_Coordinator__c);
}            
}   
for(Id parentId : parentMap.keySet()){
AccountShare accshr=new AccountShare();
accshr.accountId = parentId;
accshr.UserOrGroupId =parentMap.get(parentId) ;
accshr.AccountAccessLevel = 'Read';
accshr.OpportunityAccessLevel = 'Read';
accshr.RowCause = Schema.AccountShare.RowCause.Manual;
parentshrList.add(accshr);
} */
        try{
            if(!parentshrList.isEmpty()){
                //insert parentshrList;
            }
        }catch(DMLException ex){
            System.debug('Sharing records with Coordinator failed'+ex.getMessage());
        }
    }
    public static void populateCoordinatorandLocation(List<Invoice__c> newMap){
        Set<Id> serviceRequestIds = new Set<Id>();
        Map<Id, ET_Service_Request__c> mapServiceRequests = new Map<Id, ET_Service_Request__c>();
        for(Invoice__c inv : newMap){
            if(inv.Service_Request__c !=null && inv.ETST_Type__c !=null){
                serviceRequestIds.add(inv.Service_Request__c);
            }
        }
        if(serviceRequestIds.size()>0){
            for(ET_Service_Request__c sevReq : [Select Id,Name,ET_Account__c,ETST_Coordinator__c FROM ET_Service_Request__c WHERE Id IN:serviceRequestIds]){
                mapServiceRequests.put(sevReq.Id, sevReq);
            }
        }
        system.debug('mapServiceRequests***'+mapServiceRequests);
        if(!mapServiceRequests.isEmpty()){
            for(Invoice__c inv : newMap){
                inv.ETST_Coordinator__c =  mapServiceRequests.get(inv.Service_Request__c).ETST_Coordinator__c;
                inv.Customer__c =  mapServiceRequests.get(inv.Service_Request__c).ET_Account__c;
            }
        }
        
    } 
    /*
public static void shareServiceRequestsToCoordinator(Map<id, ET_Service_Request__c>newMap, Map<id, ET_Service_Request__c> oldMap){
Map<Id, Id> serviceRequestMap = new Map<Id, Id>();
List<ET_Service_Request__Share> serviceRequestshrList = new List<ET_Service_Request__Share>(); 
List<ETST_Student__c> lstStudents = new List<ETST_Student__c>();
for(ET_Service_Request__c service :[select id,ETST_Student__c,ETST_Student__r.ETST_Coordinator__c from ET_Service_Request__c where Id IN:newMap.keyset()]){
if(service.ETST_Student__c!=null){
serviceRequestMap.put(service.id, service.ETST_Student__r.ETST_Coordinator__c);
}

}
for(Id serviceId : serviceRequestMap.keySet()){
ET_Service_Request__Share serviceshr = new ET_Service_Request__Share();
serviceshr.parentId = serviceId;
serviceshr.UserOrGroupId = serviceRequestMap.get(serviceId);
serviceshr.AccessLevel = 'Edit';
serviceshr.RowCause = Schema.AccountShare.RowCause.Manual;
serviceRequestshrList.add(serviceshr);
}
try{
if(!serviceRequestshrList.isEmpty()){
insert serviceRequestshrList;
}
}catch(DMLException ex){
System.debug('Sharing records with Coordinator failed'+ex.getMessage());
}
}
*/
    /* public static void serviceRequestsOwnerChangeToCoordinator(Map<Id,ET_Service_Request__c> newMap){
List<ET_Service_Request__c> updateServiceRequest = new List<ET_Service_Request__c>();        

for(ET_Service_Request__c request : [select id,ETST_Coordinator__c,ownerId from ET_Service_Request__c
where id IN:newMap.keyset() ] ){
request.OwnerId = request.ETST_Coordinator__c;
updateServiceRequest.add(request);

}
try{
update updateServiceRequest;
}catch(DMLException ex){
System.debug('Sharing records with Coordinator failed'+ex.getMessage());
}         

}*/

    
    public static void shareParentAccountsToCoordinator(Map<id, ETST_Student__c> newMap, Map<id, ETST_Student__c> oldMap){
        
        Set<Id> parentShareList  = new Set<Id>();  
        Set<Id> cordinatorList = new Set<Id>();
        for(ETST_Student__c student:[SELECT id,ETST_School__c,ETST_School__r.ETST_coordinator__c,ETST_Coordinator__c,ETST_Account_Name__c  FROM ETST_Student__c WHERE Id IN:newMap.keyset()]){
            if(student.ETST_School_Name__r.Customer__c!=null){
                parentShareList.add(student.ETST_Account_Name__c);
                cordinatorList.add(student.ETST_Coordinator__c);
            }
        }
    }
    
    

}