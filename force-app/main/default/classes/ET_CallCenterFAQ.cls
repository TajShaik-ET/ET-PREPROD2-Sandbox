public class ET_CallCenterFAQ {

    @AuraEnabled(cacheable=true)
    public static List<SObject> fetchRecords(String strQuery) {
    System.debug('strQuery: '+strQuery);
    try {
        List<SObject> recordsDataList = new List<SObject>();
        for(SObject s : Database.query(strQuery)) {
            recordsDataList.add(s);
        }
        System.debug('recordsDataList: '+recordsDataList);
        return recordsDataList;
    } catch (Exception err) {
        System.debug('err: '+err.getMessage());
        if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
            throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
        } else {
            throw new AuraHandledException(err.getMessage());
        }
    }
   }

}