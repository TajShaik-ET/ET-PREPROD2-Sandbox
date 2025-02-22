@isTest(seeAlldata=false)
public class ET_VehicleControllerTest {
  public static testMethod void getPicklistvaluesTestMethod(){
      test.startTest();
      ET_Vehicle_Predefined_Other_Cost_Master__c vehiclePredefinedOtherCostMaster = new ET_Vehicle_Predefined_Other_Cost_Master__c(isActive__c=true,Name = 'test');
      insert vehiclePredefinedOtherCostMaster;
      ET_Vehicle_Master__c testData = new ET_Vehicle_Master__c(ET_Manufacture_Year__c =2020,ET_Vehicle_Make__c='BMW',ET_Specs__c='Car',ET_Model__c = 'BMW X10',ET_Number_of_seats__c=5, ET_Vehicle_Latest_New_Purchase_Price__c=1000000);
      insert testData;
      ET_Vehicle_Model_Base_Year__c vmby = new ET_Vehicle_Model_Base_Year__c(Name = 'Base Model Year',ET_Year_Value__c = 2000);
      insert vmby;
      ET_Service_Contract_Years__c scy = new ET_Service_Contract_Years__c(Name = 'Pricing Contract Years',ET_Contract_Years__c = '1 Yr,2 Yrs,3 Yrs,4 Yrs,5 Yrs,6 Yrs,7 Yrs,8 Yrs,Multiple');
      insert scy;
      //ET_VehicleController.getPicklistvalues('ET_Special_Workforce_Requirement__c',new List<String>{'ET_Specific_Leave_Plan__c'});
      ET_VehicleController.getPicklistvalues('Vehicle__c',new List<String>{'ET_Vehicle_Type__c'});
      ET_VehicleController.getPicklistvalues('Vehicle__c',new List<String>{'ET_Vehicle_Fuel__c'});
      ET_VehicleController.getPicklistvalues('Vehicle__c',new List<String>{'ET_Vehicle_Condition__c'});
      ET_VehicleController.getPicklistvalues('Vehicle__c',new List<String>{'ET_Vehicle_category__c'});
      ET_VehicleController.getPicklistvalues('Vehicle__c',new List<String>{'ET_Specific_requirements__c'});
      ET_VehicleController.getPicklistvalues('Vehicle__c',new List<String>{'ET_Pricing_Type__c'});
      //ET_VehicleController.ET_getVehicleModelYears('BMW','Car','BMW X10');
      ET_VehicleController.ET_getVehicleModels('BMW');
      ET_VehicleController.ET_getVehicleSpecs('BMW','BMW X10');
      ET_VehicleController.getFuelTypes();
      ET_VehicleController.getVehicleMasterData('BMW','test',True,'test','test');
      ET_VehicleController.ET_getvehicleSubTypes('BMW X10');
      ET_VehicleController.ET_getvehicleFuelTypes('vehicleMake', 'model' ,'vehicleSpec','vehicleSubType');
      //    ET_VehicleController.testCoverageMethod();
      test.stopTest();
    }
}