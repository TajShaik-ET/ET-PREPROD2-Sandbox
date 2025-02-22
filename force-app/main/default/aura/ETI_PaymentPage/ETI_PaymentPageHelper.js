({
    getGoogleMarker:function(component, event, helper){
        component.set('v.mapMarkers', [
            {
                location: {
                    City: 'Abu Dhabi',
                    Country: 'UAE',
                    State: 'Abu Dhabi',
                    Street: 'Yas Island'
                },
                
                title: 'The White House',
                description: 'Landmark, historic home & office of the United States president, with tours for visitors.'
            }
        ]);
        component.set('v.zoomLevel', 15);
    },
    
    
    bookingdetails: function(component, event, helper) {
        var action = component.get("c.getBookingDataFromBookingId");
        var con=component.get("v.recordidurl");
        action.setParams({
            "bookingid": con
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("{!v.booking}",response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    
    UpdateBookingRecord: function(component, event, helper,paymentmethod) {
        // passing Insepction service id
        var action = component.get("c.UpdateBookingRecordForPayment");
        var con=component.get("v.recordidurl");
        action.setParams({
            "bookingid": con,
            "paymenttype":paymentmethod
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = JSON.stringify(response.getReturnValue());
            }
        });
        $A.enqueueAction(action); 
    },
    navigateToUrl: function (component, event,helper,recordId) {
        console.log('recordId>> '+recordId);
        var action = component.get("c.isReceiptGenerated");
        action.setParams({
            recordId : recordId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('navigateToUrl result>> '+JSON.stringify(result));
                if(result)
                    window.open("/apex/ETI_Receipt?&id=" + recordId);
                else 
                    window.open("/apex/ETI_Invoice?&id=" + recordId);
            }
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/eti-homepage?lang='+component.get("v.clLang")
            });
            urlEvent.fire();
        });
        $A.enqueueAction(action);
    },
    /*getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    }*/
})