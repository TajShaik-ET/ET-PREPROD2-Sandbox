({
    doInit: function (component, event, helper) {
        if(screen.width<=480){
            component.set('v.showInvoice', false);
        }else{
            component.set('v.showInvoice', true);
        }
      /*  component.set('v.mapMarkers', [
            {
                location: {
                    City: 'San Francisco',
                    Country: 'USA',
                    PostalCode: '94105',
                    State: 'CA',
                    Street: 'The Landmark @ One Market, Suite 300'
                },

                title: 'Emirates Tranport',
                description: 'Near RTA Head Office'
            }
        ]);
        component.set('v.zoomLevel', 8);*/
       
       //Added by Janardhan
        var urlStr = new URL(window.location.href);
        var search_params = urlStr.searchParams;
        var zoneVal = search_params.get('zone');
       //End
        component.set('v.vfUrl','/apex/ETPaymentForm?recordId='+component.get('v.recordId')+'&src=etst&zone='+zoneVal);
        var urlString=window.location.href;
       // var urlString=window.open.href;
        //console.log('urlString  '+urlString);
        var vfOrigin = urlString.substring(0, urlString.indexOf("/customer/s"));
        console.log('vfOrigin  '+vfOrigin);
        component.set("v.vfHost", vfOrigin);
        var invoicePageURL = urlString.substring(0, urlString.indexOf("/customer"));
        console.log('invoicePageURL***'+invoicePageURL);
        component.set("v.invoicePageURL", invoicePageURL);
        component.set("v.invoicePageURL",'/apex/ETST_InvoicePdf?id='+component.get('v.recordId'));
       // window.open(component.get("v.vfUrl"));
        //var vfOrigin =component.get("v.vfHost");
        //console.log('vfOrigin-->'+vfOrigin);
        window.addEventListener("message", $A.getCallback(function(event) {
            
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                //console.log(event.data);
                return;
            }
            // Handle the message
            console.log(event);
            var message = event.data;
            console.log('message-->'+message);
            if(message=='PaymentCancelled'){
                helper.redirectTo(component, '/etst-home-page');
            }
            var res = message.split("~");
            var source = '';
            var messageText = '';
            var paymentId = '';
            var paymentData = '';
            if(res.length > 0){ 
                source = res[0];
                console.log('source: '+source);
                paymentId = res[1];
                console.log('paymentId: '+paymentId);
                component.set('v.paymentId',paymentId);
                messageText = res[2];
                console.log('messageText: '+messageText);
                
            }
            
            if(messageText == 'SUCCESS'){
                 // component.set("v.currentStep",'Payment success');
                  helper.updateTransportRequestStatus(component, event, helper);
                  return;
            }else if (messageText == 'FAILED'){
                var utility = component.find("ETST_UtilityMethods");
                utility.showToast("School Tranport", 'Payment Failed', "error", "dismissible");
                helper.redirectTo(component, '/etst-home-page');
            }
            
            console.log(event.origin);
            console.log(vfOrigin);
            
        }), false);
		helper.getInvoice(component, event, helper);
        helper.getStudent(component, event, helper);
        helper.setCommunityLanguage(component, event, helper); 
        var lang=component.get('v.clLang');
        if(lang=='en' || lang=='null' || lang==null|| lang==undefined){
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__body');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
        }else{
            $A.util.addClass(component.find('mainDiv'), 'slds-modal__bodyrtl');
            $A.util.removeClass(component.find('mainDiv'), 'slds-modal__body');
        } 
    },
    cancelSave: function(component, event, helper) {
        helper.redirectTo(component, '/etst-home-page?lang='+component.get("v.clLang"));
    },
    generateInvoice: function(component, event, helper) {
        helper.createInvoice(component, event, helper);
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    likenClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        alert('thanks for like Us :)');
        component.set("v.isOpen", false);
    },
})