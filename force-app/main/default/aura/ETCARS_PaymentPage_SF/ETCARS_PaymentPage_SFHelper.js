({
    
    redirectTo : function(component, page) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": page                            
        });
        urlEvent.fire();
        
    },
    
    setPaymentPage:function(component, event, helper) {
        // set the Payment Gateway URL and handle its Response
        component.set('v.vfUrl','/apex/ETPaymentForm?recordId='+component.get('v.recordId')+'&src=etCar');
        console.log('url = '+component.get("v.vfUrl"));
        var urlString=window.location.href;
        var vfOrigin = urlString.substring(0, urlString.indexOf("/s"));
        console.log('vfOrigin  '+vfOrigin);
        component.set("v.vfHost", vfOrigin);
        window.addEventListener("message", $A.getCallback(function(event) {
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                return;
            }
            // Handle the message
            console.log(event);
            var message = event.data;
            console.log('message-->'+message);
            if(message=='PaymentCancelled'){
                helper.redirectTo(component, '/etcars-paymentpage');
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
                console.log('Payment Success');
                // var page = '/booking-confirmation-page?reqId='+component.get('v.reqId')+'&src='+component.get('v.reqType')+'&selCar_Id='+component.get('v.selectedCarId')+'&billingTotal='+component.get('v.billingTotal');
                // helper.redirectTo(component, page);
                //return;
            }
            
            console.log(event.origin);
            console.log(vfOrigin);
            
        }), false);
    },
    
    querySelectedCarId : function(component, event, helper) {
        var utility = component.find("ETCAR_UtillityMethods");
        var backendMethod = "servieReqDetails";
        var params = {
            "reqId" : component.get("v.recordId")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('reqest Details'+ JSON.stringify(response)); 
                component.set("v.serviceRecord", response);
                if(response.Service_Request_Line_Items__r.length > 0){
                    component.set("v.selectedCarId", response.Service_Request_Line_Items__r[0].ETCAR_Selecetd_Car__c);
                    var carId = response.Service_Request_Line_Items__r[0].Id;
                    // Pass CarId and get the selected Car details from server:
                    if(carId != null){
                        var utility = component.find("ETCAR_UtillityMethods");
                        var backendMethod = "getCarDetails";
                        var params = {
                            "carId" : carId
                        };
                        var promise = utility.executeServerCall(component, backendMethod, params);
                        promise.then (
                            $A.getCallback(function(response) {
                                console.log('Selected Car Details'+ response); 
                                component.set("v.selectedCar", JSON.parse(response));
                                
                            }),
                            
                            $A.getCallback(function(error) {
                                var err = JSON.parse(error);
                                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                                utility.showToast("Delivery Management", errorToShow, "error", "dismissible");
                            })
                        )
                    }
                    
                }
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Delivery Management", errorToShow, "error", "dismissible");
            })
        )	
    },
        
    queryCarDetails : function(component,carId) {
        var utility = component.find("ETCAR_UtillityMethods");
        var backendMethod = "getCarDetails";
        alert('carId = '+ carId);
        console.log('carId_New = '+ carId);
        var params = {
            "carId" : carId
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then (
            $A.getCallback(function(response) {
                console.log('Selected Car Details'+ response); 
                component.set("v.selectedCar", JSON.parse(response));
                
            }),
            
            $A.getCallback(function(error) {
                var err = JSON.parse(error);
                var errorToShow = utility.convertToUserFriendlyErrMsg(err.MESSAGE);
                utility.showToast("Delivery Management", errorToShow, "error", "dismissible");
            })
        )	
    }
})