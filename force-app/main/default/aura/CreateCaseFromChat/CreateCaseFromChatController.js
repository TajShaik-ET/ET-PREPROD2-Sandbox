({
    doInit : function(component, event, helper)  {
        var action = component.get("c.getLiveChatRecordData");
        action.setParams({
            'LiveChatTranscriptId' : component.get("v.recordId")
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.ChatRecord",response.getReturnValue());
            }
        });
		$A.enqueueAction(action);
    }, 
    
    navigate : function(component, event, helper) {
        
        /*var navigateEvent = $A.get("e.force:navigateToComponent");
        var ChatRecord = component.get("v.ChatRecord");
        navigateEvent.setParams({
            componentDef: "c:NewCaseButtonOverride3",
            componentAttributes :{ 
                parentobj:'Contact',
                recordId:ChatRecord.ContactId
                
        	}
        });
        navigateEvent.fire();*/
        try{
            var navService = component.find("navService");
            var ChatRecord = component.get("v.ChatRecord");
            var pageReference = {
                type: "standard__component",
                attributes: {
                    componentName: "c__NewCaseButtonOverride3"
                },
                state: {
                    c__parentobj: "Test",
                    c__recordId:ChatRecord.ContactId
                }
                
            };
            component.set("v.pageReference", pageReference);
        var workspaceAPI = component.find("workspace");
        // handles checking for console and standard navigation and then navigating to the component appropriately
        workspaceAPI
        .isConsoleNavigation()
        .then(function(isConsole) {
            if (isConsole) {
                console.log(pageReference);
                //  // in a console app - generate a URL and then open a subtab of the currently focused parent tab
                navService.generateUrl(pageReference).then(function(cmpURL) {
                    workspaceAPI
                    .getEnclosingTabId()
                    .then(function(tabId) {
                        return workspaceAPI.openSubtab({
                            parentTabId: tabId,
                            url: cmpURL,
                            focus: true
                        });
                    })
                    .then(function(subTabId) {
                        // the subtab has been created, use the Id to set the label
                        workspaceAPI.setTabLabel({
                            tabId: subTabId,
                            label: "New Case"
                        });
                    });
                });
            } else {
                // this is standard navigation, use the navigate method to open the component
                navService.navigate(pageReference, false);
            }
        })
        .catch(function(error) {
            console.log(error);
        });
        }
        catch(error){
            console.log(error.message);
        }
      
    },
    
    updateChatRecord: function(component, event){
        //alert('test  case creation');
        //var isCaseCreated = event.getParam("IsCaseCreated");
        //alert(isCaseCreated);
    }
})