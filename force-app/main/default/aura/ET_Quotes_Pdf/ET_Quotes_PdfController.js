({
   
    doInit : function(component, event, helper) {

        let servCharges = component.get('v.CKboxservcharge')?component.get('v.servChargeVal') :'';
        let Insurancecharge = component.get('v.CKboxInsurancecharge')?component.get('v.nameStr2') :'';
        let servchargeAED = component.get('v.CKboxservchargeAED')?component.get('v.nameStr3') :'';
        let DeliveryDays = component.get('v.CKboxDeliveryDays')?component.get('v.nameStr4') :'';
        let QuotationDays = component.get('v.CKboxQuotationDays')?component.get('v.nameStr5') :'';
        let penaltyMonths = component.get('v.CKboxpenaltyMonths')?component.get('v.nameStr6') :'';
        let penaltyMonths2 = component.get('v.CKboxpenaltyMonths2')?component.get('v.nameStr62') :'';
        let penaltyMonths3 = component.get('v.CKboxpenaltyMonths3')?component.get('v.nameStr63') :'';
        let penaltyMonths4 = component.get('v.CKboxpenaltyMonths4')?component.get('v.nameStr64') :'';
        let penaltyMonths5 = component.get('v.CKboxpenaltyMonths5')?component.get('v.nameStr65') :'';
        let penaltyMonths6 = component.get('v.CKboxpenaltyMonths6')?component.get('v.nameStr66') :'';
        
        component.set("v.vfUrl",'/apex/ET_Qoutes_NewPdf?Id='+component.get('v.recordId')); 
        
        
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
        debugger;
         let servCharges = component.get('v.CKboxservcharge')?component.get('v.servChargeVal') :'';
        let Insurancecharge = component.get('v.CKboxInsurancecharge')?component.get('v.nameStr2') :'';
        let servchargeAED = component.get('v.CKboxservchargeAED')?component.get('v.nameStr3') :'';
        let DeliveryDays = component.get('v.CKboxDeliveryDays')?component.get('v.nameStr4') :'';
        let QuotationDays = component.get('v.CKboxQuotationDays')?component.get('v.nameStr5') :'';
        let penaltyMonths = component.get('v.CKboxpenaltyMonths')?component.get('v.nameStr6') :'';
        let qId = component.get("v.recordId");
        
          helper.showSpinner(component);
        try{
            var action = component.get('c.generateQuoteDoc');
            
            component.set("v.disabled",true);
            action.setParams({
                quoteId:component.get("v.recordId")
              /*  name:component.get("v.nameStr"),
                name1:servCharges,
                name2:Insurancecharge,
                name3:servchargeAED,
                name4:DeliveryDays,
                name5:QuotationDays, 
                name6:penaltyMonths*/
                
            });
             console.log('@@'+name);
            action.setCallback(this, function(response) {
                var state = response.getState();
                alert(state);
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
    
    handleSave1: function(component, event, helper) {
    // Get the iframe element
    var iframe = component.find("pdfIframe").getElement();

    // Access the contentWindow of the iframe
    var iframeWindow = iframe.contentWindow;

    // Access the document inside the iframe
    var iframeDocument = iframeWindow.document;

    // Assuming the PDF content is in an HTML element with a specific ID,
    // you can retrieve the content by accessing the element by ID
    var pdfElement = iframeDocument.getElementById('pdfContent');

    // Extract the content of the PDF element
    var pdfData = pdfElement.innerHTML;

    // Now you have the PDF data from the iframe
    console.log(pdfData);

    // ... Rest of the code to save or process the PDF data
}

    
    
 
    
})