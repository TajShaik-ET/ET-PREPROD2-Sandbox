@isTest
public class ET_AddendumPDFPageControllerTest {
    @testSetup
    static void setupData() {
        // Create Account
        Account testAccount= new Account();
        testAccount.Name='oil and gas nttt';
        testAccount.ETSALES_Customer_Account_Id__c='1926070';
        testAccount.accountnumber='1926070';
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
            Fuel_Included_Current_Contract__c = 'No',
            RecordType__c = 'Transportation',
            Contract_Type__c ='Yearly'
        );
        insert testCustomerQuote;
        // Create Addendum
        Addendum__c addendum = new Addendum__c(
            Customer_Quote__c = testCustomerQuote.Id,
            Starting_Date__c = Date.today(),
            Effective_Date__c = Date.today(),
            Emirates_Transport_Representative__c = 'John Doe',
            ET_Designation__c = 'Manager',
            Company_s_Representative__c = 'Jane Smith',
            P_O_Box__c = '12345'
           // Contract__c = testContractPdfHeader.Id
        );
        insert addendum;
        
        // Create Contract Master and Contract Line
        Contract_Master__c contractMaster = new Contract_Master__c(
            Name = 'Test Contract Master',
            Addendum__c = addendum.Id,
            Line_No__c = 1
        );
        insert contractMaster;
        Contract_Line__c contractLine = new Contract_Line__c(
            Name = 'Test Contract Line',
            Contract_Master__c = contractMaster.Id,
            Description__c = 'John Doe',
            Editable__c = true,
            Delete__c = false,
            Line_No__c = 1
        );
        insert contractLine;
            
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
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Addendum__c LIMIT 1]);
        ET_AddendumPDFPageController testpdf = new ET_AddendumPDFPageController(sc);
    }
    @isTest
    static void testgenerateQuoteDoc() {
        // Test Data      
        String AddendumId =[SELECT Id FROM Addendum__c LIMIT 1].Id;
        String recId = AddendumId;
        String pdfType = 'Renewal';
        
        PageReference pageRef = Page.ET_ContractCoverMemo;
        pageRef.getParameters().put('Id', recId);
        
        Test.startTest();
        ET_AddendumPDFPageController.generateQuoteDoc(recId,pdfType);
        Test.stopTest();
        
    }
    
    
}