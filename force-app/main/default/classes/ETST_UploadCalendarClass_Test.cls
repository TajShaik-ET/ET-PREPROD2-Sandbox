@isTest
public class ETST_UploadCalendarClass_Test{
    
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
    
    public static  testMethod void uploadCalendarTest(){ 
        
        System.Test.startTest();
        
        ETST_UploadCalendarClass calInstance = new ETST_UploadCalendarClass();          
        String s1e = 'School Id,School Name,Academic Start Date,Academic End Date';
        String s2e = '2844,GREENWOOD INTERNATIONAL SCHOOL,01/09/20,05/06/24';
        s1e=s1e+'\r\n'+s2e;
        calInstance.contentFile = Blob.valueOf(s1e);
        calInstance.ReadFile();        
        
        ETST_UploadCalendarClass calInstance1 = new ETST_UploadCalendarClass();          
        String s1 = 'School Id,School Name,Academic Start Date,Academic End Date';
        String s2 = ',GREENWOOD INTERNATIONAL SCHOOL,01/09/20,05/06/24';
        s1=s1+'\r\n'+s2;
        calInstance1.contentFile = Blob.valueOf(s1);
        calInstance1.ReadFile();
        
        ETST_UploadCalendarClass calInstance2 = new ETST_UploadCalendarClass();          
        String s1a = 'School Id,School Name,Academic Start Date,Academic End Date';
        String s2a = '2844,GREENWOOD INTERNATIONAL SCHOOL,01-09-20,05-06-24';
        s1a=s1a+'\r\n'+s2a;
        calInstance2.contentFile = Blob.valueOf(s1a);
        calInstance2.ReadFile();
        
        calInstance.getuploadedCalendars();
        calInstance.insertCalendar();
        
        System.Test.stopTest();
    }
    
}