/********************************************************************************************************
* @author       Smaartt
* @description  ET_FinanceController- Controller class to process finance document records.

----------------------------------------------------------------------------------------------------------------
            -- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version          Date        Author            Details
1.           V1.0                                   Initial Version
2.           V2.0       2/5/23    Sreelakshmi SK    Added parameters and conditions to include selected from date and to date in getAllInvDetails method
                                                    Added start date and end date parameters in saveFinanceDocument method
*********************************************************************************************************/

public class ET_FinanceController {
    @AuraEnabled
    public static finWrapper  getZoneList() {
        finWrapper wrap=new finWrapper();
        List<AggregateResult> aggList= [SELECT  GL_Zone__c FROM ETSALES_Location__c where GL_Zone__c!=null
                                        group by GL_Zone__c order by GL_Zone__c];
        for(AggregateResult aggr:aggList ){ 
            wrap.zoneList.add((String)aggr.get('GL_Zone__c'));
        }
        aggList= [SELECT  Name FROM GL_Activity__c where Name!=null
                  group by Name order by Name];
        for(AggregateResult aggr:aggList ){ 
            wrap.activityList.add((String)aggr.get('Name'));
        }
        return wrap;
    }
    public class finWrapper{
        @AuraEnabled  public List<string>  zoneList=new List<string>();
        @AuraEnabled  public List<string>  activityList=new List<string>();
    }
    
    @AuraEnabled
    public static List<string> getZoneLocations(String zone) {
        List<string> locList=new list<String>();
        for(ETSALES_Location__c loc: [SELECT  Name FROM ETSALES_Location__c where name!=null and GL_Zone__c=:zone order by Name] ){ // Added order by in query -- Sreelakshmi SK 6/3/2023
            locList.add(loc.Name);
        }
        return locList;
    } 
    /*@AuraEnabled
public static List<Invoice__c>  getInvDetails(String coordinator,String type) {
//string status=System.label.ETST_Payment_Success_In_Review;
List<Invoice__c> invList= [select id,Name,ETST_Coordinator__r.Name,Total_Inv_Amount__c,createdDate,ETST_Type__c
from Invoice__c where ETST_Coordinator__r.Name =:coordinator and ETST_Coordinator__c!=null
and  //Service_Request__r.etst_status__c=:status AND 
ETST_Type__c=:type AND ET_Doc_Id__c=null ];
System.debug('invList++'+invList);
return invList;
}*/
    @AuraEnabled
    public static List<ET_Receipt__c>  getReceiptDetails(String coordinator,String type,String SchoolName) { // Added by Sreelakshmi -- 22 Mar 23 (schoolName)
        //string status=System.label.ETST_Payment_Success_In_Review;
        System.debug('Condition SchoolName:'+SchoolName);
        String qry='select id,Name,ET_Coordinator__r.Name,ET_Amount__c,createdDate,Payment_Mode__c,ET_Service_Request__r.ETST_Student__r.Name,ET_Service_Request__r.ET_Account__r.Name,ET_Service_Request__r.ETST_Student__r.ETST_First_Name__c, ET_Service_Request__r.ETST_Area_Zone__c, ET_Service_Request__r.ETST_Student__r.ETST_Phone__c,  ET_Service_Request__r.ETST_Student__r.ETST_Student_School__c,  ET_Service_Request__r.ETST_Student__r.ETST_Student_Id__c,  ET_Service_Request__r.ETST_Service_Type__c, ET_Service_Request__r.ETST_Transport_Type__c,  ET_Service_Request__r.ETST_Pick_Up_Start_Date__c,  ET_Service_Request__r.ETST_Pick_Up_End_Date__c, ET_Service_Request__r.ETST_Fare_Charges__c,  ET_Payment__r.ETST_AuthorizationCode__c';
        // Added school name condition -- Sreelakshmi SK 22- Mar-23
        qry+=' from ET_Receipt__c where ET_Coordinator__r.Name =:coordinator  and ET_Service_Request__c!=null AND ET_Finance_Document__c=null AND ET_Service_Request__r.ETST_Student__r.ETST_Student_School__c=:SchoolName'; 
        if(type!='' && type!=null){
            qry+='and Payment_Mode__c=:type';
        }      
        
       // System.debug('ReceiptDetails:'+database.query(qry));
        
        return database.query(qry);
    }
    
