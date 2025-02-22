@isTest
public class sendEmailsToUsers_test {
    @isTest
    static void testSendEmailsToESEUsersAfterInsert() {
        //Create  Account for that one 
        Account testAccount = new Account(
            RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId(),
            Name = 'AL KHAIL',
            phone= '971567567',  
            billingcity='DUBAI',
            billingpostalcode='SW1635HJ',
            billingcountry='UAE',
            billingstreet='DUBAI INTERNET CITY',
            ETST_Name_AR__c='AL JEE'
            
        );
        insert testAccount;
        //Cretae data with Contact
        Contact testCon = new Contact(
            AccountId = testAccount.Id,
            FirstName = 'al mousa',
            LastName = 'alhukatr',
            email = 'test@test.com',
            RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(),
            birthdate = Date.newInstance(1992, 04, 12)
            
        );
        insert testCon;
        Profile prof = [select id from profile where name ='System Administrator'];
        User portalUser = new User(
            firstName = 'Al mouasa',
            lastName = 'halktour',
            ProfileID = prof.id,
            email= 'yellure9707@gmail.com ',
            username = 'Almouasa@test.com',
            Alias='test',
            TimeZoneSidKey='Asia/Dubai',
            LocaleSidKey='en_IE_EURO',
            EmailEncodingKey='ISO-8859-1',
            LanguageLocaleKey='en_US'
        );
        insert portalUser;
        //Ese Department
        ESE_Department__c eseDepartment = new ESE_Department__c();
        eseDepartment.School_Name__c=testAccount.ID;
        eseDepartment.Category__c='Pending Hemam for Inclusive Education services';
        
        insert eseDepartment;
        
        // Ese User is Associated with department
        ESE_User__C eseUser = new ESE_User__C();
        eseUser.User__c=portalUser.ID;
        eseUser.School_Department__c=eseDepartment.Id;
        
        insert eseUser;
        
        // Create test data for Cases and related records as needed
        Case testCase = new Case();
        testCase.AccountId=testAccount.ID;
        testCase.Status_Category__c='Pending Hemam for Inclusive Education services';
        testCase.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Handicap_Services_Transport_or_Nanny_Request').getRecordTypeId();
        insert testCase;
       
        // Create a map to simulate the trigger context with the test Case
        
        Map<Id, Case> testMap = new Map<Id, Case>{ testCase.Id => testCase };
            Test.startTest();
        sendEmailsToUsers.sendEmailsToESEUsersAfterInsert(testMap);
         sendEmailsToUsers.utilityMethod();
        Test.stopTest();
        
       // System.assertEquals(1, Limits.getEmailInvocations(), 'Emails were not sent as expected.');
        
    }
    
