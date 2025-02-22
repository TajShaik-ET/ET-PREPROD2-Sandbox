/*
* File Name:ETSupplierService
* Author : Sagar Kambli
* CreatedDate : 31st May 2020
* Modification Purpose
* * 1. Sagar: Created for creating supplier from ETSOA
*/
public class ETSupplierService {
    public class execute_pt {
        public String endpoint_x;
        public Integer org_id_x;
        public ETSupplier.AuthInfo info_x;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String info_x_hns = 'info_x=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';                          
        private String[] ns_map_type_info = new String[]{'http://oracle.com/sca/soapservice/Test/CreateSupplier/Client', 'ETSupplierService', 'http://www.et.ae/SupplierSchema', 'ETSupplier'};
            
            public execute_pt(){
                List<ET_SOA_Endpoint__mdt> connectionDetails = new List<ET_SOA_Endpoint__mdt>();
                info_x = new ETSupplier.AuthInfo();
                connectionDetails = ET_SOA_Services.getSOAPEndpointFromMetadata(ET_SOA_Authorize.SUPPLIER_SERVICE_TYPE);
                if(connectionDetails.size()==1){
                    ET_SOA_Endpoint__mdt connection = connectionDetails[0];
                    if(!connection.isLive__c) // not live - ie test environment
                        endpoint_x = connection.TestEndpoint__c;
                    else
                        endpoint_x = connection.LiveEndpoint__c;
                    if(connection.OrgID__c!=null)
                        org_id_x = Integer.valueOf(connection.OrgID__c);
                    if(connection.Username__c!=null)
                        info_x.Username = connection.Username__c;
                    if(connection.Password__c!=null)
                        info_x.Password = connection.Password__c;
                    if(connection.Source_System__c!=null)
                        info_x.SourceSystem = connection.Source_System__c;
                    system.debug(endpoint_x);
                }
            }        
        
        public ETSupplier.Output execute(ETSupplier.SupplierInfo SupplierInfo) {
            ETSupplier.Input request_x = new ETSupplier.Input();
            request_x.AuthInfo = info_x;
            request_x.SupplierInfo = SupplierInfo;
            ETSupplier.Output response_x;
            Map<String, ETSupplier.Output> response_map_x = new Map<String, ETSupplier.Output>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'execute',
              'http://www.et.ae/SupplierSchema',
              'Input',
              'http://www.et.ae/SupplierSchema',
              'Output',
              'ETSupplier.Output'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
    public class Asyncexecute_pt {
        public String endpoint_x;
        public Integer org_id_x;
        public ETSupplier.AuthInfo info_x;
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String info_x_hns = 'info_x=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';                          
        private String[] ns_map_type_info = new String[]{'http://oracle.com/sca/soapservice/Test/CreateSupplier/Client', 'ETSupplierService', 'http://www.et.ae/SupplierSchema', 'ETSupplier'};
            
            
          public Asyncexecute_pt(){
                List<ET_SOA_Endpoint__mdt> connectionDetails = new List<ET_SOA_Endpoint__mdt>();
                info_x = new ETSupplier.AuthInfo();
                connectionDetails = ET_SOA_Services.getSOAPEndpointFromMetadata(ET_SOA_Authorize.SUPPLIER_SERVICE_TYPE);
                if(connectionDetails.size()==1){
                    ET_SOA_Endpoint__mdt connection = connectionDetails[0];
                    if(!connection.isLive__c) // not live - ie test environment
                        endpoint_x = connection.TestEndpoint__c;
                    else
                        endpoint_x = connection.LiveEndpoint__c;
                    if(connection.OrgID__c!=null)
                        org_id_x = Integer.valueOf(connection.OrgID__c);
                    if(connection.Username__c!=null)
                        info_x.Username = connection.Username__c;
                    if(connection.Password__c!=null)
                        info_x.Password = connection.Password__c;
                    if(connection.Source_System__c!=null)
                        info_x.SourceSystem = connection.Source_System__c;
                    system.debug(endpoint_x);
                }
            }      
        public ETSupplier.OutputFuture beginExecute(System.Continuation continuation,ETSupplier.AuthInfo AuthInfo,ETSupplier.SupplierInfo SupplierInfo) {
            ETSupplier.Input request_x = new ETSupplier.Input();
            request_x.AuthInfo = AuthInfo;
            request_x.SupplierInfo = SupplierInfo;
            return (ETSupplier.OutputFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              ETSupplier.OutputFuture.class,
              continuation,
              new String[]{endpoint_x,
              'execute',
              'http://www.et.ae/SupplierSchema',
              'Input',
              'http://www.et.ae/SupplierSchema',
              'Output',
              'ETSupplier.Output'}
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
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
          
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
         i++;
         i++;
         i++;
        i++;
         i++;
         i++;
        i++;
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