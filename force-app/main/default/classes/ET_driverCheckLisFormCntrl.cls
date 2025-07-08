/************************************************************************************************************************
 * Name               : ET_driverCheckLisFormCntrl                                                                      *
 * Test Class		  : ET_driverCheckLisFormCntrlTest                                                                  *
 * Description        : Apex Class for Driver Checklsit Application                                                     *
 * Created Date       : 02/Feb/2024                                                                                     *
 * Created By         : Taj Shaik(SMAARTT)                                                                              *
 * -----------------------------------------------------------------------------------------------                      *
 * VERSION   AUTHOR      DATE                COMMENTS                                                                   *
 * 1.0       Taj Shaik   02/Feb/2024         Initial Draft.                                                             *
 ***********************************************************************************************************************/
public Without Sharing class ET_driverCheckLisFormCntrl {
    
    @AuraEnabled
    public static List<DriverChecklistWrapper> getDriverChecklistsMdt(String queryDriver) {
        List<DriverChecklistWrapper> DriverChecklistWrpList = New List<DriverChecklistWrapper>();
        List<DriverChecklistMaster__mdt> checklistRecords = New List<DriverChecklistMaster__mdt>();
        Map<String,Decimal> srNoCount = New Map<String,Decimal>();
        Map<String,Decimal> categoryCount = New Map<String,Decimal>();
        if(queryDriver != null && queryDriver != ''){
            checklistRecords = Database.query(queryDriver);
            System.debug('checklists MDT: '+checklistRecords);
        }
        for(DriverChecklistMaster__mdt mdt: checklistRecords){
            if(!srNoCount.containsKey(String.valueOf(mdt.Number__c)))
                srNoCount.put(String.valueOf(mdt.Number__c),1);
            else
                if(srNoCount.containsKey(String.valueOf(mdt.Number__c)))
                srNoCount.put(String.valueOf(mdt.Number__c),srNoCount.get(String.valueOf(mdt.Number__c))+1);
            
            if(!categoryCount.containsKey(mdt.Category_En__c))
                categoryCount.put(mdt.Category_En__c,1);
            else
                if(categoryCount.containsKey(mdt.Category_En__c))
                categoryCount.put(mdt.Category_En__c,categoryCount.get(mdt.Category_En__c)+1);
        }
        System.debug('srNoCount: '+srNoCount);
        System.debug('categoryCount: '+categoryCount);
        for(DriverChecklistMaster__mdt mdt: checklistRecords){
            DriverChecklistWrapper DriverChecklistWrp = New DriverChecklistWrapper();
            DriverChecklistWrp.srNo = mdt.Number__c;
            DriverChecklistWrp.Seq = mdt.Sequence__c;
            DriverChecklistWrp.optionType = mdt.Type__c; 
            if(mdt.Type__c == 'Comment')
                DriverChecklistWrp.commentReq = false;
            DriverChecklistWrp.srNoShow = mdt.Show_Number__c;
            if(srNoCount.containsKey(String.valueOf(mdt.Number__c)))
                DriverChecklistWrp.srNoCount = srNoCount.get(String.valueOf(mdt.Number__c));
            DriverChecklistWrp.category.ar = mdt.Category_Ar__c;
            DriverChecklistWrp.category.en = mdt.Category_En__c;
            DriverChecklistWrp.category.ur = mdt.Category_UR__c;
            DriverChecklistWrp.categoryShow = mdt.Show_Category__c;
            if(categoryCount.containsKey(mdt.Category_En__c))
                DriverChecklistWrp.categoryCount = categoryCount.get(mdt.Category_En__c);
            DriverChecklistWrp.checkPoint.ar = mdt.Question_Ar__c;
            DriverChecklistWrp.checkPoint.en = mdt.Question_En__c;
            DriverChecklistWrp.checkPoint.ur = mdt.Question_UR__c;
            DriverChecklistWrp.severity.ar = mdt.Severity_Ar__c;
            DriverChecklistWrpList.add(DriverChecklistWrp);
        }
        return DriverChecklistWrpList;
    }
    
    @AuraEnabled    
    public static Id getDriverCheckListRecord(String status){
        Driver_Daily_Check_List__c driver = New Driver_Daily_Check_List__c();
        if(status != null && status != ''){
            driver.Status__c = 'Draft';
            Insert driver;
        }
        return driver.Id;
    }
    
    @AuraEnabled    
    public static Boolean saveDriverCheckListLines(Id checklistRecId, String driverChecklistWrpListStr){
        System.debug('checklistRecId: '+checklistRecId);
        System.debug('driverChecklistWrpListStr: '+driverChecklistWrpListStr);
        Boolean isSuccess = false;
        List<DriverChecklistWrapper> DriverChecklistWrpList = (List<DriverChecklistWrapper>) System.JSON.deserialize(driverChecklistWrpListStr, List<DriverChecklistWrapper>.class);
        List<Driver_Check_List_Line__c> linesList = New List<Driver_Check_List_Line__c>();
        if(checklistRecId != null && DriverChecklistWrpList.Size()>0 ){
            for(DriverChecklistWrapper wrp: driverChecklistWrpList){
                Driver_Check_List_Line__c line = New Driver_Check_List_Line__c();
                line.Driver_Check_List__c = checklistRecId;
                line.Question_Ar__c = wrp.checkPoint.Ar;
                line.Question_En__c = wrp.checkPoint.En;
                line.Question_Ur__c = wrp.checkPoint.Ur;
                line.Category_Ar__c = wrp.category.Ar;
                line.Category_En__c = wrp.category.En;
                line.Category_Ur__c = wrp.category.Ur;
                line.Severity_Ar__c = wrp.severity.Ar;
                line.Show_Number__c = wrp.srNoShow;
                line.Show_Category__c = wrp.categoryShow;
                line.Sequence__c = wrp.seq;
                line.Number__c = wrp.srNo;
                line.Response__c = wrp.response;
                linesList.add(line);
            }
        }
        if(linesList.Size()>0){
            Insert linesList;
            isSuccess = true;
        }
        return isSuccess;
    }
    
    @AuraEnabled
    public static Boolean deleteChecklist(String checklistRecId) {
        Boolean isDeleted = false;
        List<Driver_Daily_Check_List__c> cheklistToDelete = new List<Driver_Daily_Check_List__c>();
        if(checklistRecId != null && checklistRecId != ''){
            cheklistToDelete = [SELECT Id FROM Driver_Daily_Check_List__c WHERE Id =: checklistRecId AND Status__c = 'Draft'];
        }
        If(cheklistToDelete.Size()>0){
            Delete cheklistToDelete;
            isDeleted = true;
        }
        return isDeleted;
    }
    
    @AuraEnabled
    public static List<SObject> fetchRecords(String query) {
        System.debug('query: '+query);
        try {
            List<SObject> recordsDataList = new List<SObject>();
            for(SObject s : Database.query(query)) {
                recordsDataList.add(s);
            }
            System.debug('recordsDataList: '+recordsDataList);
            return recordsDataList;
        } catch (Exception err) {
            System.debug('err: '+err.getMessage());
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }
    
    public class DriverChecklistSectionWrapper {
        @AuraEnabled public List<DriverChecklistWrapper> DriverChecklistWrp { get; set; }
        public DriverChecklistSectionWrapper() {
            this.DriverChecklistWrp = New List<DriverChecklistWrapper>();
        }
    }
    
    public class DriverChecklistWrapper {
        @AuraEnabled public Decimal seq { get; set; }
        @AuraEnabled public Decimal srNo { get; set; }
        @AuraEnabled public String iconSelectedAction { get; set; }
        @AuraEnabled public String response { get; set; }
        @AuraEnabled public Boolean commentReq { get; set; }
        @AuraEnabled public String optionType { get; set; }
        @AuraEnabled public Decimal srNoCount { get; set; }
        @AuraEnabled public Boolean srNoShow { get; set; }
        @AuraEnabled public LangWrapper category { get; set; }
        @AuraEnabled public Decimal categoryCount { get; set; }
        @AuraEnabled public Boolean categoryShow { get; set; }
        @AuraEnabled public LangWrapper checkPoint { get; set; }
        @AuraEnabled public LangWrapper severity { get; set; }
        @AuraEnabled public Boolean isDisabled { get; set; }
        public DriverChecklistWrapper() {
            this.category = New LangWrapper();
            this.checkPoint = New LangWrapper();
            this.severity = New LangWrapper();
            this.iconSelectedAction ='';
            this.isDisabled = false;
        }
    }
    
    public class LangWrapper {
        @AuraEnabled public String ar { get; set; }
        @AuraEnabled public String en { get; set; }
        @AuraEnabled public String ur { get; set; }
    }
    
    @AuraEnabled 
    public static string addFilesToRecords(String recordId , String fileData){
        List<ContentVersion> lstContentVesions = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLinks = new  List<ContentDocumentLink>();
        list<uploadedDocs> files;  
        files = (List<uploadedDocs>)JSON.deserialize(fileData,  List<uploadedDocs>.Class);
        if(files.size()>0){            
            for(uploadedDocs doc :files){
                ContentVersion objContentVersion = new ContentVersion();
                objContentVersion.ContentLocation = 'S';
                /*String body = doc.base64;               
                String base64Mark = 'base64,';
                integer dataStart = body.indexOf(base64Mark) + base64Mark.length();
                body = body.substring(dataStart);*/
                //system.debug('body = '+ body);
                objContentVersion.VersionData = EncodingUtil.base64Decode(doc.base64);//EncodingUtil.base64Decode(body);
                objContentVersion.Title = doc.filename;
                objContentVersion.Origin = 'H';
                objContentVersion.PathOnClient = '/' + doc.filename;
                lstContentVesions.add(objContentVersion);
            }
        }
        if(lstContentVesions!=null && lstContentVesions.size()>0){
            try{
                insert lstContentVesions;   
                system.debug('******After lstContentVesions****'+lstContentVesions);
            }Catch(Exception ex){
                system.debug('***Exception Cause lstContentVesions*****'+ex.getMessage());
                system.debug('***Exception Cause getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception happend'+ex.getMessage());                                       
            }
            
        }
        map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
        for(ContentVersion objContentVersion :[Select Id,ContentDocumentId from ContentVersion where Id in :lstContentVesions]){
            mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
        }
        for(ContentVersion objContentVersion :lstContentVesions){
            
            if(mapofContentVersionIdwithContentDocumentIds.containskey(objContentVersion.Id)){
                ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                objContentDocumentLink.LinkedEntityId = recordId;
                objContentDocumentLink.ShareType = 'V';
                objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id);
                lstContentDocumentLinks.add(objContentDocumentLink);
            }
            
        }
        system.debug('******lstContentDocumentLinks****'+lstContentDocumentLinks);
        if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
            try{
                insert lstContentDocumentLinks; 
                return 'Success';
            }Catch(Exception ex){
                system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
                system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
            }
        }else{
            return 'Error';
        }
    }
    
    public class uploadedDocs{
        @AuraEnabled
        Public String filename;
        @AuraEnabled
        Public String filetype;
        @AuraEnabled
        Public String base64;
    }
    //This Method Retrun UploadedFiles
    @AuraEnabled 
    public static List<ContentDocument> getUploadedDriverFiles(string driverID){        
        Set<Id> recordIds=new Set<Id>{driverID};
            Set<Id> documentIds = new Set<Id>(); 
        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        return [SELECT Id, Title, FileType, OwnerId, Owner.Name, CreatedDate,
                CreatedById, CreatedBy.Name, ContentSize FROM ContentDocument WHERE id IN: documentIds];  
    } 
    @AuraEnabled  
    public static void deleteFiles(string sdocumentId){ 
        delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:sdocumentId];       
    }  
}