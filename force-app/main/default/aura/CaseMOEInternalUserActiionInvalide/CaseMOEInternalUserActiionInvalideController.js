({
    doInit : function(component, event, helper) {
        component.set("v.spinner", true); 
        component.set("v.confirmFlag", true);
        helper.doInit(component, event, helper);
    },
    closeConfirmModal : function(component, event, helper){
       // $A.get("e.force:closeQuickAction").fire();
        component.set("v.confirmFlag",false);
    },
    saveRecord : function(component, event, helper){
        var val = component.find("comment").get("v.value");
        if(val == null || val == '' || val== 'undefined'){
            component.find("comment").showHelpMessageIfInvalid();
            component.set("v.isDisabled", false);
        }else{
        	helper.updateCaseStatus(component, event, helper);  
        }
        
    },
    showSpinner: function(component, event, helper) {
      //  component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    }
})