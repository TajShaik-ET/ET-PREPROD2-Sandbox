@isTest
public class SS_TicketingSystem_Controller_Test{
    
    @isTest public static void  insertnewdata(){
        
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'ET_HQ_Head_of_Service' Limit 1];
         UserRole userrole2 = [Select Id, DeveloperName From UserRole Where DeveloperName = 'ADECPartnerUser' Limit 1];
       
        Id partnerprof = [select id from profile where name='Partner Community Login User'].id;
        Id adminprof = [select id from profile where name='System Administrator'].id;
        
      
            User useradmin = new User();
            useradmin.firstName = 'test02';
            useradmin.lastName = 'test03';
            useradmin.UserRoleId =userrole.Id;
            useradmin.profileId = adminprof;
            useradmin.username = 'test02@uichangeset.com';
            useradmin.email = 'test@test.com';
            useradmin.Alias='test';
            useradmin.TimeZoneSidKey='Asia/Dubai';
            useradmin.LocaleSidKey='en_IE_EURO';
            useradmin.EmailEncodingKey='ISO-8859-1';
            useradmin.LanguageLocaleKey='en_US';
            insert useradmin;
        system.debug('############'+useradmin);
        System.runAs(useradmin){
             system.debug('######'+userInfo.getuserId());
           
            Account accoun = new Account();
            accoun.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account').getRecordTypeId();
            accoun.Name = 'test corp';
            accoun.phone= '01123123';
            accoun.billingcity='London';
            accoun.billingpostalcode='SW1635HJ';
            accoun.billingcountry='United Kingdom';
            accoun.billingstreet='address 1';
            accoun.OwnerId=useradmin.id;
            insert accoun;
            system.debug('######'+accoun.ownerID);
            
            Contact c = new Contact();
            c.AccountId = accoun.Id;
            c.FirstName = 'test';
            c.LastName = 'test';
            c.email = 'test@test.com';
            c.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Contact').getRecordTypeId(); 
            c.birthdate = Date.newInstance(1992, 04, 12);
            insert c;
            system.debug('######'+c);
            
            /* User user2 = new User();
            user2.firstName = 'test1';
            user2.lastName = 'test2';
            user2.contactId=contactId;
            user2.PortalRole ='Manager';
            user2.profileId = partnerprof;
            user2.username = 'test1@uichangeset.com';
            user2.email = 'test@test.com';
            user2.Alias='test';
            user2.TimeZoneSidKey='Asia/Dubai';
            user2.LocaleSidKey='en_IE_EURO';
            user2.EmailEncodingKey='ISO-8859-1';
            user2.LanguageLocaleKey='en_US';
            insert user2;
            */
            
            List<case> cslist= new List<Case>();
            for(Integer i=0;i<10;i++){
                Case cs= new Case();
                cs.Accountid=accoun.id;
                cs.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ETST_Ministry_of_Education').getRecordTypeId();
                cs.contactid=c.id;
                if(i<5){
                    cs.status='New';
                    cs.Case_Types__c='Request for Awareness Session';
                    cs.Requestor__c='Parent/Guardian';
                    cs.CCM_Remarks__c='Test';
                    cs.Solution__c='Test';
                }
                else if(i>4 && i<8){
                    cs.status='Submitted for ADEC';
                    cs.Case_Types__c='Evaluation of Schools/Services';
                    cs.Requestor__c='Parent/Guardian';
                    
                }
                else{
                    
                    cs.status='On Hold';
                    cs.Case_Types__c='Request for New Bus/Supervisors/Teachers Transfer';
                    cs.Requestor__c='Parent/Guardian';
                    
                }
                cslist.add(cs);
            }
            insert cslist;
            
            CaseComment cment= new CaseComment();
            cment.CommentBody='Test class case created';
            cment.parentId=cslist[0].id;
            insert cment;
            
          
            String response ;
            String responseticket ;
            String responsecommenthistory;
            String responseComment;
           
            response=SS_TicketingSystem_Controller.getDashboardData();
            responseticket=SS_TicketingSystem_Controller.getTicketDetails('New');
            responseticket=SS_TicketingSystem_Controller.getTicketDetails('On Hold');
            responseticket=SS_TicketingSystem_Controller.getTicketDetails('Submitted for ADEC');
            //    responseComment=SS_TicketingSystem_Controller.manageTicket(cslist[0].id,'Test case','Closed');
            responseComment=SS_TicketingSystem_Controller.manageTicket(cslist[0].id,'Test case','Reopen');
            responsecommenthistory=SS_TicketingSystem_Controller.getCommentsHistory(cslist[0].id);
            system.assertequals(responseComment,'Success');
            }
          
        }
    
    
}