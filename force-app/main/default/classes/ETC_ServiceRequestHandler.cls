public class  ETC_ServiceRequestHandler {
    
    // ET Limo Services payment link information
    public static void sendPaymentLinkRentalServices(List<ET_Service_Request__c> newList, Map<Id,ET_Service_Request__c> oldMap){
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.ETC_OrgWideEmail];
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        Set<Id> updateCheckboxIds = new Set<Id>();
        List<ET_Service_Request__c> updateList = new List<ET_Service_Request__c>();
        string htmlBody;
        EmailTemplate template = [SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName ='ETC_Send_Payment_Link_Template'];
        for(ET_Service_Request__c req: newList){
            if(req.RecordTypeId == srRecordTypeId && req.ETC_Send_Payment_Link__c == true && oldMap.get(req.id).ETC_Send_Payment_Link__c!= true){
                List<string> toEmails= new List<string>();
                if(req.ETC_Customer_Email_Id__c!=null) toEmails.add(req.ETC_Customer_Email_Id__c);
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = toEmails;
                if ( owea != null && owea.size() > 0 ) {
                    message.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                message.setSubject(template.Subject);
                htmlBody=template.htmlValue;
                if(req.ETC_Account_Name__c!=null) htmlBody=template.htmlValue.replaceAll('<<AccountName>>',req.ETC_Account_Name__c);
                htmlBody=htmlBody.replaceAll('<<link>>',Label.ETCSendPaymentLink+'/etpayment/s/?id='+req.Id+'&src=etcar#');
                message.setHtmlBody(htmlBody);
                messages.add(message);
                updateCheckboxIds.add(req.Id);
            }
        }
        try{
            if(messages!= null &&  messages.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
            if(updateCheckboxIds !=null && updateCheckboxIds.size()>0){
                for(ET_Service_Request__c sr: [SELECT id,ETC_Send_Payment_Link__c FROM ET_Service_Request__c WHERE ID In:updateCheckboxIds]){
                    sr.ETC_Send_Payment_Link__c = false;
                    updateList.add(sr);
                }
                update updateList;
            }
        }catch(exception e){
            system.debug('exception '+e);
        }
    }
    

    public static void sendReceiptToCustomer(List<ET_Receipt__c> newList){
        string rcptRecTyeId = Schema.SObjectType.ET_Receipt__c.getRecordTypeInfosByDeveloperName().get('ET_Car_Services').getRecordTypeId(); 
        set<Id> reqIds = new Set<Id>();
        for(ET_Receipt__c rcpt : newList){
            if(rcpt.RecordTypeId == rcptRecTyeId){
                reqIds.add(rcpt.ET_Service_Request__c);
            }
        }
        if(!reqIds.isEmpty()){
            sendConfirmationEmail(reqIds);  
            sendMailToBOT(reqIds);
        } 
    }
    
    
    
    @future(callout=true)
    public static void sendConfirmationEmail(Set<id> reqIds){
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.ETC_OrgWideEmail];
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<string> toEmails= new List<string>();
        EmailTemplate template = [SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName ='ETCBookingConfirmationVF'];
        for(ET_Service_Request__c req: [SELECT Id,RecordTypeId,Name,ET_Account__r.RecordType.DeveloperName,ETC_Customer_Email_Id__c,ETC_Contact__r.Email,ET_Account__r.PersonEmail,ETC_Payment_Status__c,ETCAR_Request_Type__c FROM ET_Service_Request__c WHERE Id In:reqIds] ){
            system.debug('req = '+ JSON.serializePretty(req));
            if(req!=null && req.ETCAR_Request_Type__c=='Manual'){
                system.debug('Manual');
                if(req.ETC_Customer_Email_Id__c!=null) toEmails.add(req.ETC_Customer_Email_Id__c);
            }else if(req.ETCAR_Request_Type__c=='Online'){
                system.debug('Online Acc '+req.ET_Account__r.PersonEmail);
                system.debug('Online Con '+req.ETC_Contact__r.Email);
                if(req.ET_Account__r.RecordType.DeveloperName=='Person_B2C'){
                    if(req.ET_Account__c!=null) toEmails.add(req.ET_Account__r.PersonEmail);
                }else{
                    if(req.ETC_Contact__c!=null) toEmails.add(req.ETC_Contact__r.Email);
                } 
            }
            system.debug('toEmails '+toEmails);
            system.debug('orgwide '+owea.get(0).Id);
            system.debug('reqId '+req.Id);
            String vfPage='Payment Receipt';
            PageReference pdf = new PageReference(label.ETC_Payment_Site+'ETC_ReceiptPage');//Page.ETC_ReceiptPage;
            pdf.setRedirect(true); 
            pdf.getParameters().put('id',req.Id);
            Blob pdfContent;
            try {
                system.debug('pdf '+pdf);
                pdfContent = (Test.isRunningTest()) ? Blob.valueOf('Test') : pdf.getContent();
                string fileName=vfPage+'.pdf';
                Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
                att.setFileName(fileName);
                att.setBody(pdfContent);                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = toEmails;
                if ( owea != null && owea.size() > 0 ) {
                    message.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                // message.setSenderDisplayName('Emirates Transport');
                message.setSubject(template.Subject);
                message.setTemplateId(template.id);
                message.setSaveAsActivity(false);
                message.setTargetObjectId(userinfo.getUserId());
                message.setTreatTargetObjectAsRecipient(false);
                message.setWhatId(req.Id);
                message.setFileAttachments(new Messaging.EmailFileAttachment[] {att});
                messages.add(message);
            } catch (VisualforceException e) {
                System.debug('exc '+e);
                pdfContent = Blob.valueOf('Some Text');
            }
        }
        try{
            if(messages!=null &&  messages.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if (results!=null &&  !results.get(0).isSuccess()) {
                    System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                    String errorMessage = results.get(0).getErrors()[0].getMessage();
                    system.debug('errorMessage  = ' + errorMessage);
                    system.debug('errorTargetObjectId  = ' + results.get(0).getErrors()[0].getTargetObjectId());
                }
            }
        }catch(exception e){
            system.debug('Exception ='+ e.getMessage());
            system.debug('Exception Trace='+ e.getStackTraceString());
            system.debug('Exception line='+ e.getLineNumber());
        }
    }
     
    public static void sendBookingCancellationToCustomer(List<ET_Service_Request__c> newList, Map<Id,ET_Service_Request__c> oldMap){
        Set<Id> cancelReqIds = new Set<Id>();
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
        for(ET_Service_Request__c req : newList){
            if(req.RecordTypeId ==srRecordTypeId && req.ETC_Payment_Status__c == 'Refund Requested' && oldMap.get(req.id).ETC_Payment_Status__c!= req.ETC_Payment_Status__c){
                cancelReqIds.add(req.Id);
            }
        }  
        if(!cancelReqIds.isEmpty()) sendCancellationEmail(cancelReqIds);
    } 
    
    @future(callout=true)
    public static void sendCancellationEmail(Set<id> reqIds){
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.ETC_OrgWideEmail];
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<string> toEmails= new List<string>();
        EmailTemplate template = [SELECT Id,Subject,Body,HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName ='ETCBookingCancellationVF'];
        for(ET_Service_Request__c req: [SELECT Id,RecordTypeId,Name,ET_Account__r.RecordType.Name,ETC_Customer_Email_Id__c,ETC_Contact__r.Email,ET_Account__r.PersonEmail,ETC_Payment_Status__c,ETCAR_Request_Type__c FROM ET_Service_Request__c WHERE Id In:reqIds] ){
            system.debug('req = '+ JSON.serializePretty(req));
            if(req!=null && req.ETCAR_Request_Type__c=='Manual'){
                system.debug('Manual');
                if(req.ETC_Customer_Email_Id__c!=null) toEmails.add(req.ETC_Customer_Email_Id__c);
            }else if(req.ETCAR_Request_Type__c=='Online'){
                if(req.ET_Account__r.RecordType.Name=='Person (B2C)'){
                    if(req.ET_Account__c!=null) toEmails.add(req.ET_Account__r.PersonEmail);
                }else{
                    if(req.ETC_Contact__c!=null) toEmails.add(req.ETC_Contact__r.Email);
                } 
            }
            try {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = toEmails;
                if ( owea != null && owea.size() > 0 ) {
                    message.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                message.setSubject(template.Subject);
                message.setTemplateId(template.id);
                message.setSaveAsActivity(false);
                message.setTargetObjectId(userinfo.getUserId());
                message.setTreatTargetObjectAsRecipient(false);
                message.setWhatId(req.Id);
                messages.add(message);
            } catch (VisualforceException e) {
                System.debug('exc '+e);
            }
        }
        try{
            if(messages!=null &&  messages.size()>0){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if (results!=null &&  !results.get(0).isSuccess()) {
                    System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                    String errorMessage = results.get(0).getErrors()[0].getMessage();
                    system.debug('errorMessage  = ' + errorMessage);
                    system.debug('errorTargetObjectId  = ' + results.get(0).getErrors()[0].getTargetObjectId());
                }
            }
        }catch(exception e){
            system.debug('Exception ='+ e.getMessage());
            system.debug('Exception Trace='+ e.getStackTraceString());
            system.debug('Exception line='+ e.getLineNumber());
        }
    }
    
  /*  public static void sendBookingsMailToRPABot(Set<id> reqIds){
        Decimal bkngsCount = 0;
        for(ET_Service_Request__c req : [SELECT Id, ETC_Count_of_Confirmed_Bookings__c FROM ET_Service_Request__c WHERE Id In: reqIds]){
            bkngsCount += req.ETC_Count_of_Confirmed_Bookings__c;
            System.debug('bkngsCount '+bkngsCount);
        }
        
        if(bkngsCount != 0){
            sendMailToBOT(reqIds);
        }
        
    } */
    
    @future(callout=true)
    public static void sendMailToBOT(Set<id> reqIds){

        List<Messaging.SingleEmailMessage> messagesList = new List<Messaging.SingleEmailMessage>();
        List<string> toEmails= System.label.ETC_RPABotMailAddress.split(',');
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.ETC_OrgWideEmail];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toEmails);
        mail.setSubject( 'Vehicle Bookings Created' );
        mail.setHtmlBody( 'Please find the attachment for latest bookings' );
        String contentCSV = '';
        for ( ETCAR_Service_Request_Line_Item__c vBkng: [ SELECT ETC_Customer_Name__c,ETC_BOT_Customer_Name__c,ETC_Customer_Sub_Account_Name__c,ETC_Requester__c,ETC_Guest_Name__c,ETC_Vehicle_Type__c,ETC_Duration__c,ETC_Pick_UP_Date_Time_BOT__c,ETC_Passenger_Mobile_Number__c,
                                                         ETST_Pick_Up_From__c,ETST_Drop_Off_To__c,ETCAR_Pickup_Zone__c,ETCAR_Drop_Off_Zone__c,ETC_Region__c,ETC_Department__c,ETC_Section__c,ETC_Unit__c,ETC_Base_Fare__c,ETC_Payment_Type__c,ETC_Flight_Number__c,
                                                         ETC_Is_Special_Request_BOT__c,ETC_Booking_Group_Name__c,ETC_Remarks__c,ETC_Instructions_To_Driver__c,Name
                                                         FROM ETCAR_Service_Request_Line_Item__c 
                                                         WHERE ETCAR_Service_Request__c in: reqIds AND ETCAR_Service_Request__r.ETC_Post_Service_Payment__c!=true AND ETCAR_Status__c =:'Booking Confirmed' AND ETST_Service_Type__c != 'Rental' ]) {
                                                             
                                                             
            contentCSV += vBkng.ETC_BOT_Customer_Name__c + ',' + vBkng.ETC_Customer_Sub_Account_Name__c + ',' + vBkng.ETC_Requester__c + ',' + vBkng.ETC_Guest_Name__c+ ',' + vBkng.ETC_Vehicle_Type__c+ ',' + vBkng.ETC_Duration__c+ ',' + vBkng.ETC_Pick_UP_Date_Time_BOT__c+ ',' + ' '+ ',' + vBkng.ETC_Passenger_Mobile_Number__c+ ',' + vBkng.ETST_Pick_Up_From__c.replaceAll(',','')+ ',' + vBkng.ETST_Drop_Off_To__c.replaceAll(',','')+ ',' + vBkng.ETCAR_Pickup_Zone__c 
                + ',' + vBkng.ETCAR_Drop_Off_Zone__c+ ',' + vBkng.ETC_Region__c+ ',' + vBkng.ETC_Department__c+ ',' + vBkng.ETC_Section__c+ ',' + vBkng.ETC_Unit__c+ ',' + vBkng.ETC_Base_Fare__c+ ',' + vBkng.ETC_Payment_Type__c+ ',' + vBkng.ETC_Flight_Number__c+ ',' + vBkng.ETC_Is_Special_Request_BOT__c+ ',' + vBkng.ETC_Booking_Group_Name__c+ ',' + vBkng.ETC_Remarks__c+ ',' + vBkng.ETC_Instructions_To_Driver__c+ ',' + vBkng.Name+'\n';
        }
        String content = 'Customer Name,Customer Sub Account Name,Requester,Passenger,Vehicle Type,Order Type,PickUpTimeB,Trip Duration,Passenger Mobile Number,Pick-Up LandMark,Drop-Off Landmark,Pick-Up Zone,Drop-Off Zone,Region,Department,Section,Unit,Base Fare,PaymentType,Flight Number,Is Special Request,Booking Group Name,Remarks,Instructions To Driver,Reference Number\n' + contentCSV;
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName( 'VehicleBookings.csv' );
        attachment.setBody( Blob.valueOf( content ) );
        if ( owea != null && owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        mail.setTargetObjectId(userinfo.getUserId());
        mail.setSaveAsActivity(false);
        mail.setFileAttachments( new Messaging.EmailFileAttachment[]{ attachment } );
      if(String.isNotEmpty(contentCSV))  Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
    }
    

    //ET Limo Services invoice record creation
    public static void createInvoiceForRentalServices(List<ET_Service_Request__c> newList, Map<Id,ET_Service_Request__c> oldMap){
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
        Id recordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Services').getRecordTypeId();
        List<Invoice__c> invList = new List<Invoice__c>();
        
      
        for(ET_Service_Request__c req : newList){
            if(req.RecordTypeId ==srRecordTypeId && req.ETC_Payment_Status__c == 'Payment Success' && oldMap.get(req.id).ETC_Payment_Status__c!= 'Payment Success'){
                Invoice__c inv = new Invoice__c();
                inv.RecordTypeId = recordTypeId;
                inv.Service_Request__c = req.Id;
                inv.Transaction_Type__c = 'Limo and Rental Services';
                inv.Branch_Name__c = 'Dubai';
                inv.Department__c = req.ETC_Service_Type__c;
                inv.Total_Inv_Amount__c = req.ETC_Billing_Total__c;
                invList.add(inv);
            }
        }
        if(invList != null && invList.size()>0){
            try{
                system.debug('Invoice');
                insert invList;
            }catch(exception e){
                system.debug('Exception-> '+e);
            }
        }
    }
    
     public static void updateInvoiceAmount(List<ET_Service_Request__c> newList, Map<Id,ET_Service_Request__c> oldMap){
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
       
        List<Invoice__c> invList = new List<Invoice__c>();
        List<id> serviceReqIds = new List<id>();
      
        for(ET_Service_Request__c req : newList){
            if( req.ETST_Fare_Charges__c != oldMap.get(req.id).ETST_Fare_Charges__c){
               serviceReqIds.add(req.Id);
            }
        }
         for(Invoice__c inv : [SELECT Total_Inv_Amount__c, Service_Request__r.ETST_Fare_Charges__c FROM Invoice__c WHERE Service_Request__c IN :serviceReqIds]){
             inv.Total_Inv_Amount__c = inv.Service_Request__r.ETST_Fare_Charges__c;
             invList.add(inv);
         }
        if(invList != null && invList.size()>0){
            try{
                system.debug('Invoice');
                update invList;
            }catch(exception e){
                system.debug('Exception-> '+e);
            }
        }
    }
    
    public static void confirmVechicleBookings(List<ET_Service_Request__c> newList, Map<Id,ET_Service_Request__c> oldMap){
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
        List<ETCAR_Service_Request_Line_Item__c> vBnkgList = new List<ETCAR_Service_Request_Line_Item__c>();
        for(ET_Service_Request__c req : [SELECT Id,RecordTypeId,ETC_Payment_Status__c,(SELECT Id,ETCAR_Status__c FROM Service_Request_Line_Items__r WHERE ETCAR_Status__c != 'Cancelled' AND ETCAR_Selecetd_Car__c != null) FROM ET_Service_Request__c WHERE ID In : newList]){
            if(req.RecordTypeId ==srRecordTypeId && req.ETC_Payment_Status__c == 'Payment Success' && oldMap.get(req.id).ETC_Payment_Status__c!= 'Payment Success'){
                for(ETCAR_Service_Request_Line_Item__c vBnkg : req.Service_Request_Line_Items__r){
                    vBnkg.ETCAR_Status__c = 'Booking Confirmed';
                    vBnkgList.add(vBnkg);
                }
            }
        }
        if(vBnkgList!= null && vBnkgList.size()>0){
            update vBnkgList;
        }
    }
    
    @AuraEnabled
    public static string updatePostServicePayment(String recId){
        ET_Service_Request__c req = [Select id,ETC_Post_Service_Payment__c from ET_Service_Request__c where Id=:recId];
        req.ETC_Post_Service_Payment__c = true;
        update req;
        Set<Id> reqIds = new Set<Id>{recId};
            List<ETCAR_Service_Request_Line_Item__c> vBkngList = new List<ETCAR_Service_Request_Line_Item__c>();
        for (ETCAR_Service_Request_Line_Item__c vBkng: [SELECT Id,ETCAR_Status__c FROM ETCAR_Service_Request_Line_Item__c WHERE ETCAR_Service_Request__c=:recId]){
            vBkng.ETCAR_Status__c = 'Booking Confirmed';
            vBkngList.add(vBkng);
        }
        if(!vBkngList.isEmpty()) update vBkngList;
        sendMailToBOTPostPayment(reqIds);
        system.debug('reqIds '+reqIds);
        return recId;
    }
    
    @future(callout=true)
    public static void sendMailToBOTPostPayment(Set<id> reqIds){

        List<Messaging.SingleEmailMessage> messagesList = new List<Messaging.SingleEmailMessage>();
        List<string> toEmails= System.label.ETC_RPABotMailAddress.split(',');
        OrgWideEmailAddress[] owea = [SELECT Id,Address FROM OrgWideEmailAddress WHERE DisplayName =:System.Label.ETC_OrgWideEmail];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toEmails);
        mail.setSubject( 'Vehicle Bookings Created' );
        mail.setHtmlBody( 'Please find the attachment for latest bookings' );
        String contentCSV = '';
        for ( ETCAR_Service_Request_Line_Item__c vBkng: [ SELECT ETC_Customer_Name__c,ETC_BOT_Customer_Name__c,ETC_Customer_Sub_Account_Name__c,ETC_Requester__c,ETC_Guest_Name__c,ETC_Vehicle_Type__c,ETC_Duration__c,ETC_Pick_UP_Date_Time_BOT__c,ETC_Passenger_Mobile_Number__c,
                                                         ETST_Pick_Up_From__c,ETST_Drop_Off_To__c,ETCAR_Pickup_Zone__c,ETCAR_Drop_Off_Zone__c,ETC_Region__c,ETC_Department__c,ETC_Section__c,ETC_Unit__c,ETC_Base_Fare__c,ETC_Payment_Type__c,ETC_Flight_Number__c,
                                                         ETC_Is_Special_Request_BOT__c,ETC_Booking_Group_Name__c,ETC_Remarks__c,ETC_Instructions_To_Driver__c,Name
                                                         FROM ETCAR_Service_Request_Line_Item__c 
                                                         WHERE ETCAR_Service_Request__c in: reqIds AND ETCAR_Status__c =:'Booking Confirmed' AND ETST_Service_Type__c != 'Rental' ]) {
                                                             
                                                             
            contentCSV += vBkng.ETC_BOT_Customer_Name__c + ',' + vBkng.ETC_Customer_Sub_Account_Name__c + ',' + vBkng.ETC_Requester__c + ',' + vBkng.ETC_Guest_Name__c+ ',' + vBkng.ETC_Vehicle_Type__c+ ',' + vBkng.ETC_Duration__c+ ',' + vBkng.ETC_Pick_UP_Date_Time_BOT__c+ ',' + ' '+ ',' + vBkng.ETC_Passenger_Mobile_Number__c+ ',' + vBkng.ETST_Pick_Up_From__c.replaceAll(',','')+ ',' + vBkng.ETST_Drop_Off_To__c.replaceAll(',','')+ ',' + vBkng.ETCAR_Pickup_Zone__c 
                + ',' + vBkng.ETCAR_Drop_Off_Zone__c+ ',' + vBkng.ETC_Region__c+ ',' + vBkng.ETC_Department__c+ ',' + vBkng.ETC_Section__c+ ',' + vBkng.ETC_Unit__c+ ',' + vBkng.ETC_Base_Fare__c+ ',' + vBkng.ETC_Payment_Type__c+ ',' + vBkng.ETC_Flight_Number__c+ ',' + vBkng.ETC_Is_Special_Request_BOT__c+ ',' + vBkng.ETC_Booking_Group_Name__c+ ',' + vBkng.ETC_Remarks__c+ ',' + vBkng.ETC_Instructions_To_Driver__c+ ',' + vBkng.Name+'\n';
        }
        String content = 'Customer Name,Customer Sub Account Name,Requester,Passenger,Vehicle Type,Order Type,PickUpTimeB,Trip Duration,Passenger Mobile Number,Pick-Up LandMark,Drop-Off Landmark,Pick-Up Zone,Drop-Off Zone,Region,Department,Section,Unit,Base Fare,PaymentType,Flight Number,Is Special Request,Booking Group Name,Remarks,Instructions To Driver,Reference Number\n' + contentCSV;
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName( 'VehicleBookings.csv' );
        attachment.setBody( Blob.valueOf( content ) );
        if ( owea != null && owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        mail.setTargetObjectId(userinfo.getUserId());
        mail.setSaveAsActivity(false);
        mail.setFileAttachments( new Messaging.EmailFileAttachment[]{ attachment } );
      if(String.isNotEmpty(contentCSV))  Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
    }
}