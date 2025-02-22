({
	closeModel : function(component, event, helper) {
		$A.get("e.force:closeQuickAction").fire();
	},
    cancelPayment : function(component, event, helper) {
        helper.cancelPaymentHelper(component, event);
	},
    toggleSpinner : function(component,event,helper){
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, 'slds-hide');
    }
    
})