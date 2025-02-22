@isTest
global class WebServiceMockImpl implements WebServiceMock {
public void doInvoke(
    Object stub,
    Object request,
    Map<String, Object> response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNS,
    String responseName,
    String responseType) {
        System.debug('############################################## 321   ' + request);
        // Create response based on called method
        if(request instanceof ET_Lookup.Input){
            ET_Lookup.output details = new ET_Lookup.output();
            details.status = 's';
            ET_Lookup.AmanLookupValuesCollection datarec = new ET_Lookup.AmanLookupValuesCollection();
            datarec.AmanLookupValues = new List<ET_Lookup.AmanLookupValues>{new ET_Lookup.AmanLookupValues()};
                details.data = datarec;
            response.put('response_x', details); 
        }else if(request instanceof ET_Lookup.output){
            ET_Lookup.output details = new ET_Lookup.output();
            System.debug('##############################################123    ' + details);
            response.put('response_x', details); 
        }else if( request instanceOf ETAbuDhabiInspectionService.getVehicleDetails_element){
            ETAbuDhabiInspectionService.getVehicleDetailsResponse_element details = new ETAbuDhabiInspectionService.getVehicleDetailsResponse_element();
            details.getVehicleDetailsResult = new ETAbuDhabiInspectionService.VehicleDetails();
            details.getVehicleDetailsResult.PlateInfo = new ETAbuDhabiInspectionService.PlateKey();
            details.getVehicleDetailsResult.RegistrationExpiryDate = String.valueOf(System.today());
            details.getVehicleDetailsResult.PlateInfo.PlateNo = 123456;
            details.getVehicleDetailsResult.PlateInfo.PlateSourceCode = 01;
            System.debug('##  '+ details);
            response.put('response_x', details); 
        }else if(request instanceOf ET_Fee.InspectionFeeInputDetailCollection_element){
            ET_Fee.Output details = new ET_Fee.Output();
            details.status ='Y';     
            response.put('response_x', details); 
        }else if(request instanceOf ET_ERPVehicle.Input){
            ET_ERPVehicle.Output details = new ET_ERPVehicle.Output();
            details.XxetVehicleMasterDetMvCollection = new ET_ERPVehicle.XxetVehicleMasterDetMvCollection();
            ET_ERPVehicle.XxetVehicleMasterDetMv eterpv = new ET_ERPVehicle.XxetVehicleMasterDetMv();
            eterpv.internalNo = '123';
            details.XxetVehicleMasterDetMvCollection.XxetVehicleMasterDetMv = new List<ET_ERPVehicle.XxetVehicleMasterDetMv>{eterpv};
            response.put('response_x', details); 
        }else if(request instanceOf ETEmployee.InputType){
            ETEmployee.OutputType details = new ETEmployee.OutputType();
            ETEmployee.EmployeeData_element ele   = new ETEmployee.EmployeeData_element();
            ETEmployee.EmployeeRecord_element  row = new ETEmployee.EmployeeRecord_element();
            row.EmployeeNumber = '123';
            row.EmployeeNameEn = '123';
            ele.EmployeeRecord =row ;
            details.EmployeeData = new List<ETEmployee.EmployeeData_element>{ele};
                response.put('response_x', details); 
        }else if(request instanceOf ET_fee.Input){
            system.debug('request'+request);
            ET_Fee.Output details = new ET_Fee.Output();
            details.status ='S';                
            details.InspectionFeeOutputDetailCollection =  new ET_Fee.InspectionFeeOutputDetailCollection_element();
            ET_Fee.InspectionFeeOutputDetail  InspectionFeeOutputDe = new ET_Fee.InspectionFeeOutputDetail();
            InspectionFeeOutputDe.SerialNo = '1';
            InspectionFeeOutputDe.TotalAmount = 23;
            InspectionFeeOutputDe.TaxAmount = 23;
            InspectionFeeOutputDe.FeeAmount = 23;
            details.InspectionFeeOutputDetailCollection.InspectionFeeOutputDetailCollection = new List<ET_Fee.InspectionFeeOutputDetail>{InspectionFeeOutputDe};
            response.put('response_x', details); 
        }else if(request instanceof ETAbuDhabiInspectionService.GetVehicleDetailsRequest){
            System.debug('Inside the webservice ');
            ETAbuDhabiInspectionService.GetVehicleDetailsRequest details = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
            details.ChassisNo = 'JTFHX02P8D0073462';
            details.SystemCode = 4;
            details.UserID = 'ET';
            ET_SOA_Services soa = new ET_SOA_Services();
            ETAbuDhabiInspectionService.getVehicleDetailsResponse_element vehicleDetails = soa.getVehiclesDetails(details); 
            System.debug('details for request'+details);
            response.put('response_x', details); 
            ETAbuDhabiInspectionService.GetVehicleDetailsRequest details1 = new ETAbuDhabiInspectionService.GetVehicleDetailsRequest();
            ETAbuDhabiInspectionService.PlateKey platedetails = new ETAbuDhabiInspectionService.PlateKey();
            details1.SystemCode = integer.valueOf(system.label.ETI_AMAN_System_Code);
            details1.UserID = system.label.ETI_AMAN_UserID;
            platedetails.PlateOrgNo = long.valueOf(system.label.ETI_AMAN_PlateOrgNo);
            platedetails.PlateNo=32052;
            platedetails.PlateColorCode =52;
            platedetails.PlateTypeCode = 1;
            platedetails.PlateSourceCode =1 ;
            platedetails.PlateKindCode=1;
            details1.PlateInfo = platedetails;
            ETAbuDhabiInspectionService.getVehicleDetailsResponse_element vehicleDetails1 = soa.getVehiclesDetails(details1);
            System.debug('details for request'+details1);
            response.put('response_x', details1); 
        }else{
            ET_CraeteARInvoice.OutputParameters_element details = new ET_CraeteARInvoice.OutputParameters_element();
            details.PV_OUT_STATUS = 'Y';
            details.PV_OUT_EBIZ_TRX_NO = '123';
            details.PV_OUT_ERROR = '';
            response.put('response_x', details); 
        }
    }
}