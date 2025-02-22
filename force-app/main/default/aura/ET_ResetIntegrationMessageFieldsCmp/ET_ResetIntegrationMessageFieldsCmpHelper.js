({
		resetIntegrationMessageValue : function(cmp) {		
		// reset integration message
		console.log('----recordId-- ' + cmp.get("v.recordId")+'--sObjectname--'+cmp.get("v.sObjectName"));
		var sRecordId=cmp.get("v.recordId");
		var sObjectname=cmp.get("v.sObjectName");
		var str1=sObjectname+':'+sRecordId;
		console.log(str1);
		// Invoke controller method
		var action = cmp.get("c.resetIntegrationMessageFields");
		action.setParams({'objToIDString': str1});
		action.setCallback(this, function(response) {
		var state = response.getState();
		if (state === "SUCCESS") {
		// refresh the recordpage view
		var hitRefresh =$A.get('e.force:refreshView');
		hitRefresh.fire();
		console.log('----Success Message--- ' + response.getReturnValue());
		}else {
			console.log('Problem in setting the integration message to null ' + state);
		}
		// Display toast message to indicate load status
		var toastEvent = $A.get("e.force:showToast");
		if (state === 'SUCCESS'){
			toastEvent.setParams({
			"title": "Success!",
			"message": " Synchronization has initiated successfully."
			});
		}else {
			toastEvent.setParams({
			"title": "Error!",
			"message": " Synchronization has failed."
			});
		}
		toastEvent.fire();
		// Close the action panel
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();

		});
		$A.enqueueAction(action);
	}
})