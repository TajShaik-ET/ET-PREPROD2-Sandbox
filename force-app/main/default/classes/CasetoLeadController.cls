public class CasetoLeadController {   

    @AuraEnabled
    public static List<Case> fetchContactList(Id qId){
		system.debug('@@@@@@Inside'+qId);
        return [select Id,CaseNumber,First_Name__c,Last_Name__c,Email__c,Phone_Number__c,Account.Name,Contact.Name,Lead_Created__c,Description,Detail_business_Enquiry__c,ContactEmail,ContactMobile,Request_Category__c,Preferred_Location__c from Case where id=:qId Limit 1];             

    }
     @AuraEnabled
    public static void updateCase(Case caserecord){
		if(caserecord!=null) 
        caserecord.Lead_Created__c= true;
        update caserecord;
   
    }

}