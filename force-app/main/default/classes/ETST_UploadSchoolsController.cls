public class ETST_UploadSchoolsController {
    
    public string nameFile {get;set;}
    
    public Blob contentFile {get;set;}
    public blob csvFileBody {get;set;}    
    List<Account> accountList;
    public Id accRecordType;
    public string getbaseUrl(){
        List<contentVersion> template=[select id from contentVersion where Title ='School Data Template' order by versionNumber desc LIMIT 1];
        
        if(template.size()>0 && template !=null){
            Id contentVersionId=template[0].Id;
            return string.valueof(System.URL.getOrgDomainUrl().toExternalForm())+'/sfc/servlet.shepherd/version/download/'+contentVersionId;
            
        }else{
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'You dont have access to the template. Please contact school admin');
            ApexPages.addMessage(errormsg); 
            return null;
        }
        
    }
    // baseUrl = 'test'//URL.getSalesforceBaseUrl();
    List<string> coordinatorList;
    List<string> ParentList;    
    /***This function reads the CSV file and inserts records into the Account object. ***/
    public void ReadFile(){
        try{
            //Convert the uploaded file which is in BLOB format into a string
            nameFile =blobToString(contentFile,'UTF-8');
            
            //Now sepatate every row of the excel file
            List<String> filelines = nameFile.split('\r\n');
            
            accountList=new List<Account>();
            coordinatorList=new List<String>();
            ParentList=new List<String>();  
            accRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId();
            for (Integer i=1;i<filelines.size();i++){
                String[] inputvalues = new String[]{};
                    String[] inputvaluesbyQuote = new String[]{};
                        if(filelines[i].contains('"')){
                            inputvaluesbyQuote=filelines[i].split('"');                            
                            for(String s : inputvaluesbyQuote){
                                if(s.startsWith(',')){
                                    s=s.subString(1);
                                }
                               if(s.countMatches(',') != 1 && s.countMatches(',') != 2){           
                                    List<String> lst2 = new List<String>();
                                    lst2 = s.split(',');
                                    for(String s2 : lst2){                  
                                        inputvalues.add(s2);  
                                    }                                    
                                }else{
                                    inputvalues.add(s.removeEnd(','));
                                     }
                            }
                        }else{
                            inputvalues = filelines[i].split(',');
                        }                
                /*System.debug('inputvalues '+inputvalues[0]+' '+inputvalues[1]+
                            inputvalues[2]+' '+inputvalues[3]+
                            inputvalues[4]+' '+inputvalues[5]+
                            inputvalues[6]+' '+inputvalues[7]+
                             inputvalues[8]+' '+inputvalues[9]+
                            inputvalues[10]+' '+inputvalues[11]);*/
                Account newAcc = new Account();
                newAcc.RecordTypeId = accRecordType;
                if(inputValues[0]==null || inputValues[0]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Regulatory Id should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newAcc.ETST_SchoolRefID__c = inputValues[0];
                if(inputValues[1]==null || inputValues[1]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'School Name should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newAcc.Name = inputValues[1];
                if(inputValues[2]==null || inputValues[2]==''){
                  ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Street should not be blank in row '+(i+1));
                  ApexPages.addMessage(errormsg); 
                  return;  
                }
                newAcc.BillingStreet = inputValues[2];
                if(inputValues[3]==null || inputValues[3]==''){
                  ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'City should not be blank in row '+(i+1));
                  ApexPages.addMessage(errormsg); 
                  return;  
                }
                newAcc.BillingCity = inputValues[3];
                if(inputValues[4]==null || inputValues[4]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'State should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newAcc.BillingState = inputValues[4];
                if(inputValues[5]==null || inputValues[5]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Country should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newAcc.BillingCountry = inputValues[5];
                if(inputValues[7]==null || inputValues[7]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Coordinator Email should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newAcc.ETST_Coordinator_Email__c=inputValues[7];
                if(inputValues[8]==null || inputValues[8]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Contract Id should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                newAcc.ETST_Contract_Id__c=inputValues[8];
                newAcc.Phone = inputValues[9];
                if(inputvalues.size()>10){
                newAcc.Website = inputValues[10];
                }
                if(inputvalues.size()>12){
                    if(inputValues[12]==null || inputValues[12]==''){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'School Type should not be blank in row '+(i+1));
                        ApexPages.addMessage(errormsg); 
                        return;  
                    }else if(inputValues[12]=='University' || inputValues[12]=='Nursery' || inputValues[12]=='Private School' || 
                             inputValues[12]=='Government School' || inputValues[12]=='Chartered School' || inputValues[12]=='Ajyal School' ){
                        newAcc.ETST_Account_Type__c=inputValues[12];
                    }else{
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'School Type accepts only University, Private School, Government School, Chartered School or Ajyal School values. Please check the School Type Value in row '+(i+1));
                        ApexPages.addMessage(errormsg); 
                        return; 
                    }
                    
                }
                
                if(inputvalues.size()>11){
                    if(inputValues[11]!=null && inputValues[11]!='')
                        newAcc.ETST_Parent_School_Id__c=Decimal.valueOf(inputValues[11]);
                    ParentList.add(inputValues[11]);
                }
                
                coordinatorList.add(inputValues[7]);
                accountList.add(newAcc);
            }
            system.debug('accountList***'+accountList);
            String coordinatorProfileId=[select id from profile where name=:System.Label.ETST_Coordinator_ProfileName].Id;
            Map<String,Id> coordinatorIds=new Map<String,Id>();
            for(user u: [select id, email from user where email IN: coordinatorList and profileId=:coordinatorProfileId]){
                coordinatorIds.put(u.email,u.Id);
            }
            
            System.debug('coordinatorIds '+coordinatorIds);
            
            for(Account acc: accountList){
                if(acc.ETST_Coordinator_Email__c!=null && acc.ETST_Coordinator_Email__c!=''
                   && coordinatorIds.get(acc.ETST_Coordinator_Email__c)!=null){
                       System.debug('ETST_Coordinator_Email__c '+coordinatorIds.get(acc.ETST_Coordinator_Email__c));
                       acc.ETST_Coordinator__c=coordinatorIds.get(acc.ETST_Coordinator_Email__c);
                   }else if(coordinatorIds.get(acc.ETST_Coordinator_Email__c)==null)  {
                       ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,acc.ETST_Coordinator_Email__c+'  Coordinator doesnt exist in the System');
                       ApexPages.addMessage(errormsg); 
                       return;
                   }         
            }
            
            system.debug('accountList***'+accountList);
        }
        catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }       
        
        
        try{
            List<string> contractList=new List<string>();
            List<string> schoolIds=new List<string>();
            for (Account acc:accountList){
                if(!contractList.contains(acc.ETST_Contract_Id__c)){
                    contractList.add(acc.ETST_Contract_Id__c);  
                }                
                schoolIds.add(acc.ETST_SchoolRefID__c);
            }
            
            map<string,Id> schoolIdsMap=new map<string,Id>();
            for(Account acc: [select id,ETST_SchoolRefID__c from Account 
                              where ETST_SchoolRefID__c IN :schoolIds]){
                                  schoolIdsMap.put(acc.ETST_SchoolRefID__c,acc.Id);
                                  
                              }
            Map<String,Id> contractIdMap=new Map<String,Id>();
            for(ET_Sales_Agreement__c con: [select id,Contract_No__c from ET_Sales_Agreement__c 
                                            where Contract_No__c IN :contractList]){
                                                contractIdMap.put(con.Contract_No__c,con.Id);
                                            }
            System.debug('schoolIdsMap -->'+schoolIdsMap); 
            
            for (Account acc:accountList){
                if(schoolIdsMap.containsKey(acc.ETST_SchoolRefID__c)){
                    acc.Id=schoolIdsMap.get(acc.ETST_SchoolRefID__c); 
                }                
            } 
            
            upsert accountList; 
            
            System.debug('accountList -->'+accountList);          
            
            
            Map<String,Id> contractIdMapNew=new Map<String,Id>();
            Map<String,Id> parentIds=new Map<String,Id>();
            if(ParentList.size()>0 && ParentList !=null){
            for(Account acc: [select ETST_SchoolRefID__c, Id from Account where ETST_SchoolRefID__c IN: ParentList
                             and  ETST_SchoolRefID__c !=null and ETST_SchoolRefID__c!='']){
                parentIds.put(acc.ETST_SchoolRefID__c,acc.Id);
            }  
            }
            for(Account acc: [select id,ETST_Contract_Id__c from Account 
                              where ETST_Contract_Id__c IN :contractList]){
                                  contractIdMapNew.put(acc.ETST_Contract_Id__c,acc.Id);
                              }
            
            List<ET_Sales_Agreement__c> lstContracts=new List<ET_Sales_Agreement__c> (); 
            for(String contractNo:contractList){
                if(!contractIdMap.containsKey(contractNo)){
                    ET_Sales_Agreement__c contract=new ET_Sales_Agreement__c();
                    contract.Contract_No__c=contractNo;
                    contract.Name=contractNo;
                    contract.Salesforce_Customer__c=contractIdMapNew.get(contractNo);
                    lstContracts.add(contract); 
                }
                
            }
            
            
            try{
                insert lstContracts;
                for(Account acc: accountList){
                    if(acc.ETST_Parent_School_Id__c!=null 
                       && parentIds.get(String.valueOf(acc.ETST_Parent_School_Id__c))!=null){
                           acc.ParentId=parentIds.get(String.valueOf(acc.ETST_Parent_School_Id__c));
                       } 
                }
                update accountList;
                if(accountList.size()>0)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,accountList.size()+' records uploaded successfully'));
            }
            catch (Exception e)
            {
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records '+e.getMessage());
                String msg=e.getMessage();
                System.debug('msg -->'+msg);
                if(msg.contains('DUPLICATES_DETECTED')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'School Details are already existing. Please Check the uplaoding data'));
                }else{
                    ApexPages.addMessage(errormsg);
                }
                
            } 
        }catch(Exception ex){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'There is a problem with Contract data. Please contact School Admin');
            ApexPages.addMessage(errormsg);
        }
        
    }   
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }  
    
}