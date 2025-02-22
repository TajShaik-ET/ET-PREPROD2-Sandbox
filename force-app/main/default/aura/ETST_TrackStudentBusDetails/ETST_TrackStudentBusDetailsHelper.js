({
    doInit : function(component, event, helper) {
        
        var utility = component.find("ETDM_UtilityMethods");
        var backendMethod = "getDriverLocationDetails";
         var params = {
            "workOrderId" : component.get('v.workOrderId')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
               // component.set('v.driverList',response);
			 component.set('v.mapMarkers', [
                {
                    location: {
                        Latitude: response.userAccount.Account.BillingLatitude,
                        Longitude: response.userAccount.Account.BillingLongitude
                    } ,
                    title: 'Pickup Location',  
                   
                },
                 {
                    location: {
                        Latitude: response.ServiceResourceRecord.LastKnownLatitude,
                        Longitude: response.ServiceResourceRecord.LastKnownLongitude
                    } ,
                    title: 'Delivery Agent Location',  
                   
                },
                
                {
                    location: {
                        Latitude: response.WorkOrderRecord.Latitude,
                        Longitude: response.WorkOrderRecord.Longitude
                    } ,
                    title: 'Delivery Location',  
                   
                }
            ]);
           
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Delivery Management", errorToShow, "error", "dismissible");
            })
        )	
    } 
    
    })