    /*Test Car Rental Receipts --- Added by Sreelakshmi SK -- 4 April 2023*/
    
    
    
    /*-----------------------------------------------------------------------*/
    
    @AuraEnabled
    public static List<ET_Receipt__c>  getAllInvDetails(String location,String activity,String type1, datetime startDate,datetime endDate) { //added parameters start date and end date --- Sreelakshmi SK 2/5/23
        String outputstartDate;
        String outputendDate;
        //Start date format conversion-- added by Sreelakshmi SK 2/5/23
        if(startDate!=null){
            Datetime inputstartDate = Datetime.valueOf(startDate);
        	outputstartDate = inputstartDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        }
        
        //End date format conversion-- added by Sreelakshmi SK 2/5/23
        if(endDate!=null){
            Datetime inputendDate = Datetime.valueOf(endDate);
            outputendDate = inputendDate.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        }
        
        
        //string status=System.label.ETST_Payment_Success_In_Review;
        //Added ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c in the query --- Sreelakshmi SK 10/4/2023
        string query='select id,ET_Service_Request__r.ETST_Student__r.ETST_School__c,ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c,Name,ET_Coordinator__r.Name,ET_Amount__c,createdDate,Payment_Mode__c,ET_Service_Request__c,ETST_School_Name__c from ET_Receipt__c where ET_Coordinator__r.GL_Location_Code__c =\''+location+'\' and ET_Coordinator__r.GL_Activity_Code__c  =\''+activity+'\' and ET_Coordinator__c!=null and ET_Finance_Document__c=null';
        
        if(type1!='')
        {
            query+=' and Payment_Mode__c= \''+type1+'\'';
        }
        System.debug('startDate:'+startDate);
        // start date condition added by Sreelakshmi SK 2/5/23
        if(startDate!=null){
            query+= ' and CreatedDate >= '+outputstartDate;
        }
        System.debug('endDate:'+endDate);
        // end date condition added by Sreelakshmi SK 2/5/23
        if(endDate!=null){
            query+= ' and CreatedDate<= '+outputendDate;
        }
        system.debug('query '+query);
        List<ET_Receipt__c> invList= Database.query(query);
        //system.debug('created date:'+invList[0].createdDate);
        System.debug('invList Check++'+invList);
        return invList;
    }
    
    /*Test Car Rental Receipts --- Added by Sreelakshmi SK -- 4 April 2023*/
    
   /* @AuraEnabled
    public static List<ET_Receipt__c>  CarRentalGetAllInvDetails(String location,String activity,String type1) {
        Id receiptRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ET_Car_Services').getRecordTypeId();
        string query='select id,Name,ET_Coordinator__r.Name,ET_Amount__c,createdDate,Payment_Mode__c,ET_Service_Request__c,ETST_School_Name__c from ET_Receipt__c where  ET_Finance_Document__c=null and RecordTypeId:=receiptRecordTypeId';
        
        if(type1!='')
        {
            query+=' and Payment_Mode__c= \''+type1+'\'';
        }
        system.debug('query '+query);
        List<ET_Receipt__c> carRentalInvList= Database.query(query);
        //System.debug('invList Check++'+invList);
        return carRentalInvList;
    }*/
    
    /*-----------------------------------------------------------------------*/
    
