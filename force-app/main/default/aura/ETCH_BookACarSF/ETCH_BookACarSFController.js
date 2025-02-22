({
    doInit : function(component, event, helper) {
        helper.getBookingReqinfo(component, event, helper);
        var today = $A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm");
        component.set("v.todaysDate", today);
    },
    
    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        // handle Validations in One Way
        var isAllValid = true;
        var controlAuraIds = component.get("v.mandatoryFields_oneWay"); 
        console.log('Mandatory fields :');
        console.dir(controlAuraIds);
        for(let idd of controlAuraIds ){
            console.log('idd = '+ idd);
            let element = component.find(idd);
            if(element){
                console.log('value = '+ element.get("v.value"));
                if(!element.get("v.value")){
                    element.reportValidity();
                    isAllValid = false;
                }
            }
        }
        //check PickupDate Time Validation  
        if(component.get("v.invalidPickupDate")){
            isAllValid = false;
        }
        
        var utility = component.find("ETCAR_UtillityMethods");
        console.log('isAllValid  = '+ isAllValid);
        if(isAllValid){
            component.set('v.loaded', !component.get('v.loaded'));
            var fields = event.getParam("fields");
            fields.ETCAR_Service_Request__c =  component.get('v.serReqId');
            if(component.get('v.passengerMobileNumber') != undefined && component.get('v.passengerMobileNumber') != null){
                fields.ETC_Passenger_Mobile_Number__c = '+971'+component.get('v.passengerMobileNumber');   
            } 
            fields.ETST_Service_Type__c = 'One Way';
            fields.ETC_Duration__c = $A.get("$Label.c.ETC_OneWay_OrderType");
            component.set("v.serviceType" ,'One Way');
            console.log('fields str = '+ JSON.stringify(fields));
            component.find("form").submit(fields);
        }
    },
    
    handleSubmit_H : function(component, event, helper) {
        event.preventDefault();
        // handle Validations in Hourly
        var isAllValid = true;
        var controlAuraIds = component.get("v.mandatoryFields_Hourly"); 
        for(let idd of controlAuraIds ){
            let element = component.find(idd);
            if(element){
                console.log('value = '+ element.get("v.value"));
                if(!element.get("v.value")){
                    if(idd == 'H_ETCAR_Pick_UP_Date_Time__c'){
                        element.reportValidity();
                    }
                    isAllValid = false;
                }
            }
        }
        //check PickupDate Time Validation  
        if(component.get("v.invalidPickupDate_H")){
            isAllValid = false;
        }
        if(isAllValid){
            component.set('v.loaded', !component.get('v.loaded'));
            var fields = event.getParam("fields");
            fields.ETCAR_Service_Request__c = component.get('v.serReqId');
            fields.ETST_Service_Type__c = 'Hourly';
            if(component.get('v.H_passengerMobileNumber') != undefined && component.get('v.H_passengerMobileNumber') != null){
                fields.ETC_Passenger_Mobile_Number__c = '+971'+component.get('v.H_passengerMobileNumber');   
            } 
            component.set("v.serviceType" ,'Hourly');
            fields.ETST_Pick_Up_From__c = component.get("v.VehicleBooking_H.ETST_Pick_Up_From__c");
            fields.ETST_Drop_Off_To__c = component.get("v.VehicleBooking_H.ETST_Drop_Off_To__c");
            console.log('fields str = '+ JSON.stringify(fields));
            component.find("form_H").submit(fields);
            
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
                carInventoryType : 'ETC_Limo_Vehicle'
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
    
    handleOnError_H : function(component, event, helper) {
        component.set('v.loaded', !component.get('v.loaded'));
        var utility = component.find("ETCAR_UtillityMethods");
        console.error('error = '+ event.getParam("detail"));
        var error = event.getParam("detail");
        //set Validation message from salsforce and show in UI...
        component.set("v.serverValidationMsg_H", error);
        $A.util.removeClass(component.find("serverValidations_H"), "slds-hide");
        console.log(error.detail); // main error message
        console.dir(JSON.stringify(event.getParams())); 
    },
    
    handleTabSelect : function(component, event, helper) {
        let allFieldIds =component.get("v.allFields");
        // for every Tab Change of Hourly & One Way --> null the fields if filled previously...
        for(let idd of allFieldIds ){
            let element = component.find(idd);
            if(element){
                console.log('in element');
              //  element.set("v.value",null);
            }
        }
        //hide Validations on Success for one way
        $A.util.addClass(component.find("serverValidations"), "slds-hide");
        //hide Validations on Success for Hourly
        $A.util.addClass(component.find("serverValidations_H"), "slds-hide");
        // null the address search on Tab Change
        component.set("v.dropAddressList", null);
        component.set("v.pickAddressList", null);
        component.set("v.flightdetails",false);
        component.set('v.isDropoff',false);
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
    
    selectPickUpOption_H:function(component, event, helper) {
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
        helper.getAddressDetailsByPlaceId_H(component, event);
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
    selectDropOffOption_H:function(component, event, helper) {
        console.log('---selectOption---');
        component.set('v.isDropoff',true);
        var str = event.currentTarget.dataset.address;;
        var result = str.includes("Airport");
        console.log('result = '+ result);
        if(result){
            component.set("v.flightdetails_D",true);
        }else{
            component.set("v.flightdetails_D",false);
        }
        helper.getAddressDetailsByPlaceId_H(component, event);
    },
    
    getPickupLocation_H : function(component, event, helper) {
        component.set('v.isDropoff',false);
        var searchText=component.get("v.VehicleBooking_H.ETST_Pick_Up_From__c");
        $A.util.removeClass(component.find("Drop-Address-listbox_H"), "slds-hide");
        if(!searchText){
            $A.util.addClass(component.find("H_invalidpickup"), "slds-hide"); 
            component.set("v.H_pickAddressList", null);
        }
        else{
           helper.getAddressRecommendations_H(component,event,searchText); 
        } 
        
    },  
    
    getPickupLocation: function(component, event, helper) {
        component.set('v.isDropoff',false);
        var searchText=component.get("v.VehicleBooking.ETST_Pick_Up_From__c");
        console.log('searchText = '+searchText);
        if(!searchText){
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
    getDropoffLocation_H: function(component, event, helper) {
        console.log('---getDropoffLocation---');
        component.set('v.isDropoff',true);
        var searchText=component.get("v.VehicleBooking_H.ETST_Drop_Off_To__c");
        console.log('searchText = '+searchText);
        if(!searchText){
            $A.util.addClass(component.find("H_invalidDrop"), "slds-hide");   
            component.set("v.H_dropAddressList", null);
        }
        else{
           helper.getAddressRecommendations_H(component,event,searchText);
        } 
        
    },
    
    validatePickupDateTime: function(component, event, helper) {
        var today = $A.localizationService.formatDateUTC(new Date(), "yyyy-MM-ddTHH:mm");
        if(component.get('v.VehicleBooking.ETCAR_Pick_UP_Date_Time__c')>=today){
            $A.util.addClass(component.find("invalidPickupDate"), "slds-hide");
            component.set("v.invalidPickupDate", false);
        }
        else if(!component.get('v.VehicleBooking.ETCAR_Pick_UP_Date_Time__c') ){
            $A.util.addClass(component.find("invalidPickupDate"), "slds-hide");
            component.set("v.invalidPickupDate", true);
        }
        
        else{
            // in case of Error 
            component.set("v.invalidPickupDate", true);
            $A.util.removeClass(component.find("invalidPickupDate"), "slds-hide");
        }
    },
    
    validatePickupDateTime_hourly: function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "yyyy-MM-ddTHH:mm");
        if(component.get('v.VehicleBooking_H.ETCAR_Pick_UP_Date_Time__c')>=today){
            $A.util.addClass(component.find("invalidPickupDate_H"), "slds-hide");
            component.set("v.invalidPickupDate_H", false);
        }else{
            // in case of Error 
            component.set("v.invalidPickupDate_H", true);
            $A.util.removeClass(component.find("invalidPickupDate_H"), "slds-hide");
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