public with sharing class ETIN_InsuranceAdminController {
    
    
     @AuraEnabled    
    public static list<ETIN_Insurance__c> getInsuranceDetails(String policyNumber,String EmpID,String firstName,String lastName,String emiratesID,String plan,String Location) {
        
        
        Id HealthNewRecTyID = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
        //Id HealthNewRecTyID2 = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('ETIN_Health_Insurance_In_progress').getRecordTypeId();
        set<id> recTypeId = new set<id>();
        recTypeId.add(HealthNewRecTyID);
        //recTypeId.add(HealthNewRecTyID2);
        
        String whereClause  ='WHERE RecordTypeid =:recTypeId';
        String queryLimit =' ORDER BY Name DESC LIMIT 1000';
        
        list<ETIN_Insurance__c> insuranceList = new list<ETIN_Insurance__c>();
        if (String.isNotEmpty(policyNumber))
        {            
            whereClause+=' AND Card_Number__c LIKE \'%'+String.escapeSingleQuotes(policyNumber)+'%\'';
        }
        if (String.isNotEmpty(firstName))
        {            
            whereClause+=' AND EmployeeAcc__r.FirstName LIKE \'%'+String.escapeSingleQuotes(firstName)+'%\'';
        }
         if (String.isNotEmpty(lastName))
        {            
            whereClause+=' AND EmployeeAcc__r.LastName LIKE \'%'+String.escapeSingleQuotes(lastName)+'%\'';
        }
        if (String.isNotEmpty(emiratesID))
        {            
            whereClause+=' AND EmployeeAcc__r.ET_Emirates_Id__c LIKE \'%'+String.escapeSingleQuotes(emiratesID)+'%\'';
        }
        if (String.isNotEmpty(EmpID))
        {            
            whereClause+=' AND EmployeeAcc__r.ETIN_Employee_Id__c LIKE \'%'+String.escapeSingleQuotes(EmpID)+'%\'';
        }
       
        if (Location=='Dubai'){
        
          List<String> dubaiCondition = label.Insurance_DubaiSet.split(',');
        whereClause+= ' AND Visa_Emirates__c =:dubaiCondition ';
            
        }
        else if (Location=='Abu Dhabi'){
        List<String> abuDhabiCondition = label.Insurance_AbuDhabiSet.split(',');
        whereClause+= ' AND Visa_Emirates__c =:abuDhabiCondition ';    
        }
        
        
        
        String queryString = 'SELECT id,Name,Plan__c,Employee_Family__c,Member_Name__c,Effective_Date__c,Employee_ID__c,Expiry_Date__c,EmployeeAcc__r.FirstName,EmployeeAcc__r.ET_Emirates_Id__c,EmployeeAcc__r.LastName,EmployeeAcc__r.Name,EmployeeAcc__r.ETIN_Employee_Id__c,EmployeeAcc__r.PersonContact.Birthdate,Relation__c,Status__c,Renew_Status__c,Insurance_Current_Status__c,EmployeeAcc__c,Insurance_Policy_Number__c,Insurance_Company__c,Card_Number__c FROM ETIN_Insurance__c '+whereClause+queryLimit;
        system.debug(queryString);
        insuranceList.addAll((List<ETIN_Insurance__c>) Database.query(queryString));
        system.debug(insuranceList+'res.....');
        
        return insuranceList;
    }
    
     @AuraEnabled 
    public static user fetchUser(){
        
        User oUser = [select id,Name,Username,UserRole.Name,Profile.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    @AuraEnabled   
    public static Id getRecordTypeId(string objName,string devName){
        
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(objName) ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByDeveloperName();
        Id rtId = RecordTypeInfo.get(devName).getRecordTypeId();
        
        return rtId;
    }
    
    
    @AuraEnabled    
    public static list<account> getEmployeeDetails(String EmpID,String firstName,String lastName,String Dept,string location) { 
        
        Id empRecTypeId = Schema.SObjectType.account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
       
        Set<Id> recTypesIds = new Set<Id>();
        recTypesIds.add(empRecTypeId);
       
        
        String whereClause  ='WHERE RecordTypeid =:recTypesIds AND Type=\'Employee\' AND ';
        if (location=='Dubai'){
          List<String> dubaiCondition = label.Insurance_DubaiSet.split(',');
            system.debug('dubaiCondition'+dubaiCondition);
        whereClause+= 'ETIN_Place_of_Visa_Issuance__c =:dubaiCondition ';            
        }
        else if (location=='Abu Dhabi') {
        List<String> abuDhabiCondition = label.Insurance_AbuDhabiSet.split(',');
            system.debug('abuDhabiCondition'+abuDhabiCondition);
        whereClause+= 'ETIN_Place_of_Visa_Issuance__c =:abuDhabiCondition ';    
        }
        String queryLimit =' LIMIT 3';
        list<account> empList = new list<account>(); 
        
         if (String.isNotEmpty(EmpID))
        {            
            whereClause+=' AND ETIN_Employee_Id__c LIKE \'%'+String.escapeSingleQuotes(EmpID)+'%\'';
        }
        if (String.isNotEmpty(firstName))
        {            
            whereClause+=' AND FirstName LIKE \'%'+String.escapeSingleQuotes(firstName)+'%\'';
        }
        if (String.isNotEmpty(lastName))
        {            
            whereClause+=' AND LastName LIKE \'%'+String.escapeSingleQuotes(lastName)+'%\'';
        }
       
        
        String queryString = 'SELECT id,FirstName,LastName,Name,ET_Emirates_Id__c,ETIN_Employee_Id__c,ETIN_Place_of_Visa_Issuance__c,ETIN_Work_Emirates__c,PersonBirthdate,ETST_Gender__c,ETIN_Employee_Status__c,ETIN_Salary_Band__c,ETIN_Gross_Salary__c,recordType.name FROM account '+whereClause+queryLimit;
        
        system.debug('Emp Query'+queryString);
        
        empList.addAll((List<account>) Database.query(queryString));
        system.debug('empList'+empList);
        return empList;
    }
    
    @AuraEnabled    
    public static list<ETIN_Employee_Family__c> getEmployeeFamilyDetails(String EmpID,String firstName,String lastName) { 
        
        String whereClause  ='WHERE Id != null ';
        String queryLimit =' LIMIT 4';
        list<ETIN_Employee_Family__c> empList = new list<ETIN_Employee_Family__c>();         
         if (String.isNotEmpty(EmpID))
        {            
            whereClause+=' AND Employee__r.ETIN_Employee_Id__c LIKE \'%'+String.escapeSingleQuotes(EmpID)+'%\'';
        }
        if (String.isNotEmpty(firstName))
        {            
            whereClause+=' AND Employee__r.FirstName LIKE \'%'+String.escapeSingleQuotes(firstName)+'%\'';
        }
        if (String.isNotEmpty(lastName))
        {            
            whereClause+=' AND Employee__r.LastName LIKE \'%'+String.escapeSingleQuotes(lastName)+'%\'';
        }
              
        String queryString = 'SELECT id,Name,First_Name__c,Gender__c,Age__c,Employee_ID__c,Employee__c,Employee__r.ETIN_Gross_Salary__c,Place_of_Visa_Issuance__c,Relation__c,Date_Of_Birth__c FROM ETIN_Employee_Family__c '+whereClause+queryLimit;
        empList.addAll((List<ETIN_Employee_Family__c>) Database.query(queryString));
        return empList;
    }
   
   @AuraEnabled
    public static List <ContentDocumentLink> getAttachments(String parentRecID) {
        return [SELECT Id,ContentDocumentId,ContentDocument.Title,ContentDocument.FileType FROM ContentDocumentLink where LinkedEntityId=:parentRecID];
        
    } 
        @AuraEnabled
        public static String getImageContent(String docId) {
             
            return [SELECT Id,Title FROM ContentVersion WHERE ContentDocumentId =:docId limit 1].Id;
        }


     @AuraEnabled
    public static void deleteAttachment(String contentDocId) { 
        
        ContentDocument deleteContent = new ContentDocument(Id=contentDocId);
    
        try {
            delete deleteContent;
        }
        catch (Exception e) {
            //system.debug('--'+e.getMessage());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
        }
    }
    
    @AuraEnabled
    public static List<String> getselectOptions(string objObject, string fld) { //
      
     List < String > allOpts = new list < String > ();
        
      DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objObject).getDescribe();
      DescribeFieldResult fieldResult = objResult.fields.getMap().get(fld).getDescribe();
     
        list < Schema.PicklistEntry > values =fieldResult.getPicklistValues();
        system.debug(values+'----');
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        //allOpts.sort();
      
        return allOpts;
    }       
    
    /* ------------------- Vehicle Component -------------------*/
    /*
     @AuraEnabled    
    public static list<ETIN_Insurance__c> getVehInsDetails(String policyNumber,String PlateNum,String ChassisNum,String engineNum) {
        
        system.debug('---------');
        Id VehNewRecTyID = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Insurance').getRecordTypeId();
        
        String whereClause  ='WHERE RecordTypeid =:VehNewRecTyID';
        String queryLimit =' LIMIT 50000';
        
        list<ETIN_Insurance__c> insuranceList = new list<ETIN_Insurance__c>();
        
      
        if (String.isNotEmpty(policyNumber))
        {            
            whereClause+=' AND Insurance_Policy_Number__c LIKE \'%'+String.escapeSingleQuotes(policyNumber)+'%\'';
        }
        if (String.isNotEmpty(PlateNum))
        {            
            whereClause+=' AND Plate_Number__c LIKE \'%'+String.escapeSingleQuotes(PlateNum)+'%\'';
        }
        if (String.isNotEmpty(engineNum))
        {            
            whereClause+=' AND Engine_Number__c LIKE \'%'+String.escapeSingleQuotes(engineNum)+'%\'';
        }
         if (String.isNotEmpty(ChassisNum))
        {            
            whereClause+=' AND Chassis_Number__c LIKE \'%'+String.escapeSingleQuotes(ChassisNum)+'%\'';
        }
       
        
        String queryString = 'SELECT id,Name,Renew_Status__c,Insurance_Policy_Number__c,Insurance_Current_Status__c,Vehicle__c,Vehicle__r.Name,Plate_Number__c,Engine_Number__c,Chassis_Number__c FROM ETIN_Insurance__c '+whereClause+queryLimit;
        system.debug(queryString);
        insuranceList.addAll((List<ETIN_Insurance__c>) Database.query(queryString));
        system.debug(insuranceList+'res.....');
        
        return insuranceList;
    } */
    @AuraEnabled    
    public static Id callBatchClsHealthRenewPrcs(string PartnerId,string Prcs){
        
        Id batchJobId = database.executeBatch(new ETIN_BulkHealthApprovalBatchCls(PartnerId,Prcs),1);        
        return batchJobId;
    }
    
     @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors,JobItemsProcessed,TotalJobItems FROM AsyncApexJob WHERE Id = :jobID];
        return jobInfo;
    }
    
    
  /*   @AuraEnabled    
    public static Id callVehicleBatchClsRenewPrcs(){
        //system.debug('vehicle class');
        
         Id batchJobId = database.executeBatch(new ETIN_BulkVehicleApprovalBatchCls(),1);        
        return batchJobId;
        
    }*/
     @AuraEnabled    
    public static string singleRecRenewPrcss(Id recID){
        
        ETIN_Insurance__c et = [ select Id,Employee_Family__c,Plan__c,Card_Number__c,RecordTypeId,Insurance_Policy_Number__c,Principal_Reference__c,Enrollment_Date__c,Insurance_Company__c,Insurance_Current_Status__c,Gross_Salary__c,EmployeeAcc__r.ETIN_Gross_Salary__c,Visa_Emirates__c,EmployeeAcc__c from ETIN_Insurance__c where Id=:recID];
        string msg='Error';
        string plan ='';
        
      /*  for (Insurance_Plans_Master__mdt plm :  [select id,DeveloperName,MasterLabel,Plans__c,Condition__c,Salary__c,Emirates__c from Insurance_Plans_Master__mdt]){
            if( plm.Emirates__c == et.Employee__r.ETIN_Visa_Emirates__c && et.Employee__r.ETIN_Gross_Salary__c <= plm.Salary__c  && plm.Condition__c == 'Less or Equal' ){
              
                   plan =   plm.Plans__c;                    
              }
             if( plm.Emirates__c == et.Employee__r.ETIN_Visa_Emirates__c && et.Employee__r.ETIN_Gross_Salary__c > plm.Salary__c  && plm.Condition__c == 'More' ){
              
                   plan =   plm.Plans__c;                    
              }
           }*/
         List<InsurancePlansMaster__c> masterPanelList = [select id,Name,Plans__c,Condition__c,Salary__c,Emirates__c from InsurancePlansMaster__c];
        for(InsurancePlansMaster__c plm : masterPanelList){
            
            if( plm.Emirates__c == et.Visa_Emirates__c && et.EmployeeAcc__r.ETIN_Gross_Salary__c <= plm.Salary__c  && plm.Condition__c == 'Less or Equal' ){
                
                plan =   plm.Plans__c;                    
            }
            if( plm.Emirates__c == et.Visa_Emirates__c && et.EmployeeAcc__r.ETIN_Gross_Salary__c > plm.Salary__c  && plm.Condition__c == 'More' ){
                
                plan =   plm.Plans__c;                    
            }
        }
        
        /* create new insurance record */
        ETIN_Insurance__c etNew = new ETIN_Insurance__c();
            
           etNew.Previous_Insurance__c = et.Id;
           
            etNew.EmployeeAcc__c = et.EmployeeAcc__c;
            etNew.Insurance_Company__c = et.Insurance_Company__c;
            etNew.Enrollment_Date__c = system.today();
            etNew.RecordTypeId = et.RecordTypeId;
            etNew.Plan__c = plan;
            etNew.Gross_Salary__c = et.Gross_Salary__c;
            etNew.Status__c = 'New';
            etNew.Member_Status__c ='Existing';
            etNew.Employee_Family__c = et.Employee_Family__c;
            //etNew.Member_Number__c = et.Card_Number__c;
            etNew.Principal_Reference__c = et.Principal_Reference__c;
            etNew.Old_Package_Name__c = et.Plan__c;
            etNew.Renew_Request__c = True;
        
            //etNew.Card_Number__c = et.Card_Number__c;
            //etNew.Insurance_Policy_Number__c = et.Insurance_Policy_Number__c;
        
               try{
            insert etNew; 
            
        }catch(Exception e){
            system.debug('Inseration Error:'+e);
             msg='Error';
        }
         
        if(etNew.Id != null){
            
            /* update old record as renewed */
            ETIN_Insurance__c etOld = new ETIN_Insurance__c();
            
            etOld.Id = recID;
            etOld.Renew_Status__c = true;
            
            update etOld;
            
             msg='Success';
        }        
        
        return msg;
    }
