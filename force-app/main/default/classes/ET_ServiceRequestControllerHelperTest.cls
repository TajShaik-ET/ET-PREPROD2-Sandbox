@isTest(SeeAllData=false)
private class ET_ServiceRequestControllerHelperTest {
    
   
    
   /* @isTest static void testBoilingPoint() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Account';
        opp.recordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Leasing').getRecordTypeId();
        opp.StageName = 'Qualification';
        opp.CloseDate = System.today()+8;
        opp.ETSALES_GNG_Approval_Status_Date__c = System.today()+8;
        opp.ETSALES_Approval_Status__c = 'Approved';
        opp.ETSALES_GL_Services__c = 'Bus';
        insert opp;
       
        
        /*ET_Vehicle_Quote_Item__c vehicleQuote = new ET_Vehicle_Quote_Item__c();
        vehicleQuote.Quote__c = q.id;
        vehicleQuote.ET_Quote_Item_Type__c='Vehicle';
        vehicleQuote.ET_Line_Number__c = 1;
        vehicleQuote.ET_Contract_Period__c = 1;
        vehicleQuote.ET_Depreciation_Method__c='Accelerated';
        vehicleQuote.ET_Fleet_Type__c='ET Fleet';
        vehicleQuote.ET_Depreciation_Type__c='Percentage';
        vehicleQuote.ET_Vehicle_Source__c = 'Main';
        vehicleQuote.ET_Vehicle_Current_Purchase_Price__c=3000;
        vehicleQuote.ET_Vehicle_Original_Purchase_Price__c = 2000;
        vehicleQuote.ET_Number_of_Vehicles__c = 2;
        vehicleQuote.ET_Min_Depreciation_Years__c = 2;
        vehicleQuote.ET_Vat_Rate__c = 'Exempt';
        
        insert vehicleQuote;
        
        ET_Service_Request_Common_Data__c et_service_request_common_data = new ET_Service_Request_Common_Data__c(
            CurrencyIsoCode = 'AED',
            ET_Common_Data_Type__c = 'All Tab',
            ET_Contract_Period__c = '1 Yr,2 Yrs,3 Yrs,4 Yrs,5 Yrs,6 Yrs,7 Yrs,8 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Dubai',
            ET_Working_Days_Per_Week__c = '7',
            ET_Working_Months_Per_Year__c = '12');
        insert et_service_request_common_data;
        Map<Object, Object> mapObj =  new Map<object, object>();
        mapObj.put('CurrencyIsoCode' , 'AED');
        mapObj.put('ET_Common_Data_Type__c' , 'All Tab');
        List<String> strLst = new List<String>{'1 Yr','2 Yrs','3 Yrs','4 Yrs','5 Yrs','6 Yrs','7 Yrs','8 Yrs'};
        mapObj.put('ET_Contract_Period__c' , strLst);
        mapObj.put('ET_Contract_Type__c' , 'New');
        mapObj.put('ET_Working_Months_Per_Year__c' , '12');
        mapObj.put('ET_Working_Days_Per_Week__c' , '7');
        mapObj.put('ET_Service_Emirate__c' , 'Dubai');
        mapObj.put('ET_Pricing_Type__c' , 'Annual Price');
        mapObj.put('ET_Pricing_Method__c' , 'Per Unit');
        mapObj.put('ET_Price_Utilization__c' , 1.0);
        ET_Pricing_Service_Request__c sr = new ET_Pricing_Service_Request__c(Opportunity__c = opp.Id, ET_PSR_IsActive__c = true, 
                                                                             ET_Service_Request_Common_Data__c = ET_Service_Request_Common_Data.id);
        insert sr;
        
        Quote q = new Quote();
        q.name = 'Quote1' + opp.name;
        q.opportunityId = opp.id;
        q.Is_Target_Price_Required__c=true;
        q.ET_Type__c = 'Total Project Summary';
        q.ET_Pricing_Service_Request__c = sr.Id;
        insert q;
        
        Vehicle__c vehicle = new Vehicle__c(
            ET_Pricing_Service_Request__c = sr.id,
            CurrencyIsoCode = 'AED',
            ET_Annual_KM__c = 40000.0,
            ET_Contract_Period__c = '1 Yr,2 Yrs,3 Yrs,4 Yrs,5 Yrs,6 Yrs,7 Yrs,8 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Fleet_Type__c = 'ET Fleet',
            ET_Insurance_Coverage__c = 'UAE Only',
            ET_Price_Utilization__c = 2.0,
            ET_Pricing_Method__c = 'Comprehensive Price per Route',
            ET_Pricing_Type__c = 'Per student',
            ET_Service_Emirate__c = 'Ajman',
            ET_Specific_requirements__c = 'Yes',
            ET_Vehicle_Condition__c = 'New',
            ET_Vehicle_Fuel__c = 'No',
            ET_Vehicle_Line__c = 1.0,
            ET_Vehicle_MAKE__c = 'Toyota',
            ET_Vehicle_Model_Year__c = '2018',
            ET_Vehicle_Model__c = 'Coaster',
            ET_Vehicle_Quantity__c = 13.0,
            ET_Vehicle_Specs__c = 'Diesel',
            ET_Working_Days_Per_Week__c = 5.0,
            ET_Other_Annual_Requirement__c = 'ET_CCTV_Camera,ET_GPS_Tracking_System,ET_Fuel_Card',
            ET_Working_Months_Per_Year__c = 6.0,
        ET_Service_Request_Common_Data__c = ET_Service_Request_Common_Data.id);
        insert vehicle;
        ET_Other_Cost_Request__c et_other_cost_request = new ET_Other_Cost_Request__c(
            Name = 'Admin',
            CurrencyIsoCode = 'AED',
            ET_Cost_Type__c = 'One_time_Cost,Annual_Cost',
            ET_Cost_Value__c = 1000.0,
            Vehicle_Request__c = vehicle.id);
        insert et_other_cost_request;
        
        ET_Service_Request_Common_Data__c et_service_request_common_data1 = new ET_Service_Request_Common_Data__c(
            CurrencyIsoCode = 'AED',
            ET_Common_Data_Type__c = 'All Tab',
            ET_Contract_Period__c = '1 Yr,2 Yrs,3 Yrs,4 Yrs,5 Yrs,6 Yrs,7 Yrs,8 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Dubai',
            ET_Working_Days_Per_Week__c = '7',
            ET_Working_Months_Per_Year__c = '12');
        insert et_service_request_common_data1;
        
        Id devRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByName().get('Nanny').getRecordTypeId();
        List<ET_Work_force__c> etworkforce = new List<ET_Work_force__c>();
        ET_Work_force__c et_work_force = new ET_Work_force__c(
            ET_Service_Request_Common_Data__c = et_service_request_common_data1.id,
            CurrencyIsoCode = 'AED',
            ET_Contract_Period__c = '2 Yrs,3 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Driver_Category__c = 'Driver Demo',
            ET_No_of_Drivers__c = 10.0,
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Pricing_Service_Request__c = sr.id,
            ET_Special_Requirements__c = 'Yes',
            ET_Workforce_Line_Info__c = 'ET_Driver:1',
            ET_Working_Days_Per_Week__c = 3.0,
            ET_Working_Months_Per_Year__c = 8.0,
        recordtypeid = devRecordTypeId);
        etworkforce.add(et_work_force);
        devRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByName().get('Driver').getRecordTypeId();
        et_work_force = new ET_Work_force__c(
            ET_Service_Request_Common_Data__c = et_service_request_common_data1.id,
            CurrencyIsoCode = 'AED',
            ET_Contract_Period__c = '2 Yrs,3 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Driver_Category__c = 'Driver Demo',
            ET_No_of_Drivers__c = 10.0,
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Pricing_Service_Request__c = sr.id,
            ET_Special_Requirements__c = 'Yes',
            ET_Workforce_Line_Info__c = 'ET_Driver:1',
            ET_Working_Days_Per_Week__c = 3.0,
            ET_Working_Months_Per_Year__c = 8.0,
        recordtypeid = devRecordTypeId);
        etworkforce.add(et_work_force);
        devRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByName().get('Supervisor').getRecordTypeId();
        et_work_force = new ET_Work_force__c(
            ET_Service_Request_Common_Data__c = et_service_request_common_data1.id,
            CurrencyIsoCode = 'AED',
            ET_Contract_Period__c = '2 Yrs,3 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Driver_Category__c = 'Driver Demo',
            ET_No_of_Drivers__c = 10.0,
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Pricing_Service_Request__c = sr.id,
            ET_Special_Requirements__c = 'Yes',
            ET_Workforce_Line_Info__c = 'ET_Driver:1',
            ET_Working_Days_Per_Week__c = 3.0,
            ET_Working_Months_Per_Year__c = 8.0,
        recordtypeid = devRecordTypeId);
        etworkforce.add(et_work_force);
        devRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByName().get('Coordinator').getRecordTypeId();
        et_work_force = new ET_Work_force__c(
            ET_Service_Request_Common_Data__c = et_service_request_common_data1.id,
            CurrencyIsoCode = 'AED',
            ET_Contract_Period__c = '2 Yrs,3 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Driver_Category__c = 'Driver Demo',
            ET_No_of_Drivers__c = 10.0,
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Pricing_Service_Request__c = sr.id,
            ET_Special_Requirements__c = 'Yes',
            ET_Workforce_Line_Info__c = 'ET_Driver:1',
            ET_Working_Days_Per_Week__c = 3.0,
            ET_Working_Months_Per_Year__c = 8.0,
        recordtypeid = devRecordTypeId);
        etworkforce.add(et_work_force);
        devRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByName().get('Accountant/Cashier').getRecordTypeId();
        et_work_force = new ET_Work_force__c(
            ET_Service_Request_Common_Data__c = et_service_request_common_data1.id,
            CurrencyIsoCode = 'AED',
            ET_Contract_Period__c = '2 Yrs,3 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Driver_Category__c = 'Driver Demo',
            ET_No_of_Drivers__c = 10.0,
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Pricing_Service_Request__c = sr.id,
            ET_Special_Requirements__c = 'Yes',
            ET_Workforce_Line_Info__c = 'ET_Driver:1',
            ET_Working_Days_Per_Week__c = 3.0,
            ET_Working_Months_Per_Year__c = 8.0,
        recordtypeid = devRecordTypeId);
        etworkforce.add(et_work_force);
        devRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByName().get('Other Employee').getRecordTypeId();
        et_work_force = new ET_Work_force__c(
            ET_Service_Request_Common_Data__c = et_service_request_common_data1.id,
            CurrencyIsoCode = 'AED',
            ET_Contract_Period__c = '2 Yrs,3 Yrs',
            ET_Contract_Type__c = 'New',
            ET_Driver_Category__c = 'Driver Demo',
            ET_No_of_Drivers__c = 10.0,
            ET_Price_Utilization__c = 1.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Annual Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Pricing_Service_Request__c = sr.id,
            ET_Special_Requirements__c = 'Yes',
            ET_Workforce_Line_Info__c = 'ET_Driver:1',
            ET_Working_Days_Per_Week__c = 3.0,
            ET_Working_Months_Per_Year__c = 8.0,
        recordtypeid = devRecordTypeId);
        etworkforce.add(et_work_force);
        insert etworkforce;
		
        ET_Service_Request__c req = new ET_Service_Request__c();
        req.ETCAR_Request_Type__c = 'Online';
        insert req;
        
        ETCAR_Service_Request_Line_Item__c vehBkng = new ETCAR_Service_Request_Line_Item__c();
        vehBkng.ETST_Pick_Up_From__c = 'Dubai';
        vehBkng.ETST_Service_Type__c = 'One Way';
        vehBkng.ETCAR_Service_Request__c = req.Id;
       // insert vehBkng;
        
        Test.startTest();
        
        Map<integer,list<sObject>> itemYearsLineMap = new Map<integer,list<sObject>>();
        List<ET_Alter_Rates_Elements__mdt> vehicleMdt = [Select id, Element_Name__c, Element_Api_Name__c from ET_Alter_Rates_Elements__mdt];
        integer Line = 0;
        String StrObj = '[{"elementRatesLineObj":[{"elementRatesYearObj":[{"elementLabel":"Insurance Rate (%)","elementRatesLineItemsObj":[{"elementAPIName":"ET_Insurance_Rate__c","elementRate":"2.60","isEdit":true,"quoteItemId":"a223M000000ILRKQA4"},{"elementAPIName":"ET_Insurance_Rate__c","isEdit":true},{"elementAPIName":"ET_Insurance_Rate__c","isEdit":true},{"elementAPIName":"ET_Insurance_Rate__c","isEdit":true},{"elementAPIName":"ET_Insurance_Rate__c","isEdit":true},{"elementAPIName":"ET_Insurance_Rate__c","isEdit":true},{"elementAPIName":"ET_Insurance_Rate__c","isEdit":true},{"elementAPIName":"ET_Insurance_Rate__c","isEdit":true}],"isRowEdit":true,"isSelected":false,"requestedBy":"Rate Fixing","approvedBy":"General Manager","alteringReason":"Rate","errorMsg":""},{"elementLabel":"General Reserve(%)","elementRatesLineItemsObj":[{"elementAPIName":"ET_General_Reserve_Rate__c","elementRate":"6.00","isEdit":false,"quoteItemId":"a223M000000ILRKQA4"},{"elementAPIName":"ET_General_Reserve_Rate__c","isEdit":false},{"elementAPIName":"ET_General_Reserve_Rate__c","isEdit":false},{"elementAPIName":"ET_General_Reserve_Rate__c","isEdit":false},{"elementAPIName":"ET_General_Reserve_Rate__c","isEdit":false},{"elementAPIName":"ET_General_Reserve_Rate__c","isEdit":false},{"elementAPIName":"ET_General_Reserve_Rate__c","isEdit":false},{"elementAPIName":"ET_General_Reserve_Rate__c","isEdit":false}],"isRowEdit":false,"isSelected":false,"requestedBy":"","approvedBy":""},{"elementLabel":"Vehicle Registration Fees","elementRatesLineItemsObj":[{"elementAPIName":"ET_Vehicle_Registration__c","elementRate":"900.00","isEdit":false,"quoteItemId":"a223M000000ILRKQA4"},{"elementAPIName":"ET_Vehicle_Registration__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Registration__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Registration__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Registration__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Registration__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Registration__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Registration__c","isEdit":false}],"isRowEdit":false,"isSelected":false,"requestedBy":"","approvedBy":""},{"elementLabel":"Financing (%)","elementRatesLineItemsObj":[{"elementAPIName":"ET_Financing_Rate__c","elementRate":"2.25","isEdit":false,"quoteItemId":"a223M000000ILRKQA4"},{"elementAPIName":"ET_Financing_Rate__c","isEdit":false},{"elementAPIName":"ET_Financing_Rate__c","isEdit":false},{"elementAPIName":"ET_Financing_Rate__c","isEdit":false},{"elementAPIName":"ET_Financing_Rate__c","isEdit":false},{"elementAPIName":"ET_Financing_Rate__c","isEdit":false},{"elementAPIName":"ET_Financing_Rate__c","isEdit":false},{"elementAPIName":"ET_Financing_Rate__c","isEdit":false}],"isRowEdit":false,"isSelected":false,"requestedBy":"","approvedBy":""},{"elementLabel":"Maintenance rate","elementRatesLineItemsObj":[{"elementAPIName":"ET_Vehicle_Maintenance_Rate__c","elementRate":"0.088","isEdit":false,"quoteItemId":"a223M000000ILRKQA4"},{"elementAPIName":"ET_Vehicle_Maintenance_Rate__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Maintenance_Rate__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Maintenance_Rate__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Maintenance_Rate__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Maintenance_Rate__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Maintenance_Rate__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Maintenance_Rate__c","isEdit":false}],"isRowEdit":false,"isSelected":false,"requestedBy":"","approvedBy":""},{"elementLabel":"Required ROI Rate(%)","elementRatesLineItemsObj":[{"elementAPIName":"ET_Vehicle_Profit_Rate_from_Master__c","elementRate":"4.50","isEdit":false,"quoteItemId":"a223M000000ILRKQA4"},{"elementAPIName":"ET_Vehicle_Profit_Rate_from_Master__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Profit_Rate_from_Master__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Profit_Rate_from_Master__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Profit_Rate_from_Master__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Profit_Rate_from_Master__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Profit_Rate_from_Master__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Profit_Rate_from_Master__c","isEdit":false}],"isRowEdit":false,"isSelected":false,"requestedBy":"","approvedBy":""},{"elementLabel":"Discount/Additional Profit(%)","elementRatesLineItemsObj":[{"elementAPIName":"ET_Discounts_Additional_Profit__c","elementRate":"0","isEdit":false,"quoteItemId":"a223M000000ILRKQA4"},{"elementAPIName":"ET_Discounts_Additional_Profit__c","isEdit":false},{"elementAPIName":"ET_Discounts_Additional_Profit__c","isEdit":false},{"elementAPIName":"ET_Discounts_Additional_Profit__c","isEdit":false},{"elementAPIName":"ET_Discounts_Additional_Profit__c","isEdit":false},{"elementAPIName":"ET_Discounts_Additional_Profit__c","isEdit":false},{"elementAPIName":"ET_Discounts_Additional_Profit__c","isEdit":false},{"elementAPIName":"ET_Discounts_Additional_Profit__c","isEdit":false}],"isRowEdit":false,"isSelected":false,"requestedBy":"","approvedBy":""},{"elementLabel":"Vehicle Depreciation Rates %","elementRatesLineItemsObj":[{"elementAPIName":"ET_Vehicle_Depreciation_Percentage__c","elementRate":"30.00","isEdit":false,"quoteItemId":"a223M000000ILRKQA4"},{"elementAPIName":"ET_Vehicle_Depreciation_Percentage__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Depreciation_Percentage__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Depreciation_Percentage__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Depreciation_Percentage__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Depreciation_Percentage__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Depreciation_Percentage__c","isEdit":false},{"elementAPIName":"ET_Vehicle_Depreciation_Percentage__c","isEdit":false}],"isRowEdit":false,"isSelected":false,"requestedBy":"","approvedBy":""}],"isSelectedAll":false,"Line":1}],"service":"Vehicle"},{"service":"Driver"},{"service":"Nanny"},{"service":"Coordinator"},{"service":"Supervisor"},{"service":"Other Employee"}] Employee"}]';
        	ET_ServiceRequestControllerHelper ets = new ET_ServiceRequestControllerHelper();
            ET_ServiceRequestControllerHelper.getEditableFieldsforPricingTeamHelper();
        	ET_ServiceRequestControllerHelper.getUserPermissionsHelper();
            ET_ServiceRequestControllerHelper.saveCommonData(mapObj, 'Vehicle Tab', sr);
            ET_ServiceRequestControllerHelper.fetchExistingAppData(sr.id);
        	ET_ServiceRequestControllerHelper.getVehicleAlterRatesWrp(itemYearsLineMap, vehicleMdt, Line);
        	System.debug('--Test Quote -- : ' + q.Id);
        	//ET_ServiceRequestControllerHelper.saveAlterRatesHelper(StrObj,req.Id, q.Id, q.Id);
        Test.stopTest();
    }*/
    @isTest
    public static void testCoverageMethod(){
        ET_ServiceRequestControllerHelper.testCoverage();
    }
}