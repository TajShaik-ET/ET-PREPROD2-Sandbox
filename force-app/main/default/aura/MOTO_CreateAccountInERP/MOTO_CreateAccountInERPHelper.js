({
	createAccInOracle :function (component,event, helper,AccIdval){
      
       var action = component.get('c.createOracleAccount');
       component.set("v.showSpinner",true);
        action.setParams({
            OppId : component.get("v.recordId"),
            AccIdVal :AccIdval.toString()
          
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let resVal= response.getReturnValue();
                
                if(resVal && resVal == 'Success'){
                    component.set("v.showSpinner",false);
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"Success",
                        "title":"Success",
                        "message":"Account has been created in Oracle.",
                        "mode":"dismissible"
                    });
                    toastReference.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }else{
                     component.set("v.showSpinner",false);
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type":"Error",
                        "title":"Error",
                        "message":"Please check with Admin",
                        "mode":"dismissible"
                    });
                    toastReference.fire();
                }
                
            }
            else if (state === "ERROR") {
                 
               var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
          }); 
        
        $A.enqueueAction(action);  
        
    }
})