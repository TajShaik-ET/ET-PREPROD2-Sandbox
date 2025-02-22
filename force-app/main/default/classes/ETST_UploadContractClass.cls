public with sharing class ETST_UploadContractClass {
    
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
        List<ET_Sales_Agreement__c> contractstoupdate;
    //List<Account> accstoupload;
    List<ETST_School__c> schoolstoupdate;
    List<ETST_Price_List__c> pricelisttoUpload;
    
    public string getbaseUrl(){
        List<contentVersion> template=[select id from contentVersion where Title ='Pricelist Template' order by versionNumber desc LIMIT 1];
        if(template.size()>0 && template !=null){
            Id contentVersionId=template[0].Id;
            return string.valueof(System.URL.getOrgDomainUrl().toExternalForm())+'/sfc/servlet.shepherd/version/download/'+contentVersionId;
            
        }else{
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'You dont have access to the template. Please contact school admin');
            ApexPages.addMessage(errormsg); 
            return null;
        }
    }
    
    /***This function reads the CSV file and inserts records into the Pricelist object. ***/
    
    
    public void ReadFile()
    {
        try{
            //Convert the uploaded file which is in BLOB format into a string
            // Blob  contentFile1=EncodingUtil.base64Decode(contentFile);
            nameFile =blobToString( contentFile,'UTF-8');
            
            //Now sepatate every row of the excel file
            filelines = nameFile.split('\n');
            
            //Iterate through every line and create a Account record for each row
            contractstoupdate = new List<ET_Sales_Agreement__c>();
            //accstoupload=new List<Account>();
            schoolstoupdate=new List<ETST_School__c>();
            pricelisttoUpload=new List<ETST_Price_List__c>();
            
            Id SchoolRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_School').getRecordTypeId(); 
            
            for (Integer i=1;i<filelines.size();i++)
            {
                //System.debug('filelines-->'+filelines[i]);
                String[] inputvalues = new String[]{};
                    inputvalues = filelines[i].split(',');
                system.debug(filelines[i] + ' -- '+inputvalues.size());

                // if(inputvalues[2]!=null && inputvalues[2]!=''){
                ETST_Price_List__c price=new ETST_Price_List__c();
                
                if(inputValues[2]==null || inputValues[2]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Contract Id should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_Org_Id__c=inputvalues[0];
                price.ETST_Contract_Id__c=inputvalues[2];
                price.ETST_Contract_Line__c=inputvalues[3];
                if(inputValues[4]==null || inputValues[4]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'School Id should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_School_Ref_Id__c=inputvalues[4];
                price.ETST_School_Name__c=inputvalues[5];
                price.ETST_AR_Customer_number__c=inputvalues[6];
                if(inputValues[8]==null || inputValues[8]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Zone should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                
                price.ETST_Zone__c=inputvalues[8];
                price.ETST_Area__c=inputvalues[9];
                if(inputValues[10]==null || inputValues[10]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Transport Type should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_Transport_Type__c=inputvalues[10];
                if((inputValues[11]==null || inputValues[11]=='') && inputValues[29]=='Parent'){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Yearly Amount should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                if(inputvalues[11]!=null && inputvalues[11]!=''){
                    price.ETST_Fare_Amount__c=decimal.valueOf(inputvalues[11]);
                }
                if((inputValues[12]==null || inputValues[12]=='') && inputValues[29]=='Parent'){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Monthly Amount should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                if(inputvalues[12]!=null && inputvalues[12]!=''){
                    price.ETST_Amount__c=decimal.valueOf(inputvalues[12]);
                }
                if(inputvalues[13]!=null && inputvalues[13]!=''){
                    price.ETST_Discount_Percentage__c=decimal.valueOf(inputvalues[13]);
                }
                if(inputvalues[14]!=null && inputvalues[14]!=''){
                    price.ETST_Half_Yearly_Discount_Percentage__c=decimal.valueOf(inputvalues[14]);
                }
                if(inputvalues[15]!=null && inputvalues[15]!=''){
                    price.ETST_Quarterly_Discount_Percentage__c=decimal.valueOf(inputvalues[15]);
                }
                if(inputvalues[16]!=null && inputvalues[16]!=''){
                    price.ETST_Tax_Percentage__c=decimal.valueOf(inputvalues[16]);
                } 
                if(inputvalues[17]!=null && inputvalues[17]!=''){
                    price.ETST_School_Commission_Value__c=decimal.valueOf(inputvalues[17]);
                } 
                if(inputvalues[18]!=null && inputvalues[18]!=''){
                    price.ETST_School_Commission_Percentage__c=decimal.valueOf(inputvalues[18]);  
                }
                if(inputvalues[19]!=null && inputvalues[19]!=''){
                    price.ETST_Refundable_Percentage__c=decimal.valueOf(inputvalues[19]);
                }
                if(inputvalues[20]!=null && inputvalues[20]!=''){
                    price.ETST_Refund_Value__c=decimal.valueOf(inputvalues[20]); 
                }
                if(inputvalues[21]!=null && inputvalues[21]!=''){
                    price.ETST_Maintenance_Amount__c=decimal.valueOf(inputvalues[21]); 
                }
                if(inputvalues[22]!=null && inputvalues[22]!=''){
                    price.ETST_Other_Deductions_Value__c=decimal.valueOf(inputvalues[22]);
                }  
                if(inputValues[23]==null || inputValues[23]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Contract Start Date should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                if(inputvalues[23]!=null && inputvalues[23]!=''){
                    System.debug('inputvalues[23]'+inputvalues[23]);
                    price.ETST_Contract_Start_Date__c = date.parse(inputvalues[23]);
                }
                if(inputValues[24]==null || inputValues[24]==''){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Contract End Date should not be blank in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                if(inputvalues[24]!=null && inputvalues[24]!=''){
                     System.debug('inputvalues[24]'+inputvalues[24]);
                    price.ETST_Contract_End_Date__c = date.parse(inputvalues[24]); 
                } 
                if(inputValues[25]!='P' && inputValues[25]!='O'){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Monthly Allowed field accepts only P (Yes) or O (No) values in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_Monthly_Allowed__c=inputvalues[25]=='P'?true:false;
                if(inputValues[26]!='P' && inputValues[26]!='O'){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Quarterly Allowed field accepts only P (Yes) or O (No) values in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_Quarterly_Allowed__c=inputvalues[26]=='P'?true:false;
                if(inputValues[27]!='P' && inputValues[27]!='O'){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Half Yearly Allowed field accepts only P (Yes) or O (No) values in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_Half_Yearly_Allowed__c=inputvalues[27]=='P'?true:false;
                if(inputValues[28]!='P' && inputValues[28]!='O'){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Yearly Allowed field accepts only P (Yes) or O (No) values in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_Yearly_Allowed__c=inputvalues[28]=='P'?true:false;
                
                if(inputValues[29]!='School' && inputValues[29]!='Parent' && inputValues[29]!='Group'){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Payee field accepts only School, Parent or Group values in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_Payee__c=inputvalues[29];  
                if(inputValues[30]!='Month' && inputValues[30]!='Day' && inputValues[30]!='None'){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Pro Rate field accepts only Month or Day or None values in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_Pro_Rate__c=inputvalues[30];
                if(inputValues[31]!='P' && inputValues[31]!='O'){
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'On Demand Allowed field accepts only P (Yes) or O (No) values in row '+(i+1));
                    ApexPages.addMessage(errormsg); 
                    return;  
                }
                price.ETST_On_Demand_Allowed__c=inputvalues[31]=='P'?true:false;  
                if(inputvalues.size()>31){
                    if(inputvalues[32]!=null && inputvalues[32]!=''){
                        price.ETST_Min_Duration__c=integer.valueOf(inputvalues[32]);
                    }
                }
                if(inputvalues.size()>32){
                    if(inputvalues[33]!=null && inputvalues[33]!=''){
                        price.ETST_Max_Duration__c=integer.valueOf(inputvalues[33]);
                    }
                }
                if(inputvalues.size()>33){
                    if((inputvalues[34]==null || inputvalues[34]=='' ||
                        inputvalues[34]=='0') && inputvalues[31]=='P' ){
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'On Demand Rate per Day should not be blank in row '+(i+1));
                            ApexPages.addMessage(errormsg); 
                            return; 
                        }
                    
                    system.debug('value***'+inputvalues[34]);
                    if(inputvalues[34]!=null && inputvalues[34]!=''){
                        price.ETST_Ondemand_Rate_per_Day__c=decimal.valueOf(inputvalues[34]);
                    }
                } 
                if(inputvalues.size()>34){
                    if(inputvalues[35]==null || inputvalues[35]==''){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Cheque Payment Allowed should not be blank in row '+(i+1));
                        ApexPages.addMessage(errormsg); 
                        return; 
                    }
                    
                    price.ETST_Cheque_Payment_Allowed__c=inputvalues[35]=='P'?true:false;  
                } 
                if(inputvalues.size()>35){
                    if((inputvalues[36]==null || inputvalues[36]=='') && inputvalues[35]=='P' ){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Courier Address should not be blank in row '+(i+1));
                        ApexPages.addMessage(errormsg); 
                        return; 
                    }
                    
                    price.ETST_Courier_Address__c=inputvalues[36];
                    
                } 
                if(inputvalues.size()>36){
                    if(inputvalues[37]==null || inputvalues[37]=='') {
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Cancellation Mode(Month/Day) should not be blank in row '+(i+1));
                        ApexPages.addMessage(errormsg); 
                        return; 
                    }
                    
                    price.ETST_Cancellation_Mode__c=inputvalues[37];
                    
                } 
                if(inputvalues.size()>37){
                     if(inputvalues[38]==null || inputvalues[38]=='') {
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Courier Address should not be blank in row '+(i+1));
                        ApexPages.addMessage(errormsg); 
                        return; 
                    }
                    
                    price.ETST_Cancellation_Fee__c=decimal.valueOf(inputvalues[38]); 
                    
                } 
                price.ETST_Is_Active__c=true;
                pricelisttoUpload.add(price);
                
            }
        }
        catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records '+e.getMessage());
            String msg=e.getMessage();
            System.debug('msg -->'+msg);
            ApexPages.addMessage(errormsg);
            //if(msg.contains('Invalid date')){
                
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please enter date in the format mm/dd/yyyy'));
            //}else{
            //    ApexPages.addMessage(errormsg);
            //}
        }       
        
        try{
            List<string> contractList=new List<string>();
            List<string> contractIds=new List<string>();
            for (ETST_Price_List__c price:pricelisttoUpload){
                if(!contractList.contains(price.ETST_School_Ref_Id__c)){
                    contractList.add(price.ETST_School_Ref_Id__c);  
                }                
                contractIds.add(price.ETST_School_Ref_Id__c +price.ETST_Transport_Type__c);
            }
            
            System.debug('contractList-->'+contractList);
            Map<String,Id> contractIdMap=new Map<String,Id>();
            for(ET_Sales_Agreement__c con: [select id,name,salesforce_customer__r.ETST_Contract_Id__c from ET_Sales_Agreement__c 
                                            where salesforce_customer__r.ETST_SchoolRefID__c IN :contractList]){
                                                contractIdMap.put(con.Name,con.Id);
                                            }
            if(contractIdMap==null || contractIdMap.size()==0){
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please upload the school data before uploading the price list data');
                ApexPages.addMessage(errormsg); 
                return; 
            }
            
            /*
for(ET_Sales_Agreement__c con: [select id,Contract_No__c from ET_Sales_Agreement__c 
where Contract_No__c IN :contractList]){
contractIdMap.put(con.Contract_No__c,con.Id);
}
List<ET_Sales_Agreement__c> lstContracts=new List<ET_Sales_Agreement__c> (); 
for(String contractNo:contractList){
if(!contractIdMap.containsKey(contractNo)){
ET_Sales_Agreement__c contract=new ET_Sales_Agreement__c();
contract.Contract_No__c=contractNo;
contract.Name=contractNo;
lstContracts.add(contract); 
}

}



try{
insert lstContracts;
}catch(Exception ex){
ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'There is a problem with Contract data. Please contact School Admin');
ApexPages.addMessage(errormsg);
}
//List<Account> accList=[select id,ETST_Contract_Id__c,ETST_SchoolRefID__c from Account where ETST_SchoolRefID__c IN :SchoolList];
//List<ETST_Price_List__c> existingContracts=[select id,ETST_Contract_Id__c from ETST_Price_List__c where ETST_Contract_Id__c IN :contractIds];
*/
            Map<String,Id> contractIdMapNew=new Map<String,Id>();
            List<ETST_Price_List__c> deactivateexisting=new List<ETST_Price_List__c>();
            for(ETST_Price_List__c price:[select id,ETST_Contract_Id__c from ETST_Price_List__c 
                                          where ETST_PriceList_Unique_Id__c IN :contractIds]){
                                              price.ETST_Is_Active__c=false;
                                              deactivateexisting.add(price);
                                          }
            try{
                update deactivateexisting;  
            }catch(Exception e){
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured deactivating the price records'+e.getMessage());
                ApexPages.addMessage(errormsg);
            }
            
            
            
            
            for(ETST_Price_List__c price:pricelisttoUpload){
                if(contractIdMap.containsKey(price.ETST_Contract_Id__c)){
                    price.ETST_Sales_Agreement__c=contractIdMap.get(price.ETST_Contract_Id__c);
                }else{
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please upload the school data before uploading the price list data for School Id: '+price.ETST_School_Ref_Id__c);
                    ApexPages.addMessage(errormsg); 
                    return; 
                    
                }
                
            }
            
            insert pricelisttoUpload;
            if(pricelisttoUpload.size()>0)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Confirm,pricelisttoUpload.size()+' records uploaded successfully'));
        }
        catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }    
        
    }
    
    /**** This function sends back to the visualforce page the list of account records that were inserted ****/ 
    public List<ETST_Price_List__c> getuploadedPricelist()
    {
        if (pricelisttoUpload!= NULL)
            if (pricelisttoUpload.size() > 0)
            return pricelisttoUpload;
        else
            return null;                    
        else
            return null;
    }  
    /**
This function convers the input CSV file in BLOB format into a string
@param input    Blob data representing correct string in @inCharset encoding
@param inCharset    encoding of the Blob data (for example 'ISO 8859-1')
*/
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