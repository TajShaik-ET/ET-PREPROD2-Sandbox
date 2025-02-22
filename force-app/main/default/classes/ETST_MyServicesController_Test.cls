@isTest
public class ETST_MyServicesController_Test {
    
    @isTest static void testMyServices(){
        
        System.Test.startTest();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com');
        insert acc;
       /* Contact con = new Contact(lastname = 'Test1', accountid = acc.Id);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardusersree@testorg.com',contactid=con.Id);*/
        ETST_Student__c stdnt = new ETST_Student__c(Name='Student',ETST_Emirates_Id__c='784-1347-1234567-1',ETST_Account_Name__c=acc.Id);
        insert stdnt;
        
        List<ET_Service_Request__c> srList = new List<ET_Service_Request__c>();
        Id srRecordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByName().get('School Service Request').getRecordTypeId();
        For(Integer i=0;i<10;i++){
            ET_Service_Request__c  etreq = new ET_Service_Request__c(recordtypeId= srRecordTypeId,Payment_Status__c='Not Initiated',ETST_Student__c=stdnt.Id,ETST_Pick_Up_End_Date__c=System.today()+3,
                                                                     ETST_Paid_By__c = 'Self',ETST_Is_Renewed__c=false,ETST_Is_Active__c=true,ETST_User__c=userinfo.getUserId());
            srList.add(etreq);
        }
        insert srList;
        User u1=[select id from user where contactId=:acc.PersonContactId and isActive=true LIMIT 1];
        system.runAs(u1){
            ETST_MyServicesController.getServiceRequests();
        }
    }
}