@isTest
public class ETM_controller_Test {
    
    @isTest
    static void testETMController(){
        
        Lead ld = new Lead();
        ld.LastName = 'LastName';
        ld.Company = 'testCompany';
        ld.Phone = '12345678';
        ld.MobilePhone = '987654321';
        ld.Email = 'testEmail@123.com';
        ld.ETSALES_Budget__c   = 123456798;
        ld.ETSALES_Lead_Rating__c  = 'Hot';
        insert ld;
        
        ETM_Sales_Vehicle_Inventory__c vehInv = new ETM_Sales_Vehicle_Inventory__c(Name='Test Vehicle',ETM_Vehicle_No__c='12345',ETM_Vehicle_Type__c='SUV',ETM_Model__c='2020',
                                                                                   ETM_Make__c='MITSUBISHI',ETM_Plate_No__c='123',ETM_Chassis_No__c='321');
        insert vehInv;
        List<ETM_controller.vehicleWrapper> vhWrpList = new List<ETM_controller.vehicleWrapper>();
        ETM_controller.vehicleWrapper vhWrp  = new ETM_controller.vehicleWrapper();
        vhWrp.Id=ld.Id;
        vhWrp.VehicleNo=vehInv.Id;
        vhWrpList.add(vhWrp);
        String JSONString = JSON.serialize(vhWrpList);
        system.debug('JSONString '+JSONString);
        
        Test.startTest();
        List<String> carTypes = new List<String> {'SUV'};
        List<String> carMakes = new List<String> {'MITSUBISHI'};
        List<String> carModels = new List<String> {'2020'};
        ETM_controller.queryVehicleInfo(carTypes, carMakes, carModels);
        ETM_controller.queryVehFilters();
        ETM_controller.buildErrorResponse('source', 'errorMessage', 'stackTrace');
        ETM_controller.createTestDrives(ld.Id, JSONString);
        Test.stopTest();
    }
}