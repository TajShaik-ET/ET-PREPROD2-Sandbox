({
	doInit: function(component,event,helper){
		var multipeList = component.get("v.multipleList");
		 
		if(multipeList != undefined && multipeList!= null){
	
			for(var x in multipeList){

				if(multipeList[x] == "ET_Pricing_Method__c"){
					$A.util.toggleClass(component.find("ET_Pricing_Utilization__c"), "slds-hide");
				}
				$A.util.toggleClass(component.find(multipeList[x]), "slds-hide");
			}	
		}
		var otherEmpObj = component.get("v.workForceRecord");
		otherEmpObj["ET_OtherEmployee_Line__c"] = component.get("v.lineNumber");
		component.set("v.workForceRecord",otherEmpObj);
		helper.getEmployeeDetails(component,event,helper);
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

	handleChangeInPriceMethod: function(component,event,helper){
        var dependentValueMap = component.get("v.pricingMethodAndDependentTypeMap");
        var priceMethodValue = component.get("v.workForceRecord").ET_Pricing_Method__c;
        component.set("v.pricingTypes", dependentValueMap[priceMethodValue]);
	},
	
	handleChangeInPriceType: function(component,event,helper){
		var workForceDataObj = component.get("v.workForceRecord")
		var pricingTypeValue = workForceDataObj.ET_Pricing_Type__c;
	   if(pricingTypeValue ){
           var priceUtilizationDiv = component.find("ET_Pricing_Utilization__c");
		   if(pricingTypeValue == 'Annual Price'){
			workForceDataObj.ET_Price_Utilization__c = 1;
			   component.set("v.workForceRecord", workForceDataObj);
			   component.set("v.disablePriceUtilization", true);
		   }else{
			workForceDataObj.ET_Price_Utilization__c = null;
			   component.set("v.workForceRecord", workForceDataObj);
			   component.set("v.disablePriceUtilization", false);
		   }
            $A.util.removeClass(priceUtilizationDiv,  'slds-hide');
		   
	   }
	},

	setAlreadyStoredData: function(component,event,helper){
		var params = event.getParam('arguments');
        if(params){
            var existingData = params.manpowerDataToBeSet;
            if(existingData != undefined ){
				if(existingData.ET_Contract_Period__c != undefined){
					var contractPeriodLst = existingData.ET_Contract_Period__c.toString().split(',');
					component.set("v.contractValue", contractPeriodLst);
				}
				component.set("v.workForceRecord", existingData );
				if(existingData.ET_Special_Requirements__c == 'Yes'){
					component.set("v.displaySpecialRequirements", true);
                    component.set("v.isSalaryDetailSet", true); //Mani
					if(existingData.Specific_Workforce_Requirements__r){
						component.set("v.existingOtherEmpSpecialData", existingData.Specific_Workforce_Requirements__r[0]);
					}
                     if(existingData.Other_Cost_Requests__r){
                        component.set("v.existingOtherEmployeeOtherCosts", existingData.Other_Cost_Requests__r);
                    }
					
				}
			}
		}
	},

	doRefresh: function(component,event,helper){

		//var commonWorkforceDetailCmp = component.find("");
		var childCmpId = event.getParam('childCmpAuraId');
        if(childCmpId){
			if(childCmpId == 'otherEmployeeSpecialRequirements'){
				var cmp = component.find(childCmpId);
                if(cmp){
                    if(cmp.length && cmp.length == 1){
                        cmp = cmp[0];
                    }
                }
				cmp.prePopulateCommonWorkforceData(component.get("v.existingOtherEmpSpecialData"));
                if(component.get("v.existingOtherEmployeeOtherCosts")){
                    for(var otherCost of component.get("v.existingOtherEmployeeOtherCosts")){
                        helper.handleAddOtherCostHelper(component,otherCost);
                    }
                }
			}
		}
	},
    
    handleAddOtherCostMore: function(component,event,helper){
        if(helper.validateOtherCostFieldsPerTab(component,event,helper) ||  component.find("otherEmpOtherCostCmp") == undefined){
            helper.handleAddOtherCostHelper(component,null);
        }
        
    },
    
    loadSpecialRequirementDetails : function(component,event,helper){
        var record = component.get("v.workForceRecord");
        component.set("v.isSalaryDetailSet", false);
        if(record && record.ET_Other_employee_Category__c){
            var masterData = component.get("v.otherEmployeeMasterDataMap");
            if(masterData && masterData[record.ET_Other_employee_Category__c]){
                var salaryMap = masterData[record.ET_Other_employee_Category__c];
                component.set("v.otherEmployeeSalaryDetailMap", salaryMap);
                component.set("v.isSalaryDetailSet", true);
                component.set("v.displaySpecialRequirements",true);
                component.set("v.workForceRecord.ET_Special_Requirements__c", 'Yes');
            }
        }
    },
    showAlterRates: function(component, event, helper) {
		component.set('v.showAlterRates', true);
	},
    doAlterRates: function(component, event, helper){
        var params = event.getParam('arguments');
        if (params) {
            component.set('v.alterRatesObj', params.alterRatesObj1);
        }
    },
})