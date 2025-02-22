/* Class : ETM_controller
   Description : Controller class used for ET Moto
				 1 All Vehicles from inventory are displayed in 'select Car' Page with filter Parameters to search for any desired car.
				 2 Selected Cars can be added as Test Drives in Lead.
   Test Class  :ETM_controller_Test
   Component used to show Vehicles : Emoto_Select_Car.cmp
*/


public class ETM_controller {
    /* Method     : queryVehicleInfo
	   Desription : To query all Vehicle info.
	*/	
    
    @AuraEnabled
    public static List<vehicleWrapper> queryVehicleInfo(List<String> carTypes, List<String> carMakes, List<String> carModels ){
        List<ETM_Sales_Vehicle_Inventory__c> vehcleList = new List<ETM_Sales_Vehicle_Inventory__c>();
        List<vehicleWrapper> vehcleListWr = new List<vehicleWrapper>();
        String queryString;
        List<id> selectedInventryids = new List<id>();
        for(ETM_Vehicle_Test_Drive__c etmVeh : [SELECT id, ETM_Vehicle_No__c FROM ETM_Vehicle_Test_Drive__c WHERE ETM_Status__c = 'Selected']){
            selectedInventryids.add(etmVeh.ETM_Vehicle_No__c);
        }
        queryString = 'SELECT Id,Name,ETM_Vehicle_No__c,ETM_Vehicle_Status__c,ETM_Vehicle_Type__c,ETM_Price__c,ETM_Warranty_Km__c,ETM_Warranty_Period__c,ETM_Car_Image__c,';
        queryString += 'ETM_Vehicle_Description__c,ETM_Plate_No__c,ETM_Make__c,ETM_KM__c,ETM_Installation_Charges__c, ETM_Model__c,ETM_Family__c';
        queryString += ' FROM ETM_Sales_Vehicle_Inventory__c where createdDate != null'; // where createdDate != null --> this one is default where and all filter conditions comes in AND conditions... 
       
        if(selectedInventryids != null && selectedInventryids.size() > 0){
            queryString += ' AND id not in :selectedInventryids';  
        }
        if(carTypes != null && carTypes.size() > 0){
            queryString += ' AND ETM_Vehicle_Type__c in :carTypes';  
        }
        if(carMakes != null && carMakes.size() > 0){
            queryString += ' AND ETM_Make__c in :carMakes';  
        }
        if(carModels != null && carModels.size() > 0){
            queryString += ' AND ETM_Model__c in :carModels';  
        }
        
        
        vehcleList = Database.query(queryString);
        
        if(vehcleList != null && vehcleList.size() > 0){
            for(ETM_Sales_Vehicle_Inventory__c veh :vehcleList ){
                vehicleWrapper vw = new vehicleWrapper();
                vw.Id = veh.id;
                vw.VehicleName = veh.Name;
                vw.VehicleNo = veh.ETM_Vehicle_No__c;
                vw.Family = veh.ETM_Family__c;
                vw.VehicleModel = veh.ETM_Model__c;
                vw.VehicleImage = veh.ETM_Car_Image__c;
                vw.VehicleStatus = veh.ETM_Vehicle_Status__c;
                vw.VehicleType = veh.ETM_Vehicle_Type__c;
                vw.WarrantyKm = veh.ETM_Warranty_Km__c;
                vw.WarrantyPeriod = veh.ETM_Warranty_Period__c;
                vw.VehicleDescription = veh.ETM_Vehicle_Description__c;
                vw.PlateNo = veh.ETM_Plate_No__c;
                vw.Price = veh.ETM_Price__c;
                vw.Make = veh.ETM_Make__c;
                vw.KM = veh.ETM_KM__c;
                vw.InstallationCharges = veh.ETM_Installation_Charges__c;
                vw.isChecked = false;
                vehcleListWr.add(vw);
            }
        }
        system.debug('Vehicles = '+ JSON.serializePretty(vehcleListWr));
        return vehcleListWr;
        
    }
    
    /* Method     : queryVehFilters
	   Desription : To query Vehcile Filters..
	*/	
    
