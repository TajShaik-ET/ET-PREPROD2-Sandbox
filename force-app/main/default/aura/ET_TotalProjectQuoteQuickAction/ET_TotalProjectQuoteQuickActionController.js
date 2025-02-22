({
        doInit : function(component, event, helper) {
            var action = component.get('c.getTotalProjectQuoteId');
            action.setParams({
                quoteId : component.get("v.recordId")
            });
            component.set('v.loaded', !component.get('v.loaded'));
            action.setCallback(this, function(response) {
                component.set('v.loaded', !component.get('v.loaded'));
                //store state of response
                var state = response.getState();
                if (state === "SUCCESS") {
                    var totalProjectQuoteId = response.getReturnValue();
                    window.open("/apex/ET_Quotation_Pricing_PDF?quoteId="+totalProjectQuoteId);	
                    //to close popup
                    var action = component.get('c.closeAction');
                    $A.enqueueAction(action);
                }
                else if(state == "ERROR"){
                    var errors = response.getError();                      
                    alert(errors[0].message);
                }
            });
            $A.enqueueAction(action);
        },
        
        closeAction :function(component, event, helper){
            $A.get("e.force:closeQuickAction").fire();
        },
        
        
        
    })