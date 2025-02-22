({
	doInit : function(component, event, helper) {
		var existingData = component.get("v.existingData");
        if(existingData){
            component.set("v.otherCostTabSpecificRecords", existingData);
            debugger;
            var costTypeArray =[];
            console.log('existingData  8= '+ JSON.stringify(existingData));
            console.log('typeof existingData.ET_Cost_Type__c = '+ typeof existingData.ET_Cost_Type__c);
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
            console.log('costTypeValue = '+ JSON.stringify(costTypeArray));
        }
	},
    
     handleRemove : function(component, event, helper) {
        $A.util.toggleClass(component.find('ConfirmDialog2'), 'slds-hide');
        
    },
    handleNo:function(component, event, helper){
        $A.util.toggleClass(component.find('ConfirmDialog2'), 'slds-hide');
    },
    handleYes:function(component, event, helper){
        $A.util.toggleClass(component.find('ConfirmDialog2'), 'slds-hide');
        /*var notifyRequirementTab = component.getEvent("notifyRequirementTab");
        //alert('in collapsible cmp :'+ component.get("v.lineItemNumber"));
        notifyRequirementTab.setParam(
                    "deletedlineItemNumber",component.get("v.lineItemNumber"));
        notifyRequirementTab.fire();
        //alert('delete event fired');*/
        console.log('getLocalId other cost:: ',component.getLocalId());
        var existingData = component.get("v.existingData");
        if(existingData && existingData.Id){
            var deletedotherCostEvt = component.getEvent("deletedOtherCostsIdsEvt");
            deletedotherCostEvt.setParams(
                {"tabName" :  component.getLocalId(),
                 "otherCostObjId" : existingData.Id});
            deletedotherCostEvt.fire();
        }
       
        component.destroy();
    },
})