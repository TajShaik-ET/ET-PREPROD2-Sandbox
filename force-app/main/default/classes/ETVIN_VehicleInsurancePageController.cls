public with sharing class ETVIN_VehicleInsurancePageController {
    
     
     @AuraEnabled    
    public static list<ETVIN_Vehicle_Insurance__c> getInsuranceDetails(String policyNumber,String plateNumber,String chassisNumber,String engineNumber,String vehicleModel,String InsPartner) {
      
        try{
            String whereClause  ='where Name != null AND';
            String queryLimit =' ORDER BY Name DESC LIMIT 500';
            
            list<ETVIN_Vehicle_Insurance__c> insuranceList = new list<ETVIN_Vehicle_Insurance__c>();
            
            //system.debug(policyNumber+'pol');
            if (String.isNotEmpty(policyNumber))
            {            
                whereClause+=' ETVIN_Insurance_Policy_Number__r.Name LIKE \'%'+String.escapeSingleQuotes(policyNumber)+'%\' AND';
            }
            if (String.isNotEmpty(plateNumber))
            {            
                whereClause+=' Vehicle__r.Plate_Number__c LIKE \'%'+String.escapeSingleQuotes(plateNumber)+'%\' AND';
            }
            if (String.isNotEmpty(chassisNumber))
            {            
                whereClause+=' Vehicle__r.Chassis_No__c LIKE \'%'+String.escapeSingleQuotes(chassisNumber)+'%\' AND';
            }
          /*  if (String.isNotEmpty(engineNumber))
            {            
                whereClause+=' ETVIN_Vehicle__r.ETVIN_Engine_Number__c LIKE \'%'+String.escapeSingleQuotes(engineNumber)+'%\' AND';
            }*/
            if (String.isNotEmpty(vehicleModel))
            {            
                whereClause+=' Vehicle__r.Internal_No__c LIKE \'%'+String.escapeSingleQuotes(vehicleModel)+'%\' AND';
            }
            if (String.isNotEmpty(InsPartner))
            {            
                whereClause+=' ETVIN_Insurance_Company__c=:InsPartner AND';
            }
            
            whereClause = whereClause.removeEnd('AND');
             
            
            String queryString = 'SELECT id,Name,ETVIN_Is_Renewed__c,Vehicle__c,ETVIN_Insurance_Company__c,ETVIN_Insurance_Status__c,ETVIN_Enrollment_Date__c,ETVIN_Expiry_Date__c,Vehicle__r.Chassis_No__c,ETVIN_Insurance_Policy_Number__r.Name,Vehicle__r.Plate_Number__c, Vehicle__r.Internal_No__c FROM ETVIN_Vehicle_Insurance__c '+whereClause+queryLimit;
           // system.debug(queryString);
            insuranceList.addAll((List<ETVIN_Vehicle_Insurance__c>) Database.query(queryString));
            //system.debug(insuranceList+'res.....');
            
            return insuranceList;
        }
        catch(Exception e){
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());  
        }
       
    
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
    
  /*  
    @AuraEnabled    
    public static list<contact> getEmployeeDetails(String EmpID,String firstName,String lastName,String Dept) { 
        
        Id empRecTypeId = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('ET_Employees').getRecordTypeId();
        Id empRecTypeId2 = Schema.SObjectType.contact.getRecordTypeInfosByDeveloperName().get('ETIN_Employee_Family').getRecordTypeId();
        Set<Id> recTypesIds = new Set<Id>();
        recTypesIds.add(empRecTypeId);
        recTypesIds.add(empRecTypeId2);
        
        String whereClause  ='WHERE RecordTypeid =:recTypesIds';
        String queryLimit =' LIMIT 3';
        list<Contact> empList = new list<Contact>(); 
        
         if (String.isNotEmpty(EmpID))
        {            
            whereClause+=' AND ETIN_Employee_ID__c LIKE \'%'+String.escapeSingleQuotes(EmpID)+'%\'';
        }
        if (String.isNotEmpty(firstName))
        {            
            whereClause+=' AND FirstName LIKE \'%'+String.escapeSingleQuotes(firstName)+'%\'';
        }
        if (String.isNotEmpty(lastName))
        {            
            whereClause+=' AND LastName LIKE \'%'+String.escapeSingleQuotes(lastName)+'%\'';
        }
        if (String.isNotEmpty(Dept))
        {            
            whereClause+=' AND ETIN_Department__c LIKE \'%'+String.escapeSingleQuotes(Dept)+'%\'';
        }
        
        String queryString = 'SELECT id,FirstName,LastName,Name,ETIN_Employee__r.ETIN_Insurance_Card_Number__c,ETIN_Employee_ID__c,ETIN_Relation__c,ETIN_Visa_Emirates__c,ETIN_Department__c,ETIN_Work_Emirates__c,ETIN_DOB__c,ETIN_Gender__c,ETIN_Salary_Band__c,ETIN_Gross_Salary__c,recordType.name FROM contact '+whereClause+queryLimit;
        
        system.debug('Emp Query'+queryString);
        
        empList.addAll((List<contact>) Database.query(queryString));
        
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
*/

     @AuraEnabled
    public static void deleteAttachment(String contentDocId) { 
        
        ContentDocument deleteContent = new ContentDocument(Id=contentDocId);
    
        try {
            delete deleteContent;
        }
        catch (Exception e) {
            
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
        }
    } 
    
    @AuraEnabled
    public static List<String> getselectOptions(string objObject, string fld) { 
      
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
 /*   @AuraEnabled    
    public static Id callBatchClsVehicleRenewPrcs(string PartnerId,string Prcs){
        
        Id batchJobId = database.executeBatch(new ETVIN_BulkVehicleRenewBatchCls(PartnerId,Prcs),1);        
        return batchJobId;
    }
    
     @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors,JobItemsProcessed,TotalJobItems FROM AsyncApexJob WHERE Id = :jobID];
        return jobInfo;
    }
    */
    
  /*   @AuraEnabled    
    public static Id callVehicleBatchClsRenewPrcs(){
        //system.debug('vehicle class');
        
         Id batchJobId = database.executeBatch(new ETIN_BulkVehicleApprovalBatchCls(),1);        
        return batchJobId;
        
    }*/
 /*   @AuraEnabled    
    public static string singleRecRenewPrcss(Id recID,Id PartnerId,string Prcs){
        
        ETVIN_Vehicle_Insurance__c et = [select id,Name,ETVIN_Insurance_Company__c,Vehicle__c,ETVIN_Insurance_Policy_Number__c,ETVIN_Accessories_Insurance_Value__c,ETVIN_Accident_Endorsement_Value__c,ETVIN_Contract_Number__c,ETVIN_Driver_Insurance_Value__c,ETVIN_Insurance_Rate_Based_on_Contract__c,ETVIN_Passenger_Insurance_Value__c,ETVIN_Vehicle_Insurance_Value__c from ETVIN_Vehicle_Insurance__c where ETVIN_Renew_Request__c = false AND ETVIN_Insurance_Status__c='Active' AND Id=:recID]; 
               
        string msg='Error';
        
         ETVIN_Vehicle_Insurance__c eviNew = new ETVIN_Vehicle_Insurance__c();
            
             if(Prcs =='new'){
                 eviNew.ETVIN_Insurance_Company__c = PartnerId;
            }else {
                 eviNew.ETVIN_Insurance_Company__c = et.ETVIN_Insurance_Company__c;
            }
            eviNew.Vehicle__c = et.Vehicle__c;
            eviNew.ETVIN_Enrollment_Date__c = system.today();
            eviNew.ETVIN_Insurance_Status__c = 'Inactive';
            eviNew.ETVIN_Renew_Request__c = true;
            eviNew.ETVIN_Insurance_Policy_Number__c = et.ETVIN_Insurance_Policy_Number__c;
            eviNew.ETVIN_Parent_Vehicle_Insurance__c = et.Id;
            eviNew.ETVIN_Accessories_Insurance_Value__c= et.ETVIN_Accessories_Insurance_Value__c;
            eviNew.ETVIN_Accident_Endorsement_Value__c = et.ETVIN_Accident_Endorsement_Value__c;
            eviNew.ETVIN_Contract_Number__c= et.ETVIN_Contract_Number__c;
            eviNew.ETVIN_Driver_Insurance_Value__c = et.ETVIN_Driver_Insurance_Value__c;
            eviNew.ETVIN_Insurance_Rate_Based_on_Contract__c = et.ETVIN_Insurance_Rate_Based_on_Contract__c;
            eviNew.ETVIN_Passenger_Insurance_Value__c= et.ETVIN_Passenger_Insurance_Value__c;
            eviNew.ETVIN_Vehicle_Insurance_Value__c= et.ETVIN_Vehicle_Insurance_Value__c;
         
     
        try{
            insert eviNew; 
            
        }catch(Exception e){
            system.debug('Inseration Error:'+e);
            msg='Error';
        }
        // update old record as renewe
        if(eviNew.Id != null){
           ETVIN_Vehicle_Insurance__c etUpdate = new ETVIN_Vehicle_Insurance__c();
            etUpdate.Id = recID;
            etUpdate.ETVIN_Is_Renewed__c = true;
            update etUpdate;
            
                      
            msg='Success';
        }        
        
        return msg; 
            
     } */
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
               return [select id,name from account where Type='Insurance Partner'];
             }
            catch (Exception e) {
                
                throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
            }
        
    }

     @AuraEnabled
    public static ETIN_RenewalButton__c getRenewalButtonSettings(){
        return ETIN_RenewalButton__c.getValues('Renewal_Button');
    }
    
     @AuraEnabled
    public static string getInsMasterDetails(){
        
        return JSON.serialize([SELECT Id,Name,Condition__c,Emirates__c,Insurance_Company__c,Plans__c,Salary__c FROM InsurancePlansMaster__c]);
    }
    
    @AuraEnabled
    public static List<InsuranceDocumentMaster__c> getDocumentMasterDetails(String Emirate){
        
        return [select id,Name,Emirate__c,Label_Name__c,Formats__c from InsuranceDocumentMaster__c where Emirate__c=:Emirate AND Visibility__c=True] ;
       // return [select id,DeveloperName,MasterLabel,Label_Name__c,Formats__c from Insurance_Documents_Master__mdt where MasterLabel=:Emirate AND Visibility__c=True] ;
    } 
    
   
     @AuraEnabled
    public static List <ETIN_DefaultInsurancePartners__c> getDefaultInsPartners() {
        return [SELECT Id,Name,Account_ID__c FROM ETIN_DefaultInsurancePartners__c order by Name];
        
    }  
    
    @AuraEnabled
    public static List<VehicleInsuranceClaimDocs__c> getInsClaimDetails(){
        
        return [select id,Name,Accepted_Format__c,Label__c,Visibility__c from VehicleInsuranceClaimDocs__c where Visibility__c=True] ;
     
    } 
    
     @AuraEnabled 
    public static user fetchUser(){
        
        User oUser = [select id,Name,Username,UserRole.Name FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    @AuraEnabled
    public static string insertData(String strfromle){
        
        String returnresponse ='';
        set<string> vehIds = new set<string>();
        map<string,string> VehNumbervsVehId = new map<string,string>();
        List<Correction_Cancel_Request__c> newCancellationList = new List<Correction_Cancel_Request__c>();
        system.debug('strfromle = ' + strfromle);
        List<fieldWrapper> datalist = (List<fieldWrapper>)JSON.deserialize(strfromle, List<fieldWrapper>.class);
        system.debug('datalist = ' + datalist);
        //system.debug('datalistSize = ' + datalist.size());
        list<Veh_Default_Insurance_partner__c> vehDeflist=  [select id,Account_ID__c from Veh_Default_Insurance_partner__c];
        for(fieldWrapper wrapper: datalist){
            
            vehIds.add(wrapper.VehicleInternalNumber);
        }
        if(vehIds.size()>0){
            
            
            for(Vehicle_Master__c ve : [select id,Name from Vehicle_Master__c where Name =:vehIds limit 50000]){
                VehNumbervsVehId.put(ve.Name,ve.Id);
            }
            
        }
         Id CancellationRecType = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosByDeveloperName().get('Cancellation_Request').getRecordTypeId();
        
        for(fieldWrapper wrapper: datalist){
            
            
            Correction_Cancel_Request__c can =new  Correction_Cancel_Request__c();
             
             can.RecordTypeId = CancellationRecType;
             can.Insured_Value__c = wrapper.InsuredValue;
             can.Refund_Amount__c = wrapper.RefundPremium;
             can.Refund_VAT__c = wrapper.RefundVAT;
             can.Total_Refund__c = wrapper.TotalAmount;
             can.Insurance_Company__c = vehDeflist[0].Account_ID__c;
            
            if(VehNumbervsVehId.containsKey(wrapper.VehicleInternalNumber)){
                can.Vehicle_Master__c = VehNumbervsVehId.get(wrapper.VehicleInternalNumber);
            }
            
            newCancellationList.add(can);            
        }
        
        if(newCancellationList.size() > 0){
            try {
                insert newCancellationList;
                returnresponse = 'SUCCESS';
            }
            catch(Exception ex){
                returnresponse = 'ERROR';
                system.debug('-err-'+ex);
                throw new AuraHandledException('Error-- '+ ex.getMessage());  
            }
        }
        return returnresponse;
      
    }
    
    public class fieldWrapper{  
        public String VehicleInternalNumber; 
        public decimal InsuredValue;  
        public decimal RefundPremium;
        public decimal RefundVAT;
        public decimal TotalAmount;
        
    }
    
    @AuraEnabled
    public static string insertDataRenewal(String strfromle){
        
        system.debug('--'+strfromle);
         String returnresponse ='';
        set<string> vehIds = new set<string>();
        set<string> policyNumbers = new set<string>();
        map<string,string> policyNumbervsId = new map<string,string>();        
        map<string,string> VehNumbervsInsId = new map<string,string>();
        list<ETVIN_Vehicle_Insurance__c> newInsertList = new list<ETVIN_Vehicle_Insurance__c>();
         List<RenewalfieldWrapper> datalist = (List<RenewalfieldWrapper>)JSON.deserialize(strfromle, List<RenewalfieldWrapper>.class);
         list<Veh_Default_Insurance_partner__c> vehDeflist=  [select id,Account_ID__c from Veh_Default_Insurance_partner__c];
         
        for(RenewalfieldWrapper wrapper: datalist){
            
            vehIds.add(wrapper.VehicleInternalNumber);
            policyNumbers.add(wrapper.InsurancePolicyNumber);
        }
        if(vehIds.size()>0){
            
            
            for(Vehicle_Master__c ve : [select id,Name from Vehicle_Master__c where Name =:vehIds limit 50000]){
                VehNumbervsInsId.put(ve.Name,ve.Id);
            }
            
        }
        for(ETVIN_Insurance_Policy_Numbers__c pol :[select id,Name from ETVIN_Insurance_Policy_Numbers__c where name=:policyNumbers]){
            policyNumbervsId.put(pol.Name,pol.Id);
          }
        for(RenewalfieldWrapper wrapper: datalist){
           
             
             if(VehNumbervsInsId.containsKey(wrapper.VehicleInternalNumber)){
                 
                ETVIN_Vehicle_Insurance__c ev = new ETVIN_Vehicle_Insurance__c();
                 
                  ev.Vehicle__c = VehNumbervsInsId.get(wrapper.VehicleInternalNumber);
                  ev.ETVIN_Insurance_Company__c = vehDeflist[0].Account_ID__c;
                  ev.ETVIN_Insurance_Policy_Number__c = policyNumbervsId.get(wrapper.InsurancePolicyNumber);
                  //ev.ETVIN_TCF_No__c = wrapper.TCFNo;
                  ev.ETVIN_Vehicle_Insurance_Value__c = wrapper.InsuredValue;
                  ev.ETVIN_Enrollment_Date__c = date.valueOf(wrapper.EffectiveDate);
                  ev.ETVIN_Expiry_Date__c = date.valueOf(wrapper.ExpiryDate);
                  ev.Premium_Expense__c = wrapper.PremiumExpense;
                  ev.Insurance_Premium_With_Vat__c = wrapper.InsurancePremiumWithVAT;
                  ev.ETVIN_Renew_Request__c = true;
                 
                 newInsertList.add(ev);
             }
            
        }
        
        if(newInsertList.size() > 0){
            try {
                insert newInsertList;
                returnresponse = 'SUCCESS';
            }
            catch(Exception ex){
                returnresponse = 'ERROR';
                system.debug('-err-'+ex);
                throw new AuraHandledException('Error-- '+ ex.getMessage());  
            }
        }
        return returnresponse;
        
    }
    
     public class RenewalfieldWrapper{  
        public String VehicleInternalNumber; 
        public String InsurancePolicyNumber;
        public decimal InsuredValue;  
       // public decimal TCFNo;
        public string EffectiveDate;
        public string ExpiryDate;
        public decimal PremiumExpense;
        public decimal InsurancePremiumWithVAT;
        
    }
		
   
    
}