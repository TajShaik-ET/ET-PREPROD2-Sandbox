public class ETVIN_VehicleInsuranceSettingsCtrl{
    
    @AuraEnabled
    public static List <VehicleInsuranceClaimDocs__c> getDocMasterClaims() {
        return [SELECT Id,Name,Accepted_Format__c,Label__c,Visibility__c FROM VehicleInsuranceClaimDocs__c ];
        
    } 
    
      @AuraEnabled
    public static String SaveClaimDocs( VehicleInsuranceClaimDocs__c Row ) {
        
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, 4);
        
        VehicleInsuranceClaimDocs__c inscl = new VehicleInsuranceClaimDocs__c();
        
           inscl.Name = Row.Label__c.deleteWhitespace()+'_'+randomNumber;
           inscl.Label__c = Row.Label__c;
           inscl.Visibility__c = Row.Visibility__c;
           inscl.Accepted_Format__c = Row.Accepted_Format__c;
       
        try {
                 insert inscl;
             }
            catch (Exception e) {
                 system.debug('Inseration Error:'+e);
                throw new AuraHandledException('Something went wrong: '+ e.getMessage());   
                
            }
        return null;
       
    }
     @AuraEnabled
    public static void updateClaimData(VehicleInsuranceClaimDocs__c Row ) {
        
        try{
            update Row;
        }catch(Exception e){
            //system.debug('Inseration Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
      
    }
    
    @AuraEnabled
    public static void DeleteClaimDocRec(VehicleInsuranceClaimDocs__c Row ) {
        system.debug('Row----'+Row);      
        try{
            delete Row;
        }catch(Exception e){
            //system.debug('Inseration Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
        
     }   
     @AuraEnabled
    public static list<VehicleInsEmailNotification__c> getEmailConfigData(){
        
        return [select id,name,Email__c,Label__c from VehicleInsEmailNotification__c];
    }
    
     @AuraEnabled
    public static void updateEmailConfigData(VehicleInsEmailNotification__c Row ) {
        
        try{
            update Row;
        }catch(Exception e){
            //system.debug('Inseration Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
      
    }
    
     @AuraEnabled    
    public static list<account> getPartnerAccList(){
        try {
               return [select id,name from account where recordtype.developername='ETSALES_B2B_Account' and Type='Insurance Partner'];
             }
            catch (Exception e) {
                
                throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
            }
        
    }
    @AuraEnabled  
    public static Veh_Default_Insurance_partner__c getDefaultInsPartner(){
        
        return [select id,Account_ID__c from Veh_Default_Insurance_partner__c];
    }
    
    @AuraEnabled     
    public static void updateInsPartnerDefault(list<Veh_Default_Insurance_partner__c> newValue){
        
        
        try { 
          update newValue;
        }catch(Exception e) {
            system.debug('----'+e.getMessage()); 
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
        }
    }
    
   
    
}