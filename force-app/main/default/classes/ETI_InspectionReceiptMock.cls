/***********************************************************************************************************************
* Name               : ETI_InspectionReceiptMock                                                                       *
* Test Class		 : ETI_InspectionReceiptCtrl_Test                                                                  *
* Description        : Mock Apex Class for Aman receipt API                                                            * 
* Created Date       : 06/Sep/2023                                                                                     *
* Created By         : Taj Shaik (SMAARTT)                                                                             *
* -----------------------------------------------------------------------------------------------                      *
* VERSION   AUTHOR      DATE                COMMENTS                                                                   *
* 1.0       Taj Shaik   06/Sep/2023         Initial Draft.                                                             *
***********************************************************************************************************************/
@isTest
global class ETI_InspectionReceiptMock implements HttpCalloutMock { 
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        ETI_InspectionReceiptCtrl.LanguageWrapper LanguageWrp = New ETI_InspectionReceiptCtrl.LanguageWrapper();  
        LanguageWrp.EN = 'Retest';
        LanguageWrp.AR = 'Arabic';
        
        ETI_InspectionReceiptCtrl.ReceiptDetailWrapper ReceiptDetailWrp = New ETI_InspectionReceiptCtrl.ReceiptDetailWrapper();
        ReceiptDetailWrp.Location = LanguageWrp;
        ReceiptDetailWrp.Receipt_No = '';
        ReceiptDetailWrp.Receipt_DateTime = '';
        ReceiptDetailWrp.Reference_No = '';
        ReceiptDetailWrp.Pay_type = '';
        ReceiptDetailWrp.Lane_Type = LanguageWrp;
        ReceiptDetailWrp.Test_Type = LanguageWrp;
        ReceiptDetailWrp.Test_Purpose = LanguageWrp;
        ReceiptDetailWrp.Test_Count = '';
        ReceiptDetailWrp.Amount = '';
        ReceiptDetailWrp.Total_Amount = '';
        ReceiptDetailWrp.Cashier = '';
        ReceiptDetailWrp.Test_Violation_No_List = '';
        
        List<ETI_InspectionReceiptCtrl.PreviousTestWrapper> PreviousTestWrpList = New List<ETI_InspectionReceiptCtrl.PreviousTestWrapper>();
        ETI_InspectionReceiptCtrl.PreviousTestWrapper PreviousTestWrp = New ETI_InspectionReceiptCtrl.PreviousTestWrapper();
        PreviousTestWrp.Name = LanguageWrp;
        PreviousTestWrp.Type = 'LIGHT';
        PreviousTestWrp.Code = '0101';
        PreviousTestWrp.Defect = 'Major';
        ETI_InspectionReceiptCtrl.PreviousTestWrapper PreviousTestWrp1 = New ETI_InspectionReceiptCtrl.PreviousTestWrapper();
        PreviousTestWrp1.Name = LanguageWrp;
        PreviousTestWrp1.Type = 'STEERING';
        PreviousTestWrp1.Code = '0207';
        PreviousTestWrp1.Defect = 'Minor';
        PreviousTestWrpList.add(PreviousTestWrp1);
        ReceiptDetailWrp.Test_No_List = PreviousTestWrpList;
        
        //(ETI_InspectionReceiptCtrl.LanguageWrapper)JSON.deserialize(JSON.serialize('{"EN":"14600 KG","AR":"14600"}'),ETI_InspectionReceiptCtrl.LanguageWrapper.Class);
        //String Test_No_List = '[{"Type":"LIGHT","Name":{"EN":"Repair/Replace Side Lights","AR":"إصلاح / استبدال الأضواء الجانبية"},"Defect":"Major","Code":"0101"},{"Type":"STEERING","Name":{"EN":"Repair/Tighten control Idler and pitman arm","AR":"اصلاح/ استبدال الذراع العاطل والهابط"},"Defect":"Major","Code":"0207"}]';
        //(List<ETI_InspectionReceiptCtrl.PreviousTestWrapper>)JSON.deserialize(JSON.serialize(Test_No_List),List<ETI_InspectionReceiptCtrl.PreviousTestWrapper>.Class);
        
        ETI_InspectionReceiptCtrl.VehicleDetailWrapper VehicleDetailWrp = New ETI_InspectionReceiptCtrl.VehicleDetailWrapper();
        VehicleDetailWrp.Plate_No  = '';
        VehicleDetailWrp.Plate_Color  = LanguageWrp;
        VehicleDetailWrp.Plate_Type  = LanguageWrp;
        VehicleDetailWrp.Plate_Source  = LanguageWrp;
        VehicleDetailWrp.Vehicle_Make  = LanguageWrp;
        VehicleDetailWrp.Vehicle_Model  = LanguageWrp;
        VehicleDetailWrp.Vehicle_Type  = LanguageWrp;
        VehicleDetailWrp.Vehicle_Color  = LanguageWrp;
        VehicleDetailWrp.Country  = LanguageWrp;
        VehicleDetailWrp.Model_Year  = '';
        VehicleDetailWrp.Body_Number  = '';
        VehicleDetailWrp.Chassis_No  = '';
        VehicleDetailWrp.Act_Chassis_No  = '';
        VehicleDetailWrp.Engine_No  = '';
        VehicleDetailWrp.Cylinders  = '';
        VehicleDetailWrp.Doors  = '';
        VehicleDetailWrp.Seats  = '';
        VehicleDetailWrp.Axles  = '';
        VehicleDetailWrp.Tires  = '';
        VehicleDetailWrp.Horsepower  = '';
        VehicleDetailWrp.Weight_Unloaded  = LanguageWrp;
        VehicleDetailWrp.Weight_Loaded  = LanguageWrp;
        VehicleDetailWrp.Fuel_Type  = LanguageWrp;
        VehicleDetailWrp.Gear_Type  = LanguageWrp;
        VehicleDetailWrp.Steering_Type  = LanguageWrp;
        VehicleDetailWrp.KM_Reading  = '';
        ReceiptDetailWrp.Vehicle_Details = VehicleDetailWrp;
        
        ETI_InspectionReceiptCtrl.ReceiptWrapper receiptWrp = New ETI_InspectionReceiptCtrl.ReceiptWrapper();
        receiptWrp.Status = 'S';
        receiptWrp.Message = 'Inspection Receipt Exists';
        receiptWrp.ReceiptDetails = ReceiptDetailWrp;
        
        String strReceiptWrp = JSON.serialize(receiptWrp);
        response.setBody(strReceiptWrp);
        response.setStatusCode(200);
        return response; 
    }
}