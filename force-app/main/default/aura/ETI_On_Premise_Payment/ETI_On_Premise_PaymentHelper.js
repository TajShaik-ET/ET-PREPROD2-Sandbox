({
	getRecordtypeId: function(component) {
        var action = component.get("c.getB2BRecordtypeId");
        action.setParams({ 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var b2brecordtypeId = response.getReturnValue();
                console.log('b2brecordtypeId  ' , b2brecordtypeId);
                component.set('v.b2brecordtypeid', b2brecordtypeId);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
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
            //$A.util.toggleClass(component.find("spinner"), 'slds-hide');
        });
        $A.enqueueAction(action);
    }
})