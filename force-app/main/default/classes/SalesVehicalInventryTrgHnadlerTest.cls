@IsTest
public class SalesVehicalInventryTrgHnadlerTest {
  
    @IsTest
    static void testVehiclePriceChange() {
        ETM_Sales_Vehicle_Inventory__c vehicle = new ETM_Sales_Vehicle_Inventory__c();
        vehicle.Name = 'Test Vehicle';
        vehicle.ETM_Price__c = 10000;
        vehicle.ETM_Vehicle_Status__c='Contract Cancelled';
        insert vehicle;
        
       vehicle.ETM_Price__c = 20000;
       vehicle.ETM_Vehicle_Status__c='Ready for Photoshoot';
       update vehicle;
        
    }    
    

}