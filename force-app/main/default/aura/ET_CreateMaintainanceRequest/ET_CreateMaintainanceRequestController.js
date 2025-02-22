({	
    doInit: function(component, event, helper) {
        helper.addTableRows(component, event);
    },
    addRow: function(component, event, helper) {
        helper.addTableRows(component, event);
    },
    
    removeRow: function(component, event, helper) {
        var mainReqList = component.get("v.maintenanceRequestList");
        var selectedItem = event.currentTarget;
        var index = selectedItem.dataset.record;
        mainReqList.splice(index, 1);
        component.set("v.maintenanceRequestList", mainReqList);
    },
    
    saveRecord : function(component, event, helper) {
        var maintenanceRequestList = component.get('v.maintenanceRequestList'); 
        //  alert('maintenanceRequestList = '+JSON.stringify(maintenanceRequestList));
        var maintenanceQuestionnaire = component.get('v.maintenanceQuestionnaire');
        // alert('maintenanceQuestionnaire = '+JSON.stringify(maintenanceQuestionnaire));
        
        var opportunityId = component.get('v.recordId');
        
        var action = component.get("c.createMaintenanceRequestRecord");
        action.setParams({ 
            maintenanceRequestList : maintenanceRequestList,
            opportunityId : opportunityId,
            maintenanceQuestionnaire : maintenanceQuestionnaire
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var retrurnValue = response.getReturnValue();
                if(retrurnValue){ 
                    //alert('The Records created SuccessFully!');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: "Record created SuccessFully!",
                        title: "Success",
                        type : 'success'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                }else{
                    toastEvent.setParams({
                        message: "Error in Creating record!!",
                        title: "Error",
                        type : 'suerrorccess'
                    });
                    toastEvent.fire();
                    // alert('Error in Creating record!');
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        alert('Something went wrong. Please contact your system admin with error message :  '+errors[0].message);
                        component.set("v.showSpinner",false); 
                    }
                } else {
                    console.log("Unknown error");
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
})