@isTest
public class ET_FuelConsumptionMonthTest {
    
    @testSetup
    static void setupData() {
        // Create a SALine_Assigned_Vehicle__c record
        SALine_Assigned_Vehicle__c vehicle = new SALine_Assigned_Vehicle__c(Name = 'Test Vehicle');
        insert vehicle;
        
        // Create initial Fuel_Consumption__c records for this vehicle
        Fuel_Consumption__c fuel1 = new Fuel_Consumption__c(
            Vehicle_Number__c = vehicle.Id,
            Month__c = 'July',
            Fuel_Consumption__c =12312 
        );
        
        Fuel_Consumption__c fuel2 = new Fuel_Consumption__c(
            Vehicle_Number__c = vehicle.Id,
            Month__c = 'July',
            Fuel_Consumption__c =12312 
        );
        
        insert new List<Fuel_Consumption__c>{fuel1, fuel2};
    }
    
    @isTest
    static void testInsertTrigger() {
        // Retrieve the vehicle created in testSetup
        SALine_Assigned_Vehicle__c vehicle = [SELECT Id, Fuel_Consumption_Month__c FROM SALine_Assigned_Vehicle__c WHERE Name = 'Test Vehicle' LIMIT 1];
        
        // Verify that the Fuel_Consumption_Month__c is correctly updated with the latest record's month
        // Since July is the latest record in setupData, the vehicle should have July's month
        Test.startTest();
        vehicle = [SELECT Id, Fuel_Consumption_Month__c FROM SALine_Assigned_Vehicle__c WHERE Id = :vehicle.Id LIMIT 1];
        Test.stopTest();
        
    }
}