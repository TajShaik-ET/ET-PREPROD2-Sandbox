({
	doInit : function(component, event, helper) {
		helper.getvehicleDetails(component,event,helper);
        helper.getOpportunityDetails(component,event,helper);
		var multipeList = component.get("v.multipleList");
		if(multipeList != undefined && multipeList!= null){
			for(var x in multipeList){
				if(multipeList[x] == "ET_Pricing_Method__c"){
					$A.util.removeClass(component.find("ET_Pricing_Utilization__c"), "slds-hide");
				}
				$A.util.removeClass(component.find(multipeList[x]), "slds-hide");
			}	
		}
		//SK-
        console.log('OpprecordTypeName: '+component.get("v.OpprecordTypeName"));
        if(component.get("v.OpprecordTypeName")=='Leasing/ Rental'){
            //var fieldDivCmp = component.find("VehicleNoOfSeatsdiv");
            //$A.util.addClass(fieldDivCmp, 'slds-hide');
            var CurrentYear = new Date().getFullYear();
           // var currentYearString = currentYear.toString();
            var vehicleObj = component.get("v.vehicleLine");
           
            vehicleObj["ET_Vehicle_Line__c"] = component.get("v.lineNumber");
            vehicleObj["ET_Service_Type__c"] = component.get("v.SetServicetype");
            vehicleObj["ET_Fuel_Type__c"] = component.get("v.SetFuelType");
            vehicleObj["ET_Vehicle_Model_Year__c"] = component.get("v.SetNewVehicleModel");;
            vehicleObj["ET_Number_of_seats__c"] = component.get("v.SetNumberofseats");

            component.set("v.vehicleLine",vehicleObj);
            console.log('inside getOpprecordTypeName of ET_VehicleDetails in doinit of vehicleLine : '+JSON.stringify(component.get("v.vehicleLine")));
        }else{
            var vehicleObj = component.get("v.vehicleLine");
            vehicleObj["ET_Vehicle_Line__c"] = component.get("v.lineNumber");
            component.set("v.vehicleLine",vehicleObj);
        }
	},
    
    onServiceTypeChange : function(component, event, helper) {
        var serviceType = component.get("v.vehicleLine").ET_Service_Type__c;
        if(serviceType  == 'Logistic Services' ||  serviceType  == 'Ambulance Service'){
            component.set("v.showtrailerAndRefrigerator",true);
        }
        else{
            component.set("v.showtrailerAndRefrigerator",false);
        }
    },
    getvehicleModels:  function(component, event, helper) {
		helper.getvehicleModels(component, event, helper);
	},
	getvehicleSpecs:  function(component, event, helper) {
		helper.getvehicleSpecs(component, event, helper);
	},
    
    getVehicleSubTypesController : function(component, event, helper) {
		helper.getVehicleSubTypesControllerHelper(component, event, helper);
	},
  

    getVehicleFuelTypesController : function(component, event, helper) {
		helper.getFuelTypes(component, event, helper);
	},

	
	displaySpecialRequirementsSection : function(component, event, helper) {
		
		var elementId = event.getSource().getLocalId();
        console.log(elementId);
        console.log('From Aura Id ',component.find(elementId).get("v.value"));
        var picklistValue = component.find(elementId).get("v.value");
		if(picklistValue == 'Yes'){
			component.set("v.displaySpecialRequirements",true);
		}else{
			component.set("v.displaySpecialRequirements",false);
		}
	},
	updateCommonFields : function(component, event, helper) {
	//	alert('Updating common Fields');
		
	},
	updateVehicleFuelInformation : function(component, event, helper) {
		helper.updateVehicleFuelInformationHelper(component, event, helper);
	},

	handleChangeInPriceMethod: function(component,event,helper){
        var dependentValueMap = component.get("v.pricingMethodAndDependentTypeMap");
        var priceMethodValue = component.get("v.vehicleLine").ET_Pricing_Method__c;
        component.set("v.pricingTypes", dependentValueMap[priceMethodValue]);

	},
    
    handleOriginalPurchasePriceChange : function(component,event,helper){
        var vehicleCondition = component.get("v.vehicleLine").ET_Vehicle_Condition__c;
        var originalPurchasePrice = component.get("v.vehicleLine").ET_Vehicle_Original_Purchase_Price__c;
        if(vehicleCondition == 'New'){
             component.set("v.vehicleLine.ET_Vehicle_Current_Purchase_Price__c", originalPurchasePrice);
        }
    },
    
    handleOriginalPurchasePriceChangeInTrailer : function(component,event,helper){
        var trailerCondition = component.get("v.vehicleLine").Trailer_condition__c;
        var originalPurchasePrice = component.get("v.vehicleLine").Trailer_original_purchase_price__c;
        if(trailerCondition == 'New'){
             component.set("v.vehicleLine.Trailer_Current_purchase_price__c", originalPurchasePrice);
        }
    },
    
     handleOriginalPurchasePriceChangeInRefrigerator : function(component,event,helper){
        var refrigeratorCondition = component.get("v.vehicleLine").Refrigerator_condition__c;
        var originalPurchasePrice = component.get("v.vehicleLine").Refrigerator_original_purchase_price__c;
        if(refrigeratorCondition == 'New'){
             component.set("v.vehicleLine.Refrigerator_Current_purchase_price__c", originalPurchasePrice);
        }
    },
	
    handleChangeInPriceType: function(component,event,helper){
        var vehicleDataObj = component.get("v.vehicleLine")
        var pricingTypeValue = vehicleDataObj.ET_Pricing_Type__c;
        if(pricingTypeValue ){
            var priceUtilizationDiv = component.find("ET_Pricing_Utilization__c");
            if(pricingTypeValue == 'Annual Price'){
                $A.util.removeClass(priceUtilizationDiv,  'slds-hide');
                vehicleDataObj.ET_Price_Utilization__c = 1;
                component.set("v.vehicleLine", vehicleDataObj);
                component.set("v.disablePriceUtilization", true);
            }else{
                vehicleDataObj.ET_Price_Utilization__c = null;
                component.set("v.vehicleLine", vehicleDataObj);
                component.set("v.disablePriceUtilization", false);
                $A.util.removeClass(priceUtilizationDiv,  'slds-hide');
            }
            
        }
    },

	handleVehicleConditionChange: function(component,event,helper){
		var vehicleModalYearOptionLst = component.get("v.vehicleModelYearOriginalLst");
		var vehicleCondition = component.get("v.vehicleLine").ET_Vehicle_Condition__c;
		var updatedYearOptionLst;
		var optionLstSize = vehicleModalYearOptionLst.length;
		if(vehicleModalYearOptionLst != undefined && optionLstSize != undefined && optionLstSize > 1){
			if(vehicleCondition == 'New'){ 
				var vehicleModalYearfrmMasterData = vehicleModalYearOptionLst[optionLstSize -1];
				var currentYear = new Date().getFullYear();
				if((currentYear - vehicleModalYearfrmMasterData) > 3){
					var errorMessage = 'Modal year not found according to Vehicle Condition. Please contact Administrator to correct this Vehicle Master Data';
					helper.throwError(component,event,helper,errorMessage);
				}else{
					updatedYearOptionLst = [];
					for(var i=3; i > -1 ; i--){
						updatedYearOptionLst.push(currentYear - i);
					}
				}
				
				
			}else if(vehicleCondition == 'Used'){
				var errorCmp = component.find("generatedErrorCmp");
				if(errorCmp!= undefined){
					errorCmp.destroy();
				}
				updatedYearOptionLst = [];
				updatedYearOptionLst =  component.get("v.vehicleModelYearOriginalLst");
			}		
			component.set("v.vehicleModelYear",updatedYearOptionLst);
		}
	},

	setAlreadyStoredData: function(component,event,helper){
		var params = event.getParam('arguments');
        if(params){
            var existingData = params.vehicleDataToBeSet;
            console.log('existingData>> '+JSON.stringify(existingData));
            if(existingData != undefined ){
                component.set("v.isSettingAlreadyStoredData", true);
				if(existingData.ET_Contract_Period__c != undefined){
					var contractPeriodLst = existingData.ET_Contract_Period__c.toString().split(',');
					component.set("v.contractValue", contractPeriodLst);
				}
                var selectedTrailerOrRefrigeratorList =[];
                if(existingData.Add_Trailer_Equipment__c == true){
                    selectedTrailerOrRefrigeratorList.push('Trailer/Equipment');
                    component.set('v.showTraileRequirement', true);
                }
                if(existingData.Add_Refregirator__c == true){
                    selectedTrailerOrRefrigeratorList.push('Refrigerator');
                    component.set('v.showRefrigeratorRequirement', true);
                }
                component.set("v.selectedTrailerOrRefrigerator", selectedTrailerOrRefrigeratorList);
                component.set("v.vehicleLine", existingData );
                helper.getvehicleModels(component, event, helper).then(
                    $A.getCallback(function(result) {
                        component.set("v.vehicleLine", existingData );
                        helper.getVehicleSubTypesControllerHelper(component, event, helper).then(
                            $A.getCallback(function(result) {
                                component.set("v.vehicleLine", existingData );
                                helper.getFuelTypes(component, event, helper).then(
                                    $A.getCallback(function(result) {
                                        component.set("v.vehicleLine", existingData );
                                    })
                                )
                            })
                        )
                    })
                )
                
               helper.updateVehicleFuelInformationHelper(component, event, helper);
				if(existingData.ET_Specific_requirements__c == 'Yes'){
					component.set("v.displaySpecialRequirements", true);
                    
                    if(existingData.Other_Cost_Requests__r && existingData.Other_Cost_Requests__r.length > 0){
                        console.log('other cost>> '+JSON.stringify(existingData.Other_Cost_Requests__r));
                        //component.set("v.existingVehicleOtherCosts", existingData.Other_Cost_Requests__r);
                        var predefinedOtherCost=[];
                        var selectedOtherCosts=[];
                        for(var otherCost of existingData.Other_Cost_Requests__r){
                            if(otherCost.Other_Cost_Type__c=='Dynamic')
                            	helper.handleAddOtherCostHelper(component,otherCost);
                            else if(otherCost.Other_Cost_Type__c=='Predefined'){
                                predefinedOtherCost.push(otherCost);
                                helper.handleOtherVehicleReqHelper(component,otherCost);
                                selectedOtherCosts.push(otherCost.Other_Requirement_API_Name__c);
                            }
                        }
                        if(predefinedOtherCost.length>0 && selectedOtherCosts.length>0){
                            component.set("v.selectedOtherCostSpecReqLst",selectedOtherCosts);
                            component.set("v.otherVehicleReqRecords",predefinedOtherCost);
                            //mani-commented
                            //component.set('v.showOtherVehicleRequirements', true);
                            console.log('selectedOtherCosts>> '+JSON.stringify(selectedOtherCosts));
                        }
                    }
                    
                    else if(existingData.ET_Other_Cost_Request__c && existingData.ET_Other_Cost_Request__c.length > 0){
                        console.log('other cost>> '+JSON.stringify(existingData.ET_Other_Cost_Request__c));
                        var predefinedOtherCost=[];
                        var selectedOtherCosts=[];
                        for(var otherCost of existingData.ET_Other_Cost_Request__c){
                            if(otherCost.Other_Cost_Type__c=='Dynamic')
                                helper.handleAddOtherCostHelper(component,otherCost);
                            else if(otherCost.Other_Cost_Type__c=='Predefined'){
                                predefinedOtherCost.push(otherCost);
                                helper.handleOtherVehicleReqHelper(component,otherCost);
                                selectedOtherCosts.push(otherCost.Other_Requirement_API_Name__c);
                            }
                        }
                        if(predefinedOtherCost.length>0 && selectedOtherCosts.length>0){
                            component.set("v.selectedOtherCostSpecReqLst",selectedOtherCosts);
                            component.set("v.otherVehicleReqRecords",predefinedOtherCost);
                            //mani-commented
                            //component.set('v.showOtherVehicleRequirements', true);
                            console.log('selectedOtherCosts>> '+JSON.stringify(selectedOtherCosts));
                        }
                    }
                }
			}
		}
	},
    
    handleAddOtherCostMore: function(component,event,helper){
         if(helper.validateOtherCostFieldsPerTab(component,event,helper) ||  component.find("vehicleOtherCostCmp") == undefined){
            helper.handleAddOtherCostHelper(component,null);
        }
         
    },
    showAlterRates: function(component, event, helper) {
		component.set('v.showAlterRates', true);
	},
    itemsChange: function(component, event, helper){
    	var compEvent = component.getEvent("alterRateEvent");
        compEvent.setParams({
            "alterRatesObj" : component.get("v.alterRatesObj") 
        });
        compEvent.fire();
	},
    doAlterRates: function(component, event, helper){
        var params = event.getParam('arguments');
        if (params) {
            component.set('v.alterRatesObj', params.alterRatesObj1);
        }
    },
    
    setQuoteIdFromParentTab : function(component, event, helper){
        var params = event.getParam('arguments');
        if (params) {
            component.set('v.quoteId', params.quoteId);
        }
    },
    
    handleOtherVehicleReqChange: function(component, event, helper){
		var selectedOtherReq= component.get("v.otherVehicleReqRecords");
        var otherVehicleReqNames=event.getParam('value');
        let uncheckIndex;
        console.log('selectedOtherReq>> ',JSON.stringify(selectedOtherReq));
        console.log('otherVehicleReqNames>> ',JSON.stringify(otherVehicleReqNames));
        if(selectedOtherReq.length!= undefined && selectedOtherReq.length>0){
            for (var i = 0; i < selectedOtherReq.length; i++) {
                if(!otherVehicleReqNames.includes(selectedOtherReq[i].Other_Requirement_API_Name__c)){
                    uncheckIndex= i;
                    component.set("v.removePredefinedOtherCost",selectedOtherReq[i].Other_Requirement_API_Name__c);
                    $A.util.toggleClass(component.find('ConfirmDialog2'), 'slds-hide');
                    break;
                }
            }
        }
        console.log('uncheckIndex>> ',uncheckIndex);
        if (uncheckIndex!=undefined && uncheckIndex > -1) {
            var selectedOtherReq1=[];
            for (var i = 0; i < selectedOtherReq.length; i++) {
                if(otherVehicleReqNames.includes(selectedOtherReq[i].Other_Requirement_API_Name__c)){
                    selectedOtherReq1.push(selectedOtherReq[i]);
                }
            }
            selectedOtherReq=selectedOtherReq1;
            console.log('selectedOtherReq1>> ',JSON.stringify(selectedOtherReq1));
        }else {
            otherVehicleReqNames.map(function(item) {
                let index;
                let flag;
                for (var i = 0; i < selectedOtherReq.length; i++) {
                    if(selectedOtherReq[i].Other_Requirement_API_Name__c==item){
                        flag=true;
                        break;
                    }else {
                        flag=false;
                    }
                }
                if(!flag){
                    var reqRecord = new Object();
                    reqRecord.sObjectType="ET_Other_Cost_Request__c";
                    if(item.includes('ET_')){
                        reqRecord.Name= item.split('ET_').join('');
                        reqRecord.Name= reqRecord.Name.split('_').join(' ');
                    }
                    reqRecord.Other_Requirement_API_Name__c=item.split('__c').join('');
                    reqRecord.ET_Cost_Value__c=null;
                    reqRecord.ET_Cost_Type__c="";
                    helper.handleOtherVehicleReqHelper(component,reqRecord);
                    selectedOtherReq.push(reqRecord);
                } 
            });
		}
        console.log('selectedOtherReq2>> ',JSON.stringify(selectedOtherReq));
        component.set('v.otherVehicleReqRecords', selectedOtherReq);
    },
    
    handleSelectionOfTrailerOrRefrigerator : function(component, event, helper){
        var selectedValue=event.getParam('value');
        debugger;
        console.log('selectedValue  = '+ selectedValue);
        if(selectedValue == "Trailer/Equipment"){
            component.set('v.showTraileRequirement', true);
            component.set('v.vehicleLine.Add_Trailer_Equipment__c', true);
            //make Refrigerator fields false
            component.set('v.showRefrigeratorRequirement', false);
            component.set('v.vehicleLine.Add_Refregirator__c', false);
        }
        if(selectedValue == "Refrigerator"){
            component.set('v.showRefrigeratorRequirement', true);
            component.set('v.vehicleLine.Add_Refregirator__c', true);
            //make trailer fields false
            component.set('v.showTraileRequirement', false);
            component.set('v.vehicleLine.Add_Trailer_Equipment__c', false);
        }
        if(selectedValue.includes("Refrigerator") && selectedValue.includes("Trailer/Equipment")){
            component.set('v.showRefrigeratorRequirement', true);
            component.set('v.vehicleLine.Add_Refregirator__c', true);
            component.set('v.showTraileRequirement', true);
            component.set('v.vehicleLine.Add_Trailer_Equipment__c', true);
        }
        if(selectedValue == null || selectedValue == '' || selectedValue == undefined ){
            component.set('v.showRefrigeratorRequirement', false);
            component.set('v.vehicleLine.Add_Refregirator__c', false);
            component.set('v.showTraileRequirement', false);
            component.set('v.vehicleLine.Add_Trailer_Equipment__c', false);
        }
    },
    handleNo:function(component, event, helper){
        $A.util.toggleClass(component.find('ConfirmDialog2'), 'slds-hide');
    },
    handleYes:function(component, event, helper){
        $A.util.toggleClass(component.find('ConfirmDialog2'), 'slds-hide');
        var selectedOtherReq= component.get("v.otherVehicleReqRecords");
        var removePredefinedOtherCost= component.get("v.removePredefinedOtherCost");
        var childComponent =component.find('vehicleReqCmp');
        if(childComponent.length != undefined){
            for(var child of childComponent){
                console.log('getLocalId iff:: ',child.getLocalId());
                if(child.get("v.predefinedOtherCostRecord").Other_Requirement_API_Name__c==removePredefinedOtherCost){
                    if(child.get("v.predefinedOtherCostRecord").Id){
                        var deletedotherCostEvt = component.getEvent("deletedOtherCostsIdsEvt");
                        deletedotherCostEvt.setParams(
                            {"tabName" :  child.getLocalId(),
                             "otherCostObjId" : child.get("v.predefinedOtherCostRecord").Id});
                        deletedotherCostEvt.fire();
                    }
                    child.destroy();
                }
            } 
        }else if(childComponent.length == undefined){
            var childComponent =component.find('vehicleReqCmp');
            var existingData = childComponent.get("v.predefinedOtherCostRecord");
            if(existingData && existingData.Id){
                var deletedotherCostEvt = component.getEvent("deletedOtherCostsIdsEvt");
                deletedotherCostEvt.setParams(
                    {"tabName" :  childComponent.getLocalId(),
                     "otherCostObjId" : existingData.Id});
                deletedotherCostEvt.fire();
            } 
            childComponent.destroy();
        }
    },

    //Taj
    warningVehicleQuantityChange: function (component, event, helper) {
        helper.showToast(component, event, helper, 'Warning', 'Updating the quantity will result in the deletion of the combination.', 'warning', 'pester');
    },

    handleVehicleQuantityChange: function (component, event, helper) {
        component.set("v.changeInVehicleQuantity", true);
        const message = {
            changeInVehicleQuantity: true
        };
        component.find("changeInQuantityLMS").publish(message);
    },
		
})