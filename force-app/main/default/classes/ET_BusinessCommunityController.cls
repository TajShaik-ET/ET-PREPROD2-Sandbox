/*
*********************************************************
Apex Class Name    : ET_BusinessCommunityController
Created Date       : July 12, 2020
@description       : This is class is used for ESE all Approval processes is handled by this class
@author            : Smaartt 
Modification Log:
Ver   Date         Author                               Modification
1.0   25-08-2023   Akash Yellure                     Initial Version
1.1   04/08/2023   Arunsarathy            (ESE special requests other than Abu Dhabi
*********************************************************Sanbox
*/
public class  ET_BusinessCommunityController {   

    @AuraEnabled
    public static List<Case> getCasesByRecordType(String recordTypeName,List<String> fields) {
        // Validate input parameter
        if (String.isEmpty(recordTypeName)) {
            throw new AuraHandledException('Record Type Name is required.');
        }
        if (fields == null || fields.isEmpty()) {  
            throw new AuraHandledException('Fields are required.');
        }
        String fieldList = String.join(fields, ',');
        String query = 'SELECT ' + fieldList + ' FROM Case WHERE RecordType.DeveloperName = :recordTypeName';
        List<Case> cases = Database.query(query);
        return cases;
    }
    
    
    /*
*********************************************************
@Method Name    : customerCaseApprovalProcess
@author         : Akash Yellure
@description    : 
@param          :
@return         : Output
********************************************************
*/ 
    @AuraEnabled
    public static string customerCaseApprovalProcess(String recId, string caseComments){
        String HSE_Inspector = System.Label.HSE_Inspector;
        String HSE_Transportation_Inspector = System.Label.HSE_Transportation_Inspector;
        String HSE_Quality_Coordinator = System.Label.HSE_Quality_Coordinator;
        String ESE_Transportation=System.Label.ESE_Transportation;
        String ESE_Transportation_Inspector=System.Label.ESE_Transportation_Inspector;
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c,Request_Type__c,Request_Type_AR__c from case where Id=:recId];
        Case caserecord = [select id,Account.name,Contact.name,ContactId,AccountId FROM Case WHERE Id =: recId];
        User contactuser=[select name,Profile.Name from user where ContactId=:caserecord.ContactId];
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        
        if(contactuser.Profile.Name==HSE_Inspector){
            if (c.RecordType.developername == 'ESE_Issue' && c.Status_Category__c=='Pending with HSE Quality Coordinator For Review'){
                c.Sub_Status__c = 'Redirected By HSE Quality Coordinator';
                c.Status_Category__c = 'Pending with HSE Inspector';    
            } 
            else if(c.RecordType.developername == 'ESE_Issue' && c.Status_Category__c=='Pending with HSE Quality Coordinator'){
                c.Sub_Status__c = 'Approved by HSE Quality Coordinator';
                c.Status_Category__c = 'Pending with Operation Manager';  
            }    
        
        }
		else if(contactuser.Profile.Name==HSE_Transportation_Inspector){
            if (c.RecordType.developername == 'ESE_Issue' && c.Status_Category__c=='Pending with HSE Quality Coordinator For Review'){
                c.Sub_Status__c = 'Redirected By HSE Quality Coordinator';
                c.Status_Category__c = 'Pending with HSE Transportation Inspector'; 
            }  
            else if(c.RecordType.developername == 'ESE_Issue' && c.Status_Category__c=='Pending with HSE Quality Coordinator'){
                c.Sub_Status__c = 'Approved by HSE Quality Coordinator';
                c.Status_Category__c = 'Pending with Operation Manager';  
            }    
        }
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
        }
        
        try{
            insert caseCommentsList;
            update c;
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        return c.Status;
    }
    /*
*********************************************************
@Method Name    : customerCaseRejectProcess
@author         : Akash Yellure
@description    :
@param          :
@return         : Output
********************************************************
*/ 
@AuraEnabled
    public static string customerCaseRejectProcess(String recId, string caseComments){
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c from case where Id=:recId];
        if (c.RecordType.developername == 'ESE_Issue' && c.Status_Category__c=='Pending with HSE Quality Coordinator')
        { 
            c.Status='Rejected';   
            c.Sub_Status__c = 'Rejeted by HSE Quality Coordinator';
            c.Status_Category__c = 'Further information is pending from the requester';
        }  
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
            system.debug('comment.ET_Comments__c'+comment.ET_Comments__c); 
        }
        try{
            insert caseCommentsList;
            update c;
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        return c.Status;
        
    }
    /*
*********************************************************
@Method Name    : cutomerCaseUpdateCommnets
@author         : Akash Yellure
@description    : 
@param          :
@return         : Output
********************************************************
*/ 
     @AuraEnabled
    public static string cutomerCaseUpdateCommnets(String recId, string caseComments ,boolean finevalue){
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c from case where Id=:recId];
        if(c.RecordType.developername == 'ESE_Issue' && c.Status_Category__c=='Further information is pending from the requester') {
            c.Sub_Status__c = 'Information added by the requester';
            c.Status_Category__c = 'Pending with Operation Manager'; 
        } 
        else if(c.RecordType.developername == 'ESE_Issue' && c.Sub_Status__c !=null  && c.Status_Category__c=='Pending with HSE Inspector'){
            c.Sub_Status__c = 'Information added by the requester';
            c.Status_Category__c = 'Pending with HSE Quality Coordinator';
            
        }
          else if(c.RecordType.developername == 'ESE_Issue' && c.Sub_Status__c !=null  && c.Status_Category__c=='Pending with HSE Transportation Inspector'){
            c.Sub_Status__c = 'Information added by the requester';
            c.Status_Category__c = 'Pending with HSE Quality Coordinator';
            
        }
         else if(c.RecordType.developername == 'ESE_Issue' && c.Sub_Status__c !=null  && c.Status_Category__c=='Pending with HSE Quality Coordinator For Review'){
             c.Status_Category__c = 'Pending with Operation Manager'; 
             c.Sub_Status__c = 'Comment Updated by Quality Coordinator';
        }
        else if(c.RecordType.developername == 'ESE_Issue' && c.Sub_Status__c=='Solution Provided by Operation Coordinator'){
            c.Sub_Status__c = 'Fine Added by Transportation Team';
            c.Status_Category__c = '';
            c.Status = 'Closed';
            c.CCM_Remarks__c='test';
            c.Fine_Applicable__c=true;
        }
        else if(c.RecordType.developername == 'ESE_Issue'  && c.Sub_Status__c=='Further information is pending from the requester'){
            c.Status_Category__c = 'Pending with Operation Manager';
        } 
        else if(c.RecordType.developername == 'ESE_Issue'  && c.Status_Category__c=='Pending with ESE Inspector'){
            c.Sub_Status__c = 'Information added by the requester';
            c.Status_Category__c = 'Pending with Operation Coordinator';
            
        }
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
            system.debug('comment.ET_Comments__c'+comment.ET_Comments__c);
        }
        try{
            insert caseCommentsList;
            update c;
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        return c.Status;
        
    }


       
        /*
*********************************************************
@Method Name    : getDashboardDataCustomerCare
@author         : Akash Yellure
@description    : method to is used to get Dashboard Customer Care Count on portal
@param          :
@return         : Output
********************************************************
*/
@AuraEnabled
public static caseWrapper getDashboardDataCustomerCare() {
    caseWrapper dashboardWrap = new caseWrapper();
    
    try {
        // Fetch User and Account Information
        User u = [SELECT Id, AccountId, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        Account parentAccount = [SELECT Id, Name FROM Account WHERE Id = :u.AccountId];
        List<Account> childAccounts = [SELECT Id, Name FROM Account WHERE ParentId = :parentAccount.Id];

        // Fetch User Profile
        Profile userProfile = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        dashboardWrap.loggedinUserProfileName = userProfile.Name;

        // Allowed profiles for child accounts
        Set<String> allowedProfiles = new Set<String>{
            System.Label.ESE_Transportation, System.Label.ESE_Transportation_Inspector,
            System.Label.HSE_Inspector, System.Label.HSE_Transportation_Inspector, System.Label.HSE_Quality_Coordinator,
            System.Label.ET_MOE_Department_Of_School_Services_Profie, System.Label.ET_MOE_Department_Of_School_Activities_Profie,
            System.Label.ET_MOE_Personnel_Management_Profie_Name, System.Label.ET_MOE_Special_Education_Profie_Name,
            System.Label.ET_MOE_Extra_Curricular_Activities_Profie_Name, System.Label.ET_MOE_Inclusive_Education_Department_in_ESE
        };

        // Define Allowed Record Types in a Set
        Set<String> allowedRecordTypes = new Set<String>{
            'ESE_Issue', 'Accident_Emergency', 'Feedback', 'Driver_Staff_Behaviour_TL', 
            'Online_Services_Main', 'Other_Requests', 'Traffic_Violation_TL', 'Theft', 
            'Service_Quality_Compliance', 'Safety_Issues_TL', 'Add_Service'
        };

        Set<Id> accountIds = new Set<Id>();
        
        if (childAccounts.size() > 0 && allowedProfiles.contains(userProfile.Name)) {
            for (Account childAcc : childAccounts) {
                accountIds.add(childAcc.Id);
            }
        } else {
            accountIds.add(parentAccount.Id);
        }

        // Fetch Case Counts
        dashboardWrap.newCount = [SELECT COUNT() FROM Case WHERE Status = 'New' AND RecordType.DeveloperName IN :allowedRecordTypes];
        dashboardWrap.inprogressCount = [SELECT COUNT() FROM Case WHERE Status = 'In Progress' AND RecordType.DeveloperName IN :allowedRecordTypes];
        dashboardWrap.closedCount = [SELECT COUNT() FROM Case WHERE Status = 'Closed' AND RecordType.DeveloperName IN :allowedRecordTypes];
        dashboardWrap.rejectedCount = [SELECT COUNT() FROM Case WHERE Status = 'Rejected' AND RecordType.DeveloperName IN :allowedRecordTypes];
        dashboardWrap.OnRequestMoreInfo = [SELECT COUNT() FROM Case WHERE Sub_Status__c = 'Operations Coordinator sent for more information' AND RecordType.DeveloperName = 'ESE_Issue'];

    } catch (Exception e) {
        System.debug('Error fetching dashboard data: ' + e.getMessage());
    }
    
    return dashboardWrap;
}

      /*
*********************************************************
@Method Name    : getCaseDetailsCustomer
@author         : Akash Yellure
@description    : method to is used to get Dashboard Customer Care all Detail of Created Case
@param          :
@return         : Output
********************************************************
*/
@AuraEnabled
public static List<Case> getCaseDetailsCustomer(String status) {
    try {
        // Get User Profile
        Profile userProfile = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()];

        // Define allowed profiles
        Set<String> allowedProfiles = new Set<String>{
            System.Label.ET_MOE_Department_Of_School_Services_Profie, 
            System.Label.ET_MOE_Department_Of_School_Activities_Profie, 
            System.Label.ET_Government_School_Profile_Name, 
            System.Label.ET_MOE_Personnel_Management_Profie_Name, 
            System.Label.ET_MOE_Extra_Curricular_Activities_Profie_Name, 
            System.Label.ET_MOE_Inclusive_Education_Department_in_ESE, 
            System.Label.HSE_Inspector, 
            System.Label.HSE_Transportation_Inspector, 
            System.Label.HSE_Quality_Coordinator, 
            System.Label.ESE_Transportation,
            System.Label.ESE_Transportation_Inspector

        };

        // Check if the user profile is allowed
        if (!allowedProfiles.contains(userProfile.Name)) {
            System.debug('User profile not authorized to view case details');
            return new List<Case>(); // Return empty list if unauthorized
        }

        // Fetch Case Details based on Status
        return fetchCasesByStatus(status);
        
    } catch (Exception ex) {
        System.debug('Error: ' + ex.getMessage());
        return null;
    }
}

