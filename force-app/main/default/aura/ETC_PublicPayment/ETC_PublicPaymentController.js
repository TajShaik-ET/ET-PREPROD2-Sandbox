({
    doInit : function(component, event, helper) {
        var url = new URL(window.location.href);
        var search_params = url.searchParams.get('id');
        var search_params_src = url.searchParams.get('src');
       // helper.getParamsfromURL(component, event, helper);
        component.set('v.vfUrl', '../apex/ETPaymentForm?recordId='+search_params+'&src='+search_params_src+'#');
        var urlString = window.location.href;
            //console.log('urlString  '+urlString);
        var vfOrigin = urlString.substring(0, urlString.indexOf("/etpayment/s"));
            //console.log('vfOrigin  ' + vfOrigin);
        window.addEventListener("message", $A.getCallback(function (event) {
          
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
               // console.log('--inside if--'+event.data);
                return;
            }            
           
            var res = event.data.split("~");
            var source = '';
            var messageText = '';
            var paymentId = '';
            var paymentData = '';
            if (res.length > 0) {
                source = res[0];
                console.log('source: ' + source);
                paymentId = res[1];
                //console.log('paymentId: ' + paymentId);
                component.set('v.paymentId', paymentId);
                messageText = res[2];
                console.log('messageText: ' + messageText);
            }
            if (messageText == 'SUCCESS') {
                
              
                component.set("v.showFrame",false);   
                component.set("v.showMsg",true);   
               /* var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": 'https://et.ae/en/'
                    });
                    urlEvent.fire();*/
                
            }else{
                 var toastReference = $A.get("e.force:showToast");
                toastReference.setParams({
                    "type":"Error",
                    "title":"Error",
                    "message":"Your Payment Failed, Please try again",
                    "mode":"dismissible"
                });
                toastReference.fire();
            }
        }), false);
    }
})