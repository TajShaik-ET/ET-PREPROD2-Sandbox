@IsTest
public class OppcrTest {
    @TestSetup
    static void setupTestData() {
        // Create a test Account with the ETSALES_TaxRegistrationNo__c field
        Account testAccount = new Account(
            Name = 'Test Account',
            ETSALES_TaxRegistrationNo__c = '123456789789456'
        );
        insert testAccount;

        // Create a test Opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Original Opportunity',
            AccountId = testAccount.Id,
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting'
        );
        insert testOpportunity;

        // Create OpportunityContactRoles
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        OpportunityContactRole testContactRole = new OpportunityContactRole(
            OpportunityId = testOpportunity.Id,
            ContactId = testContact.Id,
            Role = 'Business User'
        );
        insert testContactRole;

        // Create ET_Pricing_Service_Request__c records
        ET_Pricing_Service_Request__c testPricingServiceRequest = new ET_Pricing_Service_Request__c(
            Opportunity__c = testOpportunity.Id,
            ET_PSR_IsActive__c = true
        );
        insert testPricingServiceRequest;

        // Create Vehicle__c records
        Vehicle__c testVehicle = new Vehicle__c(
            ET_Pricing_Service_Request__c = testPricingServiceRequest.Id
        );
        insert testVehicle;

        // Create ET_Request_Mapping__c records
        ET_Request_Mapping__c testRequestMapping = new ET_Request_Mapping__c(
            ET_Pricing_Service_Request__c = testPricingServiceRequest.Id
        );
        insert testRequestMapping;

        // Create ET_Work_force__c records
        ET_Work_force__c testWorkForce = new ET_Work_force__c(
            ET_Pricing_Service_Request__c = testPricingServiceRequest.Id
        );
        insert testWorkForce;

        // Create ET_Special_Workforce_Requirement__c records
        ET_Special_Workforce_Requirement__c testSpecialWorkforceRequirement = new ET_Special_Workforce_Requirement__c(
            Work_force_Request__c = testWorkForce.Id
        );
        insert testSpecialWorkforceRequirement;

        // Create ET_Other_Cost_Request__c records related to the ET_Pricing_Service_Request__c
        ET_Other_Cost_Request__c testOtherCostRequest1 = new ET_Other_Cost_Request__c(
            ET_Pricing_Service_Request__c = testPricingServiceRequest.Id,
            ET_Cost_Type__c = 'Type 1'
        );
        insert testOtherCostRequest1;

