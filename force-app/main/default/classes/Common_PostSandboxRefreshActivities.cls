/***********************************
*@author: Kumaresan Manickam
*@desc:   Post refresh of org this class will be executed if we give "Common_PostSandboxRefreshActivities" class in the post execution field. 
*@pre - requisite: 
        1. Ensure updating the documents under "Shared Internal" document folder and created/replace the documents with upto date csv file.
            (i). All custom labels can be maintained under single document record.
            (ii). Individual document records to be created for each custom metata data object & each custom setting object
            (iii) For Custom Metadata,
                    Maintain the format of document name such as "Post Refresh - Custom Metadata"
                    Do not alter columns "Sandbox Name", "Metadata Object API Name","Masterlabel","Developername".  Use api name of custom metadata in column "Metadata Object API Name"
                    Add new columns with field api name if in case of new fields to be added.
                    "Post Refresh - Custom Label", "Post Refresh - Custom Setting - List" when creating.
            (iv) For Custom Setting of list type,
                    Maintain the format of document name such as "Post Refresh - Custom Setting - List"
                    Do not alter columns "Sandbox Name", "Custom Setting API Name","Name".  Use api name of custom setting in column "Custom Setting API Name"
                    Add new columns with field api name if in case of new fields to be added.
            (v) Create new rows of data for each sandbox org with related org Id as and when required in the same csv file. Our logic will only pick the related org specific row while processing.
        2. Review & update the email field types in lines starting from 146-161 so that our batch will update new fields as needed.
*@operations: 
        1. This class currently managed to update Custom label, Custom Metadata & Custom Setting of List type alone. post email error processing not done so far.
        2. 3 new individual scheduled apex instances will be created with name "Lead Clean up", "Account clean up", "contact clean up" (one time jobs) and error csv will be received post completion.
        3. Any validation preventing the record getting updated will be ignored and to be taken care manually by user.
        4. Script to call externally from developer console after refresh completed if in case of the class didn't executed well automatically:-
            Common_PostSandboxRefreshActivities c=new Common_PostSandboxRefreshActivities();
            c.orgId=UserInfo.getOrganizationId();
            c.currentOrgSandboxName=context.sandboxName();
            c.Utility();
 */       
