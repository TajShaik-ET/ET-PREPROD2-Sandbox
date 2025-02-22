trigger ET_Registration_Req_Trigger on ET_Registration_Request__c (after insert) {
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            System.debug('Before Insert');
        }
        when AFTER_INSERT {
            System.debug('After Insert');
            ET_RegistrationController.notifyAction(Trigger.New);
        }
        when AFTER_UPDATE {
            System.debug('After Update');
        }
        when else{
            System.debug('Something went wrong');
        }
    }   
}