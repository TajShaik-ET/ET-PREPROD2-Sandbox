@isTest
public class CaseTrigger_SMS_HandlerTest {
     @isTest public static void DataSetUp(){
        Account accoun = new Account();
        accoun.Name = 'test corp';
        accoun.phone= '01123123';
        accoun.billingcity='London';
        accoun.billingpostalcode='SW1635HJ';
        accoun.billingcountry='United Kingdom';
        accoun.billingstreet='address 1';
        insert accoun;
    
    
        Contact c = new Contact();
        c.AccountId = accoun.ID;
        c.ETSALES_Mob_Country_Code__c = 'UAE(+971)';
        c.MobilePhone = '88887778'; 
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
        for(Integer i=0;i<5;i++){
        Case cs= new Case();
        cs.Accountid=accoun.id;
        cs.ContactId = c.Id;
        cs.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('School_Transport').getRecordTypeId();
        
        if(i<3){
        cs.status='New';
        cs.Case_Types__c='Request for Awareness Session';
        cs.Requestor__c='Parent/Guardian';
         cs.Assigned_To__c=user2.id;
        }
        else if(i>3 && i<5){
        cs.status='Submitted for ADEC';
        cs.Case_Types__c='Evaluation of Schools/Services';
        cs.Requestor__c='Parent/Guardian';
        
        }
        else{
        
        cs.status='On Hold';
        cs.Case_Types__c='Request for New Bus/Supervisors/Teachers Transfer';
        cs.Requestor__c='Parent/Guardian';
        
        }
        cs.Origin = 'Phone Call';
        cslist.add(cs);
        }
         Test.startTest();
        Test.setMock(WebServiceMock.class, new SendSMSCalloutMock());
        insert cslist;
        cslist[1].Priority = 'Normal - close withen 2 working days';
        update cslist[1];
        cslist[2].status = 'Solution Completed';
        cslist[2].Solution__c = 'Closed';
        cslist[2].CCM_Remarks__c = 'Closed';
        update cslist[2];
        ET_SendSMS_API_Paramter.Control obj = new  ET_SendSMS_API_Paramter.Control();
        CaseTrigger_SMS_Handler.testCoverage();
        Test.stopTest();
        
    }
    
     
}