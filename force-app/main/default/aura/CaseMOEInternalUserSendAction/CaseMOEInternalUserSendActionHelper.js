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
    updateCaseStatus : function(component, event, helper) {
        component.set("v.isDisabled", true); 
        var recordId = component.get("v.recordId");
        component.set("v.caseIds", recordId);
        var action = component.get('c.updateMOECaseStatus');
        action.setParams({
            "caseIds":component.get("v.caseIds"),
            "status":"Send",
            "ccmRemarks":component.get("v.ccmRemarks"),
            "Solution":component.get("v.Solution"),
            "Comments":component.get("v.comments")
        });
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state            
            if (state == 'SUCCESS') {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:showToast').setParams({
                    "title": "Success",
                    "message": "Case record is updated successfully!",
                    "type": "success",
                }).fire();
                var workspaceAPI = component.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    var focusedTabId = response.tabId;
                    workspaceAPI.closeTab({
                        tabId: focusedTabId,
                        includeAllSubtabs: false
                    });
                })
                .catch(function(error) {
                    console.log(error);
                });
            }
        });
        $A.enqueueAction(action);    	
    }
})