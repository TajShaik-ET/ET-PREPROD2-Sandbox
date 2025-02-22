({
	doInit : function(component, event, helper)  {
        component.set('v.loaded',false);
		var exeAction = component.get("c.getBusinessType");
        exeAction.setParams({
         
        });
        this.serverSideCall(component,exeAction).then(
            function(response) {
                component.set('v.accountRec',response);//.RecordType.DeveloperName);
                if(response.ETST_Account_Type__c=='Government School'){
					component.set('v.govtSchool',true);
                }
                
                component.set('v.loaded',true);
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