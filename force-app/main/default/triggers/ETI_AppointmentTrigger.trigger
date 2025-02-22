trigger ETI_AppointmentTrigger on ServiceAppointment (before insert , after update) {
    // before Trigger
    if(trigger.isbefore && trigger.isinsert){
        ETI_appointmentTriggerHandler.populateValuesinAppointment(trigger.new);
    }
     
    if(trigger.isAfter && trigger.isUpdate){
        system.debug('in after Trigger');
        ETI_appointmentTriggerHandler.handleAfterAppointmentInsert(trigger.oldMap, trigger.newMap);
    }
}