({
    getvehicleCalcDetails : function (component,event,helper) {
        component.set('v.loaded', !component.get('v.loaded'));
        var action = component.get("c.ET_getvehicleCalcDetails");
        action.setParams({
            'quoteId': component.get('v.quoteId')
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
             if (state === "SUCCESS"){
                 component.set('v.loaded', !component.get('v.loaded'));
                var response=a.getReturnValue();
                console.log('response '+response);
                if(response!=null && response!=undefined){
                    var jsonResponse = JSON.parse(response);
                    console.log(JSON.stringify(jsonResponse));
                    component.set('v.totalLines',jsonResponse.noOfVehicleLinesInRequest);
                    component.set('v.isTargetPriceRequired',jsonResponse.quoteDetailsWrapper.isTargetPriceRequired);
                    component.set('v.quotetype',jsonResponse.quoteDetailsWrapper.quotetype);
                    component.set('v.totalNumberOfVehicles',jsonResponse.quoteDetailsWrapper.totalNumberOfVehicles);
                    component.set('v.totalNumberOfDrivers',jsonResponse.quoteDetailsWrapper.totalNumberOfDrivers);
                    component.set('v.totalNumberOfNannies',jsonResponse.quoteDetailsWrapper.totalNumberOfNannies);
                    component.set('v.totalNumberOfAccountants',jsonResponse.quoteDetailsWrapper.totalNumberOfAccountants);
                    component.set('v.totalNumberOfCoordinators',jsonResponse.quoteDetailsWrapper.totalNumberOfCoordinators);
                    component.set('v.totalNumberOfSupervisors',jsonResponse.quoteDetailsWrapper.totalNumberOfSupervisors);
                    console.log('vehicleCalcDetails  = '+ JSON.stringify(jsonResponse.vehicleQuoteWrapper));
                    component.set("v.vehicleCalcDetails",jsonResponse.vehicleQuoteWrapper);
                    console.log('vehicleApprovalDetails  = '+ JSON.stringify(jsonResponse.vehicleApprovalDetailsWrp));
                    component.set('v.vehicleApprovalDetails',jsonResponse.vehicleApprovalDetailsWrp);
                    helper.getPageData (component,event,helper,1);
                }else{
                    console.log('response is null');
                }
            }
            else if(state === "ERROR"){
                component.set('v.loaded', !component.get('v.loaded'));
                alert('Internal Error. Please Try again or Contact System Admin.');
            }
        });
        $A.enqueueAction(action);
    },
    resetAllLines:  function (component,event,helper) {
        component.set("v.vehicleLine1",null);
        component.set("v.vehicleLine2",null);
        component.set("v.vehicleLine3",null);
        component.set("v.vehicleLine4",null);
        component.set("v.vehicleLine5",null);
        component.set("v.vehicleLine6",null);
        component.set("v.vehicleLine7",null);
        component.set("v.vehicleLine8",null);
        //component.set("v.vehicleLine9",null);
    },
    getPageData:  function (component,event,helper,lineNo) {
        component.set('v.lineNo',lineNo);
        for(var vehicleLine of component.get('v.vehicleCalcDetails')){
            if(vehicleLine.contractYear==1 && vehicleLine.vehicleLineItemNumberFromRequest==lineNo){
                component.set("v.vehicleLine1",vehicleLine);
                component.set("v.noOfVehiles",vehicleLine.numberOfVehicles);
                component.set("v.VehcType",vehicleLine.vehicleLineUniqueKey);
                component.set("v.VehSource",vehicleLine.vehicleSource);
                component.set("v.serviceType",vehicleLine.serviceType);
                helper.setSpcialRequirementLabelsLst(component,vehicleLine);
            }else if(vehicleLine.contractYear==2 && vehicleLine.vehicleLineItemNumberFromRequest==lineNo){
                component.set("v.vehicleLine2",vehicleLine);
                component.set("v.noOfVehiles",vehicleLine.numberOfVehicles);
                component.set("v.VehcType",vehicleLine.vehicleLineUniqueKey);
                component.set("v.VehSource",vehicleLine.vehicleSource);
                component.set("v.serviceType",vehicleLine.serviceType);
                helper.setSpcialRequirementLabelsLst(component,vehicleLine);
            }else if(vehicleLine.contractYear==3 && vehicleLine.vehicleLineItemNumberFromRequest==lineNo){
                component.set("v.vehicleLine3",vehicleLine);
                component.set("v.noOfVehiles",vehicleLine.numberOfVehicles);
                component.set("v.VehcType",vehicleLine.vehicleLineUniqueKey);
                component.set("v.VehSource",vehicleLine.vehicleSource);
                component.set("v.serviceType",vehicleLine.serviceType);
                helper.setSpcialRequirementLabelsLst(component,vehicleLine);
            }else if(vehicleLine.contractYear==4 && vehicleLine.vehicleLineItemNumberFromRequest==lineNo){
                component.set("v.vehicleLine4",vehicleLine );
                component.set("v.noOfVehiles",vehicleLine.numberOfVehicles);
                component.set("v.VehcType",vehicleLine.vehicleLineUniqueKey);
                component.set("v.VehSource",vehicleLine.vehicleSource);
                component.set("v.serviceType",vehicleLine.serviceType);
                helper.setSpcialRequirementLabelsLst(component,vehicleLine);
            }else if(vehicleLine.contractYear==5 && vehicleLine.vehicleLineItemNumberFromRequest==lineNo){
                component.set("v.vehicleLine5",vehicleLine);
                component.set("v.noOfVehiles",vehicleLine.numberOfVehicles);
                component.set("v.VehcType",vehicleLine.vehicleLineUniqueKey);
                component.set("v.VehSource",vehicleLine.vehicleSource);
                component.set("v.serviceType",vehicleLine.serviceType);
                helper.setSpcialRequirementLabelsLst(component,vehicleLine);
            }else if(vehicleLine.contractYear==6 && vehicleLine.vehicleLineItemNumberFromRequest==lineNo){
                component.set("v.vehicleLine6",vehicleLine);
                component.set("v.noOfVehiles",vehicleLine.numberOfVehicles);
                component.set("v.VehcType",vehicleLine.vehicleLineUniqueKey);
                component.set("v.VehSource",vehicleLine.vehicleSource);
                component.set("v.serviceType",vehicleLine.serviceType);
                helper.setSpcialRequirementLabelsLst(component,vehicleLine);
            }else if(vehicleLine.contractYear==7 && vehicleLine.vehicleLineItemNumberFromRequest==lineNo){
                component.set("v.vehicleLine7",vehicleLine);
                component.set("v.noOfVehiles",vehicleLine.numberOfVehicles);
                component.set("v.VehcType",vehicleLine.vehicleLineUniqueKey);
                component.set("v.VehSource",vehicleLine.vehicleSource);
                component.set("v.serviceType",vehicleLine.serviceType);
                helper.setSpcialRequirementLabelsLst(component,vehicleLine);
            }else if(vehicleLine.contractYear==8 && vehicleLine.vehicleLineItemNumberFromRequest==lineNo){
                component.set("v.vehicleLine8",vehicleLine);
                component.set("v.noOfVehiles",vehicleLine.numberOfVehicles);
                component.set("v.VehcType",vehicleLine.vehicleLineUniqueKey);
                component.set("v.VehSource",vehicleLine.vehicleSource);
                component.set("v.serviceType",vehicleLine.serviceType);
                helper.setSpcialRequirementLabelsLst(component,vehicleLine);
            }
        }
    },

    setSpcialRequirementLabelsLst : function(component,vehicleLine){
        var specialReqLabelLst = [];
        
        if(vehicleLine.vehicleSpecialRequirementLst.length > 0){
            for(var specReq of vehicleLine.vehicleSpecialRequirementLst){
                specialReqLabelLst.push(specReq['specificRequirementLabel']);
               
            }
            component.set("v.spcialRequirementLabelsLst", specialReqLabelLst);
          
            console.log(JSON.stringify(specialReqLabelLst));
        }
    }
})