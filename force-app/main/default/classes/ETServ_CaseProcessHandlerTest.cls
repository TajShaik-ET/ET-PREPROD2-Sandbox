@isTest
private class ETServ_CaseProcessHandlerTest {



   private static testMethod void doTest() {
   
   ETServ_CaseProcessHandler.utilityMethod();
         /*List<Id> clist = new List<Id>();
        ET_Location__c loc = new ET_Location__c();
        loc.Name = 'Test location';
        loc.Latitude__c = '23.2';
        loc.Longitude__c = '23.2';
        loc.Operations_Queue_Id__c=System.Label.ET_Services_Omni_Channel_Queue;
        insert loc;
         ET_Location__c loc2 = new ET_Location__c();
        loc2.Name = 'Test location2';
        loc2.Latitude__c = '23.2';
        loc2.Longitude__c = '23.2';
         insert loc2;
        Account acc = new Account(name = 'test acc',Location__c=loc.id);
         Account acc2 = new Account(name = 'test acc2',Location__c=loc2.id);
       
        Id recordtypid =Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Asked_to_print_a_new_card_for_students').getRecordTypeId();
        System.Test.startTest();
        Case cs = new Case(Status= 'New',
                     Accountid=acc.id,
                     Location__c=loc.id,
                    Recordtypeid =recordtypid
                    );
        insert cs;
         Case cs2 = new Case(Status= 'New',
                     Accountid=acc2.id,
                     Location__c=loc2.id,
                    Recordtypeid =recordtypid
                    
                    );
        insert cs2;
        clist.add(cs.id);
        clist.add(cs2.id);
ETServ_CaseProcessHandler.caseProcess(clist);
        System.Test.stopTest();*/

     

    }
}