@isTest
private class ETVIN_VehicleInsuranceHandlerTest {
    public static testmethod void  test1(){
        
        
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
            
            Test.startTest();
            
            // Call the method to be tested
            ETVIN_VehicleInsuranceHandler.handleInsuranceRecords(new List<ETVIN_Vehicle_Insurance__c>{etv}, null);
             ETVIN_VehicleInsuranceHandler.handleInsuranceRecords(new List<ETVIN_Vehicle_Insurance__c>{etv1}, null);
            
            Test.stopTest();
            
        }
        
    }
    
    
}