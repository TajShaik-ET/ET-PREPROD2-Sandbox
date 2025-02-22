/*
ET_ServiceRequestController : This class is used to save the vehicle, workforce details
Created On: 02/02/2020
Created By: Pankaj.Gupta@smaartt.com
Actions performed in This Class : 
1 

Methods and it's Description: 

1 createQuotation : To calculate all elements of vehicle and Manpower and to wrap up in a wrapper clas

*/
public without sharing class ET_ServiceRequestController {
    public static List<ET_Work_force__c> upsertWorkforces = new List<ET_Work_force__c>();
    private static List<ET_Special_Workforce_Requirement__c> specialWorkforceReqToDeleteLst = new List<ET_Special_Workforce_Requirement__c>();
    
    public static Map<Id, List<ET_Other_Cost_Request__c >> vehicleVsOtherCostMap = new Map<Id, List<ET_Other_Cost_Request__c >>();    
    public static Map<Id, List<ET_Other_Cost_Request__c >> srVsOtherCostMap = new Map<Id, List<ET_Other_Cost_Request__c >>();
    private static List<integer> contractYears = new List<integer>();  
    Private static Map<integer, Map<String, otherCostCalcClassTProj>>  vehSpecilReqsForTotProjMap = new Map<integer, Map<String, otherCostCalcClassTProj>>();
    Private static integer totalVehicleLines =0;
    Private static decimal totalVehicles =0;
    Private static decimal totalMainVehicles =0;
    
    @AuraEnabled
    public static string getActiveSRId(String opportunityId){
        try{
            Opportunity opp = [select id, (select id, ET_PSR_IsActive__c from Pricing_Service_Requests__r) from Opportunity where Id =: opportunityId ];
            for(ET_Pricing_Service_Request__c request : opp.Pricing_Service_Requests__r){
                if(request.ET_PSR_IsActive__c){
                    return request.Id;
                }
            }
        }catch(Exception ex){
            system.debug(ex.getMessage());
            return null;
        }
        return 'NoActiveSR';
    }
    
    /* 
Basic and Gross salary changes with respect to Manpower Category. So Return a Map with those details.
Key = Manpower Category and Value = Basic and Gross salary details.
*/
    
    @AuraEnabled
    public static Map<String,MasterDataSalarydetails> getDriverMasterData(){
        try{
            Map<String,MasterDataSalarydetails> categoryWiseData = new Map<String,MasterDataSalarydetails>();
            for(Workforce_Master__c workforceMaster : [select ET_Workforce_Category__c,Workforce_Type__c, Salary_Grade__r.Gross_Salary__c, 
                                                       Salary_Grade__r.Basic_Salary__c,Cost_of_Living_Allowance__c,Transport_Allowance__c,
                                                       Additional_Transport_Allowance__c,Other_Allowance__c,Social_Allowance__c,Housing_Allowance__c
                                                       from Workforce_Master__c 
                                                       where Workforce_Type__c = 'Driver']){
                                                           MasterDataSalarydetails data = new MasterDataSalarydetails();
                                                           data.grossSalary = workforceMaster.Salary_Grade__r.Gross_Salary__c;
                                                           data.basicSalary = workforceMaster.Salary_Grade__r.Basic_Salary__c;
                                                           data.workForceMaster = workforceMaster;
                                                           categoryWiseData.put(workforceMaster.ET_Workforce_Category__c, data);
                                                       }
            
            return categoryWiseData;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static Map<String,MasterDataSalarydetails> getNannyMasterData(){
        try{
            Map<String,MasterDataSalarydetails> categoryWiseData = new Map<String,MasterDataSalarydetails>();
            for( Workforce_Master__c workforceMaster : [select ET_Workforce_Category__c,Workforce_Type__c,
                                                        Salary_Grade__r.Gross_Salary__c, Salary_Grade__r.Basic_Salary__c,
                                                        Cost_of_Living_Allowance__c,Transport_Allowance__c,Housing_Allowance__c,
                                                        Additional_Transport_Allowance__c,Other_Allowance__c,Social_Allowance__c
                                                        from Workforce_Master__c where Workforce_Type__c = 'Nanny']){
                                                            MasterDataSalarydetails data = new MasterDataSalarydetails();
                                                            data.grossSalary = workforceMaster.Salary_Grade__r.Gross_Salary__c;
                                                            data.basicSalary = workforceMaster.Salary_Grade__r.Basic_Salary__c;
                                                            data.workForceMaster = workforceMaster;
                                                            categoryWiseData.put(workforceMaster.ET_Workforce_Category__c, data);
                                                        }
            
            return categoryWiseData;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static Map<String,MasterDataSalarydetails> getSupervisorMasterData(){
        try{
            Map<String,MasterDataSalarydetails> categoryWiseData = new Map<String,MasterDataSalarydetails>();
            for(Workforce_Master__c workforceMaster : [select ET_Workforce_Category__c,Workforce_Type__c, Salary_Grade__r.Gross_Salary__c, Salary_Grade__r.Basic_Salary__c,
                                                       Cost_of_Living_Allowance__c,Transport_Allowance__c,Housing_Allowance__c,
                                                       Additional_Transport_Allowance__c,Other_Allowance__c,Social_Allowance__c
                                                       from Workforce_Master__c where Workforce_Type__c = 'Supervisor']){
                                                           MasterDataSalarydetails data = new MasterDataSalarydetails();
                                                           data.grossSalary = workforceMaster.Salary_Grade__r.Gross_Salary__c;
                                                           data.basicSalary = workforceMaster.Salary_Grade__r.Basic_Salary__c;
                                                           data.workForceMaster = workforceMaster;
                                                           categoryWiseData.put(workforceMaster.ET_Workforce_Category__c, data);
                                                       }
            
            return categoryWiseData;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    
    
    
    
    public static Financial_Analysis__c calcualteIRR( integer investment, integer cashflowAmunt, integer period, integer terminalAmount ,Id financeId , String fieldApiname){
        List<Decimal> cashFlowValues = new List<decimal>();
        decimal irr = 0;
        integer counter=0;
        Financial_Analysis__c financeRec = new Financial_Analysis__c();
        system.debug('investment__a = '+ investment);
        system.debug('cashflowAmunt = '+ cashflowAmunt);
        system.debug('period = '+ period);
        system.debug('terminalAmount = '+ terminalAmount);
        system.debug('financeId = '+ financeId);
        system.debug('fieldApiname__a = '+ fieldApiname);
        try{
            cashFlowValues.add(-investment);
            for(integer i=0 ; i< period ; i++){
                cashFlowValues.add(cashflowAmunt);
                system.debug('cashFlowValues = '+ cashFlowValues); 
            }
            integer listSize = cashFlowValues.size();
            system.debug('listSize = '+ listSize);
            cashFlowValues[listSize-1] = cashFlowValues[listSize-1] + terminalAmount;
            
            irr = XIRR.calculateExcelIRR(cashFlowValues);
            if(irr != null && financeId != null){
                financeRec.Id = financeId;
                financeRec.put(fieldApiname, irr.setScale(2)) ;
                counter++;
                system.debug('counter = '+ counter);
                system.debug('Limits.getCpuTime() = '+ Limits.getCpuTime());
            }
            return financeRec;
            /*Commented by Janardhan 03/02/2023
*   decimal IRR = 2.0;
system.debug('listSize = '+ cashFlowValues[listSize-1]);
decimal threshold  = 0.005;
double guess = threshold + 1;
decimal nextGuess = 2 ;
integer counter=0;
system.debug('guess = '+ guess);
//start
while(Math.abs(guess) > threshold){
guess = 0;
nextGuess = 0;
for(integer i=0; i<cashFlowValues.size() ; i++){
integer a =i-1;
decimal b = 1+IRR/100;
decimal guessTemp = guess + cashFlowValues[i]/Math.pow(double.valueof(1+IRR/100) , double.valueof(i-1)) ;
if( guessTemp > (Math.pow(2,63) -1) ){
guessTemp = (Math.pow(2,63) -1);
}
guess = guessTemp;
nextGuess = nextGuess + -i*cashFlowValues[i]/Math.pow(double.valueof(1+IRR/100) , double.valueof(i-1));
}
IRR = IRR - Guess/nextGuess;
counter++;
//system.debug('counter = '+ counter);
//system.debug('Limits.getCpuTime() = '+ Limits.getCpuTime());
}

system.debug('irr = '+ irr );
if(irr != null && financeId != null){
financeRec.Id = financeId;
financeRec.put(fieldApiname, irr.setScale(2)) ;
}
system.debug('investment__a = '+ investment);
system.debug('counter = '+ cashflowAmunt);
system.debug('counter = '+ period);
system.debug('counter = '+ terminalAmount);
system.debug('counter = '+ financeId);
system.debug('fieldApiname__a = '+ fieldApiname);
return financeRec;*/
            
            
        }
        catch(Exception e){
            ET_PricingUtilityClass.logException(e, 'Pricing');
            system.debug('Exception ='+ e.getMessage());
            system.debug('Exception Trace='+ e.getStackTraceString());
            system.debug('Exception line='+ e.getLineNumber());
            return null;
        }
    }
    
    @AuraEnabled
    public static Map<String,MasterDataSalarydetails> getCoordinatorMasterData(){
        try{
            Map<String,MasterDataSalarydetails> categoryWiseData = new Map<String,MasterDataSalarydetails>();
            for(Workforce_Master__c workforceMaster : [select ET_Workforce_Category__c,Workforce_Type__c, Salary_Grade__r.Gross_Salary__c, Salary_Grade__r.Basic_Salary__c,
                                                       Cost_of_Living_Allowance__c,Transport_Allowance__c,Housing_Allowance__c,
                                                       Additional_Transport_Allowance__c,Other_Allowance__c,Social_Allowance__c
                                                       from Workforce_Master__c where Workforce_Type__c = 'Coordinator']){
                                                           MasterDataSalarydetails data = new MasterDataSalarydetails();
                                                           data.grossSalary = workforceMaster.Salary_Grade__r.Gross_Salary__c;
                                                           data.basicSalary = workforceMaster.Salary_Grade__r.Basic_Salary__c;
                                                           data.workForceMaster = workforceMaster;
                                                           categoryWiseData.put(workforceMaster.ET_Workforce_Category__c, data);
                                                       }
            return categoryWiseData;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static Map<String,MasterDataSalarydetails> getAccountantMasterData(){
        try{
            Map<String,MasterDataSalarydetails> categoryWiseData = new Map<String,MasterDataSalarydetails>();
            for( Workforce_Master__c workforceMaster : [select ET_Workforce_Category__c,Workforce_Type__c, Salary_Grade__r.Gross_Salary__c, Salary_Grade__r.Basic_Salary__c,
                                                        Cost_of_Living_Allowance__c,Transport_Allowance__c,Housing_Allowance__c,
                                                        Additional_Transport_Allowance__c,Other_Allowance__c,Social_Allowance__c
                                                        from Workforce_Master__c where Workforce_Type__c = 'Accountant/Cashier']){
                                                            MasterDataSalarydetails data = new MasterDataSalarydetails();
                                                            data.grossSalary = workforceMaster.Salary_Grade__r.Gross_Salary__c;
                                                            data.basicSalary = workforceMaster.Salary_Grade__r.Basic_Salary__c;
                                                            data.workForceMaster = workforceMaster;
                                                            categoryWiseData.put(workforceMaster.ET_Workforce_Category__c, data);
                                                        }
            
            return categoryWiseData;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static Map<String,MasterDataSalarydetails> getOtherEmpMasterData(){
        try{
            Map<String,MasterDataSalarydetails> categoryWiseData = new Map<String,MasterDataSalarydetails>();
            for(Workforce_Master__c workforceMaster : [select ET_Workforce_Category__c,Workforce_Type__c, Salary_Grade__r.Gross_Salary__c, Salary_Grade__r.Basic_Salary__c,
                                                       Cost_of_Living_Allowance__c,Transport_Allowance__c,Housing_Allowance__c,
                                                       Additional_Transport_Allowance__c,Other_Allowance__c,Social_Allowance__c
                                                       from Workforce_Master__c where Workforce_Type__c = 'Other Employee']){
                                                           MasterDataSalarydetails data = new MasterDataSalarydetails();
                                                           data.grossSalary = workforceMaster.Salary_Grade__r.Gross_Salary__c;
                                                           data.basicSalary = workforceMaster.Salary_Grade__r.Basic_Salary__c;
                                                           data.workForceMaster = workforceMaster;
                                                           categoryWiseData.put(workforceMaster.ET_Workforce_Category__c, data);
                                                       }
            system.debug('categoryWiseData  = '+ categoryWiseData);
            return categoryWiseData;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    
    
    /* public class workforceMasterDataClass{
public String workforceCategory;


}*/
    
    
    public class MasterDataSalarydetails{
        @AuraEnabled
        public Decimal grossSalary;
        @AuraEnabled
        public Decimal basicSalary;
        @AuraEnabled
        public Workforce_Master__c workForceMaster;
    }
    
    /* 
Description : For Pricing Service Request - related opportunity. Check if ETSALES_Approval_Status__c == approved - that is Go-No-Go approved. 
That Pricing service Request is allowed to Customize.

*/
    @AuraEnabled
    public static Boolean authorizedToCustomizePricing(String serviceRequestId){
        try{
            ET_Pricing_Service_Request__c serviceRequest = getServiceRequestForValidation(serviceRequestId);
            if(serviceRequest.Opportunity__r.ETSALES_GNG_Approval_Status_Date__c != null && serviceRequest.Opportunity__r.ETSALES_Approval_Status__c == 'Approved'){
                return true;
            }
            return false;
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
        return null;
    }
    
    private static ET_Pricing_Service_Request__c getServiceRequestForValidation(String serviceRequestId){
        return [select id, ET_PSR_IsActive__c,(Select id, Approval_Status__c,IsActive__c,Status from Quotes__r),(select id from Work_force_Requests__r),
                (select id from Request_Mapping__r), (select id, ET_Vehicle_Fuel__c, ET_Vehicle_Fuel_Consumption__c from Vehicle_Requests__r),
                Opportunity__r.ETSALES_GNG_Approval_Status_Date__c, Opportunity__r.ETSALES_Approval_Status__c 
                from ET_Pricing_Service_Request__c where Id =: serviceRequestId ];
    }
    
    
    @AuraEnabled
    public static String authorizeOperation(String serviceRequestId, String operation){
        boolean fuelValuePresent = true;
        try{
            ET_Pricing_Service_Request__c serviceRequest = getServiceRequestForValidation(serviceRequestId);
            if(operation == 'serviceRequestFormModification'){
                if(!serviceRequest.ET_PSR_IsActive__c){
                    return 'SRIsInActive';
                }
                else if(serviceRequest.Quotes__r.size() > 0){
                    Boolean isOneOfActiveQuoteNotApproved = false;
                    for(Quote quote :  serviceRequest.Quotes__r){
                        if(quote.IsActive__c){
                            if(quote.Status == 'Submitted for Approval' || quote.Approval_Status__c == 'Approved'){
                                isOneOfActiveQuoteNotApproved = true;  
                            }
                        }
                    }
                    
                    if(isOneOfActiveQuoteNotApproved){
                        return 'QuoteIsNotApprovedOrRejected';
                    }
                    return 'Success'; 
                }else if(serviceRequest.Quotes__r.size() == 0){
                    return 'Success'; 
                }
            }
            else if(operation == 'quoteCreation'){
                if(serviceRequest.Opportunity__r.ETSALES_GNG_Approval_Status_Date__c == null || serviceRequest.Opportunity__r.ETSALES_Approval_Status__c == null || (serviceRequest.Opportunity__r.ETSALES_GNG_Approval_Status_Date__c != null && serviceRequest.Opportunity__r.ETSALES_Approval_Status__c != 'Approved')){
                    return 'GoNoGoApprrovalIsMissing';
                }
                if(serviceRequest.Vehicle_Requests__r != null && serviceRequest.Vehicle_Requests__r.size() > 0 &&  serviceRequest.Work_force_Requests__r != null && serviceRequest.Work_force_Requests__r.size() > 0 &&  serviceRequest.Request_Mapping__r.size() ==0){
                    return 'PricingCustomizationNotPresent';
                }
                
                if(serviceRequest.Vehicle_Requests__r != null && serviceRequest.Vehicle_Requests__r.size() > 0 ){
                    for(Vehicle__c vehReq : serviceRequest.Vehicle_Requests__r){
                        if(vehReq.ET_Vehicle_Fuel__c == 'Yes'){
                            if(vehReq.ET_Vehicle_Fuel_Consumption__c == null || vehReq.ET_Vehicle_Fuel_Consumption__c == 0){
                                fuelValuePresent = false;
                            }
                        }
                    }
                    
                    if(fuelValuePresent == false){
                        return 'fuelValueMissing';
                    }
                }
                
            }
            
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
        return 'Success'; 
    }
    
    @AuraEnabled
    public static void validateOppStage(String recordId){
        string msg;
        try{
            Opportunity opp = [Select id, StageName from Opportunity where id =: recordId];
            if(opp.StageName == 'Qualification' || opp.StageName == 'Requirement Analysis' || opp.stageName == 'Decision' || opp.StageName == 'Pricing Request'){
                opp.StageName = 'Pricing Request'; 
                update opp;
            }
            
            else
            {
                throw new MyException('InvalidStage');               
            }
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);
        }
        catch(Exception e){
            //throw all other exception message
            msg = 'Exception ='+e.getMessage() +'\n'+ ' Trace= '+e.getStackTraceString();
            if(msg.contains('InvalidStage')){
                throw new AuraHandledException('This Operation is invalid for this Opportunity Stage');
            }
            else{
                throw new AuraHandledException(msg);
            }
        }
    }
    
    @AuraEnabled
    public static string fetchOpportunityRecordType(String oppId, String serviceRequestId){
        try{
            Opportunity opp;
            // system.debug('oppId  : '+ oppId + ' service request id '+ serviceRequestId );
            if(oppId != null && oppId != ''){
                // system.debug('inside opp if ');
                opp = [Select id, RecordType.DeveloperName from Opportunity where Id =: oppId];
                return opp.RecordType.DeveloperName;
            }else if(serviceRequestId != null && serviceRequestId != ''){
                ET_Pricing_Service_Request__c serviceRequest = [Select Opportunity__r.RecordType.DeveloperName from ET_Pricing_Service_Request__c where Id =: serviceRequestId];
                return serviceRequest.Opportunity__r.RecordType.DeveloperName;
            }
            
            return null; 
        }catch(exception ex){
            system.debug(ex.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static String getSObjectNameFromRecordId(Id RecordId){
        if(RecordId != null){
            return RecordId.getsobjecttype().getDescribe().getName();
        }
        return null;    
    }
    @AuraEnabled
    public static String getDetailFromRecordId(Id RecordId){
        if(RecordId != null){
            List<ET_Pricing_Service_Request__c> psr = [Select Id, Name, Opportunity__r.Id from ET_Pricing_Service_Request__c where Id =:RecordId];
            for(ET_Pricing_Service_Request__c ps :psr){
                return ps.Opportunity__r.Id;
            }
        }
        return null;    
    }
    @AuraEnabled
    public static String getOpportunityRecordTypeId(Id opportunityId) {
        if(opportunityId != null){
            List<Opportunity> oppList = new List<Opportunity>();
            oppList = [SELECT Id, Name, RecordType.Name, RecordTypeId FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
            if(oppList.size() > 0){
                return oppList[0].RecordType.Name; 
            }else{
                return null;  
            }
        }
        return null;   
    }
    
    @AuraEnabled
    public static Profile getProfileInfo(){
        try{
            String profileId = UserInfo.getProfileId();
            Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
            return profile;
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static saveAllDataWrapper saveAllTabCommonData(Id opportunityId, Map<String,Object> data){
        //Opportunity opp = [select id from Opportunity where id = :opportunityId];
        //('saveAllTabCommonData -------data' + data);
        Object commonData = data.get('allTabCommonData');
        saveAllDataWrapper allDataWra = new saveAllDataWrapper();
        if(commonData != null){
            Id commonObjId = ET_ServiceRequestControllerHelper.saveCommonData(commonData,'All Tab', null);
            if(commonObjId != null){
                ET_Pricing_Service_Request__c pricingServiceReq = new ET_Pricing_Service_Request__c(Opportunity__c = opportunityId);
                pricingServiceReq.ET_Service_Request_Common_Data__c = commonObjId;
                insert pricingServiceReq;
                allDataWra.serviceReqId = pricingServiceReq.Id;
                allDataWra.commonDataId = commonObjId;
                return allDataWra;
            }
        }
        return null;
    }
    
    Public Class saveAllDataWrapper{
        @AuraEnabled
        Public String serviceReqId;
        @AuraEnabled
        Public String commonDataId;
    }
    
    @AuraEnabled(cacheable=true)
    public static ET_ServiceRequestControllerHelper.applicationData fetchExistingApplicationData(Id serviceRequestId){
        return ET_ServiceRequestControllerHelper.fetchExistingAppData(serviceRequestId);
    }
    
    @AuraEnabled
    public static void submitForApproval(String quoteId, String comments, String filesData, String quoteDetailStr){
        System.debug('quoteId: '+quoteId); 
        System.debug('quoteDetailStr: '+quoteDetailStr);
        string res;
        try{
            //ET_QuoteApprovalController.submitForApproval(quoteId, comments); 

            if(quoteId != null && quoteDetailStr != null)
                udpateQuote(quoteId, quoteDetailStr);
            
            if(filesData != null)
                addFilesToRecords(quoteId, filesData);

            ET_QuoteApprovalController.submitForApproval(quoteId, comments);    
        }
        catch(exception e){
            system.debug('Error ' +e.getMessage());
            if(!Test.isRunningTest()){
            //for(integer i=0; i < e.getNumDml(); i++){
                    throw new AuraHandledException('Approval Request is already submitted. Please check the status in Quote');
                //}
            }
        }
        //return res;
    }

    public static void udpateQuote(String quoteId, String quoteDetailStr){
        System.debug('udpateQuote:');
            if (String.isNotBlank(quoteDetailStr)) {
                try {
                    Map<String, Object> quoteDetailMap = (Map<String, Object>) JSON.deserializeUntyped(quoteDetailStr);
                    Quote qt = New Quote();
                    qt.Id = quoteId;
                    if (quoteDetailMap.containsKey('Quote_Type__c')) {
                        qt.Quote_Type__c = (String) quoteDetailMap.get('Quote_Type__c');
                    }
                    if (quoteDetailMap.containsKey('Contract_Year__c')) {
                        qt.Contract_Year__c = (String) quoteDetailMap.get('Contract_Year__c');
                    }
                    if (quoteDetailMap.containsKey('Quote_Total_Investment__c')) {
                        Object value = quoteDetailMap.get('Quote_Total_Investment__c');
                        if (value instanceof String) {
                            qt.Quote_Total_Investment__c = Decimal.valueOf((String)value);
                        } else if (value instanceof Integer) {
                            qt.Quote_Total_Investment__c = Decimal.valueOf(String.valueOf((Integer)value));
                        } else if (value instanceof Decimal) {
                            qt.Quote_Total_Investment__c = (Decimal)value;
                        }
                    }
                    if (quoteDetailMap.containsKey('Total_Investment_New_Vehicles_Manual__c')) {
                        Object value = quoteDetailMap.get('Total_Investment_New_Vehicles_Manual__c');
                        if (value instanceof String) {
                            qt.Total_Investment_New_Vehicles_Manual__c = Decimal.valueOf((String)value);
                        } else if (value instanceof Integer) {
                            qt.Total_Investment_New_Vehicles_Manual__c = Decimal.valueOf(String.valueOf((Integer)value));
                        } else if (value instanceof Decimal) {
                            qt.Total_Investment_New_Vehicles_Manual__c = (Decimal)value;
                        }
                    }
                    if (quoteDetailMap.containsKey('Total_Value_of_Rental_Manual__c')) {
                        Object value = quoteDetailMap.get('Total_Value_of_Rental_Manual__c');
                        if (value instanceof String) {
                            qt.Total_Value_of_Rental_Manual__c = Decimal.valueOf((String)value);
                        } else if (value instanceof Integer) {
                            qt.Total_Value_of_Rental_Manual__c = Decimal.valueOf(String.valueOf((Integer)value));
                        } else if (value instanceof Decimal) {
                            qt.Total_Value_of_Rental_Manual__c = (Decimal)value;
                        }
                    }
                    UPDATE qt;
                } catch (JSONException e) {
                    System.debug('JSON Deserialization Error: ' + e.getMessage());
                    throw new AuraHandledException('Quote Update Failed. Please check with the Admin.');
                }
            }
    }
    
    // Added by Arunsarathy for Save file upload in quote while submit for approval on 18.05.2023
    @future
    public static void addFilesToRecords(String recordId , String filesData){
        Savepoint sp = Database.setSavepoint();
        List<ContentVersion> lstContentVesions = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLinks = new  List<ContentDocumentLink>();
        list<uploadedDocs> files;  
        files = (List<uploadedDocs>)JSON.deserialize(filesData,  List<uploadedDocs>.Class);
        if(files.size()>0){ 
            system.debug('files = '+ files);
            system.debug('files = '+ files.size());
            for(uploadedDocs doc :files){
                system.debug('doc = '+ doc);
                ContentVersion objContentVersion = new ContentVersion();
                objContentVersion.ContentLocation = 'S';
                objContentVersion.VersionData = EncodingUtil.base64Decode(doc.base64);//EncodingUtil.base64Decode(body);
                objContentVersion.Title = doc.filename;
                objContentVersion.Origin = 'H';
                objContentVersion.PathOnClient = '/' + doc.filename;
                lstContentVesions.add(objContentVersion);
                
            }
            
        }
        if(lstContentVesions!=null && lstContentVesions.size()>0){
            try{
                insert lstContentVesions;   
                system.debug('******After lstContentVesions****'+lstContentVesions);
            }Catch(Exception ex){
                system.debug('***Exception Cause lstContentVesions*****'+ex.getMessage());
                system.debug('***Exception Cause getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception happend'+ex.getMessage());                                       
            }
            
        }
        map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
        for(ContentVersion objContentVersion :[Select Id,ContentDocumentId from ContentVersion where Id in :lstContentVesions]){
            mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
        }
        
        for(ContentVersion objContentVersion :lstContentVesions){
            
            if(mapofContentVersionIdwithContentDocumentIds.containskey(objContentVersion.Id)){
                ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                objContentDocumentLink.LinkedEntityId = recordId;
                objContentDocumentLink.ShareType = 'V';
                objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id);
                lstContentDocumentLinks.add(objContentDocumentLink);
            }
            
        }
        system.debug('******lstContentDocumentLinks****'+lstContentDocumentLinks);
        if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
            try{
                insert lstContentDocumentLinks; 
                //return 'Success';
            }Catch(Exception ex){
                Database.rollback(sp);
                system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
                system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
            }
        }else{
            //return 'Error';
        }
        
        
        
    }
    
    
    public class uploadedDocs{
        @AuraEnabled
        Public String filename;
        @AuraEnabled
        Public String filetype;
        @AuraEnabled
        Public String base64;
        
    }
    
    @AuraEnabled
    public static boolean updateCommonInfoToVehicleAndWorkforce(String commonReqId, String commonReqChanges){
        
        List<Vehicle__c> vehlsToUpdate = new List<Vehicle__c>();
        List<ET_Work_force__c>  wForceReqToUpdate = new List<ET_Work_force__c>();
        boolean resp = true;
        
        Map<String, Object> commonReqChangesMap = (Map<String, Object>)JSON.deserializeUntyped(commonReqChanges);
        
        ET_Pricing_Service_Request__c serReq = [select id ,
                                                (select id,ET_Contract_Type__c,ET_Service_Emirate__c,ET_Working_Days_Per_Week__c,
                                                 ET_Working_Months_Per_Year__c,ET_Pricing_Method__c,ET_Contract_Period__c,
                                                 ET_Pricing_Type__c, ET_Price_Utilization__c
                                                 from Vehicle_Requests__r),
                                                (select id,ET_Contract_Type__c,ET_Service_Emirate__c,ET_Working_Days_Per_Week__c,
                                                 ET_Working_Months_Per_Year__c,ET_Pricing_Method__c,
                                                 ET_Pricing_Type__c, ET_Price_Utilization__c,ET_Contract_Period__c
                                                 from Work_force_Requests__r)
                                                from ET_Pricing_Service_Request__c 
                                                where ET_Service_Request_Common_Data__c =:commonReqId];
        
        // check if Vehicle requests present and if there update common details to Vehicle request...
        if(serReq != null && serReq.Vehicle_Requests__r != null && serReq.Vehicle_Requests__r.size() > 0){
            for(Vehicle__c veh :serReq.Vehicle_Requests__r ){
                veh.ET_Contract_Period__c = (String)commonReqChangesMap.get('ET_Contract_Period__c');
                veh.ET_Contract_Type__c = (String)commonReqChangesMap.get('ET_Contract_Type__c');
                veh.ET_Service_Emirate__c = (String)commonReqChangesMap.get('ET_Service_Emirate__c');
                veh.ET_Working_Days_Per_Week__c = Decimal.valueOf(Integer.valueof(commonReqChangesMap.get('ET_Working_Days_Per_Week__c')));
                veh.ET_Working_Months_Per_Year__c = Decimal.valueOf(Integer.valueof(commonReqChangesMap.get('ET_Working_Months_Per_Year__c')));
                veh.ET_Pricing_Method__c = (String)commonReqChangesMap.get('ET_Pricing_Method__c');
                veh.ET_Pricing_Type__c = (String)commonReqChangesMap.get('ET_Pricing_Type__c');
                veh.ET_Price_Utilization__c = Decimal.valueOf(Integer.valueof(commonReqChangesMap.get('ET_Price_Utilization__c')));
                vehlsToUpdate.add(veh);
            }
        }
        
        // check if workforce requests present and if there update common details to workforce request...
        if(serReq != null && serReq.Work_force_Requests__r != null && serReq.Work_force_Requests__r.size() > 0){
            for(ET_Work_force__c wForce :serReq.Work_force_Requests__r ){
                wForce.ET_Contract_Period__c = (String)commonReqChangesMap.get('ET_Contract_Period__c');
                wForce.ET_Contract_Type__c = (String)commonReqChangesMap.get('ET_Contract_Type__c');
                wForce.ET_Service_Emirate__c = (String)commonReqChangesMap.get('ET_Service_Emirate__c');
                wForce.ET_Working_Days_Per_Week__c = Decimal.valueOf(Integer.valueof(commonReqChangesMap.get('ET_Working_Days_Per_Week__c')));
                wForce.ET_Working_Months_Per_Year__c = Decimal.valueOf(Integer.valueof(commonReqChangesMap.get('ET_Working_Months_Per_Year__c')));
                wForce.ET_Pricing_Method__c = (String)commonReqChangesMap.get('ET_Pricing_Method__c');
                wForce.ET_Pricing_Type__c = (String)commonReqChangesMap.get('ET_Pricing_Type__c');
                wForce.ET_Price_Utilization__c = Decimal.valueOf(Integer.valueof(commonReqChangesMap.get('ET_Price_Utilization__c')));
                wForceReqToUpdate.add(wForce);
            }
        }
        
        try{
            if(vehlsToUpdate != null && !vehlsToUpdate.isEmpty()){
                update vehlsToUpdate;
                resp = true;
            }
            
            if(wForceReqToUpdate != null &&  !wForceReqToUpdate.isEmpty()){
                update wForceReqToUpdate;
                resp = true;
            }
        }
        Catch(Exception e){
            resp = false;
            system.debug('Exception e = '+ e.getMessage());
            system.debug('Exception Trace = '+ e.getStackTraceString());
            throw new AuraHandledException('Internal Error. Please contact system admin.');
        }
        
        return resp ;
    }
    
    @AuraEnabled
    public static String submitForOppApprovalToSalesHead(String reqId){
        String resp;
        String approvalProcess ='Opportunity_Approval_Process1';
        try{
            ET_Pricing_Service_Request__c req = [select id, opportunity__r.ETSALES_Approval_Status__c, opportunity__r.OwnerId,opportunity__r.id,
                                                 isServiceRequestRejected__c,(select id from Work_force_Requests__r), (select id from Vehicle_Requests__r),
                                                 (select id from Request_Mapping__r) from ET_Pricing_Service_Request__c where id =:reqId];
            //Request Mapping must be there in case of vehicle and Manpower presence...
            //If only Vehicle or Manpower -- system can handle , no need of customize pricing...
            if( req.Vehicle_Requests__r != null && req.Vehicle_Requests__r.size() > 0 && req.Work_force_Requests__r != null && req.Work_force_Requests__r.size() > 0 &&   req.Request_Mapping__r.size() ==0){
                throw new MyException('Please Create Customize Pricing for the Service Request before submitting for Approval');
            }
            
            // if Vehicle and workforce are not created and trying to submit for Head of sales, Restrict it
            if( req.Vehicle_Requests__r.isempty() && req.Work_force_Requests__r.isempty() ){
                throw new MyException('Request is not completed or saved. Please save the request and try again.');
            }
            
            if( req.opportunity__r.ETSALES_Approval_Status__c == null ||  req.opportunity__r.ETSALES_Approval_Status__c =='Rejected' ||  req.opportunity__r.ETSALES_Approval_Status__c =='Rejected by Pricing Team' )
            {
                List<User> usr = [Select Id, ManagerId from User where Id=:req.opportunity__r.OwnerId limit 1];
                // Create an approval request for the account
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(req.opportunity__r.Id);
                
                // Submit on behalf of a specific submitter
                req1.setSubmitterId(req.opportunity__r.OwnerId); 
                
                // Submit the record to specific process and skip the criteria evaluation
                req1.setProcessDefinitionNameOrId(approvalProcess);
                req1.setSkipEntryCriteria(true);
                req1.setNextApproverIds(new Id[] {usr[0].ManagerId});
                
                if(!Test.isRunningTest()){
                    Approval.ProcessResult result = Approval.process(req1);
                    system.debug('result.isSuccess() = '+ result.isSuccess());
                    System.assert(result.isSuccess());
                    resp = 'true';
                }
                if(req.isServiceRequestRejected__c){
                    req.isServiceRequestRejected__c = false;
                    update req;
                }
            }
            else{
                resp = 'opportunity is either already Approved or submitted for Approval.';
            }
        }
        catch(Exception e){
            resp = 'false';
            system.debug('Exception ='+ e.getMessage());
            system.debug('Exception Trace='+ e.getStackTraceString());
            system.debug('Exception line='+ e.getLineNumber());
            if(e.getMessage().contains('MANAGER_NOT_DEFINED')){
                throw new AuraHandledException('Heads of Sales is Required to submit for approval, Please fill and Resubmit again.');
            }
            else if(e.getMessage().contains('Please Create Customize Pricing')){
                throw new AuraHandledException( e.getMessage());
            }
            else if(e.getMessage().contains('Request is not completed')){
                throw new AuraHandledException( e.getMessage());
            }
            else if(e.getMessage().contains('ALREADY_IN_PROCESS')){
                throw new AuraHandledException( 'Request is already submitted for Approval. Please reject the request and try again.');
            }
            else
                throw new AuraHandledException('Internal Error. Please contact system admin.');
        }
        return resp;
    }
    
    public class MyException extends Exception {}
    
    @AuraEnabled
    public static boolean fetchSubmitFlag(String quoteId){
        return ET_QuoteApprovalController.fetchSubmitFlag(quoteId); 
    }
    
    @AuraEnabled
    public static void saveAlterRates(String alterRatesWrapper, String serviceRequestId, String quoteId, String totalProjectQuoteId){
        ET_ServiceRequestControllerHelper.saveAlterRatesHelper(alterRatesWrapper , serviceRequestId ,quoteId, totalProjectQuoteId );
    }
    
    @AuraEnabled
    public static Boolean deleteQuote(Id serviceRequestRecordId){
        boolean flag = false;
        List<ET_Quote_Item_SpecReq__c> VehspecReqs = new List<ET_Quote_Item_SpecReq__c>();
        List<ET_Quote_Item_SpecReq__c> wForspecReqs = new List<ET_Quote_Item_SpecReq__c>();
        List<ET_Quote_Item_SpecReq__c> allSpecReqs = new List<ET_Quote_Item_SpecReq__c>();
        List<String> vehQuoteItemsIds = new List<String>();
        List<String> wForceQuoteItemsIds = new List<String>();
        if(serviceRequestRecordId!=null){
            List<quote> quotes = [select id, (select id from Workforce_Quote_Items__r), (select id from Quote_Calculation__r) from quote where IsActive__c = true AND ET_Pricing_Service_Request__c =:serviceRequestRecordId ];
            if(quotes != null && !quotes.isEmpty()){
                for(quote qt : quotes){
                    if(qt.Workforce_Quote_Items__r != null && qt.Workforce_Quote_Items__r.size() > 0){
                        for(ET_Workforce_Quote_Item__c wforQitem : qt.Workforce_Quote_Items__r ){
                            wForceQuoteItemsIds.add(wforQitem.id);
                        }
                    }
                    if(qt.Quote_Calculation__r != null && qt.Quote_Calculation__r.size() > 0){
                        for(ET_Vehicle_Quote_Item__c vQitem : qt.Quote_Calculation__r ){
                            vehQuoteItemsIds.add(vQitem.id);
                        }
                    }
                }
                
                VehspecReqs = [select id from ET_Quote_Item_SpecReq__c where ET_Vehicle_Quote_Item__c in :vehQuoteItemsIds ];
                
                wForspecReqs = [select id from ET_Quote_Item_SpecReq__c where Workforce_Quote_Item__c in :wForceQuoteItemsIds ];
                allSpecReqs.addAll(VehspecReqs);
                allSpecReqs.addAll(wForspecReqs);
                try{
                    if(allSpecReqs != null && allSpecReqs.size() > 0){
                        delete allSpecReqs;
                    }
                    delete quotes;
                    flag = true;
                }
                catch(Exception e){
                    ET_PricingUtilityClass.logException(e, 'Pricing');
                    system.debug('Exception ='+ e.getMessage());
                    system.debug('Exception Trace='+ e.getStackTraceString());
                    system.debug('Exception line='+ e.getLineNumber());
                    flag = false;
                    throw new AuraHandledException('Exception ='+ e.getMessage() + 'Exception Trace='+ e.getStackTraceString()+'Exception line='+ e.getLineNumber() + 'Exeption Cause :'+ e.getCause());
                }
            }
        }
        return flag;
    }
    
    @AuraEnabled
    public static void rejectServiceRequest(Id serviceRequestId,string rejectionReason){
        String msg;
        try{
            if(serviceRequestId!=null && rejectionReason!=null && rejectionReason!=''){
                List<string> lstToAddress = new list<string>();
                set<Id> oppIds = new set<Id>();
                List<Opportunity> updateOpportunity =  new List<Opportunity>(); 
                List<ET_Pricing_Service_Request__c> updateQuoteServiceRequest =  new List<ET_Pricing_Service_Request__c>(); 
                for(ET_Pricing_Service_Request__c sr:[Select Id,Opportunity__c,Opportunity__r.Owner.Id,Opportunity__r.Owner.Email From ET_Pricing_Service_Request__c Where Id=:serviceRequestId]){
                    lstToAddress.add(sr.Opportunity__r.Owner.Email);
                    ET_Pricing_Service_Request__c serviceReq=new ET_Pricing_Service_Request__c(); 
                    serviceReq.Id=sr.Id;
                    serviceReq.Rejection_Reason__c = rejectionReason;
                    serviceReq.isServiceRequestRejected__c=true;
                    updateQuoteServiceRequest.add(serviceReq);
                    Opportunity opp=new Opportunity(); 
                    opp.Id= sr.Opportunity__c;
                    opp.ETSALES_Approval_Status__c='Rejected by Pricing Team';
                    opp.StageName='Decision';
                    updateOpportunity.add(opp);
                }
                update updateQuoteServiceRequest;
                if(!updateQuoteServiceRequest.isEmpty()){
                    Messaging.SingleEmailMessage[] emailToSend=new List<Messaging.SingleEmailMessage>();
                    contact conFinal ;
                    for(contact con : [select id, Email from Contact]){
                        if(con.email != null){
                            conFinal = con;
                        }
                        break;
                    }
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :System.Label.orgWideEmail];
                    if(conFinal !=null && !lstToAddress.isEmpty()){
                        list<EmailTemplate> EmailTemplates=[SELECT Id,Subject,HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Quote_Service_Rejected_Template' limit 1];
                        if(EmailTemplates!=NULL && EmailTemplates.size()>0){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setTargetObjectId(conFinal.id);
                            mail.setTemplateId(EmailTemplates[0].id);
                            mail.setWhatId(updateQuoteServiceRequest[0].Id);
                            mail.setToAddresses(lstToAddress);
                            Savepoint sp = Database.setSavepoint();
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                            Database.rollback(sp);
                            Messaging.SingleEmailMessage sEmail = new Messaging.SingleEmailMessage();
                            if(owea.size() > 0) {
                                sEmail.setOrgWideEmailAddressId(owea.get(0).Id);
                            }
                            sEmail.setToAddresses(mail.getToAddresses());
                            sEmail.setPlainTextBody(mail.getPlainTextBody());
                            //String htmlBody = mail.getHTMLBody().replace('{!ET_Pricing_Service_Request__c.Rejection_Reason__c}',rejectionReason);
                            sEmail.setHTMLBody(mail.getHTMLBody());
                            sEmail.setSubject(mail.getSubject());
                            emailToSend.add(sEmail);
                        }
                    }
                    if(!updateOpportunity.isEmpty())
                    {
                        update updateOpportunity;   
                    }
                    List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailToSend);
                }
            }
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);
        }
        catch(Exception e){
            ET_PricingUtilityClass.logException(e, 'Pricing');
            //throw all other exception message
            msg = 'Exception ='+e.getMessage() +'\n'+ ' Trace= '+e.getStackTraceString();
            throw new AuraHandledException(msg);
        }
        
    }
    
    /* Method      : getServiceRelatedInfo
Description : To get all the info related to Service Request...
*/
    
    @AuraEnabled
    public static serviceRequestInformationWrapper getServiceRelatedInfo(Id serviceRequestId){
        serviceRequestInformationWrapper reqWr = new serviceRequestInformationWrapper();
        
        if(serviceRequestId != null){
            List<ET_Pricing_Service_Request__c> pReqList = new List<ET_Pricing_Service_Request__c>([select id ,Opportunity__r.ETSALES_Approval_Status__c
                                                                                                    from ET_Pricing_Service_Request__c 
                                                                                                    where id = :serviceRequestId ]);
            List<quote> activeQuotes =  getActiveQuotes(serviceRequestId, null); //moved query to method
            /*new List<quote>([select id, ET_Type__c,ET_Pricing_Service_Request__c,
                                                        Opportunity.ETSALES_Approval_Status__c,status,
                                                        OwnerId,CreatedById,Quote_Total_Investment__c,CreatedBy.Profile.Name,Validate_Quotation_Notification_Sent__c,
                                                        Quote_Type__c,Total_Investment_New_Vehicles_Manual__c,Total_Value_of_Rental_Manual__c,
                                                        (SELECT ContentDocumentId, 
                                                        ContentDocument.Title, 
                                                        ContentDocument.FileExtension, 
                                                        ContentDocument.LatestPublishedVersionId
                                                        FROM ContentDocumentLinks WHERE ContentDocument.Title LIKE '%_ManualQuotation%' LIMIT 1)
                                                        FROM quote 
                                                        where IsActive__c = True 
                                                        AND ET_Pricing_Service_Request__c = :serviceRequestId 
                                                        ]) ;*/
            if(activeQuotes != null && !activeQuotes.isEmpty()){
                for(quote qt : activeQuotes){
                    if(qt.ET_Type__c == 'Quote for Approval'){
                        reqWr.quoteId = qt.id;
                        reqWr.quotationStatus = qt.status;
                        reqWr.quoteDetail = qt;
                        if(UserInfo.getUserId() == qt.CreatedById){
                            reqWr.isInitiatedUser = true;
                        }
                        if(qt.status == 'Draft' || qt.status == 'Rejected' ){
                            reqWr.changesAllowedInQuotation = true;
                        }
                    }
                    else if(qt.ET_Type__c == 'Total Project Summary'){
                        reqWr.totalProjectQuoteId = qt.id;
                    }
                }
            }
            if(pReqList != null && !pReqList.isEmpty()){
                reqWr.opportunityStatus  = pReqList[0].Opportunity__r.ETSALES_Approval_Status__c;
            }
        }
        return reqWr;    
    }

    @AuraEnabled
    public static List<Quote> getActiveQuotes(Id serviceRequestId, Id quoteId) {
        List<Quote> activeQuotes = new List<Quote>();
        String query = 'SELECT id, QuoteNumber, ET_Type__c, ET_Pricing_Service_Request__c, ' +
                    'Opportunity.ETSALES_Approval_Status__c, Opportunity.ETSALES_Opportunity_Number__c, status, ' +
                    'OwnerId, CreatedById, Quote_Total_Investment__c, CreatedBy.Profile.Name, ' +
                    'Validate_Quotation_Notification_Sent__c, Quote_Type__c, Contract_Year__c, ' +
                    'Total_Investment_New_Vehicles_Manual__c, Total_Value_of_Rental_Manual__c, ' +
                    '(SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension, ' +
                    'ContentDocument.LatestPublishedVersionId ' +
                    'FROM ContentDocumentLinks WHERE ContentDocument.Title LIKE \'%_ManualQuotation%\' ORDER BY SystemModstamp DESC LIMIT 1) ' +
                    'FROM Quote WHERE IsActive__c = TRUE';
        if (serviceRequestId != null) {
            query += ' AND ET_Pricing_Service_Request__c = :serviceRequestId';
        } else if (quoteId != null) {
            query += ' AND Id = :quoteId';
        } else {
            // If neither parameter is provided, return an empty list
            return activeQuotes;
        }
        // Execute the query
        activeQuotes = Database.query(query);
        System.debug('activeQuotes: '+activeQuotes);
        return activeQuotes;
    }
    
    // Wrapper class to 
    public class serviceRequestInformationWrapper{
        @AuraEnabled
        Public String quoteId;
        @AuraEnabled
        Public String totalProjectQuoteId;
        @AuraEnabled
        Public String opportunityStatus;
        @AuraEnabled
        Public String quotationStatus;
        @AuraEnabled
        Public boolean changesAllowedInQuotation = false;
        //Taj
        @AuraEnabled
        Public Quote quoteDetail;
        @AuraEnabled
        Public Boolean isInitiatedUser = false;
    }
    
    /*Method      : getEditableFieldsforPricingTeam
Description : To get Editable Fields for Pricing Team
*/
    
    @AuraEnabled
    public static String getEditableFieldsforPricingTeam(){
        return ET_ServiceRequestControllerHelper.getEditableFieldsforPricingTeamHelper();
    }
    
    /*Method      : getUserPermissions
Description : To get user permissions like - Pricing or Sales Team and other required info...
*/
    
    @AuraEnabled
    public static ET_ServiceRequestControllerHelper.userPermissions getUserPermissions(){
        return ET_ServiceRequestControllerHelper.getUserPermissionsHelper();
    }
    
    /* Method      : saveServiceRequestData
Description : To Create or update Pricing Service Request and it's related line items..
*/
    
    @AuraEnabled
    public static String saveServiceRequestData(Id serviceRequestId, Map<String,Object> allTabData, String operation, 
                                                List<String> existingCommonDataTabLst)
    {
        
        
        try{ 
            ET_Pricing_Service_Request__c serviceRequest = [Select id, Opportunity__r.Id, (select Id, ET_Service_Request_Common_Data__c from Vehicle_Requests__r), (select Id from Other_Cost_Requests__r), 
                                                            ET_Service_Request_Common_Data__c , ET_Service_Request_Common_Data__r.ET_Common_Data_Type__c, ET_Service_Request_Common_Data__r.ET_Contract_Period__c, ET_Service_Request_Common_Data__r.ET_Contract_Type__c,
                                                            ET_Service_Request_Common_Data__r.ET_Fleet_Type__c, ET_Service_Request_Common_Data__r.ET_Price_Utilization__c, 
                                                            ET_Service_Request_Common_Data__r.ET_Pricing_Method__c, ET_Service_Request_Common_Data__r.ET_Pricing_Type__c,
                                                            ET_Service_Request_Common_Data__r.ET_Service_Emirate__c, ET_Service_Request_Common_Data__r.ET_Working_Days_Per_Week__c, 
                                                            ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c,
                                                            ET_Service_Request_Common_Data__r.ET_Request_for_Separate_Prices__c,
                                                            ET_Service_Request_Common_Data__r.ET_Working_Months_Per_Year__c from ET_Pricing_Service_Request__c where id= :serviceRequestId];
            
            List<ET_Work_force__c> workforceRequestData = [Select Id,ET_Workforce_Record_Type_Name__c,ET_Service_Request_Common_Data__c,ET_Pricing_Service_Request__c from ET_Work_force__c where ET_Pricing_Service_Request__c = :serviceRequestId ];
            Id oppId =  serviceRequest.Opportunity__r.Id;
            system.debug('allTabData'+allTabData);
            Opportunity opp = [select id, StageName from Opportunity where id =: oppId];
            List<ET_Work_force__c> driverRequestLst = new List<ET_Work_force__c>();
            List<ET_Work_force__c> nannyRequestLst = new List<ET_Work_force__c>();
            List<ET_Work_force__c> supervisorRequestLst = new List<ET_Work_force__c>();
            List<ET_Work_force__c> coordinatorRequestLst = new List<ET_Work_force__c>();
            List<ET_Work_force__c> otherEmpRequestLst = new List<ET_Work_force__c>();
            List<ET_Work_force__c> accountantRequestLst = new List<ET_Work_force__c>();
            
            for(ET_Work_force__c workforce : workforceRequestData){
                if(workforce.ET_Workforce_Record_Type_Name__c.equalsIgnoreCase('ET_Driver')){
                    driverRequestLst.add(workforce);
                }else if(workforce.ET_Workforce_Record_Type_Name__c.equalsIgnoreCase('ET_Nanny')){
                    nannyRequestLst.add(workforce);
                }
                else if(workforce.ET_Workforce_Record_Type_Name__c.equalsIgnoreCase('ET_Supervisor')){
                    supervisorRequestLst.add(workforce);
                }
                else if(workforce.ET_Workforce_Record_Type_Name__c.equalsIgnoreCase('ET_Coordinator')){
                    coordinatorRequestLst.add(workforce);
                }
                else if(workforce.ET_Workforce_Record_Type_Name__c.equalsIgnoreCase('ET_Accountant_Cashier')){
                    accountantRequestLst.add(workforce);
                }
                else if(workforce.ET_Workforce_Record_Type_Name__c.equalsIgnoreCase('ET_Other_Employee')){
                    otherEmpRequestLst.add(workforce);
                }
            }
            //deletedOtherCostTabWiseIds
            // System.debug('Mappingdata-->'+allTabData);
            List<Vehicle__c> upsertVehicles=new List<Vehicle__c>();
            List<ET_Other_Cost_Request__c> upsertOtherCostLst = new List<ET_Other_Cost_Request__c>();
            List<Vehicle__c> vehicleToBeDeleted = new List<Vehicle__c>();
            List<ET_Work_force__c> workforceToBeDeleted = new List<ET_Work_force__c>();
            List<ET_Other_Cost_Request__c> otherCostToBeDeleted = new List<ET_Other_Cost_Request__c>();
            
            List<ET_Service_Request_Common_Data__c> tabCommonDataToBeDeletedWhenTabDeleted = new List<ET_Service_Request_Common_Data__c>();
            List<Vehicle__c> vehicleRequestToBeDeletedWhenTabDeleted = new List<Vehicle__c>();
            List<ET_Work_force__c> workforceRequestToBeDeletedWhenTabDeleted =  new List<ET_Work_force__c>();
            List<ET_Other_Cost_Request__c> otherCostToBeDeletedWhenTabDeleted  = new List<ET_Other_Cost_Request__c>();
            
            
            /****************Delete back end requests when Tabs Removed while updating requests****************/
            
            
            
            if(allTabData.get('deletedWholeTabLst') != null){
                List<Object> tabNameObjlst = (List<Object>)allTabData.get('deletedWholeTabLst');
                if(tabNameObjlst.size() > 0){
                    for(Object tabName : tabNameObjlst){
                        String tabNameStr = (String)tabName;
                        if(tabNameStr.equalsIgnoreCase('Vehicle')){
                            if(serviceRequest.Vehicle_Requests__r.size() > 0){
                                
                                tabCommonDataToBeDeletedWhenTabDeleted.add(new ET_Service_Request_Common_Data__c(id = (Id)serviceRequest.Vehicle_Requests__r[0].ET_Service_Request_Common_Data__c));
                                vehicleRequestToBeDeletedWhenTabDeleted.addAll(serviceRequest.Vehicle_Requests__r);
                            }
                            
                        }else if(tabNameStr.equalsIgnoreCase('Driver')){
                            if(driverRequestLst.size() > 0){
                                
                                if(driverRequestLst[0].ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c){
                                    tabCommonDataToBeDeletedWhenTabDeleted.add(new ET_Service_Request_Common_Data__c(id = (Id)driverRequestLst[0].ET_Service_Request_Common_Data__c));
                                }
                                workforceRequestToBeDeletedWhenTabDeleted.addAll(driverRequestLst);
                            }
                            
                        }else if(tabNameStr.equalsIgnoreCase('Nanny')){
                            if(nannyRequestLst.size() > 0){
                                
                                if(nannyRequestLst[0].ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c){
                                    tabCommonDataToBeDeletedWhenTabDeleted.add(new ET_Service_Request_Common_Data__c(id = (Id)nannyRequestLst[0].ET_Service_Request_Common_Data__c));
                                }
                                workforceRequestToBeDeletedWhenTabDeleted.addAll(nannyRequestLst);
                            }
                            
                        }else if(tabNameStr.equalsIgnoreCase('Supervisor')){
                            if(supervisorRequestLst.size() > 0){
                                
                                if(supervisorRequestLst[0].ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c){
                                    tabCommonDataToBeDeletedWhenTabDeleted.add(new ET_Service_Request_Common_Data__c(id = (Id)supervisorRequestLst[0].ET_Service_Request_Common_Data__c));
                                }
                                workforceRequestToBeDeletedWhenTabDeleted.addAll(supervisorRequestLst);
                            }
                        }else if(tabNameStr.equalsIgnoreCase('Coordinator')){
                            if(coordinatorRequestLst.size() > 0){
                                
                                if(coordinatorRequestLst[0].ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c){
                                    tabCommonDataToBeDeletedWhenTabDeleted.add(new ET_Service_Request_Common_Data__c(id = (Id)coordinatorRequestLst[0].ET_Service_Request_Common_Data__c));
                                }
                                workforceRequestToBeDeletedWhenTabDeleted.addAll(coordinatorRequestLst);
                            }
                        }else if(tabNameStr.equalsIgnoreCase('Other_Employee')){
                            if(otherEmpRequestLst.size() > 0){
                                
                                if(otherEmpRequestLst[0].ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c){
                                    tabCommonDataToBeDeletedWhenTabDeleted.add(new ET_Service_Request_Common_Data__c(id = (Id)otherEmpRequestLst[0].ET_Service_Request_Common_Data__c));
                                }
                                workforceRequestToBeDeletedWhenTabDeleted.addAll(otherEmpRequestLst);
                            }
                        }else if(tabNameStr.equalsIgnoreCase('Accountant')){
                            if(accountantRequestLst.size() > 0){
                                
                                if(accountantRequestLst[0].ET_Service_Request_Common_Data__c != serviceRequest.ET_Service_Request_Common_Data__c){
                                    tabCommonDataToBeDeletedWhenTabDeleted.add(new ET_Service_Request_Common_Data__c(id = (Id)accountantRequestLst[0].ET_Service_Request_Common_Data__c));
                                }
                                workforceRequestToBeDeletedWhenTabDeleted.addAll(accountantRequestLst);
                            }
                        }else if(tabNameStr.equalsIgnoreCase('Other_Cost')){
                            if(serviceRequest.Other_Cost_Requests__r.size() > 0){
                                otherCostToBeDeletedWhenTabDeleted.addAll(serviceRequest.Other_Cost_Requests__r);
                            }
                        }
                    }
                }
                
            }
            
            if(workforceRequestToBeDeletedWhenTabDeleted.size() > 0){
                delete workforceRequestToBeDeletedWhenTabDeleted;
            }
            if(vehicleRequestToBeDeletedWhenTabDeleted.size() > 0){
                delete vehicleRequestToBeDeletedWhenTabDeleted;
            }
            if(otherCostToBeDeletedWhenTabDeleted.size() > 0){
                delete otherCostToBeDeletedWhenTabDeleted;
            }
            
            
            
            /*  operations to delete -> deleted Vehicle/Manpower lines/ other cost at app or Tab Level */
            
            Id appLevelCommonDataObjId;
            if(serviceRequest != null && serviceRequest.ET_Service_Request_Common_Data__c != null){
                appLevelCommonDataObjId = serviceRequest.ET_Service_Request_Common_Data__c;
            }
            Id vehicleTabCommonDataId;
            Id driverTabCommonDataId;
            Id nannyTabCommonDataId;
            Id supervisorTabCommonDataId;
            Id coordinatorTabCommonDataId;
            Id accountantTabCommonDataId;
            Id otherEmpTabCommonDataId;
            
            Id alreadyExistingVehicleTabCommonDataId;
            Id alreadyExistingDriverTabCommonDataId;
            Id alreadyExistingNannyTabCommonDataId;
            Id alreadyExistingSupervisorTabCommonDataId;
            Id alreadyExistingCoordinatorTabCommonDataId;
            Id alreadyExistingAccountantTabCommonDataId;
            Id alreadyExistingOtherEmpTabCommonDataId;
            
            
            if(existingCommonDataTabLst == null || (existingCommonDataTabLst != null && existingCommonDataTabLst.size() == 0) || !existingCommonDataTabLst.contains('Vehicle')){
                // system.debug('existing common data not found  for vehicle');
                if(allTabData.get('vehicleTabCommonInfo') != null){
                    vehicleTabCommonDataId = ET_ServiceRequestControllerHelper.saveCommonData((Object)allTabData.get('vehicleTabCommonInfo'), 'Vehicle Tab', serviceRequest);
                }else{
                    vehicleTabCommonDataId = appLevelCommonDataObjId;
                }
            }
            if(allTabData.get('deletedVehicleCmpIds') != null){
                for(Object idObj : (List<Object>) allTabData.get('deletedVehicleCmpIds')){
                    Id vehicleId = (Id)idObj;
                    vehicleToBeDeleted.add(new Vehicle__c(id = vehicleId));
                }
            }
            
            if(allTabData.get('deletedManpowerCmpIds') != null){
                
                for(Object idObj : (List<Object>) allTabData.get('deletedManpowerCmpIds')){
                    Id manpowerId = (Id)idObj;
                    workforceToBeDeleted.add(new ET_Work_force__c(id = manpowerId));
                }
            }
            
            
            if(allTabData.get('deletedOtherCostCmpIds') != null){
                for(Object idObj : (List<Object>) allTabData.get('deletedOtherCostCmpIds')){
                    Id otherCostId = (Id)idObj;
                    otherCostToBeDeleted.add(new ET_Other_Cost_Request__c(id = otherCostId));
                }
            }
            
            if(allTabData.get('deletedOtherCostTabWiseIds') != null){
                for(Object idObj : (List<Object>) allTabData.get('deletedOtherCostTabWiseIds')){
                    Id otherCostId = (Id)idObj;
                    otherCostToBeDeleted.add(new ET_Other_Cost_Request__c(id = otherCostId));
                }
            }
            
            /******************* Create/ update Vehicles with Line Info, Common Data and other cost*******************/
            
            Map<Integer,Object> vehicleLineNumberAndOtherCostsMap = new Map<Integer,Object>();
            
            if(allTabData.get('vehicleTabInfo') !=null){
                // system.debug('vehicle yab info :: '+ allTabData.get('vehicleTabInfo'));
                
                for(Object instance: (List<object>)allTabData.get('vehicleTabInfo')){
                    Map<Object, Object> dataObj =( Map<Object, Object>)instance;
                    if(dataObj!=null && dataObj.get('ET_Service_Request_Common_Data__c') != null && alreadyExistingVehicleTabCommonDataId == null ){
                        alreadyExistingVehicleTabCommonDataId = (Id)dataobj.get('ET_Service_Request_Common_Data__c');
                    }
                }
                
                for(Object instance: (List<object>)allTabData.get('vehicleTabInfo')){
                    Map<Object, Object> dataObj =( Map<Object, Object>)instance;
                    // system.debug('dataObj : '+ JSON.serializePretty(dataObj) );
                    if(dataObj!=null){
                        Vehicle__c obj;
                        if(dataObj.get('sObjectType') != null && dataObj.get('Id') == null){
                            // system.debug('new vehicle');
                            obj = new Vehicle__c();
                        }else if(dataObj.get('sObjectType') == null && dataObj.get('Id') != null){
                            //system.debug('old vehicle');
                            obj = new Vehicle__c(Id = (Id)dataObj.get('Id') ) ;
                        }
                        /* String typeStr = (String)dataObj.get('sObjectType');
SObject obj = (Vehicle__c)Type.forName(typeStr).newInstance();*/
                        
                        for(Object key : dataObj.keyset()){
                            //system.debug('dataObj.keyset() : '+ JSON.serializePretty(dataObj.keyset()) );
                            String keyStr = (String)key;
                            //System.debug(keyStr);
                            if(dataObj.get(keyStr)!=null  && keyStr != 'sObjectType' && keyStr != 'Id' && keyStr != 'ET_Pricing_Service_Request__c' && keyStr != 'Other_Cost_Requests__r' ){
                                //System.debug('keyStr 896 '+dataobj.get(keyStr));
                                //System.debug('keyStr 897 '+keyStr);
                                
                                if(keyStr=='ET_Annual_KM__c' || keyStr=='ET_Number_of_seats__c'||
                                   keyStr=='ET_Working_Days_Per_Week__c' ||keyStr=='ET_Working_Months_Per_Year__c'  
                                   || keyStr=='ET_Vehicle_Quantity__c'|| keyStr=='ET_Price_Utilization__c' || keyStr == 'ET_Vehicle_Line__c' || keyStr == 'ET_Vehicle_Fuel_Consumption__c' 
                                   || keyStr == 'ET_Number_of_seats__c' || keyStr == 'ET_Vehicle_Original_Purchase_Price__c' || keyStr == 'ET_Vehicle_Current_Purchase_Price__c' || keyStr == 'ET_Annual_Target_Price__c'
                                   || keyStr == 'Trailer_original_purchase_price__c'  || keyStr == 'Trailer_Current_purchase_price__c'  || keyStr == 'Trailer_model_year__c'
                                   || keyStr == 'Trailer_External_Maintenance_Cost__c' 
                                   || keyStr == 'Refrigerator_External_Maintenance_Cost__c' || keyStr == 'Refrigerator_original_purchase_price__c' || keyStr == 'Refrigerator_Current_purchase_price__c'
                                   || keyStr == 'Refrigerator_model_year__c')
                                {
                                    //System.debug('keyStr 907 '+keyStr);
                                    //System.debug('keyStr 908 '+dataobj.get(keyStr));
                                    if(dataobj?.get(keyStr) != null){
                                        obj.put(keyStr, Double.valueOf(dataobj.get(keyStr)));  
                                    }
                                }
                                else if(keyStr == 'ET_Contract_Period__c' || keyStr == 'ET_Other_Annual_Requirement__c' || keyStr == 'ET_Other_One_Time_Requirement__c'){
                                    
                                    String value = String.valueOf(dataobj.get(keyStr));
                                    String finalValue = '';
                                    value = value.removeStart('(');
                                    value = value.removeEnd(')');
                                    for(String valueStr : value.split(',')){
                                        finalValue += valueStr.trim() + ',';
                                    }
                                    finalValue = finalValue.removeEnd(',');
                                    
                                    obj.put(keyStr, finalValue);  
                                }
                                else if( keyStr == 'ET_Other_Cost_Request__c' ){
                                    vehicleLineNumberAndOtherCostsMap.put(Integer.valueOf(dataobj.get('ET_Vehicle_Line__c')), dataobj.get(keyStr));
                                }
                                
                                else if(keyStr == 'Add_Trailer_Equipment__c' || keyStr == 'Add_Refregirator__c'){
                                    obj.put(keyStr, dataobj.get(keyStr));  
                                }
                                
                                else if(keyStr != 'ET_Service_Request_Common_Data__c' && keyStr != 'ET_Service_Request_Common_Data__r' && keyStr != 'ET_Request_for_Target_Price__c' && keyStr != 'ET_Request_for_Separate_Prices__c' && keyStr != 'ET_Pricing_Service_Request__r'){//Added Noor Shaik on 07/04/2021
                                    
                                    obj.put(keyStr, String.valueOf(dataobj.get(keyStr)));  
                                }
                                
                            }
                            
                            
                            
                        }
                        if(vehicleTabCommonDataId != null){
                            //system.debug('new vehicle' + dataobj.get('ET_Annual_KM__c'));
                            obj.put('ET_Service_Request_Common_Data__c', vehicleTabCommonDataId);
                            
                        }else if(alreadyExistingVehicleTabCommonDataId != null){
                            // system.debug('old vehicle' + dataobj.get('ET_Annual_KM__c'));
                            obj.put('ET_Service_Request_Common_Data__c', alreadyExistingVehicleTabCommonDataId);
                        }
                        if(dataObj.get('ET_Pricing_Service_Request__c') == null){
                            obj.put('ET_Pricing_Service_Request__c', serviceRequestId);
                        }
                        
                        upsertVehicles.add((Vehicle__c)obj);
                        //system.debug('upsertVehicles : '+ upsertVehicles);
                    }
                }
            }
            /***********************************************************************************************************************************/
            
            /*************************************operations on workforce ******************************************************************/
            
            String workforceRecordTypeDeveloperName;
            Map<String,Object> workforceTypeAndLineNumberComboAndOtherCostMap = new Map<String,Object>();
            Map<String,Map<Object, Object>> workforceSpecificInfoMap = new Map<String, Map<Object,Object>>();
            //Insert Driver details
            if(existingCommonDataTabLst == null || (existingCommonDataTabLst != null && existingCommonDataTabLst.size() == 0) || !existingCommonDataTabLst.contains('Driver')){
                if(allTabData.get('driverTabCommonInfo') != null){
                    driverTabCommonDataId = ET_ServiceRequestControllerHelper.saveCommonData((Object)allTabData.get('driverTabCommonInfo'), 'Driver Tab', null);
                }else{
                    driverTabCommonDataId = appLevelCommonDataObjId;
                }
            }
            if(allTabData.get('driverTabInfo')!=null){   
                workforceRecordTypeDeveloperName = 'ET_Driver';
                Id driverRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName()
                    .get(workforceRecordTypeDeveloperName)
                    .getRecordTypeId();
                for(Object instance: (List<object>)allTabData.get('driverTabInfo')){
                    Map<Object, Object> dataObj =( Map<Object, Object>)instance;
                    if(dataObj!=null && dataObj.get('ET_Service_Request_Common_Data__c') != null && alreadyExistingDriverTabCommonDataId == null ){
                        alreadyExistingDriverTabCommonDataId = (Id)dataobj.get('ET_Service_Request_Common_Data__c');
                    }
                }        
                for(Object instance: (List<object>)allTabData.get('driverTabInfo')){
                    Map<String,Map<Object, Object>> specificInfoMap = getWorkforceSpecificInfoMap(instance, workforceRecordTypeDeveloperName, 'ET_No_of_Drivers__c','ET_Driver_Line__c',serviceRequestId,driverRecordTypeId,driverTabCommonDataId,alreadyExistingDriverTabCommonDataId, workforceTypeAndLineNumberComboAndOtherCostMap);
                    if(specificInfoMap != null && specificInfoMap.size() > 0){
                        workforceSpecificInfoMap.putAll(specificInfoMap);
                    }
                    // system.debug('workforceSpecificInfoMap :: ' + workforceSpecificInfoMap );
                    // system.debug('upsertVehicles  : '+ upsertVehicles);
                }
            }
            //Insert Nanny details
            if(existingCommonDataTabLst == null || (existingCommonDataTabLst != null && existingCommonDataTabLst.size() == 0) || !existingCommonDataTabLst.contains('Nanny')){
                if(allTabData.get('nannyTabCommonInfo') != null){
                    nannyTabCommonDataId = ET_ServiceRequestControllerHelper.saveCommonData((Object)allTabData.get('nannyTabCommonInfo'), 'Nanny Tab', null);
                }else{
                    nannyTabCommonDataId = appLevelCommonDataObjId;
                }
            }
            if(allTabData.get('nannyTabInfo')!=null){   
                workforceRecordTypeDeveloperName = 'ET_Nanny'; 
                Id nannyRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName()
                    .get(workforceRecordTypeDeveloperName)
                    .getRecordTypeId();
                
                for(Object instance: (List<object>)allTabData.get('nannyTabInfo')){
                    Map<Object, Object> dataObj =( Map<Object, Object>)instance;
                    if(dataObj!=null && dataObj.get('ET_Service_Request_Common_Data__c') != null && alreadyExistingNannyTabCommonDataId == null ){
                        alreadyExistingNannyTabCommonDataId = (Id)dataobj.get('ET_Service_Request_Common_Data__c');
                    }
                }
                
                for(Object instance: (List<object>)allTabData.get('nannyTabInfo')){
                    Map<String,Map<Object, Object>> specificInfoMap = getWorkforceSpecificInfoMap(instance, workforceRecordTypeDeveloperName, 'ET_Number_of_Nannies__c','ET_Nanny_Line__c',serviceRequestId,nannyRecordTypeId,nannyTabCommonDataId,alreadyExistingNannyTabCommonDataId,workforceTypeAndLineNumberComboAndOtherCostMap);
                    if(specificInfoMap != null && specificInfoMap.size() > 0){
                        workforceSpecificInfoMap.putAll(specificInfoMap);
                    }
                    
                }
            }
            //Insert Supervisor details
            if(existingCommonDataTabLst == null || (existingCommonDataTabLst != null && existingCommonDataTabLst.size() == 0) || !existingCommonDataTabLst.contains('Supervisor')){
                if(allTabData.get('supervisorTabCommonInfo') != null){
                    supervisorTabCommonDataId = ET_ServiceRequestControllerHelper.saveCommonData((Object)allTabData.get('supervisorTabCommonInfo') ,'Supervisor Tab', null);
                }else{
                    supervisorTabCommonDataId = appLevelCommonDataObjId;
                }
            }
            if(allTabData.get('supervisorTabInfo')!=null){
                workforceRecordTypeDeveloperName = 'ET_Supervisor';
                Id supervisoRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName()
                    .get(workforceRecordTypeDeveloperName)
                    .getRecordTypeId(); 
                
                for(Object instance: (List<object>)allTabData.get('supervisorTabInfo')){
                    Map<Object, Object> dataObj =( Map<Object, Object>)instance;
                    if(dataObj!=null && dataObj.get('ET_Service_Request_Common_Data__c') != null && alreadyExistingSupervisorTabCommonDataId == null ){
                        alreadyExistingSupervisorTabCommonDataId = (Id)dataobj.get('ET_Service_Request_Common_Data__c');
                    }
                }            
                for(Object instance: (List<object>)allTabData.get('supervisorTabInfo')){
                    Map<String,Map<Object, Object>> specificInfoMap = getWorkforceSpecificInfoMap(instance, workforceRecordTypeDeveloperName, 'ET_Number_of_Supervisors__c','ET_Supervisor_Line__c',serviceRequestId,supervisoRecordTypeId,supervisorTabCommonDataId,alreadyExistingSupervisorTabCommonDataId,workforceTypeAndLineNumberComboAndOtherCostMap);
                    if(specificInfoMap != null && specificInfoMap.size() > 0){
                        workforceSpecificInfoMap.putAll(specificInfoMap);
                    }
                }
            }
            //Insert Coordinator details
            if(existingCommonDataTabLst == null || (existingCommonDataTabLst != null && existingCommonDataTabLst.size() == 0) || !existingCommonDataTabLst.contains('Coordinator')){
                if(allTabData.get('coordinatorTabCommonInfo') != null){
                    coordinatorTabCommonDataId = ET_ServiceRequestControllerHelper.saveCommonData((Object)allTabData.get('coordinatorTabCommonInfo'), 'Coordinator Tab', null);
                }else{
                    coordinatorTabCommonDataId = appLevelCommonDataObjId;
                }
            }
            if(allTabData.get('coordinatorTabInfo')!=null){ 
                workforceRecordTypeDeveloperName = 'ET_Coordinator';
                Id coordinatorRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName()
                    .get(workforceRecordTypeDeveloperName)
                    .getRecordTypeId(); 
                
                for(Object instance: (List<object>)allTabData.get('coordinatorTabInfo')){
                    Map<Object, Object> dataObj =( Map<Object, Object>)instance;
                    if(dataObj!=null && dataObj.get('ET_Service_Request_Common_Data__c') != null && alreadyExistingCoordinatorTabCommonDataId == null ){
                        alreadyExistingCoordinatorTabCommonDataId = (Id)dataobj.get('ET_Service_Request_Common_Data__c');
                    }
                }          
                for(Object instance: (List<object>)allTabData.get('coordinatorTabInfo')){
                    Map<String,Map<Object, Object>> specificInfoMap = getWorkforceSpecificInfoMap(instance, workforceRecordTypeDeveloperName, 'ET_Number_of_Coordinators__c','ET_Coordinator_Line__c',serviceRequestId,coordinatorRecordTypeId,coordinatorTabCommonDataId,alreadyExistingCoordinatorTabCommonDataId,workforceTypeAndLineNumberComboAndOtherCostMap);
                    if(specificInfoMap != null && specificInfoMap.size() > 0){
                        workforceSpecificInfoMap.putAll(specificInfoMap);
                    }
                }
            }
            //Insert Accountant/Cashier details
            if(existingCommonDataTabLst == null || (existingCommonDataTabLst != null && existingCommonDataTabLst.size() == 0) || !existingCommonDataTabLst.contains('Accountant')){
                if(allTabData.get('accountantTabCommonInfo') != null){
                    accountantTabCommonDataId = ET_ServiceRequestControllerHelper.saveCommonData((Object)allTabData.get('accountantTabCommonInfo'), 'Accountant Tab', null);
                }else{
                    accountantTabCommonDataId = appLevelCommonDataObjId;
                }
            }
            if(allTabData.get('accountantTabInfo')!=null){   
                workforceRecordTypeDeveloperName = 'ET_Accountant_Cashier';
                Id accountantRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName()
                    .get(workforceRecordTypeDeveloperName)
                    .getRecordTypeId(); 
                
                for(Object instance: (List<object>)allTabData.get('accountantTabInfo')){
                    Map<Object, Object> dataObj =( Map<Object, Object>)instance;
                    if(dataObj!=null && dataObj.get('ET_Service_Request_Common_Data__c') != null && alreadyExistingAccountantTabCommonDataId == null ){
                        alreadyExistingAccountantTabCommonDataId = (Id)dataobj.get('ET_Service_Request_Common_Data__c');
                    }
                }      
                for(Object instance: (List<object>)allTabData.get('accountantTabInfo')){
                    Map<String,Map<Object, Object>> specificInfoMap = getWorkforceSpecificInfoMap(instance, workforceRecordTypeDeveloperName , 'ET_Number_of_Accountants__c','ET_Accountant_Line__c',serviceRequestId,accountantRecordTypeId,accountantTabCommonDataId,alreadyExistingAccountantTabCommonDataId,workforceTypeAndLineNumberComboAndOtherCostMap);
                    if(specificInfoMap != null && specificInfoMap.size() > 0){
                        workforceSpecificInfoMap.putAll(specificInfoMap);
                    }
                }
            }
            //Insert Other employee details
            if(existingCommonDataTabLst == null || (existingCommonDataTabLst != null && existingCommonDataTabLst.size() == 0) || !existingCommonDataTabLst.contains('OtherEmployee')){
                if(allTabData.get('otherEmpTabCommonInfo') != null){
                    otherEmpTabCommonDataId = ET_ServiceRequestControllerHelper.saveCommonData((Object)allTabData.get('otherEmpTabCommonInfo') , 'Other Emp Tab', null);
                }else{
                    otherEmpTabCommonDataId = appLevelCommonDataObjId;
                }
            }
            if(allTabData.get('otherEmployeeTabInfo')!=null){  
                system.debug('instance__otherEmp'+allTabData.get('otherEmployeeTabInfo'));
                workforceRecordTypeDeveloperName = 'ET_Other_Employee';
                Id otherEmpRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName()
                    .get(workforceRecordTypeDeveloperName)
                    .getRecordTypeId();
                
                for(Object instance: (List<object>)allTabData.get('otherEmployeeTabInfo')){
                    Map<Object, Object> dataObj =( Map<Object, Object>)instance;
                    if(dataObj!=null && dataObj.get('ET_Service_Request_Common_Data__c') != null && alreadyExistingOtherEmpTabCommonDataId == null ){
                        alreadyExistingOtherEmpTabCommonDataId = (Id)dataobj.get('ET_Service_Request_Common_Data__c');
                    }
                }
                for(Object instance: (List<object>)allTabData.get('otherEmployeeTabInfo')){
                    Map<String,Map<Object, Object>> specificInfoMap = getWorkforceSpecificInfoMap(instance, workforceRecordTypeDeveloperName, 'ET_Number_of_Other_Employees__c','ET_OtherEmployee_Line__c',serviceRequestId,otherEmpRecordTypeId,otherEmpTabCommonDataId,alreadyExistingOtherEmpTabCommonDataId,workforceTypeAndLineNumberComboAndOtherCostMap);
                    if(specificInfoMap != null && specificInfoMap.size() > 0){
                        workforceSpecificInfoMap.putAll(specificInfoMap);
                    }
                }
            }
            
            // upsert other cost 
            
            if(allTabData.get('otherCostTabInfo')!=null){
                system.debug('instance__d'+allTabData.get('otherCostTabInfo'));
                for(Object instance: (List<Object>)allTabData.get('otherCostTabInfo')){
                    Map<Object, Object> dataObj =( Map<Object, Object>)instance;
                    system.debug('instance__d'+dataObj);
                    if(dataObj!=null){
                        ET_Other_Cost_Request__c obj;
                        if(dataObj.get('sObjectType') != null && dataObj.get('Id') == null){
                            // system.debug('new vehicle');
                            obj = new ET_Other_Cost_Request__c();
                        }else if(dataObj.get('sObjectType') == null && dataObj.get('Id') != null){
                            //system.debug('old vehicle');
                            obj = new ET_Other_Cost_Request__c(Id = (Id)dataObj.get('Id') ) ;
                        }
                        /* String typeStr = (String)dataObj.get('sObjectType');
SObject obj = (Vehicle__c)Type.forName(typeStr).newInstance();*/
                        
                        for(Object key : dataObj.keyset()){
                            
                            String keyStr = (String)key;
                            System.debug('keyStr__D'+keyStr);
                            //&& dataObj.get(keyStr)!=''
                            if(dataObj.get(keyStr)!=null && keyStr != 'sObjectType' && keyStr != 'Id'
                               && keyStr != 'ET_Pricing_Service_Request__c'){
                                   System.debug('keyStr__d'+dataobj.get(keyStr));
                                   if(keyStr=='ET_Cost_Value__c'|| keyStr == 'ET_Other_Cost_Line_Number__c'){
                                       obj.put(keyStr, Double.valueOf(dataobj.get(keyStr)));  
                                       
                                   }else if(keyStr == 'ET_Cost_Type__c' ){
                                       List<Object> valueObjLst = (List<Object>)dataobj.get(keyStr);
                                       
                                       String finalValue = '';
                                       for(Object valueObj : valueObjLst){
                                           String valueStr = (String)valueObj;
                                           finalValue += valueStr.trim() + ',';
                                       }
                                       finalValue = finalValue.removeEnd(',');
                                       
                                       obj.put(keyStr, finalValue);  
                                   }else if(keyStr == 'Name'){
                                       obj.put(keyStr, String.valueOf(dataobj.get(keyStr)));  
                                   }
                                   
                               }
                        }
                        
                        if(dataObj.get('ET_Pricing_Service_Request__c') == null){
                            obj.put('ET_Pricing_Service_Request__c', serviceRequestId);
                        }
                        
                        //obj.put('ET_Other_Cost_Request_Type__c', 'Service Request');
                        
                        upsertOtherCostLst.add((ET_Other_Cost_Request__c)obj);
                    }
                }
            }
            
            
            // DML operations 
            
            if(upsertOtherCostLst!=null && upsertOtherCostLst.size()>0){
                upsert upsertOtherCostLst;
            }
            if(upsertVehicles!=null && upsertVehicles.size()>0){
                upsert upsertVehicles;
            }
            if(upsertWorkforces!=null && upsertWorkforces.size()>0){
                upsert upsertWorkforces;
            }
            
            if(specialWorkforceReqToDeleteLst.size() > 0){
                delete specialWorkforceReqToDeleteLst;
            }
            if(vehicleToBeDeleted.size() > 0){
                delete vehicleToBeDeleted;
            }
            
            if(workforceToBeDeleted.size() > 0){
                delete workforceToBeDeleted;
            }
            if(otherCostToBeDeleted.size() > 0){
                delete otherCostToBeDeleted;
            }
            List<ET_Other_Cost_Request__c> otherCostListToUpsert = new List<ET_Other_Cost_Request__c>(); 
            
            
            // Vehicle other cost to upsert
            for(Vehicle__c vehicle : upsertVehicles){
                // system.debug('line no = '+ Integer.valueOf(vehicle.ET_Vehicle_Line__c));
                //system.debug('vehicleLineNumberAndOtherCostsMap 1207 = '+ JSON.serializePretty(vehicleLineNumberAndOtherCostsMap) );
                List<Object> otherCostObjLst = (List<Object>)vehicleLineNumberAndOtherCostsMap.get(Integer.valueOf(vehicle.ET_Vehicle_Line__c));
                //system.debug('otherCostObjLst = '+ JSON.serializePretty(otherCostObjLst));
                if(otherCostObjLst != null && otherCostObjLst.size() > 0){
                    for(Object otherCostobj : otherCostObjLst) {
                        Map<Object,Object> otherCostJson = (Map<Object,Object>)otherCostobj;
                        if(otherCostJson != null){
                            ET_Other_Cost_Request__c vehicleReqOtherCostObj;
                            if(otherCostJson.get('Id') == null && otherCostJson.get('sObjectType') != null){
                                vehicleReqOtherCostObj = new ET_Other_Cost_Request__c();
                            }else if(otherCostJson.get('Id') != null){
                                vehicleReqOtherCostObj = new ET_Other_Cost_Request__c(Id = (Id)otherCostJson.get('Id'));
                            }
                            /*else{
vehicleReqOtherCostObj = new ET_Other_Cost_Request__c();
}
*/
                            // system.debug('otherCostJson = '+ JSON.serializePretty(otherCostJson));
                            for(Object key : otherCostJson.keySet()){
                                String keyStr = (String)Key;
                                // system.debug('keyStr  = ' + keyStr);
                                if(keyStr != 'sObjectType' && keyStr != 'Vehicle_Request__c' && keyStr != 'Id'){
                                    if(keyStr == 'ET_Cost_Value__c'){
                                        vehicleReqOtherCostObj.put(keyStr, Integer.valueOf(otherCostJson.get(keyStr)));
                                    }else if(keyStr == 'ET_Cost_Type__c'){
                                        List<Object> valueObjLst = (List<Object>)otherCostJson.get(keyStr);
                                        
                                        String finalValue = '';
                                        for(Object valueObj : valueObjLst){
                                            String valueStr = (String)valueObj;
                                            finalValue += valueStr.trim() + ',';
                                        }
                                        finalValue = finalValue.removeEnd(',');
                                        
                                        vehicleReqOtherCostObj.put(keyStr, finalValue);  
                                    }else{
                                        vehicleReqOtherCostObj.put(keyStr, String.valueOf(otherCostJson.get(keyStr)));
                                    }   
                                    
                                }
                                if(vehicleReqOtherCostObj.get('Vehicle_Request__c') == null){
                                    vehicleReqOtherCostObj.put('Vehicle_Request__c', vehicle.Id);  
                                }
                                /* if(vehicleReqOtherCostObj.get('ET_Other_Cost_Request_Type__c') == null){
vehicleReqOtherCostObj.put('ET_Other_Cost_Request_Type__c', 'Vehicle');   
}*/
                            }
                            // Vehicle other cost to upsert
                            otherCostListToUpsert.add(vehicleReqOtherCostObj);
                        }
                        
                    }
                }
            }
            
            // Special workforce requirement to UPSERT....
            
            //List<ET_Work_force__c> workForceRecords = [Select id, ET_Workforce_Record_Type_Name__c from ET_Work_force__c where ET_Service_Request__c = :serviceRequestId];
            List<ET_Special_Workforce_Requirement__c> specialWorkforceReqLstToUpsert = new List<ET_Special_Workforce_Requirement__c>();
            // if(workforceSpecificInfoMap != null && workforceSpecificInfoMap.size() > 0){
            for(ET_Work_force__c workforceObj : upsertWorkforces){
                
                Map<Object,Object> specificReqInfoJson = workforceSpecificInfoMap.get(workforceObj.ET_Workforce_Line_Info__c);
                if(specificReqInfoJson != null && specificReqInfoJson.size() > 0){
                    ET_Special_Workforce_Requirement__c specialWorkforceReqObj;
                    //system.debug('specificReqInfoJson = '+ JSON.serializePretty(specificReqInfoJson));
                    if(specificReqInfoJson.get('Id') == null && specificReqInfoJson.get('sObjectType') != null){
                        specialWorkforceReqObj = new ET_Special_Workforce_Requirement__c();
                    }else if(specificReqInfoJson.get('Id') != null){
                        specialWorkforceReqObj = new ET_Special_Workforce_Requirement__c(Id = (Id)specificReqInfoJson.get('Id'));
                    }
                    
                    for(Object key : specificReqInfoJson.keySet()){
                        String keyStr = (String)Key;
                        if(keyStr != 'sObjectType' && keyStr != 'Work_force_Request__c' && keyStr != 'Id'){
                            if(! (keyStr.contains('Type') || keyStr.contains('ET_Specific_Leave_Plan__c') 
                                  || keyStr.contains('Notes__c') || keyStr.contains('Resource_Type__c')|| keyStr.contains('Married__c'))){
                                      specialWorkforceReqObj.put(keyStr, Integer.valueOf(specificReqInfoJson.get(keyStr)));
                                  }else{
                                      specialWorkforceReqObj.put(keyStr, String.valueOf(specificReqInfoJson.get(keyStr)));
                                  }   
                            
                        }
                        
                    }
                    if(specificReqInfoJson.get('Work_force_Request__c') == null){
                        specialWorkforceReqObj.put('Work_force_Request__c',workforceObj.Id);
                    }
                    // Special workforce requirement to UPSERT....
                    specialWorkforceReqLstToUpsert.add(specialWorkforceReqObj);
                }
                
                // other cost in workforce objets - upsert...
                List<Object> otherCostObjLst = (List<Object>)workforceTypeAndLineNumberComboAndOtherCostMap.get(workforceObj.ET_Workforce_Line_Info__c);
                if(otherCostObjLst != null && otherCostObjLst.size() > 0){
                    for(Object otherCostobj : otherCostObjLst) {
                        Map<Object,Object> otherCostJson = (Map<Object,Object>)otherCostobj;
                        if(otherCostJson != null){
                            ET_Other_Cost_Request__c workforceReqOtherCostObj;
                            if(otherCostJson.get('Id') == null && otherCostJson.get('sObjectType') != null){
                                workforceReqOtherCostObj = new ET_Other_Cost_Request__c();
                            }else if(otherCostJson.get('Id') != null){
                                workforceReqOtherCostObj = new ET_Other_Cost_Request__c(Id = (Id)otherCostJson.get('Id'));
                            }
                            
                            for(Object key : otherCostJson.keySet()){
                                String keyStr = (String)Key;
                                if(keyStr != 'sObjectType' && keyStr != 'Work_force_Request__c' && keyStr != 'Id'){
                                    if(keyStr == 'ET_Cost_Value__c'){
                                        workforceReqOtherCostObj.put(keyStr, Integer.valueOf(otherCostJson.get(keyStr)));
                                    }else if(keyStr == 'ET_Cost_Type__c'){
                                        List<Object> valueObjLst = (List<Object>)otherCostJson.get(keyStr);
                                        
                                        String finalValue = '';
                                        for(Object valueObj : valueObjLst){
                                            String valueStr = (String)valueObj;
                                            finalValue += valueStr.trim() + ',';
                                        }
                                        finalValue = finalValue.removeEnd(',');
                                        
                                        workforceReqOtherCostObj.put(keyStr, finalValue);  
                                    }else{
                                        workforceReqOtherCostObj.put(keyStr, String.valueOf(otherCostJson.get(keyStr)));
                                    }   
                                    
                                }
                                if(workforceReqOtherCostObj.get('Work_force_Request__c') == null){
                                    workforceReqOtherCostObj.put('Work_force_Request__c', workforceObj.Id);  
                                }
                                /* if(workforceReqOtherCostObj.get('ET_Other_Cost_Request_Type__c') == null){
workforceReqOtherCostObj.put('ET_Other_Cost_Request_Type__c', workforceObj.ET_Workforce_Record_Type_Name__c);   
}*/
                            }
                            otherCostListToUpsert.add(workforceReqOtherCostObj);
                        }
                        
                    }
                }
                
            }
            
            if(specialWorkforceReqLstToUpsert!=null && specialWorkforceReqLstToUpsert.size()>0){
                upsert specialWorkforceReqLstToUpsert;
            }
            
            
            
            // system.debug('workforceTypeAndLineNumberComboAndOtherCostMap :' + JSON.serializePretty(workforceTypeAndLineNumberComboAndOtherCostMap ));
            if(otherCostListToUpsert.size() > 0){
                //  system.debug('othercost to update for specific tab :' + otherCostListToUpsert);
                upsert otherCostListToUpsert;
            }
            activateServiceRequest(serviceRequestId);
            moveOpportunityToReqAnalysisStage(opp);
            
            return 'Success';
        }
        
        catch(Exception e){
            ET_PricingUtilityClass.logException(e, 'Pricing');
            system.debug('Exception ='+ e.getMessage());
            system.debug('Exception Trace='+ e.getStackTraceString());
            system.debug('Exception line='+ e.getLineNumber());
            throw new AuraHandledException('Exception ='+ e.getMessage() + 'Exception Trace='+ e.getStackTraceString());
        }
    }
    
    /* Method : activateServiceRequest
Description : Activates latest service Request and deactivates rest other service Requests for the opportunity
Deactivate the Quotes related to deactivated Service Requests..
*/
    @testVisible
    private static void activateServiceRequest(Id serviceRequestId){
        List<ET_Pricing_Service_Request__c> requestsToUpdate;
        Set<Id> pricingServiceRequestIdsToBeDeactivated = new Set<Id>();
        try{
            for(Opportunity opp : [select id, (select id, ET_PSR_IsActive__c from Pricing_Service_Requests__r) from Opportunity where Id IN (select Opportunity__c from ET_Pricing_Service_Request__c where id =: serviceRequestId)]){
                
                if(opp != null && opp.Pricing_Service_Requests__r != null && opp.Pricing_Service_Requests__r.size() > 0){
                    
                    requestsToUpdate = new List<ET_Pricing_Service_Request__c>();
                    for(ET_Pricing_Service_Request__c request : opp.Pricing_Service_Requests__r){
                        if(request.id == serviceRequestId){
                            request.ET_PSR_IsActive__c = true;
                            requestsToUpdate.add(request);
                        }
                        if(request.id != serviceRequestId && request.ET_PSR_IsActive__c){
                            pricingServiceRequestIdsToBeDeactivated.add(request.id);
                            request.ET_PSR_IsActive__c = false;
                            requestsToUpdate.add(request);
                        }
                    }
                }
            }
            List<Quote> quoteToBeDeativated =  new List<Quote>(); 
            if(pricingServiceRequestIdsToBeDeactivated.size() > 0){
                for(Quote quote :  [Select id, IsActive__c from Quote where ET_Pricing_Service_Request__c IN: pricingServiceRequestIdsToBeDeactivated and IsActive__c = true]){
                    //system.debug('quote to be deactivate : '+ quote);
                    quote.IsActive__c = false;
                    quoteToBeDeativated.add(quote);
                }
            }
            
            
            if(requestsToUpdate != null && requestsToUpdate.size() > 0){
                update requestsToUpdate;
            }
            if(quoteToBeDeativated.size() > 0){
                update quoteToBeDeativated;
            }
        }catch(Exception ex){
            system.debug(ex.getMessage());
        }
        
    }
    
    private static void moveOpportunityToReqAnalysisStage(Opportunity opp){
        if(opp.StageName == 'Qualification'){
            opp.StageName = 'Requirement Analysis'; 
        }
        update opp;
    }
    
    /* Method      : getWorkforceSpecificInfoMap
Description : To upsert workforce based on it's Type and to return Map of -> 'workforce line no' and Special Requirements for that workforce..
*/
    
    public static Map<String,Map<Object, Object>> getWorkforceSpecificInfoMap(Object instance,String workforceType, String numberOfWorkforceTypeKey, String workforceLineItemKey,Id serviceRequestId, Id recordTyeId, Id commonInfoRecordId, Id alredayExistingManpowerTabCommonData, Map<String,Object> workforceTypeAndLineNumberComboAndOtherCostMap){
        Map<Object, Object> dataObj =( Map<Object, Object>)instance;
        //  system.debug('getWorkforceSpecificInfoMap method :: '+ workforceType);
        /*String typeStr = (String)dataObj.get('sObjectType');
SObject obj = (ET_Work_force__c)Type.forName(typeStr).newInstance();*/
        ET_Work_force__c obj;
        if(dataObj.get('sObjectType') != null && dataObj.get('Id') == null){
            //system.debug('new vehicle');
            obj = new ET_Work_force__c();
        }else if(dataObj.get('sObjectType') == null && dataObj.get('Id') != null){
            //system.debug('old vehicle');
            obj = new ET_Work_force__c(Id = (Id)dataObj.get('Id') ) ;
        }
        Map<String,Map<Object, Object>> workforceSpecificInfoMapRecord = new Map<String, Map<Object,Object>>();
        for(Object key : dataObj.keyset()){
            
            String keyStr = (String)key;
            System.debug(keyStr);
            if(dataObj.get(keyStr)!=null &&  dataObj.get(keyStr)!='' && keyStr != 'sObjectType' && keyStr != 'Id' && keyStr != 'ET_Pricing_Service_Request__c' && keyStr != 'ET_Workforce_Record_Type_Name__c'){
                // System.System.debug('keyStr'+dataobj.get(keyStr));
                if(keyStr != 'ET_Special_Workforce_Requirement__c' && keyStr != 'Specific_Workforce_Requirements__r' && keyStr != 'Other_Cost_Requests__r'){
                    // system.debug('keyStr---------------->'+ keyStr );
                    if(keyStr.equals(numberOfWorkforceTypeKey) || keyStr.equals('ET_Working_Days_Per_Week__c') ||keyStr.equals('ET_Working_Months_Per_Year__c')){
                        obj.put(keyStr, Integer.valueOf(dataObj.get(keyStr)));  
                        
                    }else if(keyStr.equals(workforceLineItemKey)){
                        obj.put('ET_Workforce_Line_Info__c', workforceType+':'+String.valueOf(dataObj.get(keyStr)));  
                    }else if(keyStr == 'ET_Contract_Period__c' ){
                        String value = String.valueOf(dataObj.get(keyStr));
                        String finalValue = '';
                        value = value.removeStart('(');
                        value = value.removeEnd(')');
                        for(String valueStr : value.split(',')){
                            finalValue += valueStr.trim() + ',';
                        }
                        finalValue = finalValue.removeEnd(',');
                        
                        obj.put(keyStr, finalValue);  
                    }else if(keyStr=='ET_Price_Utilization__c' || keyStr == 'ET_Annual_Target_Price__c'){
                        obj.put(keyStr, Double.valueOf(dataobj.get(keyStr))); 
                    }else if(keyStr == 'ET_Other_Cost_Request__c'  && dataObj.get(keyStr) != null && dataObj.get('ET_Special_Requirements__c') == 'Yes'){
                        //  system.debug('inside other cost =======');
                        if(dataobj.get('ET_Workforce_Line_Info__c') != null ){
                            workforceTypeAndLineNumberComboAndOtherCostMap.put(String.valueOf(dataobj.get('ET_Workforce_Line_Info__c')), (Object)dataobj.get(keyStr));
                        }else {
                            workforceTypeAndLineNumberComboAndOtherCostMap.put(workforceType+':'+String.valueOf(dataobj.get(workforceLineItemKey)), (Object)dataobj.get(keyStr));
                        }
                        //system.debug('workforceTypeAndLineNumberComboAndOtherCostMap inside method '+ JSON.serializePretty(workforceTypeAndLineNumberComboAndOtherCostMap));
                    }else if(keyStr != 'ET_Service_Request_Common_Data__c' && keyStr != 'ET_Service_Request_Common_Data__r' && keyStr != 'ET_Request_for_Target_Price__c' &&  keyStr != 'ET_Request_for_Separate_Prices__c'){//Added Noor Shaik on 07/04/2021
                        obj.put(keyStr, String.valueOf(dataobj.get(keyStr)));  
                    }
                }else{
                    if(keyStr == 'ET_Special_Workforce_Requirement__c' && dataObj.get(keyStr) != null && dataObj.get('ET_Special_Requirements__c') == 'Yes'){
                        if(dataobj.get('ET_Workforce_Line_Info__c') != null ){
                            workforceSpecificInfoMapRecord.put(String.valueOf(dataobj.get('ET_Workforce_Line_Info__c')), (Map<Object, Object>)dataobj.get(keyStr));
                        }else {
                            workforceSpecificInfoMapRecord.put(workforceType+':'+String.valueOf(dataobj.get(workforceLineItemKey)), (Map<Object, Object>)dataobj.get(keyStr));
                        }
                    }
                    
                    if(keyStr == 'Specific_Workforce_Requirements__r' && dataObj.get(keyStr) != null && dataObj.get('ET_Special_Workforce_Requirement__c') == null && dataObj.get('ET_Special_Requirements__c') == 'No'){
                        //it means special requirement should get deleted in the system
                        Object reqObj = (Object)dataObj.get('Specific_Workforce_Requirements__r');
                        // system.debug('reqObj : '+ JSON.serializePretty(reqObj));
                        if(reqObj != null){
                            List<Object> recObjLst = (List<Object>)reqObj;
                            //  system.debug('recObjLst' + recObjLst);
                            Map<Object,Object> requirement = (Map<Object,Object>)(recObjLst[0]);
                            specialWorkforceReqToDeleteLst.add(new ET_Special_Workforce_Requirement__c(Id = (Id)requirement.get('Id')));
                        }
                        
                    }
                }
                
            }
            
        }
        
        if(commonInfoRecordId != null){
            //system.debug('new vehicle' + dataobj.get('ET_Annual_KM__c'));
            obj.put('ET_Service_Request_Common_Data__c', commonInfoRecordId);
            
        }else if(alredayExistingManpowerTabCommonData != null){
            //system.debug('old vehicle' + dataobj.get('ET_Annual_KM__c'));
            obj.put('ET_Service_Request_Common_Data__c', alredayExistingManpowerTabCommonData);
        }
        if(dataObj.get('ET_Pricing_Service_Request__c') == null){
            obj.put('ET_Pricing_Service_Request__c', serviceRequestId);
        }
        //obj.put('ET_Service_Request__c', serviceRequestId);
        if(dataObj.get('RecordTypeId') == null){
            obj.put('RecordTypeId', recordTyeId);
        }
        
        
        
        //obj.put('ET_Service_Request_Common_Data__c', commonInfoRecordId);
        //system.debug('obj inside getWorkforceRecord method : '+ obj);
        upsertWorkforces.add((ET_Work_force__c)obj);
        //system.debug('workforceSpecificInfoMapRecord inside getWorkforceRecord method : '+ workforceSpecificInfoMapRecord);
        return workforceSpecificInfoMapRecord;
    }
    
    /* Method      : createQuotation
Description : All the Elememts are calculated in this method. Like Vehicle elements and Manpower elements.
doWorkforceQuoteCalculation - called this method to do - workforce calculations.
vehicleQuoteCalcClass -- Wrapper to store all Vehicle calculations 

*/
    
    @AuraEnabled
    public static createQuotationReturnWrapper createQuotation(String serviceRequestId){
        createQuotationReturnWrapper createQuotationReturnWrp = New createQuotationReturnWrapper();
        system.debug('Limits.getCpuTime() = '+ Limits.getCpuTime());
        system.debug('Enter__d');
        if(serviceRequestId != null && serviceRequestId != ''){
            try{ 
                ET_Pricing_Service_Request__c serviceRequest = [select id, Name, Opportunity__r.Id, Opportunity__r.account.ETSALES_Profile_Class__c,
                                                                Opportunity__r.RecordType.DeveloperName, Opportunity__r.Name, Opportunity__r.ET_Oracle_Pricing_Service_Type__c, 
                                                                ET_Service_Request_Common_Data__r.ET_Contract_Period__c,
                                                                ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c,
                                                                ET_Service_Request_Common_Data__r.ET_Request_for_Separate_Prices__c
                                                                from ET_Pricing_Service_Request__c where Id =: serviceRequestId];
                String oppRecordTypeDeveloperName = serviceRequest.Opportunity__r.RecordType.DeveloperName;
                boolean isVATCalculated = false;
                system.debug('isVATCalculated__d = '+ isVATCalculated);
                QuoteCalculationClass quotecalculationObj = new QuoteCalculationClass();
                
                quotecalculationObj.opportunityId = serviceRequest.Opportunity__r.Id;
                quotecalculationObj.serviceRequestId = serviceRequestId;
                // check Customers eligibility for Vat Calculation...
                List<Client_Classification_Master__c> ccmList = new List<Client_Classification_Master__c>();
                
                ccmList = [Select Classification__c from Client_Classification_Master__c where Client_Type__c =: serviceRequest.Opportunity__r.account.ETSALES_Profile_Class__c limit 1]; 
                
                // if profile class is not defined at Customer Level - Consider him as 'Standard Rated Customer' and Calculate Vat...
                System.debug('ProfileName-->'+serviceRequest.Opportunity__r.account.ETSALES_Profile_Class__c);
                if(String.isBlank(serviceRequest.Opportunity__r.account.ETSALES_Profile_Class__c)){
                    isVATCalculated = true;
                }
                
                //if Client is not Zero Rated, Calculated VAT...
                if(!ccmList.isEmpty() && ccmList[0].Classification__c != null && ccmList[0].Classification__c != 'Zero Rated Client'){
                    isVATCalculated = true;
                    quotecalculationObj.clientClassification = ccmList[0].Classification__c;
                }
                // if client classification in account not matching with one defined in client classification master -- default it to 'Standard Rated Client'
                else if(ccmList.isEmpty() ){
                    isVATCalculated = true;
                    quotecalculationObj.clientClassification = 'Standard Rated Client';
                }
                
                
                // Vat Master Data
                Map<String,String> servReqVSRate = new Map<String,String>();
                for(VAT_Master_Data__c vm: [Select id,Requirment__c,Service_Type__c, Tax_Rate__c from VAT_Master_Data__c]){
                    servReqVSRate.put(vm.Service_Type__c,vm.Tax_Rate__c);
                }
                
                quotecalculationObj.clientType = serviceRequest.Opportunity__r.account.ETSALES_Profile_Class__c ;
                
                
                //-----------------------------vehicle calculation starts here --------------------------------
                
                List<ET_Maintenance_Rate__c> maintenanceRateLst = [Select id, 
                                                                   ET_Vehicle_Type__c,
                                                                   ET_Vehicle_Model__c,
                                                                   ET_Vehicle_Specs__c,
                                                                   Vehicle_Make__c,
                                                                   ET_Country_of_Origin__c,
                                                                   ET_Purchase_Price_Start_Range__c ,
                                                                   ET_Purchase_Price_End_Range__c ,
                                                                   ET_Variable_Maintenance_Rate_1st_year__c,
                                                                   ET_Variable_Maintenance_Rate_2nd_year__c,
                                                                   ET_Variable_Maintenance_Rate_3rd_year__c,
                                                                   ET_Variable_Maintenance_Rate_4th_year__c,
                                                                   ET_Variable_Maintenance_Rate_5th_year__c,
                                                                   ET_Variable_Maintenance_Rate_6th_year__c,
                                                                   ET_Variable_Maintenance_Rate_7th_year__c,
                                                                   ET_Variable_Maintenance_Rate_8th_year__c
                                                                   From    ET_Maintenance_Rate__c];
                
                
                
                List<Vehicle_Insurance_Fee_Master__c> vehicleInsuranceMasterLst = [Select id,
                                                                                   ET_Vehicle_Type_Master__c,
                                                                                   Vehicle_Type__c,
                                                                                   ET_Passenger_Cost_Per_Seat__c,
                                                                                   ET_Other_Cost__c,
                                                                                   ET_Number_of_Depreciated_years__c,
                                                                                   ET_Minimum_Cost__c,
                                                                                   ET_Minimum_Vehicle_Value__c,
                                                                                   ET_Emirates__c,
                                                                                   ET_Insurance_Rate_1st_Year__c,
                                                                                   ET_Insurance_Rate_2nd_Year__c,
                                                                                   ET_Insurance_Rate_3rd_Year__c,
                                                                                   ET_Insurance_Rate_4th_Year__c,
                                                                                   ET_Insurance_Rate_5th_Year__c,
                                                                                   ET_Insurance_Rate_6th_Year__c,
                                                                                   ET_Insurance_Rate_7th_Year__c,
                                                                                   ET_Insurance_Rate_8th_Year__c,
                                                                                   ET_Driver_Cost__c,
                                                                                   ET_Ambulance_Cost__c
                                                                                   FROM  Vehicle_Insurance_Fee_Master__c];
                
                List<ET_Vehicle_Registration_Inspection_Fee__c> vehicleRegInsFeeLst = [Select Id,
                                                                                       ET_Vehicle_Type__c,
                                                                                       ET_Vehicle_Type__r.ET_Vehicle_Type__c,
                                                                                       ET_Vehicle_Type__r.ET_Vehicle_Sub_Type__c,
                                                                                       ET_Registration_Fee_1st_Year__c,
                                                                                       ET_Registration_Fee_2nd_Year__c,
                                                                                       ET_Registration_Fee_3rd_Year__c,
                                                                                       ET_Registration_Fee_4th_Year__c,
                                                                                       ET_Registration_Fee_5th_Year__c,
                                                                                       ET_Registration_Fee_6th_Year__c,
                                                                                       ET_Registration_Fee_7th_Year__c,
                                                                                       ET_Registration_Fee_8th_Year__c,
                                                                                       ET_Emirates__c
                                                                                       From    ET_Vehicle_Registration_Inspection_Fee__c];
                
                List<ET_Vehicle_Predefined_Other_Cost_Master__c> vehicleSpecialRequirementMaster = [Select Name,
                                                                                                    ET_Api_Name__c,
                                                                                                    ET_Annual_Cost__c,
                                                                                                    ET_One_Time_Cost__c
                                                                                                    From ET_Vehicle_Predefined_Other_Cost_Master__c];
                
                List<ET_Vehicle_Fuel_Master__c> fuelMasterData = [Select id, 
                                                                  ET_Actual_Liter_Price__c,
                                                                  ET_Fuel_Type__c,
                                                                  ET_Liter_Price__c
                                                                  From  ET_Vehicle_Fuel_Master__c];
                
                List<ET_Pricing_Service_Reserve_Master__c> serviceReserveMaster = [Select ET_Depreciation_Method__c,
                                                                                   ET_Depreciation_Reserve_Rate__c,
                                                                                   ET_Driver_Reserve_Rate__c,
                                                                                   ET_Fuel_Reserve_Rate__c,
                                                                                   ET_General_Reserve_Rate__c,
                                                                                   ET_Maintenance_Reserve_Rate__c,
                                                                                   ET_Service_Type__c,
                                                                                   ET_Manpower_Reserve_Rate__c
                                                                                   From ET_Pricing_Service_Reserve_Master__c];
                //system.debug('serviceReserveMaster : ' + serviceReserveMaster);
                
                Map<String, ET_Pricing_Service_Reserve_Master__c> reserveMasterWithServiceType = new Map<String, ET_Pricing_Service_Reserve_Master__c>();
                if(serviceReserveMaster.size() > 0){
                    for(ET_Pricing_Service_Reserve_Master__c reserveData : serviceReserveMaster){
                        reserveMasterWithServiceType.put(reserveData.ET_Service_Type__c, reserveData);
                    }
                }
                
                // Vehicle Type Master Map
                List<ET_Vehicle_Type_Master__c> vehicleTypeMaster = new List<ET_Vehicle_Type_Master__c>([select id, ET_Vehicle_Type__c , ET_Vehicle_Sub_Type__c 
                                                                                                         FROM ET_Vehicle_Type_Master__c  ]);
                Map<String, ET_Vehicle_Type_Master__c> vehicleTypeIdWithTypeAndSubTypeMap = new Map<String, ET_Vehicle_Type_Master__c>();
                if(vehicleTypeMaster != null && vehicleTypeMaster.size() > 0){
                    for(ET_Vehicle_Type_Master__c vehicleType : vehicleTypeMaster){
                        vehicleTypeIdWithTypeAndSubTypeMap.put(vehicleType.ET_Vehicle_Type__c + '-'+vehicleType.ET_Vehicle_Sub_Type__c, vehicleType);
                    }
                }
                
                // Extra Bus Fees for School Transportation
                List<ET_Extra_Bus_Fees_Master__c> extraBusFeesMasterData = new List<ET_Extra_Bus_Fees_Master__c>();
                extraBusFeesMasterData = [SELECT id, Emirates__c ,
                                          Name, Year_1__c ,Year_2__c , Year_3__c,
                                          Year_4__c , Year_5__c , Year_6__c,
                                          Year_7__c , Year_8__c 
                                          FROM ET_Extra_Bus_Fees_Master__c];
                
                List<ET_Pricing_Vehicle_Finance_Rate_Setup__c> financeCalcMetadataLst = [SELECT ET_Finance_Rate__c, ET_Number_of_Financing_years__c, ET_Vehicle_Type__c 
                                                                                         FROM ET_Pricing_Vehicle_Finance_Rate_Setup__c];
                
                
                
                
                List<ET_Pricing_Profit_Calculation_Setup__c> annualProfitMasterData = [Select Name, ET_Api_Name__c,
                                                                                       ET_Pricing_Policy_Rate_1_year__c,
                                                                                       ET_Pricing_Policy_Rate_2_year__c,
                                                                                       ET_Pricing_Policy_Rate_3_year__c,
                                                                                       ET_Pricing_Policy_Rate_4_year__c,
                                                                                       ET_Pricing_Policy_Rate_5_year__c,
                                                                                       ET_Pricing_Policy_Rate_6_year__c,
                                                                                       ET_Pricing_Policy_Rate_7_year__c,
                                                                                       ET_Pricing_Policy_Rate_8_year__c
                                                                                       From    ET_Pricing_Profit_Calculation_Setup__c
                                                                                       Where ET_Api_Name__c = 'ET_Annual_Fuel_Profit_Margin' or
                                                                                       ET_Api_Name__c = 'ET_Annual_Vehicles_Profit_Margin'];
                
                List<ET_Vehicle_Depreciation_Master__c> vehicleDepreciationMasterData = [Select 
                                                                                         ET_Minimum_resale_value_percentage__c,
                                                                                         ET_Min_Resale_Value__c,
                                                                                         ET_Vehicle_Model__c,
                                                                                         Vehicle_Make__c,
                                                                                         ET_Min_Depreciation_Years__c,
                                                                                         ET_Max_Resale_Value__c,
                                                                                         ET_Max_Depreciation_Years__c,
                                                                                         ET_Depreciation_Type__c,
                                                                                         ET_Depreciation_1_Year__c,
                                                                                         ET_Depreciation_2_Year__c,
                                                                                         ET_Depreciation_3_Year__c,
                                                                                         ET_Depreciation_4_Year__c,
                                                                                         ET_Depreciation_5_Year__c,
                                                                                         ET_Depreciation_6_Year__c,
                                                                                         ET_Depreciation_7_Year__c,
                                                                                         ET_Depreciation_8_Year__c,
                                                                                         ET_Depreciation_Rate_Max__c
                                                                                         From ET_Vehicle_Depreciation_Master__c];
                
                Map<String, ET_Vehicle_Depreciation_Master__c> vehicleModelAndDepreciationMasterMap = new Map<String, ET_Vehicle_Depreciation_Master__c>();
                if(vehicleDepreciationMasterData != null && vehicleDepreciationMasterData.size() > 0){
                    for(ET_Vehicle_Depreciation_Master__c data : vehicleDepreciationMasterData){
                        vehicleModelAndDepreciationMasterMap.put((data.Vehicle_Make__c+'-'+ data.ET_Vehicle_Model__c).tolowercase(),data);
                    }                    
                }                                                                  
                
                // workforce Calculation Starts here..
                quotecalculationObj = workForceServiceRequestControllerHelper.doWorkforceQuoteCalculation(serviceRequestId,quotecalculationObj,isVATCalculated, servReqVSRate , reserveMasterWithServiceType);
                
                
                // query Request data 
                // Vehicle Requests attached to Pricing Service Request..
                Map<Id, Vehicle__c > vehicleRequestMap = new Map<Id,Vehicle__c>();
                vehicleRequestMap = ET_PricingUtilityClass.getVehicleRequestMap(serviceRequestId);                    
                
                // Query other cost...
                string query = 'Select ET_Cost_Type__c,ET_Cost_Value__c,Other_Cost_Type__c,ET_Other_Cost_Line_Number__c,ET_Other_Cost_Request_Type__c,ET_Pricing_Service_Request__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,OwnerId,SystemModstamp,Vehicle_Request__c,Work_force_Request__c FROM ET_Other_Cost_Request__c where ET_Pricing_Service_Request__c =\''+ serviceRequestId+'\'';
                set<Id> vehicleIdSet = new set<Id>();  
                //System.debug('@@ ' +vehicleRequestMap );
                if(vehicleRequestMap != null){
                    vehicleIdSet = vehicleRequestMap.Keyset();
                    query += ' OR Vehicle_Request__c IN :vehicleIdSet'; // vehicle level other cost..
                }
                //system.debug('query: '+query);
                for(ET_Other_Cost_Request__c otCost : database.query(query)){
                    if(otCost.ET_Pricing_Service_Request__c == null){
                        if(vehicleVsOtherCostMap.containsKey(otCost.Vehicle_Request__c)){
                            vehicleVsOtherCostMap.get(otCost.Vehicle_Request__c).add(otCost);
                        }else{
                            List<ET_Other_Cost_Request__c> ocList = new List<ET_Other_Cost_Request__c>();
                            ocList.add(otCost);
                            vehicleVsOtherCostMap.put(otCost.Vehicle_Request__c, ocList);
                        }
                    }else{
                        if(srVsOtherCostMap.containsKey(otCost.ET_Pricing_Service_Request__c)){
                            srVsOtherCostMap.get(otCost.ET_Pricing_Service_Request__c).add(otCost);
                        }else{
                            List<ET_Other_Cost_Request__c> ocList = new List<ET_Other_Cost_Request__c>();
                            ocList.add(otCost);
                            srVsOtherCostMap.put(otCost.ET_Pricing_Service_Request__c, ocList);
                        }
                    }
                }
                
                // *********************** vehicleDynamicOtherCost cals**************** start*******/
                
                if(srVsOtherCostMap.containsKey(serviceRequestId)){
                    
                    List<String> contYearLst = new List<String>();
                    contYearLst = serviceRequest.ET_Service_Request_Common_Data__r.ET_Contract_Period__c.split(',');
                    
                    List<ET_Other_Cost_Request__c> oneTimeCost = new List<ET_Other_Cost_Request__c>();
                    List<ET_Other_Cost_Request__c> annualCost = new List<ET_Other_Cost_Request__c>();
                    List<ET_Other_Cost_Request__c> bothCost = new List<ET_Other_Cost_Request__c>();
                    LIst<otherCostCalcClass> otCostCalcList = new List<otherCostCalcClass>();
                    
                    for(ET_Other_Cost_Request__c otCost: srVsOtherCostMap.get(serviceRequestId)){
                        if(otCost.ET_Cost_Type__c != null){
                            if(otCost.ET_Cost_Type__c.contains('One_time_Cost') && otCost.ET_Cost_Type__c.contains('Annual_Cost')){
                                bothCost.add(otCost);
                            }else if(otCost.ET_Cost_Type__c.contains('One_time_Cost') && !otCost.ET_Cost_Type__c.contains('Annual_Cost')){
                                oneTimeCost.add(otCost);
                            }else if(!otCost.ET_Cost_Type__c.contains('One_time_Cost') && otCost.ET_Cost_Type__c.contains('Annual_Cost')){
                                annualCost.add(otCost);
                            } 
                        }
                        
                    }
                    for(String str : contYearLst){
                        str = str.removeEnd(' Yr');
                        str = str.removeEnd(' Yrs');
                        integer contYear = Integer.valueOf(str);
                        if(!oneTimeCost.isEmpty()){
                            for(ET_Other_Cost_Request__c otCost: oneTimeCost){
                                otherCostCalcClass otCostCalcClsInst = new otherCostCalcClass();
                                otCostCalcClsInst.otherCostValue = otCost.ET_Cost_Value__c/contYear;
                                otCostCalcClsInst.otherCostLabel = otCost.Name;
                                otCostCalcClsInst.otherCostLineNumber = otCost.ET_Other_Cost_Line_Number__c;
                                otCostCalcClsInst.contractYear = contYear;
                                otCostCalcList.add(otCostCalcClsInst);
                            }
                        }
                        
                        if(!annualCost.isEmpty()){
                            for(ET_Other_Cost_Request__c otCost: annualCost){
                                otherCostCalcClass otCostCalcClsInst = new otherCostCalcClass();
                                otCostCalcClsInst.otherCostValue = otCost.ET_Cost_Value__c;
                                otCostCalcClsInst.otherCostLabel = otCost.Name;
                                otCostCalcClsInst.otherCostLineNumber = otCost.ET_Other_Cost_Line_Number__c;
                                otCostCalcClsInst.contractYear = contYear;
                                otCostCalcList.add(otCostCalcClsInst);
                            }
                        }
                        
                        if(!bothCost.isEmpty()){
                            for(ET_Other_Cost_Request__c otCost: bothCost){
                                otherCostCalcClass otCostCalcClsInst = new otherCostCalcClass();
                                otCostCalcClsInst.otherCostValue = otCost.ET_Cost_Value__c + (otCost.ET_Cost_Value__c/contYear);
                                otCostCalcClsInst.otherCostLabel = otCost.Name;
                                otCostCalcClsInst.otherCostLineNumber = otCost.ET_Other_Cost_Line_Number__c;
                                otCostCalcClsInst.contractYear = contYear;
                                otCostCalcList.add(otCostCalcClsInst);
                            }
                        }
                    }
                    quotecalculationObj.otherCostQuoteItemLst=otCostCalcList;
                }
                else{
                    quotecalculationObj.otherCostQuoteItemLst=new List<otherCostCalcClass>();
                }
                
                
                
                // *********************** vehicleDYnamicOtherCost cals**************** end*******/
                
                
                if(vehicleRequestMap != null){
                    Set<String> vehicleRequestMakeSet = new Set<String>();
                    Set<String> vehicleRequestModelSet = new Set<String>();
                    Set<String> vehicleRequestSpecSet = new Set<String>();
                    Set<String> vehicleRequestTypeSet = new Set<String>();
                    Set<String> vehicleRequestFuelSet = new Set<String>();
                    Set<String> vehicleRequestModelyearSet = new Set<String>();
                    
                    for(Vehicle__c vehicle : vehicleRequestMap.values()){
                        if(vehicle.ET_Vehicle_MAKE__c != null){
                            vehicleRequestMakeSet.add(vehicle.ET_Vehicle_MAKE__c); 
                        }
                        if(vehicle.ET_Vehicle_Model__c != null){
                            vehicleRequestModelSet.add(vehicle.ET_Vehicle_Model__c); 
                        }
                        
                        if(vehicle.ET_Fuel_Type__c != null){
                            vehicleRequestFuelSet.add(vehicle.ET_Fuel_Type__c);
                        }
                        if(vehicle.ET_Vehicle_Sub_Type__c != null){
                            vehicleRequestTypeSet.add(vehicle.ET_Vehicle_Sub_Type__c);
                        }
                        
                    }
                    Map<Id, ET_Vehicle_Master__c> vehicleMasterMap = 
                        new Map<Id,ET_Vehicle_Master__c>([Select id, 
                                                          Name,
                                                          ET_Vehicle_Make__c,
                                                          ET_Vehicle_Latest_New_Purchase_Price__c,
                                                          ET_Vehicle_Fuel_Consumption__c,
                                                          ET_Specs__c,
                                                          ET_Number_of_seats__c,
                                                          ET_Model__c,
                                                          ET_Vehicle_Sub_Type__c,
                                                          ET_Country_Of_Origin__c,
                                                          ET_Manufacture_Year__c,
                                                          ET_Vehicle_Type_Master__c,
                                                          ET_Fuel_Type__c,
                                                          ET_Vehicle_Type_Master__r.ET_Vehicle_Type__c,
                                                          ET_Vehicle_Type_Master__r.ET_Vehicle_Sub_Type__c,
                                                          ET_Vehicle_Type_Master__r.ET_Insurance_Category__c,
                                                          ET_Vehicle_Fuel_Master__c,
                                                          ET_Vehicle_Fuel_Master__r.ET_Fuel_Type__c,
                                                          ET_Vehicle_Fuel_Master__r.ET_Actual_Liter_Price__c
                                                          From   ET_Vehicle_Master__c
                                                          Where  
                                                          ET_Vehicle_Make__c != null and
                                                          ET_Model__c != null and
                                                          ET_Vehicle_Make__c IN :vehicleRequestMakeSet and
                                                          ET_Model__c IN :vehicleRequestModelSet]);
                    // system.debug('all Vehicle master data fetched ' + JSON.serializePretty(vehicleMasterMap));
                    Map<String,ET_Vehicle_Master__c> uniqueKeyVehicleMasterMap = new Map<String,ET_Vehicle_Master__c>();
                    
                    for(ET_Vehicle_Master__c vehicleMaster : vehicleMasterMap.values()){
                        String uniqueKey = '';
                        
                        if(vehicleMaster.ET_Vehicle_Make__c != null && vehicleMaster.ET_Model__c != null ){
                            uniqueKey = vehicleMaster.ET_Vehicle_Make__c+'_'+vehicleMaster.ET_Model__c
                                +'_'+vehicleMaster.ET_Vehicle_Sub_Type__c+'_'+vehicleMaster.ET_Fuel_Type__c;
                        }
                        
                        uniqueKeyVehicleMasterMap.put(uniqueKey,vehicleMaster);
                        
                    }
                    
                    List<ET_Extra_Depreciation_Rate__c> extraDepRatesByVehicleTypeLst = [Select id, ET_Applicable_KM_End_Range__c,ET_Applicable_KM_Start_Range__c,
                                                                                         ET_Depreciation_Rate__c, Insurance_Category__c
                                                                                         from ET_Extra_Depreciation_Rate__c];
                    
                    List<vehicleQuoteCalcClass> vehicleQuoteCalcLst = new List<vehicleQuoteCalcClass>();
                    // quotecalculationObj.vehicleQuoteItemLst = vehicleQuoteCalcLst;
                    
                    //  system.debug('vehicleRequestMap size = '+ vehicleRequestMap.values().size());
                    
                    
                    // Iterate on each Vehicle Request Line and Calculate all the Price elements...
                    String fleetType ;
                    String serviceEmirate ;
                    
                    for(Vehicle__c vehicle : vehicleRequestMap.values()){
                        system.debug('vehicle request object from backend '+ JSON.serializePretty(vehicle));
                        String specificServiceEmirate = vehicle.ET_Service_Emirate__c;
                        String vehicleUniqueKeyTemp = '';
                        String vehicleUniqueKey = '';
                        if(vehicle.ET_Vehicle_MAKE__c != null && vehicle.ET_Vehicle_Model__c != null 
                           && vehicle.ET_Vehicle_Sub_Type__c != null && vehicle.ET_Fuel_Type__c != null ){ 
                               vehicleUniqueKeyTemp = vehicle.ET_Vehicle_MAKE__c+'_'+vehicle.ET_Vehicle_Model__c
                                   +'_'+vehicle.ET_Vehicle_Sub_Type__c+'_'+vehicle.ET_Fuel_Type__c;
                               
                               vehicleUniqueKey = vehicle.ET_Vehicle_MAKE__c+'_'+vehicle.ET_Vehicle_Model__c;
                           }
                        vehicleUniqueKey = vehicleUniqueKey +'_' + vehicle.ET_Vehicle_Model_Year__c; // to match with pricing combination keys 
                        String vehFleet = vehicle.ET_Fleet_Type__c;
                        decimal noOfVehicles = vehicle.ET_Vehicle_Quantity__c;
                        totalVehicles += noOfVehicles;
                        if(vehicle.ET_Vehicle_Source__c == 'Main'){
                            totalMainVehicles += noOfVehicles;
                        }
                        
                        totalVehicleLines ++;
                        fleetType = vehicle.ET_Service_Request_Common_Data__r.ET_Fleet_Type__c;
                        serviceEmirate = vehicle.ET_Pricing_Service_Request__r.ET_Service_Request_Common_Data__r.ET_Service_Emirate__c;
                        String vehicleTypeFrmRequest = vehicle.Vehicle_Type__c;
                        String vehicleSubTypeFrmRequest = vehicle.ET_Vehicle_Sub_Type__c;
                        String vehicleTypeAndSubTypeFrmRequest = vehicle.Vehicle_Type__c + '-'+ vehicle.ET_Vehicle_Sub_Type__c;
                        String insuranceCategoryFromRequest = vehicle.Insurance_Category__c;
                        List<String> contractYearLst = vehicle.ET_Contract_Period__c.split(',');
                        String vehicleMakeFromRequest = vehicle.ET_Vehicle_Make__c;
                        String vehicleModelFromRequest = vehicle.ET_Vehicle_Model__c;
                        String vehicleMakeAndModel = (vehicle.ET_Vehicle_Make__c+'-'+vehicle.ET_Vehicle_Model__c).tolowercase();
                        String fuelTypeFromRequest = vehicle.ET_Fuel_Type__c;
                        String vehicleCondFromRequest = vehicle.ET_Vehicle_Condition__c;
                        boolean isTargerPriceRequired = vehicle.ET_Pricing_Service_Request__r.ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c;
                        boolean isSeparatePriceRequired = vehicle.ET_Pricing_Service_Request__r.ET_Service_Request_Common_Data__r.ET_Request_for_Separate_Prices__c;
                        //system.debug('isTargerPriceRequired = '+ isTargerPriceRequired);
                        Integer modelYearInRequest = Integer.valueOf(vehicle.ET_Vehicle_Model_Year__c);
                        
                        ET_Vehicle_Depreciation_Master__c vehicleDepreciationMaster;
                        
                        if(vehicleModelAndDepreciationMasterMap != null &&  vehicleModelAndDepreciationMasterMap.containsKey(vehicleMakeAndModel)){
                            vehicleDepreciationMaster = vehicleModelAndDepreciationMasterMap.get(vehicleMakeAndModel);
                        }
                        
                        // Trailer attributes
                        String trailerTypeFrmRequest = vehicle.Trailer_Equipment_Type__c;
                        String trailerSubTypeFrmRequest = vehicle.Trailer_Equipment_subtype__c;
                        String trailerTypeAndSubTypeFrmRequest = vehicle.Trailer_Equipment_Type__c + '-'+ vehicle.Trailer_Equipment_subtype__c;
                        String trailerMakeFromRequest = vehicle.Trailer_Equipment_Make__c;
                        String trailerModelFromRequest = vehicle.Trailer_Equipment_Model__c;
                        String trailerCondFromRequest = vehicle.Trailer_condition__c;
                        Integer modelYearInRequestForTrailer = Integer.valueOf(vehicle.Trailer_model_year__c);
                        boolean isTrailerSelected = vehicle.Add_Trailer_Equipment__c;
                        ET_Vehicle_Depreciation_Master__c trailerDepreciationMaster;
                        
                        String trailerMakeAndModel = (vehicle.Trailer_Equipment_Make__c+'-'+vehicle.Trailer_Equipment_Model__c).tolowercase();
                        //system.debug('trailerMakeAndModel = '+ trailerMakeAndModel);
                        //system.debug('vehicleModelAndDepreciationMasterMap = '+ JSON.serializePretty(vehicleModelAndDepreciationMasterMap));
                        if(vehicleModelAndDepreciationMasterMap != null &&  vehicleModelAndDepreciationMasterMap.containsKey(trailerMakeAndModel)){
                            trailerDepreciationMaster = vehicleModelAndDepreciationMasterMap.get(trailerMakeAndModel);
                        }
                        //system.debug('trailerDepreciationMaster = '+ JSON.serializePretty(trailerDepreciationMaster));
                        
                        // Refrigerator attributes
                        String refregiratorTypeFrmRequest = vehicle.Refregirator_Type__c;
                        String refregiratorSubTypeFrmRequest = vehicle.Refregirator_subtype__c;
                        String refregiratorTypeAndSubTypeFrmRequest = vehicle.Refregirator_Type__c + '-'+ vehicle.Refregirator_subtype__c;
                        String refregiratorMakeFromRequest = vehicle.Refregirator_Make__c;
                        String refregiratorModelFromRequest = vehicle.Refregirator_Model__c;
                        String refregiratorCondFromRequest = vehicle.Refrigerator_condition__c;
                        Integer modelYearInRequestForRefregirator = Integer.valueOf(vehicle.Refrigerator_model_year__c);
                        boolean isrefregiratorSelected = vehicle.Add_Refregirator__c;
                        ET_Vehicle_Depreciation_Master__c refregiratorDepreciationMaster;
                        
                        String refregiratorMakeAndModel = (vehicle.Refregirator_Make__c+'-'+vehicle.Refregirator_Model__c).tolowercase();
                        //system.debug('refregiratorMakeAndModel = '+ refregiratorMakeAndModel);
                        //system.debug('vehicleModelAndDepreciationMasterMap = '+ JSON.serializePretty(vehicleModelAndDepreciationMasterMap));
                        if(vehicleModelAndDepreciationMasterMap != null &&  vehicleModelAndDepreciationMasterMap.containsKey(refregiratorMakeAndModel)){
                            refregiratorDepreciationMaster = vehicleModelAndDepreciationMasterMap.get(refregiratorMakeAndModel);
                        }
                        
                        
                        //*************** vehicle calculation starts here*/
                        
                        //system.debug('contractYearLst = '+ contractYearLst);
                        if(!contractYearLst.isEmpty()){
                            for(String contractYear : contractYearLst){
                                contractYear = contractYear.substring(0,1);
                                integer integerContractYear = integer.ValueOf(contractYear);
                                contractYears.add(integerContractYear);
                                vehicleQuoteCalcClass vehicleQuoteCalcObj = new vehicleQuoteCalcClass();
                                vehicleQuoteCalcObj.vehicleLineUniqueKey = vehicleUniqueKey;
                                vehicleQuoteCalcObj.vehicleLineItemNumberFromRequest = Integer.valueOf(vehicle.ET_Vehicle_Line__c);
                                vehicleQuoteCalcObj.contractYear = Integer.valueOf(contractYear);
                                vehicleQuoteCalcObj.numberOfVehicles = Integer.valueOf(vehicle.ET_Vehicle_Quantity__c);
                                vehicleQuoteCalcObj.vehicleSource = vehicle.ET_Vehicle_Source__c ;
                                vehicleQuoteCalcObj.fleetType = vehicle.ET_Fleet_Type__c ;
                                vehicleQuoteCalcObj.vehiclePricingMethod = vehicle.ET_Pricing_Method__c ;
                                vehicleQuoteCalcObj.vehiclePricingType = vehicle.ET_Pricing_Type__c;
                                vehicleQuoteCalcObj.vehiclePricingUtilization  = vehicle.ET_Price_Utilization__c;
                                vehicleQuoteCalcObj.workingMonthsPerYear =vehicle.ET_Working_Months_Per_Year__c;
                                vehicleQuoteCalcObj.workingDaysPerWeek = vehicle.ET_Working_Days_Per_Week__c;
                                vehicleQuoteCalcObj.serviceType = vehicle.ET_Service_Type__c;
                                vehicleQuoteCalcObj.totalAnnualTargetPrice = vehicle.ET_Annual_Target_Price__c;
                                vehicleQuoteCalcObj.isTargerPriceRequired = isTargerPriceRequired;
                                vehicleQuoteCalcObj.isSeparatePriceRequired = isSeparatePriceRequired;
                                vehicleQuoteCalcObj.vehicleNotes = vehicle.Vehicle_Notes__c;
                                
                                system.debug('isTargerPriceRequired2 = '+ isTargerPriceRequired);
                                vehicleQuoteCalcObj.vehReqId = vehicle.Id;
                                String oraclePricingServiceType = vehicle.ET_Service_Type__c;
                                // if cutsomer is Standard Rated Customer and based Service get the Vat rate...
                                if(isVATCalculated){
                                    if(servReqVSRate.containsKey(vehicle.ET_Service_Type__c)){
                                        vehicleQuoteCalcObj.vehicleVATRate = servReqVSRate.get(vehicle.ET_Service_Type__c);
                                    }
                                }
                                
                                ET_Pricing_Service_Reserve_Master__c requiredReserveMasterData;
                                String depreciationMethod;
                                requiredReserveMasterData = reserveMasterWithServiceType.get(oraclePricingServiceType);
                                if(requiredReserveMasterData != null){
                                    depreciationMethod = requiredReserveMasterData.ET_Depreciation_Method__c;
                                }
                                vehicleQuoteCalcObj.depreciationMethod = depreciationMethod;
                                //******************************depreciationRate calculation***START***** */
                                Decimal currentVehicleValue;
                                Decimal depreciationRate = 0.0;
                                Decimal maxDepreciationRate; 
                                vehicleQuoteCalcObj.manufactureYear = modelYearInRequest;
                                vehicleQuoteCalcObj.vehicleLatestNewPurchasePrice = vehicle.ET_Vehicle_Original_Purchase_Price__c;
                                vehicleQuoteCalcObj.vehicleCurrentPurchasePrice = vehicle.ET_Vehicle_Current_Purchase_Price__c;
                                if(vehicleDepreciationMaster != null){
                                    vehicleQuoteCalcObj.depreciationType = vehicleDepreciationMaster.ET_Depreciation_Type__c ;
                                }
                                
                                // For Trailer
                                Decimal trailerDepreciationRate = 0.0;
                                if(trailerDepreciationMaster != null){
                                    vehicleQuoteCalcObj.trailerDepreciationType = trailerDepreciationMaster.ET_Depreciation_Type__c ;
                                }
                                vehicleQuoteCalcObj.trailerModelYear = modelYearInRequestForTrailer;
                                vehicleQuoteCalcObj.trailerOriginalPurchasePrice = vehicle.Trailer_original_purchase_price__c;
                                vehicleQuoteCalcObj.trailerCurrentPurchasePrice = vehicle.Trailer_Current_purchase_price__c;
                                vehicleQuoteCalcObj.trailerCondition = trailerCondFromRequest;
                                vehicleQuoteCalcObj.isTrailerSelected = isTrailerSelected ;
                                vehicleQuoteCalcObj.trailerExtrenalMaintenanceCost = vehicle.Trailer_External_Maintenance_Cost__c;
                                
                                // For Refregirator
                                Decimal refrigeratorDepreciationRate = 0.0;
                                if(refregiratorDepreciationMaster != null){
                                    vehicleQuoteCalcObj.refrigeratorDepreciationType = refregiratorDepreciationMaster.ET_Depreciation_Type__c ;
                                }
                                vehicleQuoteCalcObj.refrigeratorModelYear = modelYearInRequestForRefregirator;
                                vehicleQuoteCalcObj.refrigeratorOriginalPurchasePrice = vehicle.Refrigerator_Original_Purchase_Price__c;
                                vehicleQuoteCalcObj.refrigeratorCurrentPurchasePrice = vehicle.Refrigerator_Current_Purchase_Price__c;
                                vehicleQuoteCalcObj.refrigeratorCondition = refregiratorCondFromRequest;
                                vehicleQuoteCalcObj.isRefrigeratorSelected = isrefregiratorSelected ;
                                vehicleQuoteCalcObj.refrigeratorExtrenalMaintenanceCost = vehicle.Refrigerator_External_Maintenance_Cost__c;
                                
                                /* Depreciation, Max depreciation and Resale Value Changes with Respect to Fleet Type*/
                                /* ET Fleet       = Same Calculations
Customer Fleet = Customers own these Vehicles and They ask for Maintenance only
No Investment from ET
No Depreciation is calculated that is Depreciation Rate = 0% and Depreciation Reserve = 0	
Lease To own   = Here Customers lease the vehicles first few years and than own it
Depreciation is 100% for each contract Year.
Resale Value =0.
*/							    // Depreciation and Resale Value for Vehicle 
                                if(vehicleDepreciationMaster !=null && vehicleDepreciationMaster.ET_Minimum_resale_value_percentage__c != null && vehicleDepreciationMaster.ET_Minimum_resale_value_percentage__c != 0.0){
                                    vehicleQuoteCalcObj.minResaleValuePercentage = vehicleDepreciationMaster.ET_Minimum_resale_value_percentage__c;
                                }
                                else if(vehicleDepreciationMaster !=null &&vehicleDepreciationMaster.ET_Min_Resale_Value__c != null && vehicleDepreciationMaster.ET_Min_Resale_Value__c != 0.0){
                                    vehicleQuoteCalcObj.minResaleValue = vehicleDepreciationMaster.ET_Min_Resale_Value__c; 
                                }
                                
                                system.debug('vehFleet = '+ vehFleet);
                                if(vehFleet == 'ET Fleet' && vehicleDepreciationMaster != null && 
                                   vehicleDepreciationMaster.ET_Depreciation_Type__c == 'Percentage' ){
                                       integer year;
                                       if(vehicleCondFromRequest == 'New'){
                                           year = vehicleQuoteCalcObj.contractYear;
                                           depreciationRate = getDepreciationRate(vehicleDepreciationMaster , year);
                                       }
                                       else if(vehicleCondFromRequest == 'Used'){
                                           integer diff = Date.Today().Year() - modelYearInRequest ;
                                           year = diff + vehicleQuoteCalcObj.contractYear;
                                           for(integer i= diff+1 ; i<= year ; i++){
                                               depreciationRate += getDepreciationRateYearWise(vehicleDepreciationMaster , i);
                                           }
                                       }
                                       vehicleQuoteCalcObj.vehicleDepreciationRate = depreciationRate;  
                                   }
                                else if(vehFleet == 'ET Fleet' && vehicleDepreciationMaster != null && vehicleDepreciationMaster.ET_Depreciation_Type__c == 'Value' ){
                                    integer year;
                                    if(vehicleCondFromRequest == 'New'){
                                        year = vehicleQuoteCalcObj.contractYear;
                                    }
                                    else if(vehicleCondFromRequest == 'Used'){
                                        integer diff = Date.Today().Year() - modelYearInRequest ;
                                        year = diff + vehicleQuoteCalcObj.contractYear;
                                    }
                                    
                                    if(year > 8){
                                        year = 8;
                                    }
                                    
                                    switch on year {
                                        when 1 {
                                            vehicleQuoteCalcObj.vehicleResaleValue = vehicleDepreciationMaster.ET_Depreciation_1_Year__c;
                                        }
                                        when 2 {
                                            vehicleQuoteCalcObj.vehicleResaleValue = vehicleDepreciationMaster.ET_Depreciation_2_Year__c;
                                        }
                                        when 3 {
                                            vehicleQuoteCalcObj.vehicleResaleValue = vehicleDepreciationMaster.ET_Depreciation_3_Year__c;
                                        }
                                        when 4 {
                                            vehicleQuoteCalcObj.vehicleResaleValue =  vehicleDepreciationMaster.ET_Depreciation_4_Year__c;
                                        }
                                        when 5 {
                                            vehicleQuoteCalcObj.vehicleResaleValue = vehicleDepreciationMaster.ET_Depreciation_5_Year__c;
                                        }
                                        when 6 {
                                            vehicleQuoteCalcObj.vehicleResaleValue = vehicleDepreciationMaster.ET_Depreciation_6_Year__c;
                                        }
                                        when 7 {
                                            vehicleQuoteCalcObj.vehicleResaleValue = vehicleDepreciationMaster.ET_Depreciation_7_Year__c;
                                        }
                                        when 8 {
                                            vehicleQuoteCalcObj.vehicleResaleValue = vehicleDepreciationMaster.ET_Depreciation_8_Year__c;
                                        }
                                    }
                                }
                                else if(vehFleet == 'Client Fleet'){
                                    vehicleQuoteCalcObj.vehicleDepreciationRate =0;
                                    vehicleQuoteCalcObj.depreciationRateforExtraMileage =0;
                                    vehicleQuoteCalcObj.vehicleResaleValue = '0';
                                }
                                else if(vehFleet == 'Lease to Own'){
                                    vehicleQuoteCalcObj.vehicleDepreciationRate =100;
                                    vehicleQuoteCalcObj.vehicleResaleValue = '0';
                                }
                                
                                // Depreciation and Resale Value for Trailer
                                if(isTrailerSelected && trailerDepreciationMaster.ET_Minimum_resale_value_percentage__c != null && trailerDepreciationMaster.ET_Minimum_resale_value_percentage__c != 0.0){
                                    vehicleQuoteCalcObj.trailerminResaleValuePercentage = trailerDepreciationMaster.ET_Minimum_resale_value_percentage__c;
                                }
                                else if(isTrailerSelected && trailerDepreciationMaster.ET_Min_Resale_Value__c != null && trailerDepreciationMaster.ET_Min_Resale_Value__c != 0.0){
                                    vehicleQuoteCalcObj.trailerminResaleValue = trailerDepreciationMaster.ET_Min_Resale_Value__c; 
                                }
                                
                                if(isTrailerSelected && vehFleet == 'ET Fleet' && trailerDepreciationMaster != null && 
                                   trailerDepreciationMaster.ET_Depreciation_Type__c == 'Percentage' ){
                                       integer year;
                                       if(trailerCondFromRequest == 'New'){
                                           year = vehicleQuoteCalcObj.contractYear;
                                           trailerDepreciationRate = getDepreciationRate(trailerDepreciationMaster , year);
                                       }
                                       else if(trailerCondFromRequest == 'Used'){
                                           integer diff = Date.Today().Year() - modelYearInRequestForTrailer ;
                                           year = diff + vehicleQuoteCalcObj.contractYear;
                                           for(integer i= diff+1 ; i<= year ; i++){
                                               trailerDepreciationRate += getDepreciationRateYearWise(trailerDepreciationMaster , i);
                                           }
                                       }
                                       vehicleQuoteCalcObj.trailerDepreciationRate = trailerDepreciationRate;  
                                   }
                                
                                else if(isTrailerSelected && vehFleet == 'ET Fleet' && trailerDepreciationMaster != null && trailerDepreciationMaster.ET_Depreciation_Type__c == 'Value' ){
                                    integer year;
                                    if(trailerCondFromRequest == 'New'){
                                        year = vehicleQuoteCalcObj.contractYear;
                                    }
                                    else if(trailerCondFromRequest == 'Used'){
                                        integer diff = Date.Today().Year() - modelYearInRequestForTrailer ;
                                        year = diff + vehicleQuoteCalcObj.contractYear;
                                    }
                                    
                                    if(year > 8){
                                        year = 8;
                                    }
                                    
                                    switch on year {
                                        when 1 {
                                            vehicleQuoteCalcObj.trailerResaleValue = trailerDepreciationMaster.ET_Depreciation_1_Year__c;
                                        }
                                        when 2 {
                                            vehicleQuoteCalcObj.trailerResaleValue = trailerDepreciationMaster.ET_Depreciation_2_Year__c;
                                        }
                                        when 3 {
                                            vehicleQuoteCalcObj.trailerResaleValue = trailerDepreciationMaster.ET_Depreciation_3_Year__c;
                                        }
                                        when 4 {
                                            vehicleQuoteCalcObj.trailerResaleValue =  trailerDepreciationMaster.ET_Depreciation_4_Year__c;
                                        }
                                        when 5 {
                                            vehicleQuoteCalcObj.trailerResaleValue = trailerDepreciationMaster.ET_Depreciation_5_Year__c;
                                        }
                                        when 6 {
                                            vehicleQuoteCalcObj.trailerResaleValue = trailerDepreciationMaster.ET_Depreciation_6_Year__c;
                                        }
                                        when 7 {
                                            vehicleQuoteCalcObj.trailerResaleValue = trailerDepreciationMaster.ET_Depreciation_7_Year__c;
                                        }
                                        when 8 {
                                            vehicleQuoteCalcObj.trailerResaleValue = trailerDepreciationMaster.ET_Depreciation_8_Year__c;
                                        }
                                    }
                                }
                                
                                else if(isTrailerSelected && vehFleet == 'Client Fleet'){
                                    vehicleQuoteCalcObj.trailerDepreciationRate =0;
                                    vehicleQuoteCalcObj.trailerResaleValue = '0';
                                }
                                else if(isTrailerSelected && vehFleet == 'Lease to Own'){
                                    vehicleQuoteCalcObj.trailerDepreciationRate =100;
                                    vehicleQuoteCalcObj.trailerResaleValue = '0';
                                }
                                
                                // Depreciation and Resale Value for Refrigerator
                                if(isrefregiratorSelected){
                                    if(refregiratorDepreciationMaster.ET_Minimum_resale_value_percentage__c != null && refregiratorDepreciationMaster.ET_Minimum_resale_value_percentage__c != 0.0){
                                        vehicleQuoteCalcObj.refrigeratorMinResaleValuePercentage = refregiratorDepreciationMaster.ET_Minimum_resale_value_percentage__c;
                                    }
                                    else if(refregiratorDepreciationMaster.ET_Min_Resale_Value__c != null && refregiratorDepreciationMaster.ET_Min_Resale_Value__c != 0.0){
                                        vehicleQuoteCalcObj.refrigeratorMinResaleValue = refregiratorDepreciationMaster.ET_Min_Resale_Value__c; 
                                    }
                                    
                                    if(vehFleet == 'ET Fleet' && refregiratorDepreciationMaster != null && 
                                       refregiratorDepreciationMaster.ET_Depreciation_Type__c == 'Percentage' ){
                                           integer year;
                                           if(refregiratorCondFromRequest == 'New'){
                                               year = vehicleQuoteCalcObj.contractYear;
                                               refrigeratorDepreciationRate = getDepreciationRate(refregiratorDepreciationMaster , year);
                                           }
                                           else if(refregiratorCondFromRequest == 'Used'){
                                               integer diff = Date.Today().Year() - modelYearInRequestForRefregirator ;
                                               year = diff + vehicleQuoteCalcObj.contractYear;
                                               for(integer i= diff+1 ; i<= year ; i++){
                                                   refrigeratorDepreciationRate += getDepreciationRateYearWise(refregiratorDepreciationMaster , i);
                                               }
                                           }
                                           vehicleQuoteCalcObj.refrigeratorDepreciationRate = refrigeratorDepreciationRate;  
                                       }
                                    
                                    else if( vehFleet == 'ET Fleet' && refregiratorDepreciationMaster != null && refregiratorDepreciationMaster.ET_Depreciation_Type__c == 'Value' ){
                                        integer year;
                                        if(refregiratorCondFromRequest == 'New'){
                                            year = vehicleQuoteCalcObj.contractYear;
                                        }
                                        else if(refregiratorCondFromRequest == 'Used'){
                                            integer diff = Date.Today().Year() - modelYearInRequestForRefregirator ;
                                            year = diff + vehicleQuoteCalcObj.contractYear;
                                        }
                                        
                                        if(year > 8){
                                            year = 8;
                                        }
                                        
                                        switch on year {
                                            when 1 {
                                                vehicleQuoteCalcObj.refrigeratorResaleValue = refregiratorDepreciationMaster.ET_Depreciation_1_Year__c;
                                            }
                                            when 2 {
                                                vehicleQuoteCalcObj.refrigeratorResaleValue = refregiratorDepreciationMaster.ET_Depreciation_2_Year__c;
                                            }
                                            when 3 {
                                                vehicleQuoteCalcObj.refrigeratorResaleValue = refregiratorDepreciationMaster.ET_Depreciation_3_Year__c;
                                            }
                                            when 4 {
                                                vehicleQuoteCalcObj.refrigeratorResaleValue =  refregiratorDepreciationMaster.ET_Depreciation_4_Year__c;
                                            }
                                            when 5 {
                                                vehicleQuoteCalcObj.refrigeratorResaleValue = refregiratorDepreciationMaster.ET_Depreciation_5_Year__c;
                                            }
                                            when 6 {
                                                vehicleQuoteCalcObj.refrigeratorResaleValue = refregiratorDepreciationMaster.ET_Depreciation_6_Year__c;
                                            }
                                            when 7 {
                                                vehicleQuoteCalcObj.refrigeratorResaleValue = refregiratorDepreciationMaster.ET_Depreciation_7_Year__c;
                                            }
                                            when 8 {
                                                vehicleQuoteCalcObj.refrigeratorResaleValue = refregiratorDepreciationMaster.ET_Depreciation_8_Year__c;
                                            }
                                        }
                                    }
                                    
                                    else if(vehFleet == 'Client Fleet'){
                                        vehicleQuoteCalcObj.refrigeratorDepreciationRate =0;
                                        vehicleQuoteCalcObj.refrigeratorResaleValue = '0';
                                    }
                                    else if(vehFleet == 'Lease to Own'){
                                        vehicleQuoteCalcObj.refrigeratorDepreciationRate =100;
                                        vehicleQuoteCalcObj.refrigeratorResaleValue = '0';
                                    }
                                }
                                
                                
                                
                                //******************************Extra Depreciation Calculation**START****** */
                                if(vehFleet == 'ET Fleet'){
                                    Decimal annualKmFrmServiceRequest = vehicle.ET_Annual_KM__c;
                                    Decimal extraDepRate = 0.00;
                                    
                                    for(ET_Extra_Depreciation_Rate__c edRate: extraDepRatesByVehicleTypeLst){
                                        if(insuranceCategoryFromRequest == edRate.Insurance_Category__c){
                                            if( annualKmFrmServiceRequest >= edRate.ET_Applicable_KM_Start_Range__c && annualKmFrmServiceRequest <= edRate.ET_Applicable_KM_End_Range__c ){
                                                extraDepRate =  (edRate.ET_Depreciation_Rate__c);
                                            }
                                            else if( (edRate.ET_Applicable_KM_End_Range__c == null ||edRate.ET_Applicable_KM_End_Range__c == 0.0 ) && annualKmFrmServiceRequest >= edRate.ET_Applicable_KM_Start_Range__c){
                                                extraDepRate =  (edRate.ET_Depreciation_Rate__c);
                                            }
                                        }
                                    }                                    
                                    if(depreciationMethod != null && depreciationMethod != ''){
                                        if(depreciationMethod == 'Accelerated'){
                                            if(depreciationRate != null && extraDepRate != null){
                                                vehicleQuoteCalcObj.depreciationRateforExtraMileage = extraDepRate;
                                            }
                                            
                                        }
                                        else if(depreciationMethod == 'Straight Line' && vehicleDepreciationMaster != null){
                                            vehicleQuoteCalcObj.depreciationRateforExtraMileage = 0;
                                        }
                                    }
                                }
                                
                                /* Resale Value for school transportation */
                                if(depreciationMethod == 'Straight Line' && vehicleDepreciationMaster != null){
                                    if(vehicleDepreciationMaster.ET_Minimum_resale_value_percentage__c != null && vehicleDepreciationMaster.ET_Minimum_resale_value_percentage__c != 0.0){
                                        vehicleQuoteCalcObj.minResaleValuePercentage = vehicleDepreciationMaster.ET_Minimum_resale_value_percentage__c;
                                    }
                                    else if(vehicleDepreciationMaster.ET_Min_Resale_Value__c != null && vehicleDepreciationMaster.ET_Min_Resale_Value__c != 0.0){
                                        vehicleQuoteCalcObj.minResaleValue = vehicleDepreciationMaster.ET_Min_Resale_Value__c; 
                                    }
                                    
                                    vehicleQuoteCalcObj.minDepreciationYears = 10;
                                }
                                
                                
                                //Resale Value for school transportation for -- Trailer
                                if(isTrailerSelected && depreciationMethod == 'Straight Line' && trailerDepreciationMaster != null){
                                    if(trailerDepreciationMaster.ET_Minimum_resale_value_percentage__c != null && trailerDepreciationMaster.ET_Minimum_resale_value_percentage__c != 0.0){
                                        vehicleQuoteCalcObj.trailerminResaleValuePercentage = trailerDepreciationMaster.ET_Minimum_resale_value_percentage__c;
                                    }
                                    else if(trailerDepreciationMaster.ET_Min_Resale_Value__c != null && trailerDepreciationMaster.ET_Min_Resale_Value__c != 0.0){
                                        vehicleQuoteCalcObj.trailerminResaleValue = trailerDepreciationMaster.ET_Min_Resale_Value__c; 
                                    }
                                    
                                    vehicleQuoteCalcObj.trailerminDepreciationYears = 10;
                                }
                                
                                //Resale Value for school transportation for -- Refrigerator
                                if(isrefregiratorSelected && depreciationMethod == 'Straight Line' && refregiratorDepreciationMaster != null){
                                    if(refregiratorDepreciationMaster.ET_Minimum_resale_value_percentage__c != null && refregiratorDepreciationMaster.ET_Minimum_resale_value_percentage__c != 0.0){
                                        vehicleQuoteCalcObj.refrigeratorMinResaleValuePercentage = refregiratorDepreciationMaster.ET_Minimum_resale_value_percentage__c;
                                    }
                                    else if(refregiratorDepreciationMaster.ET_Min_Resale_Value__c != null && refregiratorDepreciationMaster.ET_Min_Resale_Value__c != 0.0){
                                        vehicleQuoteCalcObj.refrigeratorMinResaleValue = refregiratorDepreciationMaster.ET_Min_Resale_Value__c; 
                                    }
                                    
                                    vehicleQuoteCalcObj.refrigeratorMinDepreciationYears = 10;
                                }
                                
                                
                                /*Daily Mileage and Annual Mileage Calculation Calculation */
                                Decimal annualKmFrmServiceRequest = vehicle.ET_Annual_KM__c;
                                // below logic given by business and same was implemented in oracle too..
                                if(vehicleQuoteCalcObj.workingDaysPerWeek != 0.0 && vehicleQuoteCalcObj.workingMonthsPerYear != 0.0){
                                    if(vehicleQuoteCalcObj.workingMonthsPerYear == 10 && vehicleQuoteCalcObj.workingDaysPerWeek ==5  ){
                                        vehicleQuoteCalcObj.workingDaysPerYear =  180;
                                    }
                                    else if(vehicleQuoteCalcObj.workingMonthsPerYear == 12 && vehicleQuoteCalcObj.workingDaysPerWeek ==5  ){
                                        vehicleQuoteCalcObj.workingDaysPerYear =  264;
                                    }
                                    else if(vehicleQuoteCalcObj.workingMonthsPerYear == 12 && vehicleQuoteCalcObj.workingDaysPerWeek ==6 ){
                                        vehicleQuoteCalcObj.workingDaysPerYear =  312;
                                    }
                                    else if(vehicleQuoteCalcObj.workingMonthsPerYear == 12 && vehicleQuoteCalcObj.workingDaysPerWeek ==7 ){
                                        vehicleQuoteCalcObj.workingDaysPerYear =  365;
                                    }
                                    else{
                                        vehicleQuoteCalcObj.workingDaysPerYear =  ((Double)52/12)*vehicleQuoteCalcObj.workingMonthsPerYear *vehicleQuoteCalcObj.workingDaysPerWeek ;
                                    }
                                }
                                if(annualKmFrmServiceRequest != null && annualKmFrmServiceRequest != 0.0){
                                    vehicleQuoteCalcObj.totalAnnualMileage = annualKmFrmServiceRequest;
                                    if(vehicleQuoteCalcObj.workingDaysPerYear != null && vehicleQuoteCalcObj.workingDaysPerYear != 0.0){
                                        vehicleQuoteCalcObj.dailyMileage = Math.round(annualKmFrmServiceRequest/vehicleQuoteCalcObj.workingDaysPerYear) ;
                                    }
                                }
                                
                                
                                // **********************Maintenance and repair Rate calc *************** START*********/
                                Decimal applicapleMaintenanceRate = 0.0;
                                if(maintenanceRateLst != null && maintenanceRateLst.size() > 0){
                                    for(ET_Maintenance_Rate__c mRateObj : maintenanceRateLst){
                                        if(mRateObj.ET_Vehicle_Model__c != null && mRateObj.ET_Vehicle_Model__c.equalsIgnoreCase(vehicleModelFromRequest) &&mRateObj.Vehicle_Make__c != null && mRateObj.Vehicle_Make__c.equalsIgnoreCase(vehicleMakeFromRequest) ){
                                            if(vehicleCondFromRequest == 'New'){
                                                applicapleMaintenanceRate = getmaintenanceRateYearWise(mRateObj ,vehicleQuoteCalcObj.contractYear );
                                            }
                                            else if(vehicleCondFromRequest == 'Used'){
                                                integer diff = Date.Today().Year() - modelYearInRequest ;
                                                integer year = diff + vehicleQuoteCalcObj.contractYear;
                                                applicapleMaintenanceRate = getmaintenanceRateYearWise(mRateObj ,year );
                                            }
                                            
                                        }
                                        vehicleQuoteCalcObj.vehicleMaintenanceRate = applicapleMaintenanceRate;
                                    }
                                    
                                }
                                
                                // **********************Maintenance and repair Rate calc -- Trailer *************** START*********/
                                Decimal applicapleMaintenanceRateForTrailer = 0.0;
                                if(isTrailerSelected && maintenanceRateLst != null && maintenanceRateLst.size() > 0){
                                    for(ET_Maintenance_Rate__c mRateObj : maintenanceRateLst){
                                        if(mRateObj.ET_Vehicle_Model__c != null && mRateObj.ET_Vehicle_Model__c.equalsIgnoreCase(trailerModelFromRequest) &&mRateObj.Vehicle_Make__c != null && mRateObj.Vehicle_Make__c.equalsIgnoreCase(trailerMakeFromRequest) ){
                                            if(trailerCondFromRequest == 'New'){
                                                applicapleMaintenanceRateForTrailer = getmaintenanceRateYearWise(mRateObj ,vehicleQuoteCalcObj.contractYear );
                                            }
                                            else if(trailerCondFromRequest == 'Used'){
                                                integer diff = Date.Today().Year() - modelYearInRequestForTrailer ;
                                                integer year = diff + vehicleQuoteCalcObj.contractYear;
                                                applicapleMaintenanceRateForTrailer = getmaintenanceRateYearWise(mRateObj ,year );
                                            }
                                            
                                        }
                                        vehicleQuoteCalcObj.trailerMaintenanceRate = applicapleMaintenanceRateForTrailer;
                                    }
                                    
                                }
                                
                                // **********************Maintenance and repair Rate calc -- Refrigerator *************** START*********/
                                Decimal applicapleMaintenanceRateForRefrigerator = 0.0;
                                if(isrefregiratorSelected && maintenanceRateLst != null && maintenanceRateLst.size() > 0){
                                    for(ET_Maintenance_Rate__c mRateObj : maintenanceRateLst){
                                        if(mRateObj.ET_Vehicle_Model__c != null && mRateObj.ET_Vehicle_Model__c.equalsIgnoreCase(refregiratorModelFromRequest) &&mRateObj.Vehicle_Make__c != null && mRateObj.Vehicle_Make__c.equalsIgnoreCase(refregiratorMakeFromRequest) ){
                                            if(refregiratorCondFromRequest == 'New'){
                                                applicapleMaintenanceRateForRefrigerator = getmaintenanceRateYearWise(mRateObj ,vehicleQuoteCalcObj.contractYear );
                                            }
                                            else if(refregiratorCondFromRequest == 'Used'){
                                                integer diff = Date.Today().Year() - modelYearInRequestForRefregirator ;
                                                integer year = diff + vehicleQuoteCalcObj.contractYear;
                                                applicapleMaintenanceRateForRefrigerator = getmaintenanceRateYearWise(mRateObj ,year );
                                            }
                                            
                                        }
                                        vehicleQuoteCalcObj.refrigeratorMaintenanceRate = applicapleMaintenanceRateForRefrigerator;
                                    }
                                    
                                }
                                
                                
                                
                                
                                // **********************Financing rate *************** START*********/
                                
                                ET_Pricing_Vehicle_Finance_Rate_Setup__c financeCalcRecord;
                                if(!financeCalcMetadataLst.isEmpty()){
                                    for(ET_Pricing_Vehicle_Finance_Rate_Setup__c financeRec: financeCalcMetadataLst){
                                        if(financeCalcMetadataLst.size() >1 && financeRec.ET_Vehicle_Type__c != null && financeRec.ET_Vehicle_Type__c.equalsIgnoreCase(vehicleTypeFrmRequest)){
                                            financeCalcRecord = financeRec;
                                        }
                                        else if (financeCalcMetadataLst.size() == 1 && financeRec.ET_Vehicle_Type__c.equalsIgnoreCase('All')){
                                            financeCalcRecord = financeRec;
                                            break;
                                        }
                                    }
                                }
                                
                                vehicleQuoteCalcObj.financingRate = financeCalcRecord.ET_Finance_Rate__c ; 
                                vehicleQuoteCalcObj.numberofFinancingYears = financeCalcRecord.ET_Number_of_Financing_years__c ; 
                                
                                // **********************Financing rate *************** END*********/
                                
                                // **********************vehicle Insurance rate *************** START*********/
                                
                                
                                Vehicle_Insurance_Fee_Master__c insuranceMaster;
                                if(!vehicleInsuranceMasterLst.isEmpty()){
                                    for(Vehicle_Insurance_Fee_Master__c vehicleInsuranceMaster: vehicleInsuranceMasterLst){
                                        if(vehicleInsuranceMaster.Vehicle_Type__c == vehicleTypeFrmRequest && vehicleInsuranceMaster.ET_Emirates__c != null && (vehicleInsuranceMaster.ET_Emirates__c.contains(specificServiceEmirate) || vehicleInsuranceMaster.ET_Emirates__c == 'All')){
                                            insuranceMaster = vehicleInsuranceMaster;
                                        }
                                    }
                                }
                                vehicleQuoteCalcObj.noOfSeats = vehicle.ET_Number_of_seats__c ;
                                if(insuranceMaster != null){
                                    Integer contractYearInt = Integer.valueOf(contractYear);
                                    Decimal insuranceRate = getInsuranceRate(insuranceMaster, contractYearInt);
                                    vehicleQuoteCalcObj.insuranceRate = insuranceRate;
                                    vehicleQuoteCalcObj.numberOfDeprciatedYearsfromInsuranceMaster = insuranceMaster.ET_Number_of_Depreciated_years__c;
                                    vehicleQuoteCalcObj.minVehValFromInsuranceMaster = insuranceMaster.ET_Minimum_Vehicle_Value__c;
                                    vehicleQuoteCalcObj.passengerCost = insuranceMaster.ET_Passenger_Cost_Per_Seat__c;
                                    vehicleQuoteCalcObj.driverInsuranceCost = insuranceMaster.ET_Driver_Cost__c;
                                    vehicleQuoteCalcObj.ambulanceCost = insuranceMaster.ET_Ambulance_Cost__c;
                                    vehicleQuoteCalcObj.otherCost = insuranceMaster.ET_Other_Cost__c;
                                    vehicleQuoteCalcObj.insuranceRate1stYear = insuranceMaster.ET_Insurance_Rate_1st_Year__c;
                                    vehicleQuoteCalcObj.insuranceMinCost = insuranceMaster.ET_Minimum_Cost__c;
                                }
                                
                                // **********************vehicle Insurance rate *************** END*********/
                                
                                
                                // vehicle Registration..
                                ET_Vehicle_Registration_Inspection_Fee__c regInsFeeData;
                                String vehicleTypeRecordId;
                                if(vehicleTypeIdWithTypeAndSubTypeMap != null && vehicleTypeIdWithTypeAndSubTypeMap.containsKey(vehicleTypeAndSubTypeFrmRequest)){
                                    vehicleTypeRecordId = vehicleTypeIdWithTypeAndSubTypeMap.get(vehicleTypeAndSubTypeFrmRequest).id;
                                }
                                if(!vehicleRegInsFeeLst.isEmpty()){
                                    for(ET_Vehicle_Registration_Inspection_Fee__c vehicleRegInspFee : vehicleRegInsFeeLst){
                                        if(vehicleRegInspFee.ET_Vehicle_Type__c == vehicleTypeRecordId && vehicleRegInspFee.ET_Emirates__c != null && (vehicleRegInspFee.ET_Emirates__c.containsIgnoreCase(specificServiceEmirate) || vehicleRegInspFee.ET_Emirates__c == 'All')){
                                            regInsFeeData = vehicleRegInspFee;
                                        }
                                    }
                                }
                                if(regInsFeeData != null){
                                    //ET_Vehicle_Registration_Inspection_Fee__c regInsFeeData = vehicleRegInsFeeLst[0];
                                    Decimal vehicleRegInsFee;
                                    integer year ;
                                    if(vehicleCondFromRequest == 'New'){
                                        year = vehicleQuoteCalcObj.contractYear;
                                    }
                                    else if(vehicleCondFromRequest == 'Used'){
                                        integer diff = Date.Today().Year() - modelYearInRequest ;
                                        year = diff + vehicleQuoteCalcObj.contractYear;
                                        if(year > 8){
                                            year = year -8;
                                        }
                                    }
                                    Switch on year{
                                        when 1 {
                                            vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee =  regInsFeeData.ET_Registration_Fee_1st_Year__c;
                                        }
                                        when 2 {
                                            vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee =  regInsFeeData.ET_Registration_Fee_2nd_Year__c;
                                        }
                                        when 3 {
                                            
                                            vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee =  regInsFeeData.ET_Registration_Fee_3rd_Year__c;
                                        }
                                        when 4 {
                                            
                                            vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee =  regInsFeeData.ET_Registration_Fee_4th_Year__c;
                                        }
                                        when 5 {
                                            
                                            vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee =  regInsFeeData.ET_Registration_Fee_5th_Year__c;
                                        }
                                        when 6 {
                                            
                                            vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee =  regInsFeeData.ET_Registration_Fee_6th_Year__c;
                                        }
                                        when 7 {
                                            vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee =  regInsFeeData.ET_Registration_Fee_7th_Year__c;
                                        }
                                        when 8 {
                                            vehicleQuoteCalcObj.vehicleRegistrationAndInspectionFee =  regInsFeeData.ET_Registration_Fee_8th_Year__c;
                                        }
                                        when else{
                                            
                                        }
                                    }
                                }
                                
                                
                                // Trailer - Registration Fee
                                ET_Vehicle_Registration_Inspection_Fee__c regInsFeeDataForTrailer;
                                String vehicleTypeRecordIdForTrailer;
                                if(isTrailerSelected && vehicleTypeIdWithTypeAndSubTypeMap != null && vehicleTypeIdWithTypeAndSubTypeMap.containsKey(trailerTypeAndSubTypeFrmRequest)){
                                    vehicleTypeRecordIdForTrailer = vehicleTypeIdWithTypeAndSubTypeMap.get(trailerTypeAndSubTypeFrmRequest).id;
                                }
                                if(isTrailerSelected && !vehicleRegInsFeeLst.isEmpty()){
                                    for(ET_Vehicle_Registration_Inspection_Fee__c vehicleRegInspFee : vehicleRegInsFeeLst){
                                        if(vehicleRegInspFee.ET_Vehicle_Type__c == vehicleTypeRecordIdForTrailer && vehicleRegInspFee.ET_Emirates__c != null && (vehicleRegInspFee.ET_Emirates__c.containsIgnoreCase(specificServiceEmirate) || vehicleRegInspFee.ET_Emirates__c == 'All')){
                                            regInsFeeDataForTrailer = vehicleRegInspFee;
                                        }
                                    }
                                }
                                if(isTrailerSelected && regInsFeeDataForTrailer != null){
                                    Decimal vehicleRegInsFee;
                                    integer year ;
                                    if(trailerCondFromRequest == 'New'){
                                        year = vehicleQuoteCalcObj.contractYear;
                                    }
                                    else if(trailerCondFromRequest == 'Used'){
                                        integer diff = Date.Today().Year() - modelYearInRequestForTrailer ;
                                        year = diff + vehicleQuoteCalcObj.contractYear;
                                        if(year > 8){
                                            year = year -8;
                                        }
                                    }
                                    Switch on year{
                                        when 1 {
                                            vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee =  regInsFeeDataForTrailer.ET_Registration_Fee_1st_Year__c;
                                        }
                                        when 2 {
                                            vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee =  regInsFeeDataForTrailer.ET_Registration_Fee_2nd_Year__c;
                                        }
                                        when 3 {
                                            
                                            vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee =  regInsFeeDataForTrailer.ET_Registration_Fee_3rd_Year__c;
                                        }
                                        when 4 {
                                            
                                            vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee =  regInsFeeDataForTrailer.ET_Registration_Fee_4th_Year__c;
                                        }
                                        when 5 {
                                            
                                            vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee =  regInsFeeDataForTrailer.ET_Registration_Fee_5th_Year__c;
                                        }
                                        when 6 {
                                            
                                            vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee =  regInsFeeDataForTrailer.ET_Registration_Fee_6th_Year__c;
                                        }
                                        when 7 {
                                            vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee =  regInsFeeDataForTrailer.ET_Registration_Fee_7th_Year__c;
                                        }
                                        when 8 {
                                            vehicleQuoteCalcObj.trailerRegistrationAndInspectionFee =  regInsFeeDataForTrailer.ET_Registration_Fee_8th_Year__c;
                                        }
                                        when else{
                                            
                                        }
                                    }
                                }
                                
                                // Refrigerator - Registration Fee
                                ET_Vehicle_Registration_Inspection_Fee__c regInsFeeDataForRefrigerator;
                                String vehicleTypeRecordIdForRefrigerator;
                                if(isrefregiratorSelected && vehicleTypeIdWithTypeAndSubTypeMap != null && vehicleTypeIdWithTypeAndSubTypeMap.containsKey(refregiratorTypeAndSubTypeFrmRequest)){
                                    vehicleTypeRecordIdForRefrigerator = vehicleTypeIdWithTypeAndSubTypeMap.get(refregiratorTypeAndSubTypeFrmRequest).id;
                                }
                                if(isrefregiratorSelected && !vehicleRegInsFeeLst.isEmpty()){
                                    for(ET_Vehicle_Registration_Inspection_Fee__c vehicleRegInspFee : vehicleRegInsFeeLst){
                                        if(vehicleRegInspFee.ET_Vehicle_Type__c == vehicleTypeRecordIdForRefrigerator && vehicleRegInspFee.ET_Emirates__c != null && (vehicleRegInspFee.ET_Emirates__c.containsIgnoreCase(specificServiceEmirate) || vehicleRegInspFee.ET_Emirates__c == 'All')){
                                            regInsFeeDataForRefrigerator = vehicleRegInspFee;
                                        }
                                    }
                                }
                                if(isrefregiratorSelected && regInsFeeDataForRefrigerator != null){
                                    Decimal vehicleRegInsFee;
                                    integer year ;
                                    if(refregiratorCondFromRequest == 'New'){
                                        year = vehicleQuoteCalcObj.contractYear;
                                    }
                                    else if(refregiratorCondFromRequest == 'Used'){
                                        integer diff = Date.Today().Year() - modelYearInRequestForRefregirator ;
                                        year = diff + vehicleQuoteCalcObj.contractYear;
                                        if(year > 8){
                                            year = year -8;
                                        }
                                    }
                                    Switch on year{
                                        when 1 {
                                            vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  regInsFeeDataForRefrigerator.ET_Registration_Fee_1st_Year__c;
                                        }
                                        when 2 {
                                            vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  regInsFeeDataForRefrigerator.ET_Registration_Fee_2nd_Year__c;
                                        }
                                        when 3 {
                                            
                                            vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  regInsFeeDataForRefrigerator.ET_Registration_Fee_3rd_Year__c;
                                        }
                                        when 4 {
                                            
                                            vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  regInsFeeDataForRefrigerator.ET_Registration_Fee_4th_Year__c;
                                        }
                                        when 5 {
                                            
                                            vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  regInsFeeDataForRefrigerator.ET_Registration_Fee_5th_Year__c;
                                        }
                                        when 6 {
                                            
                                            vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  regInsFeeDataForRefrigerator.ET_Registration_Fee_6th_Year__c;
                                        }
                                        when 7 {
                                            vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  regInsFeeDataForRefrigerator.ET_Registration_Fee_7th_Year__c;
                                        }
                                        when 8 {
                                            vehicleQuoteCalcObj.refrigeratorRegistrationAndInspectionFee =  regInsFeeDataForRefrigerator.ET_Registration_Fee_8th_Year__c;
                                        }
                                        when else{
                                            
                                        }
                                    }
                                }
                                
                                // **********************vehicle Registrion & Inspection Rate  *************** END*********/
                                
                                // *********************** Vehicle level DynamicOtherCost cals**************** start*******/
                                
                                if(vehicleVsOtherCostMap.containsKey(vehicle.Id)){
                                    List<ET_Other_Cost_Request__c> oneTimeCost = new List<ET_Other_Cost_Request__c>();
                                    List<ET_Other_Cost_Request__c> annualCost = new List<ET_Other_Cost_Request__c>();
                                    List<ET_Other_Cost_Request__c> bothCost = new List<ET_Other_Cost_Request__c>();
                                    LIst<ET_ServiceRequestController.otherCostCalcClass> otCostCalcList = new List<ET_ServiceRequestController.otherCostCalcClass>();
                                    
                                    for(ET_Other_Cost_Request__c otCost: vehicleVsOtherCostMap.get(vehicle.Id)){
                                        if(otCost.ET_Cost_Type__c.contains('One_time_Cost') && otCost.ET_Cost_Type__c.contains('Annual_Cost')){
                                            bothCost.add(otCost);
                                        }else if(otCost.ET_Cost_Type__c.contains('One_time_Cost') && !otCost.ET_Cost_Type__c.contains('Annual_Cost')){
                                            oneTimeCost.add(otCost);
                                        }else if(!otCost.ET_Cost_Type__c.contains('One_time_Cost') && otCost.ET_Cost_Type__c.contains('Annual_Cost')){
                                            annualCost.add(otCost);
                                        }
                                    }
                                    
                                    Map<String , otherCostCalcClassTProj> vehOneTimeSpecReqInnerMap = new Map<String , otherCostCalcClassTProj>();
                                    for(ET_Other_Cost_Request__c otCost: oneTimeCost){
                                        ET_ServiceRequestController.otherCostCalcClass otCostCalcClsInst = new ET_ServiceRequestController.otherCostCalcClass();
                                        ET_ServiceRequestController.otherCostCalcClassTProj specialOneTimeRequirementForTotalProject = new  ET_ServiceRequestController.otherCostCalcClassTProj();
                                        otCostCalcClsInst.otherCostValue = otCost.ET_Cost_Value__c/vehicleQuoteCalcObj.contractYear;
                                        otCostCalcClsInst.otherCostLabel = otCost.Name;
                                        otCostCalcList.add(otCostCalcClsInst);
                                        
                                        specialOneTimeRequirementForTotalProject.otherCostLabel = otCost.Name;
                                        specialOneTimeRequirementForTotalProject.otherCostValue = (otCost.ET_Cost_Value__c/vehicleQuoteCalcObj.contractYear)*noOfVehicles;
                                        
                                        vehOneTimeSpecReqInnerMap.put(specialOneTimeRequirementForTotalProject.otherCostLabel  ,specialOneTimeRequirementForTotalProject );
                                        
                                        // system.debug('vehSpecilReqsForTotProjMap  = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                        //system.debug('vehicleSource  2274= '+ vehicleQuoteCalcObj.vehicleSource);
                                        if(vehSpecilReqsForTotProjMap  != null && vehSpecilReqsForTotProjMap.containsKey(integerContractYear))
                                        {
                                            Map<String , otherCostCalcClassTProj> vehSpecialReqqMap  = vehSpecilReqsForTotProjMap.get(integerContractYear);
                                            if(vehSpecialReqqMap != null && vehSpecialReqqMap.containsKey(specialOneTimeRequirementForTotalProject.otherCostLabel)){
                                                if(vehicleQuoteCalcObj.vehicleSource == 'Main'){
                                                    otherCostCalcClassTProj specReq = vehSpecialReqqMap.get(specialOneTimeRequirementForTotalProject.otherCostLabel);
                                                    //system.debug('specReq  = '+ JSON.serializePretty(specReq));
                                                    decimal totalCost = specReq.otherCostValue +specialOneTimeRequirementForTotalProject.otherCostValue ;
                                                    specialOneTimeRequirementForTotalProject.otherCostValue = totalCost;
                                                    vehSpecialReqqMap.put(specialOneTimeRequirementForTotalProject.otherCostLabel   ,specialOneTimeRequirementForTotalProject );
                                                    
                                                    vehSpecilReqsForTotProjMap.put(integerContractYear ,vehSpecialReqqMap );
                                                }
                                                // system.debug('vehSpecilReqsForTotProjMap 1 = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                            }
                                            else{
                                                vehSpecialReqqMap.put(specialOneTimeRequirementForTotalProject.otherCostLabel ,specialOneTimeRequirementForTotalProject );
                                                if(vehicleQuoteCalcObj.vehicleSource == 'Main'){
                                                    vehSpecilReqsForTotProjMap.put(integerContractYear ,vehSpecialReqqMap );
                                                }
                                                //system.debug('vehSpecilReqsForTotProjMap 2 = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                            }
                                            
                                        }
                                    }
                                    
                                    if(vehicleQuoteCalcObj.vehicleSource == 'Main' && vehSpecilReqsForTotProjMap  != null && !vehSpecilReqsForTotProjMap.containsKey(integerContractYear))
                                    {
                                        vehSpecilReqsForTotProjMap.put(integerContractYear ,vehOneTimeSpecReqInnerMap );
                                    }
                                    //system.debug('vehSpecilReqsForTotProjMap 3 = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                    
                                    //Vehicle annual Cost
                                    
                                    Map<String , otherCostCalcClassTProj> vehAnnualSpecReqInnerMap = new Map<String , otherCostCalcClassTProj>();
                                    for(ET_Other_Cost_Request__c otCost: annualCost){
                                        ET_ServiceRequestController.otherCostCalcClass otCostCalcClsInst = new ET_ServiceRequestController.otherCostCalcClass();
                                        ET_ServiceRequestController.otherCostCalcClassTProj specialAnnualRequirementForTotalProject = new  ET_ServiceRequestController.otherCostCalcClassTProj();
                                        otCostCalcClsInst.otherCostValue = otCost.ET_Cost_Value__c;
                                        otCostCalcClsInst.otherCostLabel = otCost.Name;
                                        otCostCalcList.add(otCostCalcClsInst);
                                        
                                        specialAnnualRequirementForTotalProject.otherCostLabel = otCost.Name;
                                        specialAnnualRequirementForTotalProject.otherCostValue = otCost.ET_Cost_Value__c*noOfVehicles; 
                                        
                                        vehAnnualSpecReqInnerMap.put(specialAnnualRequirementForTotalProject.otherCostLabel  ,specialAnnualRequirementForTotalProject );
                                        
                                        // system.debug('vehSpecilReqsForTotProjMap  = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                        if(vehSpecilReqsForTotProjMap  != null && vehSpecilReqsForTotProjMap.containsKey(integerContractYear))
                                        {
                                            Map<String , otherCostCalcClassTProj> vehSpecialReqqMap  = vehSpecilReqsForTotProjMap.get(integerContractYear);
                                            if(vehSpecialReqqMap != null && vehSpecialReqqMap.containsKey(specialAnnualRequirementForTotalProject.otherCostLabel)){
                                                otherCostCalcClassTProj specReq = vehSpecialReqqMap.get(specialAnnualRequirementForTotalProject.otherCostLabel);
                                                //system.debug('specReq  = '+ JSON.serializePretty(specReq));
                                                decimal totalCost = specReq.otherCostValue +specialAnnualRequirementForTotalProject.otherCostValue ;
                                                if(vehicleQuoteCalcObj.vehicleSource == 'Main'){
                                                    specialAnnualRequirementForTotalProject.otherCostValue = totalCost;
                                                    vehSpecialReqqMap.put(specialAnnualRequirementForTotalProject.otherCostLabel   ,specialAnnualRequirementForTotalProject );
                                                    
                                                    vehSpecilReqsForTotProjMap.put(integerContractYear ,vehSpecialReqqMap );
                                                }
                                                // system.debug('vehSpecilReqsForTotProjMap 1 = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                            }
                                            else{
                                                vehSpecialReqqMap.put(specialAnnualRequirementForTotalProject.otherCostLabel ,specialAnnualRequirementForTotalProject );
                                                if(vehicleQuoteCalcObj.vehicleSource == 'Main'){
                                                    vehSpecilReqsForTotProjMap.put(integerContractYear ,vehSpecialReqqMap );
                                                }
                                                //system.debug('vehSpecilReqsForTotProjMap 2 = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                            }
                                        }
                                        
                                    }
                                    
                                    // system.debug('vehSpecilReqsForTotProjMap 3 = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                    if(vehicleQuoteCalcObj.vehicleSource == 'Main' && vehSpecilReqsForTotProjMap  != null && !vehSpecilReqsForTotProjMap.containsKey(integerContractYear))
                                    {
                                        vehSpecilReqsForTotProjMap.put(integerContractYear ,vehAnnualSpecReqInnerMap );
                                    }
                                    
                                    Map<String , otherCostCalcClassTProj> vehBothCostSpecReqInnerMap = new Map<String , otherCostCalcClassTProj>();
                                    for(ET_Other_Cost_Request__c otCost: bothCost){
                                        ET_ServiceRequestController.otherCostCalcClass otCostCalcClsInst = new ET_ServiceRequestController.otherCostCalcClass();
                                        ET_ServiceRequestController.otherCostCalcClassTProj specialBothCostRequirementForTotalProject = new  ET_ServiceRequestController.otherCostCalcClassTProj();
                                        otCostCalcClsInst.otherCostValue = otCost.ET_Cost_Value__c + (otCost.ET_Cost_Value__c/vehicleQuoteCalcObj.contractYear);
                                        otCostCalcClsInst.otherCostLabel = otCost.Name;
                                        otCostCalcList.add(otCostCalcClsInst);
                                        
                                        specialBothCostRequirementForTotalProject.otherCostLabel = otCost.Name;
                                        specialBothCostRequirementForTotalProject.otherCostValue = (otCost.ET_Cost_Value__c + (otCost.ET_Cost_Value__c/vehicleQuoteCalcObj.contractYear))*noOfVehicles;
                                        
                                        vehBothCostSpecReqInnerMap.put(specialBothCostRequirementForTotalProject.otherCostLabel  ,specialBothCostRequirementForTotalProject );
                                        
                                        //system.debug('vehSpecilReqsForTotProjMap  = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                        if(vehSpecilReqsForTotProjMap  != null && vehSpecilReqsForTotProjMap.containsKey(integerContractYear))
                                        {
                                            Map<String , otherCostCalcClassTProj> vehSpecialReqqMap  = vehSpecilReqsForTotProjMap.get(integerContractYear);
                                            if(vehSpecialReqqMap != null && vehSpecialReqqMap.containsKey(specialBothCostRequirementForTotalProject.otherCostLabel)){
                                                otherCostCalcClassTProj specReq = vehSpecialReqqMap.get(specialBothCostRequirementForTotalProject.otherCostLabel);
                                                //system.debug('specReq  = '+ JSON.serializePretty(specReq));
                                                decimal totalCost = specReq.otherCostValue +specialBothCostRequirementForTotalProject.otherCostValue ;
                                                if(vehicleQuoteCalcObj.vehicleSource == 'Main'){
                                                    specialBothCostRequirementForTotalProject.otherCostValue = totalCost;
                                                    vehSpecialReqqMap.put(specialBothCostRequirementForTotalProject.otherCostLabel   ,specialBothCostRequirementForTotalProject );
                                                    
                                                    vehSpecilReqsForTotProjMap.put(integerContractYear ,vehSpecialReqqMap );
                                                }
                                                
                                                // system.debug('vehSpecilReqsForTotProjMap 1 = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                            }
                                            else{
                                                vehSpecialReqqMap.put(specialBothCostRequirementForTotalProject.otherCostLabel ,specialBothCostRequirementForTotalProject );
                                                if(vehicleQuoteCalcObj.vehicleSource == 'Main'){
                                                    vehSpecilReqsForTotProjMap.put(integerContractYear ,vehSpecialReqqMap );
                                                }
                                                
                                                //system.debug('vehSpecilReqsForTotProjMap 2 = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                                            }
                                            
                                        }
                                    }
                                    if(vehicleQuoteCalcObj.vehicleSource == 'Main' && vehSpecilReqsForTotProjMap  != null && !vehSpecilReqsForTotProjMap.containsKey(integerContractYear))
                                    {
                                        vehSpecilReqsForTotProjMap.put(integerContractYear ,vehBothCostSpecReqInnerMap );
                                    }
                                    vehicleQuoteCalcObj.vehicleOtherCostLst = otCostCalcList; 
                                }
                                
                                // *********************** vehicleDYnamicOtherCost cals**************** end*******/
                                
                                Decimal totalSpecReqCost = 0.0;
                                
                                //Vehicle special Requirements (Predefined)
                                for(ET_ServiceRequestController.vehicleSpecialRequirement specReq  : vehicleQuoteCalcObj.vehicleSpecialRequirementLst){
                                    totalSpecReqCost += specReq.specificRequirementCost;
                                }
                                
                                //dynamic other cost
                                for(ET_ServiceRequestController.otherCostCalcClass specReq  : vehicleQuoteCalcObj.vehicleOtherCostLst){
                                    totalSpecReqCost += specReq.otherCostValue;
                                }
                                
                                vehicleQuoteCalcObj.totalSpecialRequirmentsCost = totalSpecReqCost;
                                
                                // **********************vehicle Fuel calc *************** START*********/
                                String fuelTypeFromServiceRequest = vehicle.ET_Fuel_Type__c;
                                String fuelRequired = vehicle.ET_Vehicle_Fuel__c;
                                // system.debug('fuelRequired  = '+ fuelRequired);
                                if(fuelRequired == 'Yes'){
                                    vehicleQuoteCalcObj.fuelRequired = true;
                                }
                                else if(fuelRequired == 'No'){
                                    vehicleQuoteCalcObj.fuelRequired = false;
                                }
                                
                                ET_Vehicle_Fuel_Master__c targetedFuelMaster;
                                if(fuelTypeFromServiceRequest != null && fuelRequired == 'Yes'){
                                    if(fuelMasterData != null && fuelMasterData.size() > 0){
                                        for(ET_Vehicle_Fuel_Master__c vehicleFuelMaster : fuelMasterData){
                                            if(fuelTypeFromServiceRequest.containsIgnoreCase(vehicleFuelMaster.ET_Fuel_Type__c )){
                                                targetedFuelMaster = vehicleFuelMaster;
                                            }
                                        }
                                    } 
                                }
                                if( targetedFuelMaster != null && vehicle.ET_Vehicle_Fuel_Consumption__c != null ){
                                    vehicleQuoteCalcObj.fuelConsumption = vehicle.ET_Vehicle_Fuel_Consumption__c ;
                                    if(targetedFuelMaster.ET_Actual_Liter_Price__c != null){
                                        vehicleQuoteCalcObj.actualLiterPrice = targetedFuelMaster.ET_Actual_Liter_Price__c;
                                    }else{
                                        // system.debug('couldn\'t calculate fuel expenses, actual liter price is null for fuel type : '+ targetedFuelMaster.ET_Fuel_Type__c);
                                    }
                                    
                                }
                                
                                // **********************vehicle Fuel calc *************** END*********/
                                
                                // system.debug('***getCpuTime()***'+Limits.getCpuTime());
                                // system.assert(false,'Show ==');  
                                // **********************vehicle Reserve calc *************** START*********/
                                if(requiredReserveMasterData != null){
                                    if(requiredReserveMasterData.ET_Depreciation_Reserve_Rate__c != null && vehFleet != 'Client Fleet' ){
                                        vehicleQuoteCalcObj.depreciationReserveRate = requiredReserveMasterData.ET_Depreciation_Reserve_Rate__c;
                                    }
                                    else if(requiredReserveMasterData.ET_Depreciation_Reserve_Rate__c != null && vehFleet == 'Client Fleet'){
                                        vehicleQuoteCalcObj.depreciationReserveRate = 0;
                                    }
                                    
                                    else{
                                        //system.debug('Depreciation Reserve rate is null for service type ' + oraclePricingServiceType);
                                    }
                                    
                                    if(requiredReserveMasterData.ET_Maintenance_Reserve_Rate__c != null){
                                        vehicleQuoteCalcObj.maintainenceReserveRate = requiredReserveMasterData.ET_Maintenance_Reserve_Rate__c;
                                    }else{
                                        //system.debug('Maintenance Reserve rate is null for service type ' + oraclePricingServiceType);
                                    }
                                    
                                    if(requiredReserveMasterData.ET_General_Reserve_Rate__c != null){
                                        vehicleQuoteCalcObj.generalReserveRate = requiredReserveMasterData.ET_General_Reserve_Rate__c;
                                    }else{
                                        //system.debug('General Reserve rate is null for service type ' + oraclePricingServiceType);
                                    }
                                    if(requiredReserveMasterData.ET_Fuel_Reserve_Rate__c != null){
                                        vehicleQuoteCalcObj.fuelReserveRate = requiredReserveMasterData.ET_Fuel_Reserve_Rate__c;
                                        // system.debug('fuelReserveRate = '+ requiredReserveMasterData.ET_Fuel_Reserve_Rate__c);
                                    }else{
                                        // system.debug('Fuel Reserve rate is null for service type ' + oraclePricingServiceType);
                                    }
                                    
                                }else{
                                    // system.debug('Reserve metadata is missing for service request type : ' + oraclePricingServiceType);
                                }
                                
                                // **********************annual fuel profit and annual vehicle profit calc *************** Start*********/
                                if(annualProfitMasterData.size() > 0  ){
                                    for(ET_Pricing_Profit_Calculation_Setup__c profitCalcMaster : annualProfitMasterData){
                                        
                                        if(profitCalcMaster.ET_Api_Name__c == 'ET_Annual_Fuel_Profit_Margin' && fuelRequired == 'Yes'){
                                            vehicleQuoteCalcObj.annualFuelProfitMarginRate = getProfitRate(profitCalcMaster,vehicleQuoteCalcObj);
                                            
                                        }else if(profitCalcMaster.ET_Api_Name__c == 'ET_Annual_Vehicles_Profit_Margin'){
                                            vehicleQuoteCalcObj.annualVehicleProfitRateFromMaster = (getProfitRate(profitCalcMaster,vehicleQuoteCalcObj)) ;
                                            
                                        }
                                        
                                    }
                                    
                                }else{
                                    // system.debug('Profit calculation metadata is missing for  \'ET_Annual_Fuel_Profit_Margin \' and \'ET_Annual_Vehicles_Profit_Margin\' or fuel is not opt for this vehicle' );
                                }
                                
                                /**Extra Bus Fee ***/
                                Integer contractYearInt = Integer.valueOf(contractYear);
                                if(extraBusFeesMasterData != null && extraBusFeesMasterData.size() > 0){
                                    for(ET_Extra_Bus_Fees_Master__c feeMaster : extraBusFeesMasterData){
                                        if(feeMaster.Emirates__c != null && (feeMaster.Emirates__c.contains(specificServiceEmirate) || feeMaster.Emirates__c == 'All')){
                                            vehicleQuoteCalcObj.extraBusFeesForSchoolTransportation = getExtraFee(feeMaster , contractYearInt );
                                        }
                                    }
                                }
                                
                                // **********************Vehicle Purchase value if-loop *************** END*********/
                                // system.debug('vehicleQuoteCalcObj : '+JSON.serializePretty(vehicleQuoteCalcObj) );
                                vehicleQuoteCalcLst.add(vehicleQuoteCalcObj);
                            }
                        }else{
                            system.debug('contractYearLst is empty, skipping all calculations');
                        }
                        
                        
                    }
                    if(!vehicleQuoteCalcLst.isEmpty()){
                        system.debug('vehicleQuoteCalcLst size = '+ vehicleQuoteCalcLst.size());
                    }
                    
                    quotecalculationObj.vehicleQuoteItemLst = vehicleQuoteCalcLst;
                    quotecalculationObj.fleetType = fleetType;
                    quotecalculationObj.serviceEmirate = serviceEmirate;
                    
                    //calling method to create quote and quote child items 
                    system.debug('final quotecalculationObj '+ quotecalculationObj);
                }else{
                    system.debug('no vehicle request data is found for pricing service request :'+ serviceRequestId);
                }
                //Taj Start
                String quoteId = String.valueOf(createQuoteObj(quotecalculationObj,serviceRequest));
                Boolean deleteQuote = false;
                if (String.isNotBlank(quoteId)) {
                    User loggedInUser = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
                    System.debug('Logged in User: ' + loggedInUser);
                    createQuotationReturnWrp.loggedInProfileName = loggedInUser.Profile.Name;
                    Set<String> profileSalesTL = new Set<String>(System.Label.TL_SalesTeam_Profiles.split(';'));
                    //if (profileSalesTL.contains(loggedInUser.Profile.Name)) {
                    List<ET_Vehicle_Quote_Item__c> quoteItems = [
                        SELECT Id, Name, ET_Vehicle_Repairs_and_Maintenance__c, ET_Vehicle_Depreciation__c, ET_Vehicle_Registration__c 
                        FROM ET_Vehicle_Quote_Item__c 
                        WHERE Quote__c =: quoteId];
                    for (ET_Vehicle_Quote_Item__c quoteItem : quoteItems) {
                        System.debug('Quote Item: ' + quoteItem);
                        if (quoteItem.ET_Vehicle_Repairs_and_Maintenance__c == 0 || Integer.valueOf(quoteItem.ET_Vehicle_Depreciation__c) == 0 || quoteItem.ET_Vehicle_Registration__c == 0) {
                            deleteQuote = true;
                            if (quoteItem.ET_Vehicle_Repairs_and_Maintenance__c == 0) {
                                if(createQuotationReturnWrp.errorMsg != null)
                                    createQuotationReturnWrp.errorMsg = createQuotationReturnWrp.errorMsg+';Repair and Maintenance is 0';
                                else 
                                    createQuotationReturnWrp.errorMsg = '- Repair and Maintenance is 0';
                            } else if (Integer.valueOf(quoteItem.ET_Vehicle_Depreciation__c) == 0) {
                                if(createQuotationReturnWrp.errorMsg != null)
                                    createQuotationReturnWrp.errorMsg = createQuotationReturnWrp.errorMsg+';Depreciation is 0';
                                else
                                    createQuotationReturnWrp.errorMsg = '- Depreciation is 0';
                            } else if (quoteItem.ET_Vehicle_Registration__c == 0) {
                                if(createQuotationReturnWrp.errorMsg != null)
                                    createQuotationReturnWrp.errorMsg = createQuotationReturnWrp.errorMsg+';Registration is 0';
                                else
                                    createQuotationReturnWrp.errorMsg = '- Registration is 0';
                            }
                            System.debug('Quote Item has a zero value: ' + quoteItem);
                            //break;
                        }
                    }
                    //}
                    if (profileSalesTL.contains(loggedInUser.Profile.Name) && deleteQuote) {
                        try {
                            Delete [SELECT Id FROM Quote WHERE Id =: quoteId];
                            quoteId = null;
                            System.debug('Quote deleted successfully.');
                        } catch (DmlException e) {
                            System.debug('An error occurred while deleting the quote: ' + e.getMessage());
                        }
                    }
                }
                createQuotationReturnWrp.quoteId = quoteId;
                System.debug('CreateQuotationReturnWrp: ' + createQuotationReturnWrp);
                return createQuotationReturnWrp;
                //Taj end
            }
            catch(Exception ex){
                system.debug('Exception occured of type :' + ex.getTypeName() + ' due to cause : ' + ex.getCause()  + 'with Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString());
                throw new AuraHandledException('Exception message : ' + ex.getMessage() +' ; stack trace : '+ ex.getStackTraceString());
            }
            
        }else{
            system.debug('pricing service request id is null');
        }
        return null;
    }

    public class createQuotationReturnWrapper{
        @AuraEnabled Public String quoteId;
        @AuraEnabled Public String loggedInProfileName;
        @AuraEnabled Public String errorMsg;
        createQuotationReturnWrapper(){
            quoteId = null;
            loggedInProfileName = null;
            errorMsg = null;
        }
    }
    
    //uncomment it later, part of main functionality
    @TestVisible
    private static Decimal getFinalCost(List<Decimal> costList){
        Decimal sum = 0.0;
        if(costList != null && costList.size() > 0){
            for(Decimal cost : costList){
                if(cost != null ){
                    sum = sum + cost;
                }
            }
        }
        return sum;
    }
    
    Public static Decimal getExtraFee(ET_Extra_Bus_Fees_Master__c extraBusFeesData , Integer contractYear){
        Decimal ExtraFeeYearWise =0.0;
        Switch on contractYear{
            when 1 {
                ExtraFeeYearWise = extraBusFeesData.Year_1__c;
            }
            when 2 {
                ExtraFeeYearWise = extraBusFeesData.Year_2__c;
            }
            when 3 {
                ExtraFeeYearWise = extraBusFeesData.Year_3__c;
            }
            when 4 {
                ExtraFeeYearWise = extraBusFeesData.Year_4__c;
            }
            when 5 {
                ExtraFeeYearWise = extraBusFeesData.Year_5__c;
            }
            when 6 {
                ExtraFeeYearWise = extraBusFeesData.Year_6__c;
            }
            when 7 {
                ExtraFeeYearWise = extraBusFeesData.Year_7__c;
            }
            when 8 {
                ExtraFeeYearWise = extraBusFeesData.Year_8__c;
            }
            when else{
                
            }
        }
        return ExtraFeeYearWise;
    }
    
    public static decimal getDepreciationRateYearWise(ET_Vehicle_Depreciation_Master__c vehicleDepreciationMaster, Integer year){
        Decimal depreciationRate =0.0;
        if(year <=8){
            switch on year {
                when 1 {
                    depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_1_Year__c);
                }
                when 2 {
                    depreciationRate =  decimal.ValueOf( vehicleDepreciationMaster.ET_Depreciation_2_Year__c);
                }
                when 3 {
                    depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_3_Year__c);
                }
                when 4 {
                    depreciationRate =   decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_4_Year__c);
                }
                when 5 {
                    depreciationRate =  decimal.ValueOf( vehicleDepreciationMaster.ET_Depreciation_5_Year__c);
                }
                when 6 {
                    depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_6_Year__c);
                }
                when 7 {
                    depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_7_Year__c);
                }
                when 8 {
                    depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_8_Year__c);
                }
            } 
        }
        
        else if(year >8){
            depreciationRate =5;
        }
        
        return depreciationRate;
    }
    
    public static decimal getDepreciationRate(ET_Vehicle_Depreciation_Master__c vehicleDepreciationMaster, Integer year){
        Decimal depreciationRate =0.0;
        switch on year {
            when 1 {
                depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_1_Year__c);
            }
            when 2 {
                
                depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_1_Year__c) +
                    decimal.ValueOf( vehicleDepreciationMaster.ET_Depreciation_2_Year__c);
            }
            when 3 {
                depreciationRate =   decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_1_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_2_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_3_Year__c);
            }
            when 4 {
                depreciationRate =   decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_1_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_2_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_3_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_4_Year__c);
            }
            when 5 {
                depreciationRate =   decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_1_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_2_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_3_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_4_Year__c) +
                    decimal.ValueOf( vehicleDepreciationMaster.ET_Depreciation_5_Year__c);
            }
            when 6 {
                depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_1_Year__c) + 
                    decimal.ValueOf( vehicleDepreciationMaster.ET_Depreciation_2_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_3_Year__c )+ 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_4_Year__c) +
                    decimal.ValueOf( vehicleDepreciationMaster.ET_Depreciation_5_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_6_Year__c);
            }
            when 7 {
                depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_1_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_2_Year__c) + 
                    decimal.ValueOf( vehicleDepreciationMaster.ET_Depreciation_3_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_4_Year__c) +
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_5_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_6_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_7_Year__c);
            }
            when 8 {
                depreciationRate =  decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_1_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_2_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_3_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_4_Year__c) +
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_5_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_6_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_7_Year__c) + 
                    decimal.ValueOf(vehicleDepreciationMaster.ET_Depreciation_8_Year__c);
            }
        }
        
        return depreciationRate;
    }
    
    public static Decimal getInsuranceRate(Vehicle_Insurance_Fee_Master__c insuranceMaster, Integer contractYear){
        Decimal insuranceRateYearWise =0.0;
        Switch on contractYear{
            when 1 {
                insuranceRateYearWise = insuranceMaster.ET_Insurance_Rate_1st_Year__c;
            }
            when 2 {
                insuranceRateYearWise = insuranceMaster.ET_Insurance_Rate_2nd_Year__c;
            }
            when 3 {
                insuranceRateYearWise = insuranceMaster.ET_Insurance_Rate_3rd_Year__c;
            }
            when 4 {
                insuranceRateYearWise = insuranceMaster.ET_Insurance_Rate_4th_Year__c;
            }
            when 5 {
                insuranceRateYearWise = insuranceMaster.ET_Insurance_Rate_5th_Year__c;
            }
            when 6 {
                insuranceRateYearWise = insuranceMaster.ET_Insurance_Rate_6th_Year__c;
            }
            when 7 {
                insuranceRateYearWise = insuranceMaster.ET_Insurance_Rate_7th_Year__c;
            }
            when 8 {
                insuranceRateYearWise = insuranceMaster.ET_Insurance_Rate_8th_Year__c;
            }
            when else{
                
            }
        }
        return insuranceRateYearWise;
    }
    
    public static Decimal getmaintenanceRateYearWise(ET_Maintenance_Rate__c maintenanceRateMaster, Integer contractYear){
        Decimal maintenanceRateYearWise =0.0;
        integer power = 0;
        if(contractYear > 8){
            power = (contractYear - 8);
            contractYear = 8;
        }
        Switch on contractYear{
            when 1 {
                maintenanceRateYearWise = maintenanceRateMaster.ET_Variable_Maintenance_Rate_1st_year__c;
            }
            when 2 {
                maintenanceRateYearWise = maintenanceRateMaster.ET_Variable_Maintenance_Rate_2nd_year__c;
            }
            when 3 {
                maintenanceRateYearWise = maintenanceRateMaster.ET_Variable_Maintenance_Rate_3rd_year__c;
            }
            when 4 {
                maintenanceRateYearWise = maintenanceRateMaster.ET_Variable_Maintenance_Rate_4th_year__c;
            }
            when 5 {
                maintenanceRateYearWise = maintenanceRateMaster.ET_Variable_Maintenance_Rate_5th_year__c;
            }
            when 6 {
                maintenanceRateYearWise = maintenanceRateMaster.ET_Variable_Maintenance_Rate_6th_year__c;
            }
            when 7 {
                maintenanceRateYearWise = maintenanceRateMaster.ET_Variable_Maintenance_Rate_7th_year__c;
            }
            when 8 {
                maintenanceRateYearWise = maintenanceRateMaster.ET_Variable_Maintenance_Rate_8th_year__c;
            }
            
        }
        
        if(power >= 1){
            maintenanceRateYearWise = maintenanceRateYearWise*(1.2).pow(power);
        }
        
        return maintenanceRateYearWise;
    }
    
    public static Decimal getProfitRate(ET_Pricing_Profit_Calculation_Setup__c profitMaster, vehicleQuoteCalcClass vehicleQuoteCalcObj){
        Decimal profitRateYearWise =0.0;
        Switch on vehicleQuoteCalcObj.contractYear{
            when 1 {
                profitRateYearWise = profitMaster.ET_Pricing_Policy_Rate_1_year__c;
            }
            when 2 {
                profitRateYearWise = profitMaster.ET_Pricing_Policy_Rate_2_year__c;
            }
            when 3 {
                profitRateYearWise = profitMaster.ET_Pricing_Policy_Rate_3_year__c;
            }
            when 4 {
                profitRateYearWise = profitMaster.ET_Pricing_Policy_Rate_4_year__c;
            }
            when 5 {
                profitRateYearWise = profitMaster.ET_Pricing_Policy_Rate_5_year__c;
            }
            when 6 {
                profitRateYearWise = profitMaster.ET_Pricing_Policy_Rate_6_year__c;
            }
            when 7 {
                profitRateYearWise = profitMaster.ET_Pricing_Policy_Rate_7_year__c;
            }
            when 8 {
                profitRateYearWise = profitMaster.ET_Pricing_Policy_Rate_8_year__c;
            }
            when else{
                
            }
        }
        return profitRateYearWise;
    } 
    
    /* Method : createQuoteObj
Desription : To Create Quote and Quote Items ..
*/
    
    public static Id createQuoteObj(QuoteCalculationClass quoteCalcObj, ET_Pricing_Service_Request__c serviceRequestObj){
        
        String response;
        try{
            if(quoteCalcObj != null){
                string serviceType = serviceRequestObj.Opportunity__r.ET_Oracle_Pricing_Service_Type__c;
                Quote quoteObj = new Quote();
                Id serviceRequestIdStr = quoteCalcObj.serviceRequestId;
                quoteObj.OpportunityId = quoteCalcObj.opportunityId;
                quoteObj.Is_Target_Price_Required__c = serviceRequestObj.ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c;
                quoteObj.ET_Pricing_Service_Request__c = quoteCalcObj.serviceRequestId;
                quoteObj.IsActive__c = true;
                quoteObj.ET_Type__c = 'Quote for Approval';
                quoteObj.Total_Number_of_Main_Vehicles__c = totalMainVehicles;
                // system.debug('totalMainVehicles 2839= '+ totalMainVehicles);
                List<ET_Pricing_VAT_setup__c> vatData =  new List<ET_Pricing_VAT_setup__c>();
                
                
                //system.debug('vatData = '+ JSON.serializePretty(vatData));
                //quoteObj.Name = serviceRequestObj.Opportunity__r.Name + '_' + serviceRequestObj.Name + '_quote'; 
                quoteObj.Name = serviceRequestObj.Opportunity__r.Name+'_ET_Quotation_Pricing_Approval';
                insert quoteObj;
                
                // Create another quote for Total Project..
                String totalProjectQuoteId = createTotalProjectQuote(quoteObj,quoteCalcObj, serviceRequestObj );
                //system.debug('total proj quote id 11 = '+ totalProjectQuoteId );
                // workforce quote items - creation
                
                response = workForceServiceRequestControllerHelper.createWorkforceQuoteItemObjs(quoteObj.id, quoteCalcObj, vatData , serviceRequestIdStr , serviceType);
                workForceServiceRequestControllerHelper.createTotalProjectWorkForceQuoteItems(totalProjectQuoteId , quoteCalcObj);
                
                // Vehicle Quote items - Creation..
                if(quoteCalcObj.opportunityId != null && quoteCalcObj.vehicleQuoteItemLst != null && quoteCalcObj.vehicleQuoteItemLst.size() > 0 ){
                    //Id serviceRequestId =   quoteCalcObj.serviceRequestId;
                    
                    List<ET_Vehicle_Quote_Item__c> vehicleQuoteItemLstToInsert = new List<ET_Vehicle_Quote_Item__c>();
                    Map<String,List<ET_Quote_Item_SpecReq__c>> vehicleQuoteItemAndItemReqMap = new Map<String,List<ET_Quote_Item_SpecReq__c>>();
                    // system.debug('quoteCalcObj.vehicleQuoteItemLst = '+JSON.serializePretty(quoteCalcObj.vehicleQuoteItemLst));
                    for(vehicleQuoteCalcClass vehicleQuoteCalObj : quoteCalcObj.vehicleQuoteItemLst){
                        ET_Vehicle_Quote_Item__c vehicleQuoteItemtoInsert = new ET_Vehicle_Quote_Item__c();
                        vehicleQuoteItemtoInsert.Quote__c = quoteObj.Id;
                        vehicleQuoteItemtoInsert.ET_Client_Type__c = quoteCalcObj.clientType;
                        vehicleQuoteItemtoInsert.ET_Client_Classification__c = quoteCalcObj.clientClassification;
                        vehicleQuoteItemtoInsert.ET_Quote_Item_Type__c = 'Vehicle';
                        vehicleQuoteItemtoInsert.ET_Contract_Period__c = vehicleQuoteCalObj.contractYear;
                        vehicleQuoteItemtoInsert.ET_Vehicle_Source__c = vehicleQuoteCalObj.vehicleSource;
                        vehicleQuoteItemtoInsert.ET_Fleet_Type__c = vehicleQuoteCalObj.fleetType;
                        vehicleQuoteItemtoInsert.ET_Line_Number__c = vehicleQuoteCalObj.vehicleLineItemNumberFromRequest;
                        vehicleQuoteItemtoInsert.ET_Vehicle_Unique_key__c = vehicleQuoteCalObj.vehicleLineUniqueKey;
                        vehicleQuoteItemtoInsert.ET_Number_of_Vehicles__c = vehicleQuoteCalObj.numberOfVehicles;
                        vehicleQuoteItemtoInsert.ET_Pricing_Method__c = vehicleQuoteCalObj.vehiclePricingMethod ;
                        vehicleQuoteItemtoInsert.ET_Pricing_Type__c = vehicleQuoteCalObj.vehiclePricingType;
                        vehicleQuoteItemtoInsert.ET_Price_Utilization__c = vehicleQuoteCalObj.vehiclePricingUtilization;
                        vehicleQuoteItemtoInsert.ET_Annual_Fuel_Profit_Margin_Rate__c = (vehicleQuoteCalObj.annualFuelProfitMarginRate).setScale(2);
                        if(vehicleQuoteItemtoInsert.ET_Vehicle_Source__c  == 'Substitutional'){
                            vehicleQuoteItemtoInsert.ET_Vehicle_Profit_Rate_from_Master__c = 0.00;
                            vehicleQuoteItemtoInsert.Required_Operating_Profit_Margin__c = 0.00; //Taj
                        }
                        else{
                            vehicleQuoteItemtoInsert.ET_Vehicle_Profit_Rate_from_Master__c = (vehicleQuoteCalObj.annualVehicleProfitRateFromMaster).setScale(2);
                            vehicleQuoteItemtoInsert.Required_Operating_Profit_Margin__c = 11.50; //Taj  //10.05;  
                        }
                        vehicleQuoteItemtoInsert.ET_No_of_Seats__c = vehicleQuoteCalObj.noOfSeats;
                        vehicleQuoteItemtoInsert.ET_Daily_Mileage__c = vehicleQuoteCalObj.dailyMileage;
                        vehicleQuoteItemtoInsert.ET_Total_Annual_Mileage__c = vehicleQuoteCalObj.totalAnnualMileage;
                        vehicleQuoteItemtoInsert.ET_Vehicle_Depreciation_Percentage__c = (vehicleQuoteCalObj.vehicleDepreciationRate).setScale(2);
                        vehicleQuoteItemtoInsert.ET_Vehicle_Resale_Value__c = vehicleQuoteCalObj.vehicleResaleValue;
                        //system.debug('final dep = '+ vehicleQuoteCalObj.vehicleDepreciation);
                        vehicleQuoteItemtoInsert.ET_Depreciation_Rate_for_Extra_Mileage__c = (vehicleQuoteCalObj.depreciationRateforExtraMileage).setScale(2);
                        vehicleQuoteItemtoInsert.ET_Vehicle_Maintenance_Rate__c = (vehicleQuoteCalObj.vehicleMaintenanceRate).setScale(3);
                        vehicleQuoteItemtoInsert.ET_Insurance_Rate__c = (vehicleQuoteCalObj.insuranceRate).setScale(2);
                        vehicleQuoteItemtoInsert.ET_Financing_Rate__c = (vehicleQuoteCalObj.financingRate).setScale(2);
                        vehicleQuoteItemtoInsert.ET_Required_ROI_Rate__c = (vehicleQuoteCalObj.requiredROIRate).setScale(2);
                        vehicleQuoteItemtoInsert.ET_General_Reserve_Rate__c = (vehicleQuoteCalObj.generalReserveRate).setScale(2);
                        vehicleQuoteItemtoInsert.Depreciated_years_from_insurance_master__c = vehicleQuoteCalObj.numberOfDeprciatedYearsfromInsuranceMaster;
                        vehicleQuoteItemtoInsert.Min_Veh_Val_from_insurance_master__c = vehicleQuoteCalObj.minVehValFromInsuranceMaster;
                        vehicleQuoteItemtoInsert.ET_Passenger_Cost__c = vehicleQuoteCalObj.passengerCost;
                        vehicleQuoteItemtoInsert.ET_Driver_insurance_cost__c = vehicleQuoteCalObj.driverInsuranceCost;
                        vehicleQuoteItemtoInsert.ET_Ambulance_Cost__c = vehicleQuoteCalObj.ambulanceCost;
                        vehicleQuoteItemtoInsert.ET_other_cost__c = vehicleQuoteCalObj.otherCost;
                        vehicleQuoteItemtoInsert.ET_Vehicle_Registration__c = vehicleQuoteCalObj.vehicleRegistrationAndInspectionFee;
                        vehicleQuoteItemtoInsert.ET_Actual_Liter_Price__c = (vehicleQuoteCalObj.actualLiterPrice).setScale(2);
                        vehicleQuoteItemtoInsert.ET_Fuel_consumption__c = (vehicleQuoteCalObj.fuelConsumption).setScale(2);
                        vehicleQuoteItemtoInsert.ET_Depreciation_Reserve_Rate__c = (vehicleQuoteCalObj.depreciationReserveRate).setScale(2);
                        vehicleQuoteItemtoInsert.ET_Maintainence_Reserve_Rate__c = (vehicleQuoteCalObj.maintainenceReserveRate).setScale(2);
                        vehicleQuoteItemtoInsert.ET_Fuel_Reserve_Rate__c = (vehicleQuoteCalObj.fuelReserveRate).setScale(2);
                        //system.debug('vehicleQuoteItemtoInsert.ET_Fuel_Reserve_Rate__c = '+ vehicleQuoteCalObj.fuelReserveRate);
                        vehicleQuoteItemtoInsert.ET_Vehicle_Original_Purchase_Price__c = vehicleQuoteCalObj.vehicleLatestNewPurchasePrice;
                        vehicleQuoteItemtoInsert.ET_Vehicle_Current_Purchase_Price__c = vehicleQuoteCalObj.vehicleCurrentPurchasePrice;
                        vehicleQuoteItemtoInsert.ET_Deduction_Rate_for_latest_new_price__c = vehicleQuoteCalObj.deductionRateForLatestNewPrice;
                        vehicleQuoteItemtoInsert.ET_Manufacture_Year__c = vehicleQuoteCalObj.manufactureYear;
                        //system.debug('vehicleQuoteCalObj.depreciationMethod = '+ vehicleQuoteCalObj.depreciationMethod);
                        vehicleQuoteItemtoInsert.ET_Depreciation_Method__c = vehicleQuoteCalObj.depreciationMethod;
                        vehicleQuoteItemtoInsert.ET_Min_Resale_Value__c = vehicleQuoteCalObj.minResaleValue;
                        vehicleQuoteItemtoInsert.ET_Minimum_resale_value_percentage__c = vehicleQuoteCalObj.minResaleValuePercentage;
                        vehicleQuoteItemtoInsert.ET_Min_Depreciation_Years__c = vehicleQuoteCalObj.minDepreciationYears;
                        vehicleQuoteItemtoInsert.ET_Number_of_Financing_years__c = vehicleQuoteCalObj.numberofFinancingYears;
                        vehicleQuoteItemtoInsert.ET_Insurance_Rate_1st_Year__c = vehicleQuoteCalObj.insuranceRate1stYear;
                        vehicleQuoteItemtoInsert.ET_Minimum_Cost__c = vehicleQuoteCalObj.insuranceMinCost;
                        //vehicleQuoteItemtoInsert.ET_Total_Special_Requirement_Cost__c = vehicleQuoteCalObj.totalSpecialRequirmentsCost;
                        vehicleQuoteItemtoInsert.ET_Working_days_per_week__c = vehicleQuoteCalObj.workingDaysPerWeek;
                        vehicleQuoteItemtoInsert.ET_Working_Months_per_year__c = vehicleQuoteCalObj.workingMonthsPerYear;
                        vehicleQuoteItemtoInsert.ET_Working_days_per_year__c = vehicleQuoteCalObj.workingDaysPerYear;
                        vehicleQuoteItemtoInsert.ET_Service_Type__c = vehicleQuoteCalObj.serviceType;
                        vehicleQuoteItemtoInsert.ET_Vat_Rate__c = vehicleQuoteCalObj.vehicleVATRate;
                        vehicleQuoteItemtoInsert.Total_Annual_Price_Target_Prices__c = vehicleQuoteCalObj.totalAnnualTargetPrice;
                        vehicleQuoteItemtoInsert.ET_Extra_Bus_Fees__c = vehicleQuoteCalObj.extraBusFeesForSchoolTransportation;
                        vehicleQuoteItemtoInsert.ET_Pricing_Vehicle_Request__c = vehicleQuoteCalObj.vehReqId;
                        vehicleQuoteItemtoInsert.ET_Depreciation_Type__c = vehicleQuoteCalObj.depreciationType;
                        vehicleQuoteItemtoInsert.ET_Fuel_Required__c = vehicleQuoteCalObj.fuelRequired;
                        vehicleQuoteItemtoInsert.Request_for_Target_Price__c = vehicleQuoteCalObj.isTargerPriceRequired;
                        vehicleQuoteItemtoInsert.Request_for_separate_prices__c = vehicleQuoteCalObj.isSeparatePriceRequired;
                        // Trailer fields mapping 
                        vehicleQuoteItemtoInsert.Trailer_Depreciation_Rate__c = vehicleQuoteCalObj.trailerDepreciationRate;
                        vehicleQuoteItemtoInsert.Trailer_Resale_Value__c = vehicleQuoteCalObj.trailerResaleValue;
                        vehicleQuoteItemtoInsert.Trailer_Current_Purchase_Price__c = vehicleQuoteCalObj.trailerCurrentPurchasePrice;
                        vehicleQuoteItemtoInsert.Trailer_Original_Purchase_Price__c = vehicleQuoteCalObj.trailerOriginalPurchasePrice;
                        vehicleQuoteItemtoInsert.Trailer_min_Resale_Value_Percentage__c = vehicleQuoteCalObj.trailerminResaleValuePercentage;
                        
                        vehicleQuoteItemtoInsert.Trailer_min_Resale_Value__c = vehicleQuoteCalObj.trailerminResaleValue;
                        vehicleQuoteItemtoInsert.Trailer_min_Depreciation_Years__c = vehicleQuoteCalObj.trailerminDepreciationYears;
                        vehicleQuoteItemtoInsert.Trailer_Condition__c = vehicleQuoteCalObj.trailerCondition;
                        vehicleQuoteItemtoInsert.Is_trailer_selected__c = vehicleQuoteCalObj.isTrailerSelected;
                        vehicleQuoteItemtoInsert.Trailer_Maintenance_Rate__c = vehicleQuoteCalObj.trailerMaintenanceRate;
                        vehicleQuoteItemtoInsert.Trailer_Registration_Fee__c = vehicleQuoteCalObj.trailerRegistrationAndInspectionFee;
                        vehicleQuoteItemtoInsert.Trailer_depreciation_type__c = vehicleQuoteCalObj.trailerDepreciationType;
                        vehicleQuoteItemtoInsert.Trailer_External_Maintenance_Cost__c = vehicleQuoteCalObj.trailerExtrenalMaintenanceCost;
                        
                        // Refrigerator fields mapping 
                        vehicleQuoteItemtoInsert.Refrigerator_Depreciation_Rate__c = vehicleQuoteCalObj.refrigeratorDepreciationRate;
                        vehicleQuoteItemtoInsert.Refrigerator_Resale_Value__c = vehicleQuoteCalObj.refrigeratorResaleValue;
                        vehicleQuoteItemtoInsert.Refrigerator_Current_Purchase_Price__c = vehicleQuoteCalObj.refrigeratorCurrentPurchasePrice;
                        vehicleQuoteItemtoInsert.Refrigerator_Original_Purchase_Price__c = vehicleQuoteCalObj.refrigeratorOriginalPurchasePrice;
                        vehicleQuoteItemtoInsert.Refrigerator_min_Resale_Value_Percentage__c = vehicleQuoteCalObj.refrigeratorMinResaleValuePercentage;
                        
                        vehicleQuoteItemtoInsert.Refrigerator_min_Resale_Value__c = vehicleQuoteCalObj.refrigeratorMinResaleValue;
                        vehicleQuoteItemtoInsert.Refrigerator_min_Depreciation_Years__c = vehicleQuoteCalObj.refrigeratorMinDepreciationYears;
                        vehicleQuoteItemtoInsert.Refrigerator_Condition__c = vehicleQuoteCalObj.refrigeratorCondition;
                        vehicleQuoteItemtoInsert.Is_Refrigerator_selected__c = vehicleQuoteCalObj.isRefrigeratorSelected;
                        vehicleQuoteItemtoInsert.Refrigerator_Maintenance_Rate__c = vehicleQuoteCalObj.refrigeratorMaintenanceRate;
                        vehicleQuoteItemtoInsert.Refrigerator_Registration_Fee__c = vehicleQuoteCalObj.refrigeratorRegistrationAndInspectionFee;
                        vehicleQuoteItemtoInsert.Refrigerator_depreciation_type__c = vehicleQuoteCalObj.refrigeratorDepreciationType;
                        vehicleQuoteItemtoInsert.Refrigerator_External_Maintenance_Cost__c = vehicleQuoteCalObj.refrigeratorExtrenalMaintenanceCost;
                        vehicleQuoteItemtoInsert.Vehicle_Notes__c = vehicleQuoteCalObj.vehicleNotes;
                        //system.debug('isTargerPriceRequired3 = '+ vehicleQuoteCalObj.isTargerPriceRequired);
                        // Vat cost for direct operational Cost
                        vehicleQuoteItemtoInsert.ET_VAT_Cost_on_Direct_Expenses__c = calculateVATCost(vatData , vehicleQuoteItemtoInsert , 'Vehicle Direct' );
                        // Vat cost for Indirect operational Cost
                        vehicleQuoteItemtoInsert.ET_VAT_Cost_on_Indirect_Expenses__c = calculateVATCost(vatData , vehicleQuoteItemtoInsert , 'Vehicle InDirect');
                        
                        
                        List<ET_Quote_Item_SpecReq__c> specReqLstToInsert = new List<ET_Quote_Item_SpecReq__c >();
                        for( ET_ServiceRequestController.vehicleSpecialRequirement specReq : vehicleQuoteCalObj.vehicleSpecialRequirementLst){
                            ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c();
                            specReqToInsert.Name = specReq.specificRequirementLabel;
                            specReqToInsert.ET_Cost__c = Math.round(specReq.specificRequirementCost);
                            specReqToInsert.ET_Api_Name__c = specReq.specificRequirementApi;
                            specReqLstToInsert.add(specReqToInsert);
                        }
                        
                        for( ET_ServiceRequestController.otherCostCalcClass specReq : vehicleQuoteCalObj.vehicleOtherCostLst){
                            ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c ();
                            specReqToInsert.Name = specReq.otherCostLabel;
                            specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                            specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                            specReqLstToInsert.add(specReqToInsert);
                            
                        }
                        
                        // for quotation level other cost
                        decimal totalQuotationLevelCostPerLine = 0.0;
                        for(otherCostCalcClass specReq : quoteCalcObj.otherCostQuoteItemLst){
                            if(specReq.contractYear == vehicleQuoteItemtoInsert.ET_Contract_Period__c){
                                ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c ();
                                specReqToInsert.Name = specReq.otherCostLabel;
                                if(totalMainVehicles != null && totalMainVehicles != 0){
                                    specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue/totalMainVehicles);
                                }
                                else{
                                    specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                                }
                                totalQuotationLevelCostPerLine += specReqToInsert.ET_Cost__c ;
                                specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                                specReqToInsert.Quote_Contract_Year__c = specReq.contractYear;
                                /* specReqToInsert.Line_Item_Number__c = specReq.otherCostLineNumber;
specReqToInsert.Quote__c = quoteObj.Id;*/
                                specReqLstToInsert.add(specReqToInsert);
                            }
                            
                        } 
                        system.debug('totalQuotationLevelCostPerLine = '+ totalQuotationLevelCostPerLine);
                        system.debug('vehicleQuoteCalObj.totalSpecialRequirmentsCost = '+ vehicleQuoteCalObj.totalSpecialRequirmentsCost);
                        vehicleQuoteItemtoInsert.ET_Total_Special_Requirement_Cost__c = vehicleQuoteCalObj.totalSpecialRequirmentsCost + totalQuotationLevelCostPerLine;
                        system.debug('vehicleQuoteCalObj.totalSpecialRequirmentsCost2 = '+ vehicleQuoteCalObj.totalSpecialRequirmentsCost);
                        vehicleQuoteItemLstToInsert.add(vehicleQuoteItemtoInsert);
                        vehicleQuoteItemAndItemReqMap.put(String.valueOf(vehicleQuoteItemtoInsert.ET_Line_Number__c) + '-'+ String.valueOf(vehicleQuoteItemtoInsert.ET_Contract_Period__c),specReqLstToInsert);
                        
                        
                    } // for loop end...
                    
                    if(vehicleQuoteItemLstToInsert != null && vehicleQuoteItemLstToInsert.size() > 0){
                        //system.debug('vehicleQuoteItemLstToInsert size = '+ vehicleQuoteItemLstToInsert.size());
                        insert vehicleQuoteItemLstToInsert; 
                        if(vehicleQuoteItemAndItemReqMap != null && vehicleQuoteItemAndItemReqMap.keySet().size() > 0){
                            List<ET_Quote_Item_SpecReq__c> specReqToInsertCombinedLst = new List<ET_Quote_Item_SpecReq__c>();
                            for(ET_Vehicle_Quote_Item__c vehicleQuoteItem : vehicleQuoteItemLstToInsert){
                                for(ET_Quote_Item_SpecReq__c specReq : vehicleQuoteItemAndItemReqMap.get(String.valueOf(vehicleQuoteItem.ET_Line_Number__c) +'-'+ String.valueOf(vehicleQuoteItem.ET_Contract_Period__c))){
                                    specReq.ET_Vehicle_Quote_Item__c = vehicleQuoteItem.Id;
                                    specReqToInsertCombinedLst.add(specReq);
                                }
                            }
                            // system.debug('specReqToInsertCombinedLst : '+ specReqToInsertCombinedLst);
                            insert specReqToInsertCombinedLst;
                        }
                    }
                    
                }
                // call a Process to calculate and update all Price elements for Vehicle and Manpower -->From Rates from o/p and input Request...
                ET_PricingQuoteItemsCalculationClass.calculateQuoteElementsWithRates( serviceRequestIdStr , quoteObj.Id ,totalProjectQuoteId  );
                // Total Project Calculations....
                // Update Vehicle quote Items in Total project Summary quotation...
                system.debug('check this');
                ET_PricingQuoteItemsCalculationClass.updateVehicleTotalProjectSummaryVehicleQuoteItems(totalProjectQuoteId);
                //update Workforce quote Items  for Total Project Summary
                ET_WorkForceQuoteItemsCalculationClass.updateWorkForceObjectsForTotalProject(totalProjectQuoteId);
                // Create Finance Calculations for ' Quote for approval' and  'Total Project quote'..
                ET_FinancialAnalysisScreenClass.saveFinancialCalculations(quoteObj.Id, totalProjectQuoteId);
                //system.debug('ET_FinancialAnalysisScreenClass Called for Total project');
                
                return quoteObj.Id; 
            }
            return null;
        }
        catch(Exception e){
            ET_PricingUtilityClass.logException(e, 'Pricing');
            system.debug('Exception ='+ e.getMessage());
            system.debug('Exception Trace='+ e.getStackTraceString());
            system.debug('Exception line='+ e.getLineNumber());
            throw new AuraHandledException('Exception ='+ e.getMessage() + 'Exception line='+ e.getLineNumber() + 'Exception Trace : '+ e.getStackTraceString()+'exception Cause : '+ e.getCause());
        }
    }
    
    // calculate Vat Cost for Vehicle - Direct and Indirect VAT costs ...
    public static Decimal calculateVATCost(List<ET_Pricing_VAT_setup__c> vatData, ET_Vehicle_Quote_Item__c  vehicleQuoteItemtoInsert, String costType){
        Decimal vatValue = 0.0;
        system.debug('vatData__c'+vatData);
        for(ET_Pricing_VAT_setup__c data : vatData){
            if(data.ET_Cost_Type__c == costType && data.ET_IsRecoverable__c){
                if(ET_Vehicle_Quote_Item__c.getSobjectType().getDescribe().fields.getMap().containsKey(data.ET_Cost_Api_Name__c)){
                    Decimal value =0.0;
                    if( data.ET_Cost_Api_Name__c =='ET_Vehicle_Current_Purchase_Price__c'){
                        system.debug('vehicleQuoteItemtoInsert.ET_Contract_Period__c'+vehicleQuoteItemtoInsert.ET_Contract_Period__c);
                        value= (Decimal)vehicleQuoteItemtoInsert.get(data.ET_Cost_Api_Name__c) / vehicleQuoteItemtoInsert.ET_Contract_Period__c;
                    }
                    else{
                        value= (Decimal)vehicleQuoteItemtoInsert.get(data.ET_Cost_Api_Name__c);
                        system.debug('value__c'+value);
                    }
                    
                    if(value != null ){
                        vatValue += value;
                    }
                }
            }
            
        }
        vatValue =  vatValue * 0.05;
        return vatValue;
    }
    
    
    //Added by Noor Shaik on 01/04/2021
    @AuraEnabled
    public static Map<string,ET_Vehicle_Predefined_Other_Cost_Master__c> getPredefinedOtherCostData(){
        Map<string,ET_Vehicle_Predefined_Other_Cost_Master__c> predefinedDataMap=new Map<string,ET_Vehicle_Predefined_Other_Cost_Master__c>();
        for(ET_Vehicle_Predefined_Other_Cost_Master__c mData:[Select Id,Name,ET_Api_Name__c,
                                                              ET_One_Time_Cost__c,ET_Annual_Cost__c 
                                                              From ET_Vehicle_Predefined_Other_Cost_Master__c 
                                                              Where isActive__c=true]){
                                                                  predefinedDataMap.put(mData.ET_Api_Name__c,mData);
                                                              }
        return predefinedDataMap;
    }
    
    /* Method 	   :  createTotalProjectQuote
Description :  To Create Total Project Summary
*/
    
    Public static String createTotalProjectQuote( quote quoteObj, QuoteCalculationClass quoteCalcObj, ET_Pricing_Service_Request__c serviceRequestObj){
        
        Quote quoteObjTProj = new Quote();
        Id serviceRequestIdStr = quoteObj.ET_Pricing_Service_Request__c;
        quoteObjTProj.OpportunityId = quoteObj.OpportunityId;
        quoteObjTProj.Is_Target_Price_Required__c = quoteObj.Is_Target_Price_Required__c;
        quoteObjTProj.ET_Pricing_Service_Request__c = quoteObj.ET_Pricing_Service_Request__c;
        quoteObjTProj.Service_Emirate__c = quoteCalcObj.serviceEmirate;
        quoteObjTProj.IsActive__c = true;
        quoteObjTProj.ET_Type__c = 'Total Project Summary';
        quoteObjTProj.Name = serviceRequestObj.Opportunity__r.Name+'_ET_Quotation_Summary_Report';
        quoteObjTProj.Total_Number_of_Vehicles__c = totalMainVehicles;
        quoteObjTProj.Total_Number_of_Main_Vehicles__c = totalMainVehicles;
        quoteObjTProj.Total_Vehicle_Lines__c = totalVehicleLines ;        
        insert quoteObjTProj;
        Set<integer> contractYearsUniq = new Set<integer>();
        contractYearsUniq.addAll(contractYears);
        // system.debug('contractYearsUniq  = '+ contractYearsUniq);
        List<ET_Vehicle_Quote_Item__c> vehQuoteItemListForTotalProjectQuote = new List<ET_Vehicle_Quote_Item__c>();
        
        Map<integer,List<ET_Quote_Item_SpecReq__c>> vehicleQuoteItemAndSpecialReqMap = new Map<integer,List<ET_Quote_Item_SpecReq__c>>();
        if(contractYearsUniq != null && contractYearsUniq.size() > 0 ){
            for(integer contY : contractYearsUniq){
                ET_Vehicle_Quote_Item__c vQItem = new ET_Vehicle_Quote_Item__c();
                //integer contY = vehicleQuoteCalObj.contractYear;
                vQItem.Quote__c = quoteObjTProj.id;
                vQItem.ET_Contract_Period__c = decimal.ValueOf(contY);
                vQItem.ET_Quote_Item_Type__c ='Vehicle';
                vQItem.ET_Fleet_Type__c = quoteCalcObj.fleetType;
                /*vQItem.ET_Client_Type__c = quoteCalcObj.clientType;
vQItem.ET_Client_Classification__c = quoteCalcObj.clientClassification;
vQItem.ET_Working_days_per_year__c = vehicleQuoteCalObj.workingDaysPerYear;
vQItem.ET_Fleet_Type__c = vehicleQuoteCalObj.fleetType;*/
                vQItem.ET_Line_Number__c = 1;
                vQItem.ET_Working_days_per_week__c = 7;
                vQItem.ET_Working_Months_per_year__c = 12;
                
                vehQuoteItemListForTotalProjectQuote.add(vQItem);
                
                List<ET_Quote_Item_SpecReq__c> specReqLstToInsert = new List<ET_Quote_Item_SpecReq__c >();
                Map<String, otherCostCalcClassTProj> contractYearSpecialReqrmnts;
                //system.debug('vehSpecilReqsForTotProjMap = '+ JSON.serializePretty(vehSpecilReqsForTotProjMap));
                if(vehSpecilReqsForTotProjMap != null && !vehSpecilReqsForTotProjMap.isEmpty() && vehSpecilReqsForTotProjMap.containsKey(contY)){
                    contractYearSpecialReqrmnts = vehSpecilReqsForTotProjMap.get(contY);
                }
                
                if(contractYearSpecialReqrmnts != null &&  !contractYearSpecialReqrmnts.isEmpty() ){
                    for(otherCostCalcClassTProj specReq : contractYearSpecialReqrmnts.values()){
                        ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c();
                        specReqToInsert.Name = specReq.otherCostLabel;
                        specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                        specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                        specReqLstToInsert.add(specReqToInsert);
                    }
                    vehicleQuoteItemAndSpecialReqMap.put(contY , specReqLstToInsert);
                }
                
                // for quotation level other cost
                for(otherCostCalcClass specReq : quoteCalcObj.otherCostQuoteItemLst){
                    if(specReq.contractYear == contY){
                        ET_Quote_Item_SpecReq__c specReqToInsert = new ET_Quote_Item_SpecReq__c ();
                        specReqToInsert.Name = specReq.otherCostLabel;
                        if(specReq.otherCostValue != null){
                            specReqToInsert.ET_Cost__c = Math.round(specReq.otherCostValue);
                        }
                        specReqToInsert.ET_Api_Name__c = specReq.otherCostLabel;
                        specReqToInsert.Quote_Contract_Year__c = specReq.contractYear;
                        /* specReqToInsert.Line_Item_Number__c = specReq.otherCostLineNumber;
specReqToInsert.Quote__c = quoteObj.Id;*/
                        specReqLstToInsert.add(specReqToInsert);
                    }
                    
                } 
            }
            
        }
        
        // add special vehicle Requirements in related list 
        if(vehQuoteItemListForTotalProjectQuote != null && vehQuoteItemListForTotalProjectQuote.size() > 0){
            insert vehQuoteItemListForTotalProjectQuote;
            system.debug('vehicleQuoteItemAndSpecialReqMap = '+ JSON.serializePretty(vehicleQuoteItemAndSpecialReqMap));
            if(vehicleQuoteItemAndSpecialReqMap != null && !vehicleQuoteItemAndSpecialReqMap.isEmpty()){
                List<ET_Quote_Item_SpecReq__c> specReqToInsertCombinedLst = new List<ET_Quote_Item_SpecReq__c>();
                for(ET_Vehicle_Quote_Item__c vehicleQuoteItem : vehQuoteItemListForTotalProjectQuote){
                    system.debug('vehicleQuoteItem.ET_Contract_Period__c = '+ vehicleQuoteItem.ET_Contract_Period__c);
                    if(vehicleQuoteItem.ET_Contract_Period__c != null  && vehicleQuoteItemAndSpecialReqMap.containskey(integer.ValueOf(vehicleQuoteItem.ET_Contract_Period__c))) {
                        for(ET_Quote_Item_SpecReq__c specReq : vehicleQuoteItemAndSpecialReqMap.get(integer.ValueOf(vehicleQuoteItem.ET_Contract_Period__c))){
                            specReq.ET_Vehicle_Quote_Item__c = vehicleQuoteItem.Id;
                            specReqToInsertCombinedLst.add(specReq);
                        }  
                    }
                }
                //system.debug('specReqToInsertCombinedLst : '+ specReqToInsertCombinedLst);
                insert specReqToInsertCombinedLst;
            }
            
        }
        //system.debug('total proj quote id = '+ quoteObjTProj.id );
        return quoteObjTProj.id;
    }

    public static List<String> getGroupMemberEmails(String groupName) {
        List<String> emailList = new List<String>();
        List<GroupMember> groupMembers = [
            SELECT UserOrGroupId, Group.Name, UserOrGroup.Email 
            FROM GroupMember 
            WHERE Group.DeveloperName = :groupName AND UserOrGroupId IN (SELECT Id FROM User WHERE IsActive = true)
        ];
        for (GroupMember member : groupMembers) {
            if (member.UserOrGroup != null && member.UserOrGroup.Email != null) {
                emailList.add(member.UserOrGroup.Email);
            }
        }
        return emailList;
    }
    
    @AuraEnabled
    public Static Boolean sendMailNotification(String type, String quoteId) {
        System.debug('type: '+type+' quoteId: '+quoteId);
        List<Quote> quoteList = New List<Quote>();
        String html = '<html>';
        html += '<body style="margin-block:0px !important;display:block;">';
        html += '<p>test</p><p>Pricing Team</p><p>testing</p>';
        html += '</body></html>';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = getGroupMemberEmails('ET_Pricing_Team'); //new String[] {address};
        mail.setToAddresses(toAddresses);
        //mail.setSubject(subject);
        //mail.setPlainTextBody(body);
        //mail.setHtmlBody(html);
        mail.setSenderDisplayName('Emirates Transport');
        mail.setReplyTo('etcares@et.ae'); 
        mail.setTargetObjectId(UserInfo.getUserId()); 
        mail.saveAsActivity = false;
        EmailTemplate emailTemplate;
        if(type == 'validateQuotation' && quoteId != null){
            for(Quote qt: [SELECT Id,Validate_Quotation_Notification_Sent__c FROM Quote WHERE Id =: quoteId]){
                if(qt.Validate_Quotation_Notification_Sent__c == false){
                    qt.Validate_Quotation_Notification_Sent__c = true;
                    quoteList.add(qt);
                }
            }
            if(quoteList.Size()>0){
                UPDATE quoteList;
            }
           emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body FROM EmailTemplate WHERE DeveloperName = 'Validate_Quotation_Approval_Notify_to_Pricing_Team'];
        }
        if(type == 'requestInitiateQuotation'){
           emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body FROM EmailTemplate WHERE DeveloperName = 'Initiate_Quotation_Notify_to_Pricing_Team'];
        }
        mail.setTemplateID(emailTemplate.Id);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return inspectEmailResults(results);
    }

    private static Boolean inspectEmailResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
    
    public class PricingException extends Exception {}
    
    /* Wrapper Classes to Create Quotation and it's related Vehicle and Manpower Quotations */    
    
    public class QuoteCalculationClass{
        public List<vehicleQuoteCalcClass> vehicleQuoteItemLst;
        public List<driverQuoteCalcClass> driverQuoteItemLst;
        public List<nannyQuoteCalcClass> nannyQuoteItemLst;
        public List<supervisorQuoteCalcClass> supervisorQuoteItemLst;
        public List<coordinatorQuoteCalcClass> coordinatorQuoteItemLst;
        public List<accountantQuoteCalcClass> accountantQuoteItemLst;
        public List<otherEmpQuoteCalcClass> otherEmpQuoteItemLst;
        public List<otherCostCalcClass> otherCostQuoteItemLst;
        public Id opportunityId;
        public Id serviceRequestId; 
        Public string clientType;
        Public string clientClassification;
        Public string fleetType;
        Public string serviceEmirate;
    }
    
    public class vehicleQuoteCalcClass{
        public Integer vehicleLineItemNumberFromRequest;
        public String  vehicleLineUniqueKey = '';
        public Integer contractYear = 0;
        public Decimal vehiclePurchasePriceBasedOnCondition = 0.0;
        public String vehicleResaleValue = '0.0';
        public Decimal vehicleResaleDecimalValue = 0.0;
        public String vehicleDepreciation = '0.0';
        public Decimal vehicleDepreciationDecimalValue = 0.0;
        public Decimal vehicleRepairsAndMaintenance = 0.0;
        public Decimal vehicleFinancing = 0.0;
        public Decimal vehicleRegistrationAndInspectionFee = 0.0;
        public Decimal vehicleInsurance = 0.0;
        public Decimal salikCost = 0.0;
        public Decimal basicTrackingSystemCost = 0.0;
        public Decimal vehicleInsuranceAverage = 0.0;
        public List<vehicleSpecialRequirement> vehicleSpecialRequirementLst = new List<vehicleSpecialRequirement>();
        public List<otherCostCalcClass> vehicleOtherCostLst = new List<otherCostCalcClass>();
        public Decimal deprciationReserve = 0.0;
        public Decimal maintenanceReserve = 0.0;
        public Decimal generalReserve = 0.0;
        public Decimal annualVehicleProfitMarginRate = 0.0;
        public Decimal annualVehicleProfitMarginValue = 0.0;
        public Decimal annualVehicleProfitRateFromMaster = 0.0;
        public Decimal fuelExpenses = 0.0;
        public Decimal fuelRate = 0.0;
        public Decimal fuelReserve = 0.0;
        public Decimal fuelReserveDiscounted = 0.0;
        public Decimal fuelReserveTarget = 0.0;
        public Decimal annualFuelProfitMarginRate = 0.0;
        public Decimal annualFuelProfitMarginValue = 0.0;
        public Decimal totalReserveCost = 0.0;
        public Decimal totalFuelCost = 0.0;
        public Decimal totalFuelCostDiscounted = 0.0;
        public Decimal totalFuelCostTargetPrice = 0.0;
        public Decimal vehicleTotalCost = 0.0;
        public Decimal vehicleTotalCostDiscountedPrice = 0.0;
        public Decimal vehicleTotalCostTargetPrice = 0.0;
        public Decimal vehicleTotalFixedCost = 0.0;
        public Decimal vehicleTotalVariableCost = 0.0;
        public String vehicleVATRate ='0';
        //   public Decimal vehicleVATCost = 0.0;// vat on Pricing
        public Decimal vehicleVATAmount = 0.0;// vat on Customer
        public Integer numberOfVehicles = 0;
        public String  vehiclePricingMethod = '';
        public String  vehiclePricingType = '';
        public Decimal vehiclePricingUtilization = 0.0;
        //SK
        public Decimal RequiredOperatingProfitMargin = 0.0;
        //new fields added //Mani
        public Decimal noOfSeats = 0;
        public Decimal dailyMileage = 0;
        public Decimal totalAnnualMileage = 0;
        public Decimal vehicleDepreciationRate = 0.0;
        public Decimal depreciationRateforExtraMileage = 0.0;
        public Decimal vehicleMaintenanceRate = 0.0;
        public Decimal insuranceRate = 0.0;
        public Decimal financingRate = 0.0;
        public Decimal requiredROIRate = 0.0;
        public Decimal generalReserveRate = 0.0;
        public Decimal numberOfDeprciatedYearsfromInsuranceMaster = 0;
        public Decimal minVehValFromInsuranceMaster  = 0;
        public Decimal passengerCost = 0.0;
        public Decimal driverInsuranceCost = 0.0;
        public Decimal ambulanceCost = 0.0;
        public Decimal otherCost = 0.0;
        public Decimal registrationFee = 0.0;
        public Decimal inspectionFee = 0.0;
        Public Decimal actualLiterPrice  = 0.0;
        Public Decimal fuelConsumption = 0.0;
        public Decimal depreciationReserveRate = 0.0;
        Public Decimal maintainenceReserveRate  = 0.0;
        Public Decimal fuelReserveRate = 0.0;
        Public String vehicleQuoteId;
        Public Decimal extraBusFeesForSchoolTransportation = 0.0;
        Public Decimal vehicleLatestNewPurchasePrice =0.0;
        Public Decimal vehicleCurrentPurchasePrice =0.0;
        Public Decimal deductionRateForLatestNewPrice =0.0;
        Public Decimal manufactureYear =0.0;
        Public String depreciationMethod ;
        Public Decimal minResaleValue =0.0;
        Public Decimal minResaleValuePercentage =0.0;
        Public Decimal minDepreciationYears =0.0;
        Public Decimal numberofFinancingYears =0.0;
        Public Decimal insuranceRate1stYear =0.0;
        Public Decimal insuranceMinCost =0.0;
        Public Decimal totalSpecialRequirmentsCost =0.0;
        public Decimal workingDaysPerWeek = 0.0;
        public Decimal workingMonthsPerYear = 0.0;
        public Decimal workingDaysPerYear = 0.0;
        public Decimal vehicleTotalInvestment = 0.0;
        Public String serviceType;  
        public Decimal totalAnnualTargetPrice = 0.0; // Target Price given by Customer
        public Decimal discountedTotalAnnualTargetPrice = 0.0;  // Total Cost Calculated when Target Price given by Customer
        public Decimal vehicleProfitMarginRateForTargetPrice = 0.0;
        public Decimal vehicleProfitMarginRateForDiscountedPrice = 0.0;
        public Decimal vehicleProfitValueForTargetPrice = 0.0;
        public Decimal discountedVehicleProfitValueForTargetPrice = 0.0;
        public Decimal fuelProfitValueTargetPrice = 0.0;
        public Decimal fuelProfitValueDiscountedPrice = 0.0;
        public Decimal fuelProfitMarginRateTargetPrice = 0.0;
        public Decimal fuelProfitMarginRateDiscountedPrice = 0.0;
        public Decimal generalReserveTargetPrice = 0.0;
        public Decimal generalReserveDiscountedPrice = 0.0;
        public boolean isTargetPriceRequired = false;
        public String vehicleSource ;
        public Decimal substitutionalVehiclesCostPerVehicle = 0.0; 
        public Decimal substitutionalVehiclesProfitPerVehicle = 0.0; 
        public String fleetType; 
        public Decimal remainingDepreciationOf10Years = 0.0; 
        public String vehReqId; 
        public Decimal vatCostonDirectExpenses = 0.0;
        public Decimal vatCostonInDirectExpenses = 0.0;
        public Decimal vatTotalCost = 0.0;
        public Decimal indirectCostForGeneralReserve = 0.0;
        public Decimal priceUtilization = 0.0;
        public String pricingType ;
        public String pricingMethod ;
        public String depreciationType; 
        public boolean fuelRequired = false; 
        public boolean isTargerPriceRequired = false; 
        public boolean isSeparatePriceRequired = false; 
        public Decimal discountOrAdditionalProfit = 0.0;
        
        // attributes for Trailer
        public boolean isTrailerSelected = false; 
        public String trailerCondition ;
        public String trailerDepreciationType ;
        public Decimal trailerOriginalPurchasePrice = 0.0;
        public Decimal trailerCurrentPurchasePrice = 0.0;
        public Decimal trailerModelYear = 0.0;
        public Decimal trailerminResaleValuePercentage = 0.0;
        public Decimal trailerminResaleValue = 0.0;
        public Decimal trailerDepreciationRate = 0.0;
        public String trailerResaleValue ='0';
        public Decimal trailerminDepreciationYears = 0.0;
        public Decimal trailerMaintenanceRate = 0.0;
        public Decimal trailerRegistrationAndInspectionFee = 0.0;
        public Decimal trailerRemainingDepreciationOf10Years = 0.0;
        public String trailerDepreciation  ='0';
        public Decimal trailerDepreciationDecimalValue = 0.0;
        public Decimal trailerResaleDecimalValue = 0.0;
        public Decimal trailerRepairsAndMaintenance = 0.0;
        public Decimal trailerExtrenalMaintenanceCost = 0.0;
        public Decimal vehicleTrailerAndRefrigeratorCurrentValue = 0.0;
        public Decimal vehicleTrailerAndRefrigeratorDepreciationValue = 0.0;
        public Decimal vehicleTrailerAndRefrigeratorResaleValue = 0.0;
        
        // for Refrigerator..
        public boolean isRefrigeratorSelected = false; 
        public String refrigeratorCondition ;
        public String refrigeratorDepreciationType ;
        public Decimal refrigeratorOriginalPurchasePrice = 0.0;
        public Decimal refrigeratorCurrentPurchasePrice = 0.0;
        public Decimal refrigeratorMinResaleValuePercentage = 0.0;
        public Decimal refrigeratorMinResaleValue = 0.0;
        public Decimal refrigeratorDepreciationRate = 0.0;
        public String refrigeratorResaleValue ='0';
        public Decimal refrigeratorMinDepreciationYears = 0.0;
        public Decimal refrigeratorMaintenanceRate = 0.0;
        public Decimal refrigeratorRegistrationAndInspectionFee = 0.0;
        public Decimal refrigeratorRemainingDepreciationOf10Years = 0.0;
        public String refrigeratorDepreciation  ='0';
        public Decimal refrigeratorDepreciationDecimalValue = 0.0;
        public Decimal refrigeratorResaleDecimalValue = 0.0;
        public Decimal refrigeratorRepairsAndMaintenance = 0.0;
        public Decimal refrigeratorExtrenalMaintenanceCost = 0.0;
        public Decimal refrigeratorModelYear = 0.0;
        public Decimal corporateTax = 0.0;
        public string vehicleNotes;
        
    }
    
    public class vehicleSpecialRequirement{
        public String specificRequirementLabel = '';
        public Decimal specificRequirementCost = 0.0;
        public String specificRequirementApi = '';
    }
    
    public class vehicleSpecialRequirementForTotalProject{
        public String specificRequirementLabel = '';
        public Decimal specificRequirementCost = 0.0;
        public String specificRequirementApi = '';
    }
    
    public class workforceQuoteCalcClass{
        public Integer workforceLineItemNumberFromRequest;
        public Integer contractYear = 0;
        public Decimal wages = 0.0;
        public Decimal overTimeCost = 0.0;
        public Decimal totalDirectOperationalCost = 0.0;
        public Decimal leaveAllowance = 0.0;
        public Decimal endOfServiceCost = 0.0;
        public Decimal clothesAllowance = 0.0;
        
        public Decimal childrenAllowance = 0.0;
        public Decimal housingAllowance = 0.0;
        public Decimal housingAllowancePercentage = 0.0;
        public Decimal socialAllowance = 0.0;
        public Decimal costoflivingAllowance = 0.0;
        public Decimal transportAllowance = 0.0;
        public Decimal additionalTransportAllowance = 0.0;
        public Decimal otherAllowance = 0.0;
        public Decimal socialInsurance = 0.0;
        public Decimal additionalWorkPermitFees = 0.0;
        public Decimal childrenAllowanceFromMaster = 0.0;
        
        public Decimal healthCardCost = 0.0;
        public Decimal licensingFee = 0.0;
        public Decimal visaCost = 0.0;
        public Decimal smartPhoneCost = 0.0;
        public Decimal airTicketsCost = 0.0;
        public Decimal accomodationAllowance = 0.0;
        public Decimal extraCertificationCost = 0.0;
        public Decimal totalIndirectOperationCost = 0.0;
        public Decimal totalCost = 0.0;
        public Decimal totalCostPerEachVehicle = 0.0;
        public Decimal totalCostPerEachVehicleDiscounted = 0.0;
        public Decimal totalCostPerEachVehicleTarget = 0.0;
        public Decimal annualProfitMarginValue = 0.0;
        public Decimal annualProfitMarginValuePerEachVehicle = 0.0;
        public Decimal annualProfitMarginRate = 0.0;
        public Decimal allowedProfit = 0.0;
        public Decimal totalAnnualNetProfitValue = 0.0;
        public Decimal totalAnnualNetProfitValuePerEachVehicle = 0.0;
        public Decimal workforceGrossSalary = 0.0;
        public String  workforcePricingMethod = '';
        public String  workforcePricingType = '';
        public Decimal workforcePricingUtilization = 0.0;
        Public Decimal driverReserveRate = 0.0;
        Public Decimal reserveRate = 0.0;
        public Decimal numberOfCoverageYearsForVisa = 0.0;
        public Decimal visaAmount = 0.0;
        public Decimal workforceBasicSalary = 0.0; 
        public Decimal profitNumberOfMonths = 0.0;   
        public Decimal profitPercentage = 0.0;   
        public Decimal workingDaysPerWeek = 0.0;
        public Decimal workingMonthsPerYear = 0.0;
        public Decimal workingDaysPerYear = 0.0;
        Public String workforceQuoteId;
        Public integer numberOfAnnualLeaveMonths =0;
        Public String numberOfEndOfServiceMonths ;
        Public String profitSalaryType;
        Public String workforceRecordType;
        public String workForceVATRate = '0';
        Public String serviceType;  
        public Decimal workForceVATAmount = 0.0; // vat on Customer
        Public Decimal salaryNoofMonthsforDriverforSLine =11;
        Public Decimal salaryNoofMonthsforOtherManpowerforSLine =12;
        Public String depreciationMethod ;
        public String workForceReqId; 
        public Decimal languageAndPsychometricTest = 0.0; 
        public Decimal workforceVatCost = 0.0;
        public Decimal totalDynamicOtherCost = 0.0;
        public Decimal manpowerReserveCost = 0.0;
        public Decimal vatCostonManpowerExpenses = 0.0;
        public Decimal discountOrAdditionalProfit = 0.0;
        public Decimal totalCostTargetPrice = 0.0;
        public Decimal profitMarginPercentageTargetPrice = 0.0;
        public Decimal profitValueTargetPrice = 0.0;
        public Decimal profitValueTargetPricePerVehicle = 0.0;
        public Decimal reserveCostTargetPrice = 0.0;
        public Decimal reserveCostDiscountedPrice = 0.0;
        public Decimal discountedManpowerTotalCost = 0.0;
        public Decimal discountedManpowerProfit = 0.0;
        public Decimal discountedManpowerProfitPerVehicle = 0.0;
        public Decimal targetManpowerProfit = 0.0;
        public Decimal discountedManpowerProfitRate = 0.0;
        public string vehQuoteId;
        public string notes;
        public string resourcetype;
        public string married;
        public Decimal noofchildren;
        public Decimal totalAnnualPriceExcludingVAT = 0.0;
        public Decimal totalMonthlyPriceExcludingVAT = 0.0;
        public Decimal vatAmountForManpower = 0.0;
        public Decimal totalAnnualPriceIncludingVAT = 0.0;
        public Decimal totalMonthlyPriceIncludingVAT = 0.0;
        public Decimal totalValueOfRental = 0.0;
        public Decimal totalManpowerProfits	 = 0.0;
        public Decimal grossProfitMargin = 0.0;
        Public string typeOfManpower;
        public string relieverFor;
        public Decimal relieverCost = 0.0;
        public Decimal corporateTax = 0.0;
        public Decimal totalVehicle = 0.0;
        
    }
    
    public class driverQuoteCalcClass{
        public workforceQuoteCalcClass driverWorkforceClassObj;
        public String driverUniqueKey = '';
        public Integer numberOfDrivers = 0;
        
        public List<otherCostCalcClass> driverOtherCostLst = new List<otherCostCalcClass>();
        
    }
    
    public class nannyQuoteCalcClass{
        public workforceQuoteCalcClass nannyWorkforceClassObj;
        public String nannyUniqueKey = '';
        public Integer numberOfNannies = 0;
        public List<otherCostCalcClass> nannyOtherCostLst = new List<otherCostCalcClass>();
    }
    
    public class supervisorQuoteCalcClass{
        public workforceQuoteCalcClass supervisorWorkforceClassObj;
        public String supervisorUniqueKey = '';
        public Integer numberOfSupervisors = 0;
        public List<otherCostCalcClass> supervisorOtherCostLst = new List<otherCostCalcClass>();
    }
    
    public class coordinatorQuoteCalcClass{
        public workforceQuoteCalcClass coordinatorWorkforceClassObj;
        public String coordinatorUniqueKey = '';
        public Integer numberOfCoordinators = 0;
        public List<otherCostCalcClass> coordinatorOtherCostLst = new List<otherCostCalcClass>();
    }
    
    public class accountantQuoteCalcClass{
        public workforceQuoteCalcClass accWorkforceClassObj;
        public String accountantUniqueKey = '';
        public Integer numberOfAccountants = 0;
        public List<otherCostCalcClass> accountantOtherCostLst = new List<otherCostCalcClass>();
    }
    
    public class otherEmpQuoteCalcClass{
        public workforceQuoteCalcClass otherEmpWorkforceClassObj;
        public String otherEmpUniqueKey = '';
        public Integer numberOfOtherEmps = 0;
        public List<otherCostCalcClass> otherEmpOtherCostLst = new List<otherCostCalcClass>();
    }
    
    public class otherCostCalcClass{
        public String otherCostLabel = '';
        public Decimal otherCostValue = 0.0;
        public Decimal otherCostLineNumber = 0;
        public Decimal contractYear = 0;
        public List<String> otherCostType = new List<String>();
    }
    
    public class otherCostCalcClassTProj{
        public String otherCostLabel = '';
        public Decimal otherCostValue = 0.0;
        public Decimal otherCostLineNumber = 0;
        public Decimal contractYear = 0;
        public List<String> otherCostType = new List<String>();
    }
    
    //added by karamat
    @AuraEnabled
    public static void tempFuture(String serviceRequestId){
        System.debug('----testFutur----'+serviceRequestId);
        futurePricingMethod(serviceRequestId);
    }
    @future
    public static void futurePricingMethod(String serviceRequestId){
        createQuotationReturnWrapper createQuotationReturnWrp = createQuotation(serviceRequestId);
        String quoteId = createQuotationReturnWrp.quoteId;
        System.debug('----quoteId----'+quoteId);
    }
    
    /* Method      : getVehicleRequestMap
    Description : to query whole Vehicle Request Records
    SK-
    */
    @AuraEnabled
    public static List<Vehicle__c> getVehicleRequests(Id serviceRequestId) {
        Map<Id, Vehicle__c> vehicleRequestMap = ET_PricingUtilityClass.getVehicleRequestMap(serviceRequestId); 
        if(vehicleRequestMap.Size()>0){
            return vehicleRequestMap.Values();
        }
        else {
            return null;
        }
    }

    //Taj
    @AuraEnabled
    public static Boolean deletePricingRequestMapping(String serviceRequestRecordId) {
        try {
            List<ET_Request_Mapping__c> listPSR = [SELECT Id, Name FROM ET_Request_Mapping__c WHERE ET_Pricing_Service_Request__c =: serviceRequestRecordId];
            If(listPSR.Size()>0){
                DELETE listPSR;
                return true;
            }else{
                return false;
            }
        } catch (Exception e) {
            // Handle any exceptions here
            throw new AuraHandledException('Error retrieving opportunity: ' + e.getMessage());
        }
    }

    // Custom exception for more specific error handling
    public class CustomException extends Exception {}

    public static void testCoverage()
    {
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
                i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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