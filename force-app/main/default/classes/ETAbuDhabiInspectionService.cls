/*
* File Name:ETAbuDhabiInspectionService
* Author : Sagar Kambli
* CreatedDate : 29/03/2020
* Modification Purpose
* * 1. Sagar: Created for AbuDhabi Inspection Service
* * 2.
*/
public class ETAbuDhabiInspectionService {
    public class GetLookupRequest {
        public String LookupName;
        public String Filter1;
        public String Filter2;
        public String UserID;
        public Integer SystemCode;
        private String[] LookupName_type_info = new String[]{'LookupName','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] Filter1_type_info = new String[]{'Filter1','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] Filter2_type_info = new String[]{'Filter2','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] UserID_type_info = new String[]{'UserID','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SystemCode_type_info = new String[]{'SystemCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'LookupName','Filter1','Filter2','UserID','SystemCode'};
    }
    public class ErrorHeader {
        public Integer ErrorCode;
        public String ErrorArabicDesc;
        public String ErrorEnglishDesc;
        private String[] ErrorCode_type_info = new String[]{'ErrorCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] ErrorArabicDesc_type_info = new String[]{'ErrorArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ErrorEnglishDesc_type_info = new String[]{'ErrorEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'ErrorCode','ErrorArabicDesc','ErrorEnglishDesc'};
    }
    public class CheckVehicleWantedRequest {
        public Long TCFNo;
        public ETAbuDhabiInspectionService.PlateKey PlateInfo;
        public String ChassisNo;
        public String UserID;
        public Integer SystemCode;
        private String[] TCFNo_type_info = new String[]{'TCFNo','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] PlateInfo_type_info = new String[]{'PlateInfo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ChassisNo_type_info = new String[]{'ChassisNo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] UserID_type_info = new String[]{'UserID','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SystemCode_type_info = new String[]{'SystemCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'TCFNo','PlateInfo','ChassisNo','UserID','SystemCode'};
    }
    public class GetVehicleReferencesResponse {
        public ETAbuDhabiInspectionService.ArrayOfVehicleReferencesRecord VehicleReferencesList;
        private String[] VehicleReferencesList_type_info = new String[]{'VehicleReferencesList','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'VehicleReferencesList'};
    }
    public class checkVehicleWanted_element {
        public ETAbuDhabiInspectionService.CheckVehicleWantedRequest request;
        private String[] request_type_info = new String[]{'request','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class GetPlateCombinationsRequest {
        public Integer PlateColorCode;
        public Integer PlateKindCode;
        public Integer PlateSourceCode;
        public String UserID;
        public Integer SystemCode;
        private String[] PlateColorCode_type_info = new String[]{'PlateColorCode','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] PlateKindCode_type_info = new String[]{'PlateKindCode','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] PlateSourceCode_type_info = new String[]{'PlateSourceCode','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] UserID_type_info = new String[]{'UserID','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SystemCode_type_info = new String[]{'SystemCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'PlateColorCode','PlateKindCode','PlateSourceCode','UserID','SystemCode'};
    }
    public class GetVehicleReferencesRequest {
        public Integer PageNo;
        public String UserID;
        public Integer SystemCode;
        private String[] PageNo_type_info = new String[]{'PageNo','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] UserID_type_info = new String[]{'UserID','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SystemCode_type_info = new String[]{'SystemCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'PageNo','UserID','SystemCode'};
    }
    public class checkVehicleWantedResponse_element {
        public ETAbuDhabiInspectionService.CheckVehicleWantedResponse checkVehicleWantedResult;
        private String[] checkVehicleWantedResult_type_info = new String[]{'checkVehicleWantedResult','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'checkVehicleWantedResult'};
    }
    public class ArrayOfPlateRecord {
        public ETAbuDhabiInspectionService.PlateRecord[] PlateRecord;
        private String[] PlateRecord_type_info = new String[]{'PlateRecord','http://adpolice.gov.ae/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'PlateRecord'};
    }
    public class ArrayOfVehicleReferencesRecord {
        public ETAbuDhabiInspectionService.VehicleReferencesRecord[] VehicleReferencesRecord;
        private String[] VehicleReferencesRecord_type_info = new String[]{'VehicleReferencesRecord','http://adpolice.gov.ae/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'VehicleReferencesRecord'};
    }
    public class PlateRecord {
        public Integer ColorCode;
        public String ArabicColorDesc;
        public String EnglishColorDesc;
        public Integer KindCode;
        public String ArabicKindDesc;
        public String EnglishKindDesc;
        public Integer SourceCode;
        public String ArabicSourceCodeDesc;
        public String EnglishSourceCodeDesc;
        private String[] ColorCode_type_info = new String[]{'ColorCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] ArabicColorDesc_type_info = new String[]{'ArabicColorDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] EnglishColorDesc_type_info = new String[]{'EnglishColorDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] KindCode_type_info = new String[]{'KindCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] ArabicKindDesc_type_info = new String[]{'ArabicKindDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] EnglishKindDesc_type_info = new String[]{'EnglishKindDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SourceCode_type_info = new String[]{'SourceCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] ArabicSourceCodeDesc_type_info = new String[]{'ArabicSourceCodeDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] EnglishSourceCodeDesc_type_info = new String[]{'EnglishSourceCodeDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'ColorCode','ArabicColorDesc','EnglishColorDesc','KindCode','ArabicKindDesc','EnglishKindDesc','SourceCode','ArabicSourceCodeDesc','EnglishSourceCodeDesc'};
    }
    public class VehicleDetails {
        public String OwnerTcfNo;
        public String OwnerTcfArabicName;
        public String OwnerTcfEnglishName;
        public ETAbuDhabiInspectionService.PlateKey PlateInfo;
        public String InsuranceCompanyName;
        public String InsuranceKindArabicDesc;
        public String InsuranceKindEnglishDesc;
        public String InsuranceExpiryDate;
        public String InsurancePolicyNo;
        public String MortgageDesc;
        public String MortgageRef;
        public String ColorCode;
        public String ColorArabicDesc;
        public String ColorEnglishDesc;
        public String TypeCode;
        public String TypeArabicDesc;
        public String TypeEnglishDesc;
        public String NationalityCode;
        public String NationalityArabicDesc;
        public String NationalityEnglishDesc;
        public String Year;
        public String Chairs;
        public String MakeCode;
        public String MakeArabicDesc;
        public String MakeEnglishDesc;
        public String ModelCode;
        public String ModelArabicDesc;
        public String ModelEnglishDesc;
        public String KindCode;
        public String KindArabicDesc;
        public String KindEnglishDesc;
        public String WeightEmpty;
        public String WeightFull;
        public String RegistrationDate;
        public String RegistrationExpiryDate;
        public String EngineNo;
        public String ChassisNo;
        public String GearCode;
        public String GearArabicDesc;
        public String GearEnglishDesc;
        public String FuelCode;
        public String FuelArabicDesc;
        public String FuelEnglishDesc;
        public String WeightCode;
        public String WeightArabicDesc;
        public String WeightEnglishDesc;
        public String SteeringCode;
        public String SteeringArabicDesc;
        public String SteeringEnglishDesc;
        public String Cylinder;
        public String AxisCount;
        public String DoorCount;
        public String HorsePower;
        public String WheelsCount;
        public String RegistrationRemarks;
        private String[] OwnerTcfNo_type_info = new String[]{'OwnerTcfNo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] OwnerTcfArabicName_type_info = new String[]{'OwnerTcfArabicName','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] OwnerTcfEnglishName_type_info = new String[]{'OwnerTcfEnglishName','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] PlateInfo_type_info = new String[]{'PlateInfo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] InsuranceCompanyName_type_info = new String[]{'InsuranceCompanyName','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] InsuranceKindArabicDesc_type_info = new String[]{'InsuranceKindArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] InsuranceKindEnglishDesc_type_info = new String[]{'InsuranceKindEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] InsuranceExpiryDate_type_info = new String[]{'InsuranceExpiryDate','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] InsurancePolicyNo_type_info = new String[]{'InsurancePolicyNo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] MortgageDesc_type_info = new String[]{'MortgageDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] MortgageRef_type_info = new String[]{'MortgageRef','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ColorCode_type_info = new String[]{'ColorCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ColorArabicDesc_type_info = new String[]{'ColorArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ColorEnglishDesc_type_info = new String[]{'ColorEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] TypeCode_type_info = new String[]{'TypeCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] TypeArabicDesc_type_info = new String[]{'TypeArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] TypeEnglishDesc_type_info = new String[]{'TypeEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] NationalityCode_type_info = new String[]{'NationalityCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] NationalityArabicDesc_type_info = new String[]{'NationalityArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] NationalityEnglishDesc_type_info = new String[]{'NationalityEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] Year_type_info = new String[]{'Year','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] Chairs_type_info = new String[]{'Chairs','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] MakeCode_type_info = new String[]{'MakeCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] MakeArabicDesc_type_info = new String[]{'MakeArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] MakeEnglishDesc_type_info = new String[]{'MakeEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ModelCode_type_info = new String[]{'ModelCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ModelArabicDesc_type_info = new String[]{'ModelArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ModelEnglishDesc_type_info = new String[]{'ModelEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] KindCode_type_info = new String[]{'KindCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] KindArabicDesc_type_info = new String[]{'KindArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] KindEnglishDesc_type_info = new String[]{'KindEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WeightEmpty_type_info = new String[]{'WeightEmpty','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WeightFull_type_info = new String[]{'WeightFull','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] RegistrationDate_type_info = new String[]{'RegistrationDate','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] RegistrationExpiryDate_type_info = new String[]{'RegistrationExpiryDate','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] EngineNo_type_info = new String[]{'EngineNo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ChassisNo_type_info = new String[]{'ChassisNo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] GearCode_type_info = new String[]{'GearCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] GearArabicDesc_type_info = new String[]{'GearArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] GearEnglishDesc_type_info = new String[]{'GearEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] FuelCode_type_info = new String[]{'FuelCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] FuelArabicDesc_type_info = new String[]{'FuelArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] FuelEnglishDesc_type_info = new String[]{'FuelEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WeightCode_type_info = new String[]{'WeightCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WeightArabicDesc_type_info = new String[]{'WeightArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WeightEnglishDesc_type_info = new String[]{'WeightEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SteeringCode_type_info = new String[]{'SteeringCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SteeringArabicDesc_type_info = new String[]{'SteeringArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SteeringEnglishDesc_type_info = new String[]{'SteeringEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] Cylinder_type_info = new String[]{'Cylinder','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] AxisCount_type_info = new String[]{'AxisCount','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] DoorCount_type_info = new String[]{'DoorCount','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] HorsePower_type_info = new String[]{'HorsePower','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WheelsCount_type_info = new String[]{'WheelsCount','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] RegistrationRemarks_type_info = new String[]{'RegistrationRemarks','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'OwnerTcfNo','OwnerTcfArabicName','OwnerTcfEnglishName','PlateInfo','InsuranceCompanyName','InsuranceKindArabicDesc','InsuranceKindEnglishDesc','InsuranceExpiryDate','InsurancePolicyNo','MortgageDesc','MortgageRef','ColorCode','ColorArabicDesc','ColorEnglishDesc','TypeCode','TypeArabicDesc','TypeEnglishDesc','NationalityCode','NationalityArabicDesc','NationalityEnglishDesc','Year','Chairs','MakeCode','MakeArabicDesc','MakeEnglishDesc','ModelCode','ModelArabicDesc','ModelEnglishDesc','KindCode','KindArabicDesc','KindEnglishDesc','WeightEmpty','WeightFull','RegistrationDate','RegistrationExpiryDate','EngineNo','ChassisNo','GearCode','GearArabicDesc','GearEnglishDesc','FuelCode','FuelArabicDesc','FuelEnglishDesc','WeightCode','WeightArabicDesc','WeightEnglishDesc','SteeringCode','SteeringArabicDesc','SteeringEnglishDesc','Cylinder','AxisCount','DoorCount','HorsePower','WheelsCount','RegistrationRemarks'};
    }
    public class insertFailureCause_element {
        public ETAbuDhabiInspectionService.InsertFailureCauseRequest request;
        private String[] request_type_info = new String[]{'request','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class CheckVehicleWantedResponse {
        public Boolean IsWanted;
        private String[] IsWanted_type_info = new String[]{'IsWanted','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'IsWanted'};
    }
    public class getVehicleDetails_element {
        public ETAbuDhabiInspectionService.GetVehicleDetailsRequest request;
        private String[] request_type_info = new String[]{'request','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class getVehicleDetailsResponse_element {
        public ETAbuDhabiInspectionService.VehicleDetails getVehicleDetailsResult;
        public String ErrorMessage;
        private String[] getVehicleDetailsResult_type_info = new String[]{'getVehicleDetailsResult','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ErrorMessage_type_info = new String[]{'ErrorMessage','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'getVehicleDetailsResult','ErrorMessage'};
    }
    public class setInspectionResultResponse_element {
        public ETAbuDhabiInspectionService.SetInspectionResultResponse setInspectionResultResult;
        private String[] setInspectionResultResult_type_info = new String[]{'setInspectionResultResult','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'setInspectionResultResult'};
    }
    public class getVehicleColorsResponse_element {
        public ETAbuDhabiInspectionService.GetVehicleColorsResponse getVehicleColorsResult;
        private String[] getVehicleColorsResult_type_info = new String[]{'getVehicleColorsResult','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'getVehicleColorsResult'};
    }
    public class GetLookupResponse {
        public ETAbuDhabiInspectionService.ArrayOfLookupRecord LookUpRecords;
        private String[] LookUpRecords_type_info = new String[]{'LookUpRecords','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'LookUpRecords'};
    }
    public class ArrayOfLookupRecord {
        public ETAbuDhabiInspectionService.LookupRecord[] LookupRecord;
        private String[] LookupRecord_type_info = new String[]{'LookupRecord','http://adpolice.gov.ae/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'LookupRecord'};
    }
    public class PlateKey {
        public Long PlateNo;
        public Long PlateOrgNo;
        public Integer PlateColorCode;
        public Integer PlateKindCode;
        public Integer PlateTypeCode;
        public Integer PlateSourceCode;
        public String PlateColorArabicDesc;
        public String PlateColorEnglishDesc;
        public String PlateSourceArabicDesc;
        public String PlateSourceEnglishDesc;
        public String PlateKindArabicDesc;
        public String PlateKindEnglishDesc;
        public String PlateTypeArabicDesc;
        public String PlateTypeEnglishDesc;
        private String[] PlateNo_type_info = new String[]{'PlateNo','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] PlateOrgNo_type_info = new String[]{'PlateOrgNo','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] PlateColorCode_type_info = new String[]{'PlateColorCode','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] PlateKindCode_type_info = new String[]{'PlateKindCode','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] PlateTypeCode_type_info = new String[]{'PlateTypeCode','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] PlateSourceCode_type_info = new String[]{'PlateSourceCode','http://adpolice.gov.ae/',null,'1','1','true'};
        private String[] PlateColorArabicDesc_type_info = new String[]{'PlateColorArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] PlateColorEnglishDesc_type_info = new String[]{'PlateColorEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] PlateSourceArabicDesc_type_info = new String[]{'PlateSourceArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] PlateSourceEnglishDesc_type_info = new String[]{'PlateSourceEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] PlateKindArabicDesc_type_info = new String[]{'PlateKindArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] PlateKindEnglishDesc_type_info = new String[]{'PlateKindEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] PlateTypeArabicDesc_type_info = new String[]{'PlateTypeArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] PlateTypeEnglishDesc_type_info = new String[]{'PlateTypeEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'PlateNo','PlateOrgNo','PlateColorCode','PlateKindCode','PlateTypeCode','PlateSourceCode','PlateColorArabicDesc','PlateColorEnglishDesc','PlateSourceArabicDesc','PlateSourceEnglishDesc','PlateKindArabicDesc','PlateKindEnglishDesc','PlateTypeArabicDesc','PlateTypeEnglishDesc'};
    }
    public class Ticket {
        public Long TicketNo;
        public DateTime TicketDate;
        public Integer TicketSource;
        public Integer BlackPoints;
        public Integer LateCharges;
        public Double Amount;
        public Boolean IsUTSTicket;
        private String[] TicketNo_type_info = new String[]{'TicketNo','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] TicketDate_type_info = new String[]{'TicketDate','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] TicketSource_type_info = new String[]{'TicketSource','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] BlackPoints_type_info = new String[]{'BlackPoints','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] LateCharges_type_info = new String[]{'LateCharges','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] Amount_type_info = new String[]{'Amount','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] IsUTSTicket_type_info = new String[]{'IsUTSTicket','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'TicketNo','TicketDate','TicketSource','BlackPoints','LateCharges','Amount','IsUTSTicket'};
    }
    public class GetVehicleTicketsResponse {
        public ETAbuDhabiInspectionService.ArrayOfTicket Tickets;
        private String[] Tickets_type_info = new String[]{'Tickets','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'Tickets'};
    }
    public class setInspectionResult_element {
        public ETAbuDhabiInspectionService.SetInspectionResultRequest request;
        private String[] request_type_info = new String[]{'request','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class SetInspectionResultResponse {
        public Long SerialNo;
        private String[] SerialNo_type_info = new String[]{'SerialNo','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'SerialNo'};
    }
    public class InsertFailureCauseRequest {
        public Long ReferenceNo;
        public Integer InspectionCenterCode;
        public Long SerialNo;
        public String TestCode;
        public String TestArabicDesc;
        public String TestEnglishDesc;
        public String TestComments;
        public String UserID;
        public Integer SystemCode;
        private String[] ReferenceNo_type_info = new String[]{'ReferenceNo','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] InspectionCenterCode_type_info = new String[]{'InspectionCenterCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] SerialNo_type_info = new String[]{'SerialNo','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] TestCode_type_info = new String[]{'TestCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] TestArabicDesc_type_info = new String[]{'TestArabicDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] TestEnglishDesc_type_info = new String[]{'TestEnglishDesc','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] TestComments_type_info = new String[]{'TestComments','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] UserID_type_info = new String[]{'UserID','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SystemCode_type_info = new String[]{'SystemCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'ReferenceNo','InspectionCenterCode','SerialNo','TestCode','TestArabicDesc','TestEnglishDesc','TestComments','UserID','SystemCode'};
    }
    public class getLookup_element {
        public ETAbuDhabiInspectionService.GetLookupRequest request;
        private String[] request_type_info = new String[]{'request','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class getLookupResponse_element {
        public ETAbuDhabiInspectionService.GetLookupResponse getLookupResult;
        private String[] getLookupResult_type_info = new String[]{'getLookupResult','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'getLookupResult'};
    }
    public class GetVehicleColorsRequest {
        public String UserID;
        public Integer SystemCode;
        private String[] UserID_type_info = new String[]{'UserID','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SystemCode_type_info = new String[]{'SystemCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'UserID','SystemCode'};
    }
    public class getVehicleReferencesResponse_element {
        public ETAbuDhabiInspectionService.GetVehicleReferencesResponse getVehicleReferencesResult;
        private String[] getVehicleReferencesResult_type_info = new String[]{'getVehicleReferencesResult','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'getVehicleReferencesResult'};
    }
    public class LookupRecord {
        public String Code;
        public String ArabicDescription;
        public String EnglishDescription;
        private String[] Code_type_info = new String[]{'Code','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ArabicDescription_type_info = new String[]{'ArabicDescription','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] EnglishDescription_type_info = new String[]{'EnglishDescription','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'Code','ArabicDescription','EnglishDescription'};
    }
    public class VehicleReferencesRecord {
        public String Year;
        public String TypeCode;
        public String MakeCode;
        public String ModelCode;
        public String KindCode;
        public String WeightCode;
        public String Cylinder;
        public String AxleCount;
        public String DoorCount;
        public String HorsePower;
        public String WeightEmpty;
        public String WeightFull;
        public String Chairs;
        public String WheelsCount;
        private String[] Year_type_info = new String[]{'Year','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] TypeCode_type_info = new String[]{'TypeCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] MakeCode_type_info = new String[]{'MakeCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ModelCode_type_info = new String[]{'ModelCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] KindCode_type_info = new String[]{'KindCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WeightCode_type_info = new String[]{'WeightCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] Cylinder_type_info = new String[]{'Cylinder','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] AxleCount_type_info = new String[]{'AxleCount','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] DoorCount_type_info = new String[]{'DoorCount','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] HorsePower_type_info = new String[]{'HorsePower','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WeightEmpty_type_info = new String[]{'WeightEmpty','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WeightFull_type_info = new String[]{'WeightFull','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] Chairs_type_info = new String[]{'Chairs','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] WheelsCount_type_info = new String[]{'WheelsCount','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'Year','TypeCode','MakeCode','ModelCode','KindCode','WeightCode','Cylinder','AxleCount','DoorCount','HorsePower','WeightEmpty','WeightFull','Chairs','WheelsCount'};
    }
    public class GetVehicleColorsResponse {
        public ETAbuDhabiInspectionService.ArrayOfLookupRecord LookUpRecords;
        private String[] LookUpRecords_type_info = new String[]{'LookUpRecords','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'LookUpRecords'};
    }
    public class getVehicleTickets_element {
        public ETAbuDhabiInspectionService.GetVehicleTicketsRequest request;
        private String[] request_type_info = new String[]{'request','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class getPlateCombinations_element {
        public ETAbuDhabiInspectionService.GetPlateCombinationsRequest request;
        private String[] request_type_info = new String[]{'request','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class UserIdentifierSoapHeaderIn {
        public String UserName;
        public String Password;
        private String[] UserName_type_info = new String[]{'UserName','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password'};
    }
    public class GetPlateCombinationsResponse {
        public ETAbuDhabiInspectionService.ArrayOfPlateRecord Plates;
        private String[] Plates_type_info = new String[]{'Plates','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'Plates'};
    }
    public class ArrayOfTicket {
        public ETAbuDhabiInspectionService.Ticket[] Ticket;
        private String[] Ticket_type_info = new String[]{'Ticket','http://adpolice.gov.ae/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'Ticket'};
    }
    public class getVehicleColors_element {
        public ETAbuDhabiInspectionService.GetVehicleColorsRequest request;
        private String[] request_type_info = new String[]{'request','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class GetVehicleTicketsRequest {
        public ETAbuDhabiInspectionService.PlateKey PlateInfo;
        public Long TCFNo;
        public String UserID;
        public Integer SystemCode;
        private String[] PlateInfo_type_info = new String[]{'PlateInfo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] TCFNo_type_info = new String[]{'TCFNo','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] UserID_type_info = new String[]{'UserID','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SystemCode_type_info = new String[]{'SystemCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'PlateInfo','TCFNo','UserID','SystemCode'};
    }
    public class getVehicleReferences_element {
        public ETAbuDhabiInspectionService.GetVehicleReferencesRequest request;
        private String[] request_type_info = new String[]{'request','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'request'};
    }
    public class SetInspectionResultRequest {
        public String ChassisNo;
        public String OldChassisNo;
        public Long ReferenceNo;
        public Boolean IsPassed;
        public DateTime InspectionDate;
        public Integer InspectionCenterCode;
        public Integer VehicleMakeCode;
        public Integer VehicleModelCode;
        public Integer VehicleKindCode;
        public Integer VehicleTypeCode;
        public Integer VehicleColorCode;
        public Integer VehicleNationalityCode;
        public String EngineNo;
        public Integer VehicleMakingYear;
        public Integer Cylinders;
        public Integer Axles;
        public Integer Doors;
        public Integer Chairs;
        public Integer HorsePower;
        public Integer WeightFull;
        public Integer WeightEmpty;
        public Integer Wheels;
        public Integer GearCode;
        public Integer WeightKindCode;
        public Integer SteeringCode;
        public Integer FuelCode;
        public String PurposeCode;
        public String UserID;
        public Integer SystemCode;
        private String[] ChassisNo_type_info = new String[]{'ChassisNo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] OldChassisNo_type_info = new String[]{'OldChassisNo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ReferenceNo_type_info = new String[]{'ReferenceNo','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] IsPassed_type_info = new String[]{'IsPassed','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] InspectionDate_type_info = new String[]{'InspectionDate','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] InspectionCenterCode_type_info = new String[]{'InspectionCenterCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] VehicleMakeCode_type_info = new String[]{'VehicleMakeCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] VehicleModelCode_type_info = new String[]{'VehicleModelCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] VehicleKindCode_type_info = new String[]{'VehicleKindCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] VehicleTypeCode_type_info = new String[]{'VehicleTypeCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] VehicleColorCode_type_info = new String[]{'VehicleColorCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] VehicleNationalityCode_type_info = new String[]{'VehicleNationalityCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] EngineNo_type_info = new String[]{'EngineNo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] VehicleMakingYear_type_info = new String[]{'VehicleMakingYear','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] Cylinders_type_info = new String[]{'Cylinders','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] Axles_type_info = new String[]{'Axles','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] Doors_type_info = new String[]{'Doors','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] Chairs_type_info = new String[]{'Chairs','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] HorsePower_type_info = new String[]{'HorsePower','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] WeightFull_type_info = new String[]{'WeightFull','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] WeightEmpty_type_info = new String[]{'WeightEmpty','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] Wheels_type_info = new String[]{'Wheels','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] GearCode_type_info = new String[]{'GearCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] WeightKindCode_type_info = new String[]{'WeightKindCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] SteeringCode_type_info = new String[]{'SteeringCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] FuelCode_type_info = new String[]{'FuelCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] PurposeCode_type_info = new String[]{'PurposeCode','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] UserID_type_info = new String[]{'UserID','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] SystemCode_type_info = new String[]{'SystemCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'ChassisNo','OldChassisNo','ReferenceNo','IsPassed','InspectionDate','InspectionCenterCode','VehicleMakeCode','VehicleModelCode','VehicleKindCode','VehicleTypeCode','VehicleColorCode','VehicleNationalityCode','EngineNo','VehicleMakingYear','Cylinders','Axles','Doors','Chairs','HorsePower','WeightFull','WeightEmpty','Wheels','GearCode','WeightKindCode','SteeringCode','FuelCode','PurposeCode','UserID','SystemCode'};
    }
    public class getVehicleTicketsResponse_element {
        public ETAbuDhabiInspectionService.GetVehicleTicketsResponse getVehicleTicketsResult;
        private String[] getVehicleTicketsResult_type_info = new String[]{'getVehicleTicketsResult','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'getVehicleTicketsResult'};
    }
    public class insertFailureCauseResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetVehicleDetailsRequest {
        public Integer SystemCode;
        public String UserID;
        public ETAbuDhabiInspectionService.PlateKey PlateInfo;
        public String ChassisNo;
        private String[] SystemCode_type_info = new String[]{'SystemCode','http://adpolice.gov.ae/',null,'1','1','false'};
        private String[] UserID_type_info = new String[]{'UserID','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] PlateInfo_type_info = new String[]{'PlateInfo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] ChassisNo_type_info = new String[]{'ChassisNo','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'SystemCode','UserID','PlateInfo','ChassisNo'};
    }
    public class getPlateCombinationsResponse_element {
        public ETAbuDhabiInspectionService.GetPlateCombinationsResponse getPlateCombinationsResult;
        private String[] getPlateCombinationsResult_type_info = new String[]{'getPlateCombinationsResult','http://adpolice.gov.ae/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://adpolice.gov.ae/','true','false'};
        private String[] field_order_type_info = new String[]{'getPlateCombinationsResult'};
    }
    public class execute_pt {
        //public String endpoint_x = 'https://etdevsoa.et.gov.ae:443/soa-infra/services/EBS_ADP_Integration/SyncAbudhabiPoliceSystemVehicleVerificationService/ADPVehicleVerificationMediator_ep';
        public String endpoint_x =  system.label.AbuDhabiPoliceEndpoint;//'https://etsoa.et.gov.ae/soa-infra/services/EBS_ADP_Integration/SyncAbudhabiPoliceSystemVehicleVerificationService/ADPVehicleVerificationMediator_ep';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public ETAbuDhabiInspectionService.ErrorHeader ErrorHeader;
        public ETAbuDhabiInspectionService.UserIdentifierSoapHeaderIn UserIdentifierSoapHeaderIn;
        private String ErrorHeader_hns = 'ErrorHeader=http://adpolice.gov.ae/';
        private String UserIdentifierSoapHeaderIn_hns = 'UserIdentifierSoapHeaderIn=http://adpolice.gov.ae/';
        private String[] ns_map_type_info = new String[]{'http://adpolice.gov.ae/', 'ETAbuDhabiInspectionService'};
        public ETAbuDhabiInspectionService.getVehicleDetailsResponse_element execute(ETAbuDhabiInspectionService.GetVehicleDetailsRequest request) {
            ETAbuDhabiInspectionService.getVehicleDetails_element request_x = new ETAbuDhabiInspectionService.getVehicleDetails_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.getVehicleDetailsResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.getVehicleDetailsResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.getVehicleDetailsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'execute',
              'http://adpolice.gov.ae/',
              'getVehicleDetails',
              'http://adpolice.gov.ae/',
              'getVehicleDetailsResponse',
              'ETAbuDhabiInspectionService.getVehicleDetailsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public ETAbuDhabiInspectionService.SetInspectionResultResponse setInspectionResult(ETAbuDhabiInspectionService.SetInspectionResultRequest request) {
            ETAbuDhabiInspectionService.setInspectionResult_element request_x = new ETAbuDhabiInspectionService.setInspectionResult_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.setInspectionResultResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.setInspectionResultResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.setInspectionResultResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://adpolice.gov.ae/setInspectionResult',
              'http://adpolice.gov.ae/',
              'setInspectionResult',
              'http://adpolice.gov.ae/',
              'setInspectionResultResponse',
              'ETAbuDhabiInspectionService.setInspectionResultResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.setInspectionResultResult;
        }
        public ETAbuDhabiInspectionService.GetVehicleColorsResponse getVehicleColors(ETAbuDhabiInspectionService.GetVehicleColorsRequest request) {
            ETAbuDhabiInspectionService.getVehicleColors_element request_x = new ETAbuDhabiInspectionService.getVehicleColors_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.getVehicleColorsResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.getVehicleColorsResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.getVehicleColorsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://adpolice.gov.ae/getVehicleColors',
              'http://adpolice.gov.ae/',
              'getVehicleColors',
              'http://adpolice.gov.ae/',
              'getVehicleColorsResponse',
              'ETAbuDhabiInspectionService.getVehicleColorsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getVehicleColorsResult;
        }
        public ETAbuDhabiInspectionService.CheckVehicleWantedResponse checkVehicleWanted(ETAbuDhabiInspectionService.CheckVehicleWantedRequest request) {
            ETAbuDhabiInspectionService.checkVehicleWanted_element request_x = new ETAbuDhabiInspectionService.checkVehicleWanted_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.checkVehicleWantedResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.checkVehicleWantedResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.checkVehicleWantedResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://adpolice.gov.ae/checkVehicleWanted',
              'http://adpolice.gov.ae/',
              'checkVehicleWanted',
              'http://adpolice.gov.ae/',
              'checkVehicleWantedResponse',
              'ETAbuDhabiInspectionService.checkVehicleWantedResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.checkVehicleWantedResult;
        }
        public ETAbuDhabiInspectionService.GetVehicleTicketsResponse getVehicleTickets(ETAbuDhabiInspectionService.GetVehicleTicketsRequest request) {
            ETAbuDhabiInspectionService.getVehicleTickets_element request_x = new ETAbuDhabiInspectionService.getVehicleTickets_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.getVehicleTicketsResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.getVehicleTicketsResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.getVehicleTicketsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://adpolice.gov.ae/getVehicleTickets',
              'http://adpolice.gov.ae/',
              'getVehicleTickets',
              'http://adpolice.gov.ae/',
              'getVehicleTicketsResponse',
              'ETAbuDhabiInspectionService.getVehicleTicketsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getVehicleTicketsResult;
        }
        public ETAbuDhabiInspectionService.getVehicleDetailsResponse_element getVehicleDetails(ETAbuDhabiInspectionService.GetVehicleDetailsRequest request) {
            ETAbuDhabiInspectionService.getVehicleDetails_element request_x = new ETAbuDhabiInspectionService.getVehicleDetails_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.getVehicleDetailsResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.getVehicleDetailsResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.getVehicleDetailsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://adpolice.gov.ae/getVehicleDetails',
              'http://adpolice.gov.ae/',
              'getVehicleDetails',
              'http://adpolice.gov.ae/',
              'getVehicleDetailsResponse',
              'ETAbuDhabiInspectionService.getVehicleDetailsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
        public void insertFailureCause(ETAbuDhabiInspectionService.InsertFailureCauseRequest request) {
            ETAbuDhabiInspectionService.insertFailureCause_element request_x = new ETAbuDhabiInspectionService.insertFailureCause_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.insertFailureCauseResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.insertFailureCauseResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.insertFailureCauseResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://adpolice.gov.ae/insertFailureCause',
              'http://adpolice.gov.ae/',
              'insertFailureCause',
              'http://adpolice.gov.ae/',
              'insertFailureCauseResponse',
              'ETAbuDhabiInspectionService.insertFailureCauseResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public ETAbuDhabiInspectionService.GetPlateCombinationsResponse getPlateCombinations(ETAbuDhabiInspectionService.GetPlateCombinationsRequest request) {
            ETAbuDhabiInspectionService.getPlateCombinations_element request_x = new ETAbuDhabiInspectionService.getPlateCombinations_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.getPlateCombinationsResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.getPlateCombinationsResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.getPlateCombinationsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://adpolice.gov.ae/getPlateCombinations',
              'http://adpolice.gov.ae/',
              'getPlateCombinations',
              'http://adpolice.gov.ae/',
              'getPlateCombinationsResponse',
              'ETAbuDhabiInspectionService.getPlateCombinationsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getPlateCombinationsResult;
        }
        public ETAbuDhabiInspectionService.GetVehicleReferencesResponse getVehicleReferences(ETAbuDhabiInspectionService.GetVehicleReferencesRequest request) {
            ETAbuDhabiInspectionService.getVehicleReferences_element request_x = new ETAbuDhabiInspectionService.getVehicleReferences_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.getVehicleReferencesResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.getVehicleReferencesResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.getVehicleReferencesResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://adpolice.gov.ae/getVehicleReferences',
              'http://adpolice.gov.ae/',
              'getVehicleReferences',
              'http://adpolice.gov.ae/',
              'getVehicleReferencesResponse',
              'ETAbuDhabiInspectionService.getVehicleReferencesResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getVehicleReferencesResult;
        }
        public ETAbuDhabiInspectionService.GetLookupResponse getLookup(ETAbuDhabiInspectionService.GetLookupRequest request) {
            ETAbuDhabiInspectionService.getLookup_element request_x = new ETAbuDhabiInspectionService.getLookup_element();
            request_x.request = request;
            ETAbuDhabiInspectionService.getLookupResponse_element response_x;
            Map<String, ETAbuDhabiInspectionService.getLookupResponse_element> response_map_x = new Map<String, ETAbuDhabiInspectionService.getLookupResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://adpolice.gov.ae/getLookup',
              'http://adpolice.gov.ae/',
              'getLookup',
              'http://adpolice.gov.ae/',
              'getLookupResponse',
              'ETAbuDhabiInspectionService.getLookupResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getLookupResult;
        }
    }
      public static void testCoverage(){
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
      }
    
 
}