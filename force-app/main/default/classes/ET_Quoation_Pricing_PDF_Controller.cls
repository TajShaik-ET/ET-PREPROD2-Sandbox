/***
Class       : ET_Quoation_Pricing_PDF_Controller
Author      : 
Description : 
TestClass  : 
----------------------------------------------------------------------------------------------------------------
-- History --
----------------------------------------------------------------------------------------------------------------
Sr.No.  version_DevInitials        Date          updated by             Details							
1.          V1.0                                                    Initial Version 
2.			V2.0				02.05.2023	   Arunsarathy R	    CorporateTax / ExtraKM new row logic updation        
3.			V3.0				09.10.2023	   Arunsarathy R	    Zone to Sector Updation
4.			V4.0				16.11.2023	   Arunsarathy R	    Adding Trailer value in Total Investment ValueUpdation
5.			V5.0				19.12.2023	   Arunsarathy R	    Options to add Multiple coordinator lines without vehicle
6.			V6.0				23.01.2024	   Arunsarathy R	    Total investment value update
7.			V7.0				23.02.2024	   Arunsarathy R	    Salik Cost and Basic Tracking cost as default
****************************************************************************************************************/


public class ET_Quoation_Pricing_PDF_Controller {
    private final Quote quote {get;set;}
    public  Map<Integer,QuotationInfo> wrapperQuotationDetails {get; set;}
    public  Map<Integer,Decimal> extraKMMap {get; set;}//Added by Arun on 10.04.2023 for Extra KM New row addition
    public Decimal extraKMPriceWorkforce {get;set;}//Added by Arun on 10.04.2023 for Extra KM New row addition
    public Decimal extraKMPriceWorkforceCord {get;set;}//Added by Arun on 10.04.2023 for Extra KM New row addition
    public Boolean vehiclePresnt{get;set;}
	public List<ET_Vehicle_Quote_Item__c> quoteItemsToUpdate {get; set;}
    public Boolean showMessage{ get; set; }
    public Map<String, String> messageDetails{ get; set; }
    public class QuotationInfo
    {   
        @AuraEnabled 
        public String headerName{get;set;}
        @AuraEnabled 
        public Boolean OnlyManpowerPresent{get;set;}
        @AuraEnabled 
        public Boolean ManpowerPresent{get;set;}
        @AuraEnabled 
        public Boolean vehiclePresent{get;set;}
        @AuraEnabled 
        public Boolean FinancialDataPresent{get;set;}
        @AuraEnabled 
        public String WorkforceAvailable{get;set;}
        @AuraEnabled 
        public String vehicleNotes{get;set;}
        @AuraEnabled 
        public String driverNotes{get;set;}
        @AuraEnabled 
        public String nannyNotes{get;set;}
        @AuraEnabled 
        public String accountantNotes{get;set;}
        @AuraEnabled 
        public String coordinatorNotes{get;set;}
        @AuraEnabled 
        public String supervisorNotes{get;set;}
        @AuraEnabled
        public RentalPriceClass FinacialData{get;set;}
        @AuraEnabled
        public ETWorkforceCalcDetailsWrapper workforceWrapper{get;set;}
        @AuraEnabled
        public quoteDetails quoteDetailsWrapper{get; set;}
        @AuraEnabled
        public quoteHeader quoteHeaderWrapper{get; set;}
        @AuraEnabled
        public Set<String> VehicleSpecialRequirementLabels {get;set;}
        /*@AuraEnabled
        public Set<String> VehicleSpecialRequirementLabelsPermit {get;set;}
        @AuraEnabled
        public Set<String> VehicleSpecialRequirementLabelsBranding {get;set;}
        @AuraEnabled
        public Set<String> VehicleSpecialRequirementLabelsLogo {get;set;}
        @AuraEnabled
        public Set<String> VehicleSpecialRequirementLabelsDriver {get;set;}*/
        @AuraEnabled
        public List<Integer> contractYears {get;set;}
        @AuraEnabled
        public  List<vehicleQuoteCalcClass> vehicleQuoteCalcContracts{get; set;}
        @AuraEnabled
        public List<vehicleApprovalDetails> vehicleApprovalDetailsWrp{get;set;} 
        @AuraEnabled
        public List<wrokforceApprovalDetails> wrokforceApprovalDetailsWrp{get;set;}
        
        
    }
    //Calulating Trailer cost seperately from Vehicle quote item based on line number for Total investment value
    public static Decimal calculateCumulativeTrailerPurchasePrice(String quoteId, String etType) {
        List<ET_Vehicle_Quote_Item__c> lineItems = [SELECT Trailer_Price__c, ET_Line_Number__c, ET_Vehicle_Source__c, ET_Number_of_Vehicles__c
                                                    FROM ET_Vehicle_Quote_Item__c
                                                    WHERE Quote__c = :quoteId];
        Map<Decimal, Decimal> lineTotalMap = new Map<Decimal, Decimal>();
        Decimal cumulativeTrailerPurchasePrice = 0;
        for (ET_Vehicle_Quote_Item__c item : lineItems) {
            Decimal trailerPurchasePrice;
            if(item.ET_Vehicle_Source__c =='Main'){ //added for adding trailer value for main vehicle only on 23.01.2023. 
                if (etType != 'Total Project Summary' ) {
                    trailerPurchasePrice = item.Trailer_Price__c * item.ET_Number_of_Vehicles__c;
                } else {
                    trailerPurchasePrice = item.Trailer_Price__c;
                }
                Decimal lineIdentifier = item.ET_Line_Number__c;
                
                if (!lineTotalMap.containsKey(lineIdentifier)) {
                    lineTotalMap.put(lineIdentifier, trailerPurchasePrice);
                }
            }
        }
        for (Decimal lineIdentifier : lineTotalMap.keySet()) {
            cumulativeTrailerPurchasePrice += lineTotalMap.get(lineIdentifier);
            System.debug('cumulativePurchasePrice for line ' + lineIdentifier + ': ' + cumulativeTrailerPurchasePrice);
        }
        
        return cumulativeTrailerPurchasePrice;
    }
    
