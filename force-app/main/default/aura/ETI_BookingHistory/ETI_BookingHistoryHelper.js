({
    doInit : function(component, event)  {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var recordId = this.getJsonFromUrl().recordId;
        component.set('v.vehId', recordId);
        console.log('url recordId>> '+recordId);
        var utility = component.find("ETI_UtilityMethods");
        var backendMethod = "getBookingHistory";
        var params = {
            "isWalkIn": false,
            "vehicleId": recordId, //component.get("v.vehId"),
            "stDate" : component.get("v.startDate"),
            "enDate" : component.get("v.endDate")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('response>> '+JSON.stringify(response));
                component.set('v.VehicleList',response);
            }),
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Vehicle Inspection", errorToShow, "error", "dismissible");
            })
        )	
    },
    deleteVehicle : function(component, event, helper,row) {
        var rows = component.get('v.VehicleList');
        var rowIndex = rows.indexOf(row);
        rows.splice(rowIndex, 1);
        component.set('v.VehicleList', rows);
        var action = component.get("c.deleteVehicles");
        action.setParams({
            "rowid" : row.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            $A.get('e.force:refreshView').fire();      
        });
        $A.enqueueAction(action);
    },
    getJsonFromUrl : function (component, event, helper) {
        var query = location.search.substr(2);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    
})