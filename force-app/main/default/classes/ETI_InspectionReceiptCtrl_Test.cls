/***********************************************************************************************************************
* Name               : ETI_InspectionReceiptCtrl_Test                                                                  *
* Description        : Test Class for ETI_InspectionReceiptCtrl                                                        * 
* Created Date       : 06/Sep/2023                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   06/Sep/2023         Initial Draft.                                                             *
* 1.1       Taj Shaik   20/Sep/2024         Sync Test Results to Aman                                                  *
***********************************************************************************************************************/
@isTest
public class ETI_InspectionReceiptCtrl_Test {
    @TestSetup
    static void setup() {
        List<ETI_Visual_Defect_Test__c> VDTList = New List<ETI_Visual_Defect_Test__c>();
        ETI_Visual_Defect_Test__c VDT = New ETI_Visual_Defect_Test__c();
        VDT.Id__c = '101';
        VDT.Ord_No__c = '1';
        VDT.Prof_Id__c = 'B';
        VDT.Refer_Id__c = '401';
        VDT.Test_Type_Id__c = '40101';
        VDT.Test_Type_Name_Ar__c = 'test';
        VDT.Test_Type_Name_En__c = 'Repair/Replace Side Lights';
        VDT.Type__c = 'LIGHT';
        VDT.Type_Level__c = '';
        VDTList.add(VDT);
        ETI_Visual_Defect_Test__c VDT1 = New ETI_Visual_Defect_Test__c();
        VDT1.Id__c = '207';
        VDT1.Ord_No__c = '7';
        VDT1.Prof_Id__c = 'B';
        VDT1.Refer_Id__c = '402';
        VDT1.Test_Type_Id__c = '40207';
        VDT1.Test_Type_Name_Ar__c = 'test';
        VDT1.Test_Type_Name_En__c = 'Repair/Tighten control Idler and pitman arm';
        VDT1.Type__c = 'STEERING';
        VDT1.Type_Level__c = '3';
        VDTList.add(VDT1);
        Insert VDTList;
        
        ET_Service_Request__c sr = new ET_Service_Request__c();
        Insert sr;
        
        ET_Customer_Vehicle__c custVehicle = New ET_Customer_Vehicle__c();
        Insert custVehicle;
        
        ETI_Booking__c booking = New ETI_Booking__c();
        booking.Service_Request__c = sr.Id; 
        booking.Booking_Status__c = 'Inspection Completed';
        booking.Customer_Vehicle__c = custVehicle.Id; 
        Insert booking;
        
        ETI_Inspection_Receipt__c inspRecpt = New ETI_Inspection_Receipt__c();
        inspRecpt.AMAN_Receipt_No__c = 'AM/22/54936';
        inspRecpt.ET_Status__c = 'Active'; 
        inspRecpt.ETI_Amount__c = 200;
        inspRecpt.Bookings__c = booking.Id;
        Insert inspRecpt;
    }
    
