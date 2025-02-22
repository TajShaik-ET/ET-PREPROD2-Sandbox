({
    setCommunityLanguage : function(component, event, helper) {
        
        var url_string = window.location.href;
        var url = new URL(url_string);
        var lang = url.searchParams.get("lang");
        component.set('v.clLang',lang);
        if(lang == 'ar'){
            component.set('v.clLang', 'ar');
            
            //GrouthRequest Custom lable for Request Creation Form in Arabic 
            
            component.set("v.clSchoolName", $A.get("$Label.c.MOE_School_Name_AR"));
            component.set("v.clCity", $A.get("$Label.c.MOE_City_AR"));
            component.set("v.clNoofStudents", $A.get("$Label.c.MOE_No_of_Students_AR"));
            component.set("v.clGender", $A.get("$Label.c.MOE_Gender_AR"));
            component.set("v.clZoneType", $A.get("$Label.c.MOE_Zone_Type_AR"));
            component.set("v.clCoordinatorName", $A.get("$Label.c.MOE_Coordinator_Name_AR"));
            component.set("v.clPhone", $A.get("$Label.c.MOE_Phone_AR"));           
            component.set("v.clDescription", $A.get("$Label.c.ESE_Description_Case_AR"));
            
            //Special Needs Nanny Request
            component.set("v.clStudent", $A.get("$Label.c.MOE_Student_AR"));
            component.set("v.clSISNumber", $A.get("$Label.c.MOE_SIS_Number_AR"));
            component.set("v.clGrade", $A.get("$Label.c.MOE_Grade_AR"));
            component.set("v.clParentName", $A.get("$Label.c.MOE_Parent_Name_AR"));
            component.set("v.clTripDestination", $A.get("$Label.c.MOE_Trip_Destination_AR"));
            component.set("v.cllandmark", $A.get("$Label.c.MOE_LAND_MARK_AR"));
            component.set("v.clDisabilityType", $A.get("$Label.c.MOE_Disability_Type_AR"));
            component.set("v.clMobilityAids", $A.get("$Label.c.MOE_Mobility_Aids_AR"));
            component.set("v.clSubRequest", $A.get("$Label.c.MOE_Sub_Request_AR"));
            component.set("v.clDelegatedPersonName", $A.get("$Label.c.MOE_Delegated_Person_Name_AR"));
            component.set("v.clDelegatedPersonPhone", $A.get("$Label.c.MOE_Delegated_Person_Phone_AR"));
            component.set("v.clAssignedResources", $A.get("$Label.c.MOE_Assigned_Resources_AR")); 
            component.set("v.clCCMRemarks", $A.get("$Label.c.MOE_CCM_Remarks_AR"));
            component.set("v.clStudenthomeAr", $A.get("$Label.c.MOE_Student_home_Ar"));
            component.set("v.clInternalNumberofStudent", $A.get("$Label.c.Internal_Number_of_Bus_Ar"))
            //Companino Request
            component.set("v.clStudentId", $A.get("$Label.c.MOE_Student_Id_AR"));
            component.set("v.clStudentCompanionName", $A.get("$Label.c.MOE_Student_Escort_Name_AR"));
            component.set("v.clCompanionIDNumber", $A.get("$Label.c.MOE_Companion_ID_Number_AR"));
            //Activity And Event Request
            component.set("v.clTripType", $A.get("$Label.c.MOE_Trip_Type_AR"));
            component.set("v.clMode", $A.get("$Label.c.MOE_Mode_AR"));
            component.set("v.clNoofPassengers", $A.get("$Label.c.MOE_No_of_Passengers_AR"));
            component.set("v.clStudentDivision", $A.get("$Label.c.MOE_Student_Division_AR"));
            component.set("v.clPreferredEndDate", $A.get("$Label.c.MOE_Preferred_End_Date_AR"));
            component.set("v.clPreferredStartDate", $A.get("$Label.c.MOE_Preferred_Start_Date_AR"));
            component.set("v.clBusSupervisorAvailable", $A.get("$Label.c.MOE_Bus_Supervisor_Available_AR"));
            component.set("v.clEscortforDisabledStudents", $A.get("$Label.c.MOE_Escort_for_Disabled_Students_AR"));
            component.set("v.clNoofDisabledStudents", $A.get("$Label.c.MOE_No_of_Disabled_Students_AR"));
            component.set("v.clTripCoordinator", $A.get("$Label.c.MOE_Trip_Coordinator_AR"));
            component.set("v.clTripLocationAr", $A.get("$Label.c.MOE_Trip_Location_Ar"));
            //Student Awareness 
            component.set("v.clNoofAttendance", $A.get("$Label.c.MOE_No_of_Attendance_AR"));
            component.set("v.clProgramType", $A.get("$Label.c.MOE_Program_Type_AR"));
            component.set("v.clCoordinator", $A.get("$Label.c.MOE_Coordinator_Number_AR"));
            //Details
            component.set("v.clSchoolCode", $A.get("$Label.c.School_Code_AR"));
            component.set("v.clSchoolArea", $A.get("$Label.c.School_Area_AR"));
            component.set("v.clSchoolCity", $A.get("$Label.c.School_City_AR"));
            
            
            
            
            component.set("v.clMyBusiness", $A.get("$Label.c.MOE_My_Business_AR"));
            component.set("v.clGeneralCases", $A.get("$Label.c.MOE_GeneralCases_AR"));
            component.set("v.clSpecialRequest", $A.get("$Label.c.MOE_Special_Request_AR"));
            component.set("v.clCustomerCare", $A.get("$Label.c.MOE_Customer_Care_AR"));
            component.set("v.clEscForm", $A.get("$Label.c.MOE_ESC_Form_Ar"));
            component.set("v.clEseDashboard", $A.get("$Label.c.MOE_ESE_Dashboard_Ar"));
            component.set("v.clAccidentVehicle", $A.get("$Label.c.MOE_Accident_Vehicle_Ar"));
            component.set("v.clCreateRequest", $A.get("$Label.c.MOE_Create_Request_AR")); 
            component.set("v.clAllSpecialRequests", $A.get("$Label.c.MOE_All_Special_Requests_AR")); 
            component.set("v.clAllRequests", $A.get("$Label.c.MOE_All_Requests_AR"));
            component.set("v.clDownload", $A.get("$Label.c.MOE_Download_AR"));
            component.set("v.clNew", $A.get("$Label.c.MOE_New_AR")); 
            component.set("v.clHome", $A.get("$Label.c.MOE_Home_AR")); 
            component.set("v.clExplore", $A.get("$Label.c.MOE_Explore_AR")); 
            component.set("v.clCreateCase", $A.get("$Label.c.MOE_CreateCase_AR")); 
            component.set("v.clInProgress", $A.get("$Label.c.MOE_InProgress_AR")); 
            component.set("v.clSelectType", $A.get("$Label.c.MOE_SelectType_AR"));
            component.set("v.clSelectAccount", $A.get("$Label.c.MOE_SelectAccount_AR"));
            component.set("v.clSelectStatus", $A.get("$Label.c.MOE_SelectStatus_AR"));
            component.set("v.clPendingApproval", $A.get("$Label.c.MOE_Pending_Approval_AR"));
            component.set("v.clRejected", $A.get("$Label.c.MOE_Rejected_AR")); 
            component.set("v.clApproved", $A.get("$Label.c.MOE_Approved_AR"));
            component.set("v.clClosed", $A.get("$Label.c.MOE_Closed_AR"));
            component.set("v.clAll", $A.get("$Label.c.MOE_All_AR"));
            component.set("v.clApprove", $A.get("$Label.c.MOE_Approve_AR")); 
            component.set("v.clReject", $A.get("$Label.c.MOE_Reject_AR"));
            component.set("v.clReply", $A.get("$Label.c.MOE_Reply_AR"));           
            component.set("v.clSearchCase", $A.get("$Label.c.MOE_Search_Case_AR"));           
            component.set("v.clSrNo", $A.get("$Label.c.MOE_Sr_No_AR"));
            component.set("v.clCaseNumber", $A.get("$Label.c.MOE_Case_Number_AR"));
            component.set("v.clType", $A.get("$Label.c.MOE_Type_AR"));
            component.set("v.clNextActivity", $A.get("$Label.c.MOE_Next_Activity_AR"));
            component.set("v.clSubject", $A.get("$Label.c.ESE_CASE_Subject_AR"));
            component.set("v.clRecentActivity", $A.get("$Label.c.MOE_Recent_Activity_AR"));
            
            component.set("v.clAssignedVehicles", $A.get("$Label.c.MOE_Assigned_Vehicles_AR"));
            
            component.set("v.clAction", $A.get("$Label.c.MOE_Action_AR"));
            component.set("v.clCaseApprovalProcess", $A.get("$Label.c.MOE_Case_Approval_Process_AR"));
            component.set("v.clSave", $A.get("$Label.c.MOE_Save_AR"));
            component.set("v.clDOyouwantto", $A.get("$Label.c.MOE_Do_you_want_to_AR"));
            component.set("v.clthecase", $A.get("$Label.c.MOE_the_case_AR"));
            component.set("v.clComments", $A.get("$Label.c.MOE_Comments_AR"));
            component.set("v.clCompletethisfield", $A.get("$Label.c.MOE_Complete_this_field_AR"));
            component.set("v.clHowcanwehelpyou", $A.get("$Label.c.MOE_How_can_we_help_you_AR"));
            component.set("v.clSelectRequestType", $A.get("$Label.c.MOE_Select_Request_Type_AR"));
            component.set("v.clNone", $A.get("$Label.c.MOE_None_AR"));
            component.set("v.clActivitiesEvents", $A.get("$Label.c.MOE_Activities_Events_AR"));
            component.set("v.clAwarenessSessionRequest", $A.get("$Label.c.MOE_Awareness_Session_Request_AR"));
            component.set("v.clGrowthRequestsforVehicleNannyandCoordinator", $A.get("$Label.c.MOE_Growth_Requests_for_Vehicle_Nanny_and_Coordinator_AR"));
            component.set("v.clHandicapServicesTransportationorNannyRequest", $A.get("$Label.c.MOE_Handicap_Services_Transportation_or_Nanny_Request_AR"));
            component.set("v.clTeachersTransportationRequest", $A.get("$Label.c.MOE_Teachers_Transportation_Request_AR"));
            
            
            component.set("v.clRequest", $A.get("$Label.c.MOE_Request_AR"));
            component.set("v.clDescriptionESECase", $A.get("$Label.c.ESE_Description_Case_AR"));
            
            
            
            
            component.set("v.clNoofVehicles", $A.get("$Label.c.MOE_No_of_Vehicles_AR"));
            component.set("v.clNoofAttendants", $A.get("$Label.c.MOE_No_of_Attendants_AR"));
            
            
            component.set("v.clSave", $A.get("$Label.c.MOE_Save_AR"));
            
            
            
            component.set("v.clGetLocation", $A.get("$Label.c.MOE_Get_Location_AR"));
            
            
            
            
            
            component.set("v.clNoofTeachers", $A.get("$Label.c.MOE_No_of_Teachers_AR"));
            
            
            component.set("v.clRequestType", $A.get("$Label.c.MOE_Request_Type_AR"));
            
            
            
            
            component.set("v.clParentPhone", $A.get("$Label.c.MOE_Parent_Phone_AR"));
            
            
            component.set("v.clAudience", $A.get("$Label.c.MOE_Audience_AR"));
            
            
            component.set("v.clSearchLocation", $A.get("$Label.c.MOE_Search_Location_AR"));
            component.set("v.clSearch", $A.get("$Label.c.MOE_Search_AR"));
            component.set("v.clClose", $A.get("$Label.c.MOE_Close_AR"));
            component.set("v.clSelectLocation", $A.get("$Label.c.MOE_Select_Location_AR"));
            component.set("v.clActive", $A.get("$Label.c.MOE_Active_AR"));
            component.set("v.clStudents", $A.get("$Label.c.MOE_Students_AR"));
            component.set("v.clStudentName", $A.get("$Label.c.MOE_Student_Name_AR"));
            
            component.set("v.clEmiratesId", $A.get("$Label.c.MOE_Emirates_Id_AR"));
            component.set("v.clName", $A.get("$Label.c.MOE_Name_AR"));
            component.set("v.clVehicleNumber", $A.get("$Label.c.MOE_Vehicle_Number_AR"));
            component.set("v.clVehicleDescription", $A.get("$Label.c.MOE_Vehicle_Description_AR"));
            component.set("v.clSalesAgreementName", $A.get("$Label.c.MOE_Sales_Agreement_Name_AR"));
            component.set("v.clAssignStartDate", $A.get("$Label.c.MOE_Assign_Start_Date_AR"));
            component.set("v.clAssignEndDate", $A.get("$Label.c.MOE_Assign_End_Date_AR"));
            component.set("v.clRaiseComplaint", $A.get("$Label.c.MOE_Raise_Complaint_AR"));
            component.set("v.clSkip", $A.get("$Label.c.MOE_Skip_AR"));
            component.set("v.clSchools", $A.get("$Label.c.MOE_Schools_AR"));
            component.set("v.clSalesAgreements", $A.get("$Label.c.MOE_Sales_Agreements_AR"));
            component.set("v.clInvoices", $A.get("$Label.c.MOE_Invoices_AR"));
            component.set("v.clInvoiceNumber", $A.get("$Label.c.MOE_Invoice_Number_AR"));
            component.set("v.clTotalInvoiceAmount", $A.get("$Label.c.MOE_Total_Invoice_Amount_AR"));
            component.set("v.clInvoiceDescription", $A.get("$Label.c.MOE_Invoice_Description_AR"));
            component.set("v.clStatus", $A.get("$Label.c.MOE_Status_AR"));
            component.set("v.clAccountName", $A.get("$Label.c.MOE_Account_Name_AR"));
            component.set("v.clContractStartDate", $A.get("$Label.c.MOE_Contract_Start_Date_AR"));
            component.set("v.clContractStartDate", $A.get("$Label.c.MOE_Contract_Start_Date_AR"));
            component.set("v.clAccountNumber", $A.get("$Label.c.MOE_Account_Number_AR"));
            component.set("v.clSchoolId", $A.get("$Label.c.MOE_School_Id_AR"));
            component.set("v.clComplete", $A.get("$Label.c.MOE_Complete_AR")); 
            component.set("v.clCancel", $A.get("$Label.c.MOE_Cancel_AR"));
            component.set("v.clCreatedDate", $A.get("$Label.c.MOE_Created_Date_AR"));
            component.set("v.clCreatedBy", $A.get("$Label.c.MOE_Created_By_AR"));
            component.set("v.clCaseOwner", $A.get("$Label.c.MOE_Case_Owner_AR"));
            
            component.set("v.clRequestaboardingpassforCompanionHandycamptransportation", $A.get("$Label.c.MOE_Request_a_boarding_pass_for_Companion_Handy_camp_transportation_AR"));
            
            
            component.set("v.clDelete", $A.get("$Label.c.MOE_Delete"));
            component.set("v.clDelete", $A.get("$Label.c.MOE_Delete_AR"));
            component.set("v.clHomeTotalRequest", $A.get("$Label.c.MOE_Home_Total_Requests_AR"));
            component.set("v.clHomeNew", $A.get("$Label.c.MOE_Home_New_AR"));
            component.set("v.clHomeOnHold", $A.get("$Label.c.MOE_Home_OnHold_AR"));
            component.set("v.clHomeApprovalPending", $A.get("$Label.c.MOE_Home_ApprovalPending_AR"));
            component.set("v.clHomeInProgress", $A.get("$Label.c.MOE_Home_InProgress_AR"));
            component.set("v.clHomeClosed", $A.get("$Label.c.MOE_Home_Closed_AR"));
            component.set("v.clOurServices", $A.get("$Label.c.MOE_Our_Services_AR"));
            component.set("v.clHomeStudentTransport", $A.get("$Label.c.MOE_Home_Student_Transport_AR"));
            component.set("v.clinspectionservices", $A.get("$Label.c.MOE_Home_Inspection_Services_AR"));
            component.set("v.cllogisticservices", $A.get("$Label.c.MOE_Home_Logistic_Service_AR"));
            component.set("v.clhomedashboard", $A.get("$Label.c.MOE_Home_Dashboard_AR"));
            component.set("v.clhomelimoservices", $A.get("$Label.c.MOE_Home_Limo_Services_AR"));
            component.set("v.clCancelled", $A.get("$Label.c.MOE_Canceled_AR"));
            component.set("v.clGoodAsNew", $A.get("$Label.c.ESE_As_Good_As_New"));
            component.set("v.clEmiratesMoto", $A.get("$Label.c.ESE_Emirates_Moto"));
            component.set("v.clEmiratesTransport", $A.get("$Label.c.ESE_Emirates_Transport"));
            component.set("v.clEtBoostsItsLogistics", $A.get("$Label.c.ESE_EtBoostsItsLogistics"));
            component.set("v.clEtCallCentreRecieved", $A.get("$Label.c.ESE_Et_Call_Centre_Recieved"));
            component.set("v.clEmiratesMotoServices", $A.get("$Label.c.ESE_Emirates_Moto_Services"));
            component.set("v.clEtPoweredBySmaartt", $A.get("$Label.c.ESE_Et_Powered_By_Smaartt"));
            
            
            component.set("v.clCancelRequest", $A.get("$Label.c.MOE_Cancel_Request_AR"));
            component.set("v.clNo", $A.get("$Label.c.MOE_Decision_No_AR"));
            component.set("v.clYes", $A.get("$Label.c.MOE_Decision_Yes_AR"));
            component.set("v.clGlobalEventRequest", $A.get("$Label.c.MOE_Global_Event_Request_AR"));
            component.set("v.clfilePreview", $A.get("$Label.c.MOE_File_Preview_AR"));
            component.set("v.faqVal", "FAQA");
            component.set("v.clCaseCustomerCare", $A.get("$Label.c.eseCaseNumberAR"));
            component.set("v.clCaseCustomerCareType", $A.get("$Label.c.eseCustomerCareCaseTypeAR"));
            component.set("v.clAwarenessSessionLocationAr", $A.get("$Label.c.MOE_Awareness_Session_LocationAr"));
            component.set("v.clFAQ", $A.get("$Label.c.FAQ_AR"));
            
            component.set("v.clSpecialNeedsActivityAndEventRequest", $A.get("$Label.c.MOE_Special_Needs_Activities_and_Events_Request_AR"));
            component.set("v.clSpecialNeedsTransportationRequest", $A.get("$Label.c.MOE_Special_Needs_Transportation_Request_AR"));
            component.set("v.clSpecialNeedsCompanionRequest", $A.get("$Label.c.MOE_Special_Needs_Companion_Request_AR"));
            component.set("v.clFleetGrowthRequest", $A.get("$Label.c.MOE_Fleet_Growth_Request_AR"));
            component.set("v.clESErejectionPageTitle", $A.get("$Label.c.Ese_Reject_Page_AR"));
             //downlode page section custom lable
            component.set("v.clPendingESE", $A.get("$Label.c.Pending_with_Inclusive_Education_Department_in_ESE"));
            component.set("v.clPendingHemam", $A.get("$Label.c.Pending_Hemam_for_Inclusive_Education_services"));
            component.set("v.clPendingMOE", $A.get("$Label.c.Pending_with_MOE_Personnel_Affairs"));
            component.set("v.clPendingSchoolActivities", $A.get("$Label.c.Pending_with_Department_Of_School_Activities"));
            component.set("v.clPendingSupervisors", $A.get("$Label.c.Pending_with_Operation_Supervisors"));
            component.set("v.clPendingManager", $A.get("$Label.c.Pending_with_Operation_Manager"));
             component.set("v.clPendingHeadofSafety", $A.get("$Label.c.Pending_with_Head_of_Safety_Unit_ar"));
            
            
        } else {
            console.log('english***');
            component.set('v.clLang', 'en');
            
            //Grouth Request For Request
            
            component.set("v.clSchoolName", $A.get("$Label.c.MOE_School_Name"));
            component.set("v.clCity", $A.get("$Label.c.MOE_City"));
            component.set("v.clNoofStudents", $A.get("$Label.c.MOE_No_of_Students"));
            component.set("v.clGender", $A.get("$Label.c.MOE_Gender"));
            component.set("v.clZoneType", $A.get("$Label.c.MOE_Zone_Type"));
            component.set("v.clCoordinatorName", $A.get("$Label.c.MOE_Coordinator_Name"));
            component.set("v.clPhone", $A.get("$Label.c.MOE_Phone"));
            component.set("v.clDescription", $A.get("$Label.c.ESE_Desprication_Case"));
            
            //Special Request Nanny Service
            component.set("v.clStudent", $A.get("$Label.c.MOE_Student"));
            component.set("v.clSISNumber", $A.get("$Label.c.MOE_SIS_Number"));
            component.set("v.clGrade", $A.get("$Label.c.MOE_Grade"));
            component.set("v.clParentName", $A.get("$Label.c.MOE_Parent_Name"));
            component.set("v.clTripDestination", $A.get("$Label.c.MOE_Trip_Destination"));
            component.set("v.cllandmark", $A.get("$Label.c.MOE_LAND_MARK"));
            component.set("v.clDisabilityType", $A.get("$Label.c.MOE_Disability_Type"));
            component.set("v.clMobilityAids", $A.get("$Label.c.MOE_Mobility_Aids"));
            component.set("v.clSubRequest", $A.get("$Label.c.MOE_Sub_Request"));
            component.set("v.clDelegatedPersonName", $A.get("$Label.c.MOE_Delegated_Person_Name"));
            component.set("v.clDelegatedPersonPhone", $A.get("$Label.c.MOE_Delegated_Person_Phone"));
            component.set("v.clAssignedResources", $A.get("$Label.c.MOE_Assigned_Resources"));
            component.set("v.clCCMRemarks", $A.get("$Label.c.MOE_CCM_Remarks"));
            component.set("v.clStudenthome", $A.get("$Label.c.MOE_Student_home"));
            component.set("v.clInternalNumberofStudent", $A.get("$Label.c.Internal_Number_of_Students_of_Bus_English"));
            //Companion Number
            component.set("v.clStudentId", $A.get("$Label.c.MOE_Student_Id"));
            component.set("v.clStudentCompanionName", $A.get("$Label.c.MOE_Student_Escort_Name"));
            component.set("v.clCompanionIDNumber", $A.get("$Label.c.MOE_Companion_ID_Number"));
            
            //Activity Event Request
            component.set("v.clTripType", $A.get("$Label.c.MOE_Trip_Type"));
            component.set("v.clMode", $A.get("$Label.c.MOE_Mode"));
            component.set("v.clNoofPassengers", $A.get("$Label.c.MOE_No_of_Passengers"));
            component.set("v.clStudentDivision", $A.get("$Label.c.MOE_Student_Division"));
            component.set("v.clPreferredEndDate", $A.get("$Label.c.MOE_Preferred_End_Date"));
            component.set("v.clPreferredStartDate", $A.get("$Label.c.MOE_Preferred_Start_Date"));
            component.set("v.clEscortforDisabledStudents", $A.get("$Label.c.MOE_Escort_for_Disabled_Students"));
            component.set("v.clNoofDisabledStudents", $A.get("$Label.c.MOE_No_of_Disabled_Students"));
            component.set("v.clBusSupervisorAvailable", $A.get("$Label.c.MOE_Bus_Supervisor_Available"));
            component.set("v.clTripCoordinator", $A.get("$Label.c.MOE_Trip_Coordinator"));
            component.set("v.clTripLocation", $A.get("$Label.c.MOE_Trip_Location"));
            //Student Awareness 
            component.set("v.clNoofAttendance", $A.get("$Label.c.MOE_No_of_Attendance"));
            component.set("v.clProgramType", $A.get("$Label.c.MOE_Program_Type"));
            component.set("v.clCoordinator", $A.get("$Label.c.MOE_Coordinator_Number"));
            //Details
            component.set("v.clSchoolCode", $A.get("$Label.c.ESE_School_Code"));
            component.set("v.clSchoolArea", $A.get("$Label.c.ESE_School_Area"));
            component.set("v.clSchoolCity", $A.get("$Label.c.ESE_School_City"));
            
            component.set("v.clMyBusiness", $A.get("$Label.c.MOE_My_Business"));
            component.set("v.clGeneralCases", $A.get("$Label.c.MOE_GeneralCases"));
            component.set("v.clSpecialRequest", $A.get("$Label.c.MOE_Special_Request"));
            component.set("v.clCustomerCare", $A.get("$Label.c.MOE_Customer_Care"));
            component.set("v.clEscForm", $A.get("$Label.c.MOE_ESC_Form"));
            component.set("v.clEseDashboard", $A.get("$Label.c.MOE_ESE_Dashboard"));
            component.set("v.clAccidentVehicle", $A.get("$Label.c.MOE_Accident_Vehicle"));
            component.set("v.clCreateRequest", $A.get("$Label.c.MOE_Create_Request")); 
            component.set("v.clAllSpecialRequests", $A.get("$Label.c.MOE_All_Special_Requests")); 
            component.set("v.clAllRequests", $A.get("$Label.c.MOE_All_Requests"));           
            component.set("v.clDownload", $A.get("$Label.c.MOE_Download"));
            component.set("v.clNew", $A.get("$Label.c.MOE_New"));
            
            component.set("v.clInProgress", $A.get("$Label.c.MOE_InProgress"));
            component.set("v.clCreateCase", $A.get("$Label.c.MOE_CreateCase"));
            component.set("v.clSelectType", $A.get("$Label.c.MOE_SelectType"));
            component.set("v.clSelectAccount", $A.get("$Label.c.MOE_SelectAccount"));
            component.set("v.clSelectStatus", $A.get("$Label.c.MOE_SelectStatus"));
            component.set("v.clHome", $A.get("$Label.c.MOE_Home"));
            component.set("v.clExplore", $A.get("$Label.c.MOE_Explore"));
            component.set("v.clPendingApproval", $A.get("$Label.c.MOE_Pending_Approval"));
            component.set("v.clRejected", $A.get("$Label.c.MOE_Rejected")); 
            component.set("v.clApproved", $A.get("$Label.c.MOE_Approved"));
            component.set("v.clClosed", $A.get("$Label.c.MOE_Closed"));  
            component.set("v.clAll", $A.get("$Label.c.MOE_All"));
            component.set("v.clApprove", $A.get("$Label.c.MOE_Approve")); 
            component.set("v.clReject", $A.get("$Label.c.MOE_Reject"));
            component.set("v.clReply", $A.get("$Label.c.MOE_Reply"));  
            component.set("v.clSearchCase", $A.get("$Label.c.MOE_Search_Case"));
            
            component.set("v.clCaseNumber", $A.get("$Label.c.MOE_Case_Number"));
            component.set("v.clType", $A.get("$Label.c.MOE_Type"));
            component.set("v.clNextActivity", $A.get("$Label.c.MOE_Next_Activity"));
            component.set("v.clSubject", $A.get("$Label.c.ESE_CASE_Subject"));
            component.set("v.clRecentActivity", $A.get("$Label.c.MOE_Recent_Activity"));
            
            component.set("v.clAssignedVehicles", $A.get("$Label.c.MOE_Assigned_Vehicles"));
            
            component.set("v.clAction", $A.get("$Label.c.MOE_Action"));
            component.set("v.clCaseApprovalProcess", $A.get("$Label.c.MOE_Case_Approval_Process"));
            component.set("v.clSave", $A.get("$Label.c.MOE_Save"));
            component.set("v.clDOyouwantto", $A.get("$Label.c.MOE_Do_you_want_to"));
            component.set("v.clthecase", $A.get("$Label.c.MOE_the_case"));
            component.set("v.clComments", $A.get("$Label.c.MOE_Comments"));
            component.set("v.clCompletethisfield", $A.get("$Label.c.MOE_Complete_this_field"));
            component.set("v.clHowcanwehelpyou", $A.get("$Label.c.MOE_How_can_we_help_you"));   
            component.set("v.clSelectRequestType", $A.get("$Label.c.MOE_Select_Request_Type"));
            component.set("v.clNone", $A.get("$Label.c.MOE_None"));
            component.set("v.clActivitiesEvents", $A.get("$Label.c.MOE_Activities_Events"));
            component.set("v.clAwarenessSessionRequest", $A.get("$Label.c.MOE_Awareness_Session_Request"));
            component.set("v.clGrowthRequestsforVehicleNannyandCoordinator", $A.get("$Label.c.MOE_Growth_Requests_for_Vehicle_Nanny_and_Coordinator"));
            component.set("v.clHandicapServicesTransportationorNannyRequest", $A.get("$Label.c.MOE_Handicap_Services_Transportation_or_Nanny_Request"));
            component.set("v.clTeachersTransportationRequest", $A.get("$Label.c.MOE_Teachers_Transportation_Request"));
            
            
            component.set("v.clRequest", $A.get("$Label.c.MOE_Request"));
            
            
            component.set("v.clCompanionIDNumber", $A.get("$Label.c.MOE_Companion_ID_Number"));
            
            
            component.set("v.clNoofVehicles", $A.get("$Label.c.MOE_No_of_Vehicles"));
            component.set("v.clNoofAttendants", $A.get("$Label.c.MOE_No_of_Attendants"));
            
            
            component.set("v.clSave", $A.get("$Label.c.MOE_Save"));
            
            
            
            component.set("v.clGetLocation", $A.get("$Label.c.MOE_Get_Location"));
            
            
            
            
            component.set("v.clNoofTeachers", $A.get("$Label.c.MOE_No_of_Teachers"));
            
            
            component.set("v.clRequestType", $A.get("$Label.c.MOE_Request_Type"));
            
            
            
            
            component.set("v.clParentPhone", $A.get("$Label.c.MOE_Parent_Phone"));
            
            
            component.set("v.clAudience", $A.get("$Label.c.MOE_Audience"));
            
            
            component.set("v.clSearchLocation", $A.get("$Label.c.MOE_Search_Location"));
            component.set("v.clSearch", $A.get("$Label.c.MOE_Search"));
            component.set("v.clClose", $A.get("$Label.c.MOE_Close"));
            component.set("v.clSelectLocation", $A.get("$Label.c.MOE_Select_Location"));
            component.set("v.clActive", $A.get("$Label.c.MOE_Active"));
            component.set("v.clStudents", $A.get("$Label.c.MOE_Students"));
            component.set("v.clStudentName", $A.get("$Label.c.MOE_Student_Name"));
            
            component.set("v.clEmiratesId", $A.get("$Label.c.MOE_Emirates_Id"));
            component.set("v.clName", $A.get("$Label.c.MOE_Name"));
            component.set("v.clVehicleNumber", $A.get("$Label.c.MOE_Vehicle_Number"));
            component.set("v.clVehicleDescription", $A.get("$Label.c.MOE_Vehicle_Description"));
            component.set("v.clSalesAgreementName", $A.get("$Label.c.MOE_Sales_Agreement_Name"));
            component.set("v.clAssignStartDate", $A.get("$Label.c.MOE_Assign_Start_Date"));
            component.set("v.clAssignEndDate", $A.get("$Label.c.MOE_Assign_End_Date"));
            component.set("v.clRaiseComplaint", $A.get("$Label.c.MOE_Raise_Complaint"));
            component.set("v.clSkip", $A.get("$Label.c.MOE_Skip"));
            component.set("v.clSchools", $A.get("$Label.c.MOE_Schools"));
            component.set("v.clSalesAgreements", $A.get("$Label.c.MOE_Sales_Agreements"));
            component.set("v.clInvoices", $A.get("$Label.c.MOE_Invoices"));
            component.set("v.clInvoiceNumber", $A.get("$Label.c.MOE_Invoice_Number"));
            component.set("v.clTotalInvoiceAmount", $A.get("$Label.c.MOE_Total_Invoice_Amount"));
            component.set("v.clInvoiceDescription", $A.get("$Label.c.MOE_Invoice_Description"));
            component.set("v.clStatus", $A.get("$Label.c.MOE_Status"));
            component.set("v.clAccountName", $A.get("$Label.c.MOE_Account_Name"));
            component.set("v.clContractStartDate", $A.get("$Label.c.MOE_Contract_Start_Date"));
            component.set("v.clContractStartDate", $A.get("$Label.c.MOE_Contract_Start_Date"));
            component.set("v.clAccountNumber", $A.get("$Label.c.MOE_Account_Number"));
            component.set("v.clSchoolId", $A.get("$Label.c.MOE_School_Id"));
            component.set("v.clComplete", $A.get("$Label.c.MOE_Complete")); 
            component.set("v.clCancel", $A.get("$Label.c.MOE_Cancel"));
            component.set("v.clCreatedDate", $A.get("$Label.c.MOE_Created_Date"));
            component.set("v.clCreatedBy", $A.get("$Label.c.MOE_Created_By"));
            component.set("v.clCaseOwner", $A.get("$Label.c.MOE_Case_Owner"));
            
            component.set("v.clRequestaboardingpassforCompanionHandycamptransportation", $A.get("$Label.c.MOE_Request_a_boarding_pass_for_Companion_Handy_camp_transportation"));
            
            
            component.set("v.clDelete", $A.get("$Label.c.MOE_Delete"));
            component.set("v.clHomeTotalRequest", $A.get("$Label.c.MOE_Home_Total_Requests"));
            component.set("v.clHomeNew", $A.get("$Label.c.MOE_Home_New"));
            component.set("v.clHomeOnHold", $A.get("$Label.c.MOE_Home_OnHold"));
            component.set("v.clHomeApprovalPending", $A.get("$Label.c.MOE_Home_ApprovalPending"));
            component.set("v.clHomeInProgress", $A.get("$Label.c.MOE_Home_InProgress"));
            component.set("v.clHomeClosed", $A.get("$Label.c.MOE_Home_Closed"));
            component.set("v.clOurServices", $A.get("$Label.c.MOE_Our_Services"));
            component.set("v.clHomeStudentTransport", $A.get("$Label.c.MOE_Home_Student_Transport"));
            component.set("v.clinspectionservices", $A.get("$Label.c.MOE_Home_Inspection_Services"));
            component.set("v.cllogisticservices", $A.get("$Label.c.MOE_Home_Logistic_Service"));
            component.set("v.clhomedashboard", $A.get("$Label.c.MOE_Home_Dashboard"));
            component.set("v.clhomelimoservices", $A.get("$Label.c.MOE_Home_Limo_Services"));
            component.set("v.clCancelRequest", $A.get("$Label.c.MOE_Cancel_Request"));
            component.set("v.clYes", $A.get("$Label.c.MOE_Decision_Yes"));
            component.set("v.clNo", $A.get("$Label.c.MOE_Decision_No"));
            component.set("v.clCancelled", $A.get("$Label.c.MOE_Canceled"));
            component.set("v.clGlobalEventRequest", $A.get("$Label.c.MOE_Global_Event_Request"));
            component.set("v.clfilePreview", $A.get("$Label.c.MOE_File_Preview"));
            //component.set("v.faqVal", "FAQ");
            component.set("v.clDescriptionESECase", $A.get("$Label.c.ESE_Description_Case"));
            component.set("v.clCaseCustomerCare", $A.get("$Label.c.eseCustomerCareNumber"));
            component.set("v.clCaseCustomerCareType", $A.get("$Label.c.eseCustomerCareCaseType"));
            component.set("v.clAwarenessSessionLocation", $A.get("$Label.c.MOE_Awareness_Session_Location"));
            component.set("v.clFAQ", $A.get("$Label.c.FAQ"));
            component.set("v.clSpecialNeedsActivityAndEventRequest", $A.get("$Label.c.MOE_Special_Needs_Activities_and_Events_Request"));
            component.set("v.clSpecialNeedsTransportationRequest", $A.get("$Label.c.MOE_Special_Needs_Transportation_Request"));
            component.set("v.clSpecialNeedsCompanionRequest", $A.get("$Label.c.MOE_Special_Needs_Companion_Request"));
            component.set("v.clFleetGrowthRequest", $A.get("$Label.c.MOE_Fleet_Growth_Request"));
            component.set("v.clSpecialDashboard", $A.get("$Label.c.Special_Request_Dashboard"));
            component.set("v.clESErejectionPageTitle", $A.get("$Label.c.Ese_Reject_Page_Title"));
            //downlode page section custom lable
            component.set("v.clPendingESE", $A.get("$Label.c.Pending_with_Inclusive_Education_Department_in_ESE_En"));
            component.set("v.clPendingHemam", $A.get("$Label.c.Pending_Hemam_for_Inclusive_Education_services_En"));
            component.set("v.clPendingMOE", $A.get("$Label.c.Pending_with_MOE_Personnel_Affairs_En"));
            component.set("v.clPendingSchoolActivities", $A.get("$Label.c.Pending_with_Department_Of_School_Activities_En"));
            component.set("v.clPendingSupervisors", $A.get("$Label.c.Pending_with_Operation_Supervisors_En"));
            component.set("v.clPendingManager", $A.get("$Label.c.Pending_with_Operation_Manager_En")); 
            component.set("v.clPendingHeadofSafety", $A.get("$Label.c.Pending_with_Head_of_Safety_Unit"));
            
            
            
            
        }
    }
})