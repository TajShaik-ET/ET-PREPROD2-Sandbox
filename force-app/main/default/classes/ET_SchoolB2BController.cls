public class ET_SchoolB2BController {
    public class MyBusinessWrapper{
        @AuraEnabled public String cntRecord;
        @AuraEnabled public String accRecord; 
        @AuraEnabled public List<ET_Sales_Agreement__c> salesAgreementList;
        @AuraEnabled public List<SALine_Assigned_Vehicle__c> assignedVehicleList;
        @AuraEnabled public List<SALine_Assigned_Resource__c> assignedResourcesList;
        @AuraEnabled public List<Invoice__c> invoicesList;
        @AuraEnabled public integer schoolsCount=0;
        @AuraEnabled public integer studentsCount=0;
        @AuraEnabled public List<Account> schoolList;
        @AuraEnabled public List<ETST_Student__c> studentsList;
        public MyBusinessWrapper(){
            salesAgreementList = new List<ET_Sales_Agreement__c>();
            assignedVehicleList = new List<SALine_Assigned_Vehicle__c>();
            assignedResourcesList = new List<SALine_Assigned_Resource__c>();
            invoicesList = new List<Invoice__c>();
            studentsList=new List<ETST_Student__c>();
        }
    }
    @AuraEnabled
    public static Account getBusinessType(){
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account acc=[select id,recordtype.developerName,ETST_Account_Type__c from account where id=:u.accountID];
        return acc;//.recordtype.developerName;
    }
    @AuraEnabled
    public static schoolWrapper getDashboardData() {
        schoolWrapper dashboardWrap=new schoolWrapper();
        try{
            User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
            Account Acc=[select id,Name,ETST_Account_Type__c from Account where Id=:u.AccountId];  
            if(Acc.Name=='MINISTRY OF EDUCATION'){
            dashboardWrap.schoolsCount=[select count() from Account where ParentId=:u.AccountId];
            dashboardWrap.studentsCount=[select count() from ETST_Student__c where ETST_School__r.ParentId=:u.AccountId and ETST_Status__c='Active'];
            dashboardWrap.salesCount=[select count() from ET_Sales_Agreement__c where Salesforce_Customer__r.ParentId=:u.AccountId];
            dashboardWrap.vehileCount=[select count() from SALine_Assigned_Vehicle__c 
                                       where Account__r.ParentId=:u.AccountId];
            dashboardWrap.resourceCount=[select count() from SALine_Assigned_Resource__c
                                         where Account__r.ParentId=:u.AccountId];
            dashboardWrap.invCount=[select count() from Invoice__c 
                                    where Sales_Agreement__r.Salesforce_Customer__r.ParentId=:u.AccountId];
            
            }else if(acc.ETST_Account_Type__c=='Government School'){
                dashboardWrap.studentsCount=[select count() from ETST_Student__c where ETST_School__c=:u.AccountId and ETST_Status__c='Active'];
                dashboardWrap.vehileCount=[select count() from SALine_Assigned_Vehicle__c 
                                           where Account__c=:u.AccountId];
                dashboardWrap.resourceCount=[select count() from SALine_Assigned_Resource__c
                                             where Account__c=:u.AccountId];
                 
            }else if(acc.ETST_Account_Type__c=='Private School'){
                dashboardWrap.salesCount=[select count() from ET_Sales_Agreement__c 
                                          where Salesforce_Customer__c=:u.AccountId];
                dashboardWrap.invCount=[select count() from Invoice__c 
                                    where Sales_Agreement__r.Salesforce_Customer__c=:u.AccountId];
                dashboardWrap.studentsCount=[select count() from ETST_Student__c where ETST_School__c=:u.AccountId and ETST_Status__c='Active'];
                dashboardWrap.vehileCount=[select count() from SALine_Assigned_Vehicle__c 
                                           where Account__c=:u.AccountId];
                dashboardWrap.resourceCount=[select count() from SALine_Assigned_Resource__c
                                             where Account__c=:u.AccountId];
                 
            }
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
        @AuraEnabled public Integer studentsCount=0; 
        @AuraEnabled public Integer schoolsCount=0; 
        @AuraEnabled public Integer vehileCount=0; 
        @AuraEnabled public Integer resourceCount=0; 
        
    }
    
    @AuraEnabled
    public static List<ETST_Student__c> getStudentList(){
        List<ETST_Student__c> studentList=new List<ETST_Student__c>();
        User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        if(Acc.Name=='MINISTRY OF EDUCATION'){
            studentList= [select id,Name,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c from ETST_Student__c 
                                     where ETST_School__r.ParentId=:u.AccountId and ETST_Status__c='Active'];
        }else{
            studentList= [select id,Name,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c from ETST_Student__c 
                                     where ETST_School__c=:u.AccountId and ETST_Status__c='Active'];  
        } 
        return studentList;
    }
    @AuraEnabled
    public static List<SALine_Assigned_Vehicle__c> getvehicleList(){
        List<SALine_Assigned_Vehicle__c> vehiclelist=new List<SALine_Assigned_Vehicle__c>();
        User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        if(Acc.Name=='MINISTRY OF EDUCATION'){        
         vehiclelist= [select Id, Name,Sales_Agreement__r.Name, Assign_Start_Date__c,
                                              Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c, Vehicle_Description__c, Vehicle_Number__c
                                              from SALine_Assigned_Vehicle__c where Account__r.ParentId=:u.AccountId];
        }else{
          vehiclelist= [select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c,
                                              Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c, Vehicle_Description__c, Vehicle_Number__c
                                              from SALine_Assigned_Vehicle__c where Account__c=:u.AccountId]; 
        }
        return vehiclelist;
    }
    
    @AuraEnabled
    public static List<SALine_Assigned_Resource__c> getResourceList(){
        List<SALine_Assigned_Resource__c> resoucelist=new List<SALine_Assigned_Resource__c>();
        User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        if(Acc.Name=='MINISTRY OF EDUCATION'){        
         resoucelist=[select Id,Name,Sales_Agreement__r.Name,  Assign_Start_Date__c,
                                                ETST_Assigned_Vehicle__c, Employee_ID__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                                                from SALine_Assigned_Resource__c  where Account__r.ParentId=:u.AccountId];
        }else{
          resoucelist=[select Id,Name,Sales_Agreement__r.Name,  Assign_Start_Date__c,
                                                ETST_Assigned_Vehicle__c, Employee_ID__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                                                from SALine_Assigned_Resource__c  where Account__c=:u.AccountId];
          
        }
        return resoucelist;
    }
    
    @AuraEnabled
    public static List<ET_Sales_Agreement__c> getSAList(){
         List<ET_Sales_Agreement__c> SAlist=new List<ET_Sales_Agreement__c>(); 
         User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
         Account Acc=[select id,Name from Account where Id=:u.AccountId];  
         if(Acc.Name=='MINISTRY OF EDUCATION'){        
         SAlist=[select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
                                             Contract_End_Date__c, Contract_No__c, Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
                                             Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
                                             Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
                                             GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                             from ET_Sales_Agreement__c where Salesforce_Customer__r.ParentId=:u.AccountId]   ;
            }
        else{
            SAlist=[select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
                                             Contract_End_Date__c, Contract_No__c,  Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
                                             Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
                                             Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
                                             GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                             from ET_Sales_Agreement__c where Salesforce_Customer__c=:u.AccountId];
        } 
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
    @AuraEnabled
    public static List<Account> getSchoolList(){
        User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
        return [select Id,Name,AccountNumber,ETST_Account_Type__c,ETST_SchoolRefID__c from Account where ParentId=:u.AccountId];
    }
    
    /*@AuraEnabled
    public static MyBusinessWrapper getUserAccountDetails(){
        List<Id> salesAgreementIdList = new List<Id>();
        MyBusinessWrapper businessWrapper = new MyBusinessWrapper();
        Id userId = UserInfo.getUserId();
        
        User u = [select id, AccountId,contactId from User where id = : userId];
        Id getContactId = u.contactId;
        system.debug('getContactId ' + getContactId);
        
        businessWrapper.schoolsCount=[select count() from Account where ParentId=:u.AccountId];
        businessWrapper.studentsCount=[select count() from ETST_Student__c where ETST_School__c=:u.AccountId and ETST_Status__c='Active'];
        Account communityUserAccount =[select Id,Name from account where Id=:u.AccountId];
        system.debug('communityUserAccount ' + communityUserAccount);
        businessWrapper.cntRecord=getContactId;//communityUserContact.id;
        businessWrapper.accRecord=communityUserAccount.id;
        businessWrapper.studentsList=[select id,Name,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c   from ETST_Student__c 
                                     where ETST_School__c=:u.AccountId and ETST_Status__c='Active'];
        businessWrapper.salesAgreementList =[select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
                                             Contract_End_Date__c, Contract_No__c, Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
                                             Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
                                             Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
                                             GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                             from ET_Sales_Agreement__c where Salesforce_Customer__c=:communityUserAccount.Id ORDER BY Name ];
        
        for(ET_Sales_Agreement__c sg : businessWrapper.salesAgreementList){
            salesAgreementIdList.add(sg.Id);
        }   
        system.debug('salesAgreementIdList '+salesAgreementIdList);
        businessWrapper.assignedVehicleList =[select Id, Name,Sales_Agreement__r.Name, Assign_End_Date__c, Assign_Start_Date__c,
                                              Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c, Vehicle_Description__c, Vehicle_Number__c
                                              from SALine_Assigned_Vehicle__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapper.assignedResourcesList =[select Id,Name,Sales_Agreement__r.Name, Assign_End_Date__c, Assign_Start_Date__c,
                                                ETST_Assigned_Vehicle__c, Employee_ID__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                                                from SALine_Assigned_Resource__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapper.invoicesList =[select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                                       Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                                       Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                                       ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                                       ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                                       Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                                       Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                                       Trx_Number__c, Voucher_Number__c, Zone__c
                                       from Invoice__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        system.debug(' businessWrapper = '+businessWrapper);
        return businessWrapper;
    }*/
    
    
}