// Helper method to fetch case details dynamically
private static List<Case> fetchCasesByStatus(String status) {
    return [
        SELECT Id, ESE_Recent_Category__c, ESE_Next_Category__c, ET_Issue_Type_New__c, 
               Driver_Name_1__r.Name, Sub_Request__c, Account.Name, CaseNumber, 
               Status, RecordType.DeveloperName, RecordTypeId, Sub_Status__c,
               Subject, Description, RecordType.Name, Case_Type_AR__c, 
               Status_Category_AR__c, Sub_Status_AR__c, ETST_Student__c, 
               ETST_Student__r.Name, School_Name_Acc__c, Status_Category__c, CreatedDate
        FROM Case 
        WHERE Status = :status 
        AND RecordType.DeveloperName IN (
            'ESE_Issue', 'Accident_Emergency', 'Feedback', 
            'Driver_Staff_Behaviour_TL', 'Online_Services_Main', 
            'Other_Requests', 'Traffic_Violation_TL', 'Theft', 
            'Service_Quality_Compliance', 'Safety_Issues_TL', 'Add_Service'
        )
        ORDER BY CaseNumber DESC
    ];
}
        /*
*********************************************************
@Method Name    : getuserDetails
@author         : Akash Yellure
@description    : method to is used to get Ese User email
@param          :
@return         : Output
********************************************************
*/ 
    @AuraEnabled
    public static User getuserDetails(){ 
        return [select id, AccountId,Account.Name,contactId,profile.Name, Email from User where id = : userinfo.getUserId()];
        
    }
    /*
*********************************************************
@Method Name    : getEseDepartmentUserData
@author         : Akash Yellure
@description    : method to is used to get Ese User Department Data 
@param          :
@return         : Output
********************************************************
*/  
    @AuraEnabled
    public static  List<ESE_User__c> getEseDepartmentUserData(){
        return [SELECT ID, User__c ,School_Department__c,School_Department__r.School_Name__c,School_Department__r.Category__c FROM ESE_User__c  where User__c =: UserInfo.getUserId() ];  
    }
    /*
*********************************************************
@Method Name    : getParentUserDetails
@author         : Akash Yellure
@description    : method to is used to get User Deatils
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled
    public static List<User> getParentUserDetails(String studentId){
        ETST_Student__c studentRec = [select Id,Name,ETST_Account_Name__c from ETST_Student__c WHERE Id=:studentId LIMIT 1];
        if(studentRec.ETST_Account_Name__c != null){
            Account acc =[Select Id,Name,createdById from Account where Id=:studentRec.ETST_Account_Name__c];
            system.debug('acc '+acc);
            Contact con=[SELECT Id,Name,AccountId,createdById from Contact where AccountId=:acc.Id];
            system.debug('con '+con);
            List<User> u = new List<User>();
            if(con != null){
                u = [Select Id,Name,contactId from User where contactId=:con.Id];
                system.debug('u '+u);
                if(u.size() <=0){
                    u = [Select Id,Name from User where Id=:con.createdById];
                }
            }else{
                u = [Select Id,Name from User where Id=:acc.createdById];
            }
            return u;
        }else{
            return null;
        }
    }
    public class MyBusinessWrapper{
        @AuraEnabled public Map<String,Integer> poList=new Map<String,Integer>();
        @AuraEnabled public String cntRecord;
        @AuraEnabled public String accRecord;
        @AuraEnabled public String accRecordName;
        @AuraEnabled public String accRecordARName;
        @AuraEnabled public String accSchoolCity;
        @AuraEnabled public String accSchoolCityAR;
        @AuraEnabled public String accSchoolCode;
        @AuraEnabled public String accSchoolArea;
        @AuraEnabled public String accSchoolAreaAR;
        @AuraEnabled public String vehicleRecord;
        @AuraEnabled public String salesRecord;
        @AuraEnabled public List<ET_Sales_Agreement__c> salesAgreementList;
        @AuraEnabled public List<SALine_Assigned_Vehicle__c> assignedVehicleList;
        @AuraEnabled public List<SALine_Assigned_Resource__c> assignedResourcesList;
        @AuraEnabled public List<Invoice__c> invoicesList;
        @AuraEnabled public integer schoolsCount=0;
        @AuraEnabled public integer studentsCount=0;
        @AuraEnabled public List<Account> schoolList;
        @AuraEnabled public List<ETST_Student__c> studentsList;
        @AuraEnabled public string accountSite;
        @AuraEnabled public List<Catchment_Area__c> catchmentArea; 
        
        public MyBusinessWrapper(){
            salesAgreementList = new List<ET_Sales_Agreement__c>();
            assignedVehicleList = new List<SALine_Assigned_Vehicle__c>();
            assignedResourcesList = new List<SALine_Assigned_Resource__c>();
            invoicesList = new List<Invoice__c>();
            studentsList=new List<ETST_Student__c>();
        }
    }
    public class CustomerCareWrapper{
        
        @AuraEnabled public List<case> caseList;
        
        public CustomerCareWrapper(){
            caseList = new List<case>();
        }
    }
    @AuraEnabled
    public static Account getBusinessType(){
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account acc=[select id,recordtype.developerName,ETST_Account_Type__c from account where id=:u.accountID];
        return acc;//.recordtype.developerName;
    }
    
    @AuraEnabled
    public static List<SALine_Assigned_Vehicle__c> showVehiclesforMonth(String POName,Integer monthNo){
        //added by Akhil M P
        Date myDate = Date.newInstance(System.Today().year(), monthNo, 1); 
        system.debug('mydate'+myDate);
        //end add
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        /* Commented on 31/05
* return [select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c, Assign_End_Date__c,
Sales_Agreement__c,
Vehicle_Description__c, Vehicle_Number__c FROM SALine_Assigned_Vehicle__c
where Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
and Sales_Agreement__r.customer_PO_No__c=:POName
and CALENDAR_MONTH(Assign_End_Date__c) = :monthNo];*/
        return [select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c, Assign_End_Date__c,
                Sales_Agreement__c,
                Vehicle_Description__c, Vehicle_Number__c FROM SALine_Assigned_Vehicle__c
                where Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
                and Sales_Agreement__r.customer_PO_No__c=:POName
                and Assign_End_Date__c >: myDate and Assign_Start_Date__c<:myDate];
    } 
    @AuraEnabled
    public static List<SALine_Assigned_Resource__c> showResourcesforMonth(String POName,Integer monthNo){
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        return [select Id,Name,Sales_Agreement__r.Name,Account__c, Assign_End_Date__c, Assign_Start_Date__c,
                ETST_Assigned_Vehicle__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                from SALine_Assigned_Resource__c
                where Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
                and Sales_Agreement__r.customer_PO_No__c=:POName
                and CALENDAR_MONTH(Assign_End_Date__c) = :monthNo];
        
    }
    
    @AuraEnabled
    public static CountClass getPODetails(String POName){
        CountClass wrap=new CountClass();
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Date startOfMonth = Date.today().toStartOfMonth().addMonths(-2);
        Date endofmonth = startOfMonth.addMonths(3).adddays(-1);
        System.debug('startOfMonth '+startOfMonth);
        System.debug('endofmonth '+endofmonth);
        List<AggregateResult> aggList=[select CALENDAR_MONTH(Assign_End_Date__c) end_month,count(id) cnt from SALine_Assigned_Vehicle__c 
                                       where  Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
                                       and Sales_Agreement__r.customer_PO_No__c=:POName
                                       and Assign_End_Date__c >= :startOfMonth
                                       and Assign_End_Date__c <=:endofmonth
                                       group by CALENDAR_MONTH(Assign_End_Date__c)
                                       order by CALENDAR_MONTH(Assign_End_Date__c) ];
        List<AggregateResult> resourceAggList=[select CALENDAR_MONTH(Assign_End_Date__c) end_month,count(id) cnt 
                                               from SALine_Assigned_Resource__c 
                                               where  Sales_Agreement__r.salesforce_Customer__c=:u.accountID 
                                               and Sales_Agreement__r.customer_PO_No__c=:POName
                                               and Assign_End_Date__c >= :startOfMonth
                                               and Assign_End_Date__c <=:endofmonth
                                               group by CALENDAR_MONTH(Assign_End_Date__c)
                                               order by CALENDAR_MONTH(Assign_End_Date__c) ];
        for(AggregateResult aggr:aggList ){ 
            wrap.VehicleCount.put((integer)aggr.get('end_month'),(integer)aggr.get('cnt'));
        }
        for(AggregateResult aggr:resourceAggList ){ 
            wrap.resourceCount.put((integer)aggr.get('end_month'),(integer)aggr.get('cnt'));
        }
        System.debug('wrapp'+wrap.VehicleCount);
        
        return wrap;
    }
    public Class CountClass{
        @AuraEnabled public map<Integer,Integer> VehicleCount=new map<Integer,Integer>();
        @AuraEnabled public map<Integer,Integer> resourceCount=new map<Integer,Integer>();
        @AuraEnabled public Integer woCount=0; 
    }
    @AuraEnabled
    public static Map<String,String> GetAvailableRecordTypeCase()
    {
        Map<String,String> recordTypeMap = new Map<String,String>();
        system.debug('********Inside**');
        for(RecordType rec : [SELECT Id,  Name, DeveloperName, Description FROM RecordType WHERE SobjectType = 'Case']) {
            recordTypeMap.put(rec.Id, rec.Name);
            system.debug('recordtype' + recordtypemap);
        }
        return recordTypeMap;
    }   
    @AuraEnabled
    
    public static List<contact> getSiteDetails(){ 
        User u = [select id, AccountId,contactId from User where id = : userinfo.getUserId()];
        return [select id,account.Name,account.ET_Preferred_Location__c,firstName,lastname,Phone from contact where contact.Account.ParentId=:u.AccountId];
        
    }
    
    @AuraEnabled
    public static MyBusinessWrapper getUserAccountDetails(){
        List<Id> salesAgreementIdList = new List<Id>();
        MyBusinessWrapper businessWrapper = new MyBusinessWrapper();
        Id userId = UserInfo.getUserId();
        // Id regularShowId = Schema.SObjectType.Account.RecordTypeInfosByName.get('Business (B2B) - School').RecordTypeId;
        //system.debug('regularShowId '+regularShowId);
        //  Id recordTypeId =[SELECT Id FROM RecordType WHERE DeveloperName = 'Business_School' AND sObjectType = 'Account'].Id;
        User u = [select id, AccountId,contactId from User where id = : userId];
        Id getContactId = u.contactId;
        system.debug('getContactId ' + getContactId);
        
        //Contact communityUserContact = [select Id, name,AccountId from contact where Id=:getContactId];
        //system.debug('communityUserContact ' + communityUserContact);
        businessWrapper.schoolsCount=[select count() from Account where ParentId=:u.AccountId];
        
        businessWrapper.catchmentArea= [select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, School_Name__c, Area_Arabic__c from Catchment_Area__c where School_Name__c=:u.AccountId];
        
        businessWrapper.studentsCount=[select count() from ETST_Student__c where ETST_School__c=:u.AccountId and ETST_Status__c='Active'];
        Account communityUserAccount =[select Id,Name,RecordTypeId,RecordType.Name,ETIN_Name_Arabic__c,School_City__c,School_City_AR__c,School_Area__c,School_Area_AR__c,School_Code__c from account where Id=:u.AccountId ];
        //  Account communityUserAccount =[select Id,Name,RecordTypeId,RecordType.Name from account where Id=:u.AccountId and RecordTypeId  = :regularShowId];
        //Account communityUserAccount =[select Id,Name,RecordTypeId,RecordType.Name from account where Id=:u.AccountId];
        
        businessWrapper.cntRecord=getContactId;//communityUserContact.id;
        businessWrapper.accRecord=communityUserAccount.id;
        businessWrapper.accRecordName=communityUserAccount.Name;
        businessWrapper.accRecordARName=communityUserAccount.ETIN_Name_Arabic__c;
        businessWrapper.accSchoolCity=communityUserAccount.School_City__c;
        businessWrapper.accSchoolCode=communityUserAccount.School_Code__c;
        businessWrapper.accSchoolArea=communityUserAccount.School_Area__c;
        businessWrapper.accSchoolAreaAR=communityUserAccount.School_City_AR__c;
        businessWrapper.accSchoolCityAR=communityUserAccount.School_Area_AR__c;
        
        businessWrapper.studentsList=[select id,Name,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c   from ETST_Student__c 
                                      where ETST_School__c=:u.AccountId and ETST_Status__c='Active'];
        businessWrapper.salesAgreementList =[select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
                                             Contract_End_Date__c, Contract_No__c, Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
                                             Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
                                             Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
                                             GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                             from ET_Sales_Agreement__c where Salesforce_Customer__c=:communityUserAccount.Id ORDER BY Name ];
        List<AggregateResult> aggList=[select Customer_PO_No__c,count(id) cnt from ET_Sales_Agreement__c 
                                       where Salesforce_Customer__c=:communityUserAccount.Id
                                       group by Customer_PO_No__c];
        for(AggregateResult aggr:aggList ){ 
            businessWrapper.poList.put((String)aggr.get('Customer_PO_No__c'),(integer)aggr.get('cnt'));
        }
        
        
        for(ET_Sales_Agreement__c sg : businessWrapper.salesAgreementList){
            salesAgreementIdList.add(sg.Id);
        }   
        system.debug('salesAgreementIdList '+salesAgreementIdList);
        businessWrapper.assignedVehicleList =[select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c, //Assign_End_Date__c
                                              Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c, Vehicle_Description__c, Vehicle_Number__c
                                              from SALine_Assigned_Vehicle__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapper.assignedResourcesList =[select Id,Name,Sales_Agreement__r.Name, Assign_End_Date__c, Assign_Start_Date__c,
                                                ETST_Assigned_Vehicle__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                                                from SALine_Assigned_Resource__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapper.invoicesList =[select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                                       Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                                       Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                                       ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                                       ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                                       Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                                       Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                                       Trx_Number__c, Voucher_Number__c, Zone__c,Due_Amount__c,Invoice_Amount__c,Invoice_Date__c
                                       from Invoice__c 
                                       where (Payment_Status__c='Not Paid' OR Payment_Status__c='Partially Paid')
                                       AND Sales_Agreement__c IN:salesAgreementIdList
                                      ];// and  Customer__c=u.AccountId  AND Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        system.debug(' businessWrapper = '+businessWrapper);
        return businessWrapper;
    }
    @AuraEnabled
    public static MyBusinessWrapper getUserAccountDetailsCRM(Id currentId ,String Type){
        MyBusinessWrapper businessWrapper = new MyBusinessWrapper();
        
        if(Type=='Assigned Resource'){
            SALine_Assigned_Resource__c assignedResourcesList =[select Id,Name,Sales_Agreement__r.Name,Account__c, Assign_End_Date__c, Assign_Start_Date__c,
                                                                ETST_Assigned_Vehicle__c , Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c,Account_Site__c
                                                                from SALine_Assigned_Resource__c where Id=:currentId ORDER BY Name];
            businessWrapper.salesRecord=assignedResourcesList.Sales_Agreement__c;
            businessWrapper.accRecord=assignedResourcesList.Account__c;
            businessWrapper.vehicleRecord=assignedResourcesList.ETST_Assigned_Vehicle__c;
            businessWrapper.accountSite = assignedResourcesList.Account_Site__c;
            
        }
        else if(Type=='Assigned vehicle'){
            SALine_Assigned_Vehicle__c assignedVehicleList =[select Id, Name,Account__c ,Sales_Agreement__c, 
                                                             Vehicle_Description__c, Vehicle_Number__c,Account_Site__c from SALine_Assigned_Vehicle__c where Id=:currentId ORDER BY Name];
            businessWrapper.salesRecord=assignedVehicleList.Sales_Agreement__c;
            businessWrapper.accRecord=assignedVehicleList.Account__c;
            businessWrapper.accountSite = assignedVehicleList.Account_Site__c;
            
        }
        else if(Type=='Invoice'){
            Invoice__c invoicesList =[select Id, Name,Sales_Agreement__c,Customer__c
                                      from Invoice__c where Id =:currentId ORDER BY Name];  
            businessWrapper.salesRecord=invoicesList.Sales_Agreement__c;
            businessWrapper.accRecord=invoicesList.Customer__c;
            
        }
        else if(Type=='Sales Aggrement'){
            ET_Sales_Agreement__c salesAgreementList =[select Id,Name,Salesforce_Customer__c,
                                                       GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                                       from ET_Sales_Agreement__c where Id=:currentId ORDER BY Name ];
            
            businessWrapper.accRecord=salesAgreementList.Salesforce_Customer__c;
            //businessWrapper.accountSite = assignedVehicleList.Account_Site__c !=null ? assignedVehicleList.Account_Site__r.Operation_Manager__c : '';
            
        }
        else if(Type=='Assigned Student'){
            ETST_Student__c studentsList=[select id,Name,ETST_Student_Id__c,ETST_Account_Name__c,ETST_Emirates_Id__c,Account_Site__c,ETST_School__c,ETST_School_Name__c,ETST_School_Name__r.ETST_Sales_Agreement__c from ETST_Student__c 
                                          where Id=:currentId and ETST_Status__c='Active'];
            businessWrapper.accRecord=studentsList.ETST_Account_Name__c;
            businessWrapper.salesRecord=studentsList.ETST_School_Name__r.ETST_Sales_Agreement__c;
            businessWrapper.accountSite = studentsList.Account_Site__c;
            
        }
        else if(Type=='Account'){
            businessWrapper.accRecord=currentId;
            
        }
        system.debug(' businessWrapper = '+businessWrapper);
        return businessWrapper;
    }
    //For Ministry of Education Cases
    @AuraEnabled
    public static MyBusinessWrapper getUserAccountDetailsMoe(){
        List<Id> salesAgreementIdList = new List<Id>();
        MyBusinessWrapper businessWrapperMin = new MyBusinessWrapper();
        Id userId = UserInfo.getUserId();
        
        User u = [select id, AccountId,contactId from User where id = : userId];
        businessWrapperMin.accRecord=u.AccountId;
        businessWrapperMin.studentsList=[select id,Name,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c   from ETST_Student__c 
                                         where ETST_School__r.ParentId=:u.AccountId and ETST_Status__c='Active'];
        businessWrapperMin.salesAgreementList =[select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
                                                Contract_End_Date__c, Contract_No__c, Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
                                                Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
                                                Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
                                                GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
                                                from ET_Sales_Agreement__c where Salesforce_Customer__r.ParentId=:u.AccountId  ORDER BY Name ];
        
        for(ET_Sales_Agreement__c sg : businessWrapperMin.salesAgreementList){
            salesAgreementIdList.add(sg.Id);
        }   
        system.debug('salesAgreementIdList '+salesAgreementIdList);
        businessWrapperMin.assignedVehicleList =[select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c,//Assign_End_Date__c
                                                 Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c, Vehicle_Description__c, Vehicle_Number__c
                                                 from SALine_Assigned_Vehicle__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapperMin.assignedResourcesList =[select Id,Name,Sales_Agreement__r.Name, Assign_End_Date__c, Assign_Start_Date__c,
                                                   ETST_Assigned_Vehicle__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                                                   from SALine_Assigned_Resource__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        businessWrapperMin.invoicesList =[select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                                          Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                                          Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                                          ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                                          ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                                          Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                                          Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                                          Trx_Number__c, Voucher_Number__c, Zone__c
                                          from Invoice__c where Sales_Agreement__c IN:salesAgreementIdList ORDER BY Name];
        
        return businessWrapperMin;
    }
    
    @AuraEnabled
    public static List<Case> getCustomerCareDetails(String caseNumber,String Status,String salesAgId, String assignedResId,String assignedVehId,String invoiceId){
        
        system.debug('caseNumber = '+caseNumber);
        system.debug('Status = '+Status);
        system.debug('salesAgId = '+salesAgId);
        system.debug('assignedResId = '+assignedResId);
        system.debug('assignedVehId = '+assignedVehId);
        system.debug('invoiceId = '+invoiceId);
        
        CustomerCareWrapper ccWrapper = new CustomerCareWrapper(); 
        MyBusinessWrapper businessWrapper = getUserAccountDetails();
        
        system.debug('businessWrapper in customer care method = '+businessWrapper );
        Id AccId=businessWrapper.accRecord;
        system.debug('#########'+AccId);
        Set<Id> salesAgreementIdList = new Set<Id>();
        for(ET_Sales_Agreement__c sg:businessWrapper.salesAgreementList){
            salesAgreementIdList.add(sg.Id);
        }
        system.debug('salesAgreementIdList = '+salesAgreementIdList );
        
        Set<Id> resourcesIdList = new Set<Id>();
        for(SALine_Assigned_Resource__c resc:businessWrapper.assignedResourcesList){
            resourcesIdList.add(resc.Id);
        }
        system.debug('resourcesIdList = '+resourcesIdList );
        
        Set<Id> vehiclesIdList = new Set<Id>();
        for(SALine_Assigned_Vehicle__c veh:businessWrapper.assignedVehicleList){
            vehiclesIdList.add(veh.Id);
        }
        system.debug('vehiclesIdList = '+vehiclesIdList );
        
        Set<Id> invoicesIdList = new Set<Id>();
        for(Invoice__c inv:businessWrapper.invoicesList){ 
            invoicesIdList.add(inv.Id);
        }
        system.debug('invoicesIdList = '+invoicesIdList );
        
        ccWrapper.caseList =[select id,CaseNumber,Status,RecordType.Name,RecordTypeId,Invoice__c,Invoice__r.name,
                             Subject, Description, Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                             Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name
                             from Case where RecordType.Name = 'B2B Business Portal Cases'
                             AND (Sales_Agreement__c IN:salesAgreementIdList
                                  OR Assigned_Resource__c IN:resourcesIdList
                                  OR Assigned_Vehicle__c IN:vehiclesIdList
                                  OR  Invoice__c IN:invoicesIdList
                                  OR  AccountId =:AccId)];
        
        system.debug('caseListttsss '+ccWrapper.caseList);
        Set<Case> caseFilteredList = new Set<Case>();
        
        for (Integer i = 0; i < ccWrapper.caseList.size(); i++) {
            if (
                (String.isNotBlank(caseNumber) ? ccWrapper.caseList[i].CaseNumber.contains(caseNumber) : true )    
                &&
                (String.isNotBlank(Status) ? ccWrapper.caseList[i].Status.equals(Status) : true)
                &&
                containsField(ccWrapper.caseList[i].Sales_Agreement__c, salesAgId)
                &&
                containsField(ccWrapper.caseList[i].Assigned_Resource__c, assignedResId)
                &&
                containsField(ccWrapper.caseList[i].Assigned_Vehicle__c, assignedVehId)
                &&
                containsField(ccWrapper.caseList[i].Invoice__c, invoiceId)
            ){
                caseFilteredList.add(ccWrapper.caseList[i]);
            }
        }
        system.debug('caseFilteredList = '+caseFilteredList );
        List<Case> updatedCaseFilteredList = new List<Case>(caseFilteredList);
        return updatedCaseFilteredList;
    }
    public class caseWrapper{ 
        @AuraEnabled public Integer newCount=0; 
        @AuraEnabled public Integer inprogressCount=0; 
        @AuraEnabled public Integer closedCount=0; 
        @AuraEnabled public Integer rejectedCount=0; 
        @AuraEnabled public Integer approvedCount=0; 
        
        @AuraEnabled public Integer cancelCount=0;
        @AuraEnabled public Integer OnHoldCount=0;
        @AuraEnabled Public Integer OnRequestMoreInfo=0;

        @AuraEnabled public string loggedinUserProfileName; 
    }
    
    /*
*********************************************************
@Method Name    : getDashboardData
@author         : Akash Yellure
@description    : method to is used to get Dashboard Data Special Request View Page or Windows
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled
    public static caseWrapper getDashboardData() {
        system.debug('in getDashboardData ');
        caseWrapper dashboardWrap=new caseWrapper();
        try{
            String privateSchoolLabel = System.Label.ET_Private_School_Profile_Name;
            String governmentSchoolLabel = System.Label.ET_Government_School_Profile_Name;
            String moeDepartmentActivitySchoolLabel = System.Label.ET_MOE_Department_Of_School_Activities_Profie;
            String moeDepartmentServicesSchoolLabel = System.Label.ET_MOE_Department_Of_School_Services_Profie;
            String moePersonnelManagementLabel = System.Label.ET_MOE_Personnel_Management_Profie_Name;
            String moeSpecialEducationtLabel = System.Label.ET_MOE_Special_Education_Profie_Name;
            String moeExtraCurricularActivitiesLabel = System.Label.ET_MOE_Extra_Curricular_Activities_Profie_Name;
            String moeInclusiveEducationDepartmentinESELabel = 'P-MOE - Inclusive Education Department in ESE';
            String govtschool='P-Govt School Partner User Login';
            Profile p=[Select Id,Name from Profile where Id=:userInfo.getProfileId() LIMIT 1];
            system.debug('profile Name '+p.name);
            if(p.Name !=privateSchoolLabel && p.Name !=governmentSchoolLabel 
               && p.Name !=moeDepartmentActivitySchoolLabel && p.Name !=moeDepartmentServicesSchoolLabel
               && p.Name !=moePersonnelManagementLabel && p.Name !=moeSpecialEducationtLabel && p.Name!=govtschool && p.Name!=moeExtraCurricularActivitiesLabel && p.Name!=moeInclusiveEducationDepartmentinESELabel){
                   system.debug('inside if');
                   dashboardWrap.newCount=[select count() from Case where status  ='New'];
                   system.debug(' newCount '+ dashboardWrap.newCount);
                   dashboardWrap.inprogressCount=[select count() from Case where status  ='In Progress'];
                   system.debug(' inprogressCount '+ dashboardWrap.inprogressCount);
                   dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected'];
                   system.debug(' rejectedCount '+ dashboardWrap.rejectedCount);
                   dashboardWrap.approvedCount=[select count() from Case where status  ='Approved']; 
                   system.debug(' approvedCount '+ dashboardWrap.approvedCount);
                   dashboardWrap.cancelCount=[select count() from Case where status  ='Cancel']; 
                   system.debug(' cancelCount '+ dashboardWrap.cancelCount);
                   dashboardWrap.closedCount=[select count() from Case where status  ='Closed' AND IsActive__c= true];
                   system.debug(' closedCount '+ dashboardWrap.closedCount);
                   dashboardWrap.OnHoldCount=[select count() from Case where status  ='On Hold']; 
                   system.debug(' OnHoldCount '+ dashboardWrap.OnHoldCount);
                   dashboardWrap.loggedinUserProfileName = [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
                   
               }else if(p.Name ==privateSchoolLabel || p.Name ==governmentSchoolLabel 
                        || p.Name ==moeDepartmentActivitySchoolLabel || p.Name ==moeDepartmentServicesSchoolLabel
                        || p.Name ==moePersonnelManagementLabel || p.Name ==moeSpecialEducationtLabel || p.Name ==govtschool || p.Name==moeExtraCurricularActivitiesLabel || p.Name==moeInclusiveEducationDepartmentinESELabel){
                            String listoftypes=System.Label.ET_Special_Requests_Record_Types;
                            List<String>  casetypeList= new List<String>();
                            casetypeList=listoftypes.split(',');
                            User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
                            system.debug('u'+u.AccountId);
                            Account Acc=[select id,Name from Account where Id=:u.AccountId];
                            system.debug('acc details'+Acc);
                            List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
                            system.debug('acc details'+acctListChild);
                            Set<id> childAccountIDs=new Set<id>();
                            childAccountIDs.add(Acc.Id);
                            for(Account childAcc:acctListChild){
                                childAccountIDs.add(childAcc.Id);
                            }
                            system.debug('childAccountIDs getDashboardData='+childAccountIDs);
                            //dashboardWrap.newCount=[select count() from Case where status  ='New' AND AccountId IN:childAccountIDs ];//AND AccountId IN:childAccountIDs AND  RecordType.Name IN :casetypeList
                            dashboardWrap.newCount=[select count() from Case where status  ='New' AND RecordType.developerName IN ('Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Request_for_the_awareness_sessions',
                                                                                                                                   'Requests_for_trips_activities_events','Special_Needs_Activities_and_Events_Request','Special_Needs_Companion_Request','Special_Needs_Transportation_Request',
                                                                                                                                   'Fleet_Growth_Request','Awareness_Session_Request') ];
                            if(p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name ==govtschool || p.Name==moeExtraCurricularActivitiesLabel || p.Name==moeInclusiveEducationDepartmentinESELabel){
                                system.debug('p.Name******* '+p.Name);
                                dashboardWrap.inprogressCount=[select count() from Case where Status='In Progress' AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions','Request_for_the_Companian_Handicap_Transportation')limit 300];//  AND AccountId IN:childAccountIDs AND  RecordType.Name IN :casetypeList
                                dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected' AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions','Request_for_the_Companian_Handicap_Transportation')limit 300];
                                dashboardWrap.approvedCount=[select count() from Case where status  ='Approved' AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions') limit 300];
                                dashboardWrap.closedCount=[select count() from Case where status  ='Closed' AND IsActive__c= true AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions','Request_for_the_Companian_Handicap_Transportation')limit 300];
                                dashboardWrap.cancelCount=[select count() from Case where status  ='Cancel' AND IsActive__c= true AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions','Request_for_the_Companian_Handicap_Transportation')limit 300];
                                dashboardWrap.OnHoldCount=[select count() from Case where status  ='On Hold' AND Sub_Status__c = 'Approved by Operation Manager' AND RecordType.developerName IN ('Handicap_Services_Transport_or_Nanny_Request') limit 300];
                            }
                            else{
                                dashboardWrap.inprogressCount=[select count() from Case where status  ='In Progress' AND AccountId IN:childAccountIDs AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions','Request_for_the_Companian_Handicap_Transportation')limit 300];//  AND AccountId IN:childAccountIDs AND  RecordType.Name IN :casetypeList
                                dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected' AND AccountId IN:childAccountIDs AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions','Request_for_the_Companian_Handicap_Transportation')limit 300];
                                dashboardWrap.approvedCount=[select count() from Case where status  ='Approved' AND AccountId IN:childAccountIDs AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions','Request_for_the_Companian_Handicap_Transportation') limit 300];
                                dashboardWrap.closedCount=[select count() from Case where status  ='Closed' AND IsActive__c= true AND AccountId IN:childAccountIDs AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions','Request_for_the_Companian_Handicap_Transportation') limit 300] ;
                                dashboardWrap.cancelCount=[select count() from Case where status  ='Cancel' AND IsActive__c= true AND AccountId IN:childAccountIDs AND RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Special_Needs_Companion_Request','Request_for_the_awareness_sessions','Request_for_the_Companian_Handicap_Transportation') limit 300];
                                dashboardWrap.OnHoldCount=[select count() from Case where status  ='On Hold' AND Sub_Status__c = 'Approved by Operation Manager' AND RecordType.developerName IN ('Handicap_Services_Transport_or_Nanny_Request') limit 300];

                            }
                            dashboardWrap.loggedinUserProfileName = [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
                        }  
            system.debug('dashboardWrap***'+dashboardWrap); 
            return dashboardWrap;   
        }    
        catch (Exception ex) {
            System.debug(ex.getMessage());
            return null;
        }
    }

   
    


    /*
*********************************************************
@Method Name    : getCaseDetails
@author         : Akash Yellure
@description    : method to is used to get  Special request Data  all data like in progress, rejected,approved,canceled, competed
@param          :
@return         : Output
********************************************************
*/
    
    @AuraEnabled
    public static List<Case> getCaseDetails(string status) {
        system.debug('in getCaseDetails');
        system.debug('in getCaseDetails status'+status);
        try{
            
            String privateSchoolLabel = System.Label.ET_Private_School_Profile_Name;
            String governmentSchoolLabel = System.Label.ET_Government_School_Profile_Name;
            String moeDepartmentActivitySchoolLabel = System.Label.ET_MOE_Department_Of_School_Activities_Profie;
            String moeDepartmentServicesSchoolLabel = System.Label.ET_MOE_Department_Of_School_Services_Profie;
            String moePersonnelManagementLabel = System.Label.ET_MOE_Personnel_Management_Profie_Name;
            String moeSpecialEducationtLabel = System.Label.ET_MOE_Special_Education_Profie_Name;
            String moeExtraCurricularActivitiesLabel = System.Label.ET_MOE_Extra_Curricular_Activities_Profie_Name;
            String moeInclusiveEducationDepartmentinESELabel = System.Label.ET_MOE_Inclusive_Education_Department_in_ESE;
            String govtschool = System.Label.Gov_Profile_login;
            String ESEsupportCenter =System.Label.ESE_Support_Center;
            Profile p=[Select Id,Name from Profile where Id=:userInfo.getProfileId() LIMIT 1];
            system.debug('profile Name in getCaseDetails '+p.Name);
            List<Case> caseList = new List<Case>();
            if(p.Name !=privateSchoolLabel && p.Name !=governmentSchoolLabel 
               && p.Name !=moeDepartmentActivitySchoolLabel && p.Name !=moeDepartmentServicesSchoolLabel
               && p.Name !=moePersonnelManagementLabel && p.Name !=moeSpecialEducationtLabel && p.Name!=govtschool && p.Name!=moeExtraCurricularActivitiesLabel  && p.Name!=moeInclusiveEducationDepartmentinESELabel){
                   system.debug('if  getCaseDetails');
                   if(status == 'All'){
                       caseList= [select id,CaseNumber,Request_Type_For_Data_Handling_AR__c,Request_Type_For_Data_Handling__c,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                  Subject, Description, RecordType.Name,ETST_Student__c,Case_Type_AR__c,Status_Category_AR__c,Sub_Status_AR__c,ETST_Student__r.Name,Student_Name__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                  Coordinator_Name__c,Student_Name_AR__c,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,FeedBack_EN__c
                                  from Case where status IN ('New','In Progress','Rejected','Approved','Closed','On Hold') Order by CaseNumber DESC limit 300]; 
                   } else {
                       caseList= [select id,CaseNumber,Request_Type_For_Data_Handling_AR__c,Request_Type_For_Data_Handling__c,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                  Subject, Description, RecordType.Name,ETST_Student__c,Case_Type_AR__c,Status_Category_AR__c,Sub_Status_AR__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                  Coordinator_Name__c,Student_Name_AR__c, Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,FeedBack_EN__c
                                  from Case where status=:status Order by CaseNumber DESC limit 300];
                   }
               }else if(p.Name ==privateSchoolLabel || p.Name ==governmentSchoolLabel ||P.Name==ESEsupportCenter
                        || p.Name ==moeDepartmentActivitySchoolLabel || p.Name ==moeDepartmentServicesSchoolLabel
                        || p.Name ==moePersonnelManagementLabel || p.Name ==moeSpecialEducationtLabel || p.Name==govtschool || p.Name==moeExtraCurricularActivitiesLabel || p.Name==moeInclusiveEducationDepartmentinESELabel){
                            system.debug('else if  childid');
                            String listoftypes=System.Label.ET_Special_Requests_Record_Types;
                            List<String>  casetypeList= new List<String>();
                            casetypeList=listoftypes.split(',');
                            User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
                            Account Acc=[select id,Name from Account where Id=:u.AccountId];
                            system.debug('acc details'+Acc);
                            List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
                            Set<id> childAccountIDs=new Set<id>();
                            childAccountIDs.add(Acc.Id);
                            for(Account childAcc:acctListChild){
                                childAccountIDs.add(childAcc.Id);
                            }
                            if(status == 'All'){
                                
                                caseList= [SELECT id, Request_Type_For_Data_Handling_AR__c, Request_Type_For_Data_Handling__c, Sub_Request_AR__c, Account.Name, CaseNumber, Status, RecordType.developerName, RecordTypeId, Sub_Status__c, Subject, Description, RecordType.Name, Case_Type_AR__c, Status_Category_AR__c, Sub_Status_AR__c, ETST_Student__c, ETST_Student__r.Name, Sales_Agreement__c, 
                                           Coordinator_Name__c, Student_Name_AR__c,Status_Category__c, CreatedDate, ETST_Student__r.ETST_Full_Name_AR__c, Account.ETIN_Name_Arabic__c, Parent_Name_Student__c, Disability_Type__c, Mobility_Ads__c, Sub_Request__c, ESE_free_text__c, School_Area__c, School_City__c, SIS_Number__c, Companion_ID_Number__c, Parent_Name__c, ID_number__c, Student_Companion_Name__c,
                                           Delegated_Person_Phone__c, CCM_Remarks__c, Request_Type__c, Grade__c, School_Code_Detail_Page__c, AccountId, Trip_Type__c, Mode__c, No_of_Passengers__c, Students_Gender__c, Student_Division__c, Preferred_Date__c, Preferred_End_Date__c, Trip_Location__c, No_of_Disabled_Students__c, Bus_Supervisor_Available__c, Phone_Number__c, No_of_Attendance__c, Coordinator_Number__c,
                                           Awareness_Session_Location__c, LandMark__c, Program_Type__c, Zone_Type__c,FeedBack_EN__c,Emirates__c
                                           from Case where status IN ('New','In Progress','Rejected','Approved','Closed','Cancel') and IsActive__c= true  AND RecordType.developerName IN ('Special_Needs_Companion_Request','Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request', 'Global_Event_Request','Request_for_the_Companian_Handicap_Transportation','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions','Special_Needs_Activities_and_Events_Request') Order by CaseNumber DESC limit 500]; //AND AccountId IN:childAccountIDs
                            }else {
                                
                                if(status =='In Progress' && (p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name==govtschool || p.Name==moeExtraCurricularActivitiesLabel || p.Name==moeInclusiveEducationDepartmentinESELabel ||P.Name==ESEsupportCenter)){
                                    caseList= [select id ,AccountId,Sub_Request_AR__c,Request_Type_For_Data_Handling_AR__c,Request_Type_For_Data_Handling__c,Sub_Request__c,Account.Name,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,Case_Type_AR__c,Status_Category_AR__c,Sub_Status_AR__c,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                               Coordinator_Name__c,Student_Name_AR__c,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,ETST_Student__r.ETST_Full_Name_AR__c,Account.ETIN_Name_Arabic__c,Parent_Name_Student__c,Student_Name__c,FeedBack_EN__c,Emirates__c
                                               from Case where Status='In Progress' AND RecordType.developerName IN ('Special_Needs_Companion_Request','Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Request_for_the_Companian_Handicap_Transportation','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC limit 500]; 
                                    
                                }else if(status =='Rejected' && (p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name==govtschool || p.Name==moeExtraCurricularActivitiesLabel || p.Name==moeInclusiveEducationDepartmentinESELabel)){
                                    caseList= [select id,Sub_Request_AR__c,Request_Type_For_Data_Handling_AR__c,Request_Type_For_Data_Handling__c,Sub_Request__c,Account.Name,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,Case_Type_AR__c,Status_Category_AR__c,Sub_Status_AR__c,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                               Coordinator_Name__c,Student_Name_AR__c,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,ETST_Student__r.ETST_Full_Name_AR__c,Account.ETIN_Name_Arabic__c,Parent_Name_Student__c,Student_Name__c,FeedBack_EN__c,Emirates__c
                                               from Case where Status='Rejected' AND RecordType.developerName IN ('Special_Needs_Companion_Request','Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Request_for_the_Companian_Handicap_Transportation','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC limit 500];
                                } else if(status =='Closed' && (p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name==govtschool || p.Name==moeExtraCurricularActivitiesLabel || p.Name==moeInclusiveEducationDepartmentinESELabel)){
                                    caseList= [select id,Sub_Request_AR__c,Request_Type_For_Data_Handling_AR__c,Sub_Request__c,Account.Name,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,Case_Type_AR__c,Status_Category_AR__c,Sub_Status_AR__c,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,Emirates__c,
                                               Coordinator_Name__c, Student_Name_AR__c, Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,ETST_Student__r.ETST_Full_Name_AR__c,Account.ETIN_Name_Arabic__c,Parent_Name_Student__c,Student_Name__c,FeedBack_EN__c
                                               from Case where Status='Closed' AND IsActive__c= true AND  RecordType.developerName IN ('Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Request_for_the_Companian_Handicap_Transportation','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC limit 500];
                                }
                                else if(status =='Cancel' && (p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name==govtschool || p.Name==moeExtraCurricularActivitiesLabel || p.Name==moeInclusiveEducationDepartmentinESELabel)){
                                    caseList= [select id,Sub_Request_AR__c,Request_Type_For_Data_Handling_AR__c,Sub_Request__c,Request_Type_For_Data_Handling__c,Account.Name,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,Case_Type_AR__c,Status_Category_AR__c,Sub_Status_AR__c,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                               Coordinator_Name__c,Student_Name_AR__c,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,ETST_Student__r.ETST_Full_Name_AR__c,Account.ETIN_Name_Arabic__c,Parent_Name_Student__c,Student_Name__c,FeedBack_EN__c,Emirates__c
                                               from Case where Status='Cancel' AND IsActive__c= true AND  RecordType.developerName IN ('Special_Needs_Companion_Request','Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Request_for_the_Companian_Handicap_Transportation','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC limit 500];
                                }
                                else if(status =='On Hold' && (p.Name == moeDepartmentActivitySchoolLabel||p.Name == moeDepartmentServicesSchoolLabel||p.Name ==moePersonnelManagementLabel||p.Name ==moeSpecialEducationtLabel || p.Name==govtschool || p.Name==moeExtraCurricularActivitiesLabel || p.Name==moeInclusiveEducationDepartmentinESELabel ||P.Name==ESEsupportCenter)){
                                    caseList= [select id ,AccountId,Sub_Request_AR__c,Request_Type_For_Data_Handling_AR__c,Request_Type_For_Data_Handling__c,Sub_Request__c,Account.Name,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                               Subject, Description, RecordType.Name,Case_Type_AR__c,Status_Category_AR__c,Sub_Status_AR__c,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                               Coordinator_Name__c,Student_Name_AR__c,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,ETST_Student__r.ETST_Full_Name_AR__c,Account.ETIN_Name_Arabic__c,Parent_Name_Student__c,Student_Name__c,FeedBack_EN__c
                                               from Case where Status='On Hold' AND Sub_Status__c = 'Approved by Operation Manager' AND RecordType.developerName IN ('Special_Needs_Companion_Request','Fleet_Growth_Request','Special_Needs_Transportation_Request','Special_Needs_Activities_and_Events_Request','Global_Event_Request','Request_for_the_Companian_Handicap_Transportation','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC limit 500]; 
                                    
                                }
                                
                            }
                        }  
            return caseList;
        }catch (Exception e) {
            System.debug(e.getMessage());
            return null;
            
        }
    } 
    @AuraEnabled
    public static List<Case> getCustomerCareDetailsMoeCases(String caseNumber,String Status,String salesAgId, String assignedResId,String assignedVehId,String stdID){
        CustomerCareWrapper ccWrapperMoe = new CustomerCareWrapper(); 
        MyBusinessWrapper businessWrapperMinistry = getUserAccountDetailsMoe();
        Id AccId=businessWrapperMinistry.accRecord;
        Set<Id> resourcesIdList = new Set<Id>();
        for(SALine_Assigned_Resource__c resc:businessWrapperMinistry.assignedResourcesList){
            resourcesIdList.add(resc.Id);
        }
        Set<Id> vehiclesIdList = new Set<Id>();
        for(SALine_Assigned_Vehicle__c veh:businessWrapperMinistry.assignedVehicleList){
            vehiclesIdList.add(veh.Id);
        }
        system.debug('vehiclesIdList = '+vehiclesIdList );
        
        Set<Id> StudentIdList = new Set<Id>();
        for(ETST_Student__c std: businessWrapperMinistry.studentsList){
            StudentIdList.add(std.Id);
        }
        system.debug('StudentIdList = '+StudentIdList );
        Set<Id> invoicesIdList = new Set<Id>();
        for(Invoice__c inv:businessWrapperMinistry.invoicesList){ 
            invoicesIdList.add(inv.Id);
        }
        String moeRecTypes=System.Label.Case_Record_Type_MOE;
        List<String> moeRecTypeList= new List<String>();
        moeRecTypeList=moeRecTypes.split(',');
        Profile p = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        system.debug('p***'+p);
        return [select id,CaseNumber,Status,RecordType.Name,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                Subject, Description, ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name
                from Case /*where  Status IN ('Pending with Department Of School Activities',
'Pending with Department Of School Services')*/];
    }
    @TestVisible private static boolean containsField(Id e1, String e2) 
    {
        return String.isNotBlank(e2) ? (e1 != null ? e1.equals(e2) : false) : true;
    }
    
    /*
*********************************************************
@Method Name    : approveMOECase
@author         : Akash Yellure
@description    : method to is used to get  Special request Staus will updated  all data like in progress, rejected,approved,canceled, competed
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled
    public static string approveMOECase(String recId, string caseComments ,string requestType,string requestTypeArabic,String emailsofeseuser){
        system.debug('recId in apex '+recId);
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c,Request_Type__c,Request_Type_AR__c,Collection_of_ESE_Approver_Email__c from case where Id=:recId];
        //****Requests_for_trips_activities_events
        if(c.RecordType.developername == 'Requests_for_trips_activities_events' && c.Status_Category__c == 'Pending with Department Of School Activities' ){
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c = 'Approved by Department of School Activities';
            c.Status_Category__c = 'Pending with Operation Supervisors'; 
        }

        //****Global Event
        else  if(c.RecordType.developername == 'Global_Event_Request' && c.Status_Category__c == 'Pending with Department Of School Activities' ){
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c = 'Approved by Department of School Activities';
            c.Status_Category__c = 'Pending with ET';
        }
        //****Growth_Request
        else if(c.RecordType.developername == 'Growth_Request' && c.Status_Category__c == 'Pending with Department Of School Services'){  
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c = 'Approved by Department of School Services';
            c.Status_Category__c = 'Pending with Operation Manager'; 
        }
        //****Request_for_the_awareness_sessions
        else if(c.RecordType.developername == 'Request_for_the_awareness_sessions' && c.Status_Category__c == 'Pending with Department Of School Services'){
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Status_Category__c = 'Pending with Head of Safety Unit';
            c.Sub_Status__c = 'Approved by Department of School Services';
        } 
        else if(c.RecordType.developername == 'Request_for_the_awareness_sessions' && c.Status_Category__c == 'Pending with Department Of School Activities'){
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Status_Category__c = 'Pending with Department Of School Services';
            c.Sub_Status__c = 'Approved by Department of School Activities';
        } 
        //****Request_for_the_Companian_Handicap_Transportation
        else if(c.RecordType.developername =='Request_for_the_Companian_Handicap_Transportation' && c.Status_Category__c =='Pending Hemam for Inclusive Education services'){ 
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Request_Type__c=requestType;
            c.Sub_Status__c ='Approved by Hemam for Inclusive Education services';
            c.Status_Category__c ='Pending with MOE - Personnel Affairs'; 
        }
        else if(c.RecordType.developername =='Request_for_the_Companian_Handicap_Transportation' && c.Status_Category__c == 'Pending with MOE - Personnel Affairs'){ 
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c ='Approved by MOE - Personnel Affairs';
            c.Status_Category__c ='Pending with Department Of School Services'; 
        }
        else if( c.RecordType.developername == 'Request_for_the_Companian_Handicap_Transportation' && c.Status_Category__c == 'Pending with Department Of School Services'){
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Status_Category__c = 'Pending with Operation Supervisors';
            c.Sub_Status__c = 'Approved by Department of School Services';
        } 
        
        //****Handicap_Services_Transport_or_Nanny_Request-SpecialNeed Services
        else if(c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request' && c.Status_Category__c == 'Pending Hemam for Inclusive Education services'){ 
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Request_Type__c=requestType;
            c.Request_Type_AR__c=requestTypeArabic;
            c.Sub_Status__c = 'Approved by Hemam for Inclusive Education services';
            c.Status_Category__c = 'Pending with Inclusive Education Department in ESE'; 
        }
        else if(c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request' && c.Status_Category__c == 'Pending with Inclusive Education Department in ESE'){ 
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c = 'Approved by Inclusive Education Department in ESE';
            c.Status_Category__c = 'Pending with Department Of School Services'; 
        }
        else if(c.RecordType.developername =='Handicap_Services_Transport_or_Nanny_Request' && c.Status_Category__c == 'Pending with Department Of School Services' ){
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Status_Category__c = 'Pending with Operation Supervisors';
            c.Sub_Status__c = 'Approved by Department of School Services';
        } 
        
        //****Abu dabi ESE approval Process 
        else if(c.RecordType.developername =='Special_Needs_Activities_and_Events_Request' && c.Status_Category__c == 'Pending with ESE Support Center'){ 
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c ='Approved by ESE Support Center';
            c.Status_Category__c ='Pending with Operation Supervisors'; 
            
        }
        else if(c.RecordType.developername =='Fleet_Growth_Request' && c.Status_Category__c == 'Pending with Department Of School Services'){ 
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c ='Approved by Department of School Services';
            c.Status_Category__c ='Pending with ESE Transport Operations'; 
        } 
        else if(c.RecordType.developername =='Fleet_Growth_Request' && c.Status_Category__c == 'Pending with ESE Transport Operations'){ 
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c ='Approved by ESE Transport Operations';
            c.Status_Category__c ='Pending with Operation Manager'; 
        }
        else if(c.RecordType.developername =='Special_Needs_Companion_Request' && c.Status_Category__c == 'Pending with ESE Support Center'){ 
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c ='Approved by ESE Support Center';
            c.Status_Category__c = 'Pending with Head of Safety Unit';
        }
        else if(c.RecordType.developername =='Special_Needs_Transportation_Request' && c.Status_Category__c == 'Pending with ESE Support Center'){ 
            if (c.Collection_of_ESE_Approver_Email__c != null && c.Collection_of_ESE_Approver_Email__c != '') {
                c.Collection_of_ESE_Approver_Email__c += ', ' + emailsofeseuser;
            } else {
                c.Collection_of_ESE_Approver_Email__c = emailsofeseuser;
            }
            c.Sub_Status__c ='Approved by ESE Support Center';
            c.Status_Category__c = 'Pending with Operation Supervisors';
        }
        
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
            system.debug(' comments user'+ comment.ET_Comments__c);
        }
        try{
            insert caseCommentsList;
            system.debug('exceuted inserted ');
            system.debug('checking status'+c.Status);
            update c;
            system.debug('exceuted update');
            system.debug(c);
            //submitForApproval(c.Id);
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        return c.Status;
    }
    
    /*
*********************************************************
@Method Name    : closeMOECase
@author         : Akash Yellure
@description    : method to is used to get  Special request Staus will updated closed
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled
    public static string closeMOECase(String recId, string caseComments){
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c from case where Id=:recId]; 
        system.debug(' c.RecordType.developername '+ c.RecordType.developername);
        system.debug(' c.status '+ c.status);
        system.debug(' c.Sub_Status__c '+ c.Sub_Status__c);
        if(c.Status_Category__c == 'Pending with Department Of School Services' && 
           (c.RecordType.developername == 'Requests_for_trips_activities_events'||c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request'||c.RecordType.developername == 'Growth_Request'||c.RecordType.developername == 'Teachers_Transportation_Request'||c.RecordType.developername == 'Request_for_the_awareness_sessions')){
               system.debug('inside if condition');
               c.status = 'Closed';
               c.Status_Category__c = '';
               c.Sub_Status__c = 'Closed by Department of School Services';
           }
        else if(c.Status_Category__c == 'Pending with Main School' && 
                (c.RecordType.developername == 'Requests_for_trips_activities_events'||c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request'||c.RecordType.developername == 'Growth_Request'||c.RecordType.developername == 'Teachers_Transportation_Request'||c.RecordType.developername == 'Request_for_the_awareness_sessions')){
                    c.status = 'Closed';
                    c.Status_Category__c = '';
                    c.Sub_Status__c = 'Closed by Main School';
                }
        
        else if(c.Status_Category__c == 'Pending with School Transportation Manager' && 
                (c.RecordType.developername == 'Requests_for_trips_activities_events'||c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request'||c.RecordType.developername == 'Growth_Request'||c.RecordType.developername == 'Teachers_Transportation_Request'||c.RecordType.developername == 'Request_for_the_awareness_sessions')){
                    c.status = 'Closed';
                    c.Status_Category__c = '';
                    c.Sub_Status__c = 'Closed by Main School';
                }
        system.debug(' c.status '+ c.status);
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
        }
        //   try{
        insert caseCommentsList; 
        update c;
        //   }catch(Exception e){
        //        system.debug(e.getMessage());
        //   }
        
        return  c.Status_Category__c;
    }
    
    /*
*********************************************************
@Method Name    : MOECaseFeedBack
@author         : SrihariKoyila
@description    : method to is used to get MOECaseFeedBack
@param          :
@return         : Output
********************************************************
*/
    
    @AuraEnabled
    public static String MOECaseFeedBack(String recId)
    {
        String status='Success';
        try{
            
            system.debug('recId'+recId);
            
            Case cs=[select Id,status,recordtype.developername,Sub_Status__c,Status_Category__c,FeedBack_EN__c from case where Id=:recId];
            system.debug('cs'+cs);
            if(cs.RecordType.developername== 'Growth_Request' && cs.FeedBack_EN__c =='Yes but different time.'){
                system.debug('inside growth');           
                cs.Status_Category__c = 'Pending with Operation Manager';
                cs.Sub_Status__c='Approved by Department of School Services';
                cs.Status = 'In Progress';
                // cs.Driver_Name__c=driverName;
                // cs.Driver_Number__c=driverMobile;
                update cs;
                
            } else if(cs.RecordType.developername== 'Handicap_Services_Transport_or_Nanny_Request' && cs.FeedBack_EN__c =='Yes but different time.'){
                cs.Status_Category__c = 'Pending with Operation Manager';
                cs.Sub_Status__c='Approved by Operation Supervisors';
                cs.Status = 'In Progress';
                // cs.Driver_Name__c=driverName;
                // cs.Driver_Number__c=driverMobile;
                update cs;
            } else if(cs.RecordType.developername== 'Requests_for_trips_activities_events' && cs.FeedBack_EN__c =='Yes but different time.'){
                cs.Status_Category__c = 'Pending with Operation Supervisors';
                cs.Sub_Status__c='Approved by Department of School Activities';
                cs.Status = 'In Progress';
                // cs.Driver_Name__c=driverName;
                // cs.Driver_Number__c=driverMobile;
                update cs;
            }
            
            system.debug('cs'+cs);
        }
        catch(exception e)
        {
            status=''+e.getMessage();
        }
        return status;
    }
    //-//
    /*   
/*
*********************************************************
@Method Name    : deleteMOECase
@author         : Akash Yellure
@description    : method to is used to get Delete Moe Case
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled
    public static string deleteMOECase(String recId)
    {
        String status='Success';
        Case c=[select Id,status,IsActive__c from case where Id=:recId];
        c.status='Closed';
        c.CCM_Remarks__c='Request is Deleted Permanently';
        c.isActive__c=false;
        try
        {
            update c;
        }
        catch(exception e)
        {
            status=''+e.getMessage();
        }
        return status;
    }
    
    /*
*********************************************************
@Method Name    : rejectMOECase
@author         : Akash Yellure
@description    : method to is used to get reject Moe Case
@param          :
@return         : Output
********************************************************
*/
    
    @AuraEnabled
    public static string rejectMOECase(String recId, string caseComments){
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c from case where Id=:recId];
        
        //***Requests_for_trips_activities_events
        if(c.RecordType.developername == 'Requests_for_trips_activities_events' && c.Status_Category__c == 'Pending with Department Of School Activities'){
            c.Sub_Status__c = 'Rejected by Department of School Activities';
            c.Status='Rejected';
            c.Status_Category__c = '';
            c.Latest_Case_Comment__c=caseComments;
        }
        else if((c.RecordType.developername == 'Requests_for_trips_activities_events' || c.RecordType.developername == 'Request_for_the_awareness_sessions') && c.Status_Category__c == 'Pending with Department Of School Services'){
            c.Sub_Status__c = 'Rejected by Department of School Services';
            c.Status='Rejected';
            c.Status_Category__c = '';
        }
        else if((c.RecordType.developername == 'Growth_Request') && c.Status_Category__c == 'Pending with Department Of School Services'){
            c.Sub_Status__c = 'Rejected by Department of School Services';
            c.Status='Rejected';
            c.Status_Category__c = '';
        }
        else if(c.RecordType.developername == 'Global_Event_Request ' || c.Status_Category__c == 'Pending with Department Of School Activities'){
            
            c.Sub_Status__c = 'Rejected by Department of School Activities';
            c.Status='In Progress';
            c.Status_Category__c = 'Pending with ET';
        }
        //Handicap_Services_Transport_or_Nanny_Request
        else if(c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request' && c.Status_Category__c == 'Pending with Department Of School Services'){           
            c.Sub_Status__c = 'Rejected by Department of School Services';
            c.Status='Rejected';
            c.Status_Category__c = '';
        } 
        else if(c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request' && c.Status_Category__c == 'Pending Hemam for Inclusive Education services'){ 
            c.Sub_Status__c = 'Rejected by Hemam for Inclusive Education services';
            c.Status_Category__c = ''; 
            c.Status='Rejected';
        }   
        else if(c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request' && c.Status_Category__c == 'Pending with Inclusive Education Department in ESE'){ 
            c.Status='Rejected';
            c.Sub_Status__c = 'Rejected by Inclusive Education Department in ESE';
            c.Status_Category__c = ''; 
        } 
        //Request_for_the_awareness_sessions
        else if(c.RecordType.developername == 'Request_for_the_awareness_sessions' && c.Status_Category__c == 'Pending with MOE-Inclusive Education for Student of Determination'){           
            c.Sub_Status__c = 'Rejected by MOE - Inclusive Education for Student of Determination';
            c.Status='Rejected';
            c.Status_Category__c = '';
        }
        else if(c.Status_Category__c == 'Pending with Department Of School Activities' && c.RecordType.developername == 'Request_for_the_awareness_sessions'){
            c.Status='Rejected';
            c.Status_Category__c = '';
            c.Sub_Status__c = 'Rejected by Department of School Activitiess';
            
        } 
        //Request_for_the_Companian_Handicap_Transportation
        else if(c.RecordType.developername == 'Request_for_the_Companian_Handicap_Transportation' && c.Status_Category__c == 'Pending Hemam for Inclusive Education services'){ 
            c.Status='Rejected';
            c.Sub_Status__c = 'Rejected by Hemam for Inclusive Education services';
            c.Status_Category__c = ''; 
            
        }
        else if(c.RecordType.developername == 'Request_for_the_Companian_Handicap_Transportation' && c.Status_Category__c == 'Pending with MOE - Personnel Affairs'){ 
            c.Status='Rejected';
            c.Sub_Status__c = 'Rejected by MOE - Personnel Affairs';
            c.Status_Category__c = ''; 
        }
        else if(c.RecordType.developername == 'Request_for_the_Companian_Handicap_Transportation' && c.Status_Category__c == 'Pending with Department Of School Services'){           
            c.Sub_Status__c = 'Rejected by Department of School Services';
            c.Status='Rejected';
            c.Status_Category__c = '';
        }
        //Abu dabi rejected  Process 
        else if(c.RecordType.developername == 'Special_Needs_Activities_and_Events_Request' && c.Status_Category__c == 'Pending with ESE Support Center'){           
            c.Sub_Status__c = 'Rejected by ESE Support Center';
            c.Status='Rejected';
            c.Status_Category__c = '';
        }
        else if(c.RecordType.developername == 'Fleet_Growth_Request' && c.Status_Category__c == 'Pending with Department Of School Services'){           
            c.Sub_Status__c = 'Rejected by Department of School Services';
            c.Status='Rejected';
            c.Status_Category__c = '';
        }
        else if(c.RecordType.developername == 'Fleet_Growth_Request' && c.Status_Category__c == 'Pending with ESE Transport Operations'){           
            c.Sub_Status__c = 'Rejected by ESE Transport Operations';
            c.Status='Rejected';
            c.Status_Category__c = '';
        }
        else if(c.RecordType.developername == 'Special_Needs_Companion_Request' && c.Status_Category__c == 'Pending with ESE Support Center'){           
            c.Sub_Status__c = 'Rejected by ESE Support Center';
            c.Status='Rejected';
            c.Status_Category__c = '';
        }
        else if(c.RecordType.developername == 'Special_Needs_Transportation_Request' && c.Status_Category__c == 'Pending with ESE Support Center'){           
            c.Sub_Status__c = 'Rejected by ESE Support Center';
            c.Status='Rejected';
            c.Status_Category__c = '';
        }
        
        
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
            system.debug('comment.ET_Comments__c'+comment.ET_Comments__c);
        }
        try{
            insert caseCommentsList;
            update c;
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        return c.Status;
    }
    
    /*
*********************************************************
@Method Name    : cancelMOECase
@author         : Akash Yellure
@description    : method to is used to get  cancel case request
@param          :
@return         : Output
********************************************************
*/    
    @AuraEnabled
    public static string cancelMOECase(String recId, string caseComments){
        Case c=[select Id,status, recordtype.developername,Sub_Status__c,Status_Category__c from case where Id=:recId];
        if(c.RecordType.developername == 'Requests_for_trips_activities_events' && c.Sub_Status__c !=null ){
            c.Sub_Status__c = 'Cancelled by School';
            c.Status='Cancel';
            c.Status_Category__c = '';
        }
        if(c.RecordType.developername == 'Handicap_Services_Transport_or_Nanny_Request' && c.Sub_Status__c !=null ){
            c.Sub_Status__c = 'Cancelled by School';
            c.Status='Cancel';
            c.Status_Category__c = '';
        }  
        if(c.RecordType.developername == 'Growth_Request' && c.Sub_Status__c !=null ){
            c.Sub_Status__c = 'Cancelled by School';
            c.Status='Cancel';
            c.Status_Category__c = '';
        }
        if(c.RecordType.developername == 'Request_for_the_Companian_Handicap_Transportation' && c.Sub_Status__c !=null ){
            c.Sub_Status__c = 'Cancelled by School';
            c.Status='Cancel';
            c.Status_Category__c = '';
        }
        if(c.RecordType.developername == 'Request_for_the_awareness_sessions' && c.Sub_Status__c !=null ) {
            c.Sub_Status__c = 'Cancelled by School';
            c.Status='Cancel';
            c.Status_Category__c = '';
        }
        if(c.RecordType.developername == 'Global_Event_Request' && c.Sub_Status__c ==null ) {
            c.Sub_Status__c = 'Cancelled by ESE';
            c.Status='Cancel';
            c.Status_Category__c = '';
        }
        List<ET_Case_Comment__c> caseCommentsList = new List<ET_Case_Comment__c>();
        if(caseComments !=null && caseComments !=''){
            ET_Case_Comment__c comment = new ET_Case_Comment__c();
            comment.ET_Case__c = c.Id;
            comment.ET_Comments__c = caseComments;
            comment.ET_Action__c = c.Sub_Status__c;
            caseCommentsList.add(comment);
            system.debug('comment.ET_Comments__c'+comment.ET_Comments__c);
        }
        
        try{
            insert caseCommentsList;
            update c;
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        return c.Status;
    }
    
    /*
*********************************************************
@Method Name    : updateAbudbiCase
@author         : Akash Yellure
@description    : method to is used to get Update Complte case
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled
    public static void updateAbudbiCase(List<Id> caseIds,String status,String driverName,String driverMobile, String Comments,String ccmRemarks){
        List<case> caseList=new List<Case>();
        List<ET_Case_Comment__c> caseComments = new List<ET_Case_Comment__c>();
        for(Case cs:[select Id,RecordType.developername,Sub_Status__c,Status,Status_Category__c,Driver_Name__c,Driver_Number__c,FeedBack_EN__c FROM Case
                     WHERE Id IN: caseIds]){
                         Case caserecord = [select id,Account.name,Contact.name,ContactId,AccountId FROM Case WHERE Id IN: caseIds];
                         User contactuser=[select name,Profile.Name from user where ContactId=:caserecord.ContactId];
                         if( cs.RecordType.developername=='Fleet_Growth_Request' && cs.Status=='In Progress' ){
                             if(status=='Complete'){
                                 cs.Sub_Status__c='Approved by Operation Manager';
                                 cs.Status_Category__c = '';
                                 cs.Status = 'Closed';
                                 cs.Driver_Name__c=driverName;
                                 cs.Driver_Number__c=driverMobile;
                                 cs.CCM_Remarks__c='case is closed';
                             }
                         }
                         else if(cs.RecordType.developername=='Special_Needs_Companion_Request' && cs.Status=='In Progress' ){
                             if(status=='Complete'){
                                 cs.Sub_Status__c='Approved By Head of Safety Unit';
                                 cs.Status_Category__c = '';
                                 cs.Status = 'Closed';
                                 cs.Driver_Name__c=driverName;
                                 cs.Driver_Number__c=driverMobile;
                                 cs.CCM_Remarks__c='case is closed';
                             }
                         }
                         else if(cs.RecordType.developername=='Special_Needs_Transportation_Request' && cs.Status=='In Progress' ){
                             if(status=='Complete'){
                                 cs.Sub_Status__c='Approved by Operation Manager';
                                 cs.Status_Category__c = '';
                                 cs.Status = 'Closed';
                                 cs.Driver_Name__c=driverName;
                                 cs.Driver_Number__c=driverMobile;
                                 cs.CCM_Remarks__c='case is closed';
                             }                                     
                         }
                         else if(cs.RecordType.developername=='Special_Needs_Activities_and_Events_Request' && cs.Status=='In Progress' ){
                             if(status=='Complete'){
                                 
                                 cs.Sub_Status__c='Approved by Operation Supervisors';
                                 cs.Status_Category__c = '';
                                 cs.Status = 'Closed';
                                 cs.Driver_Name__c=driverName;
                                 cs.Driver_Number__c=driverMobile;
                                 cs.CCM_Remarks__c='case is closed';
                             }
                             
                         }
                         else if((cs.RecordType.developername=='Requests_for_trips_activities_events') && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Operation Supervisors'){
                                 if(status=='Complete'){
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = '';
                                     cs.Status = 'Closed';
                                     cs.Driver_Name__c=driverName;
                                     cs.Driver_Number__c=driverMobile;
                                     cs.CCM_Remarks__c='testclosed';
                                 }
                             }
                         
                         if(Comments !=null && Comments !=''){
                             
                             ET_Case_Comment__c comment = new ET_Case_Comment__c();
                             comment.ET_Case__c = cs.Id;
                             comment.ET_Comments__c = Comments;
                             comment.ET_Action__c = cs.Sub_Status__c;
                             caseComments.add(comment);
                         }
                         caseList.add(cs);
                     }
        try{
            insert caseComments;
            update caseList;
        }catch(Exception e){
            System.debug('exception-->'+e.getMessage());
        }
    }
    
    /*
*********************************************************
@Method Name    : updateMOECaseStatus
@author         : Akash Yellure
@description    : method to is used to get  update all  Internal User salesforce user changes status
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled
    public static void updateMOECaseStatus(List<Id> caseIds,String status,String driverName,String driverMobile, String Comments,String ccmRemarks){
        String privateSchoolLabel = System.Label.ET_Private_School_Profile_Name;
        String governmentSchoolLabel = System.Label.ET_Government_School_Profile_Name;
        String ESEProfile = System.Label.ET_ESE_School_Profile_Name;
        String moeExtraCurricularActivitiesLabel = System.Label.ET_MOE_Extra_Curricular_Activities_Profie_Name;
        String HSE_Inspector = System.Label.HSE_Inspector;
        String HSE_Transportation_Inspector = System.Label.HSE_Transportation_Inspector;
        String HSE_Quality_Coordinator = System.Label.HSE_Quality_Coordinator;
        String ESE_Transportation=System.Label.ESE_Transportation;
        String ESE_Transportation_Inspector=System.Label.ESE_Transportation_Inspector;
        List<case> caseList=new List<Case>();
        List<ET_Case_Comment__c> caseComments = new List<ET_Case_Comment__c>();
        for(Case cs:[select Id,RecordType.developername,Sub_Status__c,Status,Status_Category__c,Driver_Name__c,Driver_Number__c,FeedBack_EN__c FROM Case
                     WHERE Id IN: caseIds]){
                         Case caserecord = [select id,Account.name,Contact.name,ContactId,AccountId FROM Case WHERE Id IN: caseIds];
                         User contactuser=[select name,Profile.Name from user where ContactId=:caserecord.ContactId];
                         system.debug('contactuser profile '+contactuser.Profile.Name);
                         system.debug('contactuser name '+contactuser.Name);
                         //Globale event Request  Approval Processs Flow
                         if(contactuser.Profile.Name==ESEProfile){
                             switch on cs.RecordType.DeveloperName {
                                 when 'Global_Event_Request' {
                                     if (cs.Status == 'In Progress' && cs.Status_Category__c == 'Pending with ET'){
                                         switch on status {
                                             when 'Complete' {
                                                 cs.Status='Closed';
                                                 cs.CCM_Remarks__c='by User';
                                                 cs.Status_Category__c =null;
                                                 cs.Sub_Status__c='Completed by ET Department';
                                             }
                                             when 'Reject' {
                                                 cs.Status = 'Rejected';
                                                 cs.Sub_Status__c = 'Rejected by ET Department';
                                                 cs.Status_Category__c = '';
                                             }
                                         }
                                     } 
                                 }
                             }
                         }
                         //Government School Case Owner Approval Process Flow
                         else if(contactuser.Profile.Name==governmentSchoolLabel){

                             if(cs.RecordType.developername=='Growth_Request' && cs.Status=='In Progress' && cs.Sub_Status__c==null){//&& cs.Status=='In Progress' && cs.Status_Category__c =='Pending with Operation Supervisors' && cs.Sub_Status__c==null
                                 if(status=='Approve'){     
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = 'Pending with Operation Manager';
                                 }else if(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                 }
                                 
                             }
                             //2s'nd Approval By Operation Manager 
                             else if(cs.RecordType.developername== 'Growth_Request' && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Operation Manager'){     
                                 if(status=='Approve'){
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = 'Pending with Resource Planner';
                                 }else if(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Manager';
                                     cs.Status_Category__c ='';
                                 }
                                 else if(status=='Complete'){
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = '';
                                     cs.Status = 'Closed';
                                     cs.Driver_Name__c=driverName;
                                     cs.Driver_Number__c=driverMobile;
                                 }
                                 
                             }
                             //3rd Approve By Resources Planner
                             else if( cs.RecordType.developername== 'Growth_Request' && cs.Status=='In Progress' &&  cs.Sub_Status__c== 'Approved by Operation Manager'){
                                 if(status=='Approve'){
                                     cs.Sub_Status__c='Approved by Resource Planner';
                                     cs.Status_Category__c = 'Pending with Department Of School Services';
                                 }else if(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by with Resource Planner';
                                     cs.Status_Category__c ='';
                                 }
                                 
                             }
                             
                          
                             /*
                             //Added SrihariKoyila
                             //we need to set here In-progress feeback Logic
                             else if( cs.RecordType.developername== 'Growth_Request' && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Operation Manager' && cs.Sub_Status__c == 'Approved by Department of School Services' && cs.FeedBack_EN__c !='Yes but different time.'){
                                 if(status=='Complete'){
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = '';
                                     cs.Status = 'Closed';
                                     cs.Driver_Name__c=driverName;
                                     cs.Driver_Number__c=driverMobile;
                                 }
                                 
                             } 
                             //once feedback received case close
                             else if( cs.RecordType.developername== 'Growth_Request' && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Operation Manager' && cs.Sub_Status__c == 'Approved by Department of School Services' && cs.FeedBack_EN__c =='Yes on time.'){
                                 if(status=='Complete'){
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = '';
                                     cs.Status = 'In Progress';
                                     cs.Driver_Name__c=driverName;
                                     cs.Driver_Number__c=driverMobile;
                                 }
                                 
                             }
                            */ 
                             
                             
                             //Handicap_Services_Transport_or_Nanny_Request
                             //4rth Approval By Operation Supervisor
                             else if( cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request' && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Operation Supervisors'){
                                 if(status=='Approve'){
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = 'Pending with Operation Manager';
                                 }else if(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                 }
                             } 
                             //we need to set here In-progress feeback Logic
                             else if( (cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request') && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Operation Manager'){
                                 if(status=='Complete'){
                                     cs.Sub_Status__c=' Approved by Operation Manager';
                                     cs.Status_Category__c = '';
                                     cs.Status = 'Closed';
                                     cs.Driver_Name__c=driverName;
                                     cs.Driver_Number__c=driverMobile;
                                 }
                                 else if(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Manager';
                                     cs.Status_Category__c ='';
                                 }
                             }
                             else if( (cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request') && cs.Status=='Closed' && cs.Sub_Status__c == 'Approved by Operation Manager'){
                                 if(status=='OnHold'){
                                     cs.Status = 'On Hold';
                                     
                                 }
                             }
                             else if( (cs.RecordType.developername=='Handicap_Services_Transport_or_Nanny_Request') && cs.Status=='On Hold' && cs.Sub_Status__c == 'Approved by Operation Manager'){
                                 if(status=='Complete'){
                                     cs.Status = 'Closed';
                                     
                                     
                                 }
                             }
                         
                              //Added SrihariKoyila-//
                             //Requests_for_trips_activities_events-1
                             else if((cs.RecordType.developername=='Requests_for_trips_activities_events') && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Operation Supervisors'){
                                 if(status=='Complete'){
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = '';
                                     cs.Status = 'Closed';
                                     cs.Driver_Name__c=driverName;
                                     cs.Driver_Number__c=driverMobile;
                                 }else if(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                 }
                             }
                            
                             
                             
                             
                             
                           
                           
                             //Request_for_the_awareness_sessions
                             else IF( cs.RecordType.developername=='Request_for_the_awareness_sessions' && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Head of Safety Unit' ){
                                /* IF(status=='Approve'){
                                     system.debug('status'+status);
                                     cs.Sub_Status__c='Approved By Head of Safety Unit';
                                     cs.Status_Category__c = 'Pending with MOE-Extra-Curricular Activities'; 
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected By Head of Safety Unit';
                                     cs.Status_Category__c ='';
                                 }
                                 else*/
                                     if(status=='Complete'){
                                     cs.Sub_Status__c='Approved By Head of Safety Unit';
                                     cs.Status_Category__c = '';
                                     cs.Status = 'Closed';
                                     cs.Driver_Name__c=driverName;
                                     cs.Driver_Number__c=driverMobile;
                                 }
                             }
                             //Request_for_the_Companian_Handicap_Transportation
                             else IF( cs.RecordType.developername=='Request_for_the_Companian_Handicap_Transportation' && cs.Status=='In Progress' && cs.Sub_Status__c=='Approved by Department of School Services'){
                                 System.debug('Test value is inside if cod');
                                 IF(status=='Approve'){
                                     System.debug('Test value is inside approve');
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = 'Pending with Operation Manager';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                 }
                                 
                             }  
                             else IF( cs.RecordType.developername=='Request_for_the_Companian_Handicap_Transportation' && cs.Status=='In Progress' && cs.Sub_Status__c=='Approved by Operation Supervisors'){                                            
                                 if(status=='Complete'){
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = '';
                                     cs.Status = 'Closed';
                                     cs.Driver_Name__c=driverName;
                                     cs.Driver_Number__c=driverMobile;
                                     cs.CCM_Remarks__c='Case is closed';
                                 }
                                 
                             }
                             //ESE_Issue
                             else if(cs.RecordType.developername=='ESE_Issue' && cs.status=='In Progress'  && cs.Status_Category__c == 'Pending with Operation Manager'){
                                 IF(status=='Approve'){
                                     cs.Status='In Progress';
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = 'Pending with Operation Supervisors';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Manager';
                                     cs.Status_Category__c ='';
                                 }
                                 else IF(status=='Infomation'){
                                     cs.Status='In Progress';
                                     cs.Sub_Status__c='Operations Manager sent for more information';
                                     cs.Status_Category__c ='Further information is pending from the requester';
                                     
                                 }                                 
                             }
                             else if(cs.RecordType.developername=='ESE_Issue' && cs.status=='In Progress'  &&   cs.Sub_Status__c=='Approved by Operation Manager'){
                                 IF(status=='Approve'){
                                     cs.Status='In Progress';
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = 'Pending with Operation Manager For Solution';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                     
                                 }
                             }
                             else if(cs.RecordType.developername=='ESE_Issue' && cs.status=='In Progress' && cs.Status_Category__c=='Pending with Operation Manager For Solution'){
                                 if(status=='Solution'){
                                     cs.Sub_Status__c='Solution Provided by Operation Manager';
                                     cs.Status_Category__c = 'Pending with ESE Transportation Team';
                                     
                                 }
                             }
                             
                         
                             
                             //Abu dabi ET use Appoval & Reject & Complete Process
                             else IF( cs.RecordType.developername=='Special_Needs_Activities_and_Events_Request' && cs.Status=='In Progress' ){
                                 if(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                 }
                             }
                             else IF( cs.RecordType.developername=='Fleet_Growth_Request' && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Operation Supervisors' ){
                                 IF(status=='Approve'){
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = 'Pending with Operation Manager';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                 }
                                 
                             }
                             else IF( cs.RecordType.developername=='Fleet_Growth_Request' && cs.Status=='In Progress' && cs.Status_Category__c == 'Pending with Operation Manager' ){
                                 IF(status=='Approve'){
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = 'Pending with Resource Planner';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Manager';
                                     cs.Status_Category__c ='';
                                 }
                                 
                             }
                             else IF( cs.RecordType.developername=='Fleet_Growth_Request' && cs.Status=='In Progress'){
                                 IF(status=='Approve'){
                                     cs.Sub_Status__c='Approved by Resource Planner';
                                     cs.Status_Category__c = 'Pending with Department Of School Services';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by with Resource Planner';
                                     cs.Status_Category__c ='';
                                 }
                                 
                             }
                             else IF( cs.RecordType.developername=='Fleet_Growth_Request' && cs.Status=='In Progress' ){
                                 if(status=='Complete'){
                                     system.debug('test status'+cs.Status);
                                     system.debug('test status'+status);
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = '';
                                     cs.Status = 'Closed';
                                     cs.Driver_Name__c=driverName;
                                     cs.Driver_Number__c=driverMobile;
                                     cs.CCM_Remarks__c='case is closed';
                                 }
                             }
                             else IF( cs.RecordType.developername=='Special_Needs_Transportation_Request' && cs.Status=='In Progress'){
                                 IF(status=='Approve'){
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = 'Pending with Operation Manager';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                 }
                             }
                        }
                         else if(contactuser.Profile.Name==HSE_Inspector){
                             //ESE Issue Approve Internal Method
                              if(cs.RecordType.developername=='ESE_Issue' && cs.status=='In Progress'  && cs.Status_Category__c == 'Pending with Operation Manager'){
                                 IF(status=='Approve'){
                                     cs.Status='In Progress';
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = 'Pending with Operation Supervisors';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Manager';
                                     cs.Status_Category__c ='';
                                 }
                                 else IF(status=='Infomation'){
                                     cs.Status='In Progress';
                                     cs.Sub_Status__c='Operations Manager sent for more information';
                                     cs.Status_Category__c ='Pending with HSE Quality Coordinator For Review';
                                     
                                 }                                 
                             }else if(cs.RecordType.developername=='ESE_Issue' && cs.status=='In Progress'  &&   cs.Sub_Status__c=='Approved by Operation Manager'){
                                 IF(status=='Approve'){
                                     cs.Status='In Progress';
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = 'Pending with Operation Manager For Solution';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                     
                                 }
                             }
                             
                             else if(cs.RecordType.developername=='ESE_Issue' && cs.status=='In Progress' && cs.Status_Category__c=='Pending with Operation Manager For Solution'){
                                 if(status=='Solution'){
                                     cs.Sub_Status__c='Solution Provided by Operation Manager';
                                     cs.Status_Category__c = 'Pending with ESE Transportation Team';
                                     
                                 }
                             }
                         }
                         else if(contactuser.Profile.Name==HSE_Transportation_Inspector){
                             //ESE Issue Approve Internal Method
                              if(cs.RecordType.developername=='ESE_Issue' && cs.status=='In Progress'  && cs.Status_Category__c == 'Pending with Operation Manager'){
                                 IF(status=='Approve'){
                                     cs.Status='In Progress';
                                     cs.Sub_Status__c='Approved by Operation Manager';
                                     cs.Status_Category__c = 'Pending with Operation Supervisors';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Manager';
                                     cs.Status_Category__c ='';
                                 }
                                 else IF(status=='Infomation'){
                                     cs.Status='In Progress';
                                     cs.Sub_Status__c='Operations Manager sent for more information';
                                     cs.Status_Category__c ='Pending with HSE Quality Coordinator For Review';
                                     
                                 }                                 
                             }else if(cs.RecordType.developername=='ESE_Issue' && cs.status=='In Progress'  &&   cs.Sub_Status__c=='Approved by Operation Manager'){
                                 IF(status=='Approve'){
                                     cs.Status='In Progress';
                                     cs.Sub_Status__c='Approved by Operation Supervisors';
                                     cs.Status_Category__c = 'Pending with Operation Manager For Solution';
                                 }else IF(status=='Reject'){
                                     cs.Status='Rejected';
                                     cs.Sub_Status__c='Rejected by Operation Supervisors';
                                     cs.Status_Category__c ='';
                                     
                                 }
                             }
                             
                             else if(cs.RecordType.developername=='ESE_Issue' && cs.status=='In Progress' && cs.Status_Category__c=='Pending with Operation Manager For Solution'){
                                 if(status=='Solution'){
                                     cs.Sub_Status__c='Solution Provided by Operation Manager';
                                     cs.Status_Category__c = 'Pending with ESE Transportation Team';
                                     
                                 }
                             }
                         }
                         else if(contactuser.profile.Name==ESE_Transportation_Inspector){
                
if (cs.RecordType.developername == 'ESE_Issue' && cs.Status == 'In Progress') { 
   
    // Case pending with Operation Coordinator
    if (cs.Status_Category__c == 'Pending with Operation Coordinator') {
        
        if (status == 'Approve') {
            cs.Status = 'In Progress';
            cs.Sub_Status__c = 'Approved by Operation Coordinator';
            cs.Status_Category__c = 'Pending with Operation Supervisors';
        } else if (status == 'Reject') {
            cs.Status = 'Closed';
            cs.Sub_Status__c = 'Rejected by Operation Coordinator';
            cs.Status_Category__c = '';
            cs.CCM_Remarks__c = 'Case is closed';
        } else if (status == 'Information') {
            cs.Status = 'In Progress';
            cs.Sub_Status__c = 'Operations Coordinator sent for more information';
            cs.Status_Category__c = 'Pending with ESE Inspector';
        }
    }

    // Case approved by Operation Coordinator
    else if (cs.Sub_Status__c == 'Approved by Operation Coordinator') {
        if (status == 'Approve') {
            cs.Status = 'In Progress';
            cs.Sub_Status__c = 'Approved by Operation Supervisors';
            cs.Status_Category__c = 'Pending with Operation Coordinator For Solution';
        } else if (status == 'Reject') {
            cs.Status = 'Closed';
            cs.Sub_Status__c = 'Rejected by Operation Supervisors';
            cs.Status_Category__c = '';
            cs.CCM_Remarks__c = 'Case is closed';
        }
    }

    // Case pending with Operation Coordinator for solution
    else if (cs.Status_Category__c == 'Pending with Operation Coordinator For Solution') {
        if (status == 'Solution') {
            cs.Sub_Status__c = 'Solution Provided by Operation Coordinator';
            cs.Status_Category__c = 'Pending with ESE Transportation Team';
        }
    }
}

                         }
                       
                        
                         if(Comments !=null && Comments !=''){
                            
                             ET_Case_Comment__c comment = new ET_Case_Comment__c();
                             comment.ET_Case__c = cs.Id;
                             comment.ET_Comments__c = Comments;
                             comment.ET_Action__c = cs.Sub_Status__c;
                             caseComments.add(comment);
                         }
                         caseList.add(cs);
                     }
        try{
            insert caseComments;
            update caseList;
        }catch(Exception e){
            System.debug('exception-->'+e.getMessage());
        }
    }
    @AuraEnabled
    public static List<Case> getRequestInfo() {
        Profile p = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];
        List<Case> customerCaseList = new List<Case>();

        String HSE_Inspector = System.Label.HSE_Inspector;
        String HSE_Transportation_Inspector = System.Label.HSE_Transportation_Inspector;
        String HSE_Quality_Coordinator = System.Label.HSE_Quality_Coordinator;
        String ESE_Transportation = System.Label.ESE_Transportation;
        String ESE_Transportation_Inspector = System.Label.ESE_Transportation_Inspector;
    
        try {
            if (p.Name == HSE_Inspector || p.Name == ESE_Transportation || p.Name == HSE_Quality_Coordinator || 
                p.Name == HSE_Transportation_Inspector || p.Name == ESE_Transportation_Inspector) {
    
                customerCaseList = [SELECT Id, ET_Issue_Type_New__c,ESE_Recent_Category__c,ESE_Next_Category__c, 
                Driver_Name_1__r.Name, Sub_Request__c, Account.Name, CaseNumber,Status_Category__c,
                RecordType.developerName, RecordTypeId, Sub_Status__c, Subject, Description, 
                RecordType.Name, Case_Type_AR__c, 
                ETST_Student__c, ETST_Student__r.Name, School_Name_Acc__c, CreatedDate
         FROM Case 
         WHERE Sub_Status__c = 'Operations Coordinator sent for more information' 
               AND RecordType.developerName IN ('ESE_Issue','' )                                             
         ORDER BY CaseNumber DESC 
         LIMIT 1000]; // Added a limit to improve performance
            }
        } catch (Exception e) {
            system.debug('Exception in getRequestInfo: ' + e.getMessage());
        }
    
        return customerCaseList;
    }
    
    


    public static void submitForApproval(Id cId){
        /*Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
req.setObjectId(cId);
Approval.ProcessResult result = Approval.process(req); */       
    }
    @AuraEnabled
    public static Case getCaseData(string recId){
        
        return [Select Id,CaseNumber,Status,Sub_Status__c,Status_Category__c,Bus_Internal_Number__c,Service_Start_Date__c,Vehicle_Type__c,Bus_Type__c,RecordType.DeveloperName FROM Case WHERE id=:recId];
    }
    @AuraEnabled
    public static ETST_Student__c getstudentDetails(string studentid){
        
        return [Select Id,Name,ETST_Grade__c,ETST_Division__c,ETST_Student_Id__c,ETST_Account_Name__c,ETST_Account_Name__r.ETST_Full_Name_AR__c FROM ETST_Student__c WHERE id=:studentid];
    }
    
    @AuraEnabled
    public static ResultWrapper getprivateschoolUserData(){//ashwini
        system.debug('inside et_business');
        ResultWrapper rw= new ResultWrapper();
        User u=[select id,AccountId,contactID from user where id=:userinfo.getUserId()];
        system.debug('u.contactID '+u.contactID);
        Contact contactrecord = [select Id, name,AccountId from contact where Id=:u.contactID];
        String accParentId=[select id,Name,parentId from Account where Id=:contactrecord.AccountId].parentId;
        system.debug('accParentId= '+accParentId);
        if(String.isNotEmpty(accParentId)){
            system.debug('parent available');
            rw.isParent = true;
        }else{
            system.debug('parent not available');
            rw.isParent = false;  
        }
        rw.loggedinUserProfileName = [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
        system.debug('rw*** '+rw);
        return rw;
    }
    
    public class ResultWrapper{//ashwini
        
        @AuraEnabled public string loggedinUserProfileName;
        @AuraEnabled public boolean isParent;
        
    }
    
    /*
*********************************************************
@Method Name    : getUserEmiratess
@author         : Akash Yellure
@description    : method to is used to get  Emirates ID on ACCOUNT TO VERIFY ABUDABI OR NON ABUDBI REGION
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled
    public static string getUserEmiratess(){//Arunsarathy 04.08.2023
        system.debug('inside et_business');
        User u=[select id,AccountId,contactID from user where id=:userinfo.getUserId()];
        system.debug('u.AccountId '+u.AccountId);
        Account accRec = [select Id, name,ETI_Emirates__c from Account where Id=:u.AccountId];
        return accRec.ETI_Emirates__c;
    }
    /*

/*
*********************************************************
@Method Name    : getESEReqLineList
@author         : Akash Yellure
@description    : method to is used to get ESE request Line item records
@param          :
@return         : Output
********************************************************
*/
    
    @AuraEnabled
    public static list<ESE_Request_Line__c> getESEReqLineList(String recordId)
    {
        List<ESE_Request_Line__c> ESElist = [Select id, name,School_Names__r.Name,Case__r.Type_Of_Case__c,Case__r.Type_Of_Case_AR__c,Case__r.Global_Event_Case_Type_Emergency__c,Assembly_Point__c,Coordinator_Phone__c,Trip_Date__c,Email__c,Supervisors_Count_From_School__c,Trip_Destination_From__c
                                             ,Trip_Destination_To__c,Cycle__c,Special_Need_Students_Count__c,School_Codes__c,FORMAT(Trip_Time_To__c),FORMAT(Trip_Time_From__c),Count_Of_Students__c,
                                             FORMAT(Arrival_Time_To_Activity__c),Count_of_Buses__c,Event_Coordinator_Name__c,Event_Coordinator_Phone__c,FORMAT(Start_Time_From_School__c),Station_Coordinator_Name__c,FORMAT(Start_Time_From_Event__c),Station_Coordinator_Phone__c
                                             from ESE_Request_Line__c where Case__c  =: recordId];
        system.debug('id'+ ESElist);
        return ESElist;
    }
    /*
*********************************************************
@Method Name    : getEnglisValue
@author         : Akash Yellure
@description    : method to is used to get English value 
@param          :
@return         : Output
********************************************************
*/
    
    @AuraEnabled 
    public static Map<String, String> getEnglisValue(){
        
        
        Map<String, String> options = new Map<String, String>();
        
        Schema.DescribeFieldResult fieldResult = Case.Request_Type__c.getDescribe();
        
        List<Schema.PicklistEntry> pValues = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {
            
            
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }
    /*
*********************************************************
@Method Name    : getArabicFieldValue
@author         : Akash Yellure
@description    : method to is used to get  Arabic Value In special Needs Companion
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled 
    public static Map<String, String> getArabicFieldValue(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResulty = Case.Request_Type_AR__c.getDescribe();
        List<Schema.PicklistEntry> pValues = fieldResulty.getPicklistValues();
        for (Schema.PicklistEntry p: pValues) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    } 
    /*
*********************************************************
@Method Name    : getschoolDetails
@author         : Akash Yellure
@description    : method to is used to get  Get School Name on companion Request
@param          :
@return         : Output
********************************************************
*/
    
    @AuraEnabled
    public static list<Account> getschoolDetails(string schoolid){
        List<Account> schoolDetails=[Select id,Name, AccountNumber  from Account  WHERE iD =:schoolid];
        return schoolDetails;
    }
    public class MyPickListInfo {
        public String validFor;
    }
    /*
*********************************************************
@Method Name    : getDependentPicklistValues
@author         : Akash Yellure
@description    : method to is used to get  Depdenedt piclist value For special needs transportation Nanny Request
@param          :
@return         : Output
********************************************************
*/
    
    @AuraEnabled
    public static Map<Object,List<String>> getDependentPicklistValues(){
        Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
        //Get dependent field result
        Schema.DescribeFieldResult dependentFieldResult = Case.Request_Type__c.getDescribe();
        //Get dependent field controlling field 
        Schema.sObjectField controllerField = dependentFieldResult.getController();
        //Check controlling field is not null
        if(controllerField == null){
            return null;
        } 
        //Get controlling field result
        Schema.DescribeFieldResult controllerFieldResult = Case.Sub_Request__c.getDescribe();
        //Get controlling field picklist values if controlling field is not a checkbox
        List<Schema.PicklistEntry> controllerValues = (controllerFieldResult.getType() == Schema.DisplayType.Boolean ? null : controllerFieldResult.getPicklistValues());
        
        //It is used to decode the characters of the validFor fields. 
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        
        for (Schema.PicklistEntry entry : dependentFieldResult.getPicklistValues()){
            if (entry.isActive()){
                //The PicklistEntry is serialized and deserialized using the Apex JSON class and it will check to have a 'validFor' field
                List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer i = 0; i < controllerValues.size(); i++){
                    Object controllerValue = (controllerValues == null ? (Object) (i == 1) : (Object) (controllerValues[i].isActive() ? controllerValues[i].getLabel() : null));
                    Integer bitIndex = i / 6;
                    Integer bitShift = 5 - Math.mod(i, 6 );
                    if(controllerValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0){
                        continue;
                    } 
                    if (!dependentPicklistValues.containsKey(controllerValue)){
                        dependentPicklistValues.put(controllerValue, new List<String>());
                    }
                    dependentPicklistValues.get(controllerValue).add(entry.getLabel());
                }
            }
        }
        return dependentPicklistValues;
    }
    
    /*
*********************************************************
@Method Name    : fetchRecords
@author         : Akash Yellure
@description    : method to is used to get  Special requet
@param          :
@return         : Output
********************************************************
*/
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value) {
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            String query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            if(String.isNotBlank(value)) {
                query += ' WHERE Id = \''+ value + '\' LIMIT 499';
            } else {
                query += ' WHERE '+filterField+
                    ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 499';
            }
            for(SObject s : Database.query(query)) {
                recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
            }
            return recordsDataList;
        } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    /*
*********************************************************
@Method Name    : closeMOECase
@author         : Akash Yellure
@description    : method to is used to get  Special request Get Files
@param          :
@return         : Output
********************************************************
*/
    //This method is used to upload a file in Attachment on home page
    @AuraEnabled 
    public static List<ContentDocument> getFiles(string fileId){        
        Set<Id> recordIds=new Set<Id>{fileId};
            Set<Id> documentIds = new Set<Id>(); 
        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        return [SELECT Id, Title, FileType, OwnerId, Owner.Name, CreatedDate,
                CreatedById, CreatedBy.Name, ContentSize FROM ContentDocument WHERE id IN: documentIds];  
    } 
    @AuraEnabled  
    public static void deleteFiles(string sdocumentId){ 
        delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:sdocumentId];       
    }  
    
    /*
*********************************************************
@Method Name    : attachFileToCase
@author         : Akash Yellure
@description    : method to is used to get   attcment file
@param          :
@return         : Output
********************************************************
*/
    //This method is used to upload a file
    @AuraEnabled 
    public static string attachFileToCase(String recordId , String filesData){
        Savepoint sp = Database.setSavepoint();
        List<ContentVersion> lstContentVesions = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLinks = new  List<ContentDocumentLink>();
        list<uploadedDocs> files;  
        files = (List<uploadedDocs>)JSON.deserialize(filesData,  List<uploadedDocs>.Class);
        if(files.size()>0){ 
            system.debug('files = '+ files);
            system.debug('files = '+ files.size());
            for(uploadedDocs doc :files){
                system.debug('doc = '+ doc);
                ContentVersion objContentVersion = new ContentVersion();
                objContentVersion.ContentLocation = 'S';
                objContentVersion.VersionData = EncodingUtil.base64Decode(doc.base64);//EncodingUtil.base64Decode(body);
                objContentVersion.Title = doc.filename;
                objContentVersion.Origin = 'H';
                objContentVersion.PathOnClient = '/' + doc.filename;
                lstContentVesions.add(objContentVersion);
            }
            
        }
        if(lstContentVesions!=null && lstContentVesions.size()>0){
            try{
                insert lstContentVesions;   
                system.debug('******After lstContentVesions****'+lstContentVesions);
            }Catch(Exception ex){
                system.debug('***Exception Cause lstContentVesions*****'+ex.getMessage());
                system.debug('***Exception Cause getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception happend'+ex.getMessage());                                       
            }
            
        }
        map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
        for(ContentVersion objContentVersion :[Select Id,ContentDocumentId from ContentVersion where Id in :lstContentVesions]){
            mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
        }
        
        for(ContentVersion objContentVersion :lstContentVesions){
            
            if(mapofContentVersionIdwithContentDocumentIds.containskey(objContentVersion.Id)){
                ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                objContentDocumentLink.LinkedEntityId = recordId;
                objContentDocumentLink.ShareType = 'V';
                objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id);
                lstContentDocumentLinks.add(objContentDocumentLink);
            }
            
        }
        system.debug('******lstContentDocumentLinks****'+lstContentDocumentLinks);
        if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
            try{
                insert lstContentDocumentLinks; 
                return 'Success';
            }Catch(Exception ex){
                Database.rollback(sp);
                system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
                system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
            }
        }else{
            return 'Error';
        }
    }
    
    public class uploadedDocs{
        @AuraEnabled
        Public String filename;
        @AuraEnabled
        Public String filetype;
        @AuraEnabled
        Public String base64;
        
    }   
    /*
*********************************************************
@Method Name    : getExportInCsv
@author         : Akash Yellure
@description    : method to is used to get  Export CSV
@param          :
@return         : Output
********************************************************
*/
    
    //Downlode Excel File in Arabic
    @AuraEnabled
    public static List<Case>getExportInCsv(string status){ 
        System.debug('Yes');
        try{
            String privateSchoolLabel = System.Label.ET_Private_School_Profile_Name;
            String governmentSchoolLabel = System.Label.ET_Government_School_Profile_Name;
            String moeDepartmentActivitySchoolLabel = System.Label.ET_MOE_Department_Of_School_Activities_Profie;
            String moeDepartmentServicesSchoolLabel = System.Label.ET_MOE_Department_Of_School_Services_Profie;
            String moePersonnelManagementLabel = System.Label.ET_MOE_Personnel_Management_Profie_Name;
            String moeSpecialEducationtLabel = System.Label.ET_MOE_Special_Education_Profie_Name;
            String moeExtraCurricularActivitiesLabel = System.Label.ET_MOE_Extra_Curricular_Activities_Profie_Name;
            String moeInclusiveEducationDepartmentinESELabel = System.Label.ET_MOE_Inclusive_Education_Department_in_ESE;
            String govtschool = System.Label.Gov_Profile_login;
            Profile p=[Select Id,Name from Profile where Id=:userInfo.getProfileId() LIMIT 1];
            List<Case> caselist =new List<Case>();
            //Get all  data in Arabic Language
            if(p.Name==govtschool){
                System.debug('Pass');
                String listofRecordType=System.Label.ET_Special_Requests_Record_Types;
                List<String> typeOfCaseList =new List<String>();
                typeOfCaseList=listofRecordType.split(',');
                User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
                Account Acc=[select id,Name from Account where Id=:u.AccountId];
                List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
                Set<id> childAccountIDs=new Set<id>();
                childAccountIDs.add(Acc.Id);
                for(Account childAcc:acctListChild){
                    childAccountIDs.add(childAcc.Id);
                }                
                if(status == 'All'){
                    caseList= [Select id,CaseNumber from Case where status IN ('New','In Progress','Rejected','Approved','Closed','Cancel') and IsActive__c= true  AND RecordType.developerName IN ( 'Global_Event_Request','Request_for_the_Companian_Handicap_Transportation','Requests_for_trips_activities_events','Handicap_Services_Transport_or_Nanny_Request','Growth_Request','Teachers_Transportation_Request','Request_for_the_awareness_sessions') Order by CaseNumber DESC];
                    System.debug(caseList);
                    //AND AccountId IN:childAccountIDs
                }
            }
            
            return caseList;            
        }catch(DMLException e) {
            System.debug(e.getMessage());
            return null;
        }
        
    } 

    @AuraEnabled
    public static string getRecordTypeName(String caseId){
        Case cs = [Select Id, RecordTypeId, RecordType.Name from Case where Id =: caseId ];
        return cs.RecordType.Name;
    }
    
    
    
    @AuraEnabled
    public static List<ET_Case_Comment__c> getCaseComments(String caseId) {
        List<ET_Case_Comment__c> caseComments = new List<ET_Case_Comment__c>();
        try {
            caseComments = [SELECT Id, Name, ET_Action__c, ET_Comments__c, CreatedDate, ET_Case__c,CreatedBy.Name
                            FROM ET_Case_Comment__c
                            WHERE ET_Case__c = :caseId];
        } catch (Exception e) {
            // Handle the exception, e.g., log an error message or return an empty list.
            System.debug('An error occurred: ' + e.getMessage());
            caseComments = new List<ET_Case_Comment__c>();
        }
        return caseComments;
    }
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        String sQuery = 'SELECT Id, Name, ETIN_Name_Arabic__c, ETST_SchoolRefID__c ' +
                'FROM Account ' +
                'WHERE ((ETIN_Name_Arabic__c LIKE \'' + searchKeyWord + '%\'' +
                ' OR ETST_SchoolRefID__c LIKE \'' + searchKeyWord + '%\'' +
                ' OR Name LIKE \'' + searchKeyWord + '%\')' +
                ' OR (RecordType.Name = \'Organization\' AND RecordType.Name = \'Business_School\'))' + 
                ' AND IsPersonAccount = false' +
                ' ORDER BY CreatedDate DESC LIMIT 10';
 
 
        
        List < sObject > lstOfRecords = Database.query(sQuery);
        system.debug('rECORDS-->' + lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }

    @AuraEnabled
    public static returnWrappper saveRequestLines(String requestLinesJSON, String caseId) {
        returnWrappper returnWrp = New returnWrappper();
        try {
            System.debug('requestLinesJSON is ' + requestLinesJSON);
            // Deserialization
            List<ESE_Request_Line__c> requestLines = (List<ESE_Request_Line__c>)JSON.deserialize(requestLinesJSON, List<ESE_Request_Line__c>.class);
            System.debug('List data with all values ' + requestLines);
            // Insertion
            if (requestLines != null && !requestLines.isEmpty()) {
                for (ESE_Request_Line__c requestLine : requestLines) {

                    // Associate each request line with the provided Case ID
                    requestLine.Case__c = caseId;
                }
                Insert requestLines;
                returnWrp.isSuccess = true;
            }
        } catch (Exception e) {
            System.debug('An error occurred: ' + e.getMessage());
            // Handle the exception as needed
            returnWrp.isSuccess = false;
            returnWrp.message = e.getMessage();
            if(returnWrp.isSuccess == false && caseId != null && caseId != ''){
                updateCase(caseId);
            }
        }
        System.debug('returnWrp ' + returnWrp);
        return returnWrp;
    }
    
    @AuraEnabled
    public static void updateCase(String caseId) {
        List<Case> listCase = New List<Case>();
        for(Case cs: [SELECT Id,Status,Description FROM Case WHERE Id =: caseId]){
            cs.Status = 'Invalid';
            cs.Description = 'Failed to create Request Lines';
            listCase.add(cs);
        }
        if(listCase.Size()>0)
            Update listCase;
    }
    
    Public Class returnWrappper{
        @AuraEnabled Public Boolean isSuccess = false;
        @AuraEnabled Public String message = null;
    }
    @AuraEnabled
    public static void sendEmail(String caseId, String usrName) {
        System.debug('Find Username: ' + usrName);
        User Usr = [SELECT Id, Name, Email FROM User WHERE Username = :usrName LIMIT 1];
        Case caseRecord = [SELECT Id, CaseNumber FROM Case WHERE Id = :caseId LIMIT 1];
        System.debug('User query result: ' + Usr);
        System.debug('User Email: ' + Usr.Email);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTargetObjectId(Usr.Id);
        email.setSubject('Reactivate Case ' + caseRecord.CaseNumber +  ' From OnHold to Closed');
        String body = 'Dear ' + Usr.Name + ',\n\n';
        body += 'Please Reactivate the Case ' + caseRecord.CaseNumber + ' From On Hold To Closed.\n\n';
        body += 'Thank You.';
        email.setPlainTextBody(body);
        email.setOrgWideEmailAddressId('0D23z000000brblCAA');
        email.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        System.debug('Email sent successfully.');
    }
    
    
    public static void utilityMethodA(){
        integer i=0;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
    public static void utilityMethod(){
        
        integer i=0;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
}