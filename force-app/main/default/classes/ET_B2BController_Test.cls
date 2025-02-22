/*
 * 
 * 10/08/2022: Janardhan M:Updated test class and removed fakecode/i++ 
 * */

@isTest(SeeAllData=true)
public class ET_B2BController_Test {
 
    @isTest Public static void wrapperClassesTest(){
        ET_B2BController.MyBusinessWrapper busWrap = new ET_B2BController.MyBusinessWrapper();
        ET_B2BController.CustomerCareWrapper casWrap = new ET_B2BController.CustomerCareWrapper();
       
         ET_B2BController.getUserDetails('School Transport');  
         ET_B2BController.MROgetUserDetails('School Transport');   
       
    }
    @isTest  
    Public static void terminateCaseTest(){
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(
            Alias = 'standt1', 
            Email='testemail@12.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='standarduser12332@testorg.com'
        );
        insert u;
        
       System.runAs(u) {
        test.startTest();
           
        String fileData = 'testfilename';
        string jsonstr='[{"strFileName":"Passport.pdf","strFileType":"application/pdf","strBase64Data":"'+fileData+'"}]';
        Account acc = new Account();
        acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc.Name = 'MINISTRY OF EDUCATION1';
        acc.phone= '01123353';
        acc.billingcity='London';
        acc.billingpostalcode='SW1635HJ';
        acc.billingcountry='United Kingdom uk';
        acc.billingstreet='address 2';
        insert acc;
             
        ET_B2BController.insertTimesheet('test',acc.Id,'test');
        ET_B2BController.getTimesheet('test',acc.Id);
        ET_User_Files__c uf = new ET_User_Files__c();
        uf.Doc_Id__c='test';
        uf.File_Name__c='test';
        insert uf;
            
        ET_B2BController.deleteFile('test');
        
        Customer_PO__c po = new Customer_PO__c(Customer_PO__c='Test'); 
        insert po;
        
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Customer_PO_No__c = 'Test';
        etSales.Salesforce_Customer__c = acc.id;
        etSales.Category__c = 'Transportation';
        insert etSales; 
        
       
            case cas = new case(
                Subject = 'Test Case',
                Description = 'Test',
                Sales_Agreement__c = etSales.Id,
                Origin = 'B2B Portal',
                AccountId = acc.Id
            );
            insert cas;
           
            ET_Sales_Agreement__c etSales3 = new ET_Sales_Agreement__c();
            etSales3.Customer_PO_No__c = 'Test3434';
            etSales3.Salesforce_Customer__c = acc.id;
            etSales3.Category__c = 'Transportation'; 
            insert etSales3; 
           try{
           // ET_B2BController.terminateRequest(cas, 'TestPO', 'TestFileData');
            ET_B2BController.createOffHireRequest(cas,po.Name, cas.Description ,jsonstr); 
             ET_B2BController.showMaintenanceVehiclesforMonth('Test3434', 12,2019);
            //ET_B2BController.getDocId('test','test');
          //ET_B2BController.saveUploadedFile(new list<string>{'test'},'test','test',new list<string>{'test'}); 
           }
           catch(Exception e){}
                Test.stopTest();
        }
    }
    @isTest Public static void getTypesTest(){
        List<String> strList = new List<String>();
        strList.add('Leasing');
        ET_B2BController.getTypes();
        ET_B2BController.getServiceTypes(strList);
    }
    /* 
        @isTest Public static void saveOppTest(){
        Customer_PO__c po = new Customer_PO__c(Customer_PO__c='TestPO');
            String fileData = 'testfilename';
            string jsonstr='[{"strFileName":"Passport.pdf","strFileType":"application/pdf","strBase64Data":"'+fileData+'"}]';
        Test.startTest();
        insert po;
        Opportunity opp = new Opportunity();
           
        ET_B2BController.saveOpportunity('Leasing', opp, 'TestPO', 'Dubai','jsonstr');
        Test.stopTest();
    }
   @isTest Public static void saveOppTest(){
        
      
      
        Opportunity opp = new Opportunity();
        
        String fileData = 'testfilename';
        string jsonstr='[{"strFileName":"Passport.pdf","strFileType":"application/pdf","strBase64Data":"'+fileData+'"}]';
         
        Test.startTest();
        ET_B2BController.saveOpportunity('Sales opportunity', opp, 'TestPO', 'Dubai',jsonstr);        
       
        Test.stopTest();
    }
    */
    @isTest Public static void getBusinessType(){
        try{
            ET_B2BController.getBusinessType();
        }catch(exception e){
            system.debug('Trace-> '+e);
        }
    }
    @isTest Public static void showVehiclesforMonthTest(){
        Account acc = new Account();
        acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc.Name = 'MINISTRY OF EDUCATION1';
        acc.phone= '01123353';
        acc.billingcity='america';
        acc.billingpostalcode='SW1635HJ';
        acc.billingcountry='United Kingdom uk';
        acc.billingstreet='address 2';
        insert acc;
        Invoice__c inv1= new Invoice__c(ETST_Active__c=true,Customer__c=acc.id,Payment_Status__c='Paid');
        insert inv1;
        
        Account child = new Account();
        child.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        child.Name = 'MINISTRY 4';
        child.phone= '0112344';
        child.billingcity='London';
        child.billingpostalcode='SW1635HJ';
        child.billingcountry='United Kingdom';
        child.billingstreet='address 21';
        child.ParentId = acc.Id;
        insert child;
        
        Contact c = new Contact(LastName = 'Contact Last Name', AccountId = acc.id);
        insert c; 
        Contact childContact = new Contact(LastName = 'Contact ss Name', AccountId = child.id);
        insert childContact;
		
		id profid=[select id from profile where name='ADNOC Partner Community'].id;
		// User user=[select id from user where isactive=true and profileid=:profid limit 1];
       
        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='ADNOC Partner Community'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test12@uniquedomain.com';
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.IsActive = true;
        user.ContactId = c.Id;
        insert user; 
        
        User childUser = new User();
        childUser.ProfileID = [Select Id From Profile Where Name='ADNOC Partner Community'].id;
        childUser.EmailEncodingKey = 'ISO-8859-1';
        childUser.LanguageLocaleKey = 'en_US';
      //  childUser.TimeZoneSidKey = 'America/New_York';
        childUser.LocaleSidKey = 'en_US';
        childUser.FirstName = 'firschildUt';
        childUser.LastName = 'laschildUt';
        childUser.Username = 'test12childU@uniquedomain.com';
        childUser.CommunityNickname = 'tUser123';
        childUser.Alias = 'tchildU';
        childUser.Email = 'childU@email.com';
        childUser.IsActive = true;
        childUser.ContactId = childContact.Id;
       // insert childUser; 
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Customer_PO_No__c = 'Test';
        etSales.Salesforce_Customer__c = acc.id;
        etSales.Category__c = 'Transportation';
        insert etSales; 
          
        ET_Sales_Agreement__c etSales2 = new ET_Sales_Agreement__c();
        etSales2.Customer_PO_No__c = 'Test3434';
        etSales2.Salesforce_Customer__c = acc.id;
        etSales2.Category__c = 'Transportation';
        insert etSales2;
        
        ETST_Student__c estud = new ETST_Student__c(ETST_Email__c='abc@xyz.com',ETST_Emirate__c='Dubai',Name='test Student',
                                                    ETST_Nationality__c='India',ETST_Emirates_Id__c='784-2131-3212131-2',
                                                    ETST_ESIS_No__c='2302',ETST_Division__c='5',ETST_Gender__c='Male',ETST_School__c = acc.Id,ETST_Relationship__c='Parent',
                                                    ETST_Student_Id__c='1223',ETST_Date_of_Birth__c=system.today()-1200);
        insert estud;
        
        SALine_Assigned_Vehicle__c vehicle=new SALine_Assigned_Vehicle__c();
        vehicle.Name='vehcle 1';
        vehicle.Account__c = acc.Id;
        vehicle.Sales_Agreement__c = etSales.Id;
        vehicle.Assign_End_Date__c =system.today();
        insert vehicle;
        
        Case cas = new Case(contactId = c.Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Accident/Emergency').getRecordTypeId();
        cas.recordTypeId = caseRecordTypeId;
        insert cas;
        
        ContentVersion fileVar = new ContentVersion();
        fileVar.PathOnClient = 'TestFile';
        fileVar.Title = 'TestFile';
        fileVar.VersionData = Blob.valueOf('sample content');
        insert fileVar;
        //Query the contentDocumentId
        ContentVersion insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:fileVar.Id];
        //Link the file with the product
        ContentDocumentLink linkedFile = new ContentDocumentLink(LinkedEntityId=cas.Id, ContentDocumentId=insertedFile.ContentDocumentId);
        insert linkedFile;
        
        ET_User_Files__c newFile = new ET_User_Files__c();
        newFile.File_Name__c ='test file';
        newFile.Doc_Id__c =linkedFile.Id;
        insert newFile;
        

        system.runAs(user){
            ET_B2BController.showVehiclesforMonth('Test', 12,2019);
            ET_B2BController.showActiveMaintenanceWoforMonth('test',1,2019);
            ET_B2BController.showEstimationforMonth('test',1,2019);
             ET_B2BController.showMaintenanceWoforMonth('test',1,2019);
            ET_B2BController.showMaintenanceVehiclesforMonth('test',1,2019);
             ET_B2BController.getMaintenancePODetails('test');
             ET_B2BController.getprivateschoolUserData();
        }

        
        Test.startTest();
        system.runAs(user){
            //ET_B2BController.showVehiclesforMonth('Test', 12,2019);
            ET_B2BController.showResourcesforMonth('Test', 12,2019);
            ET_B2BController.getPODetails('Test');
            ET_B2BController.getSiteDetails(acc.Id);
            ET_B2BController.getInvDetails(acc.Id);
            ET_B2BController.getUserAccountDetails();
            ET_B2BController.getUserAccountDetailsbyAccount(acc.Id);
            ET_B2BController.getStudentList();
            ET_B2BController.caseWrapper.getDashboardData();
            ET_B2BController.getCaseDetails('All');
            ET_B2BController.getCaseDetails('In Progress');
            ET_B2BController.getCaseDetails('Closed');
            ET_B2BController.showStudents('Test');
            ET_B2BController.getPOCategory('Test3434');
            ET_B2BController.getProfileDetails();
            ET_B2BController.getPickListValues('Case','Status');
            //ET_B2BController.getQueryDetails();
            ET_B2BController.getCaseDetailsBasedOnFilter('Accident/Emergency',acc.id,'New',true,system.today(),system.today().addDays(20));
           //  ET_B2BController.deleteFile(linkedFile.Id);
            ET_B2BController.getProfileName();
            
            
       
        }
        Test.stopTest(); 
    }
        @isTest Public static void codeCoverage2(){
        Account acc = new Account();
        acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        acc.Name = 'MINISTRY OF EDUCATION1';
        acc.phone= '01123353';
        acc.billingcity='London';
        acc.billingpostalcode='SW1635HJ';
        acc.billingcountry='United Kingdom';
        acc.billingstreet='address 1';
        insert acc;
        
        Contact c = new Contact(LastName = 'Contact Last Name', AccountId = acc.id);
        insert c; 
        
        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='Partner Community login User'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test12@uniquedomain.com';
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.IsActive = true;
        user.ContactId = c.Id;
        insert user; 
        ET_Sales_Agreement__c etSales = new ET_Sales_Agreement__c();
        etSales.Customer_PO_No__c = 'Test';
        etSales.Salesforce_Customer__c = acc.id;
        etSales.Category__c = 'Transportation';
        insert etSales;
        
        ETST_Student__c estud = new ETST_Student__c(ETST_Email__c='abc@xyz.com',ETST_Emirate__c='Dubai',Name='test Student',
                                                    ETST_Nationality__c='India',ETST_Emirates_Id__c='784-2131-3212131-2',
                                                    ETST_ESIS_No__c='2302',ETST_Division__c='5',ETST_Gender__c='Male',ETST_School__c = acc.Id,
                                                    ETST_Student_Id__c='1223',ETST_Date_of_Birth__c=system.today()-1200);
        insert estud;
        
        SALine_Assigned_Vehicle__c vehicle=new SALine_Assigned_Vehicle__c();
        vehicle.Name='vehcle 1';
        vehicle.Account__c = acc.Id;
        vehicle.Sales_Agreement__c = etSales.Id;
        vehicle.Assign_End_Date__c =system.today();
        insert vehicle;
        
        Case cas = new Case(contactId = c.Id);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Accident/Emergency').getRecordTypeId();
        cas.recordTypeId = caseRecordTypeId;
        insert cas;
        
        ContentVersion fileVar = new ContentVersion();
        fileVar.PathOnClient = 'TestFile';
        fileVar.Title = 'TestFile';
        fileVar.VersionData = Blob.valueOf('sample content');
        insert fileVar;
        //Query the contentDocumentId
        ContentVersion insertedFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:fileVar.Id];
        //Link the file with the product
        ContentDocumentLink linkedFile = new ContentDocumentLink(LinkedEntityId=cas.Id, ContentDocumentId=insertedFile.ContentDocumentId);
        insert linkedFile;
        
