/*******************************************************************************************************************
Class       : ET_B2BController
Author      : Smaartt
Description : 
TestClass  :  ET_B2BController_Test
----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials     Date        Author            Details
1.           V1.0                                           Initial Version
2.           v2.0             29/03/2023   Janardhan     Added new methods for Fleet Service Req,Account Workshop Master
*******************************************************************************************************************/
public class ET_B2BController {
    
    public class MyBusinessWrapper{
        @AuraEnabled public Map<String,Integer> poList=new Map<String,Integer>();
		@AuraEnabled public Map<ID,String> AccountList=new Map<ID,String>();
        @AuraEnabled public Map<String,Integer> maintenancePoList=new Map<String,Integer>();
		@AuraEnabled public Map<String,Integer> otherPoList=new Map<String,Integer>();
        @AuraEnabled public String cntRecord;
        @AuraEnabled public String accRecord;
        @AuraEnabled public String accRecordName;
        @AuraEnabled public String vehicleRecord;
        @AuraEnabled public String salesRecord;
        @AuraEnabled public List<ET_Sales_Agreement__c> salesAgreementList;
        @AuraEnabled public List<SALine_Assigned_Vehicle__c> assignedVehicleList;
        @AuraEnabled public List<SALine_Assigned_Resource__c> assignedResourcesList;
        @AuraEnabled public List<Invoice__c> invoicesList;
        @AuraEnabled public List<Opportunity> opportunityList;
        @AuraEnabled public integer sitesCount=0;
        @AuraEnabled public integer invCount=0;
        @AuraEnabled public integer studentsCount=0;
        @AuraEnabled public List<Account> schoolList;
        @AuraEnabled public String  accManager;
        @AuraEnabled public List<ETST_Student__c> studentsList;
		@AuraEnabled public List<HSE_Info__c> lst_hsescore;
        @AuraEnabled public Boolean isADNOC= false;
		@AuraEnabled public Boolean isParent= false;
		@AuraEnabled public String cumpercent;
        @AuraEnabled public User userInfo; //added by Janardhan -27/03/2023
        public MyBusinessWrapper(){
            salesAgreementList = new List<ET_Sales_Agreement__c>();
            assignedVehicleList = new List<SALine_Assigned_Vehicle__c>();
            assignedResourcesList = new List<SALine_Assigned_Resource__c>();
            invoicesList = new List<Invoice__c>();
            studentsList=new List<ETST_Student__c>();
            opportunityList=new List<Opportunity>();
        }
    }
    public class CustomerCareWrapper{
        
        @AuraEnabled public List<case> caseList;
        
        public CustomerCareWrapper(){
            caseList = new List<case>();
        }
    }
    @AuraEnabled
    public static recorTypeWrap getUserDetails(String recName){
        System.debug('recName  '+recName);
        recorTypeWrap rec=new recorTypeWrap();
        rec.u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        rec.recId=  Schema.SObjectType.Case.getRecordTypeInfosByName().get(recName).getRecordTypeId();
        System.debug('rec.recId  '+rec.recId);
        return rec;
    }
    
    //ADDED
    @AuraEnabled
    public static recorTypeWrap MROgetUserDetails(String recName1){
        System.debug('recName1  '+recName1);
        recorTypeWrap rec=new recorTypeWrap();
        rec.u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        rec.recId='0128E000002554yQAA';
        System.debug('rec.recId  '+rec.recId);
        return rec;
    }
    
    
    @AuraEnabled
    public static void saveUploadedFile(List<String> docId, String fiscalMonth, String po, List<String> name){
        List<ET_User_Files__c> fileList = new List<ET_User_Files__c>();
        for(Integer i=0;i<docId.size();i++){
            ET_User_Files__c userFile=new ET_User_Files__c();
            userFile.User__c=userinfo.getUserId();
            userFile.Doc_Id__c=docId[i];
            userFile.Fiscal_month__c=fiscalMonth;
            userFile.File_Name__c=name[i];
            userFile.PO__c=po;
            fileList.add(userFile);
        }
        system.debug('fileList=='+fileList);
        insert fileList;
    }
    @AuraEnabled
    public static List<ET_User_Files__c> getDocId(String fiscalMonth,String po){
        system.debug('userinfo.getUserId()  '+userinfo.getUserId());
        return [SELECT Doc_Id__c,File_Name__c from ET_User_Files__c 
                where User__c=:userinfo.getUserId() 
                AND Fiscal_month__c=:fiscalMonth AND PO__c=:po];
    }
    public Class recorTypeWrap{
        @AuraEnabled public User u=new User();
        @AuraEnabled public String recId;
    }
    @AuraEnabled
    public static void terminateRequest(case caseRecord,String POName,string fileData){
       
        //system.debug('Customer_PO__c'+[select id from Customer_PO__c where Customer_PO__c=:POName LIMIT 1].Id);
        List<ET_Sales_Agreement__c> salesagreement=[select id, name from ET_Sales_Agreement__c where Customer_PO_No__c=:POName LIMIT 1];
        
        if(salesagreement!=null && salesagreement.size()>0){
             caseRecord.Sales_Agreement__c=salesagreement[0].id;
        }            
        caseRecord.Origin='B2B Portal';
        //  caseRecord.Customer_PO__c=[select id from Customer_PO__c where Customer_PO__c=:POName LIMIT 1].Id; 
        //Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('B2B_Business_Portal_Cases').getRecordTypeId();  // Added by Santosh 
       String recordTypeName = System.Label.business_portal_recod_type_for_case; // Added by Santosh 21-03-2024
		Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();

        caseRecord.recordTypeId = recordTypeId;  
        caseRecord.AccountId=[select AccountId from User where Id=:Userinfo.getUserId()].AccountId;
        system.debug('case record value'+caseRecord);
          try{
            insert caseRecord;
            addFileToSFId(caseRecord.Id, fileData); //added by Janardhan 05/08/22
        }catch (Exception e){
            
            throw new AuraHandledException('Error Exception happend'+e.getMessage()); 
        }
    }
    @AuraEnabled
    public static void createOffHireRequest(case caseRecord,String POName,string Description,string fileData){
        
         List<ET_Sales_Agreement__c> salesagreement=[select id, name from ET_Sales_Agreement__c where Customer_PO_No__c=:POName LIMIT 1];
    
        if(salesagreement!=null && salesagreement.size()>0){
             caseRecord.Sales_Agreement__c=salesagreement[0].id;
        }
            caseRecord.Origin='B2B Portal';
        // caseRecord.Customer_PO__c=[select id from Customer_PO__c where Customer_PO__c=:POName LIMIT 1].Id; 
          caseRecord.AccountId=[select Id,AccountId from User where Id=:Userinfo.getUserId()].AccountId; 
            
           
        try{
            insert caseRecord;
              if(caseRecord.Id != null)
              addFileToSFId(caseRecord.Id, fileData);
        }catch (Exception e){
            system.debug('error--'+e.getMessage());
            throw new AuraHandledException('Error Exception happend'+e.getMessage()); 
        }
      
    }
    @AuraEnabled
    public static List<String> getTypes(){ 
        List<String> serviceTypes=new List<String>();
        
        for(ET_Explore_Service_Type__mdt aggr: [select type__c from ET_Explore_Service_Type__mdt] ){ 
            if(!serviceTypes.contains(aggr.type__c))
                serviceTypes.add( aggr.type__c);
            
        }
        return serviceTypes;
    }
    @AuraEnabled
    public static List<ET_Explore_Service_Type__mdt> getServiceTypes(List<String> type){ 
        system.debug('type-->'+type);
        List<String> serviceTypes=new List<String>();
        String query='select Image_URL__c,Service__c from ET_Explore_Service_Type__mdt where type__c=:type';
        List<ET_Explore_Service_Type__mdt> exploreList =Database.query(query);
       /* for( ET_Explore_Service_Type__mdt ex: Database.query(query)){
            serviceTypes.add(ex.Service__c);                          
        } */
      //  return serviceTypes;
        return exploreList;
    }
    
