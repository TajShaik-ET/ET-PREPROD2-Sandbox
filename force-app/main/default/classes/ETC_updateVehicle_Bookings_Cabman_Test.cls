@isTest
public class ETC_updateVehicle_Bookings_Cabman_Test {
    
    @isTest public static void updateCabmanRefNumberTest(){
        List<ET_Service_Request__c> reqList = ETC_TestDataFactory.createServiceRequests(1);
        insert reqList;
        List<ETCAR_Car__c> carsList = ETC_TestDataFactory.createCars(3, 'SUV');
        insert carsList;
        List<ETCAR_Features__c> featuresList = ETC_TestDataFactory.createFeatures(3);
        insert featuresList;
        List<ETCAR_Car_Features__c> carFeaturesList = ETC_TestDataFactory.createCarFeatures(2, carsList[0].Id, featuresList[0].Id);
        insert carFeaturesList;
        Id recordTypeId = Schema.SObjectType.Cars_Price_Matrix__c.getRecordTypeInfosByDeveloperName().get('One_Way').getRecordTypeId();
        Id recordTypeIdH = Schema.SObjectType.Cars_Price_Matrix__c.getRecordTypeInfosByDeveloperName().get('Hourly').getRecordTypeId();
        List<Cars_Price_Matrix__c> matrixList = ETC_TestDataFactory.createCarsPriceMatrix(3, 'BUR DUBAI', 'SHARJAH', recordTypeId, 'SUV');
        matrixList[0].Pickup_Zone_G__c = 'Other';
        matrixList[1].recordTypeId = recordTypeIdH;
        insert matrixList;
        Test.startTest();
        List<Car_Price_Range__c> carPriceRangeList = ETC_TestDataFactory.createCarPriceRanges(3,matrixList[1].Id);
        carPriceRangeList[0].Cars_Price_Matrix__c = matrixList[0].Id;
        insert carPriceRangeList;
        List<ETCAR_Service_Request_Line_Item__c> vBkngList = ETC_TestDataFactory.createVehicleBookings(4, reqList[0].Id, carsList[0].Id);
        vBkngList[0].ETCAR_Selecetd_Car__c = carsList[0].Id;
        vBkngList[0].ETST_Service_Type__c = 'One Way';
        vBkngList[1].ETST_Service_Type__c = 'Hourly';
        vBkngList[2].ETST_Service_Type__c = 'Rental';
        vBkngList[1].ETC_Duration__c = '3 Hours';
        vBkngList[2].ETCAR_Return_Date_Time__c = system.now()+2;
        insert vBkngList;
        List<ETCAR_Service_Request_Sub_Line_Item__c> seleactedFtrList = ETC_TestDataFactory.createSelectedFeature(3,vBkngList[0].Id,carFeaturesList[0].Id);
        seleactedFtrList[0].Service_Request_Line_Item__c = vBkngList[1].Id;
        insert seleactedFtrList;
        vBkngList[0].ETCAR_Pickup_Zone__c = 'Other';
        vBkngList[1].ETC_Duration__c = '5 Hours';
        vBkngList[2].ETCAR_Return_Date_Time__c = system.now()+3;
        update vBkngList;
        
        String vhNum = [Select id,name from ETCAR_Service_Request_Line_Item__c limit 1].name;
        system.debug('vhNum '+vhNum);
        string jsonBody = '[ { "VehNo":"'+vhNum+'","success": true,"message": "Successfully Updated" } ]';
        system.debug('jsonBody '+jsonBody);
        RestRequest request = new RestRequest();
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonBody);
        RestContext.request = request;
        ETC_updateVehicle_Bookings_From_Cabman.doPatch();
        ETC_updateVehicle_Bookings_From_Cabman.logException('exceptmsg', 'excepDetail');
        
        Test.stopTest();
        
    }
}