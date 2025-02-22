@isTest
public class ETST_UploadParentsandStudentsClass_Test {
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
        
    }
    @isTest
    public static void uploadParentTestMethod(){       
        system.Test.startTest();
        string str = 'Test,ABC,,,,Male,,India,02/02/1990,9715123423451,test.abc@test.com,123,13 b,Al Mankhool,Dubai,UAE,784-1990-1231234-8';
        string str1 = 'Test,XYZ,,,,Male,,India,02/02/1990,971512312321,test.xyz@test.com,124,14 b,Al Mankhool,Dubai,UAE,784-1990-1234123-9';
        str = str+'\r\n'+str1;
        
        ETST_UploadParentsandStudentsClass  objCls = new ETST_UploadParentsandStudentsClass();
        objCls.csvFileBody = Blob.valueOf(str);        
        objCls.getparentTemplateUrl();
        objCls.ReadFile();
        objCls.getuploadedAccounts();
        
        string str2 = 'Test,ABC,,,,Male,,India,02/02/1990,9715123423451,test.abc@test.com,123,13 b,Al Mankhool,Dubai,UAE,784-1990-1231234-8';
        string str3 = ',XYZ,,,,Male,,India,02/02/1990,971512312321,test.xyz@test.com,124,14 b,Al Mankhool,Dubai,UAE,784-1990-1234123-9';
        str2 = str2+'\r\n'+str3;
        
        ETST_UploadParentsandStudentsClass  objCls1 = new ETST_UploadParentsandStudentsClass();
        objCls1.csvFileBody = Blob.valueOf(str2);        
        objCls1.ReadFile();
        
        string str4 = 'Test,ABC,,,,Male,,India,02/02/1990,9715123423451,test.abc@test.com,123,13 b,Al Mankhool,Dubai,UAE,784-1990-1231234-8';
        string str5 = 'Test,,,,,Male,,India,02/02/1990,971512312321,test.xyz@test.com,124,14 b,Al Mankhool,Dubai,UAE,784-1990-1234123-9';
        str4 = str4+'\r\n'+str5;
        
        ETST_UploadParentsandStudentsClass  objCls2 = new ETST_UploadParentsandStudentsClass();
        objCls2.csvFileBody = Blob.valueOf(str4);        
        objCls2.ReadFile();
        
        string str6 = 'Test,ABC,,,,Male,,India,02/02/1990,9715123423451,test.abc@test.com,123,13 b,Al Mankhool,Dubai,UAE,784-1990-1231234-8';
        string str7 = 'Test,XYZ,,,,Male,,India,02/02/1990,,test.xyz@test.com,124,14 b,Al Mankhool,Dubai,UAE,784-1990-1234123-9';
        str6 = str6+'\r\n'+str7;
        
        ETST_UploadParentsandStudentsClass  objCls3 = new ETST_UploadParentsandStudentsClass();
        objCls3.csvFileBody = Blob.valueOf(str6);        
        objCls3.ReadFile();       
        system.Test.stopTest();
    } 
    
    @isTest
    public static void uploadStudentTestMethod(){       
        system.Test.startTest();
        string str = '10101,,Test,971512234567,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        string str1 = '11101,,Test1,971512234588,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        str = str+'\r\n'+str1;
        
        ETST_UploadParentsandStudentsClass  objCls = new ETST_UploadParentsandStudentsClass();
        objCls.studentCSVFileBody = Blob.valueOf(str);        
        objCls.getstudentTemplateUrl();
        objCls.readStudentFile();
        objCls.getuploadedStudents();
        
        string str2 = '10101,,Test,971512234567,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        string str3 = ',,Test1,971512234588,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        str2 = str2+'\r\n'+str3;
        ETST_UploadParentsandStudentsClass  objCls1 = new ETST_UploadParentsandStudentsClass();
        objCls1.studentCSVFileBody = Blob.valueOf(str2);        
        objCls1.readStudentFile();
        
        string str4 = '10101,,Test,971512234567,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        string str5 = '11101,,,971512234588,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        str4 = str4+'\r\n'+str5;
        ETST_UploadParentsandStudentsClass  objCls2 = new ETST_UploadParentsandStudentsClass();
        objCls2.studentCSVFileBody = Blob.valueOf(str4);        
        objCls2.readStudentFile();
        
        string str6 = '10101,,Test,971512234567,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        string str7 = '11101,,Test1,971512234588,,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        str6 = str6+'\r\n'+str7;
        ETST_UploadParentsandStudentsClass  objCls3 = new ETST_UploadParentsandStudentsClass();
        objCls3.studentCSVFileBody = Blob.valueOf(str6);        
        objCls3.readStudentFile();
        
        string str8 = '10101,,Test,971512234567,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        string str9 = '11101,,Test1,971512234588,784-2016-1456234-7,test@test.com,,,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        str8 = str8+'\r\n'+str9;
        ETST_UploadParentsandStudentsClass  objCls4 = new ETST_UploadParentsandStudentsClass();
        objCls4.studentCSVFileBody = Blob.valueOf(str8);        
        objCls4.readStudentFile();
        
        string str10 = '10101,,Test,971512234567,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        string str11 = '11101,,Test1,971512234588,784-2016-1456234-7,test@test.com,,Male,,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        str10 = str10+'\r\n'+str11;
        ETST_UploadParentsandStudentsClass  objCls5 = new ETST_UploadParentsandStudentsClass();
        objCls5.studentCSVFileBody = Blob.valueOf(str10);        
        objCls5.readStudentFile();
        
        string str12 = '10101,,Test,971512234567,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,110011, Aldar Acadamics,India,A+,Good';
        string str13 = '11101,,Test1,971512234588,784-2016-1456234-7,test@test.com,,Male,784-1272-8373838-3,A,A,01/01/2016,, Aldar Acadamics,India,A+,Good';
        str12 = str12+'\r\n'+str13;
        ETST_UploadParentsandStudentsClass  objCls6 = new ETST_UploadParentsandStudentsClass();
        objCls6.studentCSVFileBody = Blob.valueOf(str12);        
        objCls6.readStudentFile();
        system.Test.stopTest();
    }
    
}