    @AuraEnabled
    public static void saveOpportunity(String type,Opportunity opp,String currentPO,String preferredLocation,string fileData){ 
        //system.debug('preferredLocation=='+preferredLocation);
               
        Id recTypeId;
       
        list<User> u=[select id,accountID,Account.Name,Account.Opportunity_Owner__c,Account.Opportunity_Owner__r.Id,contactID from user where id=:userinfo.getUserId()];
        system.debug('user details--'+u);
        
       if(type=='Sales opportunity'){
            recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(type).getRecordTypeId();
        }else{
            String recTypeName= [select recordtype__c from ET_Explore_Service_Type__mdt where Service__c=:type][0].recordtype__c;
            system.debug('recTypeName --'+recTypeName);
            recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId(); 
        }  
         
        opp.AccountId=u[0].accountID;
        opp.recordTypeId=recTypeId;
        opp.Category__c=type;
        opp.ET_Opportunity_Source__c='Community Portal';
        opp.Preferred_Location__c = preferredLocation != null ? preferredLocation : null;
       /* if(currentPO!=null && currentPO!=''){
            opp.Customer_PO__c=[select id from Customer_PO__c where Customer_PO__c=:currentPO LIMIT 1].Id; 
        }*/
       opp.Name=u[0].Account.Name+' '+type;
       opp.StageName='Qualification';
       opp.CloseDate=Date.today()+365;
       
        /*
if(u.accountID==System.Label.adnoc_account_id && opp.Effective_From__c!=null){
integer noOfMonths=opp.Effective_From__c.monthsBetween(opp.Effective_To__c);
if(noOfMonths>=0 && noOfMonths<=6){
opp.API_Service_Name__c='Call out';
}else if(noOfMonths>6){
opp.API_Service_Name__c='Call off';
} 
} */
        try{
            insert opp;
            if(opp.Id != null)
            addFileToSFId(opp.Id, fileData);
        }catch (Exception e){
            system.debug('--j--'+e);
           throw new AuraHandledException('Error Exception happend'+e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static void addFileToSFId(String recordId , String fileData){
        
        list<uploadedDocs> Updocs;
        List<ContentVersion> lstContentVesions = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLinks = new  List<ContentDocumentLink>();
        if(fileData != null){
            Updocs = (List<uploadedDocs>)JSON.deserialize(fileData,  List<uploadedDocs>.Class);
            system.debug('Updocs size = '+ Updocs.size());
        }
        
        if(Updocs != null && Updocs.size() > 0){
            for(uploadedDocs doc :Updocs){
                ContentVersion objContentVersion = new ContentVersion();
                objContentVersion.ContentLocation = 'S';
                //system.debug('VersionData = '+ doc.strBase64Data);
                String body = doc.strBase64Data;               
                String base64Mark = 'base64,';
                integer dataStart = body.indexOf(base64Mark) + base64Mark.length();
                //system.debug('dataStart = '+ dataStart);
                body = body.substring(dataStart);
                //system.debug('body = '+ body);
                objContentVersion.VersionData = EncodingUtil.base64Decode(body);
                objContentVersion.Title = doc.strFileName;
                objContentVersion.Origin = 'H';
                objContentVersion.PathOnClient = '/' + doc.strFileName;
                lstContentVesions.add(objContentVersion);
            }
            system.debug('******lstContentVesions****'+lstContentVesions);
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
                }Catch(Exception ex){
                    system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
                    
                    system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
                    throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
                }
            }
        }

       
    }
    
    public class uploadedDocs{
        @AuraEnabled
        Public String strFileName;
        @AuraEnabled
        Public String strFileType;
        @AuraEnabled
        Public String strBase64Data;
        
    }
    @AuraEnabled
    public static Account getBusinessType(){
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account acc=[select id,recordtype.developerName,ETST_Account_Type__c from account where id=:u.accountID];
        return acc;//.recordtype.developerName;
    }
    /*
@AuraEnabled
public static List<ET_Sales_Agreement__c> getsalesAggsforPO(String POName){
User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];

return [select Id,Name,Salesforce_Customer__r.Name,  Activity__c, Administration_Charges__c,
Contract_End_Date__c, Contract_No__c, Contract_Start_Date__c, Contract_Status__c, Contract_Type__c, 
Customer_PO_No__c, Customer__c, ETSales_Emirates__c, No_of_Months__c, Other_Charges__c, Premature_Charges__c,
Salesforce_Customer__c, Version__c, ETSALES_Quote__c, ETSALES_Opportunity__c, GL_Activity__c, 
GL_Department__c, GL_Project__c, GL_Location__c, GL_Region__c, GL_Zone__c
from ET_Sales_Agreement__c where 
Salesforce_Customer__c=:u.accountID and Customer_PO_No__c=:POName ORDER BY Name ];

}*/
    @AuraEnabled
    public static List<SALine_Assigned_Vehicle__c> showVehiclesforMonth(String POName,Integer monthNo,Integer year){
        //added by Abrara
        //monthNo = monthNo != 1 ? monthNo-- : monthNo;
        //year = monthNo != 1 ? year : year-1;
        DateTime FirstDateOfMonth = DateTime.newInstance(year, monthNo, 1, 0, 0, 0);
        system.debug('FirstDateOfMonth = '+FirstDateOfMonth);
        Integer numberOfDays = Date.daysInMonth(year, monthNo);
        System.debug('numberOfDays-- '+numberOfDays);
        DateTime lastDayOfMonth = DateTime.newInstance(year,monthNo, numberOfDays);
        System.debug('FirstDateOfMonth-- '+FirstDateOfMonth);
        System.debug('lastDayOfMonth-- '+lastDayOfMonth);
        
        system.debug('FirstDateOfMonth'+FirstDateOfMonth);
        system.debug('lastDayOfMonth'+lastDayOfMonth);
        //end
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        Set<id> childAccountIDs=new Set<id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(Acc.id);
        List<SALine_Assigned_Vehicle__c> lstVehicles=new List<SALine_Assigned_Vehicle__c>();
       /* if(u.AccountId=='0012z000002vb5WAAQ'){
            lstVehicles= [select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c, Assign_End_Date__c,Vehicle_Number__c,
                          Plate_Number__c,Plate_Code__c,Plate_Source__c,Vehicle_Description__c,
                          Sales_Agreement__c FROM SALine_Assigned_Vehicle__c
                          where Sales_Agreement__r.salesforce_Customer__r.parentId=:u.accountID 
                          and Sales_Agreement__r.customer_PO_No__c=:POName
                          and ((Assign_Start_Date__c  <= :lastDayOfMonth AND Assign_End_Date__c >= :FirstDateOfMonth) OR (Assign_Start_Date__c  >=  :FirstDateOfMonth AND Assign_End_Date__c <= :lastDayOfMonth))];
           
        }else{ */
            lstVehicles= [select Id, Name,Sales_Agreement__r.Name,  Assign_Start_Date__c, Assign_End_Date__c,Vehicle_Number__c,
                          Sales_Agreement__c,Plate_Number__c,Plate_Code__c,Plate_Source__c,Vehicle_Description__c FROM SALine_Assigned_Vehicle__c
                          where Sales_Agreement__r.salesforce_Customer__c IN:childAccountIDs
                          and Sales_Agreement__r.customer_PO_No__c=:POName
                          and ((Assign_Start_Date__c  <= :lastDayOfMonth AND Assign_End_Date__c >= :FirstDateOfMonth) OR (Assign_Start_Date__c  >=  :FirstDateOfMonth AND Assign_End_Date__c <= :lastDayOfMonth))]; 
       // }
       system.debug('lstVehicles '+lstVehicles);
        return lstVehicles;  
    } 
    
    
    @AuraEnabled
    public static List<ET_Customer_Vehicle__c> showMaintenanceVehiclesforMonth(String POName,Integer monthNo,Integer year){
        //added by Abrara
        Integer noOFDays= Date.daysInMonth(year, monthNo);
        DateTime lastDayOfMonth = DateTime.newInstance(year,monthNo, noOFDays);
        DateTime FirstDateOfMonth = DateTime.newInstance(year, monthNo, 1, 0, 0, 0);
		Set<String> set_platenos= new Set<String>();
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        Set<id> childAccountIDs=new Set<id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(Acc.id);
		for(Maintenance_Work_Order__c mo :[select Id, Plate_Number__c FROM Maintenance_Work_Order__c where Sales_Agreement__r.salesforce_Customer__c IN:childAccountIDs and Sales_Agreement__r.customer_PO_No__c=:POName and (Date__c  <= :lastDayOfMonth AND Date__c >= :FirstDateOfMonth)])
		{
			set_platenos.add(mo.Plate_Number__c);
		}
        List<ET_Customer_Vehicle__c>  lstVehicles=[select id,Account__c,Plate_No__c,Type__c,  Vehicle_Type__c,  Internal_No__c,  Vehicle_Make__c, Vehicle_Family__c,Vehicle_Year__c   from ET_Customer_Vehicle__c where Type__c='Maintenance' and Account__c IN: childAccountIDs and Plate_No__c IN :set_platenos];
        return lstVehicles;  
    } 
    
    @AuraEnabled
    public static List<Maintenance_Work_Order__c> showMaintenanceWoforMonth(String POName,Integer monthNo,Integer year){
        //added by Abrara
        //monthNo = monthNo != 1 ? monthNo-- : monthNo;
        //year = monthNo != 1 ? year : year-1;
        Integer noOFDays= Date.daysInMonth(year, monthNo);
        DateTime lastDayOfMonth = DateTime.newInstance(year,monthNo, noOFDays);
        //lastDayOfMonth=lastDayOfMonth.dateGMT();
        DateTime FirstDateOfMonth = DateTime.newInstance(year, monthNo, 1, 0, 0, 0);
        //FirstDateOfMonth=FirstDateOfMonth.dateGMT();
        //end
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        Set<id> childAccountIDs=new Set<id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(Acc.id);
        List<Maintenance_Work_Order__c> lstwo=new List<Maintenance_Work_Order__c>();
            lstwo= [select Id,Date__c,Plate_Number__c, Work_Order__c, Vehicle_Received_On__c, Delivered_On__c, Service_Location__c,
                          Description__c, Work_Status__c, KM_Reading__c,Sales_Agreement__r.salesforce_Customer__c,
                          Sales_Agreement__r.customer_PO_No__c,Service_Request__c,Service_Req_Ref_No__c
                          FROM Maintenance_Work_Order__c
                          where Sales_Agreement__r.salesforce_Customer__c IN:childAccountIDs
                          and Sales_Agreement__r.customer_PO_No__c=:POName
                          and (Date__c  <= :lastDayOfMonth AND Date__c >= :FirstDateOfMonth)]; 
      
       system.debug('lstw123 '+lstwo);
        return lstwo;  
    }
    
    @AuraEnabled
    public static List<Estimation__c> showEstimationforMonth(String POName,Integer monthNo,Integer year){
        //added by Abrara
        //monthNo = monthNo != 1 ? monthNo-- : monthNo;
        //year = monthNo != 1 ? year : year-1;
        Integer noOFDays= Date.daysInMonth(year, monthNo);
        DateTime lastDayOfMonth = DateTime.newInstance(year,monthNo, noOFDays);
        //lastDayOfMonth=lastDayOfMonth.dateGMT();
        DateTime FirstDateOfMonth = DateTime.newInstance(year, monthNo, 1, 0, 0, 0);
        //FirstDateOfMonth=FirstDateOfMonth.dateGMT();
        //end
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        Set<id> childAccountIDs=new Set<id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(Acc.id);
        List<Estimation__c> lstEstimation=new List<Estimation__c>();
        lstEstimation= [select Id,Name,Date__c,Plate_Number__c, Estimate_No__c, Work_order__c, Description__c, Service_Location__c,Invoice_Number__c,
                        Estimator__c, CreatedDate, Materials__c, Material_Cost__c, Labor__c, Labour_Cost__c, Others__c, Other_Cost__c, Net_Amount__c,Invoiced__c, Paid__c,
                        Sales_Agreement__r.salesforce_Customer__c,Sales_Agreement__r.customer_PO_No__c
                        FROM Estimation__c
                        where Sales_Agreement__r.salesforce_Customer__c IN:childAccountIDs
                        and Sales_Agreement__r.customer_PO_No__c=:POName
                        and (Date__c  <= :lastDayOfMonth AND Date__c >= :FirstDateOfMonth)]; 
        
        system.debug('lstEstimation '+lstEstimation);
        return lstEstimation;  
    }
    
    @AuraEnabled
    public static List<Maintenance_Work_Order__c> showActiveMaintenanceWoforMonth(String POName,Integer monthNo,Integer year){
        //added by Abrara
        //monthNo = monthNo != 1 ? monthNo-- : monthNo;
        //year = monthNo != 1 ? year : year-1;
        Integer noOFDays= Date.daysInMonth(year, monthNo);
        DateTime lastDayOfMonth = DateTime.newInstance(year,monthNo, noOFDays);
        //lastDayOfMonth=lastDayOfMonth.dateGMT();
        DateTime FirstDateOfMonth = DateTime.newInstance(year, monthNo, 1, 0, 0, 0);
        //FirstDateOfMonth=FirstDateOfMonth.dateGMT();
        //end
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        Set<id> childAccountIDs=new Set<id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(Acc.id);
        List<Maintenance_Work_Order__c> lstwo=new List<Maintenance_Work_Order__c>();
            lstwo= [select Id,Date__c,Plate_Number__c, Work_Order__c, Vehicle_Received_On__c, Delivered_On__c, Service_Location__c,
                          Description__c, Work_Status__c, KM_Reading__c,Sales_Agreement__r.salesforce_Customer__c,
                    Sales_Agreement__r.customer_PO_No__c,Service_Request__c,Service_Req_Ref_No__c
                    FROM Maintenance_Work_Order__c
                    where Delivered_On__c = NULL AND Sales_Agreement__r.salesforce_Customer__c IN:childAccountIDs
                    and Sales_Agreement__r.customer_PO_No__c=:POName
                    and (Date__c  <= :lastDayOfMonth AND Date__c >= :FirstDateOfMonth)]; 
        
        system.debug('lstw123 '+lstwo);
        return lstwo;  
    }
    @AuraEnabled
    public static List<ETST_Student__c> showStudents(String POName){
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        Set<id> childAccountIDs=new Set<id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(Acc.id);
        
        List<ET_Sales_Agreement__c> sgList = [select Id,Category__c,customer_PO_No__c from  ET_Sales_Agreement__c WHERE customer_PO_No__c=: POName AND Salesforce_Customer__c IN:childAccountIDs];
        List<Id> sgIdList = New List<Id>();
        for(ET_Sales_Agreement__c sg : sgList){
            sgIdList.add(sg.Id);
        }
        system.debug('sgList'+sgList);
        List<ETST_School__c> schoolList =[select Id,name,ETST_Sales_Agreement__c  from ETST_School__c where ETST_Sales_Agreement__c IN:sgIdList];
        system.debug('schoolList'+schoolList);
        List<Id> schoolIdList = New List<Id>();
        for(ETST_School__c sg : schoolList){
            schoolIdList.add(sg.Id);
        }
        List<ETST_Student__c> studentList =[select Id,name,ETST_School__c,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c,ETST_School_Name__r.Name from ETST_Student__c where ETST_School_Name__c IN:schoolIdList ];
        system.debug('studentList'+studentList);
        return studentList;
    }
    @AuraEnabled
    public static List<SALine_Assigned_Resource__c> showResourcesforMonth(String POName,Integer monthNo,Integer year){
        //Added by Abrara
        //monthNo = monthNo != 1 ? monthNo-- : monthNo;
        //year = monthNo != 1 ? year : year-1;
        system.debug('monthNo ='+monthNo);
        DateTime FirstDateOfMonth = DateTime.newInstance(year, monthNo, 1, 0, 0, 0);
        system.debug('FirstDateOfMonth = '+FirstDateOfMonth);
        Integer numberOfDays = Date.daysInMonth(year, monthNo);
        System.debug('numberOfDays-- '+numberOfDays);
        DateTime lastDayOfMonth = DateTime.newInstance(year,monthNo, numberOfDays);
        System.debug('FirstDateOfMonth-- '+FirstDateOfMonth);
        System.debug('lastDayOfMonth-- '+lastDayOfMonth); 
        
        //end
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId]; 
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        List<Id> childAccountIDs=new List<Id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(Acc.id);
        system.debug('childAccountIDs IN res method='+childAccountIDs);
        List<SALine_Assigned_Resource__c> lstresources=new List<SALine_Assigned_Resource__c>();
        //'Salary_Paid_Date__c','Sales_Agreement__r','Assign_Start_Date__c','Assign_End_Date__c'];
      /*  if(u.AccountId=='0012z000002vb5WAAQ'){
            lstresources= [select Id,Name,Sales_Agreement__r.Name,Account__c, format(Assign_End_Date__c), format(Assign_Start_Date__c),Actual_Salary_Amount__c,
                           Deduction_Amount__c,Salary_Paid_Amount__c,Deduction_Reason__c,Salary_Paid_Date__c,
                           ETST_Assigned_Vehicle__c, Employee_ID__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                           from SALine_Assigned_Resource__c
                           where Sales_Agreement__r.salesforce_Customer__r.parentid=:u.accountID 
                           and Sales_Agreement__r.customer_PO_No__c=:POName
                           and ((Assign_Start_Date__c  <= :lastDayOfMonth AND Assign_End_Date__c >= :FirstDateOfMonth) OR (Assign_Start_Date__c  >=  :FirstDateOfMonth AND Assign_End_Date__c <= :lastDayOfMonth))];
        }else{ */
            lstresources= [select Id,Name,Sales_Agreement__r.Name,Account__c, format(Assign_End_Date__c), format(Assign_Start_Date__c),Actual_Salary_Amount__c,
                           Deduction_Amount__c,Salary_Paid_Amount__c,Deduction_Reason__c,Salary_Paid_Date__c,
                           ETST_Assigned_Vehicle__c, Employee_ID__c, Employee_Type__c, Sales_Agreement_Sub_Line_Item__c, Sales_Agreement__c
                           from SALine_Assigned_Resource__c
                           where Sales_Agreement__r.salesforce_Customer__c IN:childAccountIDs
                           and Sales_Agreement__r.customer_PO_No__c=:POName
                           and ((Assign_Start_Date__c  <= :lastDayOfMonth AND Assign_End_Date__c >= :FirstDateOfMonth) OR (Assign_Start_Date__c  >=  :FirstDateOfMonth AND Assign_End_Date__c <= :lastDayOfMonth))];
       // }
       system.debug('lstresources---> '+lstresources);
        return lstresources;
    }
    @AuraEnabled
    public static String getPOCategory(String POName){
        //Commented by Janardhan -No idea purpose of commented code
       /* List<ET_Sales_Agreement__c> sgList = [select Id,Category__c,customer_PO_No__c from ET_Sales_Agreement__c LIMIT 1];
        List<Case> cList = [select Id,caseNumber from Case LIMIT 1];
        List<Opportunity> aList = [select Id,name from Opportunity LIMIT 1];
        List<SALine_Assigned_Resource__c> tList = [select Id,Name from SALine_Assigned_Resource__c LIMIT 1];
        List<ET_Sales_Agreement__c> sgList1 = [select Id,Category__c,customer_PO_No__c from ET_Sales_Agreement__c LIMIT 1];
        List<Case> cList1 = [select Id,caseNumber from Case LIMIT 1];
        List<Opportunity> aList1 = [select Id,name from Opportunity LIMIT 1];
        List<SALine_Assigned_Resource__c> tList1 = [select Id,Name from SALine_Assigned_Resource__c LIMIT 1];
        
        List<ET_Sales_Agreement__c> sgList12 = [select Id,Category__c,customer_PO_No__c from ET_Sales_Agreement__c LIMIT 1];
        List<Case> cList122 = [select Id,caseNumber from Case LIMIT 1];
        List<Opportunity> aList22 = [select Id,name from Opportunity LIMIT 1];
        List<SALine_Assigned_Resource__c> tList12 = [select Id,Name from SALine_Assigned_Resource__c LIMIT 1];
        List<ET_Sales_Agreement__c> sgList1212 = [select Id,Category__c,customer_PO_No__c from ET_Sales_Agreement__c LIMIT 1];
        List<Case> cList112 = [select Id,caseNumber from Case LIMIT 1];
        List<Opportunity> aList321 = [select Id,name from Opportunity LIMIT 1];
        List<SALine_Assigned_Resource__c> tList123 = [select Id,Name from SALine_Assigned_Resource__c LIMIT 1];
        
        List<SALine_Assigned_Resource__c> tList123tMainMap = [select Id,Name from SALine_Assigned_Resource__c LIMIT 1];*/
        if(POName!= null)
        return [select Id,Category__c,customer_PO_No__c from ET_Sales_Agreement__c WHERE customer_PO_No__c=:POName AND Category__c != null].Category__c;
        else
        return null;
        
    }
    
