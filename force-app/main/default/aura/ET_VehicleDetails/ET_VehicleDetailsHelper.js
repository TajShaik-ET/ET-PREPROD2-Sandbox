({
    getvehicleDetails: function(component, event, helper) {
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "Vehicle__c",
            'field_apinames': component.get("v.picklistFields")
        });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                 component.set('v.loaded', !component.get('v.loaded'));
                var response=a.getReturnValue();
                console.log('response in getvehicleDetails  = '+ JSON.stringify(response));
                if(response!=null && response!= undefined){
                    
                    if(response.vehicleOrigin!=null && response.vehicleOrigin!=undefined){
                        component.set("v.vehicleOrigin",response.vehicleOrigin);
                    }else{
                        console.log('vehicleOrigin is null');
                    }
                    if(response.serviceTypes!=null && response.serviceTypes!=undefined){
                        component.set("v.serviceTypes",response.serviceTypes);
                    }else{
                        console.log('serviceTypes is null');
                    }
                    
                    if(response.vehicleTypes!=null && response.vehicleTypes!=undefined){
                        component.set("v.vehicleTypes",response.vehicleTypes);
                    }else{
                        console.log('vehicleTypes is null');
                    }
                    
                    if(response.vehicleSource!=null && response.vehicleSource!=undefined){
                        component.set("v.vehicleSource",response.vehicleSource);
                    }else{
                        console.log('vehicleSource is null');
                    }
                    if(response.vehicleMake!=null && response.vehicleMake!=undefined){
                        component.set("v.vehicleMake",response.vehicleMake);
                    }
                    if(response.trailerModels!=null && response.trailerModels!=undefined){
                        component.set("v.TrailerModelList",response.trailerModels);
                    }
                    if(response.trailerSubTypes!=null && response.trailerSubTypes!=undefined){
                        component.set("v.TrailerSubTypeList",response.trailerSubTypes);
                    }
                    if(response.refrigeratorModels!=null && response.refrigeratorModels!=undefined){
                        component.set("v.RefregiratorModelList",response.refrigeratorModels);
                    }
                    if(response.refrigeratorSubTypes!=null && response.refrigeratorSubTypes!=undefined){
                        component.set("v.RefregiratorSubTypeList",response.refrigeratorSubTypes);
                    }
                    if(response.vehicleCondition!=null && response.vehicleCondition!=undefined){
                        component.set("v.vehicleCondition",response.vehicleCondition);
                    }else{
                        console.log('vehicleCondition is null');    
                    }
                    
                     if(response.vehicleModelYears!=null && response.vehicleModelYears!=undefined){
                        component.set("v.vehicleModelYear",response.vehicleModelYears);
                    }
                    if(response.maxvehicleModelYears!=null && response.maxvehicleModelYears!=undefined){
                        component.set("v.vehicleModelYearnew",response.maxvehicleModelYears);
                    }
                    
                    if(response.insuranceCoverage!=null && response.insuranceCoverage!=undefined){
                        component.set("v.insuranceCoverage",response.insuranceCoverage);
                    }else{
                        console.log('insuranceCoverage is null');    
                    }
                    
                    if(response.InsuranceCategoryList!=null && response.InsuranceCategoryList!=undefined){
                        component.set("v.InsuranceCategoryList",response.InsuranceCategoryList);
                    }else{
                        console.log('InsuranceCategoryList is null');    
                    }
                    
                    if(response.vehicleFuel!=null && response.vehicleFuel!=undefined){
                        component.set("v.vehicleFuel",response.vehicleFuel);  
                    }else{
                        console.log('vehicleFuel is null');
                    }    
                    
                    if(response.specRequirement!=null && response.specRequirement!=undefined){
                       // component.set("v.specRequirement",response.specRequirement);
                    }else{
                        console.log('specRequirement is null');
                    }
                    
                    
                    
                    if(response.contractPeriods!=null && response.contractPeriods!=undefined){
                        var options=[];
                        for(var period of response.contractPeriods){
                            options.push({"label" : period + ' Contract', "value" : period});
                        }  
                        component.set("v.contractPeriods",options);
                    }else{
                        console.log('contractPeriods is null');
                    }
                    if(response.contractTypes!=null && response.contractTypes!=undefined){
                        console.log("v.contractTypes -->"+response.contractTypes);
                        component.set("v.contractTypes",response.contractTypes);
                    }else{
                        console.log('contractTypes is null');
                    }
                    if(response.serviceEmirates!=null && response.serviceEmirates!=undefined){
                        component.set("v.serviceEmirates",response.serviceEmirates);
                    }else{
                        console.log('serviceEmirates is null');
                    }  
                    if(response.pricingMethods!=null && response.pricingMethods!=undefined){
                        component.set("v.pricingMethods",response.pricingMethods);
                    }else{
                        console.log('pricingMethods is null');
                    } 
                    if(response.pricingMethodAndDependentTypeMap!=null && response.pricingMethodAndDependentTypeMap!=undefined){
                        component.set("v.pricingMethodAndDependentTypeMap",response.pricingMethodAndDependentTypeMap);
                        //setting pricing type value by default; to avoid problems while loading data in edit fucntionality.
                        component.set("v.pricingTypes", (response.pricingMethodAndDependentTypeMap)['Comprehensive Price per Quotation']);
                    }else{
                        console.log('pricingMethodAndDependentTypeMap is null');
                    }
                    if(response.fleetTypes!=null && response.fleetTypes!=undefined){
                        component.set("v.fleetTypes",response.fleetTypes);
                    }else{
                        console.log('fleetTypes is null');
                    }
                    if(response.specRequirementMap!=null && response.specRequirementMap!=undefined){
                        var options=[];
                        for(var specReq in response.specRequirementMap){
                            options.push({"label" : specReq, "value" : response.specRequirementMap[specReq]});
                        }  
                        console.log('options>> '+JSON.stringify(options));
                        component.set("v.specRequirOptionLst",options);
                    }else{
                        console.log('specRequirementMap is null');
                    }
                    if(response.specRequirementMapPermit!=null && response.specRequirementMapPermit!=undefined){
                        var options=[];
                        for(var specReq in response.specRequirementMapPermit){
                            options.push({"label" : specReq, "value" : response.specRequirementMapPermit[specReq]});
                        }  
                        console.log('options>> '+JSON.stringify(options));
                        component.set("v.specRequirOptionLstPermit",options);
                    }else{
                        console.log('specRequirementMap is null');
                    }
                    
                    var delayInMilliseconds = 200; //0.6 seconds
                    window.setTimeout(
                        $A.getCallback(function() {
                            //console.log('myHelperMethod EXECUTING NOW... ');
                            var compEvent = component.getEvent("refreshEvent");
                            compEvent.setParams({"childCmpAuraId": component.getLocalId(), "childTabLineNumber" : component.get("v.lineNumber")});
                            compEvent.fire();
                        }), delayInMilliseconds
                    );     
                }
                else{
                    console.log('response is null');
                }
                
            }
            else if(state === "ERROR"){
                 component.set('v.loaded', !component.get('v.loaded'));
                alert('Internal Error.Vehicle Information not populated. Please Try again or Contact System Admin.');
            }
            else{
                 component.set('v.loaded', !component.get('v.loaded'));
                console.log('callback from the server failed'); 
            }
        });
        $A.enqueueAction(action);
    },
    
    getvehicleModels: function(component, event, helper) {
        
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get("c.ET_getVehicleModels");
            
            action.setParams({
                'vehicleMake': component.get('v.vehicleLine.ET_Vehicle_MAKE__c')
            });
            
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS"){
                    var response=a.getReturnValue();
                    console.log('response '+response);
                    if(response!=null && response!=undefined){
                        component.set("v.vehicleModel",response);
                        resolve('resolved');
                    }else{
                        console.log('vehicleModel is null');
                        reject('rejected');
                    }
                    
                }
            });
            $A.enqueueAction(action);
        }));
    },
    getvehicleSpecs: function(component, event, helper) {
        if(component.get('v.vehicleLine.ET_Vehicle_MAKE__c') != '' &&
           component.get('v.vehicleLine.ET_Vehicle_Model__c') != ''){
            return new Promise($A.getCallback(function(resolve, reject) {
                var action = component.get("c.ET_getVehicleSpecs");
                
                action.setParams({
                    'vehicleMake': component.get('v.vehicleLine.ET_Vehicle_MAKE__c'),
                    'model': component.get('v.vehicleLine.ET_Vehicle_Model__c')
                });
                
                action.setCallback(this, function(a) {
                    var state = a.getState();
                    if (state === "SUCCESS"){
                        var response=a.getReturnValue();
                        console.log('response '+response);
                        if(response!=null && response!=undefined){
                            component.set("v.vehicleSpecs",response);
                            resolve('resolved');
                        }else{
                            console.log('vehicleSpecs is null');
                            component.set("v.vehicleSpecs",null);
                            rejected('rejected');
                        }
                        
                    }
                });
                $A.enqueueAction(action);
            }));
        }else{
            component.set("v.vehicleSpecs",null);
        }
        
        
    },
    
    updateVehicleFuelInformationHelper : function(component, event, helper) {
        if(component.get("v.vehicleLine").ET_Vehicle_Fuel__c == 'Yes'){
            $A.util.toggleClass(component.find("ET_Vehicle_Fuel_Consumption__c"), "slds-hide");
            helper.getFuelTypes(component,event,helper);
        }
    },
    
    getVehicleSubTypesControllerHelper : function(component, event, helper) {
        if(component.get('v.vehicleLine.Vehicle_Type__c') != '' ){
            return new Promise($A.getCallback(function(resolve, reject) {
                var action = component.get("c.ET_getvehicleSubTypes");
                
                    action.setParams({
                        'vehicleType': component.get('v.vehicleLine.Vehicle_Type__c')
                });
                action.setCallback(this, function(a) {
                    var state = a.getState();
                    console.log('state = '+ state);
                    if (state === "SUCCESS"){
                        var response=a.getReturnValue();
                        if(response!=null && response!=undefined){
                            component.set("v.vehicleSubTypes",response);
                            resolve('resolved');
                        }else{
                            console.log('vehicleSpecs is null');
                            component.set("v.vehicleSubTypes",null);
                            rejected('rejected');
                        }
                        
                    }
                    
                    else if (state === "INCOMPLETE") {
                        console.log('Network Issue or Server Down');
                    }
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + 
                                                errors[0].message + "Method : getvehicleSubTypes"  );
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                    
                });
                $A.enqueueAction(action);
            }));
        }else{
            component.set("v.vehicleSubTypes",null);
        }
    },
    
    getFuelTypes: function(component,event,helper){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get("c.getFuelTypes");
            action.setCallback(this, function(a) {  
                var state = a.getState();
                if (state === "SUCCESS"){
                    var response=a.getReturnValue();
                    console.log('response '+response);
                    if(response!=null && response!=undefined){
                        component.set("v.vehicleFuelTypes",response);
                        resolve('resolved');
                        
                        }else{
                            console.log('vehicle Fuel Types not found');
                            component.set("v.vehicleFuelTypes",null);
                            reject('rejected');
                        }
        
                }
            });
            $A.enqueueAction(action);
        }))
    },
    
    setModelYears : function(component,event,helper){
        
    },
    
    getVehicleMasterDataHelper: function(component,event,helper){
        if(component.get('v.vehicleLine.ET_Vehicle_MAKE__c') != '' &&  
           component.get('v.vehicleLine.ET_Vehicle_Model__c') != '' &&
           component.get('v.vehicleLine.ET_Vehicle_Sub_Type__c') != '' &&
           component.get('v.vehicleLine.ET_Fuel_Type__c') != ''){
            return new Promise($A.getCallback(function(resolve, reject) {
                var action = component.get("c.getVehicleMasterData");
                
                action.setParams({
                    'vehicleMake': component.get('v.vehicleLine.ET_Vehicle_MAKE__c'),
                    'vehicleModel': component.get('v.vehicleLine.ET_Vehicle_Model__c'),
                    'isSettingStoredData': component.get("v.isSettingAlreadyStoredData"),
                    'vehicleSubType' : component.get('v.vehicleLine.ET_Vehicle_Sub_Type__c'),
                    'vehicleFuelType' : component.get('v.vehicleLine.ET_Fuel_Type__c')
                });
                
                action.setCallback(this, function(a) {  
                    var state = a.getState();
                    if (state === "SUCCESS"){
                        var response=a.getReturnValue();
                        console.log('selected Vehicle  '+JSON.stringify(response));
                        if(response!=null && response!=undefined){
                            component.set("v.vehicleModelYear",response.vehicleModelYears);
                            if(response.vehicleMasterRecord){
                                component.set('v.vehicleLine.ET_Vehicle_Original_Purchase_Price__c',response.vehicleMasterRecord.ET_Vehicle_Latest_New_Purchase_Price__c);
                                component.set('v.vehicleLine.ET_Vehicle_Fuel_Consumption__c',response.vehicleMasterRecord.ET_Vehicle_Fuel_Consumption__c);
                                component.set('v.vehicleLine.ET_Number_of_seats__c',response.vehicleMasterRecord.ET_Number_of_seats__c);
                            }
                            //component.set('v.vehicleLine.ET_Vehicle_Current_Purchase_Price__c',);
                            resolve('resolved');
                        }else{
                            console.log('vehicleModelYear is null');
                            component.set("v.vehicleModelYear",null);
                            reject('rejected');
                        }
                        
                    }
                    else if (state === "INCOMPLETE") {
                        console.log('Network Issue or Server Down');
                    }
                        else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " + 
                                                errors[0].message + "Method : getVehicleMasterDataHelper"  );
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                });
                $A.enqueueAction(action);
            }));
        }else{
            component.set("v.vehicleModelYear",null);
        }
        
    },
    
    throwError: function(component,event,helper,errorMessage){
        $A.createComponent(
            "c:ET_DisplayErrorMessage",{
                "aura:id" : "generatedErrorCmp",
                "type" : 'Error',
                "message" : errorMessage
            },
            function(newcomponent){
                if (newcomponent.isValid()) {
                    var newCmp = component.find("errorDiv");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body);
                }
            }
        );
    },
    
    getFuelTypes: function(component,event,helper){
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get("c.getFuelTypes");
            action.setCallback(this, function(a) {  
                var state = a.getState();
                if (state === "SUCCESS"){
                    var response=a.getReturnValue();
                    console.log('response '+response);
                    if(response!=null && response!=undefined){
                        component.set("v.vehicleFuelTypes",response);
                        resolve('resolved');
                        
                    }else{
                        console.log('vehicle Fuel Types not found');
                        component.set("v.vehicleFuelTypes",null);
                        reject('rejected');
                    }
                    
                }
            });
            $A.enqueueAction(action);
        }))
    },
    handleOtherVehicleReqHelper: function(component,existingData){
        console.log('existingData helper>> '+JSON.stringify(existingData));
        $A.createComponent(
            "c:ET_OtherVehicleRequirement",{
                "aura:id" : "vehicleReqCmp",
                "existingData": existingData,
                "editableFieldsByPricingTeam" : component.get("v.editableFieldsByPricingTeam"),
                "isPricingTeam" : component.get("v.isPricingTeam"),
                "predefinedOtherCostMasterData" : component.get("v.predefinedOtherCostMasterData")
            },
            function(newcomponent){
                if (component.isValid()) {
                    var newCmp = component.find("OtherVehicleReq");
                    if(newCmp){
                        var body = newCmp.get("v.body");
                        body.push(newcomponent);
                        newCmp.set("v.body", body);  
                    }
                    else{
                        component.find("OtherVehicleReq").set("v.body" , []);
                        component.find("OtherVehicleReq").get("v.body").push(newcomponent);
                    }
                }
            }            
        );
    },
    handleAddOtherCostHelper: function(component,existingData){
        console.log('existingData helper>> '+JSON.stringify(existingData));
        $A.createComponent(
            "c:ET_OtherCostPerRequirementCmp",{
                "aura:id" : "vehicleOtherCostCmp",
                "existingData": existingData,
                "editableFieldsByPricingTeam" : component.get("v.editableFieldsByPricingTeam"),
                "isPricingTeam" :component.get("v.isPricingTeam")
            },
            function(newcomponent){
                if (component.isValid()) {
                    var newCmp = component.find("OtherCostDiv");
                    var body = newCmp.get("v.body");
                    body.push(newcomponent);
                    newCmp.set("v.body", body);             
                }
            }            
        );
    },
    
    validateOtherCostFieldsPerTab: function(component,event,helper){
        var requiredFieldIdLst;
        var isValid = true;
        var OtherCostCmps = component.find('vehicleOtherCostCmp');
        if(OtherCostCmps && OtherCostCmps.length == undefined){
            var requiredFieldsLst = [];
            requiredFieldIdLst = OtherCostCmps.get("v.otherCostDetailFieldsToValidate");
            for(var id in requiredFieldIdLst){
                if(OtherCostCmps.find(requiredFieldIdLst[id])){
                    requiredFieldsLst.push(OtherCostCmps.find(requiredFieldIdLst[id]));
                }
            }
            return helper.validateFields(requiredFieldsLst);
        }else if(OtherCostCmps && OtherCostCmps.length > 0){
            requiredFieldIdLst = OtherCostCmps[0].get("v.otherCostDetailFieldsToValidate");
            for(var otherCostCmp of OtherCostCmps){
                var requiredFieldsLst = [];
                for(var id in requiredFieldIdLst){
                    if(otherCostCmp.find(requiredFieldIdLst[id])){
                        requiredFieldsLst.push(otherCostCmp.find(requiredFieldIdLst[id]));
                    }
                }
                
                if(requiredFieldsLst.length!=undefined && requiredFieldsLst.length > 0){
                    
                    if(!helper.validateFields(requiredFieldsLst)){
                        isValid = false;
                    }
                    
                }   
            }
        }
        return isValid;
    },
    
    validateFields: function(fieldLst){
        
        var allValid = fieldLst.reduce(function (validSoFar, inputCmp) {            
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return allValid;
    },
   
    getOpportunityDetails: function(component, event, helper) {
        var action = component.get("c.getOppRecord");
        action.setParams({
            'oppId': component.get("v.oppId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.opportunitySector", response.getReturnValue());
                console.log('nura'+JSON.stringify(response.getReturnValue()));
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log('getOpportunityDetails error');
                    console.table(errors);
                    component.set("v.error", errors[0].message);
                }
            }
            
        });
        $A.enqueueAction(action);
    },

    //Taj
    showToast : function(component, event, helper, title, message, type, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title, //Info //Success //Error //Warning
            message: message,
            duration:'5000',
            type: type, //info //success //error //warning
            mode: mode //dismissible //pester //sticky
        });
        toastEvent.fire();
    },
 
})