public without sharing class customLookUpController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName,String fldApiName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = '%' + searchKeyWord + '%';
         String searchKey2 = '%rim%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id,ETT_Unique_Code__c from ' +ObjectName + ' where ETT_Item_Description__c LIKE: searchKey2  AND ' + fldApiName +' LIKE: searchKey order by createdDate DESC limit 5';
        system.debug('sQuery------>'+sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        system.debug('returnList------>'+returnList);
        return returnList;
    }
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues2(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey =  '%' + searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id,Name,Item_Code__c from '+ObjectName + ' where Item_Code__c LIKE :searchKey order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
      @AuraEnabled
    public static List <String> fetchToolsandMaterial(String itemCode) {
       
        List < String > returnList = new List < String > ();
        String sQuery =  'select id,ETT_Allocated_Units__c,ETT_Main_Stock_Units__c from ETT_Tools_Master__c where ETT_Unique_Code__c = :itemCode order by createdDate DESC limit 5';
        List < ETT_Tools_Master__c > lstOfRecords = Database.query(sQuery);
		returnList.add(String.valueOf(lstOfRecords[0].ETT_Main_Stock_Units__c));
        returnList.add(String.valueOf(lstOfRecords[0].ETT_Allocated_Units__c));
        return returnList;
    }
}