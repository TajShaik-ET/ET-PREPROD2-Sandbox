/* Class        : ET_overTimeAutomationController
    Test Class  : ET_overTimeAutomationControllerTest
    Description : Called by eT_overTimeAuto LWC
    Author      : SrihariKoyila
    */
    public class ET_overTimeAutomationController {

    @AuraEnabled
    public static void saveRecords(List<Overtime_Calculater__c> overtimeRecords) {
    try {
    Id userId = UserInfo.getUserId();
    User currentUser = [SELECT Name FROM User WHERE Id = :userId LIMIT 1];
    Date todayDate = System.today();
    OverTime_Sheets__c ovrSheet = new OverTime_Sheets__c();
    ovrSheet.OverTime_Uploader__c = currentUser.Name;
    ovrSheet.Uploaded_Date__c = todayDate;
    insert ovrSheet;
    String OTsheetId = ovrSheet.Id;

    if(overtimeRecords != null && !overtimeRecords.isEmpty()) {
        for (Overtime_Calculater__c record : overtimeRecords) {
            record.OverTime_Sheets__c = ovrSheet.Id;
        }
        insert overtimeRecords;
    }


    if (OTsheetId != null && OTsheetId != '') {
    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    req1.setComments('Automatically submitted for approval.');
    req1.setObjectId(OTsheetId);
    req1.setSubmitterId(UserInfo.getUserId());
    req1.setProcessDefinitionNameOrId('ET_OverTime_Automation_ApprovalProcess');
    req1.setSkipEntryCriteria(true);
    Approval.ProcessResult result = Approval.process(req1);
    if (result.isSuccess()) {
        System.debug('Approval process submitted successfully. Instance Id: ' + result.getInstanceId());
        System.debug('New workitem Id: ' + result.getNewWorkitemIds());
    } else {
        System.debug('Failed to submit for approval. Errors: ' + result.getErrors());
    }
    }

    } catch(Exception e) {
    throw new AuraHandledException('Error inserting records: ' + e.getMessage());
    }
    }

    @AuraEnabled(cacheable=true)
    public static List<OverTime_Sheets__c> getOTSrecords(){
    Id currentUserId = UserInfo.getUserId();
    return [SELECT Id, Name, OverTime_Uploader__c, Uploaded_Date__c FROM OverTime_Sheets__c WHERE OwnerId = :currentUserId LIMIT 10];

    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getOvertimeRecords(Id sheetId) {
    List<SObject> resultRecords = new List<SObject>();
    try {
        resultRecords = [
            SELECT Id,Employee_No__c, Employee_Name__c,Time_In__c, Time_Out__c, Total_of_Hours__c, Contract_No__c, Cust_Name__c, Cost_Recovery__c, Location__c, Category__c, Activity__c, Total_Rate__c, Type__c
            FROM Overtime_Calculater__c
            WHERE OverTime_Sheets__c = :sheetId
        ];
    } catch (Exception e) {
    throw new AuraHandledException('Error fetching records: ' + e.getMessage());
    }
    return resultRecords;
    }

    @AuraEnabled
    public static Id uploadFileToApex(String base64Data, String fileName, Id recordId) {
    try {
    ContentVersion contentVersion = new ContentVersion();
    contentVersion.Title = fileName;
    contentVersion.PathOnClient = '/' + fileName;
    contentVersion.VersionData = EncodingUtil.base64Decode(base64Data);
    insert contentVersion;

    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id].ContentDocumentId;
    cdl.LinkedEntityId = recordId;
    cdl.ShareType = 'V';
    cdl.Visibility = 'AllUsers';
    insert cdl;

    return cdl.Id;
    } catch (Exception e) {
    throw new AuraHandledException('Error uploading file: ' + e.getMessage());
    }
    }
        
        //SK
        @AuraEnabled
        public static List<Fuel_Consumption__c> getFuelConsumptionRecords() {
            return [select Id,Name,Month__c,Year__c,Vehicle_Number__c FROM Fuel_Consumption__c];
        }

    }