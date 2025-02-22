({
    doInit : function(component, event, helper)  {
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getParentRefundHistory";
        var params = {
            //"schoolId" : component.get('v.schoolId')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                
                component.set('v.refundHistList',response);
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("School Tranport", errorToShow, "error", "dismissible");
            })
        )	
    }
})