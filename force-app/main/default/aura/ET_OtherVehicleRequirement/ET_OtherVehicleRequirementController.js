({
	doInit : function(component, event, helper) {
		var existingData = component.get("v.existingData");
         if(existingData){
            component.set("v.predefinedOtherCostRecord", existingData);
            var costTypeArray =[];
            if(existingData.ET_Cost_Type__c && typeof existingData.ET_Cost_Type__c == 'object'){
                let listArray = String(existingData.ET_Cost_Type__c);
                costTypeArray = listArray.split(',').map(function(item) {
                    return item.trim();
                });
                component.set("v.costTypeValue", costTypeArray);
            }
            else if(existingData.ET_Cost_Type__c && typeof existingData.ET_Cost_Type__c != 'object'){
                 costTypeArray = existingData.ET_Cost_Type__c.split(',').map(function(item) {
                    return item.trim();
                });
                component.set("v.costTypeValue", costTypeArray);
            }
        }
	},
    handleCostTypeChange: function(component, event, helper) {
        var predefinedOtherCostRecord = component.get("v.predefinedOtherCostRecord");
        var predefinedOtherCostData = component.get("v.predefinedOtherCostMasterData");
        var costTypeValue=event.getParam('value');
        if(costTypeValue!=undefined && costTypeValue.length == 1){
            if(predefinedOtherCostRecord.Other_Requirement_API_Name__c!=undefined && predefinedOtherCostRecord.Other_Requirement_API_Name__c!=null){
            	if(costTypeValue=='One_time_Cost')
                	component.set("v.predefinedOtherCostRecord.ET_Cost_Value__c",predefinedOtherCostData[predefinedOtherCostRecord.Other_Requirement_API_Name__c].ET_One_Time_Cost__c);
                else if(costTypeValue=='Annual_Cost')
                	component.set("v.predefinedOtherCostRecord.ET_Cost_Value__c",predefinedOtherCostData[predefinedOtherCostRecord.Other_Requirement_API_Name__c].ET_Annual_Cost__c);
            }
        }else {
            component.set("v.predefinedOtherCostRecord.ET_Cost_Value__c","");
        }
        
    }
})