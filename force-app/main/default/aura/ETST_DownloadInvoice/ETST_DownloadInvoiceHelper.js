({
	getServerId : function(component, event, helper) {
        var utility = component.find("ETST_UtilityMethods");            
        var backendMethod = "getServiceReqId";
        var params = {
            "recordId" : component.get("v.recordId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        
        promise.then (
            $A.getCallback(function(response) {
                console.log('response***'+JSON.stringify(response.service));
                 console.log('response2***'+JSON.stringify(response));
               // component.set('v.serviceRequest',response.service);
		        var urlEvent = $A.get("e.force:navigateToURL");
				urlEvent.setParams({
				"url": "/apex/ETST_InvoicePage?id="+response,
				"target": "_blank"
				});
               // urlEvent.fire();
                $A.get("e.force:closeQuickAction");
                window.open("/apex/ETST_InvoicePdf?id="+response,'_blank');
				
                //window.location="/apex/ETST_InvoicePage?id="+response;
                
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