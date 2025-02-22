({
    
    getServiceDetails: function(component, event, helper) {
        console.log('Updating the status...');
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getServiceRecord";
        var params = {
            "recordId" : component.get("v.requestId") 
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.serviceRecord',response);
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    deactivateService : function(component, event, helper) {
        console.log('Updating the status...');
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "updateTransportRequestStatus";
        var params = {
            "serviceRecordId" : component.get("v.requestId"),
            "status" : 'School Changed',
            "isActive":false
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('Updated the status...');
                //helper.redirectTo(component, '/etst-home-page');
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },
    getImageContent : function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getImageContent";
        var params = {
            "docId" : component.get("v.documentId"),
            "studentId" : component.get("v.recordId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
              component.set('v.imageURL',component.get('v.prefixURL')+response);  
              $A.util.removeClass(component.find("showImage"), "slds-hide");
              $A.util.removeClass(component.find("closeModelRefresh"), "slds-hide");
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    },

    redirectTo : function(component, page) {
        var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                            "url": page                            
                        });
        urlEvent.fire();
    },
     updateLocationHelper: function(component, event, helper){
            var utility = component.find("ETST_UtilityMethods");
            var backendMethod = "updateLocation";
            var params = {
                "latitude" : component.get("v.lat"),
                "longitude" : component.get("v.lon"),
                'requestId': component.get("v.requestId"),
                "type" : component.get('v.locType')
            };
            var promise = utility.executeServerCall(component, backendMethod, params);
            
            promise.then (
                $A.getCallback(function(response) {
                    component.set('v.openpickupMap',false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type": "success",
                            "message": "The location has been updated successfully."
                        });
                        toastEvent.fire();
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/etst-home-page'                      
                    });
                    urlEvent.fire();
                    //$A.get('e.force:refreshView').fire();
                }),
                
                $A.getCallback(function(error) {
                    var err = JSON.parse(error);
                    var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                    console.log(errorToShow);
                    utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
                })
            )	
        },
     getAddressRecommendations: function(component, event,helper,searchText){
            var utility = component.find("ETST_UtilityMethods");
            var backendMethod = "getAddressSet";
            var params = {
                "SearchText" : searchText
            };
            var promise = utility.executeServerCall(component, backendMethod, params);
            
            promise.then (
                $A.getCallback(function(response) {
                    var addressResponse = JSON.parse(response);
                    var predictions = addressResponse.predictions;
                    var addresses = [];
                    if (predictions.length > 0) {
                        var placeId=predictions[0].place_id;
                        helper.getAddressDetailsByPlaceId(component,event,helper,placeId);
                        $A.util.addClass(component.find("invalidLoc"), "slds-hide");
                    }else{
                        
                        $A.util.removeClass(component.find("invalidLoc"), "slds-hide"); 
                        component.set('v.mapLoaded',true);
                    }
                    
                }),
                
                $A.getCallback(function(error) {
                    var err = JSON.parse(error);
                    var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                    console.log(errorToShow);
                    utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
                })
            )	
            
        },
        
        //get address details by place Id from google API 
        getAddressDetailsByPlaceId: function(component,event,helper,placeId){
            var utility = component.find("ETST_UtilityMethods");
            var backendMethod = "getAddressDetailsByPlaceId";
            var params = {
                PlaceID:placeId 
            };
            var promise = utility.executeServerCall(component, backendMethod, params);
            
            promise.then (
                $A.getCallback(function(response) {
                    console.log('response'+response);
                    var addressResponse = JSON.parse(response);
                    component.set('v.lat',addressResponse.result.geometry.location.lat);
                    component.set('v.lon',addressResponse.result.geometry.location.lng);
                    component.set('v.mapLoaded',true);
                    component.set('v.vfUrl','/apex/ETST_GoogleMapFinder?lat='+addressResponse.result.geometry.location.lat+'&long='+addressResponse.result.geometry.location.lng);
                    
                }),
                
                $A.getCallback(function(error) {
                    var err = JSON.parse(error);
                    var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                    console.log(errorToShow);
                    utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
                })
            )	
            
        },
        
})