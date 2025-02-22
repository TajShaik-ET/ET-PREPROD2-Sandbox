@isTest
public class ETIN_ZoneRenewalReqCtrlTest {
 
    
    private static testmethod void RenewlMethod(){
        Test.startTest(); 
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User u = new User(
            
            ProfileId = profile1.Id,
            Username = 'testtermsc@kaplan.com',
            Alias = 'batman',
            Email='testterms@kaplan.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago');
        insert u;
        user u2 = [select id from user where Username = 'testtermsc@kaplan.com' ];
        System.runas(u) {
            
            ETIN_ZoneRenewalReqCtrl.getInsuranceDetails();
            ETIN_ZoneRenewalReqCtrl.getInsuranceAdminDetails();
            ETIN_ZoneRenewalReqCtrl.getInsuranceAdminDetails();
            ETIN_ZoneRenewalReqCtrl.fetchUser();
            
            Account acc = new account();
            acc.Name = 'test343';
            
            insert acc;
            
           Account acc1 = new account();
            acc1.Name = 'test5453';
            
            insert acc1;
        
            
            List<ETIN_Insurance__c> InsList = new List<ETIN_Insurance__c>();
            List<id> idList = new List<id>();
            
            Id insHealthRecID  = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
            ETIN_Insurance__c et = new ETIN_Insurance__c();
            et.Insurance_Policy_Number__c = '133323';
            et.Insurance_Current_Status__c = 'Active';
            et.Insurance_Company_Email__c='test@gmail.com';
            et.Card_Number__c = '112121212';
            et.EmployeeAcc__c = acc.Id;
            et.Renew_Request__c = false;
            et.Insurance_Current_Status__c ='Active';
            et.RecordTypeId =insHealthRecID;
            et.OwnerId = u2.Id;
            
            insert et;
            
            idList.add(et.id);
            
            ETIN_Insurance__c et1 = new ETIN_Insurance__c();
            et1.Insurance_Policy_Number__c = '133323';
            et1.Insurance_Current_Status__c = 'Active';
            et1.Insurance_Company_Email__c='test@gmail.com';
            et1.Card_Number__c = '112121212';
            et1.EmployeeAcc__c = acc1.Id;
            et1.Renew_Request__c = false;
            et1.Insurance_Current_Status__c ='Active';
            et1.RecordTypeId =insHealthRecID;
            et1.Status__c = 'Pending with Zone Coordinator';
            et1.OwnerId = u2.Id; 
            insert et1; 
            idList.add(et1.id);
            list<ETIN_Insurance__c> listofIns = [select id,OwnerId,CreatedById from ETIN_Insurance__c where id=:idList ]; 
            // InsList.add(et);
            // InsList.add(et1);
            
            ETIN_ZoneRenewalReqCtrl.submitToZoneHRManager(idList);
            ETIN_ZoneRenewalReqCtrl.submitToInsuranceAdmin(listofIns);
            ETIN_ZoneRenewalReqCtrl.submitToZoneCoord(listofIns);
            ETIN_ZoneRenewalReqCtrl.ApprovedByAdminMethod(listofIns);
            ETIN_ZoneRenewalReqCtrl.RejectedByAdminMethod(listofIns);
        }
        
        Test.stopTest();
    }
    
    
}