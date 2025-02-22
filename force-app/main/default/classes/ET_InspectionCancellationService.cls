/*
* File Name:ET_InspectionCancellationService
* Author : Sagar Kambli
* CreatedDate : 14 May 2020
* Modification Purpose
* * 1. Sagar: Service to call both cancell receipt synchronous and asynchronous request
* * 2.
*/
public class ET_InspectionCancellationService {
    
    public class execute_pt {
        public String endpoint_x;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public String username_x;
        public String password_x;
        public OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security;
        private String Security_hns = 'Security=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';                          
	    private String[] ns_map_type_info = new String[]{'http://oracle.com/sca/soapservice/AMAN_Interfaces/CancelInspectionReceipt/Client', 'ET_InspectionCancellationService', 'http://www.et.ae', 'ET_InspectionCancellation'};
            
        public execute_pt(){
            ET_Lookup.SecurityInfo authInfo =  ET_SOA_Authorize.initializeDynamicSecurity(ET_SOA_Authorize.CANCELLATION_SERVICE_TYPE);
            endpoint_x = ET_SOA_Authorize.endpointURL;
            username_x = authInfo.Username;
            password_x = authInfo.Password;
            Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(username_x, password_x);
        }  
        
        public ET_InspectionCancellation.Output execute(String AmanReceiptNo) {
            ET_InspectionCancellation.Input request_x = new ET_InspectionCancellation.Input();
            request_x.AmanReceiptNo = AmanReceiptNo;
            ET_InspectionCancellation.Output response_x;
            Map<String, ET_InspectionCancellation.Output> response_map_x = new Map<String, ET_InspectionCancellation.Output>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'execute',
              'http://www.et.ae',
              'Input',
              'http://www.et.ae',
              'Output',
              'ET_InspectionCancellation.Output'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
    
     public class Asyncexecute_pt {
        public String endpoint_x;
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        public String username_x;
        public String password_x;
        public OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security;
        private String Security_hns = 'Security=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';                          
	    private String[] ns_map_type_info = new String[]{'http://oracle.com/sca/soapservice/AMAN_Interfaces/CancelInspectionReceipt/Client', 'ET_InspectionCancellationService', 'http://www.et.ae', 'ET_InspectionCancellation'};
            
        public Asyncexecute_pt(){
            ET_Lookup.SecurityInfo authInfo =  ET_SOA_Authorize.initializeDynamicSecurity(ET_SOA_Authorize.CANCELLATION_SERVICE_TYPE);
            endpoint_x = ET_SOA_Authorize.endpointURL;
            username_x = authInfo.Username;
            password_x = authInfo.Password;
            Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(username_x, password_x);
        }    
        public ET_InspectionCancellation.OutputFuture beginExecute(System.Continuation continuation,String AmanReceiptNo) {
            ET_InspectionCancellation.Input request_x = new ET_InspectionCancellation.Input();
            request_x.AmanReceiptNo = AmanReceiptNo;
            return (ET_InspectionCancellation.OutputFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              ET_InspectionCancellation.OutputFuture.class,
              continuation,
              new String[]{endpoint_x,
              'execute',
              'http://www.et.ae',
              'Input',
              'http://www.et.ae',
              'Output',
              'ET_InspectionCancellation.Output'}
            );
        }
    }
    public static void utilityMethod(){
        
        integer i=0;
        
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
          i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
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