    @isTest
    public static void testMethod1() { 
        ETI_Inspection_Receipt__c inspRecpt = [SELECT Id,AMAN_Receipt_No__c,ET_Status__c,ETI_Amount__c FROM ETI_Inspection_Receipt__c LIMIT 1];
        ETI_Booking__c  booking = [SELECT Id,Name,Service_Request__c,Booking_Status__c,Customer_Vehicle__c FROM ETI_Booking__c LIMIT 1];
        String inspObsrFields = 'Id,Aman_Receipt__c,AMAN_Receipt_No__c,Break_Major_Count__c,Visual_Major_Count__c,Vehicle_Make__c,Vehicle_Model__c,Vehicle_Color__c,Is_Break_Inspection_Completed__c,Is_Visual_Inspection_Completed__c,Break_Inspection_Count__c,Visual_Inspection_Count__c,Remarks__c,Steering_Type__c,Gear_Type__c,No_Of_Tires__c,No_Of_Seats__c,No_Of_Doors__c,Weight_Loaded__c,Weight_Unloaded__c,Horse_Power__c,No_Of_Cylinders__c,Fuel_Type__c,Engine_No__c,Chassis_No__c,Model_Year__c,Country__c,Vehicle_Type__c,No_Of_Axles__c,Break_Inspector_Name__c,Visual_Inspector_Name__c,Break_Inspector_Id__c,Visual_Inspector_Id__c,Lane_Number__c,isSyncedToAman__c,Integration_Status__c';
        //String inspObsrFields = 'Id,Aman_Receipt__c,AMAN_Receipt_No__c,Vehicle_Make__c,Vehicle_Model__c,Vehicle_Color__c,Remarks__c,Steering_Type__c,Gear_Type__c,No_Of_Tires__c,No_Of_Seats__c,No_Of_Doors__c,Weight_Loaded__c,Weight_Unloaded__c,Horse_Power__c,No_Of_Cylinders__c,Fuel_Type__c,Engine_No__c,Chassis_No__c,Model_Year__c,Country__c,Vehicle_Type__c,No_Of_Axles__c';
        ETI_Inspection_Observation__c inspObsr = New ETI_Inspection_Observation__c();
        inspObsr.AMAN_Receipt_No__c = 'AM/22/54936';
        inspObsr.Aman_Receipt__c = inspRecpt.Id;
        Insert inspObsr;
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new ETI_InspectionReceiptMock()); 
        ETI_InspectionReceiptCtrl.searchInspectionReceipt('AM/22/54936',inspObsrFields);
        ETI_InspectionReceiptCtrl.searchInspectionReceipt(booking.Name,inspObsrFields);
        Test.StopTest();
        String base64Data = EncodingUtil.urlDecode('Unit Test Attachment Body', 'UTF-8');
        ETI_InspectionReceiptCtrl.uploadFile(base64Data,'test',inspRecpt.Id);
        Map<ID, String> mapIdTitle =  ETI_InspectionReceiptCtrl.getRelatedFilesByRecordId(inspRecpt.Id);
        if(mapIdTitle.Size()>0){
            String docId = '';
            for(String str: mapIdTitle.keySet()){
                docId = str;
                Break;
            }
            ETI_InspectionReceiptCtrl.deleteFile(docId);
        }
        List<ETI_InspectionReceiptCtrl.inspectionCode> allCodesBreak = New List<ETI_InspectionReceiptCtrl.inspectionCode>();
        List<ETI_InspectionReceiptCtrl.inspectionCode> allCodesVisual = New List<ETI_InspectionReceiptCtrl.inspectionCode>();
        ETI_InspectionReceiptCtrl.inspectionCode inspCodeMajor = New ETI_InspectionReceiptCtrl.inspectionCode();
        inspCodeMajor.code = '101';
        inspCodeMajor.defect = 'Major';
        inspCodeMajor.remarks = 'test';
        inspCodeMajor.result = '1';
        inspCodeMajor.inspType = 'Break Inspection';
        allCodesBreak.add(inspCodeMajor);
        ETI_InspectionReceiptCtrl.inspectionCode inspCodeMinor = New ETI_InspectionReceiptCtrl.inspectionCode();
        inspCodeMinor.code = '101';
        inspCodeMinor.defect = 'Minor';
        inspCodeMinor.remarks = 'test';
        inspCodeMinor.result = '0';
        inspCodeMinor.inspType = 'Visual Inspection';
        allCodesVisual.add(inspCodeMinor);
        ETI_InspectionReceiptCtrl.saveInspectionReceipt(inspObsr,inspObsrFields,JSON.serialize(allCodesBreak),JSON.serialize(allCodesVisual));
        ETI_Inspection_Observation__c inspObsrRec = New ETI_Inspection_Observation__c();
        inspObsrRec.Id = inspObsr.id;
        inspObsrRec.Is_Visual_Inspection_Completed__c = true;
        Update inspObsrRec;
        ETI_InspectionReceiptCtrl.synInspResultsToAman(inspObsrFields,inspObsr.Id);
    }
}