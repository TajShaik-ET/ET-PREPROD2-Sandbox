({
    getInitData : function(component, event, helper) {
        var action = component.get("c.validateMobileNumber1");
        var rid = component.get("v.recordId");
        action.setParams({ CaseId : rid });
        console.log('the '+ rid);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retrurnValue = response.getReturnValue();
                    /*toastEvent.setParams({
                        "message": message
                    });
                    toastEvent.fire();*/
                    //component.set("v.isError", false);
                    $A.get("e.force:closeQuickAction").fire();
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "error",
                    "message": "Failed to click on custom button "+ errors[0].message
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
               
            }
        });
       
        $A.enqueueAction(action);     
    }
  })