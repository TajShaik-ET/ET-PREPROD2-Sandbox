@isTest
private class ET_ServiceRequestControllerTest {
    
    @testSetup
    static void setup(){
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('ETSALES_Leasing').getRecordTypeId();
        List<Account> accList = ET_ServiceRequestControllerUtility.createAccounts(1, null);
        accList[0].client_type__c = 'Sovrin';
        insert accList;
        Contact con = new contact();
        con.Lastname = 'Testcls';
        con.AccountId = accList[0].Id;
        con.Email = 'abc@mail.com';
        insert con;
        List<Opportunity> oppList = ET_ServiceRequestControllerUtility.createOpportunities(1, oppRecordTypeId, accList[0].id);insert oppList;
        System.debug(oppList);
        ET_ServiceRequestControllerUtility.createMultiplerecords();
    }
    
    @isTest 
    static void testMethod1(){
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
        test.startTest();
        ET_ServiceRequestController.createQuotation(pricingReq.id);
        test.stopTest();
    }
    
    @isTest 
    static void testBoilingPoint() {
        Account acc = new Account();
        acc.Name='test';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        insert acc;        
        /*Opportunity opp = new Opportunity();
        opp.Name='test opp';
        opp.StageName='Qualification';
        opp.AccountId=acc.Id;
        opp.CloseDate=System.today()+5;
        opp.Type='New Business';
        opp.ETSALES_GL_Services__c='Bus';
        insert opp;*/        
        List<Opportunity> oppList = [SELECT id, StageName, name FROM Opportunity Where StageName = 'Qualification' OR StageName = 'Requirement Analysis' ];
        system.debug('oppList'+oppList);
        Quote q = new Quote();
        q.name = 'Quote1' + oppList[0].name;
        q.opportunityId = oppList[0].id;
        q.Is_Target_Price_Required__c=true;
        q.ET_Type__c = 'Total Project Summary';
        insert q;
        ET_Pricing_Service_Request__c psr =  new ET_Pricing_Service_Request__c();
        psr.Opportunity__c=oppList[0].id;
        insert psr;
        ET_Pricing_Service_Request__c pricingReq = [select id, Name, Opportunity__r.Id, Opportunity__r.account.ETSALES_Profile_Class__c,
                                                    Opportunity__r.RecordType.DeveloperName, Opportunity__r.Name, Opportunity__r.ET_Oracle_Pricing_Service_Type__c, 
                                                    ET_Service_Request_Common_Data__r.ET_Contract_Period__c,
                                                    ET_Service_Request_Common_Data__r.ET_Request_for_Target_Price__c,
                                                    ET_Service_Request_Common_Data__r.ET_Request_for_Separate_Prices__c
                                                    from ET_Pricing_Service_Request__c LIMIT 1];
        Map<String,Object> data = new Map<String,Object>();
        List<Decimal> costList = new List<Decimal>();
        costList.add(1.2);
        ET_Extra_Bus_Fees_Master__c extraBusFeesData = new ET_Extra_Bus_Fees_Master__c();
        list<Integer> LstcontractYear = new list<Integer>();
        LstcontractYear.add(1);
        LstcontractYear.add(2);
        LstcontractYear.add(3);
        LstcontractYear.add(4);
        LstcontractYear.add(5);
        LstcontractYear.add(6);
        LstcontractYear.add(7);
        LstcontractYear.add(8);
        ET_Vehicle_Depreciation_Master__c vehicleDepreciationMaster = new ET_Vehicle_Depreciation_Master__c();
        vehicleDepreciationMaster.ET_Minimum_resale_value_percentage__c = 10;
        vehicleDepreciationMaster.ET_Min_Resale_Value__c = 1.1; 
        vehicleDepreciationMaster.ET_Depreciation_1_Year__c = '15';
        vehicleDepreciationMaster.ET_Depreciation_2_Year__c = '15';
        vehicleDepreciationMaster.ET_Depreciation_3_Year__c = '15';
        vehicleDepreciationMaster.ET_Depreciation_4_Year__c = '15';
        vehicleDepreciationMaster.ET_Depreciation_5_Year__c = '15';
        vehicleDepreciationMaster.ET_Depreciation_6_Year__c = '15';
        vehicleDepreciationMaster.ET_Depreciation_7_Year__c = '15';
        vehicleDepreciationMaster.ET_Depreciation_8_Year__c = '15';
        Vehicle_Insurance_Fee_Master__c insuranceMaster = new Vehicle_Insurance_Fee_Master__c();
        ET_Maintenance_Rate__c maintenanceRateMaster = new ET_Maintenance_Rate__c();
        ET_Pricing_Profit_Calculation_Setup__c profitMaster = new ET_Pricing_Profit_Calculation_Setup__c();
        ET_ServiceRequestController.vehicleQuoteCalcClass vehicleQuoteCalcObj = new ET_ServiceRequestController.vehicleQuoteCalcClass();
        vehicleQuoteCalcObj.contractYear = 1;
        ET_ServiceRequestController.getSObjectNameFromRecordId(q.Id);
        //ET_ServiceRequestController.submitForApproval(q.Id,'String comments');
        ET_ServiceRequestController.submitForApproval(null,null,null,null);
        ET_ServiceRequestController.fetchSubmitFlag(q.Id);
        ET_ServiceRequestController.deleteQuote(psr.Id);
        //ET_ServiceRequestController.createQuotation(psr.id);
        //ET_ServiceRequestController.rejectServiceRequest(psr.Id,'string rejectionReason');
        ET_ServiceRequestController.workforceQuoteCalcClass workforceQuoteCalcCls = new ET_ServiceRequestController.workforceQuoteCalcClass();
        ET_ServiceRequestController.vehicleSpecialRequirement vehicleSpecialRequirementcls = new ET_ServiceRequestController.vehicleSpecialRequirement();
        ET_ServiceRequestController.vehicleSpecialRequirementForTotalProject vehicleSpecialRequirementForTotalProjetcls = new ET_ServiceRequestController.vehicleSpecialRequirementForTotalProject();
        ET_ServiceRequestController.driverQuoteCalcClass driverQuoteCalcCls = new ET_ServiceRequestController.driverQuoteCalcClass();
        ET_ServiceRequestController.nannyQuoteCalcClass nannyQuoteCalcCls = new ET_ServiceRequestController.nannyQuoteCalcClass();
        ET_ServiceRequestController.supervisorQuoteCalcClass supervisorQuoteCalcCls = new ET_ServiceRequestController.supervisorQuoteCalcClass();
        ET_ServiceRequestController.coordinatorQuoteCalcClass coordinatorQuoteCalcCls = new ET_ServiceRequestController.coordinatorQuoteCalcClass();
        ET_ServiceRequestController.accountantQuoteCalcClass accountantQuoteCalcCls = new ET_ServiceRequestController.accountantQuoteCalcClass();
        ET_ServiceRequestController.otherEmpQuoteCalcClass otherEmpQuoteCalcCls = new ET_ServiceRequestController.otherEmpQuoteCalcClass();
        ET_ServiceRequestController.otherCostCalcClassTProj otherCostCalcClassTProjcls = new ET_ServiceRequestController.otherCostCalcClassTProj();
        List<ET_ServiceRequestController.vehicleQuoteCalcClass> lstvehicleQuoteItem = new List<ET_ServiceRequestController.vehicleQuoteCalcClass>();
        ET_ServiceRequestController.QuoteCalculationClass quoteCalcObj = new ET_ServiceRequestController.QuoteCalculationClass();
        quoteCalcObj.vehicleQuoteItemLst = lstvehicleQuoteItem;
        Test.startTest();
        ET_ServiceRequestController.getActiveSRId(oppList[0].id);
        ET_ServiceRequestController.getDriverMasterData();
        ET_ServiceRequestController.getOtherEmpMasterData();
        ET_ServiceRequestController.getAccountantMasterData();
        ET_ServiceRequestController.getCoordinatorMasterData();
        ET_ServiceRequestController.getSupervisorMasterData();
        ET_ServiceRequestController.getNannyMasterData();
        // ET_ServiceRequestController.validateOppStage(oppList[0].id);
        ET_ServiceRequestController.authorizedToCustomizePricing(pricingReq.id);
        ET_ServiceRequestController.authorizeOperation(pricingReq.id, 'serviceRequestFormModification');
        ET_ServiceRequestController.authorizeOperation(pricingReq.id, 'quoteCreation');
        ET_ServiceRequestController.fetchOpportunityRecordType(oppList[0].id, pricingReq.id);
        ET_ServiceRequestController.fetchOpportunityRecordType(null, pricingReq.id);
        ET_ServiceRequestController.fetchExistingApplicationData(pricingReq.id);
        ET_ServiceRequestController.activateServiceRequest(pricingReq.id);
        ET_ServiceRequestController.calcualteIRR( 11, 11, 1, 1,null, null);
        //ET_ServiceRequestController.saveAllTabCommonData(oppList[0].id, pricingReq.id);
        //ET_ServiceRequestController.rejectServiceRequest(pricingReq.id,'testReason');
        ET_ServiceRequestController.deleteQuote(pricingReq.id);
        ET_ServiceRequestController.getEditableFieldsforPricingTeam();
        ET_ServiceRequestController.getUserPermissions();
        ET_ServiceRequestController.saveAllTabCommonData(oppList[0].id, data);
        //ET_ServiceRequestController.saveAlterRates(alterRatesWrapper, serviceRequestId, quoteId, totalProjectQuoteId);
        ET_ServiceRequestController.getFinalCost(costList);
        for(Integer loopdec :LstcontractYear )
        {
            ET_ServiceRequestController.getExtraFee(extraBusFeesData, loopdec);    
        }
        for(Integer loopdec :LstcontractYear )
        {
            vehicleQuoteCalcObj.contractYear = loopdec;
            ET_ServiceRequestController.getDepreciationRateYearWise(vehicleDepreciationMaster, loopdec);
            ET_ServiceRequestController.getDepreciationRate(vehicleDepreciationMaster, loopdec);
            ET_ServiceRequestController.getInsuranceRate(insuranceMaster, loopdec);
            ET_ServiceRequestController.getmaintenanceRateYearWise(maintenanceRateMaster, loopdec);
            ET_ServiceRequestController.getProfitRate(profitMaster, vehicleQuoteCalcObj);
        }
        List<ET_Pricing_VAT_setup__c> vatData = new List<ET_Pricing_VAT_setup__c>();
        ET_Pricing_VAT_setup__c obj = new ET_Pricing_VAT_setup__c();
        obj.ET_Cost_Type__c = 'General';
        obj.ET_IsRecoverable__c = true;
        obj.ET_Cost_Api_Name__c = 'ET_Extra_Bus_Fees__c';
        vatData.add(obj);
        ET_Vehicle_Quote_Item__c vehicleQuoteItemtoInsert = new ET_Vehicle_Quote_Item__c();
        String costType = 'General';
        ET_ServiceRequestController.calculateVATCost(vatData, vehicleQuoteItemtoInsert, costType);
        ET_ServiceRequestController.getPredefinedOtherCostData();
        //ET_ServiceRequestController.createTotalProjectQuote(q, quoteCalcObj);
        //ET_ServiceRequestController.createQuoteObj(quoteCalcObj, pricingReq);
        //ET_ServiceRequestController.createQuotation(pricingReq.id);
        Test.stopTest();
    }
    
