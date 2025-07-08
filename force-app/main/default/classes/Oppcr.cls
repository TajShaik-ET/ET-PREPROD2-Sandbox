/*
*********************************************************
Apex Class Name    : Oppcr.cls
Created Date       : September 30, 2024
@Test class 	   :  OppcrTest.cls
@description       : This is class is used for Clone Opportunity with Pricing Service Request
@author            : Smaartt 
Modification Log:
Ver   Date         Author                               Modification
1.0   30-09-2024   Santosh kumar                     Initial Version
1.1   18/02/2025   Santosh kumar           (Trailer and Refrigerator clones)
1.2   03/04/2025   Santosh kumar           (Closed date today+1)
*********************************************************

*/ 

public with sharing class Oppcr {
    @AuraEnabled
    public static Opportunity cloneOpportunity(Id oppId, String newName) {
        System.debug('Starting cloneOpportunity method...');
        System.debug('Original Opportunity ID: ' + oppId);
        System.debug('New Opportunity Name: ' + newName);
        
        Savepoint sp = Database.setSavepoint();
        Opportunity originalOpportunity;
        try {
            originalOpportunity = getOpportunity(oppId, newName);
        } catch (Exception e) {
            System.debug('Error querying original Opportunity: ' + e.getMessage());
            Database.rollback(sp);
            Database.releaseSavepoint(sp);
            throw new AuraHandledException('Error querying original Opportunity: ' + e.getMessage());
        }
        System.debug('Original Opportunity queried successfully: ' + originalOpportunity);
        
        Opportunity clonedOpportunity;
        try {
            clonedOpportunity = originalOpportunity.clone(false, true);
            clonedOpportunity.Name = newName;
            clonedOpportunity.StageName = 'Qualification'; // Set StageName to 'Qualification'
            clonedOpportunity.CloseDate = Date.today().addDays(1); // Set CloseDate to today + 1
            insert clonedOpportunity;
        } catch (Exception e) {
            System.debug('Error cloning Opportunity: ' + e.getMessage());
            Database.rollback(sp);
            Database.releaseSavepoint(sp);
            throw new AuraHandledException('Error cloning Opportunity: ' + e.getMessage());
        }
        
        System.debug('Cloned Opportunity inserted successfully: ' + clonedOpportunity);
        
        // Cloning related Opportunity Line Items
        List<OpportunityLineItem> clonedLineItems = new List<OpportunityLineItem>();
        for (OpportunityLineItem item : originalOpportunity.OpportunityLineItems) {
            OpportunityLineItem clonedItem = item.clone(false, true);
            clonedItem.OpportunityId = clonedOpportunity.Id;
            clonedLineItems.add(clonedItem);
        }
        
        insert clonedLineItems; 
        
        
        System.debug('Cloned OpportunityLineItems inserted successfully: ' + clonedLineItems);
        
        // Cloning related Opportunity Contact Roles
        List<OpportunityContactRole> clonedContactRoles = new List<OpportunityContactRole>();
        for (OpportunityContactRole role : originalOpportunity.OpportunityContactRoles) {
            OpportunityContactRole clonedRole = role.clone(false, true);
            clonedRole.OpportunityId = clonedOpportunity.Id;
            clonedContactRoles.add(clonedRole);
        }
        insert clonedContactRoles;
        
        System.debug('Cloned OpportunityContactRoles inserted successfully: ' + clonedContactRoles);
        
        // Cloning related ET_Pricing_Service_Request__c records
        Map<Id, Id> pricingRequestMap = new Map<Id, Id>(); // Map to store original to cloned pricing request IDs
        List<ET_Pricing_Service_Request__c> originalPricingRequests = originalOpportunity.Pricing_Service_Requests__r;
        List<ET_Pricing_Service_Request__c> clonedPricingRequests = new List<ET_Pricing_Service_Request__c>();
        // Collecting all vehicles, request mappings, work forces, and other cost requests related to the original pricing requests
        Map<Id, List<Vehicle__c>> originalVehiclesMap = new Map<Id, List<Vehicle__c>>();
        Map<Id, List<ET_Request_Mapping__c>> originalRequestMappingsMap = new Map<Id, List<ET_Request_Mapping__c>>();
        Map<Id, List<ET_Work_force__c>> originalWorkForcesMap = new Map<Id, List<ET_Work_force__c>>();
        List<ET_Work_force__c> originalWorkForces = new List<ET_Work_force__c>();
        Map<Id, List<ET_Special_Workforce_Requirement__c>> originalSpecialWorkForcesMap = new Map<Id, List<ET_Special_Workforce_Requirement__c>>();
        Map<Id, List<ET_Other_Cost_Request__c>> VehicleRequestOtherCostMap = new Map<Id, List<ET_Other_Cost_Request__c>>();
        Map<Id, Id> workForceRequestMap = new Map<Id, Id>();
        Map<Id, Id> vehicleMap = new Map<Id, Id>();
        List<Vehicle__c> originalVehicles = new List<Vehicle__c>();
        Map<Id, List<ET_Other_Cost_Request__c>> originalOtherCostRequestsMap = new Map<Id, List<ET_Other_Cost_Request__c>>();
        for (ET_Pricing_Service_Request__c request : originalPricingRequests) {
            if (request.Vehicle_Requests__r != null && !request.Vehicle_Requests__r.isEmpty()) {
                originalVehiclesMap.put(request.Id, request.Vehicle_Requests__r);
                for(Vehicle__c vchild: request.Vehicle_Requests__r){
                    originalVehicles.add(vchild);
                    if (vchild.Other_Cost_Requests__r != null && !vchild.Other_Cost_Requests__r.isEmpty()) {
                        VehicleRequestOtherCostMap.put(vchild.Id, vchild.Other_Cost_Requests__r);
                    }
                }
            }
            if (request.Request_Mapping__r != null && !request.Request_Mapping__r.isEmpty()) {
                originalRequestMappingsMap.put(request.Id, request.Request_Mapping__r);
            }
            if (request.Work_force_Requests__r != null && !request.Work_force_Requests__r.isEmpty()) {
                originalWorkForcesMap.put(request.Id, request.Work_force_Requests__r);
                for(ET_Work_force__c child: request.Work_force_Requests__r){
                    originalWorkForces.add(child);
                    if (child.Specific_Workforce_Requirements__r != null && !child.Specific_Workforce_Requirements__r.isEmpty()) {
                        originalSpecialWorkForcesMap.put(child.Id, child.Specific_Workforce_Requirements__r);
                    }
                }
            }
            
            if (request.Other_Cost_Requests__r != null && !request.Other_Cost_Requests__r.isEmpty()) {
                originalOtherCostRequestsMap.put(request.Id, request.Other_Cost_Requests__r);
            }
            
            ET_Pricing_Service_Request__c clonedRequest = request.clone(false, true);
            clonedRequest.Opportunity__c = clonedOpportunity.Id;
            clonedPricingRequests.add(clonedRequest);
        }
        insert clonedPricingRequests;
        for (Integer i = 0; i < originalPricingRequests.size(); i++) {
            pricingRequestMap.put(originalPricingRequests[i].Id, clonedPricingRequests[i].Id);
        }
        
        System.debug('Cloned ET_Pricing_Service_Request__c inserted successfully: ' + clonedPricingRequests);
        
        // Cloning Vehicles
        List<Vehicle__c> vehiclesToClone = new List<Vehicle__c>();
        for (Id originalRequestId : originalVehiclesMap.keySet()) {
            for (Vehicle__c vehicle : originalVehiclesMap.get(originalRequestId)) {
                Vehicle__c clonedVehicle = vehicle.clone(false, true);
                clonedVehicle.ET_Pricing_Service_Request__c = pricingRequestMap.get(originalRequestId);
                vehiclesToClone.add(clonedVehicle);
            }
        }
        insert vehiclesToClone;
        for (Integer i = 0; i < originalVehicles.size(); i++) {
            vehicleMap.put(originalVehicles[i].Id, vehiclesToClone[i].Id);
        }
        System.debug('Cloned Vehicle__c inserted successfully: ' + vehiclesToClone);
        
        //Cloning OtherCost Request related to vehicle request
        List<ET_Other_Cost_Request__c> VehicleOtherCostToClone = new List<ET_Other_Cost_Request__c>();        
        for (Id otherCostRequestId : VehicleRequestOtherCostMap.keySet()) {
            for (ET_Other_Cost_Request__c vehicleOtherCost : VehicleRequestOtherCostMap.get(otherCostRequestId)) {
                ET_Other_Cost_Request__c clonedVehicleOtherCosts = vehicleOtherCost.clone(false, true);
                clonedVehicleOtherCosts.Vehicle_Request__c = vehicleMap.get(otherCostRequestId); // Associate with the cloned Work Force Request
                VehicleOtherCostToClone.add(clonedVehicleOtherCosts);
            }
        }
        try {
            insert VehicleOtherCostToClone;
        } catch (Exception e) {
            System.debug('Error cloning ET_Other_Cost_Request__c: ' + e.getMessage());
            Database.rollback(sp);
            Database.releaseSavepoint(sp);
            throw new AuraHandledException('Error cloning ET_Other_Cost_Request__c: ' + e.getMessage());
        }
        
        System.debug('Cloned ET_Other_Cost_Request__c related to vehicle inserted successfully: ' + VehicleOtherCostToClone);
        
                    // Cloning Request Mappings
                    /*  List<ET_Request_Mapping__c> requestMappingsToClone = new List<ET_Request_Mapping__c>();
            for (Id originalRequestId : originalRequestMappingsMap.keySet()) {
            for (ET_Request_Mapping__c requestMapping : originalRequestMappingsMap.get(originalRequestId)) {
            ET_Request_Mapping__c clonedRequestMapping = requestMapping.clone(false, true);
            clonedRequestMapping.ET_Pricing_Service_Request__c = pricingRequestMap.get(originalRequestId);
            requestMappingsToClone.add(clonedRequestMapping);
            }
            }
            try {
            insert requestMappingsToClone;
            } catch (Exception e) {
            System.debug('Error cloning ET_Request_Mapping__c: ' + e.getMessage());
            Database.rollback(sp);
            Database.releaseSavepoint(sp);
            throw new AuraHandledException('Error cloning ET_Request_Mapping__c: ' + e.getMessage());
            }
            
            */  //System.debug('Cloned ET_Request_Mapping__c inserted successfully: ' + requestMappingsToClone);
        
        // Cloning Work Forces
        List<ET_Work_force__c> workForcesToClone = new List<ET_Work_force__c>();
        for (Id originalRequestId : originalWorkForcesMap.keySet()) {
            for (ET_Work_force__c workForce : originalWorkForcesMap.get(originalRequestId)) {
                ET_Work_force__c clonedWorkForce = workForce.clone(false, true);
                clonedWorkForce.ET_Pricing_Service_Request__c = pricingRequestMap.get(originalRequestId);
                workForcesToClone.add(clonedWorkForce);
            }
        }
        try {
            insert workForcesToClone;
            for (Integer i = 0; i < originalWorkForces.size(); i++) {
                workForceRequestMap.put(originalWorkForces[i].Id, workForcesToClone[i].Id);
            }
            System.debug('workForcesToClone : ' +workForcesToClone);
        } catch (Exception e) {
            System.debug('Error cloning ET_Work_force__c: ' + e.getMessage());
            Database.rollback(sp);
            Database.releaseSavepoint(sp);
            throw new AuraHandledException('Error cloning ET_Work_force__c: ' + e.getMessage());
        }
        System.debug('Cloned ET_Work_force__c inserted successfully: ' + workForcesToClone);
       // Cloning Special Work Forces
        List<ET_Special_Workforce_Requirement__c> specialWorkForcesToClone = new List<ET_Special_Workforce_Requirement__c>();        
        for (Id workForceRequestId : originalSpecialWorkForcesMap.keySet()) {
            for (ET_Special_Workforce_Requirement__c specialWorkForce : originalSpecialWorkForcesMap.get(workForceRequestId)) {
                ET_Special_Workforce_Requirement__c clonedSpecialWorkForce = specialWorkForce.clone(false, true);
                clonedSpecialWorkForce.Work_force_Request__c = workForceRequestMap.get(workForceRequestId); // Associate with the cloned Work Force Request
                specialWorkForcesToClone.add(clonedSpecialWorkForce);
            }
        }
        try {
            insert specialWorkForcesToClone;
        } catch (Exception e) {
            System.debug('Error cloning ET_Special_Workforce_Requirement__c: ' + e.getMessage());
            Database.rollback(sp);
            Database.releaseSavepoint(sp);
            throw new AuraHandledException('Error cloning ET_Special_Workforce_Requirement__c: ' + e.getMessage());
        }
         System.debug('Cloned ET_Special_Workforce_Requirement__c inserted successfully: ' + specialWorkForcesToClone);
        // Cloning Other Cost Requests
        List<ET_Other_Cost_Request__c> otherCostRequestsToClone = new List<ET_Other_Cost_Request__c>();
        for (Id originalRequestId : originalOtherCostRequestsMap.keySet()) {
            for (ET_Other_Cost_Request__c otherCostRequest : originalOtherCostRequestsMap.get(originalRequestId)) {
                ET_Other_Cost_Request__c clonedOtherCostRequest = otherCostRequest.clone(false, true);
                clonedOtherCostRequest.ET_Pricing_Service_Request__c = pricingRequestMap.get(originalRequestId);
                otherCostRequestsToClone.add(clonedOtherCostRequest);
            }
        }
        try {
            insert otherCostRequestsToClone;
        } catch (Exception e) {
            System.debug('Error cloning ET_Other_Cost_Request__c: ' + e.getMessage());
            Database.rollback(sp);
            Database.releaseSavepoint(sp);
            throw new AuraHandledException('Error cloning ET_Other_Cost_Request__c: ' + e.getMessage());
        }
        System.debug('Cloned ET_Other_Cost_Request__c inserted successfully: ' + otherCostRequestsToClone);
        // Return the cloned Opportunity
        return clonedOpportunity;
    }
    @AuraEnabled
    public static Opportunity getOpportunity(Id oppId, String newName) {
        Return [SELECT Id, Name, ETSALES_Sector__c, CloseDate, StageName, GL_Zone_Lookup__c, ETSALES_Opportunity_Number__c, OwnerId, AccountId, Type, RecordTypeId, Contract_Type__c, Contract_Years__c,
                ET_Service_Previous_Contract__c,Contract_Type_Previous_Contract__c,Contract_Years_Previous_Contract__c,Contract_Months_Previous_Contract__c,Contract_Weeks_Previous_Contract__c,
                Contract_Days_Previous_Contract__c,Competitor_Before_ET_Previous_Contract__c,Old_No_of_Used_Vehicles__c,Old_No_of_Resources__c,
                Contract_Months__c, Contract_Weeks__c, Contract_Days__c, Competitor__c,ETSALES_GL_Services__c,
                No_of_Vehicles__c, No_of_Used_Vehicles__c, No_of_Resources__c, ETSALES_Bidding_Type__c,Type_of_Customer__c,
                ETSALES_Customer_Budget__c, Annual_proposed_amount__c, Proposed_Amount__c, Amount, Annual_budget__c, Annual_AmountFormulla__c, Investment_Amount__c, Annual_Amount_Growth__c,
                Amount_Till_End_of_the_Year__c, Customer_Budget_Previous_Contract1__c, Proposed_Amount_Previous_Contract1__c, Amount_Previous_Contract__c,
                Annual_Budget_Previous_Contract__c, Annual_Proposed_Amount_PreviousContract__c, Annual_Amount_Previous_Contract__c, Investment_Amount_Previous_Contract__c,
                Annual_Amount_Additional_Growth__c,ETSALES_Loss_Reason__c,ETSALES_Tender__c,Type_of_Service__c,Vehicle_Order_Number__c,Passport_Number__c,Emirates_ID__c,TRN_Number__c,Customer_Category__c,
                Customer_Category_Importance__c,Accidented__c,Type_of_Vehicle__c,Auction_Fees__c,Commision__c,Customer_Minimum_Selling_Price__c,Recovery__c,Vehicle_Inspection_Auction__c,Body_Polishing__c,
                Price_for_Body_Polishing__c,Bank_Name__c,Bank_Account_Number__c,IBAN_Number__c,Loss_Reason_Remarks__c,Bank_Address__c,Body_Type__c,
                (SELECT Id, Product2Id, Quantity, UnitPrice FROM OpportunityLineItems),
                (SELECT Id, ContactId, Role FROM OpportunityContactRoles),
                (SELECT Id, ET_Service_Request_Common_Data__c, ET_PSR_IsActive__c, Opportunity__c, isServiceRequestRejected__c,
                 (SELECT Id, Name, ET_Vehicle_Model__c, ET_Vehicle_Fuel__c,                        
                  Trailer_Equipment_Model__c,Trailer_Equipment_subtype__c,Trailer_condition__c,Trailer_model_year__c,Trailer_original_purchase_price__c,Trailer_Current_purchase_price__c,Trailer_External_Maintenance_Cost__c,
                  Refrigerator_model_year__c,Refregirator_subtype__c,Refrigerator_condition__c,Refregirator_Model__c,Refrigerator_original_purchase_price__c,Refrigerator_Current_purchase_price__c,Refrigerator_External_Maintenance_Cost__c,
                  ET_Vehicle_MAKE__c, ET_Vehicle_Condition__c, ET_Vehicle_Quantity__c, ET_Vehicle_Model_Year__c,
                  ET_Vehicle_Line__c, ET_Pricing_Service_Request__c, ET_Specific_requirements__c, ET_Service_Request_Common_Data__c, ET_Number_of_seats__c, ET_Fuel_Type__c,
                  ET_Annual_KM__c, ET_Vehicle_Original_Purchase_Price__c, ET_Vehicle_Current_Purchase_Price__c, ET_Service_Type__c, ET_Vehicle_Source__c, ET_Vehicle_Sub_Type__c,
                  Vehicle_Type__c, Insurance_Category__c, Request_for_Target_Price__c, Special_Requirement_Basic__c, ET_Contract_Type__c, ET_Fleet_Type__c, ET_Contract_Period__c,
                  ET_Service_Emirate__c, ET_Price_Utilization__c, ET_Working_Days_Per_Week__c, ET_Pricing_Type__c, ET_Working_Months_Per_Year__c, ET_Pricing_Method__c ,
                  (SELECT Id, Name, RecordTypeId, Other_Requirement_API_Name__c, ET_Cost_Type__c, ET_Other_Cost_Line_Number__c, ET_Cost_Value__c, Vehicle_Request__c, Work_force_Request__c, ET_Pricing_Service_Request__c, Other_Cost_Type__c 
                   FROM Other_Cost_Requests__r)
                  FROM Vehicle_Requests__r),
                 (SELECT Id, ET_Pricing_Service_Request__c, ET_Vehicle_Unique_key__c, ET_Number_of_Vehicles__c, ET_Number_of_Drivers__c, ET_Number_of_Nannies__c,
                  ET_Number_of_Accountants__c, ET_Number_of_Coordinators__c, ET_Number_of_Supervisors__c, ET_Number_of_Other_Employees__c,ET_Driver_Unique_Id__c
                  FROM Request_Mapping__r),
                 (SELECT Id, ET_Coordinator_Category__c, ET_Number_of_Coordinators__c, ET_Service_Request_Common_Data__c, ET_Special_Requirements__c, ET_Pricing_Service_Request__c,
                  ET_Workforce_Line_Info__c,ET_Driver_Category__c,ET_No_of_Drivers__c, ET_Service_Type__c, Type__c, ET_Contract_Period__c, ET_Pricing_Method__c,
                  ET_Contract_Type__c, ET_Pricing_Type__c,ET_Number_of_Nannies__c,ET_Nanny_Category__c,ET_Number_of_Supervisors__c,ET_Supervisor_Category__c,ET_Number_of_Accountants__c,
                  ET_Accountant_Category__c,ET_Number_of_Other_Employees__c,ET_Other_employee_Category__c,ET_Working_Months_Per_Year__c,ET_Working_Days_Per_Week__c,ET_Price_Utilization__c,
                  ET_Service_Emirate__c,RecordTypeId, 
                  (SELECT Id, ET_Accommodation_Allowance_Type__c, ET_Accommodation_Allowance__c, ET_Air_Tickets_Cost_Type__c, 
                   ET_Air_Tickets__c, ET_Extra_Certification_Cost_Type__c, ET_Extra_Certification__c, ET_Over_Time__c, 
                   ET_Smart_Phone_Cost_Type__c, ET_Smart_Phone__c, ET_Specific_Base_Salary__c, ET_Specific_Gross_Salary__c, 
                   ET_Specific_Insurance__c, ET_Specific_Leave_Plan__c, Language_and_Psychometric_Fee_Cost_Type__c, Language_and_Psychometric_Test_Fee__c, 
                   Training_and_Licensing_Cost_Cost_Type__c, Training_and_Licensing_Cost__c, Notes__c, Resource_Type__c, Married__c, Number_of_Children__c, 
                   Cost_of_Living_Allowance__c, Housing_Allowance__c, Transport_Allowance__c, Additional_Transport_Allowance__c, Other_Allowance__c, 
                   Social_Allowance__c, Social_Insurance__c, Workforce_Record_Type_Name__c, Workforce_Type__c 
                   FROM Specific_Workforce_Requirements__r)
                  FROM Work_force_Requests__r),
                 (SELECT Id, Name, RecordTypeId, Other_Requirement_API_Name__c, ET_Cost_Type__c, ET_Other_Cost_Line_Number__c, ET_Cost_Value__c, Vehicle_Request__c, Work_force_Request__c, ET_Pricing_Service_Request__c, Other_Cost_Type__c 
                  FROM Other_Cost_Requests__r)
                 FROM Pricing_Service_Requests__r)
                FROM Opportunity WHERE Id = :oppId LIMIT 1][0];
    }
    
}