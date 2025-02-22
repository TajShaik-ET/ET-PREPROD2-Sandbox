({
    doInit : function(component, event)  {
        var utility = component.find("ETI_UtilityMethods");
        var backendMethod = "getMyCases";
        var params = {
            "stDate" : component.get("v.startDate"),
            "enDate" : component.get("v.endDate")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                component.set('v.caseList',response);
            }),
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Vehicle Inspection", errorToShow, "error", "dismissible");
            })
        )	
    },
    showSpinner: function(component){
        component.set("v.IsSpinner",true);  
    },
    
    hideSpinner: function(component){
        component.set("v.IsSpinner",false);  
    }, 
})