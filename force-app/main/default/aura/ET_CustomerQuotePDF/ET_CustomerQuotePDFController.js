({
   
    doInit : function(component, event, helper) {
        component.set("v.vfUrl",'/apex/ET_CustomerQuotePDF?Id='+component.get('v.recordId')); 
        
        
        component.set("v.showInputDetails",false);
        component.set("v.showPdfPage",true);
        
    },
    
    previousButtonCtrl : function(component, event, helper) {
        component.set("v.showInputDetails",true);
        component.set("v.showPdfPage",false);
     
    },
    handleCancel : function(component, event, helper){
       // var url = window.location.href;
        $A.get("e.force:closeQuickAction").fire();
          //  window.history.back();
    },
    handleSave : function(component, event, helper){
        let qId = component.get("v.recordId");
        
          helper.showSpinner(component);
        try{
            var action = component.get('c.generateQuoteDoc');
            
            component.set("v.disabled",true);
            action.setParams({
                quoteId:component.get("v.recordId")
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                // alert(state);
                if (state === "SUCCESS") { 
                      helper.hideSpinner(component);
                    let data =  response.getReturnValue();                
                    console.log(data)
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "The Quote document has been Saved successfully."
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else if (state === "ERROR") {
                    component.set("v.disabled",false);
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
        }catch(e){
            console.log(e.message)
        }
    },   
     
})