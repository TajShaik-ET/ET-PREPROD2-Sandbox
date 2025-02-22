({
	doInit : function(component, event, helper)  {
        component.set('v.loaded',false);
		var exeAction = component.get("c.getDetails");
        exeAction.setParams({
           
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                component.set('v.locList',res.locList);
                component.set('v.orgList',res.orgList);
                component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    }, 
   createRegistration : function(component, newRegistration)  {
        component.set('v.loaded',false);
		var exeAction = component.get("c.saveRegistration");
        exeAction.setParams({
            "newRegistration": newRegistration
        });
        this.serverSideCall(component,exeAction).then(
            function(res) {
                component.set('v.loaded',true);
                component.set('v.showmsg',true);
                component.set('v.disable',true);
                //$A.util.removeClass(component.find("toggleId"), "slds-hide");
                
                /*var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Thanks for registering at OneET. Login credentials will be sent to your email."
                });
                toastEvent.fire();*/
                //component.set('v.loaded',true);
            }
        ).catch(
            function(error) {
                component.set('v.loaded',true);
                console.log('Error---'+JSON.stringify(error));
            }
        );
    }, 
    
    serverSideCall : function(component,action) {
        
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   
                                   var state = response.getState();
                                   // console.log(state);
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
})