global class Common_PostSandboxRefreshActivities implements SandboxPostCopy {
    global String orgId;
    global String currentOrgSandboxName;
    
    global void runApexClass(SandboxContext context) {
        orgId=context.organizationId();
        currentOrgSandboxName=context.sandboxName();
        Utility();
    }
    
    global void Utility(){        
        List<Sobject> CutsomMetadataToUpdate=new List<Sobject>();
        List<metadataservice.saveresult> results=new List<metadataservice.saveresult>();
        Id customMetadataId;        
        List<MetaDataUtility.CustomLabelWrapper> customLabelsList=new List<MetaDataUtility.CustomLabelWrapper>();
        List<Sobject> CutsomSettingToUpdate=new List<Sobject>();
        Messaging.SingleEmailMessage[] emailList=new Messaging.SingleEmailMessage[]{};
        OrgWideEmailAddress orgWideAddress=[select id, Address,DisplayName from OrgWideEmailAddress where DisplayName='Emirates Transport']; 
        Map<String,Map<String,String>> customSettingMap=new Map<String,Map<String,String>>();
        Map<Id,String> profileMap=new Map<Id,String>();
        Map<String,Id> profileNameIdMap=new Map<String,Id>();
        
        for(Profile p:[Select Id,name from Profile]){
            profileMap.put(p.Id,p.name);
            profileNameIdMap.put(p.name,p.Id);
        }
        
        for(Document d:[Select Id,body,name,contentType from Document where Folder.Developername='Shared_Internal' and name like 'Post Refresh -%']){
            String csvFile='';
            List<List<String>> itemsList=new List<List<String>>();
            try{
                if(d.name.containsIgnoreCase('custom metadata')){
                    csvFile=d.body.toString();
                    itemsList=Common_PostSandboxRefreshActivities.parseCSV(csvFile,false);
                    if(itemsList.size() >1){
                        String objAPiName=itemsList[1][1]; //second column should be 'Metadata Object API Name' always
                        CutsomMetadataToUpdate.addAll(Common_PostSandboxRefreshActivities.csvTosObject(itemsList,objAPiName,currentOrgSandboxName,null,null));                   
                    }  
                }        
                else if(d.name.containsIgnoreCase('custom label')){  
                    csvFile=d.body.toString();
                    itemsList=Common_PostSandboxRefreshActivities.parseCSV(csvFile,false);
                    if(itemsList.size() >1){
                        customLabelsList.addAll(Common_PostSandboxRefreshActivities.csvToCustomWrapper(itemsList,currentOrgSandboxName));                   
                    } 
                } 
                else if(d.name.containsIgnoreCase('custom setting')){  
                    csvFile=d.body.toString();
                    itemsList=Common_PostSandboxRefreshActivities.parseCSV(csvFile,false);
                    if(itemsList.size() >1){
                        String objAPiName=itemsList[1][1]; //second column should be 'Custom setting api Name' always
                        customSettingMap.put(objAPiName,new Map<String,String>());
                        
                        for(Sobject s:Database.query('Select '+String.join(Common_PostSandboxRefreshActivities.queryAllSObjectFields(objAPiName),',')+' from '+objAPiName)){//we are aware that this query inside for loop and it should be ok to keep since the setting we process is less numbers and we cannot query everything.
                            String key='';
                            try{
                                key=(String)s.get('Name'); 
                                Id keyId=(Id)key;//Custom setting with list type will be failed in this line and moved to catch section. Hierarcy  type setting will move on to next step
                                key=(String)s.get('SetupOwnerId'); 
                                if(String.isNotBlank(key) && profileMap.containsKey(key)){
                                    key=profileMap.get(key);
                                }
                                else if(String.isNotBlank(key) && key==orgId){
                                    key='Org Default';
                                }                                
                            }
                            Catch(Exception e){
                                if((String)s.get('SetupOwnerId')!=orgId){
                                    if(String.isNotBlank(key) && profileMap.containsKey(key)){
                                        key=profileMap.get(key);
                                    }
                                }
                            }
                            customSettingMap.get(objAPiName).put(key,(String)s.get('Id'));
                        }
                        CutsomSettingToUpdate.addAll(Common_PostSandboxRefreshActivities.csvTosObject(itemsList,objAPiName,currentOrgSandboxName,customSettingMap.get(objAPiName),profileNameIdMap));                   
                    }  
                }    
            }
            Catch(Exception e){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();   
                email.setSubject('Exception while processing class Common_PosSandboxRefreshActivities');
                email.setOrgWideEmailAddressId(orgWideAddress.id);
                email.setToAddresses( new String[] {Userinfo.getUserEmail()});
                email.setHTMLBody('Exception while processing class Common_PosSandboxRefreshActivities: '+e.getMessage()+'-'+e.getStackTraceString());
                emailList.add(email);
            }            
        }
        
        
        if(customLabelsList.size() >0){
            List<MetaDataUtility.CustomLabelWrapper> tempList;
            if(customLabelsList.size()>10){
                tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                for(Integer q=0;q<10;q++){
                    tempList.add(customLabelsList[q]);
                }
                results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                
                if(customLabelsList.size()>20){
                    tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                    for(Integer j=10;j<20;j++){
                        tempList.add(customLabelsList[j]);
                    }
                    results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                    if(customLabelsList.size()>30){
                        tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                        for(Integer j=20;j<30;j++){
                            tempList.add(customLabelsList[j]);
                        }
                        results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                        
                        if(customLabelsList.size()>40){
                            tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                            for(Integer j=30;j<40;j++){
                                tempList.add(customLabelsList[j]);
                            }
                            results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                            if(customLabelsList.size()>50){
                                tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                                for(Integer j=40;j<50;j++){
                                    tempList.add(customLabelsList[j]);
                                }
                                results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                                
                                if(customLabelsList.size()>60){
                                    tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                                    for(Integer j=50;j<60;j++){
                                        tempList.add(customLabelsList[j]);
                                    }
                                    results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                                }
                                else{
                                    tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                                    for(Integer n=50;n<customLabelsList.size();n++){
                                        tempList.add(customLabelsList[n]);
                                    }
                                    results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                                }
                            }
                            else{
                                tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                                for(Integer m=40;m<customLabelsList.size();m++){
                                    tempList.add(customLabelsList[m]);
                                }
                                results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                            }
                        }
                        else{
                            tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                            for(Integer l=30;l<customLabelsList.size();l++){
                                tempList.add(customLabelsList[l]);
                            }
                            results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                        }
                    }
                    else{
                        tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                        for(Integer k=20;k<customLabelsList.size();k++){
                            tempList.add(customLabelsList[k]);
                        }
                        results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                    }
                }
                else{
                    tempList=new List<MetaDataUtility.CustomLabelWrapper>();
                    for(Integer k=10;k<customLabelsList.size();k++){
                        tempList.add(customLabelsList[k]);
                    }
                    results.AddAll(MetaDataUtility.upsertCustomLabels(tempList));
                }
            }
            else{
                results.AddAll(MetaDataUtility.upsertCustomLabels(customLabelsList));
            }
        }  
        
        if(CutsomMetadataToUpdate.size() >0){
            customMetadataId=MetaDataUtility.upsertMetadata(CutsomMetadataToUpdate);//Call this method to process the settings via metadata api
        }
        
        if(CutsomSettingToUpdate.size() >0){
            Common_PostSandboxRefreshActivities.processFuture(JSON.Serialize(CutsomSettingToUpdate));
        }
        
        //error processing custom label update and email them with error file Email logic is not working as of now
        /*if(results!=null && results.size() >0){            
           String errorsDt='Hi Team,<br/><br/>Please take a moment to review the batch job failures on class Common_PostprocessingSandboxActivities:<br/>';
           String fileString='Name,Error Details\n';
           
           for(metadataservice.saveresult res:results){
               if(!res.success){
                   fileString+='"'+res.fullName+'",';
                   String errStr='';
                   for(MetadataService.Error err:res.errors){
                       errStr+=err.message;
                   }
                   fileString+='"'+errStr+'"\n';
               }
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
           email.setSubject('Exception while processing class Common_PostprocessingSandboxActivities for custom labels');
           email.setOrgWideEmailAddressId(orgWideAddress.id);
           email.setToAddresses( new String[] {Userinfo.getUserEmail(),'kumaresan.m@smaartt.com'});
           email.setHTMLBody(errorsDt);
           emailList.add(email);
        }
        
        if(emailList.size() >0){
            System.enqueueJob(new Common_PostRefreshErrorEmailQueuable(emailList));
        }
        */
        
        //3. Process common scheduled jobs for all sandbox to alter email/phone fields of contact, account, lead objects.
        //Note: configure the fields on a object to alter (only email & phone field type supported)        
        //schedule the batch job in next 3rd mins & abort the scheduled job
        Datetime targettedTime=Datetime.now().addMinutes(3);
        String timeStr=String.ValueOf(targettedTime.Second())+' '+String.ValueOf(targettedTime.Minute())+' '+String.ValueOf(targettedTime.Hour())+' * * ?';
        System.schedule('Lead Cleanup',timeStr,new Common_ScheduleSandboxRefreshBatch('Lead',new Set<String>{'email','ETSALES_Company_Email__c','MobilePhone','Phone'})); //add related email & phone field type fields which we would like to mask/alter
        
        //schedule the batch job in next 6th mins & abort the scheduled job         
        targettedTime=Datetime.now().addMinutes(6);
        timeStr=String.ValueOf(targettedTime.Second())+' '+String.ValueOf(targettedTime.Minute())+' '+String.ValueOf(targettedTime.Hour())+' * * ?';
        System.schedule('Contact Cleanup',timeStr,new Common_ScheduleSandboxRefreshBatch('Contact',new Set<String>{'email','mobilephone','phone','AssistantPhone','HomePhone','OtherPhone','ETSales_Phone__c'})); //add related email & phone field type fields which we would like to mask/alter
        
        //schedule the batch job in next 9th mins & abort the scheduled job
        targettedTime=Datetime.now().addMinutes(9);
        timeStr=String.ValueOf(targettedTime.Second())+' '+String.ValueOf(targettedTime.Minute())+' '+String.ValueOf(targettedTime.Hour())+' * * ?';
        System.schedule('Account Cleanup',timeStr,new Common_ScheduleSandboxRefreshBatch('Account',new Set<String>{'ETSALES_Company_Email__c','ETST_Coordinator_Email__c','ETSALES_Email__c','ETSALES_Parents_Email__c','Phone','ETST_Emergency_Contact__c','ETIN_Mobile_Number__c','ETIN_Office_Number__c'})); //add related email & phone field type fields which we would like to mask/alter
    }
    
    global static List<List<String>> parseCSV(String contents,Boolean skipHeaders)
    {
        List<List<String>> allFields = new List<List<String>>();
    
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        contents = contents.replaceAll('""','DBLQT');
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try {
            lines = contents.split('\n');
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        Integer num = 0;
        for(String line : lines) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            
            for(String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"').replaceAll('"',''));//added newly 
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                }
            }
            allFields.add(cleanFields);
        }
        if (skipHeaders) allFields.remove(0);
        return allFields;       
    }
 
    global static list<sObject> csvTosObject(List<List<String>> parsedCSV, string objectType,String currentOrgSandboxName,Map<String,String> existingDataMap,Map<String,Id> profileNameIdMap)
    {
        Schema.sObjectType objectDef = Schema.getGlobalDescribe().get(objectType).getDescribe().getSObjectType();
        schema.SObjectType sobjType = Schema.getGlobalDescribe().get(objectType);
        Map<String, Schema.sObjectField> sObjectFields = sobjType.getDescribe().fields.getMap();
        
        list<sObject> objects = new list<sObject>();
        list<string> headers = new list<string>();
        
        for(list<string> row : parsedCSV)
        {
            for(string col : row)
            {
                headers.add(col);
            }
            break;
        }
        system.debug('========================= File Column Headers');
        system.debug(headers);
            
        integer rowNumber = 0;
        for(list<string> row : parsedCSV)
        {
            system.debug('========================= Row Index' + rowNumber);
            if(rowNumber == 0)
            {
                rowNumber++;
                continue;
            }
            else
            {
                sObject thisObj = objectDef.newSobject();
                integer colIndex = 0;
                Boolean allowRowToAddCheck1=false;
                Boolean allowRowToAddCheck2=false;
                for(string col : row)
                {                   
                    string headerName = headers[colIndex].trim();
                    
                    if(colIndex ==0 && headerName=='Sandbox Name' && col==currentOrgSandboxName){
                        allowRowToAddCheck1=true;
                        colIndex++;
                        continue;
                    }
                    if(colIndex ==1 && (headerName=='Metadata Object API Name' || headerName=='Custom Setting API Name') && col==objectType){
                        allowRowToAddCheck2=true;
                        colIndex++;
                        continue;
                    }
                    
                    if(allowRowToAddCheck1 && allowRowToAddCheck2 && colIndex>=2 && headerName.length() > 0)//we are only processing columns starting from column 3
                    {         
                        try
                        {         
                            
                            Object value=col.trim();              
                            if(headerName!='SetupOwner'){
                                Schema.DisplayType valueType = sObjectFields.get(headerName).getDescribe().getType();
                                if (valueType != Schema.DisplayType.String)
                                {
                                    String svalue = (String)value;
                                    if (valueType == Schema.DisplayType.Date)
                                        value = Date.valueOf(svalue);
                                    else if(valueType == Schema.DisplayType.DateTime) {
                                        //DateTime is a special case which we need to handle carefully. It is working in my case you need to handle it.
                                        try{
                                            String d1 = svalue;
                                            list<String> d2 = d1.split('-');
                                            list<integer> timeComponent = new list<integer>();
                                            timeComponent.add(Integer.valueOf(d2[0]));
                                            timeComponent.add(Integer.valueOf(d2[1]));
                                            timeComponent.add(Integer.valueOf(d2[2].left(2)));
                                        
                                            String t = d2[2].substringBetween('T','.');
                                        
                                            list<String> time1 = t.split(':');
                                            timeComponent.add(Integer.valueOf(time1[0]));
                                            timeComponent.add(Integer.valueOf(time1[1]));
                                            timeComponent.add(Integer.valueOf(time1[2]));
                                        
                                            Datetime dt = Datetime.newInstance(timeComponent[0],timeComponent[1],timeComponent[2],timeComponent[3],timeComponent[4],timeComponent[5]);
                                            value = dt;
                                        }
                                        catch(exception ex){}
                                    }
                                    else if (valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency)
                                        value = Decimal.valueOf(svalue);
                                    else if (valueType == Schema.DisplayType.Double)
                                        value = Double.valueOf(svalue);
                                    else if (valueType == Schema.DisplayType.Integer)
                                        value = Integer.valueOf(svalue);
                                    else if (valueType == Schema.DisplayType.Base64)
                                        value = Blob.valueOf(svalue);
                                    else if (valueType == Schema.DisplayType.Boolean)
                                        value = Boolean.valueOf(svalue);
                                    else
                                        value = svalue;
                                }
                                else{
                                    value = value;
                                }                 
                                thisObj.put(headerName,value);           
                            }
                            
                            if(colIndex==2 && existingDataMap!=null && existingDataMap.containsKey((string)value) && existingDataMap.get((string)value)!=null){//This applies to list type custom setting type alone to pull current record Id to update
                                thisObj.put('Id',existingDataMap.get((string)value));
                            }
                            else if(colIndex==2 && profileNameIdMap!=null && profileNameIdMap.containsKey((string)value) && profileNameIdMap.get((string)value)!=null){
                                thisObj.put('SetupOwnerId',profileNameIdMap.get((string)value));
                            }
                        }
                        catch(exception e)
                        {
                            system.debug('============== Invalid field specified in header ' + headerName);                           
                        }
                    }
                    colIndex++;
                } 
                if(allowRowToAddCheck1 && allowRowToAddCheck2){
                    objects.add(thisObj);
                }
                rowNumber++;
            }       
        }
        return objects;
    }
    
    public static list<MetaDataUtility.CustomLabelWrapper> csvToCustomWrapper(List<List<String>> parsedCSV,String currentOrgSandboxName)
    {
        list<MetaDataUtility.CustomLabelWrapper> objects = new list<MetaDataUtility.CustomLabelWrapper>();
        list<string> headers = new list<string>();
        
        for(list<string> row : parsedCSV)
        {
            for(string col : row)
            {
                headers.add(col);
            }
            break;
        }
        system.debug('========================= File Column Headers');
        system.debug(headers);
            
        integer rowNumber = 0;
        for(list<string> row : parsedCSV)
        {
            system.debug('========================= Row Index' + rowNumber);
            if(rowNumber == 0)
            {
                rowNumber++;
                continue;
            }
            else
            {
                MetaDataUtility.CustomLabelWrapper thisObj =new MetaDataUtility.CustomLabelWrapper();
                integer colIndex = 0;
                Boolean allowRowToAddCheck1=false;
                for(string col : row)
                {                   
                    string headerName = headers[colIndex].trim();
                    
                    if(colIndex ==0 && headerName=='Sandbox Name' && col==currentOrgSandboxName){
                        allowRowToAddCheck1=true;
                        colIndex++;
                        continue;
                    }
                    
                    if(allowRowToAddCheck1 && colIndex>=1 && headerName.length() > 0)//we are only processing columns starting from column 3
                    {         
                        try
                        {                       
                            if(headerName=='fullName'){
                                thisObj.fullName=col.trim();
                            }
                            else if(headerName=='shortDescription'){
                                thisObj.shortDescription=col.trim();
                            }
                            else if(headerName=='categories'){
                                thisObj.categories=col.trim();
                            }
                            else if(headerName=='language'){
                                thisObj.language=col.trim();
                            }
                            else if(headerName=='protected_x'){
                                thisObj.protected_x=(String.isNotBlank(col.trim()) ? Boolean.ValueOf(col.trim()) : false);
                            }
                            else if(headerName=='value'){
                                thisObj.value=col.trim();
                            }
                        }
                        catch(exception e)
                        {
                            system.debug('============== Invalid field specified in header ' + headerName);                           
                        }
                    }
                    colIndex++;
                } 
                if(allowRowToAddCheck1){
                    objects.add(thisObj);
                }
                rowNumber++;
            }       
        }
        return objects;
    }
    
    Public Static List<String> queryAllSObjectFields(String SobjectApiName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<String> fieldList=new List<String>();
        
        for(String fieldName : fieldMap.keyset())
        {
            fieldList.add(fieldName);
        }
        return fieldList;
    }
    
    @future(callout=true)
    global static void processFuture(String objListStr){
        if(String.isNotBlank(objListStr)){
            List<Sobject> objList=(List<Sobject>)JSon.Deserialize(objListStr,List<Sobject>.class);
            upsert objList;
        }
    }
}