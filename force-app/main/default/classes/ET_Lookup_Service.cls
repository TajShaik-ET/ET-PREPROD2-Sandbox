/*
* File Name:ET_Lookup_Service
* Author : Sagar Kambli
* CreatedDate : 13 May 2020
* Modification Purpose
* * 1. Sagar: Wrapper class to initialize lookup details for both synchronous and asynchronous request
* * 2.
*/
public class ET_Lookup_Service {
    
    public ET_Lookup.SecurityInfo authInfo {get;set;}
   
    public class execute_pt {
        public String endpoint_x ;
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
        private String[] ns_map_type_info = new String[]{'http://www.et.ae', 'ET_Lookup', 'http://oracle.com/sca/soapservice/AMAN_Interfaces/GetLookupValues/Client', 'ET_Lookup', 'http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues', 'ET_Lookup'};
       
        public execute_pt(){
            ET_Lookup.SecurityInfo authInfo =  ET_SOA_Authorize.initializeSecurityForLookup();
            endpoint_x = ET_SOA_Authorize.endpointURL;
            username_x = authInfo.Username;
            password_x = authInfo.Password;
            Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(username_x, password_x);
        }
    
        public ET_Lookup.Output execute(String LookupType,String LookupCode) {
            system.debug('endpoint_x: '+endpoint_x);
            ET_Lookup.Input request_x = new ET_Lookup.Input();
            request_x.LookupType = LookupType;
            request_x.LookupCode = LookupCode;
            ET_Lookup.Output response_x;
            Map<String, ET_Lookup.Output> response_map_x = new Map<String, ET_Lookup.Output>();
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
              'ET_Lookup.Output'}
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

        private String[] ns_map_type_info = new String[]{'http://www.et.ae', 'ET_Lookup', 'http://oracle.com/sca/soapservice/AMAN_Interfaces/GetLookupValues/Client', 'ET_Lookup', 'http://xmlns.oracle.com/pcbpel/adapter/db/top/GetLookupValues', 'ET_Lookup'};
            
        
        public Asyncexecute_pt(){
            ET_Lookup.SecurityInfo authInfo =  ET_SOA_Authorize.initializeSecurityForLookup();
            endpoint_x = ET_SOA_Authorize.endpointURL;
            username_x = authInfo.Username;
            password_x = authInfo.Password;
            Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(username_x, password_x);
        }
        
        public ET_Lookup.OutputFuture beginExecute(System.Continuation continuation,String LookupType,String LookupCode) {
            ET_Lookup.Input request_x = new ET_Lookup.Input();
            request_x.LookupType = LookupType;
            request_x.LookupCode = LookupCode;
            return (ET_Lookup.OutputFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              ET_Lookup.OutputFuture.class,
              continuation,
              new String[]{endpoint_x,
              'execute',
              'http://www.et.ae',
              'Input',
              'http://www.et.ae',
              'Output',
              'ET_Lookup.Output'}
            );
        }
    }
  
}