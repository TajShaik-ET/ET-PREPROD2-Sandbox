@isTest(seeAllData=true)
public class simplyBookIntegrationHandlerTest {
     
    @isTest
    private static void createBooking(){
        Test.setMock(HttpCalloutMock.class, new simplybook_MockHttpResponse());
       
        Vehicle_Brand_Master__c vm = new Vehicle_Brand_Master__c();
        vm.Name='Mercedes';
        insert vm;
        Vehicle_Model_Master__c mo = new Vehicle_Model_Master__c();
        mo.name='Eclass';
        mo.Vehicle_Brand__c=vm.id;
        insert mo;
        Lead le = new Lead();
        le.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Moto_Service_Center_Body_Shop').getRecordTypeId();
        le.firstName='test';
        le.lastName ='test'+string.valueOf(system.today());
        le.Email='test@gmail.com';
        le.MobilePhone='558656023';
        le.Type_of_Services__c='Accident Repair';
        le.ETM_Vehicle_Model__c='2015';
        le.Appointment_Date__c = system.today();
        le.Description ='test';
        le.List_of_Required_Services__c = 'Battery services';
        le.Service_Cateogry__c='Bodyshop';
        le.Preferred_Location__c='Emirates Moto Al Quoz';
        le.Vehicle_Brand__c=vm.Id;
        le.Moto_Vehicle_Model__c=mo.id;
        insert le;
        lead leadInfo = [select id,Owner.Name,Vehicle_Brand__c,Vehicle_Plate_Number__c,Vehicle_Chassis__c,Vehicle_Brand__r.Name,Type_of_Services__c,ETM_Vehicle_Model__c,Moto_Vehicle_Model__c,Moto_Vehicle_Model__r.Name,FirstName,LastName,Name,Email,MobilePhone,Appointment_Date__c,Description,Campaign__r.Name,Campaign__c,Campaign__r.Simplybook_Category_Id__c,Campaign__r.Simplybook_Service_Id__c,List_of_Required_Services__c,Service_Cateogry__c,Preferred_Location__c from Lead where Id=:le.Id];
         Test.StartTest();
        //simplyBookIntegrationHandler.getAccessToken();
        simplyBookIntegrationHandler.createSimplybookRequest(leadInfo);
        simplyBookIntegrationHandler.createClient('fname','Lname','3244324343');
        //simplyBookIntegrationHandler.checkAndGetClientId('fname','Lname','3244324343');
        //string jsonstr = '{"data":[{"can_be_edited": true,"id": 494,"name": "CRM Test User","email": "testuser@gmail.com","phone": "9715586560234","address1": null,"address2": null,"city": null,"zip": null,"country_id": null,"state_id": null,"full_address": "" }],"metadata":{"items_count": 3,"pages_count": 1,"page": 1, "on_page": 10,"alphabet_index": [{"letter": "...","index": 0}]}}';
       // simplyBook_getClientInfoWrapper dataInfo = simplyBook_getClientInfoWrapper.parse(jsonstr);
        test.stoptest();
        
    }
    
}