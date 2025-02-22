({
    doInit : function(component, event, helper)  {
        var utility = component.find("ETST_UtilityMethods");
        var backendMethod = "getParentPaymentHistory";
        var params = {
            "studentId" : component.get('v.requestId')
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
               component.set('v.paymentHistList',response);
               
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                console.log(errorToShow);
				utility.showToast("School Tranport", $A.get("$Label.c.ETST_Customer_Error_Msg"), "error", "dismissible");
            })
        )	
    }
})