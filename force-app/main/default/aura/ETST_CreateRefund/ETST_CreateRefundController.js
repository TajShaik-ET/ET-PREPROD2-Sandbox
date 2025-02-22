({
     doInit : function(component, event, helper) {
        var recId=component.get("v.recordId");        
        var action = component.get("c.getReceipts");
        action.setParams({
            recordid : component.get("v.recordId")
        });
        component.set("v.showSpinner",true);
        action.setCallback(this, function(response) {
            var state = response.getState();
               
            if (state === "SUCCESS") {
                var retrurnValue = response.getReturnValue();
                console.log(retrurnValue)
                component.set("v.Receipt",retrurnValue);
            }else{
                
                console.log(state);
                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                          
                    }
                }

            }
        });
        $A.enqueueAction(action); 
    },
    save :function(component, event, helper){
        var isValid = true;
        if (isValid){ 
         var action = component.get("c.postInvoiceReceipt");
            action.setParams({               
                LstReceipt : component.get("v.Receipt"), 
                //selectedradioId : component.get("v.selectedrow") ,
               
                recordId :component.get("v.recordId")
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log("state",state);
                if (state === "SUCCESS") {
                    var responseValue = response.getReturnValue();
                    var responseData = JSON.parse(responseValue);
                    console.log('responseData',responseData);                    
                   if(responseData['Status']=='S'){                       
                       
                       var toastReference = $A.get("e.force:showToast");
                       toastReference.setParams({
                           "type":"Success",
                           "title":"Success",
                           "message":"Request is submitted successfully.",
                           "mode":"dismissible"
                       });
                       toastReference.fire();
                       
                        $A.get("e.force:closeQuickAction").fire();
                       $A.get('e.force:refreshView').fire();
                       
                    }else{
                        var toastReference = $A.get("e.force:showToast");
                        toastReference.setParams({
                            "type":"Error",
                            "title":"Error",
                            "message":responseData['Message'],
                            "mode":"dismissible"
                        });
                        toastReference.fire();
                    }
            } 
            else if (state === "INCOMPLETE") { 
                
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
        });
            $A.enqueueAction(action); 
        }   
    },
    
    checkboxSelect: function(component, event, helper) {
       // alert('check box selected');
        var selectedradioId= document.querySelector('input[name="radio"]:checked').id;
        component.set("v.selectedrow",selectedradioId);
        component.set("v.TEXTFIELDS", true);
        //console.log('-*selectedradioId*-',selectedradioId);
    },
    OnCancel : function(component, event, helper){
       
       $A.get("e.force:closeQuickAction").fire();
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        component.set("v.disableBtn",true);
        
    },
     
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
        component.set("v.disableBtn",false);
    }
});