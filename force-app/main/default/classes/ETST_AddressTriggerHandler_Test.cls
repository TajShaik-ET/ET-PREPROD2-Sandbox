@isTest
public class ETST_AddressTriggerHandler_Test {
    
    
    public static testMethod void  updatePrimaryAddressForAccountTest(){
        System.Test.startTest();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com');
        insert acc;
        
        ETST_Address__c etst = new ETST_Address__c();
        etst.account__c = acc.id;
        etst.ET_Line_1__c = 'Test-line';
        etst.ET_Country__c = 'AE';
        etst.ET_City__c = 'Hyderabad';
        etst.ET_Line_2__c = '15-45,Hitec city';
        etst.ET_Address_Type__c = 'SHIP_TO';
        etst.ET_Is_Primary__c = true;
        insert etst;
        
        delete etst;
        
        System.Test.stopTest();
    }
    
    public static testMethod void  updatePrimaryAddressForAccountOnDeleteTest(){
        System.Test.startTest();
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person (B2C)').getRecordTypeId();
        Account acc = new Account(RecordTypeId=devRecordTypeId,FirstName = 'Test',LastName = 'Test',PersonEmail='test@test.com');
        insert acc;
        
        
        ETST_Address__c etst1 = new ETST_Address__c();
        etst1.account__c = acc.id;
        etst1.ET_Line_1__c = 'Test-line';
        etst1.ET_Country__c = 'AE';
        etst1.ET_City__c = 'Hyderabad';
        etst1.ET_Line_2__c = '15-45,Hitec city';
        etst1.ET_Address_Type__c = 'BILL_TO';
        etst1.ET_Is_Primary__c = true;
        insert etst1;
        
        delete etst1;
        
        System.Test.stopTest();
    }
    
    
}