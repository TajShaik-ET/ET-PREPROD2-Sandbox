({
    doInit : function(component, event, helper) {
        let recId=component.get("v.recordId");
        var action = component.get('c.updatePostServicePayment');
        
        action.setParams({
            recId : recId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                response.getReturnValue()
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
                // Display the total in a "toast" status message
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Error",
                    "type":error,
                    "message": "Something gone wrong please contact support"
                });
                resultsToast.fire();
            }
            window.location.reload();
            
            // Close the action panel
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        
        $A.enqueueAction(action);
    }
})