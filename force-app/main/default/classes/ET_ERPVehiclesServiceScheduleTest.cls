@isTest
public class ET_ERPVehiclesServiceScheduleTest {

    public static testmethod void testmethod1(){
         Test.StartTest();
         ET_ERPVehicle.XxetVehicleMasterDetMv testObj1 = new ET_ERPVehicle.XxetVehicleMasterDetMv();
         testObj1.internalNo='101';
         testObj1.vehMode=' ';
         testObj1.description=' ';
         testObj1.segActivityCenter=' ';
         testObj1.location=' ';
         testObj1.vehicleStatus=' ';
         testObj1.plateNumber=' ';
         testObj1.plateColour=' ';
         testObj1.plateType=' ';
         testObj1.plateIssue=' ';
         testObj1.registrationDate=Date.newInstance(2020, 12, 9);
         testObj1.regRenewalDate=Date.newInstance(2020, 12, 9);
         testObj1.mainType=' ';
         testObj1.subType=' ';
         testObj1.make=' ';
         testObj1.model=' ';
         testObj1.chassisNumber=' ';
         testObj1.engineNumber=' ';
         testObj1.contractNo=1234567890;
         List<ET_ERPVehicle.XxetVehicleMasterDetMv> testObj2 = new List<ET_ERPVehicle.XxetVehicleMasterDetMv>();
         testObj2.add(testObj1);
         test.setMock(WebServiceMock.class, new ET_ERPVehiclesServiceScheduleMock());
         ET_ERP_Vehicle__c testob = new ET_ERP_Vehicle__c();
         insert testob;
         ET_ERPVehiclesServiceSchedule obj = new ET_ERPVehiclesServiceSchedule();
         String sch = '0 0 23 * * ?'; 
         system.schedule('Test Territory Check', sch, obj);
         ET_ERPVehiclesServiceSchedule.doVehicleMapping(testObj2);
         Test.stopTest(); 
    }
}