    @AuraEnabled
    public static vehFiltersWrapper queryVehFilters(){
        List<ETM_Sales_Vehicle_Inventory__c> vehclesList = new List<ETM_Sales_Vehicle_Inventory__c>();
        List<String> vehTypes = new List<String>();
        List<String> vehMakes = new List<String>();
        List<String> vehFamilies = new List<String>();
        List<String> vehModels = new List<String>(); 
        List<String> vehNumbers = new List<String>(); 
        Map<String , List<String>> vehTyeMakeMap = new Map<String , List<String>>();
        Map<String , List<String>> vehMakeFamilyMap = new Map<String , List<String>>();
        for(ETM_Sales_Vehicle_Inventory__c veh : [select id,ETM_Vehicle_Type__c , ETM_Model__c, 
                                                  ETM_KM__c,ETM_Make__c, ETM_Family__c,ETM_Vehicle_No__c
                                                  FROM
                                                  ETM_Sales_Vehicle_Inventory__c])
        {
            vehTypes.add(veh.ETM_Vehicle_Type__c);
            vehMakes.add(veh.ETM_Make__c);
            vehModels.add(veh.ETM_Model__c); 
            vehFamilies.add(veh.ETM_Family__c);
            vehNumbers.add(veh.ETM_Vehicle_No__c);
            if(vehTyeMakeMap.containsKey(veh.ETM_Vehicle_Type__c)){
                if(!vehTyeMakeMap.get(veh.ETM_Vehicle_Type__c).contains(veh.ETM_Make__c)){
                    vehTyeMakeMap.get(veh.ETM_Vehicle_Type__c).add(veh.ETM_Make__c);
                }
            }
            else{
                vehTyeMakeMap.put(veh.ETM_Vehicle_Type__c, new List<String>{veh.ETM_Make__c});
            }
            
            if(vehMakeFamilyMap.containsKey(veh.ETM_Make__c)){
                if(!vehMakeFamilyMap.get(veh.ETM_Make__c).contains(veh.ETM_Family__c)){
                    vehMakeFamilyMap.get(veh.ETM_Make__c).add(veh.ETM_Family__c);
                }
                
            }
            else{
                vehMakeFamilyMap.put(veh.ETM_Make__c, new List<String>{veh.ETM_Family__c});
            }
        }
        vehFiltersWrapper vWr = new vehFiltersWrapper();
        vWr.vehTypes =new List<String>(new Set<String>(vehTypes));
        vWr.vehMakes = new List<String>(new Set<String>(vehMakes));
        vWr.vehModels = new List<String>(new Set<String>(vehModels));
        vWr.vehFamilies = new List<String>(new Set<String>(vehFamilies));
        vWr.vehNumbers = new List<String>(new Set<String>(vehNumbers)); 
        vWr.vehTyeMakeMap = vehTyeMakeMap;
        vWr.vehMakeFamilyMap = vehMakeFamilyMap;
        return vWr;
    }
    
    public class vehFiltersWrapper{
        @AuraEnabled public List<String> vehTypes;
        @AuraEnabled public List<String> vehMakes;
        @AuraEnabled public List<String> vehModels;
        @AuraEnabled public List<String> vehFamilies;
        @AuraEnabled public List<String> vehNumbers;
        //Key = Type and Values = Makes
        @AuraEnabled public Map<String , List<String>> vehTyeMakeMap; 
        //Key = Make and Values = Families
        @AuraEnabled public Map<String , List<String>> vehMakeFamilyMap; 
    }
    
    
    public class vehicleWrapper{
        @AuraEnabled public string Id;
        @AuraEnabled public string VehicleName;
        @AuraEnabled public string VehicleNo;
        @AuraEnabled public string VehicleModel;
        @AuraEnabled public string VehicleImage;
        @AuraEnabled public string Family;
        @AuraEnabled public string VehicleStatus;
        @AuraEnabled public string VehicleType;
        @AuraEnabled public string WarrantyKm;
        @AuraEnabled public string WarrantyPeriod;
        @AuraEnabled public string VehicleDescription;
        @AuraEnabled public string PlateNo;
        @AuraEnabled public decimal Price;
        @AuraEnabled public string Make;
        @AuraEnabled public string KM;
        @AuraEnabled public decimal InstallationCharges;
        @AuraEnabled public boolean isChecked;
        
    }
    /* Method : createTestDrives
	  Description : To create the Test drives records to the Lead
	*/
    @AuraEnabled
    public static boolean createTestDrives(String leadId, String testDrveRecs){
        String errStr;
        boolean resp;
        Savepoint sp = Database.setSavepoint();  
        List<vehicleWrapper> selVehicles = new List<vehicleWrapper>();
        List<ETM_Vehicle_Test_Drive__c> testDrivesList = new List<ETM_Vehicle_Test_Drive__c>();
        if(testDrveRecs != null && testDrveRecs !=''){
            selVehicles =  (List<vehicleWrapper>) JSON.deserialize(testDrveRecs, List<vehicleWrapper>.class);
        }
        
        if(selVehicles != null && selVehicles.size() > 0){
            for(vehicleWrapper vw : selVehicles){
                ETM_Vehicle_Test_Drive__c vTest = new ETM_Vehicle_Test_Drive__c();
                vTest.ETM_Vehicle_No__c = vw.id;
                vTest.ETM_Lead__c = leadId;
                vTest.ETM_Status__c = 'Initiated';
                if(vw.id != null){
                    testDrivesList.add(vTest);
                }
            }
        }
        
        if(testDrivesList!= null && testDrivesList.size() > 0){
            try{
                database.insert(testDrivesList,false);
                resp = true;
            }
            catch(Exception e){
                Database.rollback(sp);
                errStr = JSON.serialize(ETM_Controller.buildErrorResponse('createTestDrives', e.getMessage(), e.getStackTraceString()));
                AuraHandledException ahe = new AuraHandledException(errStr);
                ahe.setMessage(errStr);
                resp = false;
                throw ahe;
            }
        } 
        
        return resp; 
    }
    
    
    @TestVisible
    private static Map<String, String> buildErrorResponse(String source, String errorMessage, String stackTrace) {
        Map<String, String> errorResponse = new Map<String, String>();
        
        errorResponse.put('SOURCE', source);
        errorResponse.put('MESSAGE', errorMessage);
        errorResponse.put('STACKTRACE', stackTrace);
        
        return errorResponse;
    }  
    
}