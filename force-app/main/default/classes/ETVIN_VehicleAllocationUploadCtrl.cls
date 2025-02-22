/* Author:Janardhan Muddana
 *  
 */
public class ETVIN_VehicleAllocationUploadCtrl {

      @AuraEnabled
    public static string insertData(String strfromle,string InvRecID){
        
      String returnresponse ='';
        set<string> vehIds = new set<string>();
        map<string,string> empIdvsAccId = new map<string,string>();
        List<ETVIN_VehicleInvoiceAllocation__c> VehUpdateList = new List<ETVIN_VehicleInvoiceAllocation__c>();
        system.debug('strfromle = ' + strfromle);
        List<fieldWrapper> datalist = (List<fieldWrapper>)JSON.deserialize(strfromle, List<fieldWrapper>.class);
       system.debug('datalist = ' + datalist);
        //system.debug('datalistSize = ' + datalist.size());
       for(fieldWrapper wrapper: datalist){
            
            vehIds.add(wrapper.VehicleInternalNumber);
        }
        if(vehIds.size()>0){
            
          
            for(Vehicle_Master__c ve : [select id,Name from Vehicle_Master__c where Name =:vehIds limit 50000]){
                empIdvsAccId.put(ve.Name,ve.Id);
            }
            
        }
        
        for(fieldWrapper wrapper: datalist){
            
                       
            ETVIN_VehicleInvoiceAllocation__c al =new  ETVIN_VehicleInvoiceAllocation__c();
            al.Amount__c = wrapper.Amount;
            al.Invoice_Type__c=wrapper.InvoiceType;
            al.Insurance_Invoices__c = InvRecID;
            
           
            if(empIdvsAccId.containsKey(wrapper.VehicleInternalNumber)){
              al.Vehicle__c = empIdvsAccId.get(wrapper.VehicleInternalNumber);
            }
                    
            VehUpdateList.add(al);            
        }
        
        if(VehUpdateList.size() > 0){
            try {
                insert VehUpdateList;
                returnresponse = 'SUCCESS';
            }
            catch(Exception ex){
                returnresponse = 'ERROR';
                system.debug('-err-'+ex);
                throw new AuraHandledException('Error-- '+ ex.getMessage());  
            }
        }
        return returnresponse;
    }
    
    public class fieldWrapper{  
        public String VehicleInternalNumber; 
        public decimal Amount;  
        public String InvoiceType;
        
    } 
   
}