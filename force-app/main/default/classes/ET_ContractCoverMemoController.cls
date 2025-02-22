/**
     * @description       : 
     * @author            : Srihari.Koyila@Smaartt.com-SK
     * @group             : 
     * @last modified on  : 09-10-2024
     * @last modified by  : Srihari.Koyila@Smaartt.com-SK
     * Modifications Log
     * Ver   Date         Author                          Modification
     * 1.0   08-06-2024   Srihari.Koyila@Smaartt.com-SK   Initial Version
    **/
    public class ET_ContractCoverMemoController {
    public string recordId {get;set;} 
    public string ContractHeaderName {get;set;}  
    public string AccountName {get;set;}  
    public string AccountNumber {get;set;}  
    public string ContractType {get;set;} 
    public string Servicetype {get;set;}  
    public Decimal QuoteTotalvalue {get;set;}  
    public string ContractDuration {get;set;}  
    public Boolean FuelCluse {get;set;}  
    public string FuelCluseValue {get;set;}  
    public string FromasSender {get;set;}  
    public Datetime DateofSender {get;set;}  
    public Decimal VehicleQuanty {get;set;}  
    public Decimal ManPowerQuanty {get;set;}  
    public Decimal TotalContractvalue {get;set;}
    public Decimal AnnualContractValue {get;set;}
    public Decimal DOAPricing {get;set;}
    public Decimal TotalOverDueAmount {get;set;}  
    public Boolean CreditAssessment {get;set;}  
    public string CreditAssessmentValue {get;set;}  




    public List<Customer_Workforce_Quote_Item__c> CustomerWorkForceItemList {get;set;}
    public List<Customer_Vehicle_Quote_Item__c> customerVehicleQuoteItemList {get;set;}

    public ET_ContractCoverMemoController(ApexPages.StandardController stdController){
        String CPDFId = ApexPages.currentPage().getParameters().get('Id'); 
        recordId = CPDFId;
        Decimal sumasTotalContractValue = 0;
        Decimal sumasTotalVeh =0;
        Decimal sumasTotalWorkForce =0;
        Decimal sumasDOAPricing =0;

        

        // Fetch Contract_Pdf_Header__c record
        Contract_Pdf_Header__c ConPdfH = [SELECT Id, Customer_Quote__c, CreatedBy.Name, CreatedDate, Contract_Type__c, Name, Sh1_Clause3_1_Agreement_YearsMonths__c, Sh1_Clause3_1_Minimum_Period__c, With_Driver__c, With_Fuel__c FROM Contract_Pdf_Header__c WHERE Id=:CPDFId];
        Customer_Quote__c customerQuote;
        if (ConPdfH.Customer_Quote__c != null) {
            customerQuote = [select Id,Quote__c,Quote_Total_Investment__c,Fuel_Included_Current_Contract__c,Account_Name__r.Name,Account_Name__r.AccountNumber,Account_Name__r.Credit_Assessment__c,Name,Opportunity_Name__r.Id,Opportunity_Name__r.Name,Opportunity_Name__r.RecordTypeId,Opportunity_Name__r.RecordType.Name,Opportunity_Name__r.Type from Customer_Quote__c where Id=:ConPdfH.Customer_Quote__c];
        }else {
            throw new CustomException('No Customer_Quote__c found for the given Id.');

        }
        Quote QT;
        if (customerQuote.Quote__c != null) {
             QT =[select Id,Total_Value_of_Rental__c from Quote where Id=:customerQuote.Quote__c limit 1];
        }else {
            throw new CustomException('No Quote__c found for the given Customer_Quote__c Id.');

        }
        if (customerQuote != null) {
            CustomerWorkForceItemList = [select Id,Name,Number_of_Workforce__c,Total_Main_Vehicle__c,Service_Type__c,Monthly_Rate_with_VAT__c,Monthly_Rate_All_Unit_with_VAT__c,Quote__c from Customer_Workforce_Quote_Item__c where Quote__c =:customerQuote.Id];
        }
        if (customerQuote != null) {
            customerVehicleQuoteItemList = [select Id,Name,Vehicle_Monthly_Cost__c,Total_Rate_All_Units__c,DOA_Pricing__c,Number_of_Vehicles__c,Passed_years_from_Bus_Model__c,Service_Type__c,Monthly_Rate_with_VAT__c,Monthly_Rate_All_Unit_with_VAT__c,Customer_Quote__c from Customer_Vehicle_Quote_Item__c where Customer_Quote__c =:customerQuote.Id];
        }


        ContractHeaderName = ConPdfH.Name;
        AccountName = customerQuote.Account_Name__r.Name;
        AccountNumber = customerQuote.Account_Name__r.AccountNumber;
        CreditAssessment = customerQuote.Account_Name__r.Credit_Assessment__c;
        Servicetype = customerQuote.Opportunity_Name__r.RecordType.Name;
        ContractType = customerQuote.Opportunity_Name__r.Type;
        QuoteTotalvalue = customerQuote.Quote_Total_Investment__c;
        FuelCluse = ConPdfH.With_Fuel__c;
        if(!FuelCluse) {
             FuelCluseValue = 'NA';
        } else {
             FuelCluseValue = String.valueOf(FuelCluse);
        }
        if(!CreditAssessment) {
             CreditAssessmentValue = 'No';
        } else {
             //CreditAssessmentValue = String.valueOf(CreditAssessment);
             CreditAssessmentValue = 'Yes';
        }
        ContractDuration = ConPdfH.Sh1_Clause3_1_Agreement_YearsMonths__c;
        FromasSender = ConPdfH.CreatedBy.Name;
        DateofSender = ConPdfH.CreatedDate;


        if (customerVehicleQuoteItemList != null && !customerVehicleQuoteItemList.isEmpty()) {
        for(Customer_Vehicle_Quote_Item__c VQI :customerVehicleQuoteItemList){
            if(VQI.Total_Rate_All_Units__c != null ){
                sumasTotalContractValue += VQI.Total_Rate_All_Units__c;
            }
            if (VQI.Number_of_Vehicles__c != null) {
                sumasTotalVeh += VQI.Number_of_Vehicles__c;
            } 
            if (VQI.DOA_Pricing__c != null) {
                sumasDOAPricing += VQI.DOA_Pricing__c;
            }
            }
            TotalContractvalue = sumasTotalContractValue;
            VehicleQuanty = sumasTotalVeh;
            DOAPricing = sumasDOAPricing;

            Customer_Quote__c UpdatDOA = new Customer_Quote__c();
            UpdatDOA.Id = customerQuote.Id;
            //UpdatDOA.Total_DOA_Pricing__c = DOAPricing;
            // update UpdatDOA;
        }

        if (CustomerWorkForceItemList != null && !CustomerWorkForceItemList.isEmpty()) {
            for (Customer_Workforce_Quote_Item__c WQI : CustomerWorkForceItemList) {
                if (WQI.Number_of_Workforce__c != null) {
                    sumasTotalWorkForce += WQI.Number_of_Workforce__c;
                }
            }
            ManPowerQuanty = sumasTotalWorkForce;
        }
        if (ConPdfH.Contract_Type__c == 'Yearly') {
            AnnualContractValue = TotalContractValue / Decimal.valueOf(ContractDuration);
        } else if (ConPdfH.Contract_Type__c == 'Monthly') {
            Decimal years = Decimal.valueOf(ContractDuration) / 12;
            AnnualContractValue = TotalContractValue / years;
        }
        // Assuming you have Account information from customerQuote
        if (customerQuote != null && customerQuote.Account_Name__r != null) {
            CreateCollectorLogHandler.customerAmountWrapper customerAmountDetails = CreateCollectorLogHandler.getCustomerAmountDetails(customerQuote.Account_Name__r.Id);
            
            if (customerAmountDetails != null) {
                TotalOverDueAmount = Decimal.valueOf(customerAmountDetails.totalReceivable);
                System.debug('Total Amount Original: ' + customerAmountDetails.totalAmountOriginal);
                System.debug('TotalOverDueAmount' + customerAmountDetails.totalReceivable);
                System.debug('Error Message: ' + customerAmountDetails.errorMessage);
            }
        }
        
    }



    @AuraEnabled
    public static string generateContractMemoDoc(string quoteId){
        system.debug(quoteId);
        String VFpageName ='ET_ContractCoverMemo';
        List<Contract_Pdf_Header__c>  cusQuote =[select Id, Name,Customer_Quote__r.Name from Contract_Pdf_Header__c where Id =:quoteId];
        String CusQuoteName = cusQuote[0].Customer_Quote__r.Name;
        PageReference pdf;
        pdf =  Page.ET_ContractCoverMemo;
        pdf.getParameters().put('Id',quoteId);
        Blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = pdf.getContentAsPDF();
        }else{
            pdfBlob = Blob.valueOf('Dummy PDF content');
        }
        try{
            ContentVersion conVer = new ContentVersion();
            DateTime  dt = System.now();
            
            conVer.ContentLocation = 'S'; // TO USE S specify this document IS IN Salesforce, TO USE E FOR external files
            conVer.PathOnClient = CusQuoteName+'_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
            conVer.Title = 'CoverMemo_'+CusQuoteName+ '_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
            conVer.VersionData = pdfBlob;
            insert conVer;  
            
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            
            ContentDocumentLink conDocLink = new ContentDocumentLink();
            conDocLink.LinkedEntityId = quoteId; //parentId
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            insert conDocLink;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return quoteId;
    }

    public class CustomException extends Exception {}


    }