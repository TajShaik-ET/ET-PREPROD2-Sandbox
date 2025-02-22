@isTest
public class ET_ContractCoverMemoControllerTest {
    @testSetup
    static void setupData() {
        // Create Account
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        Id recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Business_School' LIMIT 1].Id;
        Id RTId_Leasing = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();

        Account testAccount= new Account();
        testAccount.Name='oil and gas nttt';
        testAccount.ETSALES_Customer_Account_Id__c='1926070';
        testAccount.accountnumber='1926070';
        //testAccount.RecordTypeId =recordTypeId;
        insert testAccount;
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.Name = 'Test CoverMemo';
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.StageName = 'Sales Agreement'; // Required field for Opportunity
        testOpportunity.CloseDate = Date.today().addDays(30); // Required field for Opportunity
        insert testOpportunity;
         List<Opportunity> opplist = new List<Opportunity>();
         oppList.add(testOpportunity);
        // Create Quote
        Quote testQuote = new Quote(Name = 'Test Quote',OpportunityId = testOpportunity.Id);
        insert testQuote;
        
        // Create Customer Quote
        Customer_Quote__c testCustomerQuote = new Customer_Quote__c(
            Name = 'Test Customer Quote',
            Quote__c = testQuote.Id,
            Opportunity_Name__c =testOpportunity.Id,
            Account_Name__c = testAccount.Id,
            Quote_Total_Investment__c = 200000,
            Fuel_Included_Current_Contract__c = 'No'
        );
        insert testCustomerQuote;
        
        // Create Contract_Pdf_Header__c record
        Contract_Pdf_Header__c testContractPdfHeader = new Contract_Pdf_Header__c(
            Customer_Quote__c = testCustomerQuote.Id,
            Sh1_Clause3_1_Agreement_YearsMonths__c = '2',
            With_Fuel__c = true
        );
        insert testContractPdfHeader;
        
        // Create Customer Workforce and Vehicle Quote Items
        Customer_Workforce_Quote_Item__c workforceItem1 = new Customer_Workforce_Quote_Item__c(
            Name = 'CheckBox Row',
            Number_of_Workforce__c = null,
            Total_Main_Vehicle__c = null,
            Service_Type__c = null,
            Monthly_Rate_with_VAT__c = null,
            Monthly_Rate_All_Unit_with_VAT__c = null,
            Quote__c = testCustomerQuote.Id
        );
        
        Customer_Workforce_Quote_Item__c workforceItem2 = new Customer_Workforce_Quote_Item__c(
            Name = 'Label Row',
            Number_of_Workforce__c = null,
            Total_Main_Vehicle__c = null,
            Service_Type__c = null,
            Monthly_Rate_with_VAT__c = null,
            Monthly_Rate_All_Unit_with_VAT__c = null,
            Quote__c = testCustomerQuote.Id
        );
        
        Customer_Workforce_Quote_Item__c workforceItem3 = new Customer_Workforce_Quote_Item__c(
            Name = 'Driver',
            Number_of_Workforce__c = 3,
            Total_Main_Vehicle__c = null,
            Service_Type__c = 'Agricultural Equipment',
            Monthly_Rate_with_VAT__c = null,
            Monthly_Rate_All_Unit_with_VAT__c = 9000,
            Quote__c = testCustomerQuote.Id
        );
        insert new List<Customer_Workforce_Quote_Item__c>{workforceItem1, workforceItem2, workforceItem3};
            
            // Insert Customer_Vehicle_Quote_Item__c records
            
            Customer_Vehicle_Quote_Item__c vehicleItem1 = new Customer_Vehicle_Quote_Item__c(
                Name = 'CheckBox Row',
                Vehicle_Monthly_Cost__c = null,
                Total_Rate_All_Units__c = null,
                Number_of_Vehicles__c = null,
                Service_Type__c = null,
                Monthly_Rate_with_VAT__c = null,
                Monthly_Rate_All_Unit_with_VAT__c = null,
                Customer_Quote__c = testCustomerQuote.Id
            );
        
        Customer_Vehicle_Quote_Item__c vehicleItem2 = new Customer_Vehicle_Quote_Item__c(
            Name = 'Label Row',
            Vehicle_Monthly_Cost__c = null,
            Total_Rate_All_Units__c = null,
            Number_of_Vehicles__c = null,
            Service_Type__c = null,
            Monthly_Rate_with_VAT__c = null,
            Monthly_Rate_All_Unit_with_VAT__c = null,
            Customer_Quote__c = testCustomerQuote.Id
        );
        
        Customer_Vehicle_Quote_Item__c vehicleItem3 = new Customer_Vehicle_Quote_Item__c(
            Name = 'Audi A3_2023',
            Vehicle_Monthly_Cost__c = 800,
            Total_Rate_All_Units__c = 153600,
            Number_of_Vehicles__c = 8,
            Service_Type__c = 'General Rent',
            Monthly_Rate_with_VAT__c = null,
            Monthly_Rate_All_Unit_with_VAT__c = 6400,
            Customer_Quote__c = testCustomerQuote.Id
        );
        
        Customer_Vehicle_Quote_Item__c vehicleItem4 = new Customer_Vehicle_Quote_Item__c(
            Name = 'BMW 2 SERIES_2018',
            Vehicle_Monthly_Cost__c = 2400,
            Total_Rate_All_Units__c = 230400,
            Number_of_Vehicles__c = 4,
            Service_Type__c = 'General Rent',
            Monthly_Rate_with_VAT__c = null,
            Monthly_Rate_All_Unit_with_VAT__c = 9600,
            Customer_Quote__c = testCustomerQuote.Id
        );
        
        // Insert records
        insert new List<Customer_Vehicle_Quote_Item__c>{vehicleItem1, vehicleItem2, vehicleItem3, vehicleItem4};
            
            }
    
    @isTest
    static void testConstructor() {
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        
        PageReference pageRef = Page.ET_ContractCoverMemo;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', [SELECT Id FROM Contract_Pdf_Header__c LIMIT 1].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Contract_Pdf_Header__c LIMIT 1]);
        ET_ContractCoverMemoController testpdf = new ET_ContractCoverMemoController(sc);
        
        
        
        
    }
    
    @isTest
    static void testGenerateContractMemoDoc() {
        // Create test data and set page parameters
        String quoteId =[SELECT Id FROM Contract_Pdf_Header__c LIMIT 1].Id;
        PageReference pageRef = Page.ET_ContractCoverMemo;
        pageRef.getParameters().put('Id', quoteId);
        //Blob pdfBlob;
        Blob pdfBlob = Blob.valueOf('Dummy PDF content');
        // Test calling the static method
        Test.startTest();
        String returnedId = ET_ContractCoverMemoController.generateContractMemoDoc(quoteId);
        Test.stopTest();
        
    }
    
    @isTest
    static void testCustomExceptionHandling() {
        // Test handling when no Customer_Quote__c is found
        Contract_Pdf_Header__c noCustomerQuotePdf = new Contract_Pdf_Header__c();
        insert noCustomerQuotePdf;
        
        PageReference pageRef = Page.ET_ContractCoverMemo;
        pageRef.getParameters().put('Id', noCustomerQuotePdf.Id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(noCustomerQuotePdf);
        try {
            new ET_ContractCoverMemoController(sc);
            System.assert(false, 'Exception should have been thrown');
        } catch (ET_ContractCoverMemoController.CustomException e) {
            System.assertEquals('No Customer_Quote__c found for the given Id.', e.getMessage(), 'Custom exception message should match');
        }
    }
}