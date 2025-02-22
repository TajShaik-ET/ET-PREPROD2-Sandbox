/***************************************

Class - ETST_AccountTriggerHandler 

Modifications: Janardhan - 15.02.2023 - Commented duplication rule
****************************************/
Public Class ETST_AccountTriggerHandler{
    Public static void restrictDupliateAccount(List<Account> newAccount){
       /* Set<String> setAccName = new Set<String>();
      
        for(Account a:newAccount){
            setAccName.add(a.Name+string.valueOf(a.recordTypeId));
          
        }
        //get all existing account in the system
        Set<String> setExtAccount = new Set<String>();
        for(Account a:[Select ID,Name,RecordTypeId FROM Account WHERE Name =: setAccName]){
            setExtAccount.add(a.Name+string.valueOf(a.RecordTypeId));
            
        }
        if(!setExtAccount.isEmpty()){
            for(Account a:newAccount){
                
                if(setExtAccount.contains(a.Name+string.valueOf(a.recordTypeId)))
                    a.Name.AddError('Account with the same name '+ a.Name +' is already exist in the system, Please select existing Account');
            }
        }*/
    }
}