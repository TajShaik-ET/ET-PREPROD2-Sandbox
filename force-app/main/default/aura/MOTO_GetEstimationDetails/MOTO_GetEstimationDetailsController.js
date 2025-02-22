({
    doInit : function(component, event, helper) {
        component.set("v.showInputDetails1",false);
        component.set("v.Spinner",false);
        
        var recordId = component.get("v.recordId");
        var action = component.get("c.getserviceEstimateNo");
        action.setParams({
            "recordId": recordId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.serviceEstimateNo", response.getReturnValue());
                helper.getPdfDetails(component, event, helper);
            } else {
                console.log("Error fetching field value: " + state);
            }
        });

        $A.enqueueAction(action);
        
        
    },
    frameLoaded :function(component, event, helper) {
         component.set("v.showSpinner",false);
         component.set("v.disabled",false);
        
    },
    
    

     CreatePdfCtrl : function(component, event, helper){
     
        try{
            component.set("v.showSpinner",true);
            let serEstimNo = component.get("v.serviceEstimateNo");
            console.log('serEstimNo>>>>', serEstimNo);
            console.log('component.get("v.recordId")>>>>', component.get("v.recordId"));
            var action = component.get('c.GenerateQuoteDoc');
           
            action.setParams({
                recordId:component.get("v.recordId"),
                ServiceEtimationNo:serEstimNo
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                component.set("v.showSpinner",false);
               
                if (state === "SUCCESS") { 
                    //var pdfUrl = response.getReturnValue();
                    //helper.handlePdfUrl(component, pdfUrl);
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "Success",
                        "title" : "Success",
                        "message" : "Estimation Invoice has been sent to the customer.",
                        "mode" : "dismissible"
                    });
                    toastReference.fire();
                    $A.get("e.force:closeQuickAction").fire();
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

    CreatePdfshortUrl : function(component, event, pdfUrl){
        console.log('In Create PDF URL>>>>');
        console.log('PDF URL>>>>', pdfUrl);
        try{
            component.set("v.showSpinner",true);
           
           
            console.log('component.get("v.recordId")>>>>', component.get("v.recordId"));
            var action = component.get('c.shortUrl');
           
            action.setParams({
                url:pdfUrl,
                oppId:component.get("v.recordId")
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                component.set("v.showSpinner",false);
               
                if (state === "SUCCESS") { 
                    var toastReference = $A.get("e.force:showToast");
                    toastReference.setParams({
                        "type" : "Success",
                        "title" : "Success",
                        "message" : "Estimation Invoice has been sent to the customer.",
                        "mode" : "dismissible"
                    });
                    toastReference.fire();
                    $A.get("e.force:closeQuickAction").fire();
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
    }
    
})