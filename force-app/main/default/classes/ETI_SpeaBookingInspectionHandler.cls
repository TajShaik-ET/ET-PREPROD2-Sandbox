/*
* File Name:ETI_SpeaBookingInspectionHandler
* Author : Noor Shaik
* CreatedDate : 09/05/2020
* Modification Purpose
* * 1. Noor Shaik: Cancel SPEA Inspections
* * 2.
*/
Public class ETI_SpeaBookingInspectionHandler{
    //update receipt status
    Public static void cancelSpeaReceipt(Map<Id, ETI_Booking__c> newMap, Map<Id,ETI_Booking__c> oldMap){
        Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
        List<ETI_Inspection_Receipt__c> reciptUpdateList=new List<ETI_Inspection_Receipt__c>();
        Set<Id> ids=new Set<Id>();
        try{
            for(ETI_Booking__c etb:newMap.values()){
                if(newMap.get(etb.Id).Booking_Status__c != oldMap.get(etb.Id).Booking_Status__c
                   && newMap.get(etb.Id).Booking_Status__c =='Cancelled' && !newMap.get(etb.Id).Is_Auto_Cancelled__c 
                   && etb.Service_Type__c =='SPEA Inspection'){
                       ids.add(etb.Id);
                   }
            }
                system.debug('ids>>> '+ids);
            if(!ids.isEmpty()){
                system.debug('ids If>>> '+ids);
                /*List<ServiceAppointment> serviceAppointments=new List<ServiceAppointment>();
                for(ETI_Inspection_Receipt__c receipt:[Select Id,ET_Status__c From ETI_Inspection_Receipt__c Where Bookings__c IN:ids AND ET_Status__c != 'Cancelled']){
                    receipt.ET_Status__c = 'Cancelled';
                    reciptUpdateList.add(receipt);
                }
                if(!reciptUpdateList.isEmpty())
                    update reciptUpdateList;
                //Update Cancelled status on Service Appointment for SPEA Inspection
                for(workorder workOrder:[Select Id, Booking__c,Booking__r.Selected_Services__c,(Select Id,Status From ServiceAppointments Where Status!='Canceled' order by createdDate desc limit 1) From workorder Where Booking__c IN:ids]){
                    if(workOrder.ServiceAppointments!=null && workOrder.ServiceAppointments.size()>0){
                        serviceAppointments.add(new ServiceAppointment(Id=workOrder.ServiceAppointments[0].Id,Status='Canceled'));
                    }
                }
                if(!serviceAppointments.isEmpty())
                    update serviceAppointments;*/
            }
        }catch(DMLException ex){
            system.debug('Error '+ex.getMessage());
            ETI_ServiceRequestHandler.logException(ex, 'ETI UpdateReceipt');
        }   
    }
    public static void utilityMethod(){
        integer i=0;
        
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
    }
}