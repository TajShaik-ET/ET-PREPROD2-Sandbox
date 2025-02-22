({
    doInit : function(component, event, helper) {
        component.set("v.spinner", true); 
        component.set("v.confirmFlag", true);
        helper.doInit(component, event, helper);
         helper.validateProfile (component, event, helper);
    },
    closeConfirmModal : function(component, event, helper){
       // $A.get("e.force:closeQuickAction").fire();
        component.set("v.confirmFlag",false);
    },
    saveRecord : function(component, event, helper){
        var userPro = component.get('v.userProfile');
        if (userPro === 'ET - School Transportation Manager') {
            if (helper.validateRecords(component, event, helper)) {
                helper.updateCaseStatus(component, event, helper); 
            }
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