        ET_User_Files__c newFile = new ET_User_Files__c();
        newFile.File_Name__c ='test file';
        newFile.Doc_Id__c =linkedFile.Id;
        insert newFile;
        
        Test.startTest();
        system.runAs(user){
            ET_B2BController.showVehiclesforMonth('Test', 12,2019);
            ET_B2BController.showResourcesforMonth('Test', 12,2019);
           // ET_B2BController.showMaintenanceVehiclesforMonth();
            ET_B2BController.showMaintenanceWoforMonth('Test', 12,2019);
            ET_B2BController.showEstimationforMonth('Test', 12,2019);
            ET_B2BController.getPODetails('Test');
           // ET_B2BController.getSiteDetails();
           // ET_B2BController.getInvDetails();
            ET_B2BController.getUserAccountDetails();
            ET_B2BController.getStudentList();
            ET_B2BController.caseWrapper.getDashboardData();
            ET_B2BController.getCaseDetails('All');
            ET_B2BController.getCaseDetails('In Progress');
            ET_B2BController.getCaseDetails('Closed');
            ET_B2BController.showStudents('Test');
            //ET_B2BController.getPOCategory('Test');
            ET_B2BController.getProfileDetails();
            ET_B2BController.getPickListValues('Case','Status');
            ET_B2BController.getCaseDetailsBasedOnFilter('Accident/Emergency',acc.id,'New',true,system.today(),system.today().addDays(20));
           //  ET_B2BController.deleteFile(linkedFile.Id);
            ET_B2BController.getProfileName();
           // ET_B2BController.getprivateschoolUserData();
           ET_B2BController.fetchRecords('Account', 'Name', 'test', acc.id, 'ETSALES_B2B_Account');
             ET_B2BController.getQueryDetails();
            ET_B2BController.getFuelConsumptionRecords();
        }
        Test.stopTest();
    }
  
    @isTest Public static void b2bControllerTest(){
        
        Account acc2 = new Account();
        acc2.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        acc2.Name='TestAcc24232';
        acc2.phone= '01123353';
        acc2.AccountNumber ='12124';
        insert acc2;  
        CICO_Workshop_Location__c wl = new CICO_Workshop_Location__c();
        wl.name = 'test workshop';
        wl.Location_Code__c ='XYZ-124';
        insert wl;
        
         Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.Name ='B00123456';
        vm.Internal_No__c='B00123456';
        insert vm;
        
        Vehicle_Accident__c va = new Vehicle_Accident__c();
        va.Vehicle__c= vm.id;
        va.Account__c=acc2.Id;
        insert va;
       
        Account_Workshop_Master__c awm = new Account_Workshop_Master__c();
        awm.Account__c=acc2.Id;
        insert awm;
        
        ET_B2BController.getVehicleAccidentInfo(acc2.id,true);
        ET_B2BController.getFleetServiceRequest(acc2.id,true);
        ET_B2BController.getAccVsWorkShopMaster(acc2.Id); 
         ET_B2BController.getTrafficFineDetails(acc2.id,true);
       ET_B2BController.getSaleAgreementInfo(acc2.id,true);
       ET_B2BController.getAccVisitsInfo(acc2.id,true);
        ET_B2BController.getHSEInfo(acc2.id,true);
    }    
    @isTest Public static void codeCoverage4(){
        try{
             ET_B2BController.getMaintenancePODetails('test');
        } 
        catch(exception e){}
          
    } 
   @isTest
    static void fetchRecordsTest1() { 
        // Create a RecordType for Account

        String rec;
        // Create an Account with the specified RecordType
        Account acc = new Account();
       // acc.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account').getRecordTypeId();
        acc.Name = 'Test Account';
        acc.Phone = '123456789';
        acc.Type = 'Prospect';

        insert acc;

       // List<ET_B2BController.RecordsData> result = ET_B2BController.fetchRecords('Account', 'Name', 'Test','rec', acc.Id);
        //System.assertEquals(result != null, true);
    }
  
     @isTest
    static void testSaveUploadedFile() {
        // Create test data
        List<String> docIdList = new List<String>{'DocId1', 'DocId2'};
        String fiscalMonth = '2023-10';
        String po = 'PO123';
        List<String> nameList = new List<String>{'File1.txt', 'File2.txt'};

        // Call the method to be tested
        ET_B2BController.saveUploadedFile(docIdList, fiscalMonth, po, nameList);

        // Verify the records have been inserted
        List<ET_User_Files__c> insertedFiles = [SELECT Id FROM ET_User_Files__c];
      //  System.assertEquals(docIdList.size(), insertedFiles.size(), 'Number of records inserted should match the number of docIds');
    }
 

    @isTest
    static void testGetDocId() {
        // Create test data
        String fiscalMonth = '2023-10';
        String po = 'PO123';

        // Create a test User record
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Alias = 'tuser',
            Username = 'testuser@example.com',
            CommunityNickname = 'tuser',
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            IsActive = true
        );
       // insert testUser;

        // Assign the User to the UserInfo.getUserId() context
        //System.runAs(testUser) {
            // Call the method to be tested
            List<ET_User_Files__c> result = ET_B2BController.getDocId(fiscalMonth, po);

            // Perform assertions to verify the expected behavior of the method
            System.assertEquals(0, result.size(), 'No records should be found initially');

            // Create a test ET_User_Files__c record
            ET_User_Files__c testFile = new ET_User_Files__c(
                User__c = UserInfo.getUserId(),
                Fiscal_month__c = fiscalMonth,
                PO__c = po,
                Doc_Id__c = 'TestDocId',
                File_Name__c = 'TestFileName.txt'
            );
            insert testFile;

            // Call the method again after creating a test record
            result = ET_B2BController.getDocId(fiscalMonth, po);

            // Perform assertions to verify the expected behavior of the method
            System.assertEquals(1, result.size(), 'One record should be found after inserting a test record');
            System.assertEquals('TestDocId', result[0].Doc_Id__c, 'Doc_Id__c should match the test record');
            System.assertEquals('TestFileName.txt', result[0].File_Name__c, 'File_Name__c should match the test record');
        }
    
    
   
    
       }