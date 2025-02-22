({
    profileData: function(component, event, helper){
       
        var action = component.get('c.getProfileDetails');
      
        action.setCallback(this, function(response) {
            var state = response.getState();
                       
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                console.log(data);
                console.log(data.Government_School_Parent__c);
                //component.get()
                component.set("v.govParent",data.Government_School_Parent__c);
                console.log(component.get("v.govParent"));
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