({
	getInsurancedetails : function(component, event, helper) {
        
        
		var action = component.get("c.getCorrectionRequestDetails");
        action.setParams({ 
            recordtypeName : 'Available for Mulkiya'
        });
      
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var vehicleInsList = response.getReturnValue();
                console.log(vehicleInsList);
                 component.set('v.vehicleInsList', vehicleInsList);
                 component.set('v.FilteredData', vehicleInsList);
                
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
    updateStatusWithAcceptAndReject : function(component, event, helper, status) {
		var action = component.get("c.updateStatusForCorrectionRequest");
        var  recordId = component.get('v.recordId');
        action.setParams({ 
            recordId : recordId,
            status : status
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isModalOpen", false);
                var msg = '';
                if(status == 'Approved'){
                    msg= 'The record has been approved.'; 
                }else{
                    msg= 'The record has been rejected.';
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "dismissible",
                    message: msg,
                    type: 'Success',
                    title: 'Success!'
                });
                toastEvent.fire();
                
                  component.set('v.recordId', '');
                component.set('v.detailPage', false);
                this.getInsurancedetails(component, event, helper);
                
                var address = new URL(window.location.origin);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": address+'partnerportal/s',
                    "isredirect" :false
                });
                urlEvent.fire();
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