({
	getPicklistData : function(component, event, helper) {
		
         var action = component.get('c.getMakeVsModel');
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    let data = response.getReturnValue();
                   // console.log(data)
                   component.set("v.makeModelData",data);
                    let makelist=[];
                    Object.keys(data).forEach(function(key, index) {
                        
                        makelist.push(key);
                    });
                    component.set("v.makeOptions",makelist.sort());
                   
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            helper.showErrorToast({
                                "title": "Error",
                                "type": "Error",
                                "message":errors[0].message
                            });
                            
                        }
                    } else {
                        console.log("Unknown error");
                       
                    }
                }
            }); 
            
            $A.enqueueAction(action); 
	},
})