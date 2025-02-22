/*
* File Name:ET_ERPVehiclesServiceSchedule
* Author : Sagar Kambli
* CreatedDate :  20 May 20200
* Modification Purpose
* * 1. Sagar: Schedulable class to load all ERP Vehicles Values.
* * 2.
*/ 
global class ET_ERPVehiclesServiceSchedule implements Schedulable,Database.AllowsCallouts {
     
    
    public static ET_ERPVehicle.Output  vehicleResult {get;set;}
    
    global void execute(SchedulableContext SC) {
        Set<String> activityValues = new Set<String>();
        for(ERP_Vehicle_Activity_Setting__mdt activityMetadata: [SELECT Id, Activity_Name__c FROM ERP_Vehicle_Activity_Setting__mdt]){
            activityValues.add(activityMetadata.Activity_Name__c);
        }
        if(activityValues.size()>0){
            for(string activityType:activityValues){
                for(ERP_Vehicle_Mode_Setting__mdt vehicleMode : [SELECT Id, Label from ERP_Vehicle_Mode_Setting__mdt]){
                    if(activityType!=null && vehicleMode.Label!=null){
                        ETI_Batch_Vehicle_Service job = new ETI_Batch_Vehicle_Service(activityType,vehicleMode.Label);
                        Database.executeBatch(job,200);    
                    }
                } 
            }
        }   
    }
    
   
   //perform mapping for Vehicle Master
   public static List<ET_ERP_Vehicle__c> doVehicleMapping(List<ET_ERPVehicle.XxetVehicleMasterDetMv> vehicleData){
      List<ET_ERP_Vehicle__c> vehiclesToInsert = new List<ET_ERP_Vehicle__c>();
       if(vehicleData!=null && vehicleData.size() > 0){
           for(ET_ERPVehicle.XxetVehicleMasterDetMv row:vehicleData){
               ET_ERP_Vehicle__c vehicle = new ET_ERP_Vehicle__c();
               vehicle.Name = row.internalNo;
               vehicle.External_ID__c = row.internalNo;
               vehicle.ET_Vehicle_Mode__c=row.vehMode;
               //vehicle.ET_Fleet_Type__c=row.fleetType;
               vehicle.ET_Description__c=row.description;
               //vehicle.ET_Activity_Center__c=row.activityCenter;
               //vehicle.ET_Activity_Center_Code__c=row.activityCenterCode;
               vehicle.ET_Seg_Activity_Center__c=row.segActivityCenter;
               //vehicle.ET_segActivityCenterCode__c=row.segActivityCenterCode;
               //vehicle.ET_Sector__c=row.sector;
               vehicle.ET_Location__c=row.location;
               //vehicle.ET_Parking__c=row.parking;
               //vehicle.ET_Workhop_Location__c=row.workhopLocation;
               vehicle.ET_Vehicle_Status__c=row.vehicleStatus;
               //vehicle.ET_Asset_Op_Status__c=row.assetOpStatus;
               //vehicle.ET_Usage_Type__c=row.usageType;
               //vehicle.ET_Classification__c=row.classification;
               vehicle.ET_Plate_Number__c=row.plateNumber;
               vehicle.ET_Plate_Colour__c=row.plateColour;
               vehicle.ET_Plate_Type__c=row.plateType;
               vehicle.ET_Plate_Issue__c=row.plateIssue;
               //system.debug('registrationDate: '+row.registrationDate);
               if(row.registrationDate!=null){
                   String registrationDate = ''+row.registrationDate;  
                   vehicle.ET_Registration_Date__c = Datetime.valueOFGMT(registrationDate);
               }
               
               if(row.regRenewalDate!=null){
                   String regRenewalDate = ''+row.regRenewalDate;  
                   vehicle.ET_Registrration_Renewal_Date__c=Datetime.valueOFGMT(regRenewalDate);
               }

               //vehicle.ET_Asset_Type__c=row.assetType;
               //vehicle.ET_Manufacture_Name__c=row.manufaturerName;
               vehicle.ET_Vehicle_Type__c=row.mainType;
               vehicle.ET_Vehicle_SubType__c=row.subType;
               vehicle.ET_Make__c=row.make;
               //vehicle.ET_Vehicle_Make_Country__c=row.countryOfMake;
               vehicle.ET_Model__c=row.model;
               /*vehicle.ET_Family__c=row.family;
               vehicle.ET_Tyre_Type__c=row.tyreType;
               vehicle.ET_Number_Of_Tyres__c=row.numberOfTyres;
               vehicle.ET_Tyre_Pressure_Info__c=row.tyrePressureInfo;
               vehicle.ET_Axle_Info__c=row.axleInfo;
               vehicle.ET_Battery_Type__c=row.batteryType;
               vehicle.ET_Number_Of_Battery__c=row.numberOfBattery;
               vehicle.ET_Fuel_Type__c=row.fuelType;
               vehicle.ET_Fuel_Tank_Capacity__c=row.fuelTankCapacity;
               vehicle.ET_Manufacture_Mileage__c=row.manufacMileage;
               vehicle.ET_Actual_Mileage__c=row.actualMileage;
               vehicle.ET_No_Of_Seats__c=row.numberOfSeats;
               vehicle.ET_Type__c=row.acNonAc;*/
               vehicle.ET_Chassis_No__c=row.chassisNumber;
               vehicle.ET_Engine_Number__c=row.engineNumber;
               //vehicle.ET_Engine_Capacity__c=row.engineCapacity;
               //vehicle.ET_No_Of_Cylinder__c=row.numberOfCylinder;
               //vehicle.ET_Vehicle_Color__c=row.vehicleColor;
               //vehicle.et=row.meterMeasurements;
               //vehicle.et=row.odometer;
               /*vehicle.ET_Family_Details__c=row.familyDetails;
               vehicle.ET_Vehicle_Life__c=row.vehicleLife;
               vehicle.ET_Vehicle_Category__c=row.vehicleCategory;
               vehicle.ET_Transmission_Type__c=row.transmissionType;
               vehicle.ET_Horse_Power__c=row.horsePower;
               vehicle.ET_Green_Vehicle__c=row.greenVehicle;
               vehicle.ET_Serial_Number__c=row.serialNumber;
               vehicle.ET_Crub_Weight__c=Decimal.valueOf(row.crubWeight);
               vehicle.ET_Gross_Weight__c=Decimal.valueOf(row.grossWeight);
               vehicle.ET_Customer_Name__c=row.customerName;*/
               vehicle.ET_Contract_No__c=row.contractNo;               
               vehiclesToInsert.add(vehicle);
           }
       }
      return vehiclesToInsert;
   }
    
}