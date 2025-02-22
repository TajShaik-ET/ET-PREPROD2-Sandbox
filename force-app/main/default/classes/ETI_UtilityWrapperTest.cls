@isTest
public class ETI_UtilityWrapperTest {
    private static testmethod void testmethodInspection(){
        List<Map<String,String>> plateTypes = new List<Map<String,String>>();
        List<Map<String,String>> plateSources = new List<Map<String,String>>();
        List<Map<String,String>> plateColors = new List<Map<String,String>>();
        List<Map<String,String>> vehicleTypes = new List<Map<String,String>>();
        Map<String,String> mapPlateType = new Map<String,String>();
        mapPlateType.put('testPlate', 'testPlateVal');
        
        plateTypes.add(mapPlateType);
        plateSources.add(mapPlateType);
        plateColors.add(mapPlateType); 
        vehicleTypes.add(mapPlateType);
        ETI_UtilityWrapper.amanLookupWrapper  objplateCombinationWrapper = new ETI_UtilityWrapper.amanLookupWrapper (plateTypes,plateSources,plateColors,vehicleTypes);
        ETI_UtilityWrapper.fileNameWrp objfileNameWrp = new ETI_UtilityWrapper.fileNameWrp();
        ETI_UtilityWrapper.fileToBeUploaded objfileToBeUploaded = new ETI_UtilityWrapper.fileToBeUploaded();
        ETI_UtilityWrapper.InspectionFeeDetail objInspectionFeeDetail = new ETI_UtilityWrapper.InspectionFeeDetail('','','',12.5,12.6,15.8);
        ETI_UtilityWrapper.vehicleWrapper objvehicleWrapper = new ETI_UtilityWrapper.vehicleWrapper();
        ETI_UtilityWrapper.walkInWrapper objWalkWrapper = new ETI_UtilityWrapper.walkInWrapper();
        

        list<ETI_Required_Documents__c> requiredDocuments1 = new list<ETI_Required_Documents__c>();
        requiredDocuments1.add(new ETI_Required_Documents__c(Name='Test Document'));
        
        list<ETI_UtilityWrapper.fileToBeUploaded> uploadedFile1 = new list<ETI_UtilityWrapper.fileToBeUploaded>();
        uploadedFile1.add(objfileToBeUploaded);
        
        list<ETI_UtilityWrapper.fileNameWrp> fileName1 = new list<ETI_UtilityWrapper.fileNameWrp>();
        fileName1.add(objfileNameWrp);
        
        ETI_Booking__c booking1 = new ETI_Booking__c(); 
        
        list<string> locations1 = new list<string>();
        locations1.add('Abu Dhabi');
        
        List<Map<String,String>> serviceTypes1=new List<Map<String,String>>();
        serviceTypes1.add(new Map<String,String>{'label' =>'Police Inspection', 'value' =>'Police Inspection'});

        ETI_UtilityWrapper.bookingWrapper objBookingWrapper1 = new ETI_UtilityWrapper.bookingWrapper(1,true,true,'requestId',requiredDocuments1,uploadedFile1,fileName1,false,new ET_Customer_Vehicle__c(),booking1,null,serviceTypes1,'vehCode','serviceCode',plateTypes,plateTypes,locations1,true,true,true,true,true,true,true,true,true,false,false,false,false,true);
    }
}