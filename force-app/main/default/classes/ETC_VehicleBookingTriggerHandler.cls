public class ETC_VehicleBookingTriggerHandler {

    /* Method 	   : recalculateVehiclePriceOnZoneUpdation
       Description : Recalculate Vehicle Price, when Pickup zone or Drop off zone or Duration update updates in Vehicle Booking
	*/
    
    public static void recalculateVehiclePriceOnZoneUpdation(List<ETCAR_Service_Request_Line_Item__c> newBkngs, 
                                                             Map<Id,ETCAR_Service_Request_Line_Item__c> oldBookingsMap)
    {
        system.debug('inside price recalculation');
        // Trigger only for Pickup or Drop off zone updation or Duration update....
        // query CarPriceMatrix to use in Calculation for Limo Services
        List<Cars_Price_Matrix__c> pMatrix = new List<Cars_Price_Matrix__c>([select id,
                                                                             Name,
                                                                             recordType.Name,
                                                                             Drop_off_Zone_G__c ,
                                                                             Pickup_Zone_G__c, 
                                                                             Price__c ,
                                                                             ETC_Car_Model__r.Name,
                                                                             Price_Per_Hour__c,
                                                                             Car_Type__c, 
                                                                             (select id ,
                                                                              Hours_Package__c , 
                                                                              Price__c 
                                                                              FROM Car_Price_Ranges__r)
                                                                             FROM Cars_Price_Matrix__c ]);
        
        
        for(ETCAR_Service_Request_Line_Item__c vbkng :newBkngs ){
            system.debug('service type = '+ vbkng.ETST_Service_Type__c);
            if(vbkng.ETC_Request_Type__c == 'Car Booking Services'){
                if((oldBookingsMap.get(vbkng.id).ETCAR_Pickup_Zone__c != vbkng.ETCAR_Pickup_Zone__c) 
                   || (oldBookingsMap.get(vbkng.id).ETCAR_Drop_Off_Zone__c != vbkng.ETCAR_Drop_Off_Zone__c) 
                   ||  (oldBookingsMap.get(vbkng.id).ETC_Duration__c != vbkng.ETC_Duration__c)){
                       if(vbkng.ETST_Service_Type__c == 'One Way'){
                           system.debug('inside oneway->');
                           system.debug('type-> '+vbkng.ETC_Vehicle_Type__c);
                           for(Cars_Price_Matrix__c pm : pMatrix){
                               system.debug('pm.name-> '+pm.ETC_Car_Model__c);
                               if(vbkng.ETCAR_Pickup_Zone__c == pm.Pickup_Zone_G__c && vbkng.ETCAR_Drop_Off_Zone__c == pm.Drop_off_Zone_G__c 
                                  && vbkng.ETC_Vehicle_Type__c == pm.ETC_Car_Model__r.Name ){
                                      vbkng.ETCAR_Price__c = integer.ValueOf(pm.Price__c);
                                      system.debug('oneway Price = '+  integer.ValueOf(pm.Price__c));
                                  }
                           }
                       }
                       else if(vbkng.ETST_Service_Type__c == 'Hourly'){
                           system.debug('inside houry->');
                           for(Cars_Price_Matrix__c pm : pMatrix){
                               if(vbkng.ETC_Vehicle_Type__c == pm.ETC_Car_Model__r.Name && pm.recordType.Name == 'Hourly'){
                                      if(pm.Car_Price_Ranges__r != null && pm.Car_Price_Ranges__r.size() > 0){
                                          for(Car_Price_Range__c ran :pm.Car_Price_Ranges__r ){
                                              if(vbkng.ETC_Duration__c == ran.Hours_Package__c){
                                                  vbkng.ETCAR_Price__c = integer.ValueOf(ran.Price__c);
                                                  system.debug('hourly Price = '+  integer.ValueOf(pm.Price__c));
                                              }
                                          }
                                      }
                                  }
                           }
                       }
                   }
            }
            
        }
        
    }
    
    /* Method 	   : updateRemarks - sree
       Description : to update booking with features selected along with quantities
	*/
    
    public static boolean updateRemarksRunning=false;
    public static void updateRemarks(Map<Id, ETCAR_Service_Request_Line_Item__c> newMap){
        String remarks = '';
        Map<Id,ETCAR_Service_Request_Line_Item__c> vBkngMapUpdate = new Map<Id,ETCAR_Service_Request_Line_Item__c>();
        for(ETCAR_Service_Request_Sub_Line_Item__c ftr : [SELECT Id, Name,ETCAR_Car_Features__r.Name,Service_Request_Line_Item__c,ETCAR_Quantity__c FROM ETCAR_Service_Request_Sub_Line_Item__c WHERE Service_Request_Line_Item__c In: newMap.values()]){
            if(vBkngMapUpdate.containsKey(ftr.Service_Request_Line_Item__c)) remarks =  vBkngMapUpdate.get(ftr.Service_Request_Line_Item__c).ETC_Remarks__c+' & '+ftr.ETCAR_Car_Features__r.Name+'- '+ftr.ETCAR_Quantity__c;
            else  remarks =  ftr.ETCAR_Car_Features__r.Name +'- '+ftr.ETCAR_Quantity__c;
            vBkngMapUpdate.put(ftr.Service_Request_Line_Item__c, new ETCAR_Service_Request_Line_Item__c(Id=ftr.Service_Request_Line_Item__c, ETC_Remarks__c=remarks, ETC_Is_Special_Request__c = true));
        }
        if(vBkngMapUpdate!= null && !vBkngMapUpdate.isempty()){
            updateRemarksRunning=true;
            update vBkngMapUpdate.values();
        }
    }
    
    public static void recalculateVehiclePriceOnRental(Map<Id, ETCAR_Service_Request_Line_Item__c> newMap, Map<Id, ETCAR_Service_Request_Line_Item__c> oldMap){
        Integer iDays;
        Decimal dDays;
        Long returnDateTime;
        Long pickUpDateTime ;
        List<ETCAR_Service_Request_Line_Item__c> vBkngListToUpdate = new List<ETCAR_Service_Request_Line_Item__c>();
        for(ETCAR_Service_Request_Line_Item__c vBkng :[SELECT Id,Name,ETCAR_Selecetd_Car__r.Name,ETCAR_Selecetd_Car__r.ETCAR_Daily_Price__c,ETCAR_Selecetd_Car__r.ETCAR_Weekly_Price__c,ETCAR_Selecetd_Car__r.ETCAR_Monthly_Price__c,ETCAR_Pick_UP_Date_Time__c,ETCAR_Return_Date_Time__c,ETST_Service_Type__c
                                                       FROM ETCAR_Service_Request_Line_Item__c
                                                       WHERE Id In: newMap.values() ]){
                                                           System.debug('inside for ' + vBkng.ETST_Service_Type__c);
                                                           System.debug('old '+oldMap.get(vBkng.id).ETCAR_Return_Date_Time__c + 'new '+ vBkng.ETCAR_Return_Date_Time__c);
                                                           if(vBkng.ETST_Service_Type__c == 'Rental'){
                                                               System.debug('inside rental');
                                                               if( (  vBkng.ETCAR_Pick_UP_Date_Time__c != oldMap.get(vBkng.id).ETCAR_Pick_UP_Date_Time__c) || (vBkng.ETCAR_Return_Date_Time__c != oldMap.get(vBkng.id).ETCAR_Return_Date_Time__c) ){
                                                                   system.debug('inside if');
                                                                   returnDateTime = vBkng.ETCAR_Return_Date_Time__c.getTime();  
                                                                   pickUpDateTime = vBkng.ETCAR_Pick_UP_Date_Time__c.getTime();
                                                                   Decimal diffMilliSecs = Decimal.valueOf(returnDateTime - pickUpDateTime);
                                                                   dDays = diffMilliSecs/1000/60/60/24;
                                                                   system.debug('dDays = '+ dDays);
                                                                   iDays = Integer.valueOf(math.ceil(dDays)); // Round off decimal number to next integer
                                                                   system.debug('iDays = '+ iDays);
                                                                   Decimal remainderDays = dDays- iDays;
                                                                   system.debug('remainderDays = '+ remainderDays);
                                                                   Decimal weeklyPricePerDay = vBkng.ETCAR_Selecetd_Car__r.ETCAR_Weekly_Price__c/7;
                                                                   Decimal monthlyPricePerDay = vBkng.ETCAR_Selecetd_Car__r.ETCAR_Monthly_Price__c/30;
                                                                   system.debug('weeklyPricePerDay '+weeklyPricePerDay);
                                                                   system.debug('monthlyPricePerDay '+monthlyPricePerDay);
                                                                   if(dDays <= 6){
                                                                       vBkng.ETCAR_Price__c = Integer.ValueOf(vBkng.ETCAR_Selecetd_Car__r.ETCAR_Daily_Price__c*iDays);
                                                                   }else if(dDays >=7 && dDays <=29){
                                                                       vBkng.ETCAR_Price__c = Integer.ValueOf(weeklyPricePerDay*iDays); 
                                                                   }else if(dDays >= 30){
                                                                       vBkng.ETCAR_Price__c = Integer.ValueOf(monthlyPricePerDay*iDays);
                                                                   }
                                                                   vBkngListToUpdate.add(vBkng);
                                                               }
                                                           }
                                                       }
        if(!vBkngListToUpdate.isEmpty()){
            update vBkngListToUpdate;
        } 
    }


}