    @isTest
    static void  sendEmailsToUsersUpdate_test(){
        //Create  Account for that one 
        Account testAccount = new Account(
            RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId(),
            Name = 'AL KHAIL',
            phone= '971567567',  
            billingcity='DUBAI',
            billingpostalcode='SW1635HJ',
            billingcountry='UAE',
            billingstreet='DUBAI INTERNET CITY',
            ETST_Name_AR__c='AL JEE'
            
        );
        insert testAccount;
        
        //Cretae data with Contact
        Contact testCon = new Contact(
            AccountId = testAccount.Id,
            FirstName = 'al mousa',
            LastName = 'alhukatr',
            email = 'test@test.com',
            RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(),
            birthdate = Date.newInstance(1992, 04, 12)
            
        );
        insert testCon;
        
        Profile prof = [select id from profile where name ='System Administrator'];
        User portalUser = new User(
            firstName = 'Al mouasa',
            lastName = 'halktour',
            ProfileID = prof.id,
            email= 'yellure9707@gmail.com ',
            username = 'Almouasa@test.com',
            Alias='test',
            TimeZoneSidKey='Asia/Dubai',
            LocaleSidKey='en_IE_EURO',
            EmailEncodingKey='ISO-8859-1',
            LanguageLocaleKey='en_US'
            
            
        );
        insert portalUser;
        
        //Ese Department
        ESE_Department__c eseDepartment = new ESE_Department__c();
        eseDepartment.School_Name__c=testAccount.ID;
        eseDepartment.Category__c='Pending with Inclusive Education Department in ESE';
        
        insert eseDepartment;
        
        // Ese User is Associated with department
        ESE_User__C eseUser = new ESE_User__C();
        eseUser.User__c=portalUser.ID;
        eseUser.School_Department__c=eseDepartment.Id; 
        insert eseUser;
       
        // Create test data for Cases and related records as needed
        Case testCase = new Case();
        testCase.AccountId=testAccount.ID;
        testCase.Status_Category__c='Pending Hemam for Inclusive Education services';
        testCase.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Handicap_Services_Transport_or_Nanny_Request').getRecordTypeId();
        insert testCase;
        
        List <case> caseESE = [SELECT Id,AccountId, Status_Category__c FROM Case WHERE Id = :testCase.Id];
        for(Case cf :caseESE ){
            cf.Status_Category__c='Pending with Inclusive Education Department in ESE';
        }
        update caseESE;
        
        // Call the method with the test data
        Test.startTest();
        sendEmailsToUsers.sendEmailsToESEUsersAfterUpdate(new Map<Id, Case>{testCase.Id => testCase}, new Map<Id, Case>{testCase.Id => testCase});
         sendEmailsToUsers.utilityMethod();
        Test.stopTest();
        
       // System.assertEquals(5, Limits.getEmailInvocations(), 'Emails were not sent as expected.');
        
        
    } 
    @isTest
    static void  sendEmailsToUsersCancel_test(){
        
        //Create  Account for that one 
        Account testAccount = new Account(
            RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId(),
            Name = 'AL KHAIL',
            phone= '971567567',  
            billingcity='DUBAI',
            billingpostalcode='SW1635HJ',
            billingcountry='UAE',
            billingstreet='DUBAI INTERNET CITY',
            ETST_Name_AR__c='AL JEE'
            
        );
        insert testAccount;
        
        //Cretae data with Contact
        Contact testCon = new Contact(
            AccountId = testAccount.Id,
            FirstName = 'al mousa',
            LastName = 'alhukatr',
            email = 'test@test.com',
            RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(),
            birthdate = Date.newInstance(1992, 04, 12)
            
        );
        insert testCon;
        
        Profile prof = [select id from profile where name ='System Administrator'];
        User portalUser = new User(
            firstName = 'Al mouasa',
            lastName = 'halktour',
            ProfileID = prof.id,
            email= 'yellure9707@gmail.com ',
            username = 'Almouasa@test.com',
            Alias='test',
            TimeZoneSidKey='Asia/Dubai',
            LocaleSidKey='en_IE_EURO',
            EmailEncodingKey='ISO-8859-1',
            LanguageLocaleKey='en_US'
        );
        insert portalUser;
        
        //Ese Department
        ESE_Department__c eseDepartment = new ESE_Department__c();
        eseDepartment.School_Name__c=testAccount.ID;
        eseDepartment.Category__c='Pending with Inclusive Education Department in ESE';
        
        insert eseDepartment;
        
        // Ese User is Associated with department
        ESE_User__C eseUser = new ESE_User__C();
        eseUser.User__c=portalUser.ID;
        eseUser.School_Department__c=eseDepartment.Id;
        
        insert eseUser;
        
        // Create test data for Cases and related records as needed
        Case testCase = new Case();
        testCase.AccountId=testAccount.ID;
        testCase.Status_Category__c='Pending with Inclusive Education Department in ESE';
        testCase.Sub_Status__c='Approved by Hemam for Inclusive Education services';
        testCase.Collection_of_ESE_Approver_Email__c = 'email1@example.com,email2@example.com';
        testCase.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Handicap_Services_Transport_or_Nanny_Request').getRecordTypeId();
  
        insert testCase;
        
        List <case> caseESE = [SELECT Id,AccountId, Status_Category__c ,Collection_of_ESE_Approver_Email__c FROM Case WHERE Id = :testCase.Id];
        for(Case cf :caseESE ){
            cf.Sub_Status__c='Cancelled by School';
            cf.Collection_of_ESE_Approver_Email__c='yellure9707@gmail.com';
        }
        update caseESE;
  
        // Create a map with old and new Case records for update
        Map<Id, Case> oldNewCaseMap = new Map<Id, Case>{
            testCase.Id => new Case(
                Id = testCase.Id,
                Sub_Status__c = 'Cancelled by School'
              
            )
                };
                    
                    Test.startTest();
        sendEmailsToUsers.handleAfterUpdate(new List<Case>{testCase}, oldNewCaseMap);
         sendEmailsToUsers.utilityMethod();
        Test.stopTest();
        
    }
    
    
    
}