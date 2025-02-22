({
	doInit : function(component, event, helper)  {
        component.set('v.loaded',false);
		var exeAction = component.get("c.getDashboardData");
        exeAction.setParams({
            "recordType": component.get('v.service')
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                
                component.set('v.totalCount',response.newCount+response.inprogressCount+response.cancelledCount+response.onHoldCount); 
                component.set('v.newCount',response.newCount); 
                component.set('v.inprogressCount',response.inprogressCount); 
                component.set('v.cancelledCount',response.cancelledCount); 
                component.set('v.onHoldCount',response.onHoldCount); 
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
                                   console.log(state);
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