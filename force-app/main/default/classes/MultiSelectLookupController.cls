public with sharing class MultiSelectLookupController {
 
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String values, String filterAdditionalField, String filterValue) {
        system.debug('objectName: '+objectName);  
        system.debug('filterField: '+filterField);
        system.debug('searchString: '+searchString);
        system.debug('filterAdditionalField: '+filterAdditionalField);
        system.debug('values: '+values);
        system.debug('filterValue: '+filterValue);
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
           
            List<String> selectedvalues = (List<String>) JSON.deserialize(values, List<String>.class);
            system.debug('selectedvalues: '+selectedvalues);
            String query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            if(selectedvalues != null && selectedvalues.size() > 0) {
                query += ' WHERE Id IN: selectedvalues LIMIT 49999';
            } else {
                query += ' WHERE '+filterField+
                 ' LIKE ' + '\'%' + String.escapeSingleQuotes(searchString.trim()) + '%\' ';
                if(filterAdditionalField != null && filterValue != null){
                    query += 'AND '+filterAdditionalField+'=: filterValue ';
                }
                query += 'LIMIT 49999';
            }
            System.debug('query '+query);
         for(SObject s : Database.query(query)) {
             recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
         }
            return recordsDataList;
     } catch (Exception err) {
      if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                //system.debug('---getMessage-'+err.getMessage());
                throw new AuraHandledException(err.getMessage());
            }
     }
    }
 
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}