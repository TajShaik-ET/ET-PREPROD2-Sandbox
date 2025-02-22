public class ETC_AdminSettingsController {
    
    
    @AuraEnabled
    public static List <ETC_Limo_Refund_Settings__c> getRefundPolicies() {
        return [SELECT Id,Name,ETC_From__c,ETC_To__c,ETC_Percentage__c FROM ETC_Limo_Refund_Settings__c order by ETC_Percentage__c asc];
    }
    
    
    @AuraEnabled
    public static String saveRefundSetting( ETC_Limo_Refund_Settings__c data ) {
        
        ETC_Limo_Refund_Settings__c ref = new ETC_Limo_Refund_Settings__c();
        
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, 4);
        
        ref.Name = 'Refund '+randomNumber;
        ref.ETC_From__c = data.ETC_From__c;
        ref.ETC_To__c = data.ETC_To__c;
        ref.ETC_Percentage__c = data.ETC_Percentage__c;
        
        try {
            insert ref;
        }
        catch (Exception e) {
            
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
        }
        return null;
        
    }
    
    @AuraEnabled
    public static void updateRefundSetting(ETC_Limo_Refund_Settings__c Row ) {
       
        try{
            update Row;
        }catch(Exception e){
            system.debug('Insertion Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
     }
    
    @AuraEnabled
    public static void deleteRefundSettingRecord(ETC_Limo_Refund_Settings__c Row ) {
        
        try{
            delete Row;
        }catch(Exception e){
            system.debug('Deletion Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
        
    }  
    
}