/********************************************************************************************************************
Trigger Class : SalesVehicalInventoryTrgHnadler
Author        : Akash
Description   : Description
TestClass     : SalesVehicalInventryTrgHandlerTest
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date        Author            Details                                        
1.           v1.0             07/04/2023    Akash            Initial Version
2.           v2.0             11/04/2023   Janardhan         handleOnInsert - method is created
3.           v3.0             27/04/2023   Manisha           Commented Insert logic & Updated entry criteria in status change
4.           v4.0             16/05/2023   Janardhan         Added LastModifiedBy in Vehicle Status change notification
*******************************************************************************************************************/

public class SalesVehicalInventoryTrgHandler {
    public static void handleFieldChanges(List<ETM_Sales_Vehicle_Inventory__c> trgNew, Map<Id, ETM_Sales_Vehicle_Inventory__c> trgOldMap) {
        String emailbody = '';
        List<String> toRecipients = Label.VehicalInventoryEmailRecipient.split(',');      
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
        
        list<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:system.label.Moto_OrgWideEmail];
        
        // Check if the retail price field was updated for any of the vehicles
        for (ETM_Sales_Vehicle_Inventory__c vehicle : [select id,name,ETM_Price__c,ETM_Vehicle_Status__c,ETM_Vehicle_No__c,LastModifiedBy.Name from ETM_Sales_Vehicle_Inventory__c where id=:trgNew]) {
            ETM_Sales_Vehicle_Inventory__c oldVehInfo =trgOldMap.get(vehicle.Id);
            if (vehicle.ETM_Price__c != oldVehInfo.ETM_Price__c) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(toRecipients);
                email.setSubject('Vehicle Price Change Notification');
                email.setOrgWideEmailAddressId(owea[0].Id);
                String recordUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + oldVehInfo.Id;
                
                emailbody = '<html><body>';
                emailbody += '<p><i>Dear Team,</i></p>'; 
                emailbody += '<p><i>The retail price of ' +vehicle.Name +' with '+vehicle.ETM_Vehicle_No__c+ ' has been changed from ' +oldVehInfo.ETM_Price__c+ ' to '+vehicle.ETM_Price__c+ '.</i></p>';
                emailbody += '<p><a href="'+recordUrl+'">'+recordUrl+'</a></p>';
                emailbody +='<p><i>Thank You,</i></p>';
                emailbody +='<p><i>Marketing and Sales Team</i></p>';
                emailbody += '</body></html>'; 
                email.setHtmlBody(emailbody);
                
                emailList.add(email);
                
            }
             
            if((vehicle.ETM_Vehicle_Status__c!= oldVehInfo.ETM_Vehicle_Status__c) && vehicle.ETM_Vehicle_Status__c!='Rejected' && vehicle.ETM_Vehicle_Status__c!='Inactive-Reconditioning') {
              
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(toRecipients);
                email.setOrgWideEmailAddressId(owea[0].Id);
                email.setSubject('Vehicle Status Change Notification');
                String recordUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + oldVehInfo.Id;
                
                emailbody = '<html><body>';
                emailbody += '<p><i>Dear Team,</i></p>';
                emailbody += '<p><i> The status of  ' + vehicle.Name +' with ' + vehicle.ETM_Vehicle_No__c + ' has been changed from ' + oldVehInfo.ETM_Vehicle_Status__c + ' to '+ vehicle.ETM_Vehicle_Status__c + ' by ' + vehicle.LastModifiedBy.Name+'. </i></p>';
                emailbody +=  '<p><a href="'+recordUrl+'">'+recordUrl+'</a></p>';
                emailbody +='<p><i>Thank You,</i></p>';
                emailbody +='<p><i>Marketing and Sales Team</i></p>';
                emailbody += '</body></html>';
                email.setHtmlBody(emailbody);
                
                emailList.add(email);
                
            }
            
            //emailList.add(emailbody);
            if(emailList.size()>0){  
                Messaging.SendEmailResult[] result = Messaging.sendEmail(emailList);
                
                if (result[0].isSuccess()) {
                    System.debug('Email sent successfully');
                } else {
                    System.debug('Email failed to send: ' + result[0].getErrors()[0].getMessage());
                }
            }
        }
        
        
    }
 /*  public static void handleOnInsert(list<ETM_Sales_Vehicle_Inventory__c> trgNew){
        
        String emailbody = '';
        List<String> toRecipients = Label.VehicalInventoryEmailRecipient.split(',');      
        Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
        
        list<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address=:system.label.Moto_OrgWideEmail];
        for (ETM_Sales_Vehicle_Inventory__c vehicle : trgNew) {
            if(vehicle.ETM_Vehicle_Status__c=='Available'){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(toRecipients);
                email.setOrgWideEmailAddressId(owea[0].Id);
                email.setSubject('Vehicle Status Change Notification');
                String recordUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + vehicle.Id;
                
                emailbody = '<html><body>';
                emailbody += '<p><i>Dear Team,</i></p>'; 
                emailbody += '<p><i> The status of  ' + vehicle.Name +' with ' + vehicle.ETM_Vehicle_No__c + ' has been changed from null to '+ vehicle.ETM_Vehicle_Status__c +'.</i></p>';
                emailbody += '<p><a href="'+recordUrl+'">'+recordUrl+'</a></p>';
                emailbody +='<p><i>Thank You,</i></p>';
                emailbody +='<p><i>Marketing and Sales Team</i></p>';
                emailbody += '</body></html>';
                email.setHtmlBody(emailbody);
                
                emailList.add(email);
            }
         }
          if(emailList.size()>0)
          Messaging.SendEmailResult[] result = Messaging.sendEmail(emailList);
               
    } */

    
}