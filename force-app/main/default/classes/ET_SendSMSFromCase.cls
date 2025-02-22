/********************************
*Class has been created to send SMS from Case page layout
*Test Class Name: ET_SendSMSFromCase_Test
*Last Modified: 18 / 5/ 2021
********************************/
public class ET_SendSMSFromCase{
   @AuraEnabled(cacheable=true)
   public static List<ET_Service_Locations__mdt> getLocationDetails(){
       return [SELECT ID,Label,Address__c,Lat_Long__c FROM ET_Service_Locations__mdt LIMIT 2000];
   }
   
    @AuraEnabled
    public static String sendNotification(String subject,String recId){
        String mobileNumber = getMobileNumberFromCase(recId);
       if(mobileNumber != ''){
           ET_SendSMS_RequestAPI.execute_pt obj = new ET_SendSMS_RequestAPI.execute_pt();
           ET_SendSMS_API_Paramter.Output outpt = obj.execute('ET Cares',mobileNumber,subject); 
           return ( outpt.Status == 'S' ? outpt.Status : outpt.Message);
       }else
            return 'Mobile Number not found';
   } 
   
   Public static String getMobileNumberFromCase(String recId){
       String mobileNumber = ''; 
       Case c = [SELECT ID,AccountID,ContactID FROM Case WHERE ID=: recId];
       if(c.ContactID != null){
           Contact cont = [SELECT ID,AccountId,ETSALES_Mob_Country_Code__c,MobilePhone FROM Contact WHERE Id=: c.ContactId];
           if(cont.MobilePhone != null){
               mobileNumber = CaseTrigger_SMS_Handler.formatMobileNumber(cont.MobilePhone,cont.ETSALES_Mob_Country_Code__c);
           }
       }
       else{
               Account a = [Select ID,PersonMobilePhone,ETSALES_Mob_Country_Code__pc FROM Account WHERE ID=: c.AccountID];    
               mobileNumber = (a.PersonMobilePhone != null ? CaseTrigger_SMS_Handler.formatMobileNumber(a.PersonMobilePhone,a.ETSALES_Mob_Country_Code__pc) : '');
           }
       return mobileNumber; 
   }
}