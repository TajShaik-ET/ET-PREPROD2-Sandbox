@isTest
public class ETVIN_CompInsuredCalHandlerTest {

    private static testmethod void calculations(){
        
        Vehicle_Master__c ve =  new Vehicle_Master__c();
        ve.name = 'B0017298';
        ve.Internal_No__c = 'B0017298';
        ve.Plate_Type__c = 'Private';
        ve.Purchase_Date__c =Date.newInstance(2019, 11, 23);
        ve.Purchase_Value__c =40000;
        ve.Vehicle_Type_Desc__c= 'test';
        insert ve;
        
        Insurance_Rule_Master__c ir = new Insurance_Rule_Master__c();
        ir.Name ='test';
        ir.Insurance_Floor_Value__c = 2000;
        ir.Depreciation_Years__c = 4;
        ir.Type_Description__c='test';
        ir.Total_Loss__c = 2;
        insert ir;
        
        Account acc = new Account();
        //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Insurance_Partner').getRecordTypeId();
        acc.Name = 'test';
        
        insert acc;
        
        ETIN_Claim__c ec = new ETIN_Claim__c();
        ec.Claim_Amount__c = 200;
        ec.ETIN_Insurance_Partner__c = acc.Id;
        ec.ETIN_Claim_Status__c = 'New';
        ec.Vehicle_Master__c = ve.Id;
        ec.Accident_Date__c =  Date.newInstance(2020, 11, 23);
        ec.RecordTypeId =  Schema.SObjectType.ETIN_Claim__c.getRecordTypeInfosByDeveloperName().get('Vehicle_Insurance').getRecordTypeId();
        
       
        insert ec;        
    }
}