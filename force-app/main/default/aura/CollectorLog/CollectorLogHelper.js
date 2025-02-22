({
   
    
    getCustomerAmountInfo : function(component, event, helper) {
        var action = component.get('c.getCustomerAmountDetails');
               
        action.setParams({
            
            accID:component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var result = response.getReturnValue();
            var state = response.getState();
         
            if (state === "SUCCESS") {
              
                component.set("v.amountOriginal",result.totalAmountOriginal);
                component.set("v.totalOverDue",result.totalReceivable);
                component.set("v.buttonDisable", false);
                component.set("v.showSpinner", false);
                
                if(result.errorMessage){
                     component.set("v.showSpinner",false);
                    component.set("v.buttonDisable", true);
                    console.log(result.errorMessage);
                    $A.get('e.force:showToast').setParams({
                        "title": "Error",
                        "message": "There is no transaction available for this customer.",
                        "type": "Error",
                    }).fire();
                }
                else {
                     //component.set("v.showSpinner",true);
                }
            }else if (state === "ERROR") {
               
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);}
                }else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})