trigger ETST_StudentTrigger on ETST_Student__c (before insert, after insert, after update) {
    
    /* ET_Trigger_Deactivation__c objTriggerDeactivation = ET_Trigger_Deactivation__c.getValues('Deactivate Triggers'); 
if(objTriggerDeactivation.ETST_Student__c == false){
return;
} */
    switch on Trigger.operationType{
        when BEFORE_INSERT {
            System.debug('Before Insert');
        }
        when AFTER_INSERT {
            //ETST_ShareAccountsWithCoordinator.shareStudentsToCoordinator(Trigger.newMap, null);
            //ETST_StudentTriggerHandler.termsAndConditions(Trigger.new);
            //TermsandConditionsController.TermsandConditionsController(Trigger.new);
            //TermsandConditionsController tcinstance=new TermsandConditionsController();
            //TermsandConditionsController tcinstance1=new TermsandConditionsController(Trigger.new);
            //tcinstance.TermsandConditionsController(Trigger.new);
            ETST_StudentTriggerHandler.populateStudentSchool(Trigger.newMap); //Added by Sreelakshmi SK 4/5/23
        }
        when AFTER_UPDATE{
            System.debug('After Update');
      		ETST_StudentTriggerHandler.changeStudentSchool(trigger.newMap,trigger.oldMap); //Added by Sreelakshmi SK 23/3/23
        }
        
        when else{
            System.debug('Something went wrong');
        }
    }
    
    
}