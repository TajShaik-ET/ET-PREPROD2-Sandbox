/**
* Author: Janardhan Muddana
* CreatedDate: 18/07/2022
* Desc: this is used to send sms msg to customer using smsshastra api.
* 
* */
@isTest
public class Moto_SendSMS_Test {
    
    private static testmethod void sendSMS(){
        lead le = new lead();
        le.LastName = 'test';
        le.Email ='test@gmail.com';
        le.LeadSource='Website';
        le.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Automotive Dealership - Vehicle Inquiry/Trade-In').getRecordTypeId();
        le.Mobile_Number__c ='+971558656023';
        insert le;
        le.Appointment_Date__c = system.now()+4;
        le.Appointment_Status__c='Confirmed';
        update le;
            
        test.starttest();
        
        Test.setMock(HttpCalloutMock.class, new Moto_SMS_MockHttpResponseGenerator());
        Moto_SendSMS_LeadCreation.sendSMSOnCreation(new list<id>{le.Id});
        Moto_SendSMS_LeadAppointmentCreation.sendSMStoCustomer(new list<id>{le.Id});
        Test.stoptest();
    }
    

}