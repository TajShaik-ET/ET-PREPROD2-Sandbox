/************************************************************************************************************************
 * Name               : ET_SpeaReconciliationControllerBatch                                                            *
 * Test Class		  : ET_SpeaReconciliationControllerBatchTest                                                        *
 * Description        : Apex Class for automate SPEA Reconciliation                                                     *
 * Created Date       : 22/Apr/2024                                                                                     *
 * Created By         : Taj Shaik(SMAARTT)                                                                              *
 * -----------------------------------------------------------------------------------------------                      *
 * VERSION   AUTHOR      DATE                COMMENTS                                                                   *
 * 1.0       Taj Shaik   22/Apr/2024         Initial Draft.                                                             *
 ***********************************************************************************************************************/
global class ET_SpeaReconciliationControllerBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    global Datetime givenDateTime;
    global List<ET_Receipt__c> receiptListAll;
    global List<ET_Finance_Document__c> financeDocsAll;
    global List<ET_Finance_Document_LineItem__c> financeDocLinesAll;
    global ET_Invoice_Header__mdt invHeader;
    global ET_Invoice_Lines__mdt lineItemmdt;
    global ET_SpeaReconciliationControllerBatch(){
        System.debug('givenDateTime: '+givenDateTime);
        receiptListAll = New List<ET_Receipt__c>();
        financeDocsAll = new List<ET_Finance_Document__c>();
        financeDocLinesAll = new List<ET_Finance_Document_LineItem__c>();
        invHeader = [SELECT MasterLabel,developerName,ET_BatchSource__c,ET_BillToCustomerNumber__c,ET_Comments__c,ET_CustTrxType__c,ET_PaymentMethod__c,ET_TransactionCurrency__c FROM ET_Invoice_Header__mdt WHERE developerName = 'SPEA_Invoice' LIMIT 1];
        lineItemmdt = [SELECT DeveloperName,ET_LineType__c,ET_Tax_Code__c,ET_Tax_Rate__c,ET_Tax_Amount__c,ET_Department__c,ET_Project__c,ET_ServiceType__c FROM ET_Invoice_Lines__mdt WHERE DeveloperName = 'SPEA_INSPECTION_FEE' LIMIT 1];
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Datetime outputDateTimeStart;
        Datetime outputDateTimeEnd;
        if (givenDateTime != null) {
            outputDateTimeStart = givenDateTime;
            outputDateTimeEnd = givenDateTime.addHours(24).addSeconds(-1);
            System.debug('outputDateTimeStart: ' + outputDateTimeStart);
            System.debug('outputDateTimeEnd: ' + outputDateTimeEnd);
        }
        String speaLocation = 'Sharjah Spea Inspection Centre';
        String paymentStatus = 'Payment Success;Refund Requested';
        List<String> paymentStatusList = paymentStatus.split(';');
        String paymentState = 'CAPTURED';
        String query = 'SELECT Id,Name, ' +
            'ETST_Payment_State__c,ETST_Amount__c,ETST_Payment_Mode__c,ETST_Refund_State__c,ETST_Capture_State__c,ETST_Cardholder_Name__c, ' +
            'ETST_AuthorizationCode__c,ETS_Cheque_Issued_Date__c,ETS_Cheque_Expiry_Date__c,ET_Service_Request__c,CreatedDate, ' +
            'RecordType.DeveloperName,ET_Service_Request__r.Name,ET_Service_Request__r.Payment_Status__c,ET_Service_Request__r.ET_Location__r.Name, '+
            '(SELECT Id FROM Receipts__r) '+
            'FROM ETST_Payment__c ';
        query += 'WHERE ETST_AuthorizationCode__c != null AND ETST_Payment_State__c =: paymentState AND ET_Service_Request__c != null AND ET_Service_Request__r.Payment_Status__c IN: paymentStatusList AND ET_Service_Request__r.ET_Location__r.Name =: speaLocation ';
        if (outputDateTimeStart != null) {
            query += 'AND CreatedDate >= :outputDateTimeStart ';
        }
        if (outputDateTimeEnd != null) {
            query += 'AND CreatedDate <= :outputDateTimeEnd ';
        }
        query += 'ORDER BY LastModifiedDate DESC';
        System.debug('query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ETST_Payment__c> paymentList){
        System.debug('paymentList Size: '+paymentList.Size());
        List<ET_Finance_Document__c> financeDocs = new List<ET_Finance_Document__c>();
        List<ET_Finance_Document_LineItem__c> financeDocLines = new List<ET_Finance_Document_LineItem__c>();
        Map<String, String> mapOfFinDocAndFinDocItem = new Map<String, String>();
        paymentWrapper paymentWrp = getPaymentDetails(paymentList,lineItemmdt.ET_LineType__c);
        if(paymentWrp.receiptList.Size()>0){
            ET_Finance_Document__c doc = new ET_Finance_Document__c();
            doc.ET_Location__c = 'Al Ramool'; 
            doc.ET_Activity__c = 'Government School Center'; 
            doc.ET_Transaction_Type__c = 'Online'; 
            doc.ET_Prepared_By__c = userInfo.getUserId();
            doc.ET_Status__c = 'Confirmed';
            doc.ET_Approved_By__c = userInfo.getUserId();
            doc.ET_Prepared_Date__c = System.now();
            doc.ET_Approved_Date__c = givenDateTime;
            doc.ET_Validated_Date__c = givenDateTime.addDays(1);
            doc.ET_Batch_Source__c = invHeader.ET_BatchSource__c; 
            doc.ET_Bill_To_Customer__c = invHeader.ET_BillToCustomerNumber__c; 
            doc.ET_Customer_Oracle_Number__c = '21106205';
            doc.ET_Payment_Mode__c = invHeader.ET_PaymentMethod__c;
            datetime dt= system.now();
            String dtcombination=dt.format('yyyyMMddhmmss');
            doc.Name_Bill_to_Customer__c = invHeader.ET_BillToCustomerNumber__c+'-'+dtcombination;
            mapOfFinDocAndFinDocItem.put(invHeader.ET_BillToCustomerNumber__c, doc.Name_Bill_to_Customer__c);
            financeDocs.add(doc);
            
            ET_Finance_Document_LineItem__c lineItem = new ET_Finance_Document_LineItem__c();
            lineItem.ET_Service_Type__c = lineItemmdt.ET_ServiceType__c;
            Decimal percentageAmount = Decimal.valueOf(lineItemmdt.ET_Tax_Rate__c)/100;
            lineItem.ET_Tax_Amount__c = paymentWrp.totalAmt*percentageAmount;
            lineItem.ET_Tax_Code__c = lineItemmdt.ET_Tax_Code__c;
            lineItem.ET_Tax_Rate__c = lineItemmdt.ET_Tax_Rate__c; 
            //lineItem.School_Name__c=String.valueOf(ag.get('serviceSchoolName')); //invWrap.serviceSchoolName;
            lineItem.ET_Department__c = lineItemmdt.ET_Department__c;
            lineItem.ET_Activity_Center__c = '112001'; 
            lineItem.ET_Location__c = '311001'; 
            //lineItem.ET_Coordinator__c = String.valueOf(ag.get('coordinator')); //invWrap.coordinator;
            if(mapOfFinDocAndFinDocItem.containsKey(invHeader.ET_BillToCustomerNumber__c)){
                ET_Finance_Document__c conReference = new ET_Finance_Document__c(Name_Bill_to_Customer__c = mapOfFinDocAndFinDocItem.get(invHeader.ET_BillToCustomerNumber__c)); 
                lineItem.ET_Finance_Document__r = conReference; 
            }   
            lineItem.ET_Line_Type__c = lineItemmdt.ET_LineType__c;
            lineItem.ET_Amount__c = paymentWrp.totalAmt; 
            lineItem.ET_Invoice_Count__c = paymentWrp.bookingsCount; 
            lineItem.ET_Project__c = lineItemmdt.ET_Project__c;
            financeDocLines.add(lineItem);
            
            receiptListAll.addAll(paymentWrp.receiptList);
            if(!financeDocs.isEmpty() && !financeDocLines.isEmpty()){
                financeDocsAll.addAll(financeDocs);
                financeDocLinesAll.addAll(financeDocLines);
            }    
        }
        //System.debug('financeDocsAll Size: '+financeDocsAll.size());
        //System.debug('financeDocLinesAll Size: '+financeDocLinesAll.size());
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
        List<ET_Receipt__c>  updateReceipts = New List<ET_Receipt__c>();
        try{
            for(ET_Receipt__c receipt: receiptListAll){
                receipt.ET_Finance_Document__c = financeDocsAll[0].Id;
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
    
    public static paymentWrapper getPaymentDetails(List<ETST_Payment__c> paymentList,String payableTypes) {
        paymentWrapper paymentWrp = New paymentWrapper();
        List<ET_Receipt__c> receiptList = New List<ET_Receipt__c>();
        Map<String,ETST_Payment__c> authcodeMap = New Map<String,ETST_Payment__c>();
        Map<String,srBkgWrapper> srNewBkgCountMap = New Map<String,srBkgWrapper>();
        Map<String,srBkgWrapper> srReTestBkgCountMap = New Map<String,srBkgWrapper>();
        Decimal totalAmt = 0;
        Set<Id> srIds = New Set<Id>();
        for(ETST_Payment__c paymentRec: paymentList){
            System.debug('Receipts__r Size: '+paymentRec.Receipts__r.Size());
            if(paymentRec.Receipts__r.Size() == 0){
                totalAmt = totalAmt+paymentRec.ETST_Amount__c;
                //System.debug(paymentRec.Id+' - '+paymentRec.CreatedDate+' - '+paymentRec.ETST_AuthorizationCode__c+' - '+paymentRec.ETST_Amount__c);
                if(!authcodeMap.containsKey(paymentRec.ETST_AuthorizationCode__c))
                    authcodeMap.put(paymentRec.ETST_AuthorizationCode__c,paymentRec);
                srIds.add(paymentRec.ET_Service_Request__c);
            }
        }
        System.debug('authcodeMap Size: '+authcodeMap.Size());
        System.debug('srIds Size: '+srIds.Size());
        System.debug('totalAmt: '+totalAmt);
        if(srIds.Size()>0){
            for(ET_Service_Request__c srRec: [SELECT Id,Name,Payment_Status__c,CreatedDate,Total_Amount__c,(SELECT Id,Payment_Status__c,Booking_Status__c,Total_Amount__c,Total_Fee__c,Total_Tax__c,Service_Type__c FROM Bookings__r WHERE Payment_Status__c = 'Payment Success' AND Booking_Status__c NOT IN ('Draft','Cancelled') AND Total_Amount__c > 0 AND Service_Type__c = 'SPEA Inspection') FROM ET_Service_Request__c WHERE Id IN: srIds]){
                System.debug('Bookings__r Size: '+srRec.Bookings__r.Size());
                if(srRec.Bookings__r.Size() > 0){
                    for(ETI_Booking__c bkg: srRec.Bookings__r){
                        if(bkg.Total_Amount__c >= 2887){
                            srBkgWrapper srBkgWrp = New srBkgWrapper();
                            if(!srNewBkgCountMap.containsKey(srRec.Id)){
                                srBkgWrp.bookingsCount = 1;
                                srBkgWrp.totalAmt = bkg.Total_Amount__c;
                                srBkgWrp.srRec = srRec;
                                srBkgWrp.bookingList = New List<ETI_Booking__c>{bkg};
                                    srNewBkgCountMap.put(srRec.Id,srBkgWrp);
                            }
                            else{
                                srBkgWrp.bookingsCount = srNewBkgCountMap.get(srRec.Id).bookingsCount+1;
                                srBkgWrp.totalAmt = srNewBkgCountMap.get(srRec.Id).totalAmt+bkg.Total_Amount__c;
                                srBkgWrp.srRec = srRec;
                                if(srNewBkgCountMap.get(srRec.Id).bookingList.Size()>0)
                                    srBkgWrp.bookingList.addAll(srNewBkgCountMap.get(srRec.Id).bookingList);
                                srBkgWrp.bookingList.add(bkg);
                                srNewBkgCountMap.put(srRec.Id,srBkgWrp);
                            }
                        }else if(bkg.Total_Amount__c >= 262 && bkg.Total_Amount__c < 2887){
                            srBkgWrapper srBkgWrp = New srBkgWrapper();
                            if(!srReTestBkgCountMap.containsKey(srRec.Id)){
                                srBkgWrp.bookingsCount = 1;
                                srBkgWrp.totalAmt = bkg.Total_Amount__c;
                                srBkgWrp.srRec = srRec;
                                srBkgWrp.bookingList = New List<ETI_Booking__c>{bkg};
                                    srReTestBkgCountMap.put(srRec.Id,srBkgWrp);
                            }
                            else{
                                srBkgWrp.bookingsCount = srReTestBkgCountMap.get(srRec.Id).bookingsCount+1;
                                srBkgWrp.totalAmt = srReTestBkgCountMap.get(srRec.Id).totalAmt+bkg.Total_Amount__c;
                                srBkgWrp.srRec = srRec;
                                if(srReTestBkgCountMap.get(srRec.Id).bookingList.Size()>0)
                                    srBkgWrp.bookingList.addAll(srReTestBkgCountMap.get(srRec.Id).bookingList);
                                srBkgWrp.bookingList.add(bkg);
                                srReTestBkgCountMap.put(srRec.Id,srBkgWrp);
                            }
                        }
                    }
                }
            }
        }
        System.debug('srNewBkgCountMap Size: '+srNewBkgCountMap.Size());
        System.debug('srReTestBkgCountMap Size: '+srReTestBkgCountMap.Size());
        Integer bookingsCount = 0;
        Id ET_SPEA = Schema.SObjectType.ET_Receipt__c.getRecordTypeInfosByDeveloperName().get('ET_SPEA').getRecordTypeId();
        System.debug('ET_SPEA: '+ET_SPEA);
        if(authcodeMap.Size()>0){
            for(String authcode: authcodeMap.KeySet()){
                for(String payableType: payableTypes.Split(';')){
                    //System.debug('payableType: '+payableType);
                    ET_Receipt__c recpt = New ET_Receipt__c();
                    recpt.ET_Service_Request__c = authcodeMap.get(authcode).ET_Service_Request__c;
                    recpt.Payment_Mode__c = 'Online';
                    recpt.recordtypeId = ET_SPEA; 
                    recpt.Payable_Type__c = payableType;
                    Id srId = authcodeMap.get(authcode).ET_Service_Request__c;
                    if(srNewBkgCountMap.Size() > 0){ 
                        if(srNewBkgCountMap.containsKey(srId)){
                            srBkgWrapper srBkgWrp = srNewBkgCountMap.get(srId);
                            if(payableType == 'ET'){
                                bookingsCount = bookingsCount+srBkgWrp.bookingsCount;
                                recpt.ET_Amount__c = 2612.50*srBkgWrp.bookingsCount; 
                            }
                            if(payableType == 'SPEA')
                                recpt.ET_Amount__c = 137.50*srBkgWrp.bookingsCount;
                        }
                    }
                    if(srReTestBkgCountMap.Size() > 0){ 
                        if(srReTestBkgCountMap.containsKey(srId)){
                            srBkgWrapper srBkgWrp = srReTestBkgCountMap.get(srId);
                            if(payableType == 'ET'){
                                bookingsCount = bookingsCount+srBkgWrp.bookingsCount;
                                recpt.ET_Amount__c = 250*srBkgWrp.bookingsCount; 
                            }
                            if(payableType == 'SPEA')
                                recpt.ET_Amount__c = 0;
                        }
                    }
                    recpt.ET_Payment__c = authcodeMap.get(authcode).Id;
                    //System.debug('recpt: '+recpt);
                    receiptList.add(recpt);
                }
            }
        }
        if(receiptList.Size()>0) 
            Insert receiptList;  
        System.debug('receiptList Size: '+receiptList.Size());
        paymentWrp.bookingsCount = bookingsCount;
        paymentWrp.totalAmt = totalAmt;
        paymentWrp.receiptList = receiptList;
        System.debug('paymentWrp: '+paymentWrp);
        return paymentWrp;
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
            sr.etst_status__c = System.Label.ETST_Payment_success; //'Payment success';
            updateSRs.add(sr);
        }
        System.debug('updateSRs Size '+updateSRs.Size());
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
        finCalloutBatch.invoiceType = 'SPEA_Invoice';
        finCalloutBatch.recIds = finDocIds; 
        Id batchJobId = Database.executeBatch(finCalloutBatch,1);
    }
    
    /*public static void justToDelete(){  
        //Running Batch
        ET_SpeaReconciliationControllerBatch speaBatch = New ET_SpeaReconciliationControllerBatch();
        speaBatch.givenDateTime = System.today().addDays(-1);
        Id batchJobId = Database.executeBatch(speaBatch,2000);
        //Running Query
        DateTime givenDateTimeGmt = System.today().addDays(-9);
        Datetime outputDateTimeStart;
        Datetime outputDateTimeEnd;
        if (givenDateTimeGmt != null) {
            outputDateTimeStart = givenDateTimeGmt;
            outputDateTimeEnd = givenDateTimeGmt.addHours(24).addSeconds(-1);
            System.debug('outputDateTimeStart: ' + outputDateTimeStart);
            System.debug('outputDateTimeEnd: ' + outputDateTimeEnd);
        }
        String speaLocation = 'Sharjah Spea Inspection Centre';
        String paymentStatus = 'Payment Success;Refund Requested';
        List<String> paymentStatusList = paymentStatus.split(';');
        String paymentState = 'CAPTURED';
        String query = 'SELECT Id,Name, ' +
            'ETST_Payment_State__c,ETST_Amount__c,ETST_Payment_Mode__c,ETST_Refund_State__c,ETST_Capture_State__c,ETST_Cardholder_Name__c, ' +
            'ETST_AuthorizationCode__c,ETS_Cheque_Issued_Date__c,ETS_Cheque_Expiry_Date__c,ET_Service_Request__c,CreatedDate, ' +
            'RecordType.DeveloperName,ET_Service_Request__r.Name,ET_Service_Request__r.Payment_Status__c,ET_Service_Request__r.ET_Location__r.Name, '+
            '(SELECT Id FROM Receipts__r) '+
            'FROM ETST_Payment__c ';
        query += 'WHERE ETST_AuthorizationCode__c != null AND ETST_Payment_State__c =: paymentState AND ET_Service_Request__c != null AND ET_Service_Request__r.Payment_Status__c IN: paymentStatusList AND ET_Service_Request__r.ET_Location__r.Name =: speaLocation ';
        if (outputDateTimeStart != null) {
            query += ' AND CreatedDate >= :outputDateTimeStart';
        }
        if (outputDateTimeEnd != null) {
            query += ' AND CreatedDate <= :outputDateTimeEnd';
        }
        query += 'ORDER BY LastModifiedDate DESC LIMIT 3';
        System.debug('query ' + query);
        List<ETST_Payment__c> paymentList = Database.query(query);
        System.debug('Size: '+paymentList.Size());        
        for(ETST_Payment__c rec: paymentList){
            System.debug('Receipts__r Size: '+rec.Receipts__r.Size());
            System.debug(rec.Id+' - '+rec.Name+' - '+rec.CreatedDate+' - '+rec.ETST_AuthorizationCode__c+' - '+rec.ETST_Amount__c);
        }
        ET_SpeaReconciliationControllerBatch.paymentWrapper paymentWrp = ET_SpeaReconciliationControllerBatch.getPaymentDetails(paymentList,'ET;SPEA');
        system.debug('paymentWrp.bookingsCount: '+paymentWrp.bookingsCount);
        system.debug('paymentWrp.totalAmt: '+paymentWrp.totalAmt);
        system.debug('paymentWrp.receiptList: '+paymentWrp.receiptList.Size());
        if(paymentWrp.receiptList.Size()>0){
            for(ET_Receipt__c recpt : paymentWrp.receiptList){
                system.debug('recpt: '+recpt);
            }
        }
    }*/
    
    global Class paymentWrapper{
        global Integer bookingsCount;
        global Decimal totalAmt;
        global List<ET_Receipt__c> receiptList;
        global paymentWrapper(){
            receiptList = New List<ET_Receipt__c>();
        }
    }
    
    global Class srBkgWrapper{
        global Integer bookingsCount;
        global Decimal totalAmt;
        global ET_Service_Request__c srRec;
        global List<ETI_Booking__c> bookingList;
        global srBkgWrapper(){
            srRec = New ET_Service_Request__c();
            bookingList = New List<ETI_Booking__c>();
        }
    }
}