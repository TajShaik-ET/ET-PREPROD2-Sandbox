public class OpportunityStageUpdater {
    public static void updateOpportunityStageOnQuoteCreation(List<Customer_Quote__c> quotes) {
        Set<Id> opportunityIds = new Set<Id>();
        for (Customer_Quote__c quote : quotes) {
            if (quote.Opportunity_Name__c != null) {
                opportunityIds.add(quote.Opportunity_Name__c);
            }
        }
        Map<Id, Opportunity> relatedOpportunitiesMap = new Map<Id, Opportunity>(
            [SELECT Id, StageName, ETSALES_Approval_Status__c 
             FROM Opportunity 
             WHERE Id IN :opportunityIds]
        );
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for (Customer_Quote__c quote : quotes) {
            if (quote.Opportunity_Name__c != null) {
                Opportunity relatedOpportunity = relatedOpportunitiesMap.get(quote.Opportunity_Name__c);
                if (relatedOpportunity.ETSALES_Approval_Status__c == 'Approved' &&
                    (relatedOpportunity.StageName == 'Qualification' ||  
                     relatedOpportunity.StageName == 'Requirement Analysis' ||  
                     relatedOpportunity.StageName == 'Decision' || 
                     relatedOpportunity.StageName == 'Pricing Request')) {
                         if (relatedOpportunity.StageName != 'Proposal') {
                             relatedOpportunity.StageName = 'Proposal';
                             opportunitiesToUpdate.add(relatedOpportunity);
                         }
                     }
            }
        }
        if (!opportunitiesToUpdate.isEmpty()) {
            update opportunitiesToUpdate;
        }
    }
}