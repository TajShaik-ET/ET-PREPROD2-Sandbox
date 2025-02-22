public class GetReceiptResponseWrapper{
    public class GetReceiptByInvoiceOutput {
        public String Operating_Unit;
        public Integer ORGANIZATION_ID;
        public Integer CASH_RECEIPT_ID;
        public decimal  AMOUNT;
        public String RECEIPT_NUMBER;
        public Integer DOC_SEQUENCE_VALUE_REC;
        public String RECEIPT_DATE;
        public String GL_DATE;
        public String TYPE;
        public String RECEIPT_STATUS;
        public String CUSTOMER_NAME;
        public String CUSTOMER_NUMBER;
        public String CUSTOMER_RECEIPT_REFERENCE;
        public String RECEIPT_METHOD;
        public String STATUS;
        public Integer CUSTOMER_TRX_ID;
        public String TRX_NUMBER;
        public Long DOC_SEQUENCE_VALUE_INV;
        public String TRX_DATE;
        public decimal AMOUNT_APPLIED;
        public String Applied_Status;
        
    }
    
    public String Status;
    public String Message;
    public String OracleAPInvoiceId; 
    public String OracleAPInvoiceNumber;
    public ReceiptList ReceiptList;
    
    public class ReceiptList {
        public List<GetReceiptByInvoiceOutput> GetReceiptByInvoiceOutput;
    }
    
    
    public static GetReceiptResponseWrapper parse(String json) {
        return (GetReceiptResponseWrapper) System.JSON.deserialize(json, GetReceiptResponseWrapper.class);
    }
}