trigger ETIN_EmployeeFamilyObjTrg on ETIN_Employee_Family__c (before insert,before update) {
    
    ETIN_EmployeeFamilyObjValidation.ContactValidation(trigger.new);

}