    @AuraEnabled
    public static Map<String, List<AggregateResult>> getInvoiceByLoc(String zone,String location,String activity,String type,DateTime startDate,DateTime endDate) {
        //string status=System.label.ETST_Payment_Success_In_Review;
        String locCode=[select Location_Code__c FROM ETSALES_Location__c where name=:location LIMIT 1].Location_Code__c;
        String actCode=[select GL_Activity_Code__c from GL_Activity__c where name=:activity LIMIT 1].GL_Activity_Code__c;
        String qry='SELECT ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.ETSALES_Customer_Account_Id__c customerOracleId,ET_Service_Request__r.ETST_Student__r.ETST_School__c schoolId,ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c serviceSchoolName,ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.AccountNumber accountNumber, ET_Coordinator__c coordinator,ET_Coordinator__r.Name coordinatorName,sum(ET_Amount__c) totalAmount, COUNT(Id) invCount,ET_Service_Request__r.ETST_Student__r.ETST_School_Name__r.Name SchoolName  FROM ET_Receipt__c where ET_Coordinator__c!=null  AND ET_Finance_Document__c=null ';//and Service_Request__r.etst_status__c=:status
        if(location!=null && location!='')
            qry+=' AND ET_Coordinator__r.GL_Location_Code__c =:locCode ';
        if(activity!=null && activity!='')
            qry+=' AND ET_Coordinator__r.GL_Activity_Code__c  =:actCode ';
        if(type!=null && type!='')
            qry+=' AND Payment_Mode__c=:type ';
        if(startDate!=null)
            qry+=' AND createdDate>= :startDate ';
        if(endDate!=null)
            qry+=' AND createdDate<= :endDate '; 
        qry+='group by ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c,ET_Service_Request__r.ETST_Student__r.ETST_School__c,ET_Coordinator__r.Name,ET_Coordinator__c,ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.ETSALES_Customer_Account_Id__c,ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.AccountNumber,ET_Service_Request__r.ETST_Student__r.ETST_School_Name__r.Name order by ET_Coordinator__r.Name';                                                        
        //qry+='group by ET_Coordinator__r.Name order by ET_Coordinator__r.Name';                                                                
        List<AggregateResult> lstAggregateResult= database.query(qry);
        Map<String, List<AggregateResult>> mapOfAggregateResult = new Map<String, List<AggregateResult>>();
        if(!lstAggregateResult.isEmpty()){
            for(AggregateResult ag : lstAggregateResult) {
                if(mapOfAggregateResult.containsKey((string)ag.get('accountNumber'))) {
                    List<AggregateResult> result = mapOfAggregateResult.get((string)ag.get('accountNumber'));
                    result.add(ag);
                    mapOfAggregateResult.put((string)ag.get('accountNumber'), result);
                } else {
                    mapOfAggregateResult.put((string)ag.get('accountNumber'), new List<AggregateResult> {ag});
                }
            }
        }
        system.debug('mapOfAggregateResult***'+mapOfAggregateResult);
        // return database.query(qry);
        return mapOfAggregateResult;
    } 
    
