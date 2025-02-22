public class syncWithOracleBtnCtrl {
    
    @auraEnabled
    public static void callERPAccountIntegration(Id AccountId){
        
        system.enqueueJob(new Account_SendToERP(AccountId));
        system.debug('--sync btn-'+AccountId);
    }

}