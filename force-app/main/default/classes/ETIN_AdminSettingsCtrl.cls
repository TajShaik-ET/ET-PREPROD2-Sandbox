public class ETIN_AdminSettingsCtrl {
    
     @AuraEnabled
    public static List <ETIN_RenewalButton__c> getRenewalButton() {
        return [SELECT Id,Name,Visibility__c, Message__c FROM ETIN_RenewalButton__c];

    } 
        
       
    @AuraEnabled
    public static List <InsuranceDocumentMaster__c> getDocMasterCustom() {
        return [SELECT Id,Name,Formats__c,Label_Name__c,Emirate__c,Visibility__c,Mandatory__c FROM InsuranceDocumentMaster__c  order by Emirate__c ];
        
    } 
    
    
    @AuraEnabled
    public static string updateRenewalButton(String RecId, Boolean BooleanVal) {
       
        ETIN_RenewalButton__c er = new ETIN_RenewalButton__c();
        
        er.Id =RecId ;
        er.Visibility__c = BooleanVal;
        
        try{
            update er;
            return 'success';
        }catch(Exception e){
            system.debug('Inseration Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
           
        }
         
        
    } 
    
     //Added by Arunsarathy 23.11.2022
    @AuraEnabled
    public static string updatePopupMsg(String RecId, Boolean BooleanVal, string popmessage) {
       
         ETIN_RenewalButton__c er = new ETIN_RenewalButton__c();
        
        er.Id =RecId ;
        er.Visibility__c = BooleanVal;
        er.Message__c = popmessage;
        
        try{
            update er;
            return 'success';
        }catch(Exception e){
            system.debug('Inseration Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
           
        }
    } 
    
     @AuraEnabled
    public static String saveRecordMasterDocMdt( InsuranceDocumentMaster__c metadataRecord ) {
        
        InsuranceDocumentMaster__c ins = new InsuranceDocumentMaster__c();
        
         
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, 4);
        
        ins.Name = metadataRecord.Label_Name__c.deleteWhitespace()+'_'+randomNumber;
        ins.Label_Name__c = metadataRecord.Label_Name__c;
        ins.Formats__c = metadataRecord.Formats__c;
        ins.Emirate__c =metadataRecord.Emirate__c;
        ins.Visibility__c = metadataRecord.Visibility__c;
        ins.Mandatory__c = metadataRecord.Mandatory__c;
        
        insert ins;
        
        return null;
       
    }
    
     @AuraEnabled
    public static void DeleteRecordMasterDocMdt(InsuranceDocumentMaster__c Row ) {
        
        delete Row;
        
     }
    
     @AuraEnabled
    public static void updateRecordMasterDocMdt(InsuranceDocumentMaster__c Row ) {
        system.debug('----'+Row);
        try{
            update Row;
        }catch(Exception e){
            system.debug('Inseration Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
            
        }
         
        
     }
    
   @AuraEnabled
    public static List <InsurancePlansMaster__c> getInsurancePlanMaster() {
        return [SELECT Id,Name,Condition__c,Emirates__c,Insurance_Company__c,Plans__c,Salary__c FROM InsurancePlansMaster__c order by Emirates__c];
        
    } 
     @AuraEnabled
    public static String saveRecordMasterPlans( InsurancePlansMaster__c data ) {
        
        InsurancePlansMaster__c insp = new InsurancePlansMaster__c();
        
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, 4);
        
        insp.Name = data.Emirates__c.deleteWhitespace()+'_'+randomNumber;
        insp.Emirates__c = data.Emirates__c;
        insp.Insurance_Company__c = data.Insurance_Company__c;
        insp.Plans__c = data.Plans__c;
        insp.Salary__c = data.Salary__c;
        insp.Condition__c = data.Condition__c;
         
       
        
        try {
                 insert insp;
             }
            catch (Exception e) {
                
                throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
            }
        return null;
       
    }
       
    
     @AuraEnabled
    public static void DeletePlanMasterRec(InsurancePlansMaster__c Row ) {
        
        delete Row;
        
     }    
    
        
     @AuraEnabled
    public static void updatePlanMaster(InsurancePlansMaster__c Row ) {
       
        try{
            update Row;
        }catch(Exception e){
            system.debug('Inseration Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
            
        }
         
        
     }
    
    @AuraEnabled
    public static List <ETIN_InsuranceClaimDocs__c> getInsuranceClaimDocs() {
        return [SELECT Id,Name,Label__c,Accepted_Format__c,Mandatory__c,Visibility__c FROM ETIN_InsuranceClaimDocs__c];
        
    } 
        
     @AuraEnabled
    public static String SaveClaimDocs( ETIN_InsuranceClaimDocs__c Row ) {
        
        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
        String randomNumber = str.substring(0, 4);
        
        ETIN_InsuranceClaimDocs__c inscl = new ETIN_InsuranceClaimDocs__c();
        
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
    public static void updateClaimData(ETIN_InsuranceClaimDocs__c Row ) {
        
        try{
            update Row;
        }catch(Exception e){
            system.debug('Inseration Error:'+e);
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
      
    }
     @AuraEnabled
    public static void DeleteClaimDocRec(ETIN_InsuranceClaimDocs__c Row ) {
        
        delete Row;
        
     }   
    
     @AuraEnabled
    public static List <ETIN_DefaultInsurancePartners__c> getDefaultInsPartners() {
        return [SELECT Id,Name,Account_ID__c FROM ETIN_DefaultInsurancePartners__c order by Name];
        
    }  
     
    @AuraEnabled
    public static void updateInsPartList(List<ETIN_DefaultInsurancePartners__c> UpdateList ) {
        
        try{
            update UpdateList;
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
}