({
	doInit : function(component, event, helper)  {
        component.set('v.loaded',false);
            
		var exeAction = component.get("c.getCaseDetails");
        exeAction.setParams({
            "status": component.get('v.status'),
            "recordType":component.get('v.service')
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
             
             component.set('v.deliveryData',response);
             var corousalSize=component.get('v.corousalSize'); 
             component.set('v.currentData',response.slice(0,corousalSize)); 
             component.set('v.totalRecords',response.length);  
             component.set('v.RecordsCount',response.length);
			 component.set('v.loaded', !component.get('v.loaded'));
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