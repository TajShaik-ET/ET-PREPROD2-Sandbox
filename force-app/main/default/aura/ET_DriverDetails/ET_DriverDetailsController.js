({
	doInit : function(component, event, helper) {
        console.log('workForceRecord = '+ JSON.stringify(component.get("v.workForceRecord")));
		helper.getDriverDetails(component,event,helper);	
		var multipeList = component.get("v.multipleList");
		if(multipeList != undefined && multipeList!= null){
			for(var x in multipeList){
				if(multipeList[x] == "ET_Pricing_Method__c"){
					$A.util.removeClass(component.find("ET_Pricing_Utilization__c"), "slds-hide");
				}
				$A.util.removeClass(component.find(multipeList[x]), "slds-hide");
			}	
		}
		
		var driverObj = component.get("v.workForceRecord");
		driverObj["ET_Driver_Line__c"] = component.get("v.lineNumber");
		component.set("v.workForceRecord",driverObj);
        /* to set available driver lines
        var delayInMilliseconds = 1000;
                    window.setTimeout(
                        $A.getCallback(function() {
                            var cmpEvent = component.getEvent("getManpowerTabDetails"); 
                            cmpEvent.fire(); 
                        }), delayInMilliseconds
                    );  
        */
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
                $A.util.removeClass(priceUtilizationDiv,  'slds-hide');
                workForceDataObj.ET_Price_Utilization__c = 1;
                component.set("v.workForceRecord", workForceDataObj);
                component.set("v.disablePriceUtilization", true);
            }else{
                
                workForceDataObj.ET_Price_Utilization__c = null;
                component.set("v.workForceRecord", workForceDataObj);
                component.set("v.disablePriceUtilization", false);
                $A.util.removeClass(priceUtilizationDiv,  'slds-hide');
            }
            
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
                console.log('existingData 74= '+ JSON.stringify(existingData));
                if(existingData.ET_Special_Requirements__c == 'Yes'){
                    //component.set("v.displaySpecialRequirements", true);
                    //component.set("v.isSalaryDetailSet", true);
                    component.set("v.isExistingDataLoaded", true);
                    if(existingData.Specific_Workforce_Requirements__r){
                        component.set("v.existingDriverSpecialData", existingData.Specific_Workforce_Requirements__r[0]);
					}
                    else if(existingData.ET_Special_Workforce_Requirement__c){
                        component.set("v.existingDriverSpecialData", existingData.ET_Special_Workforce_Requirement__c);
                    }
                    if(existingData.Other_Cost_Requests__r){
                        component.set("v.existingDriverOtherCosts", existingData.Other_Cost_Requests__r);
                    }
                    else if(existingData.ET_Other_Cost_Request__c){
                        component.set("v.existingDriverOtherCosts", existingData.ET_Other_Cost_Request__c);
                    }
					
				}
                component.set("v.workForceRecord", existingData );
			}
		}
	},
    

	doRefresh: function(component,event,helper){

		//var commonWorkforceDetailCmp = component.find("");
		var childCmpId = event.getParam('childCmpAuraId');
        if(childCmpId){
			if(childCmpId == 'driverSpecialRequirements'){
				var cmp = component.find(childCmpId);
                console.log('cmp 90 == '+ JSON.stringify(cmp));
                if(cmp){
                    if(cmp.length && cmp.length == 1){
                        cmp = cmp[0];
                    }
                }
				cmp.prePopulateCommonWorkforceData(component.get("v.existingDriverSpecialData"));
                if(component.get("v.existingDriverOtherCosts")){
                    for(var otherCost of component.get("v.existingDriverOtherCosts")){
                        helper.handleAddOtherCostHelper(component,otherCost);
                    }
                }
			}
		}
	},
    
    
    handleAddOtherCostMore: function(component,event,helper){
        if(helper.validateOtherCostFieldsPerTab(component,event,helper) ||  component.find("driverOtherCostCmp") == undefined){
            helper.handleAddOtherCostHelper(component,null);
        }
        	
    },
    
    loadSpecialRequirementDetails : function(component,event,helper){
        var record = component.get("v.workForceRecord");
        component.set("v.isSalaryDetailSet", false);
        if(record && record.ET_Driver_Category__c){
            var masterData = component.get("v.driverMasterDataMap");
            if(masterData && masterData[record.ET_Driver_Category__c]){
                component.set("v.driverSalaryDetailMap", masterData[record.ET_Driver_Category__c]);
                component.set("v.displaySpecialRequirements",true);
                component.set("v.isSalaryDetailSet", true);
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
    
    // to set available driver lines
    getDriverTabDetailsController : function(component, event, helper) {
        helper.getDriverTabDetailsHelper(component, event, helper);
    },
})