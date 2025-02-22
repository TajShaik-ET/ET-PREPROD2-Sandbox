@isTest
public class ETST_AddressSearchController_Test{
    
    public static testmethod void testData(){
        
        System.Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorResponce());        
        
        ETST_AddressSearchController.getAddressSet('Dubai');
        ETST_AddressSearchController.getAddressDetailsByPlaceId('Dubai');
    }
}