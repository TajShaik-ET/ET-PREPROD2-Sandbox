({
	sendData : function(component,event,helper) {
		var action = component.get("c.sendDataToAman");
        var recordId = component.get("v.recordId");
        action.setParams({
            recId : recordId
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
                        "message":'Receipt sync is in process'
                    });
                }
                else{
                    toastEvent.setParams({ 
                        "title": "Error",
                    	"type":"error",
                        "message":'Receipt already sync'
                    });
                }
                 toastEvent.fire();
            }
            else if(state == 'ERROR'){
                var errors = response.getError();
                toastEvent.setParams({ 
                        "title": "error",
                    	"type":"Error",
                        "message":errors[0].message
                    });
                 toastEvent.fire();
            }
            $A.get("e.force:closeQuickAction").fire();
            
        });
        $A.enqueueAction(action);
	}
})