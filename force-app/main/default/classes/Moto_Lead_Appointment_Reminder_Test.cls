@isTest
public class Moto_Lead_Appointment_Reminder_Test {
    
    public static testMethod void testschedule() {
        Test.StartTest();
        lead le =new lead();
        le.LastName = 'test';
        le.Email ='test@gmail.com';
        le.LeadSource='Website';
        le.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Automotive Dealership - Vehicle Inquiry/Trade-In').getRecordTypeId();
        le.Mobile_Number__c ='+971558656023';
        le.Appointment_Date__c = system.now();
        le.Appointment_Status__c='Confirmed';
        insert le;   
        Test.setMock(HttpCalloutMock.class, new Moto_SMS_MockHttpResponseGenerator());
        Moto_Lead_Appointment_Reminder_Handler testsche = new Moto_Lead_Appointment_Reminder_Handler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}