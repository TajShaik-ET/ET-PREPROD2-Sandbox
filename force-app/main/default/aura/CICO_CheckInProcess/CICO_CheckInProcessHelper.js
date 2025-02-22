({
	getCheckInDetails : function(component, event, helper) {
        
        
		var action = component.get('c.getCheckInInfo');
      
        action.setCallback(this, function(response) {
            var state = response.getState();
               
            if (state === "SUCCESS") {  
              	

                component.set("v.checkInInfo",response.getReturnValue());
                component.set("v.checkInfilterInfo",response.getReturnValue()); 
                
                                   
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
          }); 
        
        $A.enqueueAction(action); 
	},
    
    getCheckOutDetailsWithFile : function(component, event, helper){
      
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.getCheckOutDetails');
            action.setParams({                 
                recId:event.getSource().get("v.value")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {  
                    
                   resolve(response.getReturnValue());
                    
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                            helper.showToast('warning','warning','Check Out data is not available to this Vehicle');
                            
                        }
                    } else {
                        console.log("Unknown error");
                        
                    }
                }
            }); 
            
            $A.enqueueAction(action); 
            
        }));
        
    },
    
     showToast : function (Type,Title,Msg){
        var toastReference = $A.get("e.force:showToast");
        toastReference.setParams({
            "type":Type,
            "title":Title,
            "message":Msg,
            "mode":"dismissible"
        });
        toastReference.fire();
        
    },
})