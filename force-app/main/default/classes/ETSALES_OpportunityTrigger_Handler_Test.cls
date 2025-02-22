@isTest
public class ETSALES_OpportunityTrigger_Handler_Test {
    
    public  static testMethod void setupdata(){
        System.Test.startTest();
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        GL_Activity__c	test_Activity = new GL_Activity__c(Name= 'test_Activity', GL_Activity_Code__c = '0001');
        GL_Project__c	test_Project = new GL_Project__c (Name = 'test_Project', Project_Code__c = '0002');
        ETSALES_Department__c	test_Dept = new ETSALES_Department__c (Name = 'test_Dept' , Department_Code__c = '0003');
        ETSALES_Location__c	test_location  = new ETSALES_Location__c(Name = 'test_Location',Location_Code__c='0004');
        
        
        insert test_Activity;
        insert test_Project;
        insert test_Dept;
        insert test_location;
        
        User testUser  = new User(FirstName = 'fName', LastName = 'lName',email = 'test@123.com',GL_Activity_Code__c=test_Activity.GL_Activity_Code__c,
                                  GL_Project_Code__c=test_Project.Project_Code__c,GL_Location_Code__c=test_location.Location_Code__c,
                                  GL_Department_Code__c=test_Dept.Department_Code__c,ProfileId =userProfile.Id,ETSALES_Employee_Zone__c = 'Zone A',
                                  ETSALES_Location__c='Dubai',Username = '1fname@test.com',Alias = 'fname',TimeZoneSidKey='GMT',LocaleSidKey='en_IE_EURO',
                                  EmailEncodingKey ='ISO-8859-1',LanguageLocaleKey ='en_US',isActive=true);
        
        insert testUser;
        
        User_GL_Mapping__c mappingRecList = new User_GL_Mapping__c (Name = 'Test Mapping',User__c = testUser.Id,GL_Activity__c =test_Activity.Id ,
                                                                    GL_Department__c =test_Dept.Id ,ETSALES_GL_Location__c = test_location.Id,
                                                                    GL_Project__c= test_Project.Id);
        Insert mappingRecList;
        
        Account test_Account = new Account (Name = 'tstAccount', OwnerId =testUser.Id );
        test_Account.ETSALES_TaxRegistrationNo__c = '234567890987654';
        insert test_Account;
        
        Opportunity test_Opportunity = new Opportunity (Name = 'test Opportunity' ,AccountID = test_Account.Id,StageName = 'Qualification', CloseDate= System.today(),
                                                        OwnerId = testUser.Id,
                                                        ETSALES_GL_Services__c='Government School', 
                                                        Contract_Type__c= 'Standard',
                                                        Contract_Years__c= '1',
                                                        Contract_Months__c= '2',
                                                        Contract_Weeks__c= '2',
                                                        Contract_Days__c= '2',
                                                        Competitor__c= 'NO',
                                                        No_of_Vehicles__c= Decimal.valueOf('1'),
                                                        No_of_Used_Vehicles__c= Decimal.valueOf('1'),
                                                        No_of_Resources__c= Decimal.valueOf('1')
                                                        // ETSALES_Customer_Budget__c='1231AED'
                                                        
                                                       );
        insert test_Opportunity;
        ETSALES_Tender__c tender = new ETSALES_Tender__c(); 
        tender.Name = 'Test';
        insert tender;
        test_Opportunity.ETSALES_Tender__c = tender.Id;
        
        User testUser1  = new User(FirstName = 'fName1', LastName = 'lName1',email = 'test1@123.com',GL_Activity_Code__c=test_Activity.GL_Activity_Code__c,
                                   GL_Project_Code__c=test_Project.Project_Code__c,GL_Location_Code__c=test_location.Location_Code__c,
                                   GL_Department_Code__c=test_Dept.Department_Code__c,ProfileId =userProfile.Id,ETSALES_Employee_Zone__c = 'Zone A',
                                   ETSALES_Location__c='Dubai',Username = 'fname1@test.com',Alias = 'fname1',TimeZoneSidKey='GMT',LocaleSidKey='en_IE_EURO',
                                   EmailEncodingKey ='ISO-8859-1',LanguageLocaleKey ='en_US');
        
        insert testUser1;
        
        test_Opportunity.OwnerId = testUser1.Id;
        
        update test_Opportunity;
        
        list<Opportunity> oppList=new list<Opportunity>();
        oppList.add(test_Opportunity);
        
        System.Test.stopTest();
        
    }
    private static void testmethodInspection(){
        System.Test.startTest();
        
        // ETSALES_OpportunityTrigger_Handler.utilityMethod();
        //ETSALES_OpportunityTrigger_Handler.utilityMethod1();
        
        System.Test.stopTest();
        
        
    }
    
