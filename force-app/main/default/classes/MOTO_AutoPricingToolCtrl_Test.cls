@isTest
public class MOTO_AutoPricingToolCtrl_Test {
    
    @isTest static void Method1() {
        
        Auto_Pricing_Details__c autp = new Auto_Pricing_Details__c();
        autp.Make__c = 'BMW';
        autp.Model__c='1-Series';
        
        insert autp;
        
        Test.startTest();
        MOTO_AutoPricingToolCtrl.getAutoPricingDetails('make', 'model', 2012, 'dealerName',1000,2000,'1_hour_ago');
        MOTO_AutoPricingToolCtrl.getMakeVsModel();
        
        Test.stopTest();
    }
    
}