/*   
     @AuraEnabled    
    public static string singleRecVehRenewPrcss(Id recID){
        
        ETIN_Insurance__c et = [select id,RecordTypeId,Chassis_Number__c,Vehicle__c,Plate_Number__c,Engine_Number__c,Insurance_Company__c,Insurance_Current_Status__c from ETIN_Insurance__c where Id=:recID];
        string msg='Error';
               
     
        ETIN_Insurance__c etNew = new ETIN_Insurance__c();
            
           etNew.Previous_Insurance__c = et.Id;
            etNew.Insurance_Company__c = et.Insurance_Company__c;
            etNew.RecordTypeId = et.RecordTypeId;
            etNew.Vehicle__c = et.Vehicle__c;
            etNew.Status__c = 'New';
            etNew.Renew_Request__c = True;
            etNew.Chassis_Number__c = et.Chassis_Number__c;
            etNew.Engine_Number__c = et.Engine_Number__c;
            etNew.Plate_Number__c = et.Plate_Number__c;
        
       
        try{
            insert etNew; 
            
        }catch(Exception e){
            system.debug('Inseration Error:'+e);
        }
         
        if(etNew.Id != null){
            
          
            ETIN_Insurance__c etOld = new ETIN_Insurance__c();
            
            etOld.Id = recID;
            etOld.Renew_Status__c = True;
            
            update etOld;
            
             msg='Success';
        }        
        
        return msg;
    }  */
    
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
    public static list<ETIN_RenewalButton__c> getRenewalButtonSettings(){
        return ETIN_RenewalButton__c.getall().values();
    }
     
    
     @AuraEnabled
    public static string getInsMasterDetails(){
        
        return JSON.serialize([SELECT Id,Name,Condition__c,Emirates__c,Insurance_Company__c,Plans__c,Salary__c FROM InsurancePlansMaster__c]);
    }
    
    @AuraEnabled
    public static List<InsuranceDocumentMaster__c> getDocumentMasterDetails(String Emirate){
         system.debug('Emirate'+Emirate);
       
        return [select id,Name,Emirate__c,Label_Name__c,Formats__c,Mandatory__c from InsuranceDocumentMaster__c where Emirate__c=:Emirate AND Visibility__c=True] ;
       
    } 
    
    @AuraEnabled
    public static List<ETIN_InsuranceClaimDocs__c> getInsClaimDetails(){
        
        return [select id,Name,Accepted_Format__c,Mandatory__c,Label__c,Visibility__c from ETIN_InsuranceClaimDocs__c where Visibility__c=True] ; //  and Mandatory__c = True
     
    } 
   
     @AuraEnabled
    public static List <ETIN_DefaultInsurancePartners__c> getDefaultInsPartners() {
        return [SELECT Id,Name,Account_ID__c FROM ETIN_DefaultInsurancePartners__c order by Name];
        
    }  
     @AuraEnabled  
    public static List<ContentDocument> UpdateFiles(string documenList,string EmpId){  
       
        list<ContentDocument> updateList = new list<ContentDocument>();
      
        
        ContentDocument cd = [select id,title from ContentDocument where Id=:documenList]; // Getting files from Parent record 
        cd.Title = EmpId+'-'+cd.Title;  // Changing file Title with user entered title
        try{  
            update cd;  // Update ContentDocument (File)
        }  
        catch(DMLException e){  
            system.debug('Exception has occurred! ' +e.getMessage());  
        }  
       
       return null;
    } 
    
}