public without sharing  class ETVIN_ShowVehicleInsuranceCtrl {
    
    @AuraEnabled
    public static List<ETVIN_Vehicle_Insurance__c> getInsurancePoliciyDetails(){
        List<ETVIN_Vehicle_Insurance__c> insuranceList = new List<ETVIN_Vehicle_Insurance__c>();
        id userId = UserInfo.getUserId();
        List<User> userlist = [SELECT id, contact.AccountID FROM User WHERE id = :userId];
        id accountid = userlist[0].contact.AccountID;
        for(ETVIN_Vehicle_Insurance__c vehIns : [SELECT id , Name,ETVIN_Chassis_Number__c,ETVIN_Internal_Number__c,Vehicle__r.Plate_Number__c,ETVIN_Enrollment_Date__c FROM ETVIN_Vehicle_Insurance__c WHERE ETVIN_Insurance_Company__c = :accountid AND ETVIN_Request_Status__c = 'Insurance Pending' order by Name]){
            insuranceList.add(vehIns);
        }
        return insuranceList;
    }
    @AuraEnabled
    public static id updateStatus(String recordId, String status, ETIN_Insurance_Transactions__c InsuranceTransactions){
      List<ETVIN_Vehicle_Insurance__c> vehIns = [SELECT Vehicle__c, ETVIN_Insurance_Status__c, ETVIN_Request_Status__c FROM ETVIN_Vehicle_Insurance__c WHERE id = :recordId];
        if(status == 'Approved' && vehIns.size() > 0) {
            vehIns[0].ETVIN_Insurance_Status__c = 'Active';
            vehIns[0].ETVIN_Request_Status__c  = 'Insurance Approved';
           // InsuranceTransactions.Vehicle_Master__c = vehIns[0].Vehicle__c;
            //InsuranceTransactions.Vehicle_Insurance_Policy__c = vehIns[0].Id;
            //insert InsuranceTransactions;
        }else if(vehIns.size() > 0){
            //InsuranceTransactions = new ETIN_Insurance_Transactions__c();
            //vehIns[0].ETVIN_Request_Status__c  = 'Insurance Rejected';
        }
       
        update vehIns;
        //return InsuranceTransactions.id;
        return null;
    }
    
       @AuraEnabled
    public static String updateInsurancePoliciy(String recordId){
        if(recordId != null){
            ETVIN_Vehicle_Insurance__c vehIns = [SELECT ETVIN_Request_Status__c
                                                 FROM ETVIN_Vehicle_Insurance__c
                                                 WHERE id = :recordId];
            if(vehIns.ETVIN_Request_Status__c == 'Insurance Pending' || vehIns.ETVIN_Request_Status__c == 'Insurance Rejected' || vehIns.ETVIN_Request_Status__c == 'Insurance Approved'){
                
                 return 'notUpdate';
            }else{
                vehIns.ETVIN_Request_Status__c = 'Insurance Pending';
                update vehIns;
                return 'update';
            }
          
        }
        return '';
    }
    @AuraEnabled
    public static List<String> getPicklistValues(String objectName, String fieldName){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
     @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
 
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        //Attachment attach = [SELECT Id, Name, Body, ContentType, ParentId From Attachment LIMIT 1];
        
        //Insert ContentVersion
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient = fileName;//File name with extention
        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        //cVersion.OwnerId = attach.OwnerId;//Owner of the file
        cVersion.Title = fileName;//Name of the file
        cVersion.VersionData = EncodingUtil.base64Decode(base64Data);//File content
        Insert cVersion;
        
        //After saved the Content Verison, get the ContentDocumentId
        Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
        
        //Insert ContentDocumentLink
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
        cDocLink.LinkedEntityId = ParentId;//Add attachment parentId
        cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
        cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        Insert cDocLink;
        /*Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
        insert oAttachment;*/
            
        return cDocLink.Id;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
 
        String existingBody = EncodingUtil.base64Encode(a.Body);
 
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
 
        update a;
    }
   /* @AuraEnabled 
    public static List<attachment > fetchContentDocument(String recordId){
        System.debug('recordId '  + recordId);
        return [Select id, Name From attachment  WHERE parentId = :recordId LIMIT 1000];
    }*/
    @AuraEnabled 
    public static List<contentDocument> fetchContentDocument(String recordId){
        List<id> contentList = new  List<id>();
        for(ContentDocumentLink conlink : [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = : recordId]){
            contentList.add(conlink.ContentDocumentId);
        }
        System.debug('contentList ' + contentList);
        System.debug([Select id,Title,FileType,CreatedBy.Name,ContentSize From contentDocument WHERE id IN :contentList LIMIT 1000]);
        return [Select id,Title,FileType,CreatedBy.Name,ContentSize From contentDocument WHERE id IN :contentList LIMIT 1000];
    }
     @AuraEnabled
    public static List<ETIN_Claim__c> getInsuranceClaimsDetails(){
        Id devRecordTypeId = Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosByName().get('Vehicle Insurance').getRecordTypeId();
        List<ETIN_Claim__c> insuranceList = new List<ETIN_Claim__c>();
        id userId = UserInfo.getUserId();
        List<User> userlist = [SELECT id, contact.AccountID FROM User WHERE id = :userId];
        id accountid = userlist[0].contact.AccountID;
        for(ETIN_Claim__c vehIns : [SELECT id,Chasses_Number__c,Plate_Number__c,Internal_Number__c,Policy_Number1__c,Vehicle_Type__c , Vehicle_Master__r.Vehicle_Type__c, Vehicle_Master__r.Chassis_No__c,Insurance_Policy__c, Name,Vehicle_Master__c,Claim_for__c,Vehicle_Master__r.Name,Comments__c,Claim_Amount__c FROM ETIN_Claim__c WHERE (ETIN_Insurance_Partner__c = :accountid AND ETIN_Claim_Status__c = 'Pending') AND recordtypeid =: devRecordTypeId order by Name]){
            insuranceList.add(vehIns);
        }
        return insuranceList;
    }
    
    @AuraEnabled
    public static List<ETIN_Insurance_Transactions__c> getInsuranceInsuranceTransactions(String claimid){
        List<ETIN_Insurance_Transactions__c> insuranceList = new List<ETIN_Insurance_Transactions__c>();
        for(ETIN_Insurance_Transactions__c vehIns : [SELECT id , Name FROM ETIN_Insurance_Transactions__c WHERE Claim__c = :claimid ]){
            insuranceList.add(vehIns);
        }
        return insuranceList;
    }
    @AuraEnabled
    public static void updateStatusForClaims(String recordId, String status){
        List<ETIN_Claim__c> vehIns = [SELECT ETIN_Claim_Status__c, ETIN_Insurance_Partner__c, ETIN_Insurance_Partner__r.Name,  Claim_Amount__c, Claim_for__c, Vehicle_Master__c FROM ETIN_Claim__c WHERE id = :recordId];
        if(status == 'Approved' && vehIns.size() > 0) {
            //vehIns[0].ETIN_Claim_Status__c = 'Active';
            vehIns[0].ETIN_Claim_Status__c  = 'Approved';
            if(vehIns[0].Claim_for__c == 'Scrapped Vehicle Theft'){
                Vehicle_Master__c etVehicle = [Select Vehicle_Status__c FROM Vehicle_Master__c WHERE id = :vehIns[0].Vehicle_Master__c];
                etVehicle.Vehicle_Status__c = 'Scrapped Not Sold';
                update etVehicle;
                
                ETIN_Insurance_Transactions__c etin_insurance_transactions = new ETIN_Insurance_Transactions__c(
                    CurrencyIsoCode = 'AED',
                    ETIN_AP_Type__c = 'Debit Note',
                    ETIN_Amount__c = vehIns[0].Claim_Amount__c,
                    ETIN_Invoice_Date__c = System.today(),
                    ETIN_Invoice_Type__c = 'Cancellation',
                    Insurance_Type__c = 'Vehicle',
                    Vehicle_Master__c = vehIns[0].Vehicle_Master__c,
                    Claim__c = vehIns[0].id
                );
                insert etin_insurance_transactions;
               // sendEmailForDebit(etin_insurance_transactions, vehIns[0].ETIN_Insurance_Partner__c, vehIns[0].ETIN_Insurance_Partner__r.Name);
            }
            
        }else if(vehIns.size() > 0){
            vehIns[0].ETIN_Claim_Status__c  = 'Rejected';
        }
        update vehIns;
        
    }
    
   
     @AuraEnabled
    public static List<Correction_Cancel_Request__c> getCorrectionRequestDetails(String recordtypeName){
        Id devRecordTypeId = Schema.SObjectType.Correction_Cancel_Request__c.getRecordTypeInfosByName().get(recordtypeName).getRecordTypeId();
        List<Correction_Cancel_Request__c> insuranceList = new List<Correction_Cancel_Request__c>();
        id userId = UserInfo.getUserId();
        List<User> userlist = [SELECT id, contact.AccountID FROM User WHERE id = :userId];
        id accountid = userlist[0].contact.AccountID;
        for(Correction_Cancel_Request__c vehIns : [SELECT id , SubmittedBy__c, TC_No__c,VehicleType__c, Name,Reason_for_Cancellation__c,Submitted_Date__c,Correction_for__c,Vehicle_Interanal_Number__c,Vehicle_Insurance_Policy__c,Comments__c,Effective_Date__c,createdDate FROM Correction_Cancel_Request__c WHERE (Insurance_Company__c = :accountid AND Request_Status__c = 'Insurance Pending') AND recordtypeid =: devRecordTypeId order by name]){
            
         
         // vehIns.Submitted_Date__c = Date.parse(vehIns.Submitted_Date__c.format('yyyy-MM-dd HH:mm:ss', 'PST'));
            insuranceList.add(vehIns);
        }
        return insuranceList;
    }
    
     @AuraEnabled
    public static List<Correction_Cancel_Request__c> getCancelTheftReq(String recordtypeName){
        
        List<Correction_Cancel_Request__c> insuranceList = new List<Correction_Cancel_Request__c>();
        id userId = UserInfo.getUserId();
        List<User> userlist = [SELECT id, contact.AccountID FROM User WHERE id = :userId];
        id accountid = userlist[0].contact.AccountID;
        for(Correction_Cancel_Request__c vehIns : [SELECT id , Name,Reason_for_Cancellation__c,Submitted_Date__c,Correction_for__c,Vehicle_Interanal_Number__c,Vehicle_Insurance_Policy__c,Comments__c FROM Correction_Cancel_Request__c WHERE (Insurance_Company__c = :accountid AND Request_Status__c = 'Insurance Pending') AND (recordtype.name='Cancellation Request' OR recordtype.name='Vehicle Theft Request') order by name]){
            
         
         // vehIns.Submitted_Date__c = Date.parse(vehIns.Submitted_Date__c.format('yyyy-MM-dd HH:mm:ss', 'PST'));
            insuranceList.add(vehIns);
        }
        return insuranceList;
    }
    
    
    
    @AuraEnabled
    public static void updateStatusForCorrectionRequest(String recordId, String status){
        List<Correction_Cancel_Request__c> vehIns = [SELECT Request_Status__c FROM Correction_Cancel_Request__c WHERE id = :recordId];
        if(status == 'Approved' && vehIns.size() > 0) {
            //vehIns[0].ETIN_Claim_Status__c = 'Active';
            vehIns[0].Request_Status__c  = 'Insurance Approved';
        }else if(vehIns.size() > 0){
            vehIns[0].Request_Status__c  = 'Insurance Rejected';
        }
        update vehIns;
    }
}