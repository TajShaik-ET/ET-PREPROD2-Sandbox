public  class ET_global_Event_Request_Controller {
   @AuraEnabled
    public static String createCaseWithRequests(String accountId, String contactId, String recordTypeId, String typeOfCase, String status, String statusCategory, String subject, List<ESE_Request_Line__c> eseRequestLines) {
        try {
            Case newCase = new Case(
                AccountId = accountId,
                ContactId = contactId,
                RecordTypeId = recordTypeId,
                Type_Of_Case__c = typeOfCase,
                Status = status,
                Status_Category__c = statusCategory,
                Subject = subject
            );
            insert newCase;
           
            List<ESE_Request_Line__c> linesToInsert = new List<ESE_Request_Line__c>();
            for (ESE_Request_Line__c line : eseRequestLines) {
                line.Case__c = newCase.Id;
                linesToInsert.add(line);
            }
            insert linesToInsert;
            return newCase.Id;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error creating case and request lines: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void setObjectToRecentItems(Id recordId) {
        if (!String.isBlank(recordId)) {
            Schema.SObjectType sObjectType = recordId.getSobjectType();
            String queryString = String.format('SELECT Id, Name FROM {0} WHERE Id =: recordId FOR VIEW', new List<Object>{sObjectType});
            Database.query(queryString);
            
        }
    }
 
    
}