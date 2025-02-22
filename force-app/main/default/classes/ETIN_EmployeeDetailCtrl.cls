public with sharing class  ETIN_EmployeeDetailCtrl {
   
    @AuraEnabled
    public static list<ETIN_Insurance__c> getEmpInsDetails(String userId) { 
        
      List<User> lstUser = [Select u.AccountId from User u where u.Id = :userId];
        
             List<ETIN_Insurance__c>  insList = [select Id,First_Name__c,Last_Name__c,Relation__c,Insurance_Policy_Number__c,Effective_Date__c,Expiry_Date__c,Card_Number__c,Insurance_Current_Status__c,Card_Download_URL__c from ETIN_Insurance__c where Insurance_Current_Status__c='Active' AND EmployeeAcc__c=:lstUser[0].AccountId order by Expiry_Date__c DESC];  
        system.debug('--Ins--'+insList);
        
        return insList;
    }   
    

     @AuraEnabled
    public static Id getLoginContactId(String userId) { 
    
    return  [Select AccountId from User where Id = :userId].AccountId;
    
    }
    
     @AuraEnabled
    public static string getLoginUserVisaEmirates(String userId) { 
        
       List<User> lstUser = [Select u.AccountId from User u where u.Id = :userId];
       Id AccId = lstUser[0].AccountId;
        
        
        return [select ETIN_Place_of_Visa_Issuance__c  from Account where Id = :AccId].ETIN_Place_of_Visa_Issuance__c;
    
    }
    
    
  /*  @AuraEnabled
    public static List <ContentDocumentLink> getAttachments(String parentRecID) {
        return [SELECT Id,ContentDocumentId,ContentDocument.Title,ContentDocument.FileType FROM ContentDocumentLink where LinkedEntityId=:parentRecID];
        
    } */
    
   /*  @AuraEnabled
    public static void deleteAttachment(String contentDocId) { 
        
        ContentDocument deleteContent = new ContentDocument(Id=contentDocId);
    
        try {
            delete deleteContent;
        }
        catch (Exception e) {
            
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
        }
    } */
    
   /* @AuraEnabled
    public static string DownloadAttachment(Id parentRecID){
        set<id> contentDocIds = new set<id>();
        String insuranceNum = [select Insurance_Policy_Number__c from ETIN_Insurance__c where Id=:parentRecID].Insurance_Policy_Number__c;
        List<ContentDocumentLink> contentDoc = [SELECT Id,ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:parentRecID];
        
        system.debug('---'+insuranceNum+'----'+parentRecID);
        for( ContentDocumentLink cd: contentDoc){
            contentDocIds.add(cd.ContentDocumentId);
        }
            
        List<ContentVersion> oldCV = [Select Id,Title from ContentVersion Where ContentDocumentId=:contentDocIds and IsLatest = true ];
        String URlDownload ;
        String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
        for(ContentVersion cv : oldCV){
            
            if(cv.Title == insuranceNum )             
                URlDownload = fullFileURL+'/employee/sfc/servlet.shepherd/version/download/'+cv.Id+'?operationContext=S1';
            
        }
         return 'https://etpdev-et.cs110.force.com/employeeportal/sfc/servlet.shepherd/version/download/0680C000000YiFhQAK?operationContext=S1';  
}*/
    @AuraEnabled
    public static Id getContactLoginId(Id userId){
        
       List<User> lstUser = [Select u.AccountID from User u where u.Id = :userId];
       Id contactId = lstUser[0].AccountID;
        
        return contactId;
    }
     @AuraEnabled
    public static Id getEmpFamilyID(Id InsRecID){
        
            
        return [select id,Employee_Family__c from ETIN_Insurance__c where Id=:InsRecID].Employee_Family__c ;
    }
    
    
    
 
     @AuraEnabled
    public static list<mergeTwoObjects > geDetails(String userId) { 
          system.debug('---enter--');
        List<User> lstUser = [Select u.AccountID from User u where u.Id = :userId];
        Id AccId = lstUser[0].AccountID;
        
        List<mergeTwoObjects> finallist = new List<mergeTwoObjects>();
        
        for( ETIN_Insurance__c  insList: [select Id,Name,First_Name__c,Last_Name__c,Relation__c,Insurance_Policy_Number__c,Status__c,RecordType.Name,Insurance_Current_Status__c,createdDate from ETIN_Insurance__c where EmployeeAcc__c=:AccId order by createdDate DESC]){ //Employee__c=:contactId AND
             system.debug('---enter-Ins-');
            finallist.add(new mergeTwoObjects(insList));
                          
             }
        try{ for (Case caseList : [select Id,CaseNumber,Status,ETIN_Member_First_Name__c,ETIN_Member_Last_Name__c,Relation__c,RecordType.Name,createdDate from Case where AccountID=:AccId  order by createdDate DESC]){ //ETIN_Employee_Requested__c=True ContactId=:contactId AND
                   
            system.debug('---Cases--'+caseList);
                  finallist.add(new mergeTwoObjects(caseList));             
             }  
           }catch (Exception e) {
                
                throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
            }    
                                 
                          
          return finallist;
    }
    
     public class mergeTwoObjects {
        
         @AuraEnabled  public Datetime dateRes {get;set;}
         @AuraEnabled public string RefNum {get;set;}
         @AuraEnabled  public String FirstName {get;set;}
         @AuraEnabled  public String LastName {get;set;}
         @AuraEnabled  public String Relation {get;set;}
          @AuraEnabled  public String Status {get;set;}
         @AuraEnabled  public String RequestType {get;set;}
        
        
        public mergeTwoObjects(ETIN_Insurance__c Ins){
            this.dateRes =Ins.createdDate;
            this.RefNum = Ins.Name;
            this.FirstName = Ins.First_Name__c;
            this.LastName = Ins.Last_Name__c;
            this.Relation = Ins.Relation__c;
            this.Status = Ins.Status__c;
            this.RequestType = 'New Request';
            
           
        }
        public mergeTwoObjects(Case ca){
             this.dateRes =ca.createdDate;
             this.RefNum = ca.CaseNumber;
             this.FirstName = ca.ETIN_Member_First_Name__c;
            this.LastName = ca.ETIN_Member_Last_Name__c;
            this.Relation = ca.Relation__c;
            this.Status = ca.Status;
            this.RequestType = 'Correction Request';
           
           
        }
        
    }
 
    
    @AuraEnabled
    public static Id saveTheFile( String fileName, String base64Data, String contentType,Id parentID) {
        
        Id InsuranceId =parentID;
       system.debug('entered');
        ContentVersion ContentInsert =new ContentVersion();
        ContentInsert.Title =fileName;
        base64Data=EncodingUtil.urlDecode(base64Data,'UTF-8');
        ContentInsert.VersionData= EncodingUtil.base64Decode(base64Data);
        ContentInsert.PathOnClient='/' + fileName ;
        ContentInsert.FirstPublishLocationId = InsuranceId;
        insert ContentInsert;
              
       /* List<ContentDocumentLink> contentDocumentLinkList = [SELECT LinkedEntityId, ShareType, Visibility
                                                             FROM ContentDocumentLink
                                                             WHERE LinkedEntityId =: Vehicleid];
        for(contentDocumentLink contentDocumentLink: contentDocumentLinkList){
            contentDocumentLink.ShareType = 'I';
            contentDocumentLink.Visibility = 'AllUsers';
        }
        update contentDocumentLinkList; */
       return ContentInsert.Id;
    }
    
    @AuraEnabled   
    public static Id getRecordTypeId(string objName,string devName){
        
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(objName) ;
        Schema.DescribeSObjectResult cfrSchema = s.getDescribe() ;
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo = cfrSchema.getRecordTypeInfosByDeveloperName();
        Id rtId = RecordTypeInfo.get(devName).getRecordTypeId();
        system.debug('--recType--'+rtId);
        return rtId;
    }
   
}