public class ETIN_EmpInvoiceAllocationCtrl {

    @AuraEnabled
    public static string insertData(String strfromle,string InvRecID){
        String returnresponse ='';
        set<string> EmpIds = new set<string>();
        map<string,string> empIdvsAccId = new map<string,string>();
        List<Employee_Invoice_Allocation__c> EmpAllUpdateList = new List<Employee_Invoice_Allocation__c>();
        //system.debug('strfromle = ' + strfromle);
        List<fieldWrapper> datalist = (List<fieldWrapper>)JSON.deserialize(strfromle, List<fieldWrapper>.class);
        //system.debug('datalist = ' + datalist);
        //system.debug('datalistSize = ' + datalist.size());
       for(fieldWrapper wrapper: datalist){
            
            EmpIds.add(wrapper.EmployeeId);
        }
        if(EmpIds.size()>0){
            
          
            for(Account acc : [select id,ETIN_Employee_Id__c from account where ETIN_Employee_Id__c =:EmpIds limit 50000]){
                empIdvsAccId.put(acc.ETIN_Employee_Id__c,acc.Id);
            }
            
        }
        
        for(fieldWrapper wrapper: datalist){
            
                       
            Employee_Invoice_Allocation__c al =new  Employee_Invoice_Allocation__c();
            al.Annual_Premium__c = wrapper.AnnualPremium;
            al.Claim_Amount__c = wrapper.ClaimAmount;
            al.Effective_Date__c = date.valueOf(wrapper.effectiveDate);
            al.Expiry_Date__c = date.valueOf(wrapper.expiryDate);
            al.Invoice__c = InvRecID;
            al.Membership_Code__c =wrapper.MembershipCode;
            al.Movement__c =wrapper.Movement;
            al.Policy__c=wrapper.Policy;
            if(empIdvsAccId.containsKey(wrapper.EmployeeId)){
              al.Employee__c = empIdvsAccId.get(wrapper.EmployeeId);
            }
                    
            EmpAllUpdateList.add(al);            
        }
        
        if(EmpAllUpdateList.size() > 0){
            try {
                insert EmpAllUpdateList;
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
        public String EmployeeId; 
        public String MembershipCode;        
        public String Movement;         
        public decimal ClaimAmount;  
        public decimal AnnualPremium;
        public String effectiveDate;
        public String expiryDate;
        public String Policy;
    } 
   
}