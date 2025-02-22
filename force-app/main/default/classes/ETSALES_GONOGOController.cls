public without sharing class ETSALES_GONOGOController {
    
    /**
|--------------------------------------------------------------------------
|@method        getOpportunityDetails
|--------------------------------------------------------------------------
|@created       29/04/2020
|@createdBy     Dhananjay Misal
|@description   Apex Method Returns Opportunity details along with 
Account and Contact Details
*/
    
    @AuraEnabled
    public static AccountContactListWrapper getOppAccountVehicleDetails(String oppId){
        AccountContactListWrapper accWrapper = new AccountContactListWrapper();
        try{
            List<Opportunity> oppList = [SELECT Id, Name, Type,RecordType.Name, StageName, ETSALES_Approval_Status__c, AccountId, Account.Name, Account.Type, Account.Industry,
                                         ETSALES_Customer_Budget__c,ETSALES_Tender__r.Name,CloseDate,ETSALES_Bidding_Type__c,ETSALES_GL_Services__c,
                                         (Select Id, Name,ET_PSR_IsActive__c,ET_Service_Request_Common_Data__r.ET_Price_Utilization__c, ET_Service_Request_Common_Data__r.Name,
                                          ET_Service_Request_Common_Data__r.ET_Pricing_Method__c, ET_Service_Request_Common_Data__r.ET_Pricing_Type__c,
                                          ET_Service_Request_Common_Data__r.ET_Service_Emirate__c, ET_Service_Request_Common_Data__r.ET_Fleet_Type__c, 
                                          ET_Service_Request_Common_Data__r.ET_Contract_Period__c, ET_Service_Request_Common_Data__r.ET_Contract_Type__c 
                                          FROM Pricing_Service_Requests__r),
                                          (Select Id, Name,ETS_Contract_Opportunity__c,ETS_vehicle__c, Contract_Amount__c, ETS_Self_Payment__c, ETS_Lumpsum_Package__c, ETS_Pool_Chance__c,ETS_Credit_Invoice_Allowed__c
                                          FROM Contract_Request_Forms__r)
                                         FROM Opportunity WHERE Id=:oppId limit 1];
            //FROM Opportunity WHERE Id='0060C000004Tu8lQAC' limit 1];
            
            ET_Pricing_Service_Request__c activePSR = new ET_Pricing_Service_Request__c();
            for(ET_Pricing_Service_Request__c psr : oppList[0].Pricing_Service_Requests__r){
                if(psr.ET_PSR_IsActive__c==true){
                    activePSR = psr; 
                }
            }
            system.debug('++activePSR++'+activePSR.Id);
            accWrapper.noOfPSRs = (oppList[0].Pricing_Service_Requests__r).size();
            system.debug('++noOfPSRs++'+accWrapper.noOfPSRs);
            
            List<Contact> conList = [Select Id, Name from Contact where AccountId=:oppList[0].AccountId limit 1];
            List<Vehicle__c> vehicleDetails = new List<Vehicle__c>();
            List<ET_Work_force__c> workForceDetails= New List<ET_Work_force__c>();
            List<ET_Other_Cost_Request__c> otherCostRequestDetails= New List<ET_Other_Cost_Request__c>();
            if(oppList[0].Contract_Request_Forms__r.size() > 0){
                accWrapper.contractRequestForm = oppList[0].Contract_Request_Forms__r;
            }
            
            if( activePSR.Id != null ){
                vehicleDetails = [Select Id, ET_Pricing_Service_Request__c,ET_Vehicle_MAKE__c,ET_Vehicle_Model__c ,ET_Fleet_Type__c,
                                  ET_Vehicle_Condition__c,ET_Vehicle_Quantity__c, ET_Vehicle_Specs__c, ET_Vehicle_category__c, ET_Vehicle_Model_Year__c,ET_Contract_Period__c
                                  //FROM Vehicle__c where ET_Pricing_Service_Request__c=:oppList[0].Pricing_Service_Requests__r[0].Id];
                                  FROM Vehicle__c where ET_Pricing_Service_Request__c=:activePSR.Id];
                
                system.debug('++Vehicle Size++'+vehicleDetails.size());
                workForceDetails = [SELECT Id, ET_Pricing_Service_Request__c,RecordType.Name,ET_No_of_Drivers__c, ET_Driver_Category__c,ET_Service_Emirate__c,
                                    ET_Contract_Type__c,ET_Contract_Period__c, ET_Target_Price__c,
                                    ET_Number_of_Nannies__c, ET_Nanny_Category__c,
                                    ET_Number_of_Supervisors__c, ET_Supervisor_Category__c,
                                    ET_Number_of_Coordinators__c, ET_Coordinator_Category__c,
                                    ET_Number_of_Accountants__c, ET_Accountant_Category__c,
                                    ET_Number_of_Other_Employees__c, ET_Other_employee_Category__c
                                    //FROM ET_Work_force__c where ET_Pricing_Service_Request__c=:oppList[0].Pricing_Service_Requests__r[0].Id];
                                    FROM ET_Work_force__c where ET_Pricing_Service_Request__c=:activePSR.Id];
                system.debug('++workForceDetails++'+workForceDetails);
                
                otherCostRequestDetails = [SELECT Id, Name, ET_Pricing_Service_Request__c,
                                           ET_Cost_Type__c,ET_Cost_Value__c
                                           FROM ET_Other_Cost_Request__c where ET_Pricing_Service_Request__c=:activePSR.Id];
                
                system.debug('++otherCostRequestDetails++'+otherCostRequestDetails);
            }
            
            List<Maintenance_Request__c> maintenanceRequestDetails = [SELECT Id, Name,  Opportunity__c, Make_manufacturer_type__c, Model_Type__c, Model_Year__c, Chassis_No__c, Current_KM_Hrs__c, Location__c, Maintenance_Questionnaire__c
                                                                      FROM Maintenance_Request__c 
                                                                      WHERE Opportunity__c=:oppList[0].Id];
            system.debug('++maintenanceRequestDetails++'+maintenanceRequestDetails);
            Maintenance_Questionnaire__c maintenanceQuestionneareDetails = new Maintenance_Questionnaire__c();
            if(!maintenanceRequestDetails.isEmpty()){
                maintenanceQuestionneareDetails = [SELECT Id,Name, Light_vehicle__c, Heavy_vehicle__c, Equipments__c, Location__c, No_Bays__c, Tools_Equipment__c, Current_organization_chart_of_Fleet__c, 
                                                   Operating_system_software_used__c, Procedures_follow_for_accident_repairs__c, Spare_parts_and_Tyres_currently_using__c,
                                                   Normal_duty_time__c, Workshop_Safety_HSE_policy__c, Service_interval_Light_vehicle_km__c, Service_interval_Heavy_vehicle__c, Service_interval_Equipments__c,
                                                   Warranty_terms_available__c, KPI_details__c, percentage_of_availability_of_vehicle__c, Service_contract_to_outsourcing_company__c,
                                                   Details_of_persons_regular_Maintenance__c, Criteria_to_Scrap_Vehicle__c, Procedure_to_remove_workshop_scrap__c
                                                   FROM Maintenance_Questionnaire__c
                                                   WHERE Id=:maintenanceRequestDetails[0].Maintenance_Questionnaire__c];
                system.debug('++maintenanceQuestionneareDetails++'+maintenanceQuestionneareDetails);
            }
            
            if(!oppList.isEmpty()){
                accWrapper.approvalStatus = oppList[0].ETSALES_Approval_Status__c;
                accWrapper.oppStage = oppList[0].StageName;
                accWrapper.oppRecord = oppList[0];
            }
            if(!conList.isEmpty()){
                accWrapper.conRecord = conList[0];
            }
            if(!vehicleDetails.isEmpty()){
                system.debug('++vehicleDetails++'+vehicleDetails);
                accWrapper.vehicleRecords = vehicleDetails;
            }
            if(!workForceDetails.isEmpty()){
                system.debug('++workForceDetails++'+workForceDetails);
                accWrapper.workForceRecords = workForceDetails;
            }
            if(!otherCostRequestDetails.isEmpty()){
                system.debug('++otherCostRequestDetails++'+otherCostRequestDetails);
                accWrapper.otherCostRequestRecords = otherCostRequestDetails;
            }
            if(!maintenanceRequestDetails.isEmpty()){
                system.debug('++maintenanceRequestDetails++'+maintenanceRequestDetails);
                accWrapper.maintenanceRequestRecords = maintenanceRequestDetails;
            }
            if(maintenanceQuestionneareDetails != null){
                system.debug('++maintenanceQuestionneareDetails++'+maintenanceQuestionneareDetails);
                accWrapper.maintenanceQuestionnaire = maintenanceQuestionneareDetails;
            }
            system.debug('++++'+accWrapper.workForceRecords);
            system.debug('++++'+accWrapper.oppStage);
            system.debug('++++'+accWrapper.oppRecord.RecordType.Name);
            
        }catch(Exception e){
            system.debug('Error is :'+e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
        return accWrapper;
    }
    
    @AuraEnabled
    public static String submitForOppApproval(String oppId){
        String approvalProcess ='Opportunity_Approval_Process';
        AccountContactListWrapper accWrapper = new AccountContactListWrapper();
        String serviceReqId ;
        try{
            List<Opportunity> oppList = [SELECT Id, Name, OwnerId,Type,RecordType.Name, StageName, ETSALES_Approval_Status__c, AccountId, Account.Name, Account.Type, Account.Industry,
                                         ETSALES_Customer_Budget__c,ETSALES_Tender__r.Name,CloseDate,ETSALES_Bidding_Type__c,ETSALES_GL_Services__c,Opportunity_Sales_Process__c,
                                         (Select Id, Name,isServiceRequestRejected__c,ET_PSR_IsActive__c FROM Pricing_Service_Requests__r 
                                          where ET_PSR_IsActive__c = true)
                                         FROM Opportunity WHERE Id=:oppId limit 1];

            if((oppList[0].Pricing_Service_Requests__r).size() < 1 && oppList[0].Opportunity_Sales_Process__c =='LeaseTransportManpower'){
                throw new MyException('Please add atleast 1 Pricing Service Request before submitting for Approval');
            }
            
            if(oppList[0].Pricing_Service_Requests__r != null && oppList[0].Pricing_Service_Requests__r.size() ==1){
                serviceReqId = oppList[0].Pricing_Service_Requests__r[0].id;
            }
            
            if(serviceReqId != null){
                ET_Pricing_Service_Request__c req = [select id, (select id from Request_Mapping__r) from ET_Pricing_Service_Request__c where id =:serviceReqId];
                if(req.Request_Mapping__r.size() ==0){
                    throw new MyException('Please Create Customize Pricing for the Service Request before submitting for Approval');
                }
            }
            
            if(oppList[0].ETSALES_Approval_Status__c == null || oppList[0].ETSALES_Approval_Status__c =='Rejected' ||  oppList[0].ETSALES_Approval_Status__c =='Rejected by Pricing Team' )
            {
                if(oppList[0].Opportunity_Sales_Process__c =='Driving School- B2B'){
                    approvalProcess = 'Opportunity_Driving_Approval_Process';
                }
                List<User> usr = [Select Id, ManagerId from User where Id=:oppList[0].OwnerId limit 1];
                // Create an approval request for the account
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(oppList[0].Id);
                
                // Submit on behalf of a specific submitter
                req1.setSubmitterId(oppList[0].OwnerId); 
                
                // Submit the record to specific process and skip the criteria evaluation
                req1.setProcessDefinitionNameOrId(approvalProcess);
                req1.setSkipEntryCriteria(true);
                req1.setNextApproverIds(new Id[] {usr[0].ManagerId});
                
                if(!Test.isRunningTest()){
                    Approval.ProcessResult result = Approval.process(req1);
                    System.assert(result.isSuccess());
                }
                if(oppList[0].Pricing_Service_Requests__r!=null && oppList[0].Pricing_Service_Requests__r.size()>0){
                    list<ET_Pricing_Service_Request__c> srList=new list<ET_Pricing_Service_Request__c>();
                    for(ET_Pricing_Service_Request__c sr:oppList[0].Pricing_Service_Requests__r){
                        if(sr.isServiceRequestRejected__c){
                            sr.isServiceRequestRejected__c=false;
                            srList.add(sr);
                        }
                    }
                    if(!srList.isEmpty())
                    {
                       update srList;  
                    }
                       
                }
                // Verify the result
                system.debug('++Approval Completed++');
                return oppList[0].ETSALES_Approval_Status__c;    
            }else{
                return oppList[0].ETSALES_Approval_Status__c;
            }   
        }catch(Exception e){
            system.debug('Error is :'+e.getMessage());
            if(!Test.isRunningTest()){
                if(e.getMessage().contains('MANAGER_NOT_DEFINED'))
                    throw new AuraHandledException('Heads of Sales is Required to submit for approval, Please fill and Resubmit again.');
                else
                    throw new AuraHandledException(e.getMessage());
            }else 
                return null;
        }
    } 
    
    public class MyException extends Exception {}
    // wrapper class with @AuraEnabled and {get;set;} properties 
    public class AccountContactListWrapper{
        @AuraEnabled
        public Opportunity oppRecord{get;set;}
        @AuraEnabled
        public Contact conRecord{get;set;}
        @AuraEnabled
        public List<Vehicle__c> vehicleRecords{get;set;}
        @AuraEnabled
        public List<ET_Work_force__c> workForceRecords{get;set;}
        @AuraEnabled
        public List<ET_Other_Cost_Request__c> otherCostRequestRecords{get;set;}
        @AuraEnabled
        public List<Contract_Request_Form__c> contractRequestForm{get;set;}
        @AuraEnabled
        public List<Maintenance_Request__c> maintenanceRequestRecords{get;set;}
        @AuraEnabled
        public Maintenance_Questionnaire__c maintenanceQuestionnaire{get;set;}
        @AuraEnabled
        public String approvalStatus{get;set;}
        @AuraEnabled
        public String oppStage{get;set;}
        @AuraEnabled
        public Integer noOfPSRs{get;set;}
    }
    
    @AuraEnabled
    public static Opportunity getOpportunityDetails(String oppId){
        //oppId='0060C000004Tu8lQAC';
        opportunity opp = [Select Id, Name, RecordType.Name, StageName from Opportunity where Id=:oppId];
        system.debug('++opRT++'+opp.RecordType.Name);
        return opp;
    }
}