@isTest
public class ETC_UpdateItineraryDetails_Test {

    public static testmethod void testData(){
        
        ET_Service_Request__c req = new ET_Service_Request__c();
        req.ETCAR_Request_Type__c = 'Online';
        insert req;
        
        ETCAR_Service_Request_Line_Item__c vehBkng = new ETCAR_Service_Request_Line_Item__c();
        vehBkng.ETST_Pick_Up_From__c = 'Dubai';
        vehBkng.ETST_Service_Type__c = 'One Way';
        vehBkng.ETCAR_Service_Request__c = req.Id;
        insert vehBkng;
      
        Test.startTest();
        ETC_UpdateItineraryDetails.getAddressDetailsByPlaceId('Dubai');
        ETC_UpdateItineraryDetails.getAddressSet('Dubai');
        ETC_UpdateItineraryDetails.getRequestDetials(vehBkng.Id);
        Test.stopTest();
    }
}