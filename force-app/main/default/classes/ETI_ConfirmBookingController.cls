public class ETI_ConfirmBookingController {
    @auraEnabled
    public static String getBookingRecord(String recordId){
        try{
            System.debug('recordId ' + recordId);
            ETI_Booking__c booking =  [SELECT Booking_Status__c, Booking_Date__c, Preferred_Time__c, Inspector__c, Is_booking_Confirmed__c FROM ETI_Booking__c WHERE Id = :recordId][0];
            Boolean isEmptyVal = booking.Preferred_Time__c == '' || booking.Inspector__c == null ;
            if( booking.Booking_Status__c == 'Confirmed'  ){
                return 'Error';
            }else{
                
                return 'Success';
            }
        }catch(Exception e){
            System.debug(e.getMessage());
            return 'Somthing Went wrong';
        }
    }
    
}