    @AuraEnabled  
    public static void saveFinanceDocument(String zone,String location,String activity,
    String type,String lines,datetime StartDate,datetime EndDate) { //added parameters start date and end date --- Sreelakshmi SK 2/5/23
        String locCode=[select Location_Code__c FROM ETSALES_Location__c where name=:location LIMIT 1].Location_Code__c;
        String actCode=[select GL_Activity_Code__c from GL_Activity__c where name=:activity LIMIT 1].GL_Activity_Code__c;
        List<ET_Receipt__c> invList= getAllInvDetails(locCode,actCode,type,StartDate,EndDate);
        //List<ET_Receipt__c> invList= getReceiptDetails(coordinator,type,SchoolName);
        System.debug('invList --->'+invList);
        System.debug('lines +++>'+lines);
        List<ET_Receipt__c> updateInvoices=new List<ET_Receipt__c>();
        List<ET_Service_Request__c> updateSRs=new List<ET_Service_Request__c>();
        //List<ET_FinanceController.InvoiceWrapper> wrapperList = (List<ET_FinanceController.InvoiceWrapper>) JSON.deserialize(lines, List<InvoiceWrapper>.class);
        List<ET_FinanceController.Wrapper> wrapperList = (List<ET_FinanceController.Wrapper>)JSON.deserialize(lines, List<Wrapper>.class);
        ET_Invoice_Header__mdt invHeader=[select developerName,ET_BatchSource__c,ET_BillToCustomerNumber__c,ET_Comments__c,
                                          ET_CustTrxType__c,ET_PaymentMethod__c,ET_TransactionCurrency__c 
                                          from ET_Invoice_Header__mdt where developerName='School_Invoice' LIMIT 1];
        List<ET_Finance_Document__c> financeDocs = new List<ET_Finance_Document__c>();
        Map<String, String> mapOfFinDocAndFinDocItem = new Map<String, String>();
        SObject[] sobjList = new List<SObject>(); 
        for(ET_FinanceController.Wrapper inv : wrapperList){
            for(InvoiceWrapper wrap : inv.value){
                ET_Finance_Document__c doc=new ET_Finance_Document__c();
                doc.ET_Zone__c=zone;
                doc.ET_Location__c=location;
                doc.ET_Activity__c=activity;
                doc.ET_Transaction_Type__c=type;
                doc.ET_Prepared_By__c=userInfo.getUserId();
                doc.ET_Status__c='Confirmed';
                doc.ET_Approved_By__c=userInfo.getUserId();
                doc.ET_Prepared_Date__c=System.now();
                doc.ET_Approved_Date__c=System.now();
                doc.ET_Batch_Source__c=invHeader.ET_BatchSource__c;//'CRM-GST';
                doc.ET_Bill_To_Customer__c=wrap.accountNumber;
                doc.ET_Customer_Oracle_Number__c=wrap.customerOracleId;
                doc.ET_Payment_Mode__c=invHeader.ET_PaymentMethod__c;//'ON';;
                datetime dt= system.now();
                String dtcombination=dt.format('yyyyMMddhmmss');
                doc.Name_Bill_to_Customer__c = wrap.accountNumber+'-'+wrap.coordinatorName+'-'+wrap.totalAmount+'-'+dtcombination;
                mapOfFinDocAndFinDocItem.put(wrap.accountNumber+'-'+wrap.coordinatorName+'-'+wrap.totalAmount, doc.Name_Bill_to_Customer__c);
                financeDocs.add(doc);
            }
        } 
        try{
           // insert Doc;
            ET_Invoice_Lines__mdt lineItemmdt  = [SELECT DeveloperName,ET_LineType__c,ET_Tax_Code__c,ET_Tax_Rate__c,ET_Tax_Amount__c,ET_Department__c,ET_Project__c,ET_ServiceType__c FROM ET_Invoice_Lines__mdt WHERE DeveloperName='SCHOOL_BUS_FEE' limit 1];
            List<ETST_Invoice_Lines_Location__mdt> lstLinesLocation = [Select DeveloperName,ETST_Location_Center__c, ETST_Location_Code__c FROM ETST_Invoice_Lines_Location__mdt];
            ETST_Invoice_Lines_Activity__mdt lstLinesActivity = [Select DeveloperName,ETST_Activity_Center__c, ETST_Activity_Code__c FROM ETST_Invoice_Lines_Activity__mdt where DeveloperName='Private_School_Transport'];
            List<ET_Finance_Document_LineItem__c> lstInvoiceLineItems = new List<ET_Finance_Document_LineItem__c>();
            Map<String, ETST_Invoice_Lines_Location__mdt> mapInvoiceLinesLocations =  new Map<String, ETST_Invoice_Lines_Location__mdt>(); 
            Map<String, ETST_Invoice_Lines_Activity__mdt> mapInvoiceLinesActivityCenter =  new Map<String, ETST_Invoice_Lines_Activity__mdt>(); 
            
            for(ETST_Invoice_Lines_Location__mdt loc : lstLinesLocation){
                mapInvoiceLinesLocations.put(loc.ETST_Location_Center__c, loc);
            }
            for(ET_FinanceController.Wrapper inv : wrapperList){
                for(InvoiceWrapper invWrap : inv.value){
                    ET_Finance_Document_LineItem__c lineItem = new ET_Finance_Document_LineItem__c();
                    lineItem.ET_Service_Type__c = lineItemmdt.ET_ServiceType__c;
                    lineItem.ET_Tax_Amount__c = Integer.ValueOf(lineItemmdt.ET_Tax_Amount__c);
                    lineItem.ET_Tax_Code__c = lineItemmdt.ET_Tax_Code__c;
                    lineItem.ET_Tax_Rate__c = lineItemmdt.ET_Tax_Rate__c; 
                    //lineItem.School__c=invWrap.schoolId;
                    lineItem.School_Name__c=invWrap.serviceSchoolName; // Added by Sreelakshmi SK 6/4/2023
                    //lineItem.School__c='0018E00001iRdtZQAS';
                    lineItem.ET_Department__c = lineItemmdt.ET_Department__c;
                    lineitem.ET_Activity_Center__c = actCode; //mapInvoiceLinesActivityCenter.get(inv.ET_Activity_Center__c).ETST_Activity_Code__c;
                    lineitem.ET_Location__c = locCode;
                    lineitem.ET_Coordinator__c=invWrap.coordinator;
                    if(mapOfFinDocAndFinDocItem.containsKey(invWrap.accountNumber+'-'+invWrap.coordinatorName+'-'+invWrap.totalAmount)){
                        ET_Finance_Document__c conReference = new ET_Finance_Document__c(Name_Bill_to_Customer__c =mapOfFinDocAndFinDocItem.get(invWrap.accountNumber+'-'+invWrap.coordinatorName+'-'+invWrap.totalAmount)); 
                        lineItem.ET_Finance_Document__r = conReference; 
                    }   
                    lineItem.ET_Line_Type__c = lineItemmdt.ET_LineType__c;
                    lineItem.ET_Amount__c = Decimal.valueOf(invWrap.totalAmount);
                    lineItem.ET_Invoice_Count__c = Decimal.valueOf(invWrap.invCount);
                    lineItem.ET_Project__c = lineItemmdt.ET_Project__c;
                    lstInvoiceLineItems.add(lineItem);
                    System.debug('lstInvoiceLineItems'+lstInvoiceLineItems);
                }
            } 

            if(!lstInvoiceLineItems.isEmpty() && !financeDocs.isEmpty()){
                sobjList.addAll(financeDocs);
                sobjList.addAll(lstInvoiceLineItems);
               // insert lstInvoiceLineItems;
                Database.SaveResult[] results = Database.insert(sobjList);
               // SyncInvoicesFuture(Doc.Id);
                syncwithEBS(financeDocs);
                List<Id> srIds=new List<Id>(); 
                Map<String, Id> mapFinanceDocs = new Map<String, Id>();
                
                List<ET_Finance_Document_LineItem__c> lstFinanaceDocsLineItems = [Select Id,Name,ET_Finance_Document__c,ET_Coordinator__c,ET_Coordinator__r.Name,School_Name__c FROM ET_Finance_Document_LineItem__c WHERE Id IN:lstInvoiceLineItems]; // Added School_Name__c-- Sreelakshmi SK 10/4/2023
                for(ET_Finance_Document_LineItem__c finDocLineItem : lstFinanaceDocsLineItems){
                    system.debug('finDocLineItem.School_Name__c: '+finDocLineItem.School_Name__c);
                    system.debug('finDocLineItem.ET_Finance_Document__c: '+finDocLineItem.ET_Finance_Document__c);
                    //mapFinanceDocs.put(finDocLineItem.ET_Coordinator__c,finDocLineItem.ET_Finance_Document__c);
                    //mapFinanceDocs.put(finDocLineItem.school__c,finDocLineItem.ET_Finance_Document__c); // Added by Sreelakshmi SK 6/4/2023
                    mapFinanceDocs.put(finDocLineItem.School_Name__c,finDocLineItem.ET_Finance_Document__c);
                    System.debug('mapFinanceDocs inside loop: '+mapFinanceDocs);
                    //finDocLineItem.school__c
                   
                }
                System.debug('invList in loop: '+ invList);
                System.debug('mapFinanceDocs '+mapFinanceDocs);
                for(ET_Receipt__c invoice:invList){
                    system.debug('Entering for(ET_Receipt__c invoice:invList) loop');
                    srIds.add(invoice.ET_Service_Request__c);
                    //invoice.ET_Finance_Document__c= mapFinanceDocs.get(invoice.ET_Coordinator__c); //invoice.ET_Service_Request__r.ETST_Student__r.ETST_School__c
                    //invoice.ET_Finance_Document__c= mapFinanceDocs.get(invoice.ET_Service_Request__r.ETST_Student__r.ETST_School__c); // Added by Sreelakshmi SK 6/4/2023
                    invoice.ET_Finance_Document__c= mapFinanceDocs.get(invoice.ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c); // Added by Sreelakshmi SK 6/4/2023
                    System.debug('invoice.ET_Finance_Document__c: '+invoice.ET_Finance_Document__c);
                    updateInvoices.add(invoice);
                }
                update updateInvoices;
                /*if(updateInvoices.size()>0){
submitForApproval(doc);
}*/				
              /*  for(ET_Service_Request__c sr:[select id,etst_status__c from ET_Service_Request__c
                                              where id IN :srIds]){
                                                  sr.etst_status__c='Payment success';
                                                  updateSRs.add(sr);
                                              }
                System.debug('updateSRs '+updateSRs);
                update updateSRs;*/
            }
        }catch(Exception e){
            System.debug('Exception'+e.getMessage());
        }
    }
    
