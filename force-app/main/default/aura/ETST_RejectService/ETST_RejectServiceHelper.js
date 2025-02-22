({
    
    saveRecordHelper : function(component, event, helper) { 
        try{
            var action = component.get('c.rejectService'); 
            
           
            component.set('v.record.ETST_Coordinator_Comments__c',component.get("v.comments"));
          
            action.setParams({
                "serviceRequest" : component.get('v.record')         
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state)
                if (state === "SUCCESS") { 
                    component.set("v.showSpinner",false);
                    let data = response.getReturnValue();
                    helper.showToastMessage('Success','Success','Your request is saved successfully.');
                    $A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
                else if (state === "ERROR") {
                    console.log('error')
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            component.set("v.showSpinner",false);
                            console.log("Error message: " + errors[0].message);                       
                        }
                    } else {
                        console.log("Unknown error");
                        
                    }
                }
            }); 
           $A.enqueueAction(action);
        }catch(e){
            console.log(e.message)
        }
    },
    showToastMessage : function(title,type,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":type,
            "title":title,
            "message":message,
            "mode":"dismissible"
        });
        toastEvent.fire();
    }
})