/*
* File Name:ET_IOTLocations
* Author : Sagar Kambli
* CreatedDate : 19 May 2020
* Modification Purpose
* * 1. Sagar: IOT Response wrapper 
* * 2.
*/ 
public class ET_IOTLocations {

	public class UniqueId {
		public String name;
		public String description;
		public String baseType;
		public Integer ordinal;
		public Aspects aspects;
	}

	public class FieldDefinitions {
		public UniqueId UniqueId;
		public UniqueId ObjectName;
		public UniqueId UtcDeviceDateTime;
		public UniqueId Latitude;
		public UniqueId Longitude;
		public UniqueId Speed;
		public UniqueId IgnitionStatus;
		public UniqueId Odometer;
		public UniqueId Address;
		public UniqueId GSMSignal;
		public UniqueId MainPowerVoltage;
		public UniqueId GPSDirection;
	}

	public DataShape dataShape;
	public List<Rows> rows;

	public class Aspects {
	}

	public class DataShape {
		public FieldDefinitions fieldDefinitions;
	}

	public class Rows {
		public Integer UniqueId;
		public String ObjectName;
		public Long UtcDeviceDateTime;
		public Double Latitude;
		public Double Longitude;
		public Double Speed;
		public Integer IgnitionStatus;
		public Integer Odometer;
		public String Address;
		public Integer GSMSignal;
		public Integer MainPowerVoltage;
		public Integer GPSDirection;
	}

	
	public static ET_IOTLocations parse(String json) {
		return (ET_IOTLocations) System.JSON.deserialize(json, ET_IOTLocations.class);
	}
}