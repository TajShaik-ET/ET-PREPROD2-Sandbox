public class MOTO_GetVehicleDetailWrapper {

	public String Status;
	public VehicleCollection VehicleCollection;
    public class VehicleCollection {
		public List<XxetVehicleMasterDetailV> XxetVehicleMasterDetailV;
	}
	public class XxetVehicleMasterDetailV {
		public String internalNo;
		public String vehMode;
		public String fleetType;
		public String description;
		public String activityCenter;
		public String activityCenterCode;
		public String segActivityCenter;
		public String segActivityCenterCode;
		public Object sector;
		public String location;
		public Object parking;
		public Object workhopLocation;
		public String vehicleStatus;
		public String assetOpStatus;
		public Object usageType;
		public Object classification;
		public String plateNumber;
		public String plateColour;
		public String plateType;
		public String plateIssue;
		public Object registrationDate;
		public Object regRenewalDate;
		public Object assetType;
		public String manufaturerName;
		public Object mainType;
		public Object subType;
		public String make;
		public Object countryOfMake;
		public String model;
		public String family;
		public Object tyreType;
		public Object numberOfTyres;
		public Object tyrePressureInfo;
		public Object axleInfo;
		public Object batteryType;
		public Object numberOfBattery;
		public Object fuelType;
		public Object fuelTankCapacity;
		public Object manufacMileage;
		public Object actualMileage;
		public Object numberOfSeats;
		public Object acNonAc;
		public String chassisNumber;
		public String engineNumber;
		public Object engineCapacity;
		public Object numberOfCylinder;
		public Object vehicleColor;
		public Object meterMeasurements;
		public Object odometer;
		public Object familyDetails;
		public Object vehicleLife;
		public Object vehicleCategory;
		public Object transmissionType;
		public Object horsePower;
		public Object greenVehicle;
		public Object serialNumber;
		public Object crubWeight;
		public Object grossWeight;
		public String customerName;
		public String customerNumber;
		public String customerId;
		public Integer contractNo;
		public String oldInternalNo;
	}

	
	
	public static MOTO_GetVehicleDetailWrapper parse(String json) {
		return (MOTO_GetVehicleDetailWrapper) System.JSON.deserialize(json, MOTO_GetVehicleDetailWrapper.class);
	}
}