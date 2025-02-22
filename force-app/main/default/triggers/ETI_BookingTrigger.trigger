trigger ETI_BookingTrigger on ETI_Booking__c (after Insert,after Update) {
    if(Trigger.isUpdate && Trigger.isAfter) {
        ETI_BookingInspectionHandler.SendTestResultCustomer(trigger.newMap, trigger.oldMap);
        ETI_BookingInspectionHandler.SendBookingConfirmationforExternal(trigger.newMap, trigger.oldMap);
        ETI_BookingInspectionHandler.cancelReceipt(trigger.newMap, trigger.oldMap);
        ETI_BookingInspectionHandler.BookingCancellationNotification(trigger.newMap, trigger.oldMap);
        ETI_SpeaBookingInspectionHandler.cancelSpeaReceipt(trigger.newMap, trigger.oldMap);
    }
    if(Trigger.isInsert && Trigger.isAfter) 
        ETI_BookingInspectionHandler.updateEncrypted(trigger.newMap);
}