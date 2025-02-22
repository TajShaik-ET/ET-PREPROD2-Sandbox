/*
* File Name:ET_ERPVehicleService
* Author : Sagar Kambli
* CreatedDate : 20 May 2020
* Modification Purpose
* * 1. Sagar: Wrapper class to call vehicle details endpoint for both synchronous and asynchronous request
* * 2.
*/
public class ET_ERPVehicleService {
    
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
        private String[] ns_map_type_info = new String[]{'http://www.et.ae', 'ET_ERPVehicle', 'http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster', 'ET_ERPVehicle', 'http://oracle.com/sca/soapservice/EBS_Vehicle_Integration/VehicleMaster/Client', 'ET_ERPVehicleService'};
            
         public execute_pt(){
            ET_Lookup.SecurityInfo authInfo =  ET_SOA_Authorize.initializeDynamicSecurity(ET_SOA_Authorize.ERP_VEHICLE_SERVICE);
            endpoint_x = ET_SOA_Authorize.endpointURL;
            username_x = authInfo.Username;
            password_x = authInfo.Password;
            timeout_x = 20000;
            Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(username_x, password_x);
        }  
        
        public ET_ERPVehicle.Output execute(String VehMode,String InternalNo,String Activity) {
            ET_ERPVehicle.Input request_x = new ET_ERPVehicle.Input();
            request_x.VehMode = VehMode;
            request_x.InternalNo = InternalNo;
            request_x.Activity = Activity;
            ET_ERPVehicle.Output response_x;
            Map<String, ET_ERPVehicle.Output> response_map_x = new Map<String, ET_ERPVehicle.Output>();
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
              'ET_ERPVehicle.Output'}
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
        private String[] ns_map_type_info = new String[]{'http://www.et.ae', 'ET_ERPVehicle', 'http://xmlns.oracle.com/pcbpel/adapter/db/top/VehicleMaster', 'ET_ERPVehicle', 'http://oracle.com/sca/soapservice/EBS_Vehicle_Integration/VehicleMaster/Client', 'ET_ERPVehicleService'};
        public Asyncexecute_pt(){
            ET_Lookup.SecurityInfo authInfo =  ET_SOA_Authorize.initializeDynamicSecurity(ET_SOA_Authorize.ERP_VEHICLE_SERVICE);
            endpoint_x = ET_SOA_Authorize.endpointURL;
            system.debug(endpoint_x);
            username_x = authInfo.Username;
            system.debug(username_x);
            password_x = authInfo.Password;
                        system.debug(password_x);
            Security = new OasisOpenOrgWssSecuritySecext.SecurityHeaderType(username_x, password_x);
        }    
        public ET_ERPVehicle.OutputFuture beginExecute(System.Continuation continuation,String VehMode,String InternalNo,String Activity) {
            ET_ERPVehicle.Input request_x = new ET_ERPVehicle.Input();
            request_x.VehMode = VehMode;
            request_x.InternalNo = InternalNo;
            request_x.Activity = Activity;
            return (ET_ERPVehicle.OutputFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              ET_ERPVehicle.OutputFuture.class,
              continuation,
              new String[]{endpoint_x,
              'execute',
              'http://www.et.ae',
              'Input',
              'http://www.et.ae',
              'Output',
              'ET_ERPVehicle.Output'}
            );
        }
    }
}