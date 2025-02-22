@isTest(SeeAllData=true)
public class ETVIN_ShowVehicleInsuranceCtrlTest {
    
    private static testmethod void getInsuranceDetailsTest(){
        
         Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Private';
        insert ve;
        
        Account acc = new Account();
        //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Partner').getRecordTypeId();
        acc.Name = 'xyz32454';
        
        insert acc;
        ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
        etv.Vehicle__c = ve.Id;
        etv.ETVIN_Insurance_Status__c = 'Active';
        etv.ETVIN_Request_Status__c  = 'Insurance Approved';
        etv.ETVIN_Insurance_Company__c = acc.id;
        etv.ETVIN_Effective_Date__c = system.today();
        etv.ETVIN_Expiry_Date__c =system.today()+365;
        insert etv;
        
        Correction_Cancel_Request__c cor = new Correction_Cancel_Request__c();
        cor.Comments__c = 'test';
        cor.Correction_for__c ='Chassis Number';
        cor.Insurance_Company__c = acc.id;
        cor.Vehicle_Insurance_Policy__c = etv.Id;
        cor.Vehicle_Master__c=ve.Id;
        cor.Request_Status__c='Insurance Approved';
        insert cor;
        
         ETVIN_ShowVehicleInsuranceCtrl.updateStatusForCorrectionRequest(cor.Id,'Approved');
     
         ETVIN_ShowVehicleInsuranceCtrl.updateStatusForCorrectionRequest(cor.Id,'');
    }
  
    private static testmethod void getInsuranceDetails(){
        
        test.startTest();
        ETVIN_ShowVehicleInsuranceCtrl.getInsurancePoliciyDetails();
        
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Private';
        insert ve;
        
        Account acc = new Account();
        //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Partner').getRecordTypeId();
        acc.Name = 'xyz32454';
        
        insert acc;
        
        ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
        etv.Vehicle__c = ve.Id;
        etv.ETVIN_Insurance_Status__c = 'Active';
        etv.ETVIN_Request_Status__c  = 'Insurance Approved';
        etv.ETVIN_Insurance_Company__c = acc.id;
        etv.ETVIN_Effective_Date__c = system.today();
        etv.ETVIN_Expiry_Date__c =system.today()+365;
        insert etv;
        
        ETVIN_ShowVehicleInsuranceCtrl.updateStatus(etv.id,'Approved',new ETIN_Insurance_Transactions__c(ETIN_Amount__c=2000));
        
        ETVIN_ShowVehicleInsuranceCtrl.updateStatus(etv.id,'',new ETIN_Insurance_Transactions__c(ETIN_Amount__c=2000));
       
        ETVIN_ShowVehicleInsuranceCtrl.updateInsurancePoliciy(etv.Id);
        ETVIN_ShowVehicleInsuranceCtrl.getPicklistValues('case','status');
        ETVIN_ShowVehicleInsuranceCtrl.getInsuranceClaimsDetails();
        
        ETVIN_ShowVehicleInsuranceCtrl.saveTheFile(etv.Id,'test','gefdsf','.pdf');
        ETVIN_ShowVehicleInsuranceCtrl.fetchContentDocument(etv.Id);
        
        ETIN_Claim__c ec = new ETIN_Claim__c();
        ec.Claim_Amount__c = 200;
        ec.ETIN_Insurance_Partner__c = acc.Id;
        ec.ETIN_Claim_Status__c = 'New';
        ec.Vehicle_Master__c = ve.Id;
        ec.RecordTypeId =Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Insurance').getRecordTypeId();
        insert ec;
        
        ec.ETIN_Claim_Status__c = 'Approved';
        ec.Claim_for__c = 'Scrapped Vehicle Theft';
        update ec;
        
        ETIN_Insurance_Transactions__c eit = new ETIN_Insurance_Transactions__c();
        eit.Claim__c = ec.Id;
        eit.ETIN_Amount__c = 100;
        eit.ETIN_AP_Type__c = 'Debit Note';
        insert eit;
        ETVIN_ShowVehicleInsuranceCtrl.getInsuranceInsuranceTransactions(ec.Id); 
        
        ETVIN_ShowVehicleInsuranceCtrl.getCorrectionRequestDetails('Cancellation Request');
        ETVIN_ShowVehicleInsuranceCtrl.getCancelTheftReq('Cancellation Request');
        
        
        
        
       ETVIN_ShowVehicleInsuranceCtrl.updateStatusForClaims(ec.Id,'Approved');
       
        test.stopTest();
    }
}