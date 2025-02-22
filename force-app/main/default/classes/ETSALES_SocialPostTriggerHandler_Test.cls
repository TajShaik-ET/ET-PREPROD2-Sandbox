@isTest
public class ETSALES_SocialPostTriggerHandler_Test {
    
    private static testmethod void testUpdateLeadRecordType(){
        
        Lead ld = new Lead();
        ld.LastName = 'TestLname';
        ld.FirstName='TestFname';
        ld.Email = 'Testmail@gmail.com';
        ld.MobilePhone = '123456789';
        ld.ETSALES_Lead_Type__c='Enquiry';
        ld.ETSALES_Lead_Rating__c='Hot';
        insert ld;
        
        SocialPost sp = new SocialPost();
        sp.Name = 'Test Post';
        sp.TopicProfileName = 'emiratesmoto';
        sp.WhoId = ld.Id;
        insert sp;
        
    }
}