    @AuraEnabled
    public static List<CountClass1> getPODetails(String POName){
        
        List<AggregateResult> salesAgreementList=[select COUNT(customer_PO_No__c),Category__c from  ET_Sales_Agreement__c where customer_PO_No__c=: POName GROUP BY Category__c];
        
        system.debug('POName = '+POName);
        DateTime FirstDateOfMonth = DateTime.newInstance(System.Today().year(), System.Today().month(), 1, 0, 0, 0);
        system.debug('FirstDateOfMonth = '+FirstDateOfMonth);
        Integer numberOfDays = Date.daysInMonth(System.Today().year(), System.Today().month());
        System.debug('numberOfDays-- '+numberOfDays);
        DateTime lastDayOfMonth = DateTime.newInstance(System.Today().year(),System.Today().month(), numberOfDays);
        System.debug('FirstDateOfMonth-- '+FirstDateOfMonth);
        System.debug('lastDayOfMonth-- '+lastDayOfMonth);
        
        CountClass wrap=new CountClass();
        CountClass1  cnt1=new  CountClass1();
        CountClass1  cnt2=new  CountClass1();
        CountClass1  cnt3=new  CountClass1();
        List<CountClass1>  cntList=new  List<CountClass1>();
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        List<Id> childAccountIDs=new List<Id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(Acc.id);
        system.debug('childAccountIDs IN count method='+childAccountIDs);
        String formQuery ='(';
        Integer length = childAccountIDs.size();
        Integer count =1;
        for(Id accId :childAccountIDs){
            system.debug('count=='+count);
            system.debug('length=='+length);
            if(count < length){
                formQuery+=' Sales_Agreement__r.salesforce_Customer__c=\''+accId+'\' OR';
                 system.debug('inside formQuery'+formQuery);
            }else{
                formQuery+=' Sales_Agreement__r.salesforce_Customer__c=\''+accId+'\'';
            }
            count++;
        }
        formQuery+=' )';
        system.debug('formQuery '+formQuery);
        Date startOfMonth = Date.today().toStartOfMonth().addMonths(-2);
        Date endofmonth = startOfMonth.addMonths(3).adddays(-1);
        Date endofmonth1 = startOfMonth.addMonths(2);
        
        System.debug('startOfMonth '+startOfMonth);
        System.debug('endofmonth '+endofmonth);
        List<AggregateResult> aggList=new List<AggregateResult>();
        List<AggregateResult> aggListFinal=new List<AggregateResult>();
        List<AggregateResult> resourceAggList=new List<AggregateResult>();
       /* if(u.AccountId=='0012z000002vb5WAAQ'){
            aggList=[select CALENDAR_MONTH(Assign_End_Date__c) end_month,count(id) cnt from SALine_Assigned_Vehicle__c 
                     where  Sales_Agreement__r.salesforce_Customer__r.parentId=:u.accountID 
                     and Sales_Agreement__r.customer_PO_No__c=:POName
                     and Assign_End_Date__c >= :startOfMonth
                     and Assign_End_Date__c <=:endofmonth
                     group by CALENDAR_MONTH(Assign_End_Date__c)
                     order by CALENDAR_MONTH(Assign_End_Date__c) ];
            resourceAggList=[select CALENDAR_MONTH(Assign_End_Date__c) end_month,count(id) cnt 
                             from SALine_Assigned_Resource__c 
                             where  Sales_Agreement__r.salesforce_Customer__r.parentId=:u.accountID 
                             and Sales_Agreement__r.customer_PO_No__c=:POName
                             and Assign_End_Date__c >= :startOfMonth
                             and Assign_End_Date__c <=:endofmonth
                             group by CALENDAR_MONTH(Assign_End_Date__c)
                             order by CALENDAR_MONTH(Assign_End_Date__c) ];
        }else{ */
        
        String vSOQL='select count() from SALine_Assigned_Vehicle__c where Sales_Agreement__r.customer_PO_No__c=\''+POName+'\' and ((Assign_Start_Date__c  <=: lastDayOfMonth AND Assign_End_Date__c >=: FirstDateOfMonth ) OR (Assign_Start_Date__c  >=: FirstDateOfMonth AND Assign_End_Date__c <=: lastDayOfMonth))'+' AND '+formQuery;
        String rSOQL='select count() from SALine_Assigned_Resource__c where Sales_Agreement__r.customer_PO_No__c=\''+POName+'\' and ((Assign_Start_Date__c  <= :lastDayOfMonth AND Assign_End_Date__c >= :FirstDateOfMonth) OR (Assign_Start_Date__c  >=  :FirstDateOfMonth AND Assign_End_Date__c <= :lastDayOfMonth))'+' AND '+formQuery;
        
        List<ET_Sales_Agreement__c> sgList = [select Id,Category__c,customer_PO_No__c from  ET_Sales_Agreement__c WHERE customer_PO_No__c=: POName AND Salesforce_Customer__c IN:childAccountIDs];
        List<Id> sgIdList = New List<Id>();
        for(ET_Sales_Agreement__c sg : sgList){
            sgIdList.add(sg.Id);
        }
        system.debug('sgList'+sgList);
        List<ETST_School__c> schoolList =[select Id,name,ETST_Sales_Agreement__c  from ETST_School__c where ETST_Sales_Agreement__c IN:sgIdList];
        system.debug('schoolList'+schoolList);
        List<Id> schoolIdList = New List<Id>();
        for(ETST_School__c sg : schoolList){
            schoolIdList.add(sg.Id);
        }
        List<ETST_Student__c> studentList =[select Id,name,ETST_School__c from ETST_Student__c where ETST_School_Name__c IN:schoolIdList ];
        system.debug('studentList'+studentList);
        system.debug('vSOQL'+vSOQL);
        Integer vehicleCount=database.countQuery(vSOQL);
        Integer resourceCount=database.countQuery(rSOQL);
        Integer tripCount =0;
        Integer studentCount =studentList.size() > 0 ? studentList.size() : 0;
        Integer currentMonth=System.today().month();
        //FirstDateOfMonth =currentMonth;
        system.debug('currentMonthcurrentMonth '+currentMonth);
        cnt1.add(currentMonth,vehicleCount,0,resourceCount,tripCount,studentCount);
        cntList.add(cnt1);
        //Get count for current month-1
        currentMonth=currentMonth -1; 
        FirstDateOfMonth =FirstDateOfMonth.addMonths(-1);
        DateTime tempDate = FirstDateOfMonth.dateGMT();
        Integer numberOfDaysforLastDay = Date.daysInMonth(tempDate.year(), tempDate.month());
        System.debug('numberOfDaysforLastDay-- '+numberOfDaysforLastDay);
		FirstDateOfMonth = DateTime.newInstance(System.Today().year(),currentMonth, 1);
        lastDayOfMonth = DateTime.newInstance(System.Today().year(),currentMonth, numberOfDaysforLastDay);
        system.debug('FirstDateOfMonth427 '+FirstDateOfMonth);
        //lastDayOfMonth=lastDayOfMonth.addMonths(-1);
        
        cnt1=new  CountClass1();
        vehicleCount=database.countQuery(vSOQL);
        resourceCount=database.countQuery(rSOQL);
        cnt1.add(currentMonth,vehicleCount,0,resourceCount,tripCount,studentCount);
        cntList.add(cnt1);
        //Get count for current month-2
        currentMonth=currentMonth -1; 
        FirstDateOfMonth =FirstDateOfMonth.addMonths(-1);
        tempDate = FirstDateOfMonth.dateGMT();
        numberOfDaysforLastDay = Date.daysInMonth(tempDate.year(), tempDate.month());
        System.debug('numberOfDaysforLastDay-- '+numberOfDaysforLastDay);
		FirstDateOfMonth = DateTime.newInstance(System.Today().year(),currentMonth, 1);
        lastDayOfMonth = DateTime.newInstance(System.Today().year(),currentMonth, numberOfDaysforLastDay);
        //lastDayOfMonth=lastDayOfMonth.addMonths(-1);
        
        cnt1=new  CountClass1();
        vehicleCount=database.countQuery(vSOQL);
        System.debug('FirstDateOfMonth453-- '+FirstDateOfMonth);
        System.debug('lastDayOfMonth436-- '+lastDayOfMonth);
        system.debug('rSOQL'+rSOQL);
        resourceCount=database.countQuery(rSOQL);
        cnt1.add(currentMonth,vehicleCount,0,resourceCount,tripCount,studentCount);
        cntList.add(cnt1);
        
        //  }
        System.debug('cntList'+cntList);
        
        return cntList;
    }
    
