@isTest
public class ETSALES_OpportunityTriggerHandler_Test {

    static testMethod void opportunityTest(){
        Account testAccount = new Account(Name= 'testAccount');
        
        insert testAccount;
        
        Opportunity testOpportunity = new Opportunity (Name ='OpportunityTest', AccountId = testAccount.Id,StageName= 'Negotiation',CloseDate=System.today() );
        insert testOpportunity;
        
        Quote testQuote = new Quote (Name = 'testQuote', OpportunityID =testOpportunity.Id,isActive__c=TRUE);
        insert testQuote;
        
        List<Opportunity> newOpptyList = [SELECT Id FROM Opportunity];
        
        system.assertEquals(1, newOpptyList.size());
        ETSALES_OpportunityTriggerHandler.stageChangeValidation(newOpptyList);
        
       
    }
}