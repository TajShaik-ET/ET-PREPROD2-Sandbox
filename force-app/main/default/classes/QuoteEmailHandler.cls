/***********************************************************************************************************************
* Name               : QuoteEmailHandler                                                                               *
* Test Class         : QuoteEmailHandlerTest                                                                           *
* Description        : Apex Class to Send Emails on Quote Creation.                                                    *
* Created Date       : 03/Mar/2025                                                                                     *
* Created By         : Mohith (SMAARTT)                                                                                *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Mohith      03/Mar/2025         Initial Draft.                                                             *
* 1.1       Taj Shaik   29/May/2025         Code Refactor                                                              *
***********************************************************************************************************************/

public class QuoteEmailHandler {
    
    public static void sendQuoteEmail(List<Id> quoteIds) {
        if (quoteIds == null || quoteIds.isEmpty()) return;
        
        List<Quote> quotes = [
            SELECT Id, QuoteNumber, ET_Type__c, OpportunityId
            FROM Quote
            WHERE Id IN :quoteIds
        ];
        
        OrgWideEmailAddress orgWideEmail;
        try {
            orgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'noreply@et.ae' LIMIT 1];
        } catch (Exception e) {
            System.debug('OrgWideEmailAddress not found: ' + e.getMessage());
            return;
        }
        
        List<Quote> validQuotes = new List<Quote>();
        Set<Id> opportunityIds = new Set<Id>();
        for (Quote q : quotes) {
            if (q.ET_Type__c == 'Quote for Approval' && q.OpportunityId != null) {
                validQuotes.add(q);
                opportunityIds.add(q.OpportunityId);
            }
        }
        
        if (validQuotes.isEmpty() || opportunityIds.isEmpty()) return;
        
        Map<Id, Opportunity> oppMap = fetchOpportunities(opportunityIds);
        Map<Id, List<ET_Pricing_Service_Request__c>> oppToPsrMap = fetchActivePSRs(opportunityIds);
        Map<Id, List<Vehicle__c>> psrToVehiclesMap = fetchVehicles(oppToPsrMap);
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (Quote q : validQuotes) {
            Opportunity opp = oppMap.get(q.OpportunityId);
            if (opp == null) continue;
            
            List<ET_Pricing_Service_Request__c> psrs = oppToPsrMap.get(opp.Id);
            if (psrs == null || psrs.isEmpty()) continue;
            
            List<Vehicle__c> allVehicles = new List<Vehicle__c>();
            for (ET_Pricing_Service_Request__c psr : psrs) {
                List<Vehicle__c> vehicles = psrToVehiclesMap.get(psr.Id);
                if (vehicles != null) {
                    allVehicles.addAll(vehicles);
                }
            }
            
            if (allVehicles.isEmpty()) continue;
            
            String emailBody = buildEmailBody(q, opp, allVehicles);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // Read and parse email list from Custom Label
            List<String> toAddresses = Label.Quote_Notification_Emails.split(';');
            mail.setToAddresses(toAddresses);
            mail.setSubject('New Quote is Created: ' + q.QuoteNumber);
            mail.setHtmlBody(emailBody);
            mail.setOrgWideEmailAddressId(orgWideEmail.Id);
            emails.add(mail);
        }
        
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
    
    private static Map<Id, Opportunity> fetchOpportunities(Set<Id> oppIds) {
        return new Map<Id, Opportunity>(
            [SELECT Id, ETSALES_Opportunity_Number__c, Owner.Name
             FROM Opportunity
             WHERE Id IN :oppIds]
        );
    }
    
    private static Map<Id, List<ET_Pricing_Service_Request__c>> fetchActivePSRs(Set<Id> oppIds) {
        Map<Id, List<ET_Pricing_Service_Request__c>> result = new Map<Id, List<ET_Pricing_Service_Request__c>>();
        for (ET_Pricing_Service_Request__c psr : [
            SELECT Id, Opportunity__c
            FROM ET_Pricing_Service_Request__c
            WHERE Opportunity__c IN :oppIds AND ET_PSR_IsActive__c = true
        ]) {
            if (!result.containsKey(psr.Opportunity__c)) {
                result.put(psr.Opportunity__c, new List<ET_Pricing_Service_Request__c>());
            }
            result.get(psr.Opportunity__c).add(psr);
        }
        return result;
    }
    
    private static Map<Id, List<Vehicle__c>> fetchVehicles(Map<Id, List<ET_Pricing_Service_Request__c>> oppToPsrMap) {
        Set<Id> psrIds = new Set<Id>();
        for (List<ET_Pricing_Service_Request__c> psrs : oppToPsrMap.values()) {
            for (ET_Pricing_Service_Request__c psr : psrs) {
                psrIds.add(psr.Id);
            }
        }
        
        Map<Id, List<Vehicle__c>> result = new Map<Id, List<Vehicle__c>>();
        for (Vehicle__c v : [
            SELECT ET_Vehicle_MAKE__c, ET_Vehicle_Model_Year__c,
            ET_Vehicle_Quantity__c, ET_Vehicle_Model__c,
            ET_Vehicle_Original_Purchase_Price__c, ET_Vehicle_Current_Purchase_Price__c,
            Vehicle_Notes__c, ET_Pricing_Service_Request__c
            FROM Vehicle__c
            WHERE ET_Pricing_Service_Request__c IN :psrIds
            AND ET_Vehicle_Condition__c = 'New'
        ]) {
            if (!result.containsKey(v.ET_Pricing_Service_Request__c)) {
                result.put(v.ET_Pricing_Service_Request__c, new List<Vehicle__c>());
            }
            result.get(v.ET_Pricing_Service_Request__c).add(v);
        }
        
        return result;
    }
    
    private static String buildEmailBody(Quote q, Opportunity opp, List<Vehicle__c> vehicles) {
        String body = 'Hi,<br><br>';
        body += 'New Quote is Created: <b>' + q.QuoteNumber + '</b><br><br>';
        body += '<b>Opportunity Details:</b><br>';
        body += 'Opportunity Number: ' + opp.ETSALES_Opportunity_Number__c + '<br>';
        body += 'Opportunity Owner: ' + opp.Owner.Name + '<br>';
        body += 'Quote Number: ' + q.QuoteNumber + '<br><br>';
        body += '<b>Vehicle Details:</b><br>';
        
        for (Vehicle__c v : vehicles) {
            body += 'Make: ' + v.ET_Vehicle_MAKE__c + '<br>';
            body += 'Model: ' + v.ET_Vehicle_Model__c + '<br>';
            body += 'Model Year: ' + v.ET_Vehicle_Model_Year__c + '<br>';
            body += 'Quantity: ' + v.ET_Vehicle_Quantity__c + '<br>';
            body += 'Original Price: ' + v.ET_Vehicle_Original_Purchase_Price__c + '<br>';
            body += 'Current Price: ' + v.ET_Vehicle_Current_Purchase_Price__c + '<br>';
            body += 'Notes: ' + v.Vehicle_Notes__c + '<br><br>';
        }
        
        body += 'Note: This is a system-generated email.<br><br>';
        body += 'Regards,<br>ET Team';
        
        return body;
    }
}