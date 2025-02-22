trigger UpdateOpportunityOnQuoteCreation on Customer_Quote__c (after insert) {
    OpportunityStageUpdater.updateOpportunityStageOnQuoteCreation(Trigger.new);
}