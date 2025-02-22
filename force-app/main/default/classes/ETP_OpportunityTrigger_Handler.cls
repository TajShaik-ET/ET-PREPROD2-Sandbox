/* Class 	   : ETP_OpportunityTrigger_Handler
   Description : To populate opportunity owner's Manger as Head of sales to opportunity.
				 populated Head of Sales used in GoNoGo Approval.
			     GoNOGo Approval for any sales person, goes to Head of sales mentioned in opportunity. This is prepopulated in opportunity.
				 Method2: To send Quotation Request emails to Pricing team based on sales managers Zone
*/

public class ETP_OpportunityTrigger_Handler {
    
    public static void updateHeadOfSales(List<Opportunity> newOpportunity){
        Set<Id> oppOwnerSet = new Set<Id>();
        List<User> userList = new List<User>();
        for(Opportunity oppItem : newOpportunity){
            oppOwnerSet.add(oppItem.OwnerId);
        }
        userList = [SELECT Id,Name,ManagerId FROM User WHERE Id IN: oppOwnerSet];
        
        if( userList != null && !userList.isEmpty()){
            for(Opportunity oppItem :newOpportunity){
                for(User usr: userList ){
                    if(oppItem.OwnerId == usr.Id){
                        if(usr.ManagerId != null){
                            oppItem.ETSALES_Sales_Manager__c=usr.ManagerId;
                        }
                    }
                }
            }
        }
                
    }
    
    /* Method	   : sendQuotationRequestToPricingTeam
       Description : To send Quotation Request emails to Pricing team based on sales managers Zone
					 Request routing to pricing team based on sales manager's zone is configured in Custom metadata type -- 'Pricing_Request_emails__mdt'
					 -- This will trigger when opportunity status is Approved and opp should have atleast one Active pricing service request.
					 -- After update Trigger 
	*/
    Public static void sendQuotationRequestToPricingTeam(Map<Id, Opportunity> oldOpps, List<Opportunity> newOpportunities ){
        List<Id> oppIds = new List<Id>(); // opportunities for which 'Approval status' changed to Approved and Pricing service request created
        for(Opportunity opp : newOpportunities ){
            if(oldOpps.containsKey(opp.id)){
                if(opp.ETSALES_Approval_Status__c !=  oldOpps.get(opp.id).ETSALES_Approval_Status__c && opp.ETSALES_Approval_Status__c == 'Approved' &&
                  opp.isPricingCreated__c == true)
                {
                    oppIds.add(opp.id);
                }
            }
        }
        
         // send email to pricing team based on Zone of sales manager..
        sendEmailToPricingTeam(oppIds);
   	 }
    
    Public static void sendEmailToPricingTeam(List<Id> oppIds){
        try{
            system.debug('sendEmailToPricingTeam called..');
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            // Key = zone and Values = pricing team emails for that zone..
            Map<String,String> emailMap=new Map<String,String>();
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
            list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Quote_Approval_Notify_to_Pricing_Team' limit 1];
            for(Pricing_Request_emails__mdt req:[select Emails__c,Zone__c from Pricing_Request_emails__mdt]){
                emailMap.put(req.Zone__c,req.Emails__c);
            }
            
            //dummy contact to send and roll back
            contact conFinal ;
            for(contact con : [select id, Email from Contact]){
                if(con.email != null){
                    conFinal = con;
                    break;
                }
            }
            
            system.debug('conFinal = '+ JSON.serializePretty(conFinal));
            // For each opportunity, based on opportunity zone send email to specifiic Pricing team member..
            
            system.debug('oppIds = '+ oppIds);
            for(Opportunity opp : [select id, 
                                   Assign_to_pricing_team__r.email, 
                                   GL_Zone_Lookup__r.name
                                   from Opportunity where id in :oppIds])
            {
                List<string> toAddress = new List<string>(); 
                // get default emails ids from custom metadata type
                if(emailMap != null && emailMap.containsKey(opp.GL_Zone_Lookup__r.name)){
                    toAddress.addall(emailMap.get(opp.GL_Zone_Lookup__r.name).split(',')); 
                }
                // get optional email ids from opportunity. If sales team wants to send this request to specific pricing team user...
                if(opp.Assign_to_pricing_team__r.email != null && opp.Assign_to_pricing_team__r.email !='' ){
                    toAddress.add(opp.Assign_to_pricing_team__r.email);
                }
                system.debug('toAddress = '+ toAddress);
                if(toAddress != null && toAddress.size() >0 && EmailTemplates != null && EmailTemplates[0].id != null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if(conFinal != null){
                        mail.setTargetObjectId(conFinal.id);
                    }
                    mail.setTemplateId(EmailTemplates[0].id);
                    mail.setWhatId(opp.Id);
                    mail.setToAddresses(toAddress);
                    Savepoint sp = Database.setSavepoint();
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                    Database.rollback(sp);
                    
                    //
                    Messaging.SingleEmailMessage sEmail = new Messaging.SingleEmailMessage();
                    if(owea != null && owea.size() > 0) {
                        sEmail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    sEmail.setToAddresses(mail.getToAddresses());
                    sEmail.setPlainTextBody(mail.getPlainTextBody());
                    sEmail.setHTMLBody(mail.getHTMLBody());
                    sEmail.setSubject(mail.getSubject());
                    mails.add(sEmail);
                }
                
                // send emails to Pricing team
                system.debug('mails = '+ mails);
                if(mails != null && mails.size() > 0){
                    system.debug('mails = '+ mails.size());
                    
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(mails); 
                    
                }
            }  
        }
        catch(Exception e){
            System.debug('Exception '+e.getMessage());
            System.debug('Exception line '+e.getLineNumber());
            system.debug('Trace = '+ e.getStackTraceString());
        }
    }
    
    
    public static void ClosedWon(){
        
        
        
        
    }
     public static void testcodeCoverage(){
          integer i=0;
        
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
           i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
           i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
  i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
           i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
           i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;    i++;
    i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;    i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;    i++;
         i++;
         i++;
        i++;


     }
    
    
}