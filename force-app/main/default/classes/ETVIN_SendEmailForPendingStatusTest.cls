@isTest
public class ETVIN_SendEmailForPendingStatusTest {
  
    private static testmethod void sendEmailFunc(){
        
        test.startTest();
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Private';
        insert ve;
        
        Account acc = new Account();
        //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Partner').getRecordTypeId();
        acc.Name = 'test';
        
        insert acc;
        
        contact con = new contact();
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        con.AccountId = acc.Id;
        con.ETVIN_Insurance_Portal_User__c = true;
        insert con;
        
        
        contact con2 = new contact();
        con2.LastName = 'test1';
        con2.Email = 'test2@gmail.com';
        con2.ETVIN_Insurance_Portal_User__c = true;
        con2.AccountId = acc.Id;
        insert con2;
        
        ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
        etv.Vehicle__c = ve.Id;
        etv.ETVIN_Insurance_Company__c= acc.id;
        etv.ETVIN_Insurance_Status__c = 'Active';
        etv.ETVIN_Request_Status__c  = 'New';
        
        insert etv;
        etv.ETVIN_Request_Status__c  ='Insurance Pending';
        update etv;
        etv.ETVIN_Request_Status__c  ='Insurance Approved';
        update etv;
        etv.ETVIN_Request_Status__c  ='Insurance Rejected';
        update etv;
        
        ETIN_Claim__c cl = new ETIN_Claim__c();
        cl.ETIN_Insurance_Partner__c = acc.Id;
        cl.Vehicle_Master__c = ve.Id;
        cl.RecordTypeId = Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Insurance').getRecordTypeId();
        
        insert cl;
        
        cl.ETIN_Claim_Status__c ='Pending';
        //update cl;
        cl.ETIN_Claim_Status__c ='Rejected';
        update cl;
         cl.ETIN_Claim_Status__c ='Approved';
        update cl;
        
         VehicleInsEmailNotification__c vr = new VehicleInsEmailNotification__c();
        vr.Email__c = 'test@gmail.com';
        vr.Label__c ='PRO';
        vr.Name = 'PRO';
        insert vr;
        
        Correction_Cancel_Request__c co  = new Correction_Cancel_Request__c();
        co.Vehicle_Master__c = ve.id;
        co.Vehicle_Insurance_Policy__c = etv.Id;
        co.Request_Status__c= 'New';
        co.Correction_for__c ='Chassis Number';
        co.Insurance_Company__c = acc.id;
        
        insert co;
        co.Request_Status__c= 'Insurance Pending';
        update co;
        co.Request_Status__c= 'Insurance Approved';
        update co;
        co.Request_Status__c= 'Insurance Rejected';
         update co;
        
         Correction_Cancel_Request__c co1  = new Correction_Cancel_Request__c();
        co1.Vehicle_Master__c = ve.id;
        co1.Vehicle_Insurance_Policy__c = etv.Id;
        co1.Insurance_Company__c = acc.Id;
        co1.Request_Status__c= 'New';
        co1.Reason_for_Cancellation__c = 'Vehicle Theft';
        co1.RecordTypeId = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Theft_Request').getRecordTypeId();
        insert co1;
        
        co1.Reason_for_Cancellation__c = 'Scrapped Vehicle Theft';
        update co1;
        
        ETIN_Insurance_Transactions__c eit = new ETIN_Insurance_Transactions__c();
        
        eit.ETIN_AP_Type__c = 'Debit Note';
        eit.ETIN_Amount__c = 100;
        insert eit;
        
       
         
        test.stopTest();
        
    }
    
    private static testmethod void testCorrectionReq(){
         test.startTest();
        VehicleInsEmailNotification__c email = new VehicleInsEmailNotification__c();
        email.Name ='Pro';
        email.Label__c='PRO';
        email.Email__c ='test@ma.com';
        insert email;
        
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Private';
        insert ve;
        
        Account acc = new Account();
        //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Partner').getRecordTypeId();
        acc.Name = 'test';
        
        insert acc;
        
        contact con = new contact();
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        con.AccountId = acc.Id;
        con.ETVIN_Insurance_Portal_User__c = true;
        insert con;
        
        ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
        etv.Vehicle__c = ve.Id;
        etv.ETVIN_Insurance_Company__c= acc.id;
        etv.ETVIN_Insurance_Status__c = 'Active';
        etv.ETVIN_Request_Status__c  = 'New';
        
        insert etv;
        
        Correction_Cancel_Request__c mulReq = new Correction_Cancel_Request__c();
        mulReq.Vehicle_Master__c = ve.id;
        mulReq.Vehicle_Insurance_Policy__c = etv.Id;
        mulReq.Request_Status__c= 'Insurance Pending';
        mulReq.Insurance_Company__c = acc.id;
        mulReq.RecordTypeId =  Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosByDeveloperName().get('Available_for_Mulkiya').getRecordTypeId();
        insert mulReq;       
        
        test.stopTest();
    }
}