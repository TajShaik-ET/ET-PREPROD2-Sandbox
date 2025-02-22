public class ETIN_BulkAddResUploadCtrl {
  
    @AuraEnabled
    public static string updateData(String strfromle){
        String returnresponse ='';
        set<string> setRefNumber = new set<string>();
        map<string,string> InsRefNumvsRecId = new map<string,string>();
        List<ETIN_Insurance__c> InsuranceUpdateList = new List<ETIN_Insurance__c>();
        //system.debug('strfromle = ' + strfromle);
        List<fieldWrapper> datalist = (List<fieldWrapper>)JSON.deserialize(strfromle, List<fieldWrapper>.class);
        //system.debug('datalist = ' + datalist);
        //system.debug('datalistSize = ' + datalist.size());
       /* for(fieldWrapper wrapper: datalist){
            
            setRefNumber.add(wrapper.InsRefNumber);
        }
        if(setRefNumber.size()>0){
            
          
            for(ETIN_Insurance__c ins : [select id,Name from ETIN_Insurance__c where name =:setRefNumber]){
                InsRefNumvsRecId.put(ins.Name,ins.Id);
            }
            //system.debug('--Map data--'+InsRefNumvsRecId);
        }*/
        
        for(fieldWrapper wrapper: datalist){
            ETIN_Insurance__c ins =new  ETIN_Insurance__c();
            ins.Ins_External_Id__c = wrapper.InsRefNumber;
            if(string.isNotBlank(wrapper.CardNumber)){
                 ins.Card_Number__c = wrapper.CardNumber;
            }
            if(string.isNotBlank(wrapper.PolicyNumber)){
                 ins.Insurance_Policy_Number__c = wrapper.PolicyNumber;
            }
           
           
            system.debug('1--'+wrapper.InsRefNumber);
            InsuranceUpdateList.add(ins);            
        }
        
        if(InsuranceUpdateList.size() > 0){
            try {
                upsert InsuranceUpdateList Ins_External_Id__c;
                returnresponse = 'SUCCESS';
            }
            catch(Exception ex){
                returnresponse = 'ERROR';
                system.debug('-err-'+ex);
                throw new AuraHandledException('Error-- '+ ex.getMessage());  
            }
        }
        return returnresponse;
    }
    
    public class fieldWrapper{  
        public String InsRefNumber; 
        public String CardNumber;        
        public String PolicyNumber;        
        
        
    } 
    
    /*Renewal Process Update   */   
   @AuraEnabled
    public static string updateRenewalData(String strfromle){
        String returnresponse ='';
        set<string> setRefNumber = new set<string>();
        map<string,string> InsRefNumvsRecId = new map<string,string>();
        List<ETIN_Insurance__c> InsuranceUpdateList = new List<ETIN_Insurance__c>();
        //system.debug('strfromle = ' + strfromle);
        List<fieldWrapperRenewal> datalist = (List<fieldWrapperRenewal>)JSON.deserialize(strfromle, List<fieldWrapperRenewal>.class);
        //system.debug('datalist = ' + datalist);
        //system.debug('datalistSize = ' + datalist.size());
               
        for(fieldWrapperRenewal wrapper: datalist){
            ETIN_Insurance__c ins =new  ETIN_Insurance__c();
            ins.Ins_External_Id__c = wrapper.InsRefNumber;
            if(string.isNotBlank(wrapper.CardNumber)){
                 ins.Card_Number__c = wrapper.CardNumber;
                 ins.Insurance_Current_Status__c ='Active';
                 ins.Status__c ='Completed';
            }
            if(string.isNotBlank(wrapper.PolicyNumber)){
                ins.Insurance_Policy_Number__c = wrapper.PolicyNumber;
            }
            
           
            //system.debug('1--'+wrapper.InsRefNumber);
            InsuranceUpdateList.add(ins);            
        }
        
        if(InsuranceUpdateList.size() > 0){
            try {
                upsert InsuranceUpdateList Ins_External_Id__c;
                returnresponse = 'SUCCESS';
            }
            catch(Exception ex){
                returnresponse = 'ERROR';
                system.debug('-err-'+ex);
                throw new AuraHandledException('Error-- '+ ex.getMessage());  
            }
        }
        return returnresponse;
    }
    
    public class fieldWrapperRenewal{  
        public String InsRefNumber; 
        public String CardNumber;        
        public String PolicyNumber;        
        
        
    } 
}