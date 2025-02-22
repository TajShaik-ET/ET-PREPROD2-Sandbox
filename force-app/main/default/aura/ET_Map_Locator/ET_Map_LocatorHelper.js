({
	readData : function(cmp,event) {
		 // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get("c.loadVehiclesByPlateNo");
        action.setParams({ PlateNo : cmp.get("v.PlateNo"),isAllVehicles: cmp.get("v.showAll") });

        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var markers = response.getReturnValue();
                console.log(markers);
                
                var defaultLatitude;
                var defaultLongitude;
                try{
                if(markers.length > 1){
                    var row = markers[0].location; 
                    defaultLatitude = row.Latitude;
                    defaultLongitude = row.Longitude;
                }
                }
                catch(error){
                    console.log(error.message);
                }
                console.log(defaultLatitude);
                console.log(defaultLongitude);
                if(!cmp.get("v.showAll"))
                {
                    cmp.set('v.zoomLevel', 8);
                    
                }
                else
                {
                    console.log('inside center');
                    cmp.set('v.zoomLevel', 8);
                }
                cmp.set('v.center', {
                    location: {
                        Latitude:'25.3850883',
                        Longitude: '55.4444383'
                    }
                });
                cmp.set('v.mapMarkers',markers);
                cmp.set('v.listViewType','hidden');
               	cmp.set('v.markersTitle', 'Location Details');
                cmp.set('v.showFooter', false);
                console.log('Loaded successfully');
            }
            else if (state === "INCOMPLETE") {
                // do something
                console.log("Some error occured during process");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
	},
    readETData : function(cmp,event) {
		 // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get("c.loadETLocations");
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var markers = response.getReturnValue();
                console.log(markers);
                
                var defaultLatitude;
                var defaultLongitude;
                try{
                if(markers.length > 1){
                    var row = markers[0].location; 
                    defaultLatitude = row.Latitude;
                    defaultLongitude = row.Longitude;
                }
                }
                catch(error){
                    console.log(error.message);
                }
                console.log(defaultLatitude);
                console.log(defaultLongitude);
                if(!cmp.get("v.showAll"))
                {
                    cmp.set('v.zoomLevel', 8);
                    
                }
                else
                {
                    console.log('inside center');
                    cmp.set('v.zoomLevel', 8);
                }
                cmp.set('v.center', {
                    location: {
                        Latitude:'25.3850883',
                        Longitude: '55.4444383'
                    }
                });
                cmp.set('v.mapMarkers',markers);
                cmp.set('v.listViewType','hidden');
               	cmp.set('v.markersTitle', 'Location Details');
                cmp.set('v.showFooter', false);
                console.log('Loaded successfully');
            }
            else if (state === "INCOMPLETE") {
                // do something
                console.log("Some error occured during process");
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
	}
})