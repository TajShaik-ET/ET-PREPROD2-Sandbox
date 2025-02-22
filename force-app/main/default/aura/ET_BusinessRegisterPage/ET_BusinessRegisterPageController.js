({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    clickCreate: function(component, event, helper) {
        let validReg = component.find('registrationForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validReg){
            // Create the new expense
            let newRegistration = component.get("v.newRegistration");
            console.log("Create expense: " + JSON.stringify(newRegistration));
            helper.createRegistration(component, newRegistration);
        }
    }
})