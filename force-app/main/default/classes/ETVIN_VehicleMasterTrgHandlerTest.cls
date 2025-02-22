@isTest(seeAllData=true)
public class ETVIN_VehicleMasterTrgHandlerTest {
    private static testmethod void vehicleMaster(){
    
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Private';
        ve.Activity_Center_code__c='123';
        ve.Department_Code__c = '123';
        ve.Project_Code__c='123';
        ve.Location_Code__c='123';
              
        insert ve;

        GL_Activity__c ac = new GL_Activity__c();
        ac.Name ='test';
        ac.GL_Activity_Code__c = '123';
        insert ac;
        ETSALES_Department__c de = new ETSALES_Department__c();
        de.Name = 'test';
        de.Department_Code__c = '123';
        insert de;
        ETSALES_Location__c lo = new ETSALES_Location__c();
        lo.Name ='test';
        lo.Location_Code__c='123';
        lo.GL_Zone__c ='Zone A';
        insert lo;
        GL_Project__c pr = new GL_Project__c();
        pr.Name = 'test';
        pr.Project_Code__c='123';
        insert pr;
    }       
    
}