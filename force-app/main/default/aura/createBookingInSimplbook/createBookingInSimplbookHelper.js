({
    sendToSimplybook : function(component, event, helper) {
        
        var action = component.get('c.createSimplybookRequest');
        component.set("v.showSpinner",true);
        action.setParams({            
            leadDetails : component.get("v.record")
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                try{
                    
                    var res = JSON.parse(response.getReturnValue());
                    console.log(res)
                    
                    if(res && res.bookings && res.bookings[0].id){
                        
                        component.set("v.hasError",false);
                        console.log(res.bookings[0].id)
                       
                        component.set("v.simplyBookId",res.bookings[0].id.toString());
                        
                        component.find("leadForm").submit();
                        
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Success",
                            "title":"Success",
                            "message":"Lead booking details has been created in simplybook",
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                        $A.get("e.force:closeQuickAction").fire();                        
 						$A.get('e.force:refreshView').fire();
                        
                    }else if(res && res.code){
                        component.set("v.hasError",true);
                        component.set("v.showSpinner",false);
                        component.set("v.ErrMsg",JSON.stringify(res));
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"error",
                            "title":"error",
                            "message":res.message +'-'+Object.values(res.data)[0],
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                       
                    }else {//if(res && res =='Error')
                         
                         component.set("v.hasError",true);
                          component.set("v.showSpinner",false);
                         var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"error",
                            "title":"error",
                            "message":"Please check with Admin",
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                    }
                    
                }catch(e){
                    console.log(e.message)
                      var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"error",
                            "title":"error",
                            "message":"Simplybook has some error, try after sometime",
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                }
                
            }else if (state === "ERROR") {
                component.set("v.showSpinner",false);
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert(errors[0].message);
                      
                        
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"error",
                            "title":"error",
                            "message":errors[0].message,
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                        
                    }
                  
                }else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})