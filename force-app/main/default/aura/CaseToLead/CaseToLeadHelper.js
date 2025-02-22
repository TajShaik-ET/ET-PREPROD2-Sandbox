({
    showHide : function(component) {
        /*  console.log('__>InsideHelper');
        var action = component.get("c.updateCase");
        var cRec =  component.get("v.cases");
		console.log('### MAB@@3@' + cRec);
	    action.setParams({"caserecord":cRec});
	    action.setCallback(this, function(response) {
	     var state=response.getState();
         console.log('### MAB2' + state);
         if (state === "SUCCESS") {               
             console.log('### MAB3' + response.getReturnValue()[0]);
             $A.get('e.force:refreshView').fire();
            }             
	    });
	    $A.enqueueAction(action);        
     */   
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.refreshTab({
                tabId: focusedTabId,
                includeAllSubtabs: false
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})