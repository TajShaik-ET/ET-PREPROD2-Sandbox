({
	updateTabs: function(component,selectedCheckbox, selected){
        var evCmp = component.getEvent("tabVisibilityEvent");
        var params = {"tabName": selectedCheckbox, "selected": selected};
        evCmp.setParams(params);
        console.log('tabName ::' +JSON.stringify(selectedCheckbox) + 'selected ' + JSON.stringify(selected ));
        evCmp.fire();
 
    },

    fetchOppRecordType: function(component, opportunityRecordId, serviceRequestRecordId){
        
        
        var action = component.get("c.fetchOpportunityRecordType");
        action.setParams({"oppId": String(opportunityRecordId),
                          "serviceRequestId": String(serviceRequestRecordId)});
        
        action.setCallback(this, function(response){
            console.log(response.getState());
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('result in doinit of wrapper : ' + JSON.stringify(result));
                if(result != null){
                    if(result == 'ETSALES_Leasing'){
                        component.set("v.isVehicleDisabled", false);
                        component.set("v.isDriverDisabled", true);
                        component.set("v.isNannyDisabled", true);
                        component.set("v.isCoordinatorDisabled", true);
                        component.set("v.isAccountantDisabled", true);
                        component.set("v.isSupervisorDisabled", true);
                        component.set("v.isOtherEmpDisabled", true);
                        component.set("v.isOtherCostDisabled", true);
                    }else if(result == 'ETSALES_Transportation'){
                        component.set("v.isVehicleDisabled", false);
                        component.set("v.isDriverDisabled", false);
                        component.set("v.isNannyDisabled", false);
                        component.set("v.isCoordinatorDisabled", false);
                        component.set("v.isAccountantDisabled", false);
                        component.set("v.isSupervisorDisabled", false);
                        component.set("v.isOtherEmpDisabled", false);
                        component.set("v.isOtherCostDisabled", false);
                    }else if(result == 'ETSALES_Manpower'){
                        component.set("v.isVehicleDisabled", true);
                        component.set("v.isDriverDisabled", false);
                        component.set("v.isNannyDisabled", false);
                        component.set("v.isCoordinatorDisabled", false);
                        component.set("v.isAccountantDisabled", false);
                        component.set("v.isSupervisorDisabled", false);
                        component.set("v.isOtherEmpDisabled", false);
                        component.set("v.isOtherCostDisabled", false);
                    }else{
                        component.set("v.isVehicleDisabled", false);
                        component.set("v.isDriverDisabled", false);
                        component.set("v.isNannyDisabled", false);
                        component.set("v.isCoordinatorDisabled", false);
                        component.set("v.isAccountantDisabled", false);
                        component.set("v.isSupervisorDisabled", false);
                        component.set("v.isOtherEmpDisabled", false);
                        component.set("v.isOtherCostDisabled", false);
                    }
                    
                    var evCmp = component.getEvent("opportunityRecordTypeEvent");
                    var params = {"oppRecordType": result};
                    evCmp.setParams(params);
                    //console.log('tabName ::' +JSON.stringify(selectedCheckbox) + 'selected ' + JSON.stringify(selected ));
                    evCmp.fire();
                    
                }else{
                    console.log('Something went wrong,Opportunity record type is not found ');
                }
                
                
            }else{
                var errors = response.getError();
                alert(errors);
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
     getSObjectName: function(component,RecordId,helper){
         var action = component.get("c.getSObjectNameFromRecordId");
                action.setParams({"RecordId": String(RecordId)});

                action.setCallback(this, function(response){
                    console.log(response.getState());
                    if(response.getState() == 'SUCCESS'){
                        var result = response.getReturnValue();
                        console.log('result in doinit of wrapper : ' + JSON.stringify(result));
                        if(result != null){
                            if(result == 'Opportunity'){
                               // component.set("v.opportunityRecordId",RecordId);
                               helper.fetchOppRecordType(component, RecordId,'');
                            }else if(result == 'ET_Pricing_Service_Request__c'){
                                helper.fetchOppRecordType(component, '',RecordId);
                                
                            }
                        }
                    }
                });
        $A.enqueueAction(action);
    },
    
    UserPermissions: function (component, event, helper) {
        var action = component.get("c.getProfileInfo");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('getUserPermissions = ' + JSON.stringify(response.getReturnValue()));
                var resObj = response.getReturnValue();
                if (resObj.Name == 'System Administrator') {
                    component.set("v.isSysAdmin", false);
                    console.log('profile name__q' + resObj.Name);
                }
            }
            else if (state === "INCOMPLETE") {
                console.log('Network Issue or Server Down');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message + "Method :" + 'UserPermissions');
                        alert('Internal Server Error. Please Contact System Admin.');
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})