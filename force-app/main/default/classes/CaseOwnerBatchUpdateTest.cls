@isTest
public class CaseOwnerBatchUpdateTest {
    
    @testSetup
    static void setup() {
        // Create test data
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 200; i++) {
            cases.add(new Case(Subject = 'Test Case ' + i, Status = 'New'));
        }
        insert cases;
    }

    @isTest
    static void testBatchUpdate() {
        // Retrieve test data
        List<Case> caseList = [SELECT Id FROM Case LIMIT 200];
        List<Id> caseIds = new List<Id>();
        for (Case c : caseList) {
            caseIds.add(c.Id);
        }

        // Create a new user to be the new owner
        User newOwner = new User(
            Username = 'newowner@test.com',
            LastName = 'Owner',
            Email = 'newowner@test.com',
            Alias = 'newown',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert newOwner;

        // Instantiate the batch class
        CaseOwnerBatchUpdate batch = new CaseOwnerBatchUpdate(caseIds, newOwner.Id);

        // Execute the batch
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify the owner has been updated
        for (Case c : [SELECT Id, OwnerId FROM Case WHERE Id IN :caseIds]) {
            System.assertEquals(newOwner.Id, c.OwnerId, 'OwnerId should be updated to newOwner.Id');
        }
    }
}