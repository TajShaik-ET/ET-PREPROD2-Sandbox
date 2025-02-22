@isTest
public class OpportunityContactValidatorTest {

    @testSetup
    static void setupTestData() {
        Account accountWithContact = new Account(Name = 'Account with Contact');
        Account accountWithoutContact = new Account(Name = 'Account without Contact');
        insert new List<Account>{ accountWithContact, accountWithoutContact };
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = accountWithContact.Id
        );
        insert contact;
        Id leasingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'ETSALES_Leasing' AND SObjectType = 'Opportunity' LIMIT 1].Id;
        Id manpowerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'ETSALES_Manpower' AND SObjectType = 'Opportunity' LIMIT 1].Id;
        Opportunity oppWithContact = new Opportunity(
            Name = 'Opportunity with Contact',
            AccountId = accountWithContact.Id,
            RecordTypeId = leasingRecordTypeId,
            CloseDate = System.today(),
            StageName = 'Prospecting'
        );

        Opportunity oppWithoutContact = new Opportunity(
            Name = 'Opportunity without Contact',
            AccountId = accountWithoutContact.Id,
            RecordTypeId = leasingRecordTypeId,
            CloseDate = System.today(),
            StageName = 'Prospecting'
        );

        Opportunity oppNonLeasingRecordType = new Opportunity(
            Name = 'Opportunity non-leasing',
            AccountId = accountWithContact.Id,
            RecordTypeId = manpowerRecordTypeId,
            CloseDate = System.today(),
            StageName = 'Prospecting'
        );
        insert new List<Opportunity>{ oppWithContact, oppNonLeasingRecordType };
    }

    @isTest
    static void testOpportunityWithContact() {
        Opportunity oppWithContact = [SELECT Id, AccountId, RecordType.DeveloperName FROM Opportunity WHERE Name = 'Opportunity with Contact' LIMIT 1];
        Test.startTest();
        List<Opportunity> oppList = new List<Opportunity>{ oppWithContact };
        OpportunityContactValidator.validateContactsOnOpportunity(oppList);


		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standtu', Email='standarduser@testorgtest.com', 
            EmailEncodingKey='UTF-8', LastName='Testing user', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgtest.com');
        
        insert u;

        System.runAs(u) {            
            ETSALES_Tender__c tender = new ETSALES_Tender__c(
            	ETSALES_Customer__c =  oppList[0].AccountId
            );           
            insert tender;
            
            oppList[0].OwnerId = u.Id;
            oppList[0].ETSALES_Tender__c = tender.Id;
            
            List<Opportunity> oppl = new List<opportunity>();
            oppl.add(oppList[0]);
        	update oppl;
        }		       
        Test.stopTest();
    }

    @isTest
    static void testOpportunityWithoutContact() {
            Account accountWithoutContact = [SELECT Id FROM Account WHERE Name = 'Account without Contact' LIMIT 1];
            Opportunity oppWithoutContact = new Opportunity(
            Name = 'Opportunity without Contact',
            AccountId = accountWithoutContact.Id,
            CloseDate = System.today(),
            StageName = 'Prospecting',
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'ETSALES_Leasing' LIMIT 1].Id
        );
        Test.startTest();
        List<Opportunity> oppList = new List<Opportunity>{ oppWithoutContact };
        try {
            OpportunityContactValidator.validateContactsOnOpportunity(oppList);
                   } catch (DmlException e) {
            System.assert(e.getMessage().contains('You cannot create an Opportunity for an Account that has no Contacts'), 'Expected validation error message was not thrown.');
        }
        Test.stopTest();
    }

    @isTest
    static void testNonLeasingRecordTypeOpportunity() {
         Opportunity oppNonLeasingRecordType = [SELECT Id, AccountId, RecordType.DeveloperName FROM Opportunity WHERE Name = 'Opportunity non-leasing' LIMIT 1];
         Test.startTest();
        List<Opportunity> oppList = new List<Opportunity>{ oppNonLeasingRecordType };
        OpportunityContactValidator.validateContactsOnOpportunity(oppList);
        Test.stopTest();
    }
}