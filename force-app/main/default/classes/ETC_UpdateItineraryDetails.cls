public class ETC_UpdateItineraryDetails {
    
    @AuraEnabled
    public static ETCAR_Service_Request_Line_Item__c getRequestDetials(String recId) {  
        
        return [ SELECT Id, Name, ETST_Pick_Up_From__c, ETST_Service_Type__c FROM ETCAR_Service_Request_Line_Item__c WHERE Id =: recId ];   
    }  
    @AuraEnabled
    public static String getAddressSet(String SearchText){
        return ETST_AddressSearchController.getAddressSet(SearchText);
    } 
    @AuraEnabled
    public static String getAddressDetailsByPlaceId(String PlaceID){
        return ETST_AddressSearchController.getAddressDetailsByPlaceId(PlaceID);
    }
    /*@AuraEnabled
    public static List<ETST_Payment__c> getPaymentHistory(Date stDate, Date enDate){
        system.debug('stDate '+stDate+' enDate '+enDate);
        String userAccountId=ETC_UtilityClass.getAccountId();
        String errStr;
        Id carServicesRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
        try{
            // String userAccountId=getAccountId();   
            String qryString = 'Select Id,name,ETST_Amount__c,CreatedDate,ETST_Payment_Mode__c,ET_Service_Request__r.ET_Account__r.Name,ETST_Payment_State__c FROM ETST_Payment__c where ET_Service_Request__r.ET_Account__c =:userAccountId AND (ET_Service_Request__r.RecordTypeId=:rntRecordTypeId OR ET_Service_Request__r.RecordTypeId=:carServicesRecordTypeId)';
            if(stDate!=NULL && enDate!=NULL)
                qryString += ' AND CreatedDate >=:stDate AND CreatedDate <=:enDate';
            qryString +=+' order by CreatedDate desc';
            system.debug('qryString '+qryString);
            List<ETST_Payment__c> myPayments = Database.query(qryString);
            return myPayments;
        }catch (Exception e) {
            errStr = '';// JSON.serialize(ETI_B2B_VehicleController.buildErrorResponse('getPaymentHistory', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
    }*/
}