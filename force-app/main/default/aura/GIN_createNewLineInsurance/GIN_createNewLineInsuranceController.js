({
	doInit : function(component, event, helper) {
		
	},
    
    onForceLoad : function(component, event, helper) {
        
         let recordData = component.get("v.record");
         let insType = recordData.Insurance_Type__c;
        
        if(insType == 'Property All Risk'){
            component.set('v.showInterestInsured',true);
            component.set('v.showLocation',true);
            component.set('v.showSumAssured',true);            
        }else if(insType == 'Fire and Allied Perils Insurance'){
            component.set('v.showItemDesc',true);
            component.set('v.showLocation',true);
            component.set('v.showSumAssured',true); 
            
        }else if(insType == 'Third Party Liability'){
            component.set('v.showAddress',true);
            component.set('v.showLocation',true);
            
        }else if(insType == 'Public Liability'){
            component.set('v.showLocation',true);
            component.set('v.showItemDesc',true);
        }else if(insType == 'Contractor\'s Plant & Machinery'){
             component.set('v.showItemDesc',true);
            component.set('v.ShowEEL',true);            
            component.set('v.showSumAssured',true); 
        }else if(insType == 'Money Policy'){
            //component.set('v.showLocation',true);
            component.set('v.ShowMoneyPolicy',true);
            //component.set('v.showSumAssured',true); 
            
        }else if(insType == 'Work Compensation (W.COMP)'){
             component.set('v.ShowWC',true);
            
        }else{
            
             component.set('v.ShowWarnMsg',true); 
        }
        
    },
  
    handleSubmit : function(component, event, helper) {
       // event.preventDefault();
    },
    handleSuccess :function(component, event, helper) {
       
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get('v.recordId'),
                "slideDevName": "related"
            });
            navEvt.fire();
       
    },
    handleError : function(component, event, helper) {}
})