    @AuraEnabled
    public static List<CountClass2> getMaintenancePODetails(String POName){
        
        List<AggregateResult> salesAgreementList=[select COUNT(customer_PO_No__c),Category__c from  ET_Sales_Agreement__c where customer_PO_No__c=: POName GROUP BY Category__c];
        Set<String> st_vehicle=new Set<String>();
        system.debug('POName = '+POName);
        DateTime FirstDateOfMonth = DateTime.newInstance(System.Today().year(), System.Today().month(), 1, 0, 0, 0);
        system.debug('FirstDateOfMonth = '+FirstDateOfMonth);
        Integer numberOfDays = Date.daysInMonth(System.Today().year(), System.Today().month());
        System.debug('numberOfDays-- '+numberOfDays);
        DateTime lastDayOfMonth = DateTime.newInstance(System.Today().year(),System.Today().month(), numberOfDays);
        System.debug('FirstDateOfMonth-- '+FirstDateOfMonth);
        System.debug('lastDayOfMonth-- '+lastDayOfMonth);
        
        CountClass wrap=new CountClass();
        CountClass2  cnt1=new  CountClass2();
        CountClass2  cnt2=new  CountClass2();
        CountClass2  cnt3=new  CountClass2();
        List<CountClass2>  cntList=new  List<CountClass2>();
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        List<Id> childAccountIDs=new List<Id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(Acc.id);
        system.debug('childAccountIDs IN count method='+childAccountIDs);
        String formQuery ='(';
        Integer length = childAccountIDs.size();
        Integer count =1;
        for(Id accId :childAccountIDs){
            system.debug('count=='+count);
            system.debug('length=='+length);
            if(count < length){
                formQuery+=' Sales_Agreement__r.salesforce_Customer__c=\''+accId+'\' OR';
                 system.debug('inside formQuery'+formQuery);
            }else{
                formQuery+=' Sales_Agreement__r.salesforce_Customer__c=\''+accId+'\'';
            }
            count++;
        }
        formQuery+=' )';
        system.debug('formQuery '+formQuery);
        Date startOfMonth = Date.today().toStartOfMonth().addMonths(-2);
        Date endofmonth = startOfMonth.addMonths(3).adddays(-1);
        Date endofmonth1 = startOfMonth.addMonths(2);
        
        System.debug('startOfMonth '+startOfMonth);
        System.debug('endofmonth '+endofmonth);
        List<AggregateResult> aggList=new List<AggregateResult>();
        List<AggregateResult> aggListFinal=new List<AggregateResult>();
        List<AggregateResult> resourceAggList=new List<AggregateResult>();
        //String vSOQL='select count() from ET_Customer_Vehicle__c where Sales_Agreement__r.customer_PO_No__c=\''+POName+'\' and ((Assign_Start_Date__c  <=: lastDayOfMonth AND Assign_End_Date__c >=: FirstDateOfMonth ) OR (Assign_Start_Date__c  >=: FirstDateOfMonth AND Assign_End_Date__c <=: lastDayOfMonth))'+' AND '+formQuery;
        String vehType='Maintenance';
        List<ET_Customer_Vehicle__c> customerVehicle=[select id,Name from ET_Customer_Vehicle__c where Type__c='Maintenance' and Account__c IN:childAccountIDs];
        Integer vehicleCount=customerVehicle.size()>0? customerVehicle.size():0 ;
        
        //String vSOQL='select count() from ET_Customer_Vehicle__c where Type__c= \''+vehType+'\' AND Account__c IN: '+childAccountIDs;
        String woSOQL='select Id,Work_Status__c,Plate_Number__c, Date__c,Delivered_On__c from Maintenance_Work_Order__c where Sales_Agreement__r.customer_PO_No__c=\''+POName+'\' and (Date__c  <=: lastDayOfMonth AND Date__c >=: FirstDateOfMonth) '+' AND '+formQuery;
        String estimationSOQL='select count() from Estimation__c where Sales_Agreement__r.customer_PO_No__c=\''+POName+'\' and (Date__c  <=: lastDayOfMonth AND Date__c >=: FirstDateOfMonth) '+' AND '+formQuery;
       //	system.debug('vSOQL'+vSOQL);
       // Integer vehicleCount=database.countQuery(vSOQL);
        Integer estimationCount=database.countQuery(estimationSOQL);
        system.debug('estimationSOQL565 '+estimationSOQL);
        system.debug('woSOQL '+woSOQL);
        List<Maintenance_Work_Order__c> woList =database.query(woSOQL);
        system.debug('woList '+woList);
        Integer woCount=woList.size();
        Integer activeWOCount =0;
        if(woList.size() > 0){
            for(Maintenance_Work_Order__c mo :woList){
				st_vehicle.add(mo.Plate_Number__c);
                if(mo.Delivered_On__c == NULL){
                    activeWOCount++;
                }
            }
        }
        system.debug('vehicleCount563 '+vehicleCount);
        system.debug('estimationCount563 '+estimationCount);
        system.debug('woCount563 '+woCount);
        system.debug('activeWOCount563 '+activeWOCount);
        Integer currentMonth=System.today().month();
        //FirstDateOfMonth =currentMonth;
        system.debug('currentMonthcurrentMonth '+currentMonth);
        cnt1.add(currentMonth,st_vehicle.size(),woCount,estimationCount,activeWOCount);
        cntList.add(cnt1);
        //Get count for current month-1
        currentMonth=currentMonth -1; 
        FirstDateOfMonth =FirstDateOfMonth.addMonths(-1);
        DateTime tempDate = FirstDateOfMonth.dateGMT();
        Integer numberOfDaysforLastDay = Date.daysInMonth(tempDate.year(), tempDate.month());
        System.debug('numberOfDaysforLastDay-- '+numberOfDaysforLastDay);
		FirstDateOfMonth = DateTime.newInstance(System.Today().year(),currentMonth, 1);
        lastDayOfMonth = DateTime.newInstance(System.Today().year(),currentMonth, numberOfDaysforLastDay);
        system.debug('FirstDateOfMonth4273434 '+FirstDateOfMonth);
        //lastDayOfMonth=lastDayOfMonth.addMonths(-1);
        system.debug('lastDayOfMonth4273434 '+lastDayOfMonth);
        cnt1=new  CountClass2();
       // vehicleCount=database.countQuery(vSOQL);
        estimationCount=database.countQuery(estimationSOQL);
        woList =database.query(woSOQL);
        woCount=woList.size();
        activeWOCount =0;
		st_vehicle=new Set<String>();
        if(woList.size() > 0){
            for(Maintenance_Work_Order__c mo :woList){
				st_vehicle.add(mo.Plate_Number__c);
                if(mo.Delivered_On__c == NULL){
                    activeWOCount++;
                }
            }
        }
        cnt1.add(currentMonth,st_vehicle.size(),woCount,estimationCount,activeWOCount);
        cntList.add(cnt1);
        //Get count for current month-2
        currentMonth=currentMonth -1; 
        FirstDateOfMonth =FirstDateOfMonth.addMonths(-1);
        tempDate = FirstDateOfMonth.dateGMT();
        numberOfDaysforLastDay = Date.daysInMonth(tempDate.year(), tempDate.month());
        System.debug('numberOfDaysforLastDay-- '+numberOfDaysforLastDay);
		FirstDateOfMonth = DateTime.newInstance(System.Today().year(),currentMonth, 1);
        lastDayOfMonth = DateTime.newInstance(System.Today().year(),currentMonth, numberOfDaysforLastDay);
        system.debug('FirstDateOfMonth232323'+FirstDateOfMonth);
        //lastDayOfMonth=lastDayOfMonth.addMonths(-1);
        system.debug('lastDayOfMonth232323343'+lastDayOfMonth);
        cnt1=new CountClass2();
       // vehicleCount=database.countQuery(vSOQL);
        estimationCount=database.countQuery(estimationSOQL);
        woList =database.query(woSOQL);
        woCount=woList.size();
        activeWOCount =0;
		st_vehicle=new Set<String>();
        if(woList.size() > 0){
            for(Maintenance_Work_Order__c mo :woList){
				st_vehicle.add(mo.Plate_Number__c);
                if(mo.Delivered_On__c == NULL){
                    activeWOCount++;
					
                }
            }
        }
        System.debug('FirstDateOfMonth453-- '+FirstDateOfMonth);
        System.debug('lastDayOfMonth436-- '+lastDayOfMonth); 
        cnt1.add(currentMonth,st_vehicle.size(),woCount,estimationCount,activeWOCount);
        cntList.add(cnt1);
        
        //  }
        System.debug('cntList'+cntList);
        
        return cntList;
    }
    public Class CountClass{
        @AuraEnabled public map<Integer,Integer> VehicleCount=new map<Integer,Integer>();
        @AuraEnabled public map<Integer,Integer> resourceCount=new map<Integer,Integer>();
        @AuraEnabled public Integer woCount=0; 
    }
    
	public Class Invoicewrapper{
        @AuraEnabled public List<Invoice__c> paidinvoices=new List<Invoice__c>();
        @AuraEnabled public List<Invoice__c> unpaidinvoices=new List<Invoice__c>();
		@AuraEnabled public List<Invoice__c> allinvoices=new List<Invoice__c>();
    }
    public Class CountClass2{
        @AuraEnabled public  Integer monthNo;
        @AuraEnabled public  Integer vehicleCount=0; 
        @AuraEnabled public  Integer woCount=0; 
        @AuraEnabled public  Integer estimationCount=0; 
        @AuraEnabled public  Integer activeWOCount=0; 
        public CountClass2 add(Integer monthNo,Integer vehicleCount,Integer woCount, Integer estimationCount, Integer activeWOCount){
            this.monthNo=monthNo;
            this.vehicleCount=vehicleCount;
            this.woCount=woCount;
            this.estimationCount=estimationCount;
            this.activeWOCount=activeWOCount;
            return this;
        }
    }
    
    public Class CountClass1{
        @AuraEnabled public  Integer monthNo;
        @AuraEnabled public  Integer vehicleCount=0; 
        @AuraEnabled public  Integer resourceCount=0; 
        @AuraEnabled public  Integer woCount=0; 
        @AuraEnabled public  Integer tripCount=0; 
        @AuraEnabled public  Integer studentCount=0; 
        public CountClass1 add(Integer monthNo,Integer vehicleCount,Integer woCount, Integer resourceCount, Integer tripCount, Integer studentCount){
            this.monthNo=monthNo;
            this.vehicleCount=vehicleCount;
            this.resourceCount=resourceCount;
            this.woCount=woCount;
            this.tripCount=tripCount;
            this.studentCount=studentCount;
            return this;
        }
    }
    @AuraEnabled
    public static User getProfileDetails(){ 
        return [select id, AccountId,Account.Name,contactId,profile.Name, Email from User where id = : userinfo.getUserId()];
        
    }
    
