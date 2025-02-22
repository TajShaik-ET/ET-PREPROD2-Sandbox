@IsTest (SeeAllData=true)
public class ETIN_InsuranceAdminControllerTest {
    
    private static testmethod void getInsuranceDetails(){
        ETIN_InsuranceAdminController.getInsuranceDetails('test', 'test', 'test', 'test', 'test', 'test','');
    }
    
    private static testmethod void getEmployeeDetails(){
        ETIN_InsuranceAdminController.getEmployeeDetails('test', 'test', 'test', 'test','Abu Dhabi');
        ETIN_InsuranceAdminController.getEmployeeFamilyDetails('test', 'test', 'test');
    }
    
    private static testmethod void getRecordTypeId(){
        ETIN_InsuranceAdminController.getRecordTypeId('ETIN_Insurance__c', 'Health_Insurance');
    }
    
    private static testmethod void getselectOptions(){
        
        ETIN_InsuranceAdminController.getselectOptions('Case', 'Status');     
    }
    private static testmethod void commonMethod(){
        
         Id empRecTypeId = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('ET_Employees').getRecordTypeId();
        Id empRecTypeId2 = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('ETIN_Employee_Family').getRecordTypeId();
        
        ETIN_InsuranceAdminController.getAttachments('');
        ETIN_InsuranceAdminController.getPartnerAccList();
        Account acc = new account();
        acc.Name = 'test34231';
        
        insert acc;
        
        Contact co = new contact();
        co.AccountId = acc.Id;
        co.LastName = 'lastname';
        co.RecordTypeId = empRecTypeId2;
        co.ETIN_Insurance_Card_Number__c = '213';
        insert co;
        
         Id insHealthRecID  = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
        ETIN_Insurance__c et = new ETIN_Insurance__c();
        et.Insurance_Policy_Number__c = '133323';
        et.Insurance_Current_Status__c = 'Active';
        et.Insurance_Company_Email__c='test@gmail.com';
        et.Card_Number__c = '112121212';
        et.EmployeeAcc__c = acc.Id;
        et.Renew_Request__c = false;
        et.Status__c='Completed';
        et.Insurance_Current_Status__c ='Active';
        et.RecordTypeId =insHealthRecID;
        
        insert et;
        
        ETIN_InsuranceAdminController.singleRecRenewPrcss(et.Id);
        
        //ETIN_InsuranceAdminController.getImageContent('');   
        ETIN_InsuranceAdminController.getAttachments('');
        // ETIN_InsuranceAdminController.deleteAttachment('');
       
        
        ETIN_InsuranceAdminController.singleRecRenewPrcss(et.Id);
        
        ETIN_InsuranceAdminController.getRenewalButtonSettings();
        ETIN_InsuranceAdminController.getInsMasterDetails();
        ETIN_InsuranceAdminController.getDocumentMasterDetails('Dubai');
        ETIN_InsuranceAdminController.getInsClaimDetails();
                ETIN_InsuranceAdminController.fetchUser();
        
        
        
         //
        Test.startTest();
          //  ETIN_InsuranceAdminController.callBatchClsHealthRenewPrcs(acc.id, '');
       /* ETIN_BulkHealthApprovalBatchCls etb = new ETIN_BulkHealthApprovalBatchCls(acc.Id,'');
        database.executeBatch(etb,1);*/
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        
        ETIN_InsuranceAdminController.getImageContent(cvList[0].ContentDocumentId);
        
        //ETIN_InsuranceAdminController.deleteAttachment(cdList[0].Id);
        
        ETIN_DefaultInsurancePartners__c isp = new ETIN_DefaultInsurancePartners__c();
        isp.Name = 'test';
        isp.Account_ID__c ='test';
        insert isp;
        ETIN_InsuranceAdminController.getDefaultInsPartners();
        Test.stopTest();

    }
    
}