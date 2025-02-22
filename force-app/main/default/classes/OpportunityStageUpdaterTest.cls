@isTest
public class OpportunityStageUpdaterTest {
    
    @testSetup
    static void setupTestData() {
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        List<Opportunity> oppList = new List<Opportunity>{
            new Opportunity(Name = 'Opp 1', StageName = 'Qualification', CloseDate = Date.today(),Proposed_Amount__c= 346, AccountId = testAccount.Id, ETSALES_Approval_Status__c = 'Approved'),
                new Opportunity(Name = 'Opp 2', StageName = 'Pricing Request', CloseDate = Date.today(),Proposed_Amount__c= 346, AccountId = testAccount.Id, ETSALES_Approval_Status__c = 'Approved'),
                new Opportunity(Name = 'Opp 3', StageName = 'Decision', CloseDate = Date.today(), Proposed_Amount__c= 346,AccountId = testAccount.Id, ETSALES_Approval_Status__c = 'Submitted For Approval'),
                new Opportunity(Name = 'Opp 4', StageName = 'Proposal', CloseDate = Date.today(),Proposed_Amount__c= 346, AccountId = testAccount.Id, ETSALES_Approval_Status__c = 'Approved') // Already in Proposal
                };
                    insert oppList;
        List<Customer_Quote__c> quoteList = new List<Customer_Quote__c>{
            new Customer_Quote__c(Name = 'Quote 1', Opportunity_Name__c = oppList[0].Id),
                new Customer_Quote__c(Name = 'Quote 2', Opportunity_Name__c = oppList[1].Id),
                new Customer_Quote__c(Name = 'Quote 3', Opportunity_Name__c = oppList[2].Id),
                new Customer_Quote__c(Name = 'Quote 4', Opportunity_Name__c = oppList[3].Id)
                };
                  insert quoteList;
    }
    @isTest
    static void testUpdateOpportunityStage() {
        Opportunity opp1 = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Opp 1'];
        Opportunity opp2 = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Opp 2'];
        Opportunity opp3 = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Opp 3'];
        Opportunity opp4 = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Opp 4'];
        List<Customer_Quote__c> quotes = [SELECT Id, Opportunity_Name__c FROM Customer_Quote__c];
        OpportunityStageUpdater.updateOpportunityStageOnQuoteCreation(quotes);
        Opportunity updatedOpp1 = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Opp 1'];
        Opportunity updatedOpp2 = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Opp 2'];
        Opportunity updatedOpp3 = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Opp 3'];
        Opportunity updatedOpp4 = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Opp 4'];
        
    }
}