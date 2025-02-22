public class ET_FederalB2BController {
    public class MyBusinessWrapper{
        @AuraEnabled public List<ET_Sales_Agreement__c> salesAgreementList;
        @AuraEnabled public List<Invoice__c> invoicesList;
        @AuraEnabled public List<Estimation__c> estList;
        public MyBusinessWrapper(){
            salesAgreementList = new List<ET_Sales_Agreement__c>();
            invoicesList = new List<Invoice__c>();
            estList = new List<Estimation__c>();
            
        }
    }
    @AuraEnabled
    public static schoolWrapper getDashboardData() {
        schoolWrapper dashboardWrap=new schoolWrapper();
        try{
            User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
            dashboardWrap.salesCount=[select count() from ET_Sales_Agreement__c 
                                      where Salesforce_Customer__c=:u.AccountId];
            dashboardWrap.invCount=[select count() from Invoice__c 
                                    where Sales_Agreement__r.Salesforce_Customer__c=:u.AccountId];
            dashboardWrap.estCount=[select count() from Estimation__c where Account__c=:u.AccountId];
            
           return   dashboardWrap;   
        }    
        catch (Exception ex) {
            System.debug(ex.getMessage());
            return null;
            
        }
    }
    
    public class schoolWrapper{ 
        @AuraEnabled public Integer salesCount=0; 
        @AuraEnabled public Integer invCount=0; 
        @AuraEnabled public Integer estCount=0; 
        
    }
    
   @AuraEnabled
    public static List<Estimation__c> getEstimationsList(){
        List<Estimation__c> estlist=new List<Estimation__c>();
        User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
         estlist= [select Id, Name,Account__r.Name,Service_Center__c
                                              from Estimation__c where Account__c=:u.AccountId]; 
         
        return estlist;
    }
    
   @AuraEnabled
    public static List<ET_Sales_Agreement__c> getSAList(){
         List<ET_Sales_Agreement__c> SAlist=new List<ET_Sales_Agreement__c>(); 
         User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
         Account Acc=[select id,Name from Account where Id=:u.AccountId];  
         
         SAlist=[select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
                                             Contract_End_Date__c, Contract_No__c, Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
                                             Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
                                             Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
                                             GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                             from ET_Sales_Agreement__c where Salesforce_Customer__c=:u.AccountId];
        
        return SAlist;
    }
    @AuraEnabled
    public static List<Invoice__c> getInvoiceListHelper(){
        User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
        
        return [select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                                       Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                                       Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                                       ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                                       ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                                       Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                                       Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                                       Trx_Number__c, Voucher_Number__c, Zone__c
                                       from Invoice__c where Sales_Agreement__r.Salesforce_Customer__c=:u.AccountId];
    }
    
   

}