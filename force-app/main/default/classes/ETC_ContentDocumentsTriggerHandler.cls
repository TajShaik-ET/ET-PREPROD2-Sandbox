public class ETC_ContentDocumentsTriggerHandler {
    /* Method : To give file access to External Users when file is inserted in system
                Give Sharing access to  files inserted for -- 'ETCAR_Car__c' & 'ETCAR_Features__c'
     */
    public static void giveFileAccesstoExternalUsers(List<ContentDocumentLink> newdocs){
        
        String carPrefix = Schema.getGlobalDescribe().get('ETCAR_Car__c').getDescribe().getKeyPrefix();
        String featPrefix = Schema.getGlobalDescribe().get('ETCAR_Features__c').getDescribe().getKeyPrefix();
        
        //Added By Janardhan for Vehicle Insurance
         String vehInsReq = Schema.getGlobalDescribe().get('Correction_Cancel_Request__c').getDescribe().getKeyPrefix();
         String vehClaim = Schema.getGlobalDescribe().get('ETIN_Claim__c').getDescribe().getKeyPrefix();
         String vehInsPolicy = Schema.getGlobalDescribe().get('ETVIN_Vehicle_Insurance__c').getDescribe().getKeyPrefix();
         String hseInfo = Schema.getGlobalDescribe().get('HSE_Info__c').getDescribe().getKeyPrefix();
        
        
        for (ContentDocumentLink cdl : newdocs) {
            if (String.valueOf(cdl.LinkedEntityId).startsWithIgnoreCase(carPrefix) || 
                String.valueOf(cdl.LinkedEntityId).startsWithIgnoreCase(featPrefix) || 
                string.valueOf(cdl.LinkedEntityId).startsWithIgnoreCase(vehInsReq) || 
                string.valueOf(cdl.LinkedEntityId).startsWithIgnoreCase(vehClaim) ||
                 string.valueOf(cdl.LinkedEntityId).startsWithIgnoreCase(vehInsPolicy)||
                string.valueOf(cdl.LinkedEntityId).startsWithIgnoreCase(hseInfo)
               ) {
                cdl.Visibility = 'AllUsers';
            }                         
        }
    }
}