public class CICO_CustmLkupCtrl {
    
     @AuraEnabled
    public static list<account> getAcctFilterList(string searchWord){
        
        String queryStr;
        queryStr = 'SELECT Id,Name from Account where (Name LIKE  \'%'+ searchWord +'%\' OR ETIN_Employee_Id__c LIKE  \'%'+ searchWord +'%\') AND Type= \'Employee\' limit 5';
       
        return Database.Query(queryStr);
    }

}