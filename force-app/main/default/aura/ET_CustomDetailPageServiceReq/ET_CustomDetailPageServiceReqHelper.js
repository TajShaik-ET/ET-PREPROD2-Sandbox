({
    getcaseCommentsbyUser: function(component,event,helper){
        debugger;
        var action = component.get('c.getCaseComments');
        
        var idofcase = component.get('v.recordId');
        var caseIDlookup=component.get('v.recordId').toString();
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
    },
     getprofiledata: function(component, event, helper) {
        
        var action = component.get("c.getuserDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                 console.log('Need profile data' + JSON.stringify(response));
                var userProfile = response.getReturnValue();
               
                if (userProfile === 'MOE - Department Of School Services') {
                    component.set("v.MOE_Department_Of_School_Services", true);
                } else if (userProfile === 'P-MOE - Department Of School Activities') {
                    component.set("v.P_MOE_Department_Of_School_Activities", true);
                } else if (userProfile === 'P-MOE - Inclusive Education Department in ESE') {
                    component.set("v.P_MOE_Inclusive_Education_Department_in_ESE", true);
                } else if (userProfile === 'MOE - Personnel Management') {
                    component.set("v.MOE_Personnel_Management", true);
                } else if (userProfile === 'ESE head Office') {
                    component.set("v.ESE_head_Office", true);
                } else if (userProfile === 'P-MOE - Extra-Curricular Activities') {
                    component.set("v.P_MOE_Extra_Curricular_Activities", true);
                }
               
                component.set("v.userProfile", userProfile);
            }
        });
        $A.enqueueAction(action);
    }
})