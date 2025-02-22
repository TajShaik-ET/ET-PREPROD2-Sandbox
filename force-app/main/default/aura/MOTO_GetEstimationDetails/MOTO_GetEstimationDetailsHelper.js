({
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
     
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    getPdfDetails : function(component, event, helper) {
        component.set("v.showSpinner",true);
        component.set("v.disabled",true);
        let serEstimNo = component.get("v.serviceEstimateNo");
        console.log('serEstimNo>>>>', serEstimNo);
        component.set("v.vfUrl",'/apex/MOTO_EstimationInvoicePdf?estimNo='+serEstimNo); 
        
        component.set("v.showPdfPage",true);        
       
        
       // component.set("v.showSpinner",false);
      /* var action = component.get("c.makeGetCallout");
        action.setParams({
            ServiceEtimationNo:serEstimNo,
            recordId:component.get("v.recordId"),
        });
       
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var retrurnValue = response.getReturnValue();                           
                 console.log(retrurnValue)
                 component.set("v.showPdfPage",true);
                alert()
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);}}
            }
        });
        $A.enqueueAction(action); */
       
    },

    /*handlePdfUrl: function(component, pdfUrl) {
        // Perform actions with the pdfUrl as needed
        console.log("Handling PDF URL: " + pdfUrl);
        console.log('Opp ID in Helper>>>>', component.get("v.recordId"));
        
        // You can call another method or perform additional logic here
        //this.CreatePdfshortUrl(component, pdfUrl);
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
                    console.log('In Success URL>>>>');
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
    }*/

})