public class GIN_InsuranceLinesInsertHandler {
 @AuraEnabled
    public static string insertData(String strfromle,string recordID){
        
        String returnresponse ='';
        map<string,string> empIdvsAccId = new map<string,string>();
        set<string> empIdList = new set<string>();
        list<Insurance_Line_Item__c> listLines = new list<Insurance_Line_Item__c>();
        
        
        system.debug('strfromle = ' + strfromle);
        List<fieldWrapper> datalist = (List<fieldWrapper>)JSON.deserialize(strfromle, List<fieldWrapper>.class);
       system.debug('datalist = ' + datalist);
        
        for(fieldWrapper wrapper: datalist){
            
            empIdList.add(wrapper.FinanceNumber);
        }
        
        if(empIdList.size()>0){
            
          
            for(Account acc : [select id,ETIN_Employee_Id__c from Account where ETIN_Employee_Id__c =:empIdList limit 50000]){
                empIdvsAccId.put(acc.ETIN_Employee_Id__c,acc.Id);
            }
            
        }
        for(fieldWrapper wrapper: datalist){
            Insurance_Line_Item__c line = new Insurance_Line_Item__c();
                           
             if(empIdvsAccId.containsKey(wrapper.FinanceNumber)){
                   line.Employee__c = empIdvsAccId.get(wrapper.FinanceNumber);
                   line.General_Insurance_Policy__c =recordID;
                   line.Insurance_Limit__c = wrapper.InsuranceLimit;
                 
                 listLines.add(line);
              }
            
        }
        
        if(listLines.size() > 0){
            try {
                insert listLines;
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
        
        public decimal InsuranceLimit;  
        public String FinanceNumber;
        
    } 
    
    @AuraEnabled
    public static list<Insurance_Line_Item__c> getInsLinesData(string recordID){
        
        return [select Name,Employee__r.Name,Job_Title__c,Finance_No__c,Monthly_Salary__c,Zone__c,Insurance_Limit__c from Insurance_Line_Item__c  where Employee__c !=null AND General_Insurance_Policy__c=:recordID];
        
    }
   
     @AuraEnabled
    public static string insertDataWorkComp(String strfromle,string recordID){
         
        String returnresponse ='';
        map<string,string> empIdvsAccId = new map<string,string>();
        set<string> empIdList = new set<string>();
        list<Insurance_Line_Item__c> listLines = new list<Insurance_Line_Item__c>();
        
        
        system.debug('strfromle = ' + strfromle);
        List<workCmpWrapper> datalist = (List<workCmpWrapper>)JSON.deserialize(strfromle, List<workCmpWrapper>.class);
       system.debug('datalist = ' + datalist);
        
        for(workCmpWrapper wrapper: datalist){
            
            empIdList.add(wrapper.FinanceNumber);
        }
        
        if(empIdList.size()>0){
            
          
            for(Account acc : [select id,ETIN_Employee_Id__c from Account where ETIN_Employee_Id__c =:empIdList limit 50000]){
                empIdvsAccId.put(acc.ETIN_Employee_Id__c,acc.Id);
            }
            
        }
        for(workCmpWrapper wrapper: datalist){
            Insurance_Line_Item__c line = new Insurance_Line_Item__c();
                           
             if(empIdvsAccId.containsKey(wrapper.FinanceNumber)){
                   line.Employee__c = empIdvsAccId.get(wrapper.FinanceNumber);
                   line.General_Insurance_Policy__c =recordID;
                                  
                 listLines.add(line);
              }
            
        }
        
        if(listLines.size() > 0){
            try {
                insert listLines;
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
    public class workCmpWrapper{  
              
        public String FinanceNumber;
        
    } 
    @AuraEnabled
    public static string insertMoneyPolicyUnderInsReq(String strfromle,string recordID,string requestType,string policyId){
        
         String returnresponse ='';
        map<string,string> empIdvsAccId = new map<string,string>();
        set<string> empIdList = new set<string>();
        list<Insurance_Line_Item__c> listLines = new list<Insurance_Line_Item__c>();
        
        
        system.debug('strfromle = ' + strfromle);
        List<fieldWrapperMoneyPolicyUnderIns> datalist = (List<fieldWrapperMoneyPolicyUnderIns>)JSON.deserialize(strfromle, List<fieldWrapperMoneyPolicyUnderIns>.class);
       system.debug('datalist = ' + datalist);
        
        for(fieldWrapperMoneyPolicyUnderIns wrapper: datalist){
            
            empIdList.add(wrapper.FinanceNumber);
        }
        
        if(empIdList.size()>0){
            
          
            for(Account acc : [select id,ETIN_Employee_Id__c from Account where ETIN_Employee_Id__c =:empIdList limit 50000]){
                empIdvsAccId.put(acc.ETIN_Employee_Id__c,acc.Id);
            }
            
        }
        for(fieldWrapperMoneyPolicyUnderIns wrapper: datalist){
            Insurance_Line_Item__c line = new Insurance_Line_Item__c();
                           
             if(empIdvsAccId.containsKey(wrapper.FinanceNumber)){
                   line.Employee__c = empIdvsAccId.get(wrapper.FinanceNumber);
                   line.General_Insurance_Policy__c =policyId;
                   line.Insurance_Request__c =recordID;
                   line.Action__c = requestType;
                   line.Insurance_Limit__c = wrapper.InsuranceLimit;
                 
                 listLines.add(line);
              }
            
        }
        
        if(listLines.size() > 0){
            try {
                insert listLines;
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
     public class fieldWrapperMoneyPolicyUnderIns{  
        
        public decimal InsuranceLimit;  
        public String FinanceNumber;
        
    } 
     @AuraEnabled
    public static list<Insurance_Line_Item__c> getInsLinesByInsReqId(string recordID){
        
        return [select Name,Employee__r.Name,Job_Title__c,Finance_No__c,Monthly_Salary__c,Zone__c,Insurance_Limit__c from Insurance_Line_Item__c  where Employee__c !=null AND Insurance_Request__c=:recordID];
        
    }
    
     @AuraEnabled
    public static string insertDataWorkCompUnderInsReq(String strfromle,string recordID,string requestType,string policyId){
         
        String returnresponse ='';
        map<string,string> empIdvsAccId = new map<string,string>();
        set<string> empIdList = new set<string>();
        list<Insurance_Line_Item__c> listLines = new list<Insurance_Line_Item__c>();
        
        
        system.debug('strfromle = ' + strfromle);
        List<workCmpInsReqWrapper> datalist = (List<workCmpInsReqWrapper>)JSON.deserialize(strfromle, List<workCmpInsReqWrapper>.class);
       system.debug('datalist = ' + datalist);
        
        for(workCmpInsReqWrapper wrapper: datalist){
            
            empIdList.add(wrapper.FinanceNumber);
        }
        
        if(empIdList.size()>0){
            
          
            for(Account acc : [select id,ETIN_Employee_Id__c from Account where ETIN_Employee_Id__c =:empIdList limit 50000]){
                empIdvsAccId.put(acc.ETIN_Employee_Id__c,acc.Id);
            }
            
        }
        for(workCmpInsReqWrapper wrapper: datalist){
            Insurance_Line_Item__c line = new Insurance_Line_Item__c();
                           
             if(empIdvsAccId.containsKey(wrapper.FinanceNumber)){
                   line.Employee__c = empIdvsAccId.get(wrapper.FinanceNumber);
                   line.General_Insurance_Policy__c =policyId;
                   line.Insurance_Request__c = recordID;
                   line.Action__c = requestType;
                                  
                 listLines.add(line);
              }
            
        }
        
        if(listLines.size() > 0){
            try {
                insert listLines;
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
    public class workCmpInsReqWrapper{  
              
        public String FinanceNumber;
        
    } 
}