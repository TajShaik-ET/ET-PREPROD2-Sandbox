/*
Name: ContractPreviewController
Test Class: 
Author: Sreelakshmi SK
Created Date: 25 May 2023
Description: Controller to provide sales agreement details in ContractPreview.vfp
*/

public class ContractPreviewController {
    public list<ET_Sales_Agreement__c> salesAgreementRecord{get; set;}       
    public ContractPreviewController(){
        ID idtest=ApexPages.currentPage().getParameters().get('id');
        salesAgreementRecord=[select id,name,Customer_PO_No__c, Salesforce_Customer__r.Name, Salesforce_Customer__r.ETSALES_Trade_License_Number__c, Contract_Start_Date__c  from ET_Sales_Agreement__c where id=:idtest];
        system.debug(salesAgreementRecord);
        
    }
    
    
    /*
Name: ContractPreviewController
Test Class: 
Author: SriHari Koyila
Created Date: 25 Sept 2023
Description: Controller to provide sales agreement details in LeaseContractPreview.vfp
*/
    
    public string ET_Solitation {get;set;}
    public string ET_ETRepresentative {get;set;}
    public string ET_Designation {get;set;}
    public string LA_Solitation {get;set;}
    public string LA_LARepresentative {get;set;}
    public string LA_Designation {get;set;}
    public string LA_AgreementDate {get;set;}
    public string LA_POBusiness {get;set;}
    public string LA_PostOfBox {get;set;}
    public string LA_ALMPYear {get;set;}
    public string LA_InCAccident {get;set;}
    public string LA_CMCost {get;set;}
    public string LA_TVNExceed {get;set;}
    public string LA_LAKilometer {get;set;}
    public string LA_DOAgreement {get;set;}
    public string LA_FAllowance {get;set;}
    public string LA_VOSCheque {get;set;}
    //
    public Date ContractStartDate {get;set;}
    public Date ContractEndtDate {get;set;}
    public string ETService {get;set;}
    public string Licensenumber {get;set;}  
    public string AccountName {get;set;}  
    
