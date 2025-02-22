/*
* File Name:ET_CreateARInvoiceService
* Author :Smaartt
* CreatedDate : 10 Aug 2020
* Modification Purpose
* * 1. Waseem: Service to call both create invoice in Oracle synchronous and asynchronous request
* * 2. Shashank: Added the endpoint_x as Label name 
*/

public class ET_CreateARInvoiceService {
    
    public class SyncARInvoiceToEBSServiceBPELProcess_pt {
        public String endpoint_x = System.Label.ETSALES_InvoiceEndPoint;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x=120000;
        private String[] ns_map_type_info = new String[]{'http://www.emiratestransport.com/schemas', 'ET_CraeteARInvoice', 'http://xmlns.oracle.com/EmiratesTransport/SyncARInvoiceToEBSService/SyncARInvoiceToEBSServiceBPELProcess', 'ET_CreateARInvoiceService', 'http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA', 'ET_CraeteARInvoice'};
       
            //Method to invoke to craete AR invoices in Oracle EBS.
            public ET_CraeteARInvoice.OutputParameters_element process(ET_CraeteARInvoice.AMAN_INVOICE_element AMAN_INVOICE) {
            ET_CraeteARInvoice.INVOICE_element request_x = new ET_CraeteARInvoice.INVOICE_element();
            request_x.AMAN_INVOICE = AMAN_INVOICE;
            ET_CraeteARInvoice.OutputParameters_element response_x;
            Map<String, ET_CraeteARInvoice.OutputParameters_element> response_map_x = new Map<String, ET_CraeteARInvoice.OutputParameters_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'process',
              'http://www.emiratestransport.com/schemas',
              'INVOICE',
              'http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA',
              'OutputParameters',
              'ET_CraeteARInvoice.OutputParameters_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
    
    //Class to create async AR invoices.
    
    public class AsyncSyncARInvoiceToEBSServiceBPELProcess_pt {
        public String endpoint_x = 'https://etdevsoa.et.gov.ae:443/soa-infra/services/CommonBusinessServices/SyncARInvoiceToEBSService/syncarinvoicetoebsservicebpelprocess_client_ep';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.emiratestransport.com/schemas', 'ET_CraeteARInvoice', 'http://xmlns.oracle.com/EmiratesTransport/SyncARInvoiceToEBSService/SyncARInvoiceToEBSServiceBPELProcess', 'ET_CreateARInvoiceService', 'http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA', 'ET_CraeteARInvoice'};
       
            //Method to craete AR inovoices.
            public ET_CreateARInvoiceService.OutputParameters_elementFuture beginProcess(System.Continuation continuation,ET_CraeteARInvoice.AMAN_INVOICE_element AMAN_INVOICE) {
            ET_CraeteARInvoice.INVOICE_element request_x = new ET_CraeteARInvoice.INVOICE_element();
            request_x.AMAN_INVOICE = AMAN_INVOICE;
            return (ET_CreateARInvoiceService.OutputParameters_elementFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              ET_CreateARInvoiceService.OutputParameters_elementFuture.class,
              continuation,
              new String[]{endpoint_x,
              'process',
              'http://www.emiratestransport.com/schemas',
              'INVOICE',
              'http://xmlns.oracle.com/pcbpel/adapter/db/sp/XXET_AR_AMAN_INTF_PKG_OA',
              'OutputParameters',
              'ET_CraeteARInvoice.OutputParameters_element'}
            );
        }
    }
    
    // method to get responses.
      
    public class OutputParameters_elementFuture extends System.WebServiceCalloutFuture 
    {
        public ET_CraeteARInvoice.OutputParameters_element getValue() {
            ET_CraeteARInvoice.OutputParameters_element response = (ET_CraeteARInvoice.OutputParameters_element)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
}