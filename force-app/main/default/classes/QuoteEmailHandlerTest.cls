/***********************************************************************************************************************
* Name               : QuoteEmailHandlerTest                                                                           *
* Description        : Apex Test Class                                                                                 *
* Created Date       : 03/Mar/2025                                                                                     *
* Created By         : Mohith (SMAARTT)                                                                                *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Mohith      03/Mar/2025         Initial Draft.                                                             *
* 1.1       Taj Shaik   29/May/2025         Code Refactor                                                              *
***********************************************************************************************************************/
@isTest
public class QuoteEmailHandlerTest {
    
    @testSetup
    static void setupTestData() {
        // Create Test User
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com.salesforce', // UNIQUE USERNAME
            Alias = 'testusr',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        Insert testUser;
        
        // Create an Account
        Account acc = new Account(Name = 'Test Account');
        Insert acc;
        
        // Create an Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acc.Id,
            StageName = 'Qualification', 
            CloseDate = Date.today().addDays(10),
            OwnerId = testUser.Id
        );
        Insert opp;
        
        // Create Active Pricing Service Request
        ET_Pricing_Service_Request__c pricingRequest = new ET_Pricing_Service_Request__c(
            Opportunity__c = opp.Id,
            ET_PSR_IsActive__c = true
        );
        Insert pricingRequest;
        
        // Create a New Vehicle related to the Pricing Service Request
        Vehicle__c vehicle = new Vehicle__c(
            ET_Vehicle_MAKE__c = 'Toyota',
            ET_Vehicle_Model_Year__c = '2024',
            ET_Vehicle_Quantity__c = 2,
            ET_Vehicle_Model__c = 'Corolla',
            ET_Vehicle_Condition__c = 'New',
            ET_Pricing_Service_Request__c = pricingRequest.Id
        );
        Insert vehicle;
        
        // Create a Quote for Approval linked to Opportunity
        Quote quote = new Quote(
            Name = 'Test Quote',
            OpportunityId = opp.Id,
            ET_Type__c = 'Quote for Approval',
            Status = 'Draft'
        );
        Insert quote;
    }
    
    @isTest
    static void testSendQuoteEmail() {
        Test.startTest();
        Integer emailBefore = Limits.getEmailInvocations();
        
        // Fetch the test quote
        Map<Id,Quote> testQuotes = New Map<Id,Quote>([SELECT Id, OpportunityId, ET_Type__c, QuoteNumber FROM Quote WHERE ET_Type__c = 'Quote for Approval']);
        
        List<Id> quoteIdList = new List<Id>(testQuotes.keySet());
        
        // Call the handler method
        QuoteEmailHandler.sendQuoteEmail(quoteIdList);
        
        Integer emailAfter = Limits.getEmailInvocations();
        Test.stopTest();
        
        // Assert that at least one email was sent
        System.assert(emailAfter > emailBefore, 'At least one email should have been sent');
    }
}