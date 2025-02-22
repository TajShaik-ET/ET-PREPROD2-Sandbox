({
    doinit : function(component, event, helper) {
        helper.setCommunityLanguage(component, event, helper); 
        console.log('isInspectionFeeExist>> '+component.get("v.isInspectionFeeExist"));
        var bookingFeeDetails=component.get("v.bookingFeeDetails");
        console.log('bookingFeeDetails>> '+JSON.stringify(bookingFeeDetails));
        component.set("v.paymentvehicleid", bookingFeeDetails.serviceRequestId);
        console.log('serviceRequestId>> '+bookingFeeDetails.serviceRequestId);
        //var feeDetails;
        var serviceRequestId;
        /*for (var key in bookingFeeDetails) {
            if(serviceRequestId=='' || serviceRequestId ==null || serviceRequestId == undefined)
                serviceRequestId=key;
            feeDetails=bookingFeeDetails[key];
        }
        component.set("v.paymentvehicleid", serviceRequestId);*/
        var feeDetails =[];
        for(var idx = 0; idx < bookingFeeDetails.chassisNo.length; idx++){
            for (var i = 0; i < bookingFeeDetails.chassisNo[idx].typeList.length; i++) {
                for(var j = 0; j < bookingFeeDetails.chassisNo[idx].typeList[i].serviceItems.length; j++){
                    if(bookingFeeDetails.chassisNo[idx].typeList[i].serviceItems[j].Fee_Integration_Status__c=='S'){
                        component.set("v.isFeeExist", true);
                    }
                    feeDetails.push(bookingFeeDetails.chassisNo[idx].typeList[i].serviceItems[j]);
                }
            }
        }
        console.log('feeDetails>> '+JSON.stringify(feeDetails));
        component.set('v.feeDetails', feeDetails);
        for(var idx = 0; idx < feeDetails.length; idx++){
            if(feeDetails[idx].Fee_Integration_Status__c=='S'){
                component.set("v.isFeeExist", true);
                break;
            }
        }
        console.log('isFeeExist>> '+component.get("v.isFeeExist"));
        if(component.get("v.isFeeExist"))
            helper.calculateSubTotalAmount(component, event, component.get("v.feeDetails"));
        else 
            return true;
        //configurable lookup logic
        var displayServiceAction = component.get("c.objDisplayServiceSettings");
        displayServiceAction.setCallback(this, function(response){
             var state = response.getState();
                console.log('state>> '+state);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set("v.displaySettings",result);
                }
         });
    	$A.enqueueAction(displayServiceAction);
        
        /*if(component.get("v.isInspectionFeeExist")){
            console.log('Afterbooking>> '+JSON.stringify(component.get("v.Afterbooking")));
            var action = component.get("c.getAfterBookingDetails");
            action.setParams({
                lstBooking: component.get("v.Afterbooking")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state>> '+state);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    component.set("v.bookingData",result);
                     helper.calculateSubTotalAmount(component, event, helper);
                    //ETI_VehicleController.bookingWrapper
                    console.log('resultWrp>> '+JSON.stringify(result));
                    //helper.hideSpinner(component);
                }else {
                    alert("Temporary Error: There is a problem in getting booked details.");
                }
            });
            $A.enqueueAction(action);
        }else {
            var con1 = component.get("v.paymentvehicleid");
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/eti-vehiclepayment?recordId=" + con1 + "&button=Premises"
            });
            urlEvent.fire();
        }*/
    },
    
    closePaymentDetail: function (component, event, helper) {
        if(component.get('v.subtotalPrice')!=undefined && component.get('v.subtotalPrice')==0){
            var msg=component.get("v.Request_completed_Message");
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Success"),msg,"","dismissible","success");
        }
        component.set("v.isInspectionFeeExist", false);
        var url = new URL(window.location.href);
        var search_params = url.searchParams; 
        var recId = search_params.get('recordId');
        var urlEvent = $A.get("e.force:navigateToURL");
        if(component.get('v.isNavigateToHome')){
            urlEvent.setParams({
                "url": decodeURIComponent(window.location)
            });
        }else {
            urlEvent.setParams({
                "url": '/customer/s/vehicle-page?showH=true&recordId='+recId+'&lang='+component.get("v.clLang")                        
            });
        }
        urlEvent.fire();
    },
    cardPayment: function (component, event, helper) {
        let termsAndCond= component.get('v.isTearmAndCondition');
        var subTotal = component.get("v.subtotalPrice");
        if(!termsAndCond){
            component.set("v.IsSpinner", false);
            var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
            var errorElement =  component.find('termsandconditioncheckboxError').getElement();
            $A.util.addClass(parentElement, 'slds-has-error');
            $A.util.removeClass(errorElement, 'slds-hide');
            return false;
        }
        var whichButton = event.getSource().getLocalId();
      
        if(subTotal != null && subTotal < 150000 && subTotal > 0){
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/eti-vehiclepayment?recordId=" + component.get("v.paymentvehicleid") +"&button=" + whichButton + "&src=et"+"&lang="+component.get("v.clLang")
            });
            urlEvent.fire();
        }else{
            var msg=subTotal==null ||subTotal==0? 'Subtotal cant be 0 or null' : 'Cap limit exceeds for online payment, please try less than or eqaul to 150000 AED.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("warning!",msg,"","dismissible","warning");
        }
        
    }, 
    handleTermAndCond: function(component, event){
        try{
          var val =  component.find('termsandconditioncheckbox').getElement().checked;
            if(val){
                var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                $A.util.removeClass(parentElement, 'slds-has-error');
                $A.util.addClass(errorElement, 'slds-hide');
            }else{
                var parentElement =  component.find('termsandconditioncheckboxParent').getElement();
                var errorElement =  component.find('termsandconditioncheckboxError').getElement();
                $A.util.addClass(parentElement, 'slds-has-error');
                $A.util.removeClass(errorElement, 'slds-hide');
            }
            component.set('v.isTearmAndCondition', val);
        }catch(err){
            console.log(err.message)
        }
    },
    removeBooking: function(component, event, helper){
        helper.removeBookingHelper(component, event, helper);
    }
})