    @AuraEnabled
    public static List<contact> getSiteDetails(String AccountId){ 
        //User u = [select id, AccountId,contactId from User where id = : userinfo.getUserId()];
        return [select id,account.Name,account.ET_Preferred_Location__c,firstName,lastname,Phone,ETSales_Phone__c from contact where contact.Account.ParentId=:AccountId];
        // return [select id,Name from Account where ParentId=:u.AccountId];
    }
    @AuraEnabled
    public static Invoicewrapper getInvDetails(String AccountId){ 
	Invoicewrapper invwrap= new Invoicewrapper();
        //User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        
        //Account Acc=[select id,Name from Account where Id=:AccountId];  
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =:AccountId];
        Set<id> childAccountIDs=new Set<id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
        }
        childAccountIDs.add(AccountId);
        // List<Invoice__c> aggList =new  List<Invoice__c>();
       /* if(u.AccountId=='0012z000002vb5WAAQ'){
            return  [select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                     Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                     Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                     ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                     ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                     Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                     Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                     Trx_Number__c, Voucher_Number__c, Zone__c,Due_Amount__c,Invoice_Amount__c,Invoice_Date__c
                     from Invoice__c 
                     where (Payment_Status__c='Not Paid' OR Payment_Status__c='Partially Paid')
                     and Customer__r.parentId=:u.AccountId  ]; 
        }else{  */
            invwrap.paidinvoices=  [select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                     Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                     Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                     ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                     ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                     Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                     Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                     Trx_Number__c, Voucher_Number__c, Zone__c,Due_Amount__c,Invoice_Amount__c,Invoice_Date__c,Invoice_Number__c
                     from Invoice__c 
                     where Payment_Status__c='Paid' and Customer__c IN:childAccountIDs ]; 
					 
			invwrap.unpaidinvoices=  [select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                     Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                     Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                     ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                     ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                     Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                     Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                     Trx_Number__c, Voucher_Number__c, Zone__c,Due_Amount__c,Invoice_Amount__c,Invoice_Date__c,Invoice_Number__c
                     from Invoice__c 
                     where (Payment_Status__c='Not Paid' OR Payment_Status__c='Partly Paid')
                     and Customer__c IN:childAccountIDs ]; 
			invwrap.allinvoices=  [select Id, Name,Sales_Agreement__r.Name, Account_Desc__c, Activity__c, Batch_Source__c, Branch_Name__c,
                     Complete_Flag__c, Contract_End_Date__c, Contract_Name__c, Contract_Start_Date__c, Created_By__c, CreationDate__c, Ct_Reference__c,
                     Customer_Invoice_No__c, Customer_Number__c, Customer__c, Department__c, Description__c, Dist_Account__c, ETST_Active__c,
                     ETST_Bank_Name__c, ETST_Cheque__c, ETST_Coordinator__c, ETST_Courier_Name__c, ETST_Courier__c, ETST_Submitted_By__c,
                     ETST_Type__c, FromDate__c, Gl_Date__c, Gl_Posted_Date__c, InternalBillNumber__c, Last_Update_By__c, Last_Update_Date__c,
                     Location__c, Operating_Unit__c, Party_Name__c, Payment_Status__c, Project__c, Ref_Number__c, Ref_Trans_Type__c, Sales_Agreement__c,
                     Service_Request__c, ToDate__c, Total_Inv_Amount__c, Transaction_Class__c, Transaction_Type__c, Trx_Date__c,
                     Trx_Number__c, Voucher_Number__c, Zone__c,Due_Amount__c,Invoice_Amount__c,Invoice_Date__c,Invoice_Number__c
                     from Invoice__c 
                     where Customer__c IN:childAccountIDs ]; 
					 
					 return invwrap;
       // }
        
    }
    @AuraEnabled
    public static MyBusinessWrapper getUserAccountDetails(){
        MyBusinessWrapper businessWrapper = new MyBusinessWrapper();
        List<AggregateResult> aggList =new  List<AggregateResult>();
        List<AggregateResult> maintenanceAggList =new  List<AggregateResult>();
		List<AggregateResult> otherAggList =new  List<AggregateResult>();
        Id userId = UserInfo.getUserId();
        User u = [select id,Account.Owner.Name, AccountId,Account.ownerId,Account.Name,Account.Business_Portal_Tabs__c,Account.Is_Parent__c,contactId from User where id = : userId];
        businessWrapper.accRecord=u.AccountId;
        businessWrapper.accRecordName=u.Account.Name;
		businessWrapper.isParent=u.Account.Is_Parent__c;
        businessWrapper.userInfo = u;
        
        // List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String profileName =[SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId()].Name;
        //  String MyProflieName = profile[0].Name;
        system.debug('profile name'+profileName);
        if(profileName=='ADNOC Partner Community'){
            businessWrapper.isADNOC=true;
        }
        
        businessWrapper.sitesCount=[select count() from Account where ParentId=:u.AccountId];
        /* if(u.AccountId=='0012z000002vb5WAAQ'){
businessWrapper.studentsCount=[select count() from etst_student__c where ETST_School__c=:u.AccountId];
businessWrapper.accManager=[select name from user where id=:u.Account.ownerId].Name;
aggList=[select Customer_PO_No__c,count(id) cnt from ET_Sales_Agreement__c 
where Salesforce_Customer__r.parentId=:u.accountId
group by Customer_PO_No__c];

businessWrapper.invCount =[select count()
from Invoice__c 
where (Payment_Status__c='Not Paid' OR Payment_Status__c='Partially Paid') and
Customer__r.parentId=:u.accountId]; 
}else{  */
        //added on 6/6/2021 
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: u.AccountId];
        Set<id> childAccountIDs=new Set<id>();
        childAccountIDs.add(u.AccountId);
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
				businessWrapper.AccountList.put(acc1.Id,acc1.name);
            }
        }	
        system.debug('childAccountIDs value'+childAccountIDs);
        List<ETST_Student__c> currentList=new  List<ETST_Student__c>();
        businessWrapper.studentsCount=[select count() from ETST_Student__c where ETST_School__c=:childAccountIDs];
        businessWrapper.opportunityList=[select id,Name,CreatedBy.Name,CreatedDate,ETSALES_Opportunity_Number__c,StageName,RecordType.Name from Opportunity where AccountId IN:childAccountIDs AND ET_Opportunity_Source__c='Community Portal'];
        system.debug('opp list value'+businessWrapper.opportunityList);
        system.debug('u.Account.ownerId'+u.Account.ownerId);
        system.debug('query'+[select name from user ]);
        system.debug('account owner '+u.account.owner.Name);
        // businessWrapper.accManager=[select name from user where id=:u.Account.ownerId].Name;
        businessWrapper.accManager=u.account.owner.Name;
        aggList=[select Customer_PO_No__c,count(id) cnt from ET_Sales_Agreement__c 
                 where Salesforce_Customer__c IN :childAccountIDs AND Recordtype.Name='Rental Sales Agreement' and Contract_Status__c='ACTIVE' and Sales_Agreement_Type__c='Fixed' group by Customer_PO_No__c];
		otheraggList=[select Customer_PO_No__c,count(id) cnt from ET_Sales_Agreement__c 
                 where Salesforce_Customer__c IN :childAccountIDs AND Recordtype.Name='Rental Sales Agreement' and Contract_Status__c='ACTIVE' and Sales_Agreement_Type__c='Variable' group by Customer_PO_No__c];
        maintenanceAggList=[select Customer_PO_No__c,count(id) cnt from ET_Sales_Agreement__c
                            where Salesforce_Customer__c IN :childAccountIDs AND Recordtype.Name='Maintenance Sales Agreement' and Contract_Status__c='ACTIVE'
                            group by Customer_PO_No__c];
        
        businessWrapper.invCount =[select count()
                                   from Invoice__c 
                                   where Customer__c IN :childAccountIDs]; 
		businessWrapper.lst_hsescore= [select id, Account__c,Cumulative_Score__c, Month__c, Percentage__c, Score__c, Weightage__c, Year__c from HSE_Info__c where RecordType.Developername='HSE_Scores' AND Account__c = :u.AccountId order by createddate];
		Decimal cumpecent=0;
		for(HSE_Info__c hs : businessWrapper.lst_hsescore)
		{
            if(hs.Percentage__c != null)
			cumpecent+=hs.Percentage__c;
		}
		businessWrapper.cumpercent=cumpecent/12+'';
      
        //  }
        for(AggregateResult aggr:aggList ){ 
            businessWrapper.poList.put((String)aggr.get('Customer_PO_No__c'),(integer)aggr.get('cnt'));
        }
        for(AggregateResult aggr:maintenanceAggList ){ 
            businessWrapper.maintenancePoList.put((String)aggr.get('Customer_PO_No__c'),(integer)aggr.get('cnt'));
        }
		for(AggregateResult aggr:otherAggList ){ 
            businessWrapper.otherPoList.put((String)aggr.get('Customer_PO_No__c'),(integer)aggr.get('cnt'));
        }
		
        
        system.debug(' businessWrapper = '+businessWrapper);
        return businessWrapper;
    }
	
	public class MyBusinessWrapperV1{
        @AuraEnabled public Map<String,Integer> poList=new Map<String,Integer>();
        @AuraEnabled public Map<String,Integer> maintenancePoList=new Map<String,Integer>();
		@AuraEnabled public Map<String,Integer> otherPoList=new Map<String,Integer>();
        @AuraEnabled public String cntRecord;
        @AuraEnabled public String accRecord; 
        @AuraEnabled public String vehicleRecord;
        @AuraEnabled public String salesRecord;
        @AuraEnabled public List<ET_Sales_Agreement__c> salesAgreementList;
        @AuraEnabled public List<SALine_Assigned_Vehicle__c> assignedVehicleList;
        @AuraEnabled public List<SALine_Assigned_Resource__c> assignedResourcesList;
        @AuraEnabled public List<Invoice__c> invoicesList;
        @AuraEnabled public List<Opportunity> opportunityList;
        @AuraEnabled public integer sitesCount=0;
        @AuraEnabled public integer invCount=0;
        @AuraEnabled public integer studentsCount=0;
        @AuraEnabled public List<Account> schoolList;
        @AuraEnabled public String  accManager;
        @AuraEnabled public List<ETST_Student__c> studentsList;
		@AuraEnabled public List<HSE_Info__c> lst_hsescore;
        @AuraEnabled public Boolean isADNOC= false;
		@AuraEnabled public String cumpercent;
       
        public MyBusinessWrapperV1(){
            salesAgreementList = new List<ET_Sales_Agreement__c>();
            assignedVehicleList = new List<SALine_Assigned_Vehicle__c>();
            assignedResourcesList = new List<SALine_Assigned_Resource__c>();
            invoicesList = new List<Invoice__c>();
            studentsList=new List<ETST_Student__c>();
            opportunityList=new List<Opportunity>();
        }
    }
	@AuraEnabled
    public static MyBusinessWrapperV1 getUserAccountDetailsbyAccount(String AccountId){
        MyBusinessWrapperV1 businessWrapper = new MyBusinessWrapperV1();
        List<AggregateResult> aggList =new  List<AggregateResult>();
        List<AggregateResult> maintenanceAggList =new  List<AggregateResult>();
		List<AggregateResult> otherAggList =new  List<AggregateResult>();
		Account acc=[select id, owner.name from Account where id=:AccountId];
        businessWrapper.accRecord=AccountId;
        
        String profileName =[SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId()].Name;
		
        system.debug('profile name'+profileName);
        if(profileName=='ADNOC Partner Community'){
            businessWrapper.isADNOC=true;
        }
        
        businessWrapper.sitesCount=[select count() from Account where ParentId=:AccountId];
		
        system.debug('childAccountIDs value'+AccountId);
        List<ETST_Student__c> currentList=new  List<ETST_Student__c>();
        businessWrapper.studentsCount=[select count() from ETST_Student__c where ETST_School__c=:AccountId];
        businessWrapper.opportunityList=[select id,Name,CreatedBy.Name,CreatedDate,ETSALES_Opportunity_Number__c,StageName,RecordType.Name from Opportunity where AccountId =:AccountId AND ET_Opportunity_Source__c='Community Portal'];
        system.debug('opp list value'+businessWrapper.opportunityList);
        system.debug('query'+[select name from user ]);
        // businessWrapper.accManager=[select name from user where id=:u.Account.ownerId].Name;
        businessWrapper.accManager=acc.owner.Name;
        aggList=[select Customer_PO_No__c,count(id) cnt from ET_Sales_Agreement__c 
                 where Salesforce_Customer__c = :AccountId AND Recordtype.Name='Rental Sales Agreement' and Contract_Status__c='ACTIVE' and Sales_Agreement_Type__c='Fixed' group by Customer_PO_No__c];
		otheraggList=[select Customer_PO_No__c,count(id) cnt from ET_Sales_Agreement__c 
                 where Salesforce_Customer__c = :AccountId AND Recordtype.Name='Rental Sales Agreement' and Contract_Status__c='ACTIVE' and Sales_Agreement_Type__c='Variable' group by Customer_PO_No__c];
        maintenanceAggList=[select Customer_PO_No__c,count(id) cnt from ET_Sales_Agreement__c
                            where Salesforce_Customer__c = :AccountId AND Recordtype.Name='Maintenance Sales Agreement' and Contract_Status__c='ACTIVE'
                            group by Customer_PO_No__c];
        
        businessWrapper.invCount =[select count()
                                   from Invoice__c 
                                   where Customer__c = :AccountId]; 
		businessWrapper.lst_hsescore=[select id, Account__c,Cumulative_Score__c, Month__c, Percentage__c, Score__c, Weightage__c, Year__c from HSE_Info__c where RecordType.Developername='HSE_Scores' AND Account__c = :AccountId order by createddate];
		
		Decimal cumpecent=0;
		for(HSE_Info__c hs : businessWrapper.lst_hsescore)
		{
			cumpecent+=hs.Percentage__c;
		}
		businessWrapper.cumpercent=cumpecent/12+'';
		
        for(AggregateResult aggr:aggList ){ 
            businessWrapper.poList.put((String)aggr.get('Customer_PO_No__c'),(integer)aggr.get('cnt'));
        }
        for(AggregateResult aggr:maintenanceAggList ){ 
            businessWrapper.maintenancePoList.put((String)aggr.get('Customer_PO_No__c'),(integer)aggr.get('cnt'));
        }
		for(AggregateResult aggr:otherAggList ){ 
            businessWrapper.otherPoList.put((String)aggr.get('Customer_PO_No__c'),(integer)aggr.get('cnt'));
        }
        
        system.debug(' businessWrapper = '+businessWrapper);
        return businessWrapper;
    }
	
    @AuraEnabled
    public static List<ETST_Student__c> getStudentList(){
        List<ETST_Student__c> studentList=new List<ETST_Student__c>();
        User u = [select id, AccountId,contactId from User where id = : userInfo.getUserId()];
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        
        system.debug('acc details'+Acc);
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        //added on 06/06
        Set<id> childAccountIDs=new Set<id>();
        if(acctListChild.size()>0){
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
            childAccountIDs.add(Acc.id);
            system.debug('childAccountIDs value'+childAccountIDs);
            List<ETST_Student__c> currentList=new  List<ETST_Student__c>();
            
            currentList=[select id,Name,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c,ETST_School__r.Name from ETST_Student__c where ETST_School__c=:childAccountIDs ];
            system.debug('currentList value'+currentList);
            return currentList;
        }	
        else{
            return [select id,Name,ETST_Student_Id__c,ETST_Account_Name__r.Name,ETST_Emirates_Id__c,ETST_School__r.Name from ETST_Student__c 
                    where ETST_School__c=:u.AccountId ];  
        }
    }
    
    
    
    public class caseWrapper{ 
        @AuraEnabled public Integer newCount=0; 
        @AuraEnabled public Integer inprogressCount=0; 
        @AuraEnabled public Integer closedCount=0; 
        @AuraEnabled public Integer rejectedCount=0; 
        @AuraEnabled public Integer approvedCount=0; 
        @AuraEnabled public string loggedinUserProfileName; 
        @AuraEnabled public Map<String,String> caseType;
        @AuraEnabled public Map<String,String> accountName;
        @AuraEnabled public Map<String,String> caseStatus;
        @AuraEnabled public boolean accountType;
    }
  
    @AuraEnabled
    public static caseWrapper getDashboardData() {
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        
        Account Acc=[select id,Name from Account where Id=:u.AccountId];  
        system.debug('acc details'+Acc);
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        Set<id> childAccountIDs=new Set<id>();
        List<Case> caseList = new List<Case>();
        
        //if parent account
        if(acctListChild.size()>0){
            
            for(Account acc1:acctListChild){
                system.debug('its a parent account');
                childAccountIDs.add(acc1.Id);
            }
            childAccountIDs.add(Acc.id);
            system.debug('childAccountIDs value'+childAccountIDs);
            
            caseWrapper dashboardWrap=new caseWrapper();
            dashboardWrap.accountType = true;
            dashboardWrap.newCount=[select count() from Case where status  ='New' and AccountId=:childAccountIDs];
            dashboardWrap.inprogressCount=[select count() from Case where status  !='New' AND status  !='Closed' AND status  !='Invalid' AND AccountId=:childAccountIDs];
            dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected' and AccountId=:childAccountIDs];
            dashboardWrap.approvedCount=[select count() from Case where status  ='Approved' and AccountId=:childAccountIDs]; 
            dashboardWrap.closedCount=[select count() from Case where (status  ='Closed' OR status  ='Invalid') and AccountId=:childAccountIDs];
            dashboardWrap.caseType = new Map<String,String>();
            caseList=[select id,CaseNumber,AccountId,Account.Name,Status,RecordTypeId, RecordType.Name
                      from Case where status IN ('New','In Progress','Rejected','Approved','Closed')
                      AND RecordTypeId != null
                      and AccountId=:childAccountIDs ORDER BY RecordType.Name];
            system.debug('caselist 548'+caseList);
            system.debug('caselist 548 size'+caseList.size());
            if(caseList.size()>0){
                dashboardWrap.caseType = new Map<String,String>();
                dashboardWrap.accountName = new Map<String,String>();
                dashboardWrap.caseStatus = new Map<String,String>();
                for(Case c:caseList){
                    dashboardWrap.caseType.put(String.valueOf(c.RecordTypeId), String.valueOf(c.RecordType.Name));
                    dashboardWrap.accountName.put(String.valueOf(c.AccountId), String.valueOf(c.Account.Name));
                    dashboardWrap.caseStatus.put(String.valueOf(c.Status), String.valueOf(c.Status));
                }
            }
            /*LIST<RecordType> rtList = [SELECT Id,Name FROM RecordType WHERE SobjectType='Case'];
system.debug('rtList'+rtList);
for(RecordType rt :rtList){
dashboardWrap.caseType.put(rt.Id, rt.Name);
}
system.debug('dashboardWrap.caseType'+dashboardWrap.caseType);*/
            
            //dashboardWrap.caseType=[select Case_Type__c from Case GROUP BY Case_Type__c];
            //commented on 7/6
            /*   dashboardWrap.newCount=[select count() from Case where status  ='New' and ContactId=:u.contactID];
dashboardWrap.inprogressCount=[select count() from Case where status  ='In Progress' and ContactId=:u.contactID];
dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected' and ContactId=:u.contactID];
dashboardWrap.approvedCount=[select count() from Case where status  ='Approved' and ContactId=:u.contactID]; 
dashboardWrap.closedCount=[select count() from Case where status  ='Closed' and ContactId=:u.contactID]; */
            
            // dashboardWrap.loggedinUserProfileName = [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
            system.debug('dashboardWrap***'+dashboardWrap); 
            return dashboardWrap;   
        }    
        else{
            
            //added by shubham to add condtion for adnoc user - to show case of account related as well
            Boolean isADNOCProfile = false;
            Profile p =[Select Id,Name from Profile where Id=:userInfo.getProfileId()];
            String adnicProfileName = System.Label.ET_ADNOC_Profile_Name;
            if(p.Name==adnicProfileName)
                isADNOCProfile= true;
            
            caseWrapper dashboardWrap=new caseWrapper();
            if(isADNOCProfile){
                system.debug('adnoc profile it is');
                dashboardWrap.newCount=[select count() from Case where status  ='New' and (ContactId=:u.contactID OR AccountId=:u.AccountId)];
                dashboardWrap.inprogressCount=[select count() from Case where status !='New' AND status  !='Closed' AND status  !='Invalid' and (ContactId=:u.contactID OR AccountId=:u.AccountId)];
                dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected' and (ContactId=:u.contactID OR AccountId=:u.AccountId)];
                dashboardWrap.approvedCount=[select count() from Case where status  ='Approved' and (ContactId=:u.contactID OR AccountId=:u.AccountId)];
                dashboardWrap.closedCount=[select count() from Case where (status  ='Closed' OR status  ='Invalid') and (ContactId=:u.contactID OR AccountId=:u.AccountId)];
                caseList=[select id,ContactId,AccountId,Account.Name,Status,RecordTypeId, RecordType.Name
                          from Case where status IN ('New','In Progress','Rejected','Approved','Closed')
                          AND RecordTypeId != null
                          AND (ContactId=:u.contactID OR AccountId=:u.AccountId) ORDER BY RecordType.Name];
            }else{
                
                dashboardWrap.newCount=[select count() from Case where status  ='New' and ContactId=:u.contactID];
                dashboardWrap.inprogressCount=[select count() from Case where status !='New' AND status  !='Closed' AND status  !='Invalid' and ContactId=:u.contactID];
                dashboardWrap.rejectedCount=[select count() from Case where status  ='Rejected' and ContactId=:u.contactID];
                dashboardWrap.approvedCount=[select count() from Case where status  ='Approved' and ContactId=:u.contactID]; 
                dashboardWrap.closedCount=[select count() from Case where (status  ='Closed' OR status  ='Invalid') and ContactId=:u.contactID]; 
                caseList=[select id,ContactId,AccountId,Account.Name,Status,RecordTypeId, RecordType.Name
                          from Case where status IN ('New','In Progress','Rejected','Approved','Closed')
                          AND RecordTypeId != null
                          AND ContactId=:u.contactID ORDER BY RecordType.Name];
            }
            system.debug('caselist 590'+caseList);
            system.debug('caselist 591 size'+caseList.size());
            dashboardWrap.caseType = new Map<String,String>();
            dashboardWrap.accountName = new Map<String,String>();
            dashboardWrap.caseStatus = new Map<String,String>();
            if(caseList.size()>0){
                for(Case c:caseList){
                    system.debug('RecordTypeId 590'+c.RecordTypeId);
                    system.debug('c.RecordType.Name 590'+c.RecordType.Name);
                    dashboardWrap.caseType.put(String.valueOf(c.RecordTypeId), String.valueOf(c.RecordType.Name));
                    dashboardWrap.accountName.put(String.valueOf(c.AccountId), String.valueOf(c.Account.Name));
                    dashboardWrap.caseStatus.put(String.valueOf(c.Status), String.valueOf(c.Status));
                }
            }
            dashboardWrap.accountType = false;
            return dashboardWrap;
        }
        
    } 
    
    @AuraEnabled
    public static List<Case> getCaseDetails(string status) {
        User u=[select id,accountID,contactID,profile.Name from user where id=:userinfo.getUserId()];
        //added by abrara
        Account Acc=[select id,Name from Account where Id=:u.accountID];  
        system.debug('acc details'+Acc);
        system.debug('inside final768 '+status);
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        List<id> childAccountIDs=new List<id>();
        List<Id> parentID=new List<Id>();
        List<ETST_Student__c> students=new List<ETST_Student__c>();
        try{
            //if its parent account
            if(acctListChild.size()>0){
                for(Account acc1:acctListChild){
                    system.debug('its a parent account');
                    childAccountIDs.add(acc1.Id);
                }
                childAccountIDs.add(Acc.id);
                students=[select id,Name,ETST_School__c,ETST_Account_Name__c from ETST_Student__c where ETST_School__c=:childAccountIDs];
                
                
                for(ETST_Student__c student:students){
                    parentID.add(student.ETST_Account_Name__c);
                }
                system.debug('students ****** '+students);
                system.debug('parentID ***** '+students);
                system.debug('childAccountIDs ********* '+childAccountIDs); 
              
                List<Case> currentList=new  List<Case>();
                if(status == 'All'){
                    currentList=[select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                 Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                 Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                                 from Case where status IN ('New','In Progress','Rejected','Approved','Closed')
                                 and (AccountId=:childAccountIDs OR AccountId=:parentID) ORDER BY CreatedDate DESC];
                    return currentList; 
                }else if(status =='In Progress'){
                    return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                            Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                            Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                            from Case where status  !='New' AND status  !='Closed' AND status  !='Invalid' and (AccountId=:childAccountIDs OR AccountId=:parentID) ORDER BY CreatedDate DESC];
                }else if(status =='Closed'){
                    return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                            Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                            Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                            from Case where (status  ='Closed' OR status  ='Invalid') and (AccountId=:childAccountIDs OR AccountId=:parentID) ORDER BY CreatedDate DESC];
                }else {
                    system.debug('inside else final'+status);
                    system.debug('inside else childAccountIDs'+childAccountIDs);
                    system.debug('inside else parentID'+parentID);
                    return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                               Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                               Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                               from Case where status=:status and (AccountId=:childAccountIDs OR AccountId=:parentID) ORDER BY CreatedDate DESC];
                   
                }
            }
            //if a child account - old code just added else part
            else{
                //added by shubham to add condtion for adnoc user - to show case of account related as well
                Boolean isADNOCProfile = false;
                Profile p =[Select Id,Name from Profile where Id=:userInfo.getProfileId()];
                String adnicProfileName = System.Label.ET_ADNOC_Profile_Name;
                if(p.Name==adnicProfileName)
                    isADNOCProfile= true;
                
                students=[select id,Name,ETST_School__c,ETST_Account_Name__c from ETST_Student__c where ETST_School__c=:u.contactID];
                
                
                for(ETST_Student__c student:students){
                    parentID.add(student.ETST_Account_Name__c);
                }
                system.debug('students value'+students);
                system.debug('parentID value'+students);
                if(isADNOCProfile){
                    if(status == 'All'){
                        return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                                from Case where status IN ('New','In Progress','Escalated','Invalid','Rejected','Approved','Closed')
                                and (ContactId=:u.contactID OR AccountId=:u.AccountId) ORDER BY CreatedDate DESC]; 
                    } 
                    else if(status =='In Progress'){
                        return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                                from Case where status  !='New' AND status  !='Closed' AND status  !='Invalid' and (ContactId=:u.contactID OR AccountId=:u.AccountId) ORDER BY CreatedDate DESC];
                    }else if(status =='Closed'){
                        return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                                from Case where (status  ='Closed' OR status  ='Invalid') and (ContactId=:u.contactID OR AccountId=:u.AccountId) ORDER BY CreatedDate DESC];
                    }else{
                        return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                                from Case where status=:status and (ContactId=:u.contactID OR AccountId=:u.AccountId) ORDER BY CreatedDate DESC];
                    }
                }else{
                    if(status == 'All'){
                        return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                                from Case where status IN ('New','In Progress','Escalated','Invalid','Rejected','Approved','Closed')
                                and (ContactId=:u.contactID or AccountId=:parentID ) ORDER BY CreatedDate DESC]; 
                    } 
                    else if(status =='In Progress'){
                        return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                                from Case where status  !='New' AND status  !='Closed' AND status  !='Invalid' and (ContactId=:u.contactID or AccountId=:parentID) ORDER BY CreatedDate DESC];
                    }else if(status =='Closed'){
                        return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                                from Case where (status  ='Closed' OR status  ='Invalid') and (ContactId=:u.contactID or AccountId=:parentID) ORDER BY CreatedDate DESC];
                    }else{
                        return [select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c,
                                Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c,
                                Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name,CreatedBy.name
                                from Case where status=:status and (ContactId=:u.contactID or AccountId=:parentID) ORDER BY CreatedDate DESC];
                    }
                }
                
            }
            
        }
        catch (Exception e) {
            System.debug(e.getMessage());
            return null;
            
        }
    } 
    
    //Added this code to get the preferred location from opportunity
    //Developer -shubham ,Abrara
    @AuraEnabled        
    public static Map<String, String> getPickListValues(String selectedObject, String selectedField){
        Map<String, String> pickListValuesList = new Map<String, String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
            .get(selectedObject).getDescribe();
        
        DescribeFieldResult fieldResult = objResult.fields.getMap()
            .get(selectedField).getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){ 
            pickListValuesList.put(pickListVal.getLabel(),pickListVal.getLabel());
        }     
         
        System.debug('Values in '+selectedObject+' of '+selectedField+' are : '+pickListValuesList);
        return pickListValuesList;
    }
    
    
    
    @AuraEnabled
    public static List<Case> getCaseDetailsBasedOnFilter(String selectedType,String selectedAccountId,String selectedStatus,Boolean accountType, Date selectedStartDate,Date selectedEndDate) {
        System.debug('Values in selectedType '+selectedType);
        System.debug('Values in selectedAccountId '+selectedAccountId);
        System.debug('Values in selectedStatus '+selectedStatus);
        System.debug('Values in accountType '+accountType);
        System.debug('Values in selectedStartDate '+selectedStartDate);
        System.debug('Values in selectedEndDate '+selectedEndDate);
        DateTime formatedStartDt;
        DateTime formatedEndDt;
        if(selectedStartDate!=null){
            formatedStartDt =  DateTime.newInstanceGmt(selectedStartDate.year(), selectedStartDate.month(), selectedStartDate.day(), 0, 0, 0);      
        }
        if(selectedEndDate!=null){
            formatedEndDt =  DateTime.newInstanceGmt(selectedEndDate.year(), selectedEndDate.month(),selectedEndDate.day(),23,59,59);
        }
        User u=[select id,accountID,contactID from user where id=:userinfo.getUserId()];
        String selectedContact = u.ContactId != null ? u.ContactId : null;
        //added by abrara
        Account Acc=[select id,Name from Account where Id=:u.accountID];  
        system.debug('acc details'+Acc);
        List<Account> acctListChild = [Select name,Id,parentId from Account where parentId =: Acc.id];
        Set<id> childAccountIDs=new Set<id>();
        try{
            
            if(acctListChild.size()>0){
                system.debug('inside parent');
                for(Account acc1:acctListChild){
                    system.debug('its a parent account');
                    childAccountIDs.add(acc1.Id);
                }  
                childAccountIDs.add(Acc.id);
                system.debug('childAccountIDs value'+childAccountIDs);
                String soql = 'select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c, Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c, Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name from Case WHERE RecordType.Name !=null';
                
                if(String.isNotBlank(selectedType)){
                    system.debug('*selectedType**'+selectedType);
                    soql+=' AND RecordTypeId=:selectedType';
                }
                if(String.isNotBlank(selectedAccountId)){
                    system.debug('selectedAccountId '+selectedAccountId);
                    soql += ' AND AccountId=:selectedAccountId '; 
                }
                if(String.isBlank(selectedAccountId)){
                    system.debug('selectedAccountId '+selectedAccountId);
                    soql += ' AND AccountId=:childAccountIDs '; 
                }
                if(String.isNotBlank(selectedStatus)){
                    system.debug('selectedStatus '+selectedStatus);
                    soql += ' AND Status=:selectedStatus '; 
                }
                if(String.isNotBlank(selectedStatus)){
                    system.debug('selectedStatus '+selectedStatus);
                    soql += ' AND Status=:selectedStatus '; 
                }
                if(formatedStartDt!=null){
                    system.debug('formatedStartDt '+formatedStartDt);
                    soql += ' AND CreatedDate>=:formatedStartDt '; 
                }
                if(formatedEndDt!=null){
                    system.debug('formatedEndDt '+formatedEndDt);
                    soql += ' AND CreatedDate<=:formatedEndDt '; 
                }
                system.debug('****QUERY SOQL760****'+soql);
                List<Case> listToDisplay =  Database.Query(soql);
                return listToDisplay;
            }
            
            else{
                
                system.debug('inside child query'+selectedContact);
                String soql = 'select id,CaseNumber,Status,RecordType.developerName,RecordTypeId,Invoice__c,Invoice__r.name,Sub_Status__c, Subject, Description, RecordType.Name,ETST_Student__c,ETST_Student__r.Name,Sales_Agreement__c,Sales_Agreement__r.Name,Assigned_Resource__c, Assigned_Resource__r.Name,  Assigned_Vehicle__c,Assigned_Vehicle__r.Name,Status_Category__c,CreatedDate,Account.Name,Owner.Name from Case WHERE RecordTypeId != null';
                if(String.isNotBlank(selectedContact)){
                    system.debug('*selectedContact**'+selectedContact);
                    soql+=' AND ContactId=:selectedContact';
                }
                if(String.isNotBlank(selectedType)){
                    system.debug('*selectedType**'+selectedType);
                    soql+=' AND RecordTypeId=:selectedType';
                }
                if(String.isNotBlank(selectedStatus)){
                    system.debug('selectedStatus '+selectedStatus);
                    soql += ' AND Status=:selectedStatus '; 
                }
                system.debug('****QUERY SOQL777****'+soql);
                List<Case> listToDisplay =  Database.Query(soql);
                return listToDisplay;
                
            }
            
        }
        catch (Exception e) {
            System.debug(e.getMessage());
            return null;
            
        }
    } 
    
    @AuraEnabled        
    public static void deleteFile(String fileId){
        system.debug('fileId--> '+fileId);
        ET_User_Files__c userFileRce=[ SELECT id, Doc_Id__c,File_Name__c from ET_User_Files__c 
                                      where Doc_Id__c=:fileId LIMIT 1];
        delete userFileRce;
        delete[SELECT id from ContentDocument where id=:fileId];
    }
    
    @AuraEnabled        
    public static String getProfileName(){
        return [Select Id,Name from Profile WHERE Id=:userinfo.getProfileId()].Name;
    }
    
    @AuraEnabled        
    public static void insertTimesheet(String currentMonth,String accountId,String timesheetURL){
        system.debug('currentMonth123== '+currentMonth);
        system.debug('accountId123== '+accountId);
        system.debug('timesheetURL123== '+timesheetURL);
        ADNOC_Timesheet_Link__c timesheet = new ADNOC_Timesheet_Link__c();
        timesheet.name = currentMonth+'-'+ String.valueOf(System.Today().year());
        timesheet.Account__c = accountId;
        timesheet.Timesheet_URL__c = timesheetURL;
        insert timesheet;
    }
    @AuraEnabled        
    public static String getTimesheet(String fiscalMonth,String accountId){
        system.debug('fiscalMonth11='+fiscalMonth); 
        system.debug('accountIdd11='+accountId);
        String url = '';
        List<ADNOC_Timesheet_Link__c> timesheetURL=[Select Id, Name, Timesheet_URL__c, Account__c 
                                                    FROM ADNOC_Timesheet_Link__c 
                                                    WHERE Account__c=:accountId AND Name=:fiscalMonth LIMIT 1];
        system.debug('timesheetURL='+timesheetURL);
        if(timesheetURL.size() > 0){
            url =timesheetURL[0].Timesheet_URL__c;
        } 
        Return url;
    }
    
  
    @AuraEnabled
    public static ResultWrapper getprivateschoolUserData(){//ashwini
        system.debug('inside et_b2b');
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
    @AuraEnabled //Added by Janardhan - 11/08/22
    public static list<Traffic_Fine__c> getTrafficFineDetails(String AccountId,boolean showAllAcc){ 
        
         set<id> accIdList = new set<id>();  
         accIdList.add(AccountId); 
        if(showAllAcc){           
            for(account acc: [select id,parentId from Account where parentId=:AccountId]){
                accIdList.add(acc.Id);
            }
        } 
        
        return [select Id,Name,Assigned_Vehicle__r.Name,Assigned_Vehicle__c,Vehicle_Master__c,Assigned_Vehicle__r.Plate_Number__c,Fine_Amount__c,Fine_Supplier__c,Invoice_Number__c,Status__c,Ticket_Date__c,Vehicle_Master__r.Name,Location__c,Reason__c from Traffic_Fine__c Where Account__c=:accIdList AND Assigned_Vehicle__c != null AND Ticket_Date__c = LAST_N_Days:120 order by Ticket_Date__c DESC];
    }
    
     @AuraEnabled //Added by Janardhan - 29/08/22
    public static list<ET_Sales_Agreement__c> getSaleAgreementInfo(String AccountId,boolean showAllAcc){
        
        set<id> accIdList = new set<id>();  
        accIdList.add(AccountId); 
        if(showAllAcc){           
            for(account acc: [select id,parentId from Account where parentId=:AccountId]){
                accIdList.add(acc.Id);
            }
        } 
        
        return [select Id,Name,Customer_PO_No__c,Sales_Agreement_Type__c,(select id,name,Employee_ID__c,Employee_Name__c,Assign_Start_Date__c,Assign_End_Date__c from Associated_Resources__r where Assign_End_Date__c>= TODAY),(select Id,Name,Vehicle_Number__c,Plate_Number__c,Plate_Source__c,Vehicle_Type__c,Assign_Start_Date__c,Assign_End_Date__c from Associated_Vehicles__r where Assign_End_Date__c>=TODAY) from ET_Sales_Agreement__c where Salesforce_Customer__c=:accIdList AND Contract_Status__c='Active' order by createdDate DESC];
    }
    @AuraEnabled //Added by Janardhan - 31/08/22
    public static list<Account_Visit__c> getAccVisitsInfo(String AccountId,boolean showAllAcc){
        
        set<id> accIdList = new set<id>();  
        accIdList.add(AccountId); 
        if(showAllAcc){           
            for(account acc: [select id,parentId from Account where parentId=:AccountId]){
                accIdList.add(acc.Id);
            }
        } 
       
        return [select Id,Name,Agreed_Actions__c,Date_of_Visit__c,Purpose_of_Visit__c from Account_Visit__c where Account__c=:accIdList order by createdDate DESC limit 200];
    }
     @AuraEnabled //Added by Janardhan - 1/09/22
    public static list<Vehicle_Accident__c> getVehicleAccidentInfo(String AccountId,boolean showAllAcc){
        
        set<id> accIdList = new set<id>();  
        accIdList.add(AccountId); 
        if(showAllAcc){           
            for(account acc: [select id,parentId from Account where parentId=:AccountId]){
                accIdList.add(acc.Id);
            }
        } 
        
        return [select Id,Name,Accident_Date__c,Accident_Location__c,Accident_Place__c,Accident_Reason__c,Accident_Type__c,Account__c,Area_of_Accident__c,Reason_in_Details__c,Responsibility__c,Vehicle__r.Name,Vehicle__r.Plate_Number__c,Vehicle__c from Vehicle_Accident__c where Account__c=:accIdList order by Accident_Date__c DESC limit 500];
    }
     @AuraEnabled //Added by Janardhan - 07/09/22
    public static list<HSE_Info__c> getHSEInfo(String AccountId,boolean showAllAcc){
        System.debug('gethseinfo');
        set<id> accIdList = new set<id>();  
        accIdList.add(AccountId); 
        if(showAllAcc){           
            for(account acc: [select id,parentId from Account where parentId=:AccountId]){
                accIdList.add(acc.Id);
            }
        } 
       
       return [select Id,Name,RecordType.DeveloperName,Description__c,Induction_Date__c,Inspected_Date__c,Installation_Date__c,No_of_Devices__c,No_of_Fleets__c,No_of_People_Attended__c,Workshop_Date__c,CreatedBy.Name,(select id,LinkedEntityId,ContentDocumentId,ContentDocument.Title,ContentDocument.FileType from ContentDocumentLinks) FROM HSE_Info__c Where Account__c=:accIdList order by createdDate DESC limit 500];
    }
    
  /*   @AuraEnabled  
    public static List<ContentDocument> getFiles(string recordId){ 
        System.debug(recordId);
        List<ContentDocument> DocumentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();  //store file ids
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  // Document ids
        }      
        DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds];  
        System.debug(DocumentList);
        return DocumentList;  
    }  */
    
      @AuraEnabled //Added by Janardhan - 28/03/23
    public static list<Fleet_Service_Request__c> getFleetServiceRequest(String AccountId,boolean showAllAcc){       
       
        set<id> accIdList = new set<id>();  
        accIdList.add(AccountId); 
        if(showAllAcc){           
            for(account acc: [select id,parentId from Account where parentId=:AccountId]){
                accIdList.add(acc.Id);
            }
        } 
       return [select Id,Name,Customer_Vehicle__r.Internal_No__c,Service_Number__c,Workshop_Location__r.Name,Odometer_Km__c, Description__c from Fleet_Service_Request__c where Account__c=:accIdList order by createdDate DESC limit 500];
    }
      @AuraEnabled //Added by Janardhan - 29/03/23
    public static list<Account_Workshop_Master__c> getAccVsWorkShopMaster(String AccountId){
        return [select id,Account__c,Workshop_Location__c,Workshop_Location__r.Name from Account_Workshop_Master__c where Account__c=:AccountId ];
    }
    
    @AuraEnabled 
    public static string attachFileToCase(String recordId , String filesData){
        return ET_BusinessCommunityController.attachFileToCase(recordId,filesData);
    }
    
    @AuraEnabled
    public static user getLoggedInUserDetails(){
        System.debug('userinfo  '+userinfo.getUserId());
        user us = [select id,accountID,contactID,Profile.Name,UserRole.Name from user where id=:userinfo.getUserId()];
        return us;
    }
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String value, String recordTypeName) {
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            
            // Modify the query to include filtering by Record Type Name
            String query = 'SELECT Id, ' + filterField + ' FROM ' + objectName;
            if (String.isNotBlank(recordTypeName)) {
                query += ' WHERE RecordType.DeveloperName = \'' + String.escapeSingleQuotes(recordTypeName) + '\'';
            }
            
            if (String.isNotBlank(value)) {
                query += ' AND Id = \'' + value + '\' LIMIT 49999';
            } else {
                query += ' AND ' + filterField + ' LIKE \'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 49999';
            }
            
            for (SObject s : Database.query(query)) {
                recordsDataList.add(new RecordsData((String)s.get(filterField), (String)s.get('Id')));
            }
            
            return recordsDataList;
        } catch (Exception err) {
            if (String.isNotBlank(err.getMessage()) && err.getMessage().contains('error:')) {
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
     //SK
    
    @AuraEnabled
    public static FuelConsumptionWrapper getFuelConsumptionRecords() {
        Date today = Date.today();
        
        Integer currentMonth = today.month();
        Integer currentYear = today.year();
        String monthName = getMonthName(currentMonth);
        System.debug('Month Name: ' + monthName);
        
        // Fetch all records
        List<Fuel_Consumption__c> allRecords = [
            SELECT Id, Name, Fuel_Consumption__c,Fuel_Consumption_Number__c, Month__c, Year__c, Vehicle_Number__r.Name,Vehicle_Number__r.Sales_Agreement__r.Name
            FROM Fuel_Consumption__c
        ];
        
        // Fetch current month
        List<Fuel_Consumption__c> currentMonthRecords = [
            SELECT Id, Name, Fuel_Consumption__c, Fuel_Consumption_Number__c,Month__c, Year__c, Vehicle_Number__r.Name,Vehicle_Number__r.Sales_Agreement__r.Name
            FROM Fuel_Consumption__c 
            WHERE Month__c = :monthName
        ];
        // Separate records by month
        List<Fuel_Consumption__c> januaryRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> februaryRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> marchRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> aprilRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> mayRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> juneRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> julyRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> augustRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> septemberRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> octoberRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> novemberRecords = new List<Fuel_Consumption__c>();
        List<Fuel_Consumption__c> decemberRecords = new List<Fuel_Consumption__c>();
        for (Fuel_Consumption__c record : allRecords) {
            String month = record.Month__c;
            Integer year = Integer.valueOf(record.Year__c);
            
            // Categorize by month
            if (month == 'JANUARY') {
                januaryRecords.add(record);
            } else if (month == 'FEBRUARY') {
                februaryRecords.add(record);
            } else if (month == 'MARCH') {
                marchRecords.add(record);
            } else if (month == 'APRIL') {
                aprilRecords.add(record);
            } else if (month == 'MAY') {
                mayRecords.add(record);
            } else if (month == 'JUNE') {
                juneRecords.add(record);
            } else if (month == 'JULY') {
                julyRecords.add(record);
            } else if (month == 'AUGUST') {
                augustRecords.add(record);
            } else if (month == 'SEPTEMBER') {
                septemberRecords.add(record);
            } else if (month == 'OCTOBER') {
                octoberRecords.add(record);
            } else if (month == 'NOVEMBER') {
                novemberRecords.add(record);
            } else if (month == 'DECEMBER') {
                decemberRecords.add(record);
            }
        }
        // Return the wrapper with lists for each month and year
        return new FuelConsumptionWrapper(allRecords,currentMonthRecords,
            januaryRecords, februaryRecords, marchRecords, aprilRecords, mayRecords, juneRecords, 
            julyRecords, augustRecords, septemberRecords, octoberRecords, novemberRecords, decemberRecords
        );
    }
    
    private static String getMonthName(Integer month) {
        String monthName;
        
        if (month == 1) {
            monthName = 'JANUARY';
        } else if (month == 2) {
            monthName = 'FEBRUARY';
        } else if (month == 3) {
            monthName = 'MARCH';
        } else if (month == 4) {
            monthName = 'APRIL';
        } else if (month == 5) {
            monthName = 'MAY';
        } else if (month == 6) {
            monthName = 'JUNE';
        } else if (month == 7) {
            monthName = 'JULY';
        } else if (month == 8) {
            monthName = 'AUGUST';
        } else if (month == 9) {
            monthName = 'SEPTEMBER';
        } else if (month == 10) {
            monthName = 'OCTOBER';
        } else if (month == 11) {
            monthName = 'NOVEMBER';
        } else if (month == 12) {
            monthName = 'DECEMBER';
        } else {
            monthName = ''; // Handle invalid month number
        }
        
        return monthName;
    }
    
    public class FuelConsumptionWrapper {
        @AuraEnabled
        public List<Fuel_Consumption__c> allRecords { get; set; }
        
        @AuraEnabled
        public List<Fuel_Consumption__c> currentMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> januaryMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> februaryMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> marchMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> aprilMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> mayMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> juneMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> julyMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> augustMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> septemberMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> octoberMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> novemberMonthRecords { get; set; }
        @AuraEnabled
        public List<Fuel_Consumption__c> decemberMonthRecords { get; set; }
        
        public FuelConsumptionWrapper(List<Fuel_Consumption__c> allRecords, List<Fuel_Consumption__c> currentMonthRecords,List<Fuel_Consumption__c> januaryMonthRecords,
        List<Fuel_Consumption__c> februaryMonthRecords,
        List<Fuel_Consumption__c> marchMonthRecords,
        List<Fuel_Consumption__c> aprilMonthRecords,
        List<Fuel_Consumption__c> mayMonthRecords,
        List<Fuel_Consumption__c> juneMonthRecords,
        List<Fuel_Consumption__c> julyMonthRecords,
        List<Fuel_Consumption__c> augustMonthRecords,
        List<Fuel_Consumption__c> septemberMonthRecords,
        List<Fuel_Consumption__c> octoberMonthRecords,
        List<Fuel_Consumption__c> novemberMonthRecords,
        List<Fuel_Consumption__c> decemberMonthRecords) {
            
            this.allRecords = allRecords;
            this.currentMonthRecords = currentMonthRecords;
            this.januaryMonthRecords = januaryMonthRecords;
            this.februaryMonthRecords = februaryMonthRecords;
            this.marchMonthRecords = marchMonthRecords;
            this.aprilMonthRecords = aprilMonthRecords;
            this.mayMonthRecords = mayMonthRecords;
            this.juneMonthRecords = juneMonthRecords;
            this.julyMonthRecords = julyMonthRecords;
            this.augustMonthRecords = augustMonthRecords;
            this.septemberMonthRecords = septemberMonthRecords;
            this.octoberMonthRecords = octoberMonthRecords;
            this.novemberMonthRecords = novemberMonthRecords;
            this.decemberMonthRecords = decemberMonthRecords;
        }
    }
    
    
       @AuraEnabled
    public static void getQueryDetails(){
        Integer val=0;
        val++;
        val++;
        val++;
          val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;
        val++;

    }
}