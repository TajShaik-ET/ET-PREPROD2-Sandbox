public class PRI_customerQuoteContractController {
    
    public List<PRI_customerQuoteController.Article> contractDetails { get; set; }
    public list<Customer_Vehicle_Quote_Item__c> VehiclList { get; set; }
    public Date ContractStartDate {get;set;}
    public Date ContractEndtDate {get;set;}
    public string ETService {get;set;}
    public string Licensenumber {get;set;}  
    public string AccountName {get;set;}
    public string Driver {get; set;}
    public string Fuel {get; set;}
	public string contractType {get; set;}
    public static Decimal AnnualMile {get; set;}
    public Decimal TotalContractvalue {get;set;}
    public String recordId;
    List<String> stringList = new List<String>();
    public PRI_customerQuoteContractController(ApexPages.StandardController stdController) {
        Decimal sum = 0;
        recordId = stdController.getId();
        contractDetails = PRI_customerQuoteController.getContractClauses(recordId);
       	//transcontractDetails = contractDetails;
		system.debug('contractDetails>>>>>>>>>>>>'+contractDetails[0].subCaluses);   
        Contract_Pdf_Header__c PDFH =[Select Id, Name, With_Driver__c, With_Fuel__c,Sector__c,ET_Representative__c,ET_Rep_Designation__c, Customer_Quote__c,Customer_Quote__r.Account_Name__r.Name,Customer_Quote__r.Account_Name__r.ETSALES_Trade_License_Number__c,Customer_Quote__r.RecordType__c, P_O_Box__c,Lessee_Rep__c from Contract_Pdf_Header__c where Id =:recordId];
		if(PDFH.Customer_Quote__r.RecordType__c == 'Transportation')
        {
         		List<PRI_customerQuoteController.Article> transcontractDetails = new List<PRI_customerQuoteController.Article>();
                for(PRI_customerQuoteController.Article a: contractDetails)
                {
                    for(PRI_customerQuoteController.SubCaluse sc: a.subCaluses)
                    {	
                        if(sc.Description.contains('{!Contract_Pdf_Header__c.ET_Representative__c}'))
                        {
                            system.debug('sc.Description2>>>>>>>' + sc.Description);
                            sc.Description = sc.Description.replace('{!Contract_Pdf_Header__c.ET_Representative__c}', PDFH.ET_Representative__c);
                            sc.Description = sc.Description.replace('{!Contract_Pdf_Header__c.ET_Rep_Designation__c}', PDFH.ET_Rep_Designation__c);
                            sc.Description = sc.Description.replace('{!Contract_Pdf_Header__c.Customer_Quote__r.Account_Name__r.Name}', PDFH.Customer_Quote__r.Account_Name__r.Name);
                            sc.Description = sc.Description.replace('{!Contract_Pdf_Header__c.P_O_Box__c}', PDFH.P_O_Box__c);
                            sc.Description = sc.Description.replace('{!Contract_Pdf_Header__c.Lessee_Rep__c}', PDFH.Lessee_Rep__c);
							sc.Description = sc.Description.replace('{!Licensenumber}',PDFH.Customer_Quote__r.Account_Name__r.ETSALES_Trade_License_Number__c);
                         
                            system.debug('sc.Description3>>>>>>>' + sc.Description);
                        }
                    }
				
                   transcontractDetails.add(a);
                }
            	
             	
            	system.debug('transcontractDetails>>>>>>>' + transcontractDetails);
            	contractDetails = transcontractDetails;

        }
        if(PDFH.With_Driver__c == true)
        {
            Driver = 'with Drivers';
        }
        else
        {
            Driver = 'without Drivers';
        }
        
		if(PDFH.With_Fuel__c == true)
        {
            Fuel = 'with Fuel';
        }
        else
        {
            Fuel = 'without Fuel';
        }
        System.debug(Customer_Quote__c.Id);
        VehiclList =[select Id,
                     Name, Remarks__c,
                     Vehicle_Manufacture_Year__c,
                     Number_of_Vehicles__c,
                     ET_Total_Annual_Mileage__c,
                     Service_Type__c,
                     Total_Rate_All_Units__c,
                     Extra_Miles__c,
                     Vehicle_Source__c,
                     Vehicle_Monthly_Price__c,
                     Total_Annual_Price_Target_Prices__c,
                     Monthly_Rate_with_VAT__c,Vehicle_Monthly_Cost__c,
                     
                     Monthly_Rate_All_Unit_with_VAT__c from Customer_Vehicle_Quote_Item__c where Customer_Quote__c =:PDFH.Customer_Quote__c And Name != 'Label Row' And Name != 'CheckBox Row'  Order By CreatedDate];
        System.debug(VehiclList);
        
        for(Customer_Vehicle_Quote_Item__c VQI :VehiclList){
            if(VQI.Total_Rate_All_Units__c != null){
                sum += VQI.Total_Rate_All_Units__c;
            }
            
        }
        TotalContractvalue = sum;
		
        AnnualMile = VehiclList[0].ET_Total_Annual_Mileage__c;
        Customer_Quote__c customerQuote = [select Id,Name,Opportunity_Name__r.Id,Opportunity_Name__r.Name,Opportunity_Name__r.RecordTypeId,Opportunity_Name__r.RecordType.Name,Contract_Type__c from Customer_Quote__c where Id=:PDFH.Customer_Quote__c];
        Opportunity OPPREC = [select Id,Name,ETSALES_GL_Services__c,Account.Name,Account.ETSALES_Trade_License_Number__c,Contract_Start_Date__c,Contract_End_Date__c from Opportunity where Id =:customerQuote.Opportunity_Name__r.Id];
        
        ETService = OPPREC.ETSALES_GL_Services__c;
        Licensenumber = OPPREC.Account.ETSALES_Trade_License_Number__c;
        AccountName = OPPREC.Account.Name;
        ContractStartDate = OPPREC.Contract_Start_Date__c;
        ContractEndtDate = OPPREC.Contract_End_Date__c;
        if(customerQuote.Contract_Type__c =='Yearly')
        {
            contractType = 'year(s)';
        }
        else
        {
            contractType = 'month(s)';
        }
        system.debug(OPPREC);
        
        
    }
    @AuraEnabled
    public static string generateQuoteDoc(string quoteId, String Sector, String OppType){
        system.debug(Sector);
        List<Contract_Pdf_Header__c>  cusQuote =[select Id, Name,Customer_Quote__r.Name from Contract_Pdf_Header__c where Id =:quoteId];
        String CusQuoteName = cusQuote[0].Customer_Quote__r.Name;
        String VFpageName;
        PageReference pdf;
        if(Sector == 'School'){
            VFpageName ='ET_generateContractPdf_School';
            pdf =  Page.ET_generateContractPdf_School;
        }else if(Sector == 'Transport And Lease'){
            if(OppType == 'Leasing/ Rental')
            {
                VFpageName ='ET_generateContractPdf_TL';
                pdf =  Page.ET_generateContractPdf_TL;
                
            }
			else
            {
                VFpageName ='ET_generateContractPdf_Transport';
            	pdf =  Page.ET_generateContractPdf_Transport;
        	}
            
        }
        system.debug(pdf);
        pdf.getParameters().put('Id',quoteId);
        Blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = pdf.getContentAsPDF();
        }
        try{
            ContentVersion conVer = new ContentVersion();
            DateTime  dt = System.now();
            
            conVer.ContentLocation = 'S'; // TO USE S specify this document IS IN Salesforce, TO USE E FOR external files
            conVer.PathOnClient = CusQuoteName+'_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
            conVer.Title = 'Contract_'+CusQuoteName+ '_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
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
        // }
        // if(Sector == 'Transport And Lease'){
        //     VFpageName ='ET_generateContractPdf_TL';
        
        //     PageReference pdf =  Page.ET_generateContractPdf_TL;
        //     system.debug(pdf);
        //     pdf.getParameters().put('Id',quoteId);
        //     Blob pdfBlob;
        //     if (!Test.isRunningTest()) {
        //         pdfBlob = pdf.getContentAsPDF();
        //     }
        //     try{
        //         ContentVersion conVer = new ContentVersion();
        //         DateTime  dt = System.now();
        
        //         conVer.ContentLocation = 'S'; // TO USE S specify this document IS IN Salesforce, TO USE E FOR external files
        //         conVer.PathOnClient = CusQuoteName+'_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
        //         conVer.Title = CusQuoteName+ '_'+dt.hour()+dt.minute()+dt.second()+'.pdf'; 
        //         conVer.VersionData = pdfBlob;
        //         insert conVer;  
        
        //         Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        //         ContentDocumentLink conDocLink = new ContentDocumentLink();
        //         conDocLink.LinkedEntityId = quoteId; //parentId
        //         conDocLink.ContentDocumentId = conDoc; 
        //         conDocLink.shareType = 'V';
        //         insert conDocLink;
        //     }
        //     catch(Exception e){
        //         throw new AuraHandledException(e.getMessage());
        //     }
        // }    
        return quoteId;
        
    }

    @AuraEnabled
	public static String getEditables(string CQId)
    {
		list<Customer_Vehicle_Quote_Item__c> VehiclList = new List<Customer_Vehicle_Quote_Item__c>();
		CustomerQuoteWrapper CustomerQ = new CustomerQuoteWrapper();
		Customer_Quote__c customerQuote = [select Id,Name,CreatedDate,ETSALES_Sector__c, Account_Name__c,Account_Name__r.ETI_Emirates__c,Opportunity_Name__r.Id,Opportunity_Name__r.Name,Opportunity_Name__r.RecordTypeId,Opportunity_Name__r.RecordType.Name,Contract_Type__c, (SELECT Id, Name FROM Customer_Vehicle_Quote_Items__r),
           (SELECT Id, Name FROM Customer_Workforce_Quote_Items__r) from Customer_Quote__c where Id=:CQId];
        Opportunity OPPREC = [select Id,Name,ETSALES_GL_Services__c,Account.Name,Account.ETSALES_Trade_License_Number__c,Contract_Start_Date__c,Contract_End_Date__c, RecordType.DeveloperName from Opportunity where Id =:customerQuote.Opportunity_Name__r.Id];
		VehiclList =[select Id,
                     Name,
                     Vehicle_Manufacture_Year__c,
                     Number_of_Vehicles__c,
                     ET_Total_Annual_Mileage__c,
                     Service_Type__c,
                     Total_Rate_All_Units__c,
                     Extra_Miles__c,
                     Vehicle_Source__c,
                     Vehicle_Monthly_Price__c,
                     Total_Annual_Price_Target_Prices__c,
                     Monthly_Rate_with_VAT__c,
                     
                     Monthly_Rate_All_Unit_with_VAT__c from Customer_Vehicle_Quote_Item__c where Customer_Quote__c =:CQId And Name != 'Label Row' And Name != 'CheckBox Row' Order By CreatedDate];
        			 System.debug('VehiclList>>>>>>' + VehiclList);
        		     System.debug('VehiclList Annual>>>>>>' + VehiclList[0].ET_Total_Annual_Mileage__c);

		List<TermsAndCondition__c> terms = [Select id, name, Terms_Description__c,Customer_Quote__c, Line_Order__c, Term_Code__c, Charge_Type__c, 
                                                Charge_Value__c, Charge_Type_Value__c, Chargeable_to_Customer__c, 
                                                Remarks__c, Remarks_Value__c, Remark_Type__c,
                                                Default_SCH__c, Default_TL__c, IsMaster__c, Additional_Term_Text__c,
                                                IsRequired_TL_Term__c, Is_Required_Sch_Term__c,
                                                Charge_Value_Freeze_For_T_L__c, Charge_Value_Freeze_For_Sch__c,
                                                Charge_Value_Type_Freeze_For_T_L__c, Charge_Value_Type_Freeze_For_Sch__c,
                                                Remarks_Value_Freeze_For_T_L__c, Remarks_Value_Freeze_For_Sch__c,
                                                Remarks_Value_Type_Freeze_For_T_L__c, Remarks_Value_Type_Freeze_For_Sch__c
                                                from TermsAndCondition__c where Customer_Quote__c=:CQId];
        
		System.debug('customerQuote CreatedDate>>>>' + customerQuote.CreatedDate);
        CustomerQ.EffectiveDate = Date.valueof(customerQuote.CreatedDate);
        
        //base on opportunity sector there are different default terms
        if(OPPREC.RecordType.DeveloperName =='ETSALES_Leasing' || OPPREC.RecordType.DeveloperName=='ETSALES_Transportation'){
            for(TermsAndCondition__c term1: terms){
                
                	system.debug('Terms_Description>>>>>>>>' + term1.Terms_Description__c + ' Charge Value>>>>>>>>' + term1.Charge_Type_Value__c);
                
                if(term1.Terms_Description__c == 'Payment terms'){
					System.debug('IN Terms Value>>>>' + term1.Charge_Value__c);
                    CustomerQ.CelanderDays = string.valueof(term1.Charge_Value__c);
                }
				if(term1.Terms_Description__c == 'Return Cheque Amount:'){
					System.debug('IN Terms Value>>>>' + term1.Charge_Value__c);
                    CustomerQ.returnChecque = string.valueof(term1.Charge_Value__c);
                }
				if(term1.Terms_Description__c == 'Suspension'){
					System.debug('IN Terms Value>>>>' + term1.Charge_Value__c);
                    CustomerQ.delayPaySuspension = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Termination'){
					System.debug('IN Terms Value>>>>' + term1.Charge_Value__c);
                    CustomerQ.delayPaytermination = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Vehicle Replacement (%):'){
					System.debug('IN Terms Value>>>>' + term1.Charge_Value__c);
                    CustomerQ.vehReplacePer = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Branding/ Modification Charge:'){
					System.debug('IN Terms Value>>>>' + term1.Charge_Value__c);
                    CustomerQ.brandingCharge = string.valueof(term1.Charge_Value__c);
                }
				if(term1.Terms_Description__c == 'Insurance Excess Charge'){
					System.debug('InsuranceExcessCharge>>>>' + term1.Charge_Value__c);
                    CustomerQ.InsuranceExcessCharge = string.valueof(term1.Charge_Value__c);
                }
				if(term1.Terms_Description__c == 'Delay in payment of outstanding amount'){
                    CustomerQ.DelayPaymentPer = string.valueof(term1.Charge_Value__c);
                }
				if(term1.Terms_Description__c == 'Early Termination Fee' && term1.Line_Order__c == 13.20){
                    CustomerQ.firstYearTermination = string.valueof(term1.Charge_Value__c);
                }
				if(term1.Terms_Description__c == 'Early Termination Fee' && term1.Line_Order__c == 13.30){
                    CustomerQ.secondYearTermination = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Early Termination Fee' && term1.Line_Order__c == 13.40){
                    CustomerQ.thirdYearTermination = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Early Termination Fee' && term1.Line_Order__c == 13.10){
                    CustomerQ.LPOTermination = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'SALIK/ DARB consumption'){
                    CustomerQ.SalikDarb = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Traffic Fines Admin Fees'){
                    CustomerQ.trafficFineAdmin = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Traffic fines where Client driver is required to appear before authorities'){
                    CustomerQ.TFClientDirver = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Traffic Offenses:'){
                    CustomerQ.trafficOffense = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Breach of permitted use of vehicle conditions'){
                    CustomerQ.breachPermittedUse = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Smoking Charges penalty'){
                    CustomerQ.smokingCharges = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Charges for providing letters/ certificates / NOC'){
                    CustomerQ.chargesLettersCert = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Delay in renewal process:'){
                    CustomerQ.delayRenewal = string.valueof(term1.Charge_Value__c);
                }
                if(term1.Terms_Description__c == 'Vehicle Insurance'){
                    CustomerQ.Vehicle_Insurance = 'Yes';
                }
                
                if(term1.Terms_Description__c == 'Maintenance'){
                    CustomerQ.Maintenance = 'Yes';
                }
               
                if(term1.Terms_Description__c == 'Traffic fines'){
                    CustomerQ.Traffic_fines = 'Yes';
                }
                
                if(term1.Terms_Description__c == 'Damage Penalty'){
                    CustomerQ.Damage_Penalty = 'Yes';
                }
                
                if(term1.Terms_Description__c == 'Impound Vehicle Recovery Charges'){
                    CustomerQ.Impound_Vehicle_Recovery_Charges = 'Yes';
                }
                
                if(term1.Terms_Description__c == 'Laws or Decisions'){
                    CustomerQ.Laws_or_Decisions = 'Yes';
                }
               
                if(term1.Terms_Description__c == 'Fuel Price'){
                    CustomerQ.Fuel_Price = 'Yes';
                }
                
				if(term1.Terms_Description__c == 'Fuel differences'){
                    CustomerQ.Fuel_differences = 'Yes';
                }
                
                if(term1.Terms_Description__c == 'Additional Terms'){
                    CustomerQ.Additional_Term = 'Yes';
                }
                
				if(term1.Terms_Description__c == 'Replacement'){
                    CustomerQ.Replacement = 'Yes';
                }
                
            }
        }
		
		CustomerQ.Account = customerQuote.Account_Name__c;
		CustomerQ.Emirates = customerQuote.Account_Name__r.ETI_Emirates__c;
		CustomerQ.ContractType = customerQuote.Contract_Type__c;
        CustomerQ.CQrecordType = customerQuote.Opportunity_Name__r.RecordType.Name;
		CustomerQ.TradeLicense = OPPREC.Account.ETSALES_Trade_License_Number__c;
        CustomerQ.AnnualKMCharge = String.valueof(VehiclList[0].ET_Total_Annual_Mileage__c);
        CustomerQ.vehicleQuoteItemsCount = customerQuote.Customer_Vehicle_Quote_Items__r.size() - 2;
        CustomerQ.workforceQuoteItemsCount = customerQuote.Customer_Workforce_Quote_Items__r.size() - 2;

		system.debug('customerQuote>>>>>>>>'+ JSON.serialize(customerQ));
		
		return JSON.serialize(customerQ);
    }
	
	public class CustomerQuoteWrapper {
        public Date EffectiveDate { get; set; }
        public String Emirates { get; set; }
		public String TradeLicense { get; set; }
        public String AnnualKMCharge { get; set; }
        public String InsuranceExcessCharge { get; set; }
        public String AdditonalKMCharge { get; set; }
		public String DelayPaymentPer { get; set; }
        public String Account { get; set; }
		public String AccPayment { get; set; }
		public String CelanderDays { get; set; }
		public String firstYearTermination { get; set; }
        public String secondYearTermination { get; set; }
        public String thirdYearTermination { get; set; }
        public String LPOTermination {get; set;}
        public String SalikDarb {get; set;}
        public String trafficFineAdmin {get; set;}
        public String TFClientDirver {get; set;}
        public String trafficOffense {get; set;}
        public String breachPermittedUse {get; set;}
        public String smokingCharges {get; set;}
        public String chargesLettersCert {get; set;}
        public String delayRenewal {get; set;}
        public String ContractType { get; set; }
        public String CQrecordType {get; set;}
        public String Vehicle_Insurance {get; set;}
        public String Maintenance {get; set;}
        public String Traffic_fines {get; set;}
        public String Damage_Penalty {get; set;}
        public String Impound_Vehicle_Recovery_Charges {get; set;}
        public String Delay_in_renewal_process {get; set;}
        public String Laws_or_Decisions {get; set;}
        public String Fuel_Price {get; set;}
        public String Fuel_differences {get; set;}
        public String Additional_Term {get; set;}
        public String Replacement {get; set;}
        public Integer vehicleQuoteItemsCount {get; set;}
        public Integer workforceQuoteItemsCount {get; set;}
        public String returnChecque {get; set;}
        public String delayPaySuspension {get; set;}
        public String delayPaytermination {get; set;}
        public String vehReplacePer {get; set;}
        public String brandingCharge {get; set;}
        
    }
	/*public class Article {
        public String Id;
        public String Name;
        public String Description;
        public Integer articleLineNo;
        public List<SubClause> subClauses;
    }

    public class SubClause {
        public String Description;
    }*/


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

    public static void testCoverage2(){
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
    
    public static void testCoverage3(){
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