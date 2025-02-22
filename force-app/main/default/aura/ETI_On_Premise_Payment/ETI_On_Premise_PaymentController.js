({
    doInit: function(component, event, helper) {
        $A.util.toggleClass(component.find("spinner"), 'slds-hide');
        var recordId = component.get("v.recordId");
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var resultsToast = $A.get("e.force:showToast");
        var action = component.get("c.getAmount");
       	helper.getRecordtypeId(component);
        action.setParams({ 
            recordId : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var servicereq = response.getReturnValue();
                console.log("servicereq "+JSON.stringify(servicereq));
                if(servicereq!=null && servicereq!=''){
                    component.set('v.amount', servicereq.Total_Amount__c);
                    console.log("Account>> "+servicereq.ET_Account__c);
                    if(servicereq.ET_Account__c!=undefined && servicereq.ET_Account__c!=null)
                    	component.set('v.servicerecordtypeid', servicereq.ET_Account__r.RecordTypeId);
                   // console.log('@@@@@@@@    ', servicereq.ET_Account__r.RecordTypeId);
                    //var paymentStatus = servicereq.Payment_Status__c == 'Payment Success' ? false:true;
                    if(servicereq.Payment_Status__c == 'Payment Success'){
                        $A.get("e.force:closeQuickAction").fire();
                        resultsToast.setParams({
                            "title": "Info!",
                            "mode": "sticky",
                            "message": "Your payment status is already initiated.",
                            "type":"info"
                        });
                    }else if(servicereq.Payment_Status__c == 'Payment Pending'){
                        component.set('v.paymentStatus', true);
                    }
                }else {
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.setParams({
                         title: "Info!",
                         mode: "sticky",
                         message: "You are not allowed to do a payment for Cancelled Bookings.",
                         type: "info"
                    });
                    
                }
                resultsToast.fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            $A.util.toggleClass(component.find("spinner"), 'slds-hide');
        });
        $A.enqueueAction(action);
    },
    
    handleSaveContact: function(component, event, helper) {
        try{
             $A.util.toggleClass(component.find("spinner"), 'slds-hide');
        var refId= component.get("v.transactionId");
        var paymentMode= component.get("v.paymentMode");
        console.log('recordId>> '+component.get("v.recordId"));
        console.log('refId>> '+refId);
        console.log('paymentMode>> '+paymentMode);
        if(refId !='' && refId !=null)
            component.find('transaction').setCustomValidity("");
        if(paymentMode !='' && paymentMode !=null)
            component.set('v.errorPaymentMode',false);
        if(refId!='' && refId!=null && paymentMode!='' && paymentMode!=null){
             component.set('v.isDisabledupate', true);
            var action = component.get("c.updateServiceRequest");
            action.setParams({
                "srId": component.get("v.recordId"),
                "paymentRefId": refId,
                "paymentMode": paymentMode
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var resultsToast = $A.get("e.force:showToast");
                if(state === "SUCCESS") {
                    var results = response.getReturnValue();
                    console.log('results>> ', results)
                    var message = '';
                    if(results.isAllValid){
                        resultsToast.setParams({
                            "title": "Success!",
                            "message":  "Payment details updated sucessfully.",
                            "type":"success"
                        });
                    }else{
                        //+ results.message,
                        resultsToast.setParams({
                            "title": "Error!",
                            "message":  "Receipts failed to sync with AMAN, please sync manually.",
                            "type":"error"
                        });
                    }
                    let bookingId = component.get('v.bookingId');
                    if(component.get('v.isWalkinRequest')){
                        if(results.isAllValid){
                            if( component.get('v.servicerecordtypeid') == component.get('v.b2brecordtypeid')){
                                 window.open('/apex/ETI_B2BInvoice?id=' + component.get("v.recordId"),'_blank');
                            }else{
                                window.open('/apex/ETI_Invoice?id=' + component.get("v.recordId"),'_blank');
                            }
                            resultsToast.fire();
                        }
                        if(bookingId){
                            var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": bookingId
                            });
                            navEvt.fire(); 
                        }
                        
                    }else if(results.isAllValid){
                         if( component.get('v.servicerecordtypeid') == component.get('v.b2brecordtypeid')){
                                 window.open('/apex/ETI_B2BReceipt?id=' + component.get("v.recordId"),'_blank');
                         }else{
                             window.open('/apex/ETI_Reciept?id=' + component.get("v.recordId"),'_blank');
                         }
                       
                        $A.get("e.force:closeQuickAction").fire();
                        resultsToast.fire();
                        $A.get("e.force:refreshView").fire();
                    }else{
                        $A.get("e.force:closeQuickAction").fire();
                        resultsToast.fire();
                        $A.get("e.force:refreshView").fire();
                    }
                    
                }else if (state === "ERROR") {
                    console.log('Problem saving contact, response state: ' + state);
                }else {
                    console.log('Unknown problem, response state: ' + state);
                }
                $A.util.toggleClass(component.find("spinner"), 'slds-hide');
            });
            $A.enqueueAction(action);
        }else {
            if(refId =='' || refId ==null){
                component.find('transaction').setCustomValidity("This field is required");
                component.find('transaction').reportValidity();
            }
            if(paymentMode =='' || paymentMode ==null)
                component.set('v.errorPaymentMode',true);
        }
        }catch(err){
            alert(err.message)
        }
    },
    
    handleCancel: function(component, event, helper) {
        if(component.get('v.isWalkinRequest'))
            component.set('v.isClosePopup',false);
        else
            $A.get("e.force:closeQuickAction").fire();
    }
})