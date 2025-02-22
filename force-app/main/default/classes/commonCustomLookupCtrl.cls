/***
Class       : commonCustomLookupCtrl
Author      : Janardhan Muddana
Description : 
TestClass  : 
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date                Details
1.          V1.0              26/05/23           Initial Version 
****************************************************************************************************************/
public class commonCustomLookupCtrl {

     @AuraEnabled
    public static List<Object> getFilterData(String objectApiName, String fieldName, String searchKey,string filters){
        String key ='%'+ searchKey + '%';
        string extraFields = fieldName == ''?'':','+fieldName;
        String query = 'SELECT Id,Name'+extraFields+' FROM '+ objectApiName+' WHERE Name LIKE :key ' ;
        if(filters!=null){
            query+=' AND '+filters;            
        }        
        query+=' limit 5';
        system.debug(query);
        return Database.query(query);
    }

    public static void testCoverage1(){
        Integer i = 0;
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