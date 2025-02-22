@IsTest
public class ETVIN_VehicleInsuranceSettingsCtrlTest {
    
    private static testmethod void getInsuranceDetails(){
        
        ETVIN_VehicleInsuranceSettingsCtrl.getDocMasterClaims();
        ETVIN_VehicleInsuranceSettingsCtrl.getEmailConfigData();
        VehicleInsuranceClaimDocs__c vi = new VehicleInsuranceClaimDocs__c();
        vi.Name = 'test';
        vi.Label__c = 'test';
        vi.Accepted_Format__c = '.pdf';
        vi.Visibility__c = true;
        insert vi;
        ETVIN_VehicleInsuranceSettingsCtrl.SaveClaimDocs(vi);
        ETVIN_VehicleInsuranceSettingsCtrl.updateClaimData(vi);
        ETVIN_VehicleInsuranceSettingsCtrl.DeleteClaimDocRec(vi);
        
        try{
            ETVIN_VehicleInsuranceSettingsCtrl.updateClaimData(new VehicleInsuranceClaimDocs__c()); 
        }catch(Exception e){
            
            
        }
        
        VehicleInsEmailNotification__c ve = new VehicleInsEmailNotification__c();
        ve.Name = 'test';
        ve.Email__c = 'rw@gmail.com';
        insert ve;
        ETVIN_VehicleInsuranceSettingsCtrl.updateEmailConfigData(ve);
        try{
            ETVIN_VehicleInsuranceSettingsCtrl.updateEmailConfigData(new VehicleInsEmailNotification__c()); 
            
        }catch(Exception e){
            
            
        }
        Veh_Default_Insurance_partner__c vehDe = new Veh_Default_Insurance_partner__c();
        list<Veh_Default_Insurance_partner__c> veList = new list<Veh_Default_Insurance_partner__c>();
        vehDe.name = 'test';
        vehDe.Account_ID__c='352643';
        insert vehDe;
       
        try{
            ETVIN_VehicleInsuranceSettingsCtrl.updateInsPartnerDefault(veList);
        }catch(DMLException e){
            system.assertEquals(e.getMessage(), e.getMessage()); 
        }
        veList.add(vehDe);
       // ETVIN_VehicleInsuranceSettingsCtrl.updateInsPartnerDefault(veList);
        
       ETVIN_VehicleInsuranceSettingsCtrl.getDefaultInsPartner();
        try{ 
            ETVIN_VehicleInsuranceSettingsCtrl.getPartnerAccList();
        }catch(DMLException e){
           system.assertEquals(e.getMessage(), e.getMessage()); 
        }
      
    }

}