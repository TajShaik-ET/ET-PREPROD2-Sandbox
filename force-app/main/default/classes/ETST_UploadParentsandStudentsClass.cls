public with sharing class ETST_UploadParentsandStudentsClass {  
    public string nameFile {get;set;}
    public blob csvFileBody {get;set;}
    List<ETST_Student__c> studentsList;
    List<Account> accountList;
    public Id accParentRecordType;
    public blob studentCSVFileBody {get;set;}
    public string studentCSVFileName {get;set;}
    
    public string getstudentTemplateUrl(){
        List<contentVersion> template=[select id from contentVersion where Title ='Student data template' order by versionNumber desc LIMIT 1];
        if(template.size()>0 && template !=null){
            Id contentVersionId=template[0].Id;
            return string.valueof(System.URL.getOrgDomainUrl().toExternalForm())+'/sfc/servlet.shepherd/version/download/'+contentVersionId;
            
        }else{
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'You dont have access to the template. Please contact school admin');
            ApexPages.addMessage(errormsg); 
            return null;
        }
    }
    
    public string getparentTemplateUrl(){
        List<contentVersion> template=[select id from contentVersion where Title ='Parents data template' order by versionNumber desc LIMIT 1];
        if(template.size()>0 && template !=null){
            Id contentVersionId=template[0].Id;
            return string.valueof(System.URL.getOrgDomainUrl().toExternalForm())+'/sfc/servlet.shepherd/version/download/'+contentVersionId;
            
        }else{
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'You dont have access to the template. Please contact school admin');
            ApexPages.addMessage(errormsg); 
            return null;
        }
    }
    /***This function reads the CSV file and inserts records into the Account object. ***/
    public Pagereference ReadFile(){
        try{
            //Convert the uploaded file which is in BLOB format into a string
            // nameFile=blobToString(contentFile,'UTF-8');
            
            nameFile=csvFileBody.toString();
            //Now sepatate every row of the excel file
            List<String> filelines = nameFile.split('\r\n');
            
            //Iterate through every line and create a Account record for each row
            accountList=new List<Account>();           
            accParentRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
            system.debug('size***'+filelines.size());
            for(Integer i=1;i<filelines.size();i++){
                String[] inputvalues = new String[]{};
                    inputvalues = filelines[i].split(','); 
                Account newAcc = new Account();
                newAcc.RecordTypeId = accParentRecordType;
                system.debug('inputValues***'+inputValues);
                if(inputValues[0] ==null || inputValues[0] ==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'FirstName is Required in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return null; 
                }else { 
                    newAcc.firstName = inputValues[0];
                }  
                if(inputValues[1] ==null || inputValues[1] ==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'LastName is Required in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return null; 
                }else{
                    newAcc.lastName = inputValues[1];
                }  
               // newAcc.firstName = inputValues[0];
               // newAcc.lastName = inputValues[1];
                newAcc.ETST_Gender_AR__c = inputValues[4];
                if(inputValues[5] ==null || inputValues[5] ==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Gender is Required in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return null; 
                }
                newAcc.ETST_Gender__c = inputValues[5];
                // newAcc.ETST_Nationality_AR__c = inputValues[7];
                if(inputValues[7] !=null && inputValues[7] !=''){
                    newAcc.ET_Nationality__c = inputValues[7];
                }
                if(inputValues[8] !=null && inputValues[8] !=''){
                    newAcc.ETST_Date_of_Birth__c = date.parse(inputValues[8]);
                }
                if(inputValues[9] ==null || inputValues[9] ==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Phone is Required in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return null; 
                }
                newAcc.Phone = inputValues[9];
                if(inputValues[10] ==null || inputValues[10] ==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Email Id is Required in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return null; 
                }else{
                    newAcc.PersonEmail = inputValues[10];
                }
                //newAcc.BillingStreet = inputValues[11];
                newAcc.BillingStreet = inputValues[12];
                newAcc.BillingCity = inputValues[13];
                //newAcc.BillingStreet = inputValues[14];
                newAcc.BillingCountry = inputValues[15];
                if( inputvalues.size()>16){
                    if(inputValues[16] ==null || inputValues[16] ==''){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Emirates Id is Required in row '+(i+1));
                        ApexPages.addMessage(errormsg); 
                        return null; 
                    }else{
                        String pEID = '784-[0-9]{4}-[0-9]{7}-[0-9]{1}';
                        Boolean isMatched = pattern.matches(pEID, inputValues[16]);
                        System.debug('pEID format matched: '+isMatched);                
                        if(!isMatched){ 
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter Parent Emirates Id in correct format (784-XXXX-XXXXXXX-X) in row '+(i+1));
                            ApexPages.addMessage(errormsg); 
                            return null;
                        } 
                        newAcc.ET_Emirates_Id__c = inputValues[16];
                    }
                }else{
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Emirates Id is Required in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return null;  
                }
                
                
                accountList.add(newAcc);
            }
            system.debug('accountList***'+accountList);            
            if(accountList.size()>0) {
                insert accountList;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,accountList.size()+' records uploaded successfully'));
            }
        }
        catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records '+e.getMessage());
            String msg=e.getMessage();
            System.debug('msg -->'+msg);
            if(msg.contains('Phone: Phone number should start with &quot;+971&quot; or &quot;971&quot; followed by 9 digits.')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Phone number should start with +971 or 971 followed by 9 digits'));
            }
            if(msg.contains('duplicate value found: ETST_Emirates_Id__c')){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Emirates Id is already existing for one of student in the system. Please Check the uplaoding data'));
              }else if(msg.contains('Invalid date')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter date in the format mm/dd/yyyy'));
            }
            else{
               // ApexPages.addMessage(errormsg);
            }
        }          
        return null;
    }
    /**** This function sends back to the visualforce page the list of account records that were inserted ****/ 
    public List<Account> getuploadedAccounts(){
        if(accountList!= NULL)
            if (accountList.size() > 0)
            return accountList;
        else
            return null;                    
        else
            return null;
    }  
    
    public void readStudentFile(){
        try{
            studentCSVFileName=studentCSVFileBody.toString();
            //Now sepatate every row of the excel file
            List<String> csvFilelines = studentCSVFileName.split('\r\n');       
            //Iterate through every line and create a Account record for each row
            studentsList = new List<ETST_Student__c>();
            List<string> parentEmiratesIds = new List<string>();
            List<string> schoolIds = new List<string>();
            List<String> studentEIDs = new List<String>();
            
            Map<String, Id> parentEIdmap = new Map<String, Id>();
            Map<String, Id> accMap = new Map<String, Id>();
            Map<String, Id> schoolMap = new Map<String, Id>();
            system.debug('size***'+csvFilelines.size());
            for(Integer i=1;i<csvFilelines.size();i++){
                String[] inputvalues = new String[]{};
                    inputvalues = csvFilelines[i].split(',');            
                ETST_Student__c newStudent = new ETST_Student__c();
      
                if(inputValues[0]==null || inputValues[0]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Student First Name should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newStudent.ETST_First_Name__c = inputValues[0];
                
                if(inputValues[1] !=null && inputValues[1] !=''){
                    newStudent.ETST_Middle_Name__c = inputValues[1]; 
                } 
                
                if(inputValues[2]==null || inputValues[2]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Student Last Name should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newStudent.Name = inputValues[2];
                
                if(inputValues[3]==null || inputValues[3]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Student Id should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newStudent.ETST_Student_Id__c = inputValues[3];
                
                if(inputValues[4] !=null && inputValues[4] !=''){
                    newStudent.ETST_Full_Name_AR__c = inputValues[4];
                }
                if(inputValues[5] !=null && inputValues[5] !=''){
                    newStudent.ETST_Phone__c = inputValues[5];
                }
                
                if(inputValues[6]==null || inputValues[6]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Student Emirates Id should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                String sEID = '784-[0-9]{4}-[0-9]{7}-[0-9]{1}';
                Boolean isStudentEIdMatched = pattern.matches(sEID, inputValues[6]);
                System.debug('sEID format matched: '+isStudentEIdMatched);                
                if(!isStudentEIdMatched){ 
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter Student Emirates Id in correct format (784-XXXX-XXXXXXX-X) in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;
                } 
                newStudent.ETST_Emirates_Id__c = inputValues[6];
                studentEIDs.add(newStudent.ETST_Emirates_Id__c);
                
                if(inputValues[7] !=null && inputValues[7] !=''){
                    newStudent.ETST_Email__c = inputValues[7];
                }
                
                if(inputValues[8]==null || inputValues[8]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Student Gender should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newStudent.ETST_Gender__c = inputValues[8];
                
                if(inputValues[9] !=null && inputValues[9] !=''){
                    newStudent.ETST_Gender_AR__c = inputValues[9];
                }
                
                if(inputValues[10]==null || inputValues[10]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Parent Emirates Id should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                String pEID = '784-[0-9]{4}-[0-9]{7}-[0-9]{1}';
                Boolean isMatched = pattern.matches(pEID, inputValues[10]);
                System.debug('pEID format matched: '+isMatched);                
                if(!isMatched){ 
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please enter Parent Emirates Id in correct format (784-XXXX-XXXXXXX-X) in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;
                }          
                newStudent.ETST_ParentEID__c = inputValues[10];          
                parentEmiratesIds.add(inputvalues[10]);
                //newStudent.ETST_Account_Name__c = parentEIdmap.get(inputValues[8]).Id;
                
                if(inputValues[11] !=null && inputValues[11] !=''){
                    newStudent.ETST_Grade__c = inputValues[11];
                }
                
                if(inputValues[12] !=null && inputValues[12] !=''){
                    newStudent.ETST_Division__c = inputValues[12];
                }
                
                if(inputValues[13] !=null && inputValues[13] !=''){
                    newStudent.ETST_Date_of_Birth__c = date.parse(inputValues[13]);
                }
                
                if(inputValues[14]==null || inputValues[14]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'School should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newStudent.ETST_ESIS_No__c = inputValues[14];
                schoolIds.add(inputvalues[14]);
                //newStudent.ETST_School__c = schoolMap.get(inputValues[12]).id;
                if(inputvalues.size()>15){
                    if(inputValues[15] !=null && inputValues[15] !='')
                        newStudent.ETST_Nationality__c = inputValues[15];
                }
                if(inputvalues.size()>16){
                    if(inputValues[16] !=null && inputValues[16] !='')
                        newStudent.ETST_Blood__c = inputValues[16]; 
                }
                // newStudent.ETST_Medical_Condition__c = inputValues[16];           
                studentsList.add(newStudent);
            }
            Map<Id, string> mapStudents = new Map<Id,String>();
            for(ETST_Student__c std : [Select Id, ETST_Emirates_Id__c from ETST_Student__c WHERE ETST_Emirates_Id__c IN:studentEIDs]){
                mapStudents.put(std.Id, std.ETST_Emirates_Id__c);
            }
            if(!mapStudents.isEmpty() && mapStudents.size()>0){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Student Emirates Id already exists '+mapStudents.values());
                    ApexPages.addMessage(errormsg); 
                    return;
            }
            
            for(Account acc : [Select Id,ET_Emirates_Id__c From Account WHERE ET_Emirates_Id__c IN:parentEmiratesIds]){
                parentEIdmap.put(acc.ET_Emirates_Id__c, acc.Id);
            }
            for(Account acc : [Select Id,ETST_SchoolRefID__c From Account WHERE ETST_SchoolRefID__c IN:schoolIds]){
                accMap.put(acc.ETST_SchoolRefID__c,acc.Id);
            }
            for(ETST_School__c acc : [Select Id,Customer__r.ETST_SchoolRefID__c From ETST_School__c WHERE Customer__r.ETST_SchoolRefID__c IN:schoolIds]){
                schoolMap.put(acc.Customer__r.ETST_SchoolRefID__c,acc.Id);
            }
            system.debug('studentsList***'+studentsList);
            for(ETST_Student__c std : studentsList){
                if(accMap.containsKey(std.ETST_ESIS_No__c))
                std.ETST_School__c = accMap.get(std.ETST_ESIS_No__c);
                if(schoolMap.containsKey(std.ETST_ESIS_No__c))
                std.ETST_School_Name__c = schoolMap.get(std.ETST_ESIS_No__c);
                if(parentEIdmap.containsKey(std.ETST_ParentEID__c))
                std.ETST_Account_Name__c = parentEIdmap.get(std.ETST_ParentEID__c);
            }
            insert studentsList;
        	if(studentsList.size()>0)
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm, +studentsList.size()+' Student records uploaded successfully'));
        }catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records '+e.getMessage());
            String msg=e.getMessage();
            System.debug('msg-->'+msg);
            if(msg.contains('Phone: Phone number should start with &quot;+971&quot; or &quot;971&quot; followed by 9 digits.')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Phone number should start with +971 or 971 followed by 9 digits'));
            }
            if(msg.contains('Blood Group: bad value for restricted picklist field')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter valid Blood Group for the students, if you do not know leave it blank or NA.'));
            }
            if(msg.contains('Emirates Id: Please enter Student Emirates Id in correct format')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Emirates Id: Please enter Student Emirates Id in correct format (784-XXXX-XXXXXXX-X)'));
            }
            else if(msg.contains('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Please enter Student Emirates Id in correct format (784-XXXX-XXXXXXX-X): [ETST_Emirates_Id__c]')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Emirates Id: Please enter Student Emirates Id in correct format (784-XXXX-XXXXXXX-X)'));
            }
            else{
                //ApexPages.addMessage(errormsg);
            }
            
        }  
    }
    
    /**** This function sends back to the visualforce page the list of account records that were inserted ****/ 
    public List<ETST_Student__c> getuploadedStudents(){
        if(studentsList!= NULL)
            if(studentsList.size() > 0)
            return studentsList;
        else
            return null;                    
        else
            return null;
    }
}