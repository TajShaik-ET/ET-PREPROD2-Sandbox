@isTest
public class ET_CaseManagement_Test{
    
    @isTest public static void  insertnewdata(){
        
          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User u=[select id from user where profileId=:profile1.Id and isactive=true LIMIT 1];
             
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Id schoolRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business (B2B) - School').getRecordTypeId(); 
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com',etst_coordinator__c=userinfo.getUserId());
        System.runAs(u){
           insert acc; 
        }
            List<case> cslist= new List<Case>();
            for(Integer i=0;i<10;i++){
                Case cs= new Case();
                cs.Accountid=acc.id;
                cs.Record_Types__c='School Transport';
                //cs.Recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('School Tranport').getRecordTypeId();
                //cs.contactid=c.id;
                //cs.Requestor__c='Parent/Guardian';
                if(i<5){
                    cs.status='New';
                    cs.Case_Types__c='Request for Awareness Session';
                    cs.CCM_Remarks__c='Test';
                    cs.Solution__c='Test';
                }
                else{
                    
                    cs.status='On Hold';
                    cs.Case_Types__c='Request for New Bus/Supervisors/Teachers Transfer';
                    
                }
                cslist.add(cs);
            }
            insert cslist;
            
          
            
            ET_CaseManagement.getDashboardData('School Transport');
            ET_CaseManagement.getDashboardData('All');
            ET_CaseManagement.getCaseDetails('New','School Transport');
           
            }
          
        
    
    
}