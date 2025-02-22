@isTest
public class ET_VehicleTestClass {
    public static testmethod void testVehicleService(){
        test.startTest();
        ET_VehicleInspectResultWebservice.utilityMethod();
        //ET_ValidateVehicleInfo.utilityMethod();
        //ET_ValidateVehicleInfoService.utilityMethod();
        List<ETI_Service_Line_Item__c> vItem = [SELECT Id,Booking__c,Test_Result__c,Result_Date__c FROM ETI_Service_Line_Item__c limit 1];
        update vItem;
        test.stopTest();
    }

}