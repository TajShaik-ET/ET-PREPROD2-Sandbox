public class ETI_CustomerVehicleHandler {
    
     public static void updateChassisNumber(Map<Id, ET_Customer_Vehicle__c> newMap, Map<Id, ET_Customer_Vehicle__c> oldMap){
        try{
            string vechicleRTId = Schema.SObjectType.ET_Customer_Vehicle__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId(); 
            Map<Id, ET_Customer_Vehicle__c> mapOfCustomerVehicles = new Map<Id, ET_Customer_Vehicle__c>(); 
            Map<Id, ETI_Booking__c> mapOfBookings = new Map<Id, ETI_Booking__c>();
            List<ETI_Booking__c> lstBookings = new List<ETI_Booking__c>();
            List<ETI_Service_Line_Item__c> lstServiceLineItems = new List<ETI_Service_Line_Item__c>();
            
            for(ET_Customer_Vehicle__c cusVehicle : newMap.values()){
                if(cusVehicle.Chassis_No__c != oldMap.get(cusVehicle.id).Chassis_No__c && cusVehicle.RecordTypeId == vechicleRTId){
                    mapOfCustomerVehicles.put(cusVehicle.id, cusVehicle);
                }
            }
            List<String> bookingId = new List<String>();
            List<String> serviceLineItemIds = new List<String>();

            if(!mapOfCustomerVehicles.isEmpty()){
                for(ETI_Service_Line_Item__c srvLineItem : [Select id,Name, Chassis_No__c,Booking__c,Booking__r.Customer_Vehicle__c,Booking__r.Customer_Vehicle__r.Chassis_No__c FROM ETI_Service_Line_Item__c WHERE Booking__r.Customer_Vehicle__c IN:mapOfCustomerVehicles.keyset()]){
                    if(!bookingId.contains(srvLineItem.Booking__c)){
                        ETI_Booking__c booking = new ETI_Booking__c(id=srvLineItem.Booking__c);
                        booking.Chassis_No__c = mapOfCustomerVehicles.get(srvLineItem.Booking__r.Customer_Vehicle__c).Chassis_No__c;
                        lstBookings.add(booking);
                        bookingId.add(srvLineItem.Booking__c);
                    }   
                    if(!serviceLineItemIds.contains(srvLineItem.Id)){
                        srvLineItem.Chassis_No__c = mapOfCustomerVehicles.get(srvLineItem.Booking__r.Customer_Vehicle__c).Chassis_No__c;
                        lstServiceLineItems.add(srvLineItem);
                        serviceLineItemIds.add(srvLineItem.Id);
                    }               
                }           
            }
            system.debug('lstServiceLineItems------>'+lstServiceLineItems);
            if(!lstBookings.isEmpty()) update lstBookings;
            if(!lstServiceLineItems.isEmpty()) update lstServiceLineItems;
        }catch (Exception e){
            system.debug('Trace = '+e.getMessage());
            ETI_ServiceRequestHandler.logException(e, 'ETI UpdateChassisNumber');
        }
    }
    public static void tcfNoChangedNotification(Map<Id, ET_Customer_Vehicle__c> newMap, Map<Id, ET_Customer_Vehicle__c> oldMap){
        try{
            string vechicleRTId = Schema.SObjectType.ET_Customer_Vehicle__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId(); 
            set<id> vehIds=new set<id>();
            Map<String, ET_Customer_Vehicle__c> mapOfCustomerVehicles = new Map<String, ET_Customer_Vehicle__c>();
            List<ET_Customer_Vehicle__c> lstVehicles = new List<ET_Customer_Vehicle__c>(); 
            for(ET_Customer_Vehicle__c cusVehicle : newMap.values()){
                if(cusVehicle.Tcf_No__c != oldMap.get(cusVehicle.id).Tcf_No__c && cusVehicle.Tcf_No__c!=null 
                    && cusVehicle.Chassis_No__c!=null && cusVehicle.RecordTypeId == vechicleRTId){
                    vehIds.add(cusVehicle.id);
                    mapOfCustomerVehicles.put(cusVehicle.Chassis_No__c, cusVehicle);
                }
            }
            if(!mapOfCustomerVehicles.isEmpty()){
                for(ET_Customer_Vehicle__c cusVehicle : [Select Id,Name,Account__c,Chassis_No__c,Plate_No__c,Plate_Color__c,Tcf_No__c,Is_Tcf_No_Changed__c
                                                                From ET_Customer_Vehicle__c Where Chassis_No__c IN:mapOfCustomerVehicles.keyset() 
                                                                AND Status__c='Active' AND Is_Tcf_No_Changed__c=false]){
                    if(cusVehicle.Id!=mapOfCustomerVehicles.get(cusVehicle.Chassis_No__c).Id && cusVehicle.Tcf_No__c!=null
                        && cusVehicle.Tcf_No__c !=mapOfCustomerVehicles.get(cusVehicle.Chassis_No__c).Tcf_No__c && cusVehicle.Is_Tcf_No_Changed__c==false){
                        cusVehicle.Is_Tcf_No_Changed__c =true;
                        lstVehicles.add(cusVehicle);
                    }
                }
                if(!lstVehicles.isEmpty())
                    update lstVehicles;
            }
        }catch (Exception e){
            system.debug('Trace '+e.getMessage());
            system.debug('line '+e.getLineNumber());
            ETI_ServiceRequestHandler.logException(e, 'ETI tcfNoChangedNotification');
        }
    }
    public static void validateCustomerVehicle(Map<Id, ET_Customer_Vehicle__c> newMap, Map<Id, ET_Customer_Vehicle__c> oldMap){
        /*try{
            string vechicleRTId = Schema.SObjectType.ET_Customer_Vehicle__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Inspection').getRecordTypeId(); 
            List<ETI_Booking__c> lstBookings = new List<ETI_Booking__c>();
            ET_Customer_Vehicle__c  vehicle=new ET_Customer_Vehicle__c ();
            map<id,ET_Customer_Vehicle__c> vehicleMap=new map<id,ET_Customer_Vehicle__c>();
            set<id> ids=new set<id>();
            for(ET_Customer_Vehicle__c cusVehicle : newMap.values()){
                if(cusVehicle.RecordTypeId == vechicleRTId){
                    if(cusVehicle.Selected_Type__c=='Chassis No'){
                        if(cusVehicle.Chassis_No__c ==null || cusVehicle.Chassis_No__c =='')
                            cusVehicle.addError('Please Enter a Valid Chassis No to Validate.');
                        else if(cusVehicle.Chassis_No__c != oldMap.get(cusVehicle.id).Chassis_No__c){
                            vehicle =ETI_VehicleController.getVehicleInfoFromAbuDhabi(cusVehicle);
                            system.debug('vehicle >> '+vehicle );
                            if(vehicle ==null)
                                 cusVehicle.addError('Vehicle information auto-retrieval service is not available at this time. Please proceed by entering mandatory information.');
                        }    //ids.add(cusVehicle.Id);
                    }else if(cusVehicle.Selected_Type__c=='Plate Combination' && (cusVehicle.Plate_No__c != oldMap.get(cusVehicle.id).Plate_No__c || cusVehicle.Plate_Source__c != oldMap.get(cusVehicle.id).Plate_Source__c
                             || cusVehicle.Plate_Type__c != oldMap.get(cusVehicle.id).Plate_Type__c || cusVehicle.Chassis_No__c != oldMap.get(cusVehicle.id).Plate_Color__c)){
                            //cusVehicle.addError('Please Enter a Valid Plate Combination to Validate.');
                            vehicle =ETI_VehicleController.getVehicleInfoFromAbuDhabi(cusVehicle);
                            system.debug('vehicle >> '+vehicle );
                            if(vehicle ==null)
                                 cusVehicle.addError('Vehicle information auto-retrieval service is not available at this time. Please proceed by entering mandatory information.');
    
                    }
                }
            }
            system.debug('ids>> '+ids);
            if(ids!=null && ids.size()>0){
                for(ET_Customer_Vehicle__c cusVehicle : [Select Id,Name,Chassis_No__c,Plate_No__c,Plate_Color__c,Plate_Type__c,Plate_Source__c,Vehicle_Make__c,Vehicle_Model__c,Vehicle_Year__c,Vehicle_Type__c,Registration_Expiry_Date__c,Registration_Type__c,Is_Verified__c,Account__c,Account__r.Name,Account__r.PersonMobilePhone,Encrypted_Id__c,Selected_Type__c,ET_Vehicle_type__c,RecordTypeId From ET_Customer_Vehicle__c Where Id IN:ids]){
                    vehicleMap.put(cusVehicle.Id, cusVehicle);
                }
                //for(ET_Customer_Vehicle__c cusVehicle : lstVehicles){
                for(ET_Customer_Vehicle__c obj: newMap.values()){
                    if(vehicleMap!=null && vehicleMap.size()>0 && vehicleMap.containsKey(obj.Id)){
                        system.debug('obj>> '+obj);
                        vehicle =ETI_VehicleController.getVehicleInfoFromAbuDhabi(vehicleMap.get(obj.Id));
                        system.debug('vehicle >> '+vehicle );
                        if(vehicle ==null)
                            obj.addError('Vehicle information auto-retrieval service is not available at this time. Please proceed by entering mandatory information.');
                    }    
                }
            
            }
        }catch (Exception e){
            System.debug('Exception line '+e.getLineNumber());
            system.debug('Trace = '+e.getMessage());
     
        }*/
    }
   
}