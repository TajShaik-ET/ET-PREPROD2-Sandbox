({
    doInit : function(component, event, helper) {
        console.log('onload');
        component.set("v.isOpen", true);
        helper.doInit(component, event, helper);		
    },
    closeModel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    saveRecord : function(component, event, helper){
        console.log('saved method');
        // Getting the edit form fields to validate
      //  var paymentFields = component.find("fieldToValidate");
        var paymentFields = component.find("fieldId");
        // Initialize the counter to zero - used to check validity of fields
        var blank=0;
        // If there are more than 1 fields
        console.log('paymentFields***'+paymentFields);
        if(paymentFields.length!=undefined) {
            // Iterating all the fields
            var allValid = paymentFields.reduce(function (validSoFar, inputCmp) {
                // Show help message if single field is invalid
                inputCmp.showHelpMessageIfInvalid();
                // return whether all fields are valid or not
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            // If all fields are not valid increment the counter
            if (!allValid) {
                blank++;
            }
        } else {
            // If there is only one field, get that field and check for validity (true/false)
            var allValid = paymentFields;
            // If field is not valid, increment the counter
            if (!allValid.get('v.validity').valid) {
                blank++;
            }
        }
        // Call the helper method only when counter is 0
        if(blank==0) {
            // Calling saveContacts if the button is save
             var allValid = component.find('fieldId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(allValid) {
             helper.createPaymentRecord(component, event, helper);
        }
     
            helper.createPaymentRecord(component, event, helper);
        }
    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    }
})