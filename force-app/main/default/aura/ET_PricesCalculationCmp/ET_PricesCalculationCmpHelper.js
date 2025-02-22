({
    getPricesCalculationData : function(component,event,helper) {
        var action = component.get("c.priceCalculation");
        action.setParams({
            'quoteId': component.get('v.quoteId')
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
             if (state === "SUCCESS"){
                var response=a.getReturnValue();
                console.log('response '+response);
                if(response!=null && response!=undefined){
                   // component.set("v.wrokforceCalcDetails",response.lstQuoteCalcDetails);
                   component.set("v.pricesCalculationObj", response);
                    console.log('response ' + JSON.stringify(response));
                    }else{
                        console.log('response is null');
                    }
    
            }
        });
        $A.enqueueAction(action);

    
    }
})