({
    doInit : function(component, event, helper) {
        helper.getItenaryDetailsfromURL(component, event, helper);
        helper.getCarinfo(component);
        helper.getCurrentUserDetails(component, event, helper);
        //helper.getServiceReqDetails(component, event, helper);
        console.log('test ='+JSON.stringify(component.get("v.serRequest")));
        
        var serType = component.get("v.serRequest[0].ETST_Service_Type__c");
        console.log('serType = '+ serType );
        if(serType == 'One Way'){
            component.set("selTabId",'oneWay'); 
        }
        else if(serType == 'Hourly'){
            component.set("selTabId",'HOURLY'); 
        }
        //console.log('Time = '+ component.get("v.serviceRecord").ETCAR_Pick_UP_Date_Time__c);
        // helper.calculateCarPrice(component, event, helper);
    },
    
    handlecarModelsEvent: function(component, event, helper) {
        console.log('selectedCarModels = '+ event.getParam("carModels"));
        console.log('selectedcarTypes = '+ event.getParam("carTypes"));
        console.log('selectedcarSegment = '+ event.getParam("carSegment"));
        var selModels = event.getParam("carModels");
        component.set("v.selectedCarModels" ,event.getParam("carModels"));
        component.set("v.selectedCarTypes" ,event.getParam("carTypes"));
        component.set("v.selectedCarSegment" ,event.getParam("carSegment"));
        //call server method to get the cars with selected Models
        helper.getCarinfo(component);
    },
    
    handleEdit:function(component, event, helper) {
        //Navigate to Booking Page 
        var urlEvent = $A.get("e.force:navigateToURL");
        if(component.get("v.reqType") =="Rental" ){
            urlEvent.setParams({
                "url": "/car-rental-booking-form?reqId="+component.get("v.bReqId")+"&src=ChooseCar"+
                "&isChooseCar="+component.get("v.chooseCarPage") +"&reqType="+component.get("v.reqType")+"selTabId="+component.get("v.selTabId")
            });
            urlEvent.fire();
        }
        else if(component.get("v.reqType") =="Limo"){
            urlEvent.setParams({
                "url": "/Limousine-Services?reqId="+component.get("v.bReqId")+"&src=ChooseCar"+
                "&isChooseCar="+component.get("v.chooseCarPage")+"&reqType="+component.get("v.reqType")+"selTabId="+component.get("v.selTabId")
            });
            urlEvent.fire();
        }  
    },
    
    
    onCarSelect : function(component, event, helper) {
        var carId= event.getSource().get("v.name");
        component.set("v.openFeatures", true);
        component.set("v.selectedCarId", carId);
        //save the selected Car
        var wcars= component.get("v.cars");
        for(var i=0 ; i < wcars.length ; i++ ){
            if(wcars[i].Car.Id == carId){
                component.set("v.selectedCar" , wcars[i]);
                //caculate the Car price according to Booking Dates
                //wcars[i].carPrice = wcars[i].Car.ETCAR_Daily_Price__c;
                // add the Calculated Car price to the billingTotal
                component.set("v.billingTotal", wcars[i].carPrice );
            }
        }
        
        //calculate Charges for Car
        
        
        console.log('selected car = '+ JSON.stringify(component.get("v.selectedCar")));
        
    },
    handleHome :  function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/"+component.get("v.serReqId")
        });
        urlEvent.fire();
    },
    handlePrevious :  function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/n/Book_Vehicle?c__recId="+component.get("v.serReqId")
        });
        urlEvent.fire();
    },
    //
    onFeatureSelect :  function(component, event, helper) {
        
        var checkedValue=event.getSource().get('v.checked');
        if(checkedValue){
            //  var selectedFeature = component.get("v.selectedFeature");
            var selFeatureMapList = component.get("v.selectedFeaturesList");
            if(selFeatureMapList==null || selFeatureMapList== undefined || selFeatureMapList==''){
                selFeatureMapList=[];   
            }
            //alert('test = '+event.getSource().get('v.id').split("-")[0]);
            var selectedFeature={
                'name':event.getSource().get('v.id').split("-")[0],
                'id' : event.getSource().get('v.id').split("-")[1],
                'quantity':event.getSource().get('v.id').split("-")[2],
                'price':event.getSource().get('v.name')
            }
            //add selectedFeature in map Array
            selFeatureMapList.push(selectedFeature);
        }
        else{
            //Remove selectedFeature in map Array
            var selFeatureMapList = component.get("v.selectedFeaturesList");
            //iterate
            if(selFeatureMapList.length > 0){
                for(var index = 0; index < selFeatureMapList.length; index++){
                    var currntMap = selFeatureMapList[index];
                    //console.log('name == '+ currntMap['name']);
                    //console.log('id = '+ event.getSource().get('v.id').split("-")[0]);
                    if(currntMap['name'] == event.getSource().get('v.id').split("-")[0]){
                        selFeatureMapList.splice(index , 1);
                    }
                }
            } 
        }
        
        component.set("v.selectedFeaturesList" , selFeatureMapList);
        console.log('selectedFeaturesList  = '+ JSON.stringify(component.get("v.selectedFeaturesList")));
    },
    
    /* Method : onQuantityUpdate
       Description : When Features Quantity update change the quantity in -- selectedFeaturesList
    */
    onQuantityUpdate : function(component, event, helper) {
        var selFeatureMapList = component.get("v.selectedFeaturesList");
        console.log('selFeatureMapList'+JSON.stringify(component.get("v.selectedFeaturesList")));
        if(selFeatureMapList){
            if(selFeatureMapList.length > 0){
                for(var index = 0; index < selFeatureMapList.length; index++){
                    var currntMap = selFeatureMapList[index];
                    console.log('name == '+ currntMap['name']);
                    console.log('id = '+ event.getSource().get('v.id').split("-")[0]);
                    if(currntMap['name'] == event.getSource().get('v.id')){
                        currntMap['quantity'] = event.getSource().get('v.value');
                    }
                }
            } 
        }
    },
    
    onCancel : function(component, event, helper) {
        
        component.set("v.openFeatures", false);
    },
    
    navigateForBooking: function(component, event, helper) {
        
        //Calculate Total Bill Amount -Add Car Price and Total features amount
        
        /* var features =  component.get("v.selectedFeaturesList");
        var featuresAmnt =0;
        if(features != null && features !='' && features.length >0){
            for(var i=0 ; i<features.length ; i++){
                console.log('price = '+features[i].price);
                featuresAmnt += features[i].price;
            }
        }
        console.log('featuresAmnt = '+ featuresAmnt);
        //add features Amount to BillingTotal Varible
        component.set("v.billingTotal",   component.get("v.billingTotal")+featuresAmnt );
        
        console.log('billingTotal = '+ component.get("v.billingTotal"));
*/
        //Create the selected Car as Service Request Line Item
        helper.saveSelectedCar(component, event, helper);
        
    },
    
    onPagePrevious: function(component, event, helper) {
        var page = component.get("v.page") || 1;
        console.log('page = '+ page);
        page = page - 1;
        console.log('page2 = '+ page);
        helper.getCarinfo(component, page);
        
    },
    
    onPageNext: function(component, event, helper) {
        var page = component.get("v.page") || 1;
        page = page + 1;
        helper.getCarinfo(component, page);
    }
    
})