({
	getAmanLookups: function (component, event, helper) {
            var action = component.get("c.getAmanLookupDetails");
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
            var msg='There is a problem getting plate combinations values.';
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Info!",msg,"","dismissible","info");
        }
        });
        $A.enqueueAction(action);
    },
    fetchVehicleDetails: function (component, event, helper) {
        console.log('recordId>> '+component.get('v.recordId'));
        component.set("v.IsSpinner", true);
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
                    component.set('v.customerVehicle',result);
                    var vehicleDataWrp={"Id":result.Id,"Name":result.Name,"Chassis_No__c":result.Chassis_No__c,"Plate_No__c":result.Plate_No__c,"Plate_Color__c":result.Plate_Color__c,"Plate_Type__c":result.Plate_Type__c,"Plate_Source__c":result.Plate_Source__c};
                    component.set('v.verifiedVehicleInfo',vehicleDataWrp); 
                    console.log('verifiedVehicleInfo..'+JSON.stringify(component.get('v.verifiedVehicleInfo')));
                	component.set("v.IsSpinner", false);
                }else {
                    var msg='There is a problem getting Vehicle Details.';
                    var utility = component.find("ETI_UtilityMethods");
                    var promise = utility.showToast("Info",msg,"","dismissible","info");
                    component.set("v.IsSpinner", false);
                }
             });
             $A.enqueueAction(action);
             
        }catch(err){
            alert(err.message)
        }
	},
    dataValidate: function (component, event, helper) { 
        var data= component.get('v.customerVehicle');
        console.log('dataValidate..'+JSON.stringify(component.get('v.customerVehicle')));
        var letters = /^[0-9]+$/;
        var isDataMissing=false; 
        console.log('data.Selected_Type__c '+data.Selected_Type__c);
        if(data.Selected_Type__c =='' || data.Selected_Type__c ==null || data.Selected_Type__c ==undefined){
            component.set('v.errorServiceType',true);
            isDataMissing = true;
        }
        if(data.Vehicle_Year__c != null && data.Vehicle_Year__c != undefined && data.Vehicle_Year__c != '' && this.isNumber(data.Vehicle_Year__c)){
            var d = new Date();
            var today = d.getFullYear();
            if(data.Vehicle_Year__c > today){
                component.find('vehicleYear').setCustomValidity("Year can be only 4 numbers and not future value.");
                component.find('vehicleYear').reportValidity();
                isDataMissing = true;
            }else{
                component.find('vehicleYear').setCustomValidity("");
                component.find('vehicleYear').reportValidity();
            }
            
        }
        if(data.Selected_Type__c == 'Chassis No'){
            console.log('isDataMissing INN..'+isDataMissing);
            if (component.find('chassisNo').get('v.value') == '' || component.find('chassisNo').get('v.value') == null || component.find('chassisNo').get('v.value') == undefined) {
                component.find('chassisNo').setCustomValidity("This field is required");
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
            if(data.Selected_Type__c == 'Plate Combination'){
                if (component.find('plateNo').get('v.value') == '' || component.find('plateNo').get('v.value') == null || component.find('plateNo').get('v.value') == undefined) {
                    component.find('plateNo').setCustomValidity("This field is required");
                    component.find('plateNo').reportValidity();
                    isDataMissing = true;
                }else {
                    console.log('plateNo '+component.find('plateNo').get('v.value'));
                    console.log('plateNo length '+component.find('plateNo').get('v.value').length);
                    if(!component.find('plateNo').get('v.value').toString().match(letters))
                    {
                        component.find('plateNo').setCustomValidity("Please enter only numbers.");
                        component.find('plateNo').reportValidity();
                        isDataMissing = true;
                    }else if(component.find('plateNo').get('v.value').length >5){
                        component.find('plateNo').setCustomValidity("Plate No should be 5 numbers.");
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
                    component.find('vehicleYear').setCustomValidity("Please enter only numbers.");
                    component.find('vehicleYear').reportValidity();
                    isDataMissing = true;
                }else if(component.find('vehicleYear').get('v.value').length !=4){
                    component.find('vehicleYear').setCustomValidity("Year should be 4 numbers.");
                    component.find('vehicleYear').reportValidity();
                    isDataMissing = true;
                }else {
                    component.find('vehicleYear').setCustomValidity("");
                    component.find('vehicleYear').reportValidity();
                    //isDataMissing = false;
                }
            }else {
                component.find('vehicleYear').setCustomValidity("This field is required");
                component.find('vehicleYear').reportValidity();
                component.set('v.isMessgeExist',true);
                component.set('v.errorType','warning');
                component.set('v.errorMessage','Please enter a valid Year.');
                isDataMissing = true;
            }
        }
        if(isDataMissing){
            component.set("v.IsSpinner", false);
            return true;
        } else{
             return false;
        }
    },
    updateVehicle: function(component, event, helper) {
        var action = component.get("c.updateVehicleDetails");
        action.setParams({
            "vehicleDetails": component.get('v.customerVehicle')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('state '+state);
            var result = response.getReturnValue();
            //if (component.isValid() && state === "SUCCESS") 
            var utility = component.find("ETI_UtilityMethods");
            var promise = utility.showToast("Success!","The record has been Updated Successfully.","","dismissible","success");
            $A.get('e.force:refreshView').fire()
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    },
    isNumber:function(str) {
        var pattern = /^\d+$/;
        return pattern.test(str);  // returns a boolean
    },
})