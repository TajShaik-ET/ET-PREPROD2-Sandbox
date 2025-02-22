({
    getSRCommonDetails: function(component, event, helper) {
        var action = component.get("c.getPicklistvalues");
        action.setParams({
            'objectName': "ET_Work_force__c",
            'field_apinames': component.get("v.picklistFields"),
            'workforceType': 'Supervisor'
        });
        component.set('v.loaded', !component.get('v.loaded'));
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                component.set('v.loaded', !component.get('v.loaded'));
                var response=a.getReturnValue();
                //console.log('response-->'+JSON.stringify(response));
                if(response!=null && response!=undefined){
                    if(response.workforceCategory==null||response.workforceCategory==undefined||
                       response.specRequirement==null||response.specRequirement==undefined){
                        console.log('supervisorCategory or specRequirement  is null');     
                    }
                    component.set("v.supervisorCategory",response.workforceCategory);
                    component.set("v.specRequirement",response.specRequirement);
                    if(response.contractPeriods!=null && response.contractPeriods!=undefined){
                        var options=[];
                        for(var period of response.contractPeriods){
                            options.push({"label" : period, "value" : period});
                        }  
                        component.set("v.contractPeriods",options);
                    }else{
                        console.log('contractPeriods is null');
                    }
                    if(response.serviceTypes!=null && response.serviceTypes!=undefined){
                        component.set("v.serviceTypes",response.serviceTypes);
                    }else{
                        console.log('serviceTypes is null');
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
                    
                    
                    var delayInMilliseconds = 100;
                    window.setTimeout(
                        $A.getCallback(function() {
                            //console.log('myHelperMethod EXECUTING NOW... ');
                            var compEvent = component.getEvent("refreshEvent");
                            compEvent.setParams({"childCmpAuraId": component.getLocalId(), "childTabLineNumber" : component.get("v.lineNumber")});
                            compEvent.fire();
                        }), delayInMilliseconds
                    );     
                    
                }else{
                    console.log('response is null');
                }
                
            }
            else if(state === "ERROR"){
                component.set('v.loaded', !component.get('v.loaded'));
                alert('Internal Error.Supervisor Information not populated. Please Try again or Contact System Admin.');
            }
                else{
                    component.set('v.loaded', !component.get('v.loaded'));
                    console.log('callback from the server failed'); 
                }
            
        });
        $A.enqueueAction(action);
    },
    
    handleAddOtherCostHelper: function(component,existingData){
        $A.createComponent(
            "c:ET_OtherCostPerRequirementCmp",{
                "aura:id" : "supervisorOtherCostCmp",
                "existingData" : existingData,
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
        var OtherCostCmps = component.find('supervisorOtherCostCmp');
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
    }
})