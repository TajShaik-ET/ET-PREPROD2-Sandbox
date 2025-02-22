/*
Developer Name - Srihari Koyila
Developed Date - 20 June 2023
Class          - LookupLWCController
Test Class     - LookupLWCControllerTest  
****************************************************************************************************************/
public without sharing class LookupLWCController {
    @AuraEnabled(cacheable=true)
    public static List<Object> searchRecords(String searchKey, String objectApiName,List<Id> selectedIds ,String filters){
        
        String key ='%'+ searchKey + '%';
        String query = 'SELECT Id,Name FROM '+ objectApiName+' WHERE Name LIKE :key AND Id NOT IN :selectedIds' ;
        if(filters!=null){
            query+=' AND '+filters;
            
        }
        
        query+=' limit 5';
        return Database.query(query);
    }
    
    // public class LookupWrapper{
    //    @AuraEnabled public ID Id;
    //   @AuraEnabled public String Name;
    //   public LookupWrapper(User u){
    //      this.Id = u.ContactId;
    //      this.Name = u.Contact.Name;
    //  }
    // }
}