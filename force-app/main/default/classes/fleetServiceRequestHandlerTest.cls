@isTest
public class fleetServiceRequestHandlerTest {
    
    private static testmethod void createFleetReq(){
        Test.setMock(HttpCalloutMock.class, new Oracle_Integration_Mock());
        
         Account acc2 = new Account();
        acc2.RecordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('ETSALES_B2B_Account').getRecordTypeId();
        acc2.Name='TestAcc24232';
        acc2.phone= '01123353';
        acc2.AccountNumber ='12124';
        insert acc2;  
        CICO_Workshop_Location__c wl = new CICO_Workshop_Location__c();
        wl.name = 'test workshop';
        wl.Location_Code__c ='XYZ-124';
        insert wl;
        
        ET_Customer_Vehicle__c  cv = new ET_Customer_Vehicle__c ();
        cv.Internal_No__c='B00123456';
        insert cv;
        
        Fleet_Service_Request__c fsr = new Fleet_Service_Request__c();
        fsr.Account__c = acc2.Id;
        fsr.Customer_Vehicle__c=cv.Id;
        fsr.Odometer_Km__c =2333;
        fsr.Description__c='test';
        fsr.Workshop_Location__c =wl.Id;
        test.startTest();
        insert fsr;
        test.stopTest();
    }

}