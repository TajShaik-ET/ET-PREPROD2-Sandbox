/*
* File Name:ET_CraeteARInvoice
* Author : Smaartt
* CreatedDate : 10 Aug 2020
* Modification Purpose
* * 1. Waseem: Wrapper class to initialize invoice creation in Orcale with both synchronous and asynchronous request
* * 2. Sreelakshmi SK: 16 Mar 2023 Included Service Start date and End date im INV_LINES_element
*/

public class ET_CraeteARInvoice {
    
    public class INV_HEADER_element {
        public String BatchSource;
        public String TransactionNumber;
        public Date TransactionDate;
        public String FromPeriod;
        public String ToPeriod;
        public String TransactionCurrency;
        public String BillToCustomerNumber;
        public String CustTrxType;
        public String PaymentMethod;
        public String Comments;
        private String[] BatchSource_type_info = new String[]{'BatchSource','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] TransactionNumber_type_info = new String[]{'TransactionNumber','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] TransactionDate_type_info = new String[]{'TransactionDate','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] FromPeriod_type_info = new String[]{'FromPeriod','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] ToPeriod_type_info = new String[]{'ToPeriod','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] TransactionCurrency_type_info = new String[]{'TransactionCurrency','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] BillToCustomerNumber_type_info = new String[]{'BillToCustomerNumber','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] CustTrxType_type_info = new String[]{'CustTrxType','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] PaymentMethod_type_info = new String[]{'PaymentMethod','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Comments_type_info = new String[]{'Comments','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.emiratestransport.com/schemas','true','false'};
        private String[] field_order_type_info = new String[]{'BatchSource','TransactionNumber','TransactionDate','FromPeriod','ToPeriod','TransactionCurrency','BillToCustomerNumber','CustTrxType','PaymentMethod','Comments'};
    }
    public class INVOICE_element {
        public ET_CraeteARInvoice.AMAN_INVOICE_element AMAN_INVOICE;
        private String[] AMAN_INVOICE_type_info = new String[]{'AMAN_INVOICE','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.emiratestransport.com/schemas','true','false'};
        private String[] field_order_type_info = new String[]{'AMAN_INVOICE'};
    }
    public class LINES_GROUP_element {
        public ET_CraeteARInvoice.INV_LINES_element[] INV_LINES;
        private String[] INV_LINES_type_info = new String[]{'INV_LINES','http://www.emiratestransport.com/schemas',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.emiratestransport.com/schemas','true','false'};
        private String[] field_order_type_info = new String[]{'INV_LINES'};
    }
    public class AMAN_INVOICE_element {
        public ET_CraeteARInvoice.INV_HEADER_element INV_HEADER;
        public ET_CraeteARInvoice.LINES_GROUP_element LINES_GROUP;
        private String[] INV_HEADER_type_info = new String[]{'INV_HEADER','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] LINES_GROUP_type_info = new String[]{'LINES_GROUP','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.emiratestransport.com/schemas','true','false'};
        private String[] field_order_type_info = new String[]{'INV_HEADER','LINES_GROUP'};
    }
    public class INV_LINES_element {
        public Integer line_number;
        public String line_type;
        public String Description;
        public Decimal Quantity;
        public Decimal Rate;
        public Decimal Amount;
        public String Tax_Code;
        public Decimal Tax_Rate;
        public Decimal Tax_Amount;
        public String Activity_Center;
        public String Location;
        public String Department;
        public String Project;
        public String ServiceType;
        public String ServiceStartDate; // Added by Sreelakshmi --- 16 Mar 2023
        public String ServiceEndDate; // Added by Sreelakshmi --- 16 Mar 2023
        public String AuthCode; // Added by Taj --- 02 Feb 2024
        private String[] line_number_type_info = new String[]{'line_number','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] line_type_type_info = new String[]{'line_type','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Description_type_info = new String[]{'Description','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Quantity_type_info = new String[]{'Quantity','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Rate_type_info = new String[]{'Rate','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Amount_type_info = new String[]{'Amount','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Tax_Code_type_info = new String[]{'Tax_Code','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Tax_Rate_type_info = new String[]{'Tax_Rate','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Tax_Amount_type_info = new String[]{'Tax_Amount','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Activity_Center_type_info = new String[]{'Activity_Center','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Location_type_info = new String[]{'Location','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Department_type_info = new String[]{'Department','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] Project_type_info = new String[]{'Project','http://www.emiratestransport.com/schemas',null,'1','1','false'};
        private String[] ServiceType_type_info = new String[]{'ServiceType','http://www.emiratestransport.com/schemas',null,'0','1','true'};
        private String[] ServiceStartDate_type_info = new String[] {'ServiceStartDate','http://www.emiratestransport.com/schemas',null,'1','1','false'}; // Added by Sreelakshmi --- 16 Mar 2023
        private String[] ServiceEndDate_type_info = new String[] {'ServiceEndDate','http://www.emiratestransport.com/schemas',null,'1','1','false'}; // Added by Sreelakshmi --- 16 Mar 2023   
        private String[] AuthCode_type_info = new String[] {'AuthCode','http://www.emiratestransport.com/schemas',null,'1','1','false'}; // Added by Taj --- 02 Feb 2024  
        private String[] apex_schema_type_info = new String[]{'http://www.emiratestransport.com/schemas','true','false'};
        private String[] field_order_type_info = new String[]{'line_number','line_type','Description','Quantity','Rate','Amount','Tax_Code','Tax_Rate','Tax_Amount','Activity_Center','Location','Department','Project','ServiceType','ServiceStartDate','ServiceEndDate','AuthCode'};
    }
    
     public class OutputParameters_element {
        public String PV_OUT_STATUS;
        public String PV_OUT_ERROR;
        public String PV_OUT_EBIZ_TRX_NO;
        private String[] PV_OUT_STATUS_type_info = new String[]{'PV_OUT_STATUS','http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA',null,'0','1','true'};
        private String[] PV_OUT_ERROR_type_info = new String[]{'PV_OUT_ERROR','http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA',null,'0','1','true'};
        private String[] PV_OUT_EBIZ_TRX_NO_type_info = new String[]{'PV_OUT_EBIZ_TRX_NO','http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA','true','false'};
        private String[] field_order_type_info = new String[]{'PV_OUT_STATUS','PV_OUT_ERROR','PV_OUT_EBIZ_TRX_NO'};
    }
    public class InputParameters_element {
        public ET_CraeteARInvoice.PUBLIC_XMLTYPE PXML_INV_DETAILS;
        private String[] PXML_INV_DETAILS_type_info = new String[]{'PXML_INV_DETAILS','http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA','true','false'};
        private String[] field_order_type_info = new String[]{'PXML_INV_DETAILS'};
    }
    public class PUBLIC_XMLTYPE {
        private String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
}