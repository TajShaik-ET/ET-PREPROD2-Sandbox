({
    getAllWorkforceCalcDetails : function (component,event,helper) {
       var action = component.get("c.ET_getAllWorkforceCalcDetails");
        action.setParams({
            'quoteId': component.get('v.quoteId'),
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state = '+ state);
            if (state === "SUCCESS"){
                var response=a.getReturnValue();
                console.log('quote Cal wrapper response '+JSON.stringify(response));
                if(response!=null && response!=undefined){
                    console.log('response[1] '+JSON.stringify(response[1]));
                    component.set('v.response',response);
                    component.set('v.calcDetailsWpr',response[1]);
                    component.set('v.lineNumbers',response[1].lineNumbers);
                    component.set('v.totalNoOfVehicles',response[1].quoteHeaderInfo.totalNoOfVehicles);
                    component.set('v.totalLines',response[1].quoteHeaderInfo.totalLines);
                    component.set('v.rentalPriceHeaderInfo',response[1].quoteHeaderInfo);
                    
                }else{
                    console.log('response is null');
                }
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
                else if (state === "ERROR") {
                    console.log('state  = '+ state);
                    var errors = response.getError();
                    alert('Unknown Error. Please contact system admin.');
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message + "Method :" );
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
})