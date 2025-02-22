({
	updateInsurancePoliciy : function(component, event, helper) {
		var action = component.get("c.updateInsurancePoliciy");
       var recordId =  component.get('v.recordId');
        action.setParams({ 
            recordId : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state)
            if (state === "SUCCESS") {
                 var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
               
               
                if(result == 'notUpdate'){
                    toastEvent.setParams({
                        "type": "info",
                        "title": "Info!",
                        "message": "The record has already approved or rejected."
                    });
                }else if(result == 'update'){
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "The record has been updated successfully."
                    });
                }else{
                     toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": "Something went wrong."
                    });
                }
                 toastEvent.fire();
         		$A.get("e.force:closeQuickAction").fire()
            }
            else if (state === "INCOMPLETE") {
                $A.get("e.force:closeQuickAction").fire()
                // do something
            }else if (state === "ERROR") {
                $A.get("e.force:closeQuickAction").fire()
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
	},
})