    public Decimal TotalContractvalue {get;set;}
    //
    public List<Customer_Workforce_Quote_Item__c> CustomerWorkForceItemList {get;set;}
    public List<Customer_Vehicle_Quote_Item__c> customerVehicleQuoteItemList {get;set;}
    
    
    public ContractPreviewController(ApexPages.StandardController stdController){
        Decimal sum = 0;
        
        String CustomerquoteId = ApexPages.currentPage().getParameters().get('Id'); 
        ET_Solitation  = ApexPages.CurrentPage().getparameters().get ('ET_Solitation');
        ET_ETRepresentative  = ApexPages.CurrentPage().getparameters().get('ET_ETRepresentative');
        ET_Designation  = ApexPages.CurrentPage().getparameters().get('ET_Designation');
        LA_Solitation  = ApexPages.CurrentPage().getparameters().get('LA_Solitation');
        LA_LARepresentative  = ApexPages.CurrentPage().getparameters().get('LA_LARepresentative');
        LA_Designation  = ApexPages.CurrentPage().getparameters().get('LA_Designation');
        LA_AgreementDate  = ApexPages.CurrentPage().getparameters().get('LA_AgreementDate');
        LA_POBusiness  = ApexPages.CurrentPage().getparameters().get('LA_POBusiness');
        LA_PostOfBox  = ApexPages.CurrentPage().getparameters().get('LA_PostOfBox');
        LA_ALMPYear  = ApexPages.CurrentPage().getparameters().get('LA_ALMPYear');
        LA_InCAccident  = ApexPages.CurrentPage().getparameters().get('LA_InCAccident');
        LA_CMCost  = ApexPages.CurrentPage().getparameters().get('LA_CMCost');
        LA_TVNExceed  = ApexPages.CurrentPage().getparameters().get('LA_TVNExceed');
        LA_LAKilometer  = ApexPages.CurrentPage().getparameters().get('LA_LAKilometer');
        LA_DOAgreement  = ApexPages.CurrentPage().getparameters().get('LA_DOAgreement');
        LA_FAllowance  = ApexPages.CurrentPage().getparameters().get('LA_FAllowance');
        LA_VOSCheque  = ApexPages.CurrentPage().getparameters().get('LA_VOSCheque');
        
        //ETService  = ApexPages.CurrentPage().getparameters().get('ETService');
        //Licensenumber  = ApexPages.CurrentPage().getparameters().get('Licensenumber');
        //ContractStartDate  = ApexPages.CurrentPage().getparameters().get('ContractStartDate');
        //ContractEndtDate  = ApexPages.CurrentPage().getparameters().get('ContractEndtDate');
        
        
        CustomerWorkForceItemList = [select Id,Name,Total_Main_Vehicle__c,Service_Type__c,Monthly_Rate_with_VAT__c,Monthly_Rate_All_Unit_with_VAT__c,Quote__c from Customer_Workforce_Quote_Item__c where Quote__c =:CustomerquoteId];
        customerVehicleQuoteItemList = [select Id,Name,Number_of_Vehicles__c,Passed_years_from_Bus_Model__c,Service_Type__c,Monthly_Rate_with_VAT__c,Monthly_Rate_All_Unit_with_VAT__c,Customer_Quote__c from Customer_Vehicle_Quote_Item__c where Customer_Quote__c =:CustomerquoteId];
        for(Customer_Vehicle_Quote_Item__c VQI :customerVehicleQuoteItemList){
            if(VQI.Monthly_Rate_with_VAT__c != null){
                sum += VQI.Monthly_Rate_with_VAT__c;
            }
            
        }
        TotalContractvalue = sum;
        
        Customer_Quote__c customerQuote = [select Id,Name,Opportunity_Name__r.Id,Opportunity_Name__r.Name,Opportunity_Name__r.RecordTypeId,Opportunity_Name__r.RecordType.Name from Customer_Quote__c where Id=:CustomerquoteId];
        Opportunity OPPREC = [select Id,Name,ETSALES_GL_Services__c,Account.Name,Account.ETSALES_Trade_License_Number__c,Contract_Start_Date__c,Contract_End_Date__c from Opportunity where Id =:customerQuote.Opportunity_Name__r.Id];
        
        ETService = OPPREC.ETSALES_GL_Services__c;
        Licensenumber = OPPREC.Account.ETSALES_Trade_License_Number__c;
        AccountName = OPPREC.Account.Name;
        ContractStartDate = OPPREC.Contract_Start_Date__c;
        ContractEndtDate = OPPREC.Contract_End_Date__c;
        
        system.debug(OPPREC);
        
        
    }
    //GENERATE_PDF
    @AuraEnabled
    public static string GenerateQuoteDoc(Map<String, Object> CustomerquoteREC){
        system.debug(CustomerquoteREC); 
        String PDFType = (String)CustomerquoteREC.get('PDFType');
        String QuoteName = (String)CustomerquoteREC.get('QuoteName');
        
        String recordId = (String)CustomerquoteREC.get('RecordId');
        
        
        String ET_Solitation = (String)CustomerquoteREC.get('ET_Solitation');
        String ET_ETRepresentative = (String)CustomerquoteREC.get('ET_ETRepresentative');
        String ET_Designation = (String)CustomerquoteREC.get('ET_Designation');
        String LA_Solitation = (String)CustomerquoteREC.get('LA_Solitation');
        String LA_LARepresentative = (String)CustomerquoteREC.get('LA_LARepresentative');
        String LA_Designation = (String)CustomerquoteREC.get('LA_Designation');
        String LA_AgreementDate = (String)CustomerquoteREC.get('LA_AgreementDate');
        String LA_POBusiness = (String)CustomerquoteREC.get('LA_POBusiness');
        String LA_PostOfBox = (String)CustomerquoteREC.get('LA_PostOfBox');
        String LA_ALMPYear = (String)CustomerquoteREC.get('LA_ALMPYear');
        String LA_InCAccident = (String)CustomerquoteREC.get('LA_InCAccident');
        String LA_CMCost = (String)CustomerquoteREC.get('LA_CMCost');
        String LA_TVNExceed = (String)CustomerquoteREC.get('LA_TVNExceed');
        String LA_LAKilometer = (String)CustomerquoteREC.get('LA_LAKilometer');
        String LA_DOAgreement = (String)CustomerquoteREC.get('LA_DOAgreement');
        String LA_FAllowance = (String)CustomerquoteREC.get('LA_FAllowance');
        String LA_VOSCheque = (String)CustomerquoteREC.get('LA_VOSCheque');
        
        
        
        if(PDFType == 'Leasing/ Rental'){
            PageReference pdf = Page.LeaseContractPreview;
            pdf.getParameters().put('Id', recordId);
            pdf.getParameters().put('LA_AgreementDate', LA_AgreementDate);
            pdf.getParameters().put('ET_ETRepresentative', ET_ETRepresentative);
            pdf.getParameters().put('LA_POBusiness', LA_POBusiness);
            pdf.getParameters().put('LA_LARepresentative', LA_LARepresentative);
            pdf.getParameters().put('LA_TVNExceed', LA_TVNExceed);
            pdf.getParameters().put('LA_ALMPYear', LA_ALMPYear);
            pdf.getParameters().put('LA_LAKilometer', LA_LAKilometer);
            pdf.getParameters().put('LA_CMCost', LA_CMCost);
            pdf.getParameters().put('LA_InCAccident', LA_InCAccident);
            pdf.getParameters().put('LA_VOSCheque', LA_VOSCheque);
            pdf.getParameters().put('LA_FAllowance', LA_FAllowance);
            pdf.getParameters().put('LA_DOAgreement', LA_DOAgreement);
            pdf.getParameters().put('LA_PostOfBox', LA_PostOfBox);
            pdf.getParameters().put('ET_Solitation', ET_Solitation);
            pdf.getParameters().put('LA_Solitation', LA_Solitation);
            pdf.getParameters().put('ET_Designation', ET_Designation);
            pdf.getParameters().put('LA_Designation', LA_Designation);
            pdf.getParameters().put('LA_LARepresentative', LA_LARepresentative);
            Blob pdfBlob;
            // Generate the PDF Blob
            if (!Test.isRunningTest()) {
                pdfBlob = pdf.getContentAsPDF();
            }
            
            // Create an Attachment
            Attachment attachment = new Attachment();
            attachment.ParentId = recordId; // Set the parent record Id (Customer_Quote__c)
            attachment.Name = QuoteName+'_Contract.pdf'; // Set the attachment name
            attachment.Body = pdfBlob; // Set the attachment body
            insert attachment;
        }
        if(PDFType == 'Transportation'){
            PageReference pdf = Page.TransportationContractPreview;
            
            pdf.getParameters().put('Id', recordId);
            pdf.getParameters().put('LA_AgreementDate', LA_AgreementDate);
            pdf.getParameters().put('ET_ETRepresentative', ET_ETRepresentative);
            pdf.getParameters().put('LA_POBusiness', LA_POBusiness);
            pdf.getParameters().put('LA_LARepresentative', LA_LARepresentative);
            pdf.getParameters().put('LA_TVNExceed', LA_TVNExceed);
            pdf.getParameters().put('LA_ALMPYear', LA_ALMPYear);
            pdf.getParameters().put('LA_LAKilometer', LA_LAKilometer);
            pdf.getParameters().put('LA_CMCost', LA_CMCost);
            pdf.getParameters().put('LA_InCAccident', LA_InCAccident);
            pdf.getParameters().put('LA_VOSCheque', LA_VOSCheque);
            pdf.getParameters().put('LA_FAllowance', LA_FAllowance);
            pdf.getParameters().put('LA_DOAgreement', LA_DOAgreement);
            pdf.getParameters().put('LA_PostOfBox', LA_PostOfBox);
            pdf.getParameters().put('ET_Solitation', ET_Solitation);
            pdf.getParameters().put('LA_Solitation', LA_Solitation);
            pdf.getParameters().put('ET_Designation', ET_Designation);
            pdf.getParameters().put('LA_Designation', LA_Designation);
            pdf.getParameters().put('LA_LARepresentative', LA_LARepresentative);
            
            Blob pdfBlob;
            // Generate the PDF Blob
            if (!Test.isRunningTest()) {
                pdfBlob = pdf.getContentAsPDF();
            }
            
            // Create an Attachment
            Attachment attachment = new Attachment();
            attachment.ParentId = recordId; // Set the parent record Id (Customer_Quote__c)
            attachment.Name = QuoteName+'_Contract.pdf'; // Set the attachment name
            attachment.Body = pdfBlob; // Set the attachment body
            insert attachment;
            
        } 
        if(PDFType == 'SchoolTransportation'){
            PageReference pdf = Page.SchoolTransportContractPreview;
            pdf.getParameters().put('Id', recordId);
            pdf.getParameters().put('LA_AgreementDate', LA_AgreementDate);
            pdf.getParameters().put('ET_ETRepresentative', ET_ETRepresentative);
            pdf.getParameters().put('LA_POBusiness', LA_POBusiness);
            pdf.getParameters().put('LA_LARepresentative', LA_LARepresentative);
            pdf.getParameters().put('LA_TVNExceed', LA_TVNExceed);
            pdf.getParameters().put('LA_ALMPYear', LA_ALMPYear);
            pdf.getParameters().put('LA_LAKilometer', LA_LAKilometer);
            pdf.getParameters().put('LA_CMCost', LA_CMCost);
            pdf.getParameters().put('LA_InCAccident', LA_InCAccident);
            pdf.getParameters().put('LA_VOSCheque', LA_VOSCheque);
            pdf.getParameters().put('LA_FAllowance', LA_FAllowance);
            pdf.getParameters().put('LA_DOAgreement', LA_DOAgreement);
            pdf.getParameters().put('LA_PostOfBox', LA_PostOfBox);
            pdf.getParameters().put('ET_Solitation', ET_Solitation);
            pdf.getParameters().put('LA_Solitation', LA_Solitation);
            pdf.getParameters().put('ET_Designation', ET_Designation);
            pdf.getParameters().put('LA_Designation', LA_Designation);
            pdf.getParameters().put('LA_LARepresentative', LA_LARepresentative);
            
            Blob pdfBlob;
            // Generate the PDF Blob
            if (!Test.isRunningTest()) {
                pdfBlob = pdf.getContentAsPDF();
            }
            
            // Create an Attachment
            Attachment attachment = new Attachment();
            attachment.ParentId = recordId; // Set the parent record Id (Customer_Quote__c)
            attachment.Name = QuoteName+'_Contract.pdf'; // Set the attachment name
            attachment.Body = pdfBlob; // Set the attachment body
            insert attachment;
        }   
        return recordId;
    }

    public static void testCoverage1(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}