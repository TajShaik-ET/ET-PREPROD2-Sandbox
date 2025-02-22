({
    doInit: function(component, event, helper) {
        var selectedTabLst = component.get("v.selectedTabLst");
        if(selectedTabLst != undefined ){
            if(selectedTabLst.includes("Vehicle")){
                component.set("v.isVehicleTabSelected", true);
            }
            if(selectedTabLst.includes("Drivers")){
                component.set("v.isDriverTabSelected", true);
            }
            if(selectedTabLst.includes("School_Bus_Nannies")){
                component.set("v.isNanyTabSelected", true);
            }
            if(selectedTabLst.includes("Supervisors")){
                component.set("v.isSupervisorTabSelected", true);
            }
            if(selectedTabLst.includes("Coordinators")){
                component.set("v.isCoordinatorTabSelected", true);
            }
            if(selectedTabLst.includes("Accountant")){
                component.set("v.isAccuntantTabSelected", true);
            }
            if(selectedTabLst.includes("Other_Employees")){
                component.set("v.isEmployeeTabSelected", true);
            }
            if(selectedTabLst.includes("Other_Cost")){
                component.set("v.isCostTabSelected", true);
            }
            helper.getVehAndManpowerInfo(component, event, helper); 
        }
        /* if(allDataMap['vehicleInfo'] != undefined){
          component.set("v.vehicleDetailsMap", allDataMap['vehicleInfo'] );
        }
        console.log('vehicle data doinit modal cmp : '+ JSON.stringify(allDataMap['vehicleInfo']));
       /* if(){

        }*/
      
  },
    closeModel: function(component, event, helper) {
        component.set("v.disableCustomizePricingBttn",false);
        var evCmp = component.getEvent("hideMappingModal");
        evCmp.fire();
        //component.destroy();
        
    },
    addMapping: function(component, event, helper) {
        var errCmp = component.find("errMessage");
        if(errCmp != undefined){
            errCmp.destroy();
        }
        var priceChoiceLst = [];
        
        if(component.get("v.isSupervisorTabSelected")){
            priceChoiceLst.push(component.find("selectSuperPriChoice"));
        }
        if(component.get("v.isCoordinatorTabSelected")){
            priceChoiceLst.push(component.find("selectCordiPriChoice"));
        }
        if(component.get("v.isAccuntantTabSelected")){
            priceChoiceLst.push(component.find("selectAccPriChoice"));
        }
        if(component.get("v.isEmployeeTabSelected")){
            priceChoiceLst.push(component.find("selectOtherEmployeePriChoice"));
        }
        
        var allValid = priceChoiceLst.reduce(function (validSoFar, inputCmp) {            
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if(allValid){
            var isSupervisorRequired = false;
            var isCoordinatorRequired =  false;
            var isAccountantRequired = false;
            var isOtherEmployeeRequired = false;
            if(component.get("v.supervisorPricingChoice") == 'perCombination'){
                isSupervisorRequired = true;
            }
            if(component.get("v.coordinatorPricingChoice") == 'perCombination'){
                isCoordinatorRequired = true;
            }
            if(component.get("v.accountantPricingChoice") == 'perCombination'){
                isAccountantRequired = true;
            }
            if(component.get("v.otherEmployeePricingChoice") == 'perCombination'){
                isOtherEmployeeRequired = true;
            }
            var data = component.get("v.data");
            
            $A.createComponent(
                "c:ET_MappingRow",
                {
                    "aura:id": "mappingRow",
                    data: component.get("v.allTabDataWithUpdatedUnitAvailableNo"),
                    serviceRequestRecordId :component.get("v.serviceRequestRecordId"),
                    isSupervisorRequired: isSupervisorRequired,
                    isCoordinatorRequired: isCoordinatorRequired,
                    isAccountantRequired: isAccountantRequired,
                    isOtherEmployeeRequired : isOtherEmployeeRequired,
                    isVehicleTabSelected: component.get("v.isVehicleTabSelected"),
                    isDriverTabSelected: component.get("v.isDriverTabSelected"),
                    isNanyTabSelected: component.get("v.isNanyTabSelected"),
                    isSupervisorTabSelected: component.get("v.isSupervisorTabSelected"),
                    isCoordinatorTabSelected: component.get("v.isCoordinatorTabSelected"),
                    isAccuntantTabSelected: component.get("v.isAccuntantTabSelected"),
                    isEmployeeTabSelected: component.get("v.isEmployeeTabSelected")
                },
                function(newcomponent) {
                    if (component.isValid()) {
                        var newCmp = component.find("cmpBody");
                        var body = newCmp.get("v.body");
                        body.push(newcomponent);
                        newCmp.set("v.body", body);
                        //component.set("v.addPricingComboBttnDisable", true);
                    }
                }
            );
        }
        
        
        
        
        //console.log(vehicleValues);
        
    },
    
    saveMapping: function(component, event, helper) {
        var status = component.get("v.serviceRequestModificationStatus");
        if(status == 'Success') {
            var errorOccured = false;
            var errorMessage = '';
            var errCmp = component.find("errMessage");
            if(errCmp != undefined){
                errCmp.set("v.message",errorMessage );
            }
            var mappingDataMap = new Map();
            var mappingRowCmp = component.find("mappingRow");
            var mappingDataLst =[];
            
            if(mappingRowCmp != undefined){
                
                if(mappingRowCmp.length == undefined){
                    if(!mappingRowCmp.get("v.isCombinationSaved")){
                        errorOccured = true;
                        errorMessage = 'Looks like combination didnt get saved. Try saving or deleting combination to proceed';
                    }else{
                        mappingDataLst.push(mappingRowCmp.get("v.mapping"));
                    }
                }
                else{
                    for(let singlemappingRowCmp of mappingRowCmp ){
                        if(!singlemappingRowCmp.get("v.isCombinationSaved")){
                            errorOccured = true;
                            errorMessage = 'Looks like 1 combination didnt get saved. Try saving or deleting that combination to proceed';
                        }else{
                            mappingDataLst.push(singlemappingRowCmp.get("v.mapping")); 
                        }
                    }
                }
            }
            else{
                //errorOccured = true;
                errorMessage = 'Looks like you forgot to add combination. Try adding 1 or more combinations to proceed';
                
            }
            
            if(errorOccured){
                var errCmp = component.find("errMessage");
                if(errCmp != undefined){
                    //errCmp.destroy();
                    errCmp.set("v.message",errorMessage );
                }else{
                    helper.createErrorCmp(component, errorMessage);
                }
                
            }
            else{
                
                if(mappingDataLst.length > 0){
                    mappingDataMap['mappingData'] = mappingDataLst;
                    if(component.get("v.supervisorPricingChoice")){
                        mappingDataMap['supervisorPricingChoice'] = component.get("v.supervisorPricingChoice");
                    }
                    if(component.get("v.coordinatorPricingChoice")){
                        mappingDataMap['coordinatorPricingChoice'] = component.get("v.coordinatorPricingChoice");
                    }
                    if(component.get("v.accountantPricingChoice")){
                        mappingDataMap['accountantPricingChoice'] = component.get("v.accountantPricingChoice");
                    }
                    if(component.get("v.otherEmployeePricingChoice")){
                        mappingDataMap['otherEmployeePricingChoice'] = component.get("v.otherEmployeePricingChoice");
                    }
                    var deletedComboIdsLst = component.get("v.deletedCombintaionIds");
                    if(deletedComboIdsLst){
                        mappingDataMap['CombinationsToDelete'] = deletedComboIdsLst;
                    }
                    helper.saveCombinationInfo(component,event,helper,mappingDataMap).then($A.getCallback(function(result){
                        component.set("v.disableQuoteBttn", false);
                        //component.set("v.disableCustomizePricingBttn",true);
                        var evCmp = component.getEvent("hideMappingModal");
                        evCmp.fire();
                        
                        
                    })).catch(function(err){
                        
                    })
                }
                else if(mappingDataLst.length == 0){
                    var deletedComboIdsLst = component.get("v.deletedCombintaionIds");
                    if(deletedComboIdsLst){
                        mappingDataMap['CombinationsToDelete'] = deletedComboIdsLst;
                    }
                     helper.saveCombinationInfo(component,event,helper,mappingDataMap).then($A.getCallback(function(result){
                        component.set("v.disableQuoteBttn", false);
                        //component.set("v.disableCustomizePricingBttn",true);
                        var evCmp = component.getEvent("hideMappingModal");
                        evCmp.fire();
                        
                        
                    })).catch(function(err){
                        
                    })
                    
                }
                
            }
        }
        else if(status == 'QuoteIsNotApprovedOrRejected'){
            alert('Operation is invalid, Active quote is still in approval process');
        }else if(status == 'SRIsInActive'){
            alert('Operation is invalid, Service Request is Inactive');
        }
        
        
    },
    
    handleSendDataEvent: function(component,event,helper){
        // var updatedData = component.get("v.allTabDataWithUpdatedUnitAvailableNo");
        var eventAction = event.getParam("action");
        var eventData = event.getParam("dataMap");
        var eventRecordId = event.getParam("mappingRowRecordIdUponDeletion");
        if(eventData != undefined && eventAction != undefined){
            component.set("v.allTabDataWithUpdatedUnitAvailableNo", eventData);
            //component.set("v.addPricingComboBttnDisable", false);
            if(eventAction == 'Save'){
                alert('combinaton saved successfully. proceed with adding more combination');
                return true;
            }else if(eventAction == 'Delete'){
                if(eventRecordId){
                    var deletedCmbosIdLst = component.get("v.deletedCombintaionIds");
                    deletedCmbosIdLst.push(eventRecordId);
                    component.set("v.deletedCombintaionIds", deletedCmbosIdLst);
                }
                var mappingRowCmp = component.find("mappingRow");
                /*if(mappingRowCmp != undefined && mappingRowCmp.length == 1){
            if(!mappingRowCmp.get("v.isDisable")){
              mappingRowCmp.set("v.data", component.get("v.allTabDataWithUpdatedUnitAvailableNo"));
              mappingRowCmp.updateAvailableNumberMessages();
            }
          }else*/ if(mappingRowCmp != undefined && mappingRowCmp.length > 1){
              for(let singlemappingRowCmp of mappingRowCmp ){
                  if(!singlemappingRowCmp.get("v.isDisable")){
                      singlemappingRowCmp.set("v.data", component.get("v.allTabDataWithUpdatedUnitAvailableNo"));
                      singlemappingRowCmp.updateAvailableNumberMessages();
                  }
              }
          }
            //$A.get('e.force:refreshView').fire();
            alert('combination deleted successfully');
            return true;
        }
         
     }
      return false;
      
  },
    
    setServiceRequestModificationStatus: function(component,event,helper){
        var params = event.getParam('arguments');
        if(params){
            var status = params.status;
            if(status){
                component.set("v.serviceRequestModificationStatus", status);
            }
        }
    }
});