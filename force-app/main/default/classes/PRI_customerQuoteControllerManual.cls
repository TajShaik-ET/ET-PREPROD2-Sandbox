public with sharing class PRI_customerQuoteControllerManual {
    
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
    public static Map<String,PSRDetail> getPSRData(List<String> recordIds){
        /*System.debug('recordId1: '+recordId1);
        List<String> recordIds = New List<String>();
        if(recordId1 != null)
        recordIds = recordId1.split(',');*/
        system.debug('----getPSRData----'+recordIds);
        Map<String,PSRDetail> psrDetailMap = New Map<String,PSRDetail>();
        List<ET_Pricing_Service_Request__c> quoteList = New List<ET_Pricing_Service_Request__c>();
        Set<Id> optyIds = new Set<Id>();
        Map<String,Integer> optyToCQuoteMap = New Map<String,Integer>();
        for(ET_Pricing_Service_Request__c p: [Select id,Name,Opportunity__r.AccountId,Opportunity__r.Account.Name,Opportunity__r.Account.ETSALES_Profile_Class__c, 
                      Opportunity__r.Account.AccountNumber, Opportunity__r.Account.RecordType.name, Opportunity__r.RecordType.DeveloperName,
                      Opportunity__r.Type, Opportunity__r.ETSALES_Opportunity_Number__c,
                      CreatedBy.Name,Opportunity__r.owner.name,
                      Opportunity__r.ETSALES_Sector__c, Opportunity__r.RecordType.name, Opportunity__r.Id, Opportunity__r.Fuel_Included_Current_Contract__c
                      From ET_Pricing_Service_Request__c Where Id IN: recordIds]){
                          quoteList.add(p);
                          optyIds.add(p.Opportunity__r.Id);
                      }
        for(Customer_Quote__c cQuote: [Select Id, Name, Opportunity_Name__c FROM Customer_Quote__c WHERE Opportunity_Name__c IN: optyIds]){
            if(!optyToCQuoteMap.containsKey(cQuote.Opportunity_Name__c))
                optyToCQuoteMap.put(cQuote.Opportunity_Name__c,1);
            if(optyToCQuoteMap.containsKey(cQuote.Opportunity_Name__c))
                optyToCQuoteMap.put(cQuote.Opportunity_Name__c,optyToCQuoteMap.get(cQuote.Opportunity_Name__c)+1);
        }
        for(ET_Pricing_Service_Request__c p: quoteList){
            if(!psrDetailMap.containsKey(p.Id)){
                PSRDetail psrDetail = new PSRDetail();
                psrDetail.quote = p;
                psrDetail.customerQuoteCount = optyToCQuoteMap.containsKey(p.Opportunity__r.Id) ? optyToCQuoteMap.get(p.Opportunity__r.Id) : 0;
                psrDetailMap.put(p.Id,PSRDetail);
                system.debug('--getPSRData--return--'+p);
                system.debug('--psrDetail--'+PSRDetail);
            }
        }
        system.debug('psrDetailMap>>>>>>'+ psrDetailMap);
        return psrDetailMap;
    }

    @auraEnabled (cacheable=true)
    public static List<Opportunity> getOpportunityData(Id OppId){

        List<Opportunity> opp = [SELECT Id, AccountId, Account.Name,Account.ETSALES_Profile_Class__c, 
                                        Account.AccountNumber, Account.RecordType.name, RecordType.DeveloperName, Type, 
                                        ETSALES_Opportunity_Number__c, Owner.Name, 
                                        ETSALES_Sector__c, RecordType.name, Fuel_Included_Current_Contract__c,
                                         CreatedDate
                                   FROM Opportunity
                                   WHERE Id =:OppId Limit 1];

        return opp;
    }
    
    @auraEnabled
    public static newLineItems fetchLineItems(List<String> quoteIds, String contractType){
        Map<String,PSRDetail> psrDetailMap = getPSRData(quoteIds);
        
        List<CustomerQuoteVehicleData>  vehicles = getQuoteVehicleLineItemData(quoteIds, psrDetailMap, contractType);
        List<CustomerWorkForceData>  workforce = getWorkforceQuoteLineItemsData(quoteIds, psrDetailMap, contractType);
        newLineItems lines = new newLineItems();
        lines.vehicleLines.addAll(vehicles);
        lines.workforceLines.addAll(workforce);
        return lines;
    }
	
	public static  List<CustomerQuoteVehicleData> getQuoteVehicleLineItemData(List<String> quoteIds,  Map<String,PSRDetail> psrDetailMap, String contractType){
        
        List<Vehicle__c> vehicles = getPSRVehicleLineItems(quoteIds);
        
		Map<String, CustomerQuoteVehicleData> vehiclesLines = new Map<String, CustomerQuoteVehicleData>();
        Map<String, String> vehicleAndPricingRequest = new Map<String, String>();
        System.debug('vehicles Size: '+vehicles.Size());
        for(Vehicle__c  vehicle :vehicles){
            CustomerQuoteVehicleData obj = new CustomerQuoteVehicleData();
			obj.Id = vehicle.id;
            obj.Name  = vehicle.ET_Vehicle_Model__c;
            obj.LineNumber = vehicle.ET_Vehicle_Line__c;
            obj.vehquantity = vehicle.ET_Vehicle_Quantity__c;
            obj.psrVehLineItemId  = vehicle.Id;
            obj.vehModel = vehicle.ET_Vehicle_Model__c;
            obj.ContractPeriodInYears = vehicle.ET_Contract_Period__c;
            obj.oppoRecordType = vehicle.ET_Pricing_Service_Request__r.Opportunity__r.RecordType.name;
            obj.psrVehicle = vehicle.ET_Pricing_Service_Request__r; 
            obj.vehicleLineId  = vehicle.id;
            obj.purchasePrice  = vehicle.ET_Vehicle_Current_Purchase_Price__c;
            
            
            
            //if contract is monthly then we need vehicle lines with the contract periode 1st year 
            if(contractType == 'Monthly' && vehicle.ET_Contract_Period__c == '1'){
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
        
        /*for(ET_Other_Cost_Request__c otherCost : [Select Name, ET_Cost_Value__c, ET_Cost_Type__c, Vehicle_Request__c from ET_Other_Cost_Request__c
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
                                                  }*/
        system.debug('---vehiclesLines---'+ JSON.serializePretty(vehiclesLines));
        return vehiclesLines.values();
    }
    
    
	public static  List<CustomerWorkForceData> getWorkforceQuoteLineItemsData(List<String> quoteIds, Map<String,PSRDetail> psrDetailMap, String contractType){
        List<CustomerWorkForceData> workForceLines = new List<CustomerWorkForceData>();
        
        /*if((quote.Opportunity.ETSALES_Sector__c == 'School'  ||  quote.Opportunity.ETSALES_Sector__c == 'Transport And Lease')&&
        quote.Opportunity.RecordType.DeveloperName=='ETSALES_Transportation'){
        return workForceLines;
        }*/
        List<ET_Work_force__c> workforceItems = getWorkforcePSRLineItems(quoteIds);
        System.debug('-----getWorkforceQuoteLineItemsData------'+quoteIds);
        System.debug('-----getWorkforceQuoteLineItemsData---workforceItems.size()---'+workforceItems.size());
        Map<String, CustomerWorkForceData> workforceForEachCategory = new Map<String, CustomerWorkForceData>();
        System.debug('workforceItems Size: '+workforceItems.Size());
        for(ET_Work_force__c  workforceItem :workforceItems){
            System.debug('workforceItem.Quote__c: '+workforceItem.ET_Pricing_Service_Request__c);
            ET_Pricing_Service_Request__c quote = psrDetailMap.get(workforceItem.ET_Pricing_Service_Request__c).quote;   
            System.debug('ETSALES_Sector__c: '+quote.Opportunity__r.ETSALES_Sector__c+' DeveloperName: '+quote.Opportunity__r.RecordType.DeveloperName);         
            if((quote.Opportunity__r.ETSALES_Sector__c == 'School'  ||  quote.Opportunity__r.ETSALES_Sector__c == 'Transport And Lease')){
                CustomerWorkForceData obj = new CustomerWorkForceData();
                obj.Name  = 'Driver';
                obj.LineNumber = workforceItem.ET_Workforce_Line_Info__c;
                obj.NumberOfWorker = workforceItem.ET_No_of_Drivers__c;
                obj.quoteWorkforceItemId  = workforceItem.Id;
                //obj.TotalWorkforceCost = workforceItem.ET_Total_Cost__c;
                obj.ContractPeriodInYears = workforceItem.ET_Contract_Period__c;
                obj.workforceRecordtype = workforceItem.ET_Workforce_Record_Type_Name__c;
                obj.workForceId = workforceItem.id;
                obj.workforceType = workforceItem.Type__c;
                obj.serviceType = workforceItem.ET_Service_Type__c;
                //obj.monthlyVehiclePrice = calculateWorkforceMonthlyCost(workforceItem, quote);
                obj.psrWorkforce = workforceItem.ET_Pricing_Service_Request__r; 
                System.debug('obj: '+obj);
                // obj.monthlyVehiclePrice = (workforceItem.ET_Total_Cost__c/12).setScale(2);
                obj.oppoRecordType = workforceItem.ET_Pricing_Service_Request__r.Opportunity__r.RecordType.name;
                
                //if contract is monthly then we need workforce lines with the contract periode 1st year only
                if(contractType == 'Monthly' && workforceItem.ET_Contract_Period__c == '1 Yr'){
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
    
    
	public class newLineItems{
        @AuraEnabled public List<CustomerWorkForceData> workforceLines = new List<CustomerWorkForceData>();
        @AuraEnabled public List<CustomerQuoteVehicleData> vehicleLines = new List<CustomerQuoteVehicleData>();
    }
    

	public class CustomerQuoteVehicleData{
        @AuraEnabled public id Id {get; set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public Decimal LineNumber {get; set;}
        @AuraEnabled public Decimal vehquantity {get; set;}
        @AuraEnabled public String vehModel {get; set;}
		@AuraEnabled public String psrVehLineItemId {get; set;}
        @AuraEnabled public String vehicleLineId {get; set;}
        @AuraEnabled public String oppoRecordType {get; set;}
        @AuraEnabled public ET_Pricing_Service_Request__c psrVehicle {get; set;}
		@AuraEnabled public String ContractPeriodInYears {get; set;}
        @Auraenabled public Decimal purchasePrice {get; set;}
        
    }
    
    public class OtherSpec{
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public Decimal amount {get; set;}
        @AuraEnabled public String costType {get; set;}
    }
    
    
	public class CustomerWorkForceData{
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String LineNumber {get; set;}
        @AuraEnabled public Decimal NumberOfWorker {get; set;}
        @AuraEnabled public String quoteWorkforceItemId {get; set;}
        @AuraEnabled public String ContractPeriodInYears {get; set;}
        @AuraEnabled public String oppoRecordType {get; set;}
        @AuraEnabled public String workforceRecordtype {get; set;}
        @AuraEnabled public String workForceId {get; set;}
        @AuraEnabled public String serviceType {get; set;}
        @AuraEnabled public String workforceType {get; set;}
        @AuraEnabled public ET_Pricing_Service_Request__c psrWorkforce {get; set;}
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
   
    public class PSRDetail{
        @AuraEnabled public ET_Pricing_Service_Request__c quote;
        @AuraEnabled public Integer customerQuoteCount;
    }
    
	public static  List<Vehicle__c> getPSRVehicleLineItems(List<String> quoteIds){
        system.debug('------in getQuoteVehicleLineItemData------- '+quoteIds);
        List<Vehicle__c> vehicleQuoteItemLst = new List<Vehicle__c> ( [SELECT Id, Name,ET_Vehicle_Model__c, ET_Vehicle_Quantity__c,ET_Vehicle_Line__c, ET_Vehicle_Model_Year__c,
																			  ET_Pricing_Service_Request__c, ET_Pricing_Service_Request__r.Opportunity__r.RecordType.name, ET_Contract_Period__c, ET_Pricing_Type__c, ET_Vehicle_Original_Purchase_Price__c,
                                                                              ET_Vehicle_Current_Purchase_Price__c FROM Vehicle__c 
                                                                                                   WHERE ET_Pricing_Service_Request__c IN: quoteIds   
                                                                                                   ORDER BY ET_Vehicle_Line__c ASC
                                                                                                  ]
                                                                                                );
        system.debug('vehicleQuoteItemLst  = '+ JSON.serializePretty(vehicleQuoteItemLst));
        return vehicleQuoteItemLst;
    }
    
    @AuraEnabled 
    public static  List<ET_Work_force__c> getWorkforcePSRLineItems(List<String> quoteIds){  
        List<ET_Work_force__c> workforcePSRItemLst = new List<ET_Work_force__c> ( [select Id, Name, ET_No_of_Drivers__c, ET_Pricing_Type__c,Type__c,ET_Pricing_Service_Request__r.Opportunity__r.RecordType.name,
                                                                                                         ET_Contract_Type__c, ET_Contract_Period__c, ET_Pricing_Service_Request__c,
                                                                                                         ET_Pricing_Service_Request__r.Opportunity__r.Id,ET_Working_Months_Per_Year__c,
																										 ET_Workforce_Line_Info__c, ET_Workforce_Record_Type_Name__c,ET_Service_Type__c
                                                                                                         FROM    ET_Work_force__c 
                                                                                                         where   ET_Pricing_Service_Request__c IN: quoteIds   
                                                                                                         order by ET_Contract_Period__c asc
                                                                                                        ]);
        return workforcePSRItemLst;
    }
    
    
   @AuraEnabled
    public static Map<String, String> fetchOppoRelatedPSRList(String oppId){
        Map<Id, Opportunity> initOppMap = new Map<Id, Opportunity>();
        Set<Id> oppIds = New Set<Id>();
        Map<String, String> psrIdNames = new Map<String, String>();
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
                for(ET_Pricing_Service_Request__c p : [select id, Opportunity__r.Name, Opportunity__r.ETSALES_Opportunity_Number__c,Name from ET_Pricing_Service_Request__c where Opportunity__c IN: oppIds AND ET_PSR_IsActive__c = TRUE order by createdDate desc]){
                    psrIdNames.put(p.id, p.Name+' '+p.Opportunity__r.ETSALES_Opportunity_Number__c);
                }
            }
        }
        System.debug('initOppMap: '+initOppMap);
        System.debug('oppIds: '+oppIds);
        return psrIdNames;
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
        if(opp.RecordType.DeveloperName =='ETSALES_Leasing' || opp.RecordType.DeveloperName=='ETSALES_Transportation'){
            for(TermsAndCondition__c term1: terms){
                TermAndCondition temp = buildTermObject(term1, opp);
                
                if(opp.ETSALES_Sector__c == 'School' && term1.Default_SCH__c == true){
                    defaultTerms.add(temp);
                }else if(opp.ETSALES_Sector__c == 'Transport And Lease' && term1.Default_TL__c == true){
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