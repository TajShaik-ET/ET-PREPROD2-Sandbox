({
	doinit : function(component, event, helper) {
        helper.getAmanLookups(component, event, helper);
        //helper.fetchVehicleDetails(component, event, helper);
    },
    clearValidationError: function (component, event, helper) {
        var eventId = event.getSource();
        var localId = event.getSource().getLocalId();
		console.log('localId>> '+localId+' value>> '+component.find(localId).get('v.value'));
        if(localId=='selectedType'){
            component.set('v.errorServiceType',false);
        }else if (component.find(localId).get('v.value') != '' && component.find(localId).get('v.value') != null && component.find(localId).get('v.value') != undefined) {
         	console.log('innn>> ');
            component.find(localId).setCustomValidity("");
            component.find(localId).reportValidity();
        }
    },
    clearPlateColorError: function (component, event, helper) {
        console.log('Color>> ');
        if (component.find('plateColor').get('v.value') == '' || component.find('plateColor').get('v.value') == null || component.find('plateColor').get('v.value') == undefined) {
            component.set('v.errorPlateColor',true);
            isDataMissing = true;
        }else {
            component.set('v.errorPlateColor',false);
        }
    },
    clearPlateTypeError: function (component, event, helper) {
         if (component.find('plateType').get('v.value') == '' || component.find('plateType').get('v.value') == null || component.find('plateType').get('v.value') == undefined) {
             component.set('v.errorPlateType',true);
             isDataMissing = true;
         }else {
             component.set('v.errorPlateType',false);
         }
    },
    validateYear: function(component, event, helper){
        var data = component.get("v.customerVehicle");
        var letters = /^[0-9]+$/;
        if(data.Vehicle_Year__c!=null && data.Vehicle_Year__c!=''){ 
            component.set('v.isMessgeExist',false);
            component.find('vehicleYear').setCustomValidity("");
            component.find('vehicleYear').reportValidity();
            if(!component.find('vehicleYear').get('v.value').toString().match(letters))
            {
                component.find('vehicleYear').setCustomValidity("Please enter only numbers.");
                component.find('vehicleYear').reportValidity();
            }else if(component.find('vehicleYear').get('v.value').length !=4){
                component.find('vehicleYear').setCustomValidity("Year should be 4 numbers.");
                component.find('vehicleYear').reportValidity();
            }else {
                component.find('vehicleYear').setCustomValidity("");
                component.find('vehicleYear').reportValidity();
            }
        }else if(data.Registration_Type__c != 'Registered'){
            component.find('vehicleYear').setCustomValidity("This field is required");
            component.find('vehicleYear').reportValidity();
            component.set('v.isMessgeExist',true);
            component.set('v.errorType','warning');
            component.set('v.errorMessage','Please enter a valid Year.');
        }
    },
    handleUpdateVehicle: function(component, event, helper) {
        component.set('v.isMessgeExist',false);
        var vehicle = component.get("v.customerVehicle");
        var verifiedVehicle = component.get("v.verifiedVehicleInfo");
        console.log('verifiedVehicleInfo>> '+JSON.stringify(component.get("v.verifiedVehicleInfo")));
        let isDataMissing=helper.dataValidate(component, event, helper);
        console.log('isDataMissing..'+isDataMissing);
        if(isDataMissing){
            component.set("v.IsSpinner", false);
            return false;
        }else {  
            console.log('isDataMissing '+isDataMissing);
            if((vehicle.Selected_Type__c=='Chassis No' && verifiedVehicle.Chassis_No__c!=vehicle.Chassis_No__c) 
               || (vehicle.Registration_Type__c == 'Registered' && vehicle.Selected_Type__c=='Plate Combination' && (verifiedVehicle.Plate_No__c!=vehicle.Plate_No__c 
                  || verifiedVehicle.Plate_Color__c!=vehicle.Plate_Color__c || verifiedVehicle.Plate_Source__c!=vehicle.Plate_Source__c
                  || verifiedVehicle.Plate_Type__c!=vehicle.Plate_Type__c))){
                console.log('INNN ');
                var action = component.get("c.getVehicleInfoFromAbuDhabi");
                action.setParams({
                    "vehicle": component.get('v.customerVehicle'),
                    "selectedType": vehicle.Selected_Type__c
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    console.log('state '+state);
                    if (state === "SUCCESS") {
                        var result = response.getReturnValue();
                        console.log('result '+result);
                        if(result!=null){
                            component.set('v.customerVehicle',result);
                            var vehicleDataWrp={"Id":result.Id,"Name":result.Name,"Chassis_No__c":result.Chassis_No__c,"Plate_No__c":result.Plate_No__c,"Plate_Color__c":result.Plate_Color__c,"Plate_Type__c":result.Plate_Type__c,"Plate_Source__c":result.Plate_Source__c};
                            component.set('v.verifiedVehicleInfo',vehicleDataWrp); 
                            helper.updateVehicle(component, event, helper);
                        }else {
                            var msg='Vehicle information auto-retrieval service is not available at this time. Please proceed by entering mandatory information.';
                            component.set('v.isMessgeExist',true);
                            component.set('v.errorType','info');
                            component.set('v.errorMessage',msg);
                            vehicle.Is_Verified__c = false;
                            component.set("v.customerVehicle",vehicle);
                            var vehicleDataWrp={"Id":vehicle.Id,"Name":vehicle.Name,"Chassis_No__c":vehicle.Chassis_No__c,"Plate_No__c":vehicle.Plate_No__c,"Plate_Color__c":vehicle.Plate_Color__c,"Plate_Type__c":vehicle.Plate_Type__c,"Plate_Source__c":vehicle.Plate_Source__c};
                    		component.set('v.verifiedVehicleInfo',vehicleDataWrp); 
                            console.log('verifiedVehicleInfo 111>> '+JSON.stringify(component.get("v.verifiedVehicleInfo")));
                        }
                    }
                });
                $A.enqueueAction(action);
                component.set("v.IsSpinner", false);
            }else {
                helper.updateVehicle(component, event, helper);
            }
        }
    },
    handleCancel: function(component, event, helper) {
         $A.get("e.force:closeQuickAction").fire();
    }
})