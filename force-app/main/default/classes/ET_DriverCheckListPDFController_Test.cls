@IsTest
private class ET_DriverCheckListPDFController_Test {
    @TestSetup
    static void setupTestData() {
        // Create Opportunity
       /* Opportunity testOpportunity = new Opportunity(
            Name = 'Test Vehicle Opportunity',
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(30)
        );
        insert testOpportunity;
        ET_Pricing_Service_Request__c pricingRequest = new ET_Pricing_Service_Request__c(
            Opportunity__c = testOpportunity.Id
        );
        insert pricingRequest;
*/
        Driver_Daily_Check_List__c checklist = new Driver_Daily_Check_List__c(
             Date__c = System.today(),
            Status__c = 'Submitted',
            Final_Result__c = 'Pass'
        );
        insert checklist;
        List<Driver_Check_List_Line__c> lines = new List<Driver_Check_List_Line__c>();
        lines.add(new Driver_Check_List_Line__c(
            Driver_Check_List__c = checklist.Id,
            Category_En__c = 'Safety',
            Category_Ar__c = 'سلامة',
            Category_Ur__c = 'سلامتی',
            Question_En__c = 'Tire Pressure Check',
            Question_Ar__c = 'فحص ضغط الإطارات',
            Question_Ur__c = 'ٹائر کا دباؤ چیک کریں۔',
            Response__c = 'Selected',
            Severity_Ar__c = 'High',
            Number__c = 1
        ));
            lines.add(new Driver_Check_List_Line__c(
            Driver_Check_List__c = checklist.Id,
            Category_En__c = 'Documentation',
            Category_Ar__c = 'توثيق',
            Category_Ur__c = 'دستاویزات',
            Question_En__c = 'Insurance Validity',
            Question_Ar__c = 'صلاحية التأمين',
            Question_Ur__c = 'انشورنس کی توثیق',
            Response__c = 'Not Selected',
            Severity_Ar__c = 'Medium',
            Number__c = 2
        ));
        insert lines;
    }
   @IsTest
    static void testControllerInitialization() {
        Driver_Daily_Check_List__c testChecklist = [SELECT Id FROM Driver_Daily_Check_List__c LIMIT 1];
        
        Test.setCurrentPage(Page.DriverChecklistPDF);
        ApexPages.currentPage().getParameters().put('Id', testChecklist.Id);
        ET_DriverCheckListPDFController controller = new ET_DriverCheckListPDFController();
           }
    @IsTest
    static void testPDFGeneration() {
        Driver_Daily_Check_List__c testChecklist = [SELECT Id FROM Driver_Daily_Check_List__c LIMIT 1];
         Test.setCurrentPage(Page.DriverChecklistPDF);
        ApexPages.currentPage().getParameters().put('Id', testChecklist.Id);
        ET_DriverCheckListPDFController controller = new ET_DriverCheckListPDFController();
        PageReference pdfPage = controller.generatePDF();
                    
        System.assertNotEquals(null, pdfPage, 'Should return valid PageReference');
          }

}