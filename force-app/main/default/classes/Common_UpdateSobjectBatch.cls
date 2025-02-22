/**************************************************************
*@author: Kumaresan Manickam
*@desc: Common batch apex class which is used to alter the sensitive data field information (only email & phone type fields supported as of now) by changing its value differently so that its changed.
*@script to execute: Database.executeBatch(new Common_UpdateSobjectBatch(<ObjectnameString>,new Set<String>{'Field api name-1 to alter','Field api-2 name to alter,...});
Example: To alter contact email & mobilephone fields, use the script: Database.executeBatch(new Common_UpdateSobjectBatch('Contact',new Set<String>{'email','mobilephone'}));
***************************************************************/
public class Common_UpdateSobjectBatch implements Database.Batchable<sObject>,Database.Stateful{

   public string objectApiName;
   public Set<String> fieldsListToMask;//lower case charaters to be used
   public Map<String,Schema.DisplayType> fieldTypeMap;
   public Map<String,String> errorMap;
   
   public Common_UpdateSobjectBatch(String objectApiName,Set<String> fieldsListToMask){
       this.objectApiName=objectApiName;
       this.fieldsListToMask=fieldsListToMask;
       this.fieldTypeMap=new Map<String,Schema.DisplayType>();
       if(fieldsListToMask!=null && fieldsListToMask.size() >0){
           for(String s:fieldsListToMask){
               s=s.toLowerCase();
           }
           
           fieldTypeMap=new Map<String,Schema.DisplayType>();
           Map<String, Schema.SObjectField> M;
           
           if (objectApiName=='Contact'){
               M = Schema.SObjectType.contact.fields.getMap();
           }
           else if (objectApiName=='Account'){
               M = Schema.SObjectType.Account.fields.getMap();
           }
           else if (objectApiName=='Lead'){
               M = Schema.SObjectType.Lead.fields.getMap();
           }
           
           for(String f:M.keyset()){
               if(fieldsListToMask.contains(f.toLowerCase()) || f.equalsIgnoreCase('id')){
                   Schema.SObjectField field=M.get(f);
                   fieldTypeMap.put(f,field.getDescribe().getType());
               }
           }
       }
       errorMap=new Map<String,String>();
   }
    
   public Database.QueryLocator start(Database.BatchableContext BC){
      String queryStr='Select '+String.join(new list<String>(fieldsListToMask),',')+' ,Id from '+objectApiName;
      return Database.getQueryLocator(queryStr);
   }

   public void execute(Database.BatchableContext BC, List<sObject> scope){
       List<Sobject> recordsToUpsert=new List<Sobject>();
       String emailVal;
       Boolean isValidRecordToUpdate=false;
       String phoneVal;
       
       try{
           for(sObject s:scope){
               isValidRecordToUpdate=false;
               for(String f:fieldTypeMap.keyset()){
                   Object val=s.get(f);
                   if(val !=null && String.ValueOf(val)!=null && String.ValueOf(val)!=''){
                       if(String.ValueOf(fieldTypeMap.get(f))=='Email' && !String.ValueOf(val).containsIgnoreCase('invalid')){
                           emailVal=String.ValueOf(val);
                           s.put(f,emailVal+'.invalid');
                           isValidRecordToUpdate=true;
                       }
                       /*else if(String.ValueOf(fieldTypeMap.get(f))=='Phone'){
                           phoneVal=String.ValueOf(val);
                           if(phoneVal.length() > 3){
                               phoneVal=phoneVal.subString(0,(phoneVal.length()-3));
                               phoneVal+=String.ValueOf(DateTime.now().millisecond());
                               s.put(f,phoneVal);
                               isValidRecordToUpdate=true;
                           }
                       }*/
                   }
               }
               if(isValidRecordToUpdate){
                   recordsToUpsert.add(s);
               }
           }
           
           Database.saveResult[] results=Database.update(recordsToUpsert,false);
           Integer i=0;
           for (Database.SaveResult sr : results) {
                if (!sr.isSuccess()) {
                    String errorStr='';
                    for(Database.Error err : sr.getErrors()) {
                        errorStr+=err.getMessage()+'-'+'Fields that affected this error: ' + err.getFields();
                        errorMap.put(recordsToUpsert[i].Id,errorStr);
                    }
                }
               i++;
           }
       }
       Catch(Exception e){
           errorMap.put('Unknown exception',e.getMessage()+'-'+e.getLineNumber()+'-'+e.getStackTraceString());
       }
   }

   public void finish(Database.BatchableContext BC){
       if(errorMap!=null && errorMap.keyset() != null && errorMap.Keyset().size() >0){
           OrgWideEmailAddress orgWideAddress=[select id, Address,DisplayName from OrgWideEmailAddress where DisplayName='Emirates Transport'];             
           String errorsDt='Hi Team,<br/><br/>Please take a moment to review the batch job failures on job Common_UpdateSobjectBatch for object -'+objectApiName+':<br/>';
           String fileString='Id,Error Details\n';
           for(string s:errorMap.keyset()){
               fileString+='"'+s+'","'+errorMap.get(s)+'"\n';
           }
           errorsDt+='<br/>Thanks<br/>';
           Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
           
           List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
           Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
           efa.setFileName('Error file.csv');
           efa.setBody(blob.ValueOf(fileString));
           efa.setContentType('text/csv');
           attachments.add(efa);
           
           email.setFileAttachments(attachments);
           
           email.setSubject('Exception while processing the batch job Common_UpdateSobjectBatch for object:'+objectApiName);
           email.setOrgWideEmailAddressId(orgWideAddress.id);
           email.setToAddresses( new String[] {Userinfo.getUserEmail(),'kumaresan.m@smaartt.com'});
           email.setHTMLBody(errorsDt);
           Messaging.SendEmailResult [] r =Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
   }
}