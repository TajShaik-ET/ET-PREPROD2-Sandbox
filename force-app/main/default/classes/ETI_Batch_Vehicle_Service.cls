/*
* File Name:ETI_Batch_Vehicle_Service
* Author : Sagar Kambli
* CreatedDate :  21 May 20200
* Modification Purpose
* * 1. Sagar: Batch to load all vehicle Details
* * 2.
*/ 
global class ETI_Batch_Vehicle_Service implements Database.Batchable<ET_ERPVehicle.XxetVehicleMasterDetMv>, Database.AllowsCallouts,Database.stateful{
    
    public static List<ET_ERPVehicle.XxetVehicleMasterDetMv> vehicleList{get;set;}
    public  String activityType {get;set;}
    public  String  vehMode {get;set;}
    global Map<String, String> errorMap;
    global Map<String, String> successMap;
    global String baseURL;
    
    public ETI_Batch_Vehicle_Service(String activityType, String vehMode) {
        this.activityType = activityType;
        this.vehMode = vehMode;
        errorMap = new Map<String, String>();
        successMap = new Map<String, String>();
        baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        vehicleList = new List<ET_ERPVehicle.XxetVehicleMasterDetMv>();
    }
    
    global Iterable<ET_ERPVehicle.XxetVehicleMasterDetMv> start(Database.BatchableContext BC) {
        ET_ERPVehicleService.execute_pt service = new ET_ERPVehicleService.execute_pt();
        ET_ERPVehicle.Output vehicleResult = service.execute(vehMode,'',activityType);
        if(vehicleResult!=null)
        {
            ET_ERPVehicle.XxetVehicleMasterDetMvCollection collection = vehicleResult.XxetVehicleMasterDetMvCollection;
            vehicleList = collection.XxetVehicleMasterDetMv;
        }
        
        return new ET_Vehicle_Iterable(vehicleList);
    } 
    
    global void execute(Database.BatchableContext BC, List<ET_ERPVehicle.XxetVehicleMasterDetMv> vehicleData) {
        List<ET_ERP_Vehicle__c> vehiclesToInsert = ET_ERPVehiclesServiceSchedule.doVehicleMapping(vehicleData);
        
        if(vehiclesToInsert!=null && vehiclesToInsert.size()>0){
            Database.UpsertResult[] results = Database.upsert(vehiclesToInsert, ET_ERP_Vehicle__c.External_ID__c);
            for(Integer index = 0, size = results.size(); index < size; index++) {
                if(results[index].isSuccess()) {
                    String sucMsg = baseURL + '/' + vehiclesToInsert[index].Id;
                    if(results[index].isCreated()) {
                        sucMsg += ':' + vehiclesToInsert[index].External_Id__c + ':created';
                        System.debug(vehiclesToInsert[index].External_Id__c +' was created');
                    } else {
                        sucMsg += ':' + vehiclesToInsert[index].External_Id__c + ':updated';
                        System.debug(vehiclesToInsert[index].External_Id__c +' was updated');
                    }
                    
                    successMap.put(vehiclesToInsert[index].Id, sucMsg);
                }
                else{
                    String errMsg = results[index].getErrors()[0].getMessage();
                    errorMap.put(vehiclesToInsert[index].External_Id__c, errMsg);
                }
            }
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
        ET_Common_Util.sendEmail('ERP Vehicle Daily Job - Result for ETI_Batch_Vehicle_Service', new string[]{'sagar.kambli@smaartt.com'}, null, null,'Data Results' ,successMap,errorMap);
        system.debug('Completed processing ERP Vehicle Service successfully......');
    }
    
    
}