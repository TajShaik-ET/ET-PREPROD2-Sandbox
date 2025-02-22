/**
* Author: Janardhan Muddana
* CreatedDate: 19/07/2022
* Desc: this is used to send sms/eamil msg to customer using smsshastra api at 9 AM on appointment date
* TestClass:Moto_Lead_Appointment_Reminder_Test
* */
global class Moto_Lead_Appointment_Reminder_Handler Implements Schedulable{
    
    global void execute(SchedulableContext sc){
        sendReminder();
    }
    public static void sendReminder(){
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
        EmailTemplate template = [SELECT Id,Subject,DeveloperName, Body FROM EmailTemplate WHERE DeveloperName ='Lead_Appointment_Reminder'];
        list<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:system.label.Moto_OrgWideEmail];
        
        for(lead le : [select id,name,MobilePhone,email,Appointment_Date__c,Moto_Time__c,Moto_msg_DateTime__c from lead where Appointment_Date__c=Today AND (Appointment_Status__c='Confirmed' OR Appointment_Status__c='Rescheduled')]){
            
            string composedMsg = 'Dear '+le.Name+', this is a friendly reminder for your appointment today at  '+le.Moto_Time__c+'.  Here\'s the link to your branch bit.ly/3PKHKZH and we look forward to seeing you';
            
            if(le.MobilePhone != null && le.MobilePhone.length() >= 9 ){
                system.debug('SMSAPI');
                sendSMSAPI(le.MobilePhone,composedMsg,system.label.Moto_SMS_SenderID);
            }  
            //SendEmail Msg
            
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(template.Id,null,le.Id);
            email.toAddresses = new list<string>{le.email};
                if ( owea != null && owea.size() > 0 ) {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }              
            email.setSaveAsActivity(false);             
            email.setWhatId(le.Id);
            
            emailList.add(email);
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
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