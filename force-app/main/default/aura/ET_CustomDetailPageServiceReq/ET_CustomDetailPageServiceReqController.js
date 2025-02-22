({
    doInit: function(component,event,helper){
        var action = component.get('c.getRecordTypeName');   
        action.setParams({
            caseId : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {  
                var res = response.getReturnValue();
                console.log('12-'+res);
                component.set('v.recordTypeName',res)
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
        debugger;
        helper.getcaseCommentsbyUser(component, event);
        helper.getprofiledata(component, event);
    },
    
    handleClose: function(component, event, helper) {
        component.set('v.showDetailCmp',false);
    },
    
    
    recordLoaded: function(component, event, helper) {
         var recordUi = event.getParam("recordUi");
        console.log("Record UI loaded: ", recordUi);
        
        // Access record fields, e.g., FeedBack_EN__c
        var feedbackValue = recordUi.record.fields.FeedBack_EN__c.value;
        if(feedbackValue == 'Yes but different time.'){
             component.set('v.showDateField', true);
         }
        //console.log("FeedBack_EN__c value on load: ", feedbackValue);
        
    }
     
    //--//
})