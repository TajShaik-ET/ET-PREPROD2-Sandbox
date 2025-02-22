@isTest
public class ET_BusinessCommunityController_Test{
    
    @isTest public static void  insertnewdata(){
        Account accoun;
        Contact c;
        User user;
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and isActive=true LIMIT 1];
        system.runas(admin)    {
            accoun = new Account();
            //accoun.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account').getRecordTypeId();
            accoun.Name = 'test corp';
            accoun.phone= '01123123';
            accoun.billingcity='London';
            accoun.billingpostalcode='SW1635HJ';
            accoun.billingcountry='United Kingdom';
            accoun.billingstreet='address 1';
            insert accoun;
            
            
            c = new Contact();
            c.AccountId = accoun.ID;
            c.FirstName = 'test';
            c.LastName = 'test';
            c.email = 'test@test.com';
            c.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
            c.birthdate = Date.newInstance(1992, 04, 12);
            insert c;
            
            ETST_School__c sch = new ETST_School__c();
            sch.Name='test';
            insert sch;
            
            ETST_Student__c student = new ETST_Student__c();
            student.Name='test';
            student.ETST_Emirates_Id__c= '784-8526-8521475-8';
            student.ETST_Student_Id__c='7895236';
            student.ETST_Gender__c='Male';
            student.ETST_Nationality__c='China';
            student.ETST_Date_of_Birth__c=Date.newInstance(1992, 04, 12);
            student.ETST_Division__c='2';
            student.ETST_Grade__c='A';
            student.ETST_Emirate__c='Dubai';
            student.ETST_Phone__c='+971789456123';
            student.ETST_ParentEID__c=accoun.Id;
            //student.ETST_School__c=sch.Id;
            insert student;
            
            ET_Sales_Agreement__c salA = new ET_Sales_Agreement__c();
            salA.Name='test';
            salA.Customer_PO_No__c='852963';
            
            salA.Salesforce_Customer__c=accoun.id;
            insert salA;
            
            SALine_Assigned_Resource__c assRes = new SALine_Assigned_Resource__c ();
            assRes.Name='test';
            assRes.Sales_Agreement__c=salA.id;
            assRes.Assign_End_Date__c=Date.newInstance(2022, 12, 12);
            insert assRes;
            
            ETST_Student__c studentRec = [select Id,Name,ETST_Account_Name__c from ETST_Student__c LIMIT 1];
            
           
            
            
            /*Profile prof = [select id from profile where name ='Partner Community login User'];
user = new User();
user.firstName = 'test1';
user.lastName = 'test2';
user.contactid=c.id;
user.profileId = prof.id;
user.username = 'test1@uichangeset.com';
user.email = 'test@test.com';
user.Alias='test';
user.TimeZoneSidKey='Asia/Dubai';
user.LocaleSidKey='en_IE_EURO';
user.EmailEncodingKey='ISO-8859-1';
user.LanguageLocaleKey='en_US';
insert user;*/
        }
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Salesforce_Customer__c = accoun.id;
        etSales.Contract_No__c='123223';
        insert etSales;
        SALine_Assigned_Vehicle__c etVehic = new SALine_Assigned_Vehicle__c();
       // etVehic.Vehicle_Number__c='123223';
       // etVehic.Vehicle_Description__c='Test Vehicle';
        etVehic.Sales_Agreement__c=etSales.id;
        etVehic.Name='Test';
        insert etVehic;
        SALine_Assigned_Resource__c etReso = new SALine_Assigned_Resource__c();
        etReso.Assign_End_Date__c=Date.newInstance(2022, 12, 12);
        //etReso.Employee_ID__c='123223';
        etReso.Name='Test resource';
        etReso.Sales_Agreement__c=etSales.id;
        etReso.ETST_Assigned_Vehicle__c=etVehic.id;
        insert etReso;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc2 = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test');
        insert acc2;
        ETST_School__c schl = new ETST_School__c(Name='Test', Customer__c = accoun.Id);
        insert schl;
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_Account_Name__c=acc2.Id);
        insert stdnt;      
        ET_Service_Request__c  etreq = new ET_Service_Request__c(Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Paid_By__c = 'Self');
        insert etreq;  
        Invoice__c inv = new Invoice__c(ETST_Active__c=true,ETST_Type__c='Online',Service_Request__c=etreq.Id,Sales_Agreement__c=etSales.id);
        insert inv;
        
        List<case> cslist= new List<Case>();
        for(Integer i=0;i<10;i++){
            Case cs= new Case();
            cs.Accountid=accoun.id;
            cs.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('B2B_Business_Portal_Cases').getRecordTypeId();
            cs.contactid=c.id;
            if(i<3){
                cs.status='New';
                cs.Assigned_Resource__c=etReso.id;
                cs.Case_Types__c='Request for Awareness Session';
                cs.ET_B2B_Complaint_Against__c='Assigned Resource';
            }
            else if(i>2 && i<5){
                cs.status='Submitted for ADEC';
                cs.Assigned_Vehicle__c=etVehic.id;
                cs.ET_B2B_Complaint_Against__c='Assigned Vehicle';
                
            }
            else if(i>4 && i<8){
                cs.status='New';
                cs.Invoice__c=inv.id;
                cs.Case_Types__c='Evaluation of Schools/Services';
                cs.ET_B2B_Complaint_Against__c='Invoices';
                
            }
            else{
                cs.status='Submitted for ADEC';
                cs.Sales_Agreement__c=etSales.id;
                cs.Case_Types__c='Evaluation of Schools/Services';
                cs.ET_B2B_Complaint_Against__c='Sales Agreement';
                
            }
            cslist.add(cs);
        }
        insert cslist;
        Case cs=cslist[0];
        List<case> crespList= new List<Case>();
        List<Id> idlist = new List<Id>();
        Case cse=new Case();
        cse.Accountid=accoun.id;
            cse.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('B2B_Business_Portal_Cases').getRecordTypeId();
            cse.contactid=c.id;
        
                cse.status='New';
                cse.Assigned_Resource__c=etReso.id;
                cse.Case_Types__c='Request for Awareness Session';
                cse.ET_B2B_Complaint_Against__c='Assigned Resource';
        insert cse;
        Case cse1=new Case();
        cse.Accountid=accoun.id;
            cse1.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('B2B_Business_Portal_Cases').getRecordTypeId();
            cse1.contactid=c.id;
                cse1.status='New';
                cse1.Assigned_Resource__c=etReso.id;
                cse1.Case_Types__c='Request for Awareness Session';
                cse1.ET_B2B_Complaint_Against__c='Assigned Resource';
        insert cse1;
   
        idlist.add(cse.Id);
      // idlist.add(cse1.Id);
        //insert idlist;
        
        
        
        
        List<Id> saleslist = new List<Id>();
        ET_Sales_Agreement__c salA = new ET_Sales_Agreement__c();
            salA.Name='test';
            salA.Customer_PO_No__c='852963';
            
            salA.Salesforce_Customer__c=accoun.id;

            insert salA;
            saleslist.add(salA.Id);

             SALine_Assigned_Resource__c assRes = new SALine_Assigned_Resource__c ();
            assRes.Name='test';
            assRes.Sales_Agreement__c=salA.id;
            assRes.Assign_End_Date__c=Date.newInstance(2022, 12, 12);
            insert assRes;
      
        
        system.runAs(new User(Id=Userinfo.getUserId())){
            system.debug('---------->='+cslist);
            Test.startTest();
            String response ;
            String responseticket ;
            ET_BusinessCommunityController.MyBusinessWrapper testwrap= new ET_BusinessCommunityController.MyBusinessWrapper();
           //testwrap =ET_BusinessCommunityController.getUserAccountDetailsCRM(assRes.Id, 'Assigned vehicle');
           // ET_BusinessCommunityController.getCustomerCareDetails(cs.CaseNumber,'New',etSales.id,etReso.id,etVehic.id,inv.id);
            System.assertnotequals(crespList.size(),null);
           // ET_BusinessCommunityController.utilityMethod();
            //ET_BusinessCommunityController.getprivateschoolUserData();
            ET_BusinessCommunityController.getstudentDetails(stdnt.Id);
            ET_BusinessCommunityController.getParentUserDetails(stdnt.Id);
            ET_BusinessCommunityController.showResourcesforMonth(accoun.Name, 06) ; 
            ET_BusinessCommunityController.showVehiclesforMonth(accoun.Name, 12);
            ET_BusinessCommunityController.getPODetails(accoun.Name);
            ET_BusinessCommunityController.getCaseDetails('All');
            ET_BusinessCommunityController.deleteMOECase(cs.Id);
            ET_BusinessCommunityController.rejectMOECase(cs.Id, 'comment');
            ET_BusinessCommunityController.closeMOECase(cs.Id, 'comment');
             ET_BusinessCommunityController.approveMOECase(cs.Id, 'comment','comment','comment','comments');
            ET_BusinessCommunityController.submitForApproval(cs.Id);
            ET_BusinessCommunityController.getCaseData(cs.Id);
            ET_BusinessCommunityController.fetchLookUpValues('test', 'Account');
          //  ET_BusinessCommunityController.updateMOECaseStatus('idlist', 'New', 'test', '98746985', 'Comments');
            ET_BusinessCommunityController.getCustomerCareDetailsMoeCases('test', 'New', 'salesAgId', 'assignedResId', 'assignedVehId', 'stdID');
            //ET_BusinessCommunityController.getUserAccountDetailsCRM(assRes.Id, 'Invoice');
            //ET_BusinessCommunityController.getCustomerCareDetails('0025', 'New', 'salesAgId', 'assignedResId', 'assignedVehId', 'stdID');
          ET_BusinessCommunityController.utilityMethod();
            ET_BusinessCommunityController.utilityMethodA();
            ET_BusinessCommunityController.getDashboardData();
            ET_BusinessCommunityController.getDashboardDataCustomerCare();
           // ET_BusinessCommunityController.GetAvailableRecordTypeCase();
           // ET_BusinessCommunityController.getSiteDetails();
           // ET_BusinessCommunityController.getESEReqLineList(cs.Id);
            //ET_BusinessCommunityController.getschoolDetails(cs.Id);
            ET_BusinessCommunityController.getArabicFieldValue();
            ET_BusinessCommunityController.getEnglisValue();
            Test.stopTest();
        } 
    } 
    
    @isTest public static void testmethod2(){
        Account account;
        Contact con;
        User user;
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and isActive=true LIMIT 1];
        system.runas(admin){
            
              try
              {
                  account = new Account();
            account.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Organization').getRecordTypeId();
            account.Name = 'test corp';
            account.phone= '01123123';
            account.billingcity='London';
            account.billingpostalcode='SW1635HJ';
            account.billingcountry='United Kingdom';
            account.billingstreet='address 1';
            insert account;
            
            con = new Contact();
            //con.Name='Test';
            con.LastName='test123';
            con.email = 'test@test.com';
            insert con;
            
            ETST_School__c sch = new ETST_School__c();
            sch.Name='test';
            insert sch;
            
            ETST_Student__c student = new ETST_Student__c();
            student.Name='test';
            student.ETST_Emirates_Id__c= '784-8526-8521475-8';
            student.ETST_Student_Id__c='7895236';
            student.ETST_Gender__c='Male';
            student.ETST_Nationality__c='China';
            student.ETST_Date_of_Birth__c=Date.newInstance(1992, 04, 12);
            student.ETST_Division__c='2';
            student.ETST_Grade__c='A';
            student.ETST_Emirate__c='Dubai';
            student.ETST_Phone__c='+971789456123';
            student.ETST_ParentEID__c=account.Id;
            student.ETST_School__c=sch.Id;
            insert student;
            
            Case cs = new  Case();
            //cs.Account=account.id;
            //cs.Contact=con.Id;
            cs.Subject='Test Case';
            cs.Status='in progress';
            cs.Origin='CRM';
            
            
            insert cs;
            Case updatedCase = [SELECT Id, Subject,Status, Origin FROM Case WHERE Id = :cs.Id];
            System.assertEquals(updatedCase.Subject, 'Test Case');
            Test.startTest();
            ET_BusinessCommunityController.getParentUserDetails('156173');
            Test.stopTest(); 
                  
              }
            catch(NullPointerException e)
        {
          System.debug('NullPointerException'+e);
        }
           
        }

}
     
     @isTest
    static void fetchRecordsTest1() {
       ETST_Student__c  student = new ETST_Student__c();
         student.Name='test';
         student.ETST_Full_Name_AR__c='abc';
            student.ETST_Emirates_Id__c= '784-8526-8521475-8';
            student.ETST_Student_Id__c='7895236';
            student.ETST_Gender__c='Male';
            student.ETST_Nationality__c='China';
            student.ETST_Date_of_Birth__c=Date.newInstance(1992, 04, 12);
            student.ETST_Division__c='2';
            student.ETST_Grade__c='A';
            student.ETST_Emirate__c='Dubai';
            student.ETST_Phone__c='+971789456123';
           // student.ETST_ParentEID__c=accoun.Id;
        insert student;
        
        List<ET_BusinessCommunityController.RecordsData> result = ET_BusinessCommunityController.fetchRecords('ETST_Student__c', 'ETST_Full_Name_AR__c', 'abc', '');
        System.assertEquals(result != null, true);
    }
    
    @isTest
    static void fetchRecordsTest2() {
        ETST_Student__c student = new ETST_Student__c();
        student.Name='test';
        student.ETST_Full_Name_AR__c='abc';
        student.ETST_Emirates_Id__c= '784-8526-8521475-8';
        student.ETST_Student_Id__c='7895236';
        student.ETST_Gender__c='Male';
        student.ETST_Nationality__c='China';
        student.ETST_Date_of_Birth__c=Date.newInstance(1992, 04, 12);
        student.ETST_Division__c='2';
        student.ETST_Grade__c='A';
        student.ETST_Emirate__c='Dubai';
        student.ETST_Phone__c='+971789456123';
      //  student.ETST_ParentEID__c=accoun.Id;
        insert student;
        
        List<ET_BusinessCommunityController.RecordsData> result = ET_BusinessCommunityController.fetchRecords('ETST_Student__c', 'ETST_Full_Name_AR__c', 'Test', student.ID);
        
        System.assertEquals(result.size(), 1);
    }
    
    @isTest
    static void fetchRecordsNegativeTest() {
        try {
        	List<ET_BusinessCommunityController.RecordsData> result = ET_BusinessCommunityController.fetchRecords('', 'ETST_Full_Name_AR__c', 'Test', '');
        } catch(Exception ex) {
            System.assertNotEquals(ex.getMessage(), NULL);
        }
    }
    
    @isTest
    static void eseCaseApprovaltest() {
        // Create test data
        Account tAccount = new Account();
        tAccount.Name='Smaartt Digitals';
        tAccount.phone= '01123123';
        tAccount.billingcity='London';
        tAccount.billingpostalcode='SW1635HJ';
        tAccount.billingcountry='United Kingdom';
        tAccount.billingstreet='address 1';
        insert tAccount;
        
        Contact tContact = new Contact();
        tContact.AccountId = tAccount.ID;
        tContact.FirstName = 'test';
        tContact.LastName = 'test';
        tContact.email = 'test@test.com';
        tContact.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
        tContact.birthdate = Date.newInstance(1992, 04, 12);
        insert tContact;
        
        User tUser = new User();
        tUser.ContactId = tContact.Id;
        tUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Govt School Partner User Login' LIMIT 1].Id;
        tUser.Alias = 'standt1';
        tUser.Email='testemail@12.com'; 
        tUser.EmailEncodingKey='UTF-8'; 
        tUser.LastName='Testing'; 
        tUser.LanguageLocaleKey='en_US'; 
        tUser.LocaleSidKey='en_US'; 
        tUser.TimeZoneSidKey='America/Los_Angeles'; 
        tUser.UserName='standarduser12332@testorg.com';
        
        insert tUser;
        
        
        
        Case tCase = new Case();
        tCase.AccountId=tAccount.Id;
        tCase.ContactId=tContact.Id;
        tCase.Status_Category__c='Pending with Department Of School Activities';
        tCase.Subject='Actvity';
        tCase.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ESE_Issue').getRecordTypeId();
        //tCase.RecordTypeId='0123M000000cOfYQAU';
        insert tCase;
        
        
        // Start test
        Test.startTest();
        
        // Call the method you want to test
        ET_BusinessCommunityController.customerCaseApprovalProcess(tCase.Id, 'Your test case comments');
        
        // End test
        Test.stopTest();
        
        // Perform assertions to verify the results
      List<Case> updatedCase = [SELECT Id, Sub_Status__c, Status_Category__c FROM Case WHERE Id = :tCase.Id LIMIT 1];
        Integer numberOfRecords = updatedCase.size();
        System.debug('Number of records returned: ' + numberOfRecords);
       
    }
}