public  with sharing class ETIN_ZoneRenewalReqCtrl {
    
    @AuraEnabled    
    
    public static list<ETIN_Insurance__c> getInsuranceDetails() {
        
        Id HealthNewRecTyID = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
        //Id HealthNewRecTyID2 = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('ETIN_Health_Insurance_In_progress').getRecordTypeId();
        set<id> recTypeId = new set<id>();
        recTypeId.add(HealthNewRecTyID);
        //recTypeId.add(HealthNewRecTyID2);
             
        return [SELECT id,RecordTypeId,CreatedById,Name,Previous_Owner__c,Plan__c,Employee_Family__c,Comments__c,EID__c,Employee_Family__r.Age__c, Employee_Status__c,Member_Name__c,Effective_Date__c,Employee_ID__c,Expiry_Date__c,EmployeeAcc__r.FirstName,EmployeeAcc__r.ET_Emirates_Id__c,EmployeeAcc__r.LastName,EmployeeAcc__r.Name,EmployeeAcc__r.ETIN_Employee_Id__c,EmployeeAcc__r.PersonContact.Birthdate,Relation__c,Status__c,Renew_Status__c,Insurance_Current_Status__c,EmployeeAcc__c,Insurance_Policy_Number__c,Insurance_Company__c,Card_Number__c,owner.Name,createdBy.Name from ETIN_Insurance__c where RecordTypeid=:recTypeId AND Renew_Request__c= true and Renew_Status__c=false order by Name LIMIT 50000];
    }
    
    
      @AuraEnabled    
    
    public static list<ETIN_Insurance__c> getInsuranceAdminDetails() {
        
        Id HealthNewRecTyID = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
        
       //Id HealthNewRecTyID2 = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('ETIN_Health_Insurance_In_progress').getRecordTypeId();
        set<id> recTypeId = new set<id>();
        recTypeId.add(HealthNewRecTyID);
       // recTypeId.add(HealthNewRecTyID2);
                
              
        return [SELECT id,RecordTypeId,CreatedById,Name,Plan__c,Employee_Family__c,Comments__c,EID__c,Employee_Family__r.Age__c, Employee_Status__c,Member_Name__c,Effective_Date__c,Employee_ID__c,Expiry_Date__c,EmployeeAcc__r.FirstName,EmployeeAcc__r.ET_Emirates_Id__c,EmployeeAcc__r.LastName,EmployeeAcc__r.Name,EmployeeAcc__r.ETIN_Employee_Id__c,EmployeeAcc__r.PersonContact.Birthdate,Relation__c,Status__c,Renew_Status__c,Insurance_Current_Status__c,EmployeeAcc__c,Insurance_Policy_Number__c,Insurance_Company__c,Card_Number__c,owner.Name,Previous_Owner__c,createdBy.Name  from ETIN_Insurance__c where RecordTypeid=:recTypeId AND Renew_Request__c= true AND Renew_Status__c=false AND Status__c='Under Approval'  order by Name LIMIT 50000];
    }   
        
        
    @AuraEnabled 
    public static user fetchUser(){
        
        User oUser = [select id,Name,Username,UserRole.Name,profile.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    @AuraEnabled    
    
    public static void submitToZoneHRManager(List<Id> recIDs) { 
        
        map<string,Id> empZoneVsUserID = new map<string,Id> ();
        list<id> ownerIDs = new list<id>();
        
        for(user u : [select id,ETSALES_Employee_Zone__c  from user where isActive=true AND profile.Name =:System.Label.INS_ZoneHRProfileName]){
            
            empZoneVsUserID.put(u.ETSALES_Employee_Zone__c,u.Id);
            
        }
        system.debug('--empZoneVsUserID--'+empZoneVsUserID);
        List<ETIN_Insurance__c> updateList = new  List<ETIN_Insurance__c> ();
        for(ETIN_Insurance__c et : [select Id,EmployeeAcc__r.ETIN_Employee_Zone__c from ETIN_Insurance__c where id=:recIDs ]){
            
             system.debug('---Zone--'+et.EmployeeAcc__r.ETIN_Employee_Zone__c);
            if(et.EmployeeAcc__r.ETIN_Employee_Zone__c != null || et.EmployeeAcc__r.ETIN_Employee_Zone__c != ''){
                
                et.OwnerId = empZoneVsUserID.get(et.EmployeeAcc__r.ETIN_Employee_Zone__c);
                et.Status__c ='Pending with HR Manager';
            
            }
            
            updateList.add(et);
             system.debug('----69--'+updateList);
        }
        
        if(updateList.size()>0){
            try {
                update updateList;
                
              
                
                for(ETIN_Insurance__c etu : updateList){
                    
                    ownerIDs.add(etu.ownerId);
                }
                
                
            }
            catch (Exception e) {
                
                // throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
                system.debug('exception'+e);
            }
        }    
        if(ownerIDs.size()>0){
            Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
            List<String> listStrings = new List<String>();
            
            for(user u : [SELECT Id, Email FROM User where Id=:ownerIDs]){
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
    
    @AuraEnabled    
    
    public static void submitToInsuranceAdmin(List<ETIN_Insurance__c> recList) { 
        
        list<user> u = [select id,name,Email,ETSALES_Employee_Zone__c,UserRole.Name  from user where isactive=true AND profile.Name=:system.label.INS_AdminProfileName];
        list<ETIN_Insurance__c> updateList = new list<ETIN_Insurance__c>();
        List<String> listStrings = new List<String>();
        
       // listStrings.add('janardhan.m@smaartt.com');
          for(user us : u){

              listStrings.add(us.Email);
          }
        
        for(ETIN_Insurance__c et : recList){
            
            et.Status__c = 'Under Approval';//'Admin Approval Pending';
            et.Previous_Owner__c = et.OwnerId;
            if(u.size()>0){
            et.OwnerId = u[0].Id;
            }
            
            updateList.add(et);
            
        }
        if(updateList.size()>0){
            try {
                update updateList;
                
                Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
                Id emailTemplate = [select Id, Body  from EmailTemplate where DeveloperName = 'ETIN_SendToInsuranceAdmin'].Id;
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
            catch (Exception e) {
                
                // throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
                system.debug('exception'+e);
            }
        }    
        
    }
    
     @AuraEnabled
    public static void submitToZoneCoord(List<ETIN_Insurance__c> recList) {
        
       list<ETIN_Insurance__c> updateList = new list<ETIN_Insurance__c>();
        set<Id> ownerIds = new set<id>();
        
        for(ETIN_Insurance__c et : recList){
            
            et.Status__c = 'Pending with Zone Coordinator';
            et.OwnerId = et.CreatedById;
            
            updateList.add(et);
            
        }
        if(updateList.size()>0){
            try {
                update updateList;
               // system.debug('--up--'+updateList);
                
                for(ETIN_Insurance__c er : updateList){
                    
                    ownerIds.add(er.OwnerId);
                }
            }
            catch (Exception e) {
                system.debug('exception'+e);
               throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
                
            }
            
        }
         if(ownerIds.size()>0){
            Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
            List<String> listStrings = new List<String>();
            
            for(user u : [SELECT Id, Email FROM User where Id=:ownerIds]){
                listStrings.add(u.Email);
            }
            
            Id emailTemplate = [select Id, Body  from EmailTemplate where DeveloperName = 'ETIN_SendToZoneCoordinator'].Id;
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
    
    @AuraEnabled
    public static void ApprovedByAdminMethod(List<ETIN_Insurance__c> recList) {
       
        list<ETIN_Insurance__c> updateList = new list<ETIN_Insurance__c>();
        
         for(ETIN_Insurance__c et : recList){
            
            et.Status__c = 'Under Process';
                        
            updateList.add(et);
            
        }
        
         if(updateList.size()>0){
            try {
                update updateList;
                
            }
            catch (Exception e) {
                
                // throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
                system.debug('exception'+e);
            }
            
        }
        
    }
    
     @AuraEnabled
    public static void RejectedByAdminMethod(List<ETIN_Insurance__c> recList) {
        
      system.debug('--rejc'+recList);
       
       list<ETIN_Insurance__c> updateList = new list<ETIN_Insurance__c>();
        set<Id> ownerIds = new set<id>();
        
         for(ETIN_Insurance__c et : recList){
            
            et.Status__c = 'Pending with HR Manager';
            et.OwnerId = et.Previous_Owner__c;
            updateList.add(et);
            
        }
        
         if(updateList.size()>0){
            try {
                update updateList;
                
                for(ETIN_Insurance__c er : updateList){
                    
                    ownerIds.add(er.OwnerId);
                }
                
            }
            catch (Exception e) {
                 
                system.debug('exception'+e);
                throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
            }
            
        }
        if(ownerIds.size()>0){
            Messaging.SingleEmailMessage[] emailList = new list<Messaging.SingleEmailMessage>();
            List<String> listStrings = new List<String>();
            
            for(user u : [SELECT Id, Email FROM User where Id=:ownerIds]){
                listStrings.add(u.Email);
            }
            
            Id emailTemplate = [select Id, Body  from EmailTemplate where DeveloperName = 'ETIN_SendRejectToHRManager'].Id;
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