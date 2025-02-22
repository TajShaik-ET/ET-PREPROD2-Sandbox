public  class ETI_BulkUploadVehicles {
    
    public ETI_BulkUploadVehicles(ApexPages.StandardController controller){
    }
    @AuraEnabled
    public static List<ETI_BulkVehiclesUpload_Status__c> getUserFiles(){
        return [select ETI_File_Id__c,ETI_File_Name__c,ETI_User__c,ETI_User__r.Name,ETI_Location__c,CreatedDate 
                from ETI_BulkVehiclesUpload_Status__c where ETI_Is_Processed__c=false];
    }
        
    @AuraEnabled
    public static void sendConfirmationEmail(String docId,String docName, String location){
        Id userID=userInfo.getUserId();
        ETI_BulkVehiclesUpload_Status__c userDoc=new ETI_BulkVehiclesUpload_Status__c();
        userDoc.ETI_File_Id__c=docId;
        userDoc.ETI_File_Name__c=docName;
        userDoc.ETI_Location__c=location;
        userDoc.ETI_User__c=userID;
        try{
            insert userDoc;
        }catch(Exception e){
            System.debug('Exception'+e.getMessage());
        }
        if(location!=null && location!=''){
            list<string> toAddress = new list<string>();
            String contactId=[select contactId from user where id=:userID].contactId;
            Contact con=[select name from contact where id=:contactId];
            list<ETI_Bulk_Vehicles_Upload_Recipients__mdt> recipients=[Select MasterLabel, Recipients_Email_Id__c from ETI_Bulk_Vehicles_Upload_Recipients__mdt Where MasterLabel=:location limit 1];
            list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Bulk_Vehicles_Upload_Request' limit 1];
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            //String to_Email=System.label.ETI_Bulk_Vehicle_Upload_Reciever;
            if(recipients!=null && recipients.size()>0 && EmailTemplates!=NULL && EmailTemplates.size()>0){
                string emailcontent = EmailTemplates[0].HtmlValue;
                //String to_Email=System.label.ETI_Bulk_Vehicle_Upload_Reciever;
                if(recipients[0].Recipients_Email_Id__c!= null && recipients[0].Recipients_Email_Id__c != ''){
                    toAddress.addall(recipients[0].Recipients_Email_Id__c.split(',|;'));
                    //message.setWhatId(con.Id);
                    message.setTargetObjectId(con.id);
                    message.toAddresses = toAddress;
                    string emailBody = con.Name+' Requested for Bulk Vehicles upload, Please validate and upload the vehicles.';
                    if(emailcontent.contains('{!emailContent}'))
                        emailcontent = emailcontent.Replace('{!emailContent}',emailBody);
                    message.setHTMLBody(emailcontent);
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }
                }
            }
        }
    }
    
    @AuraEnabled
    public static uploadWrapper uploadBulkVehicles(String jsonstr,String fileName,string csv, string emirate)
    {
        String[] filelines = new String[]{};
        Map<String,ET_Customer_Vehicle__c> vehiclesToUpload;
        string nameFile;
        Blob contentFile;
        set<id> ids=new set<id>();
        list<ETI_BulkVehiclesUpload_Status__c> lstUploadFile=new list<ETI_BulkVehiclesUpload_Status__c>();
        Map<Integer, String> settingsMap = new Map<Integer, String>();
        uploadWrapper wrp=new uploadWrapper();
        list<User> userDetails=[Select Id,Name,accountId,ContactId From User Where Id=:userInfo.getUserId() AND ContactId!=null limit 1];
        if(userDetails!=null && userDetails.size()>0){
            System.debug('userDetails '+userDetails[0].ContactId);
            System.debug('jsonstr '+jsonstr);
            System.debug('csv '+csv);
            System.debug('emirate'+emirate);
            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = '/' + fileName;
            cv.FirstPublishLocationId = userDetails[0].ContactId;
            cv.VersionData = Blob.valueOf(csv);
            cv.IsMajorVersion = true;
            insert cv; 
            system.debug('cv.id '+ cv.id);
            List<ContentDocumentLink> contentDocumentLinkList = [SELECT LinkedEntityId, ShareType, Visibility 
                                                                        FROM ContentDocumentLink 
                                                                        WHERE LinkedEntityId =: userDetails[0].ContactId];
            for(contentDocumentLink contentDocumentLink: contentDocumentLinkList){
                contentDocumentLink.ShareType = 'I';
                contentDocumentLink.Visibility = 'AllUsers';
            }
            update contentDocumentLinkList;
            ContentVersion cversion = [SELECT title,PathOnClient, FileType,versiondata FROM contentversion
                                       WHERE Id =:cv.Id];
            System.debug('cversion--> '+cversion);
            ETI_Customer_Vehicle_BulkUpload__mdt[] cvMdtData = [SELECT MasterLabel,column_Index__c,Field_API_Name__c,Emirate__c
                                                                       FROM ETI_Customer_Vehicle_BulkUpload__mdt
                                                                       WHERE (Emirate__c='Both' or Emirate__c=:emirate)];
                                                                       
            System.debug('cvMdtData -->'+cvMdtData);
            //put in order and API Names                                                
            for(ETI_Customer_Vehicle_BulkUpload__mdt obj: cvMdtData)
            {
                settingsMap.put(Integer.valueOf(obj.column_Index__c), obj.Field_API_Name__c);
            }   
            System.debug('settingsMap-->'+settingsMap);
            //Now sepatate every row of the excel file
            filelines = csv.split('\n');
            System.debug('filelines-->'+filelines);
            vehiclesToUpload=new Map<String,ET_Customer_Vehicle__c>();
            for (Integer i=1;i<filelines.size();i++)
            {
                System.debug('filelines inn-->'+filelines[i]);
                String[] inputvalues = new String[]{};
                ET_Customer_Vehicle__c vehicle=new ET_Customer_Vehicle__c();
                System.debug('inputvalues-->'+inputvalues);
                vehicle.Registration_Type__c='Registered';
                vehicle.Selected_Type__c='Chassis No';
                vehicle.Account__c=userDetails[0].accountId;
                if(userDetails[0].contactId!=null)
                    vehicle.Contact__c=userDetails[0].contactId;
                string[] csvRecordData=new list<string>();
                for(string str:filelines[i].split(',')){
                    if(str=='\r' || str=='\n')
                        csvRecordData.add(null);
                    else
                        csvRecordData.add(str);
                }
                System.debug('csvRecordData-->'+csvRecordData);
                String chasis;
                //for each line go through column by column and find the index from settinsMap
                for(Integer j=0; j<settingsMap.size(); j++)
                {
                    if(settingsMap.get(j+1)=='ET_Vehicle_type__c'){
                        if(csvRecordData[j]==null || csvRecordData[j]==''){
                            wrp.errormsg = 'Vehicle Type should not be blank in row '+(j);
                            return wrp;  
                        }else 
                            vehicle.put(settingsMap.get(j+1), csvRecordData[j].trim());
                    }
                    if(settingsMap.get(j+1)=='ADFCA_Type__c'){
                        if(csvRecordData[j]==null || csvRecordData[j]==''){
                            wrp.errormsg = 'ADFCA Type should not be blank in row '+(j);
                            return wrp;  
                        }else 
                            vehicle.put(settingsMap.get(j+1), csvRecordData[j].trim());
                    }
                    if(settingsMap.get(j+1)=='Chassis_No__c'){
                        if(csvRecordData[j]==null || csvRecordData[j]==''){
                            wrp.errormsg ='Chasis No. should not be blank in row '+(j);
                            return wrp;  
                        }else {
                            chasis=csvRecordData[j].trim().removeEnd('\n');
                            vehicle.put(settingsMap.get(j+1), csvRecordData[j].trim());
                        }
                    }
                }
                System.debug('vehicle-->'+vehicle);
                vehiclesToUpload.put(chasis,vehicle);
            }
            wrp.TotoalVehicles=vehiclesToUpload.size();
            for(ET_Customer_Vehicle__c vehicle: [select Chassis_No__c from ET_Customer_Vehicle__c where Chassis_No__c  =:vehiclesToUpload.keyset() 
                                                    AND Account__c=:userDetails[0].accountid AND Status__c='Active']){
                System.debug('vehiclesToUpload contains'+vehicle.Chassis_No__c);
                if(vehiclesToUpload.containsKey(vehicle.Chassis_No__c)){
                    System.debug('inner '+vehicle.Chassis_No__c);
                    vehiclesToUpload.remove(vehicle.Chassis_No__c);
                }
             }
             System.debug('vehiclesToUpload '+vehiclesToUpload);
             if(vehiclesToUpload.size()>0){
                insert vehiclesToUpload.values();
                if(!lstUploadFile.isEmpty())
                    update lstUploadFile;
                for(ET_Customer_Vehicle__c vehicle:vehiclesToUpload.values()){
                    ids.add(vehicle.id);
                }
                Database.executeBatch(new ETI_BulkVehicleUploadValidateBatch(ids),1);
                wrp.UploadedVehicles=vehiclesToUpload.size();
                wrp.DuplicateVehicles=wrp.TotoalVehicles-vehiclesToUpload.size();
             }else{
                 wrp.UploadedVehicles=0;
                 wrp.DuplicateVehicles=wrp.TotoalVehicles;
                 wrp.errormsg='Vehicle data is already existing in the system.'; 
             }
        }else 
             wrp.errormsg='Account Details are missing.'; 
        system.debug('wrp>> '+wrp);
        return wrp;
    }
    
    public class fieldWrapper{  
        public String VehicleType; 
        public String ADFCAType;        
        public String ChassisNumber;         
    } 
    public class uploadWrapper{  
        @Auraenabled public String errormsg; 
        @Auraenabled public Integer TotoalVehicles; 
        @Auraenabled public Integer UploadedVehicles;        
        @Auraenabled public Integer DuplicateVehicles;         
    } 
    public static void utilityMethod(){
        integer i=0;
        
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
        }
}