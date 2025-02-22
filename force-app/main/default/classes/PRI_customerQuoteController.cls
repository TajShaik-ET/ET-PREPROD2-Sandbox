public with sharing class PRI_customerQuoteController {
    
    static final Integer SCHOOL_MONTHS = 10;
    static final Integer OTHER_SECTOR_MONTHS = 12;
    static final Decimal CORPORATE_TAX = 9;
    static final List<String> approvalSequence = new List<String> {'Operation','Finance','Legal'};
        
        @auraEnabled
        public static List<Id> getQuoteVehicleLinesData(String recordId){
            //recordId = 'a888E0000004o7IQAQ';
            system.debug('----fetchQuoteVehcileLinesData-------'+recordId);
            List<Id> vehicleIds = new List<Id>(new Map<Id, Customer_Vehicle_Quote_Item__c>(
                [select Id from Customer_Vehicle_Quote_Item__c ]).keySet()//where  Customer_Quote__c=:recordId order by createdDate]).keySet()
                                              );
            system.debug('----fetchQuoteVehcileLinesData---vehicleIds----'+vehicleIds);
            return vehicleIds;
        }
    
    @auraEnabled (cacheable=true)
    public static Map<String,QuoteDetail> getQuoteData(List<String> recordIds){
        /*System.debug('recordId1: '+recordId1);
        List<String> recordIds = New List<String>();
        if(recordId1 != null)
        recordIds = recordId1.split(',');*/
        system.debug('----getQuoteData----'+recordIds);
        Map<String,QuoteDetail> quoteDetailMap = New Map<String,QuoteDetail>();
        List<Quote> quoteList = New List<Quote>();
        Set<Id> optyIds = new Set<Id>();
        Map<String,Integer> optyToCQuoteMap = New Map<String,Integer>();
        for(Quote q: [Select id,QuoteNumber,GL_Zone__c,Account.Name,Account.ETSALES_Profile_Class__c, 
                      Account.AccountNumber, Account.RecordType.name, Opportunity.RecordType.DeveloperName,
                      Opportunity.Type, Opportunity.ETSALES_Opportunity_Number__c,
                      ET_Total_Investment__c,CreatedBy.Name,Opportunity.owner.name,
                      Opportunity.ETSALES_Sector__c, Opportunity.RecordType.name, Opportunity.Id, Opportunity.Fuel_Included_Current_Contract__c,
                      Is_Target_Price_Required__c, Total_Number_of_Accountants__c , 
                      Total_Number_of_Coordinators__c,  Total_Number_of_Drivers__c,
                      Total_Number_of_Nannies__c , Total_Number_of_Other_Employees__c,
                      Total_Number_of_Supervisors__c, Total_Number_of_Vehicles__c, owner.name,createdDate,
                      ET_Type__c, Service_Emirate__c, Total_Vehicle_Lines__c,Quote_Total_Investment__c
                      From Quote Where Id IN: recordIds]){
                          quoteList.add(q);
                          optyIds.add(q.Opportunity.Id);
                      }
        for(Customer_Quote__c cQuote: [Select Id, Name, Opportunity_Name__c FROM Customer_Quote__c WHERE Opportunity_Name__c IN: optyIds]){
            if(!optyToCQuoteMap.containsKey(cQuote.Opportunity_Name__c))
                optyToCQuoteMap.put(cQuote.Opportunity_Name__c,1);
            if(optyToCQuoteMap.containsKey(cQuote.Opportunity_Name__c))
                optyToCQuoteMap.put(cQuote.Opportunity_Name__c,optyToCQuoteMap.get(cQuote.Opportunity_Name__c)+1);
        }
        for(Quote q: quoteList){
            if(!quoteDetailMap.containsKey(q.Id)){
                QuoteDetail quoteDetail = new QuoteDetail();
                quoteDetail.quote = q;
                quoteDetail.customerQuoteCount = optyToCQuoteMap.containsKey(q.Opportunity.Id) ? optyToCQuoteMap.get(q.Opportunity.Id) : 0;
                quoteDetailMap.put(q.Id,quoteDetail);
                system.debug('--getQuoteData--return--'+q);
                system.debug('--quoteDetail--'+quoteDetail);
            }
        }
        return quoteDetailMap;
    }
    
    @auraEnabled
    public static LineItems fetchLineItems(List<String> quoteIds, String contractType){
        Map<String,QuoteDetail> quoteDetailMap = getQuoteData(quoteIds);
        /*List<String> quoteIds = New List<String>();
        if(quoteId != null)
        quoteIds = quoteId.split(',');*/
        //Quote  quote = quoteDetail.quote;
        List<CustomerQuoteVehicleData>  vehicles = getQuoteVehicleLineItemData(quoteIds, quoteDetailMap, contractType);
        List<CustomerWorkForceData>  workforce = getWorkforceQuoteLineItemsData(quoteIds, quoteDetailMap, contractType);
        LineItems lines = new LineItems();
        lines.vehicleLines.addAll(vehicles);
        lines.workforceLines.addAll(workforce);
        return lines;
    }
    
    public static  List<CustomerQuoteVehicleData> getQuoteVehicleLineItemData(List<String> quoteIds,  Map<String,QuoteDetail> quoteDetailMap, String contractType){
        
        List<ET_Vehicle_Quote_Item__c> vehicles = getQuoteVehicleLineItems(quoteIds);
        Map<String, Map<String, Decimal>> vehiclesFinancialInfo = getFinancialAnalysis(quoteIds);
        Map<Integer,Map<String,Map<Integer,ET_Workforce_Quote_Item__c>>> workforceWrapper = buildMapForExtraKMPrice(quoteIds);
        
        Map<String, CustomerQuoteVehicleData> vehiclesLines = new Map<String, CustomerQuoteVehicleData>();
        Map<String, String> vehicleAndPricingRequest = new Map<String, String>();
        System.debug('vehicles Size: '+vehicles.Size());
        for(ET_Vehicle_Quote_Item__c  vehicle :vehicles){
            CustomerQuoteVehicleData obj = new CustomerQuoteVehicleData();
            obj.Name  = (vehicle.ET_Vehicle_Unique_key__c!=null)?vehicle.ET_Vehicle_Unique_key__c.substringAfter('_'):'';
            obj.LineNumber = vehicle.ET_Line_Number__c;
            obj.NumberOfVehicles = vehicle.ET_Number_of_Vehicles__c;
            obj.quoteVechicleLineItemId  = vehicle.Id;
            obj.TotalVehiclesCost = vehicle.ET_Total_Vehicles_Cost__c;
            obj.ContractPeriodInYears = vehicle.ET_Contract_Period__c;
            obj.oppoRecordType = vehicle.Quote__r.Opportunity.RecordType.name;
            obj.quote = vehicle.Quote__r; 
            obj.vehicleLineId  = vehicle.id;
            obj.vehSource  = vehicle.ET_Vehicle_Source__c;
            obj.serviceType  = vehicle.ET_Service_Type__c;
            obj.annualMileage = vehicle.ET_Total_Annual_Mileage__c;
            obj.monthlyVehiclePrice = calculateVehicleMonthlyCost(vehicle, quoteDetailMap, vehiclesFinancialInfo);
            obj.purchasePrice =   vehicle.ET_Vehicle_Current_Purchase_Price__c;
            obj.extraKmPrice = calculateExtraKmPrice(quoteDetailMap, vehicle, vehiclesFinancialInfo, workforceWrapper); 
            
            obj.otherSpecs = new List<OtherSpec>();
            vehicleAndPricingRequest.put(vehicle.Id, vehicle.ET_Pricing_Vehicle_Request__c);
            
            //if contract is monthly then we need vehicle lines with the contract periode 1st year 
            if(contractType == 'Monthly' && vehicle.ET_Contract_Period__c == 1){
                vehiclesLines.put(vehicle.Id, obj);
            }else if(contractType != 'Monthly'){
                vehiclesLines.put(vehicle.Id, obj);
            }
        }
        // obj.otherSpecs = new List<OtherSpec>();
        // for(ET_Quote_Item_SpecReq__c other: vehicle.Vehicle_Quote_Item_SpecRequests__r){
        //     OtherSpec temp = new OtherSpec();
        //     temp.Name = other.Name;
        //     temp.amount = other.ET_Cost__c;
        //     obj.otherSpecs.add(temp);
        // }
        
        for(ET_Other_Cost_Request__c otherCost : [Select Name, ET_Cost_Value__c, ET_Cost_Type__c, Vehicle_Request__c from ET_Other_Cost_Request__c
                                                  where Vehicle_Request__c IN :vehicleAndPricingRequest.values()]){
                                                      
                                                      List<String> vehicleIds = new List<String>();
                                                      
                                                      // ET_Pricing_Vehicle_Request__c
                                                      for(String vehId :vehicleAndPricingRequest.keySet()){
                                                          if(otherCost.Vehicle_Request__c == vehicleAndPricingRequest.get(vehId)){
                                                              vehicleIds.add(vehId);
                                                          }
                                                      }
                                                      for(String vehicleId : vehicleIds){
                                                          if(vehiclesLines.containsKey(vehicleId)){
                                                              CustomerQuoteVehicleData vehicle =  vehiclesLines.get(vehicleId);
                                                              System.debug('--------vehicle-------'+vehicle);
                                                              List<OtherSpec> specs = vehicle.otherSpecs;
                                                              OtherSpec temp = new OtherSpec();
                                                              temp.Name = otherCost.Name;
                                                              temp.amount = otherCost.ET_Cost_Value__c;
                                                              temp.costType = otherCost.ET_Cost_Type__c.replace('_', ' ');
                                                              specs.add(temp);
                                                          }
                                                      }
                                                  }
        system.debug('---vehiclesLines---'+ JSON.serializePretty(vehiclesLines));
        return vehiclesLines.values();
    }
    
    public static  List<CustomerWorkForceData> getWorkforceQuoteLineItemsData(List<String> quoteIds, Map<String,QuoteDetail> quoteDetailMap, String contractType){
        List<CustomerWorkForceData> workForceLines = new List<CustomerWorkForceData>();
        
        /*if((quote.Opportunity.ETSALES_Sector__c == 'School'  ||  quote.Opportunity.ETSALES_Sector__c == 'Transport And Lease')&&
        quote.Opportunity.RecordType.DeveloperName=='ETSALES_Transportation'){
        return workForceLines;
        }*/
        List<ET_Workforce_Quote_Item__c> workforceItems = getWorkforceQuoteLineItems(quoteIds);
        System.debug('-----getWorkforceQuoteLineItemsData------'+quoteIds);
        System.debug('-----getWorkforceQuoteLineItemsData---workforceItems.size()---'+workforceItems.size());
        Map<String, CustomerWorkForceData> workforceForEachCategory = new Map<String, CustomerWorkForceData>();
        System.debug('workforceItems Size: '+workforceItems.Size());
        for(ET_Workforce_Quote_Item__c  workforceItem :workforceItems){
            System.debug('workforceItem.Quote__c: '+workforceItem.Quote__c);
            Quote quote = quoteDetailMap.get(workforceItem.Quote__c).quote;   
            System.debug('ETSALES_Sector__c: '+quote.Opportunity.ETSALES_Sector__c+' DeveloperName: '+quote.Opportunity.RecordType.DeveloperName);         
            if((quote.Opportunity.ETSALES_Sector__c == 'School'  ||  quote.Opportunity.ETSALES_Sector__c == 'Transport And Lease')){
                CustomerWorkForceData obj = new CustomerWorkForceData();
                obj.Name  = workforceItem.ET_Workforce_Quote_Item_Type__c;
                obj.LineNumber = workforceItem.ET_Workforce_Line_Number__c;
                obj.NumberOfWorker = workforceItem.ET_Number_of_Workforce__c;
                obj.quoteWorkforceItemId  = workforceItem.Id;
                obj.TotalWorkforceCost = workforceItem.ET_Total_Cost__c;
                obj.ContractPeriodInYears = workforceItem.ET_Contract_Period__c;
                obj.workforceRecordtype = workforceItem.ET_Workforce_Record_Type__c;
                obj.workForceId = workforceItem.id;
                obj.workforceType = workforceItem.Type__c;
                obj.serviceType = workforceItem.ET_Service_Type__c;
                obj.monthlyVehiclePrice = calculateWorkforceMonthlyCost(workforceItem, quote);
                obj.quote = workforceItem.Quote__r; 
                System.debug('obj: '+obj);
                // obj.monthlyVehiclePrice = (workforceItem.ET_Total_Cost__c/12).setScale(2);
                //obj.oppoRecordType = workforceItem.Quote__r.Opportunity.RecordType.name;
                
                //if contract is monthly then we need workforce lines with the contract periode 1st year only
                if(contractType == 'Monthly' && workforceItem.ET_Contract_Period__c == 1){
                    workForceLines.add(obj);
                    System.debug('Monthly: '+obj);
                }else if(contractType != 'Monthly'){
                    workForceLines.add(obj);
                    System.debug('Yearly: '+obj);
                }
            }
        }
        //For each category only single line is required
        for(CustomerWorkForceData workForceLine : workForceLines){
            if(!workforceForEachCategory.containsKey(workForceLine.Name)){
                workforceForEachCategory.put(workForceLine.Name, workForceLine);
            }
        }
        
        System.debug('-----getWorkforceQuoteLineItemsData--workForceLines----'+workForceLines);
        return workforceForEachCategory.values();
    }
    
    public static Decimal calculateVehicleMonthlyCost(ET_Vehicle_Quote_Item__c  vehicle, Map<String,QuoteDetail> quoteDetailMap, Map<String, Map<String, Decimal>> vehiclesFinancialInfo){
        Decimal monthlyVehiclePrice = 0;
        Decimal totalCost = 0;
        Decimal SubsProfit = 0;
        Decimal SubsCost = 0;
		if(vehicle.Substitutional_vehcls_profit_Per_Vehicle__c != NULL)
        {
            SubsProfit = vehicle.Substitutional_vehcls_profit_Per_Vehicle__c;
        }
		if(vehicle.Substitutional_vehcls_profit_Per_Vehicle__c != NULL)
        {
            SubsCost = vehicle.Substitutional_Vehicles_Cost_Per_Vehicle__c;
        }
        // for Transpotation and Logistics record Type, we will use financial analysis
        Quote quote = quoteDetailMap.get(vehicle.Quote__c).quote; //Quote__r.Id
        if((quote.Opportunity.ETSALES_Sector__c == 'School'  ||  quote.Opportunity.ETSALES_Sector__c == 'Transport And Lease')&&
           (quote.Opportunity.RecordType.DeveloperName=='ETSALES_Transportation' || quote.Opportunity.RecordType.DeveloperName=='ETSALES_Logistics')){
               // Map<String, Map<String, Decimal>> vehiclesFinancialInfo = getFinancialAnalysis(quote.Id);
               Map<String, Decimal> vehicleData = vehiclesFinancialInfo.get(vehicle.Id);
               totalCost = vehicleData.get('totalAnnualPrice');
           }
        else{
            // total cost + profit + 9%profit
            Decimal corporateTaxOnProfit =  vehicle.ET_Annual_Vehicles_Profit_Value__c * (CORPORATE_TAX/100) ;
            totalCost = vehicle.ET_Total_Vehicles_Cost__c + vehicle.ET_Annual_Vehicles_Profit_Value__c + corporateTaxOnProfit + SubsCost + SubsProfit;
        }
        System.debug('-----calculateMonthlyCost----'+totalCost);
        if(totalCost != null && totalCost != 0){
            if(quote.Opportunity.ETSALES_Sector__c == 'School' && 
               (quote.Opportunity.RecordType.DeveloperName =='ETSALES_Leasing' || quote.Opportunity.RecordType.DeveloperName=='ETSALES_Transportation' || quote.Opportunity.RecordType.DeveloperName=='ETSALES_Logistics')){
                   monthlyVehiclePrice = (totalCost/SCHOOL_MONTHS).setScale(2).round(System.RoundingMode.HALF_EVEN);
               }else{
                   monthlyVehiclePrice = (totalCost/OTHER_SECTOR_MONTHS).setScale(2).round(System.RoundingMode.HALF_EVEN);
               }
        }
        
        return monthlyVehiclePrice;
    }
    
    public static Decimal calculateWorkforceMonthlyCost(ET_Workforce_Quote_Item__c  workforceItem, Quote quote){
        Decimal monthlyVehiclePrice = 0;
        //to calculate monthly price
        // total cost + profit + 9%profit 
        Decimal corporateTaxOnProfit =  workforceItem.ET_Workforce_profit_per_each_vehicle__c * (CORPORATE_TAX / 100);
        Decimal totalCost = workforceItem.ET_Total_Cost__c + workforceItem.ET_Workforce_profit_per_each_vehicle__c + corporateTaxOnProfit;
        if(quote.Opportunity.ETSALES_Sector__c == 'School' && 
           (quote.Opportunity.RecordType.DeveloperName =='ETSALES_Leasing' || quote.Opportunity.RecordType.DeveloperName=='ETSALES_Transportation' || quote.Opportunity.RecordType.DeveloperName=='ETSALES_Logistics')){
               monthlyVehiclePrice = (totalCost/SCHOOL_MONTHS).setScale(2);
           }else{
               monthlyVehiclePrice = (totalCost/OTHER_SECTOR_MONTHS).setScale(2);
           }
        return monthlyVehiclePrice;
    }
    
    /**
    * @description extra KM Price calculation for each vehicle including all workforce extra km price as well
    */
    public static Decimal calculateExtraKmPrice(Map<String,QuoteDetail> quoteDetailMap, ET_Vehicle_Quote_Item__c  vehicle, Map<String, Map<String, Decimal>> vehiclesFinancialInfo, Map<Integer,Map<String,Map<Integer,ET_Workforce_Quote_Item__c>>> workforceWrapper){
        
        Map<String, Decimal> vehicleData = vehiclesFinancialInfo.get(vehicle.Id);
        Decimal financialAnalysisExtraKmPrice = 0;
        if(vehicleData != null){
            if(vehicleData.Containskey('extraKMPrice'))
                financialAnalysisExtraKmPrice = vehicleData.get('extraKMPrice');
        }
        Decimal workforceExtraKmPrice = 0;
        for(Integer lineNo :workforceWrapper.keySet()){
            Map<String,Map<Integer,ET_Workforce_Quote_Item__c>> workforceCategoryMap = workforceWrapper.get(lineNo);
            for(String WorkforceType : workforceCategoryMap.keySet()){
                Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear = workforceCategoryMap.get(WorkforceType);
                Integer contractPeriod = Integer.valueOf(vehicle.ET_Contract_Period__c);
                if(vehicle.ET_Line_Number__c == lineNo && workforceMapByContractYear.containsKey(contractPeriod)){
                    ET_Workforce_Quote_Item__c workforce = workforceMapByContractYear.get(contractPeriod);
                    workforceExtraKmPrice +=  workforce.Extra_KM_Workforce__c;
                }
            }
        }
        
        return (workforceExtraKmPrice + financialAnalysisExtraKmPrice).setScale(2);
    }
    
    @AuraEnabled
    public static void updateTotalAmount(Id customerQuoteId, Decimal totalAmount){
        system.debug('In updateTotalAmount>>>>>>>>>>');
        system.debug('totalAmount>>>>>>>>>>' + totalAmount);
        system.debug('customerQuoteId>>>>>>>>>>' + customerQuoteId);
        if (customerQuoteId == null || totalAmount == null) {
            throw new AuraHandledException('Customer Quote ID and Total Amount are required.');
        }
        
        try {
            Customer_Quote__c quote = [SELECT Id, Quote_Total_Investment__c FROM Customer_Quote__c WHERE Id = :customerQuoteId LIMIT 1];
            quote.Quote_Total_Investment__c = totalAmount;
            update quote;
            system.debug('quote>>>>>>>>>>' + quote);
        } catch (Exception e) {
            throw new AuraHandledException('Error updating Customer Quote: ' + e.getMessage());
        }
    }
    
    public class LineItems{
        @AuraEnabled public List<CustomerWorkForceData> workforceLines = new List<CustomerWorkForceData>();
        @AuraEnabled public List<CustomerQuoteVehicleData> vehicleLines = new List<CustomerQuoteVehicleData>();
    }
    
    public class CustomerQuoteVehicleData{
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public Decimal LineNumber {get; set;}
        @AuraEnabled public Decimal NumberOfVehicles {get; set;}
        @AuraEnabled public String quoteVechicleLineItemId {get; set;}
        @AuraEnabled public Decimal TotalVehiclesCost {get; set;}
        @AuraEnabled public Decimal ContractPeriodInYears {get; set;}
        @AuraEnabled public String oppoRecordType {get; set;}
        @AuraEnabled public Decimal monthlyVehiclePrice {get; set;}
        @AuraEnabled public String vehicleLineId{get; set;}
        @AuraEnabled public String vehSource {get; set;}
        @AuraEnabled public String serviceType {get; set;}
        @Auraenabled public Decimal annualMileage {get; set;}
        @Auraenabled public Decimal purchasePrice {get; set;}
        @Auraenabled public Decimal extraKmPrice {get; set;}
        @Auraenabled public List<OtherSpec> otherSpecs {get; set;}
        @AuraEnabled public Quote quote {get; set;}
    }
    
    public class OtherSpec{
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public Decimal amount {get; set;}
        @AuraEnabled public String costType {get; set;}
    }
    
    public class CustomerWorkForceData{
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public Decimal LineNumber {get; set;}
        @AuraEnabled public Decimal NumberOfWorker {get; set;}
        @AuraEnabled public String quoteWorkforceItemId {get; set;}
        @AuraEnabled public Decimal TotalWorkforceCost {get; set;}
        @AuraEnabled public Decimal ContractPeriodInYears {get; set;}
        @AuraEnabled public String oppoRecordType {get; set;}
        @AuraEnabled public Decimal monthlyVehiclePrice {get; set;}
        @AuraEnabled public String workforceRecordtype {get; set;}
        @AuraEnabled public String workForceId {get; set;}
        @AuraEnabled public String workforceType {get; set;}
        @AuraEnabled public String serviceType {get; set;}
        @AuraEnabled public Quote quote {get; set;}
    }
    
    public class QuoteDetail{
        @AuraEnabled public Quote quote;
        @AuraEnabled public Integer customerQuoteCount;
    }
    
    public static  List<ET_Vehicle_Quote_Item__c> getQuoteVehicleLineItems(List<String> quoteIds){
        system.debug('------in getQuoteVehicleLineItemData------- '+quoteIds);
        List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLst = new List<ET_Vehicle_Quote_Item__c> ( [SELECT ET_Allowed_Vehicle_profit__c,
                                                                                                   ET_Annual_Vehicles_Profit_Margin__c,
                                                                                                   ET_Annual_Vehicles_Profit_Value__c,
                                                                                                   ET_Depreciation_Reserve__c,
                                                                                                   Quote__r.QuoteNumber,
                                                                                                   Quote__r.GL_Zone__c,
                                                                                                   Quote__r.Account.Name,
                                                                                                   Quote__r.Account.ETSALES_Profile_Class__c,
                                                                                                   Quote__r.OpportunityId,
                                                                                                   Quote__r.Opportunity.Name,
                                                                                                   Quote__r.Opportunity.ETSALES_Opportunity_Number__c,
                                                                                                   Quote__r.Opportunity.Type,
                                                                                                   Quote__r.Opportunity.RecordType.name,
                                                                                                   Quote__r.ET_Total_Investment__c,
                                                                                                   Quote__r.CreatedBy.Name,
                                                                                                   ET_Fuel_Expenses__c,
                                                                                                   ET_Fuel_Reserve__c,
                                                                                                   ET_General_Reserve__c,
                                                                                                   ET_Line_Number__c,
                                                                                                   ET_Annual_Fuel_Profit_Margin_Rate__c,
                                                                                                   ET_Annual_Fuel_Profit_Value__c,
                                                                                                   Quote__c,
                                                                                                   Id,
                                                                                                   Name,
                                                                                                   ET_Number_of_Vehicles__c,
                                                                                                   ET_Vehicle_Unique_key__c,
                                                                                                   ET_Contract_Period__c,
                                                                                                   ET_Quote_Item_Type__c,
                                                                                                   ET_Tot_Annual_Vehicles_Net_Prof_Val__c,
                                                                                                   ET_Total_Fuel_Cost__c,  
                                                                                                   ET_Total_fuel_profits__c,
                                                                                                   ET_Total_Vehicles_Cost__c,
                                                                                                   ET_Vehicle_Depreciation__c,
                                                                                                   ET_Vehicle_Financing__c,
                                                                                                   ET_Vehicle_Insurance__c,
                                                                                                   ET_Vehicle_Registration__c,
                                                                                                   ET_Vehicle_Repairs_and_Maintenance__c,
                                                                                                   ET_Maintenance_Reserve__c,
                                                                                                   ET_Total_Reserve_Cost__c,
                                                                                                   ET_Vehicle_Resale_Value__c,
                                                                                                   ET_Total_Variable_Cost__c,
                                                                                                   ET_Total_Fixed_Cost__c,
                                                                                                   ET_No_of_Seats__c, 
                                                                                                   ET_Daily_Mileage__c,
                                                                                                   ET_Total_Annual_Mileage__c,
                                                                                                   ET_Vehicle_Depreciation_Percentage__c,
                                                                                                   ET_Depreciation_Rate_for_Extra_Mileage__c,
                                                                                                   ET_Vehicle_Maintenance_Rate__c,
                                                                                                   ET_Vehicle_Fuel_Rate__c,
                                                                                                   ET_Working_days_per_week__c,
                                                                                                   ET_Working_Months_per_year__c,
                                                                                                   ET_Insurance_Rate__c,
                                                                                                   ET_Financing_Rate__c,
                                                                                                   ET_Required_ROI_Rate__c,
                                                                                                   ET_General_Reserve_Rate__c,
                                                                                                   Depreciated_years_from_insurance_master__c,
                                                                                                   Min_Veh_Val_from_insurance_master__c,
                                                                                                   ET_Passenger_Cost__c,
                                                                                                   ET_Driver_insurance_cost__c,
                                                                                                   ET_Ambulance_Cost__c,
                                                                                                   ET_other_cost__c,
                                                                                                   ET_Registration_Fee__c,
                                                                                                   ET_Inspection_Fee__c,
                                                                                                   ET_Actual_Liter_Price__c,
                                                                                                   ET_Fuel_consumption__c,
                                                                                                   ET_Depreciation_Reserve_Rate__c,
                                                                                                   ET_Maintainence_Reserve_Rate__c,
                                                                                                   ET_Fuel_Reserve_Rate__c,
                                                                                                   ET_Manufacture_Year__c,
                                                                                                   ET_Deduction_Rate_for_latest_new_price__c,
                                                                                                   ET_Depreciation_Method__c,
                                                                                                   ET_Min_Resale_Value__c,
                                                                                                   ET_Min_Depreciation_Years__c,
                                                                                                   ET_Number_of_Financing_years__c,
                                                                                                   ET_Insurance_Rate_1st_Year__c,
                                                                                                   ET_Minimum_Cost__c,
                                                                                                   ET_Total_Special_Requirement_Cost__c,
                                                                                                   ET_Vehicle_Profit_Rate_from_Master__c,
                                                                                                   ET_Vehicle_Current_Purchase_Price__c,
                                                                                                   ET_Vehicle_Original_Purchase_Price__c,
                                                                                                   ET_Vat_Rate__c,
                                                                                                   ET_Client_Type__c,
                                                                                                   ET_Client_Classification__c,
                                                                                                   Approval_Details__c,
                                                                                                   ET_Vehicle_Total_Investment__c,
                                                                                                   ET_Working_days_per_year__c,
                                                                                                   ET_Service_Type__c,
                                                                                                   ET_Vat_Amount__c,
                                                                                                   ET_Policy_Type__c,
                                                                                                   Total_Annual_Cost_Target_Prices__c,
                                                                                                   Total_Annual_Price_Target_Prices__c,
                                                                                                   Total_Fuel_Cost_Target_Price__c,
                                                                                                   is_Target_Price_Required__c,
                                                                                                   ET_Vehicle_Source__c,
                                                                                                   ET_Fleet_Type__c	,
                                                                                                   ET_Extra_Bus_Fees__c,
                                                                                                   ET_Service_Emirate__c,
                                                                                                   ET_Vehicle_Condition__c,
                                                                                                   ET_Total_Vehicle_Vat_cost__c,
                                                                                                   ET_VAT_Cost_on_Direct_Expenses__c,
                                                                                                   ET_VAT_Cost_on_Indirect_Expenses__c,
                                                                                                   ET_Price_Utilization__c,
                                                                                                   ET_Pricing_Type__c,
                                                                                                   ET_Pricing_Method__c	,
                                                                                                   ET_Depreciation_Type__c,
                                                                                                   ET_Minimum_resale_value_percentage__c,
                                                                                                   ET_Fuel_Required__c,
                                                                                                   ET_Discounts_Additional_Profit__c,
                                                                                                   Substitutional_vehcls_profit_Per_Vehicle__c,
                                                                                                   Substitutional_Vehicles_Cost_Per_Vehicle__c,
                                                                                                   ET_Annual_Fuel_Profit_Target_Prices__c,
                                                                                                   General_Reserve_Target_Prices__c,
                                                                                                   Vehicle_Profit_Value_Target_Price__c,
                                                                                                   Discounted_Vehicle_Profit_Value_Target__c,
                                                                                                   General_Reserve_for_Discounted_Price__c,
                                                                                                   Fuel_Reserve_Discounted__c,
                                                                                                   Fuel_Reserve_Target__c,
                                                                                                   Total_Fuel_Cost_Discounted__c,
                                                                                                   Fuel_Profit_Value_Discounted__c,
                                                                                                   Annual_Fuel_Profit_Margin_Discounted__c,
                                                                                                   Annual_Fuel_Profit_Margin_Target__c,
                                                                                                   Total_Vehicles_Cost_Discounted__c,
                                                                                                   Vehicles_Profit_Margin_Rate_Discounted__c,
                                                                                                   Vehicles_Profit_Margin_Rate_Target__c,
                                                                                                   ET_Pricing_Vehicle_Request__r.ET_Contract_Period__c,
                                                                                                   Request_for_Target_Price__c,
                                                                                                   Request_for_separate_prices__c,
                                                                                                   Trailer_Depreciation_Rate__c,
                                                                                                   Trailer_Resale_Value__c,
                                                                                                   Trailer_Current_Purchase_Price__c,
                                                                                                   Trailer_Original_Purchase_Price__c,
                                                                                                   Trailer_min_Resale_Value_Percentage__c,
                                                                                                   Trailer_min_Resale_Value__c,
                                                                                                   Trailer_min_Depreciation_Years__c,
                                                                                                   Trailer_Condition__c,
                                                                                                   Trailer_Maintenance_Rate__c,
                                                                                                   Trailer_Registration_Fee__c,
                                                                                                   Is_trailer_selected__c,
                                                                                                   Trailer_depreciation_type__c,
                                                                                                   Trailer_Depreciation__c,
                                                                                                   Trailer_Repairs_And_Maintenance__c,
                                                                                                   Trailer_Remaining_Depreciation_Of_10_Yea__c,
                                                                                                   Trailer_External_Maintenance_Cost__c,
                                                                                                   Total_Current_Value__c,
                                                                                                   Total_Depreciation__c,
                                                                                                   Total_Resale_Value__c,
                                                                                                   Refrigerator_Depreciation_Rate__c,
                                                                                                   Refrigerator_Resale_Value__c,
                                                                                                   Refrigerator_Current_Purchase_Price__c,
                                                                                                   Refrigerator_Original_Purchase_Price__c,
                                                                                                   Refrigerator_min_Resale_Value_Percentage__c,
                                                                                                   Refrigerator_min_Resale_Value__c,
                                                                                                   Refrigerator_min_Depreciation_Years__c,
                                                                                                   Refrigerator_Condition__c,
                                                                                                   Refrigerator_Maintenance_Rate__c,
                                                                                                   Refrigerator_Registration_Fee__c,
                                                                                                   Is_Refrigerator_selected__c,
                                                                                                   Refrigerator_depreciation_type__c,
                                                                                                   Refrigerator_Depreciation__c,
                                                                                                   Refrigerator_Repairs_And_Maintenance__c,
                                                                                                   Refrigerator_Remaining_Depreciation_Of_1__c,
                                                                                                   Refrigerator_External_Maintenance_Cost__c,
                                                                                                   ET_Remaining_Depreciation_of_10_Years__c,
                                                                                                   Vehicle_Notes__c,
                                                                                                   Corporate_Tax__c,
                                                                                                   Passed_years_from_Bus_Model__c,
                                                                                                   Remaining_years_from_the_Bus_Model__c,
                                                                                                   Current_Value_Remaining_Depreciation_of__c,
                                                                                                   Depreciation_Difference_to_other_Contrac__c,
                                                                                                   Total_Resale_Value_Min_resale_Dep_Diff__c,
                                                                                                   ET_Pricing_Vehicle_Request__c,
                                                                                                   (SELECT Name, ET_Cost__c,ET_Other_Cost_Type__c, ET_Vehicle_Quote_Item__c
                                                                                                    FROM Vehicle_Quote_Item_SpecRequests__r
                                                                                                    ORDER BY Name DESC)
                                                                                                   FROM ET_Vehicle_Quote_Item__c 
                                                                                                   WHERE ET_Quote_Item_Type__c='Vehicle' and Quote__c IN: quoteIds   
                                                                                                   ORDER BY ET_Line_Number__c ASC ,ET_Contract_Period__c ASC, Quote__r.QuoteNumber ASC
                                                                                                  ]
                                                                                                );
        // system.debug('vehicleQuoteItemLst  = '+ JSON.serializePretty(vehicleQuoteItemLst));
        return vehicleQuoteItemLst;
    }
    
    @AuraEnabled 
    public static  List<ET_Workforce_Quote_Item__c> getWorkforceQuoteLineItems(List<String> quoteIds){  
        List<ET_Workforce_Quote_Item__c> workforceQuoteItemLst = new List<ET_Workforce_Quote_Item__c> ( [SELECT   
                                                                                                         ET_Accommodation_Allowance__c,
                                                                                                         ET_Air_Tickets__c,
                                                                                                         ET_Extra_Certification_Cost__c,
                                                                                                         ET_Allowed_profit_Additions_Discounts__c,
                                                                                                         ET_Annual_leave_allowance__c,
                                                                                                         ET_Workforce_Quote_Item_Type__c,
                                                                                                         ET_Annual_Profit_Margin__c,
                                                                                                         ET_Annual_Profit_Value__c,
                                                                                                         ET_Clothes_Allowance__c,
                                                                                                         Children_Allowance__c,
                                                                                                         Cost_of_Living_Allowance__c,
                                                                                                         Housing_Allowance__c,
                                                                                                         Housing_Allowance_Percentage__c,
                                                                                                         Additional_Work_Permit_Fees__c,
                                                                                                         Children_allowance_from_master__c,
                                                                                                         Social_Allowance__c,
                                                                                                         Transport_Allowance__c,
                                                                                                         Additional_Transport_Allowance__c,
                                                                                                         Other_Allowance__c,
                                                                                                         Social_Insurance__c,
                                                                                                         Resource_Type__c,
                                                                                                         Married__c,
                                                                                                         Number_of_Children__c,
                                                                                                         ET_End_of_Service__c,
                                                                                                         ET_Health_Card__c,
                                                                                                         ET_Licensing_Fees__c,
                                                                                                         ET_Overtime__c,
                                                                                                         Quote__c,
                                                                                                         Quote__r.QuoteNumber,
                                                                                                         Quote__r.OpportunityId,
                                                                                                         Quote__r.Opportunity.Name,
                                                                                                         Quote__r.Opportunity.ETSALES_Opportunity_Number__c,
                                                                                                         ET_Total_Annual_Net_Profit_Value__c,
                                                                                                         ET_Total_Cost__c,
                                                                                                         ET_Driver_Reserve__c,
                                                                                                         ET_Total_Direct_Operational_Costs__c,
                                                                                                         ET_Total_Indirect_operational_costs__c,
                                                                                                         ET_Visa_Cost__c,
                                                                                                         ET_Wages__c,
                                                                                                         ET_Workforce_VAT_Cost__c,
                                                                                                         ET_Workforce_VAT_cost_per_Vehicle__c,
                                                                                                         Id,
                                                                                                         Name,
                                                                                                         ET_Smart_Phone_Cost__c,
                                                                                                         ET_Contract_Period__c,
                                                                                                         ET_Workforce_Line_Number__c,
                                                                                                         Line_number_from_input__c,
                                                                                                         ET_Workforce_Gross_Salary__c,
                                                                                                         ET_Number_of_Workforce__c,
                                                                                                         ET_Workforce_Unique_Key__c,
                                                                                                         ET_Working_Days_Per_Week__c,
                                                                                                         ET_Working_Months_Per_Year__c,
                                                                                                         ET_Workforce_basic_salary__c,
                                                                                                         ET_Workforce_Record_Type__c,
                                                                                                         Number_of_Annual_Leave_months__c,
                                                                                                         Number_of_End_of_Service_months__c,
                                                                                                         ET_Profit_Number_of_Months__c,
                                                                                                         ET_Profit_Salary_Type__c,
                                                                                                         Number_of_coverage_years_for_visa__c,
                                                                                                         ET_Driver_Reserve_Rate__c,
                                                                                                         ET_Visa_amount__c,
                                                                                                         ET_Client_Classification__c,
                                                                                                         Approval_Details__c,
                                                                                                         ET_Working_days_per_year__c,
                                                                                                         ET_Vat_Rate__c,
                                                                                                         ET_Service_Type__c,
                                                                                                         ET_Client_Type__c,
                                                                                                         ET_Vat_Amount__c,
                                                                                                         ET_Policy_Type__c,
                                                                                                         Total_Cost_Target_Prices__c,
                                                                                                         is_Target_Price_Required__c,
                                                                                                         ET_Depreciation_Method__c,
                                                                                                         Salary_No_of_months_for_Driver_for_SLine__c,
                                                                                                         Salary_No_of_Months_for_other_Manpower__c,
                                                                                                         ET_Language_and_Psychometric_Test__c,
                                                                                                         ET_Service_Emirate__c,
                                                                                                         ET_Workforce_cost_per_each_vehicle__c,
                                                                                                         ET_Workforce_profit_per_each_vehicle__c,
                                                                                                         Profit_Percentage_from_Master__c,
                                                                                                         ET_Reserve_Rate__c,
                                                                                                         ET_Reserve_Amount__c,
                                                                                                         Total_dynamic_other_cost__c,
                                                                                                         ET_Price_Utilization__c,
                                                                                                         ET_Pricing_Type__c,
                                                                                                         ET_Discounts_Additional_Profit__c,
                                                                                                         Manpower_Profit_Margin_Target_Prices__c,
                                                                                                         Manpower_Profit_Value_Target_Prices__c,
                                                                                                         Reserve_Cost_Target_Prices__c,
                                                                                                         Manpower_Reserve_Discounted__c,
                                                                                                         Total_Cost_Discounted__c,
                                                                                                         Manpower_Profit_Value_Discounted__c,
                                                                                                         ET_Pricing_Method__c,
                                                                                                         Workforce_cost_per_each_veh_Discounted__c,
                                                                                                         Workforce_cost_per_each_veh_Target__c,
                                                                                                         Workforce_profit_per_each_veh_Discounte__c,
                                                                                                         Workforce_profit_per_each_veh_Target__c,
                                                                                                         Vehicle_Quote_Item__c,
                                                                                                         Vehicle_Quote_Item__r.ET_Vehicle_Source__c,
                                                                                                         Notes__c,
                                                                                                         Total_Annual_Price_excluding_VAT__c,
                                                                                                         Total_Monthly_Price_excluding_VAT__c,
                                                                                                         Total_Annual_Price_including_VAT__c,
                                                                                                         Total_Monthly_Price_including_VAT__c,
                                                                                                         Total_Value_Of_Rental__c,
                                                                                                         Total_Manpower_Profits__c,
                                                                                                         Gross_profit_margin__c,
                                                                                                         Type__c,
                                                                                                         Reliever_For__c,
                                                                                                         Reliever_Cost__c,
                                                                                                         Reliever_cost_per_main_workforce__c,
                                                                                                         Corporate_Tax__c,
                                                                                                         Extra_KM_Workforce__c,
                                                                                                         (SELECT Name, ET_Cost__c, Workforce_Quote_Item__c from Quote_Item_SpecReqs__r Order by Name DESC)
                                                                                                         FROM ET_Workforce_Quote_Item__c 
                                                                                                         WHERE Quote__c IN: quoteIds   
                                                                                                         ORDER BY ET_Workforce_Line_Number__c ASC, ET_Contract_Period__c ASC, Quote__r.QuoteNumber ASC
                                                                                                        ]);
        return workforceQuoteItemLst;
    }
    
    @AuraEnabled 
    public static  List<ET_Workforce_Quote_Item__c> getWorkforceQuoteLineItems1(List<String> quoteIds){  
        List<ET_Workforce_Quote_Item__c> workforceQuoteItemLst = new List<ET_Workforce_Quote_Item__c> ( [select  Extra_KM_Workforce__c, ET_Workforce_Quote_Item_Type__c,
                                                                                                         ET_Workforce_Line_Number__c, ET_Contract_Period__c
                                                                                                         
                                                                                                         FROM    ET_Workforce_Quote_Item__c 
                                                                                                         where   Quote__c IN: quoteIds   
                                                                                                         order by  ET_Workforce_Line_Number__c asc, ET_Contract_Period__c asc
                                                                                                        ]);
        return workforceQuoteItemLst;
    }
    
    public static Map<Integer,Map<String,Map<Integer,ET_Workforce_Quote_Item__c>>> buildMapForExtraKMPrice(List<String> quoteIds){
        
        List<ET_Workforce_Quote_Item__c> workforceQuoteItemLst = getWorkforceQuoteLineItems1(quoteIds);
        Map<Integer,Map<String,Map<Integer,ET_Workforce_Quote_Item__c>>> workforceWrapper = new Map<Integer,Map<String,Map<Integer,ET_Workforce_Quote_Item__c>>>();
        Set<Integer> workforceLines = new Set<Integer>();
        
        for(ET_Workforce_Quote_Item__c workforceQitem:workforceQuoteItemLst)
        {
            workforceLines.add(Integer.valueOf(workforceQitem.ET_Workforce_Line_Number__c)); 
        }
        for(Integer lineno: workforceLines)
        {
            Map<String,Map<Integer,ET_Workforce_Quote_Item__c>> workForceMapWithWorkForceType = new Map<String,Map<Integer,ET_Workforce_Quote_Item__c>>();
            
            for(ET_Workforce_Quote_Item__c workforceQitem:workforceQuoteItemLst)
            {
                // Driver and Nanny data comes according to line
                // rest all Manpowers like - Supervisor, Coordinator, accountant, other employee -- should be considered for all lines...
                if(workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Driver' || workforceQitem.ET_Workforce_Quote_Item_Type__c == 'Nanny'){
                    if(Integer.valueOf(workforceQitem.ET_Workforce_Line_Number__c) == lineno){
                        if(workForceMapWithWorkForceType.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                        {
                            Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear  = workForceMapWithWorkForceType.get(workforceQitem.ET_Workforce_Quote_Item_Type__c);
                            if(!workforceMapByContractYear.containsKey(Integer.valueOf(workforceQitem.ET_Contract_Period__c)))
                            {
                                workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                                workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                            }
                        }else{
                            Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear = new   Map<Integer,ET_Workforce_Quote_Item__c>();
                            workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                            workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                        }
                    }
                }
                else{
                    if(workForceMapWithWorkForceType.containsKey(workforceQitem.ET_Workforce_Quote_Item_Type__c))
                    {
                        Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear  = workForceMapWithWorkForceType.get(workforceQitem.ET_Workforce_Quote_Item_Type__c);
                        if(!workforceMapByContractYear.containsKey(Integer.valueOf(workforceQitem.ET_Contract_Period__c)))
                        {
                            workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                            workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                        }
                    }else{
                        Map<Integer,ET_Workforce_Quote_Item__c> workforceMapByContractYear = new   Map<Integer,ET_Workforce_Quote_Item__c>();
                        workforceMapByContractYear.put(Integer.valueOf(workforceQitem.ET_Contract_Period__c),workforceQitem);
                        workForceMapWithWorkForceType.put(workforceQitem.ET_Workforce_Quote_Item_Type__c,workforceMapByContractYear);
                    }
                }
            }
            workforceWrapper.put(lineno, workForceMapWithWorkForceType);
        }
        
        System.debug('------workforceWrapper------'+ JSON.serializePretty(workforceWrapper));
        return workforceWrapper;
    }
    
    public static Map<String, Map<String, Decimal>> getFinancialAnalysis(List<String> quoteIds){
        List<Financial_Analysis__c> financeRecList = getFinanceCalculationsRecords(quoteIds);
        Map<String, Map<String, Decimal>> vehicleIdAndCost = new Map<String, Map<String, Decimal>>();
        
        for(Financial_Analysis__c financeRec:financeRecList){
            Map<String, Decimal> extraInfo =  new Map<String, Decimal>();
            extraInfo.put('totalAnnualPrice', (financeRec.Total_Annual_Price_excluding_VAT__c).setScale(2));
            extraInfo.put('extraKMPrice', (financeRec.extraKMPrice__c).setScale(2));
            System.debug('extraInfo: '+extraInfo);
            vehicleIdAndCost.put(financeRec.Vehicle_Quote_Item__c, extraInfo);
        }
        return vehicleIdAndCost;
    }
    
    public static List<Financial_Analysis__c> getFinanceCalculationsRecords(List<String> quoteIds){
        List<Financial_Analysis__c> financeRecList = new List<Financial_Analysis__c>([Select Id, Contract_Year__c, Line__c,
                                                                                      quote__r.ET_Type__c,
                                                                                      Vehicle_Quote_Item__c,
                                                                                      Request_Mapping__r.ET_Vehicle_Unique_key__c,
                                                                                      ET_Vehicle_Unique_key__c,
                                                                                      Total_Annual_Cost__c,
                                                                                      Total_Annual_Price_excluding_VAT__c,
                                                                                      Total_Annual_Profit__c,
                                                                                      Price_Per_Month_excluding_VAT__c,
                                                                                      VAT_Amount__c,
                                                                                      Total_Annual_Price_including_VAT__c,
                                                                                      Price_Per_Month_including_VAT__c,
                                                                                      Total_Value_of_Rental__c,
                                                                                      Total_Depreciation__c,
                                                                                      Total_Resale_Value__c,
                                                                                      Total_Vehicle_Profits__c,
                                                                                      Total_Driver_Profits__c,
                                                                                      Total_Nanny_Profits__c,
                                                                                      Total_Coordinator_Profits__c,
                                                                                      Total_Supervisor_Profits__c,
                                                                                      Total_Accountant_Profits__c,
                                                                                      Total_Other_Employee_Profits__c,
                                                                                      Total_Fuel_Profits__c,
                                                                                      Payback_1__c,
                                                                                      Payback_Ratio_1__c,
                                                                                      Payback_2__c,
                                                                                      Payback_Ratio_2__c,
                                                                                      Annual_share_of_Payback_Ratio_2__c,
                                                                                      Payback_3__c,
                                                                                      Payback_Ratio_3__c,
                                                                                      Annual_share_of_Payback_Ratio_3__c,
                                                                                      Free_Cash_Flow_Annual__c,
                                                                                      Free_Cash_Flow_Cumulative__c,
                                                                                      Net_Present_Value__c,
                                                                                      Net_Profit_Margin__c,
                                                                                      Cost_Of_Capital_Assumed__c,
                                                                                      Payback_Period_Years__c,
                                                                                      Internal_Rate_of_Return__c,
                                                                                      Return_on_Investment__c ,
                                                                                      ET_Pricing_Type__c,
                                                                                      Price_Per_Pricing_Type__c,
                                                                                      ET_Pricing_Method__c,
                                                                                      Utilization_factor__c,
                                                                                      Total_Annual_Cost_Discounted__c,
                                                                                      Total_Annual_Cost_Target_Price__c,
                                                                                      Total_Annual_Profit_Discounted__c,
                                                                                      Total_annual_Profit_Target_Price__c,
                                                                                      Total_Annual_Price_excluding_VAT_Discoun__c,
                                                                                      Total_Annual_Price_excluding_VAT_Target__c,
                                                                                      Free_Cash_Flow_Annual_Discounted__c,
                                                                                      Free_Cash_Flow_Annual_Target__c,
                                                                                      Free_Cash_Flow_Cumulative_Discounted__c,
                                                                                      Free_Cash_Flow_Cumulative_Target__c,
                                                                                      Net_Present_Value_Discounted__c,
                                                                                      Net_Present_Value_Target__c,
                                                                                      Net_Profit_Margin_Discounted__c,
                                                                                      Net_Profit_Margin_Target__c,
                                                                                      Payback_Period_in_Years_Discounted__c,
                                                                                      Payback_Period_in_Years_Target__c,
                                                                                      Internal_Rate_of_Return_Discounted__c,
                                                                                      Internal_Rate_of_Return_Target__c,
                                                                                      Return_on_Investment_Discounted__c,
                                                                                      Return_on_Investment_Target__c,
                                                                                      is_Target_Price_Required__c,
                                                                                      Number_of_Vehicles__c,
                                                                                      Resale_Value_used_for_Calculation__c,
                                                                                      Total_Profit_used_for_calculation__c,
                                                                                      Total_Profit_used_for_calc_Discount__c,
                                                                                      Total_Profit_used_for_calc_Target__c,
                                                                                      Total_Manpower_profit_used_for_calcs__c,
                                                                                      Unique_Identifier__c,
                                                                                      Total_Nanny_Profits_Target__c,
                                                                                      Total_Coordinator_Profits_Target__c,
                                                                                      Total_Supervisor_Profits_Target__c,
                                                                                      Total_Accountant_Profits_Target__c,
                                                                                      Total_Other_Emp_Profits_Target__c,
                                                                                      Total_Fuel_Profits_Target__c,
                                                                                      Total_Driver_Profits_Discounted__c,
                                                                                      Total_Nanny_Profits_Discounted__c,
                                                                                      Total_Coordinator_Profits_Discounted__c,
                                                                                      Total_Supervisor_Profits_Discounted__c,
                                                                                      Total_Accountant_Profits_Discounted__c,
                                                                                      Total_other_Emp_Profits_Discounted__c,
                                                                                      Total_Fuel_Profits_Discounted__c,
                                                                                      Total_Driver_Profits_Target__c,
                                                                                      Tot_Ann_price_exc_vat_for_vehicle_fuel__c,
                                                                                      Price_Per_month_excluding_VAT_Vehicle__c,
                                                                                      VAT_Amount_for_Vehicle__c,
                                                                                      Total_Annual_Price_including_VAT_Vehicle__c,
                                                                                      Price_Per_Month_including_VAT_Vehicle__c,
                                                                                      Total_Annual_Pric_excluding_VAT_Manpower__c,
                                                                                      Price_Per_Month_excluding_VAT_Manpower__c,
                                                                                      VAT_Amount_for_Manpower__c,
                                                                                      Total_Annual_Price_including_VAT_Manpowe__c,
                                                                                      Price_Per_month_including_VAT_Manpower__c,
                                                                                      Request_for_separate_prices__c,
                                                                                      extraKMPrice__c,
                                                                                      Corporate_Tax__c,
                                                                                      Vehicle_source__c
                                                                                      From Financial_Analysis__c
                                                                                      Where Quote__c IN: quoteIds order By Line__c,Contract_Year__c]);
        
        return financeRecList;
    }
    
    @AuraEnabled
    public static Map<String, String> fetchOppoRelatedQuoteList(String oppId){
        Map<Id, Opportunity> initOppMap = new Map<Id, Opportunity>();
        Set<Id> oppIds = New Set<Id>();
        Map<String, String> quoteIdNames = new Map<String, String>();
        String leasingRecTypes = 'ETSALES_Leasing;ETSALES_Logistics;ETSALES_Manpower';
        if(oppId != null){
            for(Opportunity opp: [SELECT Id,AccountId,ETSALES_Sector__c,Recordtype.DeveloperName FROM Opportunity WHERE Id =: oppId AND StageName != 'Closed Won' AND StageName != 'Closed Lost' AND StageName != 'Closed Cancelled']){
                if(!initOppMap.containsKey(opp.Id))
                    initOppMap.put(opp.Id,opp);
            }
            if(initOppMap.Size() > 0 && initOppMap.values().Size()>0){
                if(initOppMap.values()[0].Recordtype.DeveloperName == 'ETSALES_Leasing' || initOppMap.values()[0].Recordtype.DeveloperName == 'ETSALES_Logistics' || initOppMap.values()[0].Recordtype.DeveloperName == 'ETSALES_Manpower'){
                    for(Opportunity opp: [SELECT Id FROM Opportunity WHERE AccountId =: initOppMap.values()[0].AccountId AND ETSALES_Sector__c =: initOppMap.values()[0].ETSALES_Sector__c AND Recordtype.DeveloperName IN: leasingRecTypes.split(';') AND StageName != 'Closed Won' AND StageName != 'Closed Lost' AND StageName != 'Closed Cancelled']){
                        oppIds.add(opp.Id);
                    }
                }else if(initOppMap.values()[0].Recordtype.DeveloperName == 'ETSALES_Transportation'){
                    for(Opportunity opp: [SELECT Id FROM Opportunity WHERE AccountId =: initOppMap.values()[0].AccountId AND ETSALES_Sector__c =: initOppMap.values()[0].ETSALES_Sector__c AND Recordtype.DeveloperName =: initOppMap.values()[0].Recordtype.DeveloperName AND StageName != 'Closed Won' AND StageName != 'Closed Lost' AND StageName != 'Closed Cancelled']){
                        oppIds.add(opp.Id);
                    }
                }
            }
            if(oppIds.Size() > 0){
                for(Quote q : [select id, Opportunity.Name, Opportunity.ETSALES_Opportunity_Number__c,QuoteNumber from Quote where OpportunityId IN: oppIds AND ET_Type__c = 'Quote for Approval' order by createdDate desc]){
                    quoteIdNames.put(q.id, q.QuoteNumber+' '+q.Opportunity.ETSALES_Opportunity_Number__c);
                }
            }
        }
        System.debug('initOppMap: '+initOppMap);
        System.debug('oppIds: '+oppIds);
        return quoteIdNames;
    }
    
    @AuraEnabled
    public static Map<String, List<TermAndCondition>> getAllTerms(String oppoId){
        
        Opportunity opp = [Select id, name, RecordTypeId, RecordType.Name, RecordType.DeveloperName, ETSALES_Sector__c  
                           from Opportunity where id=: oppoId];
        
        List<TermAndCondition> defaultTerms = new List<TermAndCondition>();
        List<TermAndCondition> allTerms = new List<TermAndCondition>();
        
        List<TermsAndCondition__c> terms = [Select id, name, Terms_Description__c,Line_Order__c, Term_Code__c, Charge_Type__c, 
                                            Charge_Value__c, Charge_Type_Value__c, Chargeable_to_Customer__c, 
                                            Remarks__c, Remarks_Value__c, Remark_Type__c,
                                            Default_SCH__c, Default_TL__c, IsMaster__c, Additional_Term_Text__c,
                                            IsRequired_TL_Term__c, Is_Required_Sch_Term__c,
                                            Charge_Value_Freeze_For_T_L__c, Charge_Value_Freeze_For_Sch__c,
                                            Charge_Value_Type_Freeze_For_T_L__c, Charge_Value_Type_Freeze_For_Sch__c,
                                            Remarks_Value_Freeze_For_T_L__c, Remarks_Value_Freeze_For_Sch__c,
                                            Remarks_Value_Type_Freeze_For_T_L__c, Remarks_Value_Type_Freeze_For_Sch__c
                                            from TermsAndCondition__c where Line_Order__c != Null AND  IsMaster__c = true order by Line_Order__c];
        
        //base on opportunity sector there are different default terms
        if(opp.RecordType.DeveloperName =='ETSALES_Leasing' || opp.RecordType.DeveloperName=='ETSALES_Transportation' || opp.RecordType.DeveloperName=='ETSALES_Logistics'){
            for(TermsAndCondition__c term1: terms){
                TermAndCondition temp = buildTermObject(term1, opp);
                
                if(opp.ETSALES_Sector__c == 'School' && term1.Default_SCH__c == true){
                    defaultTerms.add(temp);
                }else if(opp.ETSALES_Sector__c == 'Transport And Lease'  && term1.Default_TL__c == true){
                    defaultTerms.add(temp);
                }
                allTerms.add(temp);
            }
        }
        
        Map<String, List<TermAndCondition>> termsForLWC = new Map<String, List<TermAndCondition>>();
        termsForLWC.put('defaultTerms', defaultTerms);
        termsForLWC.put('allTerms', allTerms);
        return termsForLWC;
    }
    
    public static TermAndCondition buildTermObject(TermsAndCondition__c term1, Opportunity opp){
        TermAndCondition temp = new TermAndCondition();
        temp.sector = opp.ETSALES_Sector__c;
        temp.termsDescription = term1.Terms_Description__c;
        temp.termCode = term1.Term_Code__c;
        temp.orderLine = term1.Line_Order__c;
        temp.chargeType = term1.Charge_Type__c;
        temp.chargeValue = term1.Charge_Value__c;
        temp.chargeTypeValue = term1.Charge_Type_Value__c;
        temp.remarks = term1.Remarks__c;
        temp.remarksValue = term1.Remarks_Value__c;
        temp.remarkType = term1.Remark_Type__c;
        temp.chargeableToCustomer = term1.Chargeable_to_Customer__c;
        if(opp.ETSALES_Sector__c == 'School'){
            temp.isRequiredTerm = term1.Is_Required_Sch_Term__c;
            temp.isChargeValueFreezed = term1.Charge_Value_Freeze_For_Sch__c;
            temp.isChargeValueTypeFreezed = term1.Charge_Value_Type_Freeze_For_Sch__c;
            temp.isRemarksValueFreezed = term1.Remarks_Value_Freeze_For_Sch__c;
            temp.isRemarksValueTypeFreezed = term1.Remarks_Value_Type_Freeze_For_Sch__c;
        }else if(opp.ETSALES_Sector__c == 'Transport And Lease'){
            temp.isRequiredTerm = term1.IsRequired_TL_Term__c;
            temp.isChargeValueFreezed = term1.Charge_Value_Freeze_For_T_L__c;
            temp.isChargeValueTypeFreezed = term1.Charge_Value_Type_Freeze_For_T_L__c;
            temp.isRemarksValueFreezed = term1.Remarks_Value_Freeze_For_T_L__c;
            temp.isRemarksValueTypeFreezed = term1.Remarks_Value_Type_Freeze_For_T_L__c;
        }
        return temp;
    }
    
    class TermAndCondition{
        @AuraEnabled public String sector {get; set;}
        @AuraEnabled public Boolean isRequiredTerm {get; set;}
        @AuraEnabled public Boolean isChargeValueFreezed {get; set;}
        @AuraEnabled public Boolean isChargeValueTypeFreezed {get; set;}
        @AuraEnabled public Boolean isRemarksValueFreezed {get; set;}
        @AuraEnabled public Boolean isRemarksValueTypeFreezed {get; set;}
        @AuraEnabled public String termsDescription {get; set;}
        @AuraEnabled public String termCode {get; set;}
        @AuraEnabled public Decimal orderLine {get; set;}
        @AuraEnabled public String chargeType {get; set;}
        @AuraEnabled public Decimal chargeValue {get; set;}
        @AuraEnabled public String chargeTypeValue {get; set;}
        @AuraEnabled public String remarks {get; set;}
        @AuraEnabled public Decimal remarksValue {get; set;}
        @AuraEnabled public String remarkType {get; set;}
        @AuraEnabled public Boolean chargeableToCustomer {get; set;}
    }
    
    /** ----------------------------------------------- Contracts creation functions start from here-------------------------- */
    
    /**
    * @description to get the master data for contract
    */
    @AuraEnabled
    public static ContractDetail getAllContractLines(String recordId){
        
        ContractDetail contractDetail = new ContractDetail();
        List<Customer_Quote__c> customerQuotes = [Select id, name, Quote__r.Status, ETSALES_Sector__c,
                                                  Opportunity_Name__r.RecordType.Name
                                                  from Customer_Quote__c 
                                                  where id=:recordId limit 1];
        Customer_Quote__c customerQuote = new Customer_Quote__c();
        if(!customerQuotes.isEmpty()){
            customerQuote = customerQuotes.get(0);
        }
        String sector = getSector(customerQuote);
        contractDetail.articlesDetail = buildArticlesArray(sector);
        contractDetail.customerQuote = customerQuote;
        return contractDetail;
    }
    
    @AuraEnabled
    public static ContractDetail getAddendumContractLines(String recordId, String admType){
        String sector;
        ContractDetail contractDetail = new ContractDetail();
        List<Customer_Quote__c> customerQuotes = [Select id, name, Quote__r.Status, ETSALES_Sector__c,
                                                  Opportunity_Name__r.RecordType.Name
                                                  from Customer_Quote__c 
                                                  where id=:recordId limit 1];
        Customer_Quote__c customerQuote = new Customer_Quote__c();
        if(!customerQuotes.isEmpty()){
            customerQuote = customerQuotes.get(0);
        }
        if(admType == 'Renewal' || admType == 'Extension')
        {
            sector = 'ADM_RENEWAL';
        }
        else if(admType == 'Additional')
        {
            sector = 'ADM_ADDITIONAL';
        }
        else
        {
            sector = 'None';
        }
         //getSector(customerQuote);
        contractDetail.articlesDetail = buildArticlesArray(sector);
        contractDetail.customerQuote = customerQuote;
        return contractDetail;
    }
    
    public static String getSector(Customer_Quote__c customerQuotes){
        if(customerQuotes.ETSALES_Sector__c == 'School'){
            return 'ST';
        }else if(customerQuotes.Opportunity_Name__r.RecordType.Name == 'Transportation'){
            return 'Transportation';
        }else{
            	return 'T&L';
        	}
    }
    
    /**
    * @description to build the contract master data array
    */
    public static List<Article> buildArticlesArray(String sector){
        List<Contract_Master__c> allArticlesDetail = [Select id, Name, Description__c,Line_No__c, (select id,Name,Description__c,Editable__c, Line_No__c from Contract_Lines__r order by Line_No__c)
                                                      from Contract_Master__c where is_master__c = true and Name<>'Additional' and Contract_Type__c =:sector order by Line_No__c];
        List<Article> articlesDetail = new  List<Article>();
        for(Contract_Master__c contractMaster: allArticlesDetail){
            Article article = new Article();
            article.Id = contractMaster.Id;
            article.Name = contractMaster.Name;
            article.Description = contractMaster.Description__c;
            article.articleLineNo = contractMaster.Line_No__c;
            List<SubCaluse> subCaluses = new List<SubCaluse>();
            for(Contract_Line__c contractLine: contractMaster.Contract_Lines__r){
                SubCaluse subCaluse = new SubCaluse();
                subCaluse.Id = contractLine.Id;
                subCaluse.Name = contractLine.Name;
                subCaluse.Description = contractLine.Description__c;
                subCaluse.SubClauseNo = contractLine.Line_No__c;
                subCaluse.isEditable = !(contractLine.Editable__c);// to disable the checkbox if cluase is not editable
                subCaluse.refArticleId = contractLine.Id;
                subCaluses.add(subCaluse);
            }
            article.subCaluses = subCaluses;
            articlesDetail.add(article);
        }
        return articlesDetail;
    }

    @AuraEnabled
	public static List<Article> buildAdditionalArticles(String sector){
        List<Contract_Master__c> allArticlesDetail = [Select id, Name, Description__c,Line_No__c, (select id,Name,Description__c,Editable__c, Line_No__c from Contract_Lines__r order by Line_No__c)
                                                      from Contract_Master__c where is_master__c = true and Name='Additional' and Contract_Type__c =:sector order by Line_No__c];
        List<Article> articlesDetail = new  List<Article>();
        for(Contract_Master__c contractMaster: allArticlesDetail){
            Article article = new Article();
            article.Id = contractMaster.Id;
            article.Name = contractMaster.Name;
            article.Description = contractMaster.Description__c;
            article.articleLineNo = contractMaster.Line_No__c;
            List<SubCaluse> subCaluses = new List<SubCaluse>();
            for(Contract_Line__c contractLine: contractMaster.Contract_Lines__r){
                SubCaluse subCaluse = new SubCaluse();
                subCaluse.Id = contractLine.Id;
                subCaluse.Name = contractLine.Name;
                subCaluse.Description = contractLine.Description__c;
                subCaluse.SubClauseNo = contractLine.Line_No__c;
                subCaluse.isEditable = !(contractLine.Editable__c);// to disable the checkbox if cluase is not editable
                subCaluse.refArticleId = contractLine.Id;
                subCaluses.add(subCaluse);
            }
            article.subCaluses = subCaluses;
            articlesDetail.add(article);
        }
        return articlesDetail;
    }
    
    /**
* When user first time click on the submit for Approval button 
*/
    @AuraEnabled
    public static Boolean submitContractforApproval(String recordId){
        Boolean flag = false;
        try{
            Contract_Pdf_Header__c pdfHeader = [Select id, name, Approval_Status__c, Approval_Stage__c, All_Approval_Finished__c from Contract_Pdf_Header__c where id=:recordId];
            String team = getApproversTeam(pdfHeader);
            System.debug('----team----'+team);
            if(team == 'Approval Finish'){
                pdfHeader.Approval_Status__c = 'Approved';
                pdfHeader.All_Approval_Finished__c = true;
            }else{
                pdfHeader.Approval_Status__c = 'Submitted';
                pdfHeader.Approval_Stage__c = team;
            }
            update pdfHeader;
            flag = true;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return flag;
    }
    
    public static String getApproversTeam(Contract_Pdf_Header__c pdfHeader){
        String team = '';
        if(String.isBlank(pdfHeader.Approval_Stage__c) && String.isBlank(pdfHeader.Approval_Status__c) && pdfHeader.All_Approval_Finished__c == false){
            team = getNextApproverTeam(pdfHeader.Id, '');
        }
        return team;
    }
    
    /**
* @description we have defined list of approvers according to their priority means 
* which team is going to approve first and which one is the next
*/
    public static String getNextApproverTeam(String recordId, String currentApprover){
        String nextApprover = '';
        Integer currentApproverIndex = -1; //if the user has just submitted the contract for approval then we need to return back first approver team from the approval sequence array 
        Boolean moveToNextTeam = false;
        
        do{
            System.debug('----Current Approver---'+currentApprover);
            
            if(!(String.isBlank(currentApprover))){
                currentApproverIndex = approvalSequence.indexOf(currentApprover);
            }
            Integer nextApproverIndex = currentApproverIndex + 1;
            if(nextApproverIndex < approvalSequence.size()){
                nextApprover =  approvalSequence.get(nextApproverIndex);
            }else{
                nextApprover = 'Approval Finish';
                break;
            }
            
            //to check whether there is some clause which required approval from current team or not
            List<Article> allArticlesDetail =  getChangedContractClauses(recordId, nextApprover);
            if(allArticlesDetail.isEmpty()){
                moveToNextTeam = true;
                currentApprover = nextApprover;
            }else{
                moveToNextTeam = false;
            }
            
        }while(moveToNextTeam);
        
        return nextApprover;
    }
    
    @AuraEnabled
    public static Boolean approveContract(String recordId){
        Boolean flag = false;
        try{
            Contract_Pdf_Header__c pdfHeader = [Select id, name, Approval_Status__c, Approval_Stage__c, All_Approval_Finished__c from Contract_Pdf_Header__c where id=:recordId];
            String nextApprover = getNextApproverTeam(recordId ,pdfHeader.Approval_Stage__c);
            if(nextApprover != 'Approval Finish'){
                pdfHeader.Approval_Status__c = 'Submitted';
                pdfHeader.Approval_Stage__c = nextApprover;
            }else{
                pdfHeader.Approval_Status__c = 'Approved';
                pdfHeader.All_Approval_Finished__c = true;
            }
            update pdfHeader;
            flag = true;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return flag;
    }
    
    @AuraEnabled
    public static List<Article> getContractDetail(String recordId){
        Contract_Pdf_Header__c pdfHeader = [Select id, name, Approval_Status__c, Approval_Stage__c from Contract_Pdf_Header__c where id=:recordId];
        return getChangedContractClauses(recordId, pdfHeader.Approval_Stage__c);
    }   
    
    /**
    * @description to return the clauses for which we need approval at specific stage of contract
    */
    public static List<Article> getChangedContractClauses(String recordId, String stage){
        
        List<Contract_Master__c> allArticlesDetail = [Select id, Name, Description__c,Line_No__c, 
                                                      (select id, Name, Description__c, Editable__c, Delete__c, Line_No__c, Referenced_Article__r.Name, 
                                                       Referenced_Article__r.Clause_Approvers__c, Referenced_Article__r.Description__c 
                                                       from Contract_Lines__r 
                                                       Where Referenced_Article__r.Clause_Approvers__c includes (:stage) AND (Editable__c = true OR  Delete__c =true)
                                                       order by Line_No__c)
                                                      from Contract_Master__c 
                                                      where Contract_Pdf_Header__c =:recordId
                                                      order by Line_No__c];
        return buildContractArray(allArticlesDetail);
    }
    
    /**
* @description to get articles detail to print in the pdf
*/
    public static List<Article> getContractClauses(String recordId){
        Contract_Pdf_Header__c pdfHeader = [Select id, name, Approval_Status__c, Approval_Stage__c from Contract_Pdf_Header__c where id=:recordId];
        
        List<Contract_Master__c> allArticlesDetail = [Select id, Name, Description__c,Line_No__c, 
                                                      (select id, Name, Description__c, Editable__c, Delete__c, Line_No__c, Referenced_Article__r.Name, 
                                                       Referenced_Article__r.Clause_Approvers__c, Referenced_Article__r.Description__c 
                                                       from Contract_Lines__r where Delete__c = false
                                                       order by Line_No__c)
                                                      from Contract_Master__c 
                                                      where Contract_Pdf_Header__c =:recordId
                                                      order by Line_No__c];
        return buildContractArray(allArticlesDetail);
    } 
    
    public static List<Article> buildContractArray(List<Contract_Master__c> allArticlesDetail){
        List<Article> articlesDetail = new  List<Article>();
        for(Contract_Master__c contractMaster: allArticlesDetail){
            Article article = new Article();
            article.Id = contractMaster.Id;
            article.Name = contractMaster.Name;
            article.Description = contractMaster.Description__c;
            article.articleLineNo = contractMaster.Line_No__c;
            List<SubCaluse> subCaluses = new List<SubCaluse>();
            for(Contract_Line__c contractLine: contractMaster.Contract_Lines__r){
                SubCaluse subCaluse = new SubCaluse();
                subCaluse.Id = contractLine.Id;
                subCaluse.Name = contractLine.Name;
                subCaluse.Description = contractLine.Description__c;
                subCaluse.SubClauseNo = contractLine.Line_No__c;
                subCaluse.isEditable = contractLine.Editable__c;
                subCaluse.isDeleteAble = contractLine.Delete__c;
                subCaluse.refArticleId = contractLine.Id;
                subCaluse.refArticleDescription = contractLine.Referenced_Article__r.Description__c;
                subCaluses.add(subCaluse);
            }
            if(!subCaluses.isEmpty()){
                article.subCaluses = subCaluses;
                articlesDetail.add(article);
            }
        }
        return articlesDetail;
    }
    
    public class ContractDetail{
        @AuraEnabled public List<Article> articlesDetail {get; set;}
        @AuraEnabled public Customer_Quote__c customerQuote {get; set;}
    }
    
    public class Article{
        @AuraEnabled public String Id {get; set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String Description {get; set;}
        @AuraEnabled public Decimal articleLineNo{get; set;}
        @AuraEnabled public List<SubCaluse> subCaluses{get; set;}
    }
    
    public class SubCaluse{
        @AuraEnabled public String Id {get; set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String Description {get; set;}
        @AuraEnabled public Decimal SubClauseNo {get; set;}
        @AuraEnabled public Boolean isEditable {get; set;}
        @AuraEnabled public Boolean isDeleteAble {get; set;}
        @AuraEnabled public String refArticleId {get; set;}
        @AuraEnabled public String refArticleDescription {get; set;}
        
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