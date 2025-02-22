global class ETI_BulkVehicleUploadValidateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
{
    global set<id> ids=new set<id>();
    global list<ET_Customer_Vehicle__c> lstVehicle;
    public ETI_BulkVehicleUploadValidateBatch(set<id> vehilceIds){
        ids=vehilceIds;
        lstVehicle=new list<ET_Customer_Vehicle__c>();
    }
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query='Select Id,Name,Chassis_No__c,Plate_No__c,Plate_Color__c,Plate_Type__c,Plate_Source__c,Vehicle_Make__c,Vehicle_Model__c,Vehicle_Year__c,Vehicle_Type__c,Registration_Expiry_Date__c,Registration_Type__c,Is_Verified__c,Account__c,Account__r.Name,Account__r.PersonMobilePhone,Encrypted_Id__c,Selected_Type__c,ET_Vehicle_type__c,RecordTypeId From ET_Customer_Vehicle__c Where Id IN:ids';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<ET_Customer_Vehicle__c> scope)
    {
        try{ 
            system.debug('scope>> '+scope.size());
            ET_Customer_Vehicle__c vehicle =ETI_B2B_VehicleController.getVehicleInfoFromAbuDhabi(scope[0],'Chassis No');
            if(vehicle !=null)
                lstVehicle.add(vehicle);
        }catch(exception e){
            System.debug('Exception '+e.getMessage());
            ETI_ServiceRequestHandler.logException(e, 'ETI BulkVehicleUploadBatch');
        }
        
    }
    global void finish(Database.BatchableContext BC)
    {
       try {
           system.debug('lstVehicle>> '+lstVehicle.size());
           if(!lstVehicle.isEmpty())
               update lstVehicle;
       }
       catch (Exception Ex) {
           System.debug('Exception '+Ex.getMessage());
           ETI_ServiceRequestHandler.logException(Ex, 'ETI BulkVehicleUploadBatch');
       }
    } 
}