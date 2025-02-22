@isTest
public class ETIN_AdminSettingsCtrlTest {

    
    private static testmethod void adminSettings(){
        
        ETIN_AdminSettingsCtrl.getDocMasterCustom();
        ETIN_AdminSettingsCtrl.getInsurancePlanMaster();
        ETIN_AdminSettingsCtrl.getRenewalButton();
        
        
        ETIN_RenewalButton__c er = new ETIN_RenewalButton__c();
        er.Name = 'testrec';
        er.Visibility__c = true;
        er.Message__c = 'test';
        insert er;
        
        ETIN_AdminSettingsCtrl.updateRenewalButton(er.Id, false);
        
        
        ETIN_AdminSettingsCtrl.updatePopupMsg(er.Id, false, 'test');
        
       
        
       InsuranceDocumentMaster__c ins = new InsuranceDocumentMaster__c();
        
        ins.Name = 'testt';
        ins.Label_Name__c = 'testtt';
        ins.Formats__c = '.jpg';
        ins.Emirate__c ='Dubai';
        ins.Visibility__c = true;
        
        insert ins;
        
        ETIN_AdminSettingsCtrl.updateRecordMasterDocMdt(ins);
        ETIN_AdminSettingsCtrl.DeleteRecordMasterDocMdt(ins);
        ETIN_AdminSettingsCtrl.saveRecordMasterDocMdt(ins);
        
        InsurancePlansMaster__c insp = new InsurancePlansMaster__c();
        
        insp.Name = 'test';
        insp.Emirates__c = 'Dubai';
        insp.Insurance_Company__c = 'AXA';
        insp.Plans__c = 'Basic';
        insp.Salary__c = 4000;
        insp.Condition__c = 'More';
         
         insert insp;
        ETIN_AdminSettingsCtrl.updatePlanMaster(insp);
        ETIN_AdminSettingsCtrl.DeletePlanMasterRec(insp);
        ETIN_AdminSettingsCtrl.saveRecordMasterPlans(insp);
        
         ETIN_InsuranceClaimDocs__c inscl = new ETIN_InsuranceClaimDocs__c();
        
           inscl.Name = 'claim';
           inscl.Label__c = 'Claim';
           inscl.Visibility__c = true;
           inscl.Accepted_Format__c = '.pdf';
        
        insert inscl;
       
       ETIN_AdminSettingsCtrl.getInsuranceClaimDocs();
       ETIN_AdminSettingsCtrl.SaveClaimDocs(inscl);
      
       ETIN_AdminSettingsCtrl.updateClaimData(inscl);
         ETIN_AdminSettingsCtrl.DeleteClaimDocRec(inscl);
       ETIN_AdminSettingsCtrl.getDefaultInsPartners();
       ETIN_AdminSettingsCtrl.getPartnerAccList();
        
        list<ETIN_DefaultInsurancePartners__c> edfList = new list<ETIN_DefaultInsurancePartners__c>();
        ETIN_DefaultInsurancePartners__c edf = new ETIN_DefaultInsurancePartners__c();
        edf.Name = 'test';
        edf.Account_ID__c ='DAMAN';
        insert edf;
        edfList.add(edf);
        
        ETIN_AdminSettingsCtrl.updateInsPartList(edfList);
        
    }
}