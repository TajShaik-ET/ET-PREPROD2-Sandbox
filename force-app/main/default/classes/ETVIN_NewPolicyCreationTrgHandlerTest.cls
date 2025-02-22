@isTest
public class ETVIN_NewPolicyCreationTrgHandlerTest {
    @isTest static void testCreateNewVehPolicy() {
        // Prepare test data
        List<Vehicle_Master__c> vehicles = new List<Vehicle_Master__c>();
        Vehicle_Master__c vm1 = new Vehicle_Master__c(TC_Number__c = 001, Amount__c = 10000, Internal_No__c='90');
        insert vm1; // Assuming DML is needed here to provide an ID
        
        vehicles.add(vm1);
        
        // Test new policy creation
        Test.startTest();
        ETVIN_NewPolicyCreationTrgHandler.createNewVehPolicy(vehicles);
        ETVIN_NewPolicyCreationTrgHandler.processVehicle(vm1);
        //ETVIN_NewPolicyCreationTrgHandler.updateExistingInsurance(vm1);
        
        Test.stopTest();
        
    }
    
    @isTest static void testUpdateExistingInsurance() {
        ETSALES_Location__c lo = new ETSALES_Location__c();
        lo.Name ='test';
        lo.Location_Code__c='123';
        lo.GL_Zone__c ='Zone A';
        insert lo;
        
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Police';
        ve.Activity_Center_code__c='123';
        ve.Department_Code__c = '123';
        ve.Project_Code__c='123';
        ve.Location_Code__c='123';
        ve.Activity_Center__c='Police';
        
        
        insert ve;
        Vehicle_Master__c ve1 =  new Vehicle_Master__c();
        ve1.name = 'B0017298';
        ve1.Internal_No__c = 'B0017298';
        ve1.Plate_Type__c = 'Police';
        ve1.Activity_Center_code__c='123';
        ve1.Department_Code__c = '123';
        ve1.Project_Code__c='123';
        ve1.Location_Code__c='123';
        ve1.Activity_Center__c='Dubai';
        
        
        insert ve1;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name=:System.Label.VIN_ZoneProfileName]; 
        User u = new User(Alias = 'standt', Email='standaxne2256@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, ETSALES_Employee_Zone__c='Zone A',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standaxne2256@testorg.com');
        
        System.runAs(u) {
            Account acc = new Account();
            acc.Name = 'test';
            acc.ETSALES_TaxRegistrationNo__c='234333333333333';
            insert acc;
            
            Veh_Default_Insurance_partner__c veh = new Veh_Default_Insurance_partner__c();
            veh.Name ='tet';
            veh.Account_ID__c = acc.Id;            
            insert veh;
            
            ETVIN_Insurance_Policy_Numbers__c insPolicyNum= new ETVIN_Insurance_Policy_Numbers__c();
            insPolicyNum.Name='009128TT';
            insPolicyNum.Activity_Center__c = 'Police';
            insPolicyNum.Active__c=true;
            insert insPolicyNum;
            ETVIN_Insurance_Policy_Numbers__c insPolicyNum1= new ETVIN_Insurance_Policy_Numbers__c();
            insPolicyNum1.Name='009128TT';
            insPolicyNum1.Activity_Center__c = 'Dubai';
            insPolicyNum1.Active__c=true;
            insert insPolicyNum1;
            
            ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
            etv.Vehicle__c = ve.Id;
            etv.ETVIN_Insurance_Company__c= acc.id;
            etv.ETVIN_Insurance_Status__c = 'Active';
            etv.ETVIN_Request_Status__c  = 'New';
            
            insert etv;
            ETVIN_Vehicle_Insurance__c etv1 = new ETVIN_Vehicle_Insurance__c();
            etv1.Vehicle__c = ve1.Id;
            etv1.ETVIN_Insurance_Company__c= acc.id;
            etv1.ETVIN_Insurance_Status__c = 'Active';
            etv1.ETVIN_Request_Status__c  = 'New';
            
            insert etv1;
            
            // Change the TC_Number__c to simulate an update scenario
            ve.TC_Number__c = 002;
            List<Vehicle_Master__c> updatedVehicles = new List<Vehicle_Master__c>{ve};
                
                // Invoke the handler for updated records
                Test.startTest();
            ETVIN_NewPolicyCreationTrgHandler.handleAfterUpdate(updatedVehicles, new Map<Id, Vehicle_Master__c>{ve.Id => ve});
            ETVIN_NewPolicyCreationTrgHandler.processVehicle(ve);
            //ETVIN_NewPolicyCreationTrgHandler.updateExistingInsurance(ve);
            Test.stopTest();
        }
    }
    
    
    
    
}