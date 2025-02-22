({
    getSRCommonDetails: function(component, event, helper) {
        var action = component.get("c.getPicklistvalues");
        action.setParams({
                'objectName': "ET_Special_Workforce_Requirement__c",
                'field_apinames': component.get("v.picklistFields")
            });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                var response=a.getReturnValue();
                if(response!=null && response!=undefined){
                    if(response.specLeavePlan==null||response.specLeavePlan==undefined){
                            console.log('specLeavePlan   is null');     
                    }
                    component.set("v.specLeavePlan",response.specLeavePlan);
                    //component.set("v.specInsurance",response.specInsurance);
                    var delayInMilliseconds = 100;
                    window.setTimeout(
                        $A.getCallback(function() {
                            //console.log('myHelperMethod EXECUTING NOW... ');
                            var compEvent = component.getEvent("refreshEvent");
                            compEvent.setParams({"childCmpAuraId": component.getLocalId()});
                            compEvent.fire();
                        }), delayInMilliseconds
                    );     
                }else{
                    console.log('response is null');
                }
             
            }else{
                console.log('Callback from the server failed');
            }
                
        });
        $A.enqueueAction(action);
    }
})