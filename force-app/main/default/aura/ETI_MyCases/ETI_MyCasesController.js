({
	doInit : function(component, event, helper) {
        helper.showSpinner(component);
        helper.doInit(component, event);
        helper.hideSpinner(component);
    }
    
})