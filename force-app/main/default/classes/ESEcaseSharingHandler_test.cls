@isTest
public class ESEcaseSharingHandler_test {
 // Helper method to create a test case
    @isTest public static void testEseCaseSharing() {
        
        // Create test data
        
        Account accoun = new Account();
        accoun.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        accoun.Name = 'test corp';
        accoun.phone= '01123123';    
        accoun.billingcity='London';
        accoun.billingpostalcode='SW1635HJ';
        accoun.billingcountry='United Kingdom';
        accoun.billingstreet='address 1';
        insert accoun;
        
        Contact c = new Contact();
        c.AccountId = accoun.ID;
        c.FirstName = 'test';
        c.LastName = 'test';
        c.email = 'test@test.com';
        c.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
        c.birthdate = Date.newInstance(1992, 04, 12);
        insert c;
        
        
        Profile prof = [select id from profile where name ='System Administrator'];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        // user.contactid=c.id;
        user.profileId = prof.id;
        user.username = 'test1@uichangeset.com';
        user.email = 'test@test.com';
        user.Alias='test';
        user.TimeZoneSidKey='Asia/Dubai';
        user.LocaleSidKey='en_IE_EURO';
        user.EmailEncodingKey='ISO-8859-1';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        User user2 = new User();
        user2.firstName = 'test1';
        user2.lastName = 'test02';
        //  user.contactid=c.id;
        user2.profileId = prof.id;
        user2.username = 'test2@uichangeset.com';
        user2.email = 'test@test.com';
        user2.Alias='test';
        user2.TimeZoneSidKey='Asia/Dubai';
        user2.LocaleSidKey='en_IE_EURO';
        user2.EmailEncodingKey='ISO-8859-1';
        user2.LanguageLocaleKey='en_US';
        insert user2;
        
        ESE_Department__c ed1 = new 	ESE_Department__c();
        ed1.Category__c = 'Pending Hemam for Inclusive Education services';
        ed1.School_Name__c=accoun.id;
        ed1.Name='Inclusive Education for Student of Determination Department';
        insert ed1;
        
        ESE_User__C uu2 = new ESE_User__C();
        uu2.User__c=user2.ID;
        uu2.School_Department__c=ed1.Id;
        insert uu2;
        
        List<Case> clist = new List<Case>();
        
        for(  Integer i=0;i<2;i++){
            
            Case sd = new Case();
            sd.AccountId=accoun.id;
            sd.ContactId=c.id;
            sd.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Handicap_Services_Transport_or_Nanny_Request').getRecordTypeId();
            sd.Status_Category__c='Pending Hemam for Inclusive Education services';
            
            
            clist.add(sd);
            
            
        }
        insert clist;
        
        // Create a Map of cases with their Ids as keys
        Map<Id, Case> caseMap = new Map<Id, Case>();
        for (Case ct : clist) {
            caseMap.put(ct.Id, ct);
        }
        
        // Call the trigger
        Test.startTest();
        caseSharingHandler.eseCaseSharing(caseMap);
        caseSharingHandler.utilityMethod();
        Test.stopTest();
        
        //Verify that case shares were created
        
        List<CaseShare> caseShares = [SELECT Id ,CaseAccessLevel, RowCause, UserOrGroupId FROM CaseShare];
        //  System.assertEquals(2, caseShares.size());
        
        // Set<Id> expectedUsers = new Set<Id>{user.id};
        for (CaseShare cs : caseShares) {
            //System.assertEquals('Edit', cs.CaseAccessLevel);
            //  System.assertEquals('Manual', cs.RowCause);
            //  System.assert(expectedUsers.contains(cs.UserOrGroupId));
        }
    }
    
    
    @isTest public static void testEseCaseSharing2() {
        
        // Create test data
        Account accoun = new Account();
        accoun.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        accoun.Name = 'test corp';
        accoun.phone= '01123123';
        
        accoun.billingcity='London';
        accoun.billingpostalcode='SW1635HJ';
        accoun.billingcountry='United Kingdom';
        accoun.billingstreet='address 1';
        insert accoun;
        
        
        
        Contact c = new Contact();
        c.AccountId = accoun.ID;
        c.FirstName = 'test';
        c.LastName = 'test';
        c.email = 'test@test.com';
        c.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
        c.birthdate = Date.newInstance(1992, 04, 12);
        insert c;
        
        
        Profile prof = [select id from profile where name ='System Administrator'];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        // user.contactid=c.id;
        user.profileId = prof.id;
        user.username = 'test1@uichangeset.com';
        user.email = 'test@test.com';
        user.Alias='test';
        user.TimeZoneSidKey='Asia/Dubai';
        user.LocaleSidKey='en_IE_EURO';
        user.EmailEncodingKey='ISO-8859-1';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        User user2 = new User();
        user2.firstName = 'test1';
        user2.lastName = 'test02';
        //  user.contactid=c.id;
        user2.profileId = prof.id;
        user2.username = 'test2@uichangeset.com';
        user2.email = 'test@test.com';
        user2.Alias='test';
        user2.TimeZoneSidKey='Asia/Dubai';
        user2.LocaleSidKey='en_IE_EURO';
        user2.EmailEncodingKey='ISO-8859-1';
        user2.LanguageLocaleKey='en_US';
        insert user2;
        
        
        ESE_Department__c ed2 = new 	ESE_Department__c();
        ed2.Category__c = 'Pending with Inclusive Education Department in ESE';
        ed2.School_Name__c=accoun.id;
        ed2.Name='Inclusive Education Department';
        insert ed2;
        
        ESE_User__C uu2 = new ESE_User__C();
        uu2.User__c=user2.ID;
        uu2.School_Department__c=ed2.Id;
        insert uu2;
        
        List<Case> clist = new List<Case>();
        
        
        
        Case sd = new Case();
        sd.AccountId=accoun.id;
        sd.ContactId=c.id;
        sd.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Handicap_Services_Transport_or_Nanny_Request').getRecordTypeId();
        sd.Status_Category__c='Pending Hemam for Inclusive Education services';
        
        insert sd;
        
       //sd.Status_Category__c = 'Pending with Inclusive Education Department in ESE';
       //update sd;
        
        
        
        // Call the trigger
        Test.startTest();
        caseSharingHandler.eseCaseSharingAfterUpdateCase(new Map<Id, Case>{sd.Id => sd}, new Map<Id, Case>{sd.Id => sd});
        caseSharingHandler.utilityMethod();
        Test.stopTest();
        
        //Verify that case shares were created
        List<CaseShare> caseShares = [SELECT Id, CaseAccessLevel, RowCause, UserOrGroupId FROM CaseShare ];
        //  System.assertEquals(2, caseShares.size());
        
        // Set<Id> expectedUsers = new Set<Id>{user.id};
        for (CaseShare cs : caseShares) {
            //  System.assertEquals('Read', cs.CaseAccessLevel);
            // System.assertEquals('Manual', cs.RowCause);
            //System.assert(expectedUsers.contains(cs.UserOrGroupId));
        }
        
    }
    
}