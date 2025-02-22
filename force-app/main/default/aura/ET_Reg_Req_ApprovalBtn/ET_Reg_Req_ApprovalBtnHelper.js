({
    
    getRegistrationRecord: function(component,event, helper) {
        var action = component.get('c.queryRegistrationRecord');
        component.set("v.spinnerVal",true);
        action.setParams({
            ReqId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {  
                component.set("v.spinnerVal",false);
                var registrationReq= response.getReturnValue() ;
                component.set("v.registrationReq", registrationReq); 
                var requestStatus = registrationReq.Request_Status__c;
                var showMsg;
                if(requestStatus == 'Approved' ){
                    showMsg = 'Request is Already Approved!';
                }
                else{
                    showMsg = 'Do you want approve request, if yes please click on \'Approve\' else click on \'Reject\'';
                }
                component.set("v.showMsg", showMsg); 
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.spinnerVal",false);
                        console.log("Error message: " + errors[0].message);
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type" : 'Error',
                            "title" : 'Error',
                            "message" :errors[0].message,
                            "mode" : "sticky"
                        });
                        toastReference.fire();
                    }
                } else {
                    console.log("Unknown error");
                    component.set("v.spinnerVal",false);
                }
            }
        }); 
        $A.enqueueAction(action);  
    },
    
    
    createCommunityUserHelper : function(component,event, helper) {
		       
       var action = component.get('c.createCommunityUser');
        component.set("v.spinnerVal",true);
        
       action.setParams({
             ReqId:component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                component.set("v.spinnerVal",false);
                var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type" : 'Success',
                    "title" : 'Success',
                    "message" : 'Account and user created successfully and user sent an welcome email.',
                    "mode" : "sticky"
                });
                toastReference.fire();
                $A.get('e.force:refreshView').fire() 
                $A.get("e.force:closeQuickAction").fire();
                
            }
            else if (state === "ERROR") {
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                         component.set("v.spinnerVal",false);
                        console.log("Error message: " + errors[0].message);
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type" : 'Error',
                            "title" : 'Error',
                            "message" :errors[0].message,
                            "mode" : "sticky"
                        });
                        toastReference.fire();
                    }
                } else {
                    console.log("Unknown error");
                     component.set("v.spinnerVal",false);
                }
            }
          }); 
        $A.enqueueAction(action);  
	}
})