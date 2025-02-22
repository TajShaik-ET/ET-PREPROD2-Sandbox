/************************************************************************************************************************
* Name               : ET_FinanceControllerBatch                                                                       *
* Test Class		  : ET_FinanceControllerBatchTest                                                                  *
* Description        : Apex Class for automate to publish finance documents                                            *
* Created Date       : 02/Feb/2024                                                                                     *
* Created By         : Taj Shaik(SMAARTT)                                                                              *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   02/Feb/2024         Initial Draft.                                                             *
* 1.1       Taj Shaik   16/Aug/2024         Issue Fix and Enhancement                                                  *
***********************************************************************************************************************/
global class ET_FinanceControllerBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    global Datetime givenDateTime;
    global String paymentType;
    global List<ET_Receipt__c> receiptListAll;
    global List<ET_Receipt__c> updateReceipts;
    global List<ET_Finance_Document__c> financeDocsAll;
    global List<ET_Finance_Document_LineItem__c> financeDocLinesAll;
    global ET_Invoice_Header__mdt invHeader;
    global ET_Invoice_Lines__mdt lineItemmdt;
    global List<ETST_Invoice_Lines_Location__mdt> lstLinesLocation;
    global ETST_Invoice_Lines_Activity__mdt lstLinesActivity;
    global Map<String, ETST_Invoice_Lines_Location__mdt> mapInvoiceLinesLocations;
    global Map<String, ETSALES_Location__c> locCodeMap;
    global Map<String, GL_Activity__c> actCodeMap;
    
    global ET_FinanceControllerBatch(){
        System.debug('givenDateTime: '+givenDateTime);
        receiptListAll = New List<ET_Receipt__c>();
        updateReceipts = New List<ET_Receipt__c>();
        financeDocsAll = new List<ET_Finance_Document__c>();
        financeDocLinesAll = new List<ET_Finance_Document_LineItem__c>();
        lineItemmdt = [SELECT DeveloperName,ET_LineType__c,ET_Tax_Code__c,ET_Tax_Rate__c,ET_Tax_Amount__c,ET_Department__c,ET_Project__c,ET_ServiceType__c FROM ET_Invoice_Lines__mdt WHERE DeveloperName = 'SCHOOL_BUS_FEE' LIMIT 1];
        locCodeMap = New Map<String, ETSALES_Location__c>();
        for(ETSALES_Location__c loc: [select Name,Location_Code__c FROM ETSALES_Location__c]){
            locCodeMap.put(loc.Location_Code__c, loc);
        }
        System.debug('locCodeMap: '+locCodeMap.Size());
        actCodeMap = New Map<String, GL_Activity__c>();
        for(GL_Activity__c act: [select Name,GL_Activity_Code__c FROM GL_Activity__c]){
            actCodeMap.put(act.GL_Activity_Code__c, act);
        }
        System.debug('actCodeMap: '+actCodeMap.Size());
        invHeader=[SELECT developerName,ET_BatchSource__c,ET_BillToCustomerNumber__c,ET_Comments__c,
                   ET_CustTrxType__c,ET_PaymentMethod__c,ET_TransactionCurrency__c 
                   FROM ET_Invoice_Header__mdt WHERE developerName = 'School_Invoice' LIMIT 1];
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String paymentStatus = 'Payment Success';
        Datetime outputDateTimeStart;
        Datetime outputDateTimeEnd;
        if (givenDateTime != null) {
            outputDateTimeStart = givenDateTime;
            outputDateTimeEnd = givenDateTime.addHours(24).addSeconds(-1);
            System.debug('outputDateTimeStart: ' + outputDateTimeStart);
            System.debug('outputDateTimeEnd: ' + outputDateTimeEnd);
        }
        String query = 'SELECT Id, ' +
            'ET_Service_Request__r.ETST_Student__r.ETST_School__c, ' +
            'ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c, ' +
            'Name, ET_Coordinator__r.Name, ET_Coordinator__r.GL_Location_Code__c, ET_Coordinator__r.GL_Activity_Code__c, ET_Amount__c, ' +
            'CreatedDate, Payment_Mode__c, ET_Service_Request__c, ETST_School_Name__c, ' +
            'ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.AccountNumber ' +
            'FROM ET_Receipt__c ' +
            'WHERE ET_Coordinator__c != null ' +
            'AND ET_Finance_Document__c = null';
        if (paymentType == 'Bank Transfer'){
            query += ' AND ET_Service_Request__r.ETST_Status__c =: paymentStatus';
        }
        if (outputDateTimeStart != null) {
            query += ' AND CreatedDate >= :outputDateTimeStart';
        }
        if (outputDateTimeEnd != null) {
            query += ' AND CreatedDate <= :outputDateTimeEnd';
        }
        if (paymentType != null) {
            query += ' AND Payment_Mode__c = :paymentType ORDER BY ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.AccountNumber';
        }
        System.debug('query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ET_Receipt__c> receiptList){
        System.debug('receiptList Size: '+receiptList.size());
        receiptListAll.addAll(receiptList);
        List<ET_Finance_Document__c> financeDocs = new List<ET_Finance_Document__c>();
        List<ET_Finance_Document_LineItem__c> financeDocLines = new List<ET_Finance_Document_LineItem__c>();
        Map<String, String> mapOfFinDocAndFinDocItem = new Map<String, String>();
        Map<String, List<AggregateResult>> aggResultMap = getInvoiceByLoc(receiptList);
        for(String accNumber: aggResultMap.KeySet()){
            for(AggregateResult ag: aggResultMap.get(accNumber)){
                if(!mapOfFinDocAndFinDocItem.containsKey(String.valueOf(ag.get('accountNumber'))+'-'+String.valueOf(ag.get('schoolId'))+'-'+ String.valueOf(ag.get('serviceSchoolName'))+'-'+String.valueOf(ag.get('coordinatorName'))+'-'+String.valueOf(ag.get('totalAmount')))){
                    system.debug('ag accountNumber: '+ag.get('accountNumber'));
                    system.debug('ag: '+ag);
                    ET_Finance_Document__c doc = new ET_Finance_Document__c();
                    //doc.ET_Zone__c=zone; 
                    if(locCodeMap.containsKey(String.valueOf(ag.get('LocationCode'))))
                        doc.ET_Location__c = locCodeMap.get(String.valueOf(ag.get('LocationCode'))).Name; //locCodeMap.get(locationMap.get(wrap.customerOracleId)).Name;
                    if(actCodeMap.containsKey(String.valueOf(ag.get('ActivityCode'))))
                        doc.ET_Activity__c = actCodeMap.get(String.valueOf(ag.get('ActivityCode'))).Name; //'Private School Transportation Center'; //actCodeMap.get(activityMap.get(wrap.customerOracleId)).Name;
                    doc.ET_Transaction_Type__c=paymentType; //type;
                    doc.ET_Prepared_By__c=userInfo.getUserId();
                    doc.ET_Status__c='Confirmed';
                    doc.ET_Approved_By__c=userInfo.getUserId();
                    doc.ET_Prepared_Date__c=System.now();
                    doc.ET_Approved_Date__c = givenDateTime;
                    doc.ET_Validated_Date__c = givenDateTime.addDays(1);
                    doc.ET_Batch_Source__c=invHeader.ET_BatchSource__c;//'CRM-GST';
                    doc.ET_Bill_To_Customer__c=accNumber; //String.valueOf(ag.get('accountNumber')); //wrap.accountNumber;
                    doc.ET_Customer_Oracle_Number__c=String.valueOf(ag.get('customerOracleId')); //wrap.customerOracleId;
                    doc.ET_Payment_Mode__c=invHeader.ET_PaymentMethod__c;//'ON';
                    datetime dt= system.now();
                    String dtcombination=dt.format('yyyyMMddhmmss');
                    doc.Name_Bill_to_Customer__c = String.valueOf(ag.get('accountNumber'))+'-'+String.valueOf(ag.get('schoolId'))+'-'+ String.valueOf(ag.get('serviceSchoolName'))+'-'+String.valueOf(ag.get('coordinatorName'))+'-'+String.valueOf(ag.get('totalAmount'))+'-'+dtcombination;
                    mapOfFinDocAndFinDocItem.put(String.valueOf(ag.get('accountNumber'))+'-'+String.valueOf(ag.get('schoolId'))+'-'+ String.valueOf(ag.get('serviceSchoolName'))+'-'+String.valueOf(ag.get('coordinatorName'))+'-'+String.valueOf(ag.get('totalAmount')), doc.Name_Bill_to_Customer__c);
                    financeDocs.add(doc);
                }
            }
        }
        for(String accNumber: aggResultMap.KeySet()){
            for(AggregateResult ag: aggResultMap.get(accNumber)){
                ET_Finance_Document_LineItem__c lineItem = new ET_Finance_Document_LineItem__c();
                lineItem.ET_Service_Type__c = lineItemmdt.ET_ServiceType__c;
                lineItem.ET_Tax_Amount__c = Integer.ValueOf(lineItemmdt.ET_Tax_Amount__c);
                lineItem.ET_Tax_Code__c = lineItemmdt.ET_Tax_Code__c;
                lineItem.ET_Tax_Rate__c = lineItemmdt.ET_Tax_Rate__c; 
                lineItem.School_Name__c=String.valueOf(ag.get('serviceSchoolName')); //invWrap.serviceSchoolName;
                lineItem.ET_Department__c = lineItemmdt.ET_Department__c;
                lineitem.ET_Activity_Center__c = String.valueOf(ag.get('ActivityCode')); //'113001'; //actCode; //mapInvoiceLinesActivityCenter.get(inv.ET_Activity_Center__c).ETST_Activity_Code__c;
                lineitem.ET_Location__c = String.valueOf(ag.get('LocationCode')); //locCode;
                lineitem.ET_Coordinator__c=String.valueOf(ag.get('coordinator')); //invWrap.coordinator;
                if(mapOfFinDocAndFinDocItem.containsKey(String.valueOf(ag.get('accountNumber'))+'-'+String.valueOf(ag.get('schoolId'))+'-'+ String.valueOf(ag.get('serviceSchoolName'))+'-'+String.valueOf(ag.get('coordinatorName'))+'-'+String.valueOf(ag.get('totalAmount')))){
                    ET_Finance_Document__c conReference = new ET_Finance_Document__c(Name_Bill_to_Customer__c =mapOfFinDocAndFinDocItem.get(String.valueOf(ag.get('accountNumber'))+'-'+String.valueOf(ag.get('schoolId'))+'-'+ String.valueOf(ag.get('serviceSchoolName'))+'-'+String.valueOf(ag.get('coordinatorName'))+'-'+String.valueOf(ag.get('totalAmount')))); 
                    lineItem.ET_Finance_Document__r = conReference; 
                }   
                lineItem.ET_Line_Type__c = lineItemmdt.ET_LineType__c;
                lineItem.ET_Amount__c = Decimal.valueOf(String.valueOf(ag.get('totalAmount'))); //invWrap.totalAmount
                lineItem.ET_Invoice_Count__c = Decimal.valueOf(String.valueOf(ag.get('invCount'))); //invWrap.invCount
                lineItem.ET_Project__c = lineItemmdt.ET_Project__c;
                financeDocLines.add(lineItem);
            }
        }
        if(!financeDocs.isEmpty() && !financeDocLines.isEmpty()){
            financeDocsAll.addAll(financeDocs);
            financeDocLinesAll.addAll(financeDocLines);
        }
        System.debug('financeDocsAll Size: '+financeDocsAll.size());
        System.debug('financeDocLinesAll Size: '+financeDocLinesAll.size());
    }  
    
    global void finish(Database.BatchableContext bc){
        System.debug('finish');
        if(!financeDocsAll.isEmpty() && !financeDocLinesAll.isEmpty()){
            SObject[] sobjList = new List<SObject>();
            sobjList.addAll(financeDocsAll);
            sobjList.addAll(financeDocLinesAll);
            Database.SaveResult[] results = Database.Insert(sobjList);
        }
        System.debug('finish financeDocsAll Size: '+financeDocsAll.size());
        System.debug('finish financeDocLinesAll Size: '+financeDocLinesAll.size());
        try{
            Map<String, Id> mapFinanceDocs = new Map<String, Id>();
            List<ET_Finance_Document_LineItem__c> lstFinanaceDocsLineItems = [Select Id,Name,ET_Finance_Document__c,ET_Finance_Document__r.ET_Bill_To_Customer__c,ET_Coordinator__c,ET_Coordinator__r.Name,School_Name__c FROM ET_Finance_Document_LineItem__c WHERE Id IN: financeDocLinesAll]; 
            for(ET_Finance_Document_LineItem__c finDocLineItem : lstFinanaceDocsLineItems){
                //system.debug('finDocLineItem.ET_Finance_Document__r.ET_Bill_To_Customer__c: '+finDocLineItem.ET_Finance_Document__r.ET_Bill_To_Customer__c);
                //system.debug('finDocLineItem.School_Name__c: '+finDocLineItem.School_Name__c);
                //system.debug('finDocLineItem.ET_Finance_Document__c: '+finDocLineItem.ET_Finance_Document__c);
                mapFinanceDocs.put(finDocLineItem.School_Name__c+'-'+finDocLineItem.ET_Coordinator__r.Name,finDocLineItem.ET_Finance_Document__c);
            }
            System.debug('receiptListAll in loop: '+ receiptListAll.Size());
            System.debug('mapFinanceDocs Size '+mapFinanceDocs.Size());
            //System.debug('mapFinanceDocs '+mapFinanceDocs);
            for(ET_Receipt__c receipt: receiptListAll){
                receipt.ET_Finance_Document__c= mapFinanceDocs.get(receipt.ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c+'-'+receipt.ET_Coordinator__r.Name);
                System.debug('receipt.ET_Finance_Document__c: '+receipt.ET_Finance_Document__c);
                updateReceipts.add(receipt); 
            }
            Update updateReceipts;
            if(!financeDocsAll.isEmpty()){
                updateSrs(financeDocsAll);
                syncwithEBS(financeDocsAll);
            }
        }catch(Exception e){
            System.debug('Exception '+e.getMessage());
        }
    }
    
    public static Map<String, List<AggregateResult>> getInvoiceByLoc(List<ET_Receipt__c> receiptList) {
        String qry = 'SELECT ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.ETSALES_Customer_Account_Id__c customerOracleId,ET_Service_Request__r.ETST_Student__r.ETST_School__c schoolId,ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c serviceSchoolName,ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.AccountNumber accountNumber, ET_Coordinator__c coordinator,ET_Coordinator__r.Name coordinatorName,sum(ET_Amount__c) totalAmount, COUNT(Id) invCount,ET_Service_Request__r.ETST_Student__r.ETST_School_Name__r.Name SchoolName,ET_Coordinator__r.GL_Location_Code__c LocationCode, ET_Coordinator__r.GL_Activity_Code__c ActivityCode  FROM ET_Receipt__c where ET_Coordinator__c!=null AND ET_Finance_Document__c=null AND Id IN: receiptList';
        qry+=' group by ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c,ET_Service_Request__r.ETST_Student__r.ETST_School__c,ET_Coordinator__r.Name,ET_Coordinator__c,ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.ETSALES_Customer_Account_Id__c,ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.AccountNumber,ET_Service_Request__r.ETST_Student__r.ETST_School_Name__r.Name, ET_Coordinator__r.GL_Location_Code__c, ET_Coordinator__r.GL_Activity_Code__c ORDER by ET_Coordinator__r.Name';                                                        
        List<AggregateResult> lstAggregateResult = database.query(qry);
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
        system.debug('mapOfAggregateResult Size***'+mapOfAggregateResult.size());
        //system.debug('mapOfAggregateResult***'+mapOfAggregateResult);
        return mapOfAggregateResult;
    }  
    
    public static void updateSrs(List<ET_Finance_Document__c> docList){
        List<ET_Service_Request__c> updateSRs = new List<ET_Service_Request__c>();
        List<id> srIds = new List<Id>();
        Set<Id> finDocIds = new Set<Id>();
        for(ET_Finance_Document__c finDoc: docList){
            finDocIds.add(finDoc.Id);
        }
        for(Invoice__c inv: [SELECT Id,Service_Request__c FROM Invoice__c WHERE ET_Doc_Id__c IN: finDocIds]){
            srIds.add(inv.Service_Request__c); 
        }   
        //Itrate over service request and populate list of SR's to update.
        for(ET_Service_Request__c sr:[SELECT Id,etst_status__c FROM ET_Service_Request__c WHERE Id IN :srIds AND etst_status__c !=: System.Label.ETST_Payment_success]){
            sr.etst_status__c = System.Label.ETST_Payment_success;//'Payment success';
            updateSRs.add(sr);
        }
        System.debug('updateSRs '+updateSRs);
        try{
            Update updateSRs;
        }catch(Exception e){
            System.debug('Exception'+e.getMessage());
        }
    }
    
    public static void syncwithEBS(List<ET_Finance_Document__c> docList){
        List<Id> finDocIds = New List<Id>();
        for(ET_Finance_Document__c finDoc:docList){
            finDocIds.add(finDoc.Id);
        }
        ET_FinanceControllerCalloutBatch finCalloutBatch = New ET_FinanceControllerCalloutBatch();
        finCalloutBatch.invoiceType = 'School_Invoice';
        finCalloutBatch.recIds = finDocIds; 
        Id batchJobId = Database.executeBatch(finCalloutBatch,1);
    }
    
    /*public static void justToDelete(){  
        //Running Batch
        ET_FinanceControllerBatch finBatch = New ET_FinanceControllerBatch();
        finBatch.givenDateTime = System.today().addDays(-547);
        finBatch.paymentType = 'Online';
        Id batchJobId = Database.executeBatch(finBatch,10000);
        //Running Query
        String paymentType = 'Online';
        DateTime givenDateTimeGmt = System.today().addDays(-9);
        Datetime outputDateTimeStart;
        Datetime outputDateTimeEnd;
        if (givenDateTimeGmt != null) {
            outputDateTimeStart = givenDateTimeGmt;
            outputDateTimeEnd = givenDateTimeGmt.addHours(24).addSeconds(-1);
            System.debug('outputDateTimeStart: ' + outputDateTimeStart);
            System.debug('outputDateTimeEnd: ' + outputDateTimeEnd);
        }
        String query = 'SELECT Id, ' +
            'ET_Service_Request__r.ETST_Student__r.ETST_School__c, ' +
            'ET_Service_Request__r.ETST_Student__r.ETST_School_Name__c, ' +
            'Name, ET_Coordinator__r.Name, ET_Amount__c, ' +
            'CreatedDate, Payment_Mode__c, ET_Service_Request__c, ETST_School_Name__c, ' +
            'ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.AccountNumber ' +
            'FROM ET_Receipt__c ' +
            'WHERE ET_Coordinator__c != null ' +
            'AND ET_Finance_Document__c = null';
        if (outputDateTimeStart != null) {
            query += ' AND CreatedDate >= :outputDateTimeStart';
        }
        if (outputDateTimeEnd != null) {
            query += ' AND CreatedDate <= :outputDateTimeEnd';
        }
        if (paymentType != null) {
            query += ' AND Payment_Mode__c = :paymentType ORDER BY ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.AccountNumber';
        }
        System.debug('query ' + query);
        List<ET_Receipt__c> receiptList = Database.query(query);
        System.debug('Size: '+receiptList.Size());        
        for(ET_Receipt__c rec: receiptList){
            System.debug(rec.CreatedDate+' - '+rec.Name+' - '+rec.ET_Service_Request__r.ETST_Student__r.ETST_School__r.Parent.AccountNumber);
        }
        Map<String, List<AggregateResult>> objMap = ET_FinanceControllerBatch.getInvoiceByLoc(receiptList);
        for(String str : objMap.KeySet()){
            system.debug('str: '+str);
            for(AggregateResult ag: objMap.get(str)){
                system.debug('ag: '+ag);
            }
        }
    }*/
}