@isTest
public class ETC_RefundController_Test {
    
    @isTest public static void refundControllerTest(){
        
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
        
        ETC_Limo_Refund_Settings__c refundSettings = new ETC_Limo_Refund_Settings__c(ETC_From__c='24',ETC_Percentage__c=1,Name='Test');
        insert refundSettings;
        
        ETST_Payment__c pymnt = new ETST_Payment__c(ET_Service_Request__c=reqList[0].Id,ETST_Payment_State__c='CAPTURED', ETST_Capture_State__c='SUCCESS');
        insert pymnt;
        
        List<String> vBkngListString = new List<String>();
        for(ETCAR_Service_Request_Line_Item__c vb :vBkngList ){
            vBkngListString.add(vb.id);
        }
        
        ETC_RefundController.getVehicleBookings(reqList[0].Id);
        ETC_RefundController.calculateRefundAmount(vBkngListString);
        ETC_RefundController.createRefund(vBkngList);
        
        Test.stopTest();
    } 
    
    @isTest public static void refundControllerTest1(){
        
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
        
        ETC_Limo_Refund_Settings__c refundSettings = new ETC_Limo_Refund_Settings__c(ETC_From__c='24',ETC_Percentage__c=1,Name='Test');
        insert refundSettings;
        
        ETST_Payment__c pymnt = new ETST_Payment__c(ET_Service_Request__c=reqList[0].Id,ETST_Payment_State__c='CAPTURED',ETST_Currency__c='AED', ETST_Capture_State__c='SUCCESS'); 
        insert pymnt;
        Test.setCreatedDate(pymnt.Id, system.now().adddays(-2));
        
        List<String> vBkngListString = new List<String>();
        for(ETCAR_Service_Request_Line_Item__c vb :vBkngList ){
            vBkngListString.add(vb.id);
        }
        
        ETC_RefundController.getVehicleBookings(reqList[0].Id);
        ETC_RefundController.calculateRefundAmount(vBkngListString);
        Test.startTest();
        System.Test.setMock(HttpCalloutMock.class, new ETC_CabmanBookingsUpdateMock());
        ETC_RefundController.createRefund(vBkngList);
        ETC_RefundController.testUtilityRFC();
        Test.stopTest();
    }
    
}