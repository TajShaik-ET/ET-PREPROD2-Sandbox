@isTest
public class ETCAR_Car_Services_Controller_Test {

    public static testmethod void  method1(){
        List<ET_Service_Request__c> reqList = ETC_TestDataFactory.createServiceRequests(1);
        insert reqList;
        List<ETCAR_Car__c> carsList = ETC_TestDataFactory.createCars(2, 'SUV');
        insert carsList;
      //  ETCAR_Service_Request_Line_Item__c selCar = ETC_TestDataFactory.createSelectedCars(reqList[0].id, carsList[0].id);
      //  insert selCar;
        List<ETCAR_Features__c> featuresList = ETC_TestDataFactory.createFeatures(3);
        insert featuresList;
        List<ETCAR_Car_Features__c> carFeaturesList = ETC_TestDataFactory.createCarFeatures(2, carsList[0].Id, featuresList[0].Id);
        insert carFeaturesList;
        List<ETCAR_Car_Features__c> carFeaturesList1 = ETC_TestDataFactory.createCarFeatures(2, carsList[1].Id, featuresList[0].Id);
        insert carFeaturesList1;
        Id recordTypeId = Schema.SObjectType.Cars_Price_Matrix__c.getRecordTypeInfosByDeveloperName().get('One_Way').getRecordTypeId();
        Id recordTypeIdH = Schema.SObjectType.Cars_Price_Matrix__c.getRecordTypeInfosByDeveloperName().get('Hourly').getRecordTypeId();
        List<Cars_Price_Matrix__c> matrixList = ETC_TestDataFactory.createCarsPriceMatrix(3, 'BUR DUBAI', 'SHARJAH', recordTypeId, 'SUV');
        matrixList[0].Pickup_Zone_G__c = 'Other';
        matrixList[1].recordTypeId = recordTypeIdH;
        insert matrixList;
        List<Car_Price_Range__c> carPriceRangeList = ETC_TestDataFactory.createCarPriceRanges(3,matrixList[1].Id);
        carPriceRangeList[0].Cars_Price_Matrix__c = matrixList[0].Id;
        insert carPriceRangeList;
        List<ETCAR_Service_Request_Line_Item__c> vBkngList = ETC_TestDataFactory.createVehicleBookings(3, reqList[0].Id,carsList[0].Id);
        vBkngList[0].ETCAR_Selecetd_Car__c = carsList[0].Id;
        vBkngList[0].ETST_Service_Type__c = 'One Way';
        vBkngList[1].ETST_Service_Type__c = 'Hourly';
        vBkngList[1].ETC_Duration__c = '3 Hours';
        insert vBkngList;
        List<ETCAR_Service_Request_Sub_Line_Item__c> seleactedFtrList = ETC_TestDataFactory.createSelectedFeature(3,vBkngList[0].Id,carFeaturesList[0].Id);
        seleactedFtrList[0].Service_Request_Line_Item__c = vBkngList[1].Id;
        insert seleactedFtrList;
        String fileData = 'testfilename';
        string jsonstr='[{"strFileName":"Passport.pdf","strFileType":"application/pdf","strBase64Data":"'+fileData+'"}]';
        List<String> selModelsList = new List<String>{'SUV'};
            List<String> segmentList = new List<String>{'Standard'};
                List<String> typesList = new List<String>{'Standard'};
                //'[{ "Label":"Luxury","value":"Luxury"}]'
        Test.startTest();
        ETCAR_Car_Services_Controller.getcarDetails(1.00, 3.00, selModelsList, vBkngList[0].Id, segmentList,typesList,'ETC_Limo_Vehicle');
        try{
            ETCAR_Car_Services_Controller.getcarDetails(1.00, 3.00, null, reqList[0].Id, null,null,null);
        }catch(exception e){
            system.debug('e '+e); 
        }
        ETCAR_Car_Services_Controller.getDocSetup('Limo Services');
        ETCAR_Car_Services_Controller.addModifiedFeatures(vBkngList[0].Id, '[{ "Label":"Wifi","Value":"wifi"}]');
        ETCAR_Car_Services_Controller.createSelctedCar( vBkngList[0].Id, '{ "Label":"Wifi","Value":"wifi"}', '[{ "Label":"Wifi","Value":"wifi"}]',reqList[0].Id);
        ETCAR_Car_Services_Controller.createSelctedCarModify( vBkngList[1].Id, '{ "Label":"Wifi","Value":"wifi"}', '[{ "Label":"Wifi","Value":"wifi"}]',reqList[1].Id);
        ETCAR_Car_Services_Controller.manageFeaturesOnPaymentPage(vBkngList[0].Id);
        ETCAR_Car_Services_Controller.getCarDetails(vBkngList[0].Id);
        ETCAR_Car_Services_Controller.getOrderHistory(5, 1, system.today()-2, system.today()+2);
        ETCAR_Car_Services_Controller.carBookingRequest(vBkngList, 'Car Booking', 'Hourly', null, 'Resident');
        ETCAR_Car_Services_Controller.carBookingRequest(vBkngList, 'Limo', 'Hourly', null, 'Resident');
        ETCAR_Car_Services_Controller.carBookingRequest(vBkngList, 'Limo', 'Hourly', jsonstr, 'Resident');
        ETCAR_Car_Services_Controller.carBookingRequest_upd(JSON.serialize(reqList[0]), 'Limo');
          ETCAR_Car_Services_Controller.getBookingReqDet(reqList[0].Id);
        ETCAR_Car_Services_Controller.testUtility();
       /*  ETCAR_Car_Services_Controller.updateServiceRequestPayment(serviceReq1.Id, 'Captured', 'Booking Confirmed');
        ETCAR_Car_Services_Controller.getAddressSet('Dubai');
        ETCAR_Car_Services_Controller.buildErrorResponse('Test', 'errorMessage', 'Info');
        ETCAR_Car_Services_Controller.updateServiceReqToCancel(serviceReq.Id); */
        Test.stopTest();
    }

}