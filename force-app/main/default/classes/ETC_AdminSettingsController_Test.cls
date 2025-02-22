@isTest
public class ETC_AdminSettingsController_Test {
    
    @isTest public static void adminSettingsTest(){
        ETC_Limo_Refund_Settings__c ref = new ETC_Limo_Refund_Settings__c(Name='Refund 1',etc_from__c='5',etc_to__c='23',etc_percentage__c=1);
        insert ref;
        ETC_Limo_Refund_Settings__c ref1 = new ETC_Limo_Refund_Settings__c(Name='Refund 2',etc_from__c='5',etc_to__c='23',etc_percentage__c=1);
        ETC_AdminSettingsController.getRefundPolicies();
        ETC_AdminSettingsController.saveRefundSetting(ref1);
        ref.ETC_From__c ='6';
        ETC_AdminSettingsController.updateRefundSetting(ref);
        ETC_AdminSettingsController.deleteRefundSettingRecord(ref);
        try{
            ETC_AdminSettingsController.updateRefundSetting(ref1);
            ETC_AdminSettingsController.deleteRefundSettingRecord(ref1);
        }catch(exception e){
            system.debug('exception-> '+e);
        }
    }
}