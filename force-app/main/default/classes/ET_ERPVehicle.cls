/*
* File Name:ET_ERPVehicle
* Author : Sagar Kambli
* CreatedDate : 20 May 2020
* Modification Purpose
* * 1. Sagar: Wrapper class to initialize vehicle details for both synchronous and asynchronous request
* * 2.
*/
global class ET_ERPVehicle {
   public class Input {
        public String VehMode;
        public String InternalNo;
        public String Activity;
        private String[] VehMode_type_info = new String[]{'VehMode','http://www.et.ae',null,'0','1','false'};
        private String[] InternalNo_type_info = new String[]{'InternalNo','http://www.et.ae',null,'0','1','false'};
        private String[] Activity_type_info = new String[]{'Activity','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'VehMode','InternalNo','Activity'};
    }
    public class Control {
        public String InstanceTitle;
        private String[] InstanceTitle_type_info = new String[]{'InstanceTitle','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'InstanceTitle'};
    }
    public class Output {
        public String Status;
        public String Message;
        public XxetVehicleMasterDetMvCollection XxetVehicleMasterDetMvCollection;
        private String[] Status_type_info = new String[]{'Status','http://www.et.ae',null,'0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://www.et.ae',null,'0','1','false'};
        private String[] XxetVehicleMasterDetMvCollection_type_info = new String[]{'XxetVehicleMasterDetMvCollection','http://www.et.ae',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'Status','Message','XxetVehicleMasterDetMvCollection'};
    }
    global class XxetVehicleMasterDetMvCollection {
        public XxetVehicleMasterDetMv[] XxetVehicleMasterDetMv;
        private String[] XxetVehicleMasterDetMv_type_info = new String[]{'XxetVehicleMasterDetMv','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster','true','true'};
        private String[] field_order_type_info = new String[]{'XxetVehicleMasterDetMv'};
    }
    public class VehicleMasterSelect_pVehMode_pInternalNo_pActivity {
        public String pVehMode;
        public String pInternalNo;
        public String pActivity;
        private String[] pVehMode_type_info = new String[]{'pVehMode','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'1','1','false'};
        private String[] pInternalNo_type_info = new String[]{'pInternalNo','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'1','1','false'};
        private String[] pActivity_type_info = new String[]{'pActivity','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster','true','true'};
        private String[] field_order_type_info = new String[]{'pVehMode','pInternalNo','pActivity'};
    }
    global class XxetVehicleMasterDetMv {
        public String internalNo;
        public String vehMode;
        public String description;
        public String segActivityCenter;
        public String location;
        public String vehicleStatus;
        public String plateNumber;
        public String plateColour;
        public String plateType;
        public String plateIssue;
        public DateTime registrationDate;
        public DateTime regRenewalDate;
        public String mainType;
        public String subType;
        public String make;
        public String model;
        public String chassisNumber;
        public String engineNumber;
        public Decimal contractNo;
        private String[] internalNo_type_info = new String[]{'internalNo','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'1','1','true'};
        private String[] vehMode_type_info = new String[]{'vehMode','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] description_type_info = new String[]{'description','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] segActivityCenter_type_info = new String[]{'segActivityCenter','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] location_type_info = new String[]{'location','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] vehicleStatus_type_info = new String[]{'vehicleStatus','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] plateNumber_type_info = new String[]{'plateNumber','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] plateColour_type_info = new String[]{'plateColour','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] plateType_type_info = new String[]{'plateType','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] plateIssue_type_info = new String[]{'plateIssue','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] registrationDate_type_info = new String[]{'registrationDate','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] regRenewalDate_type_info = new String[]{'regRenewalDate','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] mainType_type_info = new String[]{'mainType','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] subType_type_info = new String[]{'subType','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] make_type_info = new String[]{'make','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] model_type_info = new String[]{'model','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] chassisNumber_type_info = new String[]{'chassisNumber','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] engineNumber_type_info = new String[]{'engineNumber','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] contractNo_type_info = new String[]{'contractNo','http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster','true','true'};
        private String[] field_order_type_info = new String[]{'internalNo','vehMode','description','segActivityCenter','location','vehicleStatus','plateNumber','plateColour','plateType','plateIssue','registrationDate','regRenewalDate','mainType','subType','make','model','chassisNumber','engineNumber','contractNo'};
    }
    
     public class OutputFuture extends System.WebServiceCalloutFuture {
        public ET_ERPVehicle.Output getValue() {
            ET_ERPVehicle.Output response = (ET_ERPVehicle.Output)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    
}