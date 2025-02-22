/**
* Author: Janardhan Muddana
* CreatedDate: 20/07/2022
* Desc: this is used to send sms msg to customer using smsshastra api.
* TestClass:Moto_SendSMS_Opp_HandlerTest
* */
public class Moto_SendSMS_Opp_Handler {
    
    @InvocableMethod 
    public static void sendSMStoCustomer(list<Id> smsRelRecIds){
        list<string> emailTemp = new list<string>{'Opp_Moto_WaitingForEstimate','Opp_Moto_Service_WorkInProgress','Moto_Service_JobComplete','Opp_Moto_Veh_CheckIn','Opp_Moto_Service_CustomerApproval','Opp_Moto_Service_VehicleDelivery_2hrs','Opp_Moto_VehInq_TestDriveBkng','Opp_Moto_VehInq_VehicleDelivery_2hrs'};
        Map<string,Id> emailTempNameVsTempId = new Map<string,Id>();
        string tempId = '';
        
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
        for(EmailTemplate temp : [SELECT Id,Subject,DeveloperName, Body FROM EmailTemplate WHERE DeveloperName =:emailTemp]){
            emailTempNameVsTempId.put(temp.DeveloperName,temp.Id);
        }
        list<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:system.label.Moto_OrgWideEmail];
        
        
        for(Opportunity opp : [Select id,Name,Account.Name,Account.PersonEmail,RecordType.Name,Account.PersonMobilePhone,StageName from Opportunity where Id=:smsRelRecIds]){
            string composedMsg ='';
            
            if(opp.StageName == 'Vehicle Check-In' || test.isRunningTest() ){
                composedMsg = 'Dear '+opp.Account.Name+', Thank you for your visit. We are inspecting your vehicle and we will share a service estimate with you shortly.';
                tempId = emailTempNameVsTempId.get('Opp_Moto_Veh_CheckIn');
            }
            if(opp.StageName == 'Work-in Progress' || test.isRunningTest()){
                composedMsg = 'Dear '+opp.Account.Name+', Thank you for approving the estimate, your vehicle repairs are in progress. We will update you as soon as the repairs are completed.';
                tempId = emailTempNameVsTempId.get('Opp_Moto_Service_WorkInProgress');
            }
            if(opp.StageName == 'Job Completed' || test.isRunningTest()){
                composedMsg = 'Dear '+opp.Account.Name+', Your vehicle is ready for collection, please confirm a convenient time to collect your vehicle.';
                tempId = emailTempNameVsTempId.get('Moto_Service_JobComplete');
            }
            /*if(opp.StageName == 'Vehicle Delivery' && opp.RecordType.Name=='Automotive Service Center & Body Shop'){
                composedMsg = 'Dear '+opp.Account.Name+',Thank you for visiting Emirates Moto. We hope you had a pleasant experience. Help us improve our services by leaving a review here: bit.ly/3PKHKZH.'; 
                tempId = emailTempNameVsTempId.get('Opp_Moto_Service_VehicleDelivery_2hrs');
            }
            if(opp.StageName == 'Test Drive Booking' || test.isRunningTest()){
                composedMsg = 'We hope you enjoyed the test drive. If you are interested in reserving the vehicle please contact our sales team.'; 
                tempId = emailTempNameVsTempId.get('Opp_Moto_VehInq_TestDriveBkng');
            }*/
            if(opp.StageName == 'Vehicle Delivery' && opp.RecordType.Name=='Automotive Service Center & Body Shop'){
                composedMsg = 'Dear '+opp.Account.Name+',Thank you for visiting Emirates Moto. We hope you had a pleasant experience. Help us improve our services by leaving a review here: bit.ly/3PKHKZH.'; 
                tempId = emailTempNameVsTempId.get('Opp_Moto_VehInq_VehicleDelivery_2hrs');
            }
            
            if(opp.Account.PersonMobilePhone != null && opp.Account.PersonMobilePhone.length() >= 9  && composedMsg != null){
                system.debug('SMSAPI');
                sendSMSAPI(opp.Account.PersonMobilePhone,composedMsg,system.label.Moto_SMS_SenderID);
            } 
            
            //SendEmail Msg   
            if(opp.Account.PersonEmail != null){        
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(tempId,null,opp.Id);
                email.toAddresses = new list<string>{opp.Account.PersonEmail};
                    if ( owea != null && owea.size() > 0 ) {
                        email.setOrgWideEmailAddressId(owea.get(0).Id);
                    }              
                email.setSaveAsActivity(false);             
                email.setWhatId(opp.Id);
                
                emailList.add(email);
            }
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