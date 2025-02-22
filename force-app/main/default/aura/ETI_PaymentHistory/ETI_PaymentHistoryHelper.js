({
    doInit : function(component, event)  {
        var utility = component.find("ETI_UtilityMethods");
        var backendMethod = "getPaymentHistory";
        var params = {
            "stDate" : component.get("v.startDate"),
            "enDate" : component.get("v.endDate")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.paymentHistList',response);
            }),
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Vehicle Inspection", errorToShow, "error", "dismissible");
            })
        )	
    },
    getBookingAndVehicle1 : function(component, event, helper) {
        /*var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });*/
        var currentservice= component.get("v.serviceid");
        var action = component.get("c.getBookingAndVehicle");
        action.setParams({
            "serviceId" : currentservice
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var bookingList = response.getReturnValue();
                component.set('v.bookingList', bookingList);
                //alert(component.get('v.bookingList'));
            }
        });
        $A.enqueueAction(action);
    }
    
})