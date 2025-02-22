/**
* Author: Janardhan Muddana
* CreatedDate: 18/07/2022
* Desc: this is used to send sms msg to customer using smsshastra api.
* TestClass: Moto_SendSMS_Test
* */
public class Moto_SendSMS_LeadAppointmentCreation {
    
    @InvocableMethod 
    public static void sendSMStoCustomer(list<Id> smsRelRecIds){
        
        for(lead le : [Select id,Name,MobilePhone,Appointment_Date__c ,Appointment_Status__c,Moto_msg_DateTime__c from lead where Id=:smsRelRecIds]){
             string composedMsg ='';
            
            if(le.Appointment_Status__c == 'Confirmed'){                 
                composedMsg = 'Dear '+le.Name+',your appointment is confirmed for '+le.Moto_msg_DateTime__c+'. We look forward to serving you.';
            }else if(le.Appointment_Status__c == 'Rescheduled'){
                composedMsg = 'Dear '+le.Name+', your appointment has been rescheduled for '+le.Moto_msg_DateTime__c+'. We will send you a reminder SMS on the day of your appointment.';
            }else if(le.Appointment_Status__c == 'Cancelled'){
               composedMsg = 'Dear '+le.Name+', your appointment for '+le.Moto_msg_DateTime__c+' has been cancelled.';

            }
            
            if(le.MobilePhone != null && le.MobilePhone.length() >= 9 && le.Appointment_Date__c != null){
                system.debug('SMSAPI');
                sendSMSAPI(le.MobilePhone,composedMsg,system.label.Moto_SMS_SenderID);
            }            
        }
        
    }
    
    @future(callout = true)
    public static void sendSMSAPI(String mobNumber,String msg,String SenderId){
        
        string mobile = '';
        string finalmsg = msg.replace(' ','%20');   
        
        //Check Mobile Number Format
        mobile = mobNumber.replaceAll('[A-Za-z]', '');//remove any alphabets
        mobile = '971'+mobNumber.right(9);//It works for UAE Country only
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(system.label.Moto_SMS_EndpointURL+'senderid='+SenderId+'&mobileno='+mobile+'&msgtext='+finalmsg+'&priority=High&CountryCode=ALL');
        request.setMethod('GET');
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug(response);
        
    }
    
}