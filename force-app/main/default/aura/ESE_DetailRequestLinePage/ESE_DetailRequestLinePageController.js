({
 ESElineCase : function(component, event, helper) 
    {
        var ESEList = component.get("c.getESEReqLineList");
        
        
        ESEList.setParams
        ({
            recordId: component.get("v.recordId")
        });
        
          ESEList.setCallback(this, function(response) {
            var state = response.getState();
              var res = response.getReturnValue()
              alert(state);

            if (state === "SUCCESS") {  
               component.set("v.ESERequestList", res);
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

        $A.enqueueAction(ESEList); 
    }
  
        
})