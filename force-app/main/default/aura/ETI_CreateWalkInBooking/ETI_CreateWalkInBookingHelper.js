({
    doinit1 : function(component, event, helper,flag) {
        component.set("v.IsSpinner", true);
        var today = $A.localizationService.formatDateUTC(new Date(), "YYYY-MM-DD");
        console.log('today>> '+today);
		component.set('v.minDate',today);
        component.set('v.tradeMinDate',today);
        console.log('today>> '+today);
        var maxErrMsgFormat = $A.localizationService.formatDateUTC(new Date(), "dd MMM yyyy");
        component.set('v.maxDateErrmsg',maxErrMsgFormat);
        var action = component.get("c.initializeWrapper");
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state>> '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.wrapperObj',result);
                component.set('v.wrapperObj.booking.Booking_Date__c',today);
                component.set('v.wrapperObj.customerVehicle.Registration_Type__c','');
                component.set('v.wrapperObj.booking.Mobile_No__c','971');
                component.set('v.wrapperObj.booking.Selected_Services_Code__c','');
                component.set('v.wrapperObj.booking.ET_Location__c','');
                console.log('result>> '+JSON.stringify(result));
                if(result.userDetails.length>0 && result.userDetails!=undefined){
                    console.log('emirate.INN..'+result.userDetails[0].ETI_Emirate__c);
                    component.set("v.emirate",result.userDetails[0].ETI_Emirate__c);
                }
                if(flag)
                	helper.getLocation(component, event, helper);
            }
        });
        $A.enqueueAction(action);
        component.set("v.IsSpinner", false);
	},
    getPlateCombinations: function (component, event, helper) {
        var action = component.get("c.getAmanLookupDetails");
        action.setParams({
            SelectedLang: "en"
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returning = [];
                var result = response.getReturnValue();
                var pType = [];
                var pSource = [];
                var pColor = [];
                result.plateTypes.forEach(test => {
                    pType.push({
                        label: test.lookupName,
                        value: test.lookupCode
                    });
                });
                result.plateSources.forEach(test => {
                    pSource.push({
                        label: test.lookupName,
                        value: test.lookupCode
                    });
                });
                result.plateColors.forEach(test => {
                    pColor.push({
                        label: test.lookupName,
                        value: test.lookupCode
                    });
                });
                component.set("v.PlateType", pType);
                component.set("v.Platesource", pSource);
                component.set("v.Platecolor", pColor);
                console.log('@@@@', pSource);
                console.log('pType>> ' + JSON.stringify(pType));
    			this.getServiceType(component, event, helper);
            } else {
                var msg = 'There is a problem getting plate combinations  picklist values.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Info!", msg, "", "Sticky", "info");
            }
        });
        $A.enqueueAction(action);
    },
    getServiceType: function (component, event, helper) {
        var action = component.get("c.getPickListValues1");
        action.setParams({
            selectedObject: "ETI_Booking__c",
            selectedField: "Service_Type__c"
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returning = [];
                var result = response.getReturnValue();
                var sType=[];
                for (var i = 0; i < result.length; i++) {
                    if(result[i]!='SPEA Inspection' && result[i]!='ADFCA') 
                        sType.push(result[i]);
                }
                component.set("v.serviceType", sType);
                this.getPurposeType(component, event, helper);
            }
            else {
                var msg = 'There is a problem in getting Service Types.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Info", msg, "", "Sticky", "info");
            }
        });
        $A.enqueueAction(action);
    },
    getVehicleServiceType: function (component, event, helper) {
        var action = component.get("c.getVehicleServiceType");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('@########   '+ result);
                component.set("v.vehicleServiceTypeValues", result);
                this.getVehicleColor(component, event, helper);
            } else {
                var msg = 'There is a problem getting service type  picklist values.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Info!", msg, "", "Sticky", "info");
            }
        });
        $A.enqueueAction(action);
    },
    getPurposeType: function (component, event, helper) {
        var action = component.get("c.getTestPurposeTypes");
        action.setParams({
            SelectedLang: "en"
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returning = [];
                var result = response.getReturnValue();
                console.log('testPurposeType '+ JSON.stringify(result));
                component.set("v.testPurposeType", result);
                this.getVehicleType(component, event, helper);
            }
            else {
                var msg = 'There is a problem in getting Purpose Types.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Info", msg, "", "Sticky", "info");
            }
        });
        $A.enqueueAction(action);
    },
    getVehicleType: function (component, event, helper) {
        var action = component.get("c.getVehicleTypes");
        action.setParams({
            SelectedLang: "en"
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returning = [];
                var result = response.getReturnValue();
                component.set("v.newVehicleTypeList", result);
                this.getVehicleServiceType(component, event, helper);
            }
            else {
                var msg = 'There is a problem in getting Vehicle Types.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Info", msg, "", "Sticky", "info");
            }
        });
        $A.enqueueAction(action);
    },
    getLaneType: function (component, event, helper) {
        console.log('getLaneType');
        var wrp = component.get("v.wrapperObj");
        console.log('ET_Location__c '+ wrp.booking.ET_Location__c);
        console.log('Selected_Services_Code__c '+ wrp.booking.Selected_Services_Code__c);
        if(wrp.booking.ET_Location__c!=null && wrp.booking.ET_Location__c!=''
            && wrp.booking.Selected_Services_Code__c!=null && wrp.booking.Selected_Services_Code__c!=''){
            var action = component.get("c.getLaneTypes");
            action.setParams({
                location: wrp.booking.ET_Location__c,
                service: wrp.booking.Selected_Services_Code__c
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returning = [];
                    var result = response.getReturnValue();
                    console.log('laneTypes '+ JSON.stringify(result));
                    component.set("v.laneTypes", result);
                } else {
                    var msg = 'There is a problem in getting Lane Types.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Info", msg, "", "Sticky", "info");
                }
            });
            $A.enqueueAction(action);
        }
    },
    getVehicleColor: function(component,event,helper){
        var action = component.get("c.getVehicleColors");
        action.setParams({
            SelectedLang: "en"
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var result = response.getReturnValue();
                console.log('resultColor###   '+ JSON.stringify(result));
                component.set("v.newColorList",result);
            }
            else{
                var msg='Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error",msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },
    getVehicleInfo: function (component, event, customerVehicle) {
        component.set("v.IsSpinner", true);
        var wrp = component.get("v.wrapperObj");
        var selectedType;
        if(wrp.customerVehicle.Chassis_No__c!=null && wrp.customerVehicle.Chassis_No__c!='' && wrp.customerVehicle.Chassis_No__c!=undefined)
			selectedType='Chassis No';
        else 
            selectedType='Plate Combination';
        var action = component.get("c.getVehicleDetailsFromAbuDhabi");
        action.setParams({
            wrapperObj: JSON.stringify(component.get("v.wrapperObj")),
            vehicle: customerVehicle,
            selectedType: selectedType,
            customerVehiclesFlag: true
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result info>> '+JSON.stringify(result));
                if (result !== null && result != undefined) {
                    if(result.customerVehicles != undefined && result.customerVehicles.length>0){
                        component.set("v.wrapperObj", result);
                        component.set('v.isShowVehicleDetails', true);
                    }else if(result.customerVehicle !=null && result.customerVehicle.Is_Verified__c)
                        component.set("v.wrapperObj.customerVehicle", result.customerVehicle);
                    else {
                        var msg = 'Unable to find the Vehicle/AbuDhabi Police Service is down at this Movement, Please enter a valid chassis or plate combination to re-check.';
                        component.set('v.isMessgeExist', true);
                        component.set('v.errorType', 'info');
                        component.set('v.errorMessage', msg);
                        component.set('v.isChassisExist', false);
                        component.set("v.IsSpinner", false);
                        return true;
                    }
                    component.set('v.isMessgeExist', false);
                    component.set('v.isChassisExist', true);
                    component.set("v.IsSpinner", false);
                    console.log('getVehicleInfo result>> '+JSON.stringify(component.get("v.wrapperObj")));
                } else {
                    var msg = 'Unable to find the Vehicle/AbuDhabi Police Service is down at this Movement, Please enter a valid chassis or plate combination to re-check.';
                    component.set('v.isMessgeExist', true);
                    component.set('v.errorType', 'info');
                    component.set('v.errorMessage', msg);
                    component.set('v.isChassisExist', false);
                }
            }
            component.set("v.IsSpinner", false);
        });
        $A.enqueueAction(action);
    },
    getLocation: function (component, event, helper) {
        var wrp = component.get("v.wrapperObj");
        var action = component.get("c.getAllLocations");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result>> ' + JSON.stringify(result));
                var locations=[];
                for(var i=0; i<result.length; i++){
                    if(result[i].name!='Sharjah Spea Inspection Centre')
                        locations.push(result[i]);
                }
                console.log('locations>> ' + JSON.stringify(locations));
                component.set("v.locationMap", locations);
                if(result.length ==1)
                	component.set('v.wrapperObj.booking.ET_Location__c',result[0].id);
                this.getPlateCombinations(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    getCetificateServices: function (component, event, helper) {
        var wrp = component.get("v.wrapperObj");
        component.set("v.IsSpinner", true);
        var action = component.get("c.getCertificatesforWalkin");
        var servicesMap = component.get('v.servicesMap');
        var servicepremise1 = component.get('v.Servicepremise');
        action.setParams({
            servicePremise: servicepremise1,
            bookedServicesMap : servicesMap,
            center : wrp.booking.ET_Location__c
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('service>> ' + JSON.stringify(result));
                component.set("v.certificateServices", result);
            } else {
                var msg = 'There is a problem getting Services.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Info", msg, "", "Sticky", "info");
            }
            component.set("v.IsSpinner", false);
        });
        $A.enqueueAction(action);
    },
    getAvailableServices: function (component, event, helper) {
        var wrap = component.get('v.wrapperObj');
        console.log('wrap...'+JSON.stringify(wrap));
        component.set("v.IsSpinner", true);
        var location= 'AbuDhabi';
        if(component.get("v.selectedLocation")=='Fujairah Inspection Center' || component.get("v.emirate")=='Fujairah')
            location= 'Fujairah';
        var action = component.get("c.getWalkInServices");
        var serviceType = component.get("v.wrapperObj.booking.Service_Type__c");
        action.setParams({
            serviceType: serviceType,
            placeStr: 'Visit ET Premises',
            isAdafca: component.get("v.isAdfcaVehicle"),
            location: location
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('service>> ' + JSON.stringify(result));
                component.set("v.servicesMap", result);
                if(wrap.booking.Service_Type__c == 'Police Inspection'){
                    if(wrap.customerVehicle.ET_Vehicle_type__c == 'Trailer')
                    	component.set('v.wrapperObj.booking.Selected_Services_Code__c','10');
                    else 
                    if(wrap.customerVehicle.ET_Vehicle_type__c == 'Equipment')
                 		component.set('v.wrapperObj.booking.Selected_Services_Code__c','5');
                    else
                    if(wrap.customerVehicle.ET_Vehicle_type__c == 'Vehicle')
                 		component.set('v.wrapperObj.booking.Selected_Services_Code__c','2');
                    console.log('wrapINN...'+JSON.stringify(wrap));
                    console.log('selectedService...'+component.get("v.selectedService"));
                    this.getLaneType(component, event, helper);
                    //component.find("servicesId").set("v.value", 'Trailer');
                }else if(wrap.booking.Service_Type__c == 'ADFCA'){
                	this.getPermissionIssueLocations(component, event, helper);
                }
            }
            else {
                var msg = 'There is a problem getting Services.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Info", msg, "", "Sticky", "info");
            }
            component.set("v.IsSpinner", false);
        });
        $A.enqueueAction(action);
    },
    getPermissionIssueLocations: function(component,event,helper){
        var action = component.get("c.getPermissionIssuePlaces");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var returning = [];
                var result = response.getReturnValue();
                console.log('resultIssuePlaces###   '+ JSON.stringify(result));
                component.set('v.permissionIssuePlaces',result);
                this.getPermitPurposelst(component, event, helper);
            }
            else{
                var msg='Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error",msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },  
    getPermitPurposelst: function(component,event,helper){
        var action = component.get("c.getPickListValues");
        action.setParams({
            selectedObject: "ET_Customer_Vehicle__c",
            selectedField: "Permit_Purpose__c"
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('permitPurposeList###   '+ JSON.stringify(result));
                component.set('v.wrapperObj.PermitPurposeList',result);
            }
            else{
                var msg='Unexpected error occurred while processing your request, Please try again or contact our customer service team.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error",msg,"","dismissible","error");
            }
        });
        $A.enqueueAction(action);
    },  
    fieldValidations: function (component, event, isSaveRequest) {
        console.log('fieldValidations');
        var sectionidblock = component.find("sectionidblock").getElement();
        var wrp = component.get("v.wrapperObj");
        console.log('wrp... '+JSON.stringify(wrp));
        console.log('isSaveRequest>> '+ isSaveRequest);
        component.set("v.IsSpinner", true);
        var isValueMissing = false;
        if (wrp.customerVehicle.Registration_Type__c == 'Un-Registered') {
            if (isSaveRequest && (component.find('vehicleYear').get('v.value') == '' || component.find('vehicleYear').get('v.value') == null || component.find('vehicleYear').get('v.value') == undefined)) {
                component.find('vehicleYear').setCustomValidity("This field is required");
                component.find('vehicleYear').reportValidity();
                isValueMissing = true;
        	}else{
                var modelYear = wrp.customerVehicle.Vehicle_Year__c;
                if(!this.isNumber(modelYear)){
                    component.find('vehicleYear').setCustomValidity("Year should be in numbers");
                    component.find('vehicleYear').reportValidity();
                    isValueMissing = true;
                }
                console.log('isValueMissing2222>> ' + isValueMissing);
                if(this.isNumber(modelYear)){
                    var d = new Date();
                    var today = d.getFullYear() + 1;
                    if(modelYear > today || modelYear.length != 4){
                        component.find('vehicleYear').setCustomValidity("Year can be only 4 digits and not future value.");
                        component.find('vehicleYear').reportValidity();
                        isValueMissing = true;
                    }else{
                        component.find('vehicleYear').setCustomValidity("");
                        component.find('vehicleYear').reportValidity();
                    }
                }
            }
            if (isSaveRequest && wrp.customerVehicle.Vehicle_Type__c == '') {
                component.set('v.errorVechileType', true);
                isValueMissing = true;
            }
        }
        if (isSaveRequest && (component.find('customerPhone').get('v.value') == '' || component.find('customerPhone').get('v.value') == null || component.find('customerPhone').get('v.value') == undefined)) {
            component.find('customerPhone').setCustomValidity("This field is required");
            component.find('customerPhone').reportValidity();
            isValueMissing = true;
        }else {
            var mobile = wrp.booking.Mobile_No__c;
            var numbers = /^[0-9]+$/;
            if (!mobile.match(numbers)) {
                component.find('customerPhone').setCustomValidity("Mobile Number should numeric characters only.");
            	component.find('customerPhone').reportValidity()
                isValueMissing = true;
        	}else if (mobile.length != 12) {
                component.find('customerPhone').setCustomValidity("Mobile Number should be 12 numbers.");
            	component.find('customerPhone').reportValidity()
                isValueMissing = true;
        	}else if(mobile.substring(0, 3) !='971'){
                var msg='Mobile Number should start with 971.';
                component.find('customerPhone').setCustomValidity("Mobile Number should start with 971.");
            	component.find('customerPhone').reportValidity()
                isValueMissing = true;
            } 
        }
        if (isSaveRequest && wrp.booking.Service_Type__c=='Certificate' && (wrp.booking.Selected_Services_Code__c == undefined || wrp.booking.Selected_Services_Code__c == null || wrp.booking.Selected_Services_Code__c == '')) {
            component.set('v.errorCertificateServices', true);
            var msg = 'Please Select Service to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Error!", msg, "", "dismissible", "error");
            isValueMissing = true;
        }else {
            component.set('v.errorCertificateServices', false);
        }
        console.log('isValueMissing55>> ' + isValueMissing);
        if (isSaveRequest && component.get('v.isAdfcaVehicle')){
            if(component.find('tradeLicenseNumber').get('v.value') == undefined || component.find('tradeLicenseNumber').get('v.value') == null || component.find('tradeLicenseNumber').get('v.value') == '') {
                component.find('tradeLicenseNumber').setCustomValidity("This field is required");
                component.find('tradeLicenseNumber').reportValidity();
                isValueMissing = true;
            }
            if(component.find('tradeLicenseDate').get('v.value') == undefined || component.find('tradeLicenseDate').get('v.value') == null || component.find('tradeLicenseDate').get('v.value') == '') {
                component.find('tradeLicenseDate').setCustomValidity("This field is required");
                component.find('tradeLicenseDate').reportValidity();
                isValueMissing = true;
            }else if (component.find('tradeLicenseDate').get('v.value') < component.get("v.tradeMinDate")){
                component.find('tradeLicenseDate').setCustomValidity("Trade Liciense Date should be future.");
                component.find('tradeLicenseDate').reportValidity();
                isValueMissing = true;
            }
        }
        console.log('isValueMissing>> ' + isValueMissing);
        if (isValueMissing) {
            component.set("v.IsSpinner", false);
            component.set('v.isMessgeExist', true);
            component.set('v.errorType', 'error');
            component.set('v.errorMessage', 'Please fill the all required fields.');
            sectionidblock.scrollTop = 0;
            return false;
        } else {
            component.set("v.IsSpinner", false);
            if(wrp.totalAmount==null || wrp.totalAmount==undefined){
                var msg = 'Please get Fee details to proceed.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error!", msg, "", "dismissible", "error");
                return false;
            }else {
                component.set('v.isMessgeExist', false);
                if (wrp.customerVehicle.Registration_Type__c === 'Registered') {
                    if (wrp.customerVehicle.Is_Verified__c)
                        this.saveServiceRequest(component, event, isSaveRequest);
                    else {
                        component.set('v.isMessgeExist', true);
                        component.set('v.errorType', 'warning');
                        component.set('v.errorMessage', 'This Vechile is not Validated with AbuDhabi Police System, Please Validate to proceed.');
                        sectionidblock.scrollTop = 0;
                        return false;
                    }
                } else if (wrp.customerVehicle.Registration_Type__c === 'Un-Registered') {
                    this.saveServiceRequest(component, event, isSaveRequest);
                }
            }
        }
    },
    saveServiceRequest: function (component, event, isSaveRequest) {
        var sectionidblock = component.find("sectionidblock").getElement();
        console.log('isSaveRequest>> ' + isSaveRequest);
        component.set("v.wrapperObj.isErrorExit",false);
        var wrp=component.get("v.wrapperObj");
        if(wrp.booking.Booking_Date__c != '' && wrp.booking.Booking_Date__c != null 
            && wrp.booking.Booking_Date__c != undefined && wrp.booking.Booking_Date__c >= component.get("v.minDate")){
            if (isSaveRequest) {
                component.set("v.IsSpinner", true);
                var action = component.get("c.saveWalkinServiceRequest");
                action.setParams({
                    obj: JSON.stringify(wrp)
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    console.log('state>> ' + state);
                    if (state === "SUCCESS") {
                        var result = response.getReturnValue();
                        console.log('vehicle...' + JSON.stringify(result));
                        console.log('Id...' + JSON.stringify(result.booking.Service_Request__c));
                        if (result != null) {
                            component.set('v.wrapperObj', result);
                            if (result.isErrorExit){
                                component.set('v.isMessgeExist', true);
                                component.set('v.errorType', 'error');
                                component.set('v.errorMessage', result.errorMessage);
                                sectionidblock.scrollTop = 0;
                            }else {
                                var msg = 'The Request has been Created successfully.';
                                var utility = component.find("ETI_UtilityMethods");
                                var promise = utility.showToast("Success!", msg, "", "dismissible", "success");
                                component.set('v.isMessgeExist', false);
                                component.set('v.isBookingCreated', true);
                                component.set('v.recordId', result.booking.Service_Request__c);
                                component.set('v.isOnPremisePayment', true);
                            }
                        } else {
                            component.set('v.isMessgeExist', true);
                            component.set('v.errorType', 'error');
                            component.set('v.errorMessage', 'Something went wrong, please try after sometime or contact system admin.');
                        }
                    }else {
                        var msg = 'Something went wrong, please try again or contact system admin.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast("Error!", msg, "", "Sticky", "error");
                    }
                    component.set("v.IsSpinner", false);
                });
                $A.enqueueAction(action);
            }
        }else {
            var msg = 'Booking Date should be today or later.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Error!", msg, "", "Sticky", "error");
        }
    },
    getBookings: function (component, event) {
        console.log('vehicleId>> ' + JSON.stringify(component.get("v.wrapperObj.customerVehicle.Id")));
        var utility = component.find("ETI_UtilityMethods");
        var backendMethod = "getBookingHistory";
        var params = {
            "isWalkIn": true,
            "vehicleId": component.get("v.wrapperObj.customerVehicle.Id"),
            "stDate": component.get("v.startDate"),
            "enDate": component.get("v.endDate")
        };
        var promise = utility.executeServerCall(component, backendMethod, params);
        promise.then(
            $A.getCallback(function (response) {
                console.log('response>> ' + JSON.stringify(response));
                component.set('v.bookingHistory', response);
            })
        )
    },
    enableClearButton: function (component, event, helper) {
        var wrp = component.get("v.wrapperObj");
        var Chassis_No = wrp.customerVehicle.Chassis_No__c != '' && wrp.customerVehicle.Chassis_No__c != null && wrp.customerVehicle.Chassis_No__c != undefined;
        var Plate_Color = wrp.customerVehicle.Plate_Color__c != '' && wrp.customerVehicle.Plate_Color__c != null && wrp.customerVehicle.Plate_Color__c != undefined;
        var Plate_Source = wrp.customerVehicle.Plate_Source__c != '' && wrp.customerVehicle.Plate_Source__c != null && wrp.customerVehicle.Plate_Source__c != undefined;
        var Plate_Type = wrp.customerVehicle.Plate_Type__c != '' && wrp.customerVehicle.Plate_Type__c != null && wrp.customerVehicle.Plate_Type__c != undefined;
        var Vehicle_Make = wrp.customerVehicle.Vehicle_Make__c != '' && wrp.customerVehicle.Vehicle_Make__c != null && wrp.customerVehicle.Vehicle_Make__c != undefined;
        var Vehicle_Model = wrp.customerVehicle.Vehicle_Model__c != '' && wrp.customerVehicle.Vehicle_Model__c != null && wrp.customerVehicle.Vehicle_Model__c != undefined;
        var Vehicle_Year = wrp.customerVehicle.Vehicle_Year__c != '' && wrp.customerVehicle.Vehicle_Year__c != null && wrp.customerVehicle.Vehicle_Year__c != undefined;
        //var Vehicle_Type = wrp.customerVehicle.Vehicle_Type__c != '' && wrp.customerVehicle.Vehicle_Type__c != null && wrp.customerVehicle.Vehicle_Type__c != undefined;
        var Registration_Expiry_Date = wrp.customerVehicle.Registration_Expiry_Date__c != '' && wrp.customerVehicle.Registration_Expiry_Date__c != null && wrp.customerVehicle.Registration_Expiry_Date__c != undefined;
        var Engine_No = wrp.customerVehicle.Engine_No__c != '' && wrp.customerVehicle.Engine_No__c != null && wrp.customerVehicle.Engine_No__c != undefined;
        var Custom_Number = wrp.customerVehicle.Custom_Number__c != '' && wrp.customerVehicle.Custom_Number__c != null && wrp.customerVehicle.Custom_Number__c != undefined;
        var Plate_No = wrp.customerVehicle.Plate_No__c != '' && wrp.customerVehicle.Plate_No__c != null && wrp.customerVehicle.Plate_No__c != undefined;
        var Customer_Name = wrp.customerVehicle.Customer_Name__c != '' && wrp.customerVehicle.Customer_Name__c != null && wrp.customerVehicle.Customer_Name__c != undefined;
        var Customer_Phone = wrp.customerVehicle.Customer_Phone__c != '' && wrp.customerVehicle.Customer_Phone__c != null && wrp.customerVehicle.Customer_Phone__c != undefined;
        var Customer_Email = wrp.customerVehicle.Customer_Email__c != '' && wrp.customerVehicle.Customer_Email__c != null && wrp.customerVehicle.Customer_Email__c != undefined;
        // Booking Object
        var Service_Type = wrp.booking.Service_Type__c != '' && wrp.booking.Service_Type__c != null && wrp.booking.Service_Type__c != undefined;
        var Purpose_Type = wrp.booking.Purpose_Type__c != '' && wrp.booking.Purpose_Type__c != null && wrp.booking.Purpose_Type__c != undefined;
        var Selected_Services = wrp.booking.Selected_Services_Code__c != '' && wrp.booking.Selected_Services_Code__c != null && wrp.booking.Selected_Services_Code__c != undefined;
        var ET_Location = wrp.booking.ET_Location__c != '' && wrp.booking.ET_Location__c != null && wrp.booking.ET_Location__c != undefined;
        var Booking_Date = wrp.booking.Booking_Date__c != '' && wrp.booking.Booking_Date__c != null && wrp.booking.Booking_Date__c != undefined;
        var Trade_License_Number = wrp.customerVehicle.Trade_License_Number__c != '' && wrp.customerVehicle.Trade_License_Number__c != null && wrp.customerVehicle.Trade_License_Number__c != undefined;
        var KM_Reading = wrp.booking.KM_Reading__c != '' && wrp.booking.KM_Reading__c != null && wrp.booking.KM_Reading__c != undefined;
        var newColor = wrp.newColor != '' && wrp.newColor != null && wrp.newColor != undefined;
        var newVehicleType = wrp.newVehicleType != '' && wrp.newVehicleType != null && wrp.newVehicleType != undefined;
        var Allocated_Lane = wrp.booking.Allocated_Lane__c != '' && wrp.booking.Allocated_Lane__c != null && wrp.booking.Allocated_Lane__c != undefined;
        if (Chassis_No || Plate_No || Plate_Color || Plate_Source || Plate_Type || Vehicle_Make || Vehicle_Model || Vehicle_Year || Registration_Expiry_Date || Custom_Number || Engine_No || Service_Type || Purpose_Type || Selected_Services || ET_Location || Booking_Date || Trade_License_Number || KM_Reading || newColor || newVehicleType || Customer_Email || Customer_Phone || Customer_Name || Allocated_Lane){
            component.set('v.isClearEnabled', true);
        } else {
            component.set('v.isClearEnabled', false);
        }
    },
    
    cleardata: function (component, event, helper, wrp, isClearAll) {
        if(isClearAll)
        	wrp.customerVehicle.Chassis_No__c = '';
        wrp.customerVehicle.Plate_Color__c = '';
        wrp.customerVehicle.Plate_Source__c = '';
        wrp.customerVehicle.Plate_Type__c = '';
        wrp.customerVehicle.Vehicle_Make__c = '';
        wrp.customerVehicle.Vehicle_Model__c = '';
        wrp.customerVehicle.Engine_No__c = '';
        wrp.customerVehicle.Vehicle_Year__c = '';
        wrp.customerVehicle.Vehicle_Type__c = '';
        wrp.customerVehicle.Registration_Expiry_Date__c = null;
        wrp.customerVehicle.Custom_Number__c = '';
        wrp.customerVehicle.Plate_No__c = '';
        wrp.customerVehicle.Customer_Email__c = '';
        wrp.customerVehicle.Customer_Phone__c = '';
        wrp.customerVehicle.Customer_Name__c = '';
        wrp.customerVehicle.ET_Vehicle_type__c = '';
        // Booking Object
        wrp.booking.Service_Type__c = '';
        wrp.booking.Purpose_Type__c = '';
        wrp.booking.Selected_Services_Code__c = '';
        wrp.booking.Allocated_Lane__c='';
        //wrp.booking.ET_Location__c = '';
        //wrp.booking.Booking_Date__c = '';
        wrp.customerVehicle.Trade_License_Number__c = '';
        wrp.customerVehicle.Trade_License_Expiry_Date__c = null;
        wrp.booking.KM_Reading__c = '';
        wrp.newColor = '';
        wrp.newVehicleType = '';
        component.set("v.wrapperObj", wrp);
        component.set('v.isClearEnabled', false);
        if(wrp.customerVehicle.Registration_Type__c=='Registered' && wrp.customerVehicle.Chassis_No__c != null && wrp.customerVehicle.Chassis_No__c != '')
        	component.set('v.isVerifyEnabled', true);
        else 
            component.set('v.isVerifyEnabled', false);
        component.set('v.isChassisExist', false);
    },
    validateFieldvalue: function (component, event, helper, elementId) {
       var wrp = component.get("v.wrapperObj");
       try {
           console.log(wrp)
        switch (elementId) {
            case 'plateNo':
                if (wrp.customerVehicle.Plate_No__c != '' && wrp.customerVehicle.Plate_No__c != null && wrp.customerVehicle.Plate_No__c != undefined) {
                    component.find('plateNo').setCustomValidity("");
                    component.find('plateNo').reportValidity();
                    /*
                    
                   */
                } else {

                }
                break;
            case 'plateColor':
                if (wrp.customerVehicle.Plate_Color__c != '' && wrp.customerVehicle.Plate_Color__c != null && wrp.customerVehicle.Plate_Color__c != undefined) {
                   component.set('v.errorPlateColor', false);
                } else {
                    // component.set('v.errorPlateColor', true);
                }
                break;
            case 'plateType':
                if (wrp.customerVehicle.Plate_Type__c != '' && wrp.customerVehicle.Plate_Type__c != null && wrp.customerVehicle.Plate_Type__c != undefined) {
                    component.set('v.errorPlateType', false);
                } else {
                    // component.set('v.errorPlateType', true);
                }
                break;
            case 'plateSource':
                if (wrp.customerVehicle.Plate_Source__c != '' && wrp.customerVehicle.Plate_Source__c != null && wrp.customerVehicle.Plate_Source__c != undefined) {
                    component.set('v.errorPlateSource', false);
                } else {
                    // component.set('v.errorPlateSource', true);
                }
                break;
            case 'VehicleServiceType':
                if (wrp.customerVehicle.ET_Vehicle_type__c != '' && wrp.customerVehicle.ET_Vehicle_type__c != null && wrp.customerVehicle.ET_Vehicle_type__c != undefined) {
                    component.set('v.errorETIServiceType', false);
                } else {
                    component.set('v.errorETIServiceType', true);
                }
                break;
            default:
                break;
        }
       } catch (error) {
           alert(error.message);
       }
    },
    isNumber:function(str) {
        var pattern = /^\d+$/;
        return pattern.test(str);  // returns a boolean
    },
})