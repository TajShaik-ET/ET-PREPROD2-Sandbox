public class ETST_RefundRequestController {
    @AuraEnabled(cacheable=true)
    public static List<ET_Refund__c> getRefundRequests( String searchKey, String sortBy, String sortDirection) {
        string refundRecordTypeId = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('ETST_School_Refund_Record_Type').getRecordTypeId();
        String query = 'SELECT Id, Name, ET_Refund_Amount__c,CreatedDate, ET_Payment__r.Name,ET_Refund_Status__c,ET_Service_Request__r.Name  FROM ET_Refund__c WHERE RecordTypeId=:refundRecordTypeId';
        system.debug('searchKey '+searchKey);
        if ( searchKey != null && searchKey != '' ) {
            String key = '%' + searchKey + '%';
            query += ' AND Name LIKE :key';
        }
        if ( sortBy != null && sortDirection != null ) {
            query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
        }
        system.debug('refQry-> '+query);
        return Database.query( query );
    }
    
    
}