@isTest
public class ETI_FeedBackPageControllerTest {
    private static testmethod void testmethodInspection(){
        
        ET_Customer_Vehicle__c etcv1 = new ET_Customer_Vehicle__c();
        etcv1.OwnerId = userinfo.getUserId();
        etcv1.Chassis_No__c = 'D032B5GC000790';
        etcv1.Plate_No__c = '';
        etcv1.status__c = 'Active';
        etcv1.Registration_Type__c ='Registered';
            
        insert etcv1;
        ETI_FeedBackPageController.getVehIdFrmChassisNo('D032B5GC000790'); 
        ETI_FeedBackPageController.getRecordTypeId('Case','Vehicle_Inspection_Services'); 
        ETI_FeedBackPageController.getUserVehicles(UserInfo.getUserId());
        ETI_FeedBackPageController.getCaseTypes('Vehicle Inspection Services');
        ETI_B2B_FeedBackPageController.getVehIdFrmChassisNo('D032B5GC000790'); 
        ETI_B2B_FeedBackPageController.getRecordTypeId('Case','Vehicle_Inspection_Services'); 
        ETI_B2B_FeedBackPageController.getUserVehicles(UserInfo.getUserId());
        ETI_B2B_FeedBackPageController.getCaseTypes('Vehicle Inspection Services');
    }
}