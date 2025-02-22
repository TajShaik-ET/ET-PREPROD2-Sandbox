({
    doInit: function(component,event,helper){
        var otherCostObj = component.get("v.otherCostRecord");
		otherCostObj["ET_Other_Cost_Line_Number__c"] = component.get("v.lineNumber");
		component.set("v.otherCostRecord",otherCostObj);
        var existingLineData = component.get("v.existingLineData");
        if(existingLineData){
             component.set("v.otherCostRecord", existingLineData);
            if(existingLineData.ET_Cost_Type__c != null){
               var costTypeLst = existingLineData.ET_Cost_Type__c.split(',');
               component.set("v.costTypeValue", costTypeLst);
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