/***********************************************************************************************************************
* Name               : QuoteTriggerTest                                                                                *
* Description        : Apex Test Class for Quote Object Trigger.                                                       *
* Created Date       : 29/May/2025                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   29/May/2025         Initial Draft.                                                             *
***********************************************************************************************************************/

@isTest
public class QuoteTriggerTest {
    
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
        
    }
    
    @isTest
    static void testQuoteTriggerFlow() {
        Test.startTest();
        
        // Query Opportunity for reference
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        // Create a Quote for Approval linked to Opportunity
        Quote quote = new Quote(
            Name = 'Test Quote',
            OpportunityId = opp.Id,
            ET_Type__c = 'Quote for Approval',
            Status = 'Draft'
        );
        Insert quote;
        
        Test.stopTest(); // Ensures Queueable job runs
    }
    
    @isTest
    static void testQuoteTriggerIgnoresInvalidData() {
        Test.startTest();
        
        // Query Opportunity for reference
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        // Insert a quote with no Opportunity or wrong type
        Quote invalidQuote = new Quote(
            Name = 'Invalid Quote',
            OpportunityId = opp.Id,
            ET_Type__c = 'Total Project Summary',
            Status = 'Draft'
        );
        Insert invalidQuote;
        
        Test.stopTest();
        
        // No exception should occur, and no emails should be sent
        System.assertEquals(0, Limits.getEmailInvocations(), 'No email should be sent for invalid quote');
        
        TriggerRecursionHelper.reset();
    }
}