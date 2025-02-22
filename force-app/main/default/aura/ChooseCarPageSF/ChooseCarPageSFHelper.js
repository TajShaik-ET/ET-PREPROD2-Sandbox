({
	 getItenaryDetailsfromURL : function(component, event, helper){
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;

        for (i = 0; i < sURLVariables.length; i++) {
            //console.log('type of = '+ typeof sURLVariables);
            //console.log('url Params = '+ JSON.stringify(sURLVariables.BookingReq));
            
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            console.log('typeof ='+ typeof sParameterName);
            console.log('sParameterName '+i +' '+ sParameterName);
            if (sParameterName[0] === 'reqId') { //lets say you are looking for param name - firstName  
                console.log('reqid = '+ sParameterName[1]);
                component.set("v.bReqId",sParameterName[1] );
            }
            if (sParameterName[0] === 'src') { //lets say you are looking for param name - firstName  reqType
                console.log('src = '+ sParameterName[1]);
                component.set("v.reqType",sParameterName[1] ); 
            }
            if (sParameterName[0] === 'servType') { //lets say you are looking for param name - firstName  reqType
                console.log('servType = '+ sParameterName[1]);
                component.set("v.servType",sParameterName[1] ); 
            }
            /*if (sParameterName[0] === 'serReqId') { //lets say you are looking for param name - firstName  reqType
                console.log('serReqId = '+ sParameterName[1]);
                component.set("v.serReqId",sParameterName[1] ); 
            }*/
        }
    },
    getCarinfo : function(component,page) {
        console.log('req Id new = '+ component.get("v.bReqId"));
        component.set('v.loaded', !component.get('v.loaded'));
        var utility = component.find("ETCAR_UtillityMethods");
        var backendMethod = "getcarDetails";
        var pageSize = component.get("v.pageSize");
        var selModels = component.get("v.selectedCarModels");
        console.log('sel models = '+ selModels );
        var params = {
            "reqId" : component.get("v.bReqId"),
            "pageSize": pageSize,
            "pageNumber": page || 1,
            "sel_carModels" :selModels,
            "types":component.get("v.selectedCarTypes"),
            "segment":component.get("v.selectedCarSegment"),
            "carRecordType":component.get("v.carInventoryType")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                
                console.log('Cars = '+response);
                component.set('v.loaded', !component.get('v.loaded'));
                var cars = JSON.parse(response);
                component.set("v.cars",cars);
                // Iterate over cars and get its models
                if(cars != null && cars != undefined && cars.length > 0){
                    component.set('v.carModels' ,cars[0].models);
                    console.log('car models = '+cars[0].models.length);
                    component.set("v.page", cars[0].page);
                   
                    component.set("v.total", cars[0].total);
                    console.log('total = '+component.get("v.total"));
                    component.set("v.pages", Math.ceil(cars[0].total/pageSize));
                }
                
            }),
            
            $A.getCallback(function(error) {
                component.set('v.loaded', !component.get('v.loaded'));
                console.error('Errpr :'+error);
                utility.showToast("ET Car Services", error, "error", "dismissible");
            })
        )	
    },
   
    
    getCurrentUserDetails : function(component, event, helper){
        var utility = component.find("ETCAR_UtillityMethods");
        var backendMethod = "fetchUser";
        var params = {
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('user = '+response);
                component.set("v.userInfo",JSON.parse(response));
                console.log('Profile Name = '+ component.get("v.userInfo").Profile.Name); 
                component.set("v.profileName",component.get("v.userInfo").Profile.Name);
            }),
            
             $A.getCallback(function(error) {
                console.error('Errpr :'+error);
                utility.showToast("ET Car Services", error, "error", "dismissible");
            })
        )	
    },
      
    saveSelectedCar : function(component, event, helper){
        var utility = component.find("ETCAR_UtillityMethods");
        component.set('v.loaded', !component.get('v.loaded'));
        var backendMethod = "createSelctedCar";
        console.log('selected car in save = '+ JSON.stringify(component.get("v.selectedCar" )));
        var params = {
            "reqId" : component.get("v.bReqId"),
            "serReqId" : component.get("v.serReqId"),
            "seltdCar":JSON.stringify(component.get("v.selectedCar")) ,
            "featuresJ" : JSON.stringify(component.get("v.selectedFeaturesList"))
        };
       // alert("serReqId" + component.get("v.serReqId"));
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.loaded', !component.get('v.loaded'));
                if(response.includes("Failed")){
                    console.error('response = '+ response); 
                    utility.showToast("Car Services", 'Internal Error! Please contact ET', "error", "dismissible");
                }
                else{
                    component.set("v.selectedCarId", response);
                    //Refresh the Page once:
                    $A.get('e.force:refreshView').fire();
                    // Navigate to Payment Page
                  /*  var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/etcars-paymentpage?selCar_Id="+response+"&serReqId="+component.get("v.serReqId")+"&reqId="+component.get("v.bReqId")+"&servType="+component.get("v.servType")
                    }); */
                   
         utility.showToast("Success!", "Car Booked Successfully", "success", "dismissible");
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": component.get("v.bReqId"),
                        // "slideDevName": "related"
                    });
                    
                    navEvt.fire();                    
                    
                }
                
            }),
            
            $A.getCallback(function(error) {
                console.error('Errpr :'+error);
                utility.showToast("ET Car SeSrvices", error, "error", "dismissible");
            })
        )	
    }
   
    
 })