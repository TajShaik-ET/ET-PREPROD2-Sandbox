public without sharing class ET_WorkforceCalDetailsController {
    @AuraEnabled
    public static ETWorkforceCalcDetailsWrapper ET_getWorkforceCalcDetails(String quoteId,String quoteItemType){
        System.debug('quoteId-->'+quoteId);
        ETWorkforceCalcDetailsWrapper wrap=new ETWorkforceCalcDetailsWrapper();
        List<Quote> quoteList =[Select id,Is_Target_Price_Required__c, ET_Type__c From Quote Where Id=:quoteId];
        if(quoteList!=null && quoteList.size()>0){
            wrap.isTargetPriceRequired=quoteList[0].Is_Target_Price_Required__c;
            wrap.quoteType=quoteList[0].ET_Type__c;
        }
        List<ET_Workforce_Quote_Item__c> quoteItemList = new List<ET_Workforce_Quote_Item__c>();
        quoteItemList  = ET_PricingUtilityClass.getWorkforceQuoteItemLst(quoteId, quoteItemType);
        wrap.lstQuoteCalcDetails.addAll( quoteItemList);
        string appovalDetails;
        system.debug('appovalDetails1 = '+ json.serializePretty(appovalDetails));
        for(ET_Workforce_Quote_Item__c quoteItem :  quoteItemList){
            if((appovalDetails=='' || appovalDetails==null) && quoteItem.Approval_Details__c!=null && quoteItem.Approval_Details__c!=''){
                appovalDetails=quoteItem.Approval_Details__c;
                break;
            }
        }
        system.debug('appovalDetails2 = '+ json.serializePretty(appovalDetails));
        if(appovalDetails!=null && appovalDetails!=''){
            list<wrokforceApprovalDetails> ApprovalDetailsWrp=new list<wrokforceApprovalDetails>();
            for(string yearDetails:appovalDetails.split(';')){
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
                            ApprovalDetailsWrp.add(wrp);
                        }
                    }
                }
            }
            if(ApprovalDetailsWrp != null && !ApprovalDetailsWrp.isempty() ){
                wrap.wrokforceApprovalDetailsWrp = ApprovalDetailsWrp;
            }
            system.debug('ApprovalDetailsWrp = '+ json.serializePretty(ApprovalDetailsWrp));
        }
        wrap.noOfLines=(integer)[select count_distinct(ET_Workforce_Line_Number__c) noofLines 
                                 from ET_Workforce_Quote_Item__c   where   ET_Workforce_Quote_Item_Type__c=:quoteItemType and Quote__c=:quoteId][0].get('noofLines'); 
        system.debug('wrap = '+ json.serializePretty(wrap));
        return wrap;
    }
    @AuraEnabled
    public static Map<integer, ETAllWorkforceCalcDetailsWpr> ET_getAllWorkforceCalcDetails(String quoteId){
        System.debug('quoteId-->'+quoteId);
        Map<integer, ETAllWorkforceCalcDetailsWpr> allDetailsVsLineNumber = new Map<integer, ETAllWorkforceCalcDetailsWpr>();
        Map<String, ET_Vehicle_Quote_Item__c> vehicleQuoteItemMap = new Map<String, ET_Vehicle_Quote_Item__c>();
        List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLst = ET_PricingUtilityClass.getVehicleQuoteItemLst(quoteId);
        if(vehicleQuoteItemLst != null && !vehicleQuoteItemLst.isEmpty()){
            for(ET_Vehicle_Quote_Item__c vQuoteItem : vehicleQuoteItemLst){
                String key = vQuoteItem.ET_Vehicle_Unique_key__c+'=>'+vQuoteItem.ET_Line_Number__c ;
                if(!vehicleQuoteItemMap.containsKey(key)){
                    vehicleQuoteItemMap.put(key, vQuoteItem);
                }
            }
        }
        
        list<quote> retQuote = new list<quote>([select id,QuoteNumber,GL_Zone__c,Account.Name,Account.ETSALES_Profile_Class__c,Opportunity.Type,
                                                ET_Total_Investment__c,CreatedBy.Name,Total_Number_of_Vehicles__c,
                                                ET_Type__c
                                                FROM quote
                                                where id =:quoteId]);
        // get no Of lines in combinations and return line numbers...
        Map<String, List<String>> combinationMap = ET_VehicleCalcDetailsController.getCombinationServicesMap(quoteId);
        system.debug('combinationMap  = ' + JSON.serializePretty(combinationMap));
        integer lineNumber =0 ;
        integer totalNumberOfVehicles = 0;
        List<integer> lineNumbers = new list<integer>();
        if(combinationMap != null && !combinationMap.isEmpty()){
                for(String vehKey :combinationMap.keySet() ){
                    lineNumber++;
                    lineNumbers.add(lineNumber);
                    ETAllWorkforceCalcDetailsWpr wrap=new ETAllWorkforceCalcDetailsWpr();
                    if(combinationMap.containsKey(vehKey)){
                        if(vehKey != null && !vehKey.contains('no vehicle')){
                            wrap.showVehicleCalcDetails = true;
                            wrap.showFinanceCalcDetails = true;
                        }
                        System.debug('-=-=--=>>>'+vehicleQuoteItemMap);
                        System.debug('-=-=--=>>>'+vehKey);
                        System.debug('-=-=--=>>>'+vehicleQuoteItemMap.containsKey(vehKey));
                        System.debug('-=-=--=>>>'+vehKey.contains('no vehicle'));
                        if(vehicleQuoteItemMap != null && vehicleQuoteItemMap.containsKey(vehKey)){
                            ET_Vehicle_Quote_Item__c vQuoteItem = vehicleQuoteItemMap.get(vehKey);
                            if(vQuoteItem != null && vQuoteItem.ET_Vehicle_Source__c == 'Substitutional'){
                                 wrap.showFinanceCalcDetails = false;
                            }
                            if(vQuoteItem != null && vQuoteItem.ET_Fleet_Type__c == 'Client Fleet'){
                                 wrap.showFinanceCalcDetails = false;
                            }
                        }
                        List<String> vehCombinations = combinationMap.get(vehKey);
                        if(vehCombinations != null && !vehCombinations.isEmpty()){
                            for(String comb : vehCombinations ){
                                    if(comb == 'Supervisor'){
                                        wrap.showSupervisorCalcDetails = true;
                                    }
                                    else if(comb == 'Nanny'){
                                        wrap.showNannyCalcDetails = true;
                                    }
                                    else if(comb == 'Driver'){
                                        wrap.showDriverCalcDetails = true;
                                    }
                                    else if(comb == 'Coordinator'){
                                        wrap.showCoordinatorCalcDetails = true;
                                    }
                                    else if(comb == 'Accountant'){
                                        wrap.showAccountantCalcDetails = true;
                                    }
                                    else if(comb == 'other employee'){
                                        wrap.showOtherEmpCalcDetails = true;
                                    }
                            }
                        }
                        quoteHeader headerInfo=new quoteHeader();
                        if(vehicleQuoteItemLst != null && !vehicleQuoteItemLst.isEmpty()){
                            for(ET_Vehicle_Quote_Item__c vehicleQuoteItem :  vehicleQuoteItemLst){
                                if(vehicleQuoteItem.ET_Vehicle_Unique_key__c==vehKey.split('=>')[0] && vehicleQuoteItem.ET_Line_Number__c==decimal.valueOf(vehKey.split('=>')[1])){
                                    headerInfo.quoteNumber = vehicleQuoteItem.Quote__r.QuoteNumber;
                                    headerInfo.zone= vehicleQuoteItem.Quote__r.GL_Zone__c;
                                    headerInfo.clientName = vehicleQuoteItem.Quote__r.Account.Name;
                                    headerInfo.clientType = vehicleQuoteItem.Quote__r.Account.ETSALES_Profile_Class__c;
                                    headerInfo.contractType = vehicleQuoteItem.Quote__r.Opportunity.Type;
                                    headerInfo.totalInvestmentValue = vehicleQuoteItem.Quote__r.ET_Total_Investment__c;
                                    headerInfo.serviceEmirate= vehicleQuoteItem.ET_Service_Emirate__c;
                                    headerInfo.fleetType= vehicleQuoteItem.ET_Fleet_Type__c;
                                    if(vehicleQuoteItem.ET_Vehicle_Source__c == 'Main'){
                                        totalNumberOfVehicles += integer.valueOf(vehicleQuoteItem.ET_Number_of_Vehicles__c);
                                    }
                                    headerInfo.lineNo = integer.valueOf(vehicleQuoteItem.ET_Line_Number__c);
                                    headerInfo.requestor = vehicleQuoteItem.Quote__r.CreatedBy.Name;
                                    break;
                                }
                            }  
                        }
                        else{
                            if(retQuote != null && !retQuote.isEmpty()){
                                headerInfo.quoteNumber = retQuote[0].QuoteNumber;
                                headerInfo.zone= retQuote[0].GL_Zone__c;
                                headerInfo.clientName = retQuote[0].Account.Name;
                                headerInfo.clientType = retQuote[0].Account.ETSALES_Profile_Class__c;
                                headerInfo.contractType = retQuote[0].Opportunity.Type;
                                headerInfo.totalInvestmentValue = retQuote[0].ET_Total_Investment__c;
                                headerInfo.requestor = retQuote[0].CreatedBy.Name;
                            }
                        }
                        
                        if(retQuote != null && !retQuote.isEmpty() && retQuote[0].ET_Type__c == 'Total Project Summary' ){
                            headerInfo.quoteNumber = retQuote[0].QuoteNumber;
                            headerInfo.zone= retQuote[0].GL_Zone__c;
                            headerInfo.clientName = retQuote[0].Account.Name;
                            headerInfo.clientType = retQuote[0].Account.ETSALES_Profile_Class__c;
                            headerInfo.contractType = retQuote[0].Opportunity.Type;
                            headerInfo.totalInvestmentValue = retQuote[0].ET_Total_Investment__c;
                            headerInfo.requestor = retQuote[0].CreatedBy.Name;
                            if(retQuote[0].Total_Number_of_Vehicles__c != null){
                               headerInfo.totalNoOfVehicles = integer.ValueOf(retQuote[0].Total_Number_of_Vehicles__c); 
                            }
                            
                        }
                        
                        wrap.quoteHeaderInfo = headerInfo;
                        
                    }
                    allDetailsVsLineNumber.put(lineNumber , wrap);
                }
            
        }
        if(allDetailsVsLineNumber != null && !allDetailsVsLineNumber.isEmpty()){
            
            ETAllWorkforceCalcDetailsWpr wrapp = allDetailsVsLineNumber.get(1);
            
            List<Quote> quoteList =[Select id,Is_Target_Price_Required__c, ET_Type__c From Quote Where Id=:quoteId];
            if(quoteList!=null && quoteList.size()>0){
                wrapp.quoteType=quoteList[0].ET_Type__c;
            }
            if(retQuote != null && retQuote[0].ET_Type__c == 'Total Project Summary'){
                List<integer> lineNumbersForTproj = new List<integer>{1};
                    wrapp.lineNumbers = lineNumbersForTproj;
            }
            else{
                wrapp.lineNumbers = lineNumbers;
            }
            
            wrapp.quoteHeaderInfo.totalNoOfVehicles = totalNumberOfVehicles;
            if(wrapp.lineNumbers != null && !wrapp.lineNumbers.isEmpty()){
                wrapp.quoteHeaderInfo.totalLines = wrapp.lineNumbers.size();
            }
            allDetailsVsLineNumber.put(1, wrapp);
            
        }
        system.debug('allDetailsVsLineNumber  = ' + JSON.serializePretty(allDetailsVsLineNumber));
        return allDetailsVsLineNumber;
    }
    public class ETWorkforceCalcDetailsWrapper{
        @AuraEnabled
        public Boolean isTargetPriceRequired;
        @AuraEnabled
        public String quoteType;
        @AuraEnabled
        public  List<ET_Workforce_Quote_Item__c> lstQuoteCalcDetails=new List<ET_Workforce_Quote_Item__c>();
        @AuraEnabled
        public List<wrokforceApprovalDetails> wrokforceApprovalDetailsWrp;
        @AuraEnabled
        public integer noOfLines=0;    
    }
    public class wrokforceApprovalDetails{
        @AuraEnabled
        public string element;
        @AuraEnabled
        public string requestedBy;
        @AuraEnabled
        public string approvedby;
        @AuraEnabled
        public string reason;
        /*public vehicleApprovalDetails(string element,string requestedBy,string approvedby,string reason){
            this.element=element;
            this.requestedBy=requestedBy;
            this.approvedby=approvedby;
            this.reason=reason;
        }*/
    }
    
    public class ETAllWorkforceCalcDetailsWpr{
        @AuraEnabled
        public Boolean showDriverCalcDetails = false;
        @AuraEnabled
        public Boolean showFinanceCalcDetails = false;
        @AuraEnabled
        public Boolean showVehicleCalcDetails = false;
        @AuraEnabled
        public Boolean showNannyCalcDetails = false;
        @AuraEnabled
        public Boolean showSupervisorCalcDetails = false;
        @AuraEnabled
        public Boolean showCoordinatorCalcDetails = false;
        @AuraEnabled
        public Boolean showAccountantCalcDetails = false;
        @AuraEnabled
        public Boolean showOtherEmpCalcDetails = false;
        @AuraEnabled
        public Boolean showOtherCostCalcDetails = false;
        @AuraEnabled
        public String quoteType;
        @AuraEnabled
        public List<integer> lineNumbers;  
        @AuraEnabled
        public quoteHeader quoteHeaderInfo;
    }
    
    public class quoteHeader{
        @AuraEnabled
        public string zone;
        @AuraEnabled
        public string quoteNumber;
        @AuraEnabled
        public string clientName;
        @AuraEnabled
        public string clientType;
        @AuraEnabled
        public string clientCategory;
        @AuraEnabled
        public string clientStatus;
        @AuraEnabled
        public string contractType;
        @AuraEnabled
        public Decimal totalInvestmentValue;
        @AuraEnabled
        public string serviceEmirate;
        @AuraEnabled
        public string fleetType;
        @AuraEnabled
        public Integer lineNo;
        @AuraEnabled
        public Integer totalLines;
        @AuraEnabled
        public string requestor;
        @AuraEnabled
        public Integer totalNoOfVehicles;
    }
    
}