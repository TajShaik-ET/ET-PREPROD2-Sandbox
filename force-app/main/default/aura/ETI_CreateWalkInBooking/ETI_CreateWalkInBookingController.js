({
	doinit : function(component, event, helper) {
        helper.doinit1(component, event, helper, true);
	},
    doSearch: function(component, event, helper) {
		var searchKeyword= component.get('v.searchKeyword');
        console.log('searchKeyword>> '+searchKeyword);
        component.set("v.IsSpinner", true);
        if(searchKeyword==undefined || searchKeyword=='' || searchKeyword==null){
            component.set('v.isMessgeExist',true);
            component.set('v.errorType','warning');
            component.set('v.errorMessage','Please enter a Chassis No or Plate No.');
            component.set("v.IsSpinner", false);
        }else{
            var action = component.get("c.getSearchedVehicleDetails");
            action.setParams({
                wrapperObj: JSON.stringify(component.get("v.wrapperObj")),
                searchStr: searchKeyword
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state>> '+state);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('vehicle...'+JSON.stringify(result));
                    if(result!=null && result != undefined){
                        //component.set('v.wrapperObj.customerVehicle',result.customerVehicle);
                        component.set("v.wrapperObj", result);
                        if(result.customerVehicles != undefined && result.customerVehicles.length>0)
                        	component.set('v.isShowVehicleDetails', true);
                        component.set('v.isSearchedVehicles',true);
                        component.set('v.isMessgeExist',false);
                        component.set('v.isChassisExist',true);
                        component.set('v.errorReg',false);
                        console.log('customerVehicle...'+JSON.stringify(component.get("v.wrapperObj")));
                        helper.getBookings(component, event, false);
                    }else {
                        helper.doinit1(component, event, helper, false);
                        component.set('v.isMessgeExist',true);
                        component.set('v.isChassisExist',false);
                        component.set('v.errorType','info');
                        component.set('v.errorMessage','There is no Vehicle found with searched details in system, please create a new vehicle.')
                        component.set('v.wrapperObj.customerVehicle.Registration_Type__c','');
                    }
                    console.log('customerVehicle>> '+JSON.stringify(component.get('v.wrapperObj.customerVehicle')));
                }
             });
             $A.enqueueAction(action);
            component.set("v.IsSpinner", false);
        }
	},
    regTypeChange: function(component, event, helper){
        component.set('v.isMessgeExist',false);
        component.set('v.errorMessage','')
        component.set('v.isFullPaint',false);
        component.set('v.isColorChange',false);
        component.set('v.isVehicleTypeChange',false);
        component.set('v.isAdfcaVehicle',false);
        var wrp1 = component.get("v.wrapperObj");
		component.set('v.wrapperObj.booking.Selected_Services_Code__c','');
        helper.cleardata(component, event, helper, wrp1, false);
        var wrp = wrp1.customerVehicle;
        if(wrp.Registration_Type__c =='' || wrp.Registration_Type__c == null || wrp.Registration_Type__c == undefined){
            component.set('v.errorReg', true);
            component.set('v.isClearEnabled', false);
        }else{
            component.set('v.errorReg', false);
            component.set('v.isClearEnabled', true);
        }
    },
    getVerifiedData: function(component, event, helper){
        var wrp = component.get("v.wrapperObj");
        if (wrp.customerVehicle.Registration_Type__c === 'Registered'){
            component.set('v.isRegistrationDisabled',  true);
            if(wrp.customerVehicle.Chassis_No__c!=null && wrp.customerVehicle.Chassis_No__c != ''){ 
                helper.getVehicleInfo(component, event, wrp.customerVehicle);
            }else{
                wrp.customerVehicle.Chassis_No__c='';
                wrp.customerVehicle.Vehicle_Make__c='';
                wrp.customerVehicle.Vehicle_Model__c='';
                wrp.customerVehicle.Vehicle_Year__c='';
                wrp.customerVehicle.Engine_No__c='';
                wrp.customerVehicle.Registration_Expiry_Date__c=null;
                wrp.customerVehicle.Custom_Number__c='';
                helper.getVehicleInfo(component, event, wrp.customerVehicle);
            }
        } else if (wrp.customerVehicle.Registration_Type__c === 'Un-Registered') {
            if (wrp.customerVehicle.Custom_Number__c != null && wrp.customerVehicle.Custom_Number__c != '' && wrp.customerVehicle.Custom_Number__c != undefined) {
                helper.getVehicleInfo(component, event, wrp.customerVehicle);
                component.set('v.isRegistrationDisabled',  true);
            } else { 
                component.find('customNo').setCustomValidity("This field is required");
                component.find('customNo').reportValidity();
            }            
        }
        component.set('v.wrapperObj', wrp);
    },
    getVerifiedDataByChassis: function(component, event, helper){
        var wrp = component.get("v.wrapperObj.customerVehicle");
        console.log('wrp>> '+wrp);
        wrp.Vehicle_Make__c='';
        wrp.Vehicle_Model__c='';
        wrp.Vehicle_Year__c='';
        wrp.Engine_No__c='';
        wrp.Registration_Expiry_Date__c=null;
        wrp.Custom_Number__c='';
        helper.enableClearButton(component, event, helper);
        if(wrp.Registration_Type__c =='' || wrp.Registration_Type__c == null){
            component.set('v.isMessgeExist',true);
            component.set('v.errorType','warning');
            component.set('v.errorMessage','Please Select Registered Type.');
            component.set('v.errorReg',true);
        }else if (wrp.Registration_Type__c === 'Registered'){
            if(wrp.Chassis_No__c!=null && wrp.Chassis_No__c != ''){ 
                component.set('v.isVerifyEnabled',true);
                component.set('v.isClearEnabled',true);
        		component.set('v.isMessgeExist',false);
                component.set('v.errorReg',false);
            }else {
                component.set('v.isVerifyEnabled',false);
                component.set('v.isClearEnabled',false);
            }
        }else{
            if(wrp.Chassis_No__c!=null && wrp.Chassis_No__c != ''){ 
                component.set('v.isVerifyEnabled',true);
                component.set('v.isClearEnabled',true);
            }else {
                component.set('v.isVerifyEnabled',false);
                component.set('v.isClearEnabled',false);
            }
        }
    },
    handleOnCustomerNameChange: function(component, event, helper){
        var wrp = component.get("v.wrapperObj.customerVehicle");
        var a = event.getSource();
        var id = a.getLocalId();
        helper.enableClearButton(component, event, helper);
        helper.validateFieldvalue(component, event, helper, id);
    },
    handleOnPlatCombinationChange: function(component, event, helper){
        var wrp = component.get("v.wrapperObj.customerVehicle");
        var a = event.getSource();
        var id = a.getLocalId();
        if (wrp.Registration_Type__c === 'Registered'){
            var isValidPlatNo = wrp.Plate_No__c !='' && wrp.Plate_No__c != undefined && wrp.Plate_No__c != null;
            var isvalidPlatColor = wrp.Plate_Color__c != '' && wrp.Plate_Color__c != null && wrp.Plate_Color__c != undefined;
            var isValidPlatSource = wrp.Plate_Source__c !='' && wrp.Plate_Source__c != null && wrp.Plate_Source__c != undefined;
            var isValidplattype = wrp.Plate_Type__c !='' && wrp.Plate_Type__c != null && wrp.Plate_Type__c != undefined;
            if(isValidPlatNo && isvalidPlatColor && isValidPlatSource && isValidplattype){
                component.set('v.isVerifyEnabled',true);
            }else{
                component.set('v.isVerifyEnabled',false);
            }

            if(isValidPlatNo || isvalidPlatColor || isValidPlatSource || isValidplattype){
                component.set('v.isClearEnabled',true);
            }else{
                component.set('v.isClearEnabled',false);
            }
        }
        helper.enableClearButton(component, event, helper);
        helper.validateFieldvalue(component, event, helper, id);
    },
    getVerifiedDataByPlate: function(component, event, helper){
        var wrp = component.get("v.wrapperObj.customerVehicle");
        console.log('wrp>> '+wrp);
        wrp.Chassis_No__c='';
        wrp.Vehicle_Make__c='';
        wrp.Vehicle_Model__c='';
        wrp.Vehicle_Year__c='';
        wrp.Engine_No__c='';
        wrp.Registration_Expiry_Date__c=null;
        wrp.Custom_Number__c='';
        if(wrp.Registration_Type__c =='' || wrp.Registration_Type__c == null){
            component.set('v.isMessgeExist',true);
            component.set('v.errorType','warning');
            component.set('v.errorMessage','Please Select Registered Type.');
            component.set('v.errorReg',true);
        }else if (wrp.Registration_Type__c === 'Registered' ){
            if(wrp.Plate_No__c !=null && wrp.Plate_No__c !='' && wrp.Plate_Color__c !='' && wrp.Plate_Color__c != null
              && wrp.Plate_Source__c !='' && wrp.Plate_Source__c != null && wrp.Plate_Type__c !='' && wrp.Plate_Type__c != null){ 
                component.set('v.isMessgeExist',false);
                component.set('v.errorReg',false);
                helper.getVehicleInfo(component, event, wrp);
            }else {
                component.set('v.isMessgeExist',true);
                component.set('v.errorType','warning');
                component.set('v.errorMessage','Please enter a valid Plate combination.');
            }
        } 
    },
    onChassisChange: function(component, event, helper){
        var wrp = component.get("v.wrapperObj.customerVehicle");
        console.log('wrp>> '+wrp);
        if (wrp.Registration_Type__c === 'Registered' && (wrp.Chassis_No__c!=null || wrp.Plate_No__c !=null)){ 
        	component.set('v.isMessgeExist',false);
            helper.getVehicleInfo(component, event, helper);
        }else {
            component.set('v.isMessgeExist',true);
            component.set('v.errorType','warning');
            component.set('v.errorMessage','Please enter a Chassis No or Plate No.');
        }
        wrp.customerVehicle.Chassis_No__c='';
        wrp.customerVehicle.Plate_Color__c='';
        wrp.customerVehicle.Plate_Source__c='';
        wrp.customerVehicle.Plate_Type__c='';
        wrp.customerVehicle.Vehicle_Make__c='';
        wrp.customerVehicle.Vehicle_Model__c='';
        wrp.customerVehicle.Vehicle_Year__c='';
        wrp.customerVehicle.Engine_No__c = '';
        wrp.customerVehicle.Registration_Expiry_Date__c=null;
        wrp.customerVehicle.Custom_Number__c='';
		component.set("v.wrapperObj",wrp);
    },
    clearVerifiedData: function(component, event, helper){
        $A.get('e.force:refreshView').fire();
    },
    locationChange: function(component, event, helper){
        var wrp = component.get("v.wrapperObj");
        console.log('wrapperObj...'+JSON.stringify(wrp));
        var locationMap = component.get("v.locationMap");
        component.set('v.wrapperObj.booking.Selected_Services_Code__c','');
        console.log('Location...'+wrp.booking.ET_Location__c);
        console.log('locationMap...'+JSON.stringify(locationMap));
        if(wrp.booking.ET_Location__c!='' && wrp.booking.ET_Location__c!=null){
            console.log('locationMap lenth...'+locationMap.length);
            for(var i=0; i<locationMap.length; i++){
                if(locationMap[i].id==wrp.booking.ET_Location__c){
                    console.log('Location.INN..'+locationMap[i].name);
                    component.set("v.selectedLocation",locationMap[i].name);
                    if(locationMap[i].name=='Fujairah Inspection Center')
                    	component.set("v.emirate",'Fujairah');
                    else
						component.set("v.emirate",'Abu Dhabi');                        
                }
            }
        }
        if(wrp.booking.Service_Type__c!='' && wrp.booking.Service_Type__c!=null){
            var serviceType = component.get("v.wrapperObj.booking.Service_Type__c");
                helper.enableClearButton(component, event, helper);
                component.set('v.wrapperObj.booking.Selected_Services_Code__c','');
                component.set('v.wrapperObj.booking.Allocated_Lane__c','');
                component.set('v.isAdfcaVehicle',false);
                component.set('v.isVehicleTypeChange',false);
                component.set('v.isFullPaint',false);
                component.set('v.isColorChange',false);
                console.log('serviceType>> '+serviceType);
                component.set("v.certificateServices", []);
                component.set("v.servicesMap", []);
                component.set("v.laneTypes", []);
                if(serviceType=='Certificate'){
                    helper.getCetificateServices(component, event, helper);
                }else if(serviceType=='Police Inspection' || serviceType=='ADFCA'){
                    if(serviceType=='ADFCA'){
                        component.set("v.isAdfcaVehicle",true);
                        component.set("v.wrapperObj.isAdfcaVehicle",true);
                    }
                    helper.getAvailableServices(component, event, helper);
                }
                component.set('v.wrapperObj.verifiedTradeLicenseNo','');
                component.set('v.wrapperObj.customerVehicle.Trade_License_Number__c','');
                component.set('v.wrapperObj.customerVehicle.Trade_License_Expiry_Date__c',null);
                component.set('v.wrapperObj.totalFee',null);
                component.set('v.wrapperObj.totalTax',null);
                component.set('v.wrapperObj.totalAmount',null);
                component.set("v.isSaveEnabled", true);
        }
    },
    serviceTypeChange: function(component, event, helper){
        var wrp = component.get("v.wrapperObj");
        console.log('wrapperObj...'+JSON.stringify(wrp));
        if ((wrp.customerVehicle.Chassis_No__c != '' && wrp.customerVehicle.Chassis_No__c != null) 
            || (wrp.customerVehicle.Plate_No__c != '' && wrp.customerVehicle.Plate_No__c !=null)){ 
            if(wrp.customerVehicle.ET_Vehicle_type__c == '' || wrp.customerVehicle.ET_Vehicle_type__c == null){
                component.set('v.wrapperObj.booking.Service_Type__c','');
                component.set('v.wrapperObj.booking.Selected_Services_Code__c','');
                component.set('v.wrapperObj.booking.Purpose_Type__c','');
                component.set('v.wrapperObj.booking.Allocated_Lane__c','');
                var msg = 'Please Select Vehicle Service Type to proceed.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Info!", msg, "", "Sticky", "error");
            }else if(wrp.booking.ET_Location__c == '' || wrp.booking.ET_Location__c == null){
                component.set('v.wrapperObj.booking.Service_Type__c','');
                component.set('v.wrapperObj.booking.Selected_Services_Code__c','');
                //component.set('v.wrapperObj.booking.Purpose_Type__c','');
                component.set('v.wrapperObj.booking.Allocated_Lane__c','');
                var msg = 'Please Select Location to proceed.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Info!", msg, "", "Sticky", "error");
            }else{
                var serviceType = component.get("v.wrapperObj.booking.Service_Type__c");
                helper.enableClearButton(component, event, helper);
                component.set('v.wrapperObj.booking.Selected_Services_Code__c','');
                component.set('v.wrapperObj.booking.Allocated_Lane__c','');
                component.set('v.isAdfcaVehicle',false);
                component.set('v.isVehicleTypeChange',false);
                component.set('v.isFullPaint',false);
                component.set('v.isColorChange',false);
                console.log('serviceType>> '+serviceType);
                component.set("v.certificateServices", []);
                component.set("v.servicesMap", []);
                component.set("v.laneTypes", []);
                if(serviceType=='Certificate'){
                    helper.getCetificateServices(component, event, helper);
                }else if(serviceType=='Police Inspection' || serviceType=='ADFCA'){
                    if(serviceType=='ADFCA'){
                        component.set("v.isAdfcaVehicle",true);
                        component.set("v.wrapperObj.isAdfcaVehicle",true);
                    }
                    helper.getAvailableServices(component, event, helper);
                }
                component.set('v.wrapperObj.verifiedTradeLicenseNo','');
                component.set('v.wrapperObj.customerVehicle.Trade_License_Number__c','');
                component.set('v.wrapperObj.customerVehicle.Trade_License_Expiry_Date__c',null);
                component.set('v.wrapperObj.totalFee',null);
                component.set('v.wrapperObj.totalTax',null);
                component.set('v.wrapperObj.totalAmount',null);
                component.set("v.isSaveEnabled", true);
            }
        }else {
            component.set("v.isSaveEnabled", false);
            component.set('v.wrapperObj.booking.Service_Type__c','');
            var msg = 'Please Provide vehicle details to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Info!", msg, "", "Sticky", "info");
        }
    },
    validateModelYear: function(component, event, helper) {
        var wrp = component.get("v.wrapperObj");
        if (component.find('vehicleYear').get('v.value') == '' || component.find('vehicleYear').get('v.value') == null || component.find('vehicleYear').get('v.value') == undefined) {
            component.find('vehicleYear').setCustomValidity("This field is required");
            component.find('vehicleYear').reportValidity();
        }else{
            var modelYear = wrp.customerVehicle.Vehicle_Year__c;
            console.log('modelYear>> ' + modelYear);
            if(!helper.isNumber(modelYear)){
                component.find('vehicleYear').setCustomValidity("Year should be in numbers");
                component.find('vehicleYear').reportValidity();
            }else if(helper.isNumber(modelYear)){
                var d = new Date();
                var today = d.getFullYear() + 1;
                if(modelYear > today || modelYear.length != 4){
                    component.find('vehicleYear').setCustomValidity("Year can be only 4 digits and not future value.");
                    component.find('vehicleYear').reportValidity();
                }else{
                    component.find('vehicleYear').setCustomValidity("");
                    component.find('vehicleYear').reportValidity();
                }
            }
        }
    },
    onMobileChange: function(component, event, helper) {
        var wrp = component.get("v.wrapperObj");
        var mobile = wrp.booking.Mobile_No__c;
        var numbers = /^[0-9]+$/;
        if (!mobile.match(numbers)) {
            component.find('customerPhone').setCustomValidity("Mobile Number should numeric characters only.");
            component.find('customerPhone').reportValidity()
            return false;
        }else if (mobile.length != 12) {
            component.find('customerPhone').setCustomValidity("Mobile Number should be 12 numbers.");
            component.find('customerPhone').reportValidity()
            return false;
        }else if(mobile.substring(0, 3) !='971'){
            var msg='Mobile Number should start with 971.';
            component.find('customerPhone').setCustomValidity("Mobile Number should start with 971.");
            component.find('customerPhone').reportValidity()
            return false;
        }else {
            component.find('customerPhone').setCustomValidity("");
            component.find('customerPhone').reportValidity()
            return false;
        }
    },
    getLaneDetails: function(component, event, helper) {
        component.set('v.wrapperObj.totalFee',null);
        component.set('v.wrapperObj.totalTax',null);
        component.set('v.wrapperObj.totalAmount',null);
        component.set("v.laneTypes", []);
        component.set('v.wrapperObj.booking.Allocated_Lane__c','');
        if(component.get("v.wrapperObj.booking.Service_Type__c") == 'Police Inspection')
       	    helper.getLaneType(component, event, helper);
    },
    getFeeDetails: function(component, event, helper) {
        var sectionidblock = component.find("sectionidblock").getElement();
        var wrp = component.get("v.wrapperObj");
        console.log('Services>> '+wrp.booking.Selected_Services_Code__c);
        if(wrp.booking.Service_Type__c!=null && wrp.booking.Service_Type__c!='' 
           && wrp.booking.Purpose_Type__c!=null && wrp.booking.Purpose_Type__c!=''
           && wrp.booking.ET_Location__c!=null && wrp.booking.ET_Location__c!=''){
           component.set('v.errorPermissionIssuePlace', false);
           component.set('v.errorPermissionIssuePlaceMsg','');
           if(!component.get('v.isAdfcaVehicle') && wrp.booking.Selected_Services_Code__c==null && wrp.booking.Selected_Services_Code__c==''){
                var msg = 'Please select Service to proceed.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error!", msg, "", "Sticky", "error");
                return false;
           }else if(wrp.booking.Service_Type__c == 'Police Inspection' && (wrp.booking.Allocated_Lane__c==null || wrp.booking.Allocated_Lane__c=='' || wrp.booking.Allocated_Lane__c==undefined)){
                var msg = 'Please select Lane Type to proceed.';
                var utility = component.find("ETI_UtilityMethods");
                var promise = utility.showToast("Error!", msg, "", "Sticky", "error");
                return false;
           }else {
                component.set('v.wrapperObj.totalFee',null);
                component.set('v.wrapperObj.totalTax',null);
                component.set('v.wrapperObj.totalAmount',null);
                console.log(JSON.stringify(component.get("v.wrapperObj")))
                if(component.get('v.isAdfcaVehicle')){
                    if(component.find('tradeLicenseDate').get('v.value') == undefined || component.find('tradeLicenseDate').get('v.value') == null || component.find('tradeLicenseDate').get('v.value') == '') {
                        component.find('tradeLicenseDate').setCustomValidity("This field is required");
                        component.find('tradeLicenseDate').reportValidity();
                        return false;
                    }else if (component.find('tradeLicenseDate').get('v.value') < component.get("v.tradeMinDate")){
                        component.find('tradeLicenseDate').setCustomValidity("Trade Liciense Date should be future.");
                        component.find('tradeLicenseDate').reportValidity();
                        var msg = 'Trade Liciense Date should be future.';
                        var utility = component.find("ETI_UtilityMethods");
                        var promise = utility.showToast("Error!", msg, "", "dismissible", "error");
                        return false;
                    }
                } 
                component.set("v.IsSpinner", true);
                console.log('wrapperObj before'+JSON.stringify(component.get("v.wrapperObj")));
                var action = component.get("c.getWalkInFeeDetails");
                action.setParams({
                    obj: JSON.stringify(component.get("v.wrapperObj"))
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    console.log('state>> '+state);
                    if (state === "SUCCESS") {
                        var result = response.getReturnValue();
                        console.log('vehicle...'+JSON.stringify(result));
                        if(result!=null){
                            component.set('v.wrapperObj',result);
                            if (result.isErrorExit){
                                if(component.get('v.isAdfcaVehicle')){
                                    if(!result.isPermissionIssuePlaceMissing){
                                        component.find('tradeLicenseNumber').setCustomValidity(result.errorMessage);
                                        component.find('tradeLicenseNumber').reportValidity();
                                        component.set('v.wrapperObj.customerVehicle.Permission_Issue_Place__c','');
                                    }else {
                                        component.find('tradeLicenseNumber').setCustomValidity("");
                                        component.find('tradeLicenseNumber').reportValidity();
                                        component.set('v.errorPermissionIssuePlace', true);
                                        component.set('v.errorPermissionIssuePlaceMsg', result.errorMessage);
                                    }
                                }
                                component.set('v.isMessgeExist', true);
                                component.set('v.errorType', 'error');
                                component.set('v.errorMessage', result.errorMessage);
                                var msg = result.errorMessage;
                        		var utility = component.find("ETI_UtilityMethods");
                        		var promise = utility.showToast("Error!", msg, "", "dismissible", "error");
                                sectionidblock.scrollTop = 0;
                            }else {
                                if(component.get('v.isAdfcaVehicle')){
                                    component.find('tradeLicenseNumber').setCustomValidity("");
                                    component.find('tradeLicenseNumber').reportValidity();
                                }
                                component.set('v.isCertificatesChanged',false);
                            	component.set('v.isMessgeExist',false);
                                component.set('v.wrapperObj.customerVehicle.Permission_Issue_Place__c',result.customerVehicle.Permission_Issue_Place__c);
                            }
                        }
                    }
                    component.set("v.IsSpinner", false);
                });
                $A.enqueueAction(action);
            }
        }else {
            component.set('v.isMessgeExist', true);
            component.set('v.errorType', 'error');
            component.set('v.errorMessage', 'Please fill the all required fields.');
            return false;
        }
    },
	saveVehicleDetails: function(component, event, helper) {
        var sectionidblock = component.find("sectionidblock").getElement();
        //var validity = event.getSource().get("v.validity");
        //console.log('validity>> '+validity);
        console.log('entered');
        var wrp = component.get("v.wrapperObj");
        console.log('wrapperObj>> '+JSON.stringify(wrp));
        // var allValid = true;
        var allValid = component.find('fieldId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
       
        if(wrp.customerVehicle.Registration_Type__c=='Un-Registered'){
            var vehicleYear = component.find('vehicleYear');
            var value = vehicleYear.get('v.value');
            if(value == '' || value == null || value == undefined) {
                vehicleYear.set('v.validity', {valid:false, badInput :true});
                vehicleYear.showHelpMessageIfInvalid();
                allValid=false;
            }
            if (wrp.customerVehicle.Vehicle_Type__c == '') {
                component.set('v.errorVechileType', true);
                allValid=false;
            }
        }
        console.log('validity>>11');
        console.log('allValid>>11 '+allValid);

        var customerPhone = component.find('customerPhone');
        var value = customerPhone.get('v.value');
        if(value == '' || value == null || value == undefined) {
            customerPhone.set('v.validity', {valid:false, badInput :true});
            customerPhone.showHelpMessageIfInvalid();
            allValid=false;
        }
        console.log('validity>>22');
       console.log('allValid>>22 '+allValid);

        if(component.get('v.isAdfcaVehicle')){
            var tradeLicenseNumber = component.find('tradeLicenseNumber');
            var value = tradeLicenseNumber.get('v.value');
            if(value == '' || value == null || value == undefined) {
                tradeLicenseNumber.set('v.validity', {valid:false, badInput :true});
                tradeLicenseNumber.showHelpMessageIfInvalid();
                allValid=false;
            }
            var tradeLicenseDate = component.find('tradeLicenseDate');
            var value = tradeLicenseDate.get('v.value');
            var selectedDate = new Date(value);
            var now = new Date();
            if(value == '' || value == null || value == undefined) {
                tradeLicenseDate.set('v.validity', {valid:false, badInput :true});
                tradeLicenseDate.showHelpMessageIfInvalid();
                allValid=false;
            } else if (selectedDate < now) {
                tradeLicenseDate.set('v.validity', {valid:false, badInput :true});
                tradeLicenseDate.showHelpMessageIfInvalid();
                component.find('tradeLicenseDate').setCustomValidity("Trade Liciense Date should not be future.");
                component.find('tradeLicenseDate').reportValidity();
                allValid=false;
            }
            if(wrp.isPermissionIssuePlaceMissing && (wrp.customerVehicle.Permission_Issue_Place__c== undefined || wrp.customerVehicle.Permission_Issue_Place__c== null || wrp.customerVehicle.Permission_Issue_Place__c== '')){
                component.set('v.errorPermissionIssuePlace', true);
                component.set('v.errorPermissionIssuePlaceMsg', 'This field is required');
                allValid=false;
            }
        }
        console.log('allValid>> '+allValid);
        if (allValid) {
            //alert('All form entries look valid. Ready to submit!');
            helper.fieldValidations(component, event, true);
        } else {
            component.set('v.isMessgeExist', true);
            component.set('v.errorType', 'error');
            component.set('v.errorMessage', 'Please fill the all required fields.');
            sectionidblock.scrollTop = 0;
            //alert('Please update the invalid form entries and try again.');
        }
    },
    tradeLicenseValidation: function(component, event, helper) {
        if(component.find('tradeLicenseDate').get('v.value') < component.get("v.tradeMinDate")){
            component.find('tradeLicenseDate').setCustomValidity("Trade Liciense Date should be future.");
            component.find('tradeLicenseDate').reportValidity();
            return false;
        }else {
            component.find('tradeLicenseDate').setCustomValidity("");
            component.find('tradeLicenseDate').reportValidity();
        }
    },
    showRemarks: function(component, event, helper) {
        component.set("v.IsSpinner", true);
        component.set('v.isShowRemarks',true);
        var action = component.get("c.getRemarks");
        action.setParams({
            obj: JSON.stringify(component.get("v.wrapperObj"))
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state>>---- '+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result Remarks>> '+JSON.stringify(result));
                component.set("v.wrapperObj.serviceLineItems",result);
            }
            component.set("v.IsSpinner", false);
        });
        $A.enqueueAction(action);
    },
    closeRemarks: function(component, event, helper) {
        component.set('v.isShowRemarks',false);
    },
    showFeeDetails: function(component, event, helper) {
        component.set('v.isShowFeeDetails',true);
    },
    closeFeeDetails: function(component, event, helper) {
        component.set('v.isShowFeeDetails',false);
    },
    bookingDetails : function(component, event, helper) {
        console.log('id...'+event.getSource().get("v.title"));
        var navEvt;
        navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParam("recordId", a0a0C000001wGSw);
        navEvt.fire();
    },
    handleOnETIServiceType: function(component, event, helper){
        var wrp = component.get("v.wrapperObj");
        console.log('wrp>> '+JSON.stringify(wrp));
        console.log('sevice type>> '+ wrp.booking.Service_Type__c);
        component.set('v.wrapperObj.totalFee',null);
        component.set('v.wrapperObj.totalTax',null);
        component.set('v.wrapperObj.totalAmount',null);
        component.set("v.laneTypes", []);
        component.set('v.wrapperObj.booking.Allocated_Lane__c','');
        if(wrp.booking.Service_Type__c == 'Police Inspection'){
             console.log('sevice type11>> '+ wrp.booking.Service_Type__c);
             console.log('Vehicle_type '+ wrp.customerVehicle.ET_Vehicle_type__c);
             if(wrp.customerVehicle.ET_Vehicle_type__c == 'Trailer')
            	 component.set('v.wrapperObj.booking.Selected_Services_Code__c','10');
        	 else 
             if(wrp.customerVehicle.ET_Vehicle_type__c == 'Equipment')
                 component.set('v.wrapperObj.booking.Selected_Services_Code__c','5');
             else 
             if(wrp.customerVehicle.ET_Vehicle_type__c == 'Vehicle'){
                 component.set('v.wrapperObj.booking.Selected_Services_Code__c','2');
             }
             console.log('service '+ wrp.booking.Selected_Services_Code__c);
         }
        console.log('PurposeType '+ component.get('v.testPurposeType').length);
        var purposeType=component.get('v.testPurposeType');
        for (var i = 0; i < purposeType.length; i++){
             console.log('PurposeType '+ purposeType[i].name);
             if(wrp.customerVehicle.Registration_Type__c=='Un-Registered' && purposeType[i].name=='Registration ')
                 component.set('v.wrapperObj.booking.Purpose_Type__c',purposeType[i].id);
             if(wrp.customerVehicle.Registration_Type__c=='Registered' && purposeType[i].name=='Renewal ')
                 component.set('v.wrapperObj.booking.Purpose_Type__c',purposeType[i].id);
         }  
         if(component.get("v.wrapperObj.booking.Service_Type__c") == 'Police Inspection')
       	     helper.getLaneType(component, event, helper);
    },
    getSelectedVehicle: function(component, event, helper) {
        var customerVehicles=component.get("v.wrapperObj.customerVehicles");
        var vehicledId=event.getSource().get("v.value");
        for (var idx = 0; idx < customerVehicles.length; idx++) {
            if(customerVehicles[idx].vehicle.Id==vehicledId)
                customerVehicles[idx].isSelected=true;
            else 
                customerVehicles[idx].isSelected=false;
        }
        console.log('customerVehicles>> '+JSON.stringify(customerVehicles));
        component.set("v.wrapperObj.customerVehicles", customerVehicles);
    },
    proceedwithSelectedVehicle: function(component, event, helper) {
        var wrapperObj=component.get("v.wrapperObj");
        console.log('wrapperObj>> '+JSON.stringify(wrapperObj));
        var today = $A.localizationService.formatDateUTC(new Date(), "YYYY-MM-DD");
        var isSelected=false;
        for (var idx = 0; idx < wrapperObj.customerVehicles.length; idx++) {
            if(wrapperObj.customerVehicles[idx].isSelected){
                if(component.get("v.isSearchedVehicles"))
                    wrapperObj.customerVehicle=wrapperObj.customerVehicles[idx].vehicle;
                else 
                    wrapperObj.customerVehicle.Id=wrapperObj.customerVehicles[idx].vehicle.Id;
                if(wrapperObj.customerVehicles[idx].customerName!=undefined && wrapperObj.customerVehicles[idx].customerName!=null)
                	wrapperObj.customerVehicle.Customer_Name__c=wrapperObj.customerVehicles[idx].customerName;
                component.set('v.wrapperObj.booking',wrapperObj.booking);
                if(wrapperObj.customerVehicles[idx].customerPhone!=undefined && wrapperObj.customerVehicles[idx].customerPhone!=null)
                	component.set('v.wrapperObj.booking.Mobile_No__c',wrapperObj.customerVehicles[idx].customerPhone);
                isSelected=true;
                break;
            }else 
                isSelected=false;
        }
        console.log('isSelected>> '+isSelected);
        if(!isSelected){
            var msg = 'Please select a vehicle to proceed.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Error", msg, "", "Sticky", "error");
            return true;
        }
        console.log('wrapperObj111>> '+JSON.stringify(wrapperObj));
        component.set("v.wrapperObj", wrapperObj);
        component.set('v.isShowVehicleDetails',false);
    },
    closeShowVehicles: function(component, event, helper) {
        component.set('v.isShowVehicleDetails',false);
    },
    onPermitPurposeChange: function(component, event, helper) {
    	var wrapperObj=component.get("v.wrapperObj");
        console.log('wrapperObj>> '+JSON.stringify(wrapperObj));
    	for (var idx = 0; idx < wrapperObj.PermitPurposeList.length; idx++) {
    		if(wrapperObj.PermitPurposeList[idx].value==v.wrapperObj.customerVehicle.Permit_Purpose_Code__c)
        		component.set('v.wrapperObj.customerVehicle.Permit_Purpose__c',wrapperObj.PermitPurposeList[idx].label);
		}
    	console.log('wrapperObj>> '+JSON.stringify(component.get("v.wrapperObj")));
    },
    convertToUpperCase: function(component, event, helper) {
       var wrapperObj = component.get('v.wrapperObj');
        var Chassis_No = wrapperObj.customerVehicle.Chassis_No__c;
        wrapperObj.customerVehicle.Chassis_No__c = Chassis_No.toUpperCase();
        component.set('v.wrapperObj', wrapperObj);
    }
})