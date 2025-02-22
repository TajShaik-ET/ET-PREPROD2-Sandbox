({
	    getcaseCommentsbyUser: function(component,event,helper){
             debugger;
        var action = component.get('c.getCaseComments');
        
      
        var caseIDlookup=component.get('v.recordDetailId').toString();
        action.setParams({
            caseId : caseIDlookup
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                var caseCommnetsDetails = response.getReturnValue(); 
                // Format the CreatedDate
                caseCommnetsDetails.forEach(function(comment) {
                    var createdDate = new Date(comment.CreatedDate);
                    var formattedTime = createdDate.toLocaleString('en-US', { year: 'numeric', month: 'numeric', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: true });
                    comment.formattedTime = formattedTime;
                });
                
                // Set the formatted response in the Lightning component attribute
                component.set("v.caseCommentslist", caseCommnetsDetails);
                console.log('response of case Date  '+JSON.stringify(caseCommnetsDetails));  
                
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
    }})