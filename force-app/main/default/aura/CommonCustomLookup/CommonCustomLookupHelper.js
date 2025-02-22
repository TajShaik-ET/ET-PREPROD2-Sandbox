({
    getSerchResults : function(component, event, helper,currentText) {
        debugger;
        var action = component.get('c.getFilterData');    
       // alert(component.get("v.fieldApiNames"));
        action.setParams({
            objectApiName : component.get("v.objectName"),
            fieldName: component.get("v.fieldApiNames"),
            searchKey:currentText,
            filters:component.get("v.filters") 
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {  
                let data = response.getReturnValue()
                component.set("v.searchRecords", data);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
            component.set("v.LoadingText", false);
        }); 
        
        $A.enqueueAction(action);  
        
        
    }
})