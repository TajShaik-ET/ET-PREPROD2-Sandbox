@isTest
public class GIN_AutoEmailSenderClsTest {
    
    public static testmethod void autoEmailCls(){
        
        InsuranceAutoTriggerEmails__c ins = new InsuranceAutoTriggerEmails__c();
        ins.name='Rule1';
        ins.Active__c=true;
        ins.Email_ID__c='Jana@test.com';
        ins.Email_Template_Name__c='InsuranceRenewalReminder';
        ins.Trigger_Date__c = system.today();        
        insert ins;
        
        test.startTest();
        SchedulableContext sc = null;
        GIN_AutoEmailSenderCls cls = new GIN_AutoEmailSenderCls();
        cls.execute(sc);
        test.stopTest();
        
    }

}