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
            "status":"Solution",
            "ccmRemarks":component.get("v.ccmRemarks"),
            "Comments":component.get("v.comments")
        });
        
        action.setCallback(this, function (a) {
            var state = a.getState(); // get the response state            
            if (state == 'SUCCESS') {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:showToast').setParams({
                    "title": "Successful",
                    "message": "Solution Added !",
                    "type": "success",
                    "duration":' 2000',
                    "key": 'info_alt',
                    "mode": 'sticky'
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
            }else{
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:showToast').setParams({
                    "title": "Error",
                    "message": "Something went wrong!",
                    "type": "error",
                    "duration":' 2000',
                    "key": 'info_alt',
                    "mode": 'dismissible'
                }).fire();
            }
        });
        $A.enqueueAction(action);    	
    }
})