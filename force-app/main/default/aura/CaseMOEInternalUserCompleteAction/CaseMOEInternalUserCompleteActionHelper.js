({
    doInit : function(component, event, helper,status) {
        var action = component.get('c.getCaseData');
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state           
            if (state == 'SUCCESS') {
                var response=a.getReturnValue();
                console.log(JSON.stringify(response)+'response');
                if(response!=undefined && response!=null && response!=''){
                    component.set('v.recentApprover', response.Sub_Status__c);
                    component.set('v.currentApprover', response.Status_Category__c); 
                    component.set('v.currentrecType', response.RecordType.DeveloperName); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateCaseStatus: function (component, event, helper) {
        debugger;
        try {
            var recordId = component.get("v.recordId");
            component.set("v.caseIds", recordId);           
            var action = component.get('c.updateMOECaseStatus');
            action.setParams({
                "caseIds": component.get("v.caseIds"),
                "status": "Complete",
                "driverName": component.get("v.driverName"),
                "driverMobile": component.get("v.driverNumber"),
                "Comments": component.get("v.comments")
            });
            action.setCallback(this, function (a) {
                var state = a.getState();
               // alert(state);// get the response state            
                if (state === 'SUCCESS') {
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:showToast').setParams({
                        "title": "Success",
                        "message": "Case record is Closed!",
                        "type": "success",
                    }).fire();
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function (response) {
                        var focusedTabId = response.tabId;
                        workspaceAPI.closeTab({
                            tabId: focusedTabId,
                            includeAllSubtabs: false
                        });
                    })
                    .catch(function (error) {
                        console.error(error);
                    });
                } else  if (state === "ERROR"){
                    console.error("Server request failed with state: " + state);
                    $A.get('e.force:showToast').setParams({
                        "title": "Error",
                        "message": "Failed to update case status. Please try again.",
                        "type": "error",
                    }).fire();
                    var errors = response.getError();
                    Console.log("Error" + errors);
                    
                
                   
                }
            });
            
            $A.enqueueAction(action);
        } catch (ex) {
            console.error("An error occurred: " + ex.message);
            // Handle the error as needed
            $A.get('e.force:showToast').setParams({
                "title": "Error",
                "message": "An unexpected error occurred. Please try again.",
                "type": "error",
            }).fire();
        }
    }
    
})