public class ETI_UtilityWrapper{
    public class amanLookupWrapper{
        @Auraenabled public List<Map<String,String>> plateTypes;
        @Auraenabled public List<Map<String,String>> plateSources;
        @Auraenabled public List<Map<String,String>> plateColors;
        @Auraenabled public List<Map<String,String>> vehicleTypes;
        public amanLookupWrapper(List<Map<String,String>> plateTypes1,List<Map<String,String>> plateSources1,List<Map<String,String>> plateColors1,List<Map<String,String>> vehicleTypes1){
            plateTypes=plateTypes1;
            plateSources=plateSources1;
            plateColors=plateColors1;
            vehicleTypes=vehicleTypes1;
        }
    }
    public class bookingWrapper{
        @AuraEnabled public integer rowIndex;
        @AuraEnabled public boolean isSelectedRecord;
        @AuraEnabled public boolean isEnabled;
        @AuraEnabled public string  requestId;
        @AuraEnabled public list<ETI_Required_Documents__c> requiredDocuments;
        @AuraEnabled public list<fileToBeUploaded> uploadedFile;
        @AuraEnabled public list<fileNameWrp> fileName;
        @AuraEnabled public boolean isDuplicate;
        @AuraEnabled public ET_Customer_Vehicle__c customerVehicle;
        @AuraEnabled public ETI_Booking__c booking;
        @AuraEnabled public Map<string,list<string>> openServicesMap;
        @AuraEnabled public List<Map<String,String>> serviceTypes;
        @AuraEnabled public string vehicleTypeCode;
        @AuraEnabled public Boolean isAdfcaVehicle;
        @AuraEnabled public String verifiedTradeLicenseNo;
        @AuraEnabled public string serviceCode;
        @AuraEnabled public boolean enableAvailableSlots;
        @AuraEnabled public boolean isValidated;
        @AuraEnabled public string errorMessage;
        @AuraEnabled public boolean isChildValidated;
        @AuraEnabled public string childErrorMessage;
        @AuraEnabled public List<Map<String,String>> certificates;
        @AuraEnabled public List<Map<string,string>> servicesMap;
        @AuraEnabled public List<Map<string,string>> locationMap;
        @AuraEnabled public list<string> locations;
        @AuraEnabled public Map<string,list<string>> laneNslotsMap;
        @AuraEnabled public list<string> slotList;
        @AuraEnabled public list<ETI_Booking__c> bookingList;
        @AuraEnabled public map<string,list<ETI_Service_Line_Item__c>> serviceItemMap;
        @AuraEnabled public serviceLineItemWrp serviceItemWrp;
        @AuraEnabled public list<string> AddressList;
        @AuraEnabled public boolean isFeeDetailsExist;
        @AuraEnabled public string newColor;
        @AuraEnabled public string newColor2;
        @AuraEnabled public string newColor3;
        @AuraEnabled public string newColor4;
        @AuraEnabled public string newVehicleType;
        @AuraEnabled public boolean isColorChange;
        @AuraEnabled public boolean isVehicleTypeChange;
        @AuraEnabled public boolean isAddDisabled;
        @AuraEnabled public boolean isRemoveDisabled;
        @AuraEnabled public boolean isTermsAndConditionsAgreed;
        @AuraEnabled public boolean isTrailer;
        @AuraEnabled public boolean isEquipment;
        @AuraEnabled public boolean isDuplicateBookingsExit;
        @AuraEnabled public boolean showBook;
        @AuraEnabled public List<fileToBeUploaded> fileListWrap;
        public bookingWrapper(Integer rowIndex1,boolean isSelectedRecord1,Boolean isEnabled1,string  requestId1,list<ETI_Required_Documents__c> requiredDocuments1,list<fileToBeUploaded> uploadedFile1,list<fileNameWrp> fileName1,Boolean isDuplicate1,ET_Customer_Vehicle__c customerVehicle1,ETI_Booking__c booking1,Map<string,list<string>> openServicesMap1, List<Map<String,String>> serviceTypes1, String vehicleTypeCode1,String serviceCode1,List<Map<string,string>> servicesMap1,List<Map<string,string>> locationMap1,list<string> locations1,boolean isValidated1,boolean enableAvailableSlots1,Boolean isAdfcaVehicle1,boolean isChildValidated1,boolean isFeeDetailsExist1,Boolean isColorChange1,Boolean isVehicleTypeChange1,Boolean isAddDisabled1,Boolean isRemoveDisabled1,Boolean isTermsAndConditionsAgreed1,Boolean isTrailer1,boolean isEquipment1,boolean isDuplicateBookingsExit1,boolean showBook1){
            rowIndex=rowIndex1;
            isSelectedRecord=isSelectedRecord1;
            isEnabled=isEnabled1;
            requestId=requestId1;
            requiredDocuments=requiredDocuments1;
            uploadedFile=uploadedFile1;
            fileName=fileName1;
            isDuplicate=isDuplicate1;
            customerVehicle=customerVehicle1;
            booking=booking1;
            openServicesMap=openServicesMap1;
            serviceTypes=serviceTypes1;
            vehicleTypeCode=vehicleTypeCode1;
            serviceCode=serviceCode1;
            servicesMap=servicesMap1;
            locationMap=locationMap1;
            locations=locations1;
            isValidated=isValidated1;
            enableAvailableSlots=enableAvailableSlots1;
            isAdfcaVehicle=isAdfcaVehicle1;
            isChildValidated=isChildValidated1;
            isFeeDetailsExist=isFeeDetailsExist1;
            isColorChange=isColorChange1;
            isVehicleTypeChange=isVehicleTypeChange1;
            isAddDisabled=isAddDisabled1;
            isRemoveDisabled=isRemoveDisabled1;
            isTermsAndConditionsAgreed=isTermsAndConditionsAgreed1;
            isTrailer=isTrailer1;
            isEquipment=isEquipment1;
            isDuplicateBookingsExit=isDuplicateBookingsExit1;
            showBook=showBook1;
        }
    }
    public class serviceLineItemWrp{
         @AuraEnabled public String serviceRequestId;
         @AuraEnabled public List<chassisWrp> chassisNo;
    }
    public class chassisWrp{
         @AuraEnabled public String chassisNo;
         @AuraEnabled public List<serviceTypes> typeList;
    }
    public class serviceTypes {
        @AuraEnabled public String serviceType;
        @AuraEnabled public List<ETI_Service_Line_Item__c> serviceItems;
    }
    public class Service{
        @AuraEnabled public string servicename;
        @AuraEnabled public decimal amount;
    }
    public class fileNameWrp {
        @AuraEnabled public String docName;
        @AuraEnabled public String Name;
        @AuraEnabled public String Id;
    }
    public class fileToBeUploaded{
        @AuraEnabled public string docName;
        @AuraEnabled public string fileName;
        @AuraEnabled public string base64Data;
        @AuraEnabled public string contentType;
        @AuraEnabled public string vehicleId;
        //string fileName1,string base64Data1,string contentType
        public fileToBeUploaded(){}
    }
    public class vehicleWrapper{
        @AuraEnabled public boolean isChecked;
        @AuraEnabled public boolean isEnabled;
        @AuraEnabled public boolean isReTest;
        @AuraEnabled public boolean isDelete;
        @AuraEnabled public boolean isDueToTest;
        @AuraEnabled public ET_Customer_Vehicle__c customerVehicle;
        public vehicleWrapper(){}
    }
    public class InspectionFeeDetail{
        public String status;
        public String message;
        public String LastLaneTypeId;
        public Decimal FeeAmount;
        public Decimal TaxAmount;
        public Decimal TotalAmount;
        public InspectionFeeDetail(String status1,String message1,String LastLaneTypeId1,Decimal FeeAmount1,Decimal TaxAmount1,Decimal TotalAmount1){
            status=status1;
            message=message1;
            LastLaneTypeId=LastLaneTypeId1;
            FeeAmount=FeeAmount1;
            TaxAmount=TaxAmount1;
            TotalAmount=TotalAmount1;
        }
    }
    public class walkInWrapper {
        @Auraenabled public ET_Customer_Vehicle__c customerVehicle;
        @Auraenabled public ETI_Booking__c booking;
        @Auraenabled public list<walkInServiceLineItem> serviceLineItems;
        @Auraenabled public list<customerVehicleWrp> customerVehicles;
        @AuraEnabled public Boolean isAdfcaVehicle;
        @AuraEnabled public List<Map<String,String>> locationCodes;
        @AuraEnabled public List<User> userDetails;
        @AuraEnabled public Boolean isPermissionIssuePlaceMissing;
        @AuraEnabled public List<Map<String,String>> PermitPurposeList;
        @AuraEnabled public Boolean isErrorExit;
        @AuraEnabled public String verifiedTradeLicenseNo;
        @AuraEnabled public String errorMessage;
        @Auraenabled public String newColor;
        @AuraEnabled public string newColor2;
        @AuraEnabled public string newColor3;
        @AuraEnabled public string newColor4;
        @Auraenabled public String newVehicleType;
        @Auraenabled public Decimal totalFee;
        @Auraenabled public Decimal totalTax;
        @Auraenabled public Decimal totalAmount;
    }
    public class walkInServiceLineItem{
        @Auraenabled public String serviceCode;
        @Auraenabled public String remarks;
        @Auraenabled public ETI_Service_Line_Item__c serviceItem;
        public walkInServiceLineItem(String serviceCode1,ETI_Service_Line_Item__c serviceItem1,String remarks1){
            serviceCode=serviceCode1;
            serviceItem=serviceItem1;
            remarks=remarks1;
        }
    }
    public class customerVehicleWrp{
        @Auraenabled public Boolean isSelected;
        @AuraEnabled public string customerName;
        @AuraEnabled public string customerPhone;
        @AuraEnabled public string newColor4;
        @Auraenabled public ET_Customer_Vehicle__c vehicle;
        
    }
    
    public class bulkCancelBookingsWrp{
        @Auraenabled public Boolean isSelected;
        @Auraenabled public ETI_Booking__c booking;
    }
}