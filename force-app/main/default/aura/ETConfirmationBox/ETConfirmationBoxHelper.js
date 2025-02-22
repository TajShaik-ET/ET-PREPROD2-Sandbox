({
	cancelPaymentHelper : function(component, event) {
		var action = component.get('c.'+component.get('v.serverAction')); 
        action.setParams({
            "paymentId" :component.get('v.recordId')
        });
        action.setCallback(this, function(res){
            var state = res.getState(); // get the response state
            console.log('state: '+state);
            if (state === "SUCCESS") {
                var result = res.getReturnValue();
                console.log('result: '+result);
                if(result.includes('Success')){
                	this.showToast('success','Success!!',result);    
                }
                else{
                    this.showToast('info','Info!!',result);    
                }
               	
                $A.get('e.force:refreshView'). fire();
            	$A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "INCOMPLETE") {
                this.showToast('error','Incomplete!!',errors[0].message);    
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.showToast('error','Error!!',errors[0].message);    
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                         this.showToast('error','Unknown error!!',errors[0].message);    
                           
                    }
                }
        });
        $A.enqueueAction(action);  
	},
    showToast : function(mtype,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "duration":7000,
            "type":mtype,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    }
})