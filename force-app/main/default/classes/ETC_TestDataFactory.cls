@isTest
public class ETC_TestDataFactory {
    
    
    public static List<Account> createAccounts(Integer count){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Person_B2C').getRecordTypeId();
        List<Account> accList = new List<Account>();
        for(integer i=0 ; i <= count ; i++){
            Account acc = new Account();
            acc.RecordTypeId = recordTypeId;
            acc.Name = 'Test Acc';
            accList.add(acc);
        }
        return accList;
    }
    
    public static List<ET_Service_Request__c> createServiceRequests(Integer count){
        Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
        List<ET_Service_Request__c> reqList = new List<ET_Service_Request__c>();
        for(integer i=0 ; i <= count ; i++){
            ET_Service_Request__c req = new ET_Service_Request__c();
            req.RecordTypeId = recordTypeId;
            req.ETC_Customer_Email_Id__c = 'testmail@gmail.com';
            req.ETCAR_Request_Type__c = 'Manual';
            req.ETC_Service_Type__c = 'Limo Services';
            reqList.add(req);
        }
        return reqList;
    }
    
    public static List< ETCAR_Service_Request_Line_Item__c> createVehicleBookings(Integer count, String reqId, String carId){
        List<ETCAR_Service_Request_Line_Item__c> vBkngList = new List<ETCAR_Service_Request_Line_Item__c>();
        for(integer i=0 ; i <= count ; i++){
            ETCAR_Service_Request_Line_Item__c vBkng = new ETCAR_Service_Request_Line_Item__c();
            vBkng.ETCAR_Service_Request__c = reqId;
            vBkng.ETC_Guest_Name__c = 'Test Name';
            vBkng.ETC_Passenger_Mobile_Number__c = '+971123456789';
            vBkng.ETCAR_Price__c = 100.0;
            vBkng.ETST_Pick_Up_From__c = 'Dubai';
            vBkng.ETST_Drop_Off_To__c = 'Palmshore';
            vBkng.ETCAR_Pickup_Zone__c = 'BUR DUBAI';
            vBkng.ETCAR_Drop_Off_Zone__c = 'SHARJAH';
            vBkng.ETCAR_Pick_UP_Date_Time__c = system.now()+1;
            vBkng.ETC_Additional_Hours__c ='1';
            vBkng.ETCAR_Status__c = 'Booking Confirmed';
            vBkng.ETCAR_Selecetd_Car__c = carId;
            vBkngList.add(vBkng);
        }
        return vBkngList;
    }
    
    public static List<ETCAR_Car__c> createCars(Integer count, String carType){
        List<ETCAR_Car__c> carsList = new List<ETCAR_Car__c>();
        for(integer i=0; i<=count; i++){
            ETCAR_Car__c car = new ETCAR_Car__c();
            car.Name = 'Testcar'+i;
            car.ETCAR_Car_Type__c = carType;
            car.ETCAR_Available__c = true;
            car.ETCAR_Daily_Price__c = 100;
            car.ETCAR_Weekly_Price__c = 500;
            car.ETCAR_Monthly_Price__c = 1000;
            carsList.add(car);
        }
        return carsList;
    }
    
    public static List<ETCAR_Features__c> createFeatures(Integer count){
        List<ETCAR_Features__c> featuresList = new List<ETCAR_Features__c>();
        for(integer i=0; i<=count; i++){
            ETCAR_Features__c ftr = new ETCAR_Features__c();
            ftr.Name = 'TestFeature'+i;
            ftr.ETCAR_Price__c = 100.0;
            featuresList.add(ftr);
        }
        return featuresList;
    }
    
    public static List<ETCAR_Car_Features__c> createCarFeatures(Integer count, String carId, String featureId){
        List<ETCAR_Car_Features__c> carFeaturesList = new List<ETCAR_Car_Features__c>();
        for(integer i=0; i<=count; i++){
            ETCAR_Car_Features__c carFtr = new ETCAR_Car_Features__c();
            carFtr.ETCAR_Car__c = carId;
            carFtr.ETCAR_Features__c = featureId;
            carFtr.ETCAR_Active__c = true;
            carFtr.Name = 'Test'+i;
            carFeaturesList.add(carFtr);
        }
        return carFeaturesList;
    }
    
    public static List<Cars_Price_Matrix__c> createCarsPriceMatrix(Integer count, String pickZone, String dropZone, String recTypeId, String carType){
        List<Cars_Price_Matrix__c> matrixList = new List<Cars_Price_Matrix__c>();
        for(integer i=0; i<=count; i++){
            Cars_Price_Matrix__c  mtrx = new Cars_Price_Matrix__c();
            mtrx.RecordTypeId = recTypeId;
            mtrx.Pickup_Zone_G__c = pickZone;
            mtrx.Drop_off_Zone_G__c = dropZone;
            mtrx.Car_Type__c = carType;
            mtrx.Price__c = 100.0;
            matrixList.add(mtrx);
        }
        return matrixList;
    }
    
    public static List<Car_Price_Range__c> createCarPriceRanges(Integer count, String matrxId){
        List<Car_Price_Range__c> carPriceRangeList = new List<Car_Price_Range__c>();
        for(integer i=0; i<=count; i++){
            Car_Price_Range__c pr = new Car_Price_Range__c();
            pr.Cars_Price_Matrix__c = matrxId;
            carPriceRangeList.add(pr);
        } 
        return carPriceRangeList;
    }    
    
    public static ETCAR_Service_Request_Line_Item__c createSelectedCars(String serReqId,String carId){
        ETCAR_Service_Request_Line_Item__c selCar = new ETCAR_Service_Request_Line_Item__c(ETCAR_Service_Request__c=serReqId,
                                                                                           ETCAR_Selecetd_Car__c=carId);
        return selCar;
    }
    
    public static List<ETCAR_Service_Request_Sub_Line_Item__c> createSelectedFeature(Integer count, String vBkngId, String ftrId){
        List<ETCAR_Service_Request_Sub_Line_Item__c> seleactedFtrList = new List<ETCAR_Service_Request_Sub_Line_Item__c>();
        for(integer i=0; i<=count; i++){
            ETCAR_Service_Request_Sub_Line_Item__c ln = new ETCAR_Service_Request_Sub_Line_Item__c();
            ln.Service_Request_Line_Item__c = vBkngId;
            ln.ETCAR_Car_Features__c = ftrId;
            seleactedFtrList.add(ln);
        }
        return seleactedFtrList;
    }
    
}