({
doInit : function(component, event, helper)  {
    var utility = component.find("ETST_UtilityMethods");
    var backendMethod = "getParentCaseHistory";
    var params = {
        //"schoolId" : component.get('v.schoolId')
    };
    var promise = utility.executeServerCall(component, backendMethod, params);
    
    promise.then (
        $A.getCallback(function(response) {
            component.set('v.caseList',response);
            
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
})