@isTest
public class ETM_testDrive_trigger_Test {
    
    @isTest
    static void testDriveTriggerMethod() { 
        
        Lead ld = new Lead();
        ld.LastName = 'LastName';
        ld.Company = 'testCompany';
        ld.Phone = '12345678';
        ld.MobilePhone = '987654321';
        ld.Email = 'testEmail@123.com';
        ld.ETSALES_Budget__c   = 123456798;
        ld.ETSALES_Lead_Rating__c  = 'Hot';
        insert ld;
        Test.startTest();
        ETM_Sales_Vehicle_Inventory__c vehInv = new ETM_Sales_Vehicle_Inventory__c(Name='Test Vehicle',ETM_Vehicle_No__c='12345',ETM_Plate_No__c='123',ETM_Chassis_No__c='321');
        insert vehInv;
        ETM_Vehicle_Test_Drive__c vht = new ETM_Vehicle_Test_Drive__c(ETM_Vehicle_No__c=vehInv.Id,ETM_Status__c='Initiated',ETM_Lead__c=ld.Id);
        insert vht;
        vht.ETM_Status__c='Selected'; 
        update vht;
        Test.stopTest();
    }
    
}