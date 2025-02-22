@isTest
public class Moto_SendSMS_Opp_HandlerTest {
    
    public static testMethod void sendSmsEmail() {
        
        Test.StartTest();
        Account acc = new Account();
        acc.lastName = 'TestName';
        acc.firstName = 'TestName';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        acc.PersonEmail ='Test@fma.com';
        acc.PersonMobilePhone ='0558656023';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.accountId = acc.Id;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Automotive Service Center & Body Shop').getRecordTypeId();
        opp.name ='testOpp';
        opp.StageName='Service Booking';        
        opp.CloseDate = system.today()+4;
        insert opp;
        
        opp.StageName ='Waiting for Estimate';
        update opp;
        Test.setMock(HttpCalloutMock.class, new Moto_SMS_MockHttpResponseGenerator());
        Moto_SendSMS_Opp_Handler.sendSMStoCustomer(new list<id>{opp.Id});
        test.stoptest();
    }
    public static testMethod void sendSmsEmailTemp2() {
        
        Test.StartTest();
        Account acc = new Account();
        acc.lastName = 'TestName';
        acc.firstName = 'TestName';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        acc.PersonEmail ='Test@fma.com';
        acc.PersonMobilePhone ='0558656023';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.accountId = acc.Id;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Automotive Service Center & Body Shop').getRecordTypeId();
        opp.name ='testOpp';
        opp.Work_Order_Number__c = '45444';
        opp.StageName='Qualification';        
        opp.CloseDate = system.today()+4;
        insert opp;
        
        opp.StageName ='Vehicle Delivery';
        update opp;
        Test.setMock(HttpCalloutMock.class, new Moto_SMS_MockHttpResponseGenerator());
        Moto_SendSMSEMail_Opp_Handler_Template1.sendSMStoCustomer(new list<id>{opp.Id});
        test.stoptest();
    }

}