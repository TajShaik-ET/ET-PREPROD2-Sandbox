({
 
  saveRecordHelper : function(component, event, helper) {
     
     
       var action = component.get('c.approveService'); 
      
        action.setParams({
            "serviceRequestId" : component.get("v.recordId"),
            "Coordinator_Comments" : component.get("v.comments")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
               component.set("v.showSpinner",false);
                let data = response.getReturnValue();
                helper.showToastMessage('Success','Success','Your request is saved successfully.');
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "ERROR") {
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