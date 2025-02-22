public class ET_AddendumPDFPageController {
    
    // Properties
    public List<Article> contractDetails { get; set; }
    public List<Customer_Vehicle_Quote_Item__c> vehicleList { get; set; }
    public Date contractStartDate { get; set; }
    public Date contractEndDate { get; set; }
    public String etService { get; set; }
    public String licenseNumber { get; set; }
    public String accountName { get; set; }
    public String contractType { get; set; }
    public Decimal totalContractValue { get; set; }
    public static Decimal annualMileage { get; set; }
    public String recordId;
    private List<String> stringList = new List<String>();
 

    // Constructor
    public ET_AddendumPDFPageController(ApexPages.StandardController stdController) {
        recordId = stdController.getId();
        contractDetails = getContractClauses(recordId);
        processContractDetails();
    }
    
    // Method to process contract details
    private void processContractDetails() {
        Decimal sum = 0;
        
        // Fetch Addendum Record
        Addendum__c PDFH = [
            SELECT Id,Customer_Quote__r.RecordType__c, Sector__c, Approval_Status__c, Approval_Stage__c, All_Approval_Finished__c,
            Emirates_Transport_Representative__c, Company_s_Representative__c, ET_Designation__c,
            Customer_Designation__c, Salutation__c, Effective_Date__c, Agreement_Month_s__c,
            Minimum_Period__c, Customer_Salutation__c, Customer_Quote__c, Contract__c, P_O_Box__c,
            Account_Emirate__c, Trade_License__c, Addendum_Type__c,Starting_Date__c,Mobilization_Date__c
            FROM Addendum__c
            WHERE Id = :recordId
        ];
        
        if (PDFH.Customer_Quote__r.RecordType__c == 'Transportation') {
            List<Article> transcontractDetails = new List<Article>();
            for (Article a : contractDetails) {
                for (SubCaluse sc : a.subCaluses) {
                    if (sc.Description.contains('{!Addendum__c.Emirates_Transport_Representative__c}')) {
                        sc.Description = sc.Description.replace('{!Addendum__c.Emirates_Transport_Representative__c}', PDFH.Emirates_Transport_Representative__c);
                        sc.Description = sc.Description.replace('{!Addendum__c.ET_Designation__c}', PDFH.ET_Designation__c);
                        sc.Description = sc.Description.replace('{!Addendum__c.Customer_Quote__r.Account_Name__r.Name}', PDFH.Customer_Quote__r.Account_Name__r.Name);
                        sc.Description = sc.Description.replace('{!Addendum__c.P_O_Box__c}', PDFH.P_O_Box__c);
                        sc.Description = sc.Description.replace('{!Addendum__c.Company_s_Representative__c}', PDFH.Company_s_Representative__c);
                        sc.Description = sc.Description.replace('{!Licensenumber}', PDFH.Customer_Quote__r.Account_Name__r.ETSALES_Trade_License_Number__c);
                    }
                }
                transcontractDetails.add(a);
            }
            contractDetails = transcontractDetails;
        }
        
        // Fetch Vehicle Details
        vehicleList = [
            SELECT Id, Name, Remarks__c, Vehicle_Manufacture_Year__c, Number_of_Vehicles__c,
            ET_Total_Annual_Mileage__c, Service_Type__c, Total_Rate_All_Units__c,
            Extra_Miles__c, Vehicle_Source__c, Vehicle_Monthly_Price__c,
            Total_Annual_Price_Target_Prices__c, Monthly_Rate_with_VAT__c,
            Vehicle_Monthly_Cost__c, Monthly_Rate_All_Unit_with_VAT__c
            FROM Customer_Vehicle_Quote_Item__c
            WHERE Customer_Quote__c = :PDFH.Customer_Quote__c
            AND Name NOT IN ('Label Row', 'CheckBox Row')
            ORDER BY CreatedDate
        ];
        
        for (Customer_Vehicle_Quote_Item__c vehicle : vehicleList) {
            if (vehicle.Monthly_Rate_All_Unit_with_VAT__c != null) {
                sum += vehicle.Monthly_Rate_All_Unit_with_VAT__c;
            }
        }
        
        totalContractValue = sum;
        annualMileage = vehicleList.isEmpty() ? 0 : vehicleList[0].ET_Total_Annual_Mileage__c;
        
        Opportunity opportunity = [
            SELECT Id, Name, ETSALES_GL_Services__c, Account.Name,
            Account.ETSALES_Trade_License_Number__c, Contract_Start_Date__c, Contract_End_Date__c
            FROM Opportunity
            WHERE Id = :[
                SELECT Opportunity_Name__r.Id FROM Customer_Quote__c WHERE Id = :PDFH.Customer_Quote__c
            ].Opportunity_Name__r.Id
        ];
        
        etService = opportunity.ETSALES_GL_Services__c;
        licenseNumber = opportunity.Account.ETSALES_Trade_License_Number__c;
        accountName = opportunity.Account.Name;
        contractStartDate = opportunity.Contract_Start_Date__c;
        contractEndDate = opportunity.Contract_End_Date__c;
        
        Customer_Quote__c customerQuote = [
            SELECT Contract_Type__c
            FROM Customer_Quote__c
            WHERE Id = :PDFH.Customer_Quote__c
        ];
        
        contractType = customerQuote.Contract_Type__c == 'Yearly' ? 'year(s)' : 'month(s)';
    }
    
    // Method to get contract clauses
    public static List<Article> getContractClauses(String recordId) {
        List<Contract_Master__c> allArticlesDetail = [
            SELECT Id, Name, Description__c, Line_No__c,
            (SELECT Id, Name, Description__c, Editable__c, Delete__c, Line_No__c, Referenced_Article__r.Description__c
             FROM Contract_Lines__r WHERE Delete__c = false ORDER BY Line_No__c)
            FROM Contract_Master__c
            WHERE Addendum__c = :recordId
            ORDER BY Line_No__c
        ];
        System.debug(allArticlesDetail);
        return buildContractArray(allArticlesDetail);
    }
    
    // Helper method to build contract array
    public static List<Article> buildContractArray(List<Contract_Master__c> allArticlesDetail) {
        List<Article> articlesDetail = new List<Article>();
        for (Contract_Master__c contractMaster : allArticlesDetail) {
            Article article = new Article();
            article.Id = contractMaster.Id;
            article.Name = contractMaster.Name;
            article.Description = contractMaster.Description__c;
            article.articleLineNo = contractMaster.Line_No__c;
            
            List<SubCaluse> subCaluses = new List<SubCaluse>();
            for (Contract_Line__c contractLine : contractMaster.Contract_Lines__r) {
                SubCaluse subCaluse = new SubCaluse();
                subCaluse.Id = contractLine.Id;
                subCaluse.Name = contractLine.Name;
                subCaluse.Description = contractLine.Description__c;
                subCaluse.SubClauseNo = contractLine.Line_No__c;
                subCaluse.isEditable = contractLine.Editable__c;
                subCaluse.isDeleteAble = contractLine.Delete__c;
                subCaluse.refArticleDescription = contractLine.Referenced_Article__r.Description__c;
                subCaluses.add(subCaluse);
            }
            
            if (!subCaluses.isEmpty()) {
                article.subCaluses = subCaluses;
                articlesDetail.add(article);
            }
        }
        System.debug(articlesDetail);
        return articlesDetail;
    }
    
    // Inner classes
    public class Article {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String Description { get; set; }
        @AuraEnabled public Decimal articleLineNo { get; set; }
        @AuraEnabled public List<SubCaluse> subCaluses { get; set; }
    }
    
    public class SubCaluse {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String Description { get; set; }
        @AuraEnabled public Decimal SubClauseNo { get; set; }
        @AuraEnabled public Boolean isEditable { get; set; }
        @AuraEnabled public Boolean isDeleteAble { get; set; }
        @AuraEnabled public String refArticleDescription { get; set; }
    }
   
    
    
    
    @AuraEnabled
    public static string generateQuoteDoc(string RecId, String PDFAddendumType){
        system.debug(PDFAddendumType);
        List<Addendum__c>  cusQuote =[select Id, Name,Customer_Quote__r.Name from Addendum__c where Id =:RecId];
        String CusQuoteName = cusQuote[0].Customer_Quote__r.Name;
        String VFpageName;
        PageReference pdf;
        if(PDFAddendumType == 'Renewal'){
            VFpageName ='ET_AddendumPDFPage';
            pdf =  Page.ET_AddendumPDFPage;
        }else if(PDFAddendumType == 'Additional'){
            VFpageName ='ET_AddendumPDFPageAdditional';
            pdf =  Page.ET_AddendumPDFPageAdditional;
        }else if(PDFAddendumType == 'Extension'){
            VFpageName ='ET_AddendumPDFPageExtension';
            pdf =  Page.ET_AddendumPDFPageExtension;
        }
        system.debug(pdf);
        pdf.getParameters().put('Id',RecId);
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
            conVer.Title = 'Addendum_'+CusQuoteName+ '_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
            conVer.VersionData = pdfBlob;
            insert conVer;  
            
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            
            ContentDocumentLink conDocLink = new ContentDocumentLink();
            conDocLink.LinkedEntityId = RecId; //parentId
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            insert conDocLink;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
        return RecId;
        
    }
    public class CustomException extends Exception {}
    
}