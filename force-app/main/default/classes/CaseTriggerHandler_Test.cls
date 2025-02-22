@isTest

public class CaseTriggerHandler_Test	{
    
    @testSetup  static void  CallModifySharing(){
        
        Account accoun = new Account();
        
        // accoun.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account').getRecordTypeId();
        
        accoun.Name = 'test corp';
        
        accoun.phone= '01123123';
        
        accoun.IsConvertedFromLead__c=true;
        
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
        
        //  user.contactid=c.id;
        
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
        
        List<case> cslist= new List<Case>();
        
        List<case> csListFinal= new List<Case>();
        
        for(Integer i=0;i<10;i++){
            
            Case cs= new Case();
            
            cs.Accountid=accoun.id;
            
            cs.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('School_Transport').getRecordTypeId();
            
            cs.contactid=c.id;
            
            if(i<5){
                
                cs.status='New';
                
                cs.Case_Types__c='Request for Awareness Session';
                
                cs.Requestor__c='Parent/Guardian';
                
                cs.Assigned_To__c=user2.id;
                
            }
            
            else if(i>4 && i<8){
                
                cs.status='Submitted for ADEC';
                
                cs.Case_Types__c='Evaluation of Schools/Services';
                
                cs.Requestor__c='Parent/Guardian';
                
            }
            
            else{
                
                cs.status='On Hold';
                
                cs.Case_Types__c='Request for New Bus/Supervisors/Teachers Transfer';
                
                cs.Requestor__c='Parent/Guardian';
                
            }
            
            cslist.add(cs);
            
        }
        
        // insert cslist;
        
        Entitlement ent = new Entitlement(Name='Normal - close within 2 working days', AccountId=accoun.Id, 
                                          
                                          StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
        
        insert ent;
        
        List<case> modifycase= new List<Case>();
        
        modifycase.add(cslist[0]);
        
        List<Task> tasklist = new  List<Task>();Integer i ;
        
        Task t = new Task();
        
        t.Status = 'Open';
        
        t.WhatId = cslist[0].Id; 
        
        insert t;
        
        Task t2 = new Task();
        
        t2.Status = 'Open';
        
        t2.WhatId = cslist[1].Id; 
        
        insert t2;
        
        cslist[1].Priority = 'Normal - close within 2 working days';
        
        cslist[1].SlaStartDate=system.today().addDays(-10);
        
        //update cslist[1];
        
        cslist[2].status = 'Closed';
        
        cslist[2].Solution__c = 'Closed';
        
        cslist[2].CCM_Remarks__c = 'Closed';
        
        // update cslist[2];
        
        cslist[3].SlaStartDate = system.now().addDays(-1);
        
        cslist[3].status = 'Closed';
        
        cslist[3].Solution__c = 'Closed';
        
        cslist[3].CCM_Remarks__c = 'Closed';
        
        //  update cslist[3];
        
        caseTriggerhandler.validatePendingActivies(modifycase);   
        
    }
    
    @isTest public static void  CallModifySharing2(){
        
        Id UserID=[Select id from User where lastname='test2' limit 1 ].id;
        
        List<case> csListFinal2= new List<Case>();
        
        List<case> csListFinal3= new List<Case>();
        
        csListFinal2=[Select id ,Assigned_To__c from case];
        
        for (case csup: csListFinal2){
            
            csup.Assigned_To__c=UserID;
            
            csListFinal3.add(csup);
            
        }
        
        Test.StartTest();
        
        update csListFinal3;
        
        ServiceChannel serviceChannel = [SELECT Id FROM ServiceChannel WHERE DeveloperName = 'sfdc_liveagent'];
        
        System.runAs(new User(Id=userinfo.getUserId())){  
            
            AgentWork agent = new AgentWork();
            
            // agent.WorkItemId = csListFinal3[0].id;
            
            agent.ServiceChannelId = serviceChannel.Id;
            
            agent.UserId = userinfo.getUserId();
            
            //  insert agent;
            
        }
        
        Test.StopTest();
        
    }
    
    @isTest public static void  CallModifySharing3(){
        
        Id UserID=[Select id from User where lastname='test2'  limit 1].id;
        
        Id UserIDnew=[Select id from User where lastname='test02'  limit 1].id;
        
        List<case> csListFinal2= new List<Case>();
        
        List<case> csListFinal3= new List<Case>();
        
        csListFinal2=[Select id ,Assigned_To__c from case where Assigned_To__c=:UserID];
        
        for (case csup: csListFinal2){
            
            csup.Assigned_To__c=UserIDnew;
            
            csListFinal3.add(csup);
            
        }
        
        Test.StartTest();
        
        update csListFinal3;
        
        delete csListFinal3;
        
        Test.StopTest();
        
    }
    
    @isTest public static void  CallModifySharing4(){
        
        Id UserID=[Select id from User where lastname='test2'  limit 1 ].id;
        
        Id UserIDnew=[Select id from User where lastname='test02'  limit 1 ].id;
        
        List<case> csListFinal2= new List<Case>();
        
        List<case> csListFinal3= new List<Case>();
        
        Map<Id, Id> newMap = new Map<Id, Id>();
        
        csListFinal2=[Select id ,Assigned_To__c from case where Assigned_To__c=:UserID and status!='Closed'];
        
        for (case csup: csListFinal2){
            
            csup.Assigned_To__c=UserIDnew;
            
            newMap.put(csup.Id,UserID); 
            
            csListFinal3.add(csup);
            
        }
        
        Test.StartTest();
        
        CaseTriggerHandler.caseDeleteValidation(csListFinal3);
        
        CaseTriggerHandler.updateMilestones(csListFinal3);
        
        CaseTriggerHandler.updateCaseManagerEmail(newMap);
        
        Test.StopTest();
        
    }
    
    /*Test Class for SendClosedEmail*/
    
    @isTest public static void SendClosedCaseEmailTest1() {
        
        Account acc=new Account();
        
        acc.LastName='TestAccount1';
        
        acc.PersonEmail='test1email@email.com';
        
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        
        insert acc;
        
        
        Case cc = new Case();
        
        cc.AccountId=acc.Id;
        
        cc.Status='New';
        
        cc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Vehicle_Breakdown').getRecordTypeId();
        
        insert cc;
        
        cc.Solution__c='Test';
        
        cc.CCM_Remarks__c='TestRemarks';    
        
        cc.Status='Closed';
        
        //Update cc;
        
        
    }
    
    @isTest public static void SendFeedbackEmail() {
        
        Account acc=new Account();
        
        acc.LastName='TestAccount1';
        
        acc.PersonEmail='test1email@email.com';
        
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        
        insert acc;
        
        Contact c = new Contact();
        
       // c.AccountId = acc.ID;
        
        c.FirstName = 'test';
        
        c.LastName = 'test';
        
        c.email = 'test@test.com';
        
        
        c.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
        
        c.birthdate = Date.newInstance(1992, 04, 12);
        
        insert c;
        
        List<Case> trgNew = new List<Case>();
        Map<Id,Case> trgOldMap = new Map<Id,Case>();
        
        User u = [Select Id from User Where Profile.Name ='T&L - Account Manager' AND IsActive = true limit 1];
        
        Case cc = new Case();
        //cc.AccountId=acc.Id;
        cc.Status='New';
        //Accident_Emergency_School_Transport
        cc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Accident_Emergency_School_Transport').getRecordTypeId();
        cc.ContactId=c.Id;
        cc.Priority ='Emergency - close within 24 hours';
        cc.Requestor_type__c='B2C';
        cc.Subject='test';
        cc.Area__c='Abu Dhabi';
        cc.Description='test';
        cc.ETDriver__c='Yes';
        System.runAs(u) {
            insert cc;
        }
        trgOldMap.put(cc.Id,cc);
        
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Document',
            VersionData = Blob.valueOf('Test Content'),
            PathOnClient = 'test.txt'
        );
        insert testContentVersion; 
        ContentDocumentLink existingContentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id FROM ContentDocument WHERE Title = 'Test Document' LIMIT 1].Id,
            LinkedEntityId = cc.Id,
            ShareType = 'I'
        );
        insert existingContentLink;
        
        User u1= [Select Id,email from User where email ='akhil.john@smaartt.com'];
        cc.Solution__c='Test';
        cc.CCM_Remarks__c='TestRemarks';    
        cc.Status='Closed';
        System.runAs(u1) {
            Update cc;
        }
        
        trgNew.add(cc);
        
        CaseTriggerHandler.SendFeedbackEmail(trgNew,trgOldMap);
    }
   /* @isTest public static void SendFeedbackEmail2() {
        
        Account acc=new Account();
        acc.LastName='TestAccount1';
        acc.PersonEmail='test1email@email.com';
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        insert acc;
        
        Contact c = new Contact();
        //c.AccountId = acc.ID;
        c.FirstName = 'test';
        c.LastName = 'test';
        c.email = 'test@test.com';
        c.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
        c.birthdate = Date.newInstance(1992, 04, 12);
        insert c;
        
        List<Case> trgNew = new List<Case>();
        Map<Id,Case> trgOldMap = new Map<Id,Case>();
        
        User u = [Select Id from User Where Profile.Name ='T&L - Account Manager' AND IsActive = true limit 1];
        
        Case cc = new Case();
        cc.AccountId=acc.Id;
        cc.Status='New';
        cc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Accident_Emergency_School_Transport').getRecordTypeId();
        cc.ContactId=c.Id;
        cc.Email__c='test@test.com';
       // cc.Priority='Low';
        //cc.Priority_T_L__c='Medium-Close with in 15 days';
        cc.Area__c ='Abu Dhabi';
        cc.Requestor_type__c='B2B';
        cc.Impacting_finances__c='Yes';
        
        System.runAs(u) {
        insert cc;    
        }
      insert cc;   
    
        trgOldMap.put(cc.Id,cc);
        
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Document',
            VersionData = Blob.valueOf('Test Content'),
            PathOnClient = 'test.txt'
        );
        insert testContentVersion; 
        ContentDocumentLink existingContentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id FROM ContentDocument WHERE Title = 'Test Document' LIMIT 1].Id,
            LinkedEntityId = cc.Id,
            ShareType = 'I'
        );
        insert existingContentLink;
        
        
        cc.Solution__c='Test';
        cc.CCM_Remarks__c='TestRemarks';    
        cc.Status='Closed';
        Update cc;
        
        trgNew.add(cc);
        
        CaseTriggerHandler.SendFeedbackEmail(trgNew,trgOldMap);
    }*/
    
    
    
    @isTest public static void SendFeedbackEmail1() {
        
        Account acc=new Account();
        acc.LastName='TestAccount1';
        acc.PersonEmail='test1email@email.com';
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        insert acc;
        
        Contact c = new Contact();
       // c.AccountId = acc.ID;
        c.FirstName = 'test';
        c.LastName = 'test';
        c.email = 'test@test.com';
        c.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
        c.birthdate = Date.newInstance(1992, 04, 12);
        insert c;
        
        List<Case> trgNew = new List<Case>();
        Map<Id,Case> trgOldMap = new Map<Id,Case>();
        
        User u = [Select Id from User Where Profile.Name ='T&L - Account Manager' AND IsActive = true limit 1];
        
        Case cc = new Case();
        cc.AccountId=acc.Id;
        cc.Status='New';
        cc.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Accident_Emergency_Transport_and_Leasing').getRecordTypeId();
        //cc.ContactId=c.Id;
        cc.Priority='Low';
      //  cc.Priority_T_L__c='Medium-Close with in 15 days';
         cc.Area__c ='Abu Dhabi';
        cc.Requestor_type__c='B2B';
        cc.Impacting_finances__c='Yes';
         cc.Subject='test';
        //cc.Area__c='Abu Dhabi';
        cc.Description='test';
        cc.ETDriver__c='Yes';
        cc.Origin='Email';

        System.runAs(u) {
            insert cc;
        }
        trgOldMap.put(cc.Id,cc);
        
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Document',
            VersionData = Blob.valueOf('Test Content'),
            PathOnClient = 'test.txt'
        );
        insert testContentVersion; 
        ContentDocumentLink existingContentLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id FROM ContentDocument WHERE Title = 'Test Document' LIMIT 1].Id,
            LinkedEntityId = cc.Id,
            ShareType = 'I'
        );
        insert existingContentLink;
        
        User u1= [Select Id,email from User where email ='akhil.john@smaartt.com'];
        cc.Solution__c='Test';
        cc.CCM_Remarks__c='TestRemarks';    
        cc.Status='Closed';
        System.runAs(u1) {
            Update cc;
        }
        
        trgNew.add(cc);
        
        CaseTriggerHandler.SendFeedbackEmail(trgNew,trgOldMap);
    }
    
}