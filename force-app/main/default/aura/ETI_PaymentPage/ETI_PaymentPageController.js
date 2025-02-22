({
    doInit: function (component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        helper.getGoogleMarker(component, event, helper);
        var urlrecordid = component.get("v.recordId");
        component.set("v.recordidurl", urlrecordid);
        console.log("urlrecordid..." + urlrecordid);

        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
        console.log(sPageURL + '...sPageURL');
        var str = sPageURL.substring(sPageURL.search("card"), sPageURL.length);
        var Cardtype = str.substring(str.search("card"), str.search("&"));

        console.log(Cardtype + '...Cardtype');
        component.set("v.Cardtypes", Cardtype);
        var pstr = sPageURL.substring(sPageURL.search("Premises"), sPageURL.length);

        var premisestype = pstr.substring(pstr.search("Premises"), pstr.search("&"));
        console.log(premisestype + '...premisestype');
        component.set("v.premisestypes", premisestype);
        if (Cardtype == 'card') {
            console.log("inside card");
            component.set("v.paymentpremises", false);
            component.set("v.paymentType", true);
            component.set('v.vfUrl', '/apex/ETPaymentForm?recordId=' + component.get("v.recordId") + '&src=et');
            var urlString = window.location.href;
            console.log('urlString  '+urlString);
            var vfOrigin = urlString.substring(0, urlString.indexOf("/customer/s"));
            console.log('vfOrigin  ' + vfOrigin);
            component.set("v.vfHost", vfOrigin);
            //var vfOrigin =component.get("v.vfHost");
            //console.log('vfOrigin-->'+vfOrigin);
            window.addEventListener("message", $A.getCallback(function (event) {
				console.log('message11-->' + message);
                if (event.origin !== vfOrigin) {
                    // Not the expected origin: Reject the message!
                    //console.log(event.data);
                    return;
                }
                // Handle the message
                console.log(event);
                var message = event.data;
                console.log('message-->' + message);
                if (message == 'PaymentCancelled') {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/eti-homepage?lang='+component.get("v.clLang")

                    });
                    urlEvent.fire();
                }
                var res = message.split("~");
                var source = '';
                var messageText = '';
                var paymentId = '';
                var paymentData = '';
                if (res.length > 0) {
                    source = res[0];
                    console.log('source: ' + source);
                    paymentId = res[1];
                    console.log('paymentId: ' + paymentId);
                    component.set('v.paymentId', paymentId);
                    messageText = res[2];
                    console.log('messageText: ' + messageText);
                }
                if (messageText == 'SUCCESS') {
                    var msg = 'The Payment has be completed Successfully.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Success!", msg, "", "dismissible", "info");
                    var recordId = component.get("v.recordidurl");
                    //window.open("/apex/ETI_InvoicePage?id=" + recordId);
                   // window.open("/apex/ETI_InvoicePage?&id=" + recordId + '&status=Payment%20Success');
                    window.open("/apex/ETI_Invoice?&id=" + recordId);
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/eti-homepage?lang='+component.get("v.clLang")
                    });
                    urlEvent.fire();
                   //helper.navigateToUrl(component, event, helper,recordId);
                }
                console.log(event.origin);
                console.log(vfOrigin);
            }), false);
        }
        if (premisestype == 'Premises') {
            helper.bookingdetails(component, event, helper);
            component.set("v.paymentType", false);
            component.set("v.paymentpremises", true);
        }
    },
    cancelSave: function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/eti-homepage?lang='+component.get("v.clLang")
        });
        urlEvent.fire();
    },
    generateInvoicenow: function (component, event, helper) {
        var recordId = component.get("v.recordidurl");
        window.open("/apex/ETI_InvoicePage?&id=" + recordId);
    },

})