    @isTest
    public static void testForsaveServiceRequestData(){
        Map<String, object> mapObj = new Map<String, object>();
        ET_Pricing_Service_Request__c pricingReq = [SELECT id FROM ET_Pricing_Service_Request__c LIMIT 1];
        List<String> strList = new List<String>{'Vehicle', 'Other_Cost', 'Accountant', 'Other_Employee','Coordinator', 'Supervisor', 'Nanny', 'Driver'};
            Object ob = 'Vehicle';
        List<Object> strList1 = new List<Object>{'Vehicle', 'Other_Cost', 'Accountant', 'Other_Employee','Coordinator', 'Supervisor', 'Nanny', 'Driver'};
            Map<Object, object> vehicleMAp = new Map<object, object>();
        vehicleMAp.put('CurrencyIsoCode', 'AED');
        vehicleMAp.put('ET_Contract_Period__c', '1 Yr,2 Yrs,3 Yrs,4 Yrs,5 Yrs,6 Yrs,7 Yrs,8 Yrs');
        vehicleMAp.put('ET_Contract_Type__c', 'New');
        vehicleMAp.put('ET_Fleet_Type__c', 'ET Fleet');
        vehicleMAp.put('ET_Insurance_Coverage__c', 'UAE Only');
        vehicleMAp.put('ET_Pricing_Method__c', 'Comprehensive Price per Route');
        vehicleMAp.put('ET_Pricing_Type__c', 'Per student');
        vehicleMAp.put('ET_Service_Emirate__c', 'Ajman');
        vehicleMAp.put('ET_Specific_requirements__c', 'No');
        vehicleMAp.put('ET_Vehicle_Condition__c', 'New');
        vehicleMAp.put('ET_Vehicle_Fuel__c', 'No');
        vehicleMAp.put('ET_Vehicle_MAKE__c', 'Toyota');
        vehicleMAp.put('ET_Vehicle_Model_Year__c', '2018');
        vehicleMAp.put('ET_Vehicle_Model__c', 'Coaster');
        vehicleMAp.put('ET_Vehicle_Specs__c', 'Diesel');
        vehicleMAp.put('ET_Pricing_Service_Request__c', null);
        vehicleMAp.put('sObjectType', 'Vehicle__c');
        Vehicle__c vrh = new Vehicle__c();
        Map<Object, object> vehicleMAp1 = new Map<object, object>();
        String query = 'SELECT ET_Working_Months_Per_Year__c, ET_Working_Days_Per_Week__c, ET_Workforce_Line_Info__c, ET_Special_Requirements__c, ET_Pricing_Service_Request__c, ET_Service_Emirate__c, ET_Pricing_Type__c, ET_Pricing_Method__c, ET_Price_Utilization__c, ET_No_of_Drivers__c';
        query += ', ET_Driver_Category__c, ET_Contract_Type__c, ET_Contract_Period__c, CurrencyIsoCode FROM ET_Work_force__c Limit 1' ;
        ET_Work_force__c workforce = Database.query(query);
        vehicleMAp1.put('CurrencyIsoCode', workforce.CurrencyIsoCode);
        vehicleMAp1.put('ET_Workforce_Line_Info__c' , workforce.ET_Workforce_Line_Info__c);
        vehicleMAp1.put('ET_Contract_Period__c', workforce.ET_Contract_Period__c);
        vehicleMAp1.put('ET_Contract_Type__c', workforce.ET_Contract_Type__c);
        vehicleMAp1.put('ET_Driver_Category__c', workforce.ET_Driver_Category__c);
        vehicleMAp1.put('ET_Price_Utilization__c', workforce.ET_Price_Utilization__c);
        // workforce.ET_WORKING
        vehicleMAp1.put('ET_Pricing_Method__c', workforce.ET_Pricing_Method__c);
        vehicleMAp1.put('ET_Pricing_Type__c', workforce.ET_Pricing_Type__c);
        vehicleMAp1.put('ET_Service_Emirate__c', workforce.ET_Service_Emirate__c);
        vehicleMAp1.put('ET_Pricing_Service_Request__c', null);
        vehicleMAp1.put('ET_Special_Requirements__c', workforce.ET_Special_Requirements__c);
        // vehicleMAp.put('ET_Other_Cost_Request__c', 2);
        vehicleMAp1.put('sObjectType', 'ET_Work_force__c');
        List<object> vehicleList = new List<object>{vehicleMAp};
        //  mapObj.put('allTabData', JSON.serialize(o));
        mapObj.put('serviceRequestId', JSON.serialize(pricingReq.id));
        mapObj.put('deletedWholeTabLst', strList1);
        mapObj.put('vehicleTabInfo', vehicleList);
        mapObj.put('driverTabInfo', new List<object>{vehicleMAp1});
        mapObj.put('nannyTabInfo', new List<object>{vehicleMAp1});
        mapObj.put('supervisorTabInfo', new List<object>{vehicleMAp1});
        mapObj.put('coordinatorTabInfo', new List<object>{vehicleMAp1});
        mapObj.put('accountantTabInfo', new List<object>{vehicleMAp1});
        mapObj.put('otherEmployeeTabInfo', new List<object>{vehicleMAp1});
        mapObj.put('otherCostTabInfo', new List<object>{vehicleMAp1});
        Test.startTest();
        //ET_ServiceRequestController.createQuotation(pricingReq.id);
        //ET_ServiceRequestController.saveServiceRequestData(pricingReq.id, mapObj, 'serviceRequestFormModification', strList);
        Test.stopTest();
    }
    
    @isTest
    public static void testCoveragee(){
        ET_ServiceRequestController.testCoverage();
        //ET_ServiceRequestController.testCoverage1();
    }
    
}