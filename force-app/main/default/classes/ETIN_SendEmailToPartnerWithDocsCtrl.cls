public class ETIN_SendEmailToPartnerWithDocsCtrl {
    
    @AuraEnabled    
    public static list<ETIN_Insurance__c> getInsuranceDetails(String Location) {
        
        
        Id HealthNewRecTyID = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('Health_Insurance').getRecordTypeId();
        //Id HealthNewRecTyID2 = Schema.SObjectType.ETIN_Insurance__c.getRecordTypeInfosByDeveloperName().get('ETIN_Health_Insurance_In_progress').getRecordTypeId();
        set<id> recTypeId = new set<id>();
        recTypeId.add(HealthNewRecTyID);
        
        
        String whereClause  ='WHERE RecordTypeid =:recTypeId AND Status__c=\'Under Process\' AND Send_to_Partner__c= false';//
        
        //Added by Arunsarathy 12.12.2022
        if (Location=='Dubai'){
            List<String> dubaiCondition = label.Insurance_DubaiSet.split(',');
            whereClause+= ' AND Visa_Emirates__c =:dubaiCondition ';            
        }
        else if (Location=='Abu Dhabi') {
            List<String> abuDhabiCondition = label.Insurance_AbuDhabiSet.split(',');
            whereClause+= ' AND Visa_Emirates__c =:abuDhabiCondition ';
        }
        String queryLimit =' ORDER BY Name LIMIT 100';
        
        list<ETIN_Insurance__c> insuranceList = new list<ETIN_Insurance__c>();
        
        String queryString = 'SELECT id,Marital_Status__c,Location__c,ETIN_Employee_Zone__c,Name,Plan__c,Employee_Family__c,Member_Name__c,ETIN_Gender__c,Effective_Date__c,Employee_ID__c,Expiry_Date__c,EmployeeAcc__r.FirstName,EmployeeAcc__r.ET_Emirates_Id__c,EmployeeAcc__r.LastName,EmployeeAcc__r.Name,EmployeeAcc__r.ETIN_Employee_Id__c,EmployeeAcc__r.PersonContact.Birthdate,Relation__c,Status__c,Renew_Status__c,Insurance_Current_Status__c,EmployeeAcc__c,Insurance_Policy_Number__c,Insurance_Company__c,Card_Number__c,CreatedBy.Name FROM ETIN_Insurance__c '+whereClause+queryLimit;
        insuranceList.addAll((List<ETIN_Insurance__c>) Database.query(queryString));
        // system.debug(insuranceList+'res.....');
        
        return insuranceList;
    }
    @AuraEnabled    
    public static list<string> getEmailDetails(String Location) {
        
        list<string> emails = new list<string>();
        if(string.isNotEmpty(Location)){
            ETIN_DefaultInsurancePartners__c de = [select Account_ID__c from ETIN_DefaultInsurancePartners__c where name=:Location];
            //system.debug(de.Account_ID__c+'de.Account_ID__c....');
            for(Contact con: [select id,email, HasOptedOutOfEmail from Contact where accountId=:de.Account_ID__c AND HasOptedOutOfEmail = false]){
                emails.add(con.email);
            }
        }
        
        return emails;
    }
    
    
    public class fieldWrapper{  
        @AuraEnabled public String name; 
        @AuraEnabled public String base64Data;        
        @AuraEnabled  public String contentType;        
        
    } 
    
    @AuraEnabled    
    public static string sendEmailWithDocs(string toAdd,string Subject,string Body,list<ETIN_Insurance__c> InsList,list<ContentVersion> extraDocs, string ApiStringRes,string HeaderLabelsRes,string fileUpload) { 
        
        List<Messaging.SingleEmailMessage> mailsList =  new List<Messaging.SingleEmailMessage>();
        List<Messaging.EmailFileAttachment> attachList = new List<Messaging.EmailFileAttachment>();
        List<ETIN_Insurance__c> updateList = new List<ETIN_Insurance__c>();
        set<id> selectedRowIds = new set<id>();
        set<id> conDocIds= new set<id>();
        list<string> toList = toAdd.split(',');
        
        /* file upload from upload file button */
        if(fileUpload.length() >0){
            List<fieldWrapper> datalist = (List<fieldWrapper>)JSON.deserialize(fileUpload, List<fieldWrapper>.class);
            
            if(datalist.size()>0)
                for(fieldWrapper fw: datalist){
                    Messaging.EmailFileAttachment objMsgEmailAttach = new Messaging.EmailFileAttachment();
                    
                    objMsgEmailAttach.setFileName(fw.name);
                    Blob content = Blob.valueOf(fw.base64Data);
                    objMsgEmailAttach.setBody(EncodingUtil.base64Decode(fw.base64Data));
                    objMsgEmailAttach.setContentType(fw.contentType);
                    attachList.add(objMsgEmailAttach);
                }
        }
        /* creating attachement from Report string */
        
        for(ETIN_Insurance__c et : InsList){
            selectedRowIds.add(et.Id);
        }
        //system.debug('---'+toAdd+'--'+Subject+'--'+Body+'--'+selectedRowIds);
        string apiString = String.join((List<string>)JSON.Deserialize(ApiStringRes,List<string>.class),',');
        string CsvFinalval = String.join((List<string>)JSON.Deserialize(HeaderLabelsRes,List<string>.class),',')+'\n';
        string queryStr = 'select '+apiString+' from ETIN_Insurance__c where id=:selectedRowIds limit 100';
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('ETIN_Insurance__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        Map<string,string> ApiVsType = new Map<string,string>();
        for (String fieldName: fieldMap.keySet()) {
            
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            String fieldLabel = fieldName;
            ApiVsType.put(fieldLabel,String.valueof(fielddataType));
        }
        
        //system.debug('--csv-'+CsvFinalval);
        //system.debug('--api-'+queryStr);
        list<string> ApiList = apiString.split(',');
        
        for(ETIN_Insurance__c et : Database.query(queryStr)){
            
            
            string[] stringList = new string[0];
            
            for(string s : ApiList){
                string strVal ='';
                
                if(ApiVsType.get(s.toLowerCase()) == 'DATE'){
                    if(et.get(s) != null){
                        date myDate  = Date.valueOf(et.get(s));
                        strVal = myDate.format();
                    }                                           
                    
                }else{
                    strVal = string.valueOf(et.get(s));
                    
                }
                
                
                stringList.add(strVal);
            }
            String result = String.join(stringList, ', ');
            CsvFinalval +=result+'\n';
            
        } 
        
        if(!test.isRunningTest())
            if(CsvFinalval != null){
                Messaging.EmailFileAttachment objMsgEmailAttach = new Messaging.EmailFileAttachment();
                objMsgEmailAttach.setFileName('NewAdditonReport.csv');
                Blob content = Blob.valueOf('\uFEFF'+CsvFinalval);
                objMsgEmailAttach.setBody(content);
                objMsgEmailAttach.setContentType('application/vnd.ms-excel;charset=utf-8');//text/csv;charset=utf-8
                attachList.add(objMsgEmailAttach);
            } 
        
        
        for (ContentDocumentLink docLinks : [Select Id,ContentDocumentId  from ContentDocumentLink where LinkedEntityId = :selectedRowIds ]){
            conDocIds.add(docLinks.ContentDocumentId);
        } 
        
        if(extraDocs != null) {
            
            for(ContentVersion cv : extraDocs){
                conDocIds.add(cv.ContentDocumentId);
            }
        }
        
        /* creating attachement from record attached files*/        
        for(ContentVersion cv: [SELECT ContentDocumentId,VersionData,FileExtension,FileType,Id,Title FROM ContentVersion where ContentDocumentId=:conDocIds]){
            
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(cv.Title+'.'+cv.FileType); //Title of the PDF
            efa.setBody(cv.VersionData); //Body of the PDF,need to do transfer into blob
            //efa.setContentType('.'+cv.FileExtension);
            attachList.add(efa);
            
        }  
        
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(attachList!= null && attachList.size()>0 ) {
            mail.setFileAttachments(attachList);
        }       
        Id orgwideId = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where Address='etcares@et.ae'].Id;       
        mail.setSubject(Subject);
        mail.setOrgWideEmailAddressId(orgwideId); 
        mail.setReplyTo(userinfo.getUserEmail());
        mail.setHtmlBody(Body);
        mail.setToAddresses(toList);
        mail.setBccAddresses(new string[]{UserInfo.getUserEmail()});
        
        for(ETIN_Insurance__c et : InsList){
            
            et.Send_to_Partner__c = true;
            et.Sent_to_Partner_Date__c = system.now();
            
        }
        
        try {
            Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
            
            update InsList;
            
        }catch (Exception e) {
            system.debug('--Error--'+e.getMessage());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());  
            
        }
        
        return 'success';
    }
    
    
    
    @AuraEnabled    
    public static list<ContentVersion> getInsLibraryFiles(){
        
        set<id> contDocIds = new  set<id>();
        ContentWorkspace cw =  [SELECT Id,Name, RootContentFolderId FROM ContentWorkspace where name='Insurance Documents' limit 1];
        for(ContentDocumentLink cdl : [SELECT Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId=:cw.Id]){
            
            contDocIds.add(cdl.ContentDocumentId);
        } 
        
        list<ContentVersion> cvList = [SELECT ContentDocumentId,VersionData,FileExtension,FileType,Id,Title FROM ContentVersion where ContentDocumentId=:contDocIds];
        
        return cvList;
        
    }
    @AuraEnabled
    public static String getreportDetails(string Location){
        
        //system.debug('Report Id-----'+ReportId);
        ETIN_DefaultInsurancePartners__c de = [select Account_ID__c,ReportTypeID__c from ETIN_DefaultInsurancePartners__c where name=:Location];
        
        try {
            Report reportRec = [SELECT Id FROM Report WHERE Id =:de.ReportTypeID__c];
            
            Reports.ReportResults reportResult =Reports.ReportManager.runReport(reportRec.Id, true);
            
            return JSON.serialize(reportResult);
        }
        catch (Exception e) {
            
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
        }
    }
    
    @AuraEnabled 
    public static user currentUserDetailMethod(){    
      User currentUserObj = [select id,Name,FirstName,account.id, LastName,Username,Email, Profile.Name,UserRole.Name From User Where Id=:userInfo.getUserId()];
        system.debug('cc'+currentUserObj);
        return currentUserObj;
    }
}