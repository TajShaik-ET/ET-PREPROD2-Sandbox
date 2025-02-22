({
	onInit : function(component, event, helper) {
        component.set('v.loading', true);
        var action = component.get("c.doPaymentStatusUpdate");
        action.setParams({
            "paymentId": component.get('v.recordId')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if(state == 'SUCCESS'){
                var res = JSON.stringify(response.getReturnValue());
                console.log('res--->'+res);
                if(res == 'true'){                
                	toastEvent.setParams({ 
                        "title": "Success",
                    	"type":"Success",
                        "message":'Payment status updated successfully.'
                    });
                }else{
                    toastEvent.setParams({ 
                        "title": "Error",
                    	"type":"error",
                        "message":'You are not allowed to update status at this state.'
                    });
                }
                toastEvent.fire();
            }else if(state == 'ERROR'){
                var errors = response.getError();
                toastEvent.setParams({ 
                        "title": "error",
                    	"type":"Error",
                        "message":errors[0].message
                    });
                 toastEvent.fire();
            }
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
	}
})