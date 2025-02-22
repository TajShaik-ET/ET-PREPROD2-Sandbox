public class ET_InspectionTestResultService {
    
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
         public String source_x;
         public OasisOpenOrgWssSecuritySecext.SecurityHeaderType Security;
        private String Security_hns = 'Security=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';             
        private String[] ns_map_type_info = new String[]{'http://oracle.com/sca/soapservice/AMAN_Interfaces/UpdateTestStatus/Client', 'ET_InspectionTestResultService', 'http://www.et.ae', 'ET_InsepctionTestResultWrapper'};
       
            public execute_pt(){
            ET_Lookup.SecurityInfo authInfo =  ET_SOA_Authorize.initializeDynamicSecurity(ET_SOA_Authorize.AMAN_TEST_RESULT);
            endpoint_x = ET_SOA_Authorize.endpointURL;
            username_x = authInfo.Username;
            password_x = authInfo.Password;
            source_x = authInfo.SourceSystem;
            timeout_x = 50000;
                            Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(username_x, password_x);
        }  
            
            public ET_InsepctionTestResultWrapper.Output execute(String LocationCode,String AmanReceiptNo,String TestStatus) {
            ET_InsepctionTestResultWrapper.Input request_x = new ET_InsepctionTestResultWrapper.Input();
            request_x.LocationCode = LocationCode;
            request_x.AmanReceiptNo = AmanReceiptNo;
            request_x.TestStatus = TestStatus;
            ET_InsepctionTestResultWrapper.Output response_x;
            Map<String, ET_InsepctionTestResultWrapper.Output> response_map_x = new Map<String, ET_InsepctionTestResultWrapper.Output>();
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
              'ET_InsepctionTestResultWrapper.Output'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
		
     public class Asyncexecute_pt {
        public String endpoint_x = 'https://etdevsoa.et.gov.ae:443/soa-infra/services/AMAN_Interfaces/UpdateTestStatus/Client';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://oracle.com/sca/soapservice/AMAN_Interfaces/UpdateTestStatus/Client', 'ET_InspectionTestResultService', 'http://www.et.ae', 'ET_InsepctionTestResultWrapper'};
        
            public ET_InspectionTestResultService.OutputFuture beginExecute(System.Continuation continuation,String LocationCode,String AmanReceiptNo,String TestStatus) {
            ET_InsepctionTestResultWrapper.Input request_x = new ET_InsepctionTestResultWrapper.Input();
            request_x.LocationCode = LocationCode;
            request_x.AmanReceiptNo = AmanReceiptNo;
            request_x.TestStatus = TestStatus;
            return (ET_InspectionTestResultService.OutputFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              ET_InspectionTestResultService.OutputFuture.class,
              continuation,
              new String[]{endpoint_x,
              'execute',
              'http://www.et.ae',
              'Input',
              'http://www.et.ae',
              'Output',
              'ET_InspectionTestResultService.Output'}
            );
        }
    }
    
       public class OutputFuture extends System.WebServiceCalloutFuture {
        public ET_InsepctionTestResultWrapper.Output getValue() {
            ET_InsepctionTestResultWrapper.Output response = (ET_InsepctionTestResultWrapper.Output)System.WebServiceCallout.endInvoke(this);
            return response;
        }
    }
}