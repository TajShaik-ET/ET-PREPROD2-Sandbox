@isTest
public class ETVIN_sendEmailZoneCordTest {
    
    public static testmethod void  sendEmailNotif(){
        
        
         ETSALES_Location__c lo = new ETSALES_Location__c();
        lo.Name ='test';
        lo.Location_Code__c='123';
        lo.GL_Zone__c ='Zone A';
        insert lo;
        
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Private';
        ve.Activity_Center_code__c='123';
        ve.Department_Code__c = '123';
        ve.Project_Code__c='123';
        ve.Location_Code__c='123';
       
              
        insert ve;
        
               
         Profile p = [SELECT Id FROM Profile WHERE Name=:System.Label.VIN_ZoneProfileName]; 
        User u = new User(Alias = 'standt', Email='standaxne2256@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, ETSALES_Employee_Zone__c='Zone A',
            TimeZoneSidKey='America/Los_Angeles', UserName='standaxne2256@testorg.com');

        System.runAs(u) {
         Account acc = new Account();
        acc.Name = 'test';
        insert acc;
          
        Veh_Default_Insurance_partner__c veh = new Veh_Default_Insurance_partner__c();
        veh.Name ='tet';
        veh.Account_ID__c = acc.Id;            
        insert veh;
          
        ETVIN_Vehicle_Insurance__c etv = new ETVIN_Vehicle_Insurance__c();
        etv.Vehicle__c = ve.Id;
        etv.ETVIN_Insurance_Company__c= acc.id;
        etv.ETVIN_Insurance_Status__c = 'Active';
        etv.ETVIN_Request_Status__c  = 'New';
        
        insert etv;
        
          
        }
        
    }

}