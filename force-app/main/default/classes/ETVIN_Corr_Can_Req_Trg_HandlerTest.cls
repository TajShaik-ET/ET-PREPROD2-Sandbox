@isTest
public class ETVIN_Corr_Can_Req_Trg_HandlerTest {
    
    private static testmethod void corrCancelReq(){
         
        VehicleInsEmailNotification__c vr = new VehicleInsEmailNotification__c();
        vr.Email__c = 'test@gmail.com';
        vr.Label__c ='PRO';
        vr.Name = 'PRO';
        insert vr;
        
         Vehicle_Master__c vm = new Vehicle_Master__c();
        vm.Name = 'test';
        vm.Internal_No__c ='123';
        insert vm;
        Account acc = new Account();
        //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Partner').getRecordTypeId();
        acc.Name = 'HDGD32342';

        insert acc;
        
        ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
        etv.Vehicle__c = vm.Id;
        etv.ETVIN_Insurance_Status__c = 'Active';
        etv.ETVIN_Request_Status__c  = 'Insurance Approved';
        etv.ETVIN_Insurance_Company__c = acc.id;
        etv.ETVIN_Effective_Date__c = system.today();
        etv.ETVIN_Expiry_Date__c =system.today()+365;
        
        insert etv;
        
        Correction_Cancel_Request__c cr = new Correction_Cancel_Request__c();
        cr.Prove_Theft_certificate__c = false;
        cr.Cancel_Theft_Report__c = false;
        cr.Transfer_Profession_Certificate__c = false;
        cr.Police_Report__c = false;
        cr.NOC_Receive_Vehicle__c = true;
        cr.Insurance_Cancellation_Letter__c = false;
        cr.Vehicle_Master__c = vm.Id;
        cr.Correction_for__c ='Chassis Number';
        cr.Insurance_Company__c = acc.id;
        cr.Vehicle_Insurance_Policy__c = etv.Id;
        insert cr;
        
        cr.Insurance_Cancellation_Letter__c = true;
       cr.NOC_Receive_Vehicle__c = false;
        cr.Prove_Theft_certificate__c = true;
        cr.Cancel_Theft_Report__c = true;
        cr.Transfer_Profession_Certificate__c = true;
        cr.Police_Report__c = true;
       update cr;
        
    }

}