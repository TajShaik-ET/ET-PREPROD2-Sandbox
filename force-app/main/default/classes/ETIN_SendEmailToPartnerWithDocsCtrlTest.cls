@isTest
public class ETIN_SendEmailToPartnerWithDocsCtrlTest {
  
    private static testmethod void sendEmailFunction(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'ts3232xysew';
        acc.Type = 'Employee';
        acc.ETIN_Employee_Id__c ='232232';
        acc.ETIN_Place_of_Visa_Issuance__c = 'Abu Dhabi';
        acc.IsConvertedFromLead__c = true;
        insert acc;
        
        list<ETIN_Insurance__c> insList = new List<ETIN_Insurance__c>();
        ETIN_Insurance__c et = new ETIN_Insurance__c();
        et.EmployeeAcc__c = acc.Id;
        et.Insurance_Company__c=acc.Id;
        et.Card_Number__c = '24343';
        et.Status__c ='Under Process';
        et.RecordTypeId = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
          
        insert et;
        insList.add(et);
        
        ContentDocument testContDoc = new ContentDocument();
        ContentVersion testContVer = new ContentVersion();
        ContentDocumentLink testContDocLink = new ContentDocumentLink(); 
        
         testContVer.Title = 'Test Document 2';
        testContVer.PathOnClient = 'SF_ELO_Code.txt';
        testContVer.VersionData = Blob.valueOf('Test Content');   
        testContVer.IsMajorVersion = true;
        insert testContVer;
        ContentVersion cvL = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :testContVer.Id];

        //Populate and create ContentDocumentLink
        testContDocLink.LinkedEntityId = et.Id;
        testContDocLink.ContentDocumentId = cvL.ContentDocumentId;
        insert testContDocLink;

        
        Account acc2 = new Account();
        acc2.Name = 'ts3232xy1Kl3me3434';
        acc2.Type = 'Insurance Partner';
        acc2.ETIN_Employee_Id__c ='232231';
        acc2.ETIN_Place_of_Visa_Issuance__c = 'Abu Dhabi';
        acc2.IsConvertedFromLead__c = true;
        
        insert acc2;
      
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId =acc2.Id;
        con.Email= 'test@gmail.com';
        insert con;
        
        ETIN_DefaultInsurancePartners__c eti = new ETIN_DefaultInsurancePartners__c();
        eti.Name = 'Abu Dhabi';
        eti.Account_ID__c = acc2.Id;
        insert eti;
        
         ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        User testUser = new User(FirstName = 'John', LastName = 'Doe', 
                             Email = 'john.doe@example.com', 
                             Username = 'john.doe@example.com',
                                 Alias= 'asara', TimeZoneSidKey= '(GMT+04:00) Gulf Standard Time (Asia/Dubai)', LocaleSidKey= '(GMT+04:00) Gulf Standard Time (Asia/Dubai)',
                                 EmailEncodingKey= 'Unicode (UTF-8)', ProfileId= '%2F00e3z000001a509', LanguageLocaleKey= 'English (United Kingdom)'
                             );
        /*Alias, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey*/
   // insert testUser;

    // Set the current user to the test user
          System.assertEquals(UserInfo.getUserId(), ETIN_SendEmailToPartnerWithDocsCtrl.currentUserDetailMethod().Id, 'got the right user');
       
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('name', 'test.csv');
        gen.writeStringField('base64Data','244322');
         gen.writeStringField('contentType', 'text/csv');
        gen.writeEndObject();
        gen.writeEndArray();
        String jsonData = gen.getAsString();
        
        
        ETIN_SendEmailToPartnerWithDocsCtrl.getInsuranceDetails('Abu Dhabi');
         ETIN_SendEmailToPartnerWithDocsCtrl.getInsuranceDetails('Dubai');
        ETIN_SendEmailToPartnerWithDocsCtrl.getEmailDetails('Abu Dhabi');
        //ETIN_SendEmailToPartnerWithDocsCtrl.getInsLibraryFiles();
        //ETIN_SendEmailToPartnerWithDocsCtrl.getreportDetails('Abu Dhabi');
        ETIN_SendEmailToPartnerWithDocsCtrl.currentUserDetailMethod();
        ETIN_SendEmailToPartnerWithDocsCtrl.sendEmailWithDocs('test@gmail.com','Subject', 'Body',insList , cvList, '["name"]', '["name"]',jsonData);
        Test.stopTest();
    }
}