@IsTest
public class ET_overTimeAutomationControllerTest {

    @TestSetup
    static void setupTestData() {
        // Create test User
        User testUser = [SELECT Id FROM User LIMIT 1];
        if (testUser == null) {
            testUser = new User(
                FirstName = 'Test',
                LastName = 'User',
                Email = 'testuser@smaartt.com',
                Username = 'testuser@smaartt.com',
                Alias = 'tuser',
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
                LanguageLocaleKey = 'en_US'
            );
            insert testUser;
        }

        // Create test Overtime Calculater records
        List<Overtime_Calculater__c> overtimeRecords = new List<Overtime_Calculater__c>();
        for (Integer i = 0; i < 5; i++) {
            Overtime_Calculater__c record = new Overtime_Calculater__c(
                Employee_No__c = 'E' + i,
                Employee_Name__c = 'Employee ' + i,
                Time_In__c = '2024-09-02 09:15:23',
                Time_Out__c = '2024-09-02 09:15:23',
                Total_of_Hours__c = '8',
                Contract_No__c = 'C' + i,
                Cust_Name__c = 'Customer ' + i,
                Cost_Recovery__c = '100.0' + i,
                Location__c = 'Location ' + i,
                Category__c = 'Category ' + i,
                Activity__c = 'Activity ' + i,
                Total_Rate__c = '200.0' + i,
                Type__c = 'Type ' + i
            );
            overtimeRecords.add(record);
        }
        insert overtimeRecords;
    }

    @IsTest
    static void testSaveRecords() {
        Test.startTest();
        
        String jsonString = '[{"Employee_No__c":"87027","Employee_Name__c":"Akhil","Time_In__c":"2024-06-08","Time_Out__c":"7"},{"Employee_No__c":"87027","Employee_Name__c":"Akhil","Time_In__c":"2024-06-09","Time_Out__c":"7"},{"Employee_No__c":"87027","Employee_Name__c":"Akhil","Time_In__c":"2024-06-10","Time_Out__c":"7"},{"Employee_No__c":"87027","Employee_Name__c":"Akhil","Time_In__c":"2024-06-11","Time_Out__c":"7"},{"Employee_No__c":"19998","Employee_Name__c":"Amal","Time_In__c":"2024-06-08","Time_Out__c":"7"},{"Employee_No__c":"19998","Employee_Name__c":"Amal","Time_In__c":"2024-06-09","Time_Out__c":"7"}]';
        
        List<Overtime_Calculater__c> overtimeRecords = (List<Overtime_Calculater__c>) JSON.deserialize(jsonString, List<Overtime_Calculater__c>.class);
        ET_overTimeAutomationController.saveRecords(overtimeRecords);
        List<OverTime_Sheets__c> otsheets = [SELECT Id, OverTime_Uploader__c, Uploaded_Date__c FROM OverTime_Sheets__c];
        System.assertEquals(1, otsheets.size(), 'One OverTime_Sheets__c record should be created.');

        List<Overtime_Calculater__c> updatedRecords = [SELECT OverTime_Sheets__c FROM Overtime_Calculater__c WHERE Id IN :overtimeRecords];
        for (Overtime_Calculater__c record : updatedRecords) {
            System.assertNotEquals(null, record.OverTime_Sheets__c, 'Overtime_Calculater__c records should have OverTime_Sheets__c set.');
        }

        Test.stopTest();
    }

    @IsTest
    static void testGetOTSrecords() {
        Test.startTest();
        List<OverTime_Sheets__c> otsheets = ET_overTimeAutomationController.getOTSrecords();
        Test.stopTest();
    }

    @IsTest
    static void testGetOvertimeRecords() {
        Test.startTest();
        OverTime_Sheets__c ovrSheet = new OverTime_Sheets__c(
            OverTime_Uploader__c = 'Test User',
            Uploaded_Date__c = Date.today()
        );
        insert ovrSheet;

        List<Overtime_Calculater__c> overtimeRecords = [SELECT Id,OverTime_Sheets__c FROM Overtime_Calculater__c LIMIT 5];
        for (Overtime_Calculater__c record : overtimeRecords) {
            record.OverTime_Sheets__c = ovrSheet.Id;
        }
        update overtimeRecords;

        List<SObject> records = ET_overTimeAutomationController.getOvertimeRecords(ovrSheet.Id);
        System.assertEquals(overtimeRecords.size(), records.size(), 'Overtime_Calculater__c records should be returned.');
        Test.stopTest();
    }

    @IsTest
    static void testUploadFileToApex() {
        Test.startTest();
        OverTime_Sheets__c ovrSheet = new OverTime_Sheets__c(
            OverTime_Uploader__c = 'Test User',
            Uploaded_Date__c = Date.today()
        );
        insert ovrSheet;

        String base64Data = EncodingUtil.base64Encode(Blob.valueOf('Test File Content'));
        Id contentDocumentLinkId = ET_overTimeAutomationController.uploadFileToApex(base64Data, 'TestFile.txt', ovrSheet.Id);

        ContentDocumentLink cdl = [SELECT Id FROM ContentDocumentLink WHERE Id = :contentDocumentLinkId];
        System.assertNotEquals(null, cdl, 'ContentDocumentLink record should be created.');
        Test.stopTest();
    }

    
    //Integration
    @isTest
    static void testGetOverTimeData() {
        OverTime_Sheets__c overtimeSheet = new OverTime_Sheets__c(OverTime_Uploader__c = 'John Doe', Uploaded_Date__c = Date.today());
        insert overtimeSheet;

        Overtime_Calculater__c overtimeCalc = new Overtime_Calculater__c(
            OverTime_Sheets__c = overtimeSheet.Id,
            Employee_No__c = 'E123',
            Employee_Name__c = 'Jane Doe',
            Time_In__c = '2024-09-02 09:15:23',
            Time_Out__c = '2024-09-02 09:15:23',
            Total_of_Hours__c = '8',
            Contract_No__c = 'CN123',
            Cust_Name__c = 'Customer ABC',
            Cost_Recovery__c = '1000',
            Location__c = 'Office',
            Category__c = 'Category A',
            Activity__c = 'Coding',
            Total_Rate__c = '150',
            Type__c = 'Type 1'
        );
        insert overtimeCalc;

        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());

        Test.startTest();
        ET_OverTimeAutoIntegration.getOverTimeData(overtimeSheet.Id);
        Test.stopTest();

       
    }

   
    
    
    
    
    
    

  
    
    
    
}