@isTest
public class ET_ValidateVehicleInfoServiceTest {
    public static testmethod void testmethod1(){
        ET_ValidateVehicleInfoService obj = new ET_ValidateVehicleInfoService();
        ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap obj1= new ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap();
        test.setMock(WebServiceMock.class, new ET_ValidateVehicleInfoServiceMock());
        obj1.GetLookupValues(1);
    }
    public static testmethod void testmethod2(){
        ET_ValidateVehicleInfoService obj = new ET_ValidateVehicleInfoService();
        ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap obj1= new ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap();
        test.setMock(WebServiceMock.class, new ET_ValidateVehicleInfoServiceMock2());
        obj1.GetLatestVehicleInspectionChecklist();
    }
   
    public static testmethod void testmethod3(){
        ET_ValidateVehicleInfoService obj = new ET_ValidateVehicleInfoService();
        ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap obj1= new ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap();
        test.setMock(WebServiceMock.class, new ET_ValidateVehicleInfoServiceMock3());
        obj1.ExportInspectionInformation(null); 
    }
    public static testmethod void testmethod4(){
        ET_ValidateVehicleInfoService obj = new ET_ValidateVehicleInfoService();
        ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap obj1= new ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap();
        test.setMock(WebServiceMock.class, new ET_ValidateVehicleInfoServiceMock4());
        obj1.ExportPaymentInformation('101','Dubai','101','Passed','270','101','Test',Date.newInstance(2020, 12, 9),'101','01/01/2021','Dubai','Test','car','test','test','test','test','test'); 
    }
    
    public static testmethod void testmethod5(){
        ET_ValidateVehicleInfoService obj = new ET_ValidateVehicleInfoService();
        ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap obj1= new ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap();
        test.setMock(WebServiceMock.class, new ET_ValidateVehicleInfoServiceMock5());
        obj1.GetValidateVehicleInformation('101','Dubai'); 
    }
    public static testmethod void testmethod6(){
        ET_ValidateVehicleInfoService obj = new ET_ValidateVehicleInfoService();
        ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap obj1= new ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap();
        test.setMock(WebServiceMock.class, new ET_ValidateVehicleInfoServiceMock6());
        obj1.CheckViolation('101'); 
    }
    public static testmethod void testmethod7(){
        ET_ValidateVehicleInfoService obj = new ET_ValidateVehicleInfoService();
        ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap obj1= new ET_ValidateVehicleInfoService.AbuDhabiFoodControlAuthorityETServiceSoap();
        test.setMock(WebServiceMock.class, new ET_ValidateVehicleInfoServiceMock7());
        obj1.GetViolationInspectionInformation('101'); 
    }
}