    static testMethod  void testmethod2(){
        
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        GL_Activity__c	test_Activity = new GL_Activity__c(Name= 'test_Activity', GL_Activity_Code__c = '0001');
        GL_Project__c	test_Project = new GL_Project__c (Name = 'test_Project', Project_Code__c = '0002');
        ETSALES_Department__c	test_Dept = new ETSALES_Department__c (Name = 'test_Dept' , Department_Code__c = '0003');
        ETSALES_Location__c	test_location  = new ETSALES_Location__c(Name = 'test_Location',Location_Code__c='0004');
        
        insert test_Activity;
        insert test_Project;
        insert test_Dept;
        insert test_location;
        
        User testUser  = new User(FirstName = 'fName', LastName = 'lName',email = 'test@123.com',GL_Activity_Code__c=test_Activity.GL_Activity_Code__c,
                                  GL_Project_Code__c=test_Project.Project_Code__c,GL_Location_Code__c=test_location.Location_Code__c,
                                  GL_Department_Code__c=test_Dept.Department_Code__c,ProfileId =userProfile.Id,ETSALES_Employee_Zone__c = 'Zone A',
                                  ETSALES_Location__c='Dubai',Username = '1fname@test.com',Alias = 'fname',TimeZoneSidKey='GMT',LocaleSidKey='en_IE_EURO',
                                  EmailEncodingKey ='ISO-8859-1',LanguageLocaleKey ='en_US');
        
        insert testUser;
        
        User_GL_Mapping__c mappingRecList = new User_GL_Mapping__c (Name = 'Test Mapping',User__c = testUser.Id,GL_Activity__c =test_Activity.Id ,
                                                                    GL_Department__c =test_Dept.Id ,ETSALES_GL_Location__c = test_location.Id,
                                                                    GL_Project__c= test_Project.Id);
        Insert mappingRecList;
        
        Account test_Account = new Account (Name = 'tstAccount', OwnerId =testUser.Id, ETSALES_TaxRegistrationNo__c = '234567890987654' );
        
        insert test_Account;
        Id accountRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
        
        
        Opportunity test_Opportunity = new Opportunity (Name = 'test Opportunity' ,AccountID = test_Account.Id,StageName = 'Qualification', CloseDate= System.today(),
                                                        OwnerId = testUser.Id,
                                                        ETSALES_GL_Services__c='Bus', 
                                                        Contract_Type__c= 'Standard',
                                                        Contract_Years__c= '1',
                                                        Contract_Months__c= '2',
                                                        Contract_Weeks__c= '2',
                                                        Contract_Days__c= '2',
                                                        Competitor__c= 'NO',
                                                        No_of_Vehicles__c= Decimal.valueOf('1'),
                                                        No_of_Used_Vehicles__c= Decimal.valueOf('1'),
                                                        No_of_Resources__c= Decimal.valueOf('1'),
                                                        // ETSALES_Customer_Budget__c='1231AED'
                                                        Amount=1200,
                                                        Proposed_Amount__c=100
                                                        
                                                       );
        
        test_Opportunity.RecordTypeId=accountRecordTypeId;
        try{
            insert test_Opportunity;
        }
        catch (Exception ex) {
            System.debug('Exception'+ex);
        }
        
        
        
        
        
        
        List<Opportunity> opplist = new List<Opportunity>();
        oppList.add(test_Opportunity);
        System.Test.startTest();
        ETSALES_OpportunityTrigger_Handler.OppValidationOnStage(opplist); 
        ETSALES_OpportunityTrigger_Handler.OppTypeValidationForInsert(opplist);  
        Map<Id, Opportunity> oppNewMap2 = new Map<Id, Opportunity>([SELECT Id, Amount, Contract_Years__c, Contract_Years_Previous_Contract__c,
                                                                    Contract_Months__c, Contract_Months_Previous_Contract__c,
                                                                    Contract_Weeks__c, Contract_Weeks_Previous_Contract__c,
                                                                    Contract_Days__c, Contract_Days_Previous_Contract__c,
                                                                    Amount_Previous_Contract__c,Type,RecordTypeId
                                                                    FROM Opportunity WHERE Id = :test_Opportunity.Id]);
        ETSALES_OpportunityTrigger_Handler.OppTypeValidationForInsert(opplist);  
        ETSALES_OpportunityTrigger_Handler.OppTypeValidationForUpdate(opplist, oppNewMap2);  
        System.Test.stopTest();
        
        
    }
    
    
    
    
    /* Added by Sreelakshmi SK-- START 08/03/2023 */
    public static testmethod void testadditionalGrowthFormula1(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.AccountNumber = '123';
        acc.ETSALES_TaxRegistrationNo__c = '234567890987654';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'John';
        con.LastName = 'Doe';
        con.AccountId = acc.Id;
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.Type = 'New Business';
        opp.StageName = 'Qualification';
        opp.RecordTypeId= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
        opp.CloseDate = date.Today();
        opp.Name = 'Test Opportunity';
        opp.Amount = 1000;
        opp.Amount_Previous_Contract__c = 2000;
        opp.Contract_Years__c = '1';
        opp.Contract_Years_Previous_Contract__c = null;
        opp.Contract_Months__c = null;
        opp.Contract_Months_Previous_Contract__c = '6';
        opp.Contract_Weeks__c = null;
        opp.Contract_Weeks_Previous_Contract__c = null;
        opp.Contract_Days__c = null;
        opp.Contract_Days_Previous_Contract__c = null;
        opp.AccountId=acc.Id;
        opp.Proposed_Amount__c=100;
        
        insert opp;
        
        Map<Id, Opportunity> oppOldMap = new Map<Id, Opportunity>();
        oppOldMap.put(opp.Id, opp);
        
        
        
        opp.Amount = 500;
        opp.Contract_Years__c = '1';
        update opp;
        
        Map<Id, Opportunity> oppNewMap = new Map<Id, Opportunity>([SELECT Id, Amount, Contract_Years__c, Contract_Years_Previous_Contract__c,
                                                                   Contract_Months__c, Contract_Months_Previous_Contract__c,
                                                                   Contract_Weeks__c, Contract_Weeks_Previous_Contract__c,
                                                                   Contract_Days__c, Contract_Days_Previous_Contract__c,
                                                                   Amount_Previous_Contract__c,Type,RecordTypeId
                                                                   FROM Opportunity WHERE Id = :opp.Id]);
        ETSALES_OpportunityTrigger_Handler.additionalGrowthFormula(oppNewMap, oppOldMap);
        
        
        
        
        opp.Amount = 500;
        opp.Contract_Years__c = null;
        opp.Contract_Months__c='3';
        opp.Contract_Years_Previous_Contract__c='4';
        try
        {
            update opp;
        }
        Catch(exception e){
            
        }
        
        Map<Id, Opportunity> oppNewMap1 = new Map<Id, Opportunity>([SELECT Id, Amount, Contract_Years__c, Contract_Years_Previous_Contract__c,
                                                                    Contract_Months__c, Contract_Months_Previous_Contract__c,
                                                                    Contract_Weeks__c, Contract_Weeks_Previous_Contract__c,
                                                                    Contract_Days__c, Contract_Days_Previous_Contract__c,
                                                                    Amount_Previous_Contract__c,Type, RecordTypeId
                                                                    FROM Opportunity WHERE Id = :opp.Id]);
        ETSALES_OpportunityTrigger_Handler.additionalGrowthFormula(oppNewMap1, oppOldMap);
        
        
        
        opp.Amount = 500;
        opp.Contract_Years__c = null;
        opp.Contract_Months__c='3';
        opp.Contract_Years_Previous_Contract__c=null;
        opp.Contract_Months_Previous_Contract__c='4';
        try
        {
            update opp;
        }
        Catch(exception e){
            
        }
        
        
        Map<Id, Opportunity> oppNewMap2 = new Map<Id, Opportunity>([SELECT Id, Amount, Contract_Years__c, Contract_Years_Previous_Contract__c,
                                                                    Contract_Months__c, Contract_Months_Previous_Contract__c,
                                                                    Contract_Weeks__c, Contract_Weeks_Previous_Contract__c,
                                                                    Contract_Days__c, Contract_Days_Previous_Contract__c,
                                                                    Amount_Previous_Contract__c,Type,RecordTypeId
                                                                    FROM Opportunity WHERE Id = :opp.Id]);
        ETSALES_OpportunityTrigger_Handler.additionalGrowthFormula(oppNewMap2, oppOldMap);
        
        
    }
    
    
    /* Added by Sreelakshmi SK-- END */
    
    
    
    
}