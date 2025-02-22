trigger ET_ContactTrigger on Contact (before Insert,before update,after update,after insert) {
    
 

   if(trigger.IsBefore && (trigger.IsInsert|| trigger.isUpdate)){

      
     //   ETIN_ContactInsuranceValidation.ContactValidation(trigger.new);
           
    }
    
    if((trigger.isAfter && trigger.isInsert)){ 
    
    
   //      ETIN_ContactInsuranceValidation.updateContactAccount(trigger.new); 
     Oracle_Integration_Services.integrateContactToOracleFromTrigger(Trigger.New);
        
    }
        
   
}