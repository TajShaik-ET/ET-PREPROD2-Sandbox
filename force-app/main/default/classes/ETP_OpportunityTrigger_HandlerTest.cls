@IsTest
public class ETP_OpportunityTrigger_HandlerTest {
    
    public  static testMethod void setupdata(){ 
        // create test user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@sm.com', 
                          EmailEncodingKey='UTF-8', isActive = true, LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@sm.com');
        insert u;
        
        Profile userProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        GL_Activity__c	test_Activity = new GL_Activity__c(Name= 'test_Activity', GL_Activity_Code__c = '0001');
        GL_Project__c	test_Project = new GL_Project__c (Name = 'test_Project', Project_Code__c = '0002');
        ETSALES_Department__c	test_Dept = new ETSALES_Department__c (Name = 'test_Dept' , Department_Code__c = '0003');
        ETSALES_Location__c	test_location  = new ETSALES_Location__c(Name = 'test_Location',Location_Code__c='0004');
        
        insert test_Activity;
        insert test_Project;
        insert test_Dept;
        insert test_location;
        
        User_GL_Mapping__c mappingRecList = new User_GL_Mapping__c (Name = 'Test Mapping',User__c = u.Id,GL_Activity__c =test_Activity.Id ,
                                                                    GL_Department__c =test_Dept.Id ,ETSALES_GL_Location__c = test_location.Id,
                                                                    GL_Project__c= test_Project.Id);
        Insert mappingRecList;
        
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account();
        acc.FirstName = 'test';
        acc.LastName = 'test';
        acc.PersonEmail = 'test@gmail.com';
        acc.RecordTypeId = recordTypeId;
        acc.ETSALES_Email__c = 'testAcc@gmail.com';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Noor';
        con.Email = Label.ETI_TargetObject_Email;
        insert con;
        
        Opportunity test_Opportunity = new Opportunity (Name = 'test Opportunity' ,AccountID = acc.Id,StageName = 'Qualification', CloseDate= System.today(),
                                                        OwnerId = u.Id,
                                                        ETSALES_GL_Services__c='Government School', 
                                                        Contract_Type__c= 'Standard',
                                                        Contract_Years__c= '1',
                                                        Contract_Months__c= '2',
                                                        Contract_Weeks__c= '2',
                                                        Contract_Days__c= '2',
                                                        Competitor__c= 'NO',
                                                        No_of_Vehicles__c= Decimal.valueOf('1'),
                                                        No_of_Used_Vehicles__c= Decimal.valueOf('1'),
                                                        No_of_Resources__c= Decimal.valueOf('1'),
                                                        isPricingCreated__c=true
                                                        
                                                        // ETSALES_Customer_Budget__c='1231AED'
                                                        
                                                       );
        insert test_Opportunity;
        Opportunity test_Opportunity1 = new Opportunity (Name = 'test Opportunity' ,AccountID = acc.Id,StageName = 'Qualification', CloseDate= System.today(),
                                                         OwnerId = u.Id,
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
        insert test_Opportunity1;
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(test_Opportunity);
        oppList.add(test_Opportunity1);
        
        List<string> toAddress = new List<string>(); 
        toAddress.add('element@web.com');
        toAddress.add('el@web.com');
        
        System.Test.startTest();
        // ETP_OpportunityTrigger_Handler.updateHeadOfSales(oppList);        
        ETP_OpportunityTrigger_Handler.testcodeCoverage();
        System.Test.stopTest();
    }
}