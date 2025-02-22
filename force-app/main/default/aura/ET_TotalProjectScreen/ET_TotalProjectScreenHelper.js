({
    getToTalProjectCalculationData : function(component,evet,helper){
        var action = component.get("c.populateTotalProjectScreenData");
        action.setParams({
            'quoteId': component.get('v.quoteId')
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
             if (state === "SUCCESS"){
                var response=a.getReturnValue();
                console.log('response '+response);
                if(response!=null && response!=undefined){
                   // component.set("v.wrokforceCalcDetails",response.lstQuoteCalcDetails);
                    helper.getPageData (component,event,helper, response);
                    console.log('response ' + JSON.stringify(response));
                    }else{
                        console.log('response is null');
                    }
    
            }
        });
        $A.enqueueAction(action);

    },

    getPageData: function(component,event,helper,response){
        if(response.totalProjectCostCalculationLst != null && response.totalProjectCostCalculationLst.length > 0){
            component.set("v.costCalculations", response.totalProjectCostCalculationLst);
           /* for(var value of response.totalProjectCostCalculationLst){
                if(value.contractYear == 1){
                    component.set("v.CostCalculationYear1", value);
                }else if(value.contractYear == 2){
                    component.set("v.CostCalculationYear2", value);
                }else if(value.contractYear == 3){
                    component.set("v.CostCalculationYear3", value);
                }else if(value.contractYear == 4){
                    component.set("v.CostCalculationYear4", value);
                }else if(value.contractYear == 5){
                    component.set("v.CostCalculationYear5", value);
                }else if(value.contractYear == 6){
                    component.set("v.CostCalculationYear6", value);
                }else if(value.contractYear == 7){
                    component.set("v.CostCalculationYear7", value);
                }else if(value.contractYear == 8){
                    component.set("v.CostCalculationYear8", value);
                }
            }*/
        }

        if(response.totalProjectProfitValueLst != null && response.totalProjectProfitValueLst.length > 0){
            component.set("v.ProfitValueCalculations", response.totalProjectProfitValueLst);
        }

        if(response.totalProjectProfitRateLst != null && response.totalProjectProfitRateLst.length > 0){
            component.set("v.ProfitRateCalculations", response.totalProjectProfitRateLst);
        }

        if(response.totalProjectPaybackValueLst != null && response.totalProjectPaybackValueLst.length > 0){
            component.set("v.PaybackValueCalculations", response.totalProjectPaybackValueLst);
        }

        if(response.totalProjectPaybackAnalysisLst != null && response.totalProjectPaybackAnalysisLst.length > 0){
            component.set("v.PaybackAnalysisCalculations", response.totalProjectPaybackAnalysisLst);
        }


    }
    
})