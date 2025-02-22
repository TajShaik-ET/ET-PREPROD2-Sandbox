/**
 * Modified By: Janardhan
 * Date: 10/02/2023 : Add second attempt failed condition in query filter
 * 
 * */
global class ETI_UdpateVehicleDetailsAfterResultBatch implements Database.Batchable<sObject>,Database.stateful, Schedulable , Database.AllowsCallouts
{   
    global Set<Id> vehicleIds= new Set<Id>();
    global ETI_UdpateVehicleDetailsAfterResultBatch (){}
    global ETI_UdpateVehicleDetailsAfterResultBatch (set<Id> recIds){
         system.debug('enetred batch class');
        if(recIds!=null && recIds.size()>0){
            system.debug('in if');
            vehicleIds.addAll(recIds);
        }else {
             system.debug('in else');
            set<String> serviceTypes=new set<String>();
            set<String> resultValues=new set<String>();
            serviceTypes.addAll(Label.ETI_Vehicle_Sync_Service_Types.split(';'));
            resultValues.addAll(Label.ETI_Vehicle_Sync_Result.split(';'));
            for(ETI_Service_Line_Item__c service:[Select Id,Test_Date__c,Result_Date__c,booking__r.Customer_Vehicle__c From ETI_Service_Line_Item__c 
                                                  Where Result_Date__c!=null AND booking__r.Service_Type__c NOT IN :serviceTypes AND Test_Result__c IN :resultValues AND
                                                  booking__r.Customer_Vehicle__r.Registration_Type__c='Un-Registered' AND booking__r.Customer_Vehicle__r.Is_Vehicle_Synched__c =false AND booking__r.Customer_Vehicle__r.Is_Second_Sync_Attempt_Failed__c = false]){
                Integer syncDays = (service.Result_Date__c).daysBetween(system.today());
                if(syncDays >=integer.valueOf(label.ETI_Vehicle_Sync_Days))
                    vehicleIds.add(service.booking__r.Customer_Vehicle__c);
            }
            system.debug('vehicleIds = '+ vehicleIds);
        }
    }
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query='SELECT Id,Name,Chassis_No__c,Plate_No__c,Plate_Color__c,Plate_Color_Code__c,Plate_Type__c,Plate_Type_Code__c,Plate_Source__c,Plate_Source_Code__c,Vehicle_Make__c,Make_Code__c,Vehicle_Model__c,Model_Code__c ,Vehicle_Year__c,Vehicle_type__c,Vehicle_Type_Code__c,Registration_Expiry_Date__c,Registration_Type__c,Is_Verified__c,Account__c,Status__c,Integration_Message__c,Is_Vehicle_Synched__c,Is_Second_Sync_Attempt_Failed__c FROM ET_Customer_Vehicle__c WHERE Id IN:vehicleIds';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<ET_Customer_Vehicle__c> scope)
    {
        list<ET_Customer_Vehicle__c> customerVehicles=new list<ET_Customer_Vehicle__c>();
        Id regRecordTypeId = Schema.SObjectType.ET_Customer_Vehicle__c.getRecordTypeInfosByDeveloperName().get('Registered_Vehicle').getRecordTypeId();
        for(ET_Customer_Vehicle__c vehicle:scope){
            system.debug('vehicle.Chassis_No__c -- 34 = '+ vehicle.Chassis_No__c);
            if(vehicle.Chassis_No__c != '' && vehicle.Chassis_No__c != null){
                ETAbuDhabiInspectionService.GetVehicleDetailsRequest request = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
                request.ChassisNo = vehicle.Chassis_No__c;
                request.SystemCode = integer.valueOf(system.label.ETI_AMAN_System_Code);
                request.UserID = system.label.ETI_AMAN_UserID;
                ET_SOA_Services soa = new ET_SOA_Services();
                ETAbuDhabiInspectionService.getVehicleDetailsResponse_element vehicleDetails = soa.getVehiclesDetails(request); 
                System.debug('vehicleDetails 42' + vehicleDetails);
                if(vehicleDetails!=null && vehicleDetails.getVehicleDetailsResult != null)
                {
                    system.debug('inside if');
                    vehicle = ETI_VehicleController.getVehicleInfoByChasiss(vehicle,vehicleDetails);
                    vehicle.Is_Vehicle_Synched__c=true;
                    if(vehicle.Registration_Type__c=='Un-Registered'){
                        vehicle.Registration_Type__c='Registered';
                        vehicle.RecordTypeId = regRecordTypeId;
                    }
                    vehicle.Integration_Message__c ='';
                    customerVehicles.add(vehicle);
                }else {
                    system.debug('inside else');
                    if(vehicle.Integration_Message__c!=null && vehicle.Integration_Message__c!='')
                        vehicle.Is_Second_Sync_Attempt_Failed__c = true;
                    vehicle.Integration_Message__c = Label.ETI_Customer_Vehicle_Integration_Message;
                    customerVehicles.add(vehicle);
                }
            }
        }
        
         System.debug('check customerVehicles'+customerVehicles);
        try{
            if(!customerVehicles.isEmpty())
            {
                update customerVehicles;
            	system.debug('details updated 69'); 
            }
        }catch(Exception ex) {
            UTIL_Logging.ExceptionLog exLog = new UTIL_Logging.ExceptionLog(ex, 'UdpateVehicleDetailsAfterResultBatch', 'UdpateVehicleDetailsAfterResult', '', UTIL_Logging.DEBUG_LEVEL_WARN);
            UTIL_Logging.logException(exLog);
        }
    }
    global void finish(Database.BatchableContext BC)
    { 
          System.debug('inside finish-->');
    }  
    global void execute(SchedulableContext scon) {
        ETI_UdpateVehicleDetailsAfterResultBatch UdpateVehicleDetails = new ETI_UdpateVehicleDetailsAfterResultBatch(null);
        Database.executeBatch(UdpateVehicleDetails,1);
    }
}