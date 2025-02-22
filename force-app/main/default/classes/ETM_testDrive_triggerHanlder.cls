public class ETM_testDrive_triggerHanlder {
    /* Method: updateLeadWithTestDriveInfo
       Description : once Test Drive is 'selected' populate test Drive Vehcile info in Lead - Service Details.
	   Test Class  : ETM_testDrive_trigger_Test
     */
    public static void updateLeadWithTestDriveInfo(List<ETM_Vehicle_Test_Drive__c> newDrives , Map<id,ETM_Vehicle_Test_Drive__c> oldDrivesMap){
       
        Map<String, String > drive_Veh_idsMap = new Map<String, String >(); // key = test Drive id && Value = Vehicle Id
        Map<id, ETM_Sales_Vehicle_Inventory__c > VehclMap = new Map<id, ETM_Sales_Vehicle_Inventory__c >(); // key = Vehc id && Value = Vehicle Record
        
        String recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('ETSALES_Automotive_Dealership').getRecordTypeId();
        List<Lead> leads_u = new List<Lead>(); // leads to be updated
        
        String status = (system.label.ETM_TestDrive_Status!= null ? system.label.ETM_TestDrive_Status : 'Selected');
        for(ETM_Vehicle_Test_Drive__c drv : newDrives){
            if(oldDrivesMap.containsKey(drv.Id)){
                if(drv.ETM_Status__c != oldDrivesMap.get(drv.Id).ETM_Status__c && drv.ETM_Status__c == status){
                    drive_Veh_idsMap.put(drv.Id , drv.ETM_Vehicle_No__c);
                }
                
            }
        }
        
        // query vehicles info
        List<String> vehclsIds = new List<String>();
        if(drive_Veh_idsMap != null && drive_Veh_idsMap.size() >0){
            vehclsIds = drive_Veh_idsMap.values();
        }
        if(vehclsIds != null && vehclsIds.size() > 0){
            VehclMap = new Map<id, ETM_Sales_Vehicle_Inventory__c >([select id,ETM_Vehicle_No__c ,
                                                                     ETM_Vehicle_Type__c FROM ETM_Sales_Vehicle_Inventory__c]);
        }
        
        for(ETM_Vehicle_Test_Drive__c drv : newDrives){
            if(oldDrivesMap.containsKey(drv.Id)){
                if(drv.ETM_Status__c != oldDrivesMap.get(drv.Id).ETM_Status__c && drv.ETM_Status__c == 'Selected'){
                    // update fields on lead with Values from selected Vehicle...
                    Id vehId;
                    ETM_Sales_Vehicle_Inventory__c veh;
                    if(drive_Veh_idsMap.containsKey(drv.Id)){
                        vehId = drive_Veh_idsMap.get(drv.Id);
                    }
                    
                    if(VehclMap.containsKey(vehId)){
                        veh = VehclMap.get(vehId);
                    }
                    Lead ld = new Lead();
                    ld.id = drv.ETM_Lead__c;
                    ld.RecordTypeId = recordTypeId;
                    if(veh != null){
                        ld.Vehicle_type__c = veh.ETM_Vehicle_Type__c;
                        ld.ETM_Vehicle_No__c = veh.ETM_Vehicle_No__c;
                        leads_u.add(ld);
                    }
  
                }
            }
        }
        
        if(leads_u != null && leads_u.size() > 0){
            update leads_u;
        }
        
        
    }
}