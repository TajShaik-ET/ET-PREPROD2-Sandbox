public class ETIN_RenewalProcessCtrl {
    
   @AuraEnabled    
   public static list<ETIN_Insurance__c> getCurrentInsRecords(Integer recordLimit, Integer recordOffset,string visalocation) {
       
     Id HealthNewRecTyID = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
      list<ETIN_Insurance__c> insuranceList = new list<ETIN_Insurance__c>();
               
       Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
       
     String queryString = 'SELECT id,RecordTypeId,Emirates_ID__c,Visa_Emirates__c,Marital_Status__c,Name,Plan__c,Employee_Family__c,Comments__c,EID__c,Employee_Family__r.Age__c, Employee_Status__c,Member_Name__c,Effective_Date__c,Employee_ID__c,Expiry_Date__c,EmployeeAcc__r.ETIN_Gross_Salary__c,EmployeeAcc__r.FirstName,EmployeeAcc__r.ET_Emirates_Id__c,EmployeeAcc__r.LastName,EmployeeAcc__r.Name,EmployeeAcc__r.ETIN_Employee_Id__c,EmployeeAcc__r.PersonContact.Birthdate,Relation__c,Status__c,Renew_Status__c,Insurance_Current_Status__c,EmployeeAcc__c,Insurance_Policy_Number__c,Insurance_Company__c,Card_Number__c FROM ETIN_Insurance__c where Visa_Emirates__c=:visalocation AND Renew_Status__c=FALSE AND Expiry_Date__c=THIS_YEAR AND Status__c=\'Completed\'  LIMIT :intLimit Offset :intOffset';
       
      insuranceList.addAll((List<ETIN_Insurance__c>) Database.query(queryString));
       return insuranceList;
   }
    
    @AuraEnabled
    public static Integer getTotalRecords(string visalocation){
        AggregateResult results = [SELECT Count(Id) TotalRec  From ETIN_Insurance__c where Visa_Emirates__c=:visalocation AND Renew_Status__c=FALSE AND Expiry_Date__c=THIS_YEAR AND Status__c='Completed'];
        Integer TotalRec = (Integer)results.get('TotalRec') ; 
        return TotalRec;
    } 
    
    @AuraEnabled
    public static void updateInsurance(List<ETIN_Insurance__c> acc ){
        update acc;
    }
    
     @AuraEnabled 
    public static user fetchUser(){
        
        User oUser = [select id,Name,Username,UserRole.Name,profile.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    @AuraEnabled
    public static void RenewProcess(List<ETIN_Insurance__c> renewList ){
        
        list<ETIN_Insurance__c> updateInsList = new list<ETIN_Insurance__c>();
        
        set<Id> insertedRecordsId = new set<id>();
        list<id> ownerIDs = new list<id>();
        list<ETIN_Insurance__c> newRenewInsert = new list<ETIN_Insurance__c>();
        List<InsurancePlansMaster__c> masterPanelList = [select id,Name,Plans__c,Condition__c,Salary__c,Emirates__c from InsurancePlansMaster__c];
        User oUser = [select id,Name,Username,UserRole.Name,profile.Name,ETSALES_Employee_Zone__c FROM User Where id =: userInfo.getUserId()];
        
        for(ETIN_Insurance__c et : renewList){
            
            string plan ='';
            
            for(InsurancePlansMaster__c plm : masterPanelList){
                
                if( plm.Emirates__c == et.Visa_Emirates__c && et.EmployeeAcc__r.ETIN_Gross_Salary__c <= plm.Salary__c  && plm.Condition__c == 'Less or Equal' ){
                    
                    plan =   plm.Plans__c;                    
                }
                if( plm.Emirates__c == et.Visa_Emirates__c && et.EmployeeAcc__r.ETIN_Gross_Salary__c > plm.Salary__c  && plm.Condition__c == 'More' ){
                    
                    plan =   plm.Plans__c;                    
                }
              system.debug('--MasterDetails--'+plm.Emirates__c+'--'+plm.Salary__c);
            }
            system.debug('--planDetails--'+et.Visa_Emirates__c+'--'+et.EmployeeAcc__r.ETIN_Gross_Salary__c);
             
            system.debug('--plan--'+plan);
            
            ETIN_Insurance__c etNew = new ETIN_Insurance__c();
            
            etNew.Previous_Insurance__c = et.Id;            
            etNew.EmployeeAcc__c = et.EmployeeAcc__c;
            etNew.Insurance_Company__c = et.Insurance_Company__c;
            etNew.Enrollment_Date__c = system.today();
            etNew.RecordTypeId = et.RecordTypeId;
            etNew.Plan__c = plan;
            //etNew.Gross_Salary__c = et.Gross_Salary__c;
            if(oUser.Profile.Name == System.Label.INS_AdminProfileName ){
               etNew.Status__c ='Under Process'; 
            }else{
               etNew.Status__c = 'Pending with HR Manager'; 
            }            
            etNew.Principal_Reference__c = et.Principal_Reference__c;
            etNew.Old_Package_Name__c = et.Plan__c;
            etNew.Renew_Request__c = True;
            etNew.ETIN_Bulk_Process__c=True;
            etNew.Employee_Family__c = et.Employee_Family__c;
            etNew.Comments__c = et.Comments__c;
            Integer nextYear = system.today().year()+1;
            etNew.Effective_Date__c = date.newinstance(nextYear, 1, 1);
            etNew.Expiry_Date__c = date.newinstance(nextYear, 12, 31);
            
            newRenewInsert.add(etNew);
        }
        
        try{  
            if(newRenewInsert.size()>0 ) {
                Database.SaveResult[] srList = Database.insert(newRenewInsert);
                
                /*for(ETIN_Insurance__c etu : newRenewInsert){
                    
                    ownerIDs.add(etu.OwnerId);
                }*/
                for (Database.SaveResult sr : srList) {
                    
                    if (sr.isSuccess()) {
                
                       insertedRecordsId.add(sr.getId());
                       
                    }
                    
                }
                
            }
            
        }catch (Exception e) {
                
                throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
        }
        //updating recently inserted ids to previous insurance policies
        for (ETIN_Insurance__c etRecent : [select Previous_Insurance__c from ETIN_Insurance__c where Id=:insertedRecordsId]){
            
            ETIN_Insurance__c et = new ETIN_Insurance__c();
            
            et.Id= etRecent.Previous_Insurance__c;
            et.Renew_Status__c = True;
            updateInsList.add(et);
            
        }
        
        try{
            if(updateInsList.size()>0) {
                Database.SaveResult[] srList = Database.update(updateInsList);
            }
        } catch(Exception e){
            
            throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
        }
        //Send email to Hr Manager if submitter is coordinator
         if(oUser.profile.Name == System.Label.INS_ZoneCordProfileName){
            Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
            List<String> listStrings = new List<String>();
            
            for(user u : [SELECT Id, Email FROM User where isActive=true AND profile.Name=:System.Label.INS_ZoneHRProfileName AND ETSALES_Employee_Zone__c=:oUser.ETSALES_Employee_Zone__c]){
                listStrings.add(u.Email);
            }
            
            Id emailTemplate = [select Id, Body  from EmailTemplate where DeveloperName = 'ETIN_SendToZoneHRManager'].Id;
            if(listStrings.size()>0){    
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                email.setToAddresses(listStrings);
                email.setSaveAsActivity(false);
                email.setTargetObjectId(UserInfo.getUserId());
                email.setTemplateId(emailTemplate);
                emailList.add(email);
                
                
                //send an email
                Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
            }
        }
        
       
    }
    
}