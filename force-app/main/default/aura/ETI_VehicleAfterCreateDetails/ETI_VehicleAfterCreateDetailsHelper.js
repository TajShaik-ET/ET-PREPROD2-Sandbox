({
    getAmanLookups: function (component, event, helper) {
        var action = component.get("c.getAmanLookupDetails");
        action.setParams({
            selectedLang: component.get("v.clLang")
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
                    label : test.lookupName,
                    value : test.lookupCode
                });                
            });
            result.plateSources.forEach(test => {
                pSource.push({
                label : test.lookupName,
                value : test.lookupCode
            	});                
            });
            result.plateColors.forEach(test => {
                pColor.push({
                label : test.lookupName,
                value : test.lookupCode
            	});                
            });
            component.set("v.PlateType", pType);
            component.set("v.Platesource", pSource);
            component.set("v.Platecolor", pColor);
        	this.fetchVehicleDetails(component, event, helper);
        }else {
            var msg=component.get("v.Plate_Combinations_Values");
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","info");
        }
        });
        $A.enqueueAction(action);
    },
    fetchVehicleDetails: function (component, event, helper) {
        console.log('recordId>> '+component.get('v.recordId'));
        var recordId = component.get('v.recordId');
        try{
            var action = component.get("c.getVehicleDetails");
            action.setParams({
                vehId: recordId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('state111>> '+state);
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log('vehicle...'+JSON.stringify(result));
                    component.set('v.deCryptedRecordId',result.Id);
                    component.set('v.VehicleInfoData',result);
                     //component.set('v.verifiedVehicleInfo',result);
                    var vehicleDataWrp={"Id":result.Id,"Name":result.Name,"Chassis_No__c":result.Chassis_No__c,"Plate_No__c":result.Plate_No__c,"Plate_Color__c":result.Plate_Color__c,"Plate_Type__c":result.Plate_Type__c,"Plate_Source__c":result.Plate_Source__c};
                    component.set('v.verifiedVehicleInfo',vehicleDataWrp); 
                    console.log('verifiedVehicleInfo..'+JSON.stringify(component.get('v.verifiedVehicleInfo')));
                }else {
                    var msg=component.get("v.Getting_Vehicle_Details");
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Info",msg,"","dismissible","info");
                }
             });
             $A.enqueueAction(action);
             component.set("v.IsSpinner", false);
        }catch(err){
            alert(err.message)
        }
	},
    getVehicleInfo : function(component,event,customerVehicle){
        console.log('customerVehicle>> '+JSON.stringify(component.get("v.VehicleInfoData")));
        var data= component.get('v.VehicleInfoData');
        var action = component.get("c.getVehicleInfoFromAbuDhabi");
        action.setParams({
            vehicle: component.get("v.VehicleInfoData"),
            selectedType: data.Selected_Type__c
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            //console.log('---'+state );
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result>> '+JSON.stringify(result));
                if(result!==null){
                    component.set('v.VehicleInfoData',result);
                    component.set('v.isMessgeExist',false);
                }else {
					var msg=component.get("v.Service_Not_Available");
					component.set('v.isMessgeExist',true);
                    component.set('v.errorType','info');
                    component.set('v.errorMessage',msg);
                    customerVehicle.Is_Verified__c = false;
                    component.set("v.VehicleInfoData",customerVehicle);
                    component.set("v.IsSpinner", false);
                    this.dataValidate(component);
                }
            }
            component.set("v.IsSpinner", false);
        });
        $A.enqueueAction(action);
	},
    duplicateCheck: function (component, event, helper) { 
        var vehicle = component.get("v.VehicleInfoData");
        var verifiedVehicle = component.get("v.verifiedVehicleInfo");
        console.log('verifiedVehicleInfo>> '+JSON.stringify(component.get("v.verifiedVehicleInfo")));
		if((vehicle.Selected_Type__c=='Chassis No' && verifiedVehicle.Chassis_No__c!=vehicle.Chassis_No__c) 
           || (vehicle.Registration_Type__c == 'Registered' && vehicle.Selected_Type__c=='Plate Combination' && (verifiedVehicle.Plate_No__c!=vehicle.Plate_No__c 
              || verifiedVehicle.Plate_Color__c!=vehicle.Plate_Color__c || verifiedVehicle.Plate_Source__c!=vehicle.Plate_Source__c
              || verifiedVehicle.Plate_Type__c!=vehicle.Plate_Type__c))){
            var action = component.get("c.checkDuplicatevehicle");
            action.setParams({
                vehicle : vehicle,
                limitVar : 1
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var result = response.getReturnValue();
                if (component.isValid() && state === "SUCCESS") {
                     //Duplicate with different user
                     if(result === 'Duplicate vehicle'){
                         var msg=component.get("v.Vehicle_already_exist");
                         if (!confirm(msg)) 
                            return true;
                         else 
                            return false;
                     }else if(result === 'Duplicate with same User'){
                         var msg=component.get("v.Vehicle_already_exist_System");
                         var utility = component.find("ETI_UtilityMethods");
                         var promise = utility.showToast(component.get("v.Info"),msg,"","dismissible","error");
                         return true;
                     }else {
                         return false;
                     }
                }else {
                    var msg=component.get("v.Unexpected_Error_Message");
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast(component.get("v.Error"),msg,"","dismissible","error");
                }
            });
            $A.enqueueAction(action);
        }else {
            return false;
        }
    },    
    dataValidate: function (component, event, helper) { 
        console.log('hiii11');
        var data= component.get('v.VehicleInfoData');
        console.log('data..'+JSON.stringify(component.get('v.VehicleInfoData')));
        var letters = /^[0-9]+$/;
        var isDataMissing=false; 
        console.log('showHistory '+component.get('v.showHistory'));
        console.log('data.Selected_Type__c '+data.Selected_Type__c);
         if(data.Vehicle_Year__c != null && data.Vehicle_Year__c != undefined && data.Vehicle_Year__c != '' && this.isNumber(data.Vehicle_Year__c)){
            var d = new Date();
            var today = d.getFullYear()+1;
            if(data.Vehicle_Year__c > today){
                component.find('vehicleYear').setCustomValidity(component.get("v.Year_4_digits_and_not_future"));
                component.find('vehicleYear').reportValidity();
                isValueMissing = true;
            }else{
                component.find('vehicleYear').setCustomValidity("");
                component.find('vehicleYear').reportValidity();
            }
            
        }
        
        if(data.Registration_Type__c != 'Registered' && data.Selected_Type__c == 'Chassis No'){
            console.log('isDataMissing INN..'+isDataMissing);
            if (component.find('chassisNo').get('v.value') == '' || component.find('chassisNo').get('v.value') == null || component.find('chassisNo').get('v.value') == undefined) {
                component.find('chassisNo').setCustomValidity(component.get("v.Field_is_required"));
                component.find('chassisNo').reportValidity();
                isDataMissing = true;
            }else {
                component.find('chassisNo').setCustomValidity("");
                component.find('chassisNo').reportValidity();
            }
        	if(data.Chassis_No__c !='' && data.Chassis_No__c !=null)
            component.set('v.errorChassis',false);
        }
        if(data.Registration_Type__c == 'Registered'){
            if(data.Selected_Type__c == 'Chassis No' || data.Selected_Type__c == 'Plate Combination'){
                if (component.find('plateNo').get('v.value') == '' || component.find('plateNo').get('v.value') == null || component.find('plateNo').get('v.value') == undefined) {
                    component.find('plateNo').setCustomValidity(component.get("v.Field_is_required"));
                    component.find('plateNo').reportValidity();
                    isDataMissing = true;
                }else {
                    console.log('plateNo '+component.find('plateNo').get('v.value'));
                    console.log('plateNo length '+component.find('plateNo').get('v.value').length);
                    if(!component.find('plateNo').get('v.value').toString().match(letters))
                    {
                        component.find('plateNo').setCustomValidity(component.get("v.Enter_only_numbers"));
                        component.find('plateNo').reportValidity();
                        isDataMissing = true;
                    }else if(component.find('plateNo').get('v.value').length >5){
                        component.find('plateNo').setCustomValidity(component.get("v.Plate_No_should_be_5_numbers"));
                        component.find('plateNo').reportValidity();
                        isDataMissing = true;
                    }else {
                        component.find('plateNo').setCustomValidity("");
                        component.find('plateNo').reportValidity();
                        isDataMissing = false;
                    }
                }
                if (component.find('plateColor').get('v.value') == '' || component.find('plateColor').get('v.value') == null || component.find('plateColor').get('v.value') == undefined) {
                    component.set('v.errorPlateColor',true);
                    isDataMissing = true;
                }else {
                    component.set('v.errorPlateColor',false);
                }
                if (component.find('plateType').get('v.value') == '' || component.find('plateType').get('v.value') == null || component.find('plateType').get('v.value') == undefined) {
                    component.set('v.errorPlateType',true);
                    isDataMissing = true;
                }else {
                    component.set('v.errorPlateType',false);
                }
                if (component.find('plateSource').get('v.value') == '' || component.find('plateSource').get('v.value') == null || component.find('plateSource').get('v.value') == undefined) {
                    component.set('v.errorPlateSource',true);
                    isDataMissing = true;
                }else {
                    component.set('v.errorPlateSource',false);
                }
            }
        }else {
            if(data.Vehicle_Year__c!=null && data.Vehicle_Year__c!=''){ 
                component.set('v.isMessgeExist',false);
                component.find('vehicleYear').setCustomValidity("");
                component.find('vehicleYear').reportValidity();
                if(!component.find('vehicleYear').get('v.value').toString().match(letters))
                {
                    component.find('vehicleYear').setCustomValidity(component.get("v.Enter_only_numbers"));
                    component.find('vehicleYear').reportValidity();
                    isDataMissing = true;
                }else if(component.find('vehicleYear').get('v.value').length !=4){
                    component.find('vehicleYear').setCustomValidity(component.get("v.Year_should_be_4_numbers"));
                    component.find('vehicleYear').reportValidity();
                    isDataMissing = true;
                }else {
                    component.find('vehicleYear').setCustomValidity("");
                    component.find('vehicleYear').reportValidity();
                    isDataMissing = false;
                }
            }else {
                component.find('vehicleYear').setCustomValidity(component.get("v.Field_is_required"));
                component.find('vehicleYear').reportValidity();
                component.set('v.isMessgeExist',true);
                component.set('v.errorType','warning');
                component.set('v.errorMessage',component.get("v.Enter_Valid_Year"));
            }
        }
        if(isDataMissing){
            component.set("v.IsSpinner", false);
            return true;
        } else{
             return false;
        }
    },
        isNumber:function(str) {
        var pattern = /^\d+$/;
        return pattern.test(str);  // returns a boolean
    },
})