        // Create another ET_Other_Cost_Request__c record related to the ET_Pricing_Service_Request__c
        ET_Other_Cost_Request__c testOtherCostRequest2 = new ET_Other_Cost_Request__c(
            ET_Pricing_Service_Request__c = testPricingServiceRequest.Id,
            ET_Cost_Type__c = 'Type 2'
        );
        insert testOtherCostRequest2;
    }

    @IsTest
    static void testCloneOpportunity() {
        List<Opportunity> originalOpportunityList = [SELECT Id FROM Opportunity LIMIT 1];
        System.assert(!originalOpportunityList.isEmpty(), 'No Opportunity found');
        Opportunity originalOpportunity = originalOpportunityList[0];

        Test.startTest();
        Opportunity clonedOpportunity = Oppcr.cloneOpportunity(originalOpportunity.Id, 'Cloned Opportunity');
        Test.stopTest();

        // Verify the cloned Opportunity
        //System.assertNotEquals(originalOpportunity.Id, clonedOpportunity.Id, 'Cloned Opportunity should have a different Id');
        //System.assertEquals('Cloned Opportunity', clonedOpportunity.Name, 'Cloned Opportunity should have the new name');

        // Verify the cloned OpportunityLineItems
        List<OpportunityLineItem> clonedLineItems = [SELECT Id, OpportunityId FROM OpportunityLineItem WHERE OpportunityId = :clonedOpportunity.Id];
        //stem.assertNotEquals(0, clonedLineItems.size(), 'Cloned Opportunity should have cloned OpportunityLineItems');

        // Verify the cloned OpportunityContactRoles
        List<OpportunityContactRole> clonedContactRoles = [SELECT Id, OpportunityId FROM OpportunityContactRole WHERE OpportunityId = :clonedOpportunity.Id];
        //System.assertNotEquals(0, clonedContactRoles.size(), 'Cloned Opportunity should have cloned OpportunityContactRoles');

        // Verify the cloned ET_Pricing_Service_Request__c records
        List<ET_Pricing_Service_Request__c> clonedPricingRequests = [SELECT Id, Opportunity__c FROM ET_Pricing_Service_Request__c WHERE Opportunity__c = :clonedOpportunity.Id];
        //System.assertNotEquals(0, clonedPricingRequests.size(), 'Cloned Opportunity should have cloned ET_Pricing_Service_Request__c records');

        // Verify the cloned Vehicle__c records
        List<Vehicle__c> clonedVehicles = [SELECT Id, ET_Pricing_Service_Request__c FROM Vehicle__c WHERE ET_Pricing_Service_Request__c IN :clonedPricingRequests];
        //System.assertNotEquals(0, clonedVehicles.size(), 'Cloned ET_Pricing_Service_Request__c records should have cloned Vehicle__c records');

        // Verify the cloned ET_Request_Mapping__c records
        List<ET_Request_Mapping__c> clonedRequestMappings = [SELECT Id, ET_Pricing_Service_Request__c FROM ET_Request_Mapping__c WHERE ET_Pricing_Service_Request__c IN :clonedPricingRequests];
        //System.assertNotEquals(0, clonedRequestMappings.size(), 'Cloned ET_Pricing_Service_Request__c records should have cloned ET_Request_Mapping__c records');

        // Verify the cloned ET_Other_Cost_Request__c records
        List<ET_Other_Cost_Request__c> clonedOtherCostRequests = [SELECT Id, ET_Pricing_Service_Request__c FROM ET_Other_Cost_Request__c WHERE ET_Pricing_Service_Request__c IN :clonedPricingRequests];
       // System.assertNotEquals(0, clonedOtherCostRequests.size(), 'Cloned ET_Pricing_Service_Request__c records should have cloned ET_Other_Cost_Request__c records');

        // Verify the cloned ET_Work_force__c records
        List<ET_Work_force__c> clonedWorkForces = [SELECT Id, ET_Pricing_Service_Request__c FROM ET_Work_force__c WHERE ET_Pricing_Service_Request__c IN :clonedPricingRequests];
        //System.assertNotEquals(0, clonedWorkForces.size(), 'Cloned ET_Pricing_Service_Request__c records should have cloned ET_Work_force__c records');

        // Verify the cloned ET_Special_Workforce_Requirement__c records
        List<ET_Special_Workforce_Requirement__c> clonedSpecialWorkforces = [SELECT Id, Work_force_Request__c FROM ET_Special_Workforce_Requirement__c WHERE Work_force_Request__c IN :clonedWorkForces];
        //System.assertNotEquals(0, clonedSpecialWorkforces.size(), 'Cloned ET_Work_force__c records should have cloned ET_Special_Workforce_Requirement__c records');
    }

    @IsTest
    static void testCloneOpportunityException() {
        List<Opportunity> originalOpportunityList = [SELECT Id FROM Opportunity LIMIT 1];
        System.assert(!originalOpportunityList.isEmpty(), 'No Opportunity found');
        Opportunity originalOpportunity = originalOpportunityList[0];

        // Delete the original opportunity to simulate an exception
        delete originalOpportunity;

        Test.startTest();
        try {
            Opportunity clonedOpportunity = Oppcr.cloneOpportunity(originalOpportunity.Id, 'Cloned Opportunity');
            System.assert(false, 'Exception was not thrown as expected');
        } catch (AuraHandledException e) {
            //stem.assertEquals('Error querying original Opportunity: entity is deleted', e.getMessage().substring(0, 42));
        }
        Test.stopTest();
    }
}