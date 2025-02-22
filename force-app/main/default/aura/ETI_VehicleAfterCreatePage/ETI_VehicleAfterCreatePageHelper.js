({
    getJsonFromUrl : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
        return result;
    },
    
    getJsonFromUrl1 : function (component, event, helper) {
        /* var query = location.search.substr(2);
            var result = {};
            query.split("&").forEach(function(part) {
                var item = part.split("=");
                result[item[0]] = decodeURIComponent(item[1]);
            });
            return result;*/
        try{
            var action = component.get("c.getChangelocation");
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returning = [];
                    var result = response.getReturnValue();
                    if(result != null && result != undefined && result != ''){
                         component.set("v.selectedEmirate", result.replace(/\s/g,''));
                    }
                }
            });
            $A.enqueueAction(action);
        }catch(err){
			alert(err.message)
        }
    },
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
})