    public class Wrapper{
        public String key;
        public List<InvoiceWrapper> value;
    }
    
    @future(callout=true)
    public static void SyncInvoicesFuture(Id finDocId){
        ET_SOA_Services.syncInvoicesToEBS(finDocId);
    }
    @TestVisible
    public class InvoiceWrapper{
        @TestVisible String coordinatorName;
        @TestVisible String totalAmount;
        @TestVisible String invCount;
        @TestVisible String coordinator;
        @TestVisible String customerOracleId;
        @TestVisible String accountNumber;
        @TestVisible String SchoolName;
        @TestVisible String schoolId; // Added by Sreelakshmi SK 6/4/2023
        @TestVisible String serviceSchoolName; // Added by Sreelakshmi SK 6/4/2023
    }  
    public static void submitForApproval(ET_Finance_Document__c doc){
        System.debug('docId '+ doc.id);
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();          
        req.setObjectId(doc.id);
        Approval.ProcessResult result = Approval.process(req);        
    } 
    
    /********************************************************************************************************
* @author       Smaartt
* @description  Method to sync finance document with EBS.
* @param        List<ET_Finance_Document__c> docList
* @return       void
*********************************************************************************************************/
    public static void syncwithEBS(List<ET_Finance_Document__c> docList){
        //Variable declaration.
        List<ET_Service_Request__c> updateSRs=new List<ET_Service_Request__c>();
        List<id> srIds=new List<Id>();
        Set<Id> finDocIds = new Set<Id>();
        //Itrate over list of finance document and invoke integration.As webservice is not bulkified calling from for loop.
        for(ET_Finance_Document__c finDoc:docList){
            SyncInvoicesFuture(finDoc.Id);
            finDocIds.add(finDoc.Id);
        }
        
        //Loop over invoices and populate service request Ids.
        for(Invoice__c inv: [select id,Service_Request__c
                             from Invoice__c where ET_Doc_Id__c IN:finDocIds]){
                                 srIds.add(inv.Service_Request__c); 
                             }            
        
        //Itrate over service request and populate list of SR's to update.
        for(ET_Service_Request__c sr:[select id,etst_status__c from ET_Service_Request__c
                                      where id IN :srIds AND etst_status__c!= :System.Label.ETST_Payment_success]){
                                          sr.etst_status__c=System.Label.ETST_Payment_success;//'Payment success';
                                          updateSRs.add(sr);
                                      }
        System.debug('updateSRs '+updateSRs);
        try{
            update updateSRs;
        }catch(Exception e){
            System.debug('Exception'+e.getMessage());
        }
        
    }
}