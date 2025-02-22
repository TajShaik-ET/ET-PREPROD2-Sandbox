({
	//Taj
    showToast : function(component, event, helper, title, message, type, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title, //Info //Success //Error //Warning
            message: message,
            duration:'5000',
            type: type, //info //success //error //warning
            mode: mode //dismissible //pester //sticky
        });
        toastEvent.fire();
    },
})