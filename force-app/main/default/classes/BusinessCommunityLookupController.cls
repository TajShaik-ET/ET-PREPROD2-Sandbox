public class BusinessCommunityLookupController {
    @AuraEnabled
    public static List<sObject> fetchLookUpValues(String searchKeyWord, String ObjectName) {
        String searchKey = '%'+searchKeyWord+'%';   
        List<sObject> returnList = new List<sObject>(); 
        String sQuery =  'select id,Name from ' +ObjectName + ' where Name LIKE:searchKey order by createdDate DESC LIMIT 10';
        List<sObject> lstOfRecords = Database.query(sQuery);       
        for(sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        system.debug('returnList***'+returnList);
        return returnList;
    }
}