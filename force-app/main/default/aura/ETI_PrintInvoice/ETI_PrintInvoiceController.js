({
	doinit : function(component, event, helper) {
        component.set("v.IsSpinner", true);
		var recordId = component.get("v.recordId");
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        window.open("/apex/ETI_Invoice?id="+ recordId);
	}
})