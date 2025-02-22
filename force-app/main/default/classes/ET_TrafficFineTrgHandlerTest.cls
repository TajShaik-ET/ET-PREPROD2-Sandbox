@isTest
public class ET_TrafficFineTrgHandlerTest {
    
    private static testmethod void createTrafficFine(){
        Account acc = new Account();
        acc.Name ='test';
        insert acc;
        
        Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.Name ='B001234';
        vm.Internal_No__c ='B001234';
        insert vm;
        
        SALine_Assigned_Vehicle__c sla = new SALine_Assigned_Vehicle__c();
        sla.Name='B001234';
        sla.Account__c=acc.Id;
        sla.ET_Vehicle__c=vm.Id;
        sla.Assign_Start_Date__c=system.now();
        sla.Assign_End_Date__c=system.now()+10;
        insert sla;
        
        Traffic_Fine__c tf  = new Traffic_Fine__c();
        tf.Account__c = acc.Id;
        tf.Vehicle_Master__c = vm.Id;
        tf.Ticket_Date__c = system.today();
        tf.Fine_Amount__c =200;
        insert tf;        
        
    }

}