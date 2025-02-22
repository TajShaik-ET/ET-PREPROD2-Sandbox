({
	doInit : function(component, event, helper) {
        
        helper.getPicklistData(component, event, helper);
        
        let currentYear = new Date().getFullYear();
        let yearList = [];
        for(var i=currentYear; i>=2000;i-- ){
            yearList.push(i);
        }
		component.set("v.yearOptions",yearList);
	},
    onMakeChange : function(component, event, helper) {
        
        component.set("v.disableModel",false);
        let makeValue = component.get("v.makeValue");        
        let data = component.get("v.makeModelData");
         let modellist=[];
        Object.keys(data).forEach(function(key, index) {
            if(data[makeValue] == data[key]){
                data[makeValue].forEach(function(item){
                     modellist.push(item);
                });
            }           
        });
        component.set("v.modelOptions",modellist.sort());
    },
    getAutoPricingInfo : function(component, event, helper) {             
      
      var action = component.get('c.getAutoPricingDetails');
        action.setParams({
            make : component.get("v.makeValue"),
            model : component.get("v.modelValue"),
            year:parseInt(component.get("v.yearValue")),
            dealerName:component.get("v.dealerName"),
            minKm:component.get("v.minKM"),
            maxKm:component.get("v.maxKM"),
            posted :component.find('posted').get('v.value')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           
            if (state === "SUCCESS") {  
                let data = response.getReturnValue();
                component.set("v.autoPricingInfo",data);
                let amountVal=[];
                let total=0;
                let count = 0;
                data.forEach(function(item){
                    if(item.Price__c){
                        amountVal.push(item.Price__c);
                        total += item.Price__c;
                        count++;
                    }
                  
                });
               
                component.set("v.maxValue",amountVal.length ? Math.max(...amountVal):0);
                component.set("v.minValue",amountVal.length ? Math.min(...amountVal):0);
                component.set("v.avgValue",(total/count)?(total/count).toFixed(2):0);
                component.set("v.totalValue",count);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        helper.showErrorToast({
                            "title": "Error",
                            "type": "Error",
                            "message":errors[0].message
                        });
                        
                    }
                } else {
                    console.log("Unknown error");
                    
                }
            }
        }); 
        
        $A.enqueueAction(action); 
        
    }
})