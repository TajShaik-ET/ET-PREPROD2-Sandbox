public class ETVIN_VehicleTheftCtrl {

    
    @AuraEnabled  
    public static List<ContentDocument> getFiles(string recordId){  
        List<ContentDocument> DocumentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();  //store file ids
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  // Document ids
        }      
        DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds];  
        return DocumentList;  
    }  
    
    @AuraEnabled  
    public static List<ContentDocument> UpdateFiles(string documentId,string title,string recordId){  
        system.debug('title: ' +title);  
        ContentDocument cd = [select id,title from ContentDocument where Id=:documentId]; // Getting files from Parent record 
        cd.Title = title;  // Changing file Title with user entered title
        try{  
            update cd;  // Update ContentDocument (File)
        }  
        catch(DMLException e){  
            system.debug('Exception has occurred! ' +e.getMessage());  
        }  
        List<ContentDocument> DocumentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();  
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds];  
        return DocumentList;  // Return list of files on parent record
    } 
    
  /* 
    @AuraEnabled
    public static List <Vehicle_Theft_Report__c> getTheftReportData(string RecID) {
        return [SELECT Id,Name,Cancel_Request__c,Cancel_Request__r.Name FROM Vehicle_Theft_Report__c where Cancel_Request__c=:RecID];
        
    } 
     @AuraEnabled
    public static List <ETVIN_Vehicle_NOC_Report__c> getNOCReportData(string RecID) {
        return [SELECT Id,Name,Correction_Cancel_Request__c,Correction_Cancel_Request__r.Name FROM ETVIN_Vehicle_NOC_Report__c where Correction_Cancel_Request__c=:RecID];
        
    }  
        
        @AuraEnabled
        public static List <Vehicle_Profession_Certificate__c> getProfCertData(string RecID) {
            return [SELECT Id,Name,Cancel_Request__c,Cancel_Request__r.Name FROM Vehicle_Profession_Certificate__c where Cancel_Request__c=:RecID];
            
        } 
      @AuraEnabled
        public static List <Vehicle_Cancellation_Letter__c> getCanceLetterData(string RecID) {
            return [SELECT Id,Name,Cancel_Request__c,Cancel_Request__r.Name FROM Vehicle_Cancellation_Letter__c where Cancel_Request__c=:RecID];
            
        }
   */ 
     @AuraEnabled
    public static string deleteRecord(Id RecID) {
 
        Database.DeleteResult drRes =  Database.delete(RecID);
        if(drRes.isSuccess()){
            
            return 'success';
        }else{
            return 'error';
        }
    }
    
    @AuraEnabled
    public static list<string> getRelatedDocList(Id RecID) {
        list<string> docList = new list<string>();
        map<string,string> docAPIvsLable = new map<string,string>();
        
        Correction_Cancel_Request__c rec = [select id,Name,Prove_Theft_certificate__c,Insurance_Cancellation_Letter__c,Transfer_Profession_Certificate__c,Police_Report__c,NOC_Receive_Vehicle__c,Cancel_Theft_Report__c,NOC_Release_Case__c from Correction_Cancel_Request__c where id=:RecID];
        
        for(VehicleTheftPrcsDocs__c vtp : [select id,name,Doc_API_Name__c,Doc_label__c from VehicleTheftPrcsDocs__c]){
            
            docAPIvsLable.put(vtp.Doc_API_Name__c,vtp.Doc_label__c);
        }
       
        
            
        if(!rec.Prove_Theft_certificate__c){
            docList.add(docAPIvsLable.get('Prove_Theft_certificate__c'));
        }
         if(!rec.Transfer_Profession_Certificate__c){
            docList.add(docAPIvsLable.get('Transfer_Profession_Certificate__c'));
        }
         if(!rec.Police_Report__c){
            docList.add(docAPIvsLable.get('Police_Report__c'));
        }
        if(!rec.Insurance_Cancellation_Letter__c){
            
               docList.add(docAPIvsLable.get('Insurance_Cancellation_Letter__c'));            
        }
        if(!rec.NOC_Receive_Vehicle__c){
            
               docList.add(docAPIvsLable.get('NOC_Receive_Vehicle__c'));            
        }
       
         
        if(!rec.Cancel_Theft_Report__c){
            
               docList.add(docAPIvsLable.get('Cancel_Theft_Report__c'));            
        }
        if(!rec.NOC_Release_Case__c){
            
               docList.add(docAPIvsLable.get('NOC_Release_Case__c'));            
        }
        
            return docList;
    }
    
     @AuraEnabled
    public static string updateRecord(Id RecID,string DocLabel,boolean status) {
        
         map<string,string> docLablevsAPI = new map<string,string>();
        
         for(VehicleTheftPrcsDocs__c vtp : [select id,name,Doc_API_Name__c,Doc_label__c from VehicleTheftPrcsDocs__c]){
            
            docLablevsAPI.put(vtp.Doc_label__c,vtp.Doc_API_Name__c);
        }
        
        string apiName = docLablevsAPI.get(DocLabel);
        
        Correction_Cancel_Request__c  ccr = new Correction_Cancel_Request__c();
        ccr.ID =  RecID;
        ccr.put(apiName,status);
        
        update ccr;
       
        return null;
    }
   
   @AuraEnabled
    public static List<VehicleInsEmailNotification__c> getVehicleEmailRecipients() { 
        
        return [select id,name,Email__c,Label__c from VehicleInsEmailNotification__c];
    }
    
   @AuraEnabled
    public static string sendEmailtoTheList(list<string> senderList) { 
       
        map<string,string> labelVsEmail = new map<string,string>();
        list<string> tolist = new list<string>();
        
        for(VehicleInsEmailNotification__c ve : [select id,name,Email__c,Label__c from VehicleInsEmailNotification__c]){
            
            if(ve.Email__c != null)
            labelVsEmail.put(ve.Label__c,ve.Email__c);
             }
        
        for(string s : senderList){
            
            if(labelVsEmail.containsKey(s))
            tolist.add(labelVsEmail.get(s));
        }
        
        if(tolist.size()>0) {
            
             Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
 
             mail.setToAddresses(tolist);
            String htmlBody = '<p>Hi Team,</p>'; 
                    htmlBody+=   '<p>New file is added to the request.</p>';
                                     
                    htmlBody+=   '<p>Thank you and best regards,</p>';
                    htmlBody+=   '<p>FSO</p>';
                    mail.setSubject('Vehicle Insurance');
                    mail.setHtmlBody(htmlBody);
                    mail.setSaveAsActivity(false);
					Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {mail};
                        
           Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            system.debug('===='+results);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
                return 'success';
                
            }  else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
                return 'error';

                
            }
            
            
        }
       
        return null;
                
    }
    
}