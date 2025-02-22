@isTest()
public class CICO_IntimationTrgHandlerTest {      
   
    static testMethod void processIntimation(){
        Test.startTest();       
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];        
       
        User user1 = new User();
        user1.Username = 'stand3423@jana9334.com';
        user1.Email = 'us1@test.com';
        user1.LastName = 'LastName1';
        user1.FirstName = 'FirstName1';
        user1.Alias ='u1';
        user1.Grade__c ='TECH';
        user1.CommunityNickname ='use1';
        user1.ProfileId =p.id;
        user1.ETI_Inspection_Center__c='DXB-RL-M';
        
        user1.EmailEncodingKey='UTF-8';
        user1.LanguageLocaleKey='en_US';
        user1.LocaleSidKey='en_US';
        user1.TimeZoneSidKey='America/Los_Angeles';
        user1.Country = 'US';
        user1.Title = 'Territory Manager';
        insert user1;
        
      
       
        
        system.runAs(user1){
        CICO_Intimation__c inti = new CICO_Intimation__c();
        inti.Name ='1234';
        inti.Intimation_No__c='1224';
        inti.Location_Code__c ='DXB-RL-M';
        inti.Inspected_By__c = 'TECH';
        
        insert inti;
        }
        Test.stopTest();
        
    }

}