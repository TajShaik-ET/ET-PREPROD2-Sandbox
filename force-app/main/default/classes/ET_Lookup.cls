/*
* File Name:ET_Lookup
* Author : Sagar Kambli
* CreatedDate : 13 May 2020
* Modification Purpose
* * 1. Sagar: Wrapper class to initialize lookup details for both synchronous and asynchronous request
* * 2.
*/
public class ET_Lookup {
    
    /* For Synchronous Request */
    public class Input {
        public String LookupType;
        public String LookupCode;
        private String[] LookupType_type_info = new String[]{'LookupType','http://www.et.ae',null,'0','1','false'};
        private String[] LookupCode_type_info = new String[]{'LookupCode','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'LookupType','LookupCode'};
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
        public AmanLookupValuesCollection Data;
        private String[] Status_type_info = new String[]{'Status','http://www.et.ae',null,'0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://www.et.ae',null,'0','1','false'};
        private String[] Data_type_info = new String[]{'Data','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'Status','Message','Data'};
    }
    public class SecurityInfo {
        public String SourceSystem;
        public String Username;
        public String Password;
        private String[] SourceSystem_type_info = new String[]{'SourceSystem','http://www.et.ae',null,'0','1','false'};
        private String[] Username_type_info = new String[]{'Username','http://www.et.ae',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'SourceSystem','Username','Password'};
    }
    
    /* For Asynchronous request */
    public class OutputFuture extends System.WebServiceCalloutFuture {
        public Output getValue() {
            Output response = (Output)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    
    
    public class AmanLookupValues {
        public String lookupType;
        public String lookupCode;
        public String lookupName;
        public String lookupNameAr;
        public String attribute1;
        public String attribute2;
        public String attribute3;
        private String[] lookupType_type_info = new String[]{'lookupType','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'1','1','true'};
        private String[] lookupCode_type_info = new String[]{'lookupCode','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'1','1','true'};
        private String[] lookupName_type_info = new String[]{'lookupName','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'0','1','true'};
        private String[] lookupNameAr_type_info = new String[]{'lookupNameAr','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'0','1','true'};
        private String[] attribute1_type_info = new String[]{'attribute1','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'0','1','true'};
        private String[] attribute2_type_info = new String[]{'attribute2','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'0','1','true'};
        private String[] attribute3_type_info = new String[]{'attribute3','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues','true','true'};
        private String[] field_order_type_info = new String[]{'lookupType','lookupCode','lookupName','lookupNameAr','attribute1','attribute2','attribute3'};
    }
    public class GetLookupValuesSelect_InputParameters {
        public String pLookupType;
        public String pLookupCode;
        private String[] pLookupType_type_info = new String[]{'pLookupType','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'1','1','false'};
        private String[] pLookupCode_type_info = new String[]{'pLookupCode','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues','true','true'};
        private String[] field_order_type_info = new String[]{'pLookupType','pLookupCode'};
    }
    public class AmanLookupValuesCollection {
        public AmanLookupValues[] AmanLookupValues;
        private String[] AmanLookupValues_type_info = new String[]{'AmanLookupValues','http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues',null,'0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues','true','true'};
        private String[] field_order_type_info = new String[]{'AmanLookupValues'};
    }
  
}