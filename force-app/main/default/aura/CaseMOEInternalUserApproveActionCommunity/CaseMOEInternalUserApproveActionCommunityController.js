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
        helper.updateCaseStatus(component, event, helper); 
    },
    showSpinner: function(component, event, helper) {
      //  component.set("v.spinner", true); 
    },
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    }
})