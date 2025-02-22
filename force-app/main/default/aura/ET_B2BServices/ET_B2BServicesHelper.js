({
	accountDetails : function(component, event, helper) {
    //	var action = component.get("c.getAccountDetails");
        var action = component.get("c.getChangelocationFromContact");
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state>>---- '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result onload>> '+JSON.stringify(result));
                component.set("v.emirate",result);
            }
        });
        $A.enqueueAction(action);
     },
})