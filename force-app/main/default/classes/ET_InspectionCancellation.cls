/*
* File Name:ET_InspectionCancellation
* Author : Sagar Kambli
* CreatedDate : 14 May 2020
* Modification Purpose
* * 1. Sagar: Wrapper class to initialize fee cancellation details for both synchronous and asynchronous request
* * 2.
*/
public class ET_InspectionCancellation {
    public class Input {
        public String AmanReceiptNo;
        private String[] AmanReceiptNo_type_info = new String[]{'AmanReceiptNo','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'AmanReceiptNo'};
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
        private String[] Status_type_info = new String[]{'Status','http://www.et.ae',null,'0','1','false'};
        private String[] Message_type_info = new String[]{'Message','http://www.et.ae',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.et.ae','true','false'};
        private String[] field_order_type_info = new String[]{'Status','Message'};
    }
    
    public class OutputFuture extends System.WebServiceCalloutFuture {
        public Output getValue() {
            Output response = (Output)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
    
   
}