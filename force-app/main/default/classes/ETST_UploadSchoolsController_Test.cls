@isTest
public class ETST_UploadSchoolsController_Test{
    
    @testSetup
    public static void testSetup(){
        
        Id accParentRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        Id accSchoolRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name='School Coordinator']; 
        User coordinator = new User(Alias = 'cordu', Email='coordinatoruser@testorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = p.Id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='coordinatoruser@testorg.com');
        insert coordinator;
        
        Account parentAccount = new Account(FirstName='Test',LastName='Parent',RecordTypeId=accParentRecordType,
                                            ETSALES_Emirates_Passport__c='784-1272-8373838-3',Phone='971581484471',PersonEmail='vinod.test@test.com',
                                            ETSALES_Customer_Type__c='Person');
        insert parentAccount;
        
        Account schoolAccount = new Account(Name='Test School',RecordTypeId=accSchoolRecordType,
                                            ETST_Account_Type__c='Private School',ETSALES_Trade_License_Number__c='11211',ETST_SchoolRefID__c='110011',
                                            ETSALES_Trade_License_Expiry_Date__c=system.today().addDays(365),ETST_Coordinator__c=coordinator.Id);
        insert schoolAccount;
        
        ET_Sales_Agreement__c agr = new ET_Sales_Agreement__c(Salesforce_Customer__c=schoolAccount.Id);
        insert agr;
        
    } 
    
    public static  testMethod void uploadSchoolsTest(){ 
        
        System.Test.startTest();
        
        ContentVersion cv=new Contentversion();
        cv.title='school Data Template';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        insert cv;   
        
        ETST_UploadSchoolsController objSchool = new ETST_UploadSchoolsController();
        objSchool.getbaseUrl();
        
        System.Test.stopTest();
    }
    
    public static  testMethod void uploadSchoolsTest1(){ 
        
        System.Test.startTest();
        
        ETST_UploadSchoolsController objSchool = new ETST_UploadSchoolsController();
        objSchool.getbaseUrl();
        
        
        String s1 = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s2 = '110011,WEST YAS Academy,123,Dubai,Dubai,UAE,Test,Testmail@smaartt.com,5512345678,www.munaacademy.com,University,'; 
        s1=s1+'\r\n'+s2;        
        objSchool.contentFile = Blob.valueOf(s1);        
        objSchool.ReadFile(); 
        
        
        ETST_UploadSchoolsController objSchool1 = new ETST_UploadSchoolsController();
        String s3 = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s4 = ',WEST YAS Academy,123,Dubai,Dubai,UAE,Test,Testmail@smaartt.com,5512345678,www.munaacademy.com,University,';   
        s3=s3+'\r\n'+s4;        
        objSchool1.contentFile = Blob.valueOf(s3);        
        objSchool1.ReadFile(); 
        
            ETST_UploadSchoolsController objSchool2 = new ETST_UploadSchoolsController();
        String s5 = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s6 = '110011,,123,Dubai,Dubai,UAE,Test,Testmail@smaartt.com,5512345678,www.munaacademy.com,University,'; 
        s5=s5+'\r\n'+s6;        
        objSchool2.contentFile = Blob.valueOf(s5);        
        objSchool2.ReadFile();
        
        ETST_UploadSchoolsController objSchool3 = new ETST_UploadSchoolsController();
        String s7 = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s8 = '110011,WEST YAS Academy,,Dubai,Dubai,UAE,Test,Testmail@smaartt.com,5512345678,www.munaacademy.com,University,';    
        s7=s7+'\r\n'+s8;        
        objSchool3.contentFile = Blob.valueOf(s7);        
        objSchool3.ReadFile();
        
        ETST_UploadSchoolsController objSchool4 = new ETST_UploadSchoolsController();
        String s1a = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s2a = '110011,WEST YAS Academy,123,,Dubai,UAE,Test,Testmail@smaartt.com,5512345678,www.munaacademy.com,University,'; 
        s1a=s1a+'\r\n'+s2a;        
        objSchool4.contentFile = Blob.valueOf(s1a);        
        objSchool4.ReadFile(); 
        
        ETST_UploadSchoolsController objSchool5 = new ETST_UploadSchoolsController();
        String s1b = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s2b = '110011,WEST YAS Academy,123,Dubai,,UAE,Test,Testmail@smaartt.com,5512345678,www.munaacademy.com,University,'; 
        s1b=s1b+'\r\n'+s2b;        
        objSchool5.contentFile = Blob.valueOf(s1b);        
        objSchool5.ReadFile(); 
        
        ETST_UploadSchoolsController objSchool6 = new ETST_UploadSchoolsController();
        String s1c = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s2c = '110011,WEST YAS Academy,123,Dubai,Dubai,UAE,Test,,5512345678,www.munaacademy.com,University,';    
        s1c=s1c+'\r\n'+s2c;        
        objSchool6.contentFile = Blob.valueOf(s1c);        
        objSchool6.ReadFile(); 
        
        ETST_UploadSchoolsController objSchool7 = new ETST_UploadSchoolsController();
        String s1d = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s2d = '110011,WEST YAS Academy,123,Dubai,Dubai,,Test,Testmail@smaartt.com,,5512345678,www.munaacademy.com,,University,';     
        s1d=s1d+'\r\n'+s2d;
        objSchool7.contentFile = Blob.valueOf(s1d);
        objSchool7.ReadFile(); 
        
        ETST_UploadSchoolsController objSchool8 = new ETST_UploadSchoolsController();
        String s1e = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s2e = '1001,WEST YAS Academy,123,Dubai,Dubai,UAE,Sree,testmail@smaartt.com,,5512345678,www.munaacademy.com,,University,';    
        s1e=s1e+'\r\n'+s2e;
        objSchool8.contentFile = Blob.valueOf(s1e);
        objSchool8.ReadFile();
        
        ETST_UploadSchoolsController objSchool9 = new ETST_UploadSchoolsController();
        String s1f = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s2f = '1001,WEST YAS Academy,123,Dubai,Dubai,UAE,Swathi,swati.pawar@smaartt.com,1234,5512345678,www.munaacademy.com,1234,University,30/07/2020'; 
        s1f=s1f+'\r\n'+s2f;
        objSchool9.contentFile = Blob.valueOf(s1f);
        objSchool9.ReadFile();
        
        ETST_UploadSchoolsController objSchool10 = new ETST_UploadSchoolsController();
        String s1g = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s2g = '1001,WEST YAS Academy,123,Dubai,Dubai,UAE,Swathi,swati.pawar@smaartt.com,1234,5512345678,www.munaacademy.com,1234,,30/07/2020';   
        s1g=s1g+'\r\n'+s2g;
        objSchool10.contentFile = Blob.valueOf(s1g);
        objSchool10.ReadFile();
        
        ETST_UploadSchoolsController objSchool11 = new ETST_UploadSchoolsController();
        String s1h = 'School Id*,School Name*,Street*,City*,State*,Country*,Coordinator Name,Coordinator Email*,Contract Id*,Phone,Website,Main Branch School Id,School Type*,CreatedDate';
        String s2h = '1001,WEST YAS Academy,123,Dubai,Dubai,UAE,Swathi,swati.pawar@smaartt.com,1234,5512345678,www.munaacademy.com,1234,Main,30/07/2020';   
        s1h=s1h+'\r\n'+s2h;
        objSchool11.contentFile = Blob.valueOf(s1h);
        objSchool11.ReadFile();
        
        System.Test.stopTest();
    }
}