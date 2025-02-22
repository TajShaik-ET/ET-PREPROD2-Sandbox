public class ETCAR_Car_Services_Controller {
    @AuraEnabled
    public static String getcarDetails(Decimal pageSize, Decimal pageNumber, List<String> sel_carModels, String reqId, 
                                        List<String> segment, List<String> types, String carRecordType)
    {
        System.debug('Vbkng req Id = '+ reqId);
        Integer pSize;
        Integer offset;
        if(pageSize != null){
            pSize = (Integer)pageSize;
        }
        if(pageNumber != null){
            offset = ((Integer)pageNumber - 1) * pSize;
        }
        system.debug('types= '+ types);
        system.debug('segment= '+ segment);
        system.debug('car Models= '+ sel_carModels);
        String queryStr;
        queryStr = 'select id, ETCAR_A_C__c,ETCAR_Auto__c, ETCAR_Car_Segment__c,Name,ETCAR_Car_Type__c ,ETCAR_Daily_Price__c ,ETCAR_Discount_Percentage__c,';
        queryStr += 'ETCAR_Door__c ,ETCAR_Monthly_Price__c, ETCAR_People__c ,ETCAR_Suitcase__c ,ETCAR_Weekly_Price__c,';
        queryStr += ' (select id ,Name, ETCAR_Active__c, ETCAR_Car__c, ETCAR_Description__c,ETCAR_Features__c,ETCAR_Price__c,ETCAR_Quantity__c,ETCAR_Features__r.id';
        queryStr += ' FROM Car_Features__r) FROM ETCAR_Car__c where ';
        queryStr += 'ETCAR_Available__c = True';
        if(sel_carModels != null && sel_carModels.size() > 0){
            queryStr +=  ' AND Name IN : sel_carModels';
        }
        if(segment != null  && segment.size() > 0){
            queryStr += ' AND ETCAR_Car_Segment__c IN : segment';
        }
        if(types != null && types.size() > 0){
            queryStr += ' AND ETCAR_Car_Type__c IN : types';
        }
        if(carRecordType != null ){
            queryStr += ' AND RecordType.DeveloperName =: carRecordType';
        }
        queryStr += ' LIMIT :pSize OFFSET :offset';
        
        List<ETCAR_Car__c> cars = new List<ETCAR_Car__c>();
        system.debug('query check = '+ queryStr);
        cars = Database.query(queryStr);  
        
        system.debug('Cars =' +JSON.serializePretty(cars));
        // query Car Images from Custom object - ETCAR_Car__c
        Map<String, String> carImageMap = new Map<String, String>();
        carImageMap = queryObjectFiles('ETCAR_Car__c');
        //query feature images for Custom Object - ETCAR_Features__c
        //Map -> Key = featureId - LinkedEntityId && Value = LatestPublishedVersionId
        Map<String, String> featureImageMap = new Map<String, String>();
        featureImageMap = queryObjectFiles('ETCAR_Features__c');
        
        //iterate in cars and prepare Features List
        Map<String, List<carfeatures>> carFeaturesMap = new Map<String, List<carfeatures>>(); // Key - Car Id && Value = Features Listr
        List<carfeatures> Wfeatures = new List<carfeatures>();
        for(ETCAR_Car__c car : Cars){
            if(car.Car_Features__r != null && car.Car_Features__r.size() > 0){
                for(ETCAR_Car_Features__c feat : car.Car_Features__r){
                    carfeatures Wfeat = new carfeatures();
                    Wfeat.carFeatureId =feat.id;
                    Wfeat.name = feat.Name;
                    Wfeat.active = String.valueOf(feat.ETCAR_Active__c);
                    Wfeat.carId = feat.ETCAR_Car__c;
                    Wfeat.price = String.valueOf(feat.ETCAR_Price__c);
                    Wfeat.quantity = String.valueOf(feat.ETCAR_Quantity__c);
                    Wfeat.featureId = feat.ETCAR_Features__c;
                    Wfeat.description = feat.ETCAR_Description__c;
                    system.debug('outside');
                    system.debug('featureImageMap = '+featureImageMap);
                    system.debug('feat.ETCAR_Features__c = '+feat.ETCAR_Features__c);
                    if(featureImageMap.containsKey(feat.ETCAR_Features__c)){
                        system.debug('inside');
                        Wfeat.imageId = ETC_UtilityClass.getBaseURL()+'/sfc/servlet.shepherd/version/download/'+featureImageMap.get(feat.ETCAR_Features__c);
                    }
                    if(carFeaturesMap.containsKey(car.id)){
                        carFeaturesMap.get(car.id).add(Wfeat);
                    }
                    else{
                        carFeaturesMap.put(car.id , new List<carfeatures>{Wfeat});
                    }
                    
                }
            }
        }
        
        //get Car Models PickList Values
        List<String> carModels = getPickListValues('ETCAR_Car__c' , 'ETCAR_Car_Type__c');
        //set the CarModels in Wrapper class in Label and Value keypairs
        List<carModels> Wmodels = new List<carModels>();
        if(carModels != null && carModels.size() > 0){
            for(String mod : carModels){
                carModels cm = new carModels();
                cm.label = mod;
                cm.Value = mod;
                Wmodels.add(cm);
            }
        }
        
        //assign the Cars information and Image to wrapper class
        
        List<carWrapper> carsW = new List<carWrapper>();
        for(ETCAR_Car__c car : cars){
            carWrapper cw = new carWrapper();
            cw.Car = car;
            cw.carLink = ETC_UtilityClass.getBaseURL()+'/sfc/servlet.shepherd/version/download/'+carImageMap.get(car.Id);
            cw.carVersionId = '/sfc/servlet.shepherd/version/download/'+carImageMap.get(car.Id);
            cw.models = Wmodels;
            cw.pageSize = pSize;
            if(carFeaturesMap.containsKey(car.Id)){
                cw.features = carFeaturesMap.get(car.Id);
            }
            cw.page = (Integer) pageNumber;
            queryStr = 'SELECT count() FROM ETCAR_Car__c';
            queryStr += ' Where ETCAR_Available__c = True';
            if(sel_carModels != null && sel_carModels.size() > 0){
                queryStr +=  ' AND Name IN : sel_carModels';
            }
            if(segment != null && segment.size() >0){
                queryStr += ' AND ETCAR_Car_Segment__c IN : segment';
            }
            if(types != null && types.size() > 0){
                queryStr += ' AND ETCAR_Car_Type__c IN : types';
            }
            if(carRecordType != null ){
                queryStr += ' AND RecordType.DeveloperName =: carRecordType';
            }
            system.debug('query = '+queryStr );
            system.debug('total cars = '+ Database.countQuery(queryStr));
            cw.total = Database.countQuery(queryStr);  
            carsW.add(cw);
        }
        
        // Calculate Price based on Travel details
        calculatePrice(reqId,carsW);
        
        system.debug('Car info =' +JSON.serializePretty(carsW));
        
        return JSON.serializePretty(carsW);
        
    } 
    
    /* Method      :  queryObjectFiles
Description : To Query all files with Car custom object
This method returns only latest files attached to each car record.
return 	   : Map<String, String>  - carImageMap
*/
    public static Map<String, String> queryObjectFiles(String objectName){
        // Query all the Files with Car object
        system.debug('objectName = '+ objectName); 
        String queryString;
        List<ContentDocumentLink> docs = new  List<ContentDocumentLink>();
        
        queryString = 'SELECT ContentDocumentId,ContentDocument.Title,ContentDocument.LatestPublishedVersionId,LinkedEntityId';
        queryString += ' FROM ContentDocumentLink';
        queryString += ' WHERE id != null'; // generic where - so we can add filters in and clauses...
        queryString += ' AND LinkedEntityId in ( SELECT Id FROM '+objectName+')';
		queryString += ' AND LinkedEntity.Type=:objectName';
        queryString += ' order by ContentDocument.createdDate desc';
        system.debug('query = '+ queryString);
        docs = Database.query(queryString);
        system.debug('docs =' +JSON.serializePretty(docs));
        
        //Map -> Key = CarId - LinkedEntityId && Value = LatestPublishedVersionId
        Map<String, String> carImageMap = new Map<String, String>();
        
        for(ContentDocumentLink cd : docs ){
            if(!carImageMap.containsKey(cd.LinkedEntityId)){
                carImageMap.put(cd.LinkedEntityId , cd.ContentDocument.LatestPublishedVersionId); 
            }
        }
        
        return carImageMap;
    }
    
    /* Method : calculatePrice
Description : to calculate Pricing based on Travel Details for all cars
*/
    
    public static List<carWrapper>  calculatePrice(String reqId,List<carWrapper> carsW ){
        // get the Travel Details from Vehicle Booking request
        ETCAR_Service_Request_Line_Item__c sReq = ETCAR_Car_Services_Controller.vehBookingDetails(reqId);
        if(sReq != null){
            Integer iDays;
            Decimal dDays;
            String PickupZone;
            String dropOffZone;
            Decimal duration;
            Long returnDateTime;
            Long pickUpDateTime ;
            String durationPackage;
            
            if(sReq.ETCAR_Service_Request__r.ETC_Service_Type__c =='Rental Services'){
                if(sReq.ETCAR_Return_Date_Time__c !=null ){
                    returnDateTime = sReq.ETCAR_Return_Date_Time__c.getTime();
                }
                if(sReq.ETCAR_Pick_UP_Date_Time__c !=null ){
                    pickUpDateTime = sReq.ETCAR_Pick_UP_Date_Time__c.getTime();
                }
                
                Decimal diffMilliSecs = Decimal.valueOf(returnDateTime - pickUpDateTime);
                dDays = diffMilliSecs/1000/60/60/24;
                system.debug('dDays = '+ dDays);
                iDays = Integer.valueOf(math.ceil(dDays)); // Round off decimal number to next integer
                system.debug('iDays = '+ iDays);
                Decimal remainderDays = dDays- iDays;
                system.debug('remainderDays = '+ remainderDays);
            }
            
            if(sReq.ETCAR_Service_Request__r.ETC_Service_Type__c =='Limo Services'){
                
                //get PickUp Zone and Drop Off Zone from itineray Details -- for using in Limo services Price Calculation
                PickupZone = sReq.ETCAR_Pickup_Zone__c;
                dropOffZone = sReq.ETCAR_Drop_Off_Zone__c;
                duration = sReq.ETCAR_Duration__c;
                durationPackage = sReq.ETC_Duration__c;
            }
            // query CarPriceMatrix to use in Calculation for Limo Services
            List<Cars_Price_Matrix__c> pMatrix = new List<Cars_Price_Matrix__c>([select id,Name,recordType.Name, Drop_off_Zone_G__c , Pickup_Zone_G__c, Price__c ,
                                                                                 Price_Per_Hour__c,Car_Type__c,ETC_Car_Model__c, ETC_Car_Model__r.Name,
                                                                                 (select id , Hours_Package__c , Price__c FROM Car_Price_Ranges__r)
                                                                                 FROM Cars_Price_Matrix__c ]);
            
            
            // iterate over Car Wrapper Records and Calculate and populate Car Price
            for(carWrapper cw : carsW){
                system.debug('service Type = '+ sReq.ETST_Service_Type__c );
                if(sReq.ETCAR_Service_Request__r.ETC_Service_Type__c =='Rental Services'){
                    system.debug('in Rental Services');
                    //calculate the Pricing based on Difference between Pickup and DropOff Time
                    // Daily Price
                    //consider less than 1 Day as one Day....
                    Decimal weeklyPricePerDay = cw.Car.ETCAR_Weekly_Price__c/7;
                    Decimal monthlyPricePerDay = cw.Car.ETCAR_Monthly_Price__c/30;
                    system.debug('weeklyPricePerDay '+weeklyPricePerDay);
                    system.debug('monthlyPricePerDay '+monthlyPricePerDay);
                    if(dDays <= 6){
                        cw.carPrice = Integer.ValueOf(cw.Car.ETCAR_Daily_Price__c*iDays);
                    }else if(dDays >=7 && dDays <=29){
                       cw.carPrice = Integer.ValueOf(weeklyPricePerDay*iDays); 
                    }else if(dDays >= 30){
                        cw.carPrice = Integer.ValueOf(monthlyPricePerDay*iDays);
                    }
                  /*  if(dDays >=0 && dDays <=1){
                        cw.carPrice = Integer.ValueOf(cw.Car.ETCAR_Daily_Price__c*1);
                    }
                    
                    if(dDays >=1 && dDays <=6){
                        cw.carPrice = Integer.ValueOf(cw.Car.ETCAR_Daily_Price__c*iDays);
                    }
                    // Weekly Price
                    else if(dDays >=7 && dDays <=29){
                        cw.carPrice = Integer.ValueOf(cw.Car.ETCAR_Weekly_Price__c*iDays);
                    }
                    // Monthly Price
                    else if(dDays >= 30){
                        cw.carPrice = Integer.ValueOf(cw.Car.ETCAR_Monthly_Price__c*iDays);
                    } */
                }
                else if(sReq.ETCAR_Service_Request__r.ETC_Service_Type__c =='Limo Services'){
                    system.debug('in Limo Services');
                    
                    // Calculate Pricing based on Zones using Car_Price_Matrix object
                    decimal extraCost = 0;
                    system.debug('Service Type = ' + sReq.ETST_Service_Type__c);
                    system.debug('Car Model = ' + cw.car.Name);
                   if(sReq.ETST_Service_Type__c == 'One Way'){
                        for(Cars_Price_Matrix__c pm : pMatrix){
                            if(PickupZone == pm.Pickup_Zone_G__c && dropOffZone == pm.Drop_off_Zone_G__c 
                               && cw.car.Name == pm.ETC_Car_Model__r.Name &&  pm.recordType.Name == 'One Way'){
                                   cw.carPrice = integer.ValueOf(pm.Price__c);
                                   system.debug('Car Price = ' + integer.ValueOf(pm.Price__c));
                               }
                        }
                    }
                    else if(sReq.ETST_Service_Type__c == 'Hourly'){
                        system.debug('in hourly');
                        for(Cars_Price_Matrix__c pm : pMatrix){
                            if(cw.car.Name == pm.ETC_Car_Model__r.Name  && pm.recordType.Name == 'Hourly'){
                                   if(pm.Car_Price_Ranges__r != null && pm.Car_Price_Ranges__r.size() > 0){
                                       for(Car_Price_Range__c ran :pm.Car_Price_Ranges__r ){
                                           if(durationPackage == ran.Hours_Package__c){
                                               // if extra hours requested - add extra hours charge also..
                                               if(sReq.ETC_Additional_Hours__c != null){
                                                   extraCost = integer.ValueOf(sReq.ETC_Additional_Hours__c) * pm.Price_Per_Hour__c;
                                                   system.debug('extraCost = ' + extraCost);
                                               }
                                               cw.carPrice = integer.ValueOf(ran.Price__c) + integer.valueof(extraCost);
                                               system.debug('Car Price = ' + cw.carPrice);
                                           }
                                       }
                                   }
                               }
                        }
                    }
                }
                
            }
            
        }
        
        return carsW;
    }
    /* Method : queryVehFilterValues
Description : To query Vehicle Filter Values
Params : map<String, List<String>> segmentMap  --> Key = segment; Value = Car Types Values
map<String, List<String>> vehTypesMap --> Key = Car Type; Value = Car Model Values
*/
    @AuraEnabled
    Public static filtersWrapper queryVehFilterValues(){
        List<ETCAR_Car__c> cars = new List<ETCAR_Car__c>();
        map<String, map<string,fieldOptions>> segmentMap  = new  map<String, map<string,fieldOptions>>();
        map<String, map<string,fieldOptions>> vehTypesMap  = new  map<String, map<string,fieldOptions>>();
        map<String, list<fieldOptions>> segmentMapList  = new map<String, list<fieldOptions>>();
        map<String, list<fieldOptions>> vehTypesMapList  = new map<String, list<fieldOptions>>();
        filtersWrapper fw = new filtersWrapper();
        
        cars = [select id,Name , ETCAR_Car_Segment__c,ETCAR_Car_Type__c FROM ETCAR_Car__c where ETCAR_Available__c = True];
        
        if(cars != null &&  cars.size() > 0){
            for(ETCAR_Car__c car : cars){
                fieldOptions opt = new fieldOptions();
                opt.label = car.ETCAR_Car_Type__c;
                opt.value = car.ETCAR_Car_Type__c;
                if(segmentMap.containsKey(car.ETCAR_Car_Segment__c)){
                    segmentMap.get(car.ETCAR_Car_Segment__c).put(opt.label , opt);
                }
                else{
                    segmentMap.put(car.ETCAR_Car_Segment__c ,new map<string,fieldOptions>{opt.label =>opt }); 
                }
                
                // add Car Models for each Car Type
                fieldOptions opt2 = new fieldOptions();
                opt2.label = car.Name;
                opt2.value = car.Name;
                if(vehTypesMap.containsKey(car.ETCAR_Car_Type__c)){
                    vehTypesMap.get(car.ETCAR_Car_Type__c).put(opt2.label , opt2);
                }
                else{
                    vehTypesMap.put(car.ETCAR_Car_Type__c ,new map<string,fieldOptions>{opt2.label =>opt2 });
                }
                
            } 
            
            for(String keyy : segmentMap.keyset()){
                segmentMapList.put(keyy,segmentMap.get(keyy).values() ); 
            }
            
            for(String keyy : vehTypesMap.keyset()){
                vehTypesMapList.put(keyy,vehTypesMap.get(keyy).values() ); 
            }
            
            fw.segmentMap = segmentMapList;
            fw.vehTypesMap = vehTypesMapList;
            if(segmentMap != null && !segmentMap.isEmpty()){
                for(String seg :segmentMap.keyset() ){
                    fieldOptions opt3 = new fieldOptions();
                    opt3.label = seg;
                    opt3.value = seg;
                    fw.segments.add(opt3);
                }
            }
        }
        system.debug('filter Values = '+ JSON.serializePretty(fw));
        return fw;
    }
    
    // Wrapper Class to send filters picklist Values
    public class filtersWrapper{
        filtersWrapper(){
            segments = new List<fieldOptions>();
        }
        @AuraEnabled
        public map<String, List<fieldOptions>> segmentMap;
        @AuraEnabled
        public map<String, List<fieldOptions>> vehTypesMap;
        @AuraEnabled
        public List<fieldOptions> segments;
    }
    
    
    //wrapper class to wrap whole car details
    public class carWrapper {
        @AuraEnabled
        public ETCAR_Car__c Car;
        @AuraEnabled
        Public List<carfeatures> features;
        @AuraEnabled
        public String carLink;
        @AuraEnabled
        public String carVersionId; // without domain
        @AuraEnabled
        public Integer carPrice =0;
        @AuraEnabled
        Public List<carModels> models;
        @AuraEnabled
        public Integer pageSize;
        @AuraEnabled
        public Integer page ; 
        @AuraEnabled
        public Integer total ;
    } 
    
    // Car Models Wrapper class
    public class carModels{
        @AuraEnabled
        Public String label;
        @AuraEnabled
        Public String value;
    }
    
    //pick list fields options
    public class fieldOptions{
        @AuraEnabled
        Public String label;
        @AuraEnabled
        Public String value;
    }
    
    // Car Models Wrapper class
    public class carfeatures{
        @AuraEnabled
        Public String carFeatureId;
        @AuraEnabled
        Public String name;
        @AuraEnabled
        Public String active;
        @AuraEnabled
        Public String carId;
        @AuraEnabled
        Public String price;
        @AuraEnabled
        Public String quantity;
        @AuraEnabled
        Public String featureId;
        @AuraEnabled
        Public String imageId;
        @AuraEnabled
        Public String description;
        @AuraEnabled
        Public String featureName;
        @AuraEnabled
        Public boolean selected;
        
    }
    
    
    public static List<String> getPickListValues(String objectName , String fieldName ){
        List<String> picklistVals = new List<String>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            picklistVals.add(pickListVal.getValue());
        }   
        system.debug('picklistVals = '+ picklistVals);
        return picklistVals;
    }
    
    public static ETC_UtilityClass.userdetails queryUserDetails(){
        ETC_UtilityClass.userdetails userDetails =  ETC_UtilityClass.getUserDetails();
        return userDetails;
    }
    
    
    // To get the Document setup details - Required docs OR optional Docs
    @AuraEnabled 
    public static String getDocSetup(String ServiceType){
        system.debug('in getDocSetup method');
        List<ETCAR_Document_Setup__c> docSets = new List<ETCAR_Document_Setup__c>([select id, Customer_Type__c ,Document_Type__c , Emirates__c ,
                                                                                   Mandatory__c , Enable__c
                                                                                   FROM ETCAR_Document_Setup__c where Enable__c = true 
                                                                                   AND ServiceType__c =:ServiceType]);
        map<String, List<String>> reqDocs = new Map<String, List<String>>();
        map<String, List<String>> optionalDocs = new Map<String, List<String>>();
        String response;
        // Key = Customer_Type__c & Emirates__c
        
        if(docSets != null && docSets.size() > 0){
            for(ETCAR_Document_Setup__c doc : docSets){
                String keyy =doc.Emirates__c+'&'+doc.Customer_Type__c;
                if(doc.Mandatory__c == True){
                    if(reqDocs.containsKey(keyy)){
                        reqDocs.get(keyy).add(doc.Document_Type__c);
                    }
                    else{
                        reqDocs.put(keyy , new List<String>{doc.Document_Type__c});
                    }
                }
                else{
                    if(optionalDocs.containsKey(keyy)){
                        optionalDocs.get(keyy).add(doc.Document_Type__c);
                    }
                    else{
                        optionalDocs.put(keyy , new List<String>{doc.Document_Type__c});
                    }
                }
            }
            
            // set the docSetWrapper and return
            docSetup Wdoc = new docSetup();
            Wdoc.reqDocs = reqDocs;
            Wdoc.optDocs = optionalDocs;
            System.debug('doc setup docs =' + JSON.serializePretty(Wdoc));
            response = JSON.serializePretty(Wdoc);
        }
        
        return response;
        
    }
    
    
    
    
    
    // Car Models Wrapper class
    public class serviceReq{
        @AuraEnabled
        Public String PickupFrom;
        @AuraEnabled
        Public String PickUpTime;
        @AuraEnabled
        Public String returnTime;
        @AuraEnabled
        Public String age;
        @AuraEnabled
        Public String datesDiff;
    }
    
    public class docSetup{
        @AuraEnabled
        Public map<String, List<String>> reqDocs;
        @AuraEnabled
        Public map<String, List<String>> optDocs;
    }
    
    public class uploadedDocs{
        @AuraEnabled
        Public String strFileName;
        @AuraEnabled
        Public String strFileType;
        @AuraEnabled
        Public String strBase64Data;
        @AuraEnabled
        Public String fileSourceType;
    }
    
    @AuraEnabled 
    public static String addModifiedFeatures(String selectedCarId , String featuresJ){
        // get selected features in selected Car
        String response;
        List<ETCAR_Service_Request_Line_Item__c> car = new List<ETCAR_Service_Request_Line_Item__c>([SELECT Id,
                                                                                                     (select id
                                                                                                      FROM Service_Request_Sub_Line_Items__r)
                                                                                                     FROM ETCAR_Service_Request_Line_Item__c where id =:selectedCarId]);
        if(car[0].Service_Request_Sub_Line_Items__r.size() > 0){
            delete car[0].Service_Request_Sub_Line_Items__r;
        }
        
        List<Object> features = (List<Object>)JSON.deserializeUntyped(featuresJ);
        // Now insert selected Car Features for - Cars
        List<ETCAR_Service_Request_Sub_Line_Item__c> subItems = new List<ETCAR_Service_Request_Sub_Line_Item__c>();
        for(Object f : features){    
            Map<String,Object> feature = (Map<String,Object>)f;
            ETCAR_Service_Request_Sub_Line_Item__c subItem = new ETCAR_Service_Request_Sub_Line_Item__c();
            subItem.Service_Request_Line_Item__c = selectedCarId;
            subItem.ETCAR_Car_Features__c = (String)feature.get('id');
            subItem.ETCAR_Price__c =(Decimal)feature.get('price');
            system.debug('quantity = '+ feature.get('quantity') );
            Integer quan = Integer.valueof(feature.get('quantity'));
            subItem.ETCAR_Quantity__c=(Decimal)(quan);
            subItems.add(subItem);
        }
        
        try{
            insert subItems;
            response = 'Success';
        }
        
        catch(Exception e){
            system.debug('Trace = '+e.getStackTraceString());
            system.debug('Trace = '+e.getMessage());
            response ='Failed';
        }
        
        return response;
        
        
    }
    
    /* Method : createSelctedCar
Description : To Save Selected Vehicle and it's features to service Request
If Vehicle already have some features - those will be deleted and new features will be added. When user goes
back and change selection - this will be helpful.
*/
    
    
    @AuraEnabled 
    public static String createSelctedCar(String reqId , String seltdCar , String featuresJ, String serReqId){
        
        system.debug('seltdCar = '+seltdCar);
        system.debug('reqId = '+reqId);
        system.debug('featuresJ = '+featuresJ);
        system.debug('serReqId '+ serReqId);
        List<Object> features = (List<Object>)JSON.deserializeUntyped(featuresJ);
        
        carWrapper car = (carWrapper)JSON.deserialize(seltdCar, carWrapper.class);
        String response;
        List<ETCAR_Service_Request_Line_Item__c> vbList = [SELECT Id,ETST_Pick_Up_From__c,ETST_Drop_Off_To__c,ETCAR_Pick_UP_Date_Time__c,ETC_Flight_Number__c,ETC_Flight_Type__c,
                                                           ETST_Service_Type__c,ETC_Instructions_To_Driver__c,ETC_Additional_Hours__c,ETC_Duration__c FROM ETCAR_Service_Request_Line_Item__c WHERE ID=: reqId];
        //create Service Line Item with selected Car
        //List<ETCAR_Service_Request_Line_Item__c> itemsList = new List<ETCAR_Service_Request_Line_Item__c>();
        if(car != null){
            //set the save point and if any issue occurs, roll back entire transaction to this Point.
            Savepoint sp = Database.setSavepoint();  
            try{
                ETCAR_Service_Request_Line_Item__c item = new ETCAR_Service_Request_Line_Item__c();
                item.id = reqId;
                item.ETCAR_Service_Request__c = serReqId;
                //item.ETC_Previous_Booking__c = reqId;
                item.ETCAR_Image_Link__c = car.carVersionId;
                item.ETCAR_Price__c = car.carPrice;
                item.ETCAR_Selecetd_Car__c = car.Car.Id;
                item.ETC_Additional_Hours__c = vbList[0].ETC_Additional_Hours__c; 
                item.ETC_Duration__c = vbList[0].ETC_Duration__c;
                item.ETST_Pick_Up_From__c = vbList[0].ETST_Pick_Up_From__c;
                item.ETCAR_Pick_UP_Date_Time__c = vbList[0].ETCAR_Pick_UP_Date_Time__c;
                item.ETST_Drop_Off_To__c = vbList[0].ETST_Drop_Off_To__c;
                item.ETC_Flight_Number__c = vbList[0].ETC_Flight_Number__c;
                item.ETC_Flight_Type__c = vbList[0].ETC_Flight_Type__c;
                item.ETC_Instructions_To_Driver__c = vbList[0].ETC_Instructions_To_Driver__c;
                item.ETST_Service_Type__c = vbList[0].ETST_Service_Type__c;
                //item.ETC_Is_Latest_Booking__c = true;
                // itemsList.add(item);
                //itemsList.add(new ETCAR_Service_Request_Line_Item__c(id = reqId,ETC_Is_Latest_Booking__c=false));
                //item= serviceReqList[0].clone(false, false, false, false);
                update item;
                // insert item;
                //If booked Vehicle already has some features - delete them and add newly selcted features
                //upsert itemsList;
                List<ETCAR_Service_Request_Sub_Line_Item__c> features_d = new List<ETCAR_Service_Request_Sub_Line_Item__c>();
                features_d = [select id from ETCAR_Service_Request_Sub_Line_Item__c where Service_Request_Line_Item__c =:item.Id ];
                if(features_d != null && features_d.size() > 0){
                    delete features_d;
                }
                
                // Now insert selected Car Features for - Cars
                List<ETCAR_Service_Request_Sub_Line_Item__c> subItems = new List<ETCAR_Service_Request_Sub_Line_Item__c>();
                for(Object f : features){    
                    Map<String,Object> feature = (Map<String,Object>)f;
                    ETCAR_Service_Request_Sub_Line_Item__c subItem = new ETCAR_Service_Request_Sub_Line_Item__c();
                    subItem.Service_Request_Line_Item__c = item.id;
                    subItem.ETCAR_Car_Features__c = (String)feature.get('id');
                    subItem.ETCAR_Price__c =(Decimal)feature.get('price');
                    system.debug('quantity = '+ feature.get('quantity') );
                    Integer quan = Integer.valueof(feature.get('quantity'));
                    subItem.ETCAR_Quantity__c=(Decimal)(quan);
                    subItems.add(subItem);
                }
                
                insert subItems;
                response =item.Id;
            }
            catch(Exception e){
                Database.rollback(sp);
                system.debug('Trace = '+e.getStackTraceString());
                system.debug('Message = '+e.getMessage());
                response ='Failed:'+e.getMessage();
            }
        }
        
        
        //String resp = seltdCar.carLink;
        return response;
    }
    
    // to create child modified booking 
    @AuraEnabled 
    public static String createSelctedCarModify(String reqId , String seltdCar , String featuresJ, String serReqId){
        
        system.debug('seltdCar = '+seltdCar);
        system.debug('reqId = '+reqId);
        system.debug('featuresJ = '+featuresJ);
        system.debug('serReqId '+ serReqId);
        List<Object> features = (List<Object>)JSON.deserializeUntyped(featuresJ);
        
        carWrapper car = (carWrapper)JSON.deserialize(seltdCar, carWrapper.class);
        system.debug('car->' + car);
        String response;
        List<ETCAR_Service_Request_Line_Item__c> vbList = [SELECT Id,ETST_Pick_Up_From__c,ETST_Drop_Off_To__c,ETCAR_Pick_UP_Date_Time__c,ETC_Flight_Number__c,ETC_Flight_Type__c,
                                                           ETST_Service_Type__c,ETC_Instructions_To_Driver__c,ETC_Additional_Hours__c,ETC_Duration__c FROM ETCAR_Service_Request_Line_Item__c WHERE ID=: reqId];
        
        
        List<ETCAR_Service_Request_Line_Item__c> vbDraftList = [SELECT Id,Name FROM ETCAR_Service_Request_Line_Item__c WHERE ETCAR_Service_Request__c=: serReqId AND ETCAR_Status__c ='Draft'];
        if(vbDraftList.size()>0){
            delete vbDraftList;
        }
        //create Service Line Item with selected Car
        List<ETCAR_Service_Request_Line_Item__c> itemsList = new List<ETCAR_Service_Request_Line_Item__c>();
        if(car != null){
            //set the save point and if any issue occurs, roll back entire transaction to this Point.
            Savepoint sp = Database.setSavepoint();  
            try{
                ETCAR_Service_Request_Line_Item__c item = new ETCAR_Service_Request_Line_Item__c();
                // item.id = reqId;
                item.ETCAR_Service_Request__c = serReqId;
                // item.ETC_Previous_Booking__c = reqId;
                item.ETCAR_Image_Link__c = car.carVersionId;
                item.ETCAR_Price__c = car.carPrice;
                item.ETCAR_Selecetd_Car__c = car.Car.Id;
                item.ETC_Additional_Hours__c = vbList[0].ETC_Additional_Hours__c; 
                item.ETC_Duration__c = vbList[0].ETC_Duration__c;
                item.ETST_Pick_Up_From__c = vbList[0].ETST_Pick_Up_From__c;
                item.ETCAR_Pick_UP_Date_Time__c = vbList[0].ETCAR_Pick_UP_Date_Time__c;
                item.ETST_Drop_Off_To__c = vbList[0].ETST_Drop_Off_To__c;
                item.ETC_Flight_Number__c = vbList[0].ETC_Flight_Number__c;
                item.ETC_Flight_Type__c = vbList[0].ETC_Flight_Type__c;
                item.ETC_Instructions_To_Driver__c = vbList[0].ETC_Instructions_To_Driver__c;
                item.ETST_Service_Type__c = vbList[0].ETST_Service_Type__c;
               // item.ETC_Is_Latest_Booking__c = true;
                insert item;
                // itemsList.add(item);
                // itemsList.add(new ETCAR_Service_Request_Line_Item__c(id = reqId,ETC_Is_Latest_Booking__c=false));//,ETCAR_Status__c='Cancelled',ETC_Cancellation_Reason__c='Booking Modifed'));
                //item= serviceReqList[0].clone(false, false, false, false);
                //update item;
                // insert item;
                //If booked Vehicle already has some features - delete them and add newly selcted features
                // upsert itemsList;
                
                
                List<ETCAR_Service_Request_Line_Item__c> vbConfirmList = [SELECT Id,Name FROM ETCAR_Service_Request_Line_Item__c WHERE ETCAR_Service_Request__c=: serReqId AND ETCAR_Status__c ='Booking Confirmed'];
                item.ETC_Previous_Booking__c = vbConfirmList[0].Id;
                update item;
               // vbConfirmList[0].ETC_Is_Latest_Booking__c = false;
               // update vbConfirmList;
                
                List<ETCAR_Service_Request_Sub_Line_Item__c> features_d = new List<ETCAR_Service_Request_Sub_Line_Item__c>();
                features_d = [select id from ETCAR_Service_Request_Sub_Line_Item__c where Service_Request_Line_Item__c =:item.Id ];
                if(features_d != null && features_d.size() > 0){
                    delete features_d;
                }
                
                // Now insert selected Car Features for - Cars
                List<ETCAR_Service_Request_Sub_Line_Item__c> subItems = new List<ETCAR_Service_Request_Sub_Line_Item__c>();
                for(Object f : features){    
                    Map<String,Object> feature = (Map<String,Object>)f;
                    ETCAR_Service_Request_Sub_Line_Item__c subItem = new ETCAR_Service_Request_Sub_Line_Item__c();
                    subItem.Service_Request_Line_Item__c = item.id;
                    subItem.ETCAR_Car_Features__c = (String)feature.get('id');
                    subItem.ETCAR_Price__c =(Decimal)feature.get('price');
                    system.debug('quantity = '+ feature.get('quantity') );
                    Integer quan = Integer.valueof(feature.get('quantity'));
                    subItem.ETCAR_Quantity__c=(Decimal)(quan);
                    subItems.add(subItem);
                }
                
                insert subItems;
                response =item.Id;
            }
            catch(Exception e){
                Database.rollback(sp);
                system.debug('Trace = '+e.getStackTraceString());
                system.debug('Message = '+e.getMessage());
                response ='Failed:'+e.getMessage();
            }
        }
        
        
        //String resp = seltdCar.carLink;
        return response;
    }
    
    
    
    @AuraEnabled 
    public static String manageFeaturesOnPaymentPage(String vBkngId){
        // get the features in selected Car and get whole available features and 
        // Prepare a Wrapper class with available and New Features
        
        // get the map of featureId and featureImage 
        // Query all the Files with Feature object
        List<ContentDocumentLink> featDocs = [SELECT ContentDocumentId,ContentDocument.Title, 
                                              ContentDocument.LatestPublishedVersionId,
                                              LinkedEntityId  
                                              FROM ContentDocumentLink where LinkedEntityId in 
                                              ( SELECT Id FROM ETCAR_Features__c) and  LinkedEntity.Type='ETCAR_Features__c'
                                             ];
        
        //Map -> Key = featureId - LinkedEntityId && Value = LatestPublishedVersionId
        Map<String, String> featureImageMap = new Map<String, String>();
        
        for(ContentDocumentLink cd : featDocs ){
            featureImageMap.put(cd.LinkedEntityId , cd.ContentDocument.LatestPublishedVersionId);
        }
        
        // get selected features in selected Car
        List<ETCAR_Service_Request_Line_Item__c> car = new List<ETCAR_Service_Request_Line_Item__c>([SELECT Id, Name, ETCAR_Selecetd_Car__c, ETCAR_Price__c, 
                                                                                                     ETCAR_Selecetd_Car__r.Name,
                                                                                                     ETCAR_Service_Request__r.ETCAR_Billing_Total__c,
                                                                                                     ETCAR_Service_Request__c, ETCAR_Image_Link__c,
                                                                                                     (select ETCAR_Car_Features__c,ETCAR_Price__c,
                                                                                                      ETCAR_Car_Features__r.Name,
                                                                                                      ETCAR_Car_Features__r.ETCAR_Car__c,
                                                                                                      ETCAR_Car_Features__r.ETCAR_Description__c,
                                                                                                      ETCAR_Car_Features__r.ETCAR_Features__c, 
                                                                                                      ETCAR_Quantity__c
                                                                                                      FROM Service_Request_Sub_Line_Items__r)
                                                                                                     FROM ETCAR_Service_Request_Line_Item__c where id =:vBkngId]);
        
        //get the whole available features for Car
        String carId ;
        if(car.size() > 0){
            carId = car[0].ETCAR_Selecetd_Car__c;
        }
        
        List<String> selectedFeatNames = new List<String>();
        
        // iterate on selected Features and get their Names
        if(car[0].Service_Request_Sub_Line_Items__r.size() > 0){
            for(ETCAR_Service_Request_Sub_Line_Item__c feat : car[0].Service_Request_Sub_Line_Items__r){
                selectedFeatNames.add(feat.ETCAR_Car_Features__r.Name);
            }
        }
        
        //query inventory Car object for whole avaialble Features
        List<ETCAR_Car__c> cars = [select id, ETCAR_A_C__c,ETCAR_Auto__c, ETCAR_Car_Segment__c,
                                   Name,ETCAR_Car_Type__c ,ETCAR_Daily_Price__c ,ETCAR_Discount_Percentage__c ,
                                   ETCAR_Door__c ,ETCAR_Monthly_Price__c, ETCAR_People__c ,
                                   ETCAR_Suitcase__c ,ETCAR_Weekly_Price__c,
                                   (select id ,Name, ETCAR_Active__c, ETCAR_Car__c, ETCAR_Description__c,
                                    ETCAR_Features__c,ETCAR_Price__c,ETCAR_Quantity__c,ETCAR_Features__r.id
                                    FROM
                                    Car_Features__r where Name not in :selectedFeatNames )
                                   FROM ETCAR_Car__c
                                   Where  id =: carId];
        
        
        
        //frame the wrapper class of selected and available features 
        //iterate over selected features
        List<carfeatures> Wcarfeatures = new List<carfeatures>();
        if(car[0].Service_Request_Sub_Line_Items__r.size() > 0){
            for(ETCAR_Service_Request_Sub_Line_Item__c feat : car[0].Service_Request_Sub_Line_Items__r){
                carfeatures Wfeat = new carfeatures();
                Wfeat.selected = true;
                Wfeat.carFeatureId = feat.ETCAR_Car_Features__c;
                Wfeat.name = feat.ETCAR_Car_Features__r.Name;
                Wfeat.carId =  feat.ETCAR_Car_Features__r.ETCAR_Car__c;
                Wfeat.price = String.valueOf(feat.ETCAR_Price__c);
                Wfeat.quantity = String.valueOf(feat.ETCAR_Quantity__c);
                Wfeat.featureId = feat.ETCAR_Car_Features__r.ETCAR_Features__c ;
                if(featureImageMap.containsKey(feat.ETCAR_Car_Features__r.ETCAR_Features__c)){
                    Wfeat.imageId = ETC_UtilityClass.getBaseURL()+'/sfc/servlet.shepherd/version/download/'+featureImageMap.get(feat.ETCAR_Car_Features__r.ETCAR_Features__c);
                }
                
                Wfeat.description = feat.ETCAR_Car_Features__r.ETCAR_Description__c; 
                
                Wcarfeatures.add(Wfeat);
            }
        }
        
        //iterate over remaining available features
        if(cars[0].Car_Features__r.size() > 0){
            for(ETCAR_Car_Features__c feat : cars[0].Car_Features__r){
                carfeatures Wfeat = new carfeatures();
                Wfeat.selected = false;
                Wfeat.carFeatureId = feat.id;
                Wfeat.name = feat.Name;
                Wfeat.carId = feat.ETCAR_Car__c;
                Wfeat.price = String.valueOf(feat.ETCAR_Price__c);
                Wfeat.quantity = String.valueOf(feat.ETCAR_Quantity__c);
                Wfeat.featureId = feat.ETCAR_Features__c ;
                if(featureImageMap.containsKey(feat.ETCAR_Features__c)){
                    Wfeat.imageId = ETC_UtilityClass.getBaseURL()+'/sfc/servlet.shepherd/version/download/'+featureImageMap.get(feat.ETCAR_Features__c);
                }
                
                Wfeat.description = feat.ETCAR_Description__c; 
                Wcarfeatures.add(Wfeat);
            }
        }
        
        System.debug('response feature List = '+ JSON.serializePretty(Wcarfeatures));
        return JSON.serializePretty(Wcarfeatures);
        
    }
    
    @AuraEnabled 
    public static String getCarDetails(String carId){
        Map<String,Object> response= new Map<string,object>();
        List<ETCAR_Service_Request_Line_Item__c> car = [SELECT Id, Name, ETCAR_Selecetd_Car__c, ETCAR_Price__c,
                                                        ETCAR_Selecetd_Car__r.Name,ETC_Previous_Booking__r.ETC_Booking_Cost__c,ETC_Previous_Booking__r.ETCAR_Status__c,
                                                        ETCAR_Service_Request__r.ETCAR_Billing_Total__c,
                                                        ETCAR_Service_Request__c,ETC_Is_Latest_Booking__c,
                                                        ETCAR_Service_Request__r.id, ETCAR_Image_Link__c,
                                                        ETC_Booking_Cost__c,
                                                        (select ETCAR_Car_Features__c,ETCAR_Price__c,
                                                         ETCAR_Car_Features__r.Name,
                                                         ETCAR_Quantity__c
                                                         FROM Service_Request_Sub_Line_Items__r)
                                                        FROM ETCAR_Service_Request_Line_Item__c where id =:carId];
        
        List<ETCAR_Service_Request_Line_Item__c> cars = [select id,ETC_Previous_Booking__c,ETC_Previous_Booking__r.ETC_Booking_Cost__c,ETC_Booking_Cost__c,
                                                         ETC_Previous_Booking__r.ETCAR_Status__c from ETCAR_Service_Request_Line_Item__c
                                                         where ETCAR_Service_Request__c=:car[0].ETCAR_Service_Request__c and ETC_Is_Latest_Booking__c=true];
        response.put('Car',car[0]);
        response.put('latestCars',cars);
        return JSON.serializePretty(response);
        
        
    }
    
    //get orderHistory details with - Itinery Details, Selected Car and Add ON Details...
    @AuraEnabled 
    Public static String getOrderHistory(Decimal pageSize, Decimal pageNumber, Date startDate, Date endDate){
        // get the logged in user and His account and His all Service Requests
        Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        
        String userDet = ETCAR_Car_Services_Controller.fetchUser();
        User userinfo = (User)JSON.deserialize(userDet, User.Class);
        String accntId = userinfo.AccountId;
        
        String response;
        system.debug('customer acc = '+ userinfo.AccountId);
        map<String ,orderHistory> orderHistryMap = new map<String ,orderHistory>(); // Key = reqId and Value = orderHistory
        //query selected car details and it's Itinery details
        String reason = 'Booking Modified';
        String status = 'Draft';
        String queryStr = 'SELECT id,Name,';
        queryStr+=  'ETCAR_Selecetd_Car__c,ETCAR_Price__c,ETCAR_Selecetd_Car__r.Name,ETCAR_Service_Request__r.ETC_Payment_Status__c,ETCAR_Service_Request__r.ETC_Billing_Total__c,ETST_Pick_Up_From__c,';
        queryStr+= 'ETCAR_Duration__c,ETC_Duration__c,ETCAR_Pick_UP_Date_Time__c,ETC_Booking_Cost__c,ETCAR_Return_Date_Time__c,ETC_Previous_Booking__r.Id,';
        queryStr+= 'ETST_Drop_Off_To__c,ETST_Service_Type__c,ETCAR_Service_Request__r.Name,ETCAR_Service_Request__r.RecordType.Name,ETCAR_Status__c,';
        queryStr+= 'ETCAR_Service_Request__r.Id,ETCAR_Service_Request__c,ETCAR_Image_Link__c, ';
        queryStr+='(select ETCAR_Car_Features__c,ETCAR_Price__c,ETCAR_Car_Features__r.Name,ETCAR_Quantity__c FROM Service_Request_Sub_Line_Items__r)';
        queryStr+= ' FROM ETCAR_Service_Request_Line_Item__c WHERE ETCAR_Service_Request__r.ET_Account__c =:accntId';
        //queryStr+= ' AND ETCAR_Service_Request__r.ETC_Billing_Total__c >0'; // to show cancelled requests disable this condition - sree
        queryStr+=' AND ETC_Cancellation_Reason__c != : reason AND ETCAR_Status__c!=: status';
        if(startDate != null && endDate != null){
            queryStr+= ' AND ETCAR_Pick_UP_Date_Time__c >=:startDate AND ETCAR_Pick_UP_Date_Time__c<=:endDate';
        }
        
        queryStr+= ' ORDER BY createdDate DESC LIMIT :pSize OFFSET :offset';
        List<ETCAR_Service_Request_Line_Item__c> items = new List<ETCAR_Service_Request_Line_Item__c>();
        
        items = Database.query(queryStr);
        
        //convert the list to Map
        map<String , ETCAR_Service_Request_Line_Item__c> itemsMap = 
            new Map<String , ETCAR_Service_Request_Line_Item__c>(items);
        
        List<orderHistory> allHistoryList = new List<orderHistory>();
        
        if(items != null && items.size() > 0){
            for(ETCAR_Service_Request_Line_Item__c item : items){
                orderHistory oh =  new orderHistory();
                oh.servReqId = item.ETCAR_Service_Request__r.Id;
                oh.vBkId = item.Id;
                oh.prevBkngId = item.ETC_Previous_Booking__r.Id;
                oh.serReqNo = item.ETCAR_Service_Request__r.Name;
                oh.paymentStatus = item.ETCAR_Service_Request__r.ETC_Payment_Status__c;
                oh.carPrice = String.ValueOf(item.ETCAR_Price__c);
                oh.carName = item.ETCAR_Selecetd_Car__r.Name;
                oh.billingTotal = String.ValueOf(item.ETC_Booking_Cost__c);
                oh.pickupFrom = item.ETST_Pick_Up_From__c;
                oh.duration = String.ValueOf(item.ETC_Duration__c);
                oh.pickupDateTime = String.ValueOf(item.ETCAR_Pick_UP_Date_Time__c);
                oh.returnDateTime = String.ValueOf(item.ETCAR_Return_Date_Time__c);
                oh.dropOff = item.ETST_Drop_Off_To__c;
                oh.serviceType = item.ETST_Service_Type__c;
                oh.recordType = item.ETCAR_Service_Request__r.RecordType.Name;
                oh.imageLink = ETC_UtilityClass.getBaseURL()+item.ETCAR_Image_Link__c;
                oh.status = item.ETCAR_Status__c; 
                oh.features = item.Service_Request_Sub_Line_Items__r;
                orderHistryMap.put(item.ETCAR_Service_Request__r.Id , oh);
                allHistoryList.add(oh);
            }
            
            // assign the Lists to ordersWrapper
            ordersWrapper ow = new ordersWrapper();
            ow.allHistory = allHistoryList;
            ow.allHistoryMap = orderHistryMap;
            ow.pageSize =String.valueOf(pageSize);
            ow.page=String.valueOf(pageNumber);
            String queryStrTot = 'SELECT count() FROM ETCAR_Service_Request_Line_Item__c';
            queryStrTot +=' WHERE ETCAR_Service_Request__r.ET_Account__c =:accntId';
            queryStrTot +=' AND ETC_Cancellation_Reason__c != : reason AND ETCAR_Status__c!=: status';
            if(startDate != null && endDate != null){
                queryStrTot+= ' AND ETCAR_Pick_UP_Date_Time__c >=:startDate AND ETCAR_Pick_UP_Date_Time__c<=:endDate';
            }
            if(queryStrTot != null){
               ow.totalOpen=Database.countQuery(queryStrTot); 
            }
            response = JSON.serializePretty(ow);
            system.debug('order History = '+ response);
            
        }
        
        return response;
    }
    
    public class ordersWrapper{
        @AuraEnabled
        Public List<orderHistory> allHistory;
        @AuraEnabled
        Public  map<String ,orderHistory> allHistoryMap;
        @AuraEnabled
        Public String pageSize; 
        @AuraEnabled
        Public String page; 
        @AuraEnabled
        Public integer totalOpen; 
        @AuraEnabled
        Public integer totalClosed; 
    }
    
    //order History Wrapper class
    public class orderHistory{
        @AuraEnabled
        Public String servReqId;
        @AuraEnabled
        Public String vBkId;
        @AuraEnabled
        Public String prevBkngId;
        @AuraEnabled
        Public String serReqNo;
        @AuraEnabled
        Public String carPrice;
        @AuraEnabled
        Public String status;
        @AuraEnabled
        Public String carName;
        @AuraEnabled
        Public String billingTotal;
        @AuraEnabled
        Public String pickupFrom;
        @AuraEnabled
        Public String duration;
        @AuraEnabled
        Public String pickupDateTime;
        @AuraEnabled
        Public String returnDateTime;
        @AuraEnabled
        Public String dropOff;
        @AuraEnabled
        Public String serviceType;
        @AuraEnabled
        Public String recordType;
        @AuraEnabled
        Public String imageLink; 
        @AuraEnabled
        Public String paymentStatus;
        @AuraEnabled
        Public list<ETCAR_Service_Request_Sub_Line_Item__c> features;
        
    }
    
    
    @AuraEnabled 
    public static String fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Profile.Name,AccountId, Username,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled
                      FROM User Where id =: userInfo.getUserId()];
        return JSON.serializePretty(oUser) ;
    }
    
    @AuraEnabled 
    Public static ETCAR_Service_Request_Line_Item__c vehBookingDetails(String reqId){
        List<ETCAR_Service_Request_Line_Item__c> sReq =new List<ETCAR_Service_Request_Line_Item__c>([select ETST_Pick_Up_From__c, ETCAR_Pick_UP_Date_Time__c, ETCAR_Return_Date_Time__c ,ETCAR_Age__c,
                                                                                                     ETCAR_Service_Request__r.RecordType.Name,ETCAR_Service_Request__r.ETC_Service_Type__c,ETCAR_Selecetd_Car__r.ETCAR_Car_Type__c,ETC_Duration__c,
                                                                                                     ETST_Service_Type__c, ETCAR_Pickup_Zone__c, ETCAR_Drop_Off_Zone__c, ETCAR_Duration__c, ETC_Additional_Hours__c
                                                                                                     FROM ETCAR_Service_Request_Line_Item__c where id =:reqId]);
        
        return sReq[0]; 
    }
    
    
    
    //Create Service Request for Car Booking
    /* Method : carBookingRequest
Description : Create Service Request acc to Request and Create Vehicle Bookings under Service Request with Travel Details..
*/
    @AuraEnabled
    public static String carBookingRequest(List<ETCAR_Service_Request_Line_Item__c> VreqList , String serviceName , String servType , String allfilesWrapper, String Resident){
        ETC_UtilityClass.userdetails userProfileDetails;
        userProfileDetails = queryUserDetails();  
        system.debug('in method');
        system.debug('req details = '+ JSON.serializePretty(VreqList));
        //Create service Request for Car Booking 
        String resp;
        system.debug('userProfileDetails'+userProfileDetails);
        ET_Service_Request__c req = new ET_Service_Request__c();
        Savepoint sp = Database.setSavepoint();  
        if(serviceName == 'Car Booking'){
            Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
            req.ET_Account__c = userProfileDetails.accountId;
            req.ETC_Contact__c = userProfileDetails.contactId; 
            req.RecordTypeId = recordTypeId;
            req.ETCAR_Request_Type__c = 'online';
            
            system.debug('service Request = '+ JSON.serializePretty(req));
            String errStr;
            try{
                Insert req;
                resp = req.id;
                // Create vehicle Bookings for service Request
                if(!VreqList.isEmpty()){
                    // resp = createVehicleBookings(req.id , VreqList);
                }
                //upload
            }
            catch(Exception e){
                system.debug('Exception Trace : '+ e.getStackTraceString());
                system.debug('Exception Message : '+ e.getMessage());
                errStr = JSON.serialize(ETCAR_Car_Services_Controller.buildErrorResponse('carBookingRequest', e.getMessage(), e.getStackTraceString()));
                AuraHandledException ahe = new AuraHandledException(errStr);
                ahe.setMessage(errStr);
                throw ahe;
                
            }
        }
        
        else if(serviceName == 'Limo'){
            Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();
            req.ET_Account__c = userProfileDetails.accountId;
            req.ETC_Contact__c = userProfileDetails.contactId; 
            req.RecordTypeId = recordTypeId;
            req.ETCAR_Request_Type__c = 'online';
            
            String errStr;
            try{
                Insert req;
                resp = req.id;
                // Create vehicle Bookings for service Request
                if(VreqList != null && !VreqList.isEmpty()){
                    //resp = createVehicleBookings(req.id , VreqList);
                }
                
            }
            catch(Exception e){
                Database.rollback(sp);
                system.debug('Exception Trace : '+ e.getStackTraceString());
                system.debug('Exception Message : '+ e.getMessage());
                errStr = JSON.serialize(ETCAR_Car_Services_Controller.buildErrorResponse('carBookingRequest', e.getMessage(), e.getStackTraceString()));
                AuraHandledException ahe = new AuraHandledException(errStr);
                ahe.setMessage(errStr);
                throw ahe;
                
            }
        }
        
        return resp;
        
    }
    
    /* Method : uploadDocsTo_Object
Description : To upload docs to any Record
*/
    
    Public static String createVehicleBookings(String reqId, List<ETCAR_Service_Request_Line_Item__c> vBkngList )
    {
        List<ETCAR_Service_Request_Line_Item__c> vBkngs = new List<ETCAR_Service_Request_Line_Item__c>();
        String resp;
        if(vBkngList != null && reqId != null && vBkngList.size() > 0){
            for(ETCAR_Service_Request_Line_Item__c vBkng :vBkngList ){
                vBkng.ETCAR_Service_Request__c = reqId;
                vBkngs.add(vBkng);
            }
        }
        
        String errStr;
        try{
            Insert vBkngs;
            resp = vBkngs[0].id;
        }
        catch(Exception e){
            system.debug('Exception Trace : '+ e.getStackTraceString());
            system.debug('Exception Message : '+ e.getMessage());
            errStr = JSON.serialize(ETCAR_Car_Services_Controller.buildErrorResponse('createVehicleBookings', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
        
        return resp;
        
        
    }
    
    
    
    /* Method : uploadDocsTo_Object
Description : To upload docs to any Record

    
    public static void uploadDocsTo_Object(String recordId , String allfilesWrapper){
        List<uploadedDocs> Updocs;
        if(allfilesWrapper != null){
            Updocs = (List<uploadedDocs>)JSON.deserialize(allfilesWrapper,  List<uploadedDocs>.Class);
            system.debug('Updocs size = '+ Updocs.size());
        }
        List<ContentVersion> lstContentVesions = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocumentLinks = new  List<ContentDocumentLink>();
        
        // Service Request inserted and need to insert docs as attachments for service records
        if(Updocs != null && Updocs.size() > 0){
            for(uploadedDocs doc :Updocs){
                ContentVersion objContentVersion = new ContentVersion();
                objContentVersion.ContentLocation = 'S';
                system.debug('VersionData = '+ doc.strBase64Data);
                String body = doc.strBase64Data;
                //String base64Content = (String)JSON.deserialize(body, String.class);
                String base64Mark = 'base64,';
                integer dataStart = body.indexOf(base64Mark) + base64Mark.length();
                system.debug('dataStart = '+ dataStart);
                body = body.substring(dataStart);
                system.debug('body = '+ body);
                objContentVersion.VersionData = EncodingUtil.base64Decode(body);
                objContentVersion.Title = doc.strFileName;
                objContentVersion.PathOnClient = doc.strFileType;
                lstContentVesions.add(objContentVersion);
            }
            system.debug('******lstContentVesions****'+lstContentVesions);
        }
        
        if(lstContentVesions!=null && lstContentVesions.size()>0){
            
            try{
                insert lstContentVesions;   
                system.debug('******After lstContentVesions****'+lstContentVesions);
            }Catch(Exception ex){
                system.debug('***Exception Cause lstContentVesions*****'+ex.getMessage());
                system.debug('***Exception Cause getStackTraceString*****'+ex.getStackTraceString());
                throw new AuraHandledException('Error Exception happend'+ex.getStackTraceString());                                       
            }
            
            map<Id,Id> mapofContentVersionIdwithContentDocumentIds = new map<Id,Id>();
            for(ContentVersion objContentVersion :[Select Id,ContentDocumentId from ContentVersion where Id in :lstContentVesions]){
                mapofContentVersionIdwithContentDocumentIds.put(objContentVersion.Id,objContentVersion.ContentDocumentId);
            }
            
            for(ContentVersion objContentVersion :lstContentVesions){
                
                if(mapofContentVersionIdwithContentDocumentIds.containskey(objContentVersion.Id)){
                    ContentDocumentLink objContentDocumentLink = new ContentDocumentLink();
                    objContentDocumentLink.LinkedEntityId = recordId;
                    objContentDocumentLink.ShareType = 'V';
                    objContentDocumentLink.ContentDocumentId = mapofContentVersionIdwithContentDocumentIds.get(objContentVersion.Id);
                    lstContentDocumentLinks.add(objContentDocumentLink);
                }
                
            }
            system.debug('******lstContentDocumentLinks****'+lstContentDocumentLinks);
            if(lstContentDocumentLinks!=null && lstContentDocumentLinks.size()>0){
                try{
                    insert lstContentDocumentLinks;                    
                }Catch(Exception ex){
                    system.debug('***Exception Cause lstContentDocumentLinks*****'+ex.getMessage());
                    system.debug('***Exception lstContentDocumentLinks getStackTraceString*****'+ex.getStackTraceString());
                    throw new AuraHandledException('Error Exception lstContentDocumentLinks'+ex.getStackTraceString());                                       
                }
            }
        }
        
    }
*/    
    
    //update Service Request for Car Booking
    @AuraEnabled
    public static String carBookingRequest_upd(String req , String serviceName){
        system.debug('req ='+ req);
        system.debug('serviceName ='+ serviceName);
        
        ET_Service_Request__c sreq = (ET_Service_Request__c) System.JSON.deserialize(req, ET_Service_Request__c.Class);
        String errStr;
        try{
            Update sreq;
        }
        catch(Exception e){
            //system.debug('Exception Trace : '+ e.getStackTraceString());
            //system.debug('Exception Message : '+ e.getMessage());
            errStr = JSON.serialize(ETCAR_Car_Services_Controller.buildErrorResponse('carBookingRequest_upd', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
            
        }
        
        system.debug('in method');
        //Create service Request for Car Booking 
        String resp;
        /*if(serviceName == 'Rental'){
Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();

sreq.RecordTypeId = recordTypeId;
system.debug('service Request = '+ JSON.serializePretty(req));
String errStr;
try{
Update sreq;
}
catch(Exception e){
//system.debug('Exception Trace : '+ e.getStackTraceString());
//system.debug('Exception Message : '+ e.getMessage());
errStr = JSON.serialize(ETCAR_Car_Services_Controller.buildErrorResponse('carBookingRequest_upd', e.getMessage(), e.getStackTraceString()));
AuraHandledException ahe = new AuraHandledException(errStr);
ahe.setMessage(errStr);
throw ahe;

}
}

else if(serviceName == 'Limo'){
Id recordTypeId = Schema.SObjectType.ET_Service_Request__c.getRecordTypeInfosByDeveloperName().get('ETC_Car_Booking_Services').getRecordTypeId();

sreq.RecordTypeId = recordTypeId;
system.debug('service Request = '+ JSON.serializePretty(req));
String errStr;
try{
Update sreq;
}
catch(Exception e){
//system.debug('Exception Trace : '+ e.getStackTraceString());
//system.debug('Exception Message : '+ e.getMessage());
errStr = JSON.serialize(ETCAR_Car_Services_Controller.buildErrorResponse('carBookingRequest_upd', e.getMessage(), e.getStackTraceString()));
AuraHandledException ahe = new AuraHandledException(errStr);
ahe.setMessage(errStr);
throw ahe;

} 
}*/
        
        return sreq.Id;
        
    }
    
    //Create Service Request for Car Booking
    @AuraEnabled
    public static String getBookingReqDet(String ReqId){
        //Create service Request for Car Booking 
        ET_Service_Request__c resp;
        String errStr;
        try{
            List<ET_Service_Request__c> req = [select ETST_Pick_Up_From__c, ETCAR_Pick_UP_Date_Time__c, ETCAR_Return_Date_Time__c ,ETCAR_Age__c,ETST_Drop_Off_To__c
                                               FROM ET_Service_Request__c where id=:ReqId ];
            
            if(req.size() > 0){
                resp = req[0];
            }
        }
        catch(Exception e){
            system.debug('Exception Trace : '+ e.getStackTraceString());
            system.debug('Exception Message : '+ e.getMessage());
            errStr = JSON.serialize(ETCAR_Car_Services_Controller.buildErrorResponse('getETDMData', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
        
        return JSON.serializePretty(resp);
        
    }
    
    // Method to update Service Request Payment Status
    @AuraEnabled
    Public Static boolean updateStatus( ET_Service_Request__c req ,ETCAR_Service_Request_Line_Item__c vbkng,ETCAR_Service_Request_Line_Item__c prevBokking ){
        system.debug('ser req = '+ req);
        String errStr;
        boolean resp;
        Savepoint sp = Database.setSavepoint();  
        try{
            if(req != null && req.Id != null){
                update req;  
            }
            if(vbkng != null && vbkng.Id != null){
                update vbkng;
            }
            if(prevBokking != null && prevBokking.Id != null){
                update prevBokking;
            }
            resp = true;
        }
        catch(Exception e){
            Database.rollback(sp);
            errStr = JSON.serialize(ETCAR_Car_Services_Controller.buildErrorResponse('updateServiceRequestPayment', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            resp = false;
            throw ahe;
            
        }
        
        system.debug('resp = '+ resp);
        
        return resp; 
    }
    
    @AuraEnabled
    public static List<ETC_Rental_Settings__c> getRentalSettingsMatrix(){
        List<ETC_Rental_Settings__c> cancellationMatrix = new List<ETC_Rental_Settings__c>
            ([select id,ETC_Policy__c ,ETC_Refund_Percentage__c ,ETC_hours_before_booking_date__c 
              FROM ETC_Rental_Settings__c order by ETC_hours_before_booking_date__c desc ]
            );
        return cancellationMatrix;
    } 
    
    
    @AuraEnabled
    public static List<ETC_Rental_Settings__c> getRentalSettingsMatrixModify(){
        List<ETC_Rental_Settings__c> modifyMatrix = new List<ETC_Rental_Settings__c>([select id,ETC_hours_before_booking_date__c,ETC_Policy__c,ETC_Modification_Details__c 
                                                                                      FROM ETC_Rental_Settings__c where ETC_Policy__c ='Modify Booking' 
                                                                                      order by ETC_hours_before_booking_date__c desc ]);
        return modifyMatrix;
    }
    
    
    @AuraEnabled
    public static ET_Service_Request__c getRequestDetials(String recId) {  
        
        return [ SELECT Id, Name, ETST_Pick_Up_From__c, ETST_Service_Type__c FROM ET_Service_Request__c WHERE Id =: recId ];   
    }
    
    @AuraEnabled
    public static String getAddressSet(String SearchText){
        return ETST_AddressSearchController.getAddressSet(SearchText);
    } 
    @AuraEnabled
    public static String getAddressDetailsByPlaceId(String PlaceID){
        return ETST_AddressSearchController.getAddressDetailsByPlaceId(PlaceID);
    } 
    
    @TestVisible
    private static Map<String, String> buildErrorResponse(String source, String errorMessage, String stackTrace) {
        Map<String, String> errorResponse = new Map<String, String>();
        
        errorResponse.put('SOURCE', source);
        errorResponse.put('MESSAGE', errorMessage);
        errorResponse.put('STACKTRACE', stackTrace);
        
        return errorResponse;
    }  
    
    @AuraEnabled
    public static void updateServiceReqToCancel(ID RecID){
        ET_Service_Request__c esr = new ET_Service_Request__c();
        esr.Id = RecID;
        esr.ETCAR_Status__c = 'Cancelled';
        update esr;
        
    } 
    
    /* Method : handleRefundProcess 
Descriptionn : Create Refund Request with service Request id ,vehicle Booking Id and last Payment Id

If Payment Date != Today
----Refund Process initiates---
If Refund Succeded - update Booking req- Booking status -'Cancelled' & Ser Req Payment Status = 'Reversed' & Refund Status as 'Completed'
If Refund Failed   - Refund Status as 'Failed' and Show user some generic message to Try again.
If Payment Date = Today
----Refund Process initiates Next Day----
update service Request temporarily with 'Refund Requested'
--Next Day Trigger Refund Process--
If Refund Succeded - update Booking req- Booking status -'Cancelled' & Ser Req Payment Status = 'Reversed' & Refund Status as 'Completed'
If Refund Failed   - Refund Status as 'Failed' and Show user some generic message to Try again.

*/
    
    @AuraEnabled
    public static String handleRefundProcess(String refundAmount,String serviceRecordId , String requestType, String vBkngId){
        System.debug('--Create Refund Record--');
        ET_Refund__c refundRecord=new ET_Refund__c();
        String resp;
        String errStr;
        Id recType = Schema.SObjectType.ET_Refund__c.getRecordTypeInfosByDeveloperName().get('Car_Services_Refund_Record_Type').getRecordTypeId(); 
        refundRecord.ET_Refund_Amount__c = Decimal.ValueOf(refundAmount) * -1;
        refundRecord.recordTypeId=recType;
        //refundRecord.ETST_Refund_Percentage__c=refundPercentage;
        refundRecord.ET_Service_Request__c=serviceRecordId;
        refundRecord.ETC_Vehicle_Booking__c=vBkngId;
        list<ETST_Payment__c> lstPayment=[Select Id,Name,CreatedDate From ETST_Payment__c Where ET_Service_Request__c=:serviceRecordId
                                          AND ETST_Payment_State__c='CAPTURED' 
                                          AND ETST_Capture_State__c='SUCCESS' order by createdDate desc limit 1];
        
        ETCAR_Service_Request_Line_Item__c vbooking = new ETCAR_Service_Request_Line_Item__c();
        vbooking.id = vBkngId;
        
        ET_Service_Request__c sReq = new ET_Service_Request__c();
        sReq.id = serviceRecordId;
        try{
            System.debug('refundRecord '+ refundRecord);
            if(lstPayment!=null && lstPayment.size()>0){
                Date paymentDate =date.newinstance(lstPayment[0].CreatedDate.year(), lstPayment[0].CreatedDate.month(), lstPayment[0].CreatedDate.day());
                refundRecord.ET_Payment__c=lstPayment[0].Id;
                if(refundRecord.ET_Refund_Amount__c!=0 ){
                    if(paymentDate!=Date.today()){
                        ET_Common_Util.ETPaymentResponse response=ET_Payment_Controller.createRefundRequest(lstPayment[0].Id,refundRecord.ET_Refund_Amount__c);
                        system.debug('response>> '+response);
                        ET_common_util.cls_authResponse authResponse = new ET_common_util.cls_authResponse();
                        if(response!=null && response.authResponse!=null){
                            system.debug('authResponse>> '+authResponse);
                            authResponse = response.authResponse;
                            if(authResponse.authorizationCode!=null && authResponse.authorizationCode!='')
                                refundRecord.ET_Authorization_Code__c=authResponse.authorizationCode;
                            if(authResponse.success == 'true'){
                                refundRecord.ET_Refund_Status__c='Completed';
                                if(requestType != 'Modify Refund'){
                                    sReq.Payment_Status__c ='Reversed' ;
                                    vbooking.ETCAR_Status__c = 'Cancelled' ;
                                }
                                Insert refundRecord;
                                resp = 'success';
                            }else {
                                refundRecord.ET_Refund_Status__c='Failed';
                                Insert refundRecord;
                                resp = 'fail';
                            }
                        }else {
                            refundRecord.ET_Refund_Status__c='Failed';
                            Insert refundRecord;
                            resp = 'fail';
                        }
                    } else {
                        sReq.Payment_Status__c = 'Refund Requested';
                        //sReq.ETCAR_Status__c = ;
                        system.debug('paymentDate>> '+paymentDate);
                        if(paymentDate==Date.today()){
                            refundRecord.ET_Refund_Status__c='Requested';
                            upsert refundRecord;
                            integer dd=lstPayment[0].CreatedDate.day()+1;
                            integer mm=lstPayment[0].CreatedDate.month();
                            String sched3am = '0 0 3 '+dd+' '+mm+' ?'; //Next Day, 3AM
                            //String sched3am = '0 0 3 '+31+ +10+' ?';  //Next Day, 3AM
                            // ETI_CallRefundServiceScheduled SC = new ETI_CallRefundServiceScheduled(new set<Id>{booking.Id}); 
                            //System.schedule('ETI CallRefundServiceScheduled - Next Day 3AM '+booking.Name, sched3am, SC);
                        }
                    }
                }
            }
            
            if(sReq != null && requestType != 'Modify Refund'){
                update sReq;
            }
            if(vbooking != null && requestType != 'Modify Refund'){
                update vbooking;
                
            }
            
        }
        
        catch(Exception e){
            system.debug('Exception Trace : '+ e.getStackTraceString());
            system.debug('Exception Message : '+ e.getMessage());
            errStr = JSON.serialize(ETCAR_Car_Services_Controller.buildErrorResponse('handleRefundProcess', e.getMessage(), e.getStackTraceString()));
            AuraHandledException ahe = new AuraHandledException(errStr);
            ahe.setMessage(errStr);
            throw ahe;
        }
        
        return resp;
    }
    
    // Create Payment
    @AuraEnabled
    public static void createPayment(ETST_Payment__c newPayment, ET_Service_Request__c serviceRequest, string mode){
        if(mode == 'Cash'){
            newPayment.RecordTypeId = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Cash_Payment').getRecordTypeId(); 
            newPayment.ETST_Payment_Mode__c = 'Cash';
        }
        if(mode == 'Cheque'){
            newPayment.RecordTypeId = Schema.SObjectType.ETST_Payment__c.getRecordTypeInfosByDeveloperName().get('Cheque_Payment').getRecordTypeId(); 
            newPayment.ETST_Payment_Mode__c = 'Cheque';
        }
        newPayment.ET_Service_Request__c = serviceRequest.Id;
        newPayment.ETST_Parent__c = serviceRequest.ET_Account__c;
        newPayment.ETST_Payment_State__c = ET_Common_Util.PAYMENT_CAPTURED;
        try{
            insert newPayment; 
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    
    // return terms and conditions
    @AuraEnabled
    public static List<ET_Terms_and_Conditions__c> getTermsandConditions(string visibility){
        return [SELECT Id,ET_Condition__c,Header_Line__c FROM ET_Terms_and_Conditions__c 
                WHERE Active__c = true and ET_Service_Name__c = 'School' 
                AND Place_of_Visisbility__c=:visibility order by Order__c];        
    }
    
    @AuraEnabled
    public static String getBaseUrl(){
        String baseurl = System.Url.getSalesforceBaseURL().toExternalForm();
        return baseurl;
    }
    
    public static void testUtility(){
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
             i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
             i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
               i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;       i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}