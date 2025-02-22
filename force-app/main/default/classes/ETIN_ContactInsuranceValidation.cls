public class ETIN_ContactInsuranceValidation {
    
    public static void ContactValidation(list<Contact> conList){
        
        system.debug('-----Enter----');
        set<id> accIds = new set<id>();
       // map<Id,Integer> accIDConSizeSpouse = new map<Id,Integer>();
       // map<Id,Integer> accIDConSizeChild = new map<Id,Integer>();
         map<Id,Integer> empIdFamilySpouseCount = new map<Id,Integer>();
         map<Id,Integer> empIdFamilyChildCount = new map<Id,Integer>();
        set<id> empIds = new set<id>();
        
        Id ContRecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETIN_Employee_Family').getRecordTypeId();
        
        for(contact con : conList){
            
            accIds.add(con.AccountId);
            empIds.add(con.ETIN_Employee__c);
        }
        
        for(AggregateResult agg : [select count(id) co,ETIN_Employee__c from contact where ETIN_Relation__c='Spouse' AND ETIN_Employee__c=:empIds GROUP BY ETIN_Employee__c ]){
            
            empIdFamilySpouseCount.put((Id)agg.get('ETIN_Employee__c'),(Integer)agg.get('co'));
        }
        
        for(AggregateResult agg : [select count(id) co,ETIN_Employee__c from contact where ETIN_Relation__c='Child' AND ETIN_Employee__c=:empIds GROUP BY ETIN_Employee__c ]){
            
            empIdFamilyChildCount.put((Id)agg.get('ETIN_Employee__c'),(Integer)agg.get('co'));
        }
        
      
        
         for (Contact con : conList){
            
             
            if(empIdFamilySpouseCount.containsKey(con.ETIN_Employee__c) && con.ETIN_Relation__c=='Spouse' && empIdFamilySpouseCount.get(con.ETIN_Employee__c) > 0 ){
                
               
                con.ID.addError('You cannot create more than 1 spouse for Insurance');
            }
             if(empIdFamilyChildCount.containsKey(con.ETIN_Employee__c) && con.ETIN_Relation__c=='Child' && empIdFamilyChildCount.get(con.ETIN_Employee__c) > 2 ){
                
                con.ID.addError('You cannot create more than 3 child for Insurance');
                
            } 
         }
        
        
        
        
     /*   List<Account> SpouseAccList = new List<Account>([Select id ,Name,  (Select id, Name From Contacts where ETIN_Relation__c='Spouse' AND RecordTypeId=:ContRecType) from Account Where id in:accIds]);
        
        List<Account> ChildAccList = new List<Account>([Select id ,Name,  (Select id, Name From Contacts where ETIN_Relation__c='Child' AND RecordTypeId=:ContRecType) from Account Where id in:accIds]);   
        
        for(Account acc : SpouseAccList){
            List<Contact> contactList = acc.Contacts;
            accIDConSizeSpouse.put(acc.Id,contactList.size());
        }
        
        for(Account acc : ChildAccList){
            List<Contact> contactList = acc.Contacts;
            accIDConSizeChild.put(acc.Id,contactList.size());
        }
        
        
        for (Contact con : conList){
            
            if(accIDConSizeSpouse.containsKey(con.AccountID) && accIDConSizeSpouse.get(con.AccountID) > 0 ){
                
                con.AccountId.addError('You cannot create more than 1 spouse for Insurance');
            }
            if(accIDConSizeChild.containsKey(con.AccountID) && accIDConSizeChild.get(con.AccountID) > 2 ){
                
                con.AccountId.addError('You cannot create more than 3 child for Insurance');
                
            } 
            
        } */
}
    public static void updateContactAccount(list<Contact> conList){
        set<id> conIds = new set<id>();
        map<id,id> conIdvsAccId = new map<id,id>();
        list<contact> conUpdateList = new list<contact>();
        for(Contact con : conList){
            
            conIds.add(con.Id);            
        }
      /*
        Id ContRecType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETIN_Employee_Family').getRecordTypeId();
        for(contact con : [select id,ETIN_Employee__r.accountId from contact where id=:conIds]){ //and  RecordTypeId=:ContRecType]
            
            conIdvsAccId.put(con.Id,con.ETIN_Employee__r.accountId );
            
        }
        
        Id userID = [select id,name from user where UserRole.name='Insurance Admin' limit 1].Id;
        
        for(Contact con : [select id from contact where id=:conIdvsAccId.keySet()]){ //
            
            
            contact cont = new contact();
            
            cont.Id = con.Id;
            cont.AccountId = conIdvsAccId.get(con.Id);
            if(userID != null || userID != ''){
            cont.OwnerId = userID;
            }
            conUpdateList.add(cont);
            
        }
        try {
            
            update conUpdateList;
            
        }catch (DmlException  e ) {
            
            system.debug('-Excep----'+e);
        }
        */
    }
    
}