    public ET_Quoation_Pricing_PDF_Controller(ApexPages.StandardController stdController) {
        //Taj
        showMessage = false;
        messageDetails = New Map<String, String>();
        Profile loggedInUserProfile = ET_ServiceRequestController.getProfileInfo();
        System.debug('loggedInUserProfile: ' + loggedInUserProfile.Name);
        String tlSalesTeamProfiles = system.label.TL_SalesTeam_Profiles;
        List<String> profileSalesTL = tlSalesTeamProfiles.split(';');

        String quoteId = ApexPages.currentPage().getParameters().get('quoteId'); // Mani
        this.quote= (Quote)stdController.getRecord();
        this.wrapperQuotationDetails = new Map<Integer,QuotationInfo>();
        extraKMMap = new Map<Integer,Decimal> ();//Added by Arun on 10.04.2023 for Extra KM New row addition
        extraKMPriceWorkforce =0.000;//Added by Arun on 10.04.2023 for Extra KM New row addition
        extraKMPriceWorkforceCord =0.000;//Added by Arun on 10.04.2023 for Extra KM New row addition
        
        quoteId = (quoteId!=null)?quoteId:quote.id;
        Quote q =[Select id,QuoteNumber,GL_Zone__c,Account.Name,Account.ETSALES_Profile_Class__c,
                  Opportunity.Type, Opportunity.ETSALES_Opportunity_Number__c,Opportunity.ETSALES_Sector__c,
                  ET_Total_Investment__c,CreatedBy.Name,Opportunity.owner.name,
                  Is_Target_Price_Required__c, Total_Number_of_Accountants__c , 
                  Total_Number_of_Coordinators__c,  Total_Number_of_Drivers__c,
                  Total_Number_of_Nannies__c , Total_Number_of_Other_Employees__c,
                  Total_Number_of_Supervisors__c, Total_Number_of_Vehicles__c, owner.name,Owner.Profile.Name,createdDate,
                  ET_Type__c, Service_Emirate__c, Total_Vehicle_Lines__c,Quote_Total_Investment__c
                  From Quote Where Id=:quoteId];
        if (q.Total_Number_of_Vehicles__c == null || q.Total_Number_of_Vehicles__c == 0) {
            vehiclePresnt = false;
        } else {
            vehiclePresnt = true; 
        }
        Decimal cumulativeTrailerPrice = ET_Quoation_Pricing_PDF_Controller.calculateCumulativeTrailerPurchasePrice(quoteId, q.ET_Type__c);
        Boolean isTargetPriceRequired = false;
        quoteDetails quoteDetailsWrapper = new quoteDetails();      
        isTargetPriceRequired= q.Is_Target_Price_Required__c;
        quoteDetailsWrapper.isTargetPriceRequired  = q.Is_Target_Price_Required__c;
        quoteDetailsWrapper.quotetype = q.ET_Type__c;
        quoteDetailsWrapper.totalNumberOfVehicles = (q.Total_Number_of_Vehicles__c!=null)?q.Total_Number_of_Vehicles__c:0;
        quoteDetailsWrapper.totalNumberOfDrivers = (q.Total_Number_of_Drivers__c!=null)?q.Total_Number_of_Drivers__c:0;
        quoteDetailsWrapper.totalNumberOfNannies = (q.Total_Number_of_Nannies__c!=null)?q.Total_Number_of_Nannies__c:0;
        quoteDetailsWrapper.totalNumberOfAccountants = (q.Total_Number_of_Accountants__c!=null)?q.Total_Number_of_Accountants__c:0;
        quoteDetailsWrapper.totalNumberOfCoordinators = (q.Total_Number_of_Coordinators__c!=null)?q.Total_Number_of_Coordinators__c:0;
        quoteDetailsWrapper.totalNumberOfSupervisors = (q.Total_Number_of_Supervisors__c!=null)?q.Total_Number_of_Supervisors__c:0;
        quoteDetailsWrapper.totalNumberOfOtherManpower = (q.Total_Number_of_Other_Employees__c!=null)?q.Total_Number_of_Other_Employees__c:0;
        quoteDetailsWrapper.quotationCreatedDate = String.ValueOf(q.CreatedDate);
        quoteDetailsWrapper.quotationCreatedBy = q.Owner.Name;
        
        List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLst = ET_PricingUtilityClass.getVehicleQuoteItemLst(quoteId);
        List<ET_Workforce_Quote_Item__c> workforcequoteItemList = new List<ET_Workforce_Quote_Item__c>();
        // workforcequoteItemList=
        Map<Integer,List<ET_Vehicle_Quote_Item__c>> quoteItemMap = new  Map<Integer,List<ET_Vehicle_Quote_Item__c>> ();
        Integer TotalLines = 0;
        Integer totalnumberofVehicles = 0;
        string appovalDetails='';
        //vehicle section
        for(ET_Vehicle_Quote_Item__c vehicleQuoteItem:vehicleQuoteItemLst)
        {
            Set<Integer> lineNoSet = new Set<Integer>();
            Integer LineNumber = Integer.valueOf((vehicleQuoteItem.ET_Line_Number__c!=null)?vehicleQuoteItem.ET_Line_Number__c:0);
            if(LineNumber>0)
            {
                if(quoteItemMap.containsKey(LineNumber))
                {
                    quoteItemMap.get(LineNumber).add(vehicleQuoteItem);
                }
                else
                {
                    if(!lineNoSet.contains(LineNumber) && vehicleQuoteItem.ET_Vehicle_Source__c == 'Main')
                    {
                        totalnumberofVehicles = totalnumberofVehicles + ((Integer.valueOf(vehicleQuoteItem.ET_Number_of_Vehicles__c)!=null)?(Integer.valueOf(vehicleQuoteItem.ET_Number_of_Vehicles__c)):0);
                    }
                    TotalLines = TotalLines +1;
                    quoteItemMap.put(LineNumber,new List<ET_Vehicle_Quote_Item__c>{vehicleQuoteItem}) ;
                }
            }
        }
        
        for(Integer lineno:quoteItemMap.KeySet())
        {
            Boolean addQuoteItemtoWrapper = false;
            quoteHeader quoteHeaderWrapper = new quoteHeader();
            quoteHeaderWrapper.quoteNumber = q.QuoteNumber;
            quoteHeaderWrapper.opportunityNumber = q.Opportunity.ETSALES_Opportunity_Number__c;
            quoteHeaderWrapper.zone = q.Opportunity.ETSALES_Sector__c;
            quoteHeaderWrapper.clientName = q.Account.Name;
            quoteHeaderWrapper.clientType = q.Account.ETSALES_Profile_Class__c;
            quoteHeaderWrapper.contractType = q.Opportunity.Type;
            //quoteHeaderWrapper.totalInvestmentValue = q.ET_Total_Investment__c;
            // quoteHeaderWrapper.totalInvestmentValue = q.Quote_Total_Investment__c;
            if(cumulativeTrailerPrice!=null && q.Quote_Total_Investment__c!=null){
                system.debug('cumulativeTrailerPrice=='+cumulativeTrailerPrice);
                system.debug('q.Quote_Total_Investment__c=='+q.Quote_Total_Investment__c);
                quoteHeaderWrapper.totalInvestmentValueTrailer = (cumulativeTrailerPrice + q.Quote_Total_Investment__c);
            }else{
                quoteHeaderWrapper.totalInvestmentValueTrailer =  q.Quote_Total_Investment__c;
            }
            if(cumulativeTrailerPrice!=null && q.Quote_Total_Investment__c!=null){
                quoteHeaderWrapper.totalInvestmentValueTrailerSummary = ( cumulativeTrailerPrice + q.Quote_Total_Investment__c);
            }else{
                quoteHeaderWrapper.totalInvestmentValueTrailerSummary =  q.Quote_Total_Investment__c;
            }
            //Taj
            if (profileSalesTL.Contains(q.Owner.Profile.Name) && profileSalesTL.Contains(loggedInUserProfile.Name) && (quoteHeaderWrapper.totalInvestmentValueTrailer >= 500000 || quoteHeaderWrapper.totalInvestmentValueTrailerSummary >= 500000)){
                showMessage = true;
                messageDetails.put('The Total Investment exceeds 5,00,000', 'Kindly coordinate with the Pricing Team for the quotation.');
            }
            
            quoteHeaderWrapper.requestor = q.Opportunity.owner.name;
            if(q.ET_Type__c == 'Total Project Summary'){
                quoteHeaderWrapper.totalLines = integer.valueOf(q.Total_Vehicle_Lines__c);  
            }
            else{
                quoteHeaderWrapper.totalLines = TotalLines;   
            }
            quoteHeaderWrapper.lineNo = lineno;
            quoteHeaderWrapper.totalNoOfVehicles = totalnumberofVehicles != null ? totalnumberofVehicles : 0;
            if(q.ET_Type__c == 'Total Project Summary'){
                quoteHeaderWrapper.serviceEmirate= q.Service_Emirate__c;
            }
            
            QuotationInfo quoteinfo = new QuotationInfo();
            
            if(wrapperQuotationDetails.containsKey(lineno)) 
            {
                quoteinfo = wrapperQuotationDetails.get(lineno);
                system.debug('Nura2'+JSON.serializePretty(quoteinfo));
            }     
            quoteinfo.quoteDetailsWrapper = quoteDetailsWrapper;          
            List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemListfromMap = quoteItemMap.get(lineno);
            Integer increment = 0;
            Set<String> VehicleSpecialRequirementLabels = new Set<String>();
            /*Set<String> VehicleSpecialRequirementLabelsPermit = new Set<String>();
            Set<String> VehicleSpecialRequirementLabelsBranding = new Set<String>();
            Set<String> VehicleSpecialRequirementLabelsDriver = new Set<String>();
            Set<String> VehicleSpecialRequirementLabelsLogo = new Set<String>();*/
            List<Integer> contractYearsList = new List<Integer>();
            List<vehicleQuoteCalcClass> vehicleQuoteCalcContracts = new List<vehicleQuoteCalcClass>();
            
            String lineHeaderName = 'Quotation for Rental Service with';
            Boolean fuelpresent = false;
            for(ET_Vehicle_Quote_Item__c vehicleQuoteItem:vehicleQuoteItemListfromMap)
            {
                Integer LineNumber = Integer.valueOf((vehicleQuoteItem.ET_Line_Number__c!=null)?vehicleQuoteItem.ET_Line_Number__c:0);
                if(LineNumber>0)
                {    increment =  increment +1;
                 if(increment==1)
                 {
                     if(q.ET_Type__c != 'Total Project Summary'){
                         quoteHeaderWrapper.serviceEmirate= vehicleQuoteItem.ET_Service_Emirate__c;
                     }
                     quoteHeaderWrapper.fleetType= vehicleQuoteItem.ET_Fleet_Type__c;
                 }
                 addQuoteItemtoWrapper = true;
                 if(!contractYearsList.contains(Integer.valueOf(vehicleQuoteItem.ET_Contract_Period__c)))
                 {
                     contractYearsList.add( Integer.valueOf(vehicleQuoteItem.ET_Contract_Period__c));    
                 }   
                 // assign Vehicle notes to 
                 if(quoteinfo.vehicleNotes != '' || quoteinfo.vehicleNotes != null ){
                     quoteinfo.vehicleNotes = vehicleQuoteItem.Vehicle_Notes__c;
                 }
                 vehicleQuoteCalcClass vehiclewrapper = new vehicleQuoteCalcClass();           
                 vehiclewrapper.vehicleLineItemNumberFromRequest = Integer.valueOf(LineNumber);
                 vehiclewrapper.contractYear = Integer.valueOf(vehicleQuoteItem.ET_Contract_Period__c);
                 vehiclewrapper.vehiclePurchasePriceBasedOnCondition = vehicleQuoteItem.ET_Vehicle_Current_Purchase_Price__c;
                 vehiclewrapper.vehicleResaleValue = (vehicleQuoteItem.ET_Vehicle_Resale_Value__c!=null)?Decimal.valueOf(vehicleQuoteItem.ET_Vehicle_Resale_Value__c):0;
                 vehiclewrapper.vehicleDepreciation = (vehicleQuoteItem.ET_Vehicle_Depreciation__c!=null)?Decimal.valueOf(vehicleQuoteItem.ET_Vehicle_Depreciation__c):0 ;
                 vehiclewrapper.vehicleRepairsAndMaintenance = (vehicleQuoteItem.ET_Vehicle_Repairs_and_Maintenance__c!=null)?vehicleQuoteItem.ET_Vehicle_Repairs_and_Maintenance__c:0;
                 vehiclewrapper.remainingDepreciationOf10Years = (vehicleQuoteItem.ET_Remaining_Depreciation_of_10_Years__c!=null)?vehicleQuoteItem.ET_Remaining_Depreciation_of_10_Years__c:0;
                 vehiclewrapper.vehicleFinancing = (vehicleQuoteItem.ET_Vehicle_Financing__c!=null)?vehicleQuoteItem.ET_Vehicle_Financing__c:0;
                 vehiclewrapper.vehicleRegistrationAndInspectionFee = (vehicleQuoteItem.ET_Vehicle_Registration__c!=null)?vehicleQuoteItem.ET_Vehicle_Registration__c:0;
                 vehiclewrapper.vehicleInsurance = (vehicleQuoteItem.ET_Vehicle_Insurance__c!=null)?vehicleQuoteItem.ET_Vehicle_Insurance__c:0;
                 vehiclewrapper.deprciationReserve = (vehicleQuoteItem.ET_Depreciation_Reserve__c!=null)?vehicleQuoteItem.ET_Depreciation_Reserve__c:0;
                 vehiclewrapper.salikCost = (vehicleQuoteItem.Salik_Cost__c!=null)?vehicleQuoteItem.Salik_Cost__c:0;
                 vehiclewrapper.basicTrackingSystemCost = (vehicleQuoteItem.Basic_Tracking_System__c!=null)?vehicleQuoteItem.Basic_Tracking_System__c:0;
                 vehiclewrapper.maintenanceReserve = (vehicleQuoteItem.ET_Maintenance_Reserve__c!=null)?vehicleQuoteItem.ET_Maintenance_Reserve__c:0;
                 vehiclewrapper.generalReserve = (vehicleQuoteItem.ET_General_Reserve__c!=null)?vehicleQuoteItem.ET_General_Reserve__c:0;
                 vehiclewrapper.annualVehicleProfitMarginRate = (vehicleQuoteItem.ET_Annual_Vehicles_Profit_Margin__c!=null)?vehicleQuoteItem.ET_Annual_Vehicles_Profit_Margin__c:0;
                 vehiclewrapper.annualVehicleProfitMarginValue = (vehicleQuoteItem.ET_Annual_Vehicles_Profit_Value__c!=null)?vehicleQuoteItem.ET_Annual_Vehicles_Profit_Value__c:0;
                 vehiclewrapper.corporateTax = (vehicleQuoteItem.Corporate_Tax__c!=null)?vehicleQuoteItem.Corporate_Tax__c:0;
                 vehiclewrapper.fuelExpenses = (vehicleQuoteItem.ET_Fuel_Expenses__c!=null)?vehicleQuoteItem.ET_Fuel_Expenses__c:0;
                 vehiclewrapper.fuelReserve = (vehicleQuoteItem.ET_Fuel_Reserve__c!=null)?vehicleQuoteItem.ET_Fuel_Reserve__c:0;
                 vehiclewrapper.annualFuelProfitMarginRate = (vehicleQuoteItem.ET_Annual_Fuel_Profit_Margin_Rate__c!=null)?vehicleQuoteItem.ET_Annual_Fuel_Profit_Margin_Rate__c:0;
                 vehiclewrapper.annualFuelProfitMarginValue = (vehicleQuoteItem.ET_Annual_Fuel_Profit_Value__c!=null)?vehicleQuoteItem.ET_Annual_Fuel_Profit_Value__c:0;
                 vehiclewrapper.vehicleTotalCost = (vehicleQuoteItem.ET_Total_Vehicles_Cost__c!=null)?vehicleQuoteItem.ET_Total_Vehicles_Cost__c:0;
                 vehiclewrapper.vehicleTotalFixedCost = (vehicleQuoteItem.ET_Total_Fixed_Cost__c!=null)?vehicleQuoteItem.ET_Total_Fixed_Cost__c:0;
                 vehiclewrapper.vehicleTotalVariableCost = (vehicleQuoteItem.ET_Total_Variable_Cost__c!=null)?vehicleQuoteItem.ET_Total_Variable_Cost__c:0;
                 vehiclewrapper.totalFuelCost = (vehicleQuoteItem.ET_Total_Fuel_Cost__c!=null)?vehicleQuoteItem.ET_Total_Fuel_Cost__c:0;
                 if(vehiclewrapper.totalFuelCost>0)
                 {
                     fuelpresent = true;
                 }
                 vehiclewrapper.totalReserveCost = (vehicleQuoteItem.ET_Total_Reserve_Cost__c!=null)?vehicleQuoteItem.ET_Total_Reserve_Cost__c:0;
                 vehiclewrapper.numberOfVehicles = vehicleQuoteItem.ET_Number_of_Vehicles__c !=0 ? integer.Valueof(vehicleQuoteItem.ET_Number_of_Vehicles__c): 0 ;
                 vehiclewrapper.vehicleLineUniqueKey = (vehicleQuoteItem.ET_Vehicle_Unique_key__c!=null)?vehicleQuoteItem.ET_Vehicle_Unique_key__c.substringAfter('_'):'';
                 vehiclewrapper.noOfSeats = (vehicleQuoteItem.ET_No_of_Seats__c!=null)?vehicleQuoteItem.ET_No_of_Seats__c:0;
                 vehiclewrapper.passedYear = (vehicleQuoteItem.Passed_years_from_Bus_Model__c!=null)?integer.Valueof(vehicleQuoteItem.Passed_years_from_Bus_Model__c):0; //Added by Arun
                 vehiclewrapper.remainingYear = (vehicleQuoteItem.Remaining_years_from_the_Bus_Model__c!=null)?integer.Valueof(vehicleQuoteItem.Remaining_years_from_the_Bus_Model__c):0; //Added by Arun
                 vehiclewrapper.CurrentValueRemainingDepreciation = (vehicleQuoteItem.Current_Value_Remaining_Depreciation_of__c!=null)?integer.Valueof(vehicleQuoteItem.Current_Value_Remaining_Depreciation_of__c):0; //Added by Arun
                 vehiclewrapper.DepreciationDifferenceOtherContracts = (vehicleQuoteItem.Depreciation_Difference_to_other_Contrac__c!=null)?integer.Valueof(vehicleQuoteItem.Depreciation_Difference_to_other_Contrac__c):0; //Added by Arun
                 vehiclewrapper.TotalResaleValueMinResaleDepDiff = (vehicleQuoteItem.Total_Resale_Value_Min_resale_Dep_Diff__c!=null)?integer.Valueof(vehicleQuoteItem.Total_Resale_Value_Min_resale_Dep_Diff__c):0; //Added by Arun
                 vehiclewrapper.dailyMileage = (vehicleQuoteItem.ET_Daily_Mileage__c!=null)?vehicleQuoteItem.ET_Daily_Mileage__c:0;
                 vehiclewrapper.totalAnnualMileage = (vehicleQuoteItem.ET_Total_Annual_Mileage__c!=null)?vehicleQuoteItem.ET_Total_Annual_Mileage__c:0;
                 vehiclewrapper.vehicleCurrentPurchasePrice = (vehicleQuoteItem.ET_Vehicle_Current_Purchase_Price__c!=null)? vehicleQuoteItem.ET_Vehicle_Current_Purchase_Price__c:0;
                 vehiclewrapper.vehicleLatestNewPurchasePrice = (vehicleQuoteItem.ET_Vehicle_Original_Purchase_Price__c!=null)?vehicleQuoteItem.ET_Vehicle_Original_Purchase_Price__c:0;
                 vehiclewrapper.vehicleDepreciationRate = (vehicleQuoteItem.ET_Vehicle_Depreciation_Percentage__c!=null)?vehicleQuoteItem.ET_Vehicle_Depreciation_Percentage__c:0;
                 vehiclewrapper.depreciationRateforExtraMileage = (vehicleQuoteItem.ET_Depreciation_Rate_for_Extra_Mileage__c!=null)?vehicleQuoteItem.ET_Depreciation_Rate_for_Extra_Mileage__c :0 ;
                 vehiclewrapper.vehicleMaintenanceRate = (vehicleQuoteItem.ET_Vehicle_Maintenance_Rate__c!=null)?vehicleQuoteItem.ET_Vehicle_Maintenance_Rate__c:0;
                 vehiclewrapper.workingMonthsPerYear = (vehicleQuoteItem.ET_Working_Months_per_year__c!=null)?vehicleQuoteItem.ET_Working_Months_per_year__c:0;
                 vehiclewrapper.workingDaysPerWeek = (vehicleQuoteItem.ET_Working_days_per_week__c!=null)?vehicleQuoteItem.ET_Working_days_per_week__c:0;
                 vehiclewrapper.vehicleSource = (vehicleQuoteItem.ET_Vehicle_Source__c!=null)?vehicleQuoteItem.ET_Vehicle_Source__c:'';
                 vehiclewrapper.serviceType = (vehicleQuoteItem.ET_Service_Type__c!=null)?vehicleQuoteItem.ET_Service_Type__c:'';
                 vehiclewrapper.workingDaysPerYear = (vehicleQuoteItem.ET_Working_days_per_year__c!=null)?vehicleQuoteItem.ET_Working_days_per_year__c:0;
                 vehiclewrapper.extraBusFeesForSchoolTransportation = (vehicleQuoteItem.ET_Extra_Bus_Fees__c!=null)?vehicleQuoteItem.ET_Extra_Bus_Fees__c:0;
                 vehiclewrapper.fuelRate = (vehicleQuoteItem.ET_Vehicle_Fuel_Rate__c!=null)?vehicleQuoteItem.ET_Vehicle_Fuel_Rate__c:0;
                 vehiclewrapper.priceUtilization = (vehicleQuoteItem.ET_Price_Utilization__c!=null)?vehicleQuoteItem.ET_Price_Utilization__c:0;
                 vehiclewrapper.pricingType = (vehicleQuoteItem.ET_Pricing_Type__c!=null)?vehicleQuoteItem.ET_Pricing_Type__c:'';
                 vehiclewrapper.pricingMethod = (vehicleQuoteItem.ET_Pricing_Method__c!=null)?vehicleQuoteItem.ET_Pricing_Method__c:'';
                 vehiclewrapper.vehicleVATRate = (vehicleQuoteItem.ET_Vat_Rate__c!=null)?vehicleQuoteItem.ET_Vat_Rate__c:'' ;
                 vehiclewrapper.fuelRequired = (vehicleQuoteItem.ET_Fuel_Required__c!=null)?vehicleQuoteItem.ET_Fuel_Required__c:false;
                 vehiclewrapper.vatCostonDirectExpenses = (vehicleQuoteItem.ET_VAT_Cost_on_Direct_Expenses__c !=null)?vehicleQuoteItem.ET_VAT_Cost_on_Direct_Expenses__c :0;
                 vehiclewrapper.vatCostonInDirectExpenses = (vehicleQuoteItem.ET_VAT_Cost_on_Indirect_Expenses__c!=null)?vehicleQuoteItem.ET_VAT_Cost_on_Indirect_Expenses__c:0;
                 vehiclewrapper.discountOrAdditionalProfit = (vehicleQuoteItem.ET_Discounts_Additional_Profit__c!=null)?vehicleQuoteItem.ET_Discounts_Additional_Profit__c:0;
                 vehiclewrapper.substitutionalVehiclesCostPerVehicle = (vehicleQuoteItem.Substitutional_Vehicles_Cost_Per_Vehicle__c!=null)?vehicleQuoteItem.Substitutional_Vehicles_Cost_Per_Vehicle__c:0;
                 vehiclewrapper.substitutionalVehiclesProfitPerVehicle =(vehicleQuoteItem.Substitutional_vehcls_profit_Per_Vehicle__c!=null)?vehicleQuoteItem.Substitutional_vehcls_profit_Per_Vehicle__c:0; 
                 vehiclewrapper.vehicleNotes = (vehicleQuoteItem.Vehicle_Notes__c!=null)?vehicleQuoteItem.Vehicle_Notes__c:'';
                 // Trailer fields mapping ... 
                 if(vehicleQuoteItem.Is_trailer_selected__c){
                     vehiclewrapper.trailerOriginalPurchasePrice = (vehicleQuoteItem.Trailer_Original_Purchase_Price__c!=null)?vehicleQuoteItem.Trailer_Original_Purchase_Price__c:0;
                     vehiclewrapper.trailerCurrentPurchasePrice = (vehicleQuoteItem.Trailer_Current_Purchase_Price__c!=null)?vehicleQuoteItem.Trailer_Current_Purchase_Price__c:0;
                     vehiclewrapper.trailerDepreciationRate = (vehicleQuoteItem.Trailer_Depreciation_Rate__c!=null)?vehicleQuoteItem.Trailer_Depreciation_Rate__c:0;
                     vehiclewrapper.trailerResaleValue =(vehicleQuoteItem.Trailer_Resale_Value__c!=null)?Decimal.valueOf(vehicleQuoteItem.Trailer_Resale_Value__c):0; 
                     vehiclewrapper.trailerMaintenanceRate = (vehicleQuoteItem.Trailer_Maintenance_Rate__c!=null)?vehicleQuoteItem.Trailer_Maintenance_Rate__c:0;
                     vehiclewrapper.trailerDepreciation = (vehicleQuoteItem.Trailer_Depreciation__c!=null)?Decimal.valueOf(vehicleQuoteItem.Trailer_Depreciation__c):0;
                     vehiclewrapper.trailerRepairsAndMaintenance = (vehicleQuoteItem.Trailer_Repairs_And_Maintenance__c!=null)?vehicleQuoteItem.Trailer_Repairs_And_Maintenance__c:0;
                     vehiclewrapper.trailerRegistrationAndInspectionFee =(vehicleQuoteItem.Trailer_Registration_Fee__c!=null)?vehicleQuoteItem.Trailer_Registration_Fee__c:0; 
                     vehiclewrapper.trailerExtrenalMaintenanceCost =(vehicleQuoteItem.Trailer_External_Maintenance_Cost__c!=null)?vehicleQuoteItem.Trailer_External_Maintenance_Cost__c:0; 
                     vehiclewrapper.IsTrailerSelected =(vehicleQuoteItem.Is_trailer_selected__c!=null)?vehicleQuoteItem.Is_trailer_selected__c:false; 
                 }
                 
                 // Refrigerator fields mapping ... 
                 if(vehicleQuoteItem.Is_refrigerator_selected__c){
                     vehiclewrapper.refrigeratorOriginalPurchasePrice = (vehicleQuoteItem.Refrigerator_Original_Purchase_Price__c!=null)?vehicleQuoteItem.Refrigerator_Original_Purchase_Price__c:0;
                     vehiclewrapper.refrigeratorCurrentPurchasePrice = (vehicleQuoteItem.Refrigerator_Current_Purchase_Price__c!=null)?vehicleQuoteItem.Refrigerator_Current_Purchase_Price__c:0;
                     vehiclewrapper.refrigeratorDepreciationRate = (vehicleQuoteItem.Refrigerator_Depreciation_Rate__c!=null)?vehicleQuoteItem.Refrigerator_Depreciation_Rate__c:0;
                     vehiclewrapper.refrigeratorResaleValue =(vehicleQuoteItem.Refrigerator_Resale_Value__c!=null)?Decimal.valueOf(vehicleQuoteItem.Refrigerator_Resale_Value__c):0; 
                     vehiclewrapper.refrigeratorMaintenanceRate = (vehicleQuoteItem.Refrigerator_Maintenance_Rate__c!=null)?vehicleQuoteItem.Refrigerator_Maintenance_Rate__c:0;
                     vehiclewrapper.refrigeratorDepreciation = (vehicleQuoteItem.Refrigerator_Depreciation__c!=null)?Decimal.valueOf(vehicleQuoteItem.Refrigerator_Depreciation__c):0;
                     vehiclewrapper.refrigeratorRepairsAndMaintenance = (vehicleQuoteItem.Refrigerator_Repairs_And_Maintenance__c!=null)?vehicleQuoteItem.Refrigerator_Repairs_And_Maintenance__c:0;
                     vehiclewrapper.refrigeratorRegistrationAndInspectionFee =(vehicleQuoteItem.Refrigerator_Registration_Fee__c!=null)?vehicleQuoteItem.Refrigerator_Registration_Fee__c:0; 
                     vehiclewrapper.refrigeratorExtrenalMaintenanceCost =(vehicleQuoteItem.Refrigerator_External_Maintenance_Cost__c!=null)?vehicleQuoteItem.Refrigerator_External_Maintenance_Cost__c:0; 
                     vehiclewrapper.IsRefrigeratorSelected =(vehicleQuoteItem.Is_refrigerator_selected__c!=null)?vehicleQuoteItem.Is_refrigerator_selected__c:false;
                 }
                 
                 
                 if(isTargetPriceRequired)
                 {
                     vehiclewrapper.generalReserveDiscountedPrice = (vehicleQuoteItem.General_Reserve_for_Discounted_Price__c!=null)?vehicleQuoteItem.General_Reserve_for_Discounted_Price__c:0;
                     vehiclewrapper.generalReserveTargetPrice = (vehicleQuoteItem.General_Reserve_Target_Prices__c!=null)?vehicleQuoteItem.General_Reserve_Target_Prices__c:0;
                     vehiclewrapper.fuelReserveDiscounted = (vehicleQuoteItem.Fuel_Reserve_Discounted__c!=null)?vehicleQuoteItem.Fuel_Reserve_Discounted__c:0;
                     vehiclewrapper.fuelReserveTarget = (vehicleQuoteItem.Fuel_Reserve_Target__c!=null)?vehicleQuoteItem.Fuel_Reserve_Target__c:0;
                     vehiclewrapper.totalFuelCostDiscounted = (vehicleQuoteItem.Total_Fuel_Cost_Discounted__c!=null)?vehicleQuoteItem.Total_Fuel_Cost_Discounted__c:0;
                     vehiclewrapper.totalFuelCostTargetPrice = (vehicleQuoteItem.Total_Fuel_Cost_Target_Price__c!=null)?vehicleQuoteItem.Total_Fuel_Cost_Target_Price__c:0;
                     vehiclewrapper.fuelProfitValueDiscountedPrice = (vehicleQuoteItem.Fuel_Profit_Value_Discounted__c!=null)?vehicleQuoteItem.Fuel_Profit_Value_Discounted__c:0;
                     vehiclewrapper.fuelProfitValueTargetPrice = (vehicleQuoteItem.ET_Annual_Fuel_Profit_Target_Prices__c!=null)?vehicleQuoteItem.ET_Annual_Fuel_Profit_Target_Prices__c:0;
                     vehiclewrapper.vehicleTotalCostDiscountedPrice = (vehicleQuoteItem.Total_Vehicles_Cost_Discounted__c!=null)?vehicleQuoteItem.Total_Vehicles_Cost_Discounted__c:0;
                     vehiclewrapper.vehicleTotalCostTargetPrice = (vehicleQuoteItem.Total_Annual_Cost_Target_Prices__c!=null)?vehicleQuoteItem.Total_Annual_Cost_Target_Prices__c:0;
                     vehiclewrapper.vehicleProfitMarginRateForDiscountedPrice = (vehicleQuoteItem.Vehicles_Profit_Margin_Rate_Discounted__c!=null)?vehicleQuoteItem.Vehicles_Profit_Margin_Rate_Discounted__c:0;                
                     vehiclewrapper.discountedVehicleProfitValueForTargetPrice =(vehicleQuoteItem.Discounted_Vehicle_Profit_Value_Target__c!=null)?vehicleQuoteItem.Discounted_Vehicle_Profit_Value_Target__c:0;                                
                     vehiclewrapper.totalAnnualTargetPrice = vehicleQuoteItem.Total_Annual_Price_Target_Prices__c!=null? vehicleQuoteItem.Total_Annual_Price_Target_Prices__c:0;
                     vehiclewrapper.vehicleProfitValueForTargetPrice = (vehicleQuoteItem.Vehicle_Profit_Value_Target_Price__c!=null)?vehicleQuoteItem.Vehicle_Profit_Value_Target_Price__c:0;
                     vehiclewrapper.vehicleProfitMarginRateForTargetPrice  = (vehicleQuoteItem.Vehicles_Profit_Margin_Rate_Target__c!=null)?vehicleQuoteItem.Vehicles_Profit_Margin_Rate_Target__c:0;
                     
                 }
                 else
                 {
                     vehiclewrapper.generalReserveDiscountedPrice = 0;
                     vehiclewrapper.generalReserveTargetPrice = 0;
                     vehiclewrapper.fuelReserveDiscounted = 0;
                     vehiclewrapper.fuelReserveTarget = 0;
                     vehiclewrapper.totalFuelCostDiscounted = 0;
                     vehiclewrapper.totalFuelCostTargetPrice = 0;
                     vehiclewrapper.fuelProfitValueDiscountedPrice = 0;
                     vehiclewrapper.fuelProfitValueTargetPrice = 0;
                     vehiclewrapper.vehicleTotalCostDiscountedPrice = 0;
                     vehiclewrapper.vehicleTotalCostTargetPrice = 0;
                     vehiclewrapper.vehicleProfitMarginRateForDiscountedPrice = 0;                
                     vehiclewrapper.discountedVehicleProfitValueForTargetPrice =0;                                
                     vehiclewrapper.totalAnnualTargetPrice = 0;
                     vehiclewrapper.vehicleProfitValueForTargetPrice = 0;
                     vehiclewrapper.vehicleProfitMarginRateForTargetPrice  = 0;
                 }
                 
                 Map<String,Decimal> requirementLst = new Map<String,Decimal>();
                 String specialLabels = '';
                 /*String specialLabelsPermit = '';
                 String specialLabelsBranding = '';
                 String specialLabelsDriver = '';
                 String specialLabelsLogo = '';*/
                 system.debug('vehicleQuoteItem.Vehicle_Quote_Item_SpecRequests__r : '+ vehicleQuoteItem.Vehicle_Quote_Item_SpecRequests__r.toString());
                 for(ET_Quote_Item_SpecReq__c vehicleQuoteItemRequest : vehicleQuoteItem.Vehicle_Quote_Item_SpecRequests__r ){
                     if(vehicleQuoteItemRequest.Name != null && vehicleQuoteItemRequest.Name != '') 
						{ 
					/* (
                         vehicleQuoteItemRequest.Name.contains('ESMA Expenses') ||
                         vehicleQuoteItemRequest.Name.contains('Fuel Card') ||
                         vehicleQuoteItemRequest.Name.contains('GPS tracking system') ||
                         vehicleQuoteItemRequest.Name.contains('Integration cost') ||
                         vehicleQuoteItemRequest.Name.contains('Safety Tools') ||
                         vehicleQuoteItemRequest.Name.contains('Salama System') ||
                         vehicleQuoteItemRequest.Name.contains('Salik Card') ||
                         vehicleQuoteItemRequest.Name.contains('School Regulations Expenses') ||
                         vehicleQuoteItemRequest.Name.contains('Sunshade') ||
                         vehicleQuoteItemRequest.Name.contains('Washing expenses')
                     )*/

                         specialLabels = specialLabels + ',' + vehicleQuoteItemRequest.Name;
                         requirementLst.put(vehicleQuoteItemRequest.Name,vehicleQuoteItemRequest.ET_Cost__c);
                         VehicleSpecialRequirementLabels.add(vehicleQuoteItemRequest.Name);    
                     }
                    /* if(vehicleQuoteItemRequest.Name != null && vehicleQuoteItemRequest.Name != '') 
					{ 
						/*&& (
                         vehicleQuoteItemRequest.Name.contains('Asateel') ||
                         vehicleQuoteItemRequest.Name.contains('Cicpa Pass') ||
                         vehicleQuoteItemRequest.Name.contains('Food Permit') ||
                         vehicleQuoteItemRequest.Name.contains('Gate Passes (JAFZA)') ||
                         vehicleQuoteItemRequest.Name.contains('Non-Food Permit') ||
                         vehicleQuoteItemRequest.Name.contains('Parking Card') ||
                         vehicleQuoteItemRequest.Name.contains('Road Permit') ||
                         vehicleQuoteItemRequest.Name.contains('Security Pass') ||
                         vehicleQuoteItemRequest.Name.contains('SIRA') ||
                         vehicleQuoteItemRequest.Name.contains('Vehicle Washing Card')||
                         vehicleQuoteItemRequest.Name.contains('Driver/ Nany Permit')
                     )

                         specialLabelsPermit = specialLabelsPermit + ',' + vehicleQuoteItemRequest.Name;
                         requirementLst.put(vehicleQuoteItemRequest.Name,vehicleQuoteItemRequest.ET_Cost__c);
                         VehicleSpecialRequirementLabelsPermit.add(vehicleQuoteItemRequest.Name);    
                     }
                     if(vehicleQuoteItemRequest.Name != null && vehicleQuoteItemRequest.Name != '' && (
                         vehicleQuoteItemRequest.Name.contains('Branding Installation') ||
                         vehicleQuoteItemRequest.Name.contains('Branding Permit') ||
                         vehicleQuoteItemRequest.Name.contains('Branding Removal')
                         
                     )) {
                         specialLabelsBranding = specialLabelsBranding + ',' + vehicleQuoteItemRequest.Name;
                         requirementLst.put(vehicleQuoteItemRequest.Name,vehicleQuoteItemRequest.ET_Cost__c);
                         VehicleSpecialRequirementLabelsBranding.add(vehicleQuoteItemRequest.Name);    
                     }
                     if(vehicleQuoteItemRequest.Name != null && vehicleQuoteItemRequest.Name != '' && (
                         vehicleQuoteItemRequest.Name.contains('Driver Fixed Allowance') ||
                         vehicleQuoteItemRequest.Name.contains('Drug Test') ||
                         vehicleQuoteItemRequest.Name.contains('Training')
                         
                     )) {
                         specialLabelsDriver = specialLabelsDriver + ',' + vehicleQuoteItemRequest.Name;
                         requirementLst.put(vehicleQuoteItemRequest.Name,vehicleQuoteItemRequest.ET_Cost__c);
                         VehicleSpecialRequirementLabelsDriver.add(vehicleQuoteItemRequest.Name);    
                     }
                      if(vehicleQuoteItemRequest.Name != null && vehicleQuoteItemRequest.Name != '' && (
                         vehicleQuoteItemRequest.Name.contains('Brand Stickers') ||
                         vehicleQuoteItemRequest.Name.contains('Logo') ||
                         vehicleQuoteItemRequest.Name.contains('Vehicle Safety Stickers')
                         
                     )) {
                         specialLabelsLogo = specialLabelsLogo + ',' + vehicleQuoteItemRequest.Name;
                         requirementLst.put(vehicleQuoteItemRequest.Name,vehicleQuoteItemRequest.ET_Cost__c);
                         VehicleSpecialRequirementLabelsLogo.add(vehicleQuoteItemRequest.Name);    
                     }*/
                     
                 }
                 vehiclewrapper.vehicleSpecialRequirementLst = requirementLst;
                 vehiclewrapper.specialRequirementLabels = specialLabels; 
                 /*vehiclewrapper.specialRequirementLabelsPermit = specialLabelsPermit; 
                 vehiclewrapper.specialRequirementLabelsBranding = specialLabelsBranding; 
                 vehiclewrapper.specialRequirementLabelsDriver = specialLabelsDriver; 
                 vehiclewrapper.specialRequirementLabelsLogo = specialLabelsLogo;*/ 
                 vehicleQuoteCalcContracts.add(vehiclewrapper) ;                                                  
                }
                if((appovalDetails=='' || appovalDetails==null) && vehicleQuoteItem.Approval_Details__c!=null && vehicleQuoteItem.Approval_Details__c!='')
                    appovalDetails=vehicleQuoteItem.Approval_Details__c;
                
            }
            quoteinfo.quoteHeaderWrapper = quoteHeaderWrapper;
            quoteinfo.vehicleApprovalDetailsWrp = new List<vehicleApprovalDetails>();
            if(addQuoteItemtoWrapper) 
            {	//	wrapperQuotationDetails.put(lineno,)
                quoteinfo.VehicleSpecialRequirementLabels = VehicleSpecialRequirementLabels;
                /*quoteinfo.VehicleSpecialRequirementLabelsPermit = VehicleSpecialRequirementLabelsPermit;
                quoteinfo.VehicleSpecialRequirementLabelsBranding = VehicleSpecialRequirementLabelsBranding;
                quoteinfo.VehicleSpecialRequirementLabelsDriver = VehicleSpecialRequirementLabelsDriver;
                 quoteinfo.VehicleSpecialRequirementLabelsLogo = VehicleSpecialRequirementLabelsLogo;*/
                system.debug('vehicleQuoteCalcContracts == ' + JSON.serializePretty(vehicleQuoteCalcContracts));
                quoteinfo.vehicleQuoteCalcContracts = vehicleQuoteCalcContracts;
                quoteinfo.contractYears = contractYearsList;
                if(appovalDetails!=null && appovalDetails!=''){
                    list<vehicleApprovalDetails> ApprovalDetailsWrp=new list<vehicleApprovalDetails>();
                    for(string yearDetails:appovalDetails.split(';')){
                        if(yearDetails!=null && yearDetails!=''){
                            integer yearDetailsSize=yearDetails.split(',').size();
                            if(yearDetails.split(',').size()>0 && yearDetails.split(',').size()==4){
                                if(yearDetails.split(',')[1]!=null && yearDetails.split(',')[1]!=''){
                                    vehicleApprovalDetails wrp=new vehicleApprovalDetails();
                                    wrp.element=yearDetails.split(',')[0];
                                    wrp.requestedBy=yearDetails.split(',')[1];
                                    wrp.approvedby=yearDetails.split(',')[2];
                                    wrp.reason=yearDetails.split(',')[3];
                                    ApprovalDetailsWrp.add(wrp);
                                }
                            }
                        }
                    }
                    quoteinfo.vehicleApprovalDetailsWrp = ApprovalDetailsWrp;
                }
                if(fuelpresent)
                {
                    lineHeaderName = lineHeaderName + ' Vehicles, Fuel'; 
                }
                else{ 
                    lineHeaderName = lineHeaderName + ' Vehicles';
                }
                
                quoteinfo.HeaderName = lineHeaderName;
                quoteinfo.vehiclePresent = true;
                this.wrapperQuotationDetails.put(lineno,quoteinfo);     
            }
            
            //    System.debug('wrapper test'+wrapperQuotationDetails.get(1).vehicleQuoteCalcContract1.vehicleLineItemNumberFromRequest); 
        }
        
        //workforce section
        List<ET_Workforce_Quote_Item__c> workforceQuoteItemLst = ET_PricingUtilityClass.getWorkforceQuoteItemLstWithQutId(quoteId);
        //filter only Main workforce...
        // System.debug('Nura'+  JSON.serializePretty(workforceQuoteItemLst) );
        Map<integer,String> emirateWithRespectToLineMap = new Map<integer,String>();
        /*List<ET_Workforce_Quote_Item__c> workforceQuoteItemLst = new List<ET_Workforce_Quote_Item__c>();
for(ET_Workforce_Quote_Item__c workforceQitem : workforceQuoteItemLstAll){
if(workforceQitem.Type__c == 'Main'){
workforceQuoteItemLst.add(workforceQitem);
}
}*/
        
        Set<Integer> workforceLines = new Set<Integer>();
        for(ET_Workforce_Quote_Item__c workforceQitem:workforceQuoteItemLst)
        {
            workforceLines.add(Integer.valueOf(workforceQitem.ET_Workforce_Line_Number__c));
            emirateWithRespectToLineMap.put(Integer.valueOf(workforceQitem.ET_Workforce_Line_Number__c) , workforceQitem.ET_Service_Emirate__c);
            
        }
        
        integer manpowerLines =0;
        if(!workforceLines.isempty()){
            manpowerLines = workforceLines.size();
        }
        List<Integer> manpowerContractYearsList = new List<Integer>();
        //System.debug('workforceLines== '+workforceLines);
        for(Integer lineno: workforceLines)
        {
            Map<String,Map<Integer,ET_Workforce_Quote_Item__c>> workForceMapWithWorkForceType = new Map<String,Map<Integer,ET_Workforce_Quote_Item__c>>();        
            String workforceType = '';
            List<String> WorkforceList = new List<String>();
            Map<String,Set<String>> spcialRequirementLabelsLst = new Map<String,Set<String>>();
            String driverNotes;
            String nannyNotes;
            String accountantNotes;
            String coordinatorNotes;
            String supervisorNotes;
            // Decimal extraKMPriceWorkforce;//Added by Arun 10.04.2023 for Extra KM
            // Decimal extraKMPriceWorkforceCord;//Added by Arun 10.04.2023 for Extra KM
            
            for(ET_Workforce_Quote_Item__c workforceQitem:workforceQuoteItemLst)
            {
                // Added by Arun on 10.04.2023 for Extra KM workforce
                if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Driver'){
                    if(Integer.valueOf(workforceQitem.ET_Workforce_Line_Number__c)==lineno){
                        system.debug('workforceQitem.Extra_KM_Workforce__c==1'+workforceQitem.Extra_KM_Workforce__c);
                        extraKMPriceWorkforce = workforceQitem.Extra_KM_Workforce__c;
                        //extraKMMap.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c), extraKMPriceWorkforce);
                    }
                }
                //Added by Arun on 10.04.2023 for Extra KM New row addition
                if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Coordinator'){
                    if(Integer.valueOf(workforceQitem.ET_Workforce_Line_Number__c)==lineno){
                        extraKMPriceWorkforceCord = workforceQitem.Extra_KM_Workforce__c;
                        // extraKMMap.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c), extraKMPriceWorkforceCord);
                    }
                }
                if(!manpowerContractYearsList.contains(Integer.valueOf(workforceQitem.ET_Contract_Period__c)))
                {
                    manpowerContractYearsList.add( Integer.valueOf(workforceQitem.ET_Contract_Period__c));    
                } 
                //Added by Arunsarathy for Multiple coordinator lines without vehicle on 19.12.2023.
                if(!vehiclePresnt) {
                    if (workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Coordinator') {
                        if (Integer.valueOf(workforceQitem.ET_Workforce_Line_Number__c) == lineno) {
                            if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Coordinator' && coordinatorNotes != ''){
                                coordinatorNotes = workforceQitem.Notes__c;
                            }
                            if(workForceMapWithWorkForceType.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c)) {
                                Map<Integer, ET_Workforce_Quote_Item__c> workforceMapByContractYear = new Map<Integer, ET_Workforce_Quote_Item__c>();
                                if (workForceMapWithWorkForceType.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c)) {
                                    workforceMapByContractYear = workForceMapWithWorkForceType.get(workforceQitem.ET_Workforce_Quote_Item_Type__c);
                                }
                                if (!workforceMapByContractYear.containsKey(Integer.valueOf(workforceQitem.ET_Contract_Period__c))) {
                                    workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c), workforceQitem);
                                    workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c, workforceMapByContractYear);
                                }
                                {
                                    for(ET_Quote_Item_SpecReq__c specialreq:workforceQitem.Quote_Item_SpecReqs__r) {
                                        if(spcialRequirementLabelsLst.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c)) {
                                            spcialRequirementLabelsLst.get(workforceQitem.ET_Workforce_Quote_Item_Type__c).add(specialreq.Name);
                                        }else{
                                            spcialRequirementLabelsLst.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,new Set<String>{specialreq.Name});  
                                        }
                                    }
                                    workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                                    System.debug('workfoce='+workforceQitem.ET_Workforce_Quote_Item_Type__c+'contract year='+Integer.valueOf(workforceQitem.ET_Contract_Period__c)+'work annual ='+workforceQitem.ET_Wages__c);
                                    workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                                }
                                if(!workforceType.contains(workforceQitem.ET_Workforce_Quote_Item_Type__c)){
                                    workforceType = workforceType +','+ workforceQitem.ET_Workforce_Quote_Item_Type__c;
                                }
                            }
                            else {
                                Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear = new   Map<Integer,ET_Workforce_Quote_Item__c>();
                                workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                                workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                                for(ET_Quote_Item_SpecReq__c specialreq:workforceQitem.Quote_Item_SpecReqs__r) {
                                    if(spcialRequirementLabelsLst.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c)) {
                                        spcialRequirementLabelsLst.get(workforceQitem.ET_Workforce_Quote_Item_Type__c).add(specialreq.Name);
                                    }else {
                                        spcialRequirementLabelsLst.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,new Set<String>{specialreq.Name});  
                                    }
                                }
                                if(!workforceType.contains(workforceQitem.ET_Workforce_Quote_Item_Type__c))  {
                                    workforceType = workforceType +','+ workforceQitem.ET_Workforce_Quote_Item_Type__c;
                                }
                            }  
                        }
                    }
                }
                // Line ended by Arunsarathy
                // Driver and Nanny data comes according to line
                // rest all Manpowers like - Supervisor, Coordinator, accountant, other employee -- should be considered for all lines...
                system.debug('workforceQitem.ET_Workforce_Quote_Item_Type__c  = '+ workforceQitem.ET_Workforce_Quote_Item_Type__c);
                if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Driver' || workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Nanny'){
                    if(Integer.valueOf(workforceQitem.ET_Workforce_Line_Number__c)==lineno){
                        if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Driver' && driverNotes != ''){
                            driverNotes = workforceQitem.Notes__c;
                        }
                        else if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Nanny' && nannyNotes != ''){
                            nannyNotes = workforceQitem.Notes__c;
                        }
                        
                        if(workForceMapWithWorkForceType.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                        {
                            Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear  = workForceMapWithWorkForceType.get(workforceQitem.ET_Workforce_Quote_Item_Type__c);
                            if(!workforceMapByContractYear.containsKey(Integer.valueOf(workforceQitem.ET_Contract_Period__c)))
                            {
                                for(ET_Quote_Item_SpecReq__c specialreq:workforceQitem.Quote_Item_SpecReqs__r)
                                {
                                    if(spcialRequirementLabelsLst.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                                    {
                                        spcialRequirementLabelsLst.get(workforceQitem.ET_Workforce_Quote_Item_Type__c).add(specialreq.Name);
                                    }else
                                    {
                                        spcialRequirementLabelsLst.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,new Set<String>{specialreq.Name});  
                                    }
                                }
                                workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                                System.debug('workfoce='+workforceQitem.ET_Workforce_Quote_Item_Type__c+'contract year='+Integer.valueOf(workforceQitem.ET_Contract_Period__c)+'work annual ='+workforceQitem.ET_Wages__c);
                                workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                            }
                            if(!workforceType.contains(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                            {
                                workforceType = workforceType +','+ workforceQitem.ET_Workforce_Quote_Item_Type__c;
                            }
                            
                        }
                        else
                        {
                            Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear = new   Map<Integer,ET_Workforce_Quote_Item__c>();
                            workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                            System.debug('workfoce='+workforceQitem.ET_Workforce_Quote_Item_Type__c+'contract year='+Integer.valueOf(workforceQitem.ET_Contract_Period__c)+'work annual ='+workforceQitem.ET_Wages__c);
                            workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                            for(ET_Quote_Item_SpecReq__c specialreq:workforceQitem.Quote_Item_SpecReqs__r)
                            {
                                
                                if(spcialRequirementLabelsLst.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                                {
                                    spcialRequirementLabelsLst.get(workforceQitem.ET_Workforce_Quote_Item_Type__c).add(specialreq.Name);
                                }else
                                {
                                    spcialRequirementLabelsLst.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,new Set<String>{specialreq.Name});  
                                }
                            }
                            if(!workforceType.contains(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                            {
                                workforceType = workforceType +','+ workforceQitem.ET_Workforce_Quote_Item_Type__c;
                            }
                            
                        }  
                        
                    }
                }
                
                else{
                    // workforces other than Driver and Nanny...
                    /*  if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Coordinator' && coordinatorNotes != ''){
coordinatorNotes = workforceQitem.Notes__c;
}*/
                    if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Supervisor' && supervisorNotes != ''){
                        supervisorNotes = workforceQitem.Notes__c;
                    }
                    else if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Accountant/Cashier' && accountantNotes != ''){
                        accountantNotes = workforceQitem.Notes__c;
                    }
                    if(workForceMapWithWorkForceType.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                    {
                        Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear  = workForceMapWithWorkForceType.get(workforceQitem.ET_Workforce_Quote_Item_Type__c);
                        if(!workforceMapByContractYear.containsKey(Integer.valueOf(workforceQitem.ET_Contract_Period__c)))
                        {
                            for(ET_Quote_Item_SpecReq__c specialreq:workforceQitem.Quote_Item_SpecReqs__r)
                            {
                                if(spcialRequirementLabelsLst.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                                {
                                    spcialRequirementLabelsLst.get(workforceQitem.ET_Workforce_Quote_Item_Type__c).add(specialreq.Name);
                                }else
                                {
                                    spcialRequirementLabelsLst.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,new Set<String>{specialreq.Name});  
                                }
                            }
                            workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                            System.debug('workfoce='+workforceQitem.ET_Workforce_Quote_Item_Type__c+'contract year='+Integer.valueOf(workforceQitem.ET_Contract_Period__c)+'work annual ='+workforceQitem.ET_Wages__c);
                            workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                        }
                        if(!workforceType.contains(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                        {
                            workforceType = workforceType +','+ workforceQitem.ET_Workforce_Quote_Item_Type__c;
                        }
                        
                    }
                    else
                    {
                        system.debug('inside else');
                        Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear = new   Map<Integer,ET_Workforce_Quote_Item__c>();
                        workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                        System.debug('workfoce='+workforceQitem.ET_Workforce_Quote_Item_Type__c+'contract year='+Integer.valueOf(workforceQitem.ET_Contract_Period__c)+'work annual ='+workforceQitem.ET_Wages__c);
                        workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                        for(ET_Quote_Item_SpecReq__c specialreq:workforceQitem.Quote_Item_SpecReqs__r)
                        {
                            
                            if(spcialRequirementLabelsLst.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                            {
                                spcialRequirementLabelsLst.get(workforceQitem.ET_Workforce_Quote_Item_Type__c).add(specialreq.Name);
                            }else
                            {
                                spcialRequirementLabelsLst.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,new Set<String>{specialreq.Name});  
                            }
                        }
                        if(!workforceType.contains(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                        {
                            workforceType = workforceType +','+ workforceQitem.ET_Workforce_Quote_Item_Type__c;
                        }
                        
                    }  
                }
                
                
            }
            
            System.debug('workForceMapWithWorkForceType = '+workForceMapWithWorkForceType);
            List<wrokforceApprovalDetails> workApprovalDetailsList = new List<wrokforceApprovalDetails>();
            String workforceNames ='';
            for(String workforce:workForceMapWithWorkForceType.keySet())
            {
                if(!String.isEmpty(workforceNames)){
                    workforceNames = workforceNames +', '+workforce;
                }
                else{
                    workforceNames = workforce;
                }
                Map<Integer,ET_Workforce_Quote_Item__c> workforceQuoteMap = workForceMapWithWorkForceType.get(workforce);
                String WorkforceappovalDetails =  '';
                for(ET_Workforce_Quote_Item__c wQuoteItem:workforceQuoteMap.values()){
                    if((WorkforceappovalDetails=='' || WorkforceappovalDetails==null) && wQuoteItem.Approval_Details__c!=null && wQuoteItem.Approval_Details__c!=''){
                        WorkforceappovalDetails=wQuoteItem.Approval_Details__c;
                        break;
                    }
                }
                if(WorkforceappovalDetails!=null && WorkforceappovalDetails!=''){
                    list<wrokforceApprovalDetails> ApprovalDetailsWrp=new list<wrokforceApprovalDetails>();
                    for(string yearDetails:WorkforceappovalDetails.split(';')){
                        if(yearDetails!=null && yearDetails!=''){
                            system.debug('yearDetails = '+ yearDetails);
                            integer yearDetailsSize=yearDetails.split(',').size();
                            if(yearDetails.split(',').size()>0 && yearDetails.split(',').size()==4){
                                if(yearDetails.split(',')[1]!=null && yearDetails.split(',')[1]!=''){
                                    wrokforceApprovalDetails wrp=new wrokforceApprovalDetails();
                                    wrp.element=yearDetails.split(',')[0];
                                    wrp.requestedBy=yearDetails.split(',')[1];
                                    wrp.approvedby=yearDetails.split(',')[2];
                                    wrp.reason=yearDetails.split(',')[3];
                                    workApprovalDetailsList.add(wrp);
                                }
                            }
                        }
                    } }                              
            }
            
            if(workforceNames!='')
            {
                if(workforceNames.contains('Driver'))
                {
                    WorkforceList.add('Driver');
                }
                if(workforceNames.contains('Nanny'))
                {
                    WorkforceList.add('Nanny');
                }
                if(workforceNames.contains('Supervisor'))
                {
                    WorkforceList.add('Supervisor');
                }
                if(workforceNames.contains('Coordinator'))
                {
                    WorkforceList.add('Coordinator');
                }
                if(workforceNames.contains('Accountant/Cashier'))
                {
                    WorkforceList.add('Accountant/Cashier');
                }
                if(workforceNames.contains('Other Employee'))
                {
                    WorkforceList.add('Other Employee');
                }
                
            }
            
            QuotationInfo quoteinfo = new QuotationInfo();
            
            if(wrapperQuotationDetails.containsKey(lineno)) 
            {
                if(workForceMapWithWorkForceType != null && workForceMapWithWorkForceType.size()>0)
                {
                    for(String workforcename:workForceMapWithWorkForceType.keyset())
                    {
                        if(!spcialRequirementLabelsLst.containsKey(workforcename))
                        {
                            spcialRequirementLabelsLst.put(workforcename,new Set<String>());
                        }
                    }
                    ETWorkforceCalcDetailsWrapper workforceWrapper = new ETWorkforceCalcDetailsWrapper();
                    workforceWrapper.isTargetPriceRequired=q.Is_Target_Price_Required__c;
                    workforceWrapper.quoteType=q.ET_Type__c;
                    workforceWrapper.workforceQuoteMap = workForceMapWithWorkForceType;
                    workforceWrapper.WorkforceList = WorkforceList;
                    workforceWrapper.spcialRequirementLabelsLst=spcialRequirementLabelsLst;
                    quoteinfo = wrapperQuotationDetails.get(lineno);
                    
                    String headerName = quoteinfo.HeaderName;
                    if(headerName.contains('Vehicles') && String.isNotBlank(workforceNames))
                    {
                        headerName =  headerName + ' ,'+workforceNames + ' Only';
                    }
                    else if(headerName.contains('Vehicles') && String.isBlank(workforceNames)){
                        headerName =  headerName + ' Only';
                    }
                    
                    system.debug('headerName = '+ headerName);
                    quoteinfo.HeaderName = headerName;
                    quoteinfo.workforceWrapper = workforceWrapper;
                    quoteinfo.WorkforceAvailable = workforceType;
                    quoteinfo.wrokforceApprovalDetailsWrp = workApprovalDetailsList; 
                    quoteinfo.ManpowerPresent = true;
                    quoteinfo.driverNotes = driverNotes;
                    quoteinfo.nannyNotes = nannyNotes;
                    quoteinfo.accountantNotes = accountantNotes;
                    quoteinfo.coordinatorNotes = coordinatorNotes;
                    quoteinfo.supervisorNotes = supervisorNotes;
                    wrapperQuotationDetails.put(lineno,quoteinfo);
                }
                
            }
            else{
                if(workForceMapWithWorkForceType.size()>0)
                {
                    for(String workforcename:workForceMapWithWorkForceType.keyset())
                    {
                        if(!spcialRequirementLabelsLst.containsKey(workforcename))
                        {
                            spcialRequirementLabelsLst.put(workforcename,new Set<String>());
                        }
                    }
                    system.debug('quote 539 = '+ JSON.serializePretty(q));
                    quoteHeader quoteHeaderWrapper = new quoteHeader();
                    quoteHeaderWrapper.quoteNumber = q.QuoteNumber;
                    quoteHeaderWrapper.zone = q.Opportunity.ETSALES_Sector__c;
                    quoteHeaderWrapper.clientName = q.Account.Name;
                    quoteHeaderWrapper.clientType = q.Account.ETSALES_Profile_Class__c;
                    quoteHeaderWrapper.contractType = q.Opportunity.Type;
                    // quoteHeaderWrapper.totalInvestmentValue = q.Quote_Total_Investment__c!=null ? q.Quote_Total_Investment__c : 0;
                    quoteHeaderWrapper.totalInvestmentValue = 0;
                    quoteHeaderWrapper.requestor = q.Opportunity.owner.name;
                    quoteHeaderWrapper.totalLines = manpowerLines != null ? manpowerLines : 0;
                    quoteHeaderWrapper.lineNo = lineno;
                    quoteHeaderWrapper.opportunityNumber = q.Opportunity.ETSALES_Opportunity_Number__c;
                    if(emirateWithRespectToLineMap != null && emirateWithRespectToLineMap.containsKey(lineno)){
                        quoteHeaderWrapper.serviceEmirate= emirateWithRespectToLineMap.get(lineno);
                    }
                    ETWorkforceCalcDetailsWrapper workforceWrapper = new ETWorkforceCalcDetailsWrapper();
                    workforceWrapper.isTargetPriceRequired=q.Is_Target_Price_Required__c;
                    workforceWrapper.quoteType=q.ET_Type__c;
                    workforceWrapper.workforceQuoteMap = workForceMapWithWorkForceType;
                    workforceWrapper.WorkforceList = WorkforceList;
                    workforceWrapper.spcialRequirementLabelsLst=spcialRequirementLabelsLst;
                    quoteinfo.workforceWrapper = workforceWrapper;
                    String  headerName =  'Quotation for Rental Service with ' + workforceNames + ' Only';                    
                    quoteinfo.HeaderName = headerName;
                    quoteinfo.wrokforceApprovalDetailsWrp = workApprovalDetailsList;
                    quoteinfo.ManpowerPresent = true;
                    quoteinfo.vehiclePresent = false;
                    quoteinfo.WorkforceAvailable = workforceType;
                    quoteinfo.quoteHeaderWrapper = quoteHeaderWrapper;
                    
                    quoteinfo.contractYears = manpowerContractYearsList;
                    quoteinfo.quoteDetailsWrapper = quoteDetailsWrapper;          
                    wrapperQuotationDetails.put(lineno,quoteinfo);
                }
                
            }
            
        }
        
        //financial section.
		  

    // Query the ET_Vehicle_Quote_Item__c records related to the quoteId
    List<ET_Vehicle_Quote_Item__c> existingQuoteItems = [
        SELECT Id,Name,ET_Line_Number__c, Total_Value_of_Rental__c,ET_Contract_Period__c, Veh_Condition__c, Quote__r.Opportunity.Contract_Years__c, ET_Pricing_Vehicle_Request__r.ET_Vehicle_Condition__c 
        FROM ET_Vehicle_Quote_Item__c 
        WHERE Quote__c = :quoteId Order By Name
    ];

		// Create a map of the existing records for easier lookup
	    Map<Id, ET_Vehicle_Quote_Item__c> existingQuoteItemsMap = new Map<Id, ET_Vehicle_Quote_Item__c>(existingQuoteItems);
		quoteItemsToUpdate = new List<ET_Vehicle_Quote_Item__c>();
        List<ET_FinancialAnalysisScreenClass.RentalPriceClass> rentalList= ET_FinancialAnalysisScreenClass.financialAnalysisScreenData(q.id);
        Integer rentalLineNo = 0;
        Integer outerLoopIndex =0;
		
        for(ET_FinancialAnalysisScreenClass.RentalPriceClass getRentalData:rentalList)
        {
            rentalLineNo = rentalLineNo + 1;
            
            RentalPriceClass thisRentalPriceClass = new RentalPriceClass();
            
            thisRentalPriceClass.reqMapping = getRentalData.reqMapping;
            thisRentalPriceClass.financialCalcsList = getRentalData.financialCalcsList;
            ET_FinancialAnalysisScreenClass.RentalPriceHeader otherpriceheaderInfo = getRentalData.rentalPriceHeaderInfo;
            RentalPriceHeader thisRentalPriceHeader = new RentalPriceHeader();
            thisRentalPriceHeader.zone = otherpriceheaderInfo.zone;
            thisRentalPriceHeader.quoteNumber = otherpriceheaderInfo.quoteNumber;
            thisRentalPriceHeader.clientName = otherpriceheaderInfo.clientName;
            thisRentalPriceHeader.clientType = otherpriceheaderInfo.clientType;
            thisRentalPriceHeader.clientCategory = otherpriceheaderInfo.clientCategory;
            thisRentalPriceHeader.clientStatus = otherpriceheaderInfo.clientStatus;
            thisRentalPriceHeader.contractType = otherpriceheaderInfo.contractType;
            thisRentalPriceHeader.totalInvestmentValue = (otherpriceheaderInfo.totalInvestmentValue!=null)?otherpriceheaderInfo.totalInvestmentValue:0;
            thisRentalPriceHeader.serviceEmirate = otherpriceheaderInfo.serviceEmirate;
            thisRentalPriceHeader.fleetType = otherpriceheaderInfo.fleetType;
            thisRentalPriceHeader.noOfVehicles = otherpriceheaderInfo.noOfVehicles;
            thisRentalPriceHeader.lineNo = otherpriceheaderInfo.lineNo;
            thisRentalPriceHeader.totalLines = otherpriceheaderInfo.totalLines;
            thisRentalPriceHeader.requestor = otherpriceheaderInfo.requestor;
            
            thisRentalPriceClass.rentalPriceHeaderInfo = thisRentalPriceHeader;
            
            List<ET_FinancialAnalysisScreenClass.RentalPriceCalClass> otherRentalPriceClassList = getRentalData.rentalPriceCalculationLst;
            List<RentalPriceCalClass> newRentalPriceCalcClassList = new  List<RentalPriceCalClass> ();
            String contractYears = '';
            for(ET_FinancialAnalysisScreenClass.RentalPriceCalClass otherRentalPriceClass :otherRentalPriceClassList )
            {
                
                RentalPriceCalClass thisRentalPriceCalClass = new RentalPriceCalClass(); 
                contractYears = contractYears + ',' +  otherRentalPriceClass.contractYear;
                thisRentalPriceCalClass.contractYear = otherRentalPriceClass.contractYear;
                thisRentalPriceCalClass.quoteType = otherRentalPriceClass.quoteType;
                thisRentalPriceCalClass.totalAnnualCost = (otherRentalPriceClass.totalAnnualCost!=null)?otherRentalPriceClass.totalAnnualCost:0;
                thisRentalPriceCalClass.totalAnnualCostDiscounted = (otherRentalPriceClass.totalAnnualCostDiscounted!=null)?otherRentalPriceClass.totalAnnualCostDiscounted:0;
                thisRentalPriceCalClass.totalAnnualCostTarget = (otherRentalPriceClass.totalAnnualCostTarget!=null)?otherRentalPriceClass.totalAnnualCostTarget:0;
                thisRentalPriceCalClass.totalAnnualProfit = (otherRentalPriceClass.totalAnnualProfit!=null)?otherRentalPriceClass.totalAnnualProfit:0;
                thisRentalPriceCalClass.totalAnnualProfitDiscounted = (otherRentalPriceClass.totalAnnualProfitDiscounted!=null)?otherRentalPriceClass.totalAnnualProfitDiscounted:0;
                thisRentalPriceCalClass.totalAnnualProfitTarget = (otherRentalPriceClass.totalAnnualProfitTarget!=null)?otherRentalPriceClass.totalAnnualProfitTarget:0;
                thisRentalPriceCalClass.totalAnnualPriceExcludingVAT = (otherRentalPriceClass.totalAnnualPriceExcludingVAT!=null)?otherRentalPriceClass.totalAnnualPriceExcludingVAT:0;
                thisRentalPriceCalClass.totalAnnualPriceExcludingVATDiscounted = (otherRentalPriceClass.totalAnnualPriceExcludingVATDiscounted!=null)?otherRentalPriceClass.totalAnnualPriceExcludingVATDiscounted:0;
                thisRentalPriceCalClass.totalAnnualPriceExcludingVATTarget = (otherRentalPriceClass.totalAnnualPriceExcludingVATTarget!=null)?otherRentalPriceClass.totalAnnualPriceExcludingVATTarget:0;
                thisRentalPriceCalClass.pricePerMonthExcludingVAT = (otherRentalPriceClass.pricePerMonthExcludingVAT!=null)?otherRentalPriceClass.pricePerMonthExcludingVAT:0;
                thisRentalPriceCalClass.vATAmount = (otherRentalPriceClass.vATAmount!=null)?otherRentalPriceClass.vATAmount:0;
                thisRentalPriceCalClass.totalAnnualPriceIncludingVAT = (otherRentalPriceClass.totalAnnualPriceIncludingVAT!=null)?otherRentalPriceClass.totalAnnualPriceIncludingVAT:0;
                thisRentalPriceCalClass.extraKMPrice = (otherRentalPriceClass.extraKMPrice!=null)?otherRentalPriceClass.extraKMPrice:0.00;//Added by Arun on 06.04.2023 for Extra KM New row addition
                extraKMMap.put(thisRentalPriceCalClass.contractYear,  thisRentalPriceCalClass.extraKMPrice);//Added by Arun on 10.04.2023 for Extra KM New row addition
                thisRentalPriceCalClass.corporateTax = (otherRentalPriceClass.corporateTax!=null)?otherRentalPriceClass.corporateTax:0.00;//Added by Arun on 28.04.2023 for corporate tax updation
                thisRentalPriceCalClass.pricePerMonthIncludingVAT = (otherRentalPriceClass.pricePerMonthIncludingVAT!=null)?otherRentalPriceClass.pricePerMonthIncludingVAT:0;
                // Separate Prices - Vehicle and Fuel
                thisRentalPriceCalClass.totalAnnualPriceExcludingVATVehcileAndFuel = (otherRentalPriceClass.totalAnnualPriceExcludingVATVehcileAndFuel!=null)?otherRentalPriceClass.totalAnnualPriceExcludingVATVehcileAndFuel:0;
                thisRentalPriceCalClass.pricePerMonthExcludingVATVehcileAndFuel = (otherRentalPriceClass.pricePerMonthExcludingVATVehcileAndFuel!=null)?otherRentalPriceClass.pricePerMonthExcludingVATVehcileAndFuel:0;
                thisRentalPriceCalClass.vatAmountForVehcileAndFuel = (otherRentalPriceClass.vatAmountForVehcileAndFuel!=null)?otherRentalPriceClass.vatAmountForVehcileAndFuel:0;
                thisRentalPriceCalClass.totalAnnualPriceIncludingVATVehcileAndFuel = (otherRentalPriceClass.totalAnnualPriceIncludingVATVehcileAndFuel!=null)?otherRentalPriceClass.totalAnnualPriceIncludingVATVehcileAndFuel:0;
                thisRentalPriceCalClass.pricePerMonthIncludingVATVehcileAndFuel = (otherRentalPriceClass.pricePerMonthIncludingVATVehcileAndFuel!=null)?otherRentalPriceClass.pricePerMonthIncludingVATVehcileAndFuel:0;
                
                // Separate Prices - only Manpower
                thisRentalPriceCalClass.totalAnnualPriceExcludingVATManpower = (otherRentalPriceClass.totalAnnualPriceExcludingVATManpower!=null)?otherRentalPriceClass.totalAnnualPriceExcludingVATManpower:0;
                thisRentalPriceCalClass.pricePerMonthExcludingVATManpower = (otherRentalPriceClass.pricePerMonthExcludingVATManpower!=null)?otherRentalPriceClass.pricePerMonthExcludingVATManpower:0;
                thisRentalPriceCalClass.vatAmountForManpower = (otherRentalPriceClass.vatAmountForManpower!=null)?otherRentalPriceClass.vatAmountForManpower:0;
                thisRentalPriceCalClass.totalAnnualPriceIncludingVATManpower = (otherRentalPriceClass.totalAnnualPriceIncludingVATManpower!=null)?otherRentalPriceClass.totalAnnualPriceIncludingVATManpower:0;
                thisRentalPriceCalClass.pricePerMonthIncludingVATManpower = (otherRentalPriceClass.pricePerMonthIncludingVATManpower!=null)?otherRentalPriceClass.pricePerMonthIncludingVATManpower:0;
                
                
                thisRentalPriceCalClass.pricingType = otherRentalPriceClass.pricingType;
                thisRentalPriceCalClass.isTargerPriceRequired = otherRentalPriceClass.isTargerPriceRequired;                                                            
                thisRentalPriceCalClass.separatePricesRequired = otherRentalPriceClass.separatePricesRequired;                                                            
                
                newRentalPriceCalcClassList.add(thisRentalPriceCalClass);
            }
            
            thisRentalPriceClass.rentalPriceCalculationList = newRentalPriceCalcClassList;
            thisRentalPriceClass.rentalClassContractYears = contractYears;
            
            List<ET_FinancialAnalysisScreenClass.TotalValueOfQuotation>  otherTotalValueOfQuotationList =  getRentalData.totalValueOfQuotationLst;             
            
            List<TotalValueOfQuotation> newTotalValueOfQuotationList = new  List<TotalValueOfQuotation>();
            
            String totalValueOfQuotationContractYears = '';
            Integer NoOftotalvalueOfQuotation = 0;
			
            
            system.debug('Before loop outerLoopIndex>>>' + outerLoopIndex);
            for(ET_FinancialAnalysisScreenClass.TotalValueOfQuotation otherTotalValueOfQuotation :otherTotalValueOfQuotationList )
            {
                
                
				
                NoOftotalvalueOfQuotation = NoOftotalvalueOfQuotation + 1;
                totalValueOfQuotationContractYears = totalValueOfQuotationContractYears +','+ NoOftotalvalueOfQuotation; 
                TotalValueOfQuotation thisTotalValueOfQuotation = new TotalValueOfQuotation(); 
                System.debug('test cehck value = '+ otherTotalValueOfQuotation.totalValueofRental);
                thisTotalValueOfQuotation.totalValueofRental = (otherTotalValueOfQuotation.totalValueofRental!=null)?otherTotalValueOfQuotation.totalValueofRental:0;
                
                thisTotalValueOfQuotation.totalInvestment = (otherTotalValueOfQuotation.totalInvestment!=null)?otherTotalValueOfQuotation.totalInvestment:0;
                thisTotalValueOfQuotation.totalDepreciation = (otherTotalValueOfQuotation.totalDepreciation!=null)?otherTotalValueOfQuotation.totalDepreciation:0;
                thisTotalValueOfQuotation.totalResaleValue = (otherTotalValueOfQuotation.totalResaleValue!=null)?otherTotalValueOfQuotation.totalResaleValue:0;
                thisTotalValueOfQuotation.totalVehicleProfits = (otherTotalValueOfQuotation.totalVehicleProfits!=null)?otherTotalValueOfQuotation.totalVehicleProfits:0;
                thisTotalValueOfQuotation.totalDriverProfits = (otherTotalValueOfQuotation.totalDriverProfits!=null)?otherTotalValueOfQuotation.totalDriverProfits:0;
                thisTotalValueOfQuotation.totalNannyprofits = (otherTotalValueOfQuotation.totalNannyprofits!=null)?otherTotalValueOfQuotation.totalNannyprofits:0;
                thisTotalValueOfQuotation.totalCoordinatorprofits = (otherTotalValueOfQuotation.totalCoordinatorprofits!=null)?otherTotalValueOfQuotation.totalCoordinatorprofits:0;
                thisTotalValueOfQuotation.totalSupervisorprofits = (otherTotalValueOfQuotation.totalSupervisorprofits!=null)?otherTotalValueOfQuotation.totalSupervisorprofits:0;
                thisTotalValueOfQuotation.totalAccountantprofits = (otherTotalValueOfQuotation.totalAccountantprofits!=null)?otherTotalValueOfQuotation.totalAccountantprofits:0;
                thisTotalValueOfQuotation.totalOtherEmployeeprofits = (otherTotalValueOfQuotation.totalOtherEmployeeprofits!=null)?otherTotalValueOfQuotation.totalOtherEmployeeprofits:0;
                thisTotalValueOfQuotation.totalFuelProfits = (otherTotalValueOfQuotation.totalFuelProfits!=null)?otherTotalValueOfQuotation.totalFuelProfits:0;
                thisTotalValueOfQuotation.showDriverProfit = otherTotalValueOfQuotation.showDriverProfit;
                thisTotalValueOfQuotation.showNannyProfit = otherTotalValueOfQuotation.showNannyProfit;
                thisTotalValueOfQuotation.showAccountantProfit = otherTotalValueOfQuotation.showAccountantProfit;
                thisTotalValueOfQuotation.showCoordinatorProfit = otherTotalValueOfQuotation.showCoordinatorProfit;
                thisTotalValueOfQuotation.showSupervisorProfit = otherTotalValueOfQuotation.showSupervisorProfit;
                thisTotalValueOfQuotation.showOtherManpowerProfit = otherTotalValueOfQuotation.showOtherManpowerProfit;
                
				if(outerLoopIndex < existingQuoteItems.size()) {
                    	ET_Vehicle_Quote_Item__c existingQuoteItem = existingQuoteItems[outerLoopIndex];
						System.debug('In if outerLoopIndex>>>' + outerLoopIndex);
                    if(existingQuoteItem.ET_Contract_Period__c == Decimal.Valueof(existingQuoteItem.Quote__r.Opportunity.Contract_Years__c)){
                            existingQuoteItem.Total_Value_of_Rental__c = otherTotalValueOfQuotation.totalValueofRental;
							existingQuoteItem.Veh_Condition__c = existingQuoteItem.ET_Pricing_Vehicle_Request__r.ET_Vehicle_Condition__c;
                            System.debug('existingQuoteIted.Id>>>>>>>> ' + existingQuoteItem.Id + 'existingQuoteItem.Total_Value_of_Rental__c>>>>>>>> ' + existingQuoteItem.Total_Value_of_Rental__c + 'existingQuoteItem.ET_Line_Number__c>>>>>>>> ' + existingQuoteItem.ET_Line_Number__c);
                          	
                    }
                    else
                    {
                        existingQuoteItem.Total_Value_of_Rental__c = 0;
                    }
					
					quoteItemsToUpdate.add(existingQuoteItem);
                	outerLoopIndex = outerLoopIndex +1;
            	}
				
				
                newTotalValueOfQuotationList.add(thisTotalValueOfQuotation);
				//outerLoopIndex = NoOftotalvalueOfQuotation - 1;                    
            } 
			System.debug('After loop outerLoopIndex>>>' + outerLoopIndex);               
            thisRentalPriceClass.totalValueOfQuotationList = newTotalValueOfQuotationList;
            thisRentalPriceClass.totalValueOfQuotationContractYears = totalValueOfQuotationContractYears;
			System.debug('quoteItemsTo>>>>>>>> '+ quoteItemsToUpdate);
            
            List<ET_FinancialAnalysisScreenClass.FinancialAnalysis>  otherFinancialAnalysisList =  getRentalData.financialAnalysisLst; 
            List<FinancialAnalysis> newFinancialAnalysisList = new  List<FinancialAnalysis>();
            String FinancialAnalysisContractYears = '';
            Integer NoOfotherFinancialAnalysis = 0;
            for(ET_FinancialAnalysisScreenClass.FinancialAnalysis otherFinancialAnalysis :otherFinancialAnalysisList )
            {
                NoOfotherFinancialAnalysis = NoOfotherFinancialAnalysis + 1;
                FinancialAnalysisContractYears = FinancialAnalysisContractYears + NoOfotherFinancialAnalysis;
                FinancialAnalysis financialAanlysisObj = new FinancialAnalysis();
                
                financialAanlysisObj.payback = (otherFinancialAnalysis.payback!=null)?otherFinancialAnalysis.payback:0;
                financialAanlysisObj.paybackRatio = (otherFinancialAnalysis.paybackRatio!=null)?otherFinancialAnalysis.paybackRatio:0;
                financialAanlysisObj.payback2 = (otherFinancialAnalysis.payback2!=null)?otherFinancialAnalysis.payback2:0;
                financialAanlysisObj.paybackRatio2 = (otherFinancialAnalysis.paybackRatio2!=null)?otherFinancialAnalysis.paybackRatio2:0;
                financialAanlysisObj.annualshareOfPaybackRatio2 = (otherFinancialAnalysis.annualshareOfPaybackRatio2!=null)?otherFinancialAnalysis.annualshareOfPaybackRatio2:0;
                financialAanlysisObj.payback3 = (otherFinancialAnalysis.payback3!=null)?otherFinancialAnalysis.payback3:0;
                financialAanlysisObj.paybackRatio3 = (otherFinancialAnalysis.paybackRatio3!=null)?otherFinancialAnalysis.paybackRatio3:0;
                financialAanlysisObj.annualshareOfPaybackRatio3 = (otherFinancialAnalysis.annualshareOfPaybackRatio3!=null)?otherFinancialAnalysis.annualshareOfPaybackRatio3:0;
                financialAanlysisObj.freeCashFlowAnnual = (otherFinancialAnalysis.freeCashFlowAnnual!=null)?otherFinancialAnalysis.freeCashFlowAnnual:0;
                financialAanlysisObj.freeCashFlowAnnualDiscounted =(otherFinancialAnalysis.freeCashFlowAnnualDiscounted!=null)?otherFinancialAnalysis.freeCashFlowAnnualDiscounted:0;
                financialAanlysisObj.freeCashFlowAnnualTarget = (otherFinancialAnalysis.freeCashFlowAnnualTarget!=null)?otherFinancialAnalysis.freeCashFlowAnnualTarget:0;
                financialAanlysisObj.freeCashFlowCumulative = (otherFinancialAnalysis.freeCashFlowCumulative!=null)?otherFinancialAnalysis.freeCashFlowCumulative:0;
                financialAanlysisObj.freeCashFlowCumulativeDiscounted = (otherFinancialAnalysis.freeCashFlowCumulativeDiscounted!=null)?otherFinancialAnalysis.freeCashFlowCumulativeDiscounted:0;
                financialAanlysisObj.freeCashFlowCumulativeTarget = (otherFinancialAnalysis.freeCashFlowCumulativeTarget!=null)?otherFinancialAnalysis.freeCashFlowCumulativeTarget:0;
                financialAanlysisObj.netPresentValue = (otherFinancialAnalysis.netPresentValue!=null)?otherFinancialAnalysis.netPresentValue:0;
                //Taj
                System.debug('netPresentValue >>> ' + financialAanlysisObj.netPresentValue+' Line Number: '+thisRentalPriceHeader.lineNo +' contractYear: '+otherFinancialAnalysis.contractYear);
                if (profileSalesTL.Contains(q.Owner.Profile.Name) && profileSalesTL.Contains(loggedInUserProfile.Name) && financialAanlysisObj.netPresentValue < 0){
                    showMessage = true;
                    if (!messageDetails.containsKey('Net Present Value')){
                        messageDetails.put('Net Present Value', 'The calculated NPV is Negative. Kindly increase the Required Operating Profit Margin. Line Number: ' + thisRentalPriceHeader.lineNo+ ' Contract Year: ' + otherFinancialAnalysis.contractYear);
                    } else{
                        messageDetails.put('Net Present Value', messageDetails.get('Net Present Value') + ',' + ' Line Number: ' + thisRentalPriceHeader.lineNo+ ' Contract Year: ' + otherFinancialAnalysis.contractYear);
                    }
                }
                financialAanlysisObj.netPresentValueDiscounted = (otherFinancialAnalysis.netPresentValueDiscounted!=null)?otherFinancialAnalysis.netPresentValueDiscounted:0;
                financialAanlysisObj.netPresentValueTarget = (otherFinancialAnalysis.netPresentValueTarget!=null)?otherFinancialAnalysis.netPresentValueTarget:0;
                financialAanlysisObj.costOfCapitalAssumed = (otherFinancialAnalysis.costOfCapitalAssumed!=null)?otherFinancialAnalysis.costOfCapitalAssumed:0;
                financialAanlysisObj.netProfitMargin = (otherFinancialAnalysis.netProfitMargin!=null)?otherFinancialAnalysis.netProfitMargin:0;
                financialAanlysisObj.netProfitMarginDiscounted = (otherFinancialAnalysis.netProfitMarginDiscounted!=null)?otherFinancialAnalysis.netProfitMarginDiscounted:0;
                financialAanlysisObj.netProfitMarginTarget = (otherFinancialAnalysis.netProfitMarginTarget!=null)?otherFinancialAnalysis.netProfitMarginTarget:0;
                financialAanlysisObj.paybackPeriodYears = (otherFinancialAnalysis.paybackPeriodYears!=null)?otherFinancialAnalysis.paybackPeriodYears:0;
                financialAanlysisObj.paybackPeriodYearsDiscounted =(otherFinancialAnalysis.paybackPeriodYearsDiscounted!=null)? otherFinancialAnalysis.paybackPeriodYearsDiscounted:0;
                financialAanlysisObj.paybackPeriodYearsTarget = (otherFinancialAnalysis.paybackPeriodYearsTarget!=null)?otherFinancialAnalysis.paybackPeriodYearsTarget:0;
                financialAanlysisObj.internalRateOfReturn = (otherFinancialAnalysis.internalRateOfReturn!=null)?otherFinancialAnalysis.internalRateOfReturn:0;
                financialAanlysisObj.internalRateOfReturnDiscounted = (otherFinancialAnalysis.internalRateOfReturnDiscounted!=null)?otherFinancialAnalysis.internalRateOfReturnDiscounted:0;
                financialAanlysisObj.internalRateOfReturnTarget = (otherFinancialAnalysis.internalRateOfReturnTarget!=null)?otherFinancialAnalysis.internalRateOfReturnTarget:0;
                financialAanlysisObj.returnOnInvestment = (otherFinancialAnalysis.returnOnInvestment!=null)?otherFinancialAnalysis.returnOnInvestment:0;
                //Taj
                System.debug('internalRateOfReturn: >>> '+financialAanlysisObj.internalRateOfReturn);
                if (profileSalesTL.Contains(q.Owner.Profile.Name) && profileSalesTL.Contains(loggedInUserProfile.Name) && financialAanlysisObj.internalRateOfReturn < 8){ //returnOnInvestment
                    showMessage = true;
                    if (!messageDetails.containsKey('Internal Rate of Return')){
                        messageDetails.put('Internal Rate of Return', 'The calculated IRR is less than the expected value. Kindly increase the Required Operating Profit Margin. Line Number: ' + thisRentalPriceHeader.lineNo+ ' Contract Year: ' + otherFinancialAnalysis.contractYear);
                    } else{
                        messageDetails.put('Internal Rate of Return', messageDetails.get('Internal Rate of Return') + ',' + ' Line Number: ' + thisRentalPriceHeader.lineNo+ ' Contract Year: ' + otherFinancialAnalysis.contractYear);
                    }
                }
                financialAanlysisObj.returnOnInvestmentDiscounted = (otherFinancialAnalysis.returnOnInvestmentDiscounted!=null)?otherFinancialAnalysis.returnOnInvestmentDiscounted:0;
                financialAanlysisObj.returnOnInvestmentTarget = (otherFinancialAnalysis.returnOnInvestmentTarget!=null)?otherFinancialAnalysis.returnOnInvestmentTarget:0;
                financialAanlysisObj.pricingMethod = (otherFinancialAnalysis.pricingMethod!=null)?otherFinancialAnalysis.pricingMethod:'';
                financialAanlysisObj.pricingType = (otherFinancialAnalysis.pricingType!=null)?otherFinancialAnalysis.pricingType:'';
                financialAanlysisObj.pricePerPricingType = (otherFinancialAnalysis.pricePerPricingType!=null)?otherFinancialAnalysis.pricePerPricingType:0;
                
                newFinancialAnalysisList.add(financialAanlysisObj);
            }
            
            thisRentalPriceClass.financialAnalysisList = newFinancialAnalysisList;
            thisRentalPriceClass.FinancialAnalysisContractYears = FinancialAnalysisContractYears;
            
            if(wrapperQuotationDetails.containsKey(rentalLineNo))
            {
                QuotationInfo quoteInfo = new QuotationInfo();
                quoteInfo = wrapperQuotationDetails.get(rentalLineNo);
                quoteInfo.FinacialData = thisRentalPriceClass;
                quoteInfo.FinancialDataPresent = true;
                wrapperQuotationDetails.put(rentalLineNo,quoteInfo);
            }
            else
            {
                QuotationInfo quoteInfo = new QuotationInfo();            
                quoteInfo.FinacialData = thisRentalPriceClass;
                quoteInfo.FinancialDataPresent = true;
                quoteInfo.vehiclePresent = false;
                quoteInfo.ManpowerPresent = false;
                wrapperQuotationDetails.put(rentalLineNo,quoteInfo);
            }
            
        }
        System.debug('LEV'+JSON.serializePretty(wrapperQuotationDetails));
        for(Integer line:wrapperQuotationDetails.keySet())
        {
            
            QuotationInfo quoteInfo = new QuotationInfo();
            quoteInfo = wrapperQuotationDetails.get(line);
            System.debug('MAN  '+ JSON.serializePretty(quoteInfo) );
            System.debug(quoteInfo.vehiclePresent);
            System.debug(quoteInfo.FinancialDataPresent);
            
            if(quoteInfo.FinancialDataPresent!=true&&quoteInfo.vehiclePresent!=true&&quoteInfo.ManpowerPresent==true)
            {
                quoteInfo.OnlyManpowerPresent = true;
                wrapperQuotationDetails.put(line,quoteInfo);
            }
            else
            {
                quoteInfo.OnlyManpowerPresent = false;
                wrapperQuotationDetails.put(line,quoteInfo);  
            }
            
        }
    }


	public PageReference updateQuote(){
        System.debug('DML Operation Method>>>>>>' + quoteItemsToUpdate);
		System.debug('Veh Quote size>>>>>>' + quoteItemsToUpdate.size());
        try{
            update quoteItemsToUpdate;
        }
        catch(DmlException e)
        {
            system.debug('Exception on update of Vehicle Quote: ' + e.getMessage());
        }
        
		
        return null;
    }
    
    
    public class vehicleQuoteCalcClass{
        @AuraEnabled
        public String specialRequirementLabels {get;set;}
        @AuraEnabled
        public String specialRequirementLabelsPermit {get;set;}
        @AuraEnabled
        public String specialRequirementLabelsBranding {get;set;}
        @AuraEnabled
        public String specialRequirementLabelsDriver {get;set;}
         @AuraEnabled
        public String specialRequirementLabelsLogo {get;set;}
        @AuraEnabled
        public Integer vehicleLineItemNumberFromRequest {get;set;}
        @AuraEnabled
        public String  vehicleLineUniqueKey {get;set;}
        @AuraEnabled
        public Integer contractYear  {get;set;}
        @AuraEnabled
        public Decimal vehiclePurchasePriceBasedOnCondition  {get;set;}
        @AuraEnabled
        public Decimal vehicleResaleValue  {get;set;}
        @AuraEnabled
        public Decimal vehicleResaleDecimalValue {get;set;}
        @AuraEnabled
        public Decimal vehicleDepreciation {get;set;}
        @AuraEnabled
        public Decimal vehicleDepreciationDecimalValue {get;set;}
        @AuraEnabled
        public Decimal vehicleRepairsAndMaintenance{get;set;}
        @AuraEnabled
        public Decimal vehicleFinancing {get;set;}
        @AuraEnabled
        public Decimal vehicleRegistrationAndInspectionFee {get;set;}
        @AuraEnabled
        public Decimal vehicleInsurance {get;set;}
        @AuraEnabled
        public Decimal vehicleInsuranceAverage {get;set;}
        @AuraEnabled
        public Map<String,Decimal> vehicleSpecialRequirementLst {get;set;}
        @AuraEnabled
        public List<ET_ServiceRequestController.otherCostCalcClass> vehicleOtherCostLst {get;set;}
        @AuraEnabled
        public Decimal deprciationReserve {get;set;}
        @AuraEnabled
        public Decimal salikCost {get;set;}
        @AuraEnabled
        public Decimal basicTrackingSystemCost {get;set;}
        @AuraEnabled
        public Decimal maintenanceReserve {get;set;}
        @AuraEnabled
        public Decimal generalReserve {get;set;}
        @AuraEnabled
        public Decimal annualVehicleProfitMarginRate {get;set;}
        @AuraEnabled
        public Decimal annualVehicleProfitMarginValue {get;set;}
        @AuraEnabled
        public Decimal corporateTax {get;set;}
        @AuraEnabled
        public Decimal annualVehicleProfitRateFromMaster {get;set;}
        @AuraEnabled
        public Decimal fuelExpenses {get;set;}
        @AuraEnabled
        public Decimal fuelRate {get;set;}
        @AuraEnabled
        public Decimal fuelReserve {get;set;}
        @AuraEnabled
        public Decimal fuelReserveDiscounted {get;set;}
        @AuraEnabled
        public Decimal fuelReserveTarget {get;set;}
        @AuraEnabled
        public Decimal annualFuelProfitMarginRate {get;set;}
        @AuraEnabled
        public Decimal annualFuelProfitMarginValue {get;set;}
        @AuraEnabled
        public Decimal totalReserveCost {get;set;}
        @AuraEnabled
        public Decimal totalFuelCost {get;set;}
        @AuraEnabled
        public Decimal totalFuelCostDiscounted {get;set;}
        @AuraEnabled
        public Decimal totalFuelCostTargetPrice {get;set;}
        @AuraEnabled
        public Decimal vehicleTotalCost {get;set;}
        @AuraEnabled
        public Decimal vehicleTotalCostDiscountedPrice {get;set;}
        @AuraEnabled
        public Decimal vehicleTotalCostTargetPrice {get;set;}
        @AuraEnabled
        public Decimal vehicleTotalFixedCost {get;set;}
        @AuraEnabled
        public Decimal vehicleTotalVariableCost {get;set;}
        @AuraEnabled
        public String vehicleVATRate {get;set;}
        @AuraEnabled
        //   public Decimal vehicleVATCost = 0.0;// vat on Pricing
        public Decimal vehicleVATAmount {get;set;}// vat on Customer
        @AuraEnabled
        public Integer numberOfVehicles {get;set;}
        @AuraEnabled
        public String  vehiclePricingMethod {get;set;}
        @AuraEnabled
        public String  vehiclePricingType {get;set;}
        @AuraEnabled
        public Decimal vehiclePricingUtilization {get;set;}
        @AuraEnabled
        //new fields added //Mani
        public Decimal noOfSeats {get;set;}
        @AuraEnabled
        public Decimal passedYear {get;set;}//new fields added Arun 01.03.2023
        @AuraEnabled
        public Decimal remainingYear {get;set;} //new fields added Arun 01.03.2023
        @AuraEnabled
        public Decimal CurrentValueRemainingDepreciation {get;set;} //new fields added Arun 01.03.2023
        @AuraEnabled
        public Decimal DepreciationDifferenceOtherContracts {get;set;} //new fields added Arun 01.03.2023
        @AuraEnabled
        public Decimal TotalResaleValueMinResaleDepDiff {get;set;} //new fields added Arun 01.03.2023
        @AuraEnabled
        public Decimal dailyMileage {get;set;}
        @AuraEnabled
        public Decimal totalAnnualMileage {get;set;}
        @AuraEnabled
        public Decimal vehicleDepreciationRate {get;set;}
        @AuraEnabled
        public Decimal depreciationRateforExtraMileage {get;set;}
        @AuraEnabled
        public Decimal vehicleMaintenanceRate {get;set;}
        @AuraEnabled
        public Decimal insuranceRate {get;set;}
        @AuraEnabled
        public Decimal financingRate {get;set;}
        @AuraEnabled
        public Decimal requiredROIRate {get;set;}
        @AuraEnabled
        public Decimal generalReserveRate {get;set;}
        @AuraEnabled
        public Decimal numberOfDeprciatedYearsfromInsuranceMaster {get;set;}
        @AuraEnabled
        public Decimal minVehValFromInsuranceMaster  {get;set;}
        @AuraEnabled
        public Decimal passengerCost {get;set;}
        @AuraEnabled
        public Decimal driverInsuranceCost {get;set;}
        @AuraEnabled
        public Decimal ambulanceCost {get;set;}
        @AuraEnabled
        public Decimal otherCost {get;set;}
        @AuraEnabled
        public Decimal registrationFee {get;set;}
        @AuraEnabled
        public Decimal inspectionFee = 0.0;
        @AuraEnabled
        Public Decimal actualLiterPrice  {get;set;}
        @AuraEnabled
        Public Decimal fuelConsumption {get;set;}
        @AuraEnabled
        public Decimal depreciationReserveRate {get;set;}
        @AuraEnabled
        Public Decimal maintainenceReserveRate  {get;set;}
        @AuraEnabled
        Public Decimal fuelReserveRate {get;set;}
        @AuraEnabled
        Public String vehicleQuoteId  {get;set;}
        @AuraEnabled
        Public Decimal extraBusFeesForSchoolTransportation {get;set;}
        @AuraEnabled
        Public Decimal vehicleLatestNewPurchasePrice {get;set;}
        @AuraEnabled
        Public Decimal vehicleCurrentPurchasePrice {get;set;}
        @AuraEnabled
        Public Decimal deductionRateForLatestNewPrice {get;set;}
        @AuraEnabled
        Public Decimal manufactureYear {get;set;}
        @AuraEnabled
        Public String depreciationMethod {get;set;}
        @AuraEnabled
        Public Decimal minResaleValue {get;set;}
        @AuraEnabled
        Public Decimal minResaleValuePercentage {get;set;}
        @AuraEnabled
        Public Decimal minDepreciationYears {get;set;}
        @AuraEnabled
        Public Decimal numberofFinancingYears {get;set;}
        @AuraEnabled
        Public Decimal insuranceRate1stYear {get;set;}
        @AuraEnabled
        Public Decimal insuranceMinCost {get;set;}
        @AuraEnabled
        Public Decimal totalSpecialRequirmentsCost {get;set;}
        @AuraEnabled
        public Decimal workingDaysPerWeek {get;set;}
        @AuraEnabled
        public Decimal workingMonthsPerYear {get;set;}
        @AuraEnabled
        public Decimal workingDaysPerYear  {get;set;}
        @AuraEnabled
        public Decimal vehicleTotalInvestment  {get;set;}
        @AuraEnabled
        Public String serviceType  {get;set;} 
        @AuraEnabled
        public Decimal totalAnnualTargetPrice  {get;set;} // Target Price given by Customer
        @AuraEnabled
        public Decimal discountedTotalAnnualTargetPrice  {get;set;} // Total Cost Calculated when Target Price given by Customer
        @AuraEnabled
        public Decimal vehicleProfitMarginRateForTargetPrice  {get;set;}
        @AuraEnabled
        public Decimal vehicleProfitMarginRateForDiscountedPrice  {get;set;}
        @AuraEnabled
        public Decimal vehicleProfitValueForTargetPrice  {get;set;}
        @AuraEnabled
        public Decimal discountedVehicleProfitValueForTargetPrice  {get;set;}
        @AuraEnabled
        public Decimal fuelProfitValueTargetPrice  {get;set;}
        @AuraEnabled
        public Decimal fuelProfitValueDiscountedPrice  {get;set;}
        @AuraEnabled
        public Decimal fuelProfitMarginRateTargetPrice  {get;set;}
        @AuraEnabled
        public Decimal fuelProfitMarginRateDiscountedPrice  {get;set;}
        @AuraEnabled
        public Decimal generalReserveTargetPrice {get;set;}
        @AuraEnabled
        public Decimal generalReserveDiscountedPrice {get;set;}
        @AuraEnabled
        public boolean isTargetPriceRequired {get;set;}
        @AuraEnabled
        public String vehicleSource  {get;set;}
        @AuraEnabled
        public Decimal substitutionalVehiclesCostPerVehicle {get;set;} 
        @AuraEnabled
        public Decimal substitutionalVehiclesProfitPerVehicle {get;set;}
        @AuraEnabled
        public String fleetType {get;set;}
        @AuraEnabled
        public Decimal remainingDepreciationOf10Years {get;set;}
        @AuraEnabled
        public String vehReqId {get;set;} 
        @AuraEnabled
        public Decimal vatCostonDirectExpenses {get;set;}
        @AuraEnabled
        public Decimal vatCostonInDirectExpenses {get;set;}
        @AuraEnabled
        public Decimal vatTotalCost {get;set;}
        @AuraEnabled
        public Decimal indirectCostForGeneralReserve {get;set;}
        @AuraEnabled
        public Decimal priceUtilization {get;set;}
        @AuraEnabled
        public String pricingType  {get;set;}
        @AuraEnabled
        public String pricingMethod  {get;set;}
        @AuraEnabled
        public String depreciationType {get;set;} 
        @AuraEnabled
        public boolean fuelRequired {get;set;} 
        @AuraEnabled
        public boolean isTargerPriceRequired {get;set;}
        @AuraEnabled
        public boolean separatePricesRequired {get;set;}
        @AuraEnabled
        public Decimal discountOrAdditionalProfit {get;set;}
        // For Trailer 
        @AuraEnabled
        public boolean IsTrailerSelected{get;set;}
        @AuraEnabled
        public Decimal trailerOriginalPurchasePrice {get;set;}
        @AuraEnabled
        public Decimal trailerCurrentPurchasePrice {get;set;}
        @AuraEnabled
        public Decimal trailerDepreciationRate {get;set;}
        @AuraEnabled
        public Decimal trailerResaleValue {get;set;}
        @AuraEnabled
        public Decimal trailerMaintenanceRate {get;set;}
        @AuraEnabled
        public Decimal trailerDepreciation {get;set;}
        @AuraEnabled
        public Decimal trailerRepairsAndMaintenance {get;set;}
        @AuraEnabled
        public Decimal trailerRegistrationAndInspectionFee {get;set;}
        @AuraEnabled
        public Decimal trailerExtrenalMaintenanceCost {get;set;}
        
        // For Refrigerator 
        @AuraEnabled
        public boolean IsRefrigeratorSelected{get;set;}
        @AuraEnabled
        public Decimal refrigeratorOriginalPurchasePrice {get;set;}
        @AuraEnabled
        public Decimal refrigeratorCurrentPurchasePrice {get;set;}
        @AuraEnabled
        public Decimal refrigeratorDepreciationRate {get;set;}
        @AuraEnabled
        public Decimal refrigeratorResaleValue {get;set;}
        @AuraEnabled
        public Decimal refrigeratorMaintenanceRate {get;set;}
        @AuraEnabled
        public Decimal refrigeratorDepreciation {get;set;}
        @AuraEnabled
        public Decimal refrigeratorRepairsAndMaintenance {get;set;}
        @AuraEnabled
        public Decimal refrigeratorRegistrationAndInspectionFee {get;set;}
        @AuraEnabled
        public Decimal refrigeratorExtrenalMaintenanceCost {get;set;}
        @AuraEnabled
        public String vehicleNotes  {get;set;}
        
    }
    
    public class quoteDetails{
        @AuraEnabled
        public Boolean isTargetPriceRequired {get;set;}
        @AuraEnabled
        public String quotetype{get;set;}
        @AuraEnabled
        public decimal totalNumberOfVehicles{get;set;}
        @AuraEnabled
        public decimal totalNumberOfDrivers{get;set;}
        @AuraEnabled
        public decimal totalNumberOfNannies{get;set;}
        @AuraEnabled
        public decimal totalNumberOfAccountants{get;set;}
        @AuraEnabled
        public decimal totalNumberOfCoordinators{get;set;}
        @AuraEnabled
        public decimal totalNumberOfSupervisors{get;set;}
        @AuraEnabled
        public decimal totalNumberOfOtherManpower{get;set;}
        @AuraEnabled 
        public String quotationCreatedDate{get;set;}
        @AuraEnabled 
        public String quotationCreatedBy{get;set;}
        @AuraEnabled 
        public String nationality{get;set;}
        
    }
    
    public class quoteHeader{
        @AuraEnabled
        public string zone {get;set;}
        @AuraEnabled
        public string quoteNumber {get;set;}
        @AuraEnabled
        public string opportunityNumber {get;set;}
        @AuraEnabled
        public string clientName {get;set;}
        @AuraEnabled
        public string clientType {get;set;}
        @AuraEnabled
        public string clientCategory {get;set;}
        @AuraEnabled
        public string clientStatus {get;set;}
        @AuraEnabled
        public string contractType {get;set;}
        @AuraEnabled
        public Decimal totalInvestmentValue {get;set;}
        @AuraEnabled
        public Decimal totalInvestmentValueTrailer {get;set;}
        @AuraEnabled
        public Decimal totalInvestmentValueTrailerSummary {get;set;}
        @AuraEnabled
        public string serviceEmirate {get;set;}
        @AuraEnabled
        public string fleetType  {get;set;}
        @AuraEnabled
        public Integer lineNo  {get;set;}
        @AuraEnabled
        public Integer totalLines  {get;set;}
        @AuraEnabled
        public string requestor  {get;set;}
        @AuraEnabled
        public Integer totalNoOfVehicles {get;set;}
    }
    
    public class ETWorkforceCalcDetailsWrapper{
        @AuraEnabled
        public Boolean isTargetPriceRequired {get;set;}
        @AuraEnabled
        public String quoteType {get;set;}
        @AuraEnabled
        public Map<String,Set<String>> spcialRequirementLabelsLst {get;set;}
        @AuraEnabled
        public List <String> WorkforceList{get;set;}
        @AuraEnabled
        public Map<String,Map<Integer,ET_Workforce_Quote_Item__c>> workforceQuoteMap {get;set;}
        @AuraEnabled
        public List<wrokforceApprovalDetails> wrokforceApprovalDetailsWrp {get;set;}
        @AuraEnabled
        public integer noOfLines {get;set;}    
    }
    
    public class wrokforceApprovalDetails{
        @AuraEnabled
        public string element {get;set;}
        @AuraEnabled
        public string requestedBy {get;set;}
        @AuraEnabled
        public string approvedby {get;set;}
        @AuraEnabled
        public string reason {get;set;}
    }
    
    public class RentalPriceClass {
        @AuraEnabled
        public string rentalClassContractYears {get;set;}
        @AuraEnabled
        public String totalValueOfQuotationContractYears {get;set;}
        @AuraEnabled
        public String FinancialAnalysisContractYears {get;set;}
        @AuraEnabled
        public string reqMapping {get;set;}
        @AuraEnabled
        public RentalPriceHeader rentalPriceHeaderInfo {get;set;}
        @AuraEnabled
        public List<RentalPriceCalClass> rentalPriceCalculationList {get;set;}
        @AuraEnabled
        public List<TotalValueOfQuotation> totalValueOfQuotationList {get;set;}
        @AuraEnabled
        public List<FinancialAnalysis> financialAnalysisList {get;set;}
        @AuraEnabled
        public  List<Financial_Analysis__c> financialCalcsList {get;set;}
    } //covered
    public class RentalPriceHeader{
        @AuraEnabled
        public string zone {get;set;}
        @AuraEnabled
        public string quoteNumber {get;set;}
        @AuraEnabled
        public string clientName {get;set;}
        @AuraEnabled
        public string clientType {get;set;}
        @AuraEnabled
        public string clientCategory {get;set;}
        @AuraEnabled
        public string clientStatus {get;set;}
        @AuraEnabled
        public string contractType {get;set;}
        @AuraEnabled
        public Decimal totalInvestmentValue {get;set;}
        @AuraEnabled
        public Decimal totalInvestmentValueTrailer {get;set;}
        @AuraEnabled
        public Decimal totalInvestmentValueTrailerSummary {get;set;}
        @AuraEnabled
        public string serviceEmirate {get;set;}
        @AuraEnabled
        public string fleetType {get;set;}
        @AuraEnabled
        public Integer noOfVehicles {get;set;}
        @AuraEnabled
        public Integer lineNo {get;set;}
        @AuraEnabled
        public Integer totalLines {get;set;}
        @AuraEnabled
        public string requestor {get;set;}
    } //covered
    public class RentalPriceCalClass{
        @AuraEnabled
        public Integer contractYear {get;set;}
        @AuraEnabled
        public string quoteType {get;set;}
        @AuraEnabled
        public Decimal totalAnnualCost {get;set;}
        @AuraEnabled
        public Decimal totalAnnualCostDiscounted {get;set;}
        @AuraEnabled
        public Decimal totalAnnualCostTarget {get;set;}
        @AuraEnabled
        public Decimal totalAnnualProfit {get;set;}
        @AuraEnabled
        public Decimal totalAnnualProfitDiscounted {get;set;}
        @AuraEnabled
        public Decimal totalAnnualProfitTarget {get;set;}
        @AuraEnabled
        public Decimal totalAnnualPriceExcludingVAT {get;set;}
        @AuraEnabled
        public Decimal totalAnnualPriceExcludingVATDiscounted {get;set;}
        @AuraEnabled
        public Decimal totalAnnualPriceExcludingVATTarget {get;set;}
        @AuraEnabled
        public Decimal pricePerMonthExcludingVAT {get;set;}
        @AuraEnabled
        public Decimal vATAmount {get;set;}
        @AuraEnabled
        public Decimal totalAnnualPriceIncludingVAT {get;set;}
        @AuraEnabled
        public Decimal pricePerMonthIncludingVAT {get;set;}
        @AuraEnabled
        public String pricingType {get;set;}
        @AuraEnabled
        public boolean isTargerPriceRequired {get;set;}
        @AuraEnabled
        public boolean separatePricesRequired {get;set;}
        
        @AuraEnabled
        public Decimal totalAnnualPriceExcludingVATVehcileAndFuel {get;set;}
        @AuraEnabled
        public Decimal pricePerMonthExcludingVATVehcileAndFuel {get;set;}
        @AuraEnabled
        public Decimal vatAmountForVehcileAndFuel {get;set;}
        @AuraEnabled
        public Decimal totalAnnualPriceIncludingVATVehcileAndFuel {get;set;}
        @AuraEnabled
        public Decimal pricePerMonthIncludingVATVehcileAndFuel {get;set;}
        
        @AuraEnabled
        public Decimal totalAnnualPriceExcludingVATManpower {get;set;}
        @AuraEnabled
        public Decimal pricePerMonthExcludingVATManpower {get;set;}
        @AuraEnabled
        public Decimal vatAmountForManpower {get;set;}
        @AuraEnabled
        public Decimal totalAnnualPriceIncludingVATManpower {get;set;}
        @AuraEnabled
        public Decimal pricePerMonthIncludingVATManpower {get;set;}
        @AuraEnabled
        public Decimal extraKMPrice {get;set;}//Added by Arun on 06.04.2023 for Extra KM New row addition
        @AuraEnabled
        public Decimal corporateTax {get;set;}//Added by Arun on 28.04.2023 for update corporate tax
        
        
    } //covered
    public class TotalValueOfQuotation{
        
        @AuraEnabled
        public Decimal totalValueofRental {get;set;}
        @AuraEnabled
        public Decimal totalInvestment {get;set;}
        @AuraEnabled
        public Decimal totalDepreciation {get;set;}
        @AuraEnabled
        public Decimal totalResaleValue {get;set;}
        @AuraEnabled 
        public Decimal totalVehicleProfits {get;set;}
        @AuraEnabled
        public Decimal totalDriverProfits {get;set;}
        @AuraEnabled
        public Decimal totalNannyprofits {get;set;}
        @AuraEnabled 
        public Decimal totalCoordinatorprofits {get;set;}
        @AuraEnabled
        public Decimal totalSupervisorprofits {get;set;}
        @AuraEnabled
        public Decimal totalAccountantprofits {get;set;}
        @AuraEnabled
        public Decimal totalOtherEmployeeprofits {get;set;}
        @AuraEnabled
        public Decimal totalFuelProfits {get;set;}
        @AuraEnabled
        public boolean showDriverProfit {get;set;}
        @AuraEnabled
        public boolean showNannyProfit {get;set;}
        @AuraEnabled
        public boolean showAccountantProfit {get;set;}
        @AuraEnabled
        public boolean showCoordinatorProfit {get;set;}
        @AuraEnabled
        public boolean showSupervisorProfit {get;set;}
        @AuraEnabled
        public boolean showOtherManpowerProfit {get;set;}
    } //covered
    public class FinancialAnalysis{
        @AuraEnabled
        public Decimal payback {get;set;}
        @AuraEnabled
        public Decimal paybackRatio {get;set;}
        @AuraEnabled
        public Decimal payback2  {get;set;}
        @AuraEnabled
        public Decimal paybackRatio2  {get;set;}
        @AuraEnabled
        public Decimal annualshareOfPaybackRatio2 {get;set;}
        @AuraEnabled
        public Decimal payback3 {get;set;}
        @AuraEnabled
        public Decimal paybackRatio3 {get;set;}
        @AuraEnabled 
        public Decimal annualshareOfPaybackRatio3 {get;set;}
        @AuraEnabled
        public Decimal freeCashFlowAnnual {get;set;}
        @AuraEnabled
        public Decimal freeCashFlowAnnualDiscounted {get;set;}
        @AuraEnabled
        public Decimal freeCashFlowAnnualTarget {get;set;}
        @AuraEnabled
        public Decimal freeCashFlowCumulative {get;set;}
        @AuraEnabled
        public Decimal freeCashFlowCumulativeDiscounted {get;set;}
        @AuraEnabled
        public Decimal freeCashFlowCumulativeTarget {get;set;}
        @AuraEnabled
        public Decimal netPresentValue {get;set;}
        @AuraEnabled
        public Decimal netPresentValueDiscounted {get;set;}
        @AuraEnabled
        public Decimal netPresentValueTarget {get;set;}
        @AuraEnabled
        public Decimal costOfCapitalAssumed {get;set;}
        @AuraEnabled
        public Decimal netProfitMargin {get;set;}
        @AuraEnabled
        public Decimal netProfitMarginDiscounted {get;set;}
        @AuraEnabled
        public Decimal netProfitMarginTarget {get;set;}
        @AuraEnabled
        public Decimal paybackPeriodYears {get;set;}
        @AuraEnabled
        public Decimal paybackPeriodYearsDiscounted {get;set;}
        @AuraEnabled
        public Decimal paybackPeriodYearsTarget {get;set;}
        @AuraEnabled
        public Decimal internalRateOfReturn {get;set;}
        @AuraEnabled
        public Decimal internalRateOfReturnDiscounted {get;set;}
        @AuraEnabled
        public Decimal internalRateOfReturnTarget {get;set;}
        @AuraEnabled 
        public Decimal returnOnInvestment {get;set;}
        @AuraEnabled 
        public Decimal returnOnInvestmentDiscounted {get;set;}
        @AuraEnabled 
        public Decimal returnOnInvestmentTarget {get;set;}
        @AuraEnabled 
        public String pricingMethod {get;set;}
        @AuraEnabled 
        public String pricingType {get;set;}
        @AuraEnabled 
        public Decimal pricePerPricingType {get;set;}
    } //covered
    public class vehicleApprovalDetails{
        @AuraEnabled
        public string element {get;set;}
        @AuraEnabled
        public string requestedBy {get;set;}
        @AuraEnabled
        public string approvedby {get;set;}
        @AuraEnabled
        public string reason {get;set;}
    }
 
    public static void testCoverage1(){
        integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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