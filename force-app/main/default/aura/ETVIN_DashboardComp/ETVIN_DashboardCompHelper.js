({
	getInsurancedetails : function(component, event, helper) {
		var action = component.get("c.getInsurancePoliciyDetails");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var vehicleInsList = response.getReturnValue();
                
                if(vehicleInsList.length > 9) {
                    component.set('v.VehiclePolicyCount', vehicleInsList.length); 
                }else{
                    
                    component.set('v.VehiclePolicyCount', '0'+vehicleInsList.length); 
                }
               
               
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
       
	},
    getClaimdetails : function(component, event, helper) {
		var action = component.get("c.getInsuranceClaimsDetails");
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var vehicleInsList = response.getReturnValue();
                
                if(vehicleInsList.length > 9) {
                    component.set('v.ClaimPolicyCount', vehicleInsList.length); 
                }else{
                    
                    component.set('v.ClaimPolicyCount', '0'+vehicleInsList.length); 
                }
               
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
	},
    
    getCorrdetails : function(component, event, helper) {
		var action = component.get("c.getCorrectionRequestDetails");
        action.setParams({ 
            recordtypeName : 'Correction Request'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var vehicleInsList = response.getReturnValue();
               
              if(vehicleInsList.length > 9) {
                    component.set('v.CorrectionCount', vehicleInsList.length); 
                }else{
                    
                    component.set('v.CorrectionCount', '0'+vehicleInsList.length); 
                }   
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
	},
    
    getMulkiyaReqdetails : function(component, event, helper) {
        var action = component.get("c.getCorrectionRequestDetails");
        action.setParams({ 
            recordtypeName : 'Available for Mulkiya'
        });
     
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var vehicleInsList = response.getReturnValue();
             
                if(vehicleInsList.length > 9) {
                    component.set('v.mulkiyaCount', vehicleInsList.length); 
                }else{
                    
                    component.set('v.mulkiyaCount', '0'+vehicleInsList.length); 
                }   
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
    },
    getCancellationdetails : function(component, event, helper) {
		var action = component.get("c.getCancelTheftReq");
        action.setParams({ 
            recordtypeName : 'Cancellation Request'
        });
     
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var vehicleInsList = response.getReturnValue();
             
                if(vehicleInsList.length > 9) {
                    component.set('v.CancellationCount', vehicleInsList.length); 
                }else{
                    
                    component.set('v.CancellationCount', '0'+vehicleInsList.length); 
                }   
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
           
        });
        $A.enqueueAction(action);
	}
    
})