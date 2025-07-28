/***********************************************************************************************************************
* Name               : ETI_InspectionReceiptCtrl                                                                       *
* Test Class         : ETI_InspectionReceiptCtrl_Test                                                                  *
* Description        : Apex Class to fetch Aman receipt and update in Salesforce                                       *
* Created Date       : 06/Sep/2023                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   06/Sep/2023         Initial Draft.                                                             *
* 1.1       Taj Shaik   20/Sep/2024         Sync Test Results to Aman
* 1.2		Asif Tayyab 17/Feb/2024			Aproval Process and Print Integration
***********************************************************************************************************************/
public without sharing class ETI_InspectionReceiptCtrl{
    
    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getRoleAndProfile(Id userId) {
        // Fetch Role and Profile information
        User userRecord = [SELECT UserRole.Name, Profile.Name FROM User WHERE Id = :userId];
        
        Map<String, String> userInfo = new Map<String, String>();
        userInfo.put('Role', userRecord.UserRole != null ? userRecord.UserRole.Name : 'No Role Assigned');
        userInfo.put('Profile', userRecord.Profile.Name);
        system.debug('userInfo>>>>>>'+ userInfo);
        return userInfo;
    }

    @AuraEnabled(cacheable=true)
    public static List<ETI_Aman_Lookup__c> getActiveAmanLocations() {
        return [
            SELECT Id, Name 
            FROM ETI_Aman_Lookup__c 
            WHERE IsActive__c = true AND ETI_LookupType__c = 'AMAN_LOCATION'
            ORDER BY Name
        ];
    }

    @AuraEnabled
    public static List<String> getPendingReceipts(String locName) {
        System.debug('locName >>> ' + locName);
        List<String> pendingReceipts = new List<String>();
        
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('amanPendingReceipts');
        Blob beforeblob = Blob.valueOf(connection.Username__c + ':' + connection.Password__c);
        String paramvalue = EncodingUtil.base64Encode(beforeblob);
        
        HttpRequest request = new HttpRequest();
        if (ET_REST_Authorize_Helper.runningInASandbox()) {
            request.setEndpoint(connection.Dev_Endpoint__c + '?locName=' + locName);
        } else {
            request.setEndpoint(connection.LiveEndpoint_c__c + '?locName=' + locName);
        }
        request.setMethod('GET');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic ' + paramvalue);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('response Body >>> ' + response.getBody());
        
        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            if (jsonResponse.containsKey('receipts')) {
                List<Object> receiptsObj = (List<Object>) jsonResponse.get('receipts');
                for (Object obj : receiptsObj) {
                    pendingReceipts.add((String) obj);
                }
            }
            System.debug('pendingReceipts size >>> ' + pendingReceipts.size());
        }
        
        return pendingReceipts;
    }

    @auraEnabled
    public static String searchInspectionReceipt(String searchStr, String inspObsrFields){
        responseWrapper respWrp = New responseWrapper();
        List<ETI_Inspection_Receipt__c> inspRecptList = New List<ETI_Inspection_Receipt__c>();
        List<ETI_Booking__c> bookingList = New List<ETI_Booking__c>();
        List<ETI_Inspection_Observation__c> inspObsrList = New List<ETI_Inspection_Observation__c>();
        Boolean createInspObsr = false;
        String ReceiptNo = '';
        //System.debug('inspObsrFields: ' + inspObsrFields);
        if (searchStr != null && searchStr != '' && inspObsrFields != null){
            if (searchStr.startsWithIgnoreCase('B-')){
                String queryStr = 'SELECT Id,ET_Location__r.Name,ET_Location__r.Arabic_Name__c,(SELECT Id,AMAN_Receipt_No__c FROM Receipts__r LIMIT 1) FROM ETI_Booking__c WHERE Name =: searchStr LIMIT 1';
                bookingList = Database.query(queryStr);
                if (bookingList.size() > 0){
                    /*if (!String.isBlank(bookingList[0]?.ET_Location__r?.Name)){
respWrp.receiptWrp.ReceiptDetails.Location.EN = bookingList[0]?.ET_Location__r?.Name;
}
if (!String.isBlank(bookingList[0]?.ET_Location__r?.Arabic_Name__c)){
respWrp.receiptWrp.ReceiptDetails.Location.AR = bookingList[0]?.ET_Location__r?.Arabic_Name__c;
}*/
                    if (bookingList[0]?.Receipts__r.size() > 0){
                        inspRecptList = bookingList[0]?.Receipts__r;
                    }
                } else{
                    respWrp.receiptWrp = null;
                    respWrp.isSuccess = true;
                    respWrp.message = 'Booking Id is not available in CRM';
                }
                if (inspRecptList.size() > 0){
                    if (inspRecptList[0].AMAN_Receipt_No__c == null || inspRecptList[0].AMAN_Receipt_No__c == ''){
                        respWrp.receiptWrp = null;
                        respWrp.isSuccess = true;
                        respWrp.message = 'Aman Receipt Number not available in CRM';
                    } else{
                        inspObsrList = queryInspObsrList(inspRecptList[0]?.AMAN_Receipt_No__c, inspObsrFields, null);
                        createInspObsr = true;
                        respWrp.receiptWrp = getInspectionReceipt(inspRecptList[0]?.AMAN_Receipt_No__c);
                        ReceiptNo = inspRecptList[0]?.AMAN_Receipt_No__c;
                        respWrp.isSuccess = true;
                        respWrp.message = respWrp.receiptWrp.Message;
                        respWrp.inspRecpt = inspRecptList[0];
                    }
                } else{
                    respWrp.receiptWrp = null;
                    respWrp.isSuccess = true;
                    respWrp.message = 'Aman Receipt Number not available in CRM';
                }
            } else{
                respWrp.receiptWrp = getInspectionReceipt(searchStr);
                if (respWrp.receiptWrp.Status == 'S' && respWrp.receiptWrp.Message == 'Inspection Receipt Exists'){
                    String queryStr = 'SELECT Id,AMAN_Receipt_No__c FROM ETI_Inspection_Receipt__c WHERE AMAN_Receipt_No__c =: searchStr LIMIT 1';
                    inspRecptList = Database.query(queryStr);
                    respWrp.isSuccess = true;
                    respWrp.message = respWrp.receiptWrp.Message;
                    if (inspRecptList.size() > 0)
                        respWrp.inspRecpt = inspRecptList[0];
                    inspObsrList = queryInspObsrList(searchStr, inspObsrFields, null);
                    createInspObsr = true;
                } else if (respWrp.receiptWrp.Status == 'E'){
                    respWrp.receiptWrp = null;
                    respWrp.isSuccess = true;
                    respWrp.message = 'Inspection receipt not found in Aman system';
                }
            }
            if (createInspObsr == true && inspObsrList.size() == 0){
                ETI_Inspection_Observation__c inspObsr = New ETI_Inspection_Observation__c();
                if (ReceiptNo != '')
                    inspObsr.AMAN_Receipt_No__c = ReceiptNo;
                else
                    inspObsr.AMAN_Receipt_No__c = searchStr;
                if (inspRecptList.size() > 0)
                    inspObsr.Aman_Receipt__c = inspRecptList[0]?.Id;
                Insert inspObsr;
                inspObsrList.add(inspObsr);
            }
            if (inspObsrList.size() > 0){
                respWrp.inspObsr = inspObsrList[0];
                List<inspectionCode> inspectionCodes = getInspectionCodesSelected(inspObsrList[0]?.Inspection_Codes__r,null);
                if (inspectionCodes != null){
                    for (inspectionCode inspCode : inspectionCodes){
                        if (inspCode.inspType == 'Break Inspection')
                            respWrp.inspCodesNewBreak.add(inspCode);
                        if (inspCode.inspType == 'Visual Inspection')
                            respWrp.inspCodesNewVisual.add(inspCode);
                    }
                }
            }
        }
        return JSON.serialize(respWrp);
    }
    
    @auraEnabled
    public static List<ETI_Inspection_Observation__c> queryInspObsrList(string searchStr, String inspObsrFields, Id inspObsrId){
        String queryStr;
        if (searchStr != null && searchStr != '')
            queryStr = 'SELECT ' + inspObsrFields + ', (SELECT Id,Name,Code__c,Code_Type__c,Inspection_Observation__c,Inspection_Type__c,Remarks__c FROM Inspection_Codes__r) FROM ETI_Inspection_Observation__c WHERE AMAN_Receipt_No__c =: searchStr LIMIT 1';
        else if (inspObsrId != null)
            queryStr = 'SELECT ' + inspObsrFields + ', (SELECT Id,Name,Code__c,Code_Type__c,Inspection_Observation__c,Inspection_Type__c,Remarks__c FROM Inspection_Codes__r) FROM ETI_Inspection_Observation__c WHERE Id =: inspObsrId LIMIT 1';
        return (List<ETI_Inspection_Observation__c>)(database.query(queryStr));
    }
    
    @auraEnabled
    public static ReceiptWrapper getInspectionReceipt(string recpNo){
        System.debug('recpNo >>> ' + recpNo);
        ReceiptWrapper receiptWrp = New ReceiptWrapper();
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('amanReceiptDetails');
        Blob beforeblob = Blob.valueOf(connection.Username__c + ':' + connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        HttpRequest request = new HttpRequest();
        if (ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c + '?ReceiptNo=' + recpNo);
        } else{
            request.setEndpoint(connection.LiveEndpoint_c__c + '?ReceiptNo=' + recpNo);
        }
        request.setMethod('GET');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic ' + paramvalue);
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug('response Body >>> ' + response.getBody());
        if (response.getStatusCode() == 200){
            receiptWrp = (ReceiptWrapper)JSON.deserialize(response.getBody(), ReceiptWrapper.class);
            List<PreviousTestWrapper> Test_No_List = New List<PreviousTestWrapper>();
            List<String> codes = New List<String>();
            if (receiptWrp.Status == 'S' && receiptWrp.Message == 'Inspection Receipt Exists'){
                receiptWrp.inspCodeMap = getInspectionCodes();
                //system.debug('En test : '+receiptWrp.ReceiptDetails.Test_Type.EN);
                if (receiptWrp.ReceiptDetails.Test_No_List != null){
                    Test_No_List = receiptWrp.ReceiptDetails.Test_No_List;
                    if (Test_No_List.size() > 0){
                        for (PreviousTestWrapper test: Test_No_List){
                            codes.add(test.Code.removeStartIgnoreCase('0'));
                        }
                        if (codes.Size() > 0){
                            receiptWrp.inspCodesOld = getInspectionCodesSelected(null, codes);
                        }
                    }
                } 
                receiptWrp.ReceiptDetails.Test_No_List = Test_No_List;
                system.debug('ReceiptDetails >>> ' + receiptWrp.ReceiptDetails);
            }
        }
        return receiptWrp;
    }
    
    @auraEnabled(cacheable = true)
    public static Map<String, inspCodeWrapper> getInspectionCodes(){
        Map<String, inspCodeWrapper> inspCodeMap = New Map<String, inspCodeWrapper>();
        Map<String, ETI_Visual_Defect_Test__c> mapVDT = New Map<String, ETI_Visual_Defect_Test__c>();
        List<ETI_Visual_Defect_Test__c> recVDTList = New List<ETI_Visual_Defect_Test__c>();
        recVDTList = [SELECT Id, Name, Id__c, Ord_No__c, Refer_Id__c, Test_Type_Name_En__c, Prof_Id__c, Type_Level__c, Test_Type_Id__c, Test_Type_Name_Ar__c, Type__c
                      FROM ETI_Visual_Defect_Test__c
                      WHERE Type__c != ''
                      ORDER BY Id__c ASC];
        if (recVDTList.Size() > 0){
            for (ETI_Visual_Defect_Test__c recVDT : recVDTList){
                inspCodeDetailWrapper inspCode = New inspCodeDetailWrapper();
                inspCode.recordVDT = recVDT;
                if (!inspCodeMap.containsKey(recVDT.Type__c)){
                    inspCodeWrapper inspCodeWrp = New inspCodeWrapper();
                    inspCodeWrp.defectCount = 0;
                    inspCodeWrp.inspCodeDetails = New List<inspCodeDetailWrapper>{ inspCode };
                        inspCodeMap.put(recVDT.Type__c, inspCodeWrp);
                } else if (inspCodeMap.containsKey(recVDT.Type__c)){
                    inspCodeMap.get(recVDT.Type__c).inspCodeDetails.add(inspCode);
                }
            }
        }
        //System.debug('inspCodeMap size >>> '+inspCodeMap.size());
        if (inspCodeMap.Size() > 0)
            return inspCodeMap;
        else
            return null;
    }
    
    @auraEnabled(cacheable = true)
    public static List<inspectionCode> getInspectionCodesSelected(List<ETI_Inspection_Codes__c> listInspectionCodes, List<String> codesOldMajor){
        Map<String, ETI_Visual_Defect_Test__c> recVDTMap = New Map<String, ETI_Visual_Defect_Test__c>();
        List<inspectionCode> inspCodes = New List<inspectionCode>();
        Set<String> setCodes = New Set<String>();
        if (listInspectionCodes != null){
            if (listInspectionCodes.Size() > 0){
                for (ETI_Inspection_Codes__c codeRec : listInspectionCodes){
                    setCodes.add(codeRec.Code__c);
                }
            }
        }else if (codesOldMajor != null){
            if (codesOldMajor.Size() > 0){
                for (String code : codesOldMajor){
                    setCodes.add(code);
                }
            }
        }
        if (setCodes.Size() > 0){
            for(ETI_Visual_Defect_Test__c defectRec: [SELECT Id, Name, Id__c, Ord_No__c, Refer_Id__c, Test_Type_Name_En__c, Prof_Id__c, Type_Level__c, Test_Type_Id__c, Test_Type_Name_Ar__c, Type__c
                                                      FROM ETI_Visual_Defect_Test__c
                                                      WHERE Type__c != '' AND Id__c IN: setCodes
                                                      ORDER BY Id__c ASC]){
                                                          recVDTMap.put(defectRec.Id__c,defectRec);
                                                      }
        }
        //System.debug('recVDTMap size >>> '+recVDTMap.size());
        if (listInspectionCodes != null){
            if (listInspectionCodes.Size() > 0){
                for (ETI_Inspection_Codes__c codeRec : listInspectionCodes){
                    inspectionCode inspCode = New inspectionCode();
                    inspCode.code = codeRec.Code__c;
                    inspCode.inspType = codeRec.Inspection_Type__c;
                    inspCode.defect = codeRec.Code_Type__c;
                    inspCode.remarks = codeRec.Remarks__c;
                    if (recVDTMap.containsKey(codeRec.Code__c))
                        inspCode.recVDT = recVDTMap.get(codeRec.Code__c);
                    inspCodes.add(inspCode);
                }
            }
        }else if (codesOldMajor != null){
            if (codesOldMajor.Size() > 0){
                for (String code : codesOldMajor){
                    inspectionCode inspCode = New inspectionCode();
                    inspCode.code = code;
                    inspCode.defect = 'Major';
                    if (recVDTMap.containsKey(code))
                        inspCode.recVDT = recVDTMap.get(code);
                    inspCodes.add(inspCode);
                }
            }
        }
        if (inspCodes.Size() > 0)
            return inspCodes;
        else
            return null;
    }
    
    @auraEnabled
    public static String saveInspectionReceipt(ETI_Inspection_Observation__c inspObsr, String inspObsrFields, String allCodesBreakStr, String allCodesVisualStr){
        //System.debug('inspObsr : '+inspObsr);
        Savepoint sp = Database.setSavepoint();
        List<ETI_Inspection_Observation__c> inspObsrList = New List<ETI_Inspection_Observation__c>();
        List<inspectionCode> allCodesBreak = New List<inspectionCode>();
        List<inspectionCode> allCodesVisual = New List<inspectionCode>();
        
        
        
        if(!String.IsBlank(allCodesBreakStr)){
            allCodesBreak = (List<inspectionCode>)JSON.deserialize(allCodesBreakStr, List<inspectionCode>.class);
        }
        if(!String.IsBlank(allCodesVisualStr)){
            allCodesVisual = (List<inspectionCode>)JSON.deserialize(allCodesVisualStr, List<inspectionCode>.class);
        }
        if (inspObsr != null && inspObsrFields != null){
            try{
                Upsert inspObsr;
                saveInspectionCodes(inspObsr, allCodesBreak, allCodesVisual);
                inspObsrList = queryInspObsrList(null, inspObsrFields, inspObsr.Id);
                system.debug('inspObsr.Submit_for_Approval__c>>>>>>>>' + inspObsr.Submit_for_Approval__c);
                if(inspObsr.Submit_for_Approval__c == true)
                {
                    system.debug('inspObsr.Email_Sent_to_Supervisor__c>>>>>>>>' + inspObsr.Email_Sent_to_Supervisor__c);
                    if(inspObsr.Email_Sent_to_Supervisor__c == false)
                        sendEmailtoSupervisor(inspObsr);
                    
                }
                
                if(inspObsr.Approved__c == true)
                {
                    if(inspObsr.Email_Sent_to_Inspectors__c == false)
                        sendEmailToInpector(inspObsr);
                    
                }
                
                //if (inspObsrList.Size() > 0){
                //sendResultToAman(inspObsrList[0]);
                //}
            } catch (exception ex){
                System.debug('Ex Message: ' + ex.getmessage());
                Database.rollback(sp);
            }
        }
        //System.debug('inspObsrList Size : '+inspObsrList.Size());
        if (inspObsrList.size() > 0)
            return JSON.serialize(inspObsrList[0]);
        else
            return null;
    }
    public static void sendEmailtoSupervisor(ETI_Inspection_Observation__c inspObsr)
    {
        system.debug('sendEmailtoSupervisor>>>>>>>>');
        Map<String, User> userMap = new Map<String, User>();
        if(inspObsr.Approver_Finance_ID__c != null)
        {
            List<User> userList = [SELECT EmployeeNumber, Email FROM User WHERE EmployeeNumber = :inspObsr.Approver_Finance_ID__c limit 1];
            system.debug('userList>>>>>>>>' + userList);
            // Construct the map explicitly with EmployeeNumber as the key
            for (User user : userList) {
                userMap.put(user.EmployeeNumber, user);
            }
            System.debug('userMap>>>>>>>>' + userMap);
        }
        if(inspObsr.Approver_Finance_ID__c != null)
        {
            List<User> userList = [SELECT EmployeeNumber, Email FROM User WHERE EmployeeNumber = :inspObsr.Approver_Finance_ID__c limit 1];
            system.debug('userList>>>>>>>>' + userList);
            // Construct the map explicitly with EmployeeNumber as the key
            for (User user : userList) {
                userMap.put(user.EmployeeNumber, user);
            }
            System.debug('userMap>>>>>>>>' + userMap);
        }
        
        
        system.debug('In if condition Email_Sent_to_Supervisor__c>>>>>>>>>');
        
        if (userMap.containsKey(inspObsr.Approver_Finance_ID__c))
        {
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply@et.ae' limit 1];
            system.debug('In if condition>>>>>>>>>');
            String userEmail = userMap.get(inspObsr.Approver_Finance_ID__c).Email;
            
            // Send email to the user
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { userEmail });
            email.setOrgWideEmailAddressId(owea.get(0).Id);
            email.setSubject('Inspection Approval Request');
            email.setPlainTextBody('Dear User, \n\n Please approve Aman receipt: ' + inspObsr.AMAN_Receipt_No__c);
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                inspObsr.Email_Sent_to_Supervisor__c = true;
                update inspObsr;
                System.debug('Email sent successfully to: ' + email);
            } catch (Exception ex) {
                System.debug('Failed to send email: ' + ex.getMessage());
            }
            
        }
        
        
    }
    public static void sendEmailToInpector(ETI_Inspection_Observation__c inspObsr)
    {
        system.debug('sendEmailToInpector>>>>>>>>');
        String breakInsp = '82639'; //inspObsr.Break_Inspector_Id__c; 
        String visualInsp = '89999';//inspObsr.Visual_Inspector_Id__c;
        // Query user emails
        List<User> users = [SELECT EmployeeNumber, Email FROM User WHERE EmployeeNumber IN:new Set<String>{breakInsp, visualInsp}];
        system.debug('users List Inpector>>>>>>>>' + users);
        Map<String, String> userEmails = new Map<String, String>();
        
        for (User user : users) {
            if (user.Email != null) {
                userEmails.put(user.EmployeeNumber, user.Email);
            }
        }
        
        // Prepare the email addresses
        List<String> emailAddresses = new List<String>();
        if (userEmails.containsKey(breakInsp)) {
            emailAddresses.add(userEmails.get(breakInsp));
        }
        if (userEmails.containsKey(visualInsp)) {
            emailAddresses.add(userEmails.get(visualInsp));
        }
        
        if (emailAddresses.isEmpty()) {
            System.debug('No valid email addresses found for the provided user IDs.');
            return;
        }
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply@et.ae' limit 1];
        // Send the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setOrgWideEmailAddressId(owea.get(0).Id);
        email.setToAddresses(emailAddresses);
        email.setSubject('Approved Notification');
        email.setPlainTextBody('Dear Inspector, \n\n The request is approved of Aman receipt: ' + inspObsr.AMAN_Receipt_No__c);
        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            System.debug('Email sent successfully to: ' + emailAddresses);
            inspObsr.Email_Sent_to_Inspectors__c = true;
            update inspObsr;
        } catch (Exception ex) {
            System.debug('Failed to send email: ' + ex.getMessage());
        }
    }
    
    /*@auraEnabled
    public static void saveInspectionCodes(ETI_Inspection_Observation__c inspObsr, List<inspectionCode> allCodesBreak, List<inspectionCode> allCodesVisual){
        System.debug('allCodesBreak: ' + allCodesBreak);
        List<ETI_Inspection_Codes__c> InspCodes = New List<ETI_Inspection_Codes__c>();
        System.debug('Break count: ' + inspObsr.Break_Inspection_Count__c);
        System.debug('Visual count: ' + inspObsr.Visual_Inspection_Count__c);
        //if(inspObsr.Break_Inspection_Count__c == 0 || inspObsr.Break_Inspection_Count__c == null){
            if(allCodesBreak.Size() > 0){
                for (inspectionCode item : allCodesBreak){
                    ETI_Inspection_Codes__c InspCode = New ETI_Inspection_Codes__c();
                    InspCode.Inspection_Observation__c = inspObsr.Id;
                    InspCode.Inspection_Type__c = 'Break Inspection';
                    InspCode.Code__c = item.code;
                    InspCode.Code_Type__c = item.defect;
                    InspCode.Remarks__c = item.remarks;
                    InspCodes.add(InspCode);
                }
            }
        //}
        if(inspObsr.Visual_Inspection_Count__c == 0 || inspObsr.Visual_Inspection_Count__c == null){
            if(allCodesVisual.Size() > 0){
                for (inspectionCode item : allCodesVisual){
                    ETI_Inspection_Codes__c InspCode = New ETI_Inspection_Codes__c();
                    InspCode.Inspection_Observation__c = inspObsr.Id;
                    InspCode.Inspection_Type__c = 'Visual Inspection';
                    InspCode.Code__c = item.code;
                    InspCode.Code_Type__c = item.defect;
                    InspCode.Remarks__c = item.remarks;
                    InspCodes.add(InspCode);
                }
            }
        }
        if (InspCodes.Size() > 0)
            Insert InspCodes;
    }*/

    @AuraEnabled
    public static void saveInspectionCodes(
        ETI_Inspection_Observation__c inspObsr,
        List<inspectionCode> allCodesBreak,
        List<inspectionCode> allCodesVisual
    ) {
        List<ETI_Inspection_Codes__c> codesToInsert = new List<ETI_Inspection_Codes__c>();
        List<ETI_Inspection_Codes__c> codesToUpdate = new List<ETI_Inspection_Codes__c>();
        List<ETI_Inspection_Codes__c> codesToDelete = new List<ETI_Inspection_Codes__c>();

        Map<String, inspectionCode> breakCodeMap = new Map<String, inspectionCode>();
        if (allCodesBreak != null && allCodesBreak.size() > 0) {
            for (inspectionCode item : allCodesBreak) {
                if (item != null && String.isNotBlank(item.code)) {
                    breakCodeMap.put('Break Inspection::' + item.code, item);
                }
            }
        }

        Map<String, inspectionCode> visualCodeMap = new Map<String, inspectionCode>();
        if (allCodesVisual != null && allCodesVisual.size() > 0) {
            for (inspectionCode item : allCodesVisual) {
                if (item != null && String.isNotBlank(item.code)) {
                    visualCodeMap.put('Visual Inspection::' + item.code, item);
                }
            }
        }

        Map<String, ETI_Inspection_Codes__c> existingCodeMap = new Map<String, ETI_Inspection_Codes__c>();
        if (inspObsr != null && String.isNotBlank(inspObsr.Id)) {
            List<ETI_Inspection_Codes__c> existingCodes = [
                SELECT Id, Code__c, Inspection_Type__c, Code_Type__c, Remarks__c
                FROM ETI_Inspection_Codes__c
                WHERE Inspection_Observation__c = :inspObsr.Id
            ];
            if (existingCodes != null && existingCodes.size() > 0) {
                for (ETI_Inspection_Codes__c code : existingCodes) {
                    if (code != null && String.isNotBlank(code.Code__c) && String.isNotBlank(code.Inspection_Type__c)) {
                        existingCodeMap.put(code.Inspection_Type__c + '::' + code.Code__c, code);
                    }
                }
            }

            // Deletion logic
            Set<String> currentKeys = new Set<String>();
            if (breakCodeMap != null && breakCodeMap.size() > 0) currentKeys.addAll(breakCodeMap.keySet());
            if (visualCodeMap != null && visualCodeMap.size() > 0) currentKeys.addAll(visualCodeMap.keySet());

            if (existingCodeMap != null && existingCodeMap.size() > 0) {
                for (String existingKey : existingCodeMap.keySet()) {
                    if (!currentKeys.contains(existingKey)) {
                        codesToDelete.add(existingCodeMap.get(existingKey));
                    }
                }
            }
        }

        // Inserts and updates (break)
        if (breakCodeMap != null && breakCodeMap.keySet().size() > 0) {
            for (String key : breakCodeMap.keySet()) {
                inspectionCode item = breakCodeMap.get(key);
                if (existingCodeMap.containsKey(key)) {
                    ETI_Inspection_Codes__c existing = existingCodeMap.get(key);
                    Boolean isChanged =
                        existing.Code_Type__c != item.defect ||
                        existing.Remarks__c != item.remarks;
                    if (isChanged) {
                        existing.Code_Type__c = item.defect;
                        existing.Remarks__c = item.remarks;
                        codesToUpdate.add(existing);
                    }
                } else {
                    codesToInsert.add(new ETI_Inspection_Codes__c(
                        Inspection_Observation__c = inspObsr.Id,
                        Inspection_Type__c = item.inspType, //'Break Inspection',
                        Code__c = item.code,
                        Code_Type__c = item.defect,
                        Remarks__c = item.remarks
                    ));
                }
            }
        }

        // Inserts and updates (visual)
        if (visualCodeMap != null && visualCodeMap.keySet().size() > 0) {
            for (String key : visualCodeMap.keySet()) {
                inspectionCode item = visualCodeMap.get(key);
                if (existingCodeMap.containsKey(key)) {
                    ETI_Inspection_Codes__c existing = existingCodeMap.get(key);
                    Boolean isChanged =
                        existing.Code_Type__c != item.defect ||
                        existing.Remarks__c != item.remarks;
                    if (isChanged) {
                        existing.Code_Type__c = item.defect;
                        existing.Remarks__c = item.remarks;
                        codesToUpdate.add(existing);
                    }
                } else {
                    codesToInsert.add(new ETI_Inspection_Codes__c(
                        Inspection_Observation__c = inspObsr.Id,
                        Inspection_Type__c = item.inspType, //'Visual Inspection',
                        Code__c = item.code,
                        Code_Type__c = item.defect,
                        Remarks__c = item.remarks
                    ));
                }
            }
        }

        if (codesToInsert != null && codesToInsert.size() > 0) insert codesToInsert;
        if (codesToUpdate != null && codesToUpdate.size() > 0) update codesToUpdate;
        if (codesToDelete != null && codesToDelete.size() > 0) delete codesToDelete;
    }
    
    @auraEnabled
    public static string IntegrateWithAman(ETI_Inspection_Observation__c inspObsr, String inspObsrFields)
    {
        Savepoint sp = Database.setSavepoint();
        List<ETI_Inspection_Observation__c> inspObsrList = New List<ETI_Inspection_Observation__c>();
        if (inspObsr != null && inspObsrFields != null){
            try{
                Upsert inspObsr;
                inspObsrList = queryInspObsrList(null, inspObsrFields, inspObsr.Id);
                system.debug('inspObsrList Size>>>>>>>>>>>' + inspObsrList.Size());
                if (inspObsrList.Size() > 0){
                    sendResultToAman(inspObsrList[0]);
                }
                else
                {
                    return null;
                }
            }
            catch(exception ex){
                System.debug('Ex Message: ' + ex.getmessage());
                Database.rollback(sp);
            }
        }
        
        if (inspObsrList.size() > 0)
            return JSON.serialize(inspObsrList[0]);
        else
            return null;
    }
    
    
    @auraEnabled
    public static void sendResultToAman(ETI_Inspection_Observation__c inspObsr){
        System.debug('isSyncedToAman__c>>  ' + inspObsr.isSyncedToAman__c + '  Integration_Status__c>> ' + inspObsr.Integration_Status__c + '  Is_Visual_Inspection_Completed__c>> ' + inspObsr.Is_Visual_Inspection_Completed__c);
        if ((!inspObsr.isSyncedToAman__c || String.IsBlank(inspObsr.Integration_Status__c)) && inspObsr.Is_Visual_Inspection_Completed__c){
            AmanSyncWrapper AmanSyncWrp = New AmanSyncWrapper();
            AmanSyncWrp.receiptNum = inspObsr.AMAN_Receipt_No__c;
            AmanSyncWrp.inspectorNumber = inspObsr.Visual_Inspector_Id__c;
            AmanSyncWrp.laneNum = inspObsr.Lane_Number__c;
            AmanSyncWrp.defectMeasured = String.valueOf(inspObsr.Visual_Inspection_Count__c);
            AmanSyncWrp.deletedDefects = '0';
            List<inspectionCode> inspCodeList = New List<inspectionCode>();
            if (inspObsr.Inspection_Codes__r.Size() > 0){
                for (ETI_Inspection_Codes__c inspCodeRec : inspObsr.Inspection_Codes__r){
                    if (inspCodeRec?.Inspection_Type__c == 'Break Inspection'){
                        inspCodeList.add(iterateCodes(inspCodeRec));
                    }
                }
                for (ETI_Inspection_Codes__c inspCodeRec : inspObsr.Inspection_Codes__r){
                    if (inspCodeRec?.Inspection_Type__c == 'Visual Inspection'){
                        inspCodeList.add(iterateCodes(inspCodeRec));
                    }
                }
            }
            AmanSyncWrp.defects = inspCodeList;
            syncInspResultFuture(JSON.serialize(AmanSyncWrp),inspObsr.Id);
        }
    }
    
    @auraEnabled
    public static inspectionCode iterateCodes(ETI_Inspection_Codes__c inspCodeRec){
        inspectionCode inspCode = New inspectionCode();
        inspCode.code = (inspCodeRec?.Code__c.length() < 4) ? '0'+inspCodeRec?.Code__c : inspCodeRec?.Code__c;
        inspCode.remarks = inspCodeRec?.Remarks__c;
        inspCode.result = (inspCodeRec?.Code_Type__c == 'Major') ? '2' : '1';
        return inspCode;
    }
    
    @Future(callout=true)
    public static void syncInspResultFuture(String AmanSyncWrpStr, Id inspObsrId){
        //System.debug('AmanSyncWrpStr >>> '+AmanSyncWrpStr);
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('VisualInspectionResults');
        Blob beforeblob = Blob.valueOf(connection.Username__c + ':' + connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        HttpRequest request = new HttpRequest();
        if (ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c);
        } else{
            request.setEndpoint(connection.LiveEndpoint_c__c);
        }
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic ' + paramvalue);
        request.setBody(AmanSyncWrpStr);
        Http http = new Http();
        HttpResponse response = http.send(request);
        system.debug('response Body >>> ' + response.getBody());
        if (response.getStatusCode() == 200){
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String status = (String) responseMap.get('Status');
            String message = (String) responseMap.get('Message');
            if(inspObsrId != null){
                ETI_Inspection_Observation__c inspObsr = New ETI_Inspection_Observation__c();
                inspObsr.Id = inspObsrId;
                inspObsr.Integration_Message__c = (message.Length() > 250 ? message.substring(0, 250) : message);
                if(status == 'S'){
                    inspObsr.isSyncedToAman__c = true;
                    inspObsr.Integration_Status__c = 'Success';
                }else{
                    inspObsr.isSyncedToAman__c = false;
                    inspObsr.Integration_Status__c = 'Error';
                }
                Upsert inspObsr;
            }
        }
    }
    
    @auraEnabled
    public static Boolean synInspResultsToAman(String inspObsrFields, Id inspObsrId){
        List<ETI_Inspection_Observation__c> inspObsrList = New List<ETI_Inspection_Observation__c>();
        try{
            inspObsrList = queryInspObsrList(null,inspObsrFields,inspObsrId);
            if(inspObsrList.Size()>0){
                sendResultToAman(inspObsrList[0]);
            }
            return true;
        }catch (exception ex){
            System.debug('Ex Message: ' + ex.getmessage());
            throw new AuraHandledException(ex.getmessage());
        }
    }
    
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String recordId){
        ContentVersion cv = createContentVersion(base64, filename);
        ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
        if (cv == null || cdl == null){
            return null;
        }
        return cdl.Id;
    }
    
    private static ContentVersion createContentVersion(String base64, String filename){
        
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try{
            insert cv;
            return cv;
        } catch (DMLException e){
            System.debug(e);
            return null;
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId){
        if (contentVersionId == null || recordId == null){
            return null;
        }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId
                                 FROM ContentVersion
                                 WHERE Id = :contentVersionId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try{
            insert cdl;
            return cdl;
        } catch (DMLException e){
            System.debug(e);
            return null;
        }
    }
    
    @AuraEnabled(cacheable = false)
    public static Map<ID, String> getRelatedFilesByRecordId(String recordId){
        List<ContentDocumentLink> files = New List<ContentDocumentLink>();
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        if (!String.isEmpty(recordId))
            files = [SELECT ContentDocumentId
                     FROM ContentDocumentLink
                     WHERE LinkedEntityId = :recordId];
        List<ID> fileIDs = new List<ID>();
        if (files.Size() > 0){
            for (ContentDocumentLink docLink : files){
                fileIDs.add(docLink.ContentDocumentId);
            }
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title
                                         FROM ContentVersion
                                         WHERE ContentDocumentId IN:fileIDs];
            for (ContentVersion docLink : docs){
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
        }
        //System.debug('mapIdTitle Size: '+mapIdTitle.Size());
        if (mapIdTitle.Size() > 0)
            return mapIdTitle;
        else
            return null;
    }
    
    @AuraEnabled
    public static Boolean deleteFile(String ContentDocId){
        Boolean isSuccess;
        //System.debug('ContentDocId: '+ContentDocId);
        try{
            delete new ContentDocument(
                Id = ContentDocId
            );
            isSuccess = true;
        } catch (Exception e){
            System.debug(e);
            isSuccess = false;
        }
        return isSuccess;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getPicklistValues() {
        
        List<VIC_Supervisor__mdt> metadataRecords = [SELECT Name__c, Finance_Number__c FROM VIC_Supervisor__mdt];
        
        List<Map<String, String>> picklistOptions = new List<Map<String, String>>();
        for (VIC_Supervisor__mdt record : metadataRecords) {
            picklistOptions.add(new Map<String, String>{
                'label' => record.Name__c, 
                    'value' => String.valueOf(record.Finance_Number__c)
                    });
        }
        return picklistOptions;
    }
    
    @auraEnabled
    public static string getPrintResult(string recpNo, string inspNo, Id recordId){ //method is to get the print result from AMAN and save in CRM
        PrintWrapper printWrp = New PrintWrapper();
        ET_Oracle_REST_Endpoints__mdt connection = ET_REST_Authorize_Helper.getSOAPEndpointFromMetadata('amanReceiptPrint');
        Blob beforeblob = Blob.valueOf(connection.Username__c + ':' + connection.Password__c);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        HttpRequest request = new HttpRequest();
        if (ET_REST_Authorize_Helper.runningInASandbox()){
            request.setEndpoint(connection.Dev_Endpoint__c + '?receipt_no=' + recpNo + '&inspector_no=' + inspNo);
        } else{
            request.setEndpoint(connection.LiveEndpoint_c__c + '?receipt_no=' + recpNo + '&inspector_no=' + inspNo);
        }
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic ' + paramvalue);
        Http http = new Http();
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200){
            printWrp = (PrintWrapper)JSON.deserialize(response.getBody(), PrintWrapper.class);
            if (printWrp.Status == 'S' || printWrp.Status == 'E'){
                updatePrintStatus(recordId, printWrp.Status, printWrp.Message);                
            }
        }
        return printWrp.Status;
    }
    
    // Method to update the record with the status and message
    public static void updatePrintStatus(Id recordId, String status, String message) {
        // Example: Let's assume we're updating a custom object called "MyObject__c"
        ETI_Inspection_Observation__c obs = [SELECT Id, Print_Status__c, Print_Message__c FROM ETI_Inspection_Observation__c WHERE Id = :recordId LIMIT 1];
        
        // Update the record with the new status and message
        obs.Print_Status__c = status;
        obs.Print_Message__c = message;
        
        // Save the changes to the record
        try {
            update obs;
        } catch (DMLException e) {
            System.debug('Error while updating the record: ' + e.getMessage());
        }
    }
    
    public class PrintWrapper{
        public String Status;
        public String Message;  
    }
    
    public class ReceiptWrapper{
        public String Status;
        public String Message;
        public ReceiptDetailWrapper ReceiptDetails;
        Map<String, inspCodeWrapper> inspCodeMap;
        public List<inspectionCode> inspCodesOld;
        
    }
    
    public class ReceiptDetailWrapper{
        public LanguageWrapper Location;
        public String Receipt_No;
        public String Receipt_DateTime;
        public String Reference_No;
        public String Pay_type;
        public LanguageWrapper Lane_Type;
        public LanguageWrapper Test_Type;
        public LanguageWrapper Test_Purpose;
        public String Test_Count;
        public String Amount;
        public String Total_Amount;
        public String Cashier;
        public List<PreviousTestWrapper> Test_No_List;
        public String Test_Violation_No_List;
        public VehicleDetailWrapper Vehicle_Details;
        public List<PastInpectionWrapper> Past_Inspection;
        public List<PastCertificateWrapper> Past_Certificate;
    }
    
    public class VehicleDetailWrapper{
        public String Plate_No;
        public LanguageWrapper Plate_Color;
        public LanguageWrapper Plate_Type;
        public LanguageWrapper Plate_Source;
        public LanguageWrapper Vehicle_Make;
        public LanguageWrapper Vehicle_Model;
        public LanguageWrapper Vehicle_Type;
        public LanguageWrapper Vehicle_Kind;
        public LanguageWrapper Vehicle_Color;
        public LanguageWrapper Country;
        public String Model_Year;
        public String Body_Number;
        public String Chassis_No;
        public String Act_Chassis_No;
        public String Engine_No;
        public String Cylinders;
        public String Doors;
        public String Seats;
        public String Axles;
        public String Tires;
        public String Horsepower;
        public LanguageWrapper Weight_Unloaded;
        public LanguageWrapper Weight_Loaded;
        public LanguageWrapper Fuel_Type;
        public LanguageWrapper Gear_Type;
        public LanguageWrapper Steering_Type;
        public String KM_Reading;
    }
    
    public class PastInpectionWrapper{
        public String Receipt_No;
        public String Receipt_DateTime;
        public LanguageWrapper Lane_Type;
        public LanguageWrapper Test_Purpose;
        public String Test_Type;
        public String Test_Result;
        public String ADFCA_Flag;
    }
    
    public class PastCertificateWrapper{
        public String Certificate_No;
        public String Certificate_DateTime;
        public String Certificate_Type;
        public String Certificate_Status;
        public String New_Vehicle_Type;
        public String New_Vehicle_Color;
    }
    
    public class PreviousTestWrapper{
        public String Code;
        public LanguageWrapper Name;
        public String Type;
        public String Defect;
    }
    
    public class LanguageWrapper{
        public String EN;
        public String AR;
    }
    
    public class inspCodeWrapper{
        public List<inspCodeDetailWrapper> inspCodeDetails;
        public Integer defectCount;
    }
    
    public class inspCodeDetailWrapper{
        public ETI_Visual_Defect_Test__c recordVDT;
        public List<optionWrapper> options;
        public String selectedOption;
        public String remarks;
        
        Public inspCodeDetailWrapper(){
            recordVDT = New ETI_Visual_Defect_Test__c();
            options = New List<optionWrapper>{ new optionWrapper('Qualified', 'Qualified'), new optionWrapper('Minor Defect', 'Minor Defect'), new optionWrapper('Major Defect', 'Major Defect') }; //{'Qualified','Minor Defect','Major Defect','Extreme Defect'}
                selectedOption = 'Qualified';
            remarks = '';
        }
        
    }
    
    public class optionWrapper{
        public String label;
        public String value;
        public optionWrapper(String label, String value){
            this.label = label;
            this.value = value;
        }
        
    }
    
    public class responseWrapper{
        public Boolean isSuccess;
        public String message;
        public ReceiptWrapper receiptWrp;
        public ETI_Inspection_Receipt__c inspRecpt;
        public ETI_Inspection_Observation__c inspObsr;
        public List<inspectionCode> inspCodesNewBreak;
        public List<inspectionCode> inspCodesNewVisual;
        
        responseWrapper(){
            isSuccess = false;
            message = '';
            receiptWrp = New ReceiptWrapper();
            inspRecpt = New ETI_Inspection_Receipt__c();
            inspObsr = New ETI_Inspection_Observation__c();
            inspCodesNewBreak = New List<inspectionCode>();
            inspCodesNewVisual = New List<inspectionCode>();
        }
        
    }
    
    public class inspectionCode{
        public String code;
        public String defect;
        public String remarks;
        public String result;
        public String inspType;
        public ETI_Visual_Defect_Test__c recVDT;
        
        public inspectionCode(){
            code = '';
            defect = '';
            remarks = '';
            result = '';
            inspType = '';
            recVDT = New ETI_Visual_Defect_Test__c();
        }
        
    }
    
    public class AmanSyncWrapper{
        public String receiptNum;
        public String inspectorNumber;
        public String laneNum;
        public String defectMeasured;
        public String deletedDefects;
        public List<inspectionCode> defects;
        public AmanSyncWrapper(){
            this.defects = New List<inspectionCode>();
        }
    }
    
}