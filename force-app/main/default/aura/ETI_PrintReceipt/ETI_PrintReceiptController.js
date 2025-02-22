({
	doinit : function(component, event, helper) {
        component.set("v.IsSpinner", true);
		var recordId = component.get("v.recordId");
        console.log('srId>>> '+recordId);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        var action = component.get("c.getSyncAmanReciept");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var res = response.getReturnValue();
                console.log('res--->'+res);
                if(res === 'Synched')   
                    window.open("/apex/ETI_Receipt?id="+ recordId);
                else if(res === 'Cancel'){
                    var msg='Print Receipt not allowed for Cancelled Bookings.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Info!",msg,"","dismissible","info");
                }
                else if(res === 'NotSynched'){
                    var msg='Receipts are not Synched with Aman system.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Info!",msg,"","dismissible","info");
                }
                component.set("v.IsSpinner", false);
            }else {
                var msg='Unexpected error occurred while processing your request, Please try again or contact system admin.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error!",msg,"","dismissible","error");
                component.set("v.IsSpinner", false);
            }
        });
        $A.enqueueAction(action);
	}
})