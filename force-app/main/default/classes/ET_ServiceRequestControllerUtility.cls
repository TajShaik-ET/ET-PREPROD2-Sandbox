/* Class       : ET_ServiceRequestControllerUtility
Description : Test Utility Class to create Test Data
*/

public  class ET_ServiceRequestControllerUtility {
    public static List<Account>  createAccounts(integer count, String recordtypeid){
        List<Account> accList = new List<Account>();
        for(Integer i = 0 ; i < count; i++){
            Account acc = new Account();
            acc.Name = 'Test Account';
            if(recordtypeid != null && recordtypeid != ''){
                acc.RecordTypeId = recordtypeid;
            }
            accList.add(acc);
        }
        return accList;
    }
    public static List<Contact> createContacts(Integer count, String accountId) {
         List<Contact> contactList = new List<Contact>();
    for (Integer i = 0; i < count; i++) {
        Contact con = new Contact();
        con.FirstName = 'Test First Name ';
        con.LastName = 'Test Last Name ';
        if (accountId != null) {
            con.AccountId = accountId; // Associate the contact with an Account
        }
        contactList.add(con);
    }
    return contactList;
}
    
    public static List<Opportunity>  createOpportunities(integer count, String recordtypeid, String accountId){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i = 0 ; i < count; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Account';
            opp.StageName = 'Qualification';
            opp.CloseDate = System.today()+8;
            opp.ETSALES_GNG_Approval_Status_Date__c = System.today()+8;
            opp.ETSALES_Approval_Status__c = 'Approved';
            opp.ETSALES_GL_Services__c = 'Vehicle';
            if(recordtypeid != null && recordtypeid != ''){
                opp.RecordTypeId = recordtypeid;
            }
            if(accountId != null && accountId != ''){
                opp.AccountId = accountId;
            }
            oppList.add(opp);
        }
        return oppList;
    }
    
    public static void createWorkspaceMaster(){
        List<Workforce_Master__c> masterList = new List<Workforce_Master__c>();
        Workforce_Master__c workforce_master = new Workforce_Master__c(
            CurrencyIsoCode = 'AED',
            Clothes_Allowance__c = 500.0,
            Emirate__c = 'Abu dhabi',
            Number_of_Annual_Leave_months__c = '1 month full Gross salary',
            Number_of_End_of_Service_months__c = '1 month basic salary',
            Service_Type__c = 'Manpower Supply',
            Workforce_Type__c = 'Driver');
        masterList.add(workforce_master);
        
        workforce_master = new Workforce_Master__c(
            CurrencyIsoCode = 'AED',
            Clothes_Allowance__c = 500.0,
            Number_of_Annual_Leave_months__c = '1 month full Gross salary',
            Number_of_End_of_Service_months__c = '1 month basic salary',
            Workforce_Type__c = 'Nanny');
        masterList.add(workforce_master);
        workforce_master = new Workforce_Master__c(
            CurrencyIsoCode = 'AED',
            Clothes_Allowance__c = 500.0,
            Number_of_Annual_Leave_months__c = '1 month full Gross salary',
            Number_of_End_of_Service_months__c = '1 month basic salary',
            Workforce_Category__c = 'Abudhabi School Driver',
            Workforce_Type__c = 'Supervisor');
        masterList.add(workforce_master);
        workforce_master = new Workforce_Master__c(
            CurrencyIsoCode = 'AED',
            Clothes_Allowance__c = 500.0,
            Number_of_Annual_Leave_months__c = '1 month full Gross salary',
            Number_of_End_of_Service_months__c = '1 month basic salary',
            Workforce_Category__c = 'Abudhabi School Driver',
            Workforce_Type__c = 'Coordinator');
        masterList.add(workforce_master);
        workforce_master = new Workforce_Master__c(
            CurrencyIsoCode = 'AED',
            Clothes_Allowance__c = 500.0,
            Number_of_Annual_Leave_months__c = '1 month full Gross salary',
            Number_of_End_of_Service_months__c = '1 month basic salary',
            Workforce_Category__c = 'Abudhabi School Driver',
            Workforce_Type__c = 'Accountant/Cashier');
        masterList.add(workforce_master);
        workforce_master = new Workforce_Master__c(
            CurrencyIsoCode = 'AED',
            Clothes_Allowance__c = 500.0,
            Number_of_Annual_Leave_months__c = '1 month full Gross salary',
            Number_of_End_of_Service_months__c = '1 month basic salary',
            Workforce_Category__c = 'Abudhabi School Driver',
            Workforce_Type__c = 'Other Employee');
        masterList.add(workforce_master);
        insert masterList;
        
        // Health card master
        List<ET_Healthcard_Master__c> healthCardMasList = new List<ET_Healthcard_Master__c>();
        ET_Healthcard_Master__c hsm = new 	ET_Healthcard_Master__c(
            Manpower_Category__c = 'Driver',
            Operator__c= '<',
            Salary__c = 5000,
            Service_Type__c = 'Manpower Supply',
            Year_1__c= 1270,
            Year_2__c =1270,
            Year_3__c =1270,
            Year_4__c=1270,
            Year_5__c =1270,
            Year_6__c =1270,
            Year_7__c =1270,
            Year_8__c =1270,
            Emirates__c = 'Abu dhabi'
        );
        
        healthCardMasList.add(hsm);
        
        ET_Healthcard_Master__c hsm2 = new 	ET_Healthcard_Master__c(
            Manpower_Category__c = 'Driver',
            Operator__c= '>=',
            Salary__c = 5000,
            Service_Type__c = 'Manpower Supply',
            Year_1__c= 1270,
            Year_2__c =1270,
            Year_3__c =1270,
            Year_4__c=1270,
            Year_5__c =1270,
            Year_6__c =1270,
            Year_7__c =1270,
            Year_8__c =1270,
            Emirates__c = 'Abu dhabi'
        );
        
        healthCardMasList.add(hsm2);
        
        insert healthCardMasList;
        
        //workforce Visa Master
        List<ET_Workforce_Visa_Master__c> VisaMasterList = new List<ET_Workforce_Visa_Master__c>();
        ET_Workforce_Visa_Master__c  visaMaster = new ET_Workforce_Visa_Master__c(
        	ET_Api_Name__c = 'Driver',
            ET_Emirates__c = 'All',
            ET_Number_of_Coverage_years__c = 3,
            Name = 'Driver',
            Year_1__c= 743,
            Year_2__c = 372,
            Year_3__c =248,
            Year_4__c=372,
            Year_5__c =297,
            Year_6__c=248,
            Year_7__c =372,
            Year_8__c =297
        );
        
        insert visaMaster;
        
        ET_Workforce_Profit_Master__c profitMaster = new ET_Workforce_Profit_Master__c(
        	ET_Api_Name__c = 'Annual_Driver_Profit_Margin_Value',
            Name = 'Annual Driver Profit Margin Value',
            Profit_Percentage__c = 12
        );
        
        insert profitMaster;
        
        
        
    }
    
    public static void createMultiplerecords(){
        List<Opportunity> oppList = [SELECT id FROM Opportunity ];
        List<Account> accList = [SELECT id FROM Account ];
        
        // service request common data
        ET_Service_Request_Common_Data__c et_service_request_common_data = new ET_Service_Request_Common_Data__c(
            CurrencyIsoCode = 'AED',
            ET_Common_Data_Type__c = 'All Tab',
            ET_Contract_Period__c = '1 Yr',
            ET_Contract_Type__c = 'New',
            ET_Price_Utilization__c = 12.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Monthly Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Working_Days_Per_Week__c = '7',
            ET_Working_Months_Per_Year__c = '12',
            ET_Request_for_Target_Price__c = true,
            ET_Request_for_Separate_Prices__c = true
        );
        insert et_service_request_common_data;
        
        // service Request
        ET_Pricing_Service_Request__c sr = new ET_Pricing_Service_Request__c(Opportunity__c = oppList[0].Id, ET_PSR_IsActive__c = true, 
                                                                             ET_Service_Request_Common_Data__c = ET_Service_Request_Common_Data.id);
        insert sr;
        
        // Vehicle Requests
        List<Vehicle__c> vehList = new List<Vehicle__c>();
        Vehicle__c vehicle = new Vehicle__c(
            ET_Pricing_Service_Request__c = sr.id,
            CurrencyIsoCode = 'AED',
            ET_Annual_KM__c = 51600.0,
            ET_Annual_Target_Price__c = 81600,
            ET_Contract_Period__c = '1 Yr',
            ET_Contract_Type__c = 'New',
            ET_Fleet_Type__c = 'ET Fleet',
            ET_Fuel_Type__c = 'Petrol',
            ET_Insurance_Coverage__c = 'UAE Only',
            ET_Number_of_seats__c = 5,
            ET_Price_Utilization__c = 12.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Monthly Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Service_Request_Common_Data__c = ET_Service_Request_Common_Data.id,
            ET_Service_Type__c = 'General Rent',
            ET_Specific_requirements__c = 'Yes',
            ET_Vehicle_Condition__c = 'Used',
            ET_Vehicle_Current_Purchase_Price__c = 40000,
            ET_Vehicle_Fuel__c = 'No',
            ET_Vehicle_Line__c = 1,
            ET_Vehicle_MAKE__c = 'TOYOTA',
            ET_Vehicle_Model__c = 'TOYOTA Rav 4',
            ET_Vehicle_Model_Year__c = '2017',
            Add_Trailer_Equipment__c= true,
            Trailer_Equipment_Make__c = 'TRAILERS',
            Trailer_Equipment_Model__c = 'Semi Trailer',
            Trailer_Equipment_Type__c = 'Trailer',
			Trailer_Equipment_subtype__c = 'Semi-Trailer',
            Trailer_condition__c = 'New',
            Trailer_original_purchase_price__c = 40000,
            Trailer_Current_purchase_price__c = 40000,
            Trailer_model_year__c = 2021,
            
            Add_Refregirator__c= true,
            Refregirator_Make__c = 'Cooling Unit',
            Refregirator_Model__c = 'Cooling Unit 1.5 Ton',
            Refregirator_Type__c = 'Sedan',
			Refregirator_subtype__c = 'Saloon',
            Refrigerator_condition__c = 'New',
            Refrigerator_original_purchase_price__c = 1200000,
            Refrigerator_Current_purchase_price__c =1200000 ,
            Refrigerator_model_year__c = 2021,
            ET_Vehicle_Original_Purchase_Price__c = 111000,
            ET_Vehicle_Quantity__c = 10,
            ET_Vehicle_Source__c= 'Main',
            ET_Vehicle_Sub_Type__c = 'SUV',
            ET_Working_Days_Per_Week__c = 7,
            ET_Working_Months_Per_Year__c =12,
            Insurance_Category__c = 'Light',
            Vehicle_Type__c = 'SUV'
        );
        vehList.add(vehicle);
        insert vehList;
        
        Id driverRecordTypeId = Schema.SObjectType.ET_Work_force__c.getRecordTypeInfosByDeveloperName().get('ET_Driver').getRecordTypeId();
        ET_Work_force__c et_work_force = new ET_Work_force__c(
            CurrencyIsoCode = 'AED',
            ET_Contract_Period__c = '1 Yr',
            ET_Contract_Type__c = 'New',
            ET_Driver_Category__c = 'Abu dhabi Manpower Supply Driver',
            ET_No_of_Drivers__c = 10.0,
            ET_Price_Utilization__c = 12.0,
            ET_Pricing_Method__c = 'Per Unit',
            ET_Pricing_Type__c = 'Monthly Price',
            ET_Service_Emirate__c = 'Abu Dhabi',
            ET_Service_Type__c = 'General Rent',
            ET_Pricing_Service_Request__c = sr.id,
            ET_Service_Request_Common_Data__c = ET_Service_Request_Common_Data.id,
            ET_Special_Requirements__c = 'Yes',
            ET_Workforce_Line_Info__c = 'ET_Driver:1',
            ET_Working_Days_Per_Week__c = 7.0,
            ET_Working_Months_Per_Year__c = 12.0,
            RecordTypeId = driverRecordTypeId
        );
        insert et_work_force;
        
        // special workforce requirements to Driver ..
        
        ET_Special_Workforce_Requirement__c specReq = new 	ET_Special_Workforce_Requirement__c(
            ET_Specific_Base_Salary__c = 710,
            ET_Specific_Gross_Salary__c = 4000,
            Training_and_Licensing_Cost__c = 0,
            Language_and_Psychometric_Test_Fee__c = 0,
            Work_force_Request__c = et_work_force.id
        );
        
        insert specReq;
        
        // Request mapping..
        ET_Request_Mapping__c reqMapping = new ET_Request_Mapping__c(
        	ET_Driver_Unique_Id__c = 'Abu dhabi Manpower Supply Driver=>1',
            ET_Number_of_Drivers__c = 10,
            ET_Number_of_Vehicles__c = 10,
            ET_Vehicle_Unique_key__c = 'TOYOTA_TOYOTA Rav 4_2017=>1',
            ET_Pricing_Service_Request__c = sr.id
        );
        
        insert reqMapping;
            
        List<ET_Other_Cost_Request__c> etcList = new List<ET_Other_Cost_Request__c>();
        
        ET_Other_Cost_Request__c  otherC = new ET_Other_Cost_Request__c();
        otherC.ET_Pricing_Service_Request__c = sr.Id;
        otherC.Name = 'Test';
        otherC.ET_Cost_Type__c = 'One_time_Cost,Annual_Cost';
        otherC.ET_Cost_Value__c = 23;
        etcList.add(otherC);
        
        otherC = new ET_Other_Cost_Request__c();
        otherC.Name = 'Test';
        otherC.ET_Cost_Type__c = 'One_time_Cost';
        otherC.Vehicle_Request__c = vehicle.Id;
        otherC.ET_Cost_Value__c = 23;
        etcList.add(otherC);
        
        otherC = new ET_Other_Cost_Request__c();
        otherC.Name = 'Test';
        otherC.ET_Cost_Type__c = 'One_time_Cost';
        otherC.ET_Pricing_Service_Request__c = sr.Id;
        otherC.ET_Cost_Value__c = 23;
        etcList.add(otherC);
        
        otherC = new ET_Other_Cost_Request__c();
        otherC.Name = 'Test';
        otherC.ET_Cost_Type__c = 'Annual_Cost';
        otherC.ET_Pricing_Service_Request__c = sr.Id;
        otherC.ET_Cost_Value__c = 23;
        etcList.add(otherC);
        insert etcList;
        
        ET_ServiceRequestControllerUtility.createWorkspaceMaster();
        Quote quote = new Quote(
            Name = 'Explore Leasing_PSR-0226_quote',
            CurrencyIsoCode = 'AED',
            OpportunityId = oppList[0].id,
            Status = 'Draft',
            ET_Pricing_Service_Request__c = sr.id,
            Total_Number_of_Main_Vehicles__c = 10,
            Total_Number_of_Drivers__c =10,
            Total_Number_of_Accountants__c = 1,
            Total_Number_of_Coordinators__c =1,
            Total_Number_of_Nannies__c=1,
            Total_Number_of_Other_Employees__c =1,
            Total_Number_of_Supervisors__c =1,
            IsActive__c = true,
            Approval_Status__c = 'Pending for General Manager');
        insert quote;
        
        
        
        
        
        Client_Classification_Master__c client_classification_master = new Client_Classification_Master__c(
            CurrencyIsoCode = 'AED',
            Client_Type__c = 'Sovereign',
            Classification__c = 'Standard Rated Client');
        insert client_classification_master;
        
        ET_Vehicle_Type_Master__c et_vehicle_type_master = new ET_Vehicle_Type_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Vehicle_Sub_Type__c = 'SUV',
            ET_Vehicle_Type__c = 'SUV');
        insert et_vehicle_type_master;
        
        ET_Vehicle_Type_Master__c et_vehicle_type_master2 = new ET_Vehicle_Type_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Vehicle_Sub_Type__c = 'Semi-Trailer',
            ET_Vehicle_Type__c = 'Trailer');
        insert et_vehicle_type_master2;
        
        ET_Vehicle_Type_Master__c et_vehicle_type_master3 = new ET_Vehicle_Type_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Vehicle_Sub_Type__c = 'Saloon',
            ET_Vehicle_Type__c = 'Sedan');
        insert et_vehicle_type_master3;
        
        ET_Vehicle_Fuel_Master__c et_vehicle_fuel_master = new ET_Vehicle_Fuel_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Actual_Liter_Price__c = 2.05,
            ET_Fuel_Type__c = 'Petrol',
            ET_Liter_Price__c = 2.05,
            ET_Motor_Usage__c = 100.0,
            ET_Unit__c = 'Per Liter');
        insert et_vehicle_fuel_master;
        
        
        ET_Vehicle_Master__c et_vehicle_master = new ET_Vehicle_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Country_Of_Origin__c = 'Europe',
            ET_Deduction_Rate_for_latest_new_pri_del__c = 5.0,
            ET_Depreciation_Rate_Max__c = 95.0,
            ET_Manufacture_Year__c = 2019.0,
            ET_Model__c = vehicle.ET_Vehicle_Model__c,
            ET_Number_of_seats__c = 5.0,
            ET_Specs__c = vehicle.ET_Vehicle_Specs__c,
            ET_Vehicle_Fuel_Consumption__c = 8.0,
            ET_Vehicle_Fuel_Master__c = et_vehicle_fuel_master.id,
            ET_Vehicle_Latest_New_Purchase_Price__c = 147000.0,
            ET_Vehicle_Make__c = vehicle.ET_Vehicle_MAKE__c,
            ET_Vehicle_Type_Master__c = et_vehicle_type_master.id);
        
        insert et_vehicle_master;
        ET_Vehicle_Depreciation_Master__c et_vehicle_depreciation_master = new ET_Vehicle_Depreciation_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Vehicle_Type_Master__c = et_vehicle_type_master.id,
            ET_Deduction_Rate_for_latest_new_price__c = 5.0,
            Vehicle_Make__c = vehicle.ET_Vehicle_MAKE__c,
            ET_Vehicle_Model__c = vehicle.ET_Vehicle_Model__c,
            ET_Depreciation_1_Year__c = '25.0',
            ET_Depreciation_2_Year__c = '15',
            ET_Depreciation_3_Year__c = '10',
            ET_Depreciation_4_Year__c = '10',
            ET_Depreciation_5_Year__c = '10',
            ET_Depreciation_6_Year__c = '5',
            ET_Depreciation_7_Year__c = '5',
            ET_Depreciation_8_Year__c = '5',
            ET_Depreciation_Type__c = 'Percentage',
            ET_Max_Depreciation_Years__c = 20.0,
            ET_Max_Resale_Value__c = 1000.0,
            ET_Min_Depreciation_Years__c = 15.0,
            ET_Min_Resale_Value__c = 5000.0,
            ET_Minimum_resale_value_percentage__c = 10.0,
            ET_Depreciation_Rate_Max__c = 95.0);
        
        insert et_vehicle_depreciation_master;
        
        ET_Vehicle_Depreciation_Master__c et_vehicle_depreciation_master2 = new ET_Vehicle_Depreciation_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Vehicle_Type_Master__c = et_vehicle_type_master.id,
            ET_Deduction_Rate_for_latest_new_price__c = 5.0,
            Vehicle_Make__c = vehicle.Trailer_Equipment_Make__c,
            ET_Vehicle_Model__c = vehicle.Trailer_Equipment_Model__c,
            ET_Depreciation_1_Year__c = '25.0',
            ET_Depreciation_2_Year__c = '15',
            ET_Depreciation_3_Year__c = '10',
            ET_Depreciation_4_Year__c = '10',
            ET_Depreciation_5_Year__c = '10',
            ET_Depreciation_6_Year__c = '5',
            ET_Depreciation_7_Year__c = '5',
            ET_Depreciation_8_Year__c = '5',
            ET_Depreciation_Type__c = 'Percentage',
            ET_Max_Depreciation_Years__c = 20.0,
            ET_Max_Resale_Value__c = 1000.0,
            ET_Min_Depreciation_Years__c = 15.0,
            ET_Min_Resale_Value__c = 5000.0,
            ET_Minimum_resale_value_percentage__c = 10.0,
            ET_Depreciation_Rate_Max__c = 95.0);
        
        insert et_vehicle_depreciation_master2;
        
        ET_Vehicle_Depreciation_Master__c et_vehicle_depreciation_master3 = new ET_Vehicle_Depreciation_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Vehicle_Type_Master__c = et_vehicle_type_master.id,
            ET_Deduction_Rate_for_latest_new_price__c = 5.0,
            Vehicle_Make__c = vehicle.Refregirator_Make__c,
            ET_Vehicle_Model__c = vehicle.Refregirator_Model__c,
            ET_Depreciation_1_Year__c = '25.0',
            ET_Depreciation_2_Year__c = '15',
            ET_Depreciation_3_Year__c = '10',
            ET_Depreciation_4_Year__c = '10',
            ET_Depreciation_5_Year__c = '10',
            ET_Depreciation_6_Year__c = '5',
            ET_Depreciation_7_Year__c = '5',
            ET_Depreciation_8_Year__c = '5',
            ET_Depreciation_Type__c = 'Percentage',
            ET_Max_Depreciation_Years__c = 20.0,
            ET_Max_Resale_Value__c = 1000.0,
            ET_Min_Depreciation_Years__c = 15.0,
            ET_Min_Resale_Value__c = 5000.0,
            ET_Minimum_resale_value_percentage__c = 10.0,
            ET_Depreciation_Rate_Max__c = 95.0);
        
        insert et_vehicle_depreciation_master3;
        
        List<ET_Extra_Depreciation_Rate__c> extraList = new List<ET_Extra_Depreciation_Rate__c>();
        ET_Extra_Depreciation_Rate__c et_extra_depreciation_rate = new ET_Extra_Depreciation_Rate__c(
            CurrencyIsoCode = 'AED',
            ET_Applicable_KM_End_Range__c = 60000.0,
            ET_Applicable_KM_Start_Range__c = 30000.0,
            ET_Depreciation_Rate__c = 2.0,
            ET_Vehicle_Type_Master__c = et_vehicle_type_master.id);
        extraList.add(et_extra_depreciation_rate);
        
        et_extra_depreciation_rate = new ET_Extra_Depreciation_Rate__c(
            CurrencyIsoCode = 'AED',
            ET_Applicable_KM_End_Range__c = 80000.0,
            ET_Applicable_KM_Start_Range__c = 60000.0,
            ET_Depreciation_Rate__c = 0.0,
            Insurance_Category__c = 'Light',
            ET_Vehicle_Type_Master__c = et_vehicle_type_master.id);
        extraList.add(et_extra_depreciation_rate);
        
        
        insert extraList;
        
        List<ET_Pricing_Service_Reserve_Master__c> pricingServiceList = new List<ET_Pricing_Service_Reserve_Master__c>();
        ET_Pricing_Service_Reserve_Master__c et_pricing_service_reserve_master = new ET_Pricing_Service_Reserve_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Depreciation_Reserve_Rate__c = 5.0,
            ET_Fuel_Reserve_Rate__c = 5.0,
            ET_General_Reserve_Rate__c = 6.0,
            ET_Maintenance_Reserve_Rate__c = 5.0,
            ET_Driver_Reserve_Rate__c = 5.0,
            ET_Manpower_Reserve_Rate__c = 5.0,
            ET_Depreciation_Method__c = 'Accelerated',
            ET_Service_Type__c = 'General Rent');
        pricingServiceList.add(et_pricing_service_reserve_master);
        
        et_pricing_service_reserve_master = new ET_Pricing_Service_Reserve_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Depreciation_Reserve_Rate__c = 5.0,
            ET_Fuel_Reserve_Rate__c = 5.0,
            ET_General_Reserve_Rate__c = 6.0,
            ET_Maintenance_Reserve_Rate__c = 5.0,
            ET_Manpower_Reserve_Rate__c = 5.0,
            ET_Depreciation_Method__c = 'Straight Line',
            ET_Service_Type__c = 'General Rent');
        pricingServiceList.add(et_pricing_service_reserve_master);
        insert pricingServiceList;
        List<ET_Maintenance_Rate__c> maintenceList = new List<ET_Maintenance_Rate__c>();
        
        ET_Maintenance_Rate__c et_maintenance_rate = new ET_Maintenance_Rate__c(
            CurrencyIsoCode = 'AED',
            ET_Country_of_Origin__c = 'Japan',
            Vehicle_Make__c = vehicle.ET_Vehicle_MAKE__c,
            ET_Vehicle_Model__c = vehicle.ET_Vehicle_Model__c,
            ET_Purchase_Price_End_Range__c = 157000.0,
            ET_Purchase_Price_Start_Range__c = 0.0,
            ET_Fixed_Maintenance_Rate__c = 2.0,
            ET_Variable_Maintenance_Rate_1st_year__c = 5.0,
            ET_Variable_Maintenance_Rate_2nd_year__c = 5.0,
            ET_Variable_Maintenance_Rate_3rd_year__c = 5.0,
            ET_Variable_Maintenance_Rate_4th_year__c = 6.5,
            ET_Variable_Maintenance_Rate_5th_year__c = 6.5,
            ET_Variable_Maintenance_Rate_6th_year__c = 7.5,
            ET_Variable_Maintenance_Rate_7th_year__c = 7.5,
            ET_Variable_Maintenance_Rate_8th_year__c = 7.5
        );
        maintenceList.add(et_maintenance_rate);
        
        insert maintenceList;
        
        Vehicle_Insurance_Fee_Master__c vehicle_insurance_fee_master = new Vehicle_Insurance_Fee_Master__c(
            CurrencyIsoCode = 'AED',
            ET_Ambulance_Cost__c = 50.0,
            Vehicle_Type__c = 'SUV',
            ET_Driver_Cost__c = 150.0,
            ET_Insurance_Rate_1st_Year__c = 1.6,
            ET_Minimum_Cost__c = 900.0,
            ET_Minimum_Vehicle_Value__c = 8000.0,
            ET_Number_of_Depreciated_years__c = 5.0,
            ET_Other_Cost__c = 0.0,
            ET_Passenger_Cost_Per_Seat__c = 30.0,
            ET_Insurance_Rate_2nd_Year__c = 1.6,
            ET_Insurance_Rate_3rd_Year__c = 1.6,
            ET_Insurance_Rate_4th_Year__c = 1.6,
            ET_Insurance_Rate_5th_Year__c = 1.6,
            ET_Insurance_Rate_6th_Year__c = 1.6,
            ET_Insurance_Rate_7th_Year__c = 1.6,
            ET_Insurance_Rate_8th_Year__c = 1.6,
            ET_Emirates__c = 'All');
        
        insert vehicle_insurance_fee_master;
        
        ET_Pricing_VAT_setup__c vatSetup = new ET_Pricing_VAT_setup__c(
            ET_Cost_Api_Name__c = 'ET_Vehicle_Current_Purchase_Price__c',
            name = 'Vehicle Current Purchase price',
            ET_Cost_Type__c = 'Vehicle Direct',
            ET_IsRecoverable__c = true
        );
        
        insert vatSetup;
        
        ET_Vehicle_Registration_Inspection_Fee__c et_vehicle_registration_inspection_fee = new ET_Vehicle_Registration_Inspection_Fee__c(
            CurrencyIsoCode = 'AED',
            ET_Inspection_Fee_1st_Year__c = 565.00,
            ET_Inspection_Fee_2nd_Year__c = 150.0,
            ET_Inspection_Fee_3rd_Year__c = 150.0,
            ET_Inspection_Fee_4th_Year__c = 150.0,
            ET_Inspection_Fee_5th_Year__c = 150.0,
            ET_Inspection_Fee_6th_Year__c = 150.0,
            ET_Inspection_Fee_7th_Year__c = 150.0,
            ET_Inspection_Fee_8th_Year__c = 150.0,
            ET_Registration_Fee_1st_Year__c = 400.0,
            ET_Registration_Fee_2nd_Year__c = 350.0,
            ET_Registration_Fee_3rd_Year__c = 350.0,
            ET_Registration_Fee_4th_Year__c = 350.0,
            ET_Registration_Fee_5th_Year__c = 350.0,
            ET_Registration_Fee_6th_Year__c = 350.0,
            ET_Registration_Fee_7th_Year__c = 350.0,
            ET_Registration_Fee_8th_Year__c = 350.0,
            ET_Vehicle_Type__c = et_vehicle_type_master.id,
            ET_Emirates__c = 'Abu Dhabi');
        
        insert et_vehicle_registration_inspection_fee; 
        
        ET_Vehicle_Registration_Inspection_Fee__c et_vehicle_registration_inspection_fee2 = new ET_Vehicle_Registration_Inspection_Fee__c(
            CurrencyIsoCode = 'AED',
            ET_Inspection_Fee_1st_Year__c = 565.00,
            ET_Inspection_Fee_2nd_Year__c = 150.0,
            ET_Inspection_Fee_3rd_Year__c = 150.0,
            ET_Inspection_Fee_4th_Year__c = 150.0,
            ET_Inspection_Fee_5th_Year__c = 150.0,
            ET_Inspection_Fee_6th_Year__c = 150.0,
            ET_Inspection_Fee_7th_Year__c = 150.0,
            ET_Inspection_Fee_8th_Year__c = 150.0,
            ET_Registration_Fee_1st_Year__c = 400.0,
            ET_Registration_Fee_2nd_Year__c = 350.0,
            ET_Registration_Fee_3rd_Year__c = 350.0,
            ET_Registration_Fee_4th_Year__c = 350.0,
            ET_Registration_Fee_5th_Year__c = 350.0,
            ET_Registration_Fee_6th_Year__c = 350.0,
            ET_Registration_Fee_7th_Year__c = 350.0,
            ET_Registration_Fee_8th_Year__c = 350.0,
            ET_Vehicle_Type__c = et_vehicle_type_master2.id,
            ET_Emirates__c = 'Abu Dhabi');
        
        insert et_vehicle_registration_inspection_fee2; 
        
        ET_Pricing_Vehicle_Finance_Rate_Setup__c finMaster = new ET_Pricing_Vehicle_Finance_Rate_Setup__c(
        	ET_Finance_Rate__c = 2.25,
            ET_Number_of_Financing_years__c= 4,
            ET_Vehicle_Type__c= 'All'
        );
        
        insert finMaster;
    }
    
}