trigger ETC_Service_Request_Trigger on ET_Service_Request__c (before insert,after insert, before update, after update) {
    
    switch on Trigger.operationType{
        
        when AFTER_UPDATE{
            ETC_ServiceRequestHandler.sendPaymentLinkRentalServices(Trigger.new, Trigger.oldMap);
            ETC_ServiceRequestHandler.createInvoiceForRentalServices(Trigger.new, Trigger.oldMap);
            ETC_ServiceRequestHandler.updateInvoiceAmount(Trigger.new, Trigger.oldMap);
            ETC_ServiceRequestHandler.confirmVechicleBookings(Trigger.new, Trigger.oldMap);
            ETC_ServiceRequestHandler.sendBookingCancellationToCustomer(Trigger.new, Trigger.oldMap);
            // ETC_ServiceRequestHandler.createReceiptForRentalServices(Trigger.new, Trigger.oldMap);
            // ETC_ServiceRequestHandler.bookingConfirmationEmail(Trigger.new, Trigger.oldMap);
            // ETC_ServiceRequestHandler.refundCalculate(Trigger.newMap, Trigger.oldMap);
        }
       
    }
    
}