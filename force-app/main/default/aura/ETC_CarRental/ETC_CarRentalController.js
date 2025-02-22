({
    doInit : function(component, event, helper) {
        helper.getBookingReqinfo(component, event, helper);
        var today = $A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm");
        component.set("v.todaysDate", today);
    },
    
    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        debugger;
        // handle Validations in One Way
        var isAllValid = true;
        var controlAuraIds = component.get("v.mandatoryFields_oneWay"); 
        for(let idd of controlAuraIds ){
            let element = component.find(idd);
            if(element){
                console.log('value = '+ element.get("v.value"));
                if(!element.get("v.value")){
                    if(idd == 'PickupDateTime' || idd=='ETCAR_Return_Date_Time__c'){
                        element.reportValidity();
                    } 
                    isAllValid = false;
                }
            }
        }
        //check PickupDate and ReturnDate Time Validation  
        if(component.get("v.invalidPickupDate")){
            isAllValid = false;
        }else if(component.get("v.invalidReturnDate")){
            isAllValid = false;
        }
        
        var utility = component.find("ETCAR_UtillityMethods");
        console.log('isAllValid  = '+ isAllValid);
        if(isAllValid){
            component.set('v.loaded', !component.get('v.loaded'));
            var fields = event.getParam("fields");
            fields.ETCAR_Service_Request__c =  component.get('v.serReqId');
            fields.ETST_Service_Type__c = 'Rental';
            if(component.get('v.passengerMobileNumber') != undefined && component.get('v.passengerMobileNumber') != null){
                fields.ETC_Passenger_Mobile_Number__c = '+971'+component.get('v.passengerMobileNumber');   
            } 
            //fields.ETC_Duration__c = $A.get("$Label.c.ETC_OneWay_OrderType");
            component.set("v.serviceType" ,'Rental');
            console.log('fields str = '+ JSON.stringify(fields));
            component.find("form").submit(fields);
        }
    },
    
    handleOnSuccess : function(component, event, helper) {
        var vbkngId = event.getParams().response;
        console.log('vbkngId '+vbkngId.id);
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ChooseCarPageSF",
            componentAttributes: {
                serReqId : component.get('v.serReqId'),
                bReqId : vbkngId.id,
                carInventoryType : "ETC_Rental_Vehicle"
            }
        });
        evt.fire();
    },
    
    handleOnError : function(component, event, helper) {
        component.set('v.loaded', !component.get('v.loaded'));
        var utility = component.find("ETCAR_UtillityMethods");
        console.error('error = '+ event.getParam("detail"));
        var error = event.getParam("detail");
        //set Validation message from salsforce and show in UI...
        component.set("v.serverValidationMsg", error);
        $A.util.removeClass(component.find("serverValidations"), "slds-hide");
        console.log(error.detail); // main error message
        console.dir(JSON.stringify(event.getParams())); 
    },
    
    selectPickUpOption:function(component, event, helper) {
        console.log('---selectOption---');
        var str = event.currentTarget.dataset.address;;
        console.log('str  = ' + str);
        var result = str.includes("Airport");
        console.log('result = '+ result);
        if(result){
            component.set("v.flightdetails",true);
        }else{
            component.set("v.flightdetails",false);
        }
        helper.getAddressDetailsByPlaceId(component, event);
    },
    
    selectDropOffOption:function(component, event, helper) {
        console.log('---selectOption---');
        component.set('v.isDropoff',true);
        var str = event.currentTarget.dataset.address;;
        console.log('str  = ' + str);
        var result = str.includes("Airport");
        console.log('result = '+ result);
        if(result){
            component.set("v.flightdetails_D",true);
        }else{
            component.set("v.flightdetails_D",false);
        }
        helper.getAddressDetailsByPlaceId(component, event);
    },
    
    getPickupLocation: function(component, event, helper) {
        component.set('v.isDropoff',false);
        var searchText=component.get("v.VehicleBooking.ETST_Pick_Up_From__c");
        console.log('searchText = '+searchText);
        if(!searchText){
            console.log('inside if = '+searchText);
            $A.util.addClass(component.find("invalidpickup"), "slds-hide"); 
            component.set("v.pickAddressList", null);
        }
        else{
            helper.getAddressRecommendations(component,event,searchText); 
        } 
        
    },  
    getDropoffLocation: function(component, event, helper) {
        console.log('---getDropoffLocation---');
        component.set('v.isDropoff',true);
        var searchText=component.get("v.VehicleBooking.ETST_Drop_Off_To__c");
        console.log('searchText = '+searchText);
        if(!searchText){
            $A.util.addClass(component.find("invalidDrop"), "slds-hide");   
            component.set("v.dropAddressList", null);
        }
        else{
            helper.getAddressRecommendations(component,event,searchText); 
        }
    },
    
    validatePickupDateTime: function(component, event, helper) {
        debugger;
        var today = $A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm");
        if(component.get('v.VehicleBooking.ETCAR_Pick_UP_Date_Time__c')>=today){
            $A.util.addClass(component.find("invalidPickupDate"), "slds-hide");
            component.set("v.invalidPickupDate", false);
        }else{
            // in case of Error 
            component.set("v.invalidPickupDate", true);
            $A.util.removeClass(component.find("invalidPickupDate"), "slds-hide");
        }
    },
    
    validateReturnDateTime: function(component, event, helper) {
        debugger;
        var today = $A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm");
        // check if selected Date is Future Date or not
        if(component.get('v.VehicleBooking.ETCAR_Return_Date_Time__c')<=component.get('v.VehicleBooking.ETCAR_Pick_UP_Date_Time__c')){
            component.set("v.invalidReturnDate", true);
            $A.util.addClass(component.find("invalidreturnDate"), "slds-hide");
            $A.util.removeClass(component.find("returnLessthanPickup"), "slds-hide");
        }else if(component.get('v.VehicleBooking.ETCAR_Return_Date_Time__c')<=today){
            component.set("v.invalidReturnDate", true);
            $A.util.removeClass(component.find("invalidreturnDate"), "slds-hide");
        }else{
            component.set("v.invalidReturnDate", false);
            $A.util.addClass(component.find("invalidreturnDate"), "slds-hide");
            $A.util.addClass(component.find("returnLessthanPickup"), "slds-hide");
        }
    },
    
    checkForAirportText: function(component, event, helper) {
        var from = component.find("pickupAddress");
        var str = from.get("v.value");
        var substr = "Airport";
        var result = str.indexOf(substr) > -1;
        //alert(result);//
    },
    hoursChange: function(component, event, helper) {
        var hrs = component.find("additionalHoursId").get("v.value");
        console.log('hrs '+hrs);
        console.log('label '+$A.get("$Label.c.ETCRentalCarsDurationHours"));
        if(hrs == $A.get("$Label.c.ETCRentalCarsDurationHours")){
            component.set("v.additionalHours",true); 
        }else{
            component.set("v.additionalHours",false); 
            component.set("v.VehicleBooking_H.ETC_Additional